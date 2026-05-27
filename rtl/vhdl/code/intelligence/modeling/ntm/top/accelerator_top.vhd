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
use work.accelerator_core_vhdl_pkg.all;
use work.accelerator_lstm_controller_vhdl_pkg.all;

entity accelerator_top is
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

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    V_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    V_IN_S_ENABLE : in std_logic;       -- for s in 0 to S-1

    V_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    V_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1

    D_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    D_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    D_IN_M_ENABLE : in std_logic;       -- for m in 0 to M-1

    D_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    D_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    D_OUT_M_ENABLE : out std_logic;     -- for m in 0 to M-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    P_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    P_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    P_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    P_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    P_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    P_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    Q_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    Q_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    Q_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    Q_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_top_architecture of accelerator_top is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X], X_IN [X]
  -- K_IN [R,L,W]
  -- D_IN [R,L,M]
  -- V_IN [L,S]
  -- U_IN [L,L]
  -- B_IN [L]

  -- P_IN [R,Y,W]
  -- Q_IN [Y,L]

  -- Outputs:
  -- Y_OUT [Y]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_Y_STATE, CLEAN_IN_Y_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE
  -- INPUT_X_STATE, CLEAN_IN_X_STATE

  -- OUTPUT_Y_STATE, CLEAN_OUT_Y_STATE

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

  type controller_p_in_fsm is (
    STARTER_P_IN_STATE,                 -- STEP 0
    INPUT_P_IN_I_STATE,                 -- STEP 1
    INPUT_P_IN_Y_STATE,                 -- STEP 2
    INPUT_P_IN_K_STATE,                 -- STEP 3
    CLEAN_P_IN_I_STATE,                 -- STEP 4
    CLEAN_P_IN_Y_STATE,                 -- STEP 5
    CLEAN_P_IN_K_STATE                  -- STEP 6
    );

  type controller_q_in_fsm is (
    STARTER_Q_IN_STATE,                 -- STEP 0
    INPUT_Q_IN_Y_STATE,                 -- STEP 1
    INPUT_Q_IN_L_STATE,                 -- STEP 2
    CLEAN_Q_IN_Y_STATE,                 -- STEP 3
    CLEAN_Q_IN_L_STATE                  -- STEP 4
    );

  -- Ops
  type controller_tensor_matrix_product_fsm is (
    STARTER_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 0
    INPUT_I_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 1
    INPUT_J_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 2
    INPUT_K_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 3
    CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 4
    CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 5
    CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE   -- STEP 6
    );

  type controller_matrix_vector_product_fsm is (
    STARTER_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  -- Output
  type controller_y_out_fsm is (
    STARTER_Y_OUT_STATE,                -- STEP 0
    CLEAN_Y_OUT_Y_STATE,                -- STEP 1
    OUTPUT_Y_OUT_Y_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Size
  signal SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Finite State Machine
  -- Input
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_k_in_fsm_int : controller_k_in_fsm;
  signal controller_u_in_fsm_int : controller_u_in_fsm;
  signal controller_v_in_fsm_int : controller_v_in_fsm;
  signal controller_d_in_fsm_int : controller_d_in_fsm;
  signal controller_b_in_fsm_int : controller_b_in_fsm;

  signal controller_x_in_fsm_int : controller_x_in_fsm;

  signal controller_p_in_fsm_int : controller_p_in_fsm;
  signal controller_q_in_fsm_int : controller_q_in_fsm;

  -- Ops
  signal controller_tensor_matrix_product_fsm_int : controller_tensor_matrix_product_fsm;
  signal controller_matrix_vector_product_fsm_int : controller_matrix_vector_product_fsm;

  -- Output
  signal controller_y_out_fsm_int : controller_y_out_fsm;

  -- Buffer
  -- Input
  signal matrix_w_in_int : matrix_buffer;
  signal tensor_k_in_int : tensor_buffer;
  signal matrix_u_in_int : matrix_buffer;
  signal matrix_v_in_int : matrix_buffer;
  signal tensor_d_in_int : tensor_buffer;
  signal vector_b_in_int : vector_buffer;

  signal vector_x_in_int : vector_buffer;

  signal tensor_p_in_int : tensor_buffer;
  signal matrix_q_in_int : matrix_buffer;

  -- Ops
  signal tensor_operation_int : tensor_buffer;
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_y_out_int : vector_buffer;

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

  signal index_i_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_y_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_y_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_y_y_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_w_in_enable_int : std_logic;
  signal data_k_in_enable_int : std_logic;
  signal data_u_in_enable_int : std_logic;
  signal data_v_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;

  signal data_x_in_enable_int : std_logic;

  signal data_p_in_enable_int : std_logic;
  signal data_q_in_enable_int : std_logic;

  -- Ops
  signal data_tensor_matrix_product_enable_int : std_logic;
  signal data_matrix_vector_product_enable_int : std_logic;

  ------------------------------------------------------------------------------
  -- CONTROLLER
  ------------------------------------------------------------------------------

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  signal w_in_l_enable_controller : std_logic;
  signal w_in_x_enable_controller : std_logic;

  signal w_out_l_enable_controller : std_logic;
  signal w_out_x_enable_controller : std_logic;

  signal k_in_i_enable_controller : std_logic;
  signal k_in_l_enable_controller : std_logic;
  signal k_in_k_enable_controller : std_logic;

  signal k_out_i_enable_controller : std_logic;
  signal k_out_l_enable_controller : std_logic;
  signal k_out_k_enable_controller : std_logic;

  signal d_in_i_enable_controller : std_logic;
  signal d_in_l_enable_controller : std_logic;
  signal d_in_m_enable_controller : std_logic;

  signal d_out_i_enable_controller : std_logic;
  signal d_out_l_enable_controller : std_logic;
  signal d_out_m_enable_controller : std_logic;

  signal u_in_l_enable_controller : std_logic;
  signal u_in_p_enable_controller : std_logic;

  signal u_out_l_enable_controller : std_logic;
  signal u_out_p_enable_controller : std_logic;

  signal v_in_l_enable_controller : std_logic;
  signal v_in_s_enable_controller : std_logic;

  signal v_out_l_enable_controller : std_logic;
  signal v_out_s_enable_controller : std_logic;

  signal b_in_enable_controller : std_logic;

  signal b_out_enable_controller : std_logic;

  signal x_in_enable_controller : std_logic;

  signal x_out_enable_controller : std_logic;

  signal r_in_i_enable_controller : std_logic;
  signal r_in_k_enable_controller : std_logic;

  signal r_out_i_enable_controller : std_logic;
  signal r_out_k_enable_controller : std_logic;

  signal rho_in_i_enable_controller : std_logic;
  signal rho_in_m_enable_controller : std_logic;

  signal rho_out_i_enable_controller : std_logic;
  signal rho_out_m_enable_controller : std_logic;

  signal xi_in_enable_controller : std_logic;

  signal xi_out_enable_controller : std_logic;

  signal h_in_enable_controller : std_logic;

  signal h_out_enable_controller : std_logic;

  -- DATA
  signal size_x_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_s_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_m_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_controller   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_controller   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rho_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal xi_in_controller  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_controller   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT VECTOR
  -- CONTROL
  signal start_output_vector : std_logic;
  signal ready_output_vector : std_logic;

  signal p_in_i_enable_output_vector : std_logic;
  signal p_in_y_enable_output_vector : std_logic;
  signal p_in_k_enable_output_vector : std_logic;

  signal p_out_i_enable_output_vector : std_logic;
  signal p_out_y_enable_output_vector : std_logic;
  signal p_out_k_enable_output_vector : std_logic;

  signal r_in_i_enable_output_vector : std_logic;
  signal r_in_k_enable_output_vector : std_logic;

  signal r_out_i_enable_output_vector : std_logic;
  signal r_out_k_enable_output_vector : std_logic;

  signal q_in_y_enable_output_vector : std_logic;
  signal q_in_l_enable_output_vector : std_logic;

  signal q_out_y_enable_output_vector : std_logic;
  signal q_out_l_enable_output_vector : std_logic;

  signal h_in_enable_output_vector : std_logic;

  signal h_out_enable_output_vector : std_logic;

  signal y_in_enable_output_vector : std_logic;

  -- DATA
  signal size_y_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal p_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal q_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INTERFACE VECTOR
  -- CONTROL
  signal start_interface_vector : std_logic;
  signal ready_interface_vector : std_logic;

  -- Weight
  signal u_in_s_enable_interface_vector : std_logic;
  signal u_in_l_enable_interface_vector : std_logic;

  signal u_out_s_enable_interface_vector : std_logic;
  signal u_out_l_enable_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_interface_vector : std_logic;

  signal h_out_enable_interface_vector : std_logic;

  -- Interface
  signal xi_out_enable_interface_vector : std_logic;

  -- DATA
  signal size_s_in_interface_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_interface_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal xi_out_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX VECTOR PRODUCT
  -- CONTROL
  signal start_matrix_vector_product : std_logic;
  signal ready_matrix_vector_product : std_logic;

  signal data_a_in_i_enable_matrix_vector_product : std_logic;
  signal data_a_in_j_enable_matrix_vector_product : std_logic;
  signal data_b_in_enable_matrix_vector_product   : std_logic;

  signal data_i_enable_matrix_vector_product : std_logic;
  signal data_j_enable_matrix_vector_product : std_logic;

  signal data_out_enable_matrix_vector_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_matrix_vector_product   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_vector_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_vector_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_vector_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INTERFACE MATRIX
  -- CONTROL
  signal start_interface_matrix : std_logic;
  signal ready_interface_matrix : std_logic;

  -- Weight
  signal u_in_m_enable_interface_matrix : std_logic;
  signal u_in_l_enable_interface_matrix : std_logic;
  signal u_in_i_enable_interface_matrix : std_logic;

  signal u_out_m_enable_interface_matrix : std_logic;
  signal u_out_l_enable_interface_matrix : std_logic;
  signal u_out_i_enable_interface_matrix : std_logic;

  -- Hidden State
  signal h_in_i_enable_interface_matrix : std_logic;
  signal h_in_l_enable_interface_matrix : std_logic;

  signal h_out_i_enable_interface_matrix : std_logic;
  signal h_out_l_enable_interface_matrix : std_logic;

  -- Interface
  signal rho_out_i_enable_interface_matrix : std_logic;
  signal rho_out_m_enable_interface_matrix : std_logic;

  -- DATA
  signal size_m_in_interface_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_interface_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_interface_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_interface_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_interface_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal rho_out_interface_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR MATRIX PRODUCT
  -- CONTROL
  signal start_tensor_matrix_product : std_logic;
  signal ready_tensor_matrix_product : std_logic;

  signal data_a_in_i_enable_tensor_matrix_product : std_logic;
  signal data_a_in_j_enable_tensor_matrix_product : std_logic;
  signal data_a_in_k_enable_tensor_matrix_product : std_logic;
  signal data_b_in_i_enable_tensor_matrix_product : std_logic;
  signal data_b_in_j_enable_tensor_matrix_product : std_logic;

  signal data_i_enable_tensor_matrix_product : std_logic;
  signal data_j_enable_tensor_matrix_product : std_logic;
  signal data_k_enable_tensor_matrix_product : std_logic;

  signal data_out_i_enable_tensor_matrix_product : std_logic;
  signal data_out_j_enable_tensor_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- READ HEADS
  ------------------------------------------------------------------------------

  -- READING
  -- CONTROL
  signal start_reading : std_logic;
  signal ready_reading : std_logic;

  signal m_in_j_enable_reading : std_logic;
  signal m_in_k_enable_reading : std_logic;

  signal w_in_i_enable_reading : std_logic;
  signal w_in_j_enable_reading : std_logic;

  signal m_out_j_enable_reading : std_logic;
  signal m_out_k_enable_reading : std_logic;

  signal w_out_i_enable_reading : std_logic;
  signal w_out_j_enable_reading : std_logic;

  signal r_out_i_enable_reading : std_logic;
  signal r_out_k_enable_reading : std_logic;

  -- DATA
  signal size_r_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_reading  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_reading  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_out_reading : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- WRITE HEADS
  ------------------------------------------------------------------------------

  -- WRITING
  -- CONTROL
  signal start_writing : std_logic;
  signal ready_writing : std_logic;

  signal m_in_j_enable_writing : std_logic;
  signal m_in_k_enable_writing : std_logic;

  signal w_in_i_enable_writing : std_logic;
  signal w_in_j_enable_writing : std_logic;

  signal a_in_enable_writing : std_logic;

  signal w_out_i_enable_writing : std_logic;
  signal w_out_j_enable_writing : std_logic;

  signal a_out_enable_writing : std_logic;

  signal m_out_j_enable_writing : std_logic;
  signal m_out_k_enable_writing : std_logic;

  -- DATA
  signal size_r_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal m_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal a_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_out_writing : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASING
  -- CONTROL
  signal start_erasing : std_logic;
  signal ready_erasing : std_logic;

  signal m_in_j_enable_erasing : std_logic;
  signal m_in_k_enable_erasing : std_logic;

  signal w_in_i_enable_erasing : std_logic;
  signal w_in_j_enable_erasing : std_logic;

  signal e_in_enable_erasing : std_logic;

  signal w_out_i_enable_erasing : std_logic;
  signal w_out_j_enable_erasing : std_logic;

  signal e_out_enable_erasing : std_logic;

  signal m_out_j_enable_erasing : std_logic;
  signal m_out_k_enable_erasing : std_logic;

  -- DATA
  signal size_r_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal m_in_erasing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_erasing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_erasing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_out_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- MEMORY
  ------------------------------------------------------------------------------

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_in_i_enable_addressing : std_logic;
  signal k_in_k_enable_addressing : std_logic;

  signal beta_in_enable_addressing : std_logic;

  signal g_in_enable_addressing : std_logic;

  signal s_in_i_enable_addressing : std_logic;
  signal s_in_j_enable_addressing : std_logic;

  signal gamma_in_enable_addressing : std_logic;

  signal k_out_i_enable_addressing : std_logic;
  signal k_out_k_enable_addressing : std_logic;

  signal beta_out_enable_addressing : std_logic;

  signal g_out_enable_addressing : std_logic;

  signal s_out_i_enable_addressing : std_logic;
  signal s_out_j_enable_addressing : std_logic;

  signal gamma_out_enable_addressing : std_logic;

  signal m_in_j_enable_addressing : std_logic;
  signal m_in_k_enable_addressing : std_logic;

  signal m_out_j_enable_addressing : std_logic;
  signal m_out_k_enable_addressing : std_logic;

  signal w_in_i_enable_addressing : std_logic;
  signal w_in_j_enable_addressing : std_logic;

  signal w_out_i_enable_addressing : std_logic;
  signal w_out_j_enable_addressing : std_logic;

  -- DATA
  signal size_r_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal g_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- SIZE
  -- ARITHMETIC M: [RHO] = N + W + 3
  SIZE_M_IN <= std_logic_vector(unsigned(SIZE_N_IN) + unsigned(SIZE_W_IN) + to_unsigned(3, CONTROL_SIZE));

  -- ARITHMETIC S: [XI] = 2·W
  SIZE_S_IN <= std_logic_vector(unsigned(SIZE_W_IN) + unsigned(SIZE_W_IN));

  -- CONTROL
  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_X_ENABLE <= '0';
      W_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_x_w_in_loop <= ZERO_CONTROL;
      index_l_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= ZERO_CONTROL;
            index_l_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          else
            -- Control Outputs
            W_OUT_X_ENABLE <= '0';
            W_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_W_IN_X_STATE =>      -- STEP 1

          if ((W_IN_X_ENABLE = '1') and (W_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_x_w_in_loop)), to_integer(unsigned(index_l_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
          end if;

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';
          W_OUT_L_ENABLE <= '0';

        when INPUT_W_IN_L_STATE =>      -- STEP 2

          if (W_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_x_w_in_loop)), to_integer(unsigned(index_l_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_L_ENABLE <= '0';

        when CLEAN_W_IN_X_STATE =>      -- STEP 3

          if ((unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= ZERO_CONTROL;
            index_l_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_x_w_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= std_logic_vector(unsigned(index_x_w_in_loop) + unsigned(ONE_CONTROL));
            index_l_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          end if;

        when CLEAN_W_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_w_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= std_logic_vector(unsigned(index_l_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_L_STATE;
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
            controller_k_in_fsm_int <= INPUT_K_IN_L_STATE;
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
            controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
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
            if (unsigned(index_k_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
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
            controller_d_in_fsm_int <= INPUT_D_IN_L_STATE;
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
            controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
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
            if (unsigned(index_m_d_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
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
            if ((unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            elsif (unsigned(index_m_d_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
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

  p_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      P_OUT_I_ENABLE <= '0';
      P_OUT_Y_ENABLE <= '0';
      P_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_p_in_loop <= ZERO_CONTROL;
      index_y_p_in_loop <= ZERO_CONTROL;
      index_k_p_in_loop <= ZERO_CONTROL;

      data_p_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_p_in_fsm_int is
        when STARTER_P_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= ZERO_CONTROL;
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            data_p_in_enable_int <= '0';

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_Y_STATE;
          else
            -- Control Outputs
            P_OUT_I_ENABLE <= '0';
            P_OUT_Y_ENABLE <= '0';
            P_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_P_IN_I_STATE =>      -- STEP 1

          if ((P_IN_I_ENABLE = '1') and (P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
          end if;

          -- Control Outputs
          P_OUT_I_ENABLE <= '0';
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_P_IN_Y_STATE =>      -- STEP 2

          if ((P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            if (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
            else
              controller_p_in_fsm_int <= CLEAN_P_IN_Y_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_P_IN_K_STATE =>      -- STEP 3

          if (P_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            if ((unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
            elsif (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_p_in_fsm_int <= CLEAN_P_IN_Y_STATE;
            else
              controller_p_in_fsm_int <= CLEAN_P_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_K_ENABLE <= '0';

        when CLEAN_P_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_p_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= ZERO_CONTROL;
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            data_p_in_enable_int <= '1';

            -- FSM Control
            controller_p_in_fsm_int <= STARTER_P_IN_STATE;
          elsif ((unsigned(index_i_p_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= std_logic_vector(unsigned(index_i_p_in_loop) + unsigned(ONE_CONTROL));
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_I_STATE;
          end if;

        when CLEAN_P_IN_Y_STATE =>      -- STEP 3

          if ((unsigned(index_y_p_in_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_y_p_in_loop <= std_logic_vector(unsigned(index_y_p_in_loop) + unsigned(ONE_CONTROL));
            index_k_p_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_Y_STATE;
          end if;

        when CLEAN_P_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_p_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_p_in_loop <= std_logic_vector(unsigned(index_k_p_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_p_in_fsm_int <= STARTER_P_IN_STATE;
      end case;
    end if;
  end process;

  q_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      Q_OUT_Y_ENABLE <= '0';
      Q_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_y_q_in_loop <= ZERO_CONTROL;
      index_l_q_in_loop <= ZERO_CONTROL;

      data_q_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_q_in_fsm_int is
        when STARTER_Q_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= ZERO_CONTROL;
            index_l_q_in_loop <= ZERO_CONTROL;

            data_q_in_enable_int <= '0';

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_Y_STATE;
          else
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '0';
            Q_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_Q_IN_Y_STATE =>      -- STEP 1

          if ((Q_IN_Y_ENABLE = '1') and (Q_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_q_in_int(to_integer(unsigned(index_y_q_in_loop)), to_integer(unsigned(index_l_q_in_loop))) <= Q_IN;

            -- FSM Control
            controller_q_in_fsm_int <= CLEAN_Q_IN_L_STATE;
          end if;

          -- Control Outputs
          Q_OUT_Y_ENABLE <= '0';
          Q_OUT_L_ENABLE <= '0';

        when INPUT_Q_IN_L_STATE =>      -- STEP 2

          if (Q_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_q_in_int(to_integer(unsigned(index_y_q_in_loop)), to_integer(unsigned(index_l_q_in_loop))) <= Q_IN;

            -- FSM Control
            if (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_q_in_fsm_int <= CLEAN_Q_IN_Y_STATE;
            else
              controller_q_in_fsm_int <= CLEAN_Q_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          Q_OUT_L_ENABLE <= '0';

        when CLEAN_Q_IN_Y_STATE =>      -- STEP 3

          if ((unsigned(index_y_q_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= ZERO_CONTROL;
            index_l_q_in_loop <= ZERO_CONTROL;

            data_q_in_enable_int <= '1';

            -- FSM Control
            controller_q_in_fsm_int <= STARTER_Q_IN_STATE;
          elsif ((unsigned(index_y_q_in_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= std_logic_vector(unsigned(index_y_q_in_loop) + unsigned(ONE_CONTROL));
            index_l_q_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_Y_STATE;
          end if;

        when CLEAN_Q_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_q_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_q_in_loop <= std_logic_vector(unsigned(index_l_q_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_q_in_fsm_int <= STARTER_Q_IN_STATE;
      end case;
    end if;
  end process;

  -- INTERFACE_VECTOR_STATE

  -- xi(t;s) = U(s;l)·h(t;l)
  matrix_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_vector_product <= '0';
      data_a_in_j_enable_matrix_vector_product <= '0';
      data_b_in_enable_matrix_vector_product   <= '0';

      data_matrix_vector_product_enable_int <= '0';

      index_i_matrix_vector_product_loop <= ZERO_CONTROL;
      index_j_matrix_vector_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_vector_product_fsm_int is
        when STARTER_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_vector_product <= '0';
          data_a_in_j_enable_matrix_vector_product <= '0';
          data_b_in_enable_matrix_vector_product   <= '0';

          data_matrix_vector_product_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_vector_product <= SIZE_L_IN;
            size_a_j_in_matrix_vector_product <= SIZE_R_IN;
            size_b_in_matrix_vector_product   <= SIZE_L_IN;

            -- Control Internal
            index_i_matrix_vector_product_loop <= ZERO_CONTROL;
            index_j_matrix_vector_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_vector_product_fsm_int <= INPUT_I_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when INPUT_I_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_vector_product <= matrix_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
          data_b_in_matrix_vector_product <= vector_operation_int(to_integer(unsigned(index_j_matrix_vector_product_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_vector_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_vector_product_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_vector_product <= '1';
          end if;

          data_a_in_i_enable_matrix_vector_product <= '1';
          data_a_in_j_enable_matrix_vector_product <= '1';
          data_b_in_enable_matrix_vector_product   <= '1';

          -- FSM Control
          controller_matrix_vector_product_fsm_int <= CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE;

        when INPUT_J_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_vector_product <= matrix_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
          data_b_in_matrix_vector_product <= vector_operation_int(to_integer(unsigned(index_j_matrix_vector_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_vector_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_vector_product_fsm_int <= CLEAN_I_MATRIX_VECTOR_PRODUCT_STATE;
          else
            controller_matrix_vector_product_fsm_int <= CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              data_matrix_vector_product_enable_int <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_vector_product_fsm_int <= STARTER_MATRIX_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              index_i_matrix_vector_product_loop <= std_logic_vector(unsigned(index_i_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_vector_product_fsm_int <= INPUT_I_MATRIX_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';

            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

        when CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 8

          if (data_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_j_matrix_vector_product_loop <= std_logic_vector(unsigned(index_j_matrix_vector_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_vector_product_fsm_int <= INPUT_I_MATRIX_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';

            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_matrix_vector_product_fsm_int <= STARTER_MATRIX_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

  -- INTERFACE_MATRIX_STATE

  -- rho(t;i;m) = U(i;m;l)·h(t;i;l)
  tensor_matrix_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_tensor_matrix_product <= '0';
      data_a_in_j_enable_tensor_matrix_product <= '0';
      data_a_in_k_enable_tensor_matrix_product <= '0';
      data_b_in_i_enable_tensor_matrix_product <= '0';
      data_b_in_j_enable_tensor_matrix_product <= '0';

      data_tensor_matrix_product_enable_int <= '0';

      index_i_tensor_matrix_product_loop <= ZERO_CONTROL;
      index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
      index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_tensor_matrix_product_fsm_int is
        when STARTER_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_tensor_matrix_product <= '0';
          data_a_in_j_enable_tensor_matrix_product <= '0';
          data_a_in_k_enable_tensor_matrix_product <= '0';
          data_b_in_i_enable_tensor_matrix_product <= '0';
          data_b_in_j_enable_tensor_matrix_product <= '0';

          data_tensor_matrix_product_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_tensor_matrix_product <= SIZE_R_IN;
            size_a_j_in_tensor_matrix_product <= SIZE_L_IN;
            size_a_k_in_tensor_matrix_product <= SIZE_W_IN;
            size_b_i_in_tensor_matrix_product <= SIZE_R_IN;
            size_b_j_in_tensor_matrix_product <= SIZE_L_IN;

            -- Control Internal
            index_i_tensor_matrix_product_loop <= ZERO_CONTROL;
            index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
            index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_tensor_matrix_product_fsm_int <= INPUT_I_TENSOR_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_I_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

          -- Control Internal
          if (unsigned(index_i_tensor_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_tensor_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_tensor_matrix_product_loop) = unsigned(ZERO_CONTROL)) then
            start_tensor_matrix_product <= '1';
          end if;

          data_a_in_i_enable_tensor_matrix_product <= '1';
          data_a_in_j_enable_tensor_matrix_product <= '1';
          data_a_in_k_enable_tensor_matrix_product <= '1';
          data_b_in_i_enable_tensor_matrix_product <= '1';
          data_b_in_j_enable_tensor_matrix_product <= '1';

          -- FSM Control
          controller_tensor_matrix_product_fsm_int <= CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE;

        when INPUT_J_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

          data_a_in_j_enable_tensor_matrix_product <= '1';
          data_a_in_k_enable_tensor_matrix_product <= '1';
          data_b_in_j_enable_tensor_matrix_product <= '1';

          -- FSM Control
          if (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_tensor_matrix_product_fsm_int <= CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE;
          else
            controller_tensor_matrix_product_fsm_int <= CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_K_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

          -- Control Internal
          data_a_in_k_enable_tensor_matrix_product <= '1';

          -- FSM Control
          if ((unsigned(index_j_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            controller_tensor_matrix_product_fsm_int <= CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE;
          elsif (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_tensor_matrix_product_fsm_int <= CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE;
          else
            controller_tensor_matrix_product_fsm_int <= CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE;
          end if;

        when CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_tensor_matrix_product = '1' and data_j_enable_tensor_matrix_product = '1' and data_k_enable_tensor_matrix_product = '1') then
            if ((unsigned(index_j_tensor_matrix_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              data_tensor_matrix_product_enable_int <= '1';

              index_i_tensor_matrix_product_loop <= ZERO_CONTROL;
              index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
              index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= STARTER_TENSOR_MATRIX_PRODUCT_STATE;
            elsif ((unsigned(index_j_tensor_matrix_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              index_i_tensor_matrix_product_loop <= std_logic_vector(unsigned(index_i_tensor_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
              index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= INPUT_J_TENSOR_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_tensor_matrix_product <= '0';

            data_a_in_i_enable_tensor_matrix_product <= '0';
            data_a_in_j_enable_tensor_matrix_product <= '0';
            data_a_in_k_enable_tensor_matrix_product <= '0';
            data_b_in_i_enable_tensor_matrix_product <= '0';
            data_b_in_j_enable_tensor_matrix_product <= '0';
          end if;

        when CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_j_enable_tensor_matrix_product = '1' and data_k_enable_tensor_matrix_product = '1') then
            if ((unsigned(index_j_tensor_matrix_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              index_j_tensor_matrix_product_loop <= std_logic_vector(unsigned(index_j_tensor_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= INPUT_J_TENSOR_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_tensor_matrix_product <= '0';

            data_a_in_i_enable_tensor_matrix_product <= '0';
            data_a_in_j_enable_tensor_matrix_product <= '0';
            data_a_in_k_enable_tensor_matrix_product <= '0';
            data_b_in_i_enable_tensor_matrix_product <= '0';
            data_b_in_j_enable_tensor_matrix_product <= '0';
          end if;

        when CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 8

          if (data_k_enable_tensor_matrix_product = '1') then
            if (unsigned(index_k_tensor_matrix_product_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              index_k_tensor_matrix_product_loop <= std_logic_vector(unsigned(index_k_tensor_matrix_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= INPUT_J_TENSOR_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_tensor_matrix_product <= '0';

            data_a_in_i_enable_tensor_matrix_product <= '0';
            data_a_in_j_enable_tensor_matrix_product <= '0';
            data_a_in_k_enable_tensor_matrix_product <= '0';
            data_b_in_i_enable_tensor_matrix_product <= '0';
            data_b_in_j_enable_tensor_matrix_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_tensor_matrix_product_fsm_int <= STARTER_TENSOR_MATRIX_PRODUCT_STATE;
      end case;
    end if;
  end process;



  -- WRITE_HEADS_STATE

  -- M(t;j;k) = M(t;j;k)·(1 - w(t;i;j)·e(t;k))

  -- M(t;j;k) = M(t;j;k) + w(t;i;j)·a(t;k)

  -- READ_HEADS_STATE

  -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]



  -- MEMORY_STATE

  -- wc(t;i;j) = C(M(t;j;k),k(t;i;k),beta(t;i))
  -- wg(t;i;j) = g(t;i)·wc(t;i;j) + (1 - g(t;i))·w(t-1;i;j)
  -- w(t;i;j) = wg(t;i;j)*s(t;i;k)
  -- w(t;i;j) = exponentiation(w(t;i;j),gamma(t;i)) / summation(exponentiation(w(t;i;j),gamma(t;i)))[j in 0 to N-1]



  -- CONTROLLER_BODY_STATE

  -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
  -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))



  -- OUTPUT_VECTOR_STATE

  -- y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)
  y_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      Y_OUT_ENABLE <= '0';

      -- Control Internal
      index_y_y_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_y_out_fsm_int is
        when STARTER_Y_OUT_STATE =>     -- STEP 0
          if (data_w_in_enable_int = '1' and data_k_in_enable_int = '1' and data_u_in_enable_int = '1' and data_d_in_enable_int = '1' and data_b_in_enable_int = '1' and data_x_in_enable_int = '1' and data_p_in_enable_int = '1' and data_q_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_y_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_Y_STATE;
          end if;

        when CLEAN_Y_OUT_Y_STATE =>     -- STEP 1
          -- Control Outputs
          Y_OUT_ENABLE <= '0';

          -- FSM Control
          controller_y_out_fsm_int <= OUTPUT_Y_OUT_Y_STATE;

        when OUTPUT_Y_OUT_Y_STATE =>    -- STEP 2

          if (unsigned(index_y_y_out_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_y_out_int(to_integer(unsigned(index_y_y_out_loop)));

            -- Control Outputs
            READY <= '1';

            Y_OUT_ENABLE <= '1';

            -- Control Internal
            index_y_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
          elsif (unsigned(index_y_y_out_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_y_out_int(to_integer(unsigned(index_y_y_out_loop)));

            -- Control Outputs
            Y_OUT_ENABLE <= '1';

            -- Control Internal
            index_y_y_out_loop <= std_logic_vector(unsigned(index_y_y_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_Y_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
      end case;
    end if;
  end process;




  ------------------------------------------------------------------------------
  -- CONTROLLER
  ------------------------------------------------------------------------------

  -- CONTROLLER
  controller : accelerator_controller
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      W_IN_L_ENABLE => w_in_l_enable_controller,
      W_IN_X_ENABLE => w_in_x_enable_controller,

      W_OUT_L_ENABLE => w_out_l_enable_controller,
      W_OUT_X_ENABLE => w_out_x_enable_controller,

      K_IN_I_ENABLE => k_in_i_enable_controller,
      K_IN_L_ENABLE => k_in_l_enable_controller,
      K_IN_K_ENABLE => k_in_k_enable_controller,

      K_OUT_I_ENABLE => k_out_i_enable_controller,
      K_OUT_L_ENABLE => k_out_l_enable_controller,
      K_OUT_K_ENABLE => k_out_k_enable_controller,

      D_IN_I_ENABLE => d_in_i_enable_controller,
      D_IN_L_ENABLE => d_in_l_enable_controller,
      D_IN_M_ENABLE => d_in_m_enable_controller,

      D_OUT_I_ENABLE => d_out_i_enable_controller,
      D_OUT_L_ENABLE => d_out_l_enable_controller,
      D_OUT_M_ENABLE => d_out_m_enable_controller,

      U_IN_L_ENABLE => u_in_l_enable_controller,
      U_IN_P_ENABLE => u_in_p_enable_controller,

      U_OUT_L_ENABLE => u_out_l_enable_controller,
      U_OUT_P_ENABLE => u_out_p_enable_controller,

      V_IN_L_ENABLE => v_in_l_enable_controller,
      V_IN_S_ENABLE => v_in_s_enable_controller,

      V_OUT_L_ENABLE => v_out_l_enable_controller,
      V_OUT_S_ENABLE => v_out_s_enable_controller,

      B_IN_ENABLE => b_in_enable_controller,

      B_OUT_ENABLE => b_out_enable_controller,

      X_IN_ENABLE => x_in_enable_controller,

      X_OUT_ENABLE => x_out_enable_controller,

      R_IN_I_ENABLE => r_in_i_enable_controller,
      R_IN_K_ENABLE => r_in_k_enable_controller,

      R_OUT_I_ENABLE => r_out_i_enable_controller,
      R_OUT_K_ENABLE => r_out_k_enable_controller,

      RHO_IN_I_ENABLE => rho_in_i_enable_controller,
      RHO_IN_M_ENABLE => rho_in_m_enable_controller,

      RHO_OUT_I_ENABLE => rho_out_i_enable_controller,
      RHO_OUT_M_ENABLE => rho_out_m_enable_controller,

      XI_IN_ENABLE => xi_in_enable_controller,

      XI_OUT_ENABLE => xi_out_enable_controller,

      H_IN_ENABLE => h_in_enable_controller,

      H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      SIZE_X_IN => size_x_in_controller,
      SIZE_W_IN => size_w_in_controller,
      SIZE_L_IN => size_l_in_controller,
      SIZE_R_IN => size_r_in_controller,
      SIZE_S_IN => size_s_in_controller,
      SIZE_M_IN => size_m_in_controller,

      W_IN => w_in_controller,
      D_IN => d_in_controller,
      K_IN => k_in_controller,
      U_IN => u_in_controller,
      V_IN => v_in_controller,
      B_IN => b_in_controller,

      X_IN   => x_in_controller,
      R_IN   => r_in_controller,
      RHO_IN => rho_in_controller,
      XI_IN  => xi_in_controller,
      H_IN   => h_in_controller,

      W_OUT => w_out_controller,
      D_OUT => d_out_controller,
      K_OUT => k_out_controller,
      U_OUT => u_out_controller,
      V_OUT => v_out_controller,
      B_OUT => b_out_controller,

      H_OUT => h_out_controller
      );

  -- OUTPUT VECTOR
  output_vector : accelerator_output_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_vector,
      READY => ready_output_vector,

      P_IN_I_ENABLE => p_in_i_enable_output_vector,
      P_IN_Y_ENABLE => p_in_y_enable_output_vector,
      P_IN_K_ENABLE => p_in_k_enable_output_vector,

      P_OUT_I_ENABLE => p_out_i_enable_output_vector,
      P_OUT_Y_ENABLE => p_out_y_enable_output_vector,
      P_OUT_K_ENABLE => p_out_k_enable_output_vector,

      R_IN_I_ENABLE => r_in_i_enable_output_vector,
      R_IN_K_ENABLE => r_in_k_enable_output_vector,

      R_OUT_I_ENABLE => r_out_i_enable_output_vector,
      R_OUT_K_ENABLE => r_out_k_enable_output_vector,

      Q_IN_Y_ENABLE => q_in_y_enable_output_vector,
      Q_IN_L_ENABLE => q_in_l_enable_output_vector,

      Q_OUT_Y_ENABLE => q_out_y_enable_output_vector,
      Q_OUT_L_ENABLE => q_out_l_enable_output_vector,

      H_IN_ENABLE => h_in_enable_output_vector,

      H_OUT_ENABLE => h_out_enable_output_vector,

      Y_OUT_ENABLE => y_in_enable_output_vector,

      -- DATA
      SIZE_Y_IN => size_y_in_output_vector,
      SIZE_L_IN => size_l_in_output_vector,
      SIZE_W_IN => size_w_in_output_vector,
      SIZE_R_IN => size_r_in_output_vector,

      P_IN => p_in_output_vector,
      R_IN => r_in_output_vector,

      Q_IN => q_in_output_vector,
      H_IN => h_in_output_vector,

      Y_OUT => y_out_output_vector
      );

  -- INTERFACE VECTOR
  interface_vector : accelerator_interface_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_interface_vector,
      READY => ready_interface_vector,

      -- Weight
      U_IN_S_ENABLE => u_in_s_enable_interface_vector,
      U_IN_L_ENABLE => u_in_l_enable_interface_vector,

      U_OUT_S_ENABLE => u_out_s_enable_interface_vector,
      U_OUT_L_ENABLE => u_out_l_enable_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_interface_vector,

      H_OUT_ENABLE => h_out_enable_interface_vector,

      -- Interface
      XI_OUT_ENABLE => xi_out_enable_interface_vector,

      -- DATA
      SIZE_S_IN => size_s_in_interface_vector,
      SIZE_L_IN => size_l_in_interface_vector,

      U_IN => u_in_interface_vector,

      H_IN => h_in_interface_vector,

      XI_OUT => xi_out_interface_vector
      );

  -- MATRIX VECTOR PRODUCT
  matrix_vector_product : accelerator_matrix_vector_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_vector_product,
      READY => ready_matrix_vector_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_product,
      DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_product,

      DATA_I_ENABLE => data_i_enable_matrix_vector_product,
      DATA_J_ENABLE => data_j_enable_matrix_vector_product,

      DATA_OUT_ENABLE => data_out_enable_matrix_vector_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_vector_product,
      SIZE_A_J_IN => size_a_j_in_matrix_vector_product,
      SIZE_B_IN   => size_b_in_matrix_vector_product,
      DATA_A_IN   => data_a_in_matrix_vector_product,
      DATA_B_IN   => data_b_in_matrix_vector_product,
      DATA_OUT    => data_out_matrix_vector_product
      );

  -- INTERFACE MATRIX
  interface_matrix : accelerator_interface_matrix
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_interface_matrix,
      READY => ready_interface_matrix,

      -- Weight
      U_IN_I_ENABLE => u_in_i_enable_interface_matrix,
      U_IN_M_ENABLE => u_in_m_enable_interface_matrix,
      U_IN_L_ENABLE => u_in_l_enable_interface_matrix,

      U_OUT_I_ENABLE => u_out_i_enable_interface_matrix,
      U_OUT_M_ENABLE => u_out_m_enable_interface_matrix,
      U_OUT_L_ENABLE => u_out_l_enable_interface_matrix,

      -- Hidden State
      H_IN_I_ENABLE => h_in_i_enable_interface_matrix,
      H_IN_L_ENABLE => h_in_l_enable_interface_matrix,

      H_OUT_I_ENABLE => h_out_i_enable_interface_matrix,
      H_OUT_L_ENABLE => h_out_l_enable_interface_matrix,

      -- Interface
      RHO_OUT_I_ENABLE => rho_out_i_enable_interface_matrix,
      RHO_OUT_M_ENABLE => rho_out_m_enable_interface_matrix,

      -- DATA
      SIZE_M_IN => size_m_in_interface_matrix,
      SIZE_R_IN => size_r_in_interface_matrix,
      SIZE_L_IN => size_l_in_interface_matrix,

      U_IN => u_in_interface_matrix,

      H_IN => h_in_interface_matrix,

      RHO_OUT => rho_out_interface_matrix
      );

  -- TENSOR MATRIX PRODUCT
  tensor_matrix_product : accelerator_tensor_matrix_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_tensor_matrix_product,
      READY => ready_tensor_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_product,
      DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_product,

      DATA_I_ENABLE => data_i_enable_tensor_matrix_product,
      DATA_J_ENABLE => data_j_enable_tensor_matrix_product,
      DATA_K_ENABLE => data_k_enable_tensor_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_tensor_matrix_product,
      SIZE_A_J_IN => size_a_j_in_tensor_matrix_product,
      SIZE_A_K_IN => size_a_k_in_tensor_matrix_product,
      SIZE_B_I_IN => size_b_i_in_tensor_matrix_product,
      SIZE_B_J_IN => size_b_j_in_tensor_matrix_product,
      DATA_A_IN   => data_a_in_tensor_matrix_product,
      DATA_B_IN   => data_b_in_tensor_matrix_product,
      DATA_OUT    => data_out_tensor_matrix_product
      );

  ------------------------------------------------------------------------------
  -- READ HEADS
  ------------------------------------------------------------------------------

  -- READING
  reading : accelerator_reading
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_reading,
      READY => ready_reading,

      M_IN_J_ENABLE => m_in_j_enable_reading,
      M_IN_K_ENABLE => m_in_k_enable_reading,

      W_IN_I_ENABLE => w_in_i_enable_reading,
      W_IN_J_ENABLE => w_in_j_enable_reading,

      M_OUT_J_ENABLE => m_out_j_enable_reading,
      M_OUT_K_ENABLE => m_out_k_enable_reading,

      W_OUT_I_ENABLE => w_out_i_enable_reading,
      W_OUT_J_ENABLE => w_out_j_enable_reading,

      R_OUT_I_ENABLE => r_out_i_enable_reading,
      R_OUT_K_ENABLE => r_out_k_enable_reading,

      -- DATA
      SIZE_R_IN => size_r_in_reading,
      SIZE_N_IN => size_n_in_reading,
      SIZE_W_IN => size_w_in_reading,

      W_IN  => w_in_reading,
      M_IN  => m_in_reading,
      R_OUT => r_out_reading
      );

  ------------------------------------------------------------------------------
  -- WRITE HEADS
  ------------------------------------------------------------------------------

  -- WRITING
  writing : accelerator_writing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_writing,
      READY => ready_writing,

      M_IN_J_ENABLE => m_in_j_enable_writing,
      M_IN_K_ENABLE => m_in_k_enable_writing,

      W_IN_I_ENABLE => w_in_i_enable_writing,
      W_IN_J_ENABLE => w_in_j_enable_writing,

      A_IN_ENABLE => a_in_enable_writing,

      W_OUT_I_ENABLE => w_out_i_enable_writing,
      W_OUT_J_ENABLE => w_out_j_enable_writing,

      A_OUT_ENABLE => a_out_enable_writing,

      M_OUT_J_ENABLE => m_out_j_enable_writing,
      M_OUT_K_ENABLE => m_out_k_enable_writing,

      -- DATA
      SIZE_R_IN => size_r_in_writing,
      SIZE_N_IN => size_n_in_writing,
      SIZE_W_IN => size_w_in_writing,

      M_IN  => m_in_writing,
      A_IN  => a_in_writing,
      W_IN  => w_in_writing,
      M_OUT => m_out_writing
      );

  -- ERASING
  erasing : accelerator_erasing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erasing,
      READY => ready_erasing,

      M_IN_J_ENABLE => m_in_j_enable_erasing,
      M_IN_K_ENABLE => m_in_k_enable_erasing,

      W_IN_I_ENABLE => w_in_i_enable_erasing,
      W_IN_J_ENABLE => w_in_j_enable_erasing,

      E_IN_ENABLE => e_in_enable_erasing,

      W_OUT_I_ENABLE => w_out_i_enable_erasing,
      W_OUT_J_ENABLE => w_out_j_enable_erasing,

      E_OUT_ENABLE => e_out_enable_erasing,

      M_OUT_J_ENABLE => m_out_j_enable_erasing,
      M_OUT_K_ENABLE => m_out_k_enable_erasing,

      -- DATA
      SIZE_R_IN => size_r_in_erasing,
      SIZE_N_IN => size_n_in_erasing,
      SIZE_W_IN => size_w_in_erasing,

      M_IN  => m_in_erasing,
      E_IN  => e_in_erasing,
      W_IN  => w_in_erasing,
      M_OUT => m_out_erasing
      );

  ------------------------------------------------------------------------------
  -- MEMORY
  ------------------------------------------------------------------------------

  -- ADDRESSING
  addressing : accelerator_addressing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      K_IN_I_ENABLE => k_in_i_enable_addressing,
      K_IN_K_ENABLE => k_in_k_enable_addressing,

      BETA_IN_ENABLE => beta_in_enable_addressing,

      G_IN_ENABLE => g_in_enable_addressing,

      S_IN_I_ENABLE => s_in_i_enable_addressing,
      S_IN_J_ENABLE => s_in_j_enable_addressing,

      GAMMA_IN_ENABLE => gamma_in_enable_addressing,

      K_OUT_I_ENABLE => k_out_i_enable_addressing,
      K_OUT_K_ENABLE => k_out_k_enable_addressing,

      BETA_OUT_ENABLE => beta_out_enable_addressing,

      G_OUT_ENABLE => g_out_enable_addressing,

      S_OUT_I_ENABLE => s_out_i_enable_addressing,
      S_OUT_J_ENABLE => s_out_j_enable_addressing,

      GAMMA_OUT_ENABLE => gamma_out_enable_addressing,

      M_IN_J_ENABLE => m_in_j_enable_addressing,
      M_IN_K_ENABLE => m_in_k_enable_addressing,

      M_OUT_J_ENABLE => m_out_j_enable_addressing,
      M_OUT_K_ENABLE => m_out_k_enable_addressing,

      W_IN_I_ENABLE => w_in_i_enable_addressing,
      W_IN_J_ENABLE => w_in_j_enable_addressing,

      W_OUT_I_ENABLE => w_out_i_enable_addressing,
      W_OUT_J_ENABLE => w_out_j_enable_addressing,

      -- DATA
      SIZE_R_IN => size_r_in_addressing,
      SIZE_N_IN => size_n_in_addressing,
      SIZE_W_IN => size_w_in_addressing,

      K_IN     => k_in_addressing,
      BETA_IN  => beta_in_addressing,
      G_IN     => g_in_addressing,
      S_IN     => s_in_addressing,
      GAMMA_IN => gamma_in_addressing,

      M_IN => m_in_addressing,

      W_IN  => w_in_addressing,
      W_OUT => w_out_addressing
      );

end architecture;
