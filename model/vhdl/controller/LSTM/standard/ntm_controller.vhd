--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_arithmetic_pkg.all;
use work.ntm_math_pkg.all;

use work.ntm_lstm_controller_pkg.all;

entity ntm_controller is
  generic (
    DATA_SIZE    : integer := 32;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    W_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    W_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_controller_architecture of ntm_controller is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    VECTOR_ACTIVATION_STATE,            -- STEP 2
    VECTOR_FORGET_STATE,                -- STEP 3
    VECTOR_INPUT_STATE,                 -- STEP 4
    VECTOR_STATE_STATE,                 -- STEP 5
    VECTOR_OUTPUT_GATE,                 -- STEP 6
    VECTOR_HIDDEN_GATE                  -- STEP 7
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- ACTIVATION GATE VECTOR
  -- CONTROL
  signal start_activation_gate_vector : std_logic;
  signal ready_activation_gate_vector : std_logic;

  signal w_in_l_enable_activation_gate_vector : std_logic;
  signal w_in_x_enable_activation_gate_vector : std_logic;

  signal w_out_l_enable_activation_gate_vector : std_logic;
  signal w_out_x_enable_activation_gate_vector : std_logic;

  signal x_in_enable_activation_gate_vector : std_logic;

  signal x_out_enable_activation_gate_vector : std_logic;

  signal k_in_i_enable_activation_gate_vector : std_logic;
  signal k_in_l_enable_activation_gate_vector : std_logic;
  signal k_in_k_enable_activation_gate_vector : std_logic;

  signal k_out_i_enable_activation_gate_vector : std_logic;
  signal k_out_l_enable_activation_gate_vector : std_logic;
  signal k_out_k_enable_activation_gate_vector : std_logic;

  signal r_in_i_enable_activation_gate_vector : std_logic;
  signal r_in_k_enable_activation_gate_vector : std_logic;

  signal r_out_i_enable_activation_gate_vector : std_logic;
  signal r_out_k_enable_activation_gate_vector : std_logic;

  signal u_in_l_enable_activation_gate_vector : std_logic;
  signal u_in_p_enable_activation_gate_vector : std_logic;

  signal u_out_l_enable_activation_gate_vector : std_logic;
  signal u_out_p_enable_activation_gate_vector : std_logic;

  signal h_in_enable_activation_gate_vector : std_logic;

  signal h_out_enable_activation_gate_vector : std_logic;

  signal b_in_enable_activation_gate_vector : std_logic;

  signal b_out_enable_activation_gate_vector : std_logic;

  signal a_out_enable_activation_gate_vector : std_logic;

  -- DATA
  signal size_x_in_activation_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_activation_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_activation_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_activation_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal x_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_out_activation_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ACTIVATION TRAINER
  -- CONTROL
  signal start_activation_trainer : std_logic;
  signal ready_activation_trainer : std_logic;

  signal x_in_enable_activation_trainer : std_logic;

  signal x_out_enable_activation_trainer : std_logic;

  signal r_in_i_enable_activation_trainer : std_logic;
  signal r_in_k_enable_activation_trainer : std_logic;

  signal r_out_i_enable_activation_trainer : std_logic;
  signal r_out_k_enable_activation_trainer : std_logic;

  signal h_in_enable_activation_trainer : std_logic;

  signal h_out_enable_activation_trainer : std_logic;

  signal a_in_enable_activation_trainer : std_logic;
  signal i_in_enable_activation_trainer : std_logic;
  signal s_in_enable_activation_trainer : std_logic;

  signal a_out_enable_activation_trainer : std_logic;
  signal i_out_enable_activation_trainer : std_logic;
  signal s_out_enable_activation_trainer : std_logic;

  signal w_out_l_enable_activation_trainer : std_logic;
  signal w_out_x_enable_activation_trainer : std_logic;

  signal k_out_i_enable_activation_trainer : std_logic;
  signal k_out_l_enable_activation_trainer : std_logic;
  signal k_out_k_enable_activation_trainer : std_logic;

  signal u_out_l_enable_activation_trainer : std_logic;
  signal u_out_p_enable_activation_trainer : std_logic;

  signal b_out_enable_activation_trainer : std_logic;

  -- DATA
  signal size_x_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal i_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INTPUT GATE VECTOR
  -- CONTROL
  signal start_input_gate_vector : std_logic;
  signal ready_input_gate_vector : std_logic;

  signal w_in_l_enable_input_gate_vector : std_logic;
  signal w_in_x_enable_input_gate_vector : std_logic;

  signal w_out_l_enable_input_gate_vector : std_logic;
  signal w_out_x_enable_input_gate_vector : std_logic;

  signal x_in_enable_input_gate_vector : std_logic;

  signal x_out_enable_input_gate_vector : std_logic;

  signal k_in_i_enable_input_gate_vector : std_logic;
  signal k_in_l_enable_input_gate_vector : std_logic;
  signal k_in_k_enable_input_gate_vector : std_logic;

  signal k_out_i_enable_input_gate_vector : std_logic;
  signal k_out_l_enable_input_gate_vector : std_logic;
  signal k_out_k_enable_input_gate_vector : std_logic;

  signal r_in_i_enable_input_gate_vector : std_logic;
  signal r_in_k_enable_input_gate_vector : std_logic;

  signal r_out_i_enable_input_gate_vector : std_logic;
  signal r_out_k_enable_input_gate_vector : std_logic;

  signal u_in_l_enable_input_gate_vector : std_logic;
  signal u_in_p_enable_input_gate_vector : std_logic;

  signal u_out_l_enable_input_gate_vector : std_logic;
  signal u_out_p_enable_input_gate_vector : std_logic;

  signal h_in_enable_input_gate_vector : std_logic;

  signal h_out_enable_input_gate_vector : std_logic;

  signal b_in_enable_input_gate_vector : std_logic;

  signal b_out_enable_input_gate_vector : std_logic;

  signal i_out_enable_input_gate_vector : std_logic;

  -- DATA
  signal size_x_in_input_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_input_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_input_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_input_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal x_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal i_out_input_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INPUT TRAINER
  -- CONTROL
  signal start_input_trainer : std_logic;
  signal ready_input_trainer : std_logic;

  signal x_in_enable_input_trainer : std_logic;

  signal x_out_enable_input_trainer : std_logic;

  signal r_in_i_enable_input_trainer : std_logic;
  signal r_in_k_enable_input_trainer : std_logic;

  signal r_out_i_enable_input_trainer : std_logic;
  signal r_out_k_enable_input_trainer : std_logic;

  signal h_in_enable_input_trainer : std_logic;

  signal h_out_enable_input_trainer : std_logic;

  signal a_in_enable_input_trainer : std_logic;
  signal i_in_enable_input_trainer : std_logic;
  signal s_in_enable_input_trainer : std_logic;

  signal a_out_enable_input_trainer : std_logic;
  signal i_out_enable_input_trainer : std_logic;
  signal s_out_enable_input_trainer : std_logic;

  signal w_out_l_enable_input_trainer : std_logic;
  signal w_out_x_enable_input_trainer : std_logic;

  signal k_out_i_enable_input_trainer : std_logic;
  signal k_out_l_enable_input_trainer : std_logic;
  signal k_out_k_enable_input_trainer : std_logic;

  signal u_out_l_enable_input_trainer : std_logic;
  signal u_out_p_enable_input_trainer : std_logic;

  signal b_out_enable_input_trainer : std_logic;

  -- DATA
  signal size_x_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal i_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT GATE VECTOR
  -- CONTROL
  signal start_output_gate_vector : std_logic;
  signal ready_output_gate_vector : std_logic;

  signal w_in_l_enable_output_gate_vector : std_logic;
  signal w_in_x_enable_output_gate_vector : std_logic;

  signal w_out_l_enable_output_gate_vector : std_logic;
  signal w_out_x_enable_output_gate_vector : std_logic;

  signal x_in_enable_output_gate_vector : std_logic;

  signal x_out_enable_output_gate_vector : std_logic;

  signal k_in_i_enable_output_gate_vector : std_logic;
  signal k_in_l_enable_output_gate_vector : std_logic;
  signal k_in_k_enable_output_gate_vector : std_logic;

  signal k_out_i_enable_output_gate_vector : std_logic;
  signal k_out_l_enable_output_gate_vector : std_logic;
  signal k_out_k_enable_output_gate_vector : std_logic;

  signal r_in_i_enable_output_gate_vector : std_logic;
  signal r_in_k_enable_output_gate_vector : std_logic;

  signal r_out_i_enable_output_gate_vector : std_logic;
  signal r_out_k_enable_output_gate_vector : std_logic;

  signal u_in_l_enable_output_gate_vector : std_logic;
  signal u_in_p_enable_output_gate_vector : std_logic;

  signal u_out_l_enable_output_gate_vector : std_logic;
  signal u_out_p_enable_output_gate_vector : std_logic;

  signal h_in_enable_output_gate_vector : std_logic;

  signal h_out_enable_output_gate_vector : std_logic;

  signal b_in_enable_output_gate_vector : std_logic;

  signal b_out_enable_output_gate_vector : std_logic;

  signal o_out_enable_output_gate_vector : std_logic;

  -- DATA
  signal size_x_in_output_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_output_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_output_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_output_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal x_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal o_out_output_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT TRAINER
  -- CONTROL
  signal start_output_trainer : std_logic;
  signal ready_output_trainer : std_logic;

  signal x_in_enable_output_trainer : std_logic;

  signal x_out_enable_output_trainer : std_logic;

  signal r_in_i_enable_output_trainer : std_logic;
  signal r_in_k_enable_output_trainer : std_logic;

  signal r_out_i_enable_output_trainer : std_logic;
  signal r_out_k_enable_output_trainer : std_logic;

  signal h_in_enable_output_trainer : std_logic;

  signal h_out_enable_output_trainer : std_logic;

  signal a_in_enable_output_trainer : std_logic;
  signal o_in_enable_output_trainer : std_logic;

  signal a_out_enable_output_trainer : std_logic;
  signal o_out_enable_output_trainer : std_logic;

  signal w_out_l_enable_output_trainer : std_logic;
  signal w_out_x_enable_output_trainer : std_logic;

  signal k_out_i_enable_output_trainer : std_logic;
  signal k_out_l_enable_output_trainer : std_logic;
  signal k_out_k_enable_output_trainer : std_logic;

  signal u_out_l_enable_output_trainer : std_logic;
  signal u_out_p_enable_output_trainer : std_logic;

  signal b_out_enable_output_trainer : std_logic;

  -- DATA
  signal size_x_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal o_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FORGET GATE VECTOR
  -- CONTROL
  signal start_forget_gate_vector : std_logic;
  signal ready_forget_gate_vector : std_logic;

  signal w_in_l_enable_forget_gate_vector : std_logic;
  signal w_in_x_enable_forget_gate_vector : std_logic;

  signal w_out_l_enable_forget_gate_vector : std_logic;
  signal w_out_x_enable_forget_gate_vector : std_logic;

  signal x_in_enable_forget_gate_vector : std_logic;

  signal x_out_enable_forget_gate_vector : std_logic;

  signal k_in_i_enable_forget_gate_vector : std_logic;
  signal k_in_l_enable_forget_gate_vector : std_logic;
  signal k_in_k_enable_forget_gate_vector : std_logic;

  signal k_out_i_enable_forget_gate_vector : std_logic;
  signal k_out_l_enable_forget_gate_vector : std_logic;
  signal k_out_k_enable_forget_gate_vector : std_logic;

  signal r_in_i_enable_forget_gate_vector : std_logic;
  signal r_in_k_enable_forget_gate_vector : std_logic;

  signal r_out_i_enable_forget_gate_vector : std_logic;
  signal r_out_k_enable_forget_gate_vector : std_logic;

  signal u_in_l_enable_forget_gate_vector : std_logic;
  signal u_in_p_enable_forget_gate_vector : std_logic;

  signal u_out_l_enable_forget_gate_vector : std_logic;
  signal u_out_p_enable_forget_gate_vector : std_logic;

  signal h_in_enable_forget_gate_vector : std_logic;

  signal h_out_enable_forget_gate_vector : std_logic;

  signal b_in_enable_forget_gate_vector : std_logic;

  signal b_out_enable_forget_gate_vector : std_logic;

  signal f_out_enable_forget_gate_vector : std_logic;

  -- DATA
  signal size_x_in_forget_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_forget_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_forget_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_forget_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal x_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_out_forget_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FORGET TRAINER
  -- CONTROL
  signal start_forget_trainer : std_logic;
  signal ready_forget_trainer : std_logic;

  signal x_in_enable_forget_trainer : std_logic;

  signal x_out_enable_forget_trainer : std_logic;

  signal r_in_i_enable_forget_trainer : std_logic;
  signal r_in_k_enable_forget_trainer : std_logic;

  signal r_out_i_enable_forget_trainer : std_logic;
  signal r_out_k_enable_forget_trainer : std_logic;

  signal h_in_enable_forget_trainer : std_logic;

  signal h_out_enable_forget_trainer : std_logic;

  signal f_in_enable_forget_trainer : std_logic;
  signal s_in_enable_forget_trainer : std_logic;

  signal f_out_enable_forget_trainer : std_logic;
  signal s_out_enable_forget_trainer : std_logic;

  signal w_out_l_enable_forget_trainer : std_logic;
  signal w_out_x_enable_forget_trainer : std_logic;

  signal k_out_i_enable_forget_trainer : std_logic;
  signal k_out_l_enable_forget_trainer : std_logic;
  signal k_out_k_enable_forget_trainer : std_logic;

  signal u_out_l_enable_forget_trainer : std_logic;
  signal u_out_p_enable_forget_trainer : std_logic;

  signal b_out_enable_forget_trainer : std_logic;

  -- DATA
  signal size_x_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- STATE GATE VECTOR
  -- CONTROL
  signal start_state_gate_vector : std_logic;
  signal ready_state_gate_vector : std_logic;

  signal i_in_enable_state_gate_vector : std_logic;
  signal f_in_enable_state_gate_vector : std_logic;
  signal a_in_enable_state_gate_vector : std_logic;

  signal i_out_enable_state_gate_vector : std_logic;
  signal f_out_enable_state_gate_vector : std_logic;
  signal a_out_enable_state_gate_vector : std_logic;

  signal s_in_enable_state_gate_vector : std_logic;

  signal s_out_enable_state_gate_vector : std_logic;

  -- DATA
  signal size_l_in_state_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal s_in_state_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal i_in_state_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_in_state_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal a_in_state_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal s_out_state_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- HIDDEN GATE VECTOR
  -- CONTROL
  signal start_hidden_gate_vector : std_logic;
  signal ready_hidden_gate_vector : std_logic;

  signal s_in_enable_hidden_gate_vector : std_logic;
  signal o_in_enable_hidden_gate_vector : std_logic;

  signal s_out_enable_hidden_gate_vector : std_logic;
  signal o_out_enable_hidden_gate_vector : std_logic;

  signal h_out_enable_hidden_gate_vector : std_logic;

  -- DATA
  signal size_l_in_hidden_gate_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal s_in_hidden_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal o_in_hidden_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_hidden_gate_vector : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      H_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          H_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          H_OUT_ENABLE <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Control Internal
            start_activation_gate_vector <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_STATE;
          else
            -- Control Internal
            start_activation_gate_vector <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1

        when VECTOR_ACTIVATION_STATE =>  -- STEP 2

          -- a(t;l) = tanh(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + U(l-1;l-1)·h(t;l-1) + b(t;l))

          if (ready_activation_gate_vector = '1') then
            -- Control Internal
            start_forget_gate_vector <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_FORGET_STATE;
          else
            -- Control Internal
            start_activation_gate_vector <= '0';
          end if;

        when VECTOR_FORGET_STATE =>     -- STEP 3

          -- f(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + U(l-1;l-1)·h(t;l-1) + b(t;l))

          if (ready_forget_gate_vector = '1') then
            -- Control Internal
            start_input_gate_vector <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_INPUT_STATE;
          else
            -- Control Internal
            start_forget_gate_vector <= '0';
          end if;

        when VECTOR_INPUT_STATE =>      -- STEP 4

          -- i(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + U(l-1;l-1)·h(t;l-1) + b(t;l))

          if (ready_input_gate_vector = '1') then
            -- Control Internal
            start_state_gate_vector <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_STATE_STATE;
          else
            -- Control Internal
            start_input_gate_vector <= '0';
          end if;

        when VECTOR_STATE_STATE =>      -- STEP 5

          -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)
          -- s(t=0;l) = 0

          if (ready_state_gate_vector = '1') then
            -- Control Internal
            start_output_gate_vector <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_OUTPUT_GATE;
          else
            -- Control Internal
            start_state_gate_vector <= '0';
          end if;

        when VECTOR_OUTPUT_GATE =>      -- STEP 6

          -- o(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + U(l-1;l-1)·h(t;l-1) + b(t;l))

          if (ready_output_gate_vector = '1') then
            -- Control Internal
            start_hidden_gate_vector <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_HIDDEN_GATE;
          else
            -- Control Internal
            start_output_gate_vector <= '0';
          end if;

        when VECTOR_HIDDEN_GATE =>      -- STEP 7

          -- h(t;l) = o(t;l) o tanh(s(t;l))
          -- h(t=0;l) = 0; h(t;l=0) = 0

          if (ready_hidden_gate_vector = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            start_hidden_gate_vector <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- ACTIVATION GATE VECTOR
  w_in_l_enable_activation_gate_vector <= W_IN_L_ENABLE;
  w_in_x_enable_activation_gate_vector <= W_IN_X_ENABLE;
  x_in_enable_activation_gate_vector   <= X_IN_ENABLE;

  k_in_i_enable_activation_gate_vector <= K_IN_I_ENABLE;
  k_in_l_enable_activation_gate_vector <= K_IN_L_ENABLE;
  k_in_k_enable_activation_gate_vector <= K_IN_K_ENABLE;
  r_in_i_enable_activation_gate_vector <= R_IN_I_ENABLE;
  r_in_k_enable_activation_gate_vector <= R_IN_K_ENABLE;

  u_in_l_enable_activation_gate_vector <= U_IN_L_ENABLE;
  u_in_p_enable_activation_gate_vector <= U_IN_P_ENABLE;
  h_in_enable_activation_gate_vector   <= H_IN_ENABLE;

  b_in_enable_activation_gate_vector <= B_IN_ENABLE;

  -- ACTIVATION TRAINER
  x_in_enable_activation_trainer <= X_IN_ENABLE;

  r_in_i_enable_activation_trainer <= R_IN_I_ENABLE;
  r_in_k_enable_activation_trainer <= R_IN_K_ENABLE;

  h_in_enable_activation_trainer <= H_IN_ENABLE;

  a_in_enable_activation_trainer <= a_out_enable_activation_gate_vector;
  i_in_enable_activation_trainer <= i_out_enable_input_gate_vector;
  s_in_enable_activation_trainer <= s_out_enable_state_gate_vector;

  -- INTPUT GATE VECTOR
  w_in_l_enable_input_gate_vector <= W_IN_L_ENABLE;
  w_in_x_enable_input_gate_vector <= W_IN_X_ENABLE;
  x_in_enable_input_gate_vector   <= X_IN_ENABLE;

  k_in_i_enable_input_gate_vector <= K_IN_I_ENABLE;
  k_in_l_enable_input_gate_vector <= K_IN_L_ENABLE;
  k_in_k_enable_input_gate_vector <= K_IN_K_ENABLE;
  r_in_i_enable_input_gate_vector <= R_IN_I_ENABLE;
  r_in_k_enable_input_gate_vector <= R_IN_K_ENABLE;

  u_in_l_enable_input_gate_vector <= U_IN_L_ENABLE;
  u_in_p_enable_input_gate_vector <= U_IN_P_ENABLE;
  h_in_enable_input_gate_vector   <= H_IN_ENABLE;

  b_in_enable_input_gate_vector <= B_IN_ENABLE;

  -- INPUT TRAINER
  x_in_enable_input_trainer <= X_IN_ENABLE;

  r_in_i_enable_input_trainer <= R_IN_I_ENABLE;
  r_in_k_enable_input_trainer <= R_IN_K_ENABLE;

  h_in_enable_input_trainer <= H_IN_ENABLE;

  a_in_enable_input_trainer <= a_out_enable_activation_gate_vector;
  i_in_enable_input_trainer <= i_out_enable_input_gate_vector;
  s_in_enable_input_trainer <= s_out_enable_state_gate_vector;

  -- OUTPUT GATE VECTOR
  w_in_l_enable_output_gate_vector <= W_IN_L_ENABLE;
  w_in_x_enable_output_gate_vector <= W_IN_X_ENABLE;
  x_in_enable_output_gate_vector   <= X_IN_ENABLE;

  k_in_i_enable_output_gate_vector <= K_IN_I_ENABLE;
  k_in_l_enable_output_gate_vector <= K_IN_L_ENABLE;
  k_in_k_enable_output_gate_vector <= K_IN_K_ENABLE;
  r_in_i_enable_output_gate_vector <= R_IN_I_ENABLE;
  r_in_k_enable_output_gate_vector <= R_IN_K_ENABLE;

  u_in_l_enable_output_gate_vector <= U_IN_L_ENABLE;
  u_in_p_enable_output_gate_vector <= U_IN_P_ENABLE;
  h_in_enable_output_gate_vector   <= H_IN_ENABLE;

  b_in_enable_output_gate_vector <= B_IN_ENABLE;

  -- OUTPUT TRAINER
  x_in_enable_output_trainer <= X_IN_ENABLE;

  r_in_i_enable_input_trainer <= R_IN_I_ENABLE;
  r_in_k_enable_input_trainer <= R_IN_K_ENABLE;

  h_in_enable_output_trainer <= H_IN_ENABLE;

  a_in_enable_output_trainer <= a_out_enable_activation_gate_vector;
  o_in_enable_output_trainer <= o_out_enable_output_gate_vector;

  -- FORGET GATE VECTOR
  w_in_l_enable_forget_gate_vector <= W_IN_L_ENABLE;
  w_in_x_enable_forget_gate_vector <= W_IN_X_ENABLE;
  x_in_enable_forget_gate_vector   <= X_IN_ENABLE;

  k_in_i_enable_forget_gate_vector <= K_IN_I_ENABLE;
  k_in_l_enable_forget_gate_vector <= K_IN_L_ENABLE;
  k_in_k_enable_forget_gate_vector <= K_IN_K_ENABLE;
  r_in_i_enable_forget_gate_vector <= R_IN_I_ENABLE;
  r_in_k_enable_forget_gate_vector <= R_IN_K_ENABLE;

  u_in_l_enable_forget_gate_vector <= U_IN_L_ENABLE;
  u_in_p_enable_forget_gate_vector <= U_IN_P_ENABLE;
  h_in_enable_forget_gate_vector   <= H_IN_ENABLE;

  b_in_enable_forget_gate_vector <= B_IN_ENABLE;

  -- FORGET TRAINER
  x_in_enable_forget_trainer <= X_IN_ENABLE;

  r_in_i_enable_forget_trainer <= R_IN_I_ENABLE;
  r_in_k_enable_forget_trainer <= R_IN_K_ENABLE;

  h_in_enable_forget_trainer <= H_IN_ENABLE;

  f_in_enable_forget_trainer <= f_out_enable_forget_gate_vector;
  s_in_enable_forget_trainer <= s_out_enable_state_gate_vector;

  -- STATE GATE VECTOR
  s_in_enable_state_gate_vector <= s_out_enable_state_gate_vector;
  i_in_enable_state_gate_vector <= i_out_enable_input_gate_vector;
  f_in_enable_state_gate_vector <= f_out_enable_forget_gate_vector;
  a_in_enable_state_gate_vector <= a_out_enable_activation_gate_vector;

  -- HIDDEN GATE VECTOR
  s_in_enable_hidden_gate_vector <= s_out_enable_state_gate_vector;
  o_in_enable_hidden_gate_vector <= o_out_enable_output_gate_vector;

  -- DATA
  -- ACTIVATION GATE VECTOR
  size_x_in_activation_gate_vector <= SIZE_X_IN;
  size_w_in_activation_gate_vector <= SIZE_W_IN;
  size_l_in_activation_gate_vector <= SIZE_L_IN;
  size_r_in_activation_gate_vector <= SIZE_R_IN;

  w_in_activation_gate_vector <= W_IN;
  x_in_activation_gate_vector <= X_IN;

  k_in_activation_gate_vector <= K_IN;
  r_in_activation_gate_vector <= R_IN;

  u_in_activation_gate_vector <= U_IN;
  h_in_activation_gate_vector <= H_IN;

  b_in_activation_gate_vector <= B_IN;

  -- ACTIVATION TRAINER
  size_x_in_activation_trainer <= SIZE_X_IN;
  size_w_in_activation_trainer <= SIZE_W_IN;
  size_l_in_activation_trainer <= SIZE_L_IN;
  size_r_in_activation_trainer <= SIZE_R_IN;

  x_in_activation_trainer <= X_IN;
  r_in_activation_trainer <= R_IN;
  h_in_activation_trainer <= H_IN;

  a_in_activation_trainer <= a_out_activation_gate_vector;
  i_in_activation_trainer <= i_out_input_gate_vector;
  s_in_activation_trainer <= s_out_state_gate_vector;

  -- INTPUT GATE VECTOR
  size_x_in_input_gate_vector <= SIZE_X_IN;
  size_w_in_input_gate_vector <= SIZE_W_IN;
  size_l_in_input_gate_vector <= SIZE_L_IN;
  size_r_in_input_gate_vector <= SIZE_R_IN;

  w_in_input_gate_vector <= W_IN;
  x_in_input_gate_vector <= X_IN;

  k_in_input_gate_vector <= K_IN;
  r_in_input_gate_vector <= R_IN;

  u_in_input_gate_vector <= U_IN;
  h_in_input_gate_vector <= H_IN;

  b_in_input_gate_vector <= B_IN;

  -- INPUT TRAINER
  size_x_in_input_trainer <= SIZE_X_IN;
  size_w_in_input_trainer <= SIZE_W_IN;
  size_l_in_input_trainer <= SIZE_L_IN;
  size_r_in_input_trainer <= SIZE_R_IN;

  x_in_input_trainer <= X_IN;
  r_in_input_trainer <= R_IN;
  h_in_input_trainer <= H_IN;

  a_in_input_trainer <= a_out_activation_gate_vector;
  i_in_input_trainer <= i_out_input_gate_vector;
  s_in_input_trainer <= s_out_state_gate_vector;

  -- OUTPUT GATE VECTOR
  size_x_in_output_gate_vector <= SIZE_X_IN;
  size_w_in_output_gate_vector <= SIZE_W_IN;
  size_l_in_output_gate_vector <= SIZE_L_IN;
  size_r_in_output_gate_vector <= SIZE_R_IN;

  w_in_output_gate_vector <= W_IN;
  x_in_output_gate_vector <= X_IN;

  k_in_output_gate_vector <= K_IN;
  r_in_output_gate_vector <= R_IN;

  u_in_output_gate_vector <= U_IN;
  h_in_output_gate_vector <= H_IN;

  b_in_output_gate_vector <= B_IN;

  -- OUTPUT TRAINER
  size_x_in_output_trainer <= SIZE_X_IN;
  size_w_in_output_trainer <= SIZE_W_IN;
  size_l_in_output_trainer <= SIZE_L_IN;
  size_r_in_output_trainer <= SIZE_R_IN;

  x_in_output_trainer <= X_IN;
  r_in_output_trainer <= R_IN;
  h_in_output_trainer <= H_IN;

  a_in_output_trainer <= a_out_activation_gate_vector;
  o_in_output_trainer <= o_out_output_gate_vector;

  -- FORGET GATE VECTOR
  size_x_in_forget_gate_vector <= SIZE_X_IN;
  size_w_in_forget_gate_vector <= SIZE_W_IN;
  size_l_in_forget_gate_vector <= SIZE_L_IN;
  size_r_in_forget_gate_vector <= SIZE_R_IN;

  w_in_forget_gate_vector <= W_IN;
  x_in_forget_gate_vector <= X_IN;

  k_in_forget_gate_vector <= K_IN;
  r_in_forget_gate_vector <= R_IN;

  u_in_forget_gate_vector <= U_IN;
  h_in_forget_gate_vector <= H_IN;

  b_in_forget_gate_vector <= B_IN;

  -- FORGET TRAINER
  size_x_in_forget_trainer <= SIZE_X_IN;
  size_w_in_forget_trainer <= SIZE_W_IN;
  size_l_in_forget_trainer <= SIZE_L_IN;
  size_r_in_forget_trainer <= SIZE_R_IN;

  x_in_forget_trainer <= X_IN;
  r_in_forget_trainer <= R_IN;
  h_in_forget_trainer <= H_IN;

  f_in_forget_trainer <= f_out_forget_gate_vector;
  s_in_forget_trainer <= s_out_state_gate_vector;

  -- STATE GATE VECTOR
  size_l_in_state_gate_vector <= SIZE_L_IN;

  s_in_state_gate_vector <= s_out_state_gate_vector;
  i_in_state_gate_vector <= i_out_input_gate_vector;
  f_in_state_gate_vector <= f_out_forget_gate_vector;
  a_in_state_gate_vector <= a_out_activation_gate_vector;

  -- HIDDEN GATE VECTOR
  size_l_in_hidden_gate_vector <= SIZE_L_IN;

  s_in_hidden_gate_vector <= s_out_state_gate_vector;
  o_in_hidden_gate_vector <= o_out_output_gate_vector;

  -- ACTIVATION GATE VECTOR
  activation_gate_vector : ntm_activation_gate_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_activation_gate_vector,
      READY => ready_activation_gate_vector,

      W_IN_L_ENABLE => w_in_l_enable_activation_gate_vector,
      W_IN_X_ENABLE => w_in_x_enable_activation_gate_vector,

      W_OUT_L_ENABLE => w_out_l_enable_activation_gate_vector,
      W_OUT_X_ENABLE => w_out_x_enable_activation_gate_vector,

      X_IN_ENABLE => x_in_enable_activation_gate_vector,

      X_OUT_ENABLE => x_out_enable_activation_gate_vector,

      K_IN_I_ENABLE => k_in_i_enable_activation_gate_vector,
      K_IN_L_ENABLE => k_in_l_enable_activation_gate_vector,
      K_IN_K_ENABLE => k_in_k_enable_activation_gate_vector,

      K_OUT_I_ENABLE => k_out_i_enable_activation_gate_vector,
      K_OUT_L_ENABLE => k_out_l_enable_activation_gate_vector,
      K_OUT_K_ENABLE => k_out_k_enable_activation_gate_vector,

      R_IN_I_ENABLE => r_in_i_enable_activation_gate_vector,
      R_IN_K_ENABLE => r_in_k_enable_activation_gate_vector,

      R_OUT_I_ENABLE => r_out_i_enable_activation_gate_vector,
      R_OUT_K_ENABLE => r_out_k_enable_activation_gate_vector,

      U_IN_L_ENABLE => u_in_l_enable_activation_gate_vector,
      U_IN_P_ENABLE => u_in_p_enable_activation_gate_vector,

      U_OUT_L_ENABLE => u_out_l_enable_activation_gate_vector,
      U_OUT_P_ENABLE => u_out_p_enable_activation_gate_vector,

      H_IN_ENABLE => h_in_enable_activation_gate_vector,

      H_OUT_ENABLE => h_out_enable_activation_gate_vector,

      B_IN_ENABLE => b_in_enable_activation_gate_vector,

      B_OUT_ENABLE => b_out_enable_activation_gate_vector,

      A_OUT_ENABLE => a_out_enable_activation_gate_vector,

      -- DATA
      SIZE_X_IN => size_x_in_activation_gate_vector,
      SIZE_W_IN => size_w_in_activation_gate_vector,
      SIZE_L_IN => size_l_in_activation_gate_vector,
      SIZE_R_IN => size_r_in_activation_gate_vector,

      W_IN => w_in_activation_gate_vector,
      X_IN => x_in_activation_gate_vector,

      K_IN => k_in_activation_gate_vector,
      R_IN => r_in_activation_gate_vector,

      U_IN => u_in_activation_gate_vector,
      H_IN => h_in_activation_gate_vector,

      B_IN => b_in_activation_gate_vector,

      A_OUT => a_out_activation_gate_vector
      );

  -- ACTIVATION TRAINER
  activation_trainer : ntm_activation_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_activation_trainer,
      READY => ready_activation_trainer,

      X_IN_ENABLE => x_in_enable_activation_trainer,

      X_OUT_ENABLE => x_out_enable_activation_trainer,

      R_IN_I_ENABLE => r_in_i_enable_activation_trainer,
      R_IN_K_ENABLE => r_in_k_enable_activation_trainer,

      R_OUT_I_ENABLE => r_out_i_enable_activation_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_activation_trainer,

      H_IN_ENABLE => h_in_enable_activation_trainer,

      H_OUT_ENABLE => h_out_enable_activation_trainer,

      A_IN_ENABLE => a_in_enable_activation_trainer,
      I_IN_ENABLE => i_in_enable_activation_trainer,
      S_IN_ENABLE => s_in_enable_activation_trainer,

      A_OUT_ENABLE => a_out_enable_activation_trainer,
      I_OUT_ENABLE => i_out_enable_activation_trainer,
      S_OUT_ENABLE => s_out_enable_activation_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_activation_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_activation_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_activation_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_activation_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_activation_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_activation_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_activation_trainer,

      B_OUT_ENABLE => b_out_enable_activation_trainer,

      -- DATA
      SIZE_X_IN => size_x_in_activation_trainer,
      SIZE_W_IN => size_w_in_activation_trainer,
      SIZE_L_IN => size_l_in_activation_trainer,
      SIZE_R_IN => size_r_in_activation_trainer,

      X_IN => x_in_activation_trainer,
      H_IN => h_in_activation_trainer,
      R_IN => r_in_activation_trainer,

      A_IN => a_in_activation_trainer,
      I_IN => i_in_activation_trainer,
      S_IN => s_in_activation_trainer,

      W_OUT => w_out_activation_trainer,
      K_OUT => k_out_activation_trainer,
      U_OUT => u_out_activation_trainer,
      B_OUT => b_out_activation_trainer
      );

  -- INTPUT GATE VECTOR
  input_gate_vector : ntm_input_gate_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_input_gate_vector,
      READY => ready_input_gate_vector,

      W_IN_L_ENABLE => w_in_l_enable_input_gate_vector,
      W_IN_X_ENABLE => w_in_x_enable_input_gate_vector,

      W_OUT_L_ENABLE => w_out_l_enable_input_gate_vector,
      W_OUT_X_ENABLE => w_out_x_enable_input_gate_vector,

      X_IN_ENABLE => x_in_enable_input_gate_vector,

      X_OUT_ENABLE => x_out_enable_input_gate_vector,

      K_IN_I_ENABLE => k_in_i_enable_input_gate_vector,
      K_IN_L_ENABLE => k_in_l_enable_input_gate_vector,
      K_IN_K_ENABLE => k_in_k_enable_input_gate_vector,

      K_OUT_I_ENABLE => k_out_i_enable_input_gate_vector,
      K_OUT_L_ENABLE => k_out_l_enable_input_gate_vector,
      K_OUT_K_ENABLE => k_out_k_enable_input_gate_vector,

      R_IN_I_ENABLE => r_in_i_enable_input_gate_vector,
      R_IN_K_ENABLE => r_in_k_enable_input_gate_vector,

      R_OUT_I_ENABLE => r_out_i_enable_input_gate_vector,
      R_OUT_K_ENABLE => r_out_k_enable_input_gate_vector,

      U_IN_L_ENABLE => u_in_l_enable_input_gate_vector,
      U_IN_P_ENABLE => u_in_p_enable_input_gate_vector,

      U_OUT_L_ENABLE => u_out_l_enable_input_gate_vector,
      U_OUT_P_ENABLE => u_out_p_enable_input_gate_vector,

      H_IN_ENABLE => h_in_enable_input_gate_vector,

      H_OUT_ENABLE => h_out_enable_input_gate_vector,

      B_IN_ENABLE => b_in_enable_input_gate_vector,

      B_OUT_ENABLE => b_out_enable_input_gate_vector,

      I_OUT_ENABLE => i_out_enable_input_gate_vector,

      -- DATA
      SIZE_X_IN => size_x_in_input_gate_vector,
      SIZE_W_IN => size_w_in_input_gate_vector,
      SIZE_L_IN => size_l_in_input_gate_vector,
      SIZE_R_IN => size_r_in_input_gate_vector,

      W_IN => w_in_input_gate_vector,
      X_IN => x_in_input_gate_vector,

      K_IN => k_in_input_gate_vector,
      R_IN => r_in_input_gate_vector,

      U_IN => u_in_input_gate_vector,
      H_IN => h_in_input_gate_vector,

      B_IN => b_in_input_gate_vector,

      I_OUT => i_out_input_gate_vector
      );

  -- INPUT TRAINER
  input_trainer : ntm_input_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_input_trainer,
      READY => ready_input_trainer,

      X_IN_ENABLE => x_in_enable_input_trainer,

      X_OUT_ENABLE => x_out_enable_input_trainer,

      R_IN_I_ENABLE => r_in_i_enable_input_trainer,
      R_IN_K_ENABLE => r_in_k_enable_input_trainer,

      R_OUT_I_ENABLE => r_out_i_enable_input_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_input_trainer,

      H_IN_ENABLE => h_in_enable_input_trainer,

      H_OUT_ENABLE => h_out_enable_input_trainer,

      A_IN_ENABLE => a_in_enable_input_trainer,
      I_IN_ENABLE => i_in_enable_input_trainer,
      S_IN_ENABLE => s_in_enable_input_trainer,

      A_OUT_ENABLE => a_out_enable_input_trainer,
      I_OUT_ENABLE => i_out_enable_input_trainer,
      S_OUT_ENABLE => s_out_enable_input_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_input_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_input_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_input_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_input_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_input_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_input_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_input_trainer,

      B_OUT_ENABLE => b_out_enable_input_trainer,

      -- DATA
      SIZE_X_IN => size_x_in_input_trainer,
      SIZE_W_IN => size_w_in_input_trainer,
      SIZE_L_IN => size_l_in_input_trainer,
      SIZE_R_IN => size_r_in_input_trainer,

      X_IN => x_in_input_trainer,
      R_IN => r_in_input_trainer,
      H_IN => h_in_input_trainer,

      A_IN => a_in_input_trainer,
      I_IN => i_in_input_trainer,
      S_IN => s_in_input_trainer,

      W_OUT => w_out_input_trainer,
      K_OUT => k_out_input_trainer,
      U_OUT => u_out_input_trainer,
      B_OUT => b_out_input_trainer
      );

  -- OUTPUT GATE VECTOR
  output_gate_vector : ntm_output_gate_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_gate_vector,
      READY => ready_output_gate_vector,

      W_IN_L_ENABLE => w_in_l_enable_output_gate_vector,
      W_IN_X_ENABLE => w_in_x_enable_output_gate_vector,

      W_OUT_L_ENABLE => w_out_l_enable_output_gate_vector,
      W_OUT_X_ENABLE => w_out_x_enable_output_gate_vector,

      X_IN_ENABLE => x_in_enable_output_gate_vector,

      X_OUT_ENABLE => x_out_enable_output_gate_vector,

      K_IN_I_ENABLE => k_in_i_enable_output_gate_vector,
      K_IN_L_ENABLE => k_in_l_enable_output_gate_vector,
      K_IN_K_ENABLE => k_in_k_enable_output_gate_vector,

      K_OUT_I_ENABLE => k_out_i_enable_output_gate_vector,
      K_OUT_L_ENABLE => k_out_l_enable_output_gate_vector,
      K_OUT_K_ENABLE => k_out_k_enable_output_gate_vector,

      R_IN_I_ENABLE => r_in_i_enable_output_gate_vector,
      R_IN_K_ENABLE => r_in_k_enable_output_gate_vector,

      R_OUT_I_ENABLE => r_out_i_enable_output_gate_vector,
      R_OUT_K_ENABLE => r_out_k_enable_output_gate_vector,

      U_IN_L_ENABLE => u_in_l_enable_output_gate_vector,
      U_IN_P_ENABLE => u_in_p_enable_output_gate_vector,

      U_OUT_L_ENABLE => u_out_l_enable_output_gate_vector,
      U_OUT_P_ENABLE => u_out_p_enable_output_gate_vector,

      H_IN_ENABLE => h_in_enable_output_gate_vector,

      H_OUT_ENABLE => h_out_enable_output_gate_vector,

      B_IN_ENABLE => b_in_enable_output_gate_vector,

      B_OUT_ENABLE => b_out_enable_output_gate_vector,

      O_OUT_ENABLE => o_out_enable_output_gate_vector,

      -- DATA
      SIZE_X_IN => size_x_in_output_gate_vector,
      SIZE_W_IN => size_w_in_output_gate_vector,
      SIZE_L_IN => size_l_in_output_gate_vector,
      SIZE_R_IN => size_r_in_output_gate_vector,

      W_IN => w_in_output_gate_vector,
      X_IN => x_in_output_gate_vector,

      K_IN => k_in_output_gate_vector,
      R_IN => r_in_output_gate_vector,

      U_IN => u_in_output_gate_vector,
      H_IN => h_in_output_gate_vector,

      B_IN => b_in_output_gate_vector,

      O_OUT => o_out_output_gate_vector
      );

  -- OUTPUT TRAINER
  output_trainer : ntm_output_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_trainer,
      READY => ready_output_trainer,

      X_IN_ENABLE => x_in_enable_output_trainer,

      X_OUT_ENABLE => x_out_enable_output_trainer,

      R_IN_I_ENABLE => r_in_i_enable_output_trainer,
      R_IN_K_ENABLE => r_in_k_enable_output_trainer,

      R_OUT_I_ENABLE => r_out_i_enable_output_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_output_trainer,

      H_IN_ENABLE => h_in_enable_output_trainer,

      H_OUT_ENABLE => h_out_enable_output_trainer,

      A_IN_ENABLE => a_in_enable_output_trainer,
      O_IN_ENABLE => o_in_enable_output_trainer,

      A_OUT_ENABLE => a_out_enable_output_trainer,
      O_OUT_ENABLE => o_out_enable_output_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_output_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_output_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_output_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_output_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_output_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_output_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_output_trainer,

      B_OUT_ENABLE => b_out_enable_output_trainer,

      -- DATA
      SIZE_X_IN => size_x_in_output_trainer,
      SIZE_W_IN => size_w_in_output_trainer,
      SIZE_L_IN => size_l_in_output_trainer,
      SIZE_R_IN => size_r_in_output_trainer,

      X_IN => x_in_output_trainer,
      R_IN => r_in_output_trainer,
      H_IN => h_in_output_trainer,

      A_IN => a_in_output_trainer,
      O_IN => o_in_output_trainer,

      W_OUT => w_out_output_trainer,
      K_OUT => k_out_output_trainer,
      U_OUT => u_out_output_trainer,
      B_OUT => b_out_output_trainer
      );

  -- FORGET GATE VECTOR
  forget_gate_vector : ntm_forget_gate_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_forget_gate_vector,
      READY => ready_forget_gate_vector,

      W_IN_L_ENABLE => w_in_l_enable_forget_gate_vector,
      W_IN_X_ENABLE => w_in_x_enable_forget_gate_vector,

      W_OUT_L_ENABLE => w_out_l_enable_forget_gate_vector,
      W_OUT_X_ENABLE => w_out_x_enable_forget_gate_vector,

      X_IN_ENABLE => x_in_enable_forget_gate_vector,

      X_OUT_ENABLE => x_out_enable_forget_gate_vector,

      K_IN_I_ENABLE => k_in_i_enable_forget_gate_vector,
      K_IN_L_ENABLE => k_in_l_enable_forget_gate_vector,
      K_IN_K_ENABLE => k_in_k_enable_forget_gate_vector,

      K_OUT_I_ENABLE => k_out_i_enable_forget_gate_vector,
      K_OUT_L_ENABLE => k_out_l_enable_forget_gate_vector,
      K_OUT_K_ENABLE => k_out_k_enable_forget_gate_vector,

      R_IN_I_ENABLE => r_in_i_enable_forget_gate_vector,
      R_IN_K_ENABLE => r_in_k_enable_forget_gate_vector,

      R_OUT_I_ENABLE => r_out_i_enable_forget_gate_vector,
      R_OUT_K_ENABLE => r_out_k_enable_forget_gate_vector,

      U_IN_L_ENABLE => u_in_l_enable_forget_gate_vector,
      U_IN_P_ENABLE => u_in_p_enable_forget_gate_vector,

      U_OUT_L_ENABLE => u_out_l_enable_forget_gate_vector,
      U_OUT_P_ENABLE => u_out_p_enable_forget_gate_vector,

      H_IN_ENABLE => h_in_enable_forget_gate_vector,

      H_OUT_ENABLE => h_out_enable_forget_gate_vector,

      B_IN_ENABLE => b_in_enable_forget_gate_vector,

      B_OUT_ENABLE => b_out_enable_forget_gate_vector,

      F_OUT_ENABLE => f_out_enable_forget_gate_vector,

      -- DATA
      SIZE_X_IN => size_x_in_forget_gate_vector,
      SIZE_W_IN => size_w_in_forget_gate_vector,
      SIZE_L_IN => size_l_in_forget_gate_vector,
      SIZE_R_IN => size_r_in_forget_gate_vector,

      W_IN => w_in_forget_gate_vector,
      X_IN => x_in_forget_gate_vector,

      K_IN => k_in_forget_gate_vector,
      R_IN => r_in_forget_gate_vector,

      U_IN => u_in_forget_gate_vector,
      H_IN => h_in_forget_gate_vector,

      B_IN => b_in_forget_gate_vector,

      F_OUT => f_out_forget_gate_vector
      );

  -- FORGET TRAINER
  forget_trainer : ntm_forget_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_forget_trainer,
      READY => ready_forget_trainer,

      X_IN_ENABLE => x_in_enable_forget_trainer,

      X_OUT_ENABLE => x_out_enable_forget_trainer,

      R_IN_I_ENABLE => r_in_i_enable_forget_trainer,
      R_IN_K_ENABLE => r_in_k_enable_forget_trainer,

      R_OUT_I_ENABLE => r_out_i_enable_forget_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_forget_trainer,

      H_IN_ENABLE => h_in_enable_forget_trainer,

      H_OUT_ENABLE => h_out_enable_forget_trainer,

      F_IN_ENABLE => f_in_enable_forget_trainer,
      S_IN_ENABLE => s_in_enable_forget_trainer,

      F_OUT_ENABLE => f_out_enable_forget_trainer,
      S_OUT_ENABLE => s_out_enable_forget_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_forget_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_forget_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_forget_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_forget_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_forget_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_forget_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_forget_trainer,

      B_OUT_ENABLE => b_out_enable_forget_trainer,

      -- DATA
      SIZE_X_IN => size_x_in_forget_trainer,
      SIZE_W_IN => size_w_in_forget_trainer,
      SIZE_L_IN => size_l_in_forget_trainer,
      SIZE_R_IN => size_r_in_forget_trainer,

      X_IN => x_in_forget_trainer,
      R_IN => r_in_forget_trainer,
      H_IN => h_in_forget_trainer,

      F_IN => f_in_forget_trainer,
      S_IN => s_in_forget_trainer,

      W_OUT => w_out_forget_trainer,
      K_OUT => k_out_forget_trainer,
      U_OUT => u_out_forget_trainer,
      B_OUT => b_out_forget_trainer
      );

  -- STATE GATE VECTOR
  state_gate_vector : ntm_state_gate_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_state_gate_vector,
      READY => ready_state_gate_vector,

      I_IN_ENABLE => i_in_enable_state_gate_vector,
      F_IN_ENABLE => f_in_enable_state_gate_vector,
      A_IN_ENABLE => a_in_enable_state_gate_vector,

      I_OUT_ENABLE => i_out_enable_state_gate_vector,
      F_OUT_ENABLE => f_out_enable_state_gate_vector,
      A_OUT_ENABLE => a_out_enable_state_gate_vector,

      S_IN_ENABLE => s_in_enable_state_gate_vector,

      S_OUT_ENABLE => s_out_enable_state_gate_vector,

      -- DATA
      SIZE_L_IN => size_l_in_state_gate_vector,

      S_IN => s_in_state_gate_vector,
      I_IN => i_in_state_gate_vector,
      F_IN => f_in_state_gate_vector,
      A_IN => a_in_state_gate_vector,

      S_OUT => s_out_state_gate_vector
      );

  -- HIDDEN GATE VECTOR
  hidden_gate_vector : ntm_hidden_gate_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_hidden_gate_vector,
      READY => ready_hidden_gate_vector,

      S_IN_ENABLE => s_in_enable_hidden_gate_vector,
      O_IN_ENABLE => o_in_enable_hidden_gate_vector,

      S_OUT_ENABLE => s_out_enable_hidden_gate_vector,
      O_OUT_ENABLE => o_out_enable_hidden_gate_vector,

      H_OUT_ENABLE => h_out_enable_hidden_gate_vector,

      -- DATA
      SIZE_L_IN => size_l_in_hidden_gate_vector,

      S_IN => s_in_hidden_gate_vector,
      O_IN => o_in_hidden_gate_vector,

      H_OUT => h_out_hidden_gate_vector
      );

end architecture;
