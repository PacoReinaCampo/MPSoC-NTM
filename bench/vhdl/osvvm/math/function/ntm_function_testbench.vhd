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

use work.ntm_math_pkg.all;

entity ntm_function_testbench is
end ntm_function_testbench;

architecture ntm_function_testbench_architecture of ntm_function_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR CONVOLUTION
  -- CONTROL
  signal start_scalar_convolution : std_logic;
  signal ready_scalar_convolution : std_logic;

  signal data_in_enable_scalar_convolution : std_logic;

  signal data_out_enable_scalar_convolution : std_logic;

  -- DATA
  signal modulo_in_scalar_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR COSINE SIMILARITY
  -- CONTROL
  signal start_scalar_cosine : std_logic;
  signal ready_scalar_cosine : std_logic;

  signal data_in_enable_scalar_cosine : std_logic;

  signal data_out_enable_scalar_cosine : std_logic;

  -- DATA
  signal modulo_in_scalar_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLICATION
  -- CONTROL
  signal start_scalar_multiplication : std_logic;
  signal ready_scalar_multiplication : std_logic;

  signal data_in_enable_scalar_multiplication : std_logic;

  signal data_out_enable_scalar_multiplication : std_logic;

  -- DATA
  signal modulo_in_scalar_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR COSH
   -- CONTROL
  signal start_scalar_cosh : std_logic;
  signal ready_scalar_cosh : std_logic;

  -- DATA
  signal modulo_in_scalar_cosh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR SINH
  -- CONTROL
  signal start_scalar_sinh : std_logic;
  signal ready_scalar_sinh : std_logic;

  -- DATA
  signal modulo_in_scalar_sinh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR TANH
  -- CONTROL
  signal start_scalar_tanh : std_logic;
  signal ready_scalar_tanh : std_logic;

  -- DATA
  signal modulo_in_scalar_tanh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR LOGISTIC
  -- CONTROL
  signal start_scalar_logistic : std_logic;
  signal ready_scalar_logistic : std_logic;

  -- DATA
  signal modulo_in_scalar_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logistic  : std_logic;

  -- SCALAR SOFTMAX
  -- CONTROL
  signal start_scalar_softmax : std_logic;
  signal ready_scalar_softmax : std_logic;

  signal data_in_enable_scalar_softmax : std_logic;

  signal data_out_enable_scalar_softmax : std_logic;

  -- DATA
  signal modulo_in_scalar_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ONEPLUS
  -- CONTROL
  signal start_scalar_oneplus : std_logic;
  signal ready_scalar_oneplus : std_logic;

  -- DATA
  signal modulo_in_scalar_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR SUMMATION
  -- CONTROL
  signal start_scalar_summation : std_logic;
  signal ready_scalar_summation : std_logic;

  signal data_in_enable_scalar_summation : std_logic;

  signal data_out_enable_scalar_summation : std_logic;

  -- DATA
  signal modulo_in_scalar_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR CONVOLUTION
  -- CONTROL
  signal start_vector_convolution : std_logic;
  signal ready_vector_convolution : std_logic;

  signal data_a_in_vector_enable_vector_convolution : std_logic;
  signal data_a_in_scalar_enable_vector_convolution : std_logic;
  signal data_b_in_vector_enable_vector_convolution : std_logic;
  signal data_b_in_scalar_enable_vector_convolution : std_logic;

  signal data_out_vector_enable_vector_convolution : std_logic;
  signal data_out_scalar_enable_vector_convolution : std_logic;

  -- DATA
  signal modulo_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSINE SIMILARITY
  -- CONTROL
  signal start_vector_cosine : std_logic;
  signal ready_vector_cosine : std_logic;

  signal data_a_in_vector_enable_vector_cosine : std_logic;
  signal data_a_in_scalar_enable_vector_cosine : std_logic;
  signal data_b_in_vector_enable_vector_cosine : std_logic;
  signal data_b_in_scalar_enable_vector_cosine : std_logic;

  signal data_out_vector_enable_vector_cosine : std_logic;
  signal data_out_scalar_enable_vector_cosine : std_logic;

  -- DATA
  signal modulo_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_cosine   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLICATION
  -- CONTROL
  signal start_vector_multiplication : std_logic;
  signal ready_vector_multiplication : std_logic;

  signal data_in_vector_enable_vector_multiplication : std_logic;
  signal data_in_scalar_enable_vector_multiplication : std_logic;

  signal data_out_vector_enable_vector_multiplication : std_logic;
  signal data_out_scalar_enable_vector_multiplication : std_logic;

  -- DATA
  signal modulo_in_vector_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSH
  -- CONTROL
  signal start_vector_cosh : std_logic;
  signal ready_vector_cosh : std_logic;

  signal data_in_enable_vector_cosh : std_logic;

  signal data_out_enable_vector_cosh : std_logic;

  -- DATA
  signal modulo_in_vector_cosh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SINH
  -- CONTROL
  signal start_vector_sinh : std_logic;
  signal ready_vector_sinh : std_logic;

  signal data_in_enable_vector_sinh : std_logic;

  signal data_out_enable_vector_sinh : std_logic;

  -- DATA
  signal modulo_in_vector_sinh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal modulo_in_vector_tanh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal modulo_in_vector_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic  : std_logic;

  -- VECTOR SOFTMAX
  -- CONTROL
  signal start_vector_softmax : std_logic;
  signal ready_vector_softmax : std_logic;

  signal data_in_vector_enable_vector_softmax : std_logic;
  signal data_in_scalar_enable_vector_softmax : std_logic;

  signal data_out_vector_enable_vector_softmax : std_logic;
  signal data_out_scalar_enable_vector_softmax : std_logic;

  -- DATA
  signal modulo_in_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ONEPLUS
  -- CONTROL
  signal start_vector_oneplus : std_logic;
  signal ready_vector_oneplus : std_logic;

  signal data_in_enable_vector_oneplus : std_logic;

  signal data_out_enable_vector_oneplus : std_logic;

  -- DATA
  signal modulo_in_vector_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_vector_enable_vector_summation : std_logic;
  signal data_in_scalar_enable_vector_summation : std_logic;

  signal data_out_vector_enable_vector_summation : std_logic;
  signal data_out_scalar_enable_vector_summation : std_logic;

  -- DATA
  signal modulo_in_vector_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX CONVOLUTION
  -- CONTROL
  signal start_matrix_convolution : std_logic;
  signal ready_matrix_convolution : std_logic;

  signal data_a_in_matrix_enable_matrix_convolution : std_logic;
  signal data_a_in_vector_enable_matrix_convolution : std_logic;
  signal data_a_in_scalar_enable_matrix_convolution : std_logic;
  signal data_b_in_matrix_enable_matrix_convolution : std_logic;
  signal data_b_in_vector_enable_matrix_convolution : std_logic;
  signal data_b_in_scalar_enable_matrix_convolution : std_logic;

  signal data_out_matrix_enable_matrix_convolution : std_logic;
  signal data_out_vector_enable_matrix_convolution : std_logic;
  signal data_out_scalar_enable_matrix_convolution : std_logic;

  -- DATA
  signal modulo_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX COSINE SIMILARITY
  -- CONTROL
  signal start_matrix_cosine : std_logic;
  signal ready_matrix_cosine : std_logic;

  signal data_a_in_matrix_enable_matrix_cosine : std_logic;
  signal data_a_in_vector_enable_matrix_cosine : std_logic;
  signal data_a_in_scalar_enable_matrix_cosine : std_logic;
  signal data_b_in_matrix_enable_matrix_cosine : std_logic;
  signal data_b_in_vector_enable_matrix_cosine : std_logic;
  signal data_b_in_scalar_enable_matrix_cosine : std_logic;

  signal data_out_matrix_enable_matrix_cosine : std_logic;
  signal data_out_vector_enable_matrix_cosine : std_logic;
  signal data_out_scalar_enable_matrix_cosine : std_logic;

  -- DATA
  signal modulo_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX MULTIPLICATION
  -- CONTROL
  signal start_matrix_multiplication : std_logic;
  signal ready_matrix_multiplication : std_logic;

  signal data_in_matrix_enable_matrix_multiplication : std_logic;
  signal data_in_vector_enable_matrix_multiplication : std_logic;
  signal data_in_scalar_enable_matrix_multiplication : std_logic;

  signal data_out_matrix_enable_matrix_multiplication : std_logic;
  signal data_out_vector_enable_matrix_multiplication : std_logic;
  signal data_out_scalar_enable_matrix_multiplication : std_logic;

  -- DATA
  signal modulo_in_matrix_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX COSH
  -- CONTROL
  signal start_matrix_cosh : std_logic;
  signal ready_matrix_cosh : std_logic;

  signal data_in_i_enable_matrix_cosh : std_logic;
  signal data_in_j_enable_matrix_cosh : std_logic;

  signal data_out_i_enable_matrix_cosh : std_logic;
  signal data_out_j_enable_matrix_cosh : std_logic;

  -- DATA
  signal modulo_in_matrix_cosh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_cosh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_cosh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX SINH
  -- CONTROL
  signal start_matrix_sinh : std_logic;
  signal ready_matrix_sinh : std_logic;

  signal data_in_i_enable_matrix_sinh : std_logic;
  signal data_in_j_enable_matrix_sinh : std_logic;

  signal data_out_i_enable_matrix_sinh : std_logic;
  signal data_out_j_enable_matrix_sinh : std_logic;

  -- DATA
  signal modulo_in_matrix_sinh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_sinh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_sinh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TANH
  -- CONTROL
  signal start_matrix_tanh : std_logic;
  signal ready_matrix_tanh : std_logic;

  signal data_in_i_enable_matrix_tanh : std_logic;
  signal data_in_j_enable_matrix_tanh : std_logic;

  signal data_out_i_enable_matrix_tanh : std_logic;
  signal data_out_j_enable_matrix_tanh : std_logic;

  -- DATA
  signal modulo_in_matrix_tanh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_tanh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_tanh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX LOGISTIC
  -- CONTROL
  signal start_matrix_logistic : std_logic;
  signal ready_matrix_logistic : std_logic;

  signal data_in_i_enable_matrix_logistic : std_logic;
  signal data_in_j_enable_matrix_logistic : std_logic;

  signal data_out_i_enable_matrix_logistic : std_logic;
  signal data_out_j_enable_matrix_logistic : std_logic;

  -- DATA
  signal modulo_in_matrix_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_logistic  : std_logic;

  -- MATRIX SOFTMAX
  -- CONTROL
  signal start_matrix_softmax : std_logic;
  signal ready_matrix_softmax : std_logic;

  signal data_in_matrix_enable_matrix_softmax : std_logic;
  signal data_in_vector_enable_matrix_softmax : std_logic;
  signal data_in_scalar_enable_matrix_softmax : std_logic;

  signal data_out_matrix_enable_matrix_softmax : std_logic;
  signal data_out_vector_enable_matrix_softmax : std_logic;
  signal data_out_scalar_enable_matrix_softmax : std_logic;

  -- DATA
  signal modulo_in_matrix_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ONEPLUS
  -- CONTROL
  signal start_matrix_oneplus : std_logic;
  signal ready_matrix_oneplus : std_logic;

  signal data_in_i_enable_matrix_oneplus : std_logic;
  signal data_in_j_enable_matrix_oneplus : std_logic;

  signal data_out_i_enable_matrix_oneplus : std_logic;
  signal data_out_j_enable_matrix_oneplus : std_logic;

  -- DATA
  signal modulo_in_matrix_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX SUMMATION
  -- CONTROL
  signal start_matrix_summation : std_logic;
  signal ready_matrix_summation : std_logic;

  signal data_in_matrix_enable_matrix_summation : std_logic;
  signal data_in_vector_enable_matrix_summation : std_logic;
  signal data_in_scalar_enable_matrix_summation : std_logic;

  signal data_out_matrix_enable_matrix_summation : std_logic;
  signal data_out_vector_enable_matrix_summation : std_logic;
  signal data_out_scalar_enable_matrix_summation : std_logic;

  -- DATA
  signal modulo_in_matrix_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR CONVOLUTION
  scalar_convolution_function : ntm_scalar_convolution_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_convolution,
      READY => ready_scalar_convolution,

      DATA_IN_ENABLE => data_in_enable_scalar_convolution,

      DATA_OUT_ENABLE => data_out_enable_scalar_convolution,

      -- DATA
      MODULO_IN => modulo_in_scalar_convolution,
      LENGTH_IN => length_in_scalar_convolution,
      DATA_A_IN => data_a_in_scalar_convolution,
      DATA_B_IN => data_b_in_scalar_convolution,
      DATA_OUT  => data_out_scalar_convolution
      );

  -- SCALAR COSINE SIMILARITY
  scalar_cosine_similarity_function : ntm_scalar_cosine_similarity_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_cosine,
      READY => ready_scalar_cosine,

      DATA_IN_ENABLE => data_in_enable_scalar_cosine,

      DATA_OUT_ENABLE => data_out_enable_scalar_cosine,

      -- DATA
      MODULO_IN => modulo_in_scalar_cosine,
      LENGTH_IN => length_in_scalar_cosine,
      DATA_A_IN => data_a_in_scalar_cosine,
      DATA_B_IN => data_b_in_scalar_cosine,
      DATA_OUT  => data_out_scalar_cosine
      );

  -- SCALAR MULTIPLICATION
  scalar_multiplication_function : ntm_scalar_multiplication_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_multiplication,
      READY => ready_scalar_multiplication,

      DATA_IN_ENABLE => data_in_enable_scalar_multiplication,

      DATA_OUT_ENABLE => data_out_enable_scalar_multiplication,

      -- DATA
      MODULO_IN => modulo_in_scalar_multiplication,
      LENGTH_IN => length_in_scalar_multiplication,
      DATA_IN   => data_in_scalar_multiplication,
      DATA_OUT  => data_out_scalar_multiplication
      );

  -- SCALAR COSH
  scalar_cosh_function : ntm_scalar_cosh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_cosh,
      READY => ready_scalar_cosh,

      -- DATA
      MODULO_IN => modulo_in_scalar_cosh,
      DATA_IN   => data_in_scalar_cosh,
      DATA_OUT  => data_out_scalar_cosh
      );

  -- SCALAR SINH
  scalar_sinh_function : ntm_scalar_sinh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_sinh,
      READY => ready_scalar_sinh,

      -- DATA
      MODULO_IN => modulo_in_scalar_sinh,
      DATA_IN   => data_in_scalar_sinh,
      DATA_OUT  => data_out_scalar_sinh
      );

  -- SCALAR TANH
  scalar_tanh_function : ntm_scalar_tanh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_tanh,
      READY => ready_scalar_tanh,

      -- DATA
      MODULO_IN => modulo_in_scalar_tanh,
      DATA_IN   => data_in_scalar_tanh,
      DATA_OUT  => data_out_scalar_tanh
      );

  -- SCALAR LOGISTIC
  scalar_logistic_function : ntm_scalar_logistic_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_logistic,
      READY => ready_scalar_logistic,

      -- DATA
      MODULO_IN => modulo_in_scalar_logistic,
      DATA_IN   => data_in_scalar_logistic,
      DATA_OUT  => data_out_scalar_logistic
      );

  -- SCALAR SOFTMAX
  scalar_softmax_function : ntm_scalar_softmax_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_softmax,
      READY => ready_scalar_softmax,

      DATA_IN_ENABLE => data_in_enable_scalar_softmax,

      DATA_OUT_ENABLE => data_out_enable_scalar_softmax,

      -- DATA
      MODULO_IN => modulo_in_scalar_softmax,
      LENGTH_IN => length_in_scalar_softmax,
      DATA_IN   => data_in_scalar_softmax,
      DATA_OUT  => data_out_scalar_softmax
      );

  -- SCALAR ONEPLUS
  scalar_oneplus_function : ntm_scalar_oneplus_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_oneplus,
      READY => ready_scalar_oneplus,

      -- DATA
      MODULO_IN => modulo_in_scalar_oneplus,
      DATA_IN   => data_in_scalar_oneplus,
      DATA_OUT  => data_out_scalar_oneplus
      );

  -- SCALAR SUMMATION
  scalar_summation_function : ntm_scalar_summation_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_summation,
      READY => ready_scalar_summation,

      DATA_IN_ENABLE => data_in_enable_scalar_summation,

      DATA_OUT_ENABLE => data_out_enable_scalar_summation,

      -- DATA
      MODULO_IN => modulo_in_scalar_summation,
      LENGTH_IN => length_in_scalar_summation,
      DATA_IN   => data_in_scalar_summation,
      DATA_OUT  => data_out_scalar_summation
      );

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR CONVOLUTION
  vector_convolution_function : ntm_vector_convolution_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_convolution,
      READY => ready_vector_convolution,

      DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_vector_convolution,
      DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_vector_convolution,
      DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_vector_convolution,
      DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_vector_convolution,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_convolution,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_convolution,

      -- DATA
      MODULO_IN => modulo_in_vector_convolution,
      SIZE_IN   => size_in_vector_convolution,
      LENGTH_IN => length_in_vector_convolution,
      DATA_A_IN => data_a_in_vector_convolution,
      DATA_B_IN => data_b_in_vector_convolution,
      DATA_OUT  => data_out_vector_convolution
      );

  -- VECTOR COSINE SIMILARITY
  vector_cosine_similarity_function : ntm_vector_cosine_similarity_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_cosine,
      READY => ready_vector_cosine,

      DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_vector_cosine,
      DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_vector_cosine,
      DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_vector_cosine,
      DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_vector_cosine,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_cosine,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_cosine,

      -- DATA
      MODULO_IN => modulo_in_vector_cosine,
      SIZE_IN   => size_in_vector_cosine,
      LENGTH_IN => length_in_vector_cosine,
      DATA_A_IN => data_a_in_vector_cosine,
      DATA_B_IN => data_b_in_vector_cosine,
      DATA_OUT  => data_out_vector_cosine
      );

  -- VECTOR MULTIPLICATION
  vector_multiplication_function : ntm_vector_multiplication_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplication,
      READY => ready_vector_multiplication,

      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_multiplication,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_multiplication,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_multiplication,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_multiplication,

      -- DATA
      MODULO_IN => modulo_in_vector_multiplication,
      SIZE_IN   => size_in_vector_multiplication,
      LENGTH_IN => length_in_vector_multiplication,
      DATA_IN   => data_in_vector_multiplication,
      DATA_OUT  => data_out_vector_multiplication
      );

  -- VECTOR COSH
  vector_cosh_function : ntm_vector_cosh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_cosh,
      READY => ready_vector_cosh,

      DATA_IN_ENABLE => data_in_enable_vector_cosh,

      DATA_OUT_ENABLE => data_out_enable_vector_cosh,

      -- DATA
      MODULO_IN => modulo_in_vector_cosh,
      SIZE_IN   => size_in_vector_cosh,
      DATA_IN   => data_in_vector_cosh,
      DATA_OUT  => data_out_vector_cosh
      );

  -- VECTOR SINH
  vector_sinh_function : ntm_vector_sinh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_sinh,
      READY => ready_vector_sinh,

      DATA_IN_ENABLE => data_in_enable_vector_sinh,

      DATA_OUT_ENABLE => data_out_enable_vector_sinh,

      -- DATA
      MODULO_IN => modulo_in_vector_sinh,
      SIZE_IN   => size_in_vector_sinh,
      DATA_IN   => data_in_vector_sinh,
      DATA_OUT  => data_out_vector_sinh
      );

  -- VECTOR TANH
  vector_tanh_function : ntm_vector_tanh_function
    generic map (
      DATA_SIZE => DATA_SIZE
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
      MODULO_IN => modulo_in_vector_tanh,
      SIZE_IN   => size_in_vector_tanh,
      DATA_IN   => data_in_vector_tanh,
      DATA_OUT  => data_out_vector_tanh
      );

  -- VECTOR LOGISTIC
  vector_logistic_function : ntm_vector_logistic_function
    generic map (
      DATA_SIZE => DATA_SIZE
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
      MODULO_IN => modulo_in_vector_logistic,
      SIZE_IN   => size_in_vector_logistic,
      DATA_IN   => data_in_vector_logistic,
      DATA_OUT  => data_out_vector_logistic
      );

  -- VECTOR SOFTMAX
  vector_softmax_function : ntm_vector_softmax_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_softmax,
      READY => ready_vector_softmax,

      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_softmax,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_softmax,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_softmax,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_softmax,

      -- DATA
      MODULO_IN => modulo_in_vector_softmax,
      SIZE_IN   => size_in_vector_softmax,
      LENGTH_IN => length_in_vector_softmax,
      DATA_IN   => data_in_vector_softmax,
      DATA_OUT  => data_out_vector_softmax
      );

  -- VECTOR ONEPLUS
  vector_oneplus_function : ntm_vector_oneplus_function
    generic map (

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_oneplus,
      READY => ready_vector_oneplus,

      DATA_IN_ENABLE => data_in_enable_vector_oneplus,

      DATA_OUT_ENABLE => data_out_enable_vector_oneplus,

      -- DATA
      MODULO_IN => modulo_in_vector_oneplus,
      SIZE_IN   => size_in_vector_oneplus,
      DATA_IN   => data_in_vector_oneplus,
      DATA_OUT  => data_out_vector_oneplus
      );

  -- VECTOR SUMMATION
  vector_summation_function : ntm_vector_summation_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_summation,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_summation,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_summation,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_summation,

      -- DATA
      MODULO_IN => modulo_in_vector_summation,
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX CONVOLUTION
  matrix_convolution_function : ntm_matrix_convolution_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_convolution,
      READY => ready_matrix_convolution,

      DATA_A_IN_MATRIX_ENABLE => data_a_in_matrix_enable_matrix_convolution,
      DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_matrix_convolution,
      DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_matrix_convolution,
      DATA_B_IN_MATRIX_ENABLE => data_b_in_matrix_enable_matrix_convolution,
      DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_matrix_convolution,
      DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_matrix_convolution,

      DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_convolution,
      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_convolution,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_convolution,

      -- DATA
      MODULO_IN => modulo_in_matrix_convolution,
      SIZE_I_IN => size_i_in_matrix_convolution,
      SIZE_J_IN => size_j_in_matrix_convolution,
      LENGTH_IN => length_in_matrix_convolution,
      DATA_A_IN => data_a_in_matrix_convolution,
      DATA_B_IN => data_b_in_matrix_convolution,
      DATA_OUT  => data_out_matrix_convolution
      );

  -- MATRIX COSINE SIMILARITY
  matrix_cosine_similarity_function : ntm_matrix_cosine_similarity_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_cosine,
      READY => ready_matrix_cosine,

      DATA_A_IN_MATRIX_ENABLE => data_a_in_matrix_enable_matrix_cosine,
      DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_matrix_cosine,
      DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_matrix_cosine,
      DATA_B_IN_MATRIX_ENABLE => data_b_in_matrix_enable_matrix_cosine,
      DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_matrix_cosine,
      DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_matrix_cosine,

      DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_cosine,
      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_cosine,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_cosine,

      -- DATA
      MODULO_IN => modulo_in_matrix_cosine,
      SIZE_I_IN => size_i_in_matrix_cosine,
      SIZE_J_IN => size_j_in_matrix_cosine,
      LENGTH_IN => length_in_matrix_cosine,
      DATA_A_IN => data_a_in_matrix_cosine,
      DATA_B_IN => data_b_in_matrix_cosine,
      DATA_OUT  => data_out_matrix_cosine
      );

  -- MATRIX MULTIPLICATION
  matrix_multiplication_function : ntm_matrix_multiplication_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_multiplication,
      READY => ready_matrix_multiplication,

      DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_multiplication,
      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_multiplication,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_multiplication,

      DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_multiplication,
      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_multiplication,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_multiplication,

      -- DATA
      MODULO_IN => modulo_in_matrix_multiplication,
      SIZE_I_IN => size_i_in_matrix_multiplication,
      SIZE_J_IN => size_j_in_matrix_multiplication,
      LENGTH_IN => length_in_matrix_multiplication,
      DATA_IN   => data_in_matrix_multiplication,
      DATA_OUT  => data_out_matrix_multiplication
      );

  -- MATRIX COSH
  matrix_cosh_function : ntm_matrix_cosh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_cosh,
      READY => ready_matrix_cosh,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_cosh,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_cosh,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_cosh,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_cosh,

      -- DATA
      MODULO_IN => modulo_in_matrix_cosh,
      SIZE_I_IN => size_i_in_matrix_cosh,
      SIZE_J_IN => size_j_in_matrix_cosh,
      DATA_IN   => data_in_matrix_cosh,
      DATA_OUT  => data_out_matrix_cosh
      );

  -- MATRIX SINH
  matrix_sinh_function : ntm_matrix_sinh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_sinh,
      READY => ready_matrix_sinh,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_sinh,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_sinh,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_sinh,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_sinh,

      -- DATA
      MODULO_IN => modulo_in_matrix_sinh,
      SIZE_I_IN => size_i_in_matrix_sinh,
      SIZE_J_IN => size_j_in_matrix_sinh,
      DATA_IN   => data_in_matrix_sinh,
      DATA_OUT  => data_out_matrix_sinh
      );

  -- MATRIX TANH
  matrix_tanh_function : ntm_matrix_tanh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_tanh,
      READY => ready_matrix_tanh,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_tanh,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_tanh,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_tanh,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_tanh,

      -- DATA
      MODULO_IN => modulo_in_matrix_tanh,
      SIZE_I_IN => size_i_in_matrix_tanh,
      SIZE_J_IN => size_j_in_matrix_tanh,
      DATA_IN   => data_in_matrix_tanh,
      DATA_OUT  => data_out_matrix_tanh
      );

  -- MATRIX LOGISTIC
  matrix_logistic_function : ntm_matrix_logistic_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_logistic,
      READY => ready_matrix_logistic,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_logistic,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_logistic,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logistic,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logistic,

      -- DATA
      MODULO_IN => modulo_in_matrix_logistic,
      SIZE_I_IN => size_i_in_matrix_logistic,
      SIZE_J_IN => size_j_in_matrix_logistic,
      DATA_IN   => data_in_matrix_logistic,
      DATA_OUT  => data_out_matrix_logistic
      );

  -- MATRIX SOFTMAX
  matrix_softmax_function : ntm_matrix_softmax_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_softmax,
      READY => ready_matrix_softmax,

      DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_softmax,
      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_softmax,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_softmax,

      DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_softmax,
      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_softmax,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_softmax,

      -- DATA
      MODULO_IN => modulo_in_matrix_softmax,
      SIZE_I_IN => size_i_in_matrix_softmax,
      SIZE_J_IN => size_j_in_matrix_softmax,
      LENGTH_IN => length_in_matrix_softmax,
      DATA_IN   => data_in_matrix_softmax,
      DATA_OUT  => data_out_matrix_softmax
      );

  -- MATRIX ONEPLUS
  matrix_oneplus_function : ntm_matrix_oneplus_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_oneplus,
      READY => ready_matrix_oneplus,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_oneplus,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_oneplus,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_oneplus,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_oneplus,

      -- DATA
      MODULO_IN => modulo_in_matrix_oneplus,
      SIZE_I_IN => size_i_in_matrix_oneplus,
      SIZE_J_IN => size_j_in_matrix_oneplus,
      DATA_IN   => data_in_matrix_oneplus,
      DATA_OUT  => data_out_matrix_oneplus
      );

  -- MATRIX SUMMATION
  matrix_summation_function : ntm_matrix_summation_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_summation,
      READY => ready_matrix_summation,

      DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_summation,
      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_summation,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_summation,

      DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_summation,
      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_summation,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_summation,

      -- DATA
      MODULO_IN => modulo_in_matrix_summation,
      SIZE_I_IN => size_i_in_matrix_summation,
      SIZE_J_IN => size_j_in_matrix_summation,
      LENGTH_IN => length_in_matrix_summation,
      DATA_IN   => data_in_matrix_summation,
      DATA_OUT  => data_out_matrix_summation
      );

end ntm_function_testbench_architecture;
