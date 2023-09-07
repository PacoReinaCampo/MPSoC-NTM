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
use work.accelerator_state_vhdl_pkg.all;

entity accelerator_state_vector_state is
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

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_C_IN_I_ENABLE : in std_logic;
    DATA_C_IN_J_ENABLE : in std_logic;
    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_A_I_ENABLE : out std_logic;
    DATA_A_J_ENABLE : out std_logic;
    DATA_B_I_ENABLE : out std_logic;
    DATA_B_J_ENABLE : out std_logic;
    DATA_C_I_ENABLE : out std_logic;
    DATA_C_J_ENABLE : out std_logic;
    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_U_IN_ENABLE : in std_logic;

    DATA_U_ENABLE : out std_logic;

    DATA_X_OUT_ENABLE : out std_logic;

    -- DATA
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_state_vector_state_architecture of accelerator_state_vector_state is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_a_in_fsm is (
    STARTER_A_IN_STATE,                 -- STEP 0
    INPUT_A_IN_I_STATE,                 -- STEP 1
    INPUT_A_IN_J_STATE,                 -- STEP 2
    CLEAN_A_IN_I_STATE,                 -- STEP 3
    CLEAN_A_IN_J_STATE                  -- STEP 4
    );

  type controller_b_in_fsm is (
    STARTER_B_IN_STATE,                 -- STEP 0
    INPUT_B_IN_I_STATE,                 -- STEP 1
    INPUT_B_IN_J_STATE,                 -- STEP 2
    CLEAN_B_IN_I_STATE,                 -- STEP 3
    CLEAN_B_IN_J_STATE                  -- STEP 4
    );

  type controller_c_in_fsm is (
    STARTER_C_IN_STATE,                 -- STEP 0
    INPUT_C_IN_I_STATE,                 -- STEP 1
    INPUT_C_IN_J_STATE,                 -- STEP 2
    CLEAN_C_IN_I_STATE,                 -- STEP 3
    CLEAN_C_IN_J_STATE                  -- STEP 4
    );

  type controller_d_in_fsm is (
    STARTER_D_IN_STATE,                 -- STEP 0
    INPUT_D_IN_I_STATE,                 -- STEP 1
    INPUT_D_IN_J_STATE,                 -- STEP 2
    CLEAN_D_IN_I_STATE,                 -- STEP 3
    CLEAN_D_IN_J_STATE                  -- STEP 4
    );

  type controller_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_J_STATE,                 -- STEP 2
    CLEAN_K_IN_I_STATE,                 -- STEP 3
    CLEAN_K_IN_J_STATE                  -- STEP 4
    );

  type controller_u_in_fsm is (
    STARTER_U_IN_STATE,                 -- STEP 0
    INPUT_U_IN_STATE,                   -- STEP 1
    CLEAN_U_IN_STATE                    -- STEP 2
    );

  -- Ops
  type controller_first_matrix_vector_product_fsm is (
    STARTER_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_matrix_product_fsm is (
    STARTER_MATRIX_PRODUCT_STATE,       -- STEP 0
    INPUT_I_MATRIX_PRODUCT_STATE,       -- STEP 1
    INPUT_J_MATRIX_PRODUCT_STATE,       -- STEP 2
    CLEAN_I_MATRIX_PRODUCT_STATE,       -- STEP 3
    CLEAN_J_MATRIX_PRODUCT_STATE        -- STEP 4
    );

  type controller_second_matrix_vector_product_fsm is (
    STARTER_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_vector_summation_fsm is (
    STARTER_VECTOR_SUMMATION_STATE,       -- STEP 0
    INPUT_LENGTH_VECTOR_SUMMATION_STATE,  -- STEP 1
    INPUT_SIZE_VECTOR_SUMMATION_STATE,    -- STEP 2
    CLEAN_LENGTH_VECTOR_SUMMATION_STATE,  -- STEP 3
    CLEAN_SIZE_VECTOR_SUMMATION_STATE     -- STEP 4
    );

  type controller_vector_float_adder_fsm is (
    STARTER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    INPUT_VECTOR_FLOAT_ADDER_STATE,     -- STEP 2
    CLEAN_VECTOR_FLOAT_ADDER_STATE      -- STEP 4
    );

  -- Output
  type controller_x_out_fsm is (
    STARTER_X_OUT_STATE,                -- STEP 0
    CLEAN_X_OUT_STATE,                  -- STEP 2
    OUTPUT_X_OUT_STATE                  -- STEP 1
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_a_in_fsm_int : controller_a_in_fsm;
  signal controller_b_in_fsm_int : controller_b_in_fsm;
  signal controller_c_in_fsm_int : controller_c_in_fsm;
  signal controller_d_in_fsm_int : controller_d_in_fsm;

  signal controller_k_in_fsm_int : controller_k_in_fsm;

  signal controller_u_in_fsm_int : controller_u_in_fsm;

  -- Ops
  signal controller_first_matrix_vector_product_fsm_int  : controller_first_matrix_vector_product_fsm;
  signal controller_matrix_product_fsm_int               : controller_matrix_product_fsm;
  signal controller_second_matrix_vector_product_fsm_int : controller_second_matrix_vector_product_fsm;
  signal controller_vector_summation_fsm_int             : controller_vector_summation_fsm;
  signal controller_vector_float_adder_fsm_int           : controller_vector_float_adder_fsm;

  -- Output
  signal controller_x_out_fsm_int : controller_x_out_fsm;

  -- Buffer
  -- Input
  signal matrix_a_in_int : matrix_buffer;
  signal matrix_b_in_int : matrix_buffer;
  signal matrix_c_in_int : matrix_buffer;
  signal matrix_d_in_int : matrix_buffer;

  signal matrix_k_in_int : matrix_buffer;

  signal vector_u_in_int : vector_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_x_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_i_a_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_a_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_c_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_c_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_length_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_summation_loop        : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_x_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_a_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;
  signal data_c_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;

  signal data_k_in_enable_int : std_logic;

  signal data_u_in_enable_int : std_logic;

  -- Ops
  signal data_first_matrix_vector_product_enable_int  : std_logic;
  signal data_matrix_product_enable_int               : std_logic;
  signal data_second_matrix_vector_product_enable_int : std_logic;
  signal data_vector_float_adder_enable_int           : std_logic;
  signal data_vector_summation_enable_int             : std_logic;

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

  -- VECTOR FLOAT ADDER
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

  signal data_in_enable_length_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_enable_length_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_i_enable_matrix_product : std_logic;
  signal data_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

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

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- x(k+1) = A·x(k) + B·u(k)
  -- y(k) = C·x(k) + D·u(k)

  -- x(k) = exp(A,k)·x(0) + summation(exp(A,k-j-1)·B·u(j))[j in 0 to k-1]

  -- INPUT CONTROL
  a_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_A_I_ENABLE <= '0';
      DATA_A_J_ENABLE <= '0';

      -- Control Internal
      index_i_a_in_loop <= ZERO_CONTROL;
      index_j_a_in_loop <= ZERO_CONTROL;

      data_a_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_a_in_fsm_int is
        when STARTER_A_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_a_in_loop <= ZERO_CONTROL;
            index_j_a_in_loop <= ZERO_CONTROL;

            data_a_in_enable_int <= '0';

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_I_STATE;
          else
            -- Control Outputs
            DATA_A_I_ENABLE <= '0';
            DATA_A_J_ENABLE <= '0';
          end if;

        when INPUT_A_IN_I_STATE =>      -- STEP 1

          if ((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_a_in_int(to_integer(unsigned(index_i_a_in_loop)), to_integer(unsigned(index_j_a_in_loop))) <= DATA_A_IN;

            -- FSM Control
            controller_a_in_fsm_int <= CLEAN_A_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_A_I_ENABLE <= '0';
          DATA_A_J_ENABLE <= '0';

        when INPUT_A_IN_J_STATE =>      -- STEP 2

          if (DATA_A_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_a_in_int(to_integer(unsigned(index_i_a_in_loop)), to_integer(unsigned(index_j_a_in_loop))) <= DATA_A_IN;

            -- FSM Control
            if (unsigned(index_j_a_in_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
              controller_a_in_fsm_int <= CLEAN_A_IN_I_STATE;
            else
              controller_a_in_fsm_int <= CLEAN_A_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_A_J_ENABLE <= '0';

        when CLEAN_A_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_a_in_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_a_in_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_a_in_loop <= ZERO_CONTROL;
            index_j_a_in_loop <= ZERO_CONTROL;

            data_a_in_enable_int <= '1';

            -- FSM Control
            controller_a_in_fsm_int <= STARTER_A_IN_STATE;
          elsif ((unsigned(index_i_a_in_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_a_in_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_a_in_loop <= std_logic_vector(unsigned(index_i_a_in_loop) + unsigned(ONE_CONTROL));
            index_j_a_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_I_STATE;
          end if;

        when CLEAN_A_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_a_in_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_j_a_in_loop <= std_logic_vector(unsigned(index_j_a_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_a_in_fsm_int <= STARTER_A_IN_STATE;
      end case;
    end if;
  end process;

  b_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_B_I_ENABLE <= '0';
      DATA_B_J_ENABLE <= '0';

      -- Control Internal
      index_i_b_in_loop <= ZERO_CONTROL;
      index_j_b_in_loop <= ZERO_CONTROL;

      data_b_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_b_in_fsm_int is
        when STARTER_B_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= ZERO_CONTROL;
            index_j_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_I_STATE;
          else
            -- Control Outputs
            DATA_B_I_ENABLE <= '0';
            DATA_B_J_ENABLE <= '0';
          end if;

        when INPUT_B_IN_I_STATE =>      -- STEP 1

          if ((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_b_in_loop)), to_integer(unsigned(index_j_b_in_loop))) <= DATA_B_IN;

            -- FSM Control
            controller_b_in_fsm_int <= CLEAN_B_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_B_I_ENABLE <= '0';
          DATA_B_J_ENABLE <= '0';

        when INPUT_B_IN_J_STATE =>      -- STEP 2

          if (DATA_B_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_b_in_loop)), to_integer(unsigned(index_j_b_in_loop))) <= DATA_B_IN;

            -- FSM Control
            if (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
              controller_b_in_fsm_int <= CLEAN_B_IN_I_STATE;
            else
              controller_b_in_fsm_int <= CLEAN_B_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_B_J_ENABLE <= '0';

        when CLEAN_B_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_b_in_loop) = unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= ZERO_CONTROL;
            index_j_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '1';

            -- FSM Control
            controller_b_in_fsm_int <= STARTER_B_IN_STATE;
          elsif ((unsigned(index_i_b_in_loop) < unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= std_logic_vector(unsigned(index_i_b_in_loop) + unsigned(ONE_CONTROL));
            index_j_b_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_I_STATE;
          end if;

        when CLEAN_B_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_b_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_j_b_in_loop <= std_logic_vector(unsigned(index_j_b_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_in_fsm_int <= STARTER_B_IN_STATE;
      end case;
    end if;
  end process;

  c_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_C_I_ENABLE <= '0';
      DATA_C_J_ENABLE <= '0';

      -- Control Internal
      index_i_c_in_loop <= ZERO_CONTROL;
      index_j_c_in_loop <= ZERO_CONTROL;

      data_c_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_c_in_fsm_int is
        when STARTER_C_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_c_in_loop <= ZERO_CONTROL;
            index_j_c_in_loop <= ZERO_CONTROL;

            data_c_in_enable_int <= '0';

            -- FSM Control
            controller_c_in_fsm_int <= INPUT_C_IN_I_STATE;
          else
            -- Control Outputs
            DATA_C_I_ENABLE <= '0';
            DATA_C_J_ENABLE <= '0';
          end if;

        when INPUT_C_IN_I_STATE =>      -- STEP 1

          if ((DATA_C_IN_I_ENABLE = '1') and (DATA_C_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_c_in_int(to_integer(unsigned(index_i_c_in_loop)), to_integer(unsigned(index_j_c_in_loop))) <= DATA_C_IN;

            -- FSM Control
            controller_c_in_fsm_int <= CLEAN_C_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_C_I_ENABLE <= '0';
          DATA_C_J_ENABLE <= '0';

        when INPUT_C_IN_J_STATE =>      -- STEP 2

          if (DATA_C_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_c_in_int(to_integer(unsigned(index_i_c_in_loop)), to_integer(unsigned(index_j_c_in_loop))) <= DATA_C_IN;

            -- FSM Control
            if (unsigned(index_j_c_in_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL)) then
              controller_c_in_fsm_int <= CLEAN_C_IN_I_STATE;
            else
              controller_c_in_fsm_int <= CLEAN_C_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_C_J_ENABLE <= '0';

        when CLEAN_C_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_c_in_loop) = unsigned(SIZE_C_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_c_in_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_c_in_loop <= ZERO_CONTROL;
            index_j_c_in_loop <= ZERO_CONTROL;

            data_c_in_enable_int <= '1';

            -- FSM Control
            controller_c_in_fsm_int <= STARTER_C_IN_STATE;
          elsif ((unsigned(index_i_c_in_loop) < unsigned(SIZE_C_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_c_in_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_c_in_loop <= std_logic_vector(unsigned(index_i_c_in_loop) + unsigned(ONE_CONTROL));
            index_j_c_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_c_in_fsm_int <= INPUT_C_IN_I_STATE;
          end if;

        when CLEAN_C_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_c_in_loop) < unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_j_c_in_loop <= std_logic_vector(unsigned(index_j_c_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_c_in_fsm_int <= INPUT_C_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_c_in_fsm_int <= STARTER_C_IN_STATE;
      end case;
    end if;
  end process;

  d_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_D_I_ENABLE <= '0';
      DATA_D_J_ENABLE <= '0';

      -- Control Internal
      index_i_d_in_loop <= ZERO_CONTROL;
      index_j_d_in_loop <= ZERO_CONTROL;

      data_d_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_d_in_fsm_int is
        when STARTER_D_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_j_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '0';

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          else
            -- Control Outputs
            DATA_D_I_ENABLE <= '0';
            DATA_D_J_ENABLE <= '0';
          end if;

        when INPUT_D_IN_I_STATE =>      -- STEP 1

          if ((DATA_D_IN_I_ENABLE = '1') and (DATA_D_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_j_d_in_loop))) <= DATA_D_IN;

            -- FSM Control
            controller_d_in_fsm_int <= CLEAN_D_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_D_I_ENABLE <= '0';
          DATA_D_J_ENABLE <= '0';

        when INPUT_D_IN_J_STATE =>      -- STEP 2

          if (DATA_D_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_j_d_in_loop))) <= DATA_D_IN;

            -- FSM Control
            if (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_D_J_ENABLE <= '0';

        when CLEAN_D_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_d_in_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_j_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '1';

            -- FSM Control
            controller_d_in_fsm_int <= STARTER_D_IN_STATE;
          elsif ((unsigned(index_i_d_in_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= std_logic_vector(unsigned(index_i_d_in_loop) + unsigned(ONE_CONTROL));
            index_j_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          end if;

        when CLEAN_D_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_d_in_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_j_d_in_loop <= std_logic_vector(unsigned(index_j_d_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_in_fsm_int <= STARTER_D_IN_STATE;
      end case;
    end if;
  end process;

  k_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_K_I_ENABLE <= '0';
      DATA_K_J_ENABLE <= '0';

      -- Control Internal
      index_i_k_in_loop <= ZERO_CONTROL;
      index_j_k_in_loop <= ZERO_CONTROL;

      data_k_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_in_fsm_int is
        when STARTER_K_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_j_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '0';

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          else
            -- Control Outputs
            DATA_K_I_ENABLE <= '0';
            DATA_K_J_ENABLE <= '0';
          end if;

        when INPUT_K_IN_I_STATE =>      -- STEP 1

          if ((DATA_K_IN_I_ENABLE = '1') and (DATA_K_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_j_k_in_loop))) <= DATA_K_IN;

            -- FSM Control
            controller_k_in_fsm_int <= CLEAN_K_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_K_I_ENABLE <= '0';
          DATA_K_J_ENABLE <= '0';

        when INPUT_K_IN_J_STATE =>      -- STEP 2

          if (DATA_K_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_j_k_in_loop))) <= DATA_K_IN;

            -- FSM Control
            if (unsigned(index_j_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_K_J_ENABLE <= '0';

        when CLEAN_K_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_j_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '1';

            -- FSM Control
            controller_k_in_fsm_int <= STARTER_K_IN_STATE;
          elsif ((unsigned(index_i_k_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= std_logic_vector(unsigned(index_i_k_in_loop) + unsigned(ONE_CONTROL));
            index_j_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          end if;

        when CLEAN_K_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_k_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_j_k_in_loop <= std_logic_vector(unsigned(index_j_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_J_STATE;
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
      DATA_U_ENABLE <= '0';

      -- Control Internal
      index_u_in_loop <= ZERO_CONTROL;

      data_u_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_u_in_fsm_int is
        when STARTER_U_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_U_ENABLE <= '1';

            -- Control Internal
            index_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '0';

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_STATE;
          else
            -- Control Outputs
            DATA_U_ENABLE <= '0';
          end if;

        when INPUT_U_IN_STATE =>        -- STEP 1

          if (DATA_U_IN_ENABLE = '1') then
            -- Data Inputs
            vector_u_in_int(to_integer(unsigned(index_u_in_loop))) <= DATA_U_IN;

            -- FSM Control
            controller_u_in_fsm_int <= CLEAN_U_IN_STATE;
          end if;

          -- Control Outputs
          DATA_U_ENABLE <= '0';

        when CLEAN_U_IN_STATE =>        -- STEP 2

          if (unsigned(index_u_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_U_ENABLE <= '1';

            -- Control Internal
            index_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '1';

            -- FSM Control
            controller_u_in_fsm_int <= STARTER_U_IN_STATE;
          elsif (unsigned(index_u_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_U_ENABLE <= '1';

            -- Control Internal
            index_u_in_loop <= std_logic_vector(unsigned(index_u_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_u_in_fsm_int <= STARTER_U_IN_STATE;
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
            size_a_i_in_matrix_vector_product <= SIZE_A_I_IN;
            size_a_j_in_matrix_vector_product <= SIZE_A_I_IN;
            size_b_in_matrix_vector_product   <= SIZE_A_I_IN;

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
          if (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
            controller_first_matrix_vector_product_fsm_int <= CLEAN_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
          else
            controller_first_matrix_vector_product_fsm_int <= CLEAN_J_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_FIRST_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              data_first_matrix_vector_product_enable_int <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_vector_product_fsm_int <= STARTER_FIRST_MATRIX_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL))) then
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
            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
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

  matrix_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_product <= '0';
      data_a_in_j_enable_matrix_product <= '0';
      data_b_in_i_enable_matrix_product <= '0';
      data_b_in_j_enable_matrix_product <= '0';

      data_matrix_product_enable_int <= '0';

      index_i_matrix_product_loop <= ZERO_CONTROL;
      index_j_matrix_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_product_fsm_int is
        when STARTER_MATRIX_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_product <= '0';
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= '0';
          data_b_in_j_enable_matrix_product <= '0';

          data_matrix_product_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_product <= SIZE_D_I_IN;
            size_a_j_in_matrix_product <= SIZE_D_J_IN;
            size_b_i_in_matrix_product <= SIZE_D_I_IN;
            size_b_j_in_matrix_product <= SIZE_D_J_IN;

            -- Control Internal
            index_i_matrix_product_loop <= ZERO_CONTROL;
            index_j_matrix_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_product_fsm_int <= INPUT_I_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_I_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_product <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));
          data_b_in_matrix_product <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_product_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_product <= '1';
          end if;

          data_a_in_i_enable_matrix_product <= '1';
          data_a_in_j_enable_matrix_product <= '1';
          data_b_in_i_enable_matrix_product <= '1';
          data_b_in_j_enable_matrix_product <= '1';

          -- FSM Control
          controller_matrix_product_fsm_int <= CLEAN_J_MATRIX_PRODUCT_STATE;

        when INPUT_J_MATRIX_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_product <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));
          data_b_in_matrix_product <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_product <= '1';
          data_b_in_j_enable_matrix_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_product_fsm_int <= CLEAN_I_MATRIX_PRODUCT_STATE;
          else
            controller_matrix_product_fsm_int <= CLEAN_J_MATRIX_PRODUCT_STATE;
          end if;

        when CLEAN_I_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_product = '1' and data_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_matrix_product_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              data_matrix_product_enable_int <= '1';

              index_i_matrix_product_loop <= ZERO_CONTROL;
              index_j_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_product_fsm_int <= STARTER_MATRIX_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_product_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              index_i_matrix_product_loop <= std_logic_vector(unsigned(index_i_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_product_fsm_int <= INPUT_I_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_product <= '0';

            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when CLEAN_J_MATRIX_PRODUCT_STATE =>  -- STEP 8

          if (data_i_enable_matrix_product = '1') then
            if (unsigned(index_j_matrix_product_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              index_j_matrix_product_loop <= std_logic_vector(unsigned(index_j_matrix_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_product_fsm_int <= INPUT_I_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_product <= '0';

            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_matrix_product_fsm_int <= STARTER_MATRIX_PRODUCT_STATE;
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
            size_a_i_in_matrix_vector_product <= SIZE_A_I_IN;
            size_a_j_in_matrix_vector_product <= SIZE_A_I_IN;
            size_b_in_matrix_vector_product   <= SIZE_A_I_IN;

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
          if (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
            controller_second_matrix_vector_product_fsm_int <= CLEAN_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
          else
            controller_second_matrix_vector_product_fsm_int <= CLEAN_J_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_SECOND_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 3

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              data_second_matrix_vector_product_enable_int <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_vector_product_fsm_int <= STARTER_SECOND_MATRIX_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL))) then
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
            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
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

  vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_enable_length_vector_summation <= '0';
      data_in_enable_vector_summation        <= '0';

      data_vector_summation_enable_int <= '0';

      index_length_vector_summation_loop <= ZERO_CONTROL;
      index_vector_summation_loop        <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_summation_fsm_int is
        when STARTER_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_enable_length_vector_summation <= '0';
          data_in_enable_vector_summation        <= '0';

          data_vector_summation_enable_int <= '0';

          if (data_a_in_enable_int = '1' and data_a_in_enable_int = '1') then
            -- Data Inputs
            length_in_vector_summation <= SIZE_A_I_IN;
            size_in_vector_summation   <= SIZE_A_I_IN;

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

          data_in_enable_length_vector_summation <= '1';
          data_in_enable_vector_summation        <= '1';

          -- FSM Control
          controller_vector_summation_fsm_int <= CLEAN_SIZE_VECTOR_SUMMATION_STATE;

        when INPUT_SIZE_VECTOR_SUMMATION_STATE =>  -- STEP 6

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_length_vector_summation_loop)), to_integer(unsigned(index_vector_summation_loop)));

          -- Control Internal
          data_in_enable_vector_summation <= '1';

          -- FSM Control
          if (unsigned(index_vector_summation_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
            controller_vector_summation_fsm_int <= CLEAN_LENGTH_VECTOR_SUMMATION_STATE;
          else
            controller_vector_summation_fsm_int <= CLEAN_SIZE_VECTOR_SUMMATION_STATE;
          end if;

        when CLEAN_LENGTH_VECTOR_SUMMATION_STATE =>  -- STEP 7

          if (data_enable_length_vector_summation = '1' and data_enable_vector_summation = '1') then
            if ((unsigned(index_length_vector_summation_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_vector_summation_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_length_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              data_vector_summation_enable_int <= '1';

              index_length_vector_summation_loop <= ZERO_CONTROL;
              index_vector_summation_loop        <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
            elsif ((unsigned(index_length_vector_summation_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_vector_summation_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL))) then
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

            data_in_enable_length_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when CLEAN_SIZE_VECTOR_SUMMATION_STATE =>  -- STEP 8

          if (data_enable_length_vector_summation = '1') then
            if (unsigned(index_vector_summation_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_vector_summation_loop <= std_logic_vector(unsigned(index_vector_summation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_SIZE_VECTOR_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_enable_length_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_adder_fsm_int is
        when STARTER_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          data_vector_float_adder_enable_int <= '0';

          if (data_a_in_enable_int = '1' and data_a_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_A_I_IN;

            -- Control Internal
            index_vector_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when INPUT_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 5

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
          controller_vector_float_adder_fsm_int <= CLEAN_VECTOR_FLOAT_ADDER_STATE;

        when CLEAN_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  x_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_X_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_X_OUT_ENABLE <= '0';

      -- Control Internal
      index_x_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_x_out_fsm_int is
        when STARTER_X_OUT_STATE =>     -- STEP 0
          if (data_a_in_enable_int = '1' and data_b_in_enable_int = '1' and data_c_in_enable_int = '1' and data_d_in_enable_int = '1' and data_k_in_enable_int = '1' and data_u_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_x_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_out_fsm_int <= CLEAN_X_OUT_STATE;
          end if;

        when CLEAN_X_OUT_STATE =>       -- STEP 1
          -- Control Outputs
          DATA_X_OUT_ENABLE <= '0';

          -- FSM Control
          controller_x_out_fsm_int <= OUTPUT_X_OUT_STATE;

        when OUTPUT_X_OUT_STATE =>      -- STEP 2

          if (unsigned(index_x_out_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_X_OUT <= vector_x_out_int(to_integer(unsigned(index_x_out_loop)));

            -- Control Outputs
            READY <= '1';

            DATA_X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_out_fsm_int <= STARTER_X_OUT_STATE;
          elsif (unsigned(index_x_out_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_X_OUT <= vector_x_out_int(to_integer(unsigned(index_x_out_loop)));

            -- Control Outputs
            DATA_X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_out_loop <= std_logic_vector(unsigned(index_x_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_x_out_fsm_int <= CLEAN_X_OUT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_x_out_fsm_int <= STARTER_X_OUT_STATE;
      end case;
    end if;
  end process;

  -- MATRIX STATE
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

  -- MATRIX INPUT
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

  -- MATRIX OUTPUT
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

  -- MATRIX FEEDFORWARD
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

  -- VECTOR FLOAT ADDER
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

      DATA_IN_LENGTH_ENABLE => data_in_enable_length_vector_summation,
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

  -- MATRIX PRODUCT
  matrix_product : accelerator_matrix_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_product,
      READY => ready_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      DATA_I_ENABLE => data_i_enable_matrix_product,
      DATA_J_ENABLE => data_j_enable_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_product,
      SIZE_A_J_IN => size_a_j_in_matrix_product,
      SIZE_B_I_IN => size_b_i_in_matrix_product,
      SIZE_B_J_IN => size_b_j_in_matrix_product,
      DATA_A_IN   => data_a_in_matrix_product,
      DATA_B_IN   => data_b_in_matrix_product,
      DATA_OUT    => data_out_matrix_product
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

end architecture;
