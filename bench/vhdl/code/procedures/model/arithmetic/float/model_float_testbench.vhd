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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_float_pkg.all;

entity model_float_testbench is
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

    -- SCALAR-FUNCTIONALITY
    ENABLE_NTM_SCALAR_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_NTM_SCALAR_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_SCALAR_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_SCALAR_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_SCALAR_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_FLOAT_DIVIDER_CASE_1    : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_NTM_VECTOR_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_VECTOR_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_VECTOR_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_VECTOR_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_FLOAT_DIVIDER_CASE_1    : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_NTM_MATRIX_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_MATRIX_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_MATRIX_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_MATRIX_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_FLOAT_DIVIDER_CASE_1    : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_NTM_TENSOR_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_TENSOR_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_TENSOR_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_TENSOR_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_FLOAT_DIVIDER_CASE_1    : boolean := false
    );
end model_float_testbench;

architecture model_float_testbench_architecture of model_float_testbench is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant CONTROL_X : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_Y : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_Z : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_L : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));

  -- SCALAR
  constant SCALAR_ADDER_OUTPUT_0 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_float_adder('0', SCALAR_SAMPLE_A, SCALAR_SAMPLE_B);
  constant SCALAR_ADDER_OUTPUT_1 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_float_adder('0', SCALAR_SAMPLE_B, SCALAR_SAMPLE_A);

  constant SCALAR_MULTIPLIER_OUTPUT_0 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_float_multiplier(SCALAR_SAMPLE_A, SCALAR_SAMPLE_B);
  constant SCALAR_MULTIPLIER_OUTPUT_1 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_float_multiplier(SCALAR_SAMPLE_B, SCALAR_SAMPLE_A);

  constant SCALAR_DIVIDER_OUTPUT_0 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_float_divider(SCALAR_SAMPLE_A, SCALAR_SAMPLE_B);
  constant SCALAR_DIVIDER_OUTPUT_1 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_float_divider(SCALAR_SAMPLE_B, SCALAR_SAMPLE_A);

  -- VECTOR
  constant VECTOR_ADDER_OUTPUT_0 : vector_buffer := function_vector_float_adder('0', CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_ADDER_OUTPUT_1 : vector_buffer := function_vector_float_adder('0', CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_MULTIPLIER_OUTPUT_0 : vector_buffer := function_vector_float_multiplier(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_MULTIPLIER_OUTPUT_1 : vector_buffer := function_vector_float_multiplier(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_DIVIDER_OUTPUT_0 : vector_buffer := function_vector_float_divider(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_DIVIDER_OUTPUT_1 : vector_buffer := function_vector_float_divider(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  -- MATRIX
  constant MATRIX_ADDER_OUTPUT_0 : matrix_buffer := function_matrix_float_adder('0', CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_ADDER_OUTPUT_1 : matrix_buffer := function_matrix_float_adder('0', CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  constant MATRIX_MULTIPLIER_OUTPUT_0 : matrix_buffer := function_matrix_float_multiplier(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_MULTIPLIER_OUTPUT_1 : matrix_buffer := function_matrix_float_multiplier(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  constant MATRIX_DIVIDER_OUTPUT_0 : matrix_buffer := function_matrix_float_divider(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_DIVIDER_OUTPUT_1 : matrix_buffer := function_matrix_float_divider(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  -- TENSOR
  constant TENSOR_ADDER_OUTPUT_0 : tensor_buffer := function_tensor_float_adder('0', CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_ADDER_OUTPUT_1 : tensor_buffer := function_tensor_float_adder('0', CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  constant TENSOR_MULTIPLIER_OUTPUT_0 : tensor_buffer := function_tensor_float_multiplier(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_MULTIPLIER_OUTPUT_1 : tensor_buffer := function_tensor_float_multiplier(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  constant TENSOR_DIVIDER_OUTPUT_0 : tensor_buffer := function_tensor_float_divider(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_DIVIDER_OUTPUT_1 : tensor_buffer := function_tensor_float_divider(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

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

  -- SCALAR FLOAT MULTIPLIER
  -- CONTROL
  signal start_scalar_float_multiplier : std_logic;
  signal ready_scalar_float_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_multiplier : std_logic;

  -- SCALAR FLOAT DIVIDER
  -- CONTROL
  signal start_scalar_float_divider : std_logic;
  signal ready_scalar_float_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_divider : std_logic;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

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

  signal data_out_vector_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_adder : std_logic;

  -- VECTOR FLOAT MULTIPLIER
  -- CONTROL
  signal start_vector_float_multiplier : std_logic;
  signal ready_vector_float_multiplier : std_logic;

  signal data_a_in_enable_vector_float_multiplier : std_logic;
  signal data_b_in_enable_vector_float_multiplier : std_logic;

  signal data_out_enable_vector_float_multiplier : std_logic;

  -- DATA
  signal size_in_vector_float_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_multiplier : std_logic;

  -- VECTOR FLOAT DIVIDER
  -- CONTROL
  signal start_vector_float_divider : std_logic;
  signal ready_vector_float_divider : std_logic;

  signal data_a_in_enable_vector_float_divider : std_logic;
  signal data_b_in_enable_vector_float_divider : std_logic;

  signal data_out_enable_vector_float_divider : std_logic;

  -- DATA
  signal size_in_vector_float_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_divider : std_logic;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX FLOAT ADDER
  -- CONTROL
  signal start_matrix_float_adder : std_logic;
  signal ready_matrix_float_adder : std_logic;

  signal operation_matrix_float_adder : std_logic;

  signal data_a_in_i_enable_matrix_float_adder : std_logic;
  signal data_a_in_j_enable_matrix_float_adder : std_logic;
  signal data_b_in_i_enable_matrix_float_adder : std_logic;
  signal data_b_in_j_enable_matrix_float_adder : std_logic;

  signal data_out_i_enable_matrix_float_adder : std_logic;
  signal data_out_j_enable_matrix_float_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_adder : std_logic;

  -- MATRIX FLOAT MULTIPLIER
  -- CONTROL
  signal start_matrix_float_multiplier : std_logic;
  signal ready_matrix_float_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_float_multiplier : std_logic;

  signal data_out_i_enable_matrix_float_multiplier : std_logic;
  signal data_out_j_enable_matrix_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_multiplier : std_logic;

  -- MATRIX FLOAT DIVIDER
  -- CONTROL
  signal start_matrix_float_divider : std_logic;
  signal ready_matrix_float_divider : std_logic;

  signal data_a_in_i_enable_matrix_float_divider : std_logic;
  signal data_a_in_j_enable_matrix_float_divider : std_logic;
  signal data_b_in_i_enable_matrix_float_divider : std_logic;
  signal data_b_in_j_enable_matrix_float_divider : std_logic;

  signal data_out_i_enable_matrix_float_divider : std_logic;
  signal data_out_j_enable_matrix_float_divider : std_logic;

  -- DATA
  signal size_i_in_matrix_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_divider : std_logic;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR FLOAT ADDER
  -- CONTROL
  signal start_tensor_float_adder : std_logic;
  signal ready_tensor_float_adder : std_logic;

  signal operation_tensor_float_adder : std_logic;

  signal data_a_in_i_enable_tensor_float_adder : std_logic;
  signal data_a_in_j_enable_tensor_float_adder : std_logic;
  signal data_a_in_k_enable_tensor_float_adder : std_logic;
  signal data_b_in_i_enable_tensor_float_adder : std_logic;
  signal data_b_in_j_enable_tensor_float_adder : std_logic;
  signal data_b_in_k_enable_tensor_float_adder : std_logic;

  signal data_out_i_enable_tensor_float_adder : std_logic;
  signal data_out_j_enable_tensor_float_adder : std_logic;
  signal data_out_k_enable_tensor_float_adder : std_logic;

  -- DATA
  signal size_i_in_tensor_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_float_adder : std_logic;

  -- TENSOR FLOAT MULTIPLIER
  -- CONTROL
  signal start_tensor_float_multiplier : std_logic;
  signal ready_tensor_float_multiplier : std_logic;

  signal data_a_in_i_enable_tensor_float_multiplier : std_logic;
  signal data_a_in_j_enable_tensor_float_multiplier : std_logic;
  signal data_a_in_k_enable_tensor_float_multiplier : std_logic;
  signal data_b_in_i_enable_tensor_float_multiplier : std_logic;
  signal data_b_in_j_enable_tensor_float_multiplier : std_logic;
  signal data_b_in_k_enable_tensor_float_multiplier : std_logic;

  signal data_out_i_enable_tensor_float_multiplier : std_logic;
  signal data_out_j_enable_tensor_float_multiplier : std_logic;
  signal data_out_k_enable_tensor_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_tensor_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_float_multiplier : std_logic;

  -- TENSOR FLOAT DIVIDER
  -- CONTROL
  signal start_tensor_float_divider : std_logic;
  signal ready_tensor_float_divider : std_logic;

  signal data_a_in_i_enable_tensor_float_divider : std_logic;
  signal data_a_in_j_enable_tensor_float_divider : std_logic;
  signal data_a_in_k_enable_tensor_float_divider : std_logic;
  signal data_b_in_i_enable_tensor_float_divider : std_logic;
  signal data_b_in_j_enable_tensor_float_divider : std_logic;
  signal data_b_in_k_enable_tensor_float_divider : std_logic;

  signal data_out_i_enable_tensor_float_divider : std_logic;
  signal data_out_j_enable_tensor_float_divider : std_logic;
  signal data_out_k_enable_tensor_float_divider : std_logic;

  -- DATA
  signal size_i_in_tensor_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_float_divider : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  float_stimulus : model_float_stimulus
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

      ------------------------------------------------------------------------------
      -- STIMULUS SCALAR FLOAT
      ------------------------------------------------------------------------------

      -- SCALAR FLOAT ADDER
      -- CONTROL
      SCALAR_FLOAT_ADDER_START => start_scalar_float_adder,
      SCALAR_FLOAT_ADDER_READY => ready_scalar_float_adder,

      SCALAR_FLOAT_ADDER_OPERATION => operation_scalar_float_adder,

      -- DATA
      SCALAR_FLOAT_ADDER_DATA_A_IN    => data_a_in_scalar_float_adder,
      SCALAR_FLOAT_ADDER_DATA_B_IN    => data_b_in_scalar_float_adder,
      SCALAR_FLOAT_ADDER_DATA_OUT     => data_out_scalar_float_adder,
      SCALAR_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_scalar_float_adder,

      -- SCALAR FLOAT MULTIPLIER
      -- CONTROL
      SCALAR_FLOAT_MULTIPLIER_START => start_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_READY => ready_scalar_float_multiplier,

      -- DATA
      SCALAR_FLOAT_MULTIPLIER_DATA_A_IN    => data_a_in_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_DATA_B_IN    => data_b_in_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_DATA_OUT     => data_out_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_scalar_float_multiplier,

      -- SCALAR FLOAT DIVIDER
      -- CONTROL
      SCALAR_FLOAT_DIVIDER_START => start_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_READY => ready_scalar_float_divider,

      -- DATA
      SCALAR_FLOAT_DIVIDER_DATA_A_IN    => data_a_in_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_DATA_B_IN    => data_b_in_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_DATA_OUT     => data_out_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_scalar_float_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR FLOAT
      ------------------------------------------------------------------------------

      -- VECTOR FLOAT ADDER
      -- CONTROL
      VECTOR_FLOAT_ADDER_START => start_vector_float_adder,
      VECTOR_FLOAT_ADDER_READY => ready_vector_float_adder,

      VECTOR_FLOAT_ADDER_OPERATION => operation_vector_float_adder,

      VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      VECTOR_FLOAT_ADDER_SIZE_IN      => size_in_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_A_IN    => data_a_in_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_B_IN    => data_b_in_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_OUT     => data_out_vector_float_adder,
      VECTOR_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_vector_float_adder,

      -- VECTOR FLOAT MULTIPLIER
      -- CONTROL
      VECTOR_FLOAT_MULTIPLIER_START => start_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_READY => ready_vector_float_multiplier,

      VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

      VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

      -- DATA
      VECTOR_FLOAT_MULTIPLIER_SIZE_IN      => size_in_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_A_IN    => data_a_in_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_B_IN    => data_b_in_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_OUT     => data_out_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_vector_float_multiplier,

      -- VECTOR FLOAT DIVIDER
      -- CONTROL
      VECTOR_FLOAT_DIVIDER_START => start_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_READY => ready_vector_float_divider,

      VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_float_divider,

      VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE => data_out_enable_vector_float_divider,

      -- DATA
      VECTOR_FLOAT_DIVIDER_SIZE_IN      => size_in_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_A_IN    => data_a_in_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_B_IN    => data_b_in_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_OUT     => data_out_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_vector_float_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX FLOAT
      ------------------------------------------------------------------------------

      -- MATRIX FLOAT ADDER
      -- CONTROL
      MATRIX_FLOAT_ADDER_START => start_matrix_float_adder,
      MATRIX_FLOAT_ADDER_READY => ready_matrix_float_adder,

      MATRIX_FLOAT_ADDER_OPERATION => operation_matrix_float_adder,

      MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_adder,

      MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_adder,

      -- DATA
      MATRIX_FLOAT_ADDER_SIZE_I_IN    => size_i_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_SIZE_J_IN    => size_j_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_A_IN    => data_a_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_B_IN    => data_b_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_OUT     => data_out_matrix_float_adder,
      MATRIX_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_matrix_float_adder,

      -- MATRIX FLOAT MULTIPLIER
      -- CONTROL
      MATRIX_FLOAT_MULTIPLIER_START => start_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_READY => ready_matrix_float_multiplier,

      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

      MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

      -- DATA
      MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN    => size_i_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN    => size_j_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN    => data_a_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN    => data_b_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_OUT     => data_out_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_matrix_float_multiplier,

      -- MATRIX FLOAT DIVIDER
      -- CONTROL
      MATRIX_FLOAT_DIVIDER_START => start_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_READY => ready_matrix_float_divider,

      MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_divider,

      MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_divider,

      -- DATA
      MATRIX_FLOAT_DIVIDER_SIZE_I_IN    => size_i_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_SIZE_J_IN    => size_j_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_A_IN    => data_a_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_B_IN    => data_b_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_OUT     => data_out_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_matrix_float_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR FLOAT ADDER
      -- CONTROL
      TENSOR_FLOAT_ADDER_START => start_tensor_float_adder,
      TENSOR_FLOAT_ADDER_READY => ready_tensor_float_adder,

      TENSOR_FLOAT_ADDER_OPERATION => operation_tensor_float_adder,

      TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_adder,

      TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_adder,

      -- DATA
      TENSOR_FLOAT_ADDER_SIZE_I_IN => size_i_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_SIZE_J_IN => size_j_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_SIZE_K_IN => size_k_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_A_IN => data_a_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN => data_b_in_tensor_float_adder,

      TENSOR_FLOAT_ADDER_DATA_OUT     => data_out_tensor_float_adder,
      TENSOR_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_tensor_float_adder,

      -- TENSOR FLOAT MULTIPLIER
      -- CONTROL
      TENSOR_FLOAT_MULTIPLIER_START => start_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_READY => ready_tensor_float_multiplier,

      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_multiplier,

      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_multiplier,

      -- DATA
      TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN => size_i_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN => size_j_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN => size_k_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN => data_a_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN => data_b_in_tensor_float_multiplier,

      TENSOR_FLOAT_MULTIPLIER_DATA_OUT     => data_out_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_tensor_float_multiplier,

      -- TENSOR FLOAT DIVIDER
      -- CONTROL
      TENSOR_FLOAT_DIVIDER_START => start_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_READY => ready_tensor_float_divider,

      TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_divider,

      TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_divider,

      -- DATA
      TENSOR_FLOAT_DIVIDER_SIZE_I_IN => size_i_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_SIZE_J_IN => size_j_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_SIZE_K_IN => size_k_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_A_IN => data_a_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN => data_b_in_tensor_float_divider,

      TENSOR_FLOAT_DIVIDER_DATA_OUT     => data_out_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_tensor_float_divider
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR FLOAT ADDER
  model_scalar_float_adder_test : if (ENABLE_NTM_SCALAR_FLOAT_ADDER_TEST) generate
    scalar_float_adder : model_scalar_float_adder
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

        DATA_OUT => data_out_scalar_float_adder
        );
  end generate model_scalar_float_adder_test;

  -- SCALAR FLOAT MULTIPLIER
  model_scalar_float_multiplier_test : if (ENABLE_NTM_SCALAR_FLOAT_MULTIPLIER_TEST) generate
    scalar_float_multiplier : model_scalar_float_multiplier
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
  end generate model_scalar_float_multiplier_test;

  -- SCALAR FLOAT DIVIDER
  model_scalar_float_divider_test : if (ENABLE_NTM_SCALAR_FLOAT_DIVIDER_TEST) generate
    scalar_float_divider : model_scalar_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_float_divider,
        READY => ready_scalar_float_divider,

        -- DATA
        DATA_A_IN => data_a_in_scalar_float_divider,
        DATA_B_IN => data_b_in_scalar_float_divider,

        DATA_OUT     => data_out_scalar_float_divider,
        OVERFLOW_OUT => overflow_out_scalar_float_divider
        );
  end generate model_scalar_float_divider_test;

  scalar_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_scalar_float_adder = '1') then
        assert data_out_scalar_float_adder = SCALAR_ADDER_OUTPUT_0
          report "SCALAR ADDER: CALCULATED = " & to_string(data_out_scalar_float_adder) & "; CORRECT = " & to_string(SCALAR_ADDER_OUTPUT_0)
          severity error;
      end if;

      if (ready_scalar_float_multiplier = '1') then
        assert data_out_scalar_float_multiplier = SCALAR_MULTIPLIER_OUTPUT_0
          report "SCALAR MULTIPLIER: CALCULATED = " & to_string(data_out_scalar_float_multiplier) & "; CORRECT = " & to_string(SCALAR_MULTIPLIER_OUTPUT_0)
          severity error;
      end if;

      if (ready_scalar_float_divider = '1') then
        assert data_out_scalar_float_divider = SCALAR_DIVIDER_OUTPUT_0
          report "SCALAR DIVIDER: CALCULATED = " & to_string(data_out_scalar_float_divider) & "; CORRECT = " & to_string(SCALAR_DIVIDER_OUTPUT_0)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR FLOAT ADDER
  model_vector_float_adder_test : if (ENABLE_NTM_VECTOR_FLOAT_ADDER_TEST) generate
    vector_float_adder : model_vector_float_adder
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

        DATA_OUT     => data_out_vector_float_adder,
        OVERFLOW_OUT => overflow_out_vector_float_adder
        );
  end generate model_vector_float_adder_test;

  -- VECTOR FLOAT MULTIPLIER
  model_vector_float_multiplier_test : if (ENABLE_NTM_VECTOR_FLOAT_MULTIPLIER_TEST) generate
    vector_float_multiplier : model_vector_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_float_multiplier,
        READY => ready_vector_float_multiplier,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

        DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

        -- DATA
        SIZE_IN   => size_in_vector_float_multiplier,
        DATA_A_IN => data_a_in_vector_float_multiplier,
        DATA_B_IN => data_b_in_vector_float_multiplier,

        DATA_OUT     => data_out_vector_float_multiplier,
        OVERFLOW_OUT => overflow_out_vector_float_multiplier
        );
  end generate model_vector_float_multiplier_test;

  -- VECTOR FLOAT DIVIDER
  model_vector_float_divider_test : if (ENABLE_NTM_VECTOR_FLOAT_DIVIDER_TEST) generate
    vector_float_divider : model_vector_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_float_divider,
        READY => ready_vector_float_divider,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_float_divider,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_float_divider,

        DATA_OUT_ENABLE => data_out_enable_vector_float_divider,

        -- DATA
        SIZE_IN   => size_in_vector_float_divider,
        DATA_A_IN => data_a_in_vector_float_divider,
        DATA_B_IN => data_b_in_vector_float_divider,

        DATA_OUT     => data_out_vector_float_divider,
        OVERFLOW_OUT => overflow_out_vector_float_divider
        );
  end generate model_vector_float_divider_test;

  vector_assertion : process (CLK, RST)
    variable i : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
        assert data_out_vector_float_adder = VECTOR_ADDER_OUTPUT_0(i)
          report "VECTOR ADDER: CALCULATED = " & to_string(data_out_vector_float_adder) & "; CORRECT = " & to_string(VECTOR_ADDER_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_float_adder = '1' and not data_out_vector_float_adder = ZERO_DATA) then
        assert data_out_vector_float_adder = VECTOR_ADDER_OUTPUT_0(i)
          report "VECTOR ADDER: CALCULATED = " & to_string(data_out_vector_float_adder) & "; CORRECT = " & to_string(VECTOR_ADDER_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_float_multiplier = '1' and data_out_enable_vector_float_multiplier = '1') then
        assert data_out_vector_float_multiplier = VECTOR_MULTIPLIER_OUTPUT_0(i)
          report "VECTOR MULTIPLIER: CALCULATED = " & to_string(data_out_vector_float_multiplier) & "; CORRECT = " & to_string(VECTOR_MULTIPLIER_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_float_multiplier = '1' and not data_out_vector_float_multiplier = ZERO_DATA) then
        assert data_out_vector_float_multiplier = VECTOR_MULTIPLIER_OUTPUT_0(i)
          report "VECTOR MULTIPLIER: CALCULATED = " & to_string(data_out_vector_float_multiplier) & "; CORRECT = " & to_string(VECTOR_MULTIPLIER_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_float_divider = '1' and data_out_enable_vector_float_divider = '1') then
        assert data_out_vector_float_divider = VECTOR_DIVIDER_OUTPUT_0(i)
          report "VECTOR DIVIDER: CALCULATED = " & to_string(data_out_vector_float_divider) & "; CORRECT = " & to_string(VECTOR_DIVIDER_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_float_divider = '1' and not data_out_vector_float_divider = ZERO_DATA) then
        assert data_out_vector_float_divider = VECTOR_DIVIDER_OUTPUT_0(i)
          report "VECTOR DIVIDER: CALCULATED = " & to_string(data_out_vector_float_divider) & "; CORRECT = " & to_string(VECTOR_DIVIDER_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;
    end if;
  end process vector_assertion;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX FLOAT ADDER
  model_matrix_float_adder_test : if (ENABLE_NTM_MATRIX_FLOAT_ADDER_TEST) generate
    matrix_float_adder : model_matrix_float_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_float_adder,
        READY => ready_matrix_float_adder,

        OPERATION => operation_matrix_float_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_adder,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_float_adder,
        SIZE_J_IN => size_j_in_matrix_float_adder,
        DATA_A_IN => data_a_in_matrix_float_adder,
        DATA_B_IN => data_b_in_matrix_float_adder,

        DATA_OUT     => data_out_matrix_float_adder,
        OVERFLOW_OUT => overflow_out_matrix_float_adder
        );
  end generate model_matrix_float_adder_test;

  -- MATRIX FLOAT MULTIPLIER
  model_matrix_float_multiplier_test : if (ENABLE_NTM_MATRIX_FLOAT_MULTIPLIER_TEST) generate
    matrix_float_multiplier : model_matrix_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_float_multiplier,
        READY => ready_matrix_float_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_float_multiplier,
        SIZE_J_IN => size_j_in_matrix_float_multiplier,
        DATA_A_IN => data_a_in_matrix_float_multiplier,
        DATA_B_IN => data_b_in_matrix_float_multiplier,

        DATA_OUT     => data_out_matrix_float_multiplier,
        OVERFLOW_OUT => overflow_out_matrix_float_multiplier
        );
  end generate model_matrix_float_multiplier_test;

  -- MATRIX FLOAT DIVIDER
  model_matrix_float_divider_test : if (ENABLE_NTM_MATRIX_FLOAT_DIVIDER_TEST) generate
    matrix_float_divider : model_matrix_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_float_divider,
        READY => ready_matrix_float_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_divider,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_float_divider,
        SIZE_J_IN => size_j_in_matrix_float_divider,
        DATA_A_IN => data_a_in_matrix_float_divider,
        DATA_B_IN => data_b_in_matrix_float_divider,

        DATA_OUT     => data_out_matrix_float_divider,
        OVERFLOW_OUT => overflow_out_matrix_float_divider
        );
  end generate model_matrix_float_divider_test;

  matrix_assertion : process (CLK, RST)
    variable i : integer := 0;
    variable j : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1' and data_out_j_enable_matrix_float_adder = '1') then
        assert data_out_matrix_float_adder = MATRIX_ADDER_OUTPUT_0(i, j)
          report "MATRIX ADDER: CALCULATED = " & to_string(data_out_matrix_float_adder) & "; CORRECT = " & to_string(MATRIX_ADDER_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_float_adder = '1' and data_out_j_enable_matrix_float_adder = '1' and not data_out_matrix_float_adder = ZERO_DATA) then
        assert data_out_matrix_float_adder = MATRIX_ADDER_OUTPUT_0(i, j)
          report "MATRIX ADDER: CALCULATED = " & to_string(data_out_matrix_float_adder) & "; CORRECT = " & to_string(MATRIX_ADDER_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_float_adder = '1' and not data_out_matrix_float_adder = ZERO_DATA) then
        assert data_out_matrix_float_adder = MATRIX_ADDER_OUTPUT_0(i, j)
          report "MATRIX ADDER: CALCULATED = " & to_string(data_out_matrix_float_adder) & "; CORRECT = " & to_string(MATRIX_ADDER_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_float_multiplier = '1' and data_out_i_enable_matrix_float_multiplier = '1' and data_out_j_enable_matrix_float_multiplier = '1') then
        assert data_out_matrix_float_multiplier = MATRIX_MULTIPLIER_OUTPUT_0(i, j)
          report "MATRIX MULTIPLIER: CALCULATED = " & to_string(data_out_matrix_float_multiplier) & "; CORRECT = " & to_string(MATRIX_MULTIPLIER_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_float_multiplier = '1' and data_out_j_enable_matrix_float_multiplier = '1' and not data_out_matrix_float_multiplier = ZERO_DATA) then
        assert data_out_matrix_float_multiplier = MATRIX_MULTIPLIER_OUTPUT_0(i, j)
          report "MATRIX MULTIPLIER: CALCULATED = " & to_string(data_out_matrix_float_multiplier) & "; CORRECT = " & to_string(MATRIX_MULTIPLIER_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_float_multiplier = '1' and not data_out_matrix_float_multiplier = ZERO_DATA) then
        assert data_out_matrix_float_multiplier = MATRIX_MULTIPLIER_OUTPUT_0(i, j)
          report "MATRIX MULTIPLIER: CALCULATED = " & to_string(data_out_matrix_float_multiplier) & "; CORRECT = " & to_string(MATRIX_MULTIPLIER_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_float_divider = '1' and data_out_i_enable_matrix_float_divider = '1' and data_out_j_enable_matrix_float_divider = '1') then
        assert data_out_matrix_float_divider = MATRIX_DIVIDER_OUTPUT_0(i, j)
          report "MATRIX DIVIDER: CALCULATED = " & to_string(data_out_matrix_float_divider) & "; CORRECT = " & to_string(MATRIX_DIVIDER_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_float_divider = '1' and data_out_j_enable_matrix_float_divider = '1' and not data_out_matrix_float_divider = ZERO_DATA) then
        assert data_out_matrix_float_divider = MATRIX_DIVIDER_OUTPUT_0(i, j)
          report "MATRIX DIVIDER: CALCULATED = " & to_string(data_out_matrix_float_divider) & "; CORRECT = " & to_string(MATRIX_DIVIDER_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_float_divider = '1' and not data_out_matrix_float_divider = ZERO_DATA) then
        assert data_out_matrix_float_divider = MATRIX_DIVIDER_OUTPUT_0(i, j)
          report "MATRIX DIVIDER: CALCULATED = " & to_string(data_out_matrix_float_divider) & "; CORRECT = " & to_string(MATRIX_DIVIDER_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;
    end if;
  end process matrix_assertion;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR FLOAT ADDER
  model_tensor_float_adder_test : if (ENABLE_NTM_TENSOR_FLOAT_ADDER_TEST) generate
    tensor_float_adder : model_tensor_float_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_float_adder,
        READY => ready_tensor_float_adder,

        OPERATION => operation_tensor_float_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_adder,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_adder,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_adder,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_adder,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_float_adder,
        SIZE_J_IN => size_j_in_tensor_float_adder,
        SIZE_K_IN => size_k_in_tensor_float_adder,
        DATA_A_IN => data_a_in_tensor_float_adder,
        DATA_B_IN => data_b_in_tensor_float_adder,

        DATA_OUT     => data_out_tensor_float_adder,
        OVERFLOW_OUT => overflow_out_tensor_float_adder
        );
  end generate model_tensor_float_adder_test;

  -- TENSOR FLOAT MULTIPLIER
  model_tensor_float_multiplier_test : if (ENABLE_NTM_TENSOR_FLOAT_MULTIPLIER_TEST) generate
    tensor_float_multiplier : model_tensor_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_float_multiplier,
        READY => ready_tensor_float_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_multiplier,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_multiplier,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_multiplier,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_float_multiplier,
        SIZE_J_IN => size_j_in_tensor_float_multiplier,
        SIZE_K_IN => size_k_in_tensor_float_multiplier,
        DATA_A_IN => data_a_in_tensor_float_multiplier,
        DATA_B_IN => data_b_in_tensor_float_multiplier,

        DATA_OUT     => data_out_tensor_float_multiplier,
        OVERFLOW_OUT => overflow_out_tensor_float_multiplier
        );
  end generate model_tensor_float_multiplier_test;

  -- TENSOR FLOAT DIVIDER
  model_tensor_float_divider_test : if (ENABLE_NTM_TENSOR_FLOAT_DIVIDER_TEST) generate
    tensor_float_divider : model_tensor_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_float_divider,
        READY => ready_tensor_float_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_divider,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_divider,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_divider,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_divider,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_float_divider,
        SIZE_J_IN => size_j_in_tensor_float_divider,
        SIZE_K_IN => size_k_in_tensor_float_divider,
        DATA_A_IN => data_a_in_tensor_float_divider,
        DATA_B_IN => data_b_in_tensor_float_divider,

        DATA_OUT     => data_out_tensor_float_divider,
        OVERFLOW_OUT => overflow_out_tensor_float_divider
        );
  end generate model_tensor_float_divider_test;

  tensor_assertion : process (CLK, RST)
    variable i : integer := 0;
    variable j : integer := 0;
    variable k : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_tensor_float_adder = '1' and data_out_i_enable_tensor_float_adder = '1' and data_out_j_enable_tensor_float_adder = '1' and data_out_k_enable_tensor_float_adder = '1') then
        assert data_out_tensor_float_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_float_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_float_adder = '1' and data_out_j_enable_tensor_float_adder = '1' and data_out_k_enable_tensor_float_adder = '1' and not data_out_tensor_float_adder = ZERO_DATA) then
        assert data_out_tensor_float_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_float_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_float_adder = '1' and data_out_k_enable_tensor_float_adder = '1' and not data_out_tensor_float_adder = ZERO_DATA) then
        assert data_out_tensor_float_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_float_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_float_adder = '1' and not data_out_tensor_float_adder = ZERO_DATA) then
        assert data_out_tensor_float_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_float_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_float_multiplier = '1' and data_out_i_enable_tensor_float_multiplier = '1' and data_out_j_enable_tensor_float_multiplier = '1' and data_out_k_enable_tensor_float_multiplier = '1') then
        assert data_out_tensor_float_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_float_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_float_multiplier = '1' and data_out_j_enable_tensor_float_multiplier = '1' and data_out_k_enable_tensor_float_multiplier = '1' and not data_out_tensor_float_multiplier = ZERO_DATA) then
        assert data_out_tensor_float_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_float_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_float_multiplier = '1' and data_out_k_enable_tensor_float_multiplier = '1' and not data_out_tensor_float_multiplier = ZERO_DATA) then
        assert data_out_tensor_float_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_float_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_float_multiplier = '1' and not data_out_tensor_float_multiplier = ZERO_DATA) then
        assert data_out_tensor_float_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_float_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_float_divider = '1' and data_out_i_enable_tensor_float_divider = '1' and data_out_j_enable_tensor_float_divider = '1' and data_out_k_enable_tensor_float_divider = '1') then
        assert data_out_tensor_float_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_float_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_float_divider = '1' and data_out_j_enable_tensor_float_divider = '1' and data_out_k_enable_tensor_float_divider = '1' and not data_out_tensor_float_divider = ZERO_DATA) then
        assert data_out_tensor_float_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_float_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_float_divider = '1' and data_out_k_enable_tensor_float_divider = '1' and not data_out_tensor_float_divider = ZERO_DATA) then
        assert data_out_tensor_float_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_float_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_float_divider = '1' and not data_out_tensor_float_divider = ZERO_DATA) then
        assert data_out_tensor_float_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_float_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;
    end if;
  end process tensor_assertion;

end model_float_testbench_architecture;
