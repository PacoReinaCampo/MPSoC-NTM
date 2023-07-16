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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_algebra_pkg.all;

entity model_algebra_testbench is
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

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_DOT_PRODUCT_TEST              : boolean := false;
    ENABLE_NTM_VECTOR_CONVOLUTION_TEST       : boolean := false;
    ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLICATION_TEST    : boolean := false;
    ENABLE_NTM_VECTOR_SUMMATION_TEST         : boolean := false;
    ENABLE_NTM_VECTOR_MODULE_TEST            : boolean := false;

    ENABLE_NTM_DOT_PRODUCT_CASE_0              : boolean := false;
    ENABLE_NTM_VECTOR_CONVOLUTION_CASE_0       : boolean := false;
    ENABLE_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLICATION_CASE_0    : boolean := false;
    ENABLE_NTM_VECTOR_SUMMATION_CASE_0         : boolean := false;
    ENABLE_NTM_VECTOR_MODULE_CASE_0            : boolean := false;

    ENABLE_NTM_DOT_PRODUCT_CASE_1              : boolean := false;
    ENABLE_NTM_VECTOR_CONVOLUTION_CASE_1       : boolean := false;
    ENABLE_NTM_VECTOR_COSINE_SIMILARITY_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLICATION_CASE_1    : boolean := false;
    ENABLE_NTM_VECTOR_SUMMATION_CASE_1         : boolean := false;
    ENABLE_NTM_VECTOR_MODULE_CASE_1            : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_CONVOLUTION_TEST        : boolean := false;
    ENABLE_NTM_MATRIX_VECTOR_CONVOLUTION_TEST : boolean := false;
    ENABLE_NTM_MATRIX_INVERSE_TEST            : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLICATION_TEST     : boolean := false;
    ENABLE_NTM_MATRIX_PRODUCT_TEST            : boolean := false;
    ENABLE_NTM_MATRIX_VECTOR_PRODUCT_TEST     : boolean := false;
    ENABLE_NTM_MATRIX_SUMMATION_TEST          : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_TEST          : boolean := false;

    ENABLE_NTM_MATRIX_CONVOLUTION_CASE_0        : boolean := false;
    ENABLE_NTM_MATRIX_VECTOR_CONVOLUTION_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_INVERSE_CASE_0            : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLICATION_CASE_0     : boolean := false;
    ENABLE_NTM_MATRIX_PRODUCT_CASE_0            : boolean := false;
    ENABLE_NTM_MATRIX_VECTOR_PRODUCT_CASE_0     : boolean := false;
    ENABLE_NTM_MATRIX_SUMMATION_CASE_0          : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_CASE_0          : boolean := false;

    ENABLE_NTM_MATRIX_CONVOLUTION_CASE_1        : boolean := false;
    ENABLE_NTM_MATRIX_VECTOR_CONVOLUTION_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_INVERSE_CASE_1            : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLICATION_CASE_1     : boolean := false;
    ENABLE_NTM_MATRIX_PRODUCT_CASE_1            : boolean := false;
    ENABLE_NTM_MATRIX_VECTOR_PRODUCT_CASE_1     : boolean := false;
    ENABLE_NTM_MATRIX_SUMMATION_CASE_1          : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_CASE_1          : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_CONVOLUTION_TEST        : boolean := false;
    ENABLE_NTM_TENSOR_MATRIX_CONVOLUTION_TEST : boolean := false;
    ENABLE_NTM_TENSOR_INVERSE_TEST            : boolean := false;
    ENABLE_NTM_TENSOR_PRODUCT_TEST            : boolean := false;
    ENABLE_NTM_TENSOR_MATRIX_PRODUCT_TEST     : boolean := false;
    ENABLE_NTM_TENSOR_TRANSPOSE_TEST          : boolean := false;

    ENABLE_NTM_TENSOR_CONVOLUTION_CASE_0        : boolean := false;
    ENABLE_NTM_TENSOR_MATRIX_CONVOLUTION_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_INVERSE_CASE_0            : boolean := false;
    ENABLE_NTM_TENSOR_PRODUCT_CASE_0            : boolean := false;
    ENABLE_NTM_TENSOR_MATRIX_PRODUCT_CASE_0     : boolean := false;
    ENABLE_NTM_TENSOR_TRANSPOSE_CASE_0          : boolean := false;

    ENABLE_NTM_TENSOR_CONVOLUTION_CASE_1        : boolean := false;
    ENABLE_NTM_TENSOR_MATRIX_CONVOLUTION_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_INVERSE_CASE_1            : boolean := false;
    ENABLE_NTM_TENSOR_PRODUCT_CASE_1            : boolean := false;
    ENABLE_NTM_TENSOR_MATRIX_PRODUCT_CASE_1     : boolean := false;
    ENABLE_NTM_TENSOR_TRANSPOSE_CASE_1          : boolean := false
    );
end model_algebra_testbench;

