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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;
use work.accelerator_lstm_controller_pkg.all;

entity accelerator_output_trainer is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    X_IN_T_ENABLE : in std_logic;       -- for t in 0 to X-1
    X_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    X_OUT_T_ENABLE : out std_logic;     -- for t in 0 to X-1
    X_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    R_IN_T_ENABLE : in std_logic;       -- for t in 0 to T-1
    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    R_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    RHO_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
    RHO_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
    RHO_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

    RHO_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
    RHO_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
    RHO_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

    XI_IN_T_ENABLE : in std_logic;      -- for t in 0 to T-1
    XI_IN_S_ENABLE : in std_logic;      -- for s in 0 to S-1

    XI_OUT_T_ENABLE : out std_logic;    -- for t in 0 to T-1
    XI_OUT_S_ENABLE : out std_logic;    -- for s in 0 to S-1

    H_IN_T_ENABLE : in std_logic;       -- for t in 0 to T-1
    H_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    H_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    H_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    A_IN_T_ENABLE : in std_logic;       -- for t in 0 to T-1
    A_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    A_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    A_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    O_IN_T_ENABLE : in std_logic;       -- for t in 0 to T-1
    O_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    O_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    O_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    D_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    D_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    D_OUT_M_ENABLE : out std_logic;     -- for s in 0 to M-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    V_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    V_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1

    B_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- DATA
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_output_trainer_architecture of accelerator_output_trainer is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_x_in_fsm is (
    STARTER_X_IN_STATE,                 -- STEP 0
    INPUT_X_IN_T_STATE,                 -- STEP 1
    INPUT_X_IN_X_STATE,                 -- STEP 2
    CLEAN_X_IN_T_STATE,                 -- STEP 3
    CLEAN_X_IN_X_STATE                  -- STEP 4
    );

  type controller_r_in_fsm is (
    STARTER_R_IN_STATE,                 -- STEP 0
    INPUT_R_IN_T_STATE,                 -- STEP 1
    INPUT_R_IN_I_STATE,                 -- STEP 2
    INPUT_R_IN_K_STATE,                 -- STEP 3
    CLEAN_R_IN_T_STATE,                 -- STEP 4
    CLEAN_R_IN_I_STATE,                 -- STEP 5
    CLEAN_R_IN_K_STATE                  -- STEP 6
    );

  type controller_rho_in_fsm is (
    STARTER_RHO_IN_STATE,               -- STEP 0
    INPUT_RHO_IN_T_STATE,               -- STEP 1
    INPUT_RHO_IN_I_STATE,               -- STEP 2
    INPUT_RHO_IN_M_STATE,               -- STEP 3
    CLEAN_RHO_IN_T_STATE,               -- STEP 4
    CLEAN_RHO_IN_I_STATE,               -- STEP 5
    CLEAN_RHO_IN_M_STATE                -- STEP 6
    );

  type controller_xi_in_fsm is (
    STARTER_XI_IN_STATE,                -- STEP 0
    INPUT_XI_IN_T_STATE,                -- STEP 1
    INPUT_XI_IN_S_STATE,                -- STEP 2
    CLEAN_XI_IN_T_STATE,                -- STEP 3
    CLEAN_XI_IN_S_STATE                 -- STEP 4
    );

  type controller_h_in_fsm is (
    STARTER_H_IN_STATE,                 -- STEP 0
    INPUT_H_IN_T_STATE,                 -- STEP 1
    INPUT_H_IN_L_STATE,                 -- STEP 2
    CLEAN_H_IN_T_STATE,                 -- STEP 3
    CLEAN_H_IN_L_STATE                  -- STEP 4
    );

  type controller_a_in_fsm is (
    STARTER_A_IN_STATE,                 -- STEP 0
    INPUT_A_IN_T_STATE,                 -- STEP 1
    INPUT_A_IN_L_STATE,                 -- STEP 2
    CLEAN_A_IN_T_STATE,                 -- STEP 3
    CLEAN_A_IN_L_STATE                  -- STEP 4
    );

  type controller_o_in_fsm is (
    STARTER_O_IN_STATE,                 -- STEP 0
    INPUT_O_IN_T_STATE,                 -- STEP 1
    INPUT_O_IN_L_STATE,                 -- STEP 2
    CLEAN_O_IN_T_STATE,                 -- STEP 3
    CLEAN_O_IN_L_STATE                  -- STEP 4
    );

  -- Ops
  type controller_differentiation_fsm is (
    STARTER_DIFFERENTIATION_STATE,      -- STEP 0
    INPUT_I_DIFFERENTIATION_STATE,      -- STEP 1
    INPUT_J_DIFFERENTIATION_STATE,      -- STEP 2
    INPUT_K_DIFFERENTIATION_STATE,      -- STEP 3
    CLEAN_I_DIFFERENTIATION_STATE,      -- STEP 4
    CLEAN_J_DIFFERENTIATION_STATE,      -- STEP 5
    CLEAN_K_DIFFERENTIATION_STATE       -- STEP 6
    );

  -- Output
  type controller_k_out_fsm is (
    STARTER_K_OUT_STATE,                -- STEP 0
    CLEAN_K_OUT_L_STATE,                -- STEP 1
    CLEAN_K_OUT_I_STATE,                -- STEP 2
    CLEAN_K_OUT_K_STATE,                -- STEP 3
    OUTPUT_K_OUT_L_STATE,               -- STEP 4
    OUTPUT_K_OUT_I_STATE,               -- STEP 5
    OUTPUT_K_OUT_K_STATE                -- STEP 6
    );

  type controller_d_out_fsm is (
    STARTER_D_OUT_STATE,                -- STEP 0
    CLEAN_D_OUT_L_STATE,                -- STEP 1
    CLEAN_D_OUT_I_STATE,                -- STEP 2
    CLEAN_D_OUT_M_STATE,                -- STEP 3
    OUTPUT_D_OUT_L_STATE,               -- STEP 4
    OUTPUT_D_OUT_I_STATE,               -- STEP 5
    OUTPUT_D_OUT_M_STATE                -- STEP 6
    );

  type controller_w_out_fsm is (
    STARTER_W_OUT_STATE,                -- STEP 0
    CLEAN_W_OUT_L_STATE,                -- STEP 1
    CLEAN_W_OUT_X_STATE,                -- STEP 2
    OUTPUT_W_OUT_L_STATE,               -- STEP 3
    OUTPUT_W_OUT_X_STATE                -- STEP 4
    );

  type controller_v_out_fsm is (
    STARTER_V_OUT_STATE,                -- STEP 0
    CLEAN_V_OUT_L_STATE,                -- STEP 1
    CLEAN_V_OUT_S_STATE,                -- STEP 2
    OUTPUT_V_OUT_L_STATE,               -- STEP 3
    OUTPUT_V_OUT_S_STATE                -- STEP 4
    );

  type controller_u_out_fsm is (
    STARTER_U_OUT_STATE,                -- STEP 0
    CLEAN_U_OUT_L_STATE,                -- STEP 1
    CLEAN_U_OUT_P_STATE,                -- STEP 2
    OUTPUT_U_OUT_L_STATE,               -- STEP 3
    OUTPUT_U_OUT_P_STATE                -- STEP 4
    );

  type controller_b_out_fsm is (
    STARTER_B_OUT_STATE,                -- STEP 0
    CLEAN_B_OUT_T_STATE,                -- STEP 1
    CLEAN_B_OUT_L_STATE,                -- STEP 2
    OUTPUT_B_OUT_T_STATE,               -- STEP 3
    OUTPUT_B_OUT_L_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_x_in_fsm_int   : controller_x_in_fsm;
  signal controller_r_in_fsm_int   : controller_r_in_fsm;
  signal controller_rho_in_fsm_int : controller_rho_in_fsm;
  signal controller_xi_in_fsm_int  : controller_xi_in_fsm;
  signal controller_h_in_fsm_int   : controller_h_in_fsm;

  signal controller_a_in_fsm_int : controller_a_in_fsm;
  signal controller_o_in_fsm_int : controller_o_in_fsm;

  -- Ops
  signal controller_differentiation_fsm_int : controller_differentiation_fsm;

  -- Output
  signal controller_w_out_fsm_int : controller_w_out_fsm;
  signal controller_k_out_fsm_int : controller_k_out_fsm;
  signal controller_d_out_fsm_int : controller_d_out_fsm;
  signal controller_u_out_fsm_int : controller_u_out_fsm;
  signal controller_v_out_fsm_int : controller_v_out_fsm;
  signal controller_b_out_fsm_int : controller_b_out_fsm;

  -- Buffer
  -- Input
  signal matrix_x_in_int   : matrix_buffer;
  signal tensor_r_in_int   : tensor_buffer;
  signal tensor_rho_in_int : tensor_buffer;
  signal matrix_xi_in_int  : matrix_buffer;
  signal matrix_h_in_int   : matrix_buffer;

  signal matrix_a_in_int : matrix_buffer;
  signal matrix_o_in_int : matrix_buffer;

  -- Ops
  signal tensor_operation_int : tensor_buffer;

  -- Output
  signal matrix_w_out_int : matrix_buffer;
  signal tensor_k_out_int : tensor_buffer;
  signal tensor_d_out_int : tensor_buffer;
  signal matrix_u_out_int : matrix_buffer;
  signal matrix_v_out_int : matrix_buffer;
  signal vector_b_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_t_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_i_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_i_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_xi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_s_xi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_a_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_a_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_o_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_o_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_differentiation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_differentiation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_differentiation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_l_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_k_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_i_k_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_d_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_i_d_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_d_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_u_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_u_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_v_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_s_v_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_x_in_enable_int   : std_logic;
  signal data_r_in_enable_int   : std_logic;
  signal data_rho_in_enable_int : std_logic;
  signal data_xi_in_enable_int  : std_logic;
  signal data_h_in_enable_int   : std_logic;

  signal data_a_in_enable_int : std_logic;
  signal data_o_in_enable_int : std_logic;

  -- Ops
  signal data_differentiation_enable_int : std_logic;

  -- DIFFERENTIATION
  -- CONTROL
  signal start_differentiation : std_logic;
  signal ready_differentiation : std_logic;

  signal data_in_i_enable_differentiation : std_logic;
  signal data_in_j_enable_differentiation : std_logic;
  signal data_in_k_enable_differentiation : std_logic;

  signal data_i_enable_differentiation : std_logic;
  signal data_j_enable_differentiation : std_logic;
  signal data_k_enable_differentiation : std_logic;

  signal data_out_i_enable_differentiation : std_logic;
  signal data_out_j_enable_differentiation : std_logic;

  -- DATA
  signal size_i_in_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR FLOAT ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_adder : std_logic;

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_length_enable_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_enable_length_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR FLOAT MULTIPLIER
  -- CONTROL
  signal start_scalar_float_multiplier : std_logic;
  signal ready_scalar_float_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_multiplier : std_logic;

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_enable_vector_differentiation : std_logic;

  signal data_out_enable_vector_differentiation : std_logic;

  -- DATA
  signal size_in_vector_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- INPUT CONTROL
  x_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      X_OUT_T_ENABLE <= '0';
      X_OUT_X_ENABLE <= '0';

      -- Control Internal
      index_t_x_in_loop <= ZERO_CONTROL;
      index_x_x_in_loop <= ZERO_CONTROL;

      data_x_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_x_in_fsm_int is
        when STARTER_X_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= ZERO_CONTROL;
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '0';

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_T_STATE;
          else
            -- Control Outputs
            X_OUT_T_ENABLE <= '0';
            X_OUT_X_ENABLE <= '0';
          end if;

        when INPUT_X_IN_T_STATE =>      -- STEP 1

          if ((X_IN_T_ENABLE = '1') and (X_IN_X_ENABLE = '1')) then
            -- Data Inputs
            matrix_x_in_int(to_integer(unsigned(index_t_x_in_loop)), to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            controller_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
          end if;

          -- Control Outputs
          X_OUT_T_ENABLE <= '0';
          X_OUT_X_ENABLE <= '0';

        when INPUT_X_IN_X_STATE =>      -- STEP 2

          if (X_IN_X_ENABLE = '1') then
            -- Data Inputs
            matrix_x_in_int(to_integer(unsigned(index_t_x_in_loop)), to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            if (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              controller_x_in_fsm_int <= CLEAN_X_IN_T_STATE;
            else
              controller_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
            end if;
          end if;

          -- Control Outputs
          X_OUT_X_ENABLE <= '0';

        when CLEAN_X_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_x_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= ZERO_CONTROL;
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '1';

            -- FSM Control
            controller_x_in_fsm_int <= STARTER_X_IN_STATE;
          elsif ((unsigned(index_t_x_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= std_logic_vector(unsigned(index_t_x_in_loop) + unsigned(ONE_CONTROL));
            index_x_x_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_T_STATE;
          end if;

        when CLEAN_X_IN_X_STATE =>      -- STEP 4

          if (unsigned(index_x_x_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= std_logic_vector(unsigned(index_x_x_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_x_in_fsm_int <= STARTER_X_IN_STATE;
      end case;
    end if;
  end process;

  r_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      R_OUT_T_ENABLE <= '0';
      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_t_r_in_loop <= ZERO_CONTROL;
      index_i_r_in_loop <= ZERO_CONTROL;
      index_k_r_in_loop <= ZERO_CONTROL;

      data_r_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_r_in_fsm_int is
        when STARTER_R_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            R_OUT_T_ENABLE <= '1';
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_t_r_in_loop <= ZERO_CONTROL;
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '0';

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          else
            -- Control Outputs
            R_OUT_T_ENABLE <= '0';
            R_OUT_I_ENABLE <= '0';
            R_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_R_IN_T_STATE =>      -- STEP 1

          if ((R_IN_T_ENABLE = '1') and (R_IN_I_ENABLE = '1') and (R_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_r_in_int(to_integer(unsigned(index_t_r_in_loop)), to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            controller_r_in_fsm_int <= CLEAN_R_IN_T_STATE;
          end if;

          -- Control Outputs
          R_OUT_T_ENABLE <= '0';
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

        when INPUT_R_IN_I_STATE =>      -- STEP 2

          if ((R_IN_I_ENABLE = '1') and (R_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_r_in_int(to_integer(unsigned(index_t_r_in_loop)), to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            if (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_r_in_fsm_int <= CLEAN_R_IN_T_STATE;
            else
              controller_r_in_fsm_int <= CLEAN_R_IN_I_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

        when INPUT_R_IN_K_STATE =>      -- STEP 3

          if (R_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_r_in_int(to_integer(unsigned(index_t_r_in_loop)), to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            if ((unsigned(index_i_r_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_r_in_fsm_int <= CLEAN_R_IN_T_STATE;
            elsif (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_r_in_fsm_int <= CLEAN_R_IN_I_STATE;
            else
              controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

        when CLEAN_R_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_r_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_r_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_T_ENABLE <= '1';
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_t_r_in_loop <= ZERO_CONTROL;
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '1';

            -- FSM Control
            controller_r_in_fsm_int <= STARTER_R_IN_STATE;
          elsif ((unsigned(index_t_r_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_r_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_T_ENABLE <= '1';
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_t_r_in_loop <= std_logic_vector(unsigned(index_t_r_in_loop) + unsigned(ONE_CONTROL));
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_T_STATE;
          end if;

        when CLEAN_R_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_r_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= std_logic_vector(unsigned(index_i_r_in_loop) + unsigned(ONE_CONTROL));
            index_k_r_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          end if;

        when CLEAN_R_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_r_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_in_loop <= std_logic_vector(unsigned(index_k_r_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_r_in_fsm_int <= STARTER_R_IN_STATE;
      end case;
    end if;
  end process;

  rho_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      RHO_OUT_T_ENABLE <= '0';
      RHO_OUT_I_ENABLE <= '0';
      RHO_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_t_rho_in_loop <= ZERO_CONTROL;
      index_i_rho_in_loop <= ZERO_CONTROL;
      index_m_rho_in_loop <= ZERO_CONTROL;

      data_rho_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_rho_in_fsm_int is
        when STARTER_RHO_IN_STATE =>    -- STEP 0
          if (START = '1') then
            -- Control Outputs
            RHO_OUT_T_ENABLE <= '1';
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_t_rho_in_loop <= ZERO_CONTROL;
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '0';

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          else
            -- Control Outputs
            RHO_OUT_T_ENABLE <= '0';
            RHO_OUT_I_ENABLE <= '0';
            RHO_OUT_M_ENABLE <= '0';
          end if;

        when INPUT_RHO_IN_T_STATE =>    -- STEP 1

          if ((RHO_IN_T_ENABLE = '1') and (RHO_IN_I_ENABLE = '1') and (RHO_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_rho_in_int(to_integer(unsigned(index_t_rho_in_loop)), to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            controller_rho_in_fsm_int <= CLEAN_RHO_IN_T_STATE;
          end if;

          -- Control Outputs
          RHO_OUT_T_ENABLE <= '0';
          RHO_OUT_I_ENABLE <= '0';
          RHO_OUT_M_ENABLE <= '0';

        when INPUT_RHO_IN_I_STATE =>    -- STEP 2

          if ((RHO_IN_I_ENABLE = '1') and (RHO_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_rho_in_int(to_integer(unsigned(index_t_rho_in_loop)), to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            if (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_T_STATE;
            else
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_I_STATE;
            end if;
          end if;

          -- Control Outputs
          RHO_OUT_I_ENABLE <= '0';
          RHO_OUT_M_ENABLE <= '0';

        when INPUT_RHO_IN_M_STATE =>    -- STEP 3

          if (RHO_IN_M_ENABLE = '1') then
            -- Data Inputs
            tensor_rho_in_int(to_integer(unsigned(index_t_rho_in_loop)), to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            if ((unsigned(index_i_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_T_STATE;
            elsif (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_I_STATE;
            else
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_M_STATE;
            end if;
          end if;

          -- Control Outputs
          RHO_OUT_M_ENABLE <= '0';

        when CLEAN_RHO_IN_T_STATE =>    -- STEP 3

          if ((unsigned(index_t_rho_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_T_ENABLE <= '1';
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_t_rho_in_loop <= ZERO_CONTROL;
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '1';

            -- FSM Control
            controller_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
          elsif ((unsigned(index_t_rho_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_T_ENABLE <= '1';
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_t_rho_in_loop <= std_logic_vector(unsigned(index_t_rho_in_loop) + unsigned(ONE_CONTROL));
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_T_STATE;
          end if;

        when CLEAN_RHO_IN_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_rho_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= std_logic_vector(unsigned(index_i_rho_in_loop) + unsigned(ONE_CONTROL));
            index_m_rho_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          end if;

        when CLEAN_RHO_IN_M_STATE =>    -- STEP 4

          if (unsigned(index_m_rho_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_rho_in_loop <= std_logic_vector(unsigned(index_m_rho_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_M_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
      end case;
    end if;
  end process;

  xi_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      XI_OUT_T_ENABLE <= '0';
      XI_OUT_S_ENABLE <= '0';

      -- Control Internal
      index_t_xi_in_loop <= ZERO_CONTROL;
      index_s_xi_in_loop <= ZERO_CONTROL;

      data_xi_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_xi_in_fsm_int is
        when STARTER_XI_IN_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Outputs
            XI_OUT_T_ENABLE <= '1';
            XI_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_t_xi_in_loop <= ZERO_CONTROL;
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '0';

            -- FSM Control
            controller_xi_in_fsm_int <= INPUT_XI_IN_T_STATE;
          else
            -- Control Outputs
            XI_OUT_T_ENABLE <= '0';
            XI_OUT_S_ENABLE <= '0';
          end if;

        when INPUT_XI_IN_T_STATE =>     -- STEP 1

          if ((XI_IN_T_ENABLE = '1') and (XI_IN_S_ENABLE = '1')) then
            -- Data Inputs
            matrix_xi_in_int(to_integer(unsigned(index_t_xi_in_loop)), to_integer(unsigned(index_s_xi_in_loop))) <= XI_IN;

            -- FSM Control
            controller_xi_in_fsm_int <= CLEAN_XI_IN_S_STATE;
          end if;

          -- Control Outputs
          XI_OUT_T_ENABLE <= '0';
          XI_OUT_S_ENABLE <= '0';

        when INPUT_XI_IN_S_STATE =>     -- STEP 2

          if (XI_IN_S_ENABLE = '1') then
            -- Data Inputs
            matrix_xi_in_int(to_integer(unsigned(index_t_xi_in_loop)), to_integer(unsigned(index_s_xi_in_loop))) <= XI_IN;

            -- FSM Control
            if (unsigned(index_s_xi_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
              controller_xi_in_fsm_int <= CLEAN_XI_IN_T_STATE;
            else
              controller_xi_in_fsm_int <= CLEAN_XI_IN_S_STATE;
            end if;
          end if;

          -- Control Outputs
          XI_OUT_S_ENABLE <= '0';

        when CLEAN_XI_IN_T_STATE =>     -- STEP 3

          if ((unsigned(index_t_xi_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_xi_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            XI_OUT_T_ENABLE <= '1';
            XI_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_t_xi_in_loop <= ZERO_CONTROL;
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '1';

            -- FSM Control
            controller_xi_in_fsm_int <= STARTER_XI_IN_STATE;
          elsif ((unsigned(index_t_xi_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_xi_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            XI_OUT_T_ENABLE <= '1';
            XI_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_t_xi_in_loop <= std_logic_vector(unsigned(index_t_xi_in_loop) + unsigned(ONE_CONTROL));
            index_s_xi_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_xi_in_fsm_int <= INPUT_XI_IN_T_STATE;
          end if;

        when CLEAN_XI_IN_S_STATE =>     -- STEP 4

          if (unsigned(index_s_xi_in_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            XI_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_s_xi_in_loop <= std_logic_vector(unsigned(index_s_xi_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_xi_in_fsm_int <= INPUT_XI_IN_S_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_xi_in_fsm_int <= STARTER_XI_IN_STATE;
      end case;
    end if;
  end process;

  h_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      H_OUT_T_ENABLE <= '0';
      H_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_t_h_in_loop <= ZERO_CONTROL;
      index_l_h_in_loop <= ZERO_CONTROL;

      data_h_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_h_in_fsm_int is
        when STARTER_H_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            H_OUT_T_ENABLE <= '1';
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_h_in_loop <= ZERO_CONTROL;
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '0';

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_T_STATE;
          else
            -- Control Outputs
            H_OUT_T_ENABLE <= '0';
            H_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_H_IN_T_STATE =>      -- STEP 1

          if ((H_IN_T_ENABLE = '1') and (H_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_h_in_int(to_integer(unsigned(index_t_h_in_loop)), to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
          end if;

          -- Control Outputs
          H_OUT_T_ENABLE <= '0';
          H_OUT_L_ENABLE <= '0';

        when INPUT_H_IN_L_STATE =>      -- STEP 2

          if (H_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_h_in_int(to_integer(unsigned(index_t_h_in_loop)), to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            if (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_h_in_fsm_int <= CLEAN_H_IN_T_STATE;
            else
              controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          H_OUT_L_ENABLE <= '0';

        when CLEAN_H_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_h_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            H_OUT_T_ENABLE <= '1';
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_h_in_loop <= ZERO_CONTROL;
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '1';

            -- FSM Control
            controller_h_in_fsm_int <= STARTER_H_IN_STATE;
          elsif ((unsigned(index_t_h_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            H_OUT_T_ENABLE <= '1';
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_h_in_loop <= std_logic_vector(unsigned(index_t_h_in_loop) + unsigned(ONE_CONTROL));
            index_l_h_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_T_STATE;
          end if;

        when CLEAN_H_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_h_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= std_logic_vector(unsigned(index_l_h_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_h_in_fsm_int <= STARTER_H_IN_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  differentiation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_i_enable_differentiation <= '0';
      data_in_j_enable_differentiation <= '0';
      data_in_k_enable_differentiation <= '0';

      data_differentiation_enable_int <= '0';

      index_i_differentiation_loop <= ZERO_CONTROL;
      index_j_differentiation_loop <= ZERO_CONTROL;
      index_k_differentiation_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_differentiation_fsm_int is
        when STARTER_DIFFERENTIATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_i_enable_differentiation <= '0';
          data_in_j_enable_differentiation <= '0';
          data_in_k_enable_differentiation <= '0';

          data_differentiation_enable_int <= '0';

          if (START = '1') then
            -- Data Inputs
            size_i_in_differentiation <= SIZE_R_IN;
            size_j_in_differentiation <= SIZE_L_IN;
            size_k_in_differentiation <= SIZE_W_IN;

            -- Control Internal
            index_i_differentiation_loop <= ZERO_CONTROL;
            index_j_differentiation_loop <= ZERO_CONTROL;
            index_k_differentiation_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_differentiation_fsm_int <= INPUT_I_DIFFERENTIATION_STATE;
          end if;

        when INPUT_I_DIFFERENTIATION_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_differentiation <= tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop)));

          -- Control Internal
          if (unsigned(index_i_differentiation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_differentiation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_differentiation_loop) = unsigned(ZERO_CONTROL)) then
            start_differentiation <= '1';
          end if;

          data_in_i_enable_differentiation <= '1';
          data_in_j_enable_differentiation <= '1';
          data_in_k_enable_differentiation <= '1';

          -- FSM Control
          controller_differentiation_fsm_int <= CLEAN_K_DIFFERENTIATION_STATE;

        when INPUT_J_DIFFERENTIATION_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_differentiation <= tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop)));

          data_in_j_enable_differentiation <= '1';
          data_in_k_enable_differentiation <= '1';

          -- FSM Control
          if (unsigned(index_k_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_differentiation_fsm_int <= CLEAN_J_DIFFERENTIATION_STATE;
          else
            controller_differentiation_fsm_int <= CLEAN_K_DIFFERENTIATION_STATE;
          end if;

        when INPUT_K_DIFFERENTIATION_STATE =>  -- STEP 6

          -- Data Inputs
          data_in_differentiation <= tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop)));

          -- Control Internal
          data_in_k_enable_differentiation <= '1';

          -- FSM Control
          if ((unsigned(index_j_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            controller_differentiation_fsm_int <= CLEAN_I_DIFFERENTIATION_STATE;
          elsif (unsigned(index_k_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_differentiation_fsm_int <= CLEAN_J_DIFFERENTIATION_STATE;
          else
            controller_differentiation_fsm_int <= CLEAN_K_DIFFERENTIATION_STATE;
          end if;

        when CLEAN_I_DIFFERENTIATION_STATE =>  -- STEP 7

          if (data_i_enable_differentiation = '1' and data_j_enable_differentiation = '1' and data_k_enable_differentiation = '1') then
            if ((unsigned(index_j_differentiation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              data_differentiation_enable_int <= '1';

              index_i_differentiation_loop <= ZERO_CONTROL;
              index_j_differentiation_loop <= ZERO_CONTROL;
              index_k_differentiation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_differentiation_fsm_int <= STARTER_DIFFERENTIATION_STATE;
            elsif ((unsigned(index_j_differentiation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              index_i_differentiation_loop <= std_logic_vector(unsigned(index_i_differentiation_loop) + unsigned(ONE_CONTROL));
              index_j_differentiation_loop <= ZERO_CONTROL;
              index_k_differentiation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_differentiation_fsm_int <= INPUT_J_DIFFERENTIATION_STATE;
            end if;
          else
            -- Control Internal
            start_differentiation <= '0';

            data_in_i_enable_differentiation <= '0';
            data_in_j_enable_differentiation <= '0';
            data_in_k_enable_differentiation <= '0';
          end if;

        when CLEAN_J_DIFFERENTIATION_STATE =>  -- STEP 7

          if (data_j_enable_differentiation = '1' and data_k_enable_differentiation = '1') then
            if ((unsigned(index_j_differentiation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              index_j_differentiation_loop <= std_logic_vector(unsigned(index_j_differentiation_loop) + unsigned(ONE_CONTROL));
              index_k_differentiation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_differentiation_fsm_int <= INPUT_J_DIFFERENTIATION_STATE;
            end if;
          else
            -- Control Internal
            start_differentiation <= '0';

            data_in_i_enable_differentiation <= '0';
            data_in_j_enable_differentiation <= '0';
            data_in_k_enable_differentiation <= '0';
          end if;

        when CLEAN_K_DIFFERENTIATION_STATE =>  -- STEP 8

          if (data_k_enable_differentiation = '1') then
            if (unsigned(index_k_differentiation_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              index_k_differentiation_loop <= std_logic_vector(unsigned(index_k_differentiation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_differentiation_fsm_int <= INPUT_J_DIFFERENTIATION_STATE;
            end if;
          else
            -- Control Internal
            start_differentiation <= '0';

            data_in_i_enable_differentiation <= '0';
            data_in_j_enable_differentiation <= '0';
            data_in_k_enable_differentiation <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_differentiation_fsm_int <= STARTER_DIFFERENTIATION_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))
  a_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      A_OUT_T_ENABLE <= '0';
      A_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_t_a_in_loop <= ZERO_CONTROL;
      index_l_a_in_loop <= ZERO_CONTROL;

      data_a_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_a_in_fsm_int is
        when STARTER_A_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            A_OUT_T_ENABLE <= '1';
            A_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_a_in_loop <= ZERO_CONTROL;
            index_l_a_in_loop <= ZERO_CONTROL;

            data_a_in_enable_int <= '0';

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_T_STATE;
          else
            -- Control Outputs
            A_OUT_T_ENABLE <= '0';
            A_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_A_IN_T_STATE =>      -- STEP 1

          if ((A_IN_T_ENABLE = '1') and (A_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_a_in_int(to_integer(unsigned(index_t_a_in_loop)), to_integer(unsigned(index_l_a_in_loop))) <= A_IN;

            -- FSM Control
            controller_a_in_fsm_int <= CLEAN_A_IN_L_STATE;
          end if;

          -- Control Outputs
          A_OUT_T_ENABLE <= '0';
          A_OUT_L_ENABLE <= '0';

        when INPUT_A_IN_L_STATE =>      -- STEP 2

          if (A_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_a_in_int(to_integer(unsigned(index_t_a_in_loop)), to_integer(unsigned(index_l_a_in_loop))) <= A_IN;

            -- FSM Control
            if (unsigned(index_l_a_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_a_in_fsm_int <= CLEAN_A_IN_T_STATE;
            else
              controller_a_in_fsm_int <= CLEAN_A_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          A_OUT_L_ENABLE <= '0';

        when CLEAN_A_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_a_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_a_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            A_OUT_T_ENABLE <= '1';
            A_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_a_in_loop <= ZERO_CONTROL;
            index_l_a_in_loop <= ZERO_CONTROL;

            data_a_in_enable_int <= '1';

            -- FSM Control
            controller_a_in_fsm_int <= STARTER_A_IN_STATE;
          elsif ((unsigned(index_t_a_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_a_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            A_OUT_T_ENABLE <= '1';
            A_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_a_in_loop <= std_logic_vector(unsigned(index_t_a_in_loop) + unsigned(ONE_CONTROL));
            index_l_a_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_T_STATE;
          end if;

        when CLEAN_A_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_a_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            A_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_a_in_loop <= std_logic_vector(unsigned(index_l_a_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_a_in_fsm_int <= STARTER_A_IN_STATE;
      end case;
    end if;
  end process;

  o_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      O_OUT_T_ENABLE <= '0';
      O_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_t_o_in_loop <= ZERO_CONTROL;
      index_l_o_in_loop <= ZERO_CONTROL;

      data_o_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_o_in_fsm_int is
        when STARTER_O_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            O_OUT_T_ENABLE <= '1';
            O_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_o_in_loop <= ZERO_CONTROL;
            index_l_o_in_loop <= ZERO_CONTROL;

            data_o_in_enable_int <= '0';

            -- FSM Control
            controller_o_in_fsm_int <= INPUT_O_IN_T_STATE;
          else
            -- Control Outputs
            O_OUT_T_ENABLE <= '0';
            O_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_O_IN_T_STATE =>      -- STEP 1

          if ((O_IN_T_ENABLE = '1') and (O_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_o_in_int(to_integer(unsigned(index_t_o_in_loop)), to_integer(unsigned(index_l_o_in_loop))) <= O_IN;

            -- FSM Control
            controller_o_in_fsm_int <= CLEAN_O_IN_L_STATE;
          end if;

          -- Control Outputs
          O_OUT_T_ENABLE <= '0';
          O_OUT_L_ENABLE <= '0';

        when INPUT_O_IN_L_STATE =>      -- STEP 2

          if (O_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_o_in_int(to_integer(unsigned(index_t_o_in_loop)), to_integer(unsigned(index_l_o_in_loop))) <= O_IN;

            -- FSM Control
            if (unsigned(index_l_o_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_o_in_fsm_int <= CLEAN_O_IN_T_STATE;
            else
              controller_o_in_fsm_int <= CLEAN_O_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          O_OUT_L_ENABLE <= '0';

        when CLEAN_O_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_o_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_o_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            O_OUT_T_ENABLE <= '1';
            O_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_o_in_loop <= ZERO_CONTROL;
            index_l_o_in_loop <= ZERO_CONTROL;

            data_o_in_enable_int <= '1';

            -- FSM Control
            controller_o_in_fsm_int <= STARTER_O_IN_STATE;
          elsif ((unsigned(index_t_o_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_o_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            O_OUT_T_ENABLE <= '1';
            O_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_o_in_loop <= std_logic_vector(unsigned(index_t_o_in_loop) + unsigned(ONE_CONTROL));
            index_l_o_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_o_in_fsm_int <= INPUT_O_IN_T_STATE;
          end if;

        when CLEAN_O_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_o_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            O_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_o_in_loop <= std_logic_vector(unsigned(index_l_o_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_o_in_fsm_int <= INPUT_O_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_o_in_fsm_int <= STARTER_O_IN_STATE;
      end case;
    end if;
  end process;

  -- dW(l;x) = summation(do(t;l) · x(t;x))[t in 0 to T]
  w_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      W_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_L_ENABLE <= '0';
      W_OUT_X_ENABLE <= '0';

      -- Control Internal
      index_l_w_out_loop <= ZERO_CONTROL;
      index_x_w_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_w_out_fsm_int is
        when STARTER_W_OUT_STATE =>     -- STEP 0
          if (data_x_in_enable_int = '1' and data_h_in_enable_int = '1' and data_a_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_w_out_loop <= ZERO_CONTROL;
            index_x_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_L_STATE;
          end if;

        when CLEAN_W_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          W_OUT_L_ENABLE <= '0';
          W_OUT_X_ENABLE <= '0';

          -- FSM Control
          controller_w_out_fsm_int <= OUTPUT_W_OUT_X_STATE;

        when CLEAN_W_OUT_X_STATE =>     -- STEP 2

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_x_w_out_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            controller_w_out_fsm_int <= OUTPUT_W_OUT_L_STATE;
          else
            controller_w_out_fsm_int <= OUTPUT_W_OUT_X_STATE;
          end if;

        when OUTPUT_W_OUT_L_STATE =>    -- STEP 3

          if ((unsigned(index_l_w_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_out_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_l_w_out_loop)), to_integer(unsigned(index_x_w_out_loop)));

            -- Control Outputs
            READY <= '1';

            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_out_loop <= ZERO_CONTROL;
            index_x_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
          elsif ((unsigned(index_l_w_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_out_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_l_w_out_loop)), to_integer(unsigned(index_x_w_out_loop)));

            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_out_loop <= std_logic_vector(unsigned(index_l_w_out_loop) + unsigned(ONE_CONTROL));
            index_x_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_L_STATE;
          end if;

        when OUTPUT_W_OUT_X_STATE =>    -- STEP 4

          if (unsigned(index_x_w_out_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_x_w_out_loop <= std_logic_vector(unsigned(index_x_w_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
      end case;
    end if;
  end process;

  -- dK(l;i;k) = summation(do(t;l) · r(t;i;k))[t in 0 to T-1]
  k_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      K_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      K_OUT_L_ENABLE <= '0';
      K_OUT_I_ENABLE <= '0';
      K_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_l_k_out_loop <= ZERO_CONTROL;
      index_i_k_out_loop <= ZERO_CONTROL;
      index_k_k_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_k_out_fsm_int is
        when STARTER_K_OUT_STATE =>     -- STEP 0
          if (data_r_in_enable_int = '1' and data_h_in_enable_int = '1' and data_a_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_k_out_loop <= ZERO_CONTROL;
            index_i_k_out_loop <= ZERO_CONTROL;
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_L_STATE;
          end if;

        when CLEAN_K_OUT_L_STATE =>     -- STEP 1

          -- Control Outputs
          K_OUT_L_ENABLE <= '0';
          K_OUT_I_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

          -- FSM Control
          controller_k_out_fsm_int <= OUTPUT_K_OUT_K_STATE;

        when CLEAN_K_OUT_I_STATE =>     -- STEP 2

          -- Control Outputs
          K_OUT_I_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_k_out_fsm_int <= OUTPUT_K_OUT_I_STATE;
          else
            controller_k_out_fsm_int <= OUTPUT_K_OUT_K_STATE;
          end if;

        when CLEAN_K_OUT_K_STATE =>     -- STEP 2

          -- Control Outputs
          K_OUT_K_ENABLE <= '0';

          -- FSM Control
          if ((unsigned(index_l_k_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            controller_k_out_fsm_int <= OUTPUT_K_OUT_L_STATE;
          elsif (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_k_out_fsm_int <= OUTPUT_K_OUT_I_STATE;
          else
            controller_k_out_fsm_int <= OUTPUT_K_OUT_K_STATE;
          end if;

        when OUTPUT_K_OUT_L_STATE =>    -- STEP 3

          if ((unsigned(index_l_k_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_k_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            K_OUT <= tensor_k_out_int(to_integer(unsigned(index_l_k_out_loop)), to_integer(unsigned(index_i_k_out_loop)), to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            READY <= '1';

            K_OUT_L_ENABLE <= '1';
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_l_k_out_loop <= ZERO_CONTROL;
            index_i_k_out_loop <= ZERO_CONTROL;
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= STARTER_K_OUT_STATE;
          elsif ((unsigned(index_l_k_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_k_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            K_OUT <= tensor_k_out_int(to_integer(unsigned(index_l_k_out_loop)), to_integer(unsigned(index_i_k_out_loop)), to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            K_OUT_L_ENABLE <= '1';
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_l_k_out_loop <= std_logic_vector(unsigned(index_l_k_out_loop) + unsigned(ONE_CONTROL));
            index_i_k_out_loop <= ZERO_CONTROL;
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_L_STATE;
          end if;

        when OUTPUT_K_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_k_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            K_OUT <= tensor_k_out_int(to_integer(unsigned(index_l_k_out_loop)), to_integer(unsigned(index_i_k_out_loop)), to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_out_loop <= std_logic_vector(unsigned(index_i_k_out_loop) + unsigned(ONE_CONTROL));
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_I_STATE;
          end if;

        when OUTPUT_K_OUT_K_STATE =>    -- STEP 4

          if (unsigned(index_k_k_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            K_OUT <= tensor_k_out_int(to_integer(unsigned(index_l_k_out_loop)), to_integer(unsigned(index_i_k_out_loop)), to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_out_loop <= std_logic_vector(unsigned(index_k_k_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_out_fsm_int <= STARTER_K_OUT_STATE;
      end case;
    end if;
  end process;

  -- dD(l;i;m) = summation(do(t;l) · rho(t;i;m))[t in 0 to T-1]
  d_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      D_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      D_OUT_L_ENABLE <= '0';
      D_OUT_I_ENABLE <= '0';
      D_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_l_d_out_loop <= ZERO_CONTROL;
      index_i_d_out_loop <= ZERO_CONTROL;
      index_m_d_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_d_out_fsm_int is
        when STARTER_D_OUT_STATE =>     -- STEP 0
          if (data_rho_in_enable_int = '1' and data_h_in_enable_int = '1' and data_a_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_d_out_loop <= ZERO_CONTROL;
            index_i_d_out_loop <= ZERO_CONTROL;
            index_m_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_L_STATE;
          end if;

        when CLEAN_D_OUT_L_STATE =>     -- STEP 1

          -- Control Outputs
          D_OUT_L_ENABLE <= '0';
          D_OUT_I_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

          -- FSM Control
          controller_d_out_fsm_int <= OUTPUT_D_OUT_M_STATE;

        when CLEAN_D_OUT_I_STATE =>     -- STEP 2

          -- Control Outputs
          D_OUT_I_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_m_d_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_d_out_fsm_int <= OUTPUT_D_OUT_I_STATE;
          else
            controller_d_out_fsm_int <= OUTPUT_D_OUT_M_STATE;
          end if;

        when CLEAN_D_OUT_M_STATE =>     -- STEP 2

          -- Control Outputs
          D_OUT_M_ENABLE <= '0';

          -- FSM Control
          if ((unsigned(index_l_d_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            controller_d_out_fsm_int <= OUTPUT_D_OUT_L_STATE;
          elsif (unsigned(index_m_d_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_d_out_fsm_int <= OUTPUT_D_OUT_I_STATE;
          else
            controller_d_out_fsm_int <= OUTPUT_D_OUT_M_STATE;
          end if;

        when OUTPUT_D_OUT_L_STATE =>    -- STEP 3

          if ((unsigned(index_l_d_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_d_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            D_OUT <= tensor_d_out_int(to_integer(unsigned(index_l_d_out_loop)), to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_m_d_out_loop)));

            -- Control Outputs
            READY <= '1';

            D_OUT_L_ENABLE <= '1';
            D_OUT_I_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_l_d_out_loop <= ZERO_CONTROL;
            index_i_d_out_loop <= ZERO_CONTROL;
            index_m_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= STARTER_D_OUT_STATE;
          elsif ((unsigned(index_l_d_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_i_d_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            D_OUT <= tensor_d_out_int(to_integer(unsigned(index_l_d_out_loop)), to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_m_d_out_loop)));

            -- Control Outputs
            D_OUT_L_ENABLE <= '1';
            D_OUT_I_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_l_d_out_loop <= std_logic_vector(unsigned(index_l_d_out_loop) + unsigned(ONE_CONTROL));
            index_i_d_out_loop <= ZERO_CONTROL;
            index_m_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_L_STATE;
          end if;

        when OUTPUT_D_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_d_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            D_OUT <= tensor_d_out_int(to_integer(unsigned(index_l_d_out_loop)), to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_m_d_out_loop)));

            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_out_loop <= std_logic_vector(unsigned(index_i_d_out_loop) + unsigned(ONE_CONTROL));
            index_m_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_I_STATE;
          end if;

        when OUTPUT_D_OUT_M_STATE =>    -- STEP 4

          if (unsigned(index_m_d_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            D_OUT <= tensor_d_out_int(to_integer(unsigned(index_l_d_out_loop)), to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_m_d_out_loop)));

            -- Control Outputs
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_d_out_loop <= std_logic_vector(unsigned(index_m_d_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_M_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_out_fsm_int <= STARTER_D_OUT_STATE;
      end case;
    end if;
  end process;

  -- dU(l;m) = summation(do(t+1;l) · h(t;m))[t in 0 to T-1]
  u_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      U_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      U_OUT_L_ENABLE <= '0';
      U_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_l_u_out_loop <= ZERO_CONTROL;
      index_p_u_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_u_out_fsm_int is
        when STARTER_U_OUT_STATE =>     -- STEP 0
          if (data_h_in_enable_int = '1' and data_a_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_u_out_loop <= ZERO_CONTROL;
            index_p_u_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_u_out_fsm_int <= CLEAN_U_OUT_L_STATE;
          end if;

        when CLEAN_U_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          U_OUT_L_ENABLE <= '0';
          U_OUT_P_ENABLE <= '0';

          -- FSM Control
          controller_u_out_fsm_int <= OUTPUT_U_OUT_P_STATE;

        when CLEAN_U_OUT_P_STATE =>     -- STEP 2

          -- Control Outputs
          U_OUT_P_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_p_u_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
            controller_u_out_fsm_int <= OUTPUT_U_OUT_L_STATE;
          else
            controller_u_out_fsm_int <= OUTPUT_U_OUT_P_STATE;
          end if;

        when OUTPUT_U_OUT_L_STATE =>    -- STEP 3

          if ((unsigned(index_l_u_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            U_OUT <= matrix_u_out_int(to_integer(unsigned(index_l_u_out_loop)), to_integer(unsigned(index_p_u_out_loop)));

            -- Control Outputs
            READY <= '1';

            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_out_loop <= ZERO_CONTROL;
            index_p_u_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_u_out_fsm_int <= STARTER_U_OUT_STATE;
          elsif ((unsigned(index_l_u_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            U_OUT <= matrix_u_out_int(to_integer(unsigned(index_l_u_out_loop)), to_integer(unsigned(index_p_u_out_loop)));

            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_out_loop <= std_logic_vector(unsigned(index_l_u_out_loop) + unsigned(ONE_CONTROL));
            index_p_u_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_u_out_fsm_int <= CLEAN_U_OUT_L_STATE;
          end if;

        when OUTPUT_U_OUT_P_STATE =>    -- STEP 4

          if (unsigned(index_p_u_out_loop) < unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
          elsif ((unsigned(index_l_u_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            U_OUT <= matrix_u_out_int(to_integer(unsigned(index_l_u_out_loop)), to_integer(unsigned(index_p_u_out_loop)));

            -- Control Outputs
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_u_out_loop <= std_logic_vector(unsigned(index_p_u_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_u_out_fsm_int <= CLEAN_U_OUT_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_u_out_fsm_int <= STARTER_U_OUT_STATE;
      end case;
    end if;
  end process;

  -- dV(l;s) = summation(do(t;l) · xi(t;s))[t in 0 to T]
  v_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      V_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      V_OUT_L_ENABLE <= '0';
      V_OUT_S_ENABLE <= '0';

      -- Control Internal
      index_l_v_out_loop <= ZERO_CONTROL;
      index_s_v_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_v_out_fsm_int is
        when STARTER_V_OUT_STATE =>     -- STEP 0
          if (data_xi_in_enable_int = '1' and data_h_in_enable_int = '1' and data_a_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_v_out_loop <= ZERO_CONTROL;
            index_s_v_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_out_fsm_int <= CLEAN_V_OUT_L_STATE;
          end if;

        when CLEAN_V_OUT_L_STATE =>     -- STEP 1

          -- Control Outputs
          V_OUT_L_ENABLE <= '0';
          V_OUT_S_ENABLE <= '0';

          -- FSM Control
          controller_v_out_fsm_int <= OUTPUT_V_OUT_S_STATE;

        when CLEAN_V_OUT_S_STATE =>     -- STEP 2

          -- Control Outputs
          V_OUT_S_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_s_v_out_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            controller_v_out_fsm_int <= OUTPUT_V_OUT_L_STATE;
          else
            controller_v_out_fsm_int <= OUTPUT_V_OUT_S_STATE;
          end if;

        when OUTPUT_V_OUT_L_STATE =>    -- STEP 3

          if ((unsigned(index_l_v_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_out_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            V_OUT <= matrix_v_out_int(to_integer(unsigned(index_l_v_out_loop)), to_integer(unsigned(index_s_v_out_loop)));

            -- Control Outputs
            READY <= '1';

            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_out_loop <= ZERO_CONTROL;
            index_s_v_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_out_fsm_int <= STARTER_V_OUT_STATE;
          elsif ((unsigned(index_l_v_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_out_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            V_OUT <= matrix_v_out_int(to_integer(unsigned(index_l_v_out_loop)), to_integer(unsigned(index_s_v_out_loop)));

            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_out_loop <= std_logic_vector(unsigned(index_l_v_out_loop) + unsigned(ONE_CONTROL));
            index_s_v_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_out_fsm_int <= CLEAN_V_OUT_L_STATE;
          end if;

        when OUTPUT_V_OUT_S_STATE =>    -- STEP 4

          if (unsigned(index_s_v_out_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            V_OUT <= matrix_v_out_int(to_integer(unsigned(index_l_v_out_loop)), to_integer(unsigned(index_s_v_out_loop)));

            -- Control Outputs
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_s_v_out_loop <= std_logic_vector(unsigned(index_s_v_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_v_out_fsm_int <= CLEAN_V_OUT_S_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_v_out_fsm_int <= STARTER_V_OUT_STATE;
      end case;
    end if;
  end process;

  -- db(l) = summation(do(t;l))[t in 0 to T]
  b_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      B_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      B_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_l_b_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_b_out_fsm_int is
        when STARTER_B_OUT_STATE =>     -- STEP 0
          if (data_h_in_enable_int = '1' and data_a_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_L_STATE;
          end if;

        when CLEAN_B_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          B_OUT_L_ENABLE <= '0';

          -- FSM Control
          controller_b_out_fsm_int <= OUTPUT_B_OUT_L_STATE;

        when OUTPUT_B_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_b_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            B_OUT <= vector_b_out_int(to_integer(unsigned(index_l_b_out_loop)));

            -- Control Outputs
            READY <= '1';

            B_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
          elsif (unsigned(index_l_b_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            B_OUT <= vector_b_out_int(to_integer(unsigned(index_l_b_out_loop)));

            -- Control Outputs
            B_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_b_out_loop <= std_logic_vector(unsigned(index_l_b_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
      end case;
    end if;
  end process;

  -- SCALAR ADDER
  scalar_float_adder : accelerator_scalar_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_adder,
      READY => ready_scalar_float_adder,

      OPERATION => operation_scalar_float_adder,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_adder,
      DATA_B_IN => data_b_in_scalar_float_adder,

      DATA_OUT     => data_out_scalar_float_adder,
      OVERFLOW_OUT => overflow_out_scalar_float_adder
      );

  -- VECTOR SUMMATION
  vector_summation : accelerator_vector_summation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      DATA_IN_LENGTH_ENABLE => data_in_length_enable_vector_summation,
      DATA_IN_ENABLE        => data_in_enable_vector_summation,

      DATA_LENGTH_ENABLE => data_enable_length_vector_summation,
      DATA_ENABLE        => data_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

  -- SCALAR MULTIPLIER
  scalar_float_multiplier : accelerator_scalar_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_multiplier,
      READY => ready_scalar_float_multiplier,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_multiplier,
      DATA_B_IN => data_b_in_scalar_float_multiplier,

      DATA_OUT     => data_out_scalar_float_multiplier,
      OVERFLOW_OUT => overflow_out_scalar_float_multiplier
      );

  -- VECTOR DIFFERENTIATION
  vector_differentiation : accelerator_vector_differentiation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_differentiation,
      READY => ready_vector_differentiation,

      DATA_IN_ENABLE => data_in_enable_vector_differentiation,

      DATA_OUT_ENABLE => data_out_enable_vector_differentiation,

      -- DATA
      SIZE_IN   => size_in_vector_differentiation,
      LENGTH_IN => length_in_vector_differentiation,
      DATA_IN   => data_in_vector_differentiation,
      DATA_OUT  => data_out_vector_differentiation
      );

end architecture;
