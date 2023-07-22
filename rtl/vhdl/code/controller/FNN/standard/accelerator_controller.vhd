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
use work.accelerator_fnn_controller_pkg.all;

entity accelerator_controller is
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

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_controller_architecture of accelerator_controller is

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
  -- H_OUT [L]

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
  type controller_first_matrix_vector_product_fsm is (
    STARTER_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_tensor_matrix_product_fsm is (
    STARTER_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 0
    INPUT_I_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 1
    INPUT_J_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 2
    INPUT_K_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 3
    CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 4
    CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 5
    CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE   -- STEP 6
    );

  type controller_vector_summation_fsm is (
    STARTER_VECTOR_SUMMATION_STATE,       -- STEP 0
    INPUT_LENGTH_VECTOR_SUMMATION_STATE,  -- STEP 1
    INPUT_VECTOR_SUMMATION_STATE,         -- STEP 2
    CLEAN_LENGTH_VECTOR_SUMMATION_STATE,  -- STEP 3
    CLEAN_VECTOR_SUMMATION_STATE          -- STEP 4
    );

  type controller_first_vector_float_adder_fsm is (
    STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_FIRST_VECTOR_FLOAT_ADDER_STATE,    -- STEP 1
    CLEAN_FIRST_VECTOR_FLOAT_ADDER_STATE     -- STEP 2
    );

  type controller_second_matrix_vector_product_fsm is (
    STARTER_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_second_vector_float_adder_fsm is (
    STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_SECOND_VECTOR_FLOAT_ADDER_STATE,    -- STEP 2
    CLEAN_SECOND_VECTOR_FLOAT_ADDER_STATE     -- STEP 4
    );

  type controller_vector_logistic_fsm is (
    STARTER_VECTOR_LOGISTIC_STATE,      -- STEP 0
    INPUT_VECTOR_LOGISTIC_STATE,        -- STEP 2
    CLEAN_VECTOR_LOGISTIC_STATE         -- STEP 4
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
  signal controller_first_matrix_vector_product_fsm_int  : controller_first_matrix_vector_product_fsm;
  signal controller_tensor_matrix_product_fsm_int        : controller_tensor_matrix_product_fsm;
  signal controller_vector_summation_fsm_int             : controller_vector_summation_fsm;
  signal controller_first_vector_float_adder_fsm_int     : controller_first_vector_float_adder_fsm;
  signal controller_second_matrix_vector_product_fsm_int : controller_second_matrix_vector_product_fsm;
  signal controller_second_vector_float_adder_fsm_int    : controller_second_vector_float_adder_fsm;
  signal controller_vector_logistic_fsm_int              : controller_vector_logistic_fsm;

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
  signal tensor_operation_int : tensor_buffer;
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_h_out_int : vector_buffer;

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
  signal index_i_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_length_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_summation_loop        : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_logistic_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal data_first_matrix_vector_product_enable_int  : std_logic;
  signal data_tensor_matrix_product_enable_int        : std_logic;
  signal data_vector_summation_enable_int             : std_logic;
  signal data_first_vector_float_adder_enable_int     : std_logic;
  signal data_second_matrix_vector_product_enable_int : std_logic;
  signal data_second_vector_float_adder_enable_int    : std_logic;
  signal data_vector_logistic_enable_int              : std_logic;

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_float_adder : std_logic;
  signal ready_vector_float_adder : std_logic;

  signal operation_vector_float_adder : std_logic;

  signal data_a_in_enable_vector_float_adder : std_logic;
  signal data_b_in_enable_vector_float_adder : std_logic;

  signal data_out_enable_vector_float_adder : std_logic;

  -- DATA
  signal size_in_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal size_in_vector_logistic  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(l))

  -- INPUT CONTROL
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
            if (unsigned(index_m_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
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
  first_matrix_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_vector_product <= '0';
      data_a_in_j_enable_matrix_vector_product <= '0';
      data_b_in_enable_matrix_vector_product   <= '0';

      data_first_matrix_vector_product_enable_int <= '0';

      index_i_matrix_vector_product_loop <= ZERO_CONTROL;
      index_j_matrix_vector_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_first_matrix_vector_product_fsm_int is
        when STARTER_FIRST_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_vector_product <= '0';
          data_a_in_j_enable_matrix_vector_product <= '0';
          data_b_in_enable_matrix_vector_product   <= '0';

          data_first_matrix_vector_product_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_vector_product <= SIZE_L_IN;
            size_a_j_in_matrix_vector_product <= SIZE_X_IN;
            size_b_in_matrix_vector_product   <= SIZE_L_IN;

            -- Control Internal
            index_i_matrix_vector_product_loop <= ZERO_CONTROL;
            index_j_matrix_vector_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_first_matrix_vector_product_fsm_int <= INPUT_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when INPUT_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 5

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
          controller_first_matrix_vector_product_fsm_int <= CLEAN_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE;

        when INPUT_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_vector_product <= matrix_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
          data_b_in_matrix_vector_product <= vector_operation_int(to_integer(unsigned(index_j_matrix_vector_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_vector_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            controller_first_matrix_vector_product_fsm_int <= CLEAN_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
          else
            controller_first_matrix_vector_product_fsm_int <= CLEAN_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              data_first_matrix_vector_product_enable_int <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_vector_product_fsm_int <= STARTER_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              index_i_matrix_vector_product_loop <= std_logic_vector(unsigned(index_i_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_vector_product_fsm_int <= INPUT_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';

            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

        when CLEAN_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 8

          if (data_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_j_matrix_vector_product_loop <= std_logic_vector(unsigned(index_j_matrix_vector_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_first_matrix_vector_product_fsm_int <= INPUT_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
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
          controller_first_matrix_vector_product_fsm_int <= STARTER_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

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

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
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
          data_a_in_tensor_matrix_product <= tensor_d_in_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_k_in_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

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
          data_a_in_tensor_matrix_product <= tensor_d_in_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_k_in_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

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
          data_a_in_tensor_matrix_product <= tensor_d_in_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_k_in_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

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

  vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_length_enable_vector_summation <= '0';
      data_in_enable_vector_summation        <= '0';

      data_vector_summation_enable_int <= '0';

      index_length_vector_summation_loop <= ZERO_CONTROL;
      index_vector_summation_loop        <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_summation_fsm_int is
        when STARTER_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_length_enable_vector_summation <= '0';
          data_in_enable_vector_summation        <= '0';

          data_vector_summation_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_r_in_enable_int = '1') then
            -- Data Inputs
            length_in_vector_summation <= SIZE_L_IN;
            size_in_vector_summation   <= SIZE_R_IN;

            -- Control Internal
            index_length_vector_summation_loop <= ZERO_CONTROL;
            index_vector_summation_loop        <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_summation_fsm_int <= INPUT_LENGTH_VECTOR_SUMMATION_STATE;
          end if;

        when INPUT_LENGTH_VECTOR_SUMMATION_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_length_vector_summation_loop)), to_integer(unsigned(index_vector_summation_loop)));

          -- Control Internal
          if (unsigned(index_length_vector_summation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_summation_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_summation <= '1';
          end if;

          data_in_length_enable_vector_summation <= '1';
          data_in_enable_vector_summation        <= '1';

          -- FSM Control
          controller_vector_summation_fsm_int <= CLEAN_VECTOR_SUMMATION_STATE;

        when INPUT_VECTOR_SUMMATION_STATE =>  -- STEP 6

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_length_vector_summation_loop)), to_integer(unsigned(index_vector_summation_loop)));

          -- Control Internal
          data_in_enable_vector_summation <= '1';

          -- FSM Control
          if (unsigned(index_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            controller_vector_summation_fsm_int <= CLEAN_LENGTH_VECTOR_SUMMATION_STATE;
          else
            controller_vector_summation_fsm_int <= CLEAN_VECTOR_SUMMATION_STATE;
          end if;

        when CLEAN_LENGTH_VECTOR_SUMMATION_STATE =>  -- STEP 7

          if (data_enable_length_vector_summation = '1' and data_enable_vector_summation = '1') then
            if ((unsigned(index_length_vector_summation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_length_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              data_vector_summation_enable_int <= '1';

              index_length_vector_summation_loop <= ZERO_CONTROL;
              index_vector_summation_loop        <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
            elsif ((unsigned(index_length_vector_summation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_length_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              index_length_vector_summation_loop <= std_logic_vector(unsigned(index_length_vector_summation_loop) + unsigned(ONE_CONTROL));
              index_vector_summation_loop        <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_LENGTH_VECTOR_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_length_enable_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when CLEAN_VECTOR_SUMMATION_STATE =>  -- STEP 8

          if (data_enable_length_vector_summation = '1') then
            if (unsigned(index_vector_summation_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_vector_summation_loop <= std_logic_vector(unsigned(index_vector_summation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_LENGTH_VECTOR_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_length_enable_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  first_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_first_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_first_vector_float_adder_fsm_int is
        when STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          data_first_vector_float_adder_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_x_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_L_IN;

            -- Control Internal
            index_vector_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_first_vector_float_adder_fsm_int <= INPUT_FIRST_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when INPUT_FIRST_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
          data_b_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_adder <= '1';
          end if;

          data_a_in_enable_vector_float_adder <= '1';
          data_b_in_enable_vector_float_adder <= '1';

          -- FSM Control
          controller_first_vector_float_adder_fsm_int <= CLEAN_FIRST_VECTOR_FLOAT_ADDER_STATE;

        when CLEAN_FIRST_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_first_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_vector_float_adder_fsm_int <= STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_first_vector_float_adder_fsm_int <= INPUT_FIRST_VECTOR_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_first_vector_float_adder_fsm_int <= STARTER_FIRST_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  second_matrix_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_vector_product <= '0';
      data_a_in_j_enable_matrix_vector_product <= '0';
      data_b_in_enable_matrix_vector_product   <= '0';

      data_second_matrix_vector_product_enable_int <= '0';

      index_i_matrix_vector_product_loop <= ZERO_CONTROL;
      index_j_matrix_vector_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_second_matrix_vector_product_fsm_int is
        when STARTER_SECOND_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_vector_product <= '0';
          data_a_in_j_enable_matrix_vector_product <= '0';
          data_b_in_enable_matrix_vector_product   <= '0';

          data_second_matrix_vector_product_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_vector_product <= SIZE_L_IN;
            size_a_j_in_matrix_vector_product <= SIZE_X_IN;
            size_b_in_matrix_vector_product   <= SIZE_L_IN;

            -- Control Internal
            index_i_matrix_vector_product_loop <= ZERO_CONTROL;
            index_j_matrix_vector_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_second_matrix_vector_product_fsm_int <= INPUT_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when INPUT_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 1

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
          controller_second_matrix_vector_product_fsm_int <= CLEAN_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE;

        when INPUT_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 2

          -- Data Inputs
          data_a_in_matrix_vector_product <= matrix_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
          data_b_in_matrix_vector_product <= vector_operation_int(to_integer(unsigned(index_j_matrix_vector_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_vector_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            controller_second_matrix_vector_product_fsm_int <= CLEAN_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
          else
            controller_second_matrix_vector_product_fsm_int <= CLEAN_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 3

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              data_second_matrix_vector_product_enable_int <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_vector_product_fsm_int <= STARTER_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              index_i_matrix_vector_product_loop <= std_logic_vector(unsigned(index_i_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_vector_product_fsm_int <= INPUT_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';

            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

        when CLEAN_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 4

          if (data_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_j_matrix_vector_product_loop <= std_logic_vector(unsigned(index_j_matrix_vector_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_second_matrix_vector_product_fsm_int <= INPUT_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
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
          controller_second_matrix_vector_product_fsm_int <= STARTER_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

  second_vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_second_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_second_vector_float_adder_fsm_int is
        when STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          data_second_vector_float_adder_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_x_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_L_IN;

            -- Control Internal
            index_vector_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_second_vector_float_adder_fsm_int <= INPUT_SECOND_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when INPUT_SECOND_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
          data_b_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_adder <= '1';
          end if;

          data_a_in_enable_vector_float_adder <= '1';
          data_b_in_enable_vector_float_adder <= '1';

          -- FSM Control
          controller_second_vector_float_adder_fsm_int <= CLEAN_SECOND_VECTOR_FLOAT_ADDER_STATE;

        when CLEAN_SECOND_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_second_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_vector_float_adder_fsm_int <= STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_second_vector_float_adder_fsm_int <= INPUT_SECOND_VECTOR_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_second_vector_float_adder_fsm_int <= STARTER_SECOND_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  vector_logistic_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_enable_vector_logistic <= '0';

      data_vector_logistic_enable_int <= '0';

      index_vector_logistic_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_logistic_fsm_int is
        when STARTER_VECTOR_LOGISTIC_STATE =>  -- STEP 0
          -- Control Internal
          data_in_enable_vector_logistic <= '0';

          data_vector_logistic_enable_int <= '0';

          if (data_w_in_enable_int = '1') then
            -- Data Inputs
            size_in_vector_logistic <= SIZE_L_IN;

            -- Control Internal
            index_vector_logistic_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_logistic_fsm_int <= INPUT_VECTOR_LOGISTIC_STATE;
          end if;

        when INPUT_VECTOR_LOGISTIC_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_vector_logistic <= vector_operation_int(to_integer(unsigned(index_vector_logistic_loop)));

          -- Control Internal
          if (unsigned(index_vector_logistic_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_logistic_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_logistic <= '1';
          end if;

          data_in_enable_vector_logistic <= '1';

          -- FSM Control
          controller_vector_logistic_fsm_int <= CLEAN_VECTOR_LOGISTIC_STATE;

        when CLEAN_VECTOR_LOGISTIC_STATE =>  -- STEP 7

          if (data_out_enable_vector_logistic = '1' and data_out_enable_vector_logistic = '1') then
            if (unsigned(index_vector_logistic_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_logistic_loop))) <= data_out_vector_logistic;

              -- Control Internal
              data_vector_logistic_enable_int <= '1';

              index_vector_logistic_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_logistic_fsm_int <= STARTER_VECTOR_LOGISTIC_STATE;
            elsif (unsigned(index_vector_logistic_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_logistic_loop))) <= data_out_vector_logistic;

              -- Control Internal
              index_vector_logistic_loop <= std_logic_vector(unsigned(index_vector_logistic_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_logistic_fsm_int <= INPUT_VECTOR_LOGISTIC_STATE;
            end if;
          else
            -- Control Internal
            start_vector_logistic <= '0';

            data_in_enable_vector_logistic <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_logistic_fsm_int <= STARTER_VECTOR_LOGISTIC_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  h_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      H_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_h_out_fsm_int is
        when STARTER_H_OUT_STATE =>     -- STEP 0
          if (data_w_in_enable_int = '1' and data_k_in_enable_int = '1' and data_u_in_enable_int = '1' and data_d_in_enable_int = '1' and data_b_in_enable_int = '1' and data_x_in_enable_int = '1' and data_xi_in_enable_int = '1' and data_rho_in_enable_int = '1' and data_h_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

        when CLEAN_H_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          H_OUT_ENABLE <= '0';

          -- FSM Control
          controller_h_out_fsm_int <= OUTPUT_H_OUT_L_STATE;

        when OUTPUT_H_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_h_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            H_OUT <= vector_h_out_int(to_integer(unsigned(index_l_h_out_loop)));

            -- Control Outputs
            READY <= '1';

            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
          elsif (unsigned(index_l_h_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            H_OUT <= vector_h_out_int(to_integer(unsigned(index_l_h_out_loop)));

            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_out_loop <= std_logic_vector(unsigned(index_l_h_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_adder,
      READY => ready_vector_float_adder,

      OPERATION => operation_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_vector_float_adder,
      DATA_A_IN => data_a_in_vector_float_adder,
      DATA_B_IN => data_b_in_vector_float_adder,
      DATA_OUT  => data_out_vector_float_adder
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

  -- VECTOR LOGISTIC
  vector_logistic_function : accelerator_vector_logistic_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_logistic,
      READY => ready_vector_logistic,

      DATA_IN_ENABLE => data_in_enable_vector_logistic,

      DATA_OUT_ENABLE => data_out_enable_vector_logistic,

      -- DATA
      SIZE_IN  => size_in_vector_logistic,
      DATA_IN  => data_in_vector_logistic,
      DATA_OUT => data_out_vector_logistic
      );

end architecture;