architecture model_algebra_testbench_architecture of model_algebra_testbench is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant CONTROL_X : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_Y : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_Z : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_L : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));

  -- VECTOR
  constant DOT_PRODUCT_OUTPUT_0 : vector_buffer := function_dot_product(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant DOT_PRODUCT_OUTPUT_1 : vector_buffer := function_dot_product(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_CONVOLUTION_OUTPUT_0 : vector_buffer := function_vector_convolution(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_CONVOLUTION_OUTPUT_1 : vector_buffer := function_vector_convolution(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_COSINE_SIMILARITY_OUTPUT_0 : vector_buffer := function_vector_cosine_similarity(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_COSINE_SIMILARITY_OUTPUT_1 : vector_buffer := function_vector_cosine_similarity(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_MULTIPLICATION_OUTPUT_0 : vector_buffer := function_vector_multiplication(CONTROL_X, CONTROL_L, MATRIX_SAMPLE_A);
  constant VECTOR_MULTIPLICATION_OUTPUT_1 : vector_buffer := function_vector_multiplication(CONTROL_X, CONTROL_L, MATRIX_SAMPLE_B);

  constant VECTOR_SUMMATION_OUTPUT_0 : vector_buffer := function_vector_summation(CONTROL_X, CONTROL_L, MATRIX_SAMPLE_A);
  constant VECTOR_SUMMATION_OUTPUT_1 : vector_buffer := function_vector_summation(CONTROL_X, CONTROL_L, MATRIX_SAMPLE_B);

  constant VECTOR_MODULE_OUTPUT_0 : vector_buffer := function_vector_module(CONTROL_X, VECTOR_SAMPLE_A);
  constant VECTOR_MODULE_OUTPUT_1 : vector_buffer := function_vector_module(CONTROL_X, VECTOR_SAMPLE_B);

  -- MATRIX
  constant MATRIX_CONVOLUTION_OUTPUT_0 : matrix_buffer := function_matrix_convolution(CONTROL_X, CONTROL_Y, CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_CONVOLUTION_OUTPUT_1 : matrix_buffer := function_matrix_convolution(CONTROL_X, CONTROL_Y, CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  constant MATRIX_VECTOR_CONVOLUTION_OUTPUT_0 : vector_buffer := function_matrix_vector_convolution(CONTROL_X, CONTROL_Y, CONTROL_X, MATRIX_SAMPLE_A, VECTOR_SAMPLE_B);
  constant MATRIX_VECTOR_CONVOLUTION_OUTPUT_1 : vector_buffer := function_matrix_vector_convolution(CONTROL_X, CONTROL_Y, CONTROL_X, MATRIX_SAMPLE_B, VECTOR_SAMPLE_A);

  constant MATRIX_INVERSE_OUTPUT_0 : matrix_buffer := function_matrix_inverse(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A);
  constant MATRIX_INVERSE_OUTPUT_1 : matrix_buffer := function_matrix_inverse(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B);

  constant MATRIX_MULTIPLICATION_OUTPUT_0 : matrix_buffer := function_matrix_multiplication(CONTROL_X, CONTROL_Y, CONTROL_L, TENSOR_SAMPLE_A);
  constant MATRIX_MULTIPLICATION_OUTPUT_1 : matrix_buffer := function_matrix_multiplication(CONTROL_X, CONTROL_Y, CONTROL_L, TENSOR_SAMPLE_B);

  constant MATRIX_PRODUCT_OUTPUT_0 : matrix_buffer := function_matrix_product(CONTROL_X, CONTROL_Y, CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_PRODUCT_OUTPUT_1 : matrix_buffer := function_matrix_product(CONTROL_X, CONTROL_Y, CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  constant MATRIX_VECTOR_PRODUCT_OUTPUT_0 : vector_buffer := function_matrix_vector_product(CONTROL_X, CONTROL_Y, CONTROL_X, MATRIX_SAMPLE_A, VECTOR_SAMPLE_B);
  constant MATRIX_VECTOR_PRODUCT_OUTPUT_1 : vector_buffer := function_matrix_vector_product(CONTROL_X, CONTROL_Y, CONTROL_X, MATRIX_SAMPLE_B, VECTOR_SAMPLE_A);

  constant MATRIX_TRANSPOSE_OUTPUT_0 : matrix_buffer := function_matrix_transpose(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A);
  constant MATRIX_TRANSPOSE_OUTPUT_1 : matrix_buffer := function_matrix_transpose(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B);

  constant MATRIX_SUMMATION_OUTPUT_0 : matrix_buffer := function_matrix_summation(CONTROL_X, CONTROL_Y, CONTROL_L, TENSOR_SAMPLE_A);
  constant MATRIX_SUMMATION_OUTPUT_1 : matrix_buffer := function_matrix_summation(CONTROL_X, CONTROL_Y, CONTROL_L, TENSOR_SAMPLE_B);

  -- TENSOR
  constant TENSOR_CONVOLUTION_OUTPUT_0 : tensor_buffer := function_tensor_convolution(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_CONVOLUTION_OUTPUT_1 : tensor_buffer := function_tensor_convolution(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  constant TENSOR_MATRIX_CONVOLUTION_OUTPUT_0 : matrix_buffer := function_tensor_matrix_convolution(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, TENSOR_SAMPLE_A, MATRIX_SAMPLE_B);
  constant TENSOR_MATRIX_CONVOLUTION_OUTPUT_1 : matrix_buffer := function_tensor_matrix_convolution(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, TENSOR_SAMPLE_B, MATRIX_SAMPLE_A);

  constant TENSOR_INVERSE_OUTPUT_0 : tensor_buffer := function_tensor_inverse(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A);
  constant TENSOR_INVERSE_OUTPUT_1 : tensor_buffer := function_tensor_inverse(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B);

  constant TENSOR_PRODUCT_OUTPUT_0 : tensor_buffer := function_tensor_product(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_PRODUCT_OUTPUT_1 : tensor_buffer := function_tensor_product(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  constant TENSOR_MATRIX_PRODUCT_OUTPUT_0 : matrix_buffer := function_tensor_matrix_product(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, TENSOR_SAMPLE_A, MATRIX_SAMPLE_B);
  constant TENSOR_MATRIX_PRODUCT_OUTPUT_1 : matrix_buffer := function_tensor_matrix_product(CONTROL_X, CONTROL_Y, CONTROL_Z, CONTROL_X, CONTROL_Y, TENSOR_SAMPLE_B, MATRIX_SAMPLE_A);

  constant TENSOR_TRANSPOSE_OUTPUT_0 : tensor_buffer := function_tensor_transpose(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A);
  constant TENSOR_TRANSPOSE_OUTPUT_1 : tensor_buffer := function_tensor_transpose(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B);

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- DOT PRODUCT
  -- CONTROL
  signal start_dot_product : std_logic;
  signal ready_dot_product : std_logic;

  signal data_a_in_enable_dot_product : std_logic;
  signal data_b_in_enable_dot_product : std_logic;

  signal data_out_enable_dot_product : std_logic;

  -- DATA
  signal length_in_dot_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_dot_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_dot_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_dot_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR CONVOLUTION
  -- CONTROL
  signal start_vector_convolution : std_logic;
  signal ready_vector_convolution : std_logic;

  signal data_a_in_enable_vector_convolution : std_logic;
  signal data_b_in_enable_vector_convolution : std_logic;

  signal data_enable_vector_convolution : std_logic;

  signal data_out_enable_vector_convolution : std_logic;

  -- DATA
  signal length_in_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSINE_SIMILARITY
  -- CONTROL
  signal start_vector_cosine_similarity : std_logic;
  signal ready_vector_cosine_similarity : std_logic;

  signal data_a_in_enable_vector_cosine_similarity : std_logic;
  signal data_b_in_enable_vector_cosine_similarity : std_logic;

  signal data_enable_vector_cosine_similarity : std_logic;

  signal data_out_enable_vector_cosine_similarity : std_logic;

  -- DATA
  signal length_in_vector_cosine_similarity : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosine_similarity  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLICATION
  -- CONTROL
  signal start_vector_multiplication : std_logic;
  signal ready_vector_multiplication : std_logic;

  signal data_in_length_enable_vector_multiplication : std_logic;
  signal data_in_enable_vector_multiplication        : std_logic;

  signal data_length_enable_vector_multiplication : std_logic;
  signal data_enable_vector_multiplication        : std_logic;

  signal data_out_enable_vector_multiplication : std_logic;

  -- DATA
  signal size_in_vector_multiplication   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_length_enable_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_length_enable_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MODULE
  -- CONTROL
  signal start_vector_module : std_logic;
  signal ready_vector_module : std_logic;

  signal data_in_enable_vector_module : std_logic;

  signal data_enable_vector_module : std_logic;

  signal data_out_enable_vector_module : std_logic;

  -- DATA
  signal length_in_vector_module : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_module   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_module  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX CONVOLUTION
  -- CONTROL
  signal start_matrix_convolution : std_logic;
  signal ready_matrix_convolution : std_logic;

  signal data_a_in_i_enable_matrix_convolution : std_logic;
  signal data_a_in_j_enable_matrix_convolution : std_logic;
  signal data_b_in_i_enable_matrix_convolution : std_logic;
  signal data_b_in_j_enable_matrix_convolution : std_logic;

  signal data_i_enable_matrix_convolution : std_logic;
  signal data_j_enable_matrix_convolution : std_logic;

  signal data_out_i_enable_matrix_convolution : std_logic;
  signal data_out_j_enable_matrix_convolution : std_logic;

  -- DATA
  signal size_a_i_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX VECTOR CONVOLUTION
  -- CONTROL
  signal start_matrix_vector_convolution : std_logic;
  signal ready_matrix_vector_convolution : std_logic;

  signal data_a_in_i_enable_matrix_vector_convolution : std_logic;
  signal data_a_in_j_enable_matrix_vector_convolution : std_logic;
  signal data_b_in_enable_matrix_vector_convolution   : std_logic;

  signal data_i_enable_matrix_vector_convolution : std_logic;
  signal data_j_enable_matrix_vector_convolution : std_logic;

  signal data_out_enable_matrix_vector_convolution : std_logic;

  -- DATA
  signal size_a_i_in_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_matrix_vector_convolution   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_vector_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INVERSE
  -- CONTROL
  signal start_matrix_inverse : std_logic;
  signal ready_matrix_inverse : std_logic;

  signal data_in_i_enable_matrix_inverse : std_logic;
  signal data_in_j_enable_matrix_inverse : std_logic;

  signal data_i_enable_matrix_inverse : std_logic;
  signal data_j_enable_matrix_inverse : std_logic;

  signal data_out_i_enable_matrix_inverse : std_logic;
  signal data_out_j_enable_matrix_inverse : std_logic;

  -- DATA
  signal size_i_in_matrix_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_inverse   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inverse  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX MULTIPLICATION
  -- CONTROL
  signal start_matrix_multiplication : std_logic;
  signal ready_matrix_multiplication : std_logic;

  signal data_in_length_enable_matrix_multiplication : std_logic;
  signal data_in_i_enable_matrix_multiplication      : std_logic;
  signal data_in_j_enable_matrix_multiplication      : std_logic;

  signal data_length_enable_matrix_multiplication : std_logic;
  signal data_i_enable_matrix_multiplication      : std_logic;
  signal data_j_enable_matrix_multiplication      : std_logic;

  signal data_out_i_enable_matrix_multiplication : std_logic;
  signal data_out_j_enable_matrix_multiplication : std_logic;

  -- DATA
  signal size_i_in_matrix_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- MATRIX SUMMATION
  -- CONTROL
  signal start_matrix_summation : std_logic;
  signal ready_matrix_summation : std_logic;

  signal data_in_length_enable_matrix_summation : std_logic;
  signal data_in_i_enable_matrix_summation      : std_logic;
  signal data_in_j_enable_matrix_summation      : std_logic;

  signal data_length_enable_matrix_summation : std_logic;
  signal data_i_enable_matrix_summation      : std_logic;
  signal data_j_enable_matrix_summation      : std_logic;

  signal data_out_i_enable_matrix_summation : std_logic;
  signal data_out_j_enable_matrix_summation : std_logic;

  -- DATA
  signal size_i_in_matrix_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TRANSPOSE
  -- CONTROL
  signal start_matrix_transpose : std_logic;
  signal ready_matrix_transpose : std_logic;

  signal data_in_i_enable_matrix_transpose : std_logic;
  signal data_in_j_enable_matrix_transpose : std_logic;

  signal data_i_enable_matrix_transpose : std_logic;
  signal data_j_enable_matrix_transpose : std_logic;

  signal data_out_i_enable_matrix_transpose : std_logic;
  signal data_out_j_enable_matrix_transpose : std_logic;

  -- DATA
  signal size_i_in_matrix_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_transpose   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_transpose  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR CONVOLUTION
  -- CONTROL
  signal start_tensor_convolution : std_logic;
  signal ready_tensor_convolution : std_logic;

  signal data_a_in_i_enable_tensor_convolution : std_logic;
  signal data_a_in_j_enable_tensor_convolution : std_logic;
  signal data_a_in_k_enable_tensor_convolution : std_logic;
  signal data_b_in_i_enable_tensor_convolution : std_logic;
  signal data_b_in_j_enable_tensor_convolution : std_logic;
  signal data_b_in_k_enable_tensor_convolution : std_logic;

  signal data_i_enable_tensor_convolution : std_logic;
  signal data_j_enable_tensor_convolution : std_logic;
  signal data_k_enable_tensor_convolution : std_logic;

  signal data_out_i_enable_tensor_convolution : std_logic;
  signal data_out_j_enable_tensor_convolution : std_logic;
  signal data_out_k_enable_tensor_convolution : std_logic;

  -- DATA
  signal size_a_i_in_tensor_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_k_in_tensor_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR MATRIX CONVOLUTION
  -- CONTROL
  signal start_tensor_matrix_convolution : std_logic;
  signal ready_tensor_matrix_convolution : std_logic;

  signal data_a_in_i_enable_tensor_matrix_convolution : std_logic;
  signal data_a_in_j_enable_tensor_matrix_convolution : std_logic;
  signal data_a_in_k_enable_tensor_matrix_convolution : std_logic;
  signal data_b_in_i_enable_tensor_matrix_convolution : std_logic;
  signal data_b_in_j_enable_tensor_matrix_convolution : std_logic;
  signal data_b_in_k_enable_tensor_matrix_convolution : std_logic;

  signal data_i_enable_tensor_matrix_convolution : std_logic;
  signal data_j_enable_tensor_matrix_convolution : std_logic;
  signal data_k_enable_tensor_matrix_convolution : std_logic;

  signal data_out_i_enable_tensor_matrix_convolution : std_logic;
  signal data_out_j_enable_tensor_matrix_convolution : std_logic;
  signal data_out_k_enable_tensor_matrix_convolution : std_logic;

  -- DATA
  signal size_a_i_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_k_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_matrix_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR INVERSE
  -- CONTROL
  signal start_tensor_inverse : std_logic;
  signal ready_tensor_inverse : std_logic;

  signal data_in_i_enable_tensor_inverse : std_logic;
  signal data_in_j_enable_tensor_inverse : std_logic;
  signal data_in_k_enable_tensor_inverse : std_logic;

  signal data_i_enable_tensor_inverse : std_logic;
  signal data_j_enable_tensor_inverse : std_logic;
  signal data_k_enable_tensor_inverse : std_logic;

  signal data_out_i_enable_tensor_inverse : std_logic;
  signal data_out_j_enable_tensor_inverse : std_logic;
  signal data_out_k_enable_tensor_inverse : std_logic;

  -- DATA
  signal size_i_in_tensor_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_inverse   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_inverse  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR PRODUCT
  -- CONTROL
  signal start_tensor_product : std_logic;
  signal ready_tensor_product : std_logic;

  signal data_a_in_i_enable_tensor_product : std_logic;
  signal data_a_in_j_enable_tensor_product : std_logic;
  signal data_a_in_k_enable_tensor_product : std_logic;
  signal data_b_in_i_enable_tensor_product : std_logic;
  signal data_b_in_j_enable_tensor_product : std_logic;
  signal data_b_in_k_enable_tensor_product : std_logic;

  signal data_i_enable_tensor_product : std_logic;
  signal data_j_enable_tensor_product : std_logic;
  signal data_k_enable_tensor_product : std_logic;

  signal data_out_i_enable_tensor_product : std_logic;
  signal data_out_j_enable_tensor_product : std_logic;
  signal data_out_k_enable_tensor_product : std_logic;

  -- DATA
  signal size_a_i_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_k_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_product    : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- TENSOR TRANSPOSE
  -- CONTROL
  signal start_tensor_transpose : std_logic;
  signal ready_tensor_transpose : std_logic;

  signal data_in_i_enable_tensor_transpose : std_logic;
  signal data_in_j_enable_tensor_transpose : std_logic;
  signal data_in_k_enable_tensor_transpose : std_logic;

  signal data_i_enable_tensor_transpose : std_logic;
  signal data_j_enable_tensor_transpose : std_logic;
  signal data_k_enable_tensor_transpose : std_logic;

  signal data_out_i_enable_tensor_transpose : std_logic;
  signal data_out_j_enable_tensor_transpose : std_logic;
  signal data_out_k_enable_tensor_transpose : std_logic;

  -- DATA
  signal size_i_in_tensor_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_transpose   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_transpose  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  algebra_stimulus : model_algebra_stimulus
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

      -- DOT PRODUCT
      -- CONTROL
      DOT_PRODUCT_START => start_dot_product,
      DOT_PRODUCT_READY => ready_dot_product,

      DOT_PRODUCT_DATA_A_IN_ENABLE => data_a_in_enable_dot_product,
      DOT_PRODUCT_DATA_B_IN_ENABLE => data_b_in_enable_dot_product,

      DOT_PRODUCT_DATA_OUT_ENABLE => data_out_enable_dot_product,

      -- DATA
      DOT_PRODUCT_LENGTH_IN => length_in_dot_product,
      DOT_PRODUCT_DATA_A_IN => data_a_in_dot_product,
      DOT_PRODUCT_DATA_B_IN => data_b_in_dot_product,
      DOT_PRODUCT_DATA_OUT  => data_out_dot_product,

      -- VECTOR CONVOLUTION
      -- CONTROL
      VECTOR_CONVOLUTION_START => start_vector_convolution,
      VECTOR_CONVOLUTION_READY => ready_vector_convolution,

      VECTOR_CONVOLUTION_DATA_A_IN_ENABLE => data_a_in_enable_vector_convolution,
      VECTOR_CONVOLUTION_DATA_B_IN_ENABLE => data_b_in_enable_vector_convolution,

      VECTOR_CONVOLUTION_DATA_ENABLE => data_enable_vector_convolution,

      VECTOR_CONVOLUTION_DATA_OUT_ENABLE => data_out_enable_vector_convolution,

      -- DATA
      VECTOR_CONVOLUTION_LENGTH_IN => length_in_vector_convolution,
      VECTOR_CONVOLUTION_DATA_A_IN => data_a_in_vector_convolution,
      VECTOR_CONVOLUTION_DATA_B_IN => data_b_in_vector_convolution,
      VECTOR_CONVOLUTION_DATA_OUT  => data_out_vector_convolution,

      -- VECTOR COSINE_SIMILARITY
      -- CONTROL
      VECTOR_COSINE_SIMILARITY_START => start_vector_cosine_similarity,
      VECTOR_COSINE_SIMILARITY_READY => ready_vector_cosine_similarity,

      VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE => data_a_in_enable_vector_cosine_similarity,
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE => data_b_in_enable_vector_cosine_similarity,

      VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE => data_out_enable_vector_cosine_similarity,

      -- DATA
      VECTOR_COSINE_SIMILARITY_LENGTH_IN => length_in_vector_cosine_similarity,
      VECTOR_COSINE_SIMILARITY_DATA_A_IN => data_a_in_vector_cosine_similarity,
      VECTOR_COSINE_SIMILARITY_DATA_B_IN => data_b_in_vector_cosine_similarity,
      VECTOR_COSINE_SIMILARITY_DATA_OUT  => data_out_vector_cosine_similarity,

      -- VECTOR MULTIPLICATION
      -- CONTROL
      VECTOR_MULTIPLICATION_START => start_vector_multiplication,
      VECTOR_MULTIPLICATION_READY => ready_vector_multiplication,

      VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE => data_in_length_enable_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_IN_ENABLE        => data_in_enable_vector_multiplication,

      VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE => data_length_enable_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_ENABLE        => data_enable_vector_multiplication,

      VECTOR_MULTIPLICATION_DATA_OUT_ENABLE => data_out_enable_vector_multiplication,

      -- DATA
      VECTOR_MULTIPLICATION_SIZE_IN   => size_in_vector_multiplication,
      VECTOR_MULTIPLICATION_LENGTH_IN => length_in_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_IN   => data_in_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_OUT  => data_out_vector_multiplication,

      -- VECTOR SUMMATION
      -- CONTROL
      VECTOR_SUMMATION_START => start_vector_summation,
      VECTOR_SUMMATION_READY => ready_vector_summation,

      VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE => data_in_length_enable_vector_summation,
      VECTOR_SUMMATION_DATA_IN_ENABLE        => data_in_enable_vector_summation,

      VECTOR_SUMMATION_DATA_LENGTH_ENABLE => data_length_enable_vector_summation,
      VECTOR_SUMMATION_DATA_ENABLE        => data_enable_vector_summation,

      VECTOR_SUMMATION_DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      VECTOR_SUMMATION_SIZE_IN   => size_in_vector_summation,
      VECTOR_SUMMATION_LENGTH_IN => length_in_vector_summation,
      VECTOR_SUMMATION_DATA_IN   => data_in_vector_summation,
      VECTOR_SUMMATION_DATA_OUT  => data_out_vector_summation,

      -- VECTOR MODULE
      -- CONTROL
      VECTOR_MODULE_START => start_vector_module,
      VECTOR_MODULE_READY => ready_vector_module,

      VECTOR_MODULE_DATA_IN_ENABLE => data_in_enable_vector_module,

      VECTOR_MODULE_DATA_ENABLE => data_enable_vector_module,

      VECTOR_MODULE_DATA_OUT_ENABLE => data_out_enable_vector_module,

      -- DATA
      VECTOR_MODULE_LENGTH_IN => length_in_vector_module,
      VECTOR_MODULE_DATA_IN   => data_in_vector_module,
      VECTOR_MODULE_DATA_OUT  => data_out_vector_module,

      -- MATRIX CONVOLUTION
      -- CONTROL
      MATRIX_CONVOLUTION_START => start_matrix_convolution,
      MATRIX_CONVOLUTION_READY => ready_matrix_convolution,

      MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_convolution,

      MATRIX_CONVOLUTION_DATA_I_ENABLE => data_i_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_J_ENABLE => data_j_enable_matrix_convolution,

      MATRIX_CONVOLUTION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_convolution,

      -- DATA
      MATRIX_CONVOLUTION_SIZE_A_I_IN => size_a_i_in_matrix_convolution,
      MATRIX_CONVOLUTION_SIZE_A_J_IN => size_a_j_in_matrix_convolution,
      MATRIX_CONVOLUTION_SIZE_B_I_IN => size_b_i_in_matrix_convolution,
      MATRIX_CONVOLUTION_SIZE_B_J_IN => size_b_j_in_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_A_IN   => data_a_in_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN   => data_b_in_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_OUT    => data_out_matrix_convolution,

      -- MATRIX VECTOR CONVOLUTION
      -- CONTROL
      MATRIX_VECTOR_CONVOLUTION_START => start_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_READY => ready_matrix_vector_convolution,

      MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_convolution,

      MATRIX_VECTOR_CONVOLUTION_DATA_I_ENABLE => data_i_enable_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE => data_j_enable_matrix_vector_convolution,

      MATRIX_VECTOR_CONVOLUTION_DATA_OUT_ENABLE => data_out_enable_matrix_vector_convolution,

      -- DATA
      MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN => size_a_i_in_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN => size_a_j_in_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_SIZE_B_IN   => size_b_in_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_DATA_A_IN   => data_a_in_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_DATA_B_IN   => data_b_in_matrix_vector_convolution,
      MATRIX_VECTOR_CONVOLUTION_DATA_OUT    => data_out_matrix_vector_convolution,

      -- MATRIX INVERSE
      -- CONTROL
      MATRIX_INVERSE_START => start_matrix_inverse,
      MATRIX_INVERSE_READY => ready_matrix_inverse,

      MATRIX_INVERSE_DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverse,
      MATRIX_INVERSE_DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverse,

      MATRIX_INVERSE_DATA_I_ENABLE => data_i_enable_matrix_inverse,
      MATRIX_INVERSE_DATA_J_ENABLE => data_j_enable_matrix_inverse,

      MATRIX_INVERSE_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverse,
      MATRIX_INVERSE_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverse,

      -- DATA
      MATRIX_INVERSE_SIZE_I_IN => size_i_in_matrix_inverse,
      MATRIX_INVERSE_SIZE_J_IN => size_j_in_matrix_inverse,
      MATRIX_INVERSE_DATA_IN   => data_in_matrix_inverse,
      MATRIX_INVERSE_DATA_OUT  => data_out_matrix_inverse,

      -- MATRIX MULTIPLICATION
      -- CONTROL
      MATRIX_MULTIPLICATION_START => start_matrix_multiplication,
      MATRIX_MULTIPLICATION_READY => ready_matrix_multiplication,

      MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE => data_in_length_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      => data_in_i_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      => data_in_j_enable_matrix_multiplication,

      MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE => data_length_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_I_ENABLE      => data_i_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_J_ENABLE      => data_j_enable_matrix_multiplication,

      MATRIX_MULTIPLICATION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_multiplication,

      -- DATA
      MATRIX_MULTIPLICATION_SIZE_I_IN => size_i_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_SIZE_J_IN => size_j_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_LENGTH_IN => length_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_IN   => data_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_OUT  => data_out_matrix_multiplication,

      -- MATRIX PRODUCT
      -- CONTROL
      MATRIX_PRODUCT_START => start_matrix_product,
      MATRIX_PRODUCT_READY => ready_matrix_product,

      MATRIX_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      MATRIX_PRODUCT_DATA_I_ENABLE => data_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_J_ENABLE => data_j_enable_matrix_product,

      MATRIX_PRODUCT_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      MATRIX_PRODUCT_SIZE_A_I_IN => size_a_i_in_matrix_product,
      MATRIX_PRODUCT_SIZE_A_J_IN => size_a_j_in_matrix_product,
      MATRIX_PRODUCT_SIZE_B_I_IN => size_b_i_in_matrix_product,
      MATRIX_PRODUCT_SIZE_B_J_IN => size_b_j_in_matrix_product,
      MATRIX_PRODUCT_DATA_A_IN   => data_a_in_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN   => data_b_in_matrix_product,
      MATRIX_PRODUCT_DATA_OUT    => data_out_matrix_product,

      -- MATRIX VECTOR PRODUCT
      -- CONTROL
      MATRIX_VECTOR_PRODUCT_START => start_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_READY => ready_matrix_vector_product,

      MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_product,

      MATRIX_VECTOR_PRODUCT_DATA_I_ENABLE => data_i_enable_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE => data_j_enable_matrix_vector_product,

      MATRIX_VECTOR_PRODUCT_DATA_OUT_ENABLE => data_out_enable_matrix_vector_product,

      -- DATA
      MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN => size_a_i_in_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN => size_a_j_in_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_SIZE_B_IN   => size_b_in_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_DATA_A_IN   => data_a_in_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_DATA_B_IN   => data_b_in_matrix_vector_product,
      MATRIX_VECTOR_PRODUCT_DATA_OUT    => data_out_matrix_vector_product,

      -- MATRIX SUMMATION
      -- CONTROL
      MATRIX_SUMMATION_START => start_matrix_summation,
      MATRIX_SUMMATION_READY => ready_matrix_summation,

      MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE => data_in_length_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_IN_I_ENABLE      => data_in_i_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_IN_J_ENABLE      => data_in_j_enable_matrix_summation,

      MATRIX_SUMMATION_DATA_LENGTH_ENABLE => data_length_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_I_ENABLE      => data_i_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_J_ENABLE      => data_j_enable_matrix_summation,

      MATRIX_SUMMATION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_summation,

      -- DATA
      MATRIX_SUMMATION_SIZE_I_IN => size_i_in_matrix_summation,
      MATRIX_SUMMATION_SIZE_J_IN => size_j_in_matrix_summation,
      MATRIX_SUMMATION_LENGTH_IN => length_in_matrix_summation,
      MATRIX_SUMMATION_DATA_IN   => data_in_matrix_summation,
      MATRIX_SUMMATION_DATA_OUT  => data_out_matrix_summation,

      -- MATRIX TRANSPOSE
      -- CONTROL
      MATRIX_TRANSPOSE_START => start_matrix_transpose,
      MATRIX_TRANSPOSE_READY => ready_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_IN_I_ENABLE => data_in_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_IN_J_ENABLE => data_in_j_enable_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_I_ENABLE => data_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_J_ENABLE => data_j_enable_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

      -- DATA
      MATRIX_TRANSPOSE_SIZE_I_IN => size_i_in_matrix_transpose,
      MATRIX_TRANSPOSE_SIZE_J_IN => size_j_in_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_IN   => data_in_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_OUT  => data_out_matrix_transpose,

      -- TENSOR CONVOLUTION
      -- CONTROL
      TENSOR_CONVOLUTION_START => start_tensor_convolution,
      TENSOR_CONVOLUTION_READY => ready_tensor_convolution,

      TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_convolution,

      TENSOR_CONVOLUTION_DATA_I_ENABLE => data_i_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_J_ENABLE => data_j_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_K_ENABLE => data_k_enable_tensor_convolution,

      TENSOR_CONVOLUTION_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_convolution,

      -- DATA
      TENSOR_CONVOLUTION_SIZE_A_I_IN => size_a_i_in_tensor_convolution,
      TENSOR_CONVOLUTION_SIZE_A_J_IN => size_a_j_in_tensor_convolution,
      TENSOR_CONVOLUTION_SIZE_A_K_IN => size_a_k_in_tensor_convolution,
      TENSOR_CONVOLUTION_SIZE_B_I_IN => size_b_i_in_tensor_convolution,
      TENSOR_CONVOLUTION_SIZE_B_J_IN => size_b_j_in_tensor_convolution,
      TENSOR_CONVOLUTION_SIZE_B_K_IN => size_b_k_in_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_A_IN   => data_a_in_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_B_IN   => data_b_in_tensor_convolution,
      TENSOR_CONVOLUTION_DATA_OUT    => data_out_tensor_convolution,

      -- TENSOR MATRIX CONVOLUTION
      -- CONTROL
      TENSOR_MATRIX_CONVOLUTION_START => start_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_READY => ready_tensor_matrix_convolution,

      TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_convolution,

      TENSOR_MATRIX_CONVOLUTION_DATA_I_ENABLE => data_i_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE => data_j_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE => data_k_enable_tensor_matrix_convolution,

      TENSOR_MATRIX_CONVOLUTION_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_convolution,

      -- DATA
      TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN => size_a_i_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN => size_a_j_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN => size_a_k_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_SIZE_B_I_IN => size_b_i_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_SIZE_B_J_IN => size_b_j_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_A_IN   => data_a_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_B_IN   => data_b_in_tensor_matrix_convolution,
      TENSOR_MATRIX_CONVOLUTION_DATA_OUT    => data_out_tensor_matrix_convolution,

      -- TENSOR INVERSE
      -- CONTROL
      TENSOR_INVERSE_START => start_tensor_inverse,
      TENSOR_INVERSE_READY => ready_tensor_inverse,

      TENSOR_INVERSE_DATA_IN_I_ENABLE => data_in_i_enable_tensor_inverse,
      TENSOR_INVERSE_DATA_IN_J_ENABLE => data_in_j_enable_tensor_inverse,
      TENSOR_INVERSE_DATA_IN_K_ENABLE => data_in_k_enable_tensor_inverse,

      TENSOR_INVERSE_DATA_I_ENABLE => data_i_enable_tensor_inverse,
      TENSOR_INVERSE_DATA_J_ENABLE => data_j_enable_tensor_inverse,
      TENSOR_INVERSE_DATA_K_ENABLE => data_k_enable_tensor_inverse,

      TENSOR_INVERSE_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_inverse,
      TENSOR_INVERSE_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_inverse,
      TENSOR_INVERSE_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_inverse,

      -- DATA
      TENSOR_INVERSE_SIZE_I_IN => size_i_in_tensor_inverse,
      TENSOR_INVERSE_SIZE_J_IN => size_j_in_tensor_inverse,
      TENSOR_INVERSE_SIZE_K_IN => size_k_in_tensor_inverse,
      TENSOR_INVERSE_DATA_IN   => data_in_tensor_inverse,
      TENSOR_INVERSE_DATA_OUT  => data_out_tensor_inverse,

      -- TENSOR PRODUCT
      -- CONTROL
      TENSOR_PRODUCT_START => start_tensor_product,
      TENSOR_PRODUCT_READY => ready_tensor_product,

      TENSOR_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_product,

      TENSOR_PRODUCT_DATA_I_ENABLE => data_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_J_ENABLE => data_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_K_ENABLE => data_k_enable_tensor_product,

      TENSOR_PRODUCT_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_product,

      -- DATA
      TENSOR_PRODUCT_SIZE_A_I_IN => size_a_i_in_tensor_product,
      TENSOR_PRODUCT_SIZE_A_J_IN => size_a_j_in_tensor_product,
      TENSOR_PRODUCT_SIZE_A_K_IN => size_a_k_in_tensor_product,
      TENSOR_PRODUCT_SIZE_B_I_IN => size_b_i_in_tensor_product,
      TENSOR_PRODUCT_SIZE_B_J_IN => size_b_j_in_tensor_product,
      TENSOR_PRODUCT_SIZE_B_K_IN => size_b_k_in_tensor_product,
      TENSOR_PRODUCT_DATA_A_IN   => data_a_in_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN   => data_b_in_tensor_product,
      TENSOR_PRODUCT_DATA_OUT    => data_out_tensor_product,

      -- TENSOR MATRIX PRODUCT
      -- CONTROL
      TENSOR_MATRIX_PRODUCT_START => start_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_READY => ready_tensor_matrix_product,

      TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_product,

      TENSOR_MATRIX_PRODUCT_DATA_I_ENABLE => data_i_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE => data_j_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE => data_k_enable_tensor_matrix_product,

      TENSOR_MATRIX_PRODUCT_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_product,

      -- DATA
      TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN => size_a_i_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN => size_a_j_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN => size_a_k_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_SIZE_B_I_IN => size_b_i_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_SIZE_B_J_IN => size_b_j_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_A_IN   => data_a_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_B_IN   => data_b_in_tensor_matrix_product,
      TENSOR_MATRIX_PRODUCT_DATA_OUT    => data_out_tensor_matrix_product,

      -- TENSOR TRANSPOSE
      -- CONTROL
      TENSOR_TRANSPOSE_START => start_tensor_transpose,
      TENSOR_TRANSPOSE_READY => ready_tensor_transpose,

      TENSOR_TRANSPOSE_DATA_IN_I_ENABLE => data_in_i_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_IN_J_ENABLE => data_in_j_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_IN_K_ENABLE => data_in_k_enable_tensor_transpose,

      TENSOR_TRANSPOSE_DATA_I_ENABLE => data_i_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_J_ENABLE => data_j_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_K_ENABLE => data_k_enable_tensor_transpose,

      TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_transpose,

      -- DATA
      TENSOR_TRANSPOSE_SIZE_I_IN => size_i_in_tensor_transpose,
      TENSOR_TRANSPOSE_SIZE_J_IN => size_j_in_tensor_transpose,
      TENSOR_TRANSPOSE_SIZE_K_IN => size_k_in_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_IN   => data_in_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_OUT  => data_out_tensor_transpose
      );

  -- DOT PRODUCT
  model_dot_product_test : if (ENABLE_NTM_DOT_PRODUCT_TEST) generate
    dot_product : model_dot_product
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_dot_product,
        READY => ready_dot_product,

        DATA_A_IN_ENABLE => data_a_in_enable_dot_product,
        DATA_B_IN_ENABLE => data_b_in_enable_dot_product,

        DATA_OUT_ENABLE => data_out_enable_dot_product,

        -- DATA
        LENGTH_IN => length_in_dot_product,
        DATA_A_IN => data_a_in_dot_product,
        DATA_B_IN => data_b_in_dot_product,
        DATA_OUT  => data_out_dot_product
        );
  end generate model_dot_product_test;

  -- VECTOR CONVOLUTION
  model_vector_convolution_test : if (ENABLE_NTM_VECTOR_CONVOLUTION_TEST) generate
    vector_convolution : model_vector_convolution
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_convolution,
        READY => ready_vector_convolution,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_convolution,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_convolution,

        DATA_ENABLE => data_enable_vector_convolution,

        DATA_OUT_ENABLE => data_out_enable_vector_convolution,

        -- DATA
        LENGTH_IN => length_in_vector_convolution,
        DATA_A_IN => data_a_in_vector_convolution,
        DATA_B_IN => data_b_in_vector_convolution,
        DATA_OUT  => data_out_vector_convolution
        );
  end generate model_vector_convolution_test;

  -- VECTOR COSINE_SIMILARITY
  model_vector_cosine_similarity_test : if (ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST) generate
    vector_cosine_similarity : model_vector_cosine_similarity
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_cosine_similarity,
        READY => ready_vector_cosine_similarity,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_cosine_similarity,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_cosine_similarity,

        DATA_OUT_ENABLE => data_out_enable_vector_cosine_similarity,

        -- DATA
        LENGTH_IN => length_in_vector_cosine_similarity,
        DATA_A_IN => data_a_in_vector_cosine_similarity,
        DATA_B_IN => data_b_in_vector_cosine_similarity,
        DATA_OUT  => data_out_vector_cosine_similarity
        );
  end generate model_vector_cosine_similarity_test;

  -- VECTOR MULTIPLICATION
  model_vector_multiplication_test : if (ENABLE_NTM_VECTOR_MULTIPLICATION_TEST) generate
    vector_multiplication : model_vector_multiplication
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_multiplication,
        READY => ready_vector_multiplication,

        DATA_IN_LENGTH_ENABLE => data_in_length_enable_vector_multiplication,
        DATA_IN_ENABLE        => data_in_enable_vector_multiplication,

        DATA_LENGTH_ENABLE => data_length_enable_vector_multiplication,
        DATA_ENABLE        => data_enable_vector_multiplication,

        DATA_OUT_ENABLE => data_out_enable_vector_multiplication,

        -- DATA
        SIZE_IN   => size_in_vector_multiplication,
        LENGTH_IN => length_in_vector_multiplication,
        DATA_IN   => data_in_vector_multiplication,
        DATA_OUT  => data_out_vector_multiplication
        );
  end generate model_vector_multiplication_test;

  -- VECTOR SUMMATION
  model_vector_summation_test : if (ENABLE_NTM_VECTOR_SUMMATION_TEST) generate
    vector_summation : model_vector_summation
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

        DATA_LENGTH_ENABLE => data_length_enable_vector_summation,
        DATA_ENABLE        => data_enable_vector_summation,

        DATA_OUT_ENABLE => data_out_enable_vector_summation,

        -- DATA
        SIZE_IN   => size_in_vector_summation,
        LENGTH_IN => length_in_vector_summation,
        DATA_IN   => data_in_vector_summation,
        DATA_OUT  => data_out_vector_summation
        );
  end generate model_vector_summation_test;

  -- VECTOR MODULE
  model_vector_module_test : if (ENABLE_NTM_VECTOR_MODULE_TEST) generate
    vector_module : model_vector_module
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_module,
        READY => ready_vector_module,

        DATA_IN_ENABLE => data_in_enable_vector_module,

        DATA_ENABLE => data_enable_vector_module,

        DATA_OUT_ENABLE => data_out_enable_vector_module,

        -- DATA
        LENGTH_IN => length_in_vector_module,
        DATA_IN   => data_in_vector_module,
        DATA_OUT  => data_out_vector_module
        );
  end generate model_vector_module_test;

  vector_assertion : process (CLK, RST)
    variable i : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_dot_product = '1' and data_out_enable_dot_product = '1') then
        assert data_out_dot_product = DOT_PRODUCT_OUTPUT_0(i)
          report "DOT PRODUCT: CALCULATED = " & to_string(data_out_dot_product) & "; CORRECT = " & to_string(DOT_PRODUCT_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_dot_product = '1' and not data_out_dot_product = EMPTY) then
        assert data_out_dot_product = DOT_PRODUCT_OUTPUT_0(i)
          report "DOT PRODUCT: CALCULATED = " & to_string(data_out_dot_product) & "; CORRECT = " & to_string(DOT_PRODUCT_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_convolution = '1' and data_out_enable_vector_convolution = '1') then
        assert data_out_vector_convolution = VECTOR_CONVOLUTION_OUTPUT_0(i)
          report "VECTOR CONVOLUTION: CALCULATED = " & to_string(data_out_vector_convolution) & "; CORRECT = " & to_string(VECTOR_CONVOLUTION_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_convolution = '1' and not data_out_vector_convolution = EMPTY) then
        assert data_out_vector_convolution = VECTOR_CONVOLUTION_OUTPUT_0(i)
          report "VECTOR CONVOLUTION: CALCULATED = " & to_string(data_out_vector_convolution) & "; CORRECT = " & to_string(VECTOR_CONVOLUTION_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_cosine_similarity = '1' and data_out_enable_vector_cosine_similarity = '1') then
        assert data_out_vector_cosine_similarity = VECTOR_COSINE_SIMILARITY_OUTPUT_0(i)
          report "VECTOR COSINE SIMILARITY: CALCULATED = " & to_string(data_out_vector_cosine_similarity) & "; CORRECT = " & to_string(VECTOR_COSINE_SIMILARITY_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_cosine_similarity = '1' and not data_out_vector_cosine_similarity = EMPTY) then
        assert data_out_vector_cosine_similarity = VECTOR_COSINE_SIMILARITY_OUTPUT_0(i)
          report "VECTOR COSINE SIMILARITY: CALCULATED = " & to_string(data_out_vector_cosine_similarity) & "; CORRECT = " & to_string(VECTOR_COSINE_SIMILARITY_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_multiplication = '1' and data_out_enable_vector_multiplication = '1') then
        assert data_out_vector_multiplication = VECTOR_MULTIPLICATION_OUTPUT_0(i)
          report "VECTOR MULTIPLICATION: CALCULATED = " & to_string(data_out_vector_multiplication) & "; CORRECT = " & to_string(VECTOR_MULTIPLICATION_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_multiplication = '1' and not data_out_vector_multiplication = EMPTY) then
        assert data_out_vector_multiplication = VECTOR_MULTIPLICATION_OUTPUT_0(i)
          report "VECTOR MULTIPLICATION: CALCULATED = " & to_string(data_out_vector_multiplication) & "; CORRECT = " & to_string(VECTOR_MULTIPLICATION_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_summation = '1' and data_out_enable_vector_summation = '1') then
        assert data_out_vector_summation = VECTOR_SUMMATION_OUTPUT_0(i)
          report "VECTOR SUMMATION: CALCULATED = " & to_string(data_out_vector_summation) & "; CORRECT = " & to_string(VECTOR_SUMMATION_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_summation = '1' and not data_out_vector_summation = EMPTY) then
        assert data_out_vector_summation = VECTOR_SUMMATION_OUTPUT_0(i)
          report "VECTOR SUMMATION: CALCULATED = " & to_string(data_out_vector_summation) & "; CORRECT = " & to_string(VECTOR_SUMMATION_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_module = '1' and data_out_enable_vector_module = '1') then
        assert data_out_vector_module = VECTOR_MODULE_OUTPUT_0(i)
          report "VECTOR MODULE: CALCULATED = " & to_string(data_out_vector_module) & "; CORRECT = " & to_string(VECTOR_MODULE_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_module = '1' and not data_out_vector_module = EMPTY) then
        assert data_out_vector_module = VECTOR_MODULE_OUTPUT_0(i)
          report "VECTOR MODULE: CALCULATED = " & to_string(data_out_vector_module) & "; CORRECT = " & to_string(VECTOR_MODULE_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;
    end if;
  end process vector_assertion;

  -- MATRIX CONVOLUTION
  model_matrix_convolution_test : if (ENABLE_NTM_MATRIX_CONVOLUTION_TEST) generate
    matrix_convolution : model_matrix_convolution
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_convolution,
        READY => ready_matrix_convolution,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_convolution,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_convolution,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_convolution,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_convolution,

        DATA_I_ENABLE => data_i_enable_matrix_convolution,
        DATA_J_ENABLE => data_j_enable_matrix_convolution,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_convolution,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_convolution,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_matrix_convolution,
        SIZE_A_J_IN => size_a_j_in_matrix_convolution,
        SIZE_B_I_IN => size_b_i_in_matrix_convolution,
        SIZE_B_J_IN => size_b_j_in_matrix_convolution,
        DATA_A_IN   => data_a_in_matrix_convolution,
        DATA_B_IN   => data_b_in_matrix_convolution,
        DATA_OUT    => data_out_matrix_convolution
        );
  end generate model_matrix_convolution_test;

  -- MATRIX VECTOR CONVOLUTION
  model_matrix_vector_convolution_test : if (ENABLE_NTM_MATRIX_VECTOR_CONVOLUTION_TEST) generate
    matrix_vector_convolution : model_matrix_vector_convolution
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_vector_convolution,
        READY => ready_matrix_vector_convolution,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_convolution,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_convolution,
        DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_convolution,

        DATA_I_ENABLE => data_i_enable_matrix_vector_convolution,
        DATA_J_ENABLE => data_j_enable_matrix_vector_convolution,

        DATA_OUT_ENABLE => data_out_enable_matrix_vector_convolution,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_matrix_vector_convolution,
        SIZE_A_J_IN => size_a_j_in_matrix_vector_convolution,
        SIZE_B_IN   => size_b_in_matrix_vector_convolution,
        DATA_A_IN   => data_a_in_matrix_vector_convolution,
        DATA_B_IN   => data_b_in_matrix_vector_convolution,
        DATA_OUT    => data_out_matrix_vector_convolution
        );
  end generate model_matrix_vector_convolution_test;

  -- MATRIX INVERSE
  model_matrix_inverse_test : if (ENABLE_NTM_MATRIX_INVERSE_TEST) generate
    matrix_inverse : model_matrix_inverse
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_inverse,
        READY => ready_matrix_inverse,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverse,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverse,

        DATA_I_ENABLE => data_i_enable_matrix_inverse,
        DATA_J_ENABLE => data_j_enable_matrix_inverse,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverse,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverse,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_inverse,
        SIZE_J_IN => size_j_in_matrix_inverse,
        DATA_IN   => data_in_matrix_inverse,
        DATA_OUT  => data_out_matrix_inverse
        );
  end generate model_matrix_inverse_test;

  -- MATRIX MULTIPLICATION
  model_matrix_multiplication_test : if (ENABLE_NTM_MATRIX_MULTIPLICATION_TEST) generate
    matrix_multiplication : model_matrix_multiplication
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_multiplication,
        READY => ready_matrix_multiplication,

        DATA_IN_LENGTH_ENABLE => data_in_length_enable_matrix_multiplication,
        DATA_IN_I_ENABLE      => data_in_i_enable_matrix_multiplication,
        DATA_IN_J_ENABLE      => data_in_j_enable_matrix_multiplication,

        DATA_LENGTH_ENABLE => data_length_enable_matrix_multiplication,
        DATA_I_ENABLE      => data_i_enable_matrix_multiplication,
        DATA_J_ENABLE      => data_j_enable_matrix_multiplication,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_multiplication,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_multiplication,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_multiplication,
        SIZE_J_IN => size_j_in_matrix_multiplication,
        LENGTH_IN => length_in_matrix_multiplication,
        DATA_IN   => data_in_matrix_multiplication,
        DATA_OUT  => data_out_matrix_multiplication
        );
  end generate model_matrix_multiplication_test;

  -- MATRIX PRODUCT
  model_matrix_product_test : if (ENABLE_NTM_MATRIX_PRODUCT_TEST) generate
    matrix_product : model_matrix_product
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
  end generate model_matrix_product_test;

  -- MATRIX VECTOR PRODUCT
  model_matrix_vector_product_test : if (ENABLE_NTM_MATRIX_VECTOR_PRODUCT_TEST) generate
    matrix_vector_product : model_matrix_vector_product
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
  end generate model_matrix_vector_product_test;

  -- MATRIX SUMMATION
  model_matrix_summation_test : if (ENABLE_NTM_MATRIX_SUMMATION_TEST) generate
    matrix_summation : model_matrix_summation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_summation,
        READY => ready_matrix_summation,

        DATA_IN_LENGTH_ENABLE => data_in_length_enable_matrix_summation,
        DATA_IN_I_ENABLE      => data_in_i_enable_matrix_summation,
        DATA_IN_J_ENABLE      => data_in_j_enable_matrix_summation,

        DATA_LENGTH_ENABLE => data_length_enable_matrix_summation,
        DATA_I_ENABLE      => data_i_enable_matrix_summation,
        DATA_J_ENABLE      => data_j_enable_matrix_summation,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_summation,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_summation,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_summation,
        SIZE_J_IN => size_j_in_matrix_summation,
        LENGTH_IN => length_in_matrix_summation,
        DATA_IN   => data_in_matrix_summation,
        DATA_OUT  => data_out_matrix_summation
        );
  end generate model_matrix_summation_test;

  -- MATRIX TRANSPOSE
  model_matrix_transpose_test : if (ENABLE_NTM_MATRIX_TRANSPOSE_TEST) generate
    matrix_transpose : model_matrix_transpose
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_transpose,
        READY => ready_matrix_transpose,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_transpose,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_transpose,

        DATA_I_ENABLE => data_i_enable_matrix_transpose,
        DATA_J_ENABLE => data_j_enable_matrix_transpose,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_transpose,
        SIZE_J_IN => size_j_in_matrix_transpose,
        DATA_IN   => data_in_matrix_transpose,
        DATA_OUT  => data_out_matrix_transpose
        );
  end generate model_matrix_transpose_test;

  matrix_assertion : process (CLK, RST)
    variable i : integer := 0;
    variable j : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_matrix_convolution = '1' and data_out_i_enable_matrix_convolution = '1' and data_out_j_enable_matrix_convolution = '1') then
        assert data_out_matrix_convolution = MATRIX_CONVOLUTION_OUTPUT_0(i, j)
          report "MATRIX CONVOLUTION: CALCULATED = " & to_string(data_out_matrix_convolution) & "; CORRECT = " & to_string(MATRIX_CONVOLUTION_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_convolution = '1' and data_out_j_enable_matrix_convolution = '1' and not data_out_matrix_convolution = EMPTY) then
        assert data_out_matrix_convolution = MATRIX_CONVOLUTION_OUTPUT_0(i, j)
          report "MATRIX CONVOLUTION: CALCULATED = " & to_string(data_out_matrix_convolution) & "; CORRECT = " & to_string(MATRIX_CONVOLUTION_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_convolution = '1' and not data_out_matrix_convolution = EMPTY) then
        assert data_out_matrix_convolution = MATRIX_CONVOLUTION_OUTPUT_0(i, j)
          report "MATRIX CONVOLUTION: CALCULATED = " & to_string(data_out_matrix_convolution) & "; CORRECT = " & to_string(MATRIX_CONVOLUTION_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_vector_convolution = '1' and data_out_enable_matrix_vector_convolution = '1') then
        assert data_out_matrix_vector_convolution = MATRIX_VECTOR_CONVOLUTION_OUTPUT_0(i)
          report "MATRIX VECTOR CONVOLUTION: CALCULATED = " & to_string(data_out_matrix_vector_convolution) & "; CORRECT = " & to_string(MATRIX_VECTOR_CONVOLUTION_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_matrix_vector_convolution = '1' and not data_out_matrix_vector_convolution = EMPTY) then
        assert data_out_matrix_vector_convolution = MATRIX_VECTOR_CONVOLUTION_OUTPUT_0(i)
          report "MATRIX VECTOR CONVOLUTION: CALCULATED = " & to_string(data_out_matrix_vector_convolution) & "; CORRECT = " & to_string(MATRIX_VECTOR_CONVOLUTION_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_matrix_inverse = '1' and data_out_i_enable_matrix_inverse = '1' and data_out_j_enable_matrix_inverse = '1') then
        assert data_out_matrix_inverse = MATRIX_INVERSE_OUTPUT_0(i, j)
          report "MATRIX INVERSE: CALCULATED = " & to_string(data_out_matrix_inverse) & "; CORRECT = " & to_string(MATRIX_INVERSE_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_inverse = '1' and data_out_j_enable_matrix_inverse = '1' and not data_out_matrix_inverse = EMPTY) then
        assert data_out_matrix_inverse = MATRIX_INVERSE_OUTPUT_0(i, j)
          report "MATRIX INVERSE: CALCULATED = " & to_string(data_out_matrix_inverse) & "; CORRECT = " & to_string(MATRIX_INVERSE_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_inverse = '1' and not data_out_matrix_inverse = EMPTY) then
        assert data_out_matrix_inverse = MATRIX_INVERSE_OUTPUT_0(i, j)
          report "MATRIX INVERSE: CALCULATED = " & to_string(data_out_matrix_inverse) & "; CORRECT = " & to_string(MATRIX_INVERSE_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_multiplication = '1' and data_out_i_enable_matrix_multiplication = '1' and data_out_j_enable_matrix_multiplication = '1') then
        assert data_out_matrix_multiplication = MATRIX_MULTIPLICATION_OUTPUT_0(i, j)
          report "MATRIX MULTIPLICATION: CALCULATED = " & to_string(data_out_matrix_multiplication) & "; CORRECT = " & to_string(MATRIX_MULTIPLICATION_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_multiplication = '1' and data_out_j_enable_matrix_multiplication = '1' and not data_out_matrix_multiplication = EMPTY) then
        assert data_out_matrix_multiplication = MATRIX_MULTIPLICATION_OUTPUT_0(i, j)
          report "MATRIX MULTIPLICATION: CALCULATED = " & to_string(data_out_matrix_multiplication) & "; CORRECT = " & to_string(MATRIX_MULTIPLICATION_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_multiplication = '1' and not data_out_matrix_multiplication = EMPTY) then
        assert data_out_matrix_multiplication = MATRIX_MULTIPLICATION_OUTPUT_0(i, j)
          report "MATRIX MULTIPLICATION: CALCULATED = " & to_string(data_out_matrix_multiplication) & "; CORRECT = " & to_string(MATRIX_MULTIPLICATION_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_product = '1' and data_out_i_enable_matrix_product = '1' and data_out_j_enable_matrix_product = '1') then
        assert data_out_matrix_product = MATRIX_PRODUCT_OUTPUT_0(i, j)
          report "MATRIX PRODUCT: CALCULATED = " & to_string(data_out_matrix_product) & "; CORRECT = " & to_string(MATRIX_PRODUCT_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_product = '1' and data_out_j_enable_matrix_product = '1' and not data_out_matrix_product = EMPTY) then
        assert data_out_matrix_product = MATRIX_PRODUCT_OUTPUT_0(i, j)
          report "MATRIX PRODUCT: CALCULATED = " & to_string(data_out_matrix_product) & "; CORRECT = " & to_string(MATRIX_PRODUCT_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_product = '1' and not data_out_matrix_product = EMPTY) then
        assert data_out_matrix_product = MATRIX_PRODUCT_OUTPUT_0(i, j)
          report "MATRIX PRODUCT: CALCULATED = " & to_string(data_out_matrix_product) & "; CORRECT = " & to_string(MATRIX_PRODUCT_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_vector_product = '1' and data_out_enable_matrix_vector_product = '1') then
        assert data_out_matrix_vector_product = MATRIX_VECTOR_PRODUCT_OUTPUT_0(i)
          report "MATRIX VECTOR PRODUCT: CALCULATED = " & to_string(data_out_matrix_vector_product) & "; CORRECT = " & to_string(MATRIX_VECTOR_PRODUCT_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_matrix_vector_product = '1' and not data_out_matrix_vector_product = EMPTY) then
        assert data_out_matrix_vector_product = MATRIX_VECTOR_PRODUCT_OUTPUT_0(i)
          report "MATRIX VECTOR PRODUCT: CALCULATED = " & to_string(data_out_matrix_vector_product) & "; CORRECT = " & to_string(MATRIX_VECTOR_PRODUCT_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_matrix_summation = '1' and data_out_i_enable_matrix_summation = '1' and data_out_j_enable_matrix_summation = '1') then
        assert data_out_matrix_summation = MATRIX_SUMMATION_OUTPUT_0(i, j)
          report "MATRIX SUMMATION: CALCULATED = " & to_string(data_out_matrix_summation) & "; CORRECT = " & to_string(MATRIX_SUMMATION_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_summation = '1' and data_out_j_enable_matrix_summation = '1' and not data_out_matrix_summation = EMPTY) then
        assert data_out_matrix_summation = MATRIX_SUMMATION_OUTPUT_0(i, j)
          report "MATRIX SUMMATION: CALCULATED = " & to_string(data_out_matrix_summation) & "; CORRECT = " & to_string(MATRIX_SUMMATION_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_summation = '1' and not data_out_matrix_summation = EMPTY) then
        assert data_out_matrix_summation = MATRIX_SUMMATION_OUTPUT_0(i, j)
          report "MATRIX SUMMATION: CALCULATED = " & to_string(data_out_matrix_summation) & "; CORRECT = " & to_string(MATRIX_SUMMATION_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_transpose = '1' and data_out_i_enable_matrix_transpose = '1' and data_out_j_enable_matrix_transpose = '1') then
        assert data_out_matrix_transpose = MATRIX_TRANSPOSE_OUTPUT_0(i, j)
          report "MATRIX TRANSPOSE: CALCULATED = " & to_string(data_out_matrix_transpose) & "; CORRECT = " & to_string(MATRIX_TRANSPOSE_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_transpose = '1' and data_out_j_enable_matrix_transpose = '1' and not data_out_matrix_transpose = EMPTY) then
        assert data_out_matrix_transpose = MATRIX_TRANSPOSE_OUTPUT_0(i, j)
          report "MATRIX TRANSPOSE: CALCULATED = " & to_string(data_out_matrix_transpose) & "; CORRECT = " & to_string(MATRIX_TRANSPOSE_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_transpose = '1' and not data_out_matrix_transpose = EMPTY) then
        assert data_out_matrix_transpose = MATRIX_TRANSPOSE_OUTPUT_0(i, j)
          report "MATRIX TRANSPOSE: CALCULATED = " & to_string(data_out_matrix_transpose) & "; CORRECT = " & to_string(MATRIX_TRANSPOSE_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;
    end if;
  end process matrix_assertion;

  -- TENSOR CONVOLUTION
  model_tensor_convolution_test : if (ENABLE_NTM_TENSOR_CONVOLUTION_TEST) generate
    tensor_convolution : model_tensor_convolution
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_convolution,
        READY => ready_tensor_convolution,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_convolution,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_convolution,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_convolution,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_convolution,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_convolution,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_convolution,

        DATA_I_ENABLE => data_i_enable_tensor_convolution,
        DATA_J_ENABLE => data_j_enable_tensor_convolution,
        DATA_K_ENABLE => data_k_enable_tensor_convolution,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_convolution,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_convolution,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_convolution,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_tensor_convolution,
        SIZE_A_J_IN => size_a_j_in_tensor_convolution,
        SIZE_A_K_IN => size_a_k_in_tensor_convolution,
        SIZE_B_I_IN => size_b_i_in_tensor_convolution,
        SIZE_B_J_IN => size_b_j_in_tensor_convolution,
        SIZE_B_K_IN => size_b_k_in_tensor_convolution,
        DATA_A_IN   => data_a_in_tensor_convolution,
        DATA_B_IN   => data_b_in_tensor_convolution,
        DATA_OUT    => data_out_tensor_convolution
        );
  end generate model_tensor_convolution_test;

  -- TENSOR MATRIX CONVOLUTION
  model_tensor_matrix_convolution_test : if (ENABLE_NTM_TENSOR_MATRIX_CONVOLUTION_TEST) generate
    tensor_matrix_convolution : model_tensor_matrix_convolution
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_matrix_convolution,
        READY => ready_tensor_matrix_convolution,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_convolution,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_convolution,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_matrix_convolution,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_convolution,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_convolution,

        DATA_I_ENABLE => data_i_enable_tensor_matrix_convolution,
        DATA_J_ENABLE => data_j_enable_tensor_matrix_convolution,
        DATA_K_ENABLE => data_k_enable_tensor_matrix_convolution,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_convolution,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_convolution,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_tensor_matrix_convolution,
        SIZE_A_J_IN => size_a_j_in_tensor_matrix_convolution,
        SIZE_A_K_IN => size_a_k_in_tensor_matrix_convolution,
        SIZE_B_I_IN => size_b_i_in_tensor_matrix_convolution,
        SIZE_B_J_IN => size_b_j_in_tensor_matrix_convolution,
        DATA_A_IN   => data_a_in_tensor_matrix_convolution,
        DATA_B_IN   => data_b_in_tensor_matrix_convolution,
        DATA_OUT    => data_out_tensor_matrix_convolution
        );
  end generate model_tensor_matrix_convolution_test;

  -- TENSOR INVERSE
  model_tensor_inverse_test : if (ENABLE_NTM_TENSOR_INVERSE_TEST) generate
    tensor_inverse : model_tensor_inverse
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_inverse,
        READY => ready_tensor_inverse,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_inverse,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_inverse,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_inverse,

        DATA_I_ENABLE => data_i_enable_tensor_inverse,
        DATA_J_ENABLE => data_j_enable_tensor_inverse,
        DATA_K_ENABLE => data_k_enable_tensor_inverse,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_inverse,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_inverse,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_inverse,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_inverse,
        SIZE_J_IN => size_j_in_tensor_inverse,
        SIZE_K_IN => size_k_in_tensor_inverse,
        DATA_IN   => data_in_tensor_inverse,
        DATA_OUT  => data_out_tensor_inverse
        );
  end generate model_tensor_inverse_test;

  -- TENSOR PRODUCT
  model_tensor_product_test : if (ENABLE_NTM_TENSOR_PRODUCT_TEST) generate
    tensor_product : model_tensor_product
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_product,
        READY => ready_tensor_product,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_product,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_product,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_product,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_product,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_product,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_product,

        DATA_I_ENABLE => data_i_enable_tensor_product,
        DATA_J_ENABLE => data_j_enable_tensor_product,
        DATA_K_ENABLE => data_k_enable_tensor_product,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_product,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_product,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_product,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_tensor_product,
        SIZE_A_J_IN => size_a_j_in_tensor_product,
        SIZE_A_K_IN => size_a_k_in_tensor_product,
        SIZE_B_I_IN => size_b_i_in_tensor_product,
        SIZE_B_J_IN => size_b_j_in_tensor_product,
        SIZE_B_K_IN => size_b_k_in_tensor_product,
        DATA_A_IN   => data_a_in_tensor_product,
        DATA_B_IN   => data_b_in_tensor_product,
        DATA_OUT    => data_out_tensor_product
        );
  end generate model_tensor_product_test;

  -- TENSOR MATRIX PRODUCT
  model_tensor_matrix_product_test : if (ENABLE_NTM_TENSOR_MATRIX_PRODUCT_TEST) generate
    tensor_matrix_product : model_tensor_matrix_product
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
  end generate model_tensor_matrix_product_test;

  -- TENSOR TRANSPOSE
  model_tensor_transpose_test : if (ENABLE_NTM_TENSOR_TRANSPOSE_TEST) generate
    tensor_transpose : model_tensor_transpose
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_transpose,
        READY => ready_tensor_transpose,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_transpose,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_transpose,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_transpose,

        DATA_I_ENABLE => data_i_enable_tensor_transpose,
        DATA_J_ENABLE => data_j_enable_tensor_transpose,
        DATA_K_ENABLE => data_k_enable_tensor_transpose,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_transpose,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_transpose,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_transpose,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_transpose,
        SIZE_J_IN => size_j_in_tensor_transpose,
        SIZE_K_IN => size_k_in_tensor_transpose,
        DATA_IN   => data_in_tensor_transpose,
        DATA_OUT  => data_out_tensor_transpose
        );
  end generate model_tensor_transpose_test;

  tensor_assertion : process (CLK, RST)
    variable i : integer := 0;
    variable j : integer := 0;
    variable k : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_tensor_convolution = '1' and data_out_i_enable_tensor_convolution = '1' and data_out_j_enable_tensor_convolution = '1' and data_out_k_enable_tensor_convolution = '1') then
        assert data_out_tensor_convolution = TENSOR_CONVOLUTION_OUTPUT_0(i, j, k)
          report "TENSOR CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_convolution) & "; CORRECT = " & to_string(TENSOR_CONVOLUTION_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_convolution = '1' and data_out_j_enable_tensor_convolution = '1' and data_out_k_enable_tensor_convolution = '1' and not data_out_tensor_convolution = EMPTY) then
        assert data_out_tensor_convolution = TENSOR_CONVOLUTION_OUTPUT_0(i, j, k)
          report "TENSOR CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_convolution) & "; CORRECT = " & to_string(TENSOR_CONVOLUTION_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_convolution = '1' and data_out_k_enable_tensor_convolution = '1' and not data_out_tensor_convolution = EMPTY) then
        assert data_out_tensor_convolution = TENSOR_CONVOLUTION_OUTPUT_0(i, j, k)
          report "TENSOR CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_convolution) & "; CORRECT = " & to_string(TENSOR_CONVOLUTION_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_convolution = '1' and not data_out_tensor_convolution = EMPTY) then
        assert data_out_tensor_convolution = TENSOR_CONVOLUTION_OUTPUT_0(i, j, k)
          report "TENSOR CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_convolution) & "; CORRECT = " & to_string(TENSOR_CONVOLUTION_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_matrix_convolution = '1' and data_out_i_enable_tensor_matrix_convolution = '1' and data_out_j_enable_tensor_matrix_convolution = '1') then
        assert data_out_tensor_matrix_convolution = TENSOR_MATRIX_CONVOLUTION_OUTPUT_0(i, j)
          report "TENSOR MATRIX CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_matrix_convolution) & "; CORRECT = " & to_string(TENSOR_MATRIX_CONVOLUTION_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_tensor_matrix_convolution = '1' and data_out_j_enable_tensor_matrix_convolution = '1' and not data_out_tensor_matrix_convolution = EMPTY) then
        assert data_out_tensor_matrix_convolution = TENSOR_MATRIX_CONVOLUTION_OUTPUT_0(i, j)
          report "TENSOR MATRIX CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_matrix_convolution) & "; CORRECT = " & to_string(TENSOR_MATRIX_CONVOLUTION_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_tensor_matrix_convolution = '1' and not data_out_tensor_matrix_convolution = EMPTY) then
        assert data_out_tensor_matrix_convolution = TENSOR_MATRIX_CONVOLUTION_OUTPUT_0(i, j)
          report "TENSOR MATRIX CONVOLUTION: CALCULATED = " & to_string(data_out_tensor_matrix_convolution) & "; CORRECT = " & to_string(TENSOR_MATRIX_CONVOLUTION_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_tensor_inverse = '1' and data_out_i_enable_tensor_inverse = '1' and data_out_j_enable_tensor_inverse = '1' and data_out_k_enable_tensor_inverse = '1') then
        assert data_out_tensor_inverse = TENSOR_INVERSE_OUTPUT_0(i, j, k)
          report "TENSOR INVERSE: CALCULATED = " & to_string(data_out_tensor_inverse) & "; CORRECT = " & to_string(TENSOR_INVERSE_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_inverse = '1' and data_out_j_enable_tensor_inverse = '1' and data_out_k_enable_tensor_inverse = '1' and not data_out_tensor_inverse = EMPTY) then
        assert data_out_tensor_inverse = TENSOR_INVERSE_OUTPUT_0(i, j, k)
          report "TENSOR INVERSE: CALCULATED = " & to_string(data_out_tensor_inverse) & "; CORRECT = " & to_string(TENSOR_INVERSE_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_inverse = '1' and data_out_k_enable_tensor_inverse = '1' and not data_out_tensor_inverse = EMPTY) then
        assert data_out_tensor_inverse = TENSOR_INVERSE_OUTPUT_0(i, j, k)
          report "TENSOR INVERSE: CALCULATED = " & to_string(data_out_tensor_inverse) & "; CORRECT = " & to_string(TENSOR_INVERSE_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_inverse = '1' and not data_out_tensor_inverse = EMPTY) then
        assert data_out_tensor_inverse = TENSOR_INVERSE_OUTPUT_0(i, j, k)
          report "TENSOR INVERSE: CALCULATED = " & to_string(data_out_tensor_inverse) & "; CORRECT = " & to_string(TENSOR_INVERSE_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_product = '1' and data_out_i_enable_tensor_product = '1' and data_out_j_enable_tensor_product = '1' and data_out_k_enable_tensor_product = '1') then
        assert data_out_tensor_product = TENSOR_PRODUCT_OUTPUT_0(i, j, k)
          report "TENSOR PRODUCT: CALCULATED = " & to_string(data_out_tensor_product) & "; CORRECT = " & to_string(TENSOR_PRODUCT_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_product = '1' and data_out_j_enable_tensor_product = '1' and data_out_k_enable_tensor_product = '1' and not data_out_tensor_product = EMPTY) then
        assert data_out_tensor_product = TENSOR_PRODUCT_OUTPUT_0(i, j, k)
          report "TENSOR PRODUCT: CALCULATED = " & to_string(data_out_tensor_product) & "; CORRECT = " & to_string(TENSOR_PRODUCT_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_product = '1' and data_out_k_enable_tensor_product = '1' and not data_out_tensor_product = EMPTY) then
        assert data_out_tensor_product = TENSOR_PRODUCT_OUTPUT_0(i, j, k)
          report "TENSOR PRODUCT: CALCULATED = " & to_string(data_out_tensor_product) & "; CORRECT = " & to_string(TENSOR_PRODUCT_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_product = '1' and not data_out_tensor_product = EMPTY) then
        assert data_out_tensor_product = TENSOR_PRODUCT_OUTPUT_0(i, j, k)
          report "TENSOR PRODUCT: CALCULATED = " & to_string(data_out_tensor_product) & "; CORRECT = " & to_string(TENSOR_PRODUCT_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_matrix_product = '1' and data_out_i_enable_tensor_matrix_product = '1' and data_out_j_enable_tensor_matrix_product = '1') then
        assert data_out_tensor_matrix_product = TENSOR_MATRIX_PRODUCT_OUTPUT_0(i, j)
          report "TENSOR MATRIX PRODUCT: CALCULATED = " & to_string(data_out_tensor_matrix_product) & "; CORRECT = " & to_string(TENSOR_MATRIX_PRODUCT_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_tensor_matrix_product = '1' and data_out_j_enable_tensor_matrix_product = '1' and not data_out_tensor_matrix_product = EMPTY) then
        assert data_out_tensor_matrix_product = TENSOR_MATRIX_PRODUCT_OUTPUT_0(i, j)
          report "TENSOR MATRIX PRODUCT: CALCULATED = " & to_string(data_out_tensor_matrix_product) & "; CORRECT = " & to_string(TENSOR_MATRIX_PRODUCT_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_tensor_matrix_product = '1' and not data_out_tensor_matrix_product = EMPTY) then
        assert data_out_tensor_matrix_product = TENSOR_MATRIX_PRODUCT_OUTPUT_0(i, j)
          report "TENSOR MATRIX PRODUCT: CALCULATED = " & to_string(data_out_tensor_matrix_product) & "; CORRECT = " & to_string(TENSOR_MATRIX_PRODUCT_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_tensor_transpose = '1' and data_out_i_enable_tensor_transpose = '1' and data_out_j_enable_tensor_transpose = '1' and data_out_k_enable_tensor_transpose = '1') then
        assert data_out_tensor_transpose = TENSOR_TRANSPOSE_OUTPUT_0(i, j, k)
          report "TENSOR TRANSPOSE: CALCULATED = " & to_string(data_out_tensor_transpose) & "; CORRECT = " & to_string(TENSOR_TRANSPOSE_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_transpose = '1' and data_out_j_enable_tensor_transpose = '1' and data_out_k_enable_tensor_transpose = '1' and not data_out_tensor_transpose = EMPTY) then
        assert data_out_tensor_transpose = TENSOR_TRANSPOSE_OUTPUT_0(i, j, k)
          report "TENSOR TRANSPOSE: CALCULATED = " & to_string(data_out_tensor_transpose) & "; CORRECT = " & to_string(TENSOR_TRANSPOSE_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_transpose = '1' and data_out_k_enable_tensor_transpose = '1' and not data_out_tensor_transpose = EMPTY) then
        assert data_out_tensor_transpose = TENSOR_TRANSPOSE_OUTPUT_0(i, j, k)
          report "TENSOR TRANSPOSE: CALCULATED = " & to_string(data_out_tensor_transpose) & "; CORRECT = " & to_string(TENSOR_TRANSPOSE_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_transpose = '1' and not data_out_tensor_transpose = EMPTY) then
        assert data_out_tensor_transpose = TENSOR_TRANSPOSE_OUTPUT_0(i, j, k)
          report "TENSOR TRANSPOSE: CALCULATED = " & to_string(data_out_tensor_transpose) & "; CORRECT = " & to_string(TENSOR_TRANSPOSE_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;
    end if;
  end process tensor_assertion;

end model_algebra_testbench_architecture;
