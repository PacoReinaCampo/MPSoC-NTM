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

use work.accelerator_arithmetic_vhdl_pkg.all;
use work.accelerator_math_vhdl_pkg.all;
use work.accelerator_lstm_controller_vhdl_pkg.all;

entity accelerator_activation_gate_vector is
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

    W_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    W_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    D_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    D_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    D_IN_M_ENABLE : in std_logic;       -- for m in 0 to M-1

    D_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    D_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    D_OUT_M_ENABLE : out std_logic;     -- for m in 0 to M-1

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    V_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    V_IN_S_ENABLE : in std_logic;       -- for s in 0 to S-1

    V_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    V_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    RHO_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
    RHO_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

    RHO_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
    RHO_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

    XI_IN_ENABLE : in std_logic;        -- for s in 0 to S-1

    XI_OUT_ENABLE : out std_logic;      -- for s in 0 to S-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    A_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_activation_gate_vector_architecture of accelerator_activation_gate_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X],   X_IN   [X]
  -- K_IN [R,L,W], R_IN   [R,W]
  -- D_IN [R,L,M], RHO_IN [R,M]
  -- V_IN [L,S],   XI_IN  [S]
  -- U_IN [L,L],   H_IN   [L]
  -- B_IN [L]

  -- Outputs:
  -- A_OUT [L]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE
  -- INPUT_X_STATE, CLEAN_IN_X_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_L_STATE,                 -- STEP 1
    INPUT_W_IN_X_STATE,                 -- STEP 2
    CLEAN_W_IN_L_STATE,                 -- STEP 3
    CLEAN_W_IN_X_STATE                  -- STEP 4
    );

  type controller_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_L_STATE,                 -- STEP 2
    INPUT_K_IN_K_STATE,                 -- STEP 3
    CLEAN_K_IN_I_STATE,                 -- STEP 4
    CLEAN_K_IN_L_STATE,                 -- STEP 5
    CLEAN_K_IN_K_STATE                  -- STEP 6
    );

  type controller_u_in_fsm is (
    STARTER_U_IN_STATE,                 -- STEP 0
    INPUT_U_IN_L_STATE,                 -- STEP 1
    INPUT_U_IN_P_STATE,                 -- STEP 2
    CLEAN_U_IN_L_STATE,                 -- STEP 3
    CLEAN_U_IN_P_STATE                  -- STEP 4
    );

  type controller_v_in_fsm is (
    STARTER_V_IN_STATE,                 -- STEP 0
    INPUT_V_IN_L_STATE,                 -- STEP 1
    INPUT_V_IN_S_STATE,                 -- STEP 2
    CLEAN_V_IN_L_STATE,                 -- STEP 3
    CLEAN_V_IN_S_STATE                  -- STEP 4
    );

  type controller_d_in_fsm is (
    STARTER_D_IN_STATE,                 -- STEP 0
    INPUT_D_IN_I_STATE,                 -- STEP 1
    INPUT_D_IN_L_STATE,                 -- STEP 2
    INPUT_D_IN_M_STATE,                 -- STEP 3
    CLEAN_D_IN_I_STATE,                 -- STEP 4
    CLEAN_D_IN_L_STATE,                 -- STEP 5
    CLEAN_D_IN_M_STATE                  -- STEP 6
    );

  type controller_b_in_fsm is (
    STARTER_B_IN_STATE,                 -- STEP 0
    INPUT_B_IN_L_STATE,                 -- STEP 1
    CLEAN_B_IN_L_STATE                  -- STEP 2
    );

  type controller_x_in_fsm is (
    STARTER_X_IN_STATE,                 -- STEP 0
    INPUT_X_IN_X_STATE,                 -- STEP 1
    CLEAN_X_IN_X_STATE                  -- STEP 2
    );

  type controller_r_in_fsm is (
    STARTER_R_IN_STATE,                 -- STEP 0
    INPUT_R_IN_I_STATE,                 -- STEP 1
    INPUT_R_IN_K_STATE,                 -- STEP 2
    CLEAN_R_IN_I_STATE,                 -- STEP 3
    CLEAN_R_IN_K_STATE                  -- STEP 4
    );

  type controller_rho_in_fsm is (
    STARTER_RHO_IN_STATE,               -- STEP 0
    INPUT_RHO_IN_I_STATE,               -- STEP 1
    INPUT_RHO_IN_M_STATE,               -- STEP 2
    CLEAN_RHO_IN_I_STATE,               -- STEP 3
    CLEAN_RHO_IN_M_STATE                -- STEP 4
    );

  type controller_xi_in_fsm is (
    STARTER_XI_IN_STATE,                -- STEP 0
    INPUT_XI_IN_S_STATE,                -- STEP 1
    CLEAN_XI_IN_S_STATE                 -- STEP 2
    );

  type controller_h_in_fsm is (
    STARTER_H_IN_STATE,                 -- STEP 0
    CLEAN_H_IN_L_STATE,                 -- STEP 1
    INPUT_H_IN_L_STATE                  -- STEP 2
    );

  -- Ops

  -- K(i;l;k)*r(t;i;k)
  type controller_first_tensor_matrix_convolution_fsm is (
    STARTER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE,   -- STEP 0
    ENABLER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE,   -- STEP 1
    OPERATION_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE  -- STEP 2
    );

  type controller_first_vector_summation_fsm is (
    STARTER_FIRST_VECTOR_SUMMATION_STATE,   -- STEP 0
    ENABLER_FIRST_VECTOR_SUMMATION_STATE,   -- STEP 1
    OPERATION_FIRST_VECTOR_SUMMATION_STATE  -- STEP 2
    );

  -- W(l;x)*x(t;x)
  type controller_first_matrix_vector_convolution_fsm is (
    STARTER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE,   -- STEP 0
    ENABLER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE,   -- STEP 1
    OPERATION_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE  -- STEP 2
    );

  type controller_first_vector_float_adder_fsm is (
    STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    ENABLER_FIRST_VECTOR_FLOAT_ADDER_STATE,   -- STEP 1
    OPERATION_FIRST_VECTOR_FLOAT_ADDER_STATE  -- STEP 2
    );

  -- V(l;s)*xi(t;s)
  type controller_second_matrix_vector_convolution_fsm is (
    STARTER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE,   -- STEP 0
    ENABLER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE,   -- STEP 1
    OPERATION_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE  -- STEP 2
    );

  type controller_second_vector_float_adder_fsm is (
    STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    ENABLER_SECOND_VECTOR_FLOAT_ADDER_STATE,   -- STEP 1
    OPERATION_SECOND_VECTOR_FLOAT_ADDER_STATE  -- STEP 2
    );

  -- D(i;l;m)*rho(t;i;m)
  type controller_second_tensor_matrix_convolution_fsm is (
    STARTER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE,   -- STEP 0
    ENABLER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE,   -- STEP 1
    OPERATION_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE  -- STEP 2
    );

  type controller_second_vector_summation_fsm is (
    STARTER_SECOND_VECTOR_SUMMATION_STATE,   -- STEP 0
    ENABLER_SECOND_VECTOR_SUMMATION_STATE,   -- STEP 1
    OPERATION_SECOND_VECTOR_SUMMATION_STATE  -- STEP 2
    );

  -- b(l)
  type controller_third_vector_float_adder_fsm is (
    STARTER_THIRD_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    ENABLER_THIRD_VECTOR_FLOAT_ADDER_STATE,   -- STEP 1
    OPERATION_THIRD_VECTOR_FLOAT_ADDER_STATE  -- STEP 2
    );

  type controller_fourth_vector_float_adder_fsm is (
    STARTER_FOURTH_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    ENABLER_FOURTH_VECTOR_FLOAT_ADDER_STATE,   -- STEP 1
    OPERATION_FOURTH_VECTOR_FLOAT_ADDER_STATE  -- STEP 2
    );

  -- U(l;l)*h(t-1;l)
  type controller_third_matrix_vector_convolution_fsm is (
    STARTER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE,   -- STEP 0
    ENABLER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE,   -- STEP 1
    OPERATION_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE  -- STEP 2
    );

  type controller_fiveth_vector_float_adder_fsm is (
    STARTER_FIVETH_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    ENABLER_FIVETH_VECTOR_FLOAT_ADDER_STATE,   -- STEP 1
    OPERATION_FIVETH_VECTOR_FLOAT_ADDER_STATE  -- STEP 2
    );

  -- tanh(a(t;l))
  type controller_vector_tanh_fsm is (
    STARTER_VECTOR_TANH_STATE,          -- STEP 0
    ENABLER_VECTOR_TANH_STATE,          -- STEP 1
    OPERATION_VECTOR_TANH_STATE         -- STEP 2
    );

  -- Output
  type controller_h_out_fsm is (
    STARTER_H_OUT_STATE,                -- STEP 0
    CLEAN_H_OUT_L_STATE,                -- STEP 1
    OUTPUT_H_OUT_L_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_k_in_fsm_int : controller_k_in_fsm;
  signal controller_u_in_fsm_int : controller_u_in_fsm;
  signal controller_v_in_fsm_int : controller_v_in_fsm;
  signal controller_d_in_fsm_int : controller_d_in_fsm;
  signal controller_b_in_fsm_int : controller_b_in_fsm;

  signal controller_x_in_fsm_int   : controller_x_in_fsm;
  signal controller_r_in_fsm_int   : controller_r_in_fsm;
  signal controller_xi_in_fsm_int  : controller_xi_in_fsm;
  signal controller_rho_in_fsm_int : controller_rho_in_fsm;
  signal controller_h_in_fsm_int   : controller_h_in_fsm;

  -- Ops
  signal controller_first_tensor_matrix_convolution_fsm_int  : controller_first_tensor_matrix_convolution_fsm;
  signal controller_second_tensor_matrix_convolution_fsm_int : controller_second_tensor_matrix_convolution_fsm;
  signal controller_first_matrix_vector_convolution_fsm_int  : controller_first_matrix_vector_convolution_fsm;
  signal controller_second_matrix_vector_convolution_fsm_int : controller_second_matrix_vector_convolution_fsm;
  signal controller_third_matrix_vector_convolution_fsm_int  : controller_third_matrix_vector_convolution_fsm;
  signal controller_first_vector_summation_fsm_int           : controller_first_vector_summation_fsm;
  signal controller_second_vector_summation_fsm_int          : controller_second_vector_summation_fsm;
  signal controller_first_vector_float_adder_fsm_int         : controller_first_vector_float_adder_fsm;
  signal controller_second_vector_float_adder_fsm_int        : controller_second_vector_float_adder_fsm;
  signal controller_third_vector_float_adder_fsm_int         : controller_third_vector_float_adder_fsm;
  signal controller_fourth_vector_float_adder_fsm_int        : controller_fourth_vector_float_adder_fsm;
  signal controller_fiveth_vector_float_adder_fsm_int        : controller_fiveth_vector_float_adder_fsm;
  signal controller_vector_tanh_fsm_int                      : controller_vector_tanh_fsm;

  -- Output
  signal controller_h_out_fsm_int : controller_h_out_fsm;

  -- Buffer
  -- Input
  signal matrix_w_in_int : matrix_buffer;
  signal tensor_k_in_int : tensor_buffer;
  signal matrix_u_in_int : matrix_buffer;
  signal matrix_v_in_int : matrix_buffer;
  signal tensor_d_in_int : tensor_buffer;
  signal vector_b_in_int : vector_buffer;

  signal vector_x_in_int   : vector_buffer;
  signal matrix_r_in_int   : matrix_buffer;
  signal vector_xi_in_int  : vector_buffer;
  signal matrix_rho_in_int : matrix_buffer;
  signal vector_h_in_int   : vector_buffer;

  -- Ops
  signal matrix_one_operation_int : matrix_buffer;
  signal matrix_two_operation_int : matrix_buffer;

  signal vector_one_operation_int    : vector_buffer;
  signal vector_two_operation_int    : vector_buffer;
  signal vector_three_operation_int  : vector_buffer;
  signal vector_four_operation_int   : vector_buffer;
  signal vector_five_operation_int   : vector_buffer;
  signal vector_six_operation_int    : vector_buffer;
  signal vector_seven_operation_int  : vector_buffer;
  signal vector_eight_operation_int  : vector_buffer;
  signal vector_nine_operation_int   : vector_buffer;
  signal vector_ten_operation_int    : vector_buffer;
  signal vector_eleven_operation_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_l_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_v_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_s_v_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_x_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_s_xi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_first_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_first_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_first_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_out_first_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_out_first_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_second_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_second_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_second_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_out_second_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_out_second_tensor_matrix_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_first_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_first_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_out_first_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_second_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_second_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_out_second_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_third_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_third_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_out_third_matrix_vector_convolution_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_length_first_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_first_vector_summation_loop        : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_out_length_first_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_length_second_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_second_vector_summation_loop        : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_out_length_second_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_first_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_second_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_third_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_fourth_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_fiveth_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_tanh_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_l_h_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_w_in_enable_int : std_logic;
  signal data_k_in_enable_int : std_logic;
  signal data_u_in_enable_int : std_logic;
  signal data_v_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;

  signal data_x_in_enable_int   : std_logic;
  signal data_r_in_enable_int   : std_logic;
  signal data_xi_in_enable_int  : std_logic;
  signal data_rho_in_enable_int : std_logic;
  signal data_h_in_enable_int   : std_logic;

  -- Ops
  signal data_first_tensor_matrix_convolution_enable_int  : std_logic;
  signal data_second_tensor_matrix_convolution_enable_int : std_logic;
  signal data_first_matrix_vector_convolution_enable_int  : std_logic;
  signal data_second_matrix_vector_convolution_enable_int : std_logic;
  signal data_third_matrix_vector_convolution_enable_int  : std_logic;
  signal data_first_vector_summation_enable_int           : std_logic;
  signal data_second_vector_summation_enable_int          : std_logic;
  signal data_first_vector_float_adder_enable_int         : std_logic;
  signal data_second_vector_float_adder_enable_int        : std_logic;
  signal data_third_vector_float_adder_enable_int         : std_logic;
  signal data_fourth_vector_float_adder_enable_int        : std_logic;
  signal data_fiveth_vector_float_adder_enable_int        : std_logic;
  signal data_vector_tanh_enable_int                      : std_logic;

  -- VECTOR ADDER
  -- CONTROL
  signal start_first_vector_float_adder : std_logic;
  signal ready_first_vector_float_adder : std_logic;

  signal operation_first_vector_float_adder : std_logic;

  signal data_a_in_enable_first_vector_float_adder : std_logic;
  signal data_b_in_enable_first_vector_float_adder : std_logic;

  signal data_out_enable_first_vector_float_adder : std_logic;

  -- DATA
  signal size_in_first_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_first_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_first_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_first_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_second_vector_float_adder : std_logic;
  signal ready_second_vector_float_adder : std_logic;

  signal operation_second_vector_float_adder : std_logic;

  signal data_a_in_enable_second_vector_float_adder : std_logic;
  signal data_b_in_enable_second_vector_float_adder : std_logic;

  signal data_out_enable_second_vector_float_adder : std_logic;

  -- DATA
  signal size_in_second_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_second_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_second_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_second_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_third_vector_float_adder : std_logic;
  signal ready_third_vector_float_adder : std_logic;

  signal operation_third_vector_float_adder : std_logic;

  signal data_a_in_enable_third_vector_float_adder : std_logic;
  signal data_b_in_enable_third_vector_float_adder : std_logic;

  signal data_out_enable_third_vector_float_adder : std_logic;

  -- DATA
  signal size_in_third_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_third_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_third_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_third_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_fourth_vector_float_adder : std_logic;
  signal ready_fourth_vector_float_adder : std_logic;

  signal operation_fourth_vector_float_adder : std_logic;

  signal data_a_in_enable_fourth_vector_float_adder : std_logic;
  signal data_b_in_enable_fourth_vector_float_adder : std_logic;

  signal data_out_enable_fourth_vector_float_adder : std_logic;

  -- DATA
  signal size_in_fourth_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_fourth_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_fourth_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_fourth_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_fiveth_vector_float_adder : std_logic;
  signal ready_fiveth_vector_float_adder : std_logic;

  signal operation_fiveth_vector_float_adder : std_logic;

  signal data_a_in_enable_fiveth_vector_float_adder : std_logic;
  signal data_b_in_enable_fiveth_vector_float_adder : std_logic;

  signal data_out_enable_fiveth_vector_float_adder : std_logic;

  -- DATA
  signal size_in_fiveth_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_fiveth_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_fiveth_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_fiveth_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_first_vector_summation : std_logic;
  signal ready_first_vector_summation : std_logic;

  signal data_in_enable_first_vector_summation        : std_logic;
  signal data_in_length_enable_first_vector_summation : std_logic;

  signal data_enable_first_vector_summation        : std_logic;
  signal data_length_enable_first_vector_summation : std_logic;

  signal data_out_enable_first_vector_summation : std_logic;

  -- DATA
  signal size_in_first_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_first_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_first_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_first_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_second_vector_summation : std_logic;
  signal ready_second_vector_summation : std_logic;

  signal data_in_enable_second_vector_summation        : std_logic;
  signal data_in_length_enable_second_vector_summation : std_logic;

  signal data_enable_second_vector_summation        : std_logic;
  signal data_length_enable_second_vector_summation : std_logic;

  signal data_out_enable_second_vector_summation : std_logic;

  -- DATA
  signal size_in_second_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_second_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_second_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_second_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR MATRIX CONVOLUTION
  -- CONTROL
  signal start_first_tensor_matrix_convolution : std_logic;
  signal ready_first_tensor_matrix_convolution : std_logic;

  signal data_a_in_i_enable_first_tensor_matrix_convolution : std_logic;
  signal data_a_in_j_enable_first_tensor_matrix_convolution : std_logic;
  signal data_a_in_k_enable_first_tensor_matrix_convolution : std_logic;
  signal data_b_in_i_enable_first_tensor_matrix_convolution : std_logic;
  signal data_b_in_j_enable_first_tensor_matrix_convolution : std_logic;

  signal data_i_enable_first_tensor_matrix_convolution : std_logic;
  signal data_j_enable_first_tensor_matrix_convolution : std_logic;
  signal data_k_enable_first_tensor_matrix_convolution : std_logic;

  signal data_out_i_enable_first_tensor_matrix_convolution : std_logic;
  signal data_out_j_enable_first_tensor_matrix_convolution : std_logic;

  -- DATA
  signal size_a_i_in_first_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_first_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_first_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_first_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_first_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_first_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_first_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_first_tensor_matrix_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_second_tensor_matrix_convolution : std_logic;
  signal ready_second_tensor_matrix_convolution : std_logic;

  signal data_a_in_i_enable_second_tensor_matrix_convolution : std_logic;
  signal data_a_in_j_enable_second_tensor_matrix_convolution : std_logic;
  signal data_a_in_k_enable_second_tensor_matrix_convolution : std_logic;
  signal data_b_in_i_enable_second_tensor_matrix_convolution : std_logic;
  signal data_b_in_j_enable_second_tensor_matrix_convolution : std_logic;

  signal data_i_enable_second_tensor_matrix_convolution : std_logic;
  signal data_j_enable_second_tensor_matrix_convolution : std_logic;
  signal data_k_enable_second_tensor_matrix_convolution : std_logic;

  signal data_out_i_enable_second_tensor_matrix_convolution : std_logic;
  signal data_out_j_enable_second_tensor_matrix_convolution : std_logic;

  -- DATA
  signal size_a_i_in_second_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_second_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_second_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_second_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_second_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_second_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_second_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_second_tensor_matrix_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX VECTOR CONVOLUTION
  -- CONTROL
  signal start_first_matrix_vector_convolution : std_logic;
  signal ready_first_matrix_vector_convolution : std_logic;

  signal data_a_in_i_enable_first_matrix_vector_convolution : std_logic;
  signal data_a_in_j_enable_first_matrix_vector_convolution : std_logic;
  signal data_b_in_enable_first_matrix_vector_convolution   : std_logic;

  signal data_i_enable_first_matrix_vector_convolution : std_logic;
  signal data_j_enable_first_matrix_vector_convolution : std_logic;

  signal data_out_enable_first_matrix_vector_convolution : std_logic;

  -- DATA
  signal size_a_i_in_first_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_first_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_first_matrix_vector_convolution   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_first_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_first_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_first_matrix_vector_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_second_matrix_vector_convolution : std_logic;
  signal ready_second_matrix_vector_convolution : std_logic;

  signal data_a_in_i_enable_second_matrix_vector_convolution : std_logic;
  signal data_a_in_j_enable_second_matrix_vector_convolution : std_logic;
  signal data_b_in_enable_second_matrix_vector_convolution   : std_logic;

  signal data_i_enable_second_matrix_vector_convolution : std_logic;
  signal data_j_enable_second_matrix_vector_convolution : std_logic;

  signal data_out_enable_second_matrix_vector_convolution : std_logic;

  -- DATA
  signal size_a_i_in_second_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_second_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_second_matrix_vector_convolution   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_second_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_second_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_second_matrix_vector_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- CONTROL
  signal start_third_matrix_vector_convolution : std_logic;
  signal ready_third_matrix_vector_convolution : std_logic;

  signal data_a_in_i_enable_third_matrix_vector_convolution : std_logic;
  signal data_a_in_j_enable_third_matrix_vector_convolution : std_logic;
  signal data_b_in_enable_third_matrix_vector_convolution   : std_logic;

  signal data_i_enable_third_matrix_vector_convolution : std_logic;
  signal data_j_enable_third_matrix_vector_convolution : std_logic;

  signal data_out_enable_third_matrix_vector_convolution : std_logic;

  -- DATA
  signal size_a_i_in_third_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_third_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_third_matrix_vector_convolution   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_third_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_third_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_third_matrix_vector_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal size_in_vector_tanh  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- a(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

  -- K(i;l;k)*r(t;i;k)
  --   matrix_one_operation_int = first_tensor_matrix_convolution_fsm(K, r) [data_k_in_enable_int, data_r_in_enable_int]
  --   vector_one_operation_int = first_vector_summation_fsm(matrix_one_operation_int) [data_first_tensor_matrix_convolution_enable_int]

  -- W(l;x)*x(t;x)
  --   vector_two_operation_int = first_matrix_vector_convolution_fsm(W, x) [data_w_in_enable_int, data_x_in_enable_int]
  --   vector_three_operation_int = first_vector_float_adder_fsm(vector_one_operation_int, vector_two_operation_int) [data_first_vector_summation_enable_int, data_first_matrix_vector_convolution_enable_int]

  -- V(l;s)*xi(t;s)
  --   vector_four_operation_int = second_matrix_vector_convolution_fsm(V, xi) [data_v_in_enable_int, data_xi_in_enable_int]
  --   vector_five_operation_int = second_vector_float_adder_fsm(vector_three_operation_int, vector_four_operation_int) [data_first_vector_float_adder_enable_int, data_second_matrix_vector_convolution_enable_int]

  -- D(i;l;m)*rho(t;i;m)
  --   matrix_two_operation_int = second_tensor_matrix_convolution_fsm(D, rho) [data_d_in_enable_int, data_rho_in_enable_int]
  --   vector_six_operation_int = second_vector_summation_fsm(matrix_two_operation_int) [data_second_tensor_matrix_convolution_enable_int]

  -- b(l)
  --   vector_seven_operation_int = third_vector_float_adder_fsm(vector_five_operation_int, vector_six_operation_int) [data_second_vector_float_adder_enable_int, data_second_vector_summation_enable_int]
  --   vector_eight_operation_int = fourth_vector_float_adder_fsm(b, vector_seven_operation_int) [data_b_in_enable_int, data_third_vector_float_adder_enable_int]

  -- U(l;l)*h(t-1;l)
  --   vector_nine_operation_int = third_matrix_vector_convolution_fsm(U, h) [data_u_in_enable_int, data_h_in_enable_int]
  --   vector_ten_operation_int = fiveth_vector_float_adder_fsm(vector_eight_operation_int, vector_nine_operation_int) [data_third_matrix_vector_convolution_enable_int, data_fourth_vector_float_adder_enable_int]

  -- tanh(a(t;l))
  --   vector_eleven_operation_int = vector_tanh_fsm(vector_ten_operation_int) [data_fiveth_vector_float_adder_enable_int]

  -- INPUT CONTROL
  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_L_ENABLE <= '0';
      W_OUT_X_ENABLE <= '0';

      -- Control Internal
      index_l_w_in_loop <= ZERO_CONTROL;
      index_x_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= ZERO_CONTROL;
            index_x_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_L_STATE;
          else
            -- Control Outputs
            W_OUT_L_ENABLE <= '0';
            W_OUT_X_ENABLE <= '0';
          end if;

        when INPUT_W_IN_L_STATE =>      -- STEP 1

          if ((W_IN_L_ENABLE = '1') and (W_IN_X_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_l_w_in_loop)), to_integer(unsigned(index_x_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
          end if;

          -- Control Outputs
          W_OUT_L_ENABLE <= '0';
          W_OUT_X_ENABLE <= '0';

        when INPUT_W_IN_X_STATE =>      -- STEP 2

          if (W_IN_X_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_l_w_in_loop)), to_integer(unsigned(index_x_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';

        when CLEAN_W_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= ZERO_CONTROL;
            index_x_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_l_w_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= std_logic_vector(unsigned(index_l_w_in_loop) + unsigned(ONE_CONTROL));
            index_x_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_L_STATE;
          end if;

        when CLEAN_W_IN_X_STATE =>      -- STEP 4

          if (unsigned(index_x_w_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= std_logic_vector(unsigned(index_x_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_in_fsm_int <= STARTER_W_IN_STATE;
      end case;
    end if;
  end process;

  k_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      K_OUT_I_ENABLE <= '0';
      K_OUT_L_ENABLE <= '0';
      K_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_k_in_loop <= ZERO_CONTROL;
      index_l_k_in_loop <= ZERO_CONTROL;
      index_k_k_in_loop <= ZERO_CONTROL;

      data_k_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_in_fsm_int is
        when STARTER_K_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_l_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '0';

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          else
            -- Control Outputs
            K_OUT_I_ENABLE <= '0';
            K_OUT_L_ENABLE <= '0';
            K_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_K_IN_I_STATE =>      -- STEP 1

          if ((K_IN_I_ENABLE = '1') and (K_IN_L_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_l_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            controller_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
          end if;

          -- Control Outputs
          K_OUT_I_ENABLE <= '0';
          K_OUT_L_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

        when INPUT_K_IN_L_STATE =>      -- STEP 2

          if ((K_IN_L_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_l_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            if (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          K_OUT_L_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

        when INPUT_K_IN_K_STATE =>      -- STEP 3

          if (K_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_l_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            if ((unsigned(index_l_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            elsif (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          K_OUT_K_ENABLE <= '0';

        when CLEAN_K_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_k_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_l_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '1';

            -- FSM Control
            controller_k_in_fsm_int <= STARTER_K_IN_STATE;
          elsif ((unsigned(index_i_k_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= std_logic_vector(unsigned(index_i_k_in_loop) + unsigned(ONE_CONTROL));
            index_l_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          end if;

        when CLEAN_K_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_k_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_l_k_in_loop <= std_logic_vector(unsigned(index_l_k_in_loop) + unsigned(ONE_CONTROL));
            index_k_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_L_STATE;
          end if;

        when CLEAN_K_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_k_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_in_loop <= std_logic_vector(unsigned(index_k_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_in_fsm_int <= STARTER_K_IN_STATE;
      end case;
    end if;
  end process;

  u_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      U_OUT_L_ENABLE <= '0';
      U_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_l_u_in_loop <= ZERO_CONTROL;
      index_p_u_in_loop <= ZERO_CONTROL;

      data_u_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_u_in_fsm_int is
        when STARTER_U_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= ZERO_CONTROL;
            index_p_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '0';

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_L_STATE;
          else
            -- Control Outputs
            U_OUT_L_ENABLE <= '0';
            U_OUT_P_ENABLE <= '0';
          end if;

        when INPUT_U_IN_L_STATE =>      -- STEP 1

          if ((U_IN_L_ENABLE = '1') and (U_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_u_in_int(to_integer(unsigned(index_l_u_in_loop)), to_integer(unsigned(index_p_u_in_loop))) <= U_IN;

            -- FSM Control
            controller_u_in_fsm_int <= CLEAN_U_IN_P_STATE;
          end if;

          -- Control Outputs
          U_OUT_L_ENABLE <= '0';
          U_OUT_P_ENABLE <= '0';

        when INPUT_U_IN_P_STATE =>      -- STEP 2

          if (U_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_u_in_int(to_integer(unsigned(index_l_u_in_loop)), to_integer(unsigned(index_p_u_in_loop))) <= U_IN;

            -- FSM Control
            if (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_u_in_fsm_int <= CLEAN_U_IN_L_STATE;
            else
              controller_u_in_fsm_int <= CLEAN_U_IN_P_STATE;
            end if;
          end if;

          -- Control Outputs
          U_OUT_P_ENABLE <= '0';

        when CLEAN_U_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= ZERO_CONTROL;
            index_p_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '1';

            -- FSM Control
            controller_u_in_fsm_int <= STARTER_U_IN_STATE;
          elsif ((unsigned(index_l_u_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= std_logic_vector(unsigned(index_l_u_in_loop) + unsigned(ONE_CONTROL));
            index_p_u_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_L_STATE;
          end if;

        when CLEAN_U_IN_P_STATE =>      -- STEP 4

          if (unsigned(index_p_u_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_u_in_loop <= std_logic_vector(unsigned(index_p_u_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_u_in_fsm_int <= STARTER_U_IN_STATE;
      end case;
    end if;
  end process;

  v_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      V_OUT_L_ENABLE <= '0';
      V_OUT_S_ENABLE <= '0';

      -- Control Internal
      index_l_v_in_loop <= ZERO_CONTROL;
      index_s_v_in_loop <= ZERO_CONTROL;

      data_v_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_v_in_fsm_int is
        when STARTER_V_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= ZERO_CONTROL;
            index_s_v_in_loop <= ZERO_CONTROL;

            data_v_in_enable_int <= '0';

            -- FSM Control
            controller_v_in_fsm_int <= INPUT_V_IN_L_STATE;
          else
            -- Control Outputs
            V_OUT_L_ENABLE <= '0';
            V_OUT_S_ENABLE <= '0';
          end if;

        when INPUT_V_IN_L_STATE =>      -- STEP 1

          if ((V_IN_L_ENABLE = '1') and (V_IN_S_ENABLE = '1')) then
            -- Data Inputs
            matrix_v_in_int(to_integer(unsigned(index_l_v_in_loop)), to_integer(unsigned(index_s_v_in_loop))) <= V_IN;

            -- FSM Control
            controller_v_in_fsm_int <= CLEAN_V_IN_S_STATE;
          end if;

          -- Control Outputs
          V_OUT_L_ENABLE <= '0';
          V_OUT_S_ENABLE <= '0';

        when INPUT_V_IN_S_STATE =>      -- STEP 2

          if (V_IN_S_ENABLE = '1') then
            -- Data Inputs
            matrix_v_in_int(to_integer(unsigned(index_l_v_in_loop)), to_integer(unsigned(index_s_v_in_loop))) <= V_IN;

            -- FSM Control
            if (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
              controller_v_in_fsm_int <= CLEAN_V_IN_L_STATE;
            else
              controller_v_in_fsm_int <= CLEAN_V_IN_S_STATE;
            end if;
          end if;

          -- Control Outputs
          V_OUT_S_ENABLE <= '0';

        when CLEAN_V_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_v_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= ZERO_CONTROL;
            index_s_v_in_loop <= ZERO_CONTROL;

            data_v_in_enable_int <= '1';

            -- FSM Control
            controller_v_in_fsm_int <= STARTER_V_IN_STATE;
          elsif ((unsigned(index_l_v_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= std_logic_vector(unsigned(index_l_v_in_loop) + unsigned(ONE_CONTROL));
            index_s_v_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_in_fsm_int <= INPUT_V_IN_L_STATE;
          end if;

        when CLEAN_V_IN_S_STATE =>      -- STEP 4

          if (unsigned(index_s_v_in_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_s_v_in_loop <= std_logic_vector(unsigned(index_s_v_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_v_in_fsm_int <= INPUT_V_IN_S_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_v_in_fsm_int <= STARTER_V_IN_STATE;
      end case;
    end if;
  end process;

  d_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      D_OUT_I_ENABLE <= '0';
      D_OUT_L_ENABLE <= '0';
      D_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_i_d_in_loop <= ZERO_CONTROL;
      index_l_d_in_loop <= ZERO_CONTROL;
      index_m_d_in_loop <= ZERO_CONTROL;

      data_d_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_d_in_fsm_int is
        when STARTER_D_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_l_d_in_loop <= ZERO_CONTROL;
            index_m_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '0';

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          else
            -- Control Outputs
            D_OUT_I_ENABLE <= '0';
            D_OUT_L_ENABLE <= '0';
            D_OUT_M_ENABLE <= '0';
          end if;

        when INPUT_D_IN_I_STATE =>      -- STEP 1

          if ((D_IN_I_ENABLE = '1') and (D_IN_L_ENABLE = '1') and (D_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_l_d_in_loop)), to_integer(unsigned(index_m_d_in_loop))) <= D_IN;

            -- FSM Control
            controller_d_in_fsm_int <= CLEAN_D_IN_M_STATE;
          end if;

          -- Control Outputs
          D_OUT_I_ENABLE <= '0';
          D_OUT_L_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

        when INPUT_D_IN_L_STATE =>      -- STEP 2

          if ((D_IN_L_ENABLE = '1') and (D_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_l_d_in_loop)), to_integer(unsigned(index_m_d_in_loop))) <= D_IN;

            -- FSM Control
            if (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_M_STATE;
            end if;
          end if;

          -- Control Outputs
          D_OUT_L_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

        when INPUT_D_IN_M_STATE =>      -- STEP 3

          if (D_IN_M_ENABLE = '1') then
            -- Data Inputs
            tensor_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_l_d_in_loop)), to_integer(unsigned(index_m_d_in_loop))) <= D_IN;

            -- FSM Control
            if ((unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            elsif (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_M_STATE;
            end if;
          end if;

          -- Control Outputs
          D_OUT_M_ENABLE <= '0';

        when CLEAN_D_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_d_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_l_d_in_loop <= ZERO_CONTROL;
            index_m_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '1';

            -- FSM Control
            controller_d_in_fsm_int <= STARTER_D_IN_STATE;
          elsif ((unsigned(index_i_d_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= std_logic_vector(unsigned(index_i_d_in_loop) + unsigned(ONE_CONTROL));
            index_l_d_in_loop <= ZERO_CONTROL;
            index_m_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          end if;

        when CLEAN_D_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_d_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_l_d_in_loop <= std_logic_vector(unsigned(index_l_d_in_loop) + unsigned(ONE_CONTROL));
            index_m_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_L_STATE;
          end if;

        when CLEAN_D_IN_M_STATE =>      -- STEP 4

          if (unsigned(index_m_d_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_d_in_loop <= std_logic_vector(unsigned(index_m_d_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_M_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_in_fsm_int <= STARTER_D_IN_STATE;
      end case;
    end if;
  end process;

  b_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      B_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_b_in_loop <= ZERO_CONTROL;

      data_b_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_b_in_fsm_int is
        when STARTER_B_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_L_STATE;
          else
            -- Control Outputs
            B_OUT_ENABLE <= '0';
          end if;

        when INPUT_B_IN_L_STATE =>      -- STEP 1

          if (B_IN_ENABLE = '1') then
            -- Data Inputs
            vector_b_in_int(to_integer(unsigned(index_l_b_in_loop))) <= B_IN;

            -- FSM Control
            controller_b_in_fsm_int <= CLEAN_B_IN_L_STATE;
          end if;

          -- Control Outputs
          B_OUT_ENABLE <= '0';

        when CLEAN_B_IN_L_STATE =>      -- STEP 2

          if (unsigned(index_l_b_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '1';

            -- FSM Control
            controller_b_in_fsm_int <= STARTER_B_IN_STATE;
          elsif (unsigned(index_l_b_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= std_logic_vector(unsigned(index_l_b_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_in_fsm_int <= STARTER_B_IN_STATE;
      end case;
    end if;
  end process;

  x_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      X_OUT_ENABLE <= '0';

      -- Control Internal
      index_x_x_in_loop <= ZERO_CONTROL;

      data_x_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_x_in_fsm_int is
        when STARTER_X_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '0';

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          else
            -- Control Outputs
            X_OUT_ENABLE <= '0';
          end if;

        when INPUT_X_IN_X_STATE =>      -- STEP 1

          if (X_IN_ENABLE = '1') then
            -- Data Inputs
            vector_x_in_int(to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            controller_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
          end if;

          -- Control Outputs
          X_OUT_ENABLE <= '0';

        when CLEAN_X_IN_X_STATE =>      -- STEP 2

          if (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '1';

            -- FSM Control
            controller_x_in_fsm_int <= STARTER_X_IN_STATE;
          elsif (unsigned(index_x_x_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

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
      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_r_in_loop <= ZERO_CONTROL;
      index_k_r_in_loop <= ZERO_CONTROL;

      data_r_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_r_in_fsm_int is
        when STARTER_R_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '0';

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          else
            -- Control Outputs
            R_OUT_I_ENABLE <= '0';
            R_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_R_IN_I_STATE =>      -- STEP 1

          if ((R_IN_I_ENABLE = '1') and (R_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_r_in_int(to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
          end if;

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

        when INPUT_R_IN_K_STATE =>      -- STEP 2

          if (R_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_r_in_int(to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            if (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_r_in_fsm_int <= CLEAN_R_IN_I_STATE;
            else
              controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

        when CLEAN_R_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_r_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '1';

            -- FSM Control
            controller_r_in_fsm_int <= STARTER_R_IN_STATE;
          elsif ((unsigned(index_i_r_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
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
      RHO_OUT_I_ENABLE <= '0';
      RHO_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_i_rho_in_loop <= ZERO_CONTROL;
      index_m_rho_in_loop <= ZERO_CONTROL;

      data_rho_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_rho_in_fsm_int is
        when STARTER_RHO_IN_STATE =>    -- STEP 0
          if (START = '1') then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '0';

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          else
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '0';
            RHO_OUT_M_ENABLE <= '0';
          end if;

        when INPUT_RHO_IN_I_STATE =>    -- STEP 1

          if ((RHO_IN_I_ENABLE = '1') and (RHO_IN_M_ENABLE = '1')) then
            -- Data Inputs
            matrix_rho_in_int(to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            controller_rho_in_fsm_int <= CLEAN_RHO_IN_M_STATE;
          end if;

          -- Control Outputs
          RHO_OUT_I_ENABLE <= '0';
          RHO_OUT_M_ENABLE <= '0';

        when INPUT_RHO_IN_M_STATE =>    -- STEP 2

          if (RHO_IN_M_ENABLE = '1') then
            -- Data Inputs
            matrix_rho_in_int(to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            if (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_I_STATE;
            else
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_M_STATE;
            end if;
          end if;

          -- Control Outputs
          RHO_OUT_M_ENABLE <= '0';

        when CLEAN_RHO_IN_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_rho_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '1';

            -- FSM Control
            controller_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
          elsif ((unsigned(index_i_rho_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
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
      XI_OUT_ENABLE <= '0';

      -- Control Internal
      index_s_xi_in_loop <= ZERO_CONTROL;

      data_xi_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_xi_in_fsm_int is
        when STARTER_XI_IN_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Outputs
            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '0';

            -- FSM Control
            controller_xi_in_fsm_int <= INPUT_XI_IN_S_STATE;
          else
            -- Control Outputs
            XI_OUT_ENABLE <= '0';
          end if;

        when INPUT_XI_IN_S_STATE =>     -- STEP 1

          if (XI_IN_ENABLE = '1') then
            -- Data Inputs
            vector_xi_in_int(to_integer(unsigned(index_s_xi_in_loop))) <= XI_IN;

            -- FSM Control
            controller_xi_in_fsm_int <= CLEAN_XI_IN_S_STATE;
          end if;

          -- Control Outputs
          XI_OUT_ENABLE <= '0';

        when CLEAN_XI_IN_S_STATE =>     -- STEP 2

          if (unsigned(index_s_xi_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '1';

            -- FSM Control
            controller_xi_in_fsm_int <= STARTER_XI_IN_STATE;
          elsif (unsigned(index_s_xi_in_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            XI_OUT_ENABLE <= '1';

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
      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_in_loop <= ZERO_CONTROL;

      data_h_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_h_in_fsm_int is
        when STARTER_H_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '0';

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          else
            -- Control Outputs
            H_OUT_ENABLE <= '0';
          end if;

        when INPUT_H_IN_L_STATE =>      -- STEP 1

          if (H_IN_ENABLE = '1') then
            -- Data Inputs
            vector_h_in_int(to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
          end if;

          -- Control Outputs
          H_OUT_ENABLE <= '0';

        when CLEAN_H_IN_L_STATE =>      -- STEP 2

          if (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '1';

            -- FSM Control
            controller_h_in_fsm_int <= STARTER_H_IN_STATE;
          elsif (unsigned(index_l_h_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

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

  -- K(i;l;k)*r(t;i;k)
  first_tensor_matrix_convolution_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_first_tensor_matrix_convolution <= '0';

      data_a_in_i_enable_first_tensor_matrix_convolution <= '0';
      data_a_in_j_enable_first_tensor_matrix_convolution <= '0';
      data_a_in_k_enable_first_tensor_matrix_convolution <= '0';
      data_b_in_i_enable_first_tensor_matrix_convolution <= '0';
      data_b_in_j_enable_first_tensor_matrix_convolution <= '0';

      data_first_tensor_matrix_convolution_enable_int <= '0';

      index_i_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
      index_j_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
      index_k_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

      index_i_out_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
      index_j_out_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

      -- Data Internal
      size_a_i_in_first_tensor_matrix_convolution <= ZERO_CONTROL;
      size_a_j_in_first_tensor_matrix_convolution <= ZERO_CONTROL;
      size_a_k_in_first_tensor_matrix_convolution <= ZERO_CONTROL;
      size_b_i_in_first_tensor_matrix_convolution <= ZERO_CONTROL;
      size_b_j_in_first_tensor_matrix_convolution <= ZERO_CONTROL;

      data_a_in_first_tensor_matrix_convolution <= ZERO_DATA;
      data_b_in_first_tensor_matrix_convolution <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_first_tensor_matrix_convolution_fsm_int is
        when STARTER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE =>  -- STEP 0
          -- Control Internal
          start_first_tensor_matrix_convolution <= '0';

          data_a_in_i_enable_first_tensor_matrix_convolution <= '0';
          data_a_in_j_enable_first_tensor_matrix_convolution <= '0';
          data_a_in_k_enable_first_tensor_matrix_convolution <= '0';
          data_b_in_i_enable_first_tensor_matrix_convolution <= '0';
          data_b_in_j_enable_first_tensor_matrix_convolution <= '0';

          -- Data Internal
          data_a_in_first_tensor_matrix_convolution <= ZERO_DATA;
          data_b_in_first_tensor_matrix_convolution <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_first_tensor_matrix_convolution_enable_int <= '0';

            -- FSM Control
            controller_first_tensor_matrix_convolution_fsm_int <= ENABLER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE;
          end if;

        when ENABLER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE =>  -- STEP 1

          if (data_k_in_enable_int = '1' and data_r_in_enable_int = '1') then
            if (unsigned(index_i_first_tensor_matrix_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_first_tensor_matrix_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_first_tensor_matrix_convolution_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_first_tensor_matrix_convolution <= '1';

              index_i_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
              index_j_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
              index_k_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

              index_i_out_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
              index_j_out_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_a_i_in_first_tensor_matrix_convolution <= SIZE_R_IN;
              size_a_j_in_first_tensor_matrix_convolution <= SIZE_L_IN;
              size_a_k_in_first_tensor_matrix_convolution <= SIZE_W_IN;
              size_b_i_in_first_tensor_matrix_convolution <= SIZE_R_IN;
              size_b_j_in_first_tensor_matrix_convolution <= SIZE_W_IN;
            end if;

            -- FSM Control
            controller_first_tensor_matrix_convolution_fsm_int <= OPERATION_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE;
          end if;

        when OPERATION_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE =>  -- STEP 2

          if (data_i_enable_first_tensor_matrix_convolution = '1' and data_j_enable_first_tensor_matrix_convolution = '1' and data_k_enable_first_tensor_matrix_convolution = '1') then
            -- Data Inputs
            data_a_in_first_tensor_matrix_convolution <= tensor_k_in_int(to_integer(unsigned(index_i_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_k_first_tensor_matrix_convolution_loop)));
            data_b_in_first_tensor_matrix_convolution <= matrix_r_in_int(to_integer(unsigned(index_i_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_first_tensor_matrix_convolution_loop)));

            -- Control Internal
            data_a_in_i_enable_first_tensor_matrix_convolution <= '1';
            data_a_in_j_enable_first_tensor_matrix_convolution <= '1';
            data_a_in_k_enable_first_tensor_matrix_convolution <= '1';
            data_b_in_i_enable_first_tensor_matrix_convolution <= '1';
            data_b_in_j_enable_first_tensor_matrix_convolution <= '1';

            if ((unsigned(index_i_first_tensor_matrix_convolution_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_first_tensor_matrix_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_first_tensor_matrix_convolution_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              index_i_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_i_first_tensor_matrix_convolution_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_first_tensor_matrix_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_first_tensor_matrix_convolution_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              index_i_first_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_i_first_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

          elsif (data_j_enable_first_tensor_matrix_convolution = '1' and data_k_enable_first_tensor_matrix_convolution = '1') then
            -- Data Inputs
            data_a_in_first_tensor_matrix_convolution <= tensor_k_in_int(to_integer(unsigned(index_i_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_k_first_tensor_matrix_convolution_loop)));
            data_b_in_first_tensor_matrix_convolution <= matrix_r_in_int(to_integer(unsigned(index_i_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_first_tensor_matrix_convolution_loop)));

            -- Control Internal
            data_a_in_j_enable_first_tensor_matrix_convolution <= '1';
            data_a_in_k_enable_first_tensor_matrix_convolution <= '1';
            data_b_in_j_enable_first_tensor_matrix_convolution <= '1';

            if ((unsigned(index_j_first_tensor_matrix_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_first_tensor_matrix_convolution_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              index_j_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_j_first_tensor_matrix_convolution_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_first_tensor_matrix_convolution_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              index_j_first_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_j_first_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_k_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

          elsif (data_k_enable_first_tensor_matrix_convolution = '1') then
            -- Data Inputs
            data_a_in_first_tensor_matrix_convolution <= tensor_k_in_int(to_integer(unsigned(index_i_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_k_first_tensor_matrix_convolution_loop)));

            -- Control Internal
            data_a_in_k_enable_first_tensor_matrix_convolution <= '1';

            if (unsigned(index_k_first_tensor_matrix_convolution_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              index_k_first_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_k_first_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_a_in_i_enable_first_tensor_matrix_convolution <= '0';
            data_a_in_j_enable_first_tensor_matrix_convolution <= '0';
            data_a_in_k_enable_first_tensor_matrix_convolution <= '0';
            data_b_in_i_enable_first_tensor_matrix_convolution <= '0';
            data_b_in_j_enable_first_tensor_matrix_convolution <= '0';
          end if;

          if (data_out_i_enable_first_tensor_matrix_convolution = '1' and data_out_j_enable_first_tensor_matrix_convolution = '1') then
            -- Data Internal
            matrix_one_operation_int(to_integer(unsigned(index_i_out_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_out_first_tensor_matrix_convolution_loop))) <= data_out_first_tensor_matrix_convolution;

            -- Control Internal
            if (unsigned(index_i_out_first_tensor_matrix_convolution_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              index_i_out_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;
            else
              index_i_out_first_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_i_out_first_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_out_first_tensor_matrix_convolution_loop <= ZERO_CONTROL;

          elsif (data_out_j_enable_first_tensor_matrix_convolution = '1') then
            -- Data Internal
            matrix_one_operation_int(to_integer(unsigned(index_i_out_first_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_out_first_tensor_matrix_convolution_loop))) <= data_out_first_tensor_matrix_convolution;

            -- Control Internal
            if (unsigned(index_j_out_first_tensor_matrix_convolution_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              index_j_out_first_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_j_out_first_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_first_tensor_matrix_convolution <= '0';

          if (ready_first_tensor_matrix_convolution = '1') then
            -- Control Internal
            data_first_tensor_matrix_convolution_enable_int <= '1';

            -- FSM Control
            controller_first_tensor_matrix_convolution_fsm_int <= STARTER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_first_tensor_matrix_convolution_fsm_int <= STARTER_FIRST_TENSOR_MATRIX_CONVOLUTION_STATE;
      end case;
    end if;
  end process;

  first_vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_first_vector_summation <= '0';

      data_in_enable_first_vector_summation        <= '0';
      data_in_length_enable_first_vector_summation <= '0';

      data_first_vector_summation_enable_int <= '0';

      index_length_first_vector_summation_loop <= ZERO_CONTROL;
      index_first_vector_summation_loop        <= ZERO_CONTROL;

      index_out_length_first_vector_summation_loop <= ZERO_CONTROL;

      -- Data Internal
      length_in_first_vector_summation <= ZERO_CONTROL;
      size_in_first_vector_summation   <= ZERO_CONTROL;

      data_in_first_vector_summation <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_first_vector_summation_fsm_int is
        when STARTER_FIRST_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          start_first_vector_summation <= '0';

          data_in_enable_first_vector_summation        <= '0';
          data_in_length_enable_first_vector_summation <= '0';

          -- Data Internal
          data_in_first_vector_summation <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_first_vector_summation_enable_int <= '0';

            -- FSM Control
            controller_first_vector_summation_fsm_int <= ENABLER_FIRST_VECTOR_SUMMATION_STATE;
          end if;

        when ENABLER_FIRST_VECTOR_SUMMATION_STATE =>  -- STEP 1

          if (data_first_tensor_matrix_convolution_enable_int = '1') then
            if (unsigned(index_length_first_vector_summation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_first_vector_summation_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_first_vector_summation <= '1';

              index_length_first_vector_summation_loop <= ZERO_CONTROL;
              index_first_vector_summation_loop        <= ZERO_CONTROL;

              index_out_length_first_vector_summation_loop <= ZERO_CONTROL;

              -- Data Inputs
              length_in_first_vector_summation <= SIZE_L_IN;
              size_in_first_vector_summation   <= SIZE_R_IN;
            end if;

            -- FSM Control
            controller_first_vector_summation_fsm_int <= OPERATION_FIRST_VECTOR_SUMMATION_STATE;
          end if;

        when OPERATION_FIRST_VECTOR_SUMMATION_STATE =>  -- STEP 2

          if (data_enable_first_vector_summation = '1' and data_length_enable_first_vector_summation = '1') then
            -- Data Inputs
            data_in_first_vector_summation <= matrix_one_operation_int(to_integer(unsigned(index_length_first_vector_summation_loop)), to_integer(unsigned(index_first_vector_summation_loop)));

            -- Control Internal
            data_in_enable_first_vector_summation        <= '1';
            data_in_length_enable_first_vector_summation <= '1';

            if ((unsigned(index_length_first_vector_summation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_first_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              index_length_first_vector_summation_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_length_first_vector_summation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_first_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              index_length_first_vector_summation_loop <= std_logic_vector(unsigned(index_length_first_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;

            index_first_vector_summation_loop <= ZERO_CONTROL;

          elsif (data_length_enable_first_vector_summation = '1') then
            -- Data Inputs
            data_in_first_vector_summation <= matrix_one_operation_int(to_integer(unsigned(index_length_first_vector_summation_loop)), to_integer(unsigned(index_first_vector_summation_loop)));

            -- Control Internal
            data_in_length_enable_first_vector_summation <= '1';

            if (unsigned(index_first_vector_summation_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              index_first_vector_summation_loop <= std_logic_vector(unsigned(index_first_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_in_enable_first_vector_summation        <= '0';
            data_in_length_enable_first_vector_summation <= '0';
          end if;

          if (data_out_enable_first_vector_summation = '1') then
            -- Data Internal
            vector_one_operation_int(to_integer(unsigned(index_out_length_first_vector_summation_loop))) <= data_out_first_vector_summation;

            -- Control Internal
            if (unsigned(index_out_length_first_vector_summation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_out_length_first_vector_summation_loop <= ZERO_CONTROL;
            else
              index_out_length_first_vector_summation_loop <= std_logic_vector(unsigned(index_out_length_first_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_first_vector_summation <= '0';

          if (ready_first_vector_summation = '1') then
            -- Control Internal
            data_first_vector_summation_enable_int <= '1';

            -- FSM Control
            controller_first_vector_summation_fsm_int <= STARTER_FIRST_VECTOR_SUMMATION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_first_vector_summation_fsm_int <= STARTER_FIRST_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  -- W(l;x)*x(t;x)
  first_matrix_vector_convolution_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_first_matrix_vector_convolution <= '0';

      data_a_in_i_enable_first_matrix_vector_convolution <= '0';
      data_a_in_j_enable_first_matrix_vector_convolution <= '0';
      data_b_in_enable_first_matrix_vector_convolution   <= '0';

      data_first_matrix_vector_convolution_enable_int <= '0';

      index_i_first_matrix_vector_convolution_loop <= ZERO_CONTROL;
      index_j_first_matrix_vector_convolution_loop <= ZERO_CONTROL;

      index_i_out_first_matrix_vector_convolution_loop <= ZERO_CONTROL;

      -- Data Internal
      size_a_i_in_first_matrix_vector_convolution <= ZERO_CONTROL;
      size_a_j_in_first_matrix_vector_convolution <= ZERO_CONTROL;
      size_b_in_first_matrix_vector_convolution   <= ZERO_CONTROL;

      data_a_in_first_matrix_vector_convolution <= ZERO_DATA;
      data_b_in_first_matrix_vector_convolution <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_first_matrix_vector_convolution_fsm_int is
        when STARTER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 0
          -- Control Internal
          start_first_matrix_vector_convolution <= '0';

          data_a_in_i_enable_first_matrix_vector_convolution <= '0';
          data_a_in_j_enable_first_matrix_vector_convolution <= '0';
          data_b_in_enable_first_matrix_vector_convolution   <= '0';

          -- Data Internal
          data_a_in_first_matrix_vector_convolution <= ZERO_DATA;
          data_b_in_first_matrix_vector_convolution <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_first_matrix_vector_convolution_enable_int <= '0';

            -- FSM Control
            controller_first_matrix_vector_convolution_fsm_int <= ENABLER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when ENABLER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 1

          if (data_w_in_enable_int = '1' and data_x_in_enable_int = '1') then
            if (unsigned(index_i_first_matrix_vector_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_first_matrix_vector_convolution_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_first_matrix_vector_convolution <= '1';

              index_i_first_matrix_vector_convolution_loop <= ZERO_CONTROL;
              index_j_first_matrix_vector_convolution_loop <= ZERO_CONTROL;

              index_i_out_first_matrix_vector_convolution_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_a_i_in_first_matrix_vector_convolution <= SIZE_L_IN;
              size_a_j_in_first_matrix_vector_convolution <= SIZE_X_IN;
              size_b_in_first_matrix_vector_convolution   <= SIZE_X_IN;
            end if;

            -- FSM Control
            controller_first_matrix_vector_convolution_fsm_int <= OPERATION_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when OPERATION_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 2

          if (data_i_enable_first_matrix_vector_convolution = '1' and data_j_enable_first_matrix_vector_convolution = '1') then
            -- Data Inputs
            data_a_in_first_matrix_vector_convolution <= matrix_w_in_int(to_integer(unsigned(index_i_first_matrix_vector_convolution_loop)), to_integer(unsigned(index_j_first_matrix_vector_convolution_loop)));
            data_b_in_first_matrix_vector_convolution <= vector_x_in_int(to_integer(unsigned(index_i_first_matrix_vector_convolution_loop)));

            -- Control Internal
            data_a_in_i_enable_first_matrix_vector_convolution <= '1';
            data_a_in_j_enable_first_matrix_vector_convolution <= '1';
            data_b_in_enable_first_matrix_vector_convolution   <= '1';

            if ((unsigned(index_i_first_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_first_matrix_vector_convolution_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              index_i_first_matrix_vector_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_i_first_matrix_vector_convolution_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_first_matrix_vector_convolution_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              index_i_first_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_i_first_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_first_matrix_vector_convolution_loop <= ZERO_CONTROL;

          elsif (data_j_enable_first_matrix_vector_convolution = '1') then
            -- Data Inputs
            data_a_in_first_matrix_vector_convolution <= matrix_w_in_int(to_integer(unsigned(index_i_first_matrix_vector_convolution_loop)), to_integer(unsigned(index_j_first_matrix_vector_convolution_loop)));

            -- Control Internal
            data_a_in_j_enable_first_matrix_vector_convolution <= '1';

            if (unsigned(index_j_first_matrix_vector_convolution_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              index_j_first_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_j_first_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_a_in_i_enable_first_matrix_vector_convolution <= '0';
            data_a_in_j_enable_first_matrix_vector_convolution <= '0';
            data_b_in_enable_first_matrix_vector_convolution   <= '0';
          end if;

          if (data_out_enable_first_matrix_vector_convolution = '1') then
            -- Data Internal
            vector_two_operation_int(to_integer(unsigned(index_i_out_first_matrix_vector_convolution_loop))) <= data_out_first_matrix_vector_convolution;

            -- Control Internal
            if (unsigned(index_i_out_first_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_i_out_first_matrix_vector_convolution_loop <= ZERO_CONTROL;
            else
              index_i_out_first_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_i_out_first_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_first_matrix_vector_convolution <= '0';

          if (ready_first_matrix_vector_convolution = '1') then
            -- Control Internal
            data_first_matrix_vector_convolution_enable_int <= '1';

            -- FSM Control
            controller_first_matrix_vector_convolution_fsm_int <= STARTER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_first_matrix_vector_convolution_fsm_int <= STARTER_FIRST_MATRIX_VECTOR_CONVOLUTION_STATE;
      end case;
    end if;
  end process;

  first_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_first_vector_float_adder <= '0';

      data_a_in_enable_first_vector_float_adder <= '0';
      data_b_in_enable_first_vector_float_adder <= '0';

      data_first_vector_float_adder_enable_int <= '0';

      index_first_vector_float_adder_loop <= ZERO_CONTROL;

      -- Data Internal
      operation_first_vector_float_adder <= '0';

      size_in_first_vector_float_adder <= ZERO_CONTROL;

      data_a_in_first_vector_float_adder <= ZERO_DATA;
      data_b_in_first_vector_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_first_vector_float_adder_fsm_int is
        when STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          start_first_vector_float_adder <= '0';

          data_a_in_enable_first_vector_float_adder <= '0';
          data_b_in_enable_first_vector_float_adder <= '0';

          if (ready_first_vector_float_adder = '1') then
            data_first_vector_float_adder_enable_int <= '1';
          end if;

          -- Data Internal
          data_a_in_first_vector_float_adder <= ZERO_DATA;
          data_b_in_first_vector_float_adder <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_first_vector_float_adder_enable_int <= '0';

            -- FSM Control
            controller_first_vector_float_adder_fsm_int <= ENABLER_FIRST_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when ENABLER_FIRST_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 1

          if (data_first_vector_summation_enable_int = '1' and data_first_matrix_vector_convolution_enable_int = '1') then
            if (unsigned(index_first_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_first_vector_float_adder <= '1';

              index_first_vector_float_adder_loop <= ZERO_CONTROL;

              -- Data Inputs
              operation_first_vector_float_adder <= '0';

              size_in_first_vector_float_adder <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_first_vector_float_adder_fsm_int <= OPERATION_FIRST_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when OPERATION_FIRST_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_first_vector_float_adder = '1') then
            if (unsigned(index_first_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_a_in_first_vector_float_adder <= vector_one_operation_int(to_integer(unsigned(index_first_vector_float_adder_loop)));
              data_b_in_first_vector_float_adder <= vector_two_operation_int(to_integer(unsigned(index_first_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_first_vector_float_adder <= '1';
              data_b_in_enable_first_vector_float_adder <= '1';

              index_first_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_vector_float_adder_fsm_int <= STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE;
            else
              -- Data Inputs
              data_a_in_first_vector_float_adder <= vector_one_operation_int(to_integer(unsigned(index_first_vector_float_adder_loop)));
              data_b_in_first_vector_float_adder <= vector_two_operation_int(to_integer(unsigned(index_first_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_first_vector_float_adder <= '1';
              data_b_in_enable_first_vector_float_adder <= '1';

              index_first_vector_float_adder_loop <= std_logic_vector(unsigned(index_first_vector_float_adder_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_three_operation_int(to_integer(unsigned(index_first_vector_float_adder_loop))) <= data_out_first_vector_float_adder;
          else
            -- Control Internal
            start_first_vector_float_adder <= '0';

            data_a_in_enable_first_vector_float_adder <= '0';
            data_b_in_enable_first_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_first_vector_float_adder_fsm_int <= STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- V(l;s)*xi(t;s)
  second_matrix_vector_convolution_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_second_matrix_vector_convolution <= '0';

      data_a_in_i_enable_second_matrix_vector_convolution <= '0';
      data_a_in_j_enable_second_matrix_vector_convolution <= '0';
      data_b_in_enable_second_matrix_vector_convolution   <= '0';

      data_second_matrix_vector_convolution_enable_int <= '0';

      index_i_second_matrix_vector_convolution_loop <= ZERO_CONTROL;
      index_j_second_matrix_vector_convolution_loop <= ZERO_CONTROL;

      index_i_out_second_matrix_vector_convolution_loop <= ZERO_CONTROL;

      -- Data Internal
      size_a_i_in_second_matrix_vector_convolution <= ZERO_CONTROL;
      size_a_j_in_second_matrix_vector_convolution <= ZERO_CONTROL;
      size_b_in_second_matrix_vector_convolution   <= ZERO_CONTROL;

      data_a_in_second_matrix_vector_convolution <= ZERO_DATA;
      data_b_in_second_matrix_vector_convolution <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_second_matrix_vector_convolution_fsm_int is
        when STARTER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 0
          -- Control Internal
          start_second_matrix_vector_convolution <= '0';

          data_a_in_i_enable_second_matrix_vector_convolution <= '0';
          data_a_in_j_enable_second_matrix_vector_convolution <= '0';
          data_b_in_enable_second_matrix_vector_convolution   <= '0';

          -- Data Internal
          data_a_in_second_matrix_vector_convolution <= ZERO_DATA;
          data_b_in_second_matrix_vector_convolution <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_second_matrix_vector_convolution_enable_int <= '0';

            -- FSM Control
            controller_second_matrix_vector_convolution_fsm_int <= ENABLER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when ENABLER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 1

          if (data_v_in_enable_int = '1' and data_xi_in_enable_int = '1') then
            if (unsigned(index_i_second_matrix_vector_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_second_matrix_vector_convolution_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_second_matrix_vector_convolution <= '1';

              index_i_second_matrix_vector_convolution_loop <= ZERO_CONTROL;
              index_j_second_matrix_vector_convolution_loop <= ZERO_CONTROL;

              index_i_out_second_matrix_vector_convolution_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_a_i_in_second_matrix_vector_convolution <= SIZE_L_IN;
              size_a_j_in_second_matrix_vector_convolution <= SIZE_S_IN;
              size_b_in_second_matrix_vector_convolution   <= SIZE_S_IN;
            end if;

            -- FSM Control
            controller_second_matrix_vector_convolution_fsm_int <= OPERATION_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when OPERATION_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 2

          if (data_i_enable_second_matrix_vector_convolution = '1' and data_j_enable_second_matrix_vector_convolution = '1') then
            -- Data Inputs
            data_a_in_second_matrix_vector_convolution <= matrix_v_in_int(to_integer(unsigned(index_i_second_matrix_vector_convolution_loop)), to_integer(unsigned(index_j_second_matrix_vector_convolution_loop)));
            data_b_in_second_matrix_vector_convolution <= vector_xi_in_int(to_integer(unsigned(index_i_second_matrix_vector_convolution_loop)));

            -- Control Internal
            data_a_in_i_enable_second_matrix_vector_convolution <= '1';
            data_a_in_j_enable_second_matrix_vector_convolution <= '1';
            data_b_in_enable_second_matrix_vector_convolution   <= '1';

            if ((unsigned(index_i_second_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_second_matrix_vector_convolution_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
              index_i_second_matrix_vector_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_i_second_matrix_vector_convolution_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_second_matrix_vector_convolution_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
              index_i_second_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_i_second_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_second_matrix_vector_convolution_loop <= ZERO_CONTROL;

          elsif (data_j_enable_second_matrix_vector_convolution = '1') then
            -- Data Inputs
            data_a_in_second_matrix_vector_convolution <= matrix_v_in_int(to_integer(unsigned(index_i_second_matrix_vector_convolution_loop)), to_integer(unsigned(index_j_second_matrix_vector_convolution_loop)));

            -- Control Internal
            data_a_in_j_enable_second_matrix_vector_convolution <= '1';

            if (unsigned(index_j_second_matrix_vector_convolution_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
              index_j_second_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_j_second_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_a_in_i_enable_second_matrix_vector_convolution <= '0';
            data_a_in_j_enable_second_matrix_vector_convolution <= '0';
            data_b_in_enable_second_matrix_vector_convolution   <= '0';
          end if;

          if (data_out_enable_second_matrix_vector_convolution = '1') then
            -- Data Internal
            vector_four_operation_int(to_integer(unsigned(index_i_out_second_matrix_vector_convolution_loop))) <= data_out_second_matrix_vector_convolution;

            -- Control Internal
            if (unsigned(index_i_out_second_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_i_out_second_matrix_vector_convolution_loop <= ZERO_CONTROL;
            else
              index_i_out_second_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_i_out_second_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_second_matrix_vector_convolution <= '0';

          if (ready_second_matrix_vector_convolution = '1') then
            -- Control Internal
            data_second_matrix_vector_convolution_enable_int <= '1';

            -- FSM Control
            controller_second_matrix_vector_convolution_fsm_int <= STARTER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_second_matrix_vector_convolution_fsm_int <= STARTER_SECOND_MATRIX_VECTOR_CONVOLUTION_STATE;
      end case;
    end if;
  end process;

  second_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_second_vector_float_adder <= '0';

      data_a_in_enable_second_vector_float_adder <= '0';
      data_b_in_enable_second_vector_float_adder <= '0';

      data_second_vector_float_adder_enable_int <= '0';

      index_second_vector_float_adder_loop <= ZERO_CONTROL;

      -- Data Internal
      operation_second_vector_float_adder <= '0';

      size_in_second_vector_float_adder <= ZERO_CONTROL;

      data_a_in_second_vector_float_adder <= ZERO_DATA;
      data_b_in_second_vector_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_second_vector_float_adder_fsm_int is
        when STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          start_second_vector_float_adder <= '0';

          data_a_in_enable_second_vector_float_adder <= '0';
          data_b_in_enable_second_vector_float_adder <= '0';

          if (ready_second_vector_float_adder = '1') then
            data_second_vector_float_adder_enable_int <= '1';
          end if;

          -- Data Internal
          data_a_in_second_vector_float_adder <= ZERO_DATA;
          data_b_in_second_vector_float_adder <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_second_vector_float_adder_enable_int <= '0';

            -- FSM Control
            controller_second_vector_float_adder_fsm_int <= ENABLER_SECOND_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when ENABLER_SECOND_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 1

          if (data_first_vector_float_adder_enable_int = '1' and data_second_matrix_vector_convolution_enable_int = '1') then
            if (unsigned(index_second_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_second_vector_float_adder <= '1';

              index_second_vector_float_adder_loop <= ZERO_CONTROL;

              -- Data Inputs
              operation_second_vector_float_adder <= '0';

              size_in_second_vector_float_adder <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_second_vector_float_adder_fsm_int <= OPERATION_SECOND_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when OPERATION_SECOND_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_second_vector_float_adder = '1') then
            if (unsigned(index_second_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_a_in_second_vector_float_adder <= vector_three_operation_int(to_integer(unsigned(index_second_vector_float_adder_loop)));
              data_b_in_second_vector_float_adder <= vector_four_operation_int(to_integer(unsigned(index_second_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_second_vector_float_adder <= '1';
              data_b_in_enable_second_vector_float_adder <= '1';

              index_second_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_vector_float_adder_fsm_int <= STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE;
            else
              -- Data Inputs
              data_a_in_second_vector_float_adder <= vector_three_operation_int(to_integer(unsigned(index_second_vector_float_adder_loop)));
              data_b_in_second_vector_float_adder <= vector_four_operation_int(to_integer(unsigned(index_second_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_second_vector_float_adder <= '1';
              data_b_in_enable_second_vector_float_adder <= '1';

              index_second_vector_float_adder_loop <= std_logic_vector(unsigned(index_second_vector_float_adder_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_five_operation_int(to_integer(unsigned(index_second_vector_float_adder_loop))) <= data_out_second_vector_float_adder;
          else
            -- Control Internal
            start_second_vector_float_adder <= '0';

            data_a_in_enable_second_vector_float_adder <= '0';
            data_b_in_enable_second_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_second_vector_float_adder_fsm_int <= STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- D(i;l;m)*rho(t;i;m)
  second_tensor_matrix_convolution_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_second_tensor_matrix_convolution <= '0';

      data_a_in_i_enable_second_tensor_matrix_convolution <= '0';
      data_a_in_j_enable_second_tensor_matrix_convolution <= '0';
      data_a_in_k_enable_second_tensor_matrix_convolution <= '0';
      data_b_in_i_enable_second_tensor_matrix_convolution <= '0';
      data_b_in_j_enable_second_tensor_matrix_convolution <= '0';

      data_second_tensor_matrix_convolution_enable_int <= '0';

      index_i_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
      index_j_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
      index_k_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

      index_i_out_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
      index_j_out_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

      -- Data Internal
      size_a_i_in_second_tensor_matrix_convolution <= ZERO_CONTROL;
      size_a_j_in_second_tensor_matrix_convolution <= ZERO_CONTROL;
      size_a_k_in_second_tensor_matrix_convolution <= ZERO_CONTROL;
      size_b_i_in_second_tensor_matrix_convolution <= ZERO_CONTROL;
      size_b_j_in_second_tensor_matrix_convolution <= ZERO_CONTROL;

      data_a_in_second_tensor_matrix_convolution <= ZERO_DATA;
      data_b_in_second_tensor_matrix_convolution <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_second_tensor_matrix_convolution_fsm_int is
        when STARTER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE =>  -- STEP 0
          -- Control Internal
          start_second_tensor_matrix_convolution <= '0';

          data_a_in_i_enable_second_tensor_matrix_convolution <= '0';
          data_a_in_j_enable_second_tensor_matrix_convolution <= '0';
          data_a_in_k_enable_second_tensor_matrix_convolution <= '0';
          data_b_in_i_enable_second_tensor_matrix_convolution <= '0';
          data_b_in_j_enable_second_tensor_matrix_convolution <= '0';

          -- Data Internal
          data_a_in_second_tensor_matrix_convolution <= ZERO_DATA;
          data_b_in_second_tensor_matrix_convolution <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_second_tensor_matrix_convolution_enable_int <= '0';

            -- FSM Control
            controller_second_tensor_matrix_convolution_fsm_int <= ENABLER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE;
          end if;

        when ENABLER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE =>  -- STEP 1

          if (data_d_in_enable_int = '1' and data_rho_in_enable_int = '1') then
            if (unsigned(index_i_second_tensor_matrix_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_second_tensor_matrix_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_second_tensor_matrix_convolution_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_second_tensor_matrix_convolution <= '1';

              index_i_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
              index_j_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
              index_k_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

              index_i_out_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
              index_j_out_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_a_i_in_second_tensor_matrix_convolution <= SIZE_R_IN;
              size_a_j_in_second_tensor_matrix_convolution <= SIZE_L_IN;
              size_a_k_in_second_tensor_matrix_convolution <= SIZE_M_IN;
              size_b_i_in_second_tensor_matrix_convolution <= SIZE_R_IN;
              size_b_j_in_second_tensor_matrix_convolution <= SIZE_M_IN;
            end if;

            -- FSM Control
            controller_second_tensor_matrix_convolution_fsm_int <= OPERATION_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE;
          end if;

        when OPERATION_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE =>  -- STEP 2

          if (data_i_enable_second_tensor_matrix_convolution = '1' and data_j_enable_second_tensor_matrix_convolution = '1' and data_k_enable_second_tensor_matrix_convolution = '1') then
            -- Data Inputs
            data_a_in_second_tensor_matrix_convolution <= tensor_d_in_int(to_integer(unsigned(index_i_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_k_second_tensor_matrix_convolution_loop)));
            data_b_in_second_tensor_matrix_convolution <= matrix_rho_in_int(to_integer(unsigned(index_i_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_second_tensor_matrix_convolution_loop)));

            -- Control Internal
            data_a_in_i_enable_second_tensor_matrix_convolution <= '1';
            data_a_in_j_enable_second_tensor_matrix_convolution <= '1';
            data_a_in_k_enable_second_tensor_matrix_convolution <= '1';
            data_b_in_i_enable_second_tensor_matrix_convolution <= '1';
            data_b_in_j_enable_second_tensor_matrix_convolution <= '1';

            if ((unsigned(index_i_second_tensor_matrix_convolution_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_second_tensor_matrix_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_second_tensor_matrix_convolution_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              index_i_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_i_second_tensor_matrix_convolution_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_second_tensor_matrix_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_second_tensor_matrix_convolution_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              index_i_second_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_i_second_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

          elsif (data_j_enable_second_tensor_matrix_convolution = '1' and data_k_enable_second_tensor_matrix_convolution = '1') then
            -- Data Inputs
            data_a_in_second_tensor_matrix_convolution <= tensor_d_in_int(to_integer(unsigned(index_i_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_k_second_tensor_matrix_convolution_loop)));
            data_b_in_second_tensor_matrix_convolution <= matrix_rho_in_int(to_integer(unsigned(index_i_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_second_tensor_matrix_convolution_loop)));

            -- Control Internal
            data_a_in_j_enable_second_tensor_matrix_convolution <= '1';
            data_a_in_k_enable_second_tensor_matrix_convolution <= '1';
            data_b_in_j_enable_second_tensor_matrix_convolution <= '1';

            if ((unsigned(index_j_second_tensor_matrix_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_second_tensor_matrix_convolution_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              index_j_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_j_second_tensor_matrix_convolution_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_second_tensor_matrix_convolution_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              index_j_second_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_j_second_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_k_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

          elsif (data_k_enable_second_tensor_matrix_convolution = '1') then
            -- Data Inputs
            data_a_in_second_tensor_matrix_convolution <= tensor_d_in_int(to_integer(unsigned(index_i_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_k_second_tensor_matrix_convolution_loop)));

            -- Control Internal
            data_a_in_k_enable_second_tensor_matrix_convolution <= '1';

            if (unsigned(index_k_second_tensor_matrix_convolution_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              index_k_second_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_k_second_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_a_in_i_enable_second_tensor_matrix_convolution <= '0';
            data_a_in_j_enable_second_tensor_matrix_convolution <= '0';
            data_a_in_k_enable_second_tensor_matrix_convolution <= '0';
            data_b_in_i_enable_second_tensor_matrix_convolution <= '0';
            data_b_in_j_enable_second_tensor_matrix_convolution <= '0';
          end if;

          if (data_out_i_enable_second_tensor_matrix_convolution = '1' and data_out_j_enable_second_tensor_matrix_convolution = '1') then
            -- Data Internal
            matrix_two_operation_int(to_integer(unsigned(index_i_out_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_out_second_tensor_matrix_convolution_loop))) <= data_out_second_tensor_matrix_convolution;

            -- Control Internal
            if (unsigned(index_i_out_second_tensor_matrix_convolution_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              index_i_out_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;
            else
              index_i_out_second_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_i_out_second_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_out_second_tensor_matrix_convolution_loop <= ZERO_CONTROL;

          elsif (data_out_j_enable_second_tensor_matrix_convolution = '1') then
            -- Data Internal
            matrix_two_operation_int(to_integer(unsigned(index_i_out_second_tensor_matrix_convolution_loop)), to_integer(unsigned(index_j_out_second_tensor_matrix_convolution_loop))) <= data_out_second_tensor_matrix_convolution;

            -- Control Internal
            if (unsigned(index_j_out_second_tensor_matrix_convolution_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              index_j_out_second_tensor_matrix_convolution_loop <= std_logic_vector(unsigned(index_j_out_second_tensor_matrix_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_second_tensor_matrix_convolution <= '0';

          if (ready_second_tensor_matrix_convolution = '1') then
            -- Control Internal
            data_second_tensor_matrix_convolution_enable_int <= '1';

            -- FSM Control
            controller_second_tensor_matrix_convolution_fsm_int <= STARTER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_second_tensor_matrix_convolution_fsm_int <= STARTER_SECOND_TENSOR_MATRIX_CONVOLUTION_STATE;
      end case;
    end if;
  end process;

  second_vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_second_vector_summation <= '0';

      data_in_enable_second_vector_summation        <= '0';
      data_in_length_enable_second_vector_summation <= '0';

      data_second_vector_summation_enable_int <= '0';

      index_length_second_vector_summation_loop <= ZERO_CONTROL;
      index_second_vector_summation_loop        <= ZERO_CONTROL;

      index_out_length_second_vector_summation_loop <= ZERO_CONTROL;

      -- Data Internal
      length_in_second_vector_summation <= ZERO_CONTROL;
      size_in_second_vector_summation   <= ZERO_CONTROL;

      data_in_second_vector_summation <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_second_vector_summation_fsm_int is
        when STARTER_SECOND_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          start_second_vector_summation <= '0';

          data_in_enable_second_vector_summation        <= '0';
          data_in_length_enable_second_vector_summation <= '0';

          -- Data Internal
          data_in_second_vector_summation <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_second_vector_summation_enable_int <= '0';

            -- FSM Control
            controller_second_vector_summation_fsm_int <= ENABLER_SECOND_VECTOR_SUMMATION_STATE;
          end if;

        when ENABLER_SECOND_VECTOR_SUMMATION_STATE =>  -- STEP 1

          if (data_second_tensor_matrix_convolution_enable_int = '1') then
            if (unsigned(index_length_second_vector_summation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_second_vector_summation_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_second_vector_summation <= '1';

              index_length_second_vector_summation_loop <= ZERO_CONTROL;
              index_second_vector_summation_loop        <= ZERO_CONTROL;

              index_out_length_second_vector_summation_loop <= ZERO_CONTROL;

              -- Data Inputs
              length_in_second_vector_summation <= SIZE_L_IN;
              size_in_second_vector_summation   <= SIZE_R_IN;
            end if;

            -- FSM Control
            controller_second_vector_summation_fsm_int <= OPERATION_SECOND_VECTOR_SUMMATION_STATE;
          end if;

        when OPERATION_SECOND_VECTOR_SUMMATION_STATE =>  -- STEP 2

          if (data_enable_second_vector_summation = '1' and data_length_enable_second_vector_summation = '1') then
            -- Data Inputs
            data_in_second_vector_summation <= matrix_two_operation_int(to_integer(unsigned(index_length_second_vector_summation_loop)), to_integer(unsigned(index_second_vector_summation_loop)));

            -- Control Internal
            data_in_enable_second_vector_summation        <= '1';
            data_in_length_enable_second_vector_summation <= '1';

            if ((unsigned(index_length_second_vector_summation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_second_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              index_length_second_vector_summation_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_length_second_vector_summation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_second_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              index_length_second_vector_summation_loop <= std_logic_vector(unsigned(index_length_second_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;

            index_second_vector_summation_loop <= ZERO_CONTROL;

          elsif (data_length_enable_second_vector_summation = '1') then
            -- Data Inputs
            data_in_second_vector_summation <= matrix_two_operation_int(to_integer(unsigned(index_length_second_vector_summation_loop)), to_integer(unsigned(index_second_vector_summation_loop)));

            -- Control Internal
            data_in_length_enable_second_vector_summation <= '1';

            if (unsigned(index_second_vector_summation_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              index_second_vector_summation_loop <= std_logic_vector(unsigned(index_second_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_in_enable_second_vector_summation        <= '0';
            data_in_length_enable_second_vector_summation <= '0';
          end if;

          if (data_out_enable_second_vector_summation = '1') then
            -- Data Internal
            vector_six_operation_int(to_integer(unsigned(index_out_length_second_vector_summation_loop))) <= data_out_second_vector_summation;

            -- Control Internal
            if (unsigned(index_out_length_second_vector_summation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_out_length_second_vector_summation_loop <= ZERO_CONTROL;
            else
              index_out_length_second_vector_summation_loop <= std_logic_vector(unsigned(index_out_length_second_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_second_vector_summation <= '0';

          if (ready_second_vector_summation = '1') then
            -- Control Internal
            data_second_vector_summation_enable_int <= '1';

            -- FSM Control
            controller_second_vector_summation_fsm_int <= STARTER_SECOND_VECTOR_SUMMATION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_second_vector_summation_fsm_int <= STARTER_SECOND_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  -- b(l)
  third_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_third_vector_float_adder <= '0';

      data_a_in_enable_third_vector_float_adder <= '0';
      data_b_in_enable_third_vector_float_adder <= '0';

      data_third_vector_float_adder_enable_int <= '0';

      index_third_vector_float_adder_loop <= ZERO_CONTROL;

      -- Data Internal
      operation_third_vector_float_adder <= '0';

      size_in_third_vector_float_adder <= ZERO_CONTROL;

      data_a_in_third_vector_float_adder <= ZERO_DATA;
      data_b_in_third_vector_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_third_vector_float_adder_fsm_int is
        when STARTER_THIRD_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          start_third_vector_float_adder <= '0';

          data_a_in_enable_third_vector_float_adder <= '0';
          data_b_in_enable_third_vector_float_adder <= '0';

          if (ready_third_vector_float_adder = '1') then
            data_third_vector_float_adder_enable_int <= '1';
          end if;

          -- Data Internal
          data_a_in_third_vector_float_adder <= ZERO_DATA;
          data_b_in_third_vector_float_adder <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_third_vector_float_adder_enable_int <= '0';

            -- FSM Control
            controller_third_vector_float_adder_fsm_int <= ENABLER_THIRD_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when ENABLER_THIRD_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 1

          if (data_second_vector_float_adder_enable_int = '1' and data_second_vector_summation_enable_int = '1') then
            if (unsigned(index_third_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_third_vector_float_adder <= '1';

              index_third_vector_float_adder_loop <= ZERO_CONTROL;

              -- Data Inputs
              operation_third_vector_float_adder <= '0';

              size_in_third_vector_float_adder <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_third_vector_float_adder_fsm_int <= OPERATION_THIRD_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when OPERATION_THIRD_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_third_vector_float_adder = '1') then
            if (unsigned(index_third_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_a_in_third_vector_float_adder <= vector_five_operation_int(to_integer(unsigned(index_third_vector_float_adder_loop)));
              data_b_in_third_vector_float_adder <= vector_six_operation_int(to_integer(unsigned(index_third_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_third_vector_float_adder <= '1';
              data_b_in_enable_third_vector_float_adder <= '1';

              index_third_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_third_vector_float_adder_fsm_int <= STARTER_THIRD_VECTOR_FLOAT_ADDER_STATE;
            else
              -- Data Inputs
              data_a_in_third_vector_float_adder <= vector_five_operation_int(to_integer(unsigned(index_third_vector_float_adder_loop)));
              data_b_in_third_vector_float_adder <= vector_six_operation_int(to_integer(unsigned(index_third_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_third_vector_float_adder <= '1';
              data_b_in_enable_third_vector_float_adder <= '1';

              index_third_vector_float_adder_loop <= std_logic_vector(unsigned(index_third_vector_float_adder_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_seven_operation_int(to_integer(unsigned(index_third_vector_float_adder_loop))) <= data_out_third_vector_float_adder;
          else
            -- Control Internal
            start_third_vector_float_adder <= '0';

            data_a_in_enable_third_vector_float_adder <= '0';
            data_b_in_enable_third_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_third_vector_float_adder_fsm_int <= STARTER_THIRD_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  fourth_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_fourth_vector_float_adder <= '0';

      data_a_in_enable_fourth_vector_float_adder <= '0';
      data_b_in_enable_fourth_vector_float_adder <= '0';

      data_fourth_vector_float_adder_enable_int <= '0';

      index_fourth_vector_float_adder_loop <= ZERO_CONTROL;

      -- Data Internal
      operation_fourth_vector_float_adder <= '0';

      size_in_fourth_vector_float_adder <= ZERO_CONTROL;

      data_a_in_fourth_vector_float_adder <= ZERO_DATA;
      data_b_in_fourth_vector_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_fourth_vector_float_adder_fsm_int is
        when STARTER_FOURTH_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          start_fourth_vector_float_adder <= '0';

          data_a_in_enable_fourth_vector_float_adder <= '0';
          data_b_in_enable_fourth_vector_float_adder <= '0';

          if (ready_fourth_vector_float_adder = '1') then
            data_fourth_vector_float_adder_enable_int <= '1';
          end if;

          -- Data Internal
          data_a_in_fourth_vector_float_adder <= ZERO_DATA;
          data_b_in_fourth_vector_float_adder <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_fourth_vector_float_adder_enable_int <= '0';

            -- FSM Control
            controller_fourth_vector_float_adder_fsm_int <= ENABLER_FOURTH_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when ENABLER_FOURTH_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 1

          if (data_b_in_enable_int = '1' and data_third_vector_float_adder_enable_int = '1') then
            if (unsigned(index_fourth_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_fourth_vector_float_adder <= '1';

              index_fourth_vector_float_adder_loop <= ZERO_CONTROL;

              -- Data Inputs
              operation_fourth_vector_float_adder <= '0';

              size_in_fourth_vector_float_adder <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_fourth_vector_float_adder_fsm_int <= OPERATION_FOURTH_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when OPERATION_FOURTH_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_fourth_vector_float_adder = '1') then
            if (unsigned(index_fourth_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_a_in_fourth_vector_float_adder <= vector_b_in_int(to_integer(unsigned(index_fourth_vector_float_adder_loop)));
              data_b_in_fourth_vector_float_adder <= vector_seven_operation_int(to_integer(unsigned(index_fourth_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_fourth_vector_float_adder <= '1';
              data_b_in_enable_fourth_vector_float_adder <= '1';

              index_fourth_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_fourth_vector_float_adder_fsm_int <= STARTER_FOURTH_VECTOR_FLOAT_ADDER_STATE;
            else
              -- Data Inputs
              data_a_in_fourth_vector_float_adder <= vector_b_in_int(to_integer(unsigned(index_fourth_vector_float_adder_loop)));
              data_b_in_fourth_vector_float_adder <= vector_seven_operation_int(to_integer(unsigned(index_fourth_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_fourth_vector_float_adder <= '1';
              data_b_in_enable_fourth_vector_float_adder <= '1';

              index_fourth_vector_float_adder_loop <= std_logic_vector(unsigned(index_fourth_vector_float_adder_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_eight_operation_int(to_integer(unsigned(index_fourth_vector_float_adder_loop))) <= data_out_fourth_vector_float_adder;
          else
            -- Control Internal
            start_fourth_vector_float_adder <= '0';

            data_a_in_enable_fourth_vector_float_adder <= '0';
            data_b_in_enable_fourth_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_fourth_vector_float_adder_fsm_int <= STARTER_FOURTH_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- U(l;l)*h(t-1;l)
  third_matrix_vector_convolution_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_third_matrix_vector_convolution <= '0';

      data_a_in_i_enable_third_matrix_vector_convolution <= '0';
      data_a_in_j_enable_third_matrix_vector_convolution <= '0';
      data_b_in_enable_third_matrix_vector_convolution   <= '0';

      data_third_matrix_vector_convolution_enable_int <= '0';

      index_i_third_matrix_vector_convolution_loop <= ZERO_CONTROL;
      index_j_third_matrix_vector_convolution_loop <= ZERO_CONTROL;

      index_i_out_third_matrix_vector_convolution_loop <= ZERO_CONTROL;

      -- Data Internal
      size_a_i_in_third_matrix_vector_convolution <= ZERO_CONTROL;
      size_a_j_in_third_matrix_vector_convolution <= ZERO_CONTROL;
      size_b_in_third_matrix_vector_convolution   <= ZERO_CONTROL;

      data_a_in_third_matrix_vector_convolution <= ZERO_DATA;
      data_b_in_third_matrix_vector_convolution <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_third_matrix_vector_convolution_fsm_int is
        when STARTER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 0
          -- Control Internal
          start_third_matrix_vector_convolution <= '0';

          data_a_in_i_enable_third_matrix_vector_convolution <= '0';
          data_a_in_j_enable_third_matrix_vector_convolution <= '0';
          data_b_in_enable_third_matrix_vector_convolution   <= '0';

          -- Data Internal
          data_a_in_third_matrix_vector_convolution <= ZERO_DATA;
          data_b_in_third_matrix_vector_convolution <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_third_matrix_vector_convolution_enable_int <= '0';

            -- FSM Control
            controller_third_matrix_vector_convolution_fsm_int <= ENABLER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when ENABLER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 1

          if (data_u_in_enable_int = '1' and data_h_in_enable_int = '1') then
            if (unsigned(index_i_third_matrix_vector_convolution_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_third_matrix_vector_convolution_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_third_matrix_vector_convolution <= '1';

              index_i_third_matrix_vector_convolution_loop <= ZERO_CONTROL;
              index_j_third_matrix_vector_convolution_loop <= ZERO_CONTROL;

              index_i_out_third_matrix_vector_convolution_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_a_i_in_third_matrix_vector_convolution <= SIZE_L_IN;
              size_a_j_in_third_matrix_vector_convolution <= SIZE_L_IN;
              size_b_in_third_matrix_vector_convolution   <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_third_matrix_vector_convolution_fsm_int <= OPERATION_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when OPERATION_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE =>  -- STEP 2

          if (data_i_enable_third_matrix_vector_convolution = '1' and data_j_enable_third_matrix_vector_convolution = '1') then
            -- Data Inputs
            data_a_in_third_matrix_vector_convolution <= matrix_u_in_int(to_integer(unsigned(index_i_third_matrix_vector_convolution_loop)), to_integer(unsigned(index_j_third_matrix_vector_convolution_loop)));
            data_b_in_third_matrix_vector_convolution <= vector_h_in_int(to_integer(unsigned(index_i_third_matrix_vector_convolution_loop)));

            -- Control Internal
            data_a_in_i_enable_third_matrix_vector_convolution <= '1';
            data_a_in_j_enable_third_matrix_vector_convolution <= '1';
            data_b_in_enable_third_matrix_vector_convolution   <= '1';

            if ((unsigned(index_i_third_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_third_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
              index_i_third_matrix_vector_convolution_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_i_third_matrix_vector_convolution_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_third_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
              index_i_third_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_i_third_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_third_matrix_vector_convolution_loop <= ZERO_CONTROL;

          elsif (data_j_enable_third_matrix_vector_convolution = '1') then
            -- Data Inputs
            data_a_in_third_matrix_vector_convolution <= matrix_u_in_int(to_integer(unsigned(index_i_third_matrix_vector_convolution_loop)), to_integer(unsigned(index_j_third_matrix_vector_convolution_loop)));

            -- Control Internal
            data_a_in_j_enable_third_matrix_vector_convolution <= '1';

            if (unsigned(index_j_third_matrix_vector_convolution_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_j_third_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_j_third_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_a_in_i_enable_third_matrix_vector_convolution <= '0';
            data_a_in_j_enable_third_matrix_vector_convolution <= '0';
            data_b_in_enable_third_matrix_vector_convolution   <= '0';
          end if;

          if (data_out_enable_third_matrix_vector_convolution = '1') then
            -- Data Internal
            vector_nine_operation_int(to_integer(unsigned(index_i_out_third_matrix_vector_convolution_loop))) <= data_out_third_matrix_vector_convolution;

            -- Control Internal
            if (unsigned(index_i_out_third_matrix_vector_convolution_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_i_out_third_matrix_vector_convolution_loop <= ZERO_CONTROL;
            else
              index_i_out_third_matrix_vector_convolution_loop <= std_logic_vector(unsigned(index_i_out_third_matrix_vector_convolution_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_third_matrix_vector_convolution <= '0';

          if (ready_third_matrix_vector_convolution = '1') then
            -- Control Internal
            data_third_matrix_vector_convolution_enable_int <= '1';

            -- FSM Control
            controller_third_matrix_vector_convolution_fsm_int <= STARTER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_third_matrix_vector_convolution_fsm_int <= STARTER_THIRD_MATRIX_VECTOR_CONVOLUTION_STATE;
      end case;
    end if;
  end process;

  fiveth_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_fiveth_vector_float_adder <= '0';

      data_a_in_enable_fiveth_vector_float_adder <= '0';
      data_b_in_enable_fiveth_vector_float_adder <= '0';

      data_fiveth_vector_float_adder_enable_int <= '0';

      index_fiveth_vector_float_adder_loop <= ZERO_CONTROL;

      -- Data Internal
      operation_fiveth_vector_float_adder <= '0';

      size_in_fiveth_vector_float_adder <= ZERO_CONTROL;

      data_a_in_fiveth_vector_float_adder <= ZERO_DATA;
      data_b_in_fiveth_vector_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_fiveth_vector_float_adder_fsm_int is
        when STARTER_FIVETH_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          start_fiveth_vector_float_adder <= '0';

          data_a_in_enable_fiveth_vector_float_adder <= '0';
          data_b_in_enable_fiveth_vector_float_adder <= '0';

          if (ready_fiveth_vector_float_adder = '1') then
            data_fiveth_vector_float_adder_enable_int <= '1';
          end if;

          -- Data Internal
          data_a_in_fiveth_vector_float_adder <= ZERO_DATA;
          data_b_in_fiveth_vector_float_adder <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_fiveth_vector_float_adder_enable_int <= '0';

            -- FSM Control
            controller_fiveth_vector_float_adder_fsm_int <= ENABLER_FIVETH_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when ENABLER_FIVETH_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 1

          if (data_third_matrix_vector_convolution_enable_int = '1' and data_fourth_vector_float_adder_enable_int = '1') then
            if (unsigned(index_fiveth_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_fiveth_vector_float_adder <= '1';

              index_fiveth_vector_float_adder_loop <= ZERO_CONTROL;

              -- Data Inputs
              operation_fiveth_vector_float_adder <= '0';

              size_in_fiveth_vector_float_adder <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_fiveth_vector_float_adder_fsm_int <= OPERATION_FIVETH_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when OPERATION_FIVETH_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_fiveth_vector_float_adder = '1') then
            if (unsigned(index_fiveth_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_a_in_fiveth_vector_float_adder <= vector_eight_operation_int(to_integer(unsigned(index_fiveth_vector_float_adder_loop)));
              data_b_in_fiveth_vector_float_adder <= vector_nine_operation_int(to_integer(unsigned(index_fiveth_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_fiveth_vector_float_adder <= '1';
              data_b_in_enable_fiveth_vector_float_adder <= '1';

              index_fiveth_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_fiveth_vector_float_adder_fsm_int <= STARTER_FIVETH_VECTOR_FLOAT_ADDER_STATE;
            else
              -- Data Inputs
              data_a_in_fiveth_vector_float_adder <= vector_eight_operation_int(to_integer(unsigned(index_fiveth_vector_float_adder_loop)));
              data_b_in_fiveth_vector_float_adder <= vector_nine_operation_int(to_integer(unsigned(index_fiveth_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_fiveth_vector_float_adder <= '1';
              data_b_in_enable_fiveth_vector_float_adder <= '1';

              index_fiveth_vector_float_adder_loop <= std_logic_vector(unsigned(index_fiveth_vector_float_adder_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_ten_operation_int(to_integer(unsigned(index_fiveth_vector_float_adder_loop))) <= data_out_fiveth_vector_float_adder;
          else
            -- Control Internal
            start_fiveth_vector_float_adder <= '0';

            data_a_in_enable_fiveth_vector_float_adder <= '0';
            data_b_in_enable_fiveth_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_fiveth_vector_float_adder_fsm_int <= STARTER_FIVETH_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- tanh(a(t;l))
  vector_tanh_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_vector_tanh <= '0';

      data_in_enable_vector_tanh <= '0';

      data_vector_tanh_enable_int <= '0';

      index_vector_tanh_loop <= ZERO_CONTROL;

      -- Data Internal
      size_in_vector_tanh <= ZERO_CONTROL;

      data_in_vector_tanh <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_vector_tanh_fsm_int is
        when STARTER_VECTOR_TANH_STATE =>  -- STEP 0
          -- Control Internal
          start_vector_tanh <= '0';

          data_in_enable_vector_tanh <= '0';

          if (ready_vector_tanh = '1') then
            data_vector_tanh_enable_int <= '1';
          end if;

          -- Data Internal
          data_in_vector_tanh <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_vector_tanh_enable_int <= '0';

            -- FSM Control
            controller_vector_tanh_fsm_int <= ENABLER_VECTOR_TANH_STATE;
          end if;

        when ENABLER_VECTOR_TANH_STATE =>  -- STEP 1

          if (data_fiveth_vector_float_adder_enable_int = '1') then
            if (unsigned(index_vector_tanh_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_tanh_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_tanh <= '1';

              index_vector_tanh_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_in_vector_tanh <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_vector_tanh_fsm_int <= OPERATION_VECTOR_TANH_STATE;
          end if;

        when OPERATION_VECTOR_TANH_STATE =>  -- STEP 2

          if (data_out_enable_vector_tanh = '1') then
            if (unsigned(index_vector_tanh_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_in_vector_tanh <= vector_ten_operation_int(to_integer(unsigned(index_vector_tanh_loop)));

              -- Control Internal
              data_in_enable_vector_tanh <= '1';

              index_vector_tanh_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_tanh_fsm_int <= STARTER_VECTOR_TANH_STATE;
            else
              -- Data Inputs
              data_in_vector_tanh <= vector_two_operation_int(to_integer(unsigned(index_vector_tanh_loop)));

              -- Control Internal
              data_in_enable_vector_tanh <= '1';

              index_vector_tanh_loop <= std_logic_vector(unsigned(index_vector_tanh_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_eleven_operation_int(to_integer(unsigned(index_vector_tanh_loop))) <= data_out_vector_tanh;
          else
            -- Control Internal
            start_vector_tanh <= '0';

            data_in_enable_vector_tanh <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_tanh_fsm_int <= STARTER_VECTOR_TANH_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  h_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      A_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      A_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_h_out_fsm_int is
        when STARTER_H_OUT_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

          -- Control Outputs
          READY <= '0';

          A_OUT_ENABLE <= '0';

        when CLEAN_H_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          A_OUT_ENABLE <= '0';

          -- FSM Control
          if (data_vector_tanh_enable_int = '1') then
            controller_h_out_fsm_int <= OUTPUT_H_OUT_L_STATE;
          end if;

        when OUTPUT_H_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_h_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            READY <= '1';

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
          else
            -- Control Internal
            index_l_h_out_loop <= std_logic_vector(unsigned(index_l_h_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

          -- Data Outputs
          A_OUT <= vector_eleven_operation_int(to_integer(unsigned(index_l_h_out_loop)));

          -- Control Outputs
          A_OUT_ENABLE <= '1';

        when others =>
          -- FSM Control
          controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  first_vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_first_vector_float_adder,
      READY => ready_first_vector_float_adder,

      OPERATION => operation_first_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_first_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_first_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_first_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_first_vector_float_adder,
      DATA_A_IN => data_a_in_first_vector_float_adder,
      DATA_B_IN => data_b_in_first_vector_float_adder,
      DATA_OUT  => data_out_first_vector_float_adder
      );

  second_vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_second_vector_float_adder,
      READY => ready_second_vector_float_adder,

      OPERATION => operation_second_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_second_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_second_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_second_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_second_vector_float_adder,
      DATA_A_IN => data_a_in_second_vector_float_adder,
      DATA_B_IN => data_b_in_second_vector_float_adder,
      DATA_OUT  => data_out_second_vector_float_adder
      );

  third_vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_third_vector_float_adder,
      READY => ready_third_vector_float_adder,

      OPERATION => operation_third_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_third_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_third_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_third_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_third_vector_float_adder,
      DATA_A_IN => data_a_in_third_vector_float_adder,
      DATA_B_IN => data_b_in_third_vector_float_adder,
      DATA_OUT  => data_out_third_vector_float_adder
      );

  fourth_vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_fourth_vector_float_adder,
      READY => ready_fourth_vector_float_adder,

      OPERATION => operation_fourth_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_fourth_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_fourth_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_fourth_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_fourth_vector_float_adder,
      DATA_A_IN => data_a_in_fourth_vector_float_adder,
      DATA_B_IN => data_b_in_fourth_vector_float_adder,
      DATA_OUT  => data_out_fourth_vector_float_adder
      );

  fiveth_vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_fiveth_vector_float_adder,
      READY => ready_fiveth_vector_float_adder,

      OPERATION => operation_fiveth_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_fiveth_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_fiveth_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_fiveth_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_fiveth_vector_float_adder,
      DATA_A_IN => data_a_in_fiveth_vector_float_adder,
      DATA_B_IN => data_b_in_fiveth_vector_float_adder,
      DATA_OUT  => data_out_fiveth_vector_float_adder
      );

  -- VECTOR SUMMATION
  first_vector_summation : accelerator_vector_summation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_first_vector_summation,
      READY => ready_first_vector_summation,

      DATA_IN_ENABLE        => data_in_enable_first_vector_summation,
      DATA_IN_LENGTH_ENABLE => data_in_length_enable_first_vector_summation,

      DATA_ENABLE        => data_enable_first_vector_summation,
      DATA_LENGTH_ENABLE => data_length_enable_first_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_first_vector_summation,

      -- DATA
      SIZE_IN   => size_in_first_vector_summation,
      LENGTH_IN => length_in_first_vector_summation,
      DATA_IN   => data_in_first_vector_summation,
      DATA_OUT  => data_out_first_vector_summation
      );

  second_vector_summation : accelerator_vector_summation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_second_vector_summation,
      READY => ready_second_vector_summation,

      DATA_IN_ENABLE        => data_in_enable_second_vector_summation,
      DATA_IN_LENGTH_ENABLE => data_in_length_enable_second_vector_summation,

      DATA_ENABLE        => data_enable_second_vector_summation,
      DATA_LENGTH_ENABLE => data_length_enable_second_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_second_vector_summation,

      -- DATA
      SIZE_IN   => size_in_second_vector_summation,
      LENGTH_IN => length_in_second_vector_summation,
      DATA_IN   => data_in_second_vector_summation,
      DATA_OUT  => data_out_second_vector_summation
      );

  -- TENSOR MATRIX CONVOLUTION
  first_tensor_matrix_convolution : accelerator_tensor_matrix_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_first_tensor_matrix_convolution,
      READY => ready_first_tensor_matrix_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_first_tensor_matrix_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_first_tensor_matrix_convolution,
      DATA_A_IN_K_ENABLE => data_a_in_k_enable_first_tensor_matrix_convolution,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_first_tensor_matrix_convolution,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_first_tensor_matrix_convolution,

      DATA_I_ENABLE => data_i_enable_first_tensor_matrix_convolution,
      DATA_J_ENABLE => data_j_enable_first_tensor_matrix_convolution,
      DATA_K_ENABLE => data_k_enable_first_tensor_matrix_convolution,

      DATA_OUT_I_ENABLE => data_out_i_enable_first_tensor_matrix_convolution,
      DATA_OUT_J_ENABLE => data_out_j_enable_first_tensor_matrix_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_first_tensor_matrix_convolution,
      SIZE_A_J_IN => size_a_j_in_first_tensor_matrix_convolution,
      SIZE_A_K_IN => size_a_k_in_first_tensor_matrix_convolution,
      SIZE_B_I_IN => size_b_i_in_first_tensor_matrix_convolution,
      SIZE_B_J_IN => size_b_j_in_first_tensor_matrix_convolution,
      DATA_A_IN   => data_a_in_first_tensor_matrix_convolution,
      DATA_B_IN   => data_b_in_first_tensor_matrix_convolution,
      DATA_OUT    => data_out_first_tensor_matrix_convolution
      );

  second_tensor_matrix_convolution : accelerator_tensor_matrix_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_second_tensor_matrix_convolution,
      READY => ready_second_tensor_matrix_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_second_tensor_matrix_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_second_tensor_matrix_convolution,
      DATA_A_IN_K_ENABLE => data_a_in_k_enable_second_tensor_matrix_convolution,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_second_tensor_matrix_convolution,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_second_tensor_matrix_convolution,

      DATA_I_ENABLE => data_i_enable_second_tensor_matrix_convolution,
      DATA_J_ENABLE => data_j_enable_second_tensor_matrix_convolution,
      DATA_K_ENABLE => data_k_enable_second_tensor_matrix_convolution,

      DATA_OUT_I_ENABLE => data_out_i_enable_second_tensor_matrix_convolution,
      DATA_OUT_J_ENABLE => data_out_j_enable_second_tensor_matrix_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_second_tensor_matrix_convolution,
      SIZE_A_J_IN => size_a_j_in_second_tensor_matrix_convolution,
      SIZE_A_K_IN => size_a_k_in_second_tensor_matrix_convolution,
      SIZE_B_I_IN => size_b_i_in_second_tensor_matrix_convolution,
      SIZE_B_J_IN => size_b_j_in_second_tensor_matrix_convolution,
      DATA_A_IN   => data_a_in_second_tensor_matrix_convolution,
      DATA_B_IN   => data_b_in_second_tensor_matrix_convolution,
      DATA_OUT    => data_out_second_tensor_matrix_convolution
      );

  -- MATRIX VECTOR CONVOLUTION
  first_matrix_vector_convolution : accelerator_matrix_vector_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_first_matrix_vector_convolution,
      READY => ready_first_matrix_vector_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_first_matrix_vector_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_first_matrix_vector_convolution,
      DATA_B_IN_ENABLE   => data_b_in_enable_first_matrix_vector_convolution,

      DATA_I_ENABLE => data_i_enable_first_matrix_vector_convolution,
      DATA_J_ENABLE => data_j_enable_first_matrix_vector_convolution,

      DATA_OUT_ENABLE => data_out_enable_first_matrix_vector_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_first_matrix_vector_convolution,
      SIZE_A_J_IN => size_a_j_in_first_matrix_vector_convolution,
      SIZE_B_IN   => size_b_in_first_matrix_vector_convolution,
      DATA_A_IN   => data_a_in_first_matrix_vector_convolution,
      DATA_B_IN   => data_b_in_first_matrix_vector_convolution,
      DATA_OUT    => data_out_first_matrix_vector_convolution
      );

  second_matrix_vector_convolution : accelerator_matrix_vector_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_second_matrix_vector_convolution,
      READY => ready_second_matrix_vector_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_second_matrix_vector_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_second_matrix_vector_convolution,
      DATA_B_IN_ENABLE   => data_b_in_enable_second_matrix_vector_convolution,

      DATA_I_ENABLE => data_i_enable_second_matrix_vector_convolution,
      DATA_J_ENABLE => data_j_enable_second_matrix_vector_convolution,

      DATA_OUT_ENABLE => data_out_enable_second_matrix_vector_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_second_matrix_vector_convolution,
      SIZE_A_J_IN => size_a_j_in_second_matrix_vector_convolution,
      SIZE_B_IN   => size_b_in_second_matrix_vector_convolution,
      DATA_A_IN   => data_a_in_second_matrix_vector_convolution,
      DATA_B_IN   => data_b_in_second_matrix_vector_convolution,
      DATA_OUT    => data_out_second_matrix_vector_convolution
      );

  third_matrix_vector_convolution : accelerator_matrix_vector_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_third_matrix_vector_convolution,
      READY => ready_third_matrix_vector_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_third_matrix_vector_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_third_matrix_vector_convolution,
      DATA_B_IN_ENABLE   => data_b_in_enable_third_matrix_vector_convolution,

      DATA_I_ENABLE => data_i_enable_third_matrix_vector_convolution,
      DATA_J_ENABLE => data_j_enable_third_matrix_vector_convolution,

      DATA_OUT_ENABLE => data_out_enable_third_matrix_vector_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_third_matrix_vector_convolution,
      SIZE_A_J_IN => size_a_j_in_third_matrix_vector_convolution,
      SIZE_B_IN   => size_b_in_third_matrix_vector_convolution,
      DATA_A_IN   => data_a_in_third_matrix_vector_convolution,
      DATA_B_IN   => data_b_in_third_matrix_vector_convolution,
      DATA_OUT    => data_out_third_matrix_vector_convolution
      );

  -- VECTOR TANH
  vector_tanh_function : accelerator_vector_tanh_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_tanh,
      READY => ready_vector_tanh,

      DATA_IN_ENABLE => data_in_enable_vector_tanh,

      DATA_OUT_ENABLE => data_out_enable_vector_tanh,

      -- DATA
      SIZE_IN  => size_in_vector_tanh,
      DATA_IN  => data_in_vector_tanh,
      DATA_OUT => data_out_vector_tanh
      );

end architecture;
