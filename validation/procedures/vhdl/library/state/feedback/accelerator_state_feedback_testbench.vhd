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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.accelerator_state_vhdl_pkg.all;
use work.accelerator_state_feedback_pkg.all;

entity accelerator_state_feedback_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    ENABLE_ACCELERATOR_MATRIX_STATE_TEST   : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_STATE_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_STATE_CASE_1 : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_INPUT_TEST   : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_INPUT_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_INPUT_CASE_1 : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_OUTPUT_TEST   : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_OUTPUT_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_OUTPUT_CASE_1 : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_FEEDFORWARD_TEST   : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FEEDFORWARD_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FEEDFORWARD_CASE_1 : boolean := false
    );
end accelerator_state_feedback_testbench;

architecture accelerator_state_feedback_testbench_architecture of accelerator_state_feedback_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- MATRIX STATE
  -- CONTROL
  signal start_matrix_state : std_logic;
  signal ready_matrix_state : std_logic;

  signal data_a_in_i_enable_matrix_state : std_logic;
  signal data_a_in_j_enable_matrix_state : std_logic;
  signal data_b_in_i_enable_matrix_state : std_logic;
  signal data_b_in_j_enable_matrix_state : std_logic;
  signal data_c_in_i_enable_matrix_state : std_logic;
  signal data_c_in_j_enable_matrix_state : std_logic;
  signal data_d_in_i_enable_matrix_state : std_logic;
  signal data_d_in_j_enable_matrix_state : std_logic;

  signal data_a_i_enable_matrix_state : std_logic;
  signal data_a_j_enable_matrix_state : std_logic;
  signal data_b_i_enable_matrix_state : std_logic;
  signal data_b_j_enable_matrix_state : std_logic;
  signal data_c_i_enable_matrix_state : std_logic;
  signal data_c_j_enable_matrix_state : std_logic;
  signal data_d_i_enable_matrix_state : std_logic;
  signal data_d_j_enable_matrix_state : std_logic;

  signal data_k_in_i_enable_matrix_state : std_logic;
  signal data_k_in_j_enable_matrix_state : std_logic;

  signal data_k_i_enable_matrix_state : std_logic;
  signal data_k_j_enable_matrix_state : std_logic;

  signal data_a_out_i_enable_matrix_state : std_logic;
  signal data_a_out_j_enable_matrix_state : std_logic;

  -- DATA
  signal size_a_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_c_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_a_out_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INPUT
  -- CONTROL
  signal start_matrix_input : std_logic;
  signal ready_matrix_input : std_logic;

  signal data_b_in_i_enable_matrix_input : std_logic;
  signal data_b_in_j_enable_matrix_input : std_logic;
  signal data_d_in_i_enable_matrix_input : std_logic;
  signal data_d_in_j_enable_matrix_input : std_logic;

  signal data_b_i_enable_matrix_input : std_logic;
  signal data_b_j_enable_matrix_input : std_logic;
  signal data_d_i_enable_matrix_input : std_logic;
  signal data_d_j_enable_matrix_input : std_logic;

  signal data_k_in_i_enable_matrix_input : std_logic;
  signal data_k_in_j_enable_matrix_input : std_logic;

  signal data_k_i_enable_matrix_input : std_logic;
  signal data_k_j_enable_matrix_input : std_logic;

  signal data_b_out_i_enable_matrix_input : std_logic;
  signal data_b_out_j_enable_matrix_input : std_logic;

  -- DATA
  signal size_b_in_i_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_j_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_b_in_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_b_out_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX OUTPUT
  -- CONTROL
  signal start_matrix_output : std_logic;
  signal ready_matrix_output : std_logic;

  signal data_c_in_i_enable_matrix_output : std_logic;
  signal data_c_in_j_enable_matrix_output : std_logic;
  signal data_d_in_i_enable_matrix_output : std_logic;
  signal data_d_in_j_enable_matrix_output : std_logic;

  signal data_c_i_enable_matrix_output : std_logic;
  signal data_c_j_enable_matrix_output : std_logic;
  signal data_d_i_enable_matrix_output : std_logic;
  signal data_d_j_enable_matrix_output : std_logic;

  signal data_k_in_i_enable_matrix_output : std_logic;
  signal data_k_in_j_enable_matrix_output : std_logic;

  signal data_k_i_enable_matrix_output : std_logic;
  signal data_k_j_enable_matrix_output : std_logic;

  signal data_c_out_i_enable_matrix_output : std_logic;
  signal data_c_out_j_enable_matrix_output : std_logic;

  -- DATA
  signal size_c_in_i_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_j_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_c_in_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_c_out_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX FEEDFORWARD
  -- CONTROL
  signal start_matrix_feedforward : std_logic;
  signal ready_matrix_feedforward : std_logic;

  signal data_d_in_i_enable_matrix_feedforward : std_logic;
  signal data_d_in_j_enable_matrix_feedforward : std_logic;

  signal data_d_i_enable_matrix_feedforward : std_logic;
  signal data_d_j_enable_matrix_feedforward : std_logic;

  signal data_k_in_i_enable_matrix_feedforward : std_logic;
  signal data_k_in_j_enable_matrix_feedforward : std_logic;

  signal data_k_i_enable_matrix_feedforward : std_logic;
  signal data_k_j_enable_matrix_feedforward : std_logic;

  signal data_d_out_i_matrix_feedforward : std_logic;
  signal data_d_out_j_matrix_feedforward : std_logic;

  -- DATA
  signal size_d_in_i_matrix_feedforward : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_feedforward : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_d_in_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_d_out_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  state_feedback_stimulus : accelerator_state_feedback_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- MATRIX STATE
      -- CONTROL
      ACCELERATOR_MATRIX_STATE_START => start_matrix_state,
      ACCELERATOR_MATRIX_STATE_READY => ready_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_C_IN_I_ENABLE => data_c_in_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_C_IN_J_ENABLE => data_c_in_j_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_A_I_ENABLE => data_a_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_A_J_ENABLE => data_a_j_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_B_I_ENABLE => data_b_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_B_J_ENABLE => data_b_j_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_C_I_ENABLE => data_c_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_C_J_ENABLE => data_c_j_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_D_I_ENABLE => data_d_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_D_J_ENABLE => data_d_j_enable_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_K_I_ENABLE => data_k_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_K_J_ENABLE => data_k_j_enable_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_A_OUT_I_ENABLE => data_a_out_i_enable_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_A_OUT_J_ENABLE => data_a_out_j_enable_matrix_state,

      -- DATA
      ACCELERATOR_MATRIX_STATE_SIZE_A_I_IN => size_a_in_i_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_A_J_IN => size_a_in_j_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_B_I_IN => size_b_in_i_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_B_J_IN => size_b_in_j_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_C_I_IN => size_c_in_i_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_C_J_IN => size_c_in_j_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_D_I_IN => size_d_in_i_matrix_state,
      ACCELERATOR_MATRIX_STATE_SIZE_D_J_IN => size_d_in_j_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_A_IN => data_a_in_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_B_IN => data_b_in_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_C_IN => data_c_in_matrix_state,
      ACCELERATOR_MATRIX_STATE_DATA_D_IN => data_d_in_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_K_IN => data_k_in_matrix_state,

      ACCELERATOR_MATRIX_STATE_DATA_A_OUT => data_a_out_matrix_state,

      -- MATRIX INPUT
      -- CONTROL
      ACCELERATOR_MATRIX_INPUT_START => start_matrix_input,
      ACCELERATOR_MATRIX_INPUT_READY => ready_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_B_I_ENABLE => data_b_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_B_J_ENABLE => data_b_j_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_D_I_ENABLE => data_d_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_D_J_ENABLE => data_d_j_enable_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_K_I_ENABLE => data_k_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_K_J_ENABLE => data_k_j_enable_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_B_OUT_I_ENABLE => data_b_out_i_enable_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_B_OUT_J_ENABLE => data_b_out_j_enable_matrix_input,

      -- DATA
      ACCELERATOR_MATRIX_INPUT_SIZE_B_I_IN => size_b_in_i_matrix_input,
      ACCELERATOR_MATRIX_INPUT_SIZE_B_J_IN => size_b_in_j_matrix_input,
      ACCELERATOR_MATRIX_INPUT_SIZE_D_I_IN => size_d_in_i_matrix_input,
      ACCELERATOR_MATRIX_INPUT_SIZE_D_J_IN => size_d_in_j_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_B_IN => data_b_in_matrix_input,
      ACCELERATOR_MATRIX_INPUT_DATA_D_IN => data_d_in_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_K_IN => data_k_in_matrix_input,

      ACCELERATOR_MATRIX_INPUT_DATA_B_OUT => data_b_out_matrix_input,

      -- MATRIX OUTPUT
      -- CONTROL
      ACCELERATOR_MATRIX_OUTPUT_START => start_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_READY => ready_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_C_IN_I_ENABLE => data_c_in_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_C_IN_J_ENABLE => data_c_in_j_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_C_I_ENABLE => data_c_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_C_J_ENABLE => data_c_j_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_D_I_ENABLE => data_d_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_D_J_ENABLE => data_d_j_enable_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_K_I_ENABLE => data_k_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_K_J_ENABLE => data_k_j_enable_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_C_OUT_I_ENABLE => data_c_out_i_enable_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_C_OUT_J_ENABLE => data_c_out_j_enable_matrix_output,

      -- DATA
      ACCELERATOR_MATRIX_OUTPUT_SIZE_C_I_IN => size_c_in_i_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_SIZE_C_J_IN => size_c_in_j_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_SIZE_D_I_IN => size_d_in_i_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_SIZE_D_J_IN => size_d_in_j_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_C_IN => data_c_in_matrix_output,
      ACCELERATOR_MATRIX_OUTPUT_DATA_D_IN => data_d_in_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_K_IN => data_k_in_matrix_output,

      ACCELERATOR_MATRIX_OUTPUT_DATA_C_OUT => data_c_out_matrix_output,

      -- MATRIX FEEDFORWARD
      -- CONTROL
      ACCELERATOR_MATRIX_FEEDFORWARD_START => start_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_READY => ready_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_I_ENABLE => data_d_i_enable_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_J_ENABLE => data_d_j_enable_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_K_I_ENABLE => data_k_i_enable_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_K_J_ENABLE => data_k_j_enable_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_OUT_I_ENABLE => data_d_out_i_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_OUT_J_ENABLE => data_d_out_j_matrix_feedforward,

      -- DATA
      ACCELERATOR_MATRIX_FEEDFORWARD_SIZE_D_I_IN => size_d_in_i_matrix_feedforward,
      ACCELERATOR_MATRIX_FEEDFORWARD_SIZE_D_J_IN => size_d_in_j_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_IN => data_d_in_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_K_IN => data_k_in_matrix_feedforward,

      ACCELERATOR_MATRIX_FEEDFORWARD_DATA_D_OUT => data_d_out_matrix_feedforward
      );

  -- MATRIX STATE
  accelerator_state_matrix_state_test : if (ENABLE_ACCELERATOR_MATRIX_STATE_TEST) generate
    state_matrix_state : accelerator_state_matrix_state
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_state,
        READY => ready_matrix_state,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_state,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_state,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_state,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_state,
        DATA_C_IN_I_ENABLE => data_c_in_i_enable_matrix_state,
        DATA_C_IN_J_ENABLE => data_c_in_j_enable_matrix_state,
        DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_state,
        DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_state,

        DATA_A_I_ENABLE => data_a_i_enable_matrix_state,
        DATA_A_J_ENABLE => data_a_j_enable_matrix_state,
        DATA_B_I_ENABLE => data_b_i_enable_matrix_state,
        DATA_B_J_ENABLE => data_b_j_enable_matrix_state,
        DATA_C_I_ENABLE => data_c_i_enable_matrix_state,
        DATA_C_J_ENABLE => data_c_j_enable_matrix_state,
        DATA_D_I_ENABLE => data_d_i_enable_matrix_state,
        DATA_D_J_ENABLE => data_d_j_enable_matrix_state,

        DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_state,
        DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_state,

        DATA_K_I_ENABLE => data_k_i_enable_matrix_state,
        DATA_K_J_ENABLE => data_k_j_enable_matrix_state,

        DATA_A_OUT_I_ENABLE => data_a_out_i_enable_matrix_state,
        DATA_A_OUT_J_ENABLE => data_a_out_j_enable_matrix_state,

        -- DATA
        SIZE_A_I_IN => size_a_in_i_matrix_state,
        SIZE_A_J_IN => size_a_in_j_matrix_state,
        SIZE_B_I_IN => size_b_in_i_matrix_state,
        SIZE_B_J_IN => size_b_in_j_matrix_state,
        SIZE_C_I_IN => size_c_in_i_matrix_state,
        SIZE_C_J_IN => size_c_in_j_matrix_state,
        SIZE_D_I_IN => size_d_in_i_matrix_state,
        SIZE_D_J_IN => size_d_in_j_matrix_state,

        DATA_A_IN => data_a_in_matrix_state,
        DATA_B_IN => data_b_in_matrix_state,
        DATA_C_IN => data_c_in_matrix_state,
        DATA_D_IN => data_d_in_matrix_state,

        DATA_K_IN => data_k_in_matrix_state,

        DATA_A_OUT => data_a_out_matrix_state
        );
  end generate accelerator_state_matrix_state_test;

  -- MATRIX INPUT
  accelerator_state_matrix_input_test : if (ENABLE_ACCELERATOR_MATRIX_INPUT_TEST) generate
    state_matrix_input : accelerator_state_matrix_input
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_input,
        READY => ready_matrix_input,

        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_input,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_input,
        DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_input,
        DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_input,

        DATA_B_I_ENABLE => data_b_i_enable_matrix_input,
        DATA_B_J_ENABLE => data_b_j_enable_matrix_input,
        DATA_D_I_ENABLE => data_d_i_enable_matrix_input,
        DATA_D_J_ENABLE => data_d_j_enable_matrix_input,

        DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_input,
        DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_input,

        DATA_K_I_ENABLE => data_k_i_enable_matrix_input,
        DATA_K_J_ENABLE => data_k_j_enable_matrix_input,

        DATA_B_OUT_I_ENABLE => data_b_out_i_enable_matrix_input,
        DATA_B_OUT_J_ENABLE => data_b_out_j_enable_matrix_input,

        -- DATA
        SIZE_B_I_IN => size_b_in_i_matrix_input,
        SIZE_B_J_IN => size_b_in_j_matrix_input,
        SIZE_D_I_IN => size_d_in_i_matrix_input,
        SIZE_D_J_IN => size_d_in_j_matrix_input,

        DATA_B_IN => data_b_in_matrix_input,
        DATA_D_IN => data_d_in_matrix_input,

        DATA_K_IN => data_k_in_matrix_input,

        DATA_B_OUT => data_b_out_matrix_input
        );
  end generate accelerator_state_matrix_input_test;

  -- MATRIX OUTPUT
  accelerator_state_matrix_output_test : if (ENABLE_ACCELERATOR_MATRIX_OUTPUT_TEST) generate
    state_matrix_output : accelerator_state_matrix_output
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_output,
        READY => ready_matrix_output,

        DATA_C_IN_I_ENABLE => data_c_in_i_enable_matrix_output,
        DATA_C_IN_J_ENABLE => data_c_in_j_enable_matrix_output,
        DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_output,
        DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_output,

        DATA_C_I_ENABLE => data_c_i_enable_matrix_output,
        DATA_C_J_ENABLE => data_c_j_enable_matrix_output,
        DATA_D_I_ENABLE => data_d_i_enable_matrix_output,
        DATA_D_J_ENABLE => data_d_j_enable_matrix_output,

        DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_output,
        DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_output,

        DATA_K_I_ENABLE => data_k_i_enable_matrix_output,
        DATA_K_J_ENABLE => data_k_j_enable_matrix_output,

        DATA_C_OUT_I_ENABLE => data_c_out_i_enable_matrix_output,
        DATA_C_OUT_J_ENABLE => data_c_out_j_enable_matrix_output,

        -- DATA
        SIZE_C_I_IN => size_c_in_i_matrix_output,
        SIZE_C_J_IN => size_c_in_j_matrix_output,
        SIZE_D_I_IN => size_d_in_i_matrix_output,
        SIZE_D_J_IN => size_d_in_j_matrix_output,

        DATA_C_IN => data_c_in_matrix_output,
        DATA_D_IN => data_d_in_matrix_output,

        DATA_K_IN => data_k_in_matrix_output,

        DATA_C_OUT => data_c_out_matrix_output
        );
  end generate accelerator_state_matrix_output_test;

  -- MATRIX FEEDFORWARD
  accelerator_state_matrix_feedforward_test : if (ENABLE_ACCELERATOR_MATRIX_FEEDFORWARD_TEST) generate
    state_matrix_feedforward : accelerator_state_matrix_feedforward
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_feedforward,
        READY => ready_matrix_feedforward,

        DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_feedforward,
        DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_feedforward,

        DATA_D_I_ENABLE => data_d_i_enable_matrix_feedforward,
        DATA_D_J_ENABLE => data_d_j_enable_matrix_feedforward,

        DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_feedforward,
        DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_feedforward,

        DATA_K_I_ENABLE => data_k_i_enable_matrix_feedforward,
        DATA_K_J_ENABLE => data_k_j_enable_matrix_feedforward,

        DATA_D_OUT_I_ENABLE => data_d_out_i_matrix_feedforward,
        DATA_D_OUT_J_ENABLE => data_d_out_j_matrix_feedforward,

        -- DATA
        SIZE_D_I_IN => size_d_in_i_matrix_feedforward,
        SIZE_D_J_IN => size_d_in_j_matrix_feedforward,

        DATA_D_IN => data_d_in_matrix_feedforward,

        DATA_K_IN => data_k_in_matrix_feedforward,

        DATA_D_OUT => data_d_out_matrix_feedforward
        );
  end generate accelerator_state_matrix_feedforward_test;

end accelerator_state_feedback_testbench_architecture;
