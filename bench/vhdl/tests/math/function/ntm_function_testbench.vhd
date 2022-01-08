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
use work.ntm_function_pkg.all;

entity ntm_function_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- SCALAR-FUNCTIONALITY
    ENABLE_NTM_SCALAR_CONVOLUTION_TEST       : boolean := false;
    ENABLE_NTM_SCALAR_COSH_TEST              : boolean := false;
    ENABLE_NTM_SCALAR_COSINE_SIMILARITY_TEST : boolean := false;
    ENABLE_NTM_SCALAR_DIFFERENTIATION_TEST   : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST     : boolean := false;
    ENABLE_NTM_SCALAR_LOGARITHM_TEST         : boolean := false;
    ENABLE_NTM_SCALAR_LOGISTIC_TEST          : boolean := false;
    ENABLE_NTM_SCALAR_MULTIPLICATION_TEST    : boolean := false;
    ENABLE_NTM_SCALAR_ONEPLUS_TEST           : boolean := false;
    ENABLE_NTM_SCALAR_SINH_TEST              : boolean := false;
    ENABLE_NTM_SCALAR_SOFTMAX_TEST           : boolean := false;
    ENABLE_NTM_SCALAR_SUMMATION_TEST         : boolean := false;
    ENABLE_NTM_SCALAR_TANH_TEST              : boolean := false;

    ENABLE_NTM_SCALAR_CONVOLUTION_CASE_0       : boolean := false;
    ENABLE_NTM_SCALAR_COSH_CASE_0              : boolean := false;
    ENABLE_NTM_SCALAR_COSINE_SIMILARITY_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_DIFFERENTIATION_CASE_0   : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_CASE_0     : boolean := false;
    ENABLE_NTM_SCALAR_LOGARITHM_CASE_0         : boolean := false;
    ENABLE_NTM_SCALAR_LOGISTIC_CASE_0          : boolean := false;
    ENABLE_NTM_SCALAR_MULTIPLICATION_CASE_0    : boolean := false;
    ENABLE_NTM_SCALAR_ONEPLUS_CASE_0           : boolean := false;
    ENABLE_NTM_SCALAR_SINH_CASE_0              : boolean := false;
    ENABLE_NTM_SCALAR_SOFTMAX_CASE_0           : boolean := false;
    ENABLE_NTM_SCALAR_SUMMATION_CASE_0         : boolean := false;
    ENABLE_NTM_SCALAR_TANH_CASE_0              : boolean := false;

    ENABLE_NTM_SCALAR_CONVOLUTION_CASE_1       : boolean := false;
    ENABLE_NTM_SCALAR_COSH_CASE_1              : boolean := false;
    ENABLE_NTM_SCALAR_COSINE_SIMILARITY_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_DIFFERENTIATION_CASE_1   : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_CASE_1     : boolean := false;
    ENABLE_NTM_SCALAR_LOGARITHM_CASE_1         : boolean := false;
    ENABLE_NTM_SCALAR_LOGISTIC_CASE_1          : boolean := false;
    ENABLE_NTM_SCALAR_MULTIPLICATION_CASE_1    : boolean := false;
    ENABLE_NTM_SCALAR_ONEPLUS_CASE_1           : boolean := false;
    ENABLE_NTM_SCALAR_SINH_CASE_1              : boolean := false;
    ENABLE_NTM_SCALAR_SOFTMAX_CASE_1           : boolean := false;
    ENABLE_NTM_SCALAR_SUMMATION_CASE_1         : boolean := false;
    ENABLE_NTM_SCALAR_TANH_CASE_1              : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_CONVOLUTION_TEST       : boolean := false;
    ENABLE_NTM_VECTOR_COSH_TEST              : boolean := false;
    ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST : boolean := false;
    ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST   : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST     : boolean := false;
    ENABLE_NTM_VECTOR_LOGARITHM_TEST         : boolean := false;
    ENABLE_NTM_VECTOR_LOGISTIC_TEST          : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLICATION_TEST    : boolean := false;
    ENABLE_NTM_VECTOR_ONEPLUS_TEST           : boolean := false;
    ENABLE_NTM_VECTOR_SINH_TEST              : boolean := false;
    ENABLE_NTM_VECTOR_SOFTMAX_TEST           : boolean := false;
    ENABLE_NTM_VECTOR_SUMMATION_TEST         : boolean := false;
    ENABLE_NTM_VECTOR_TANH_TEST              : boolean := false;

    ENABLE_NTM_VECTOR_CONVOLUTION_CASE_0       : boolean := false;
    ENABLE_NTM_VECTOR_COSH_CASE_0              : boolean := false;
    ENABLE_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_DIFFERENTIATION_CASE_0   : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_CASE_0     : boolean := false;
    ENABLE_NTM_VECTOR_LOGARITHM_CASE_0         : boolean := false;
    ENABLE_NTM_VECTOR_LOGISTIC_CASE_0          : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLICATION_CASE_0    : boolean := false;
    ENABLE_NTM_VECTOR_ONEPLUS_CASE_0           : boolean := false;
    ENABLE_NTM_VECTOR_SINH_CASE_0              : boolean := false;
    ENABLE_NTM_VECTOR_SOFTMAX_CASE_0           : boolean := false;
    ENABLE_NTM_VECTOR_SUMMATION_CASE_0         : boolean := false;
    ENABLE_NTM_VECTOR_TANH_CASE_0              : boolean := false;

    ENABLE_NTM_VECTOR_CONVOLUTION_CASE_1       : boolean := false;
    ENABLE_NTM_VECTOR_COSH_CASE_1              : boolean := false;
    ENABLE_NTM_VECTOR_COSINE_SIMILARITY_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_DIFFERENTIATION_CASE_1   : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_CASE_1     : boolean := false;
    ENABLE_NTM_VECTOR_LOGARITHM_CASE_1         : boolean := false;
    ENABLE_NTM_VECTOR_LOGISTIC_CASE_1          : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLICATION_CASE_1    : boolean := false;
    ENABLE_NTM_VECTOR_ONEPLUS_CASE_1           : boolean := false;
    ENABLE_NTM_VECTOR_SINH_CASE_1              : boolean := false;
    ENABLE_NTM_VECTOR_SOFTMAX_CASE_1           : boolean := false;
    ENABLE_NTM_VECTOR_SUMMATION_CASE_1         : boolean := false;
    ENABLE_NTM_VECTOR_TANH_CASE_1              : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_CONVOLUTION_TEST       : boolean := false;
    ENABLE_NTM_MATRIX_COSH_TEST              : boolean := false;
    ENABLE_NTM_MATRIX_COSINE_SIMILARITY_TEST : boolean := false;
    ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST   : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST     : boolean := false;
    ENABLE_NTM_MATRIX_LOGARITHM_TEST         : boolean := false;
    ENABLE_NTM_MATRIX_LOGISTIC_TEST          : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLICATION_TEST    : boolean := false;
    ENABLE_NTM_MATRIX_ONEPLUS_TEST           : boolean := false;
    ENABLE_NTM_MATRIX_SINH_TEST              : boolean := false;
    ENABLE_NTM_MATRIX_SOFTMAX_TEST           : boolean := false;
    ENABLE_NTM_MATRIX_SUMMATION_TEST         : boolean := false;
    ENABLE_NTM_MATRIX_TANH_TEST              : boolean := false;

    ENABLE_NTM_MATRIX_CONVOLUTION_CASE_0       : boolean := false;
    ENABLE_NTM_MATRIX_COSH_CASE_0              : boolean := false;
    ENABLE_NTM_MATRIX_COSINE_SIMILARITY_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_DIFFERENTIATION_CASE_0   : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_CASE_0     : boolean := false;
    ENABLE_NTM_MATRIX_LOGARITHM_CASE_0         : boolean := false;
    ENABLE_NTM_MATRIX_LOGISTIC_CASE_0          : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLICATION_CASE_0    : boolean := false;
    ENABLE_NTM_MATRIX_ONEPLUS_CASE_0           : boolean := false;
    ENABLE_NTM_MATRIX_SINH_CASE_0              : boolean := false;
    ENABLE_NTM_MATRIX_SOFTMAX_CASE_0           : boolean := false;
    ENABLE_NTM_MATRIX_SUMMATION_CASE_0         : boolean := false;
    ENABLE_NTM_MATRIX_TANH_CASE_0              : boolean := false;

    ENABLE_NTM_MATRIX_CONVOLUTION_CASE_1       : boolean := false;
    ENABLE_NTM_MATRIX_COSH_CASE_1              : boolean := false;
    ENABLE_NTM_MATRIX_COSINE_SIMILARITY_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_DIFFERENTIATION_CASE_1   : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_CASE_1     : boolean := false;
    ENABLE_NTM_MATRIX_LOGARITHM_CASE_1         : boolean := false;
    ENABLE_NTM_MATRIX_LOGISTIC_CASE_1          : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLICATION_CASE_1    : boolean := false;
    ENABLE_NTM_MATRIX_ONEPLUS_CASE_1           : boolean := false;
    ENABLE_NTM_MATRIX_SINH_CASE_1              : boolean := false;
    ENABLE_NTM_MATRIX_SOFTMAX_CASE_1           : boolean := false;
    ENABLE_NTM_MATRIX_SUMMATION_CASE_1         : boolean := false;
    ENABLE_NTM_MATRIX_TANH_CASE_1              : boolean := false
    );
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

  signal data_a_in_enable_scalar_convolution : std_logic;
  signal data_b_in_enable_scalar_convolution : std_logic;

  signal data_out_enable_scalar_convolution : std_logic;

  -- DATA
  signal length_in_scalar_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_scalar_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR COSH
  -- CONTROL
  signal start_scalar_cosh : std_logic;
  signal ready_scalar_cosh : std_logic;

  -- DATA
  signal data_in_scalar_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR COSINE SIMILARITY
  -- CONTROL
  signal start_scalar_cosine : std_logic;
  signal ready_scalar_cosine : std_logic;

  signal data_a_in_enable_scalar_cosine : std_logic;
  signal data_b_in_enable_scalar_cosine : std_logic;

  signal data_out_enable_scalar_cosine : std_logic;

  -- DATA
  signal length_in_scalar_cosine : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_scalar_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIFFERENTIATION
  -- CONTROL
  signal start_scalar_differentiation : std_logic;
  signal ready_scalar_differentiation : std_logic;

  signal data_in_enable_scalar_differentiation  : std_logic;
  signal data_out_enable_scalar_differentiation : std_logic;

  -- DATA
  signal size_in_scalar_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal period_in_scalar_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR EXPONENTIATOR
  -- CONTROL
  signal start_scalar_exponentiator : std_logic;
  signal ready_scalar_exponentiator : std_logic;

  -- DATA
  signal data_in_scalar_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR LOGARITHM
  -- CONTROL
  signal start_scalar_logarithm : std_logic;
  signal ready_scalar_logarithm : std_logic;

  -- DATA
  signal data_in_scalar_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR LOGISTIC
  -- CONTROL
  signal start_scalar_logistic : std_logic;
  signal ready_scalar_logistic : std_logic;

  -- DATA
  signal data_in_scalar_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logistic : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLICATION
  -- CONTROL
  signal start_scalar_multiplication : std_logic;
  signal ready_scalar_multiplication : std_logic;

  signal data_in_enable_scalar_multiplication : std_logic;

  signal data_out_enable_scalar_multiplication : std_logic;

  -- DATA
  signal length_in_scalar_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ONEPLUS
  -- CONTROL
  signal start_scalar_oneplus : std_logic;
  signal ready_scalar_oneplus : std_logic;

  -- DATA
  signal data_in_scalar_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR SINH
  -- CONTROL
  signal start_scalar_sinh : std_logic;
  signal ready_scalar_sinh : std_logic;

  -- DATA
  signal data_in_scalar_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR SOFTMAX
  -- CONTROL
  signal start_scalar_softmax : std_logic;
  signal ready_scalar_softmax : std_logic;

  signal data_in_enable_scalar_softmax : std_logic;

  signal data_out_enable_scalar_softmax : std_logic;

  -- DATA
  signal length_in_scalar_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR SUMMATION
  -- CONTROL
  signal start_scalar_summation : std_logic;
  signal ready_scalar_summation : std_logic;

  signal data_in_enable_scalar_summation : std_logic;

  signal data_out_enable_scalar_summation : std_logic;

  -- DATA
  signal length_in_scalar_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR TANH
  -- CONTROL
  signal start_scalar_tanh : std_logic;
  signal ready_scalar_tanh : std_logic;

  -- DATA
  signal data_in_scalar_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_in_vector_convolution   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSH
  -- CONTROL
  signal start_vector_cosh : std_logic;
  signal ready_vector_cosh : std_logic;

  signal data_in_enable_vector_cosh : std_logic;

  signal data_out_enable_vector_cosh : std_logic;

  -- DATA
  signal size_in_vector_cosh   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_in_vector_cosine   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_cosine : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_vector_enable_vector_differentiation : std_logic;
  signal data_in_scalar_enable_vector_differentiation : std_logic;

  signal data_out_vector_enable_vector_differentiation : std_logic;
  signal data_out_scalar_enable_vector_differentiation : std_logic;

  -- DATA
  signal size_in_vector_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal period_in_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal size_in_vector_exponentiator   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGARITHM
  -- CONTROL
  signal start_vector_logarithm : std_logic;
  signal ready_vector_logarithm : std_logic;

  signal data_in_enable_vector_logarithm : std_logic;

  signal data_out_enable_vector_logarithm : std_logic;

  -- DATA
  signal size_in_vector_logarithm   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal size_in_vector_logistic   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLICATION
  -- CONTROL
  signal start_vector_multiplication : std_logic;
  signal ready_vector_multiplication : std_logic;

  signal data_in_vector_enable_vector_multiplication : std_logic;
  signal data_in_scalar_enable_vector_multiplication : std_logic;

  signal data_out_vector_enable_vector_multiplication : std_logic;
  signal data_out_scalar_enable_vector_multiplication : std_logic;

  -- DATA
  signal length_in_vector_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_in_vector_multiplication   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ONEPLUS
  -- CONTROL
  signal start_vector_oneplus : std_logic;
  signal ready_vector_oneplus : std_logic;

  signal data_in_enable_vector_oneplus : std_logic;

  signal data_out_enable_vector_oneplus : std_logic;

  -- DATA
  signal size_in_vector_oneplus   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SINH
  -- CONTROL
  signal start_vector_sinh : std_logic;
  signal ready_vector_sinh : std_logic;

  signal data_in_enable_vector_sinh : std_logic;

  signal data_out_enable_vector_sinh : std_logic;

  -- DATA
  signal size_in_vector_sinh   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SOFTMAX
  -- CONTROL
  signal start_vector_softmax : std_logic;
  signal ready_vector_softmax : std_logic;

  signal data_in_vector_enable_vector_softmax : std_logic;
  signal data_in_scalar_enable_vector_softmax : std_logic;

  signal data_out_vector_enable_vector_softmax : std_logic;
  signal data_out_scalar_enable_vector_softmax : std_logic;

  -- DATA
  signal length_in_vector_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_in_vector_softmax   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_vector_enable_vector_summation : std_logic;
  signal data_in_scalar_enable_vector_summation : std_logic;

  signal data_out_vector_enable_vector_summation : std_logic;
  signal data_out_scalar_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal size_in_vector_tanh   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_i_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX COSH
  -- CONTROL
  signal start_matrix_cosh : std_logic;
  signal ready_matrix_cosh : std_logic;

  signal data_in_i_enable_matrix_cosh : std_logic;
  signal data_in_j_enable_matrix_cosh : std_logic;

  signal data_out_i_enable_matrix_cosh : std_logic;
  signal data_out_j_enable_matrix_cosh : std_logic;

  -- DATA
  signal size_i_in_matrix_cosh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_cosh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_i_in_matrix_cosine : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_cosine : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_cosine : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX DIFFERENTIATION
  -- CONTROL
  signal start_matrix_differentiation : std_logic;
  signal ready_matrix_differentiation : std_logic;

  signal data_in_matrix_enable_matrix_differentiation : std_logic;
  signal data_in_vector_enable_matrix_differentiation : std_logic;
  signal data_in_scalar_enable_matrix_differentiation : std_logic;

  signal data_out_matrix_enable_matrix_differentiation : std_logic;
  signal data_out_vector_enable_matrix_differentiation : std_logic;
  signal data_out_scalar_enable_matrix_differentiation : std_logic;

  -- DATA
  signal size_i_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal period_in_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX EXPONENTIATOR
  -- CONTROL
  signal start_matrix_exponentiator : std_logic;
  signal ready_matrix_exponentiator : std_logic;

  signal data_in_i_enable_matrix_exponentiator : std_logic;
  signal data_in_j_enable_matrix_exponentiator : std_logic;

  signal data_out_i_enable_matrix_exponentiator : std_logic;
  signal data_out_j_enable_matrix_exponentiator : std_logic;

  -- DATA
  signal size_i_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX LOGARITHM
  -- CONTROL
  signal start_matrix_logarithm : std_logic;
  signal ready_matrix_logarithm : std_logic;

  signal data_in_i_enable_matrix_logarithm : std_logic;
  signal data_in_j_enable_matrix_logarithm : std_logic;

  signal data_out_i_enable_matrix_logarithm : std_logic;
  signal data_out_j_enable_matrix_logarithm : std_logic;

  -- DATA
  signal size_i_in_matrix_logarithm : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_logarithm : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX LOGISTIC
  -- CONTROL
  signal start_matrix_logistic : std_logic;
  signal ready_matrix_logistic : std_logic;

  signal data_in_i_enable_matrix_logistic : std_logic;
  signal data_in_j_enable_matrix_logistic : std_logic;

  signal data_out_i_enable_matrix_logistic : std_logic;
  signal data_out_j_enable_matrix_logistic : std_logic;

  -- DATA
  signal size_i_in_matrix_logistic : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_logistic : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_i_in_matrix_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ONEPLUS
  -- CONTROL
  signal start_matrix_oneplus : std_logic;
  signal ready_matrix_oneplus : std_logic;

  signal data_in_i_enable_matrix_oneplus : std_logic;
  signal data_in_j_enable_matrix_oneplus : std_logic;

  signal data_out_i_enable_matrix_oneplus : std_logic;
  signal data_out_j_enable_matrix_oneplus : std_logic;

  -- DATA
  signal size_i_in_matrix_oneplus : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_oneplus : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX SINH
  -- CONTROL
  signal start_matrix_sinh : std_logic;
  signal ready_matrix_sinh : std_logic;

  signal data_in_i_enable_matrix_sinh : std_logic;
  signal data_in_j_enable_matrix_sinh : std_logic;

  signal data_out_i_enable_matrix_sinh : std_logic;
  signal data_out_j_enable_matrix_sinh : std_logic;

  -- DATA
  signal size_i_in_matrix_sinh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_sinh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_i_in_matrix_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_i_in_matrix_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TANH
  -- CONTROL
  signal start_matrix_tanh : std_logic;
  signal ready_matrix_tanh : std_logic;

  signal data_in_i_enable_matrix_tanh : std_logic;
  signal data_in_j_enable_matrix_tanh : std_logic;

  signal data_out_i_enable_matrix_tanh : std_logic;
  signal data_out_j_enable_matrix_tanh : std_logic;

  -- DATA
  signal size_i_in_matrix_tanh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_tanh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  function_stimulus : ntm_function_stimulus
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

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR
      -----------------------------------------------------------------------

      -- SCALAR CONVOLUTION
      -- CONTROL
      SCALAR_CONVOLUTION_START => start_scalar_convolution,
      SCALAR_CONVOLUTION_READY => ready_scalar_convolution,

      SCALAR_CONVOLUTION_DATA_A_IN_ENABLE => data_a_in_enable_scalar_convolution,
      SCALAR_CONVOLUTION_DATA_B_IN_ENABLE => data_b_in_enable_scalar_convolution,

      SCALAR_CONVOLUTION_DATA_OUT_ENABLE => data_out_enable_scalar_convolution,

      -- DATA
      SCALAR_CONVOLUTION_LENGTH_IN => length_in_scalar_convolution,
      SCALAR_CONVOLUTION_DATA_A_IN => data_a_in_scalar_convolution,
      SCALAR_CONVOLUTION_DATA_B_IN => data_b_in_scalar_convolution,
      SCALAR_CONVOLUTION_DATA_OUT  => data_out_scalar_convolution,

      -- SCALAR COSH
      -- CONTROL
      SCALAR_COSH_START => start_scalar_cosh,
      SCALAR_COSH_READY => ready_scalar_cosh,

      -- DATA
      SCALAR_COSH_DATA_IN   => data_in_scalar_cosh,
      SCALAR_COSH_DATA_OUT  => data_out_scalar_cosh,

      -- SCALAR COSINE SIMILARITY
      -- CONTROL
      SCALAR_COSINE_SIMILARITY_START => start_scalar_cosine,
      SCALAR_COSINE_SIMILARITY_READY => ready_scalar_cosine,

      SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE => data_a_in_enable_scalar_cosine,
      SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE => data_b_in_enable_scalar_cosine,

      SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE => data_out_enable_scalar_cosine,

      -- DATA
      SCALAR_COSINE_SIMILARITY_LENGTH_IN => length_in_scalar_cosine,
      SCALAR_COSINE_SIMILARITY_DATA_A_IN => data_a_in_scalar_cosine,
      SCALAR_COSINE_SIMILARITY_DATA_B_IN => data_b_in_scalar_cosine,
      SCALAR_COSINE_SIMILARITY_DATA_OUT  => data_out_scalar_cosine,

      -- SCALAR DIFFERENTIATION
      -- CONTROL
      SCALAR_DIFFERENTIATION_START => start_scalar_differentiation,
      SCALAR_DIFFERENTIATION_READY => ready_scalar_differentiation,

      SCALAR_DIFFERENTIATION_DATA_IN_ENABLE => data_in_enable_scalar_differentiation,

      SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE => data_out_enable_scalar_differentiation,

      -- DATA
      SCALAR_DIFFERENTIATION_PERIOD_IN => period_in_scalar_differentiation,
      SCALAR_DIFFERENTIATION_LENGTH_IN => length_in_scalar_differentiation,
      SCALAR_DIFFERENTIATION_DATA_IN   => data_in_scalar_differentiation,
      SCALAR_DIFFERENTIATION_DATA_OUT  => data_out_scalar_differentiation,

      -- SCALAR EXPONENTIATOR
      -- CONTROL
      SCALAR_EXPONENTIATOR_START => start_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_READY => ready_scalar_exponentiator,

      -- DATA
      SCALAR_EXPONENTIATOR_DATA_IN   => data_in_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_DATA_OUT  => data_out_scalar_exponentiator,

      -- SCALAR LOGARITHM
      -- CONTROL
      SCALAR_LOGARITHM_START => start_scalar_logarithm,
      SCALAR_LOGARITHM_READY => ready_scalar_logarithm,

      -- DATA
      SCALAR_LOGARITHM_DATA_IN   => data_in_scalar_logarithm,
      SCALAR_LOGARITHM_DATA_OUT  => data_out_scalar_logarithm,

      -- SCALAR LOGISTIC
      -- CONTROL
      SCALAR_LOGISTIC_START => start_scalar_logistic,
      SCALAR_LOGISTIC_READY => ready_scalar_logistic,

      -- DATA
      SCALAR_LOGISTIC_DATA_IN   => data_in_scalar_logistic,
      SCALAR_LOGISTIC_DATA_OUT  => data_out_scalar_logistic,

      -- SCALAR MULTIPLICATION
      -- CONTROL
      SCALAR_MULTIPLICATION_START => start_scalar_multiplication,
      SCALAR_MULTIPLICATION_READY => ready_scalar_multiplication,

      SCALAR_MULTIPLICATION_DATA_IN_ENABLE => data_in_enable_scalar_multiplication,

      SCALAR_MULTIPLICATION_DATA_OUT_ENABLE => data_out_enable_scalar_multiplication,

      -- DATA
      SCALAR_MULTIPLICATION_LENGTH_IN => length_in_scalar_multiplication,
      SCALAR_MULTIPLICATION_DATA_IN   => data_in_scalar_multiplication,
      SCALAR_MULTIPLICATION_DATA_OUT  => data_out_scalar_multiplication,

      -- SCALAR ONEPLUS
      -- CONTROL
      SCALAR_ONEPLUS_START => start_scalar_oneplus,
      SCALAR_ONEPLUS_READY => ready_scalar_oneplus,

      -- DATA
      SCALAR_ONEPLUS_DATA_IN   => data_in_scalar_oneplus,
      SCALAR_ONEPLUS_DATA_OUT  => data_out_scalar_oneplus,

      -- SCALAR SINH
      -- CONTROL
      SCALAR_SINH_START => start_scalar_sinh,
      SCALAR_SINH_READY => ready_scalar_sinh,

      -- DATA
      SCALAR_SINH_DATA_IN   => data_in_scalar_sinh,
      SCALAR_SINH_DATA_OUT  => data_out_scalar_sinh,

      -- SCALAR SOFTMAX
      -- CONTROL
      SCALAR_SOFTMAX_START => start_scalar_softmax,
      SCALAR_SOFTMAX_READY => ready_scalar_softmax,

      SCALAR_SOFTMAX_DATA_IN_ENABLE => data_in_enable_scalar_softmax,

      SCALAR_SOFTMAX_DATA_OUT_ENABLE => data_out_enable_scalar_softmax,

      -- DATA
      SCALAR_SOFTMAX_LENGTH_IN => length_in_scalar_softmax,
      SCALAR_SOFTMAX_DATA_IN   => data_in_scalar_softmax,
      SCALAR_SOFTMAX_DATA_OUT  => data_out_scalar_softmax,

      -- SCALAR SUMMATION
      -- CONTROL
      SCALAR_SUMMATION_START => start_scalar_summation,
      SCALAR_SUMMATION_READY => ready_scalar_summation,

      SCALAR_SUMMATION_DATA_IN_ENABLE => data_in_enable_scalar_summation,

      SCALAR_SUMMATION_DATA_OUT_ENABLE => data_out_enable_scalar_summation,

      -- DATA
      SCALAR_SUMMATION_LENGTH_IN => length_in_scalar_summation,
      SCALAR_SUMMATION_DATA_IN   => data_in_scalar_summation,
      SCALAR_SUMMATION_DATA_OUT  => data_out_scalar_summation,

      -- SCALAR TANH
      -- CONTROL
      SCALAR_TANH_START => start_scalar_tanh,
      SCALAR_TANH_READY => ready_scalar_tanh,

      -- DATA
      SCALAR_TANH_DATA_IN   => data_in_scalar_tanh,
      SCALAR_TANH_DATA_OUT  => data_out_scalar_tanh,

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- VECTOR CONVOLUTION
      -- CONTROL
      VECTOR_CONVOLUTION_START => start_vector_convolution,
      VECTOR_CONVOLUTION_READY => ready_vector_convolution,

      VECTOR_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_vector_convolution,
      VECTOR_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_vector_convolution,
      VECTOR_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_vector_convolution,
      VECTOR_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_vector_convolution,

      VECTOR_CONVOLUTION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_convolution,
      VECTOR_CONVOLUTION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_convolution,

      -- DATA
      VECTOR_CONVOLUTION_SIZE_IN   => size_in_vector_convolution,
      VECTOR_CONVOLUTION_LENGTH_IN => length_in_vector_convolution,
      VECTOR_CONVOLUTION_DATA_A_IN => data_a_in_vector_convolution,
      VECTOR_CONVOLUTION_DATA_B_IN => data_b_in_vector_convolution,
      VECTOR_CONVOLUTION_DATA_OUT  => data_out_vector_convolution,

      -- VECTOR COSH
      -- CONTROL
      VECTOR_COSH_START => start_vector_cosh,
      VECTOR_COSH_READY => ready_vector_cosh,

      VECTOR_COSH_DATA_IN_ENABLE => data_in_enable_vector_cosh,

      VECTOR_COSH_DATA_OUT_ENABLE => data_out_enable_vector_cosh,

      -- DATA
      VECTOR_COSH_SIZE_IN   => size_in_vector_cosh,
      VECTOR_COSH_DATA_IN   => data_in_vector_cosh,
      VECTOR_COSH_DATA_OUT  => data_out_vector_cosh,

      -- VECTOR COSINE SIMILARITY
      -- CONTROL
      VECTOR_COSINE_SIMILARITY_START => start_vector_cosine,
      VECTOR_COSINE_SIMILARITY_READY => ready_vector_cosine,

      VECTOR_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_vector_cosine,

      VECTOR_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_cosine,

      -- DATA
      VECTOR_COSINE_SIMILARITY_SIZE_IN   => size_in_vector_cosine,
      VECTOR_COSINE_SIMILARITY_LENGTH_IN => length_in_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_A_IN => data_a_in_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_B_IN => data_b_in_vector_cosine,
      VECTOR_COSINE_SIMILARITY_DATA_OUT  => data_out_vector_cosine,

      -- VECTOR DIFFERENTIATION
      -- CONTROL
      VECTOR_DIFFERENTIATION_START => start_vector_differentiation,
      VECTOR_DIFFERENTIATION_READY => ready_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_differentiation,

      -- DATA
      VECTOR_DIFFERENTIATION_SIZE_IN   => size_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_LENGTH_IN => length_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_IN   => data_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_OUT  => data_out_vector_differentiation,

      -- VECTOR EXPONENTIATOR
      -- CONTROL
      VECTOR_EXPONENTIATOR_START => start_vector_exponentiator,
      VECTOR_EXPONENTIATOR_READY => ready_vector_exponentiator,

      VECTOR_EXPONENTIATOR_DATA_IN_ENABLE => data_in_enable_vector_exponentiator,

      VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      VECTOR_EXPONENTIATOR_SIZE_IN   => size_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_IN   => data_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_OUT  => data_out_vector_exponentiator,

      -- VECTOR LOGARITHM
      -- CONTROL
      VECTOR_LOGARITHM_START => start_vector_logarithm,
      VECTOR_LOGARITHM_READY => ready_vector_logarithm,

      VECTOR_LOGARITHM_DATA_IN_ENABLE => data_in_enable_vector_logarithm,

      VECTOR_LOGARITHM_DATA_OUT_ENABLE => data_out_enable_vector_logarithm,

      -- DATA
      VECTOR_LOGARITHM_SIZE_IN   => size_in_vector_logarithm,
      VECTOR_LOGARITHM_DATA_IN   => data_in_vector_logarithm,
      VECTOR_LOGARITHM_DATA_OUT  => data_out_vector_logarithm,

      -- VECTOR LOGISTIC
      -- CONTROL
      VECTOR_LOGISTIC_START => start_vector_logistic,
      VECTOR_LOGISTIC_READY => ready_vector_logistic,

      VECTOR_LOGISTIC_DATA_IN_ENABLE => data_in_enable_vector_logistic,

      VECTOR_LOGISTIC_DATA_OUT_ENABLE => data_out_enable_vector_logistic,

      -- DATA
      VECTOR_LOGISTIC_SIZE_IN   => size_in_vector_logistic,
      VECTOR_LOGISTIC_DATA_IN   => data_in_vector_logistic,
      VECTOR_LOGISTIC_DATA_OUT  => data_out_vector_logistic,

      -- VECTOR ONEPLUS
      -- CONTROL
      VECTOR_ONEPLUS_START => start_vector_oneplus,
      VECTOR_ONEPLUS_READY => ready_vector_oneplus,

      VECTOR_ONEPLUS_DATA_IN_ENABLE => data_in_enable_vector_oneplus,

      VECTOR_ONEPLUS_DATA_OUT_ENABLE => data_out_enable_vector_oneplus,

      -- DATA
      VECTOR_ONEPLUS_SIZE_IN   => size_in_vector_oneplus,
      VECTOR_ONEPLUS_DATA_IN   => data_in_vector_oneplus,
      VECTOR_ONEPLUS_DATA_OUT  => data_out_vector_oneplus,

      -- VECTOR MULTIPLICATION
      -- CONTROL
      VECTOR_MULTIPLICATION_START => start_vector_multiplication,
      VECTOR_MULTIPLICATION_READY => ready_vector_multiplication,

      VECTOR_MULTIPLICATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_multiplication,

      VECTOR_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_multiplication,

      -- DATA
      VECTOR_MULTIPLICATION_SIZE_IN   => size_in_vector_multiplication,
      VECTOR_MULTIPLICATION_LENGTH_IN => length_in_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_IN   => data_in_vector_multiplication,
      VECTOR_MULTIPLICATION_DATA_OUT  => data_out_vector_multiplication,

      -- VECTOR SINH
      -- CONTROL
      VECTOR_SINH_START => start_vector_sinh,
      VECTOR_SINH_READY => ready_vector_sinh,

      VECTOR_SINH_DATA_IN_ENABLE => data_in_enable_vector_sinh,

      VECTOR_SINH_DATA_OUT_ENABLE => data_out_enable_vector_sinh,

      -- DATA
      VECTOR_SINH_SIZE_IN   => size_in_vector_sinh,
      VECTOR_SINH_DATA_IN   => data_in_vector_sinh,
      VECTOR_SINH_DATA_OUT  => data_out_vector_sinh,

      -- VECTOR SOFTMAX
      -- CONTROL
      VECTOR_SOFTMAX_START => start_vector_softmax,
      VECTOR_SOFTMAX_READY => ready_vector_softmax,

      VECTOR_SOFTMAX_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_softmax,
      VECTOR_SOFTMAX_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_softmax,

      VECTOR_SOFTMAX_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_softmax,
      VECTOR_SOFTMAX_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_softmax,

      -- DATA
      VECTOR_SOFTMAX_SIZE_IN   => size_in_vector_softmax,
      VECTOR_SOFTMAX_LENGTH_IN => length_in_vector_softmax,
      VECTOR_SOFTMAX_DATA_IN   => data_in_vector_softmax,
      VECTOR_SOFTMAX_DATA_OUT  => data_out_vector_softmax,

      -- VECTOR SUMMATION
      -- CONTROL
      VECTOR_SUMMATION_START => start_vector_summation,
      VECTOR_SUMMATION_READY => ready_vector_summation,

      VECTOR_SUMMATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_summation,
      VECTOR_SUMMATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_summation,

      VECTOR_SUMMATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_summation,
      VECTOR_SUMMATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_summation,

      -- DATA
      VECTOR_SUMMATION_SIZE_IN   => size_in_vector_summation,
      VECTOR_SUMMATION_LENGTH_IN => length_in_vector_summation,
      VECTOR_SUMMATION_DATA_IN   => data_in_vector_summation,
      VECTOR_SUMMATION_DATA_OUT  => data_out_vector_summation,

      -- VECTOR TANH
      -- CONTROL
      VECTOR_TANH_START => start_vector_tanh,
      VECTOR_TANH_READY => ready_vector_tanh,

      VECTOR_TANH_DATA_IN_ENABLE => data_in_enable_vector_tanh,

      VECTOR_TANH_DATA_OUT_ENABLE => data_out_enable_vector_tanh,

      -- DATA
      VECTOR_TANH_SIZE_IN   => size_in_vector_tanh,
      VECTOR_TANH_DATA_IN   => data_in_vector_tanh,
      VECTOR_TANH_DATA_OUT  => data_out_vector_tanh,

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX
      -----------------------------------------------------------------------

      -- MATRIX CONVOLUTION
      -- CONTROL
      MATRIX_CONVOLUTION_START => start_matrix_convolution,
      MATRIX_CONVOLUTION_READY => ready_matrix_convolution,

      MATRIX_CONVOLUTION_DATA_A_IN_MATRIX_ENABLE => data_a_in_matrix_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN_MATRIX_ENABLE => data_b_in_matrix_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_matrix_convolution,

      MATRIX_CONVOLUTION_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_convolution,

      -- DATA
      MATRIX_CONVOLUTION_SIZE_I_IN => size_i_in_matrix_convolution,
      MATRIX_CONVOLUTION_SIZE_J_IN => size_j_in_matrix_convolution,
      MATRIX_CONVOLUTION_LENGTH_IN => length_in_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_A_IN => data_a_in_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_B_IN => data_b_in_matrix_convolution,
      MATRIX_CONVOLUTION_DATA_OUT  => data_out_matrix_convolution,

      -- MATRIX COSH
      -- CONTROL
      MATRIX_COSH_START => start_matrix_cosh,
      MATRIX_COSH_READY => ready_matrix_cosh,

      MATRIX_COSH_DATA_IN_I_ENABLE => data_in_i_enable_matrix_cosh,
      MATRIX_COSH_DATA_IN_J_ENABLE => data_in_j_enable_matrix_cosh,

      MATRIX_COSH_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_cosh,
      MATRIX_COSH_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_cosh,

      -- DATA
      MATRIX_COSH_SIZE_I_IN => size_i_in_matrix_cosh,
      MATRIX_COSH_SIZE_J_IN => size_j_in_matrix_cosh,
      MATRIX_COSH_DATA_IN   => data_in_matrix_cosh,
      MATRIX_COSH_DATA_OUT  => data_out_matrix_cosh,

      -- MATRIX COSINE SIMILARITY
      -- CONTROL
      MATRIX_COSINE_SIMILARITY_START => start_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_READY => ready_matrix_cosine,

      MATRIX_COSINE_SIMILARITY_DATA_A_IN_MATRIX_ENABLE => data_a_in_matrix_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_B_IN_MATRIX_ENABLE => data_b_in_matrix_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_matrix_cosine,

      MATRIX_COSINE_SIMILARITY_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_cosine,

      -- DATA
      MATRIX_COSINE_SIMILARITY_SIZE_I_IN => size_i_in_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_SIZE_J_IN => size_j_in_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_LENGTH_IN => length_in_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_A_IN => data_a_in_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_B_IN => data_b_in_matrix_cosine,
      MATRIX_COSINE_SIMILARITY_DATA_OUT  => data_out_matrix_cosine,

      -- MATRIX DIFFERENTIATION
      -- CONTROL
      MATRIX_DIFFERENTIATION_START => start_matrix_differentiation,
      MATRIX_DIFFERENTIATION_READY => ready_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_differentiation,

      -- DATA
      MATRIX_DIFFERENTIATION_SIZE_I_IN => size_i_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_SIZE_J_IN => size_j_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_PERIOD_IN => period_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_LENGTH_IN => length_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN   => data_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT  => data_out_matrix_differentiation,

      -- MATRIX EXPONENTIATOR
      -- CONTROL
      MATRIX_EXPONENTIATOR_START => start_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_READY => ready_matrix_exponentiator,

      MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE => data_in_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE => data_in_j_enable_matrix_exponentiator,

      MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

      -- DATA
      MATRIX_EXPONENTIATOR_SIZE_I_IN => size_i_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_SIZE_J_IN => size_j_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_IN   => data_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_OUT  => data_out_matrix_exponentiator,

      -- MATRIX LOGARITHM
      -- CONTROL
      MATRIX_LOGARITHM_START => start_matrix_logarithm,
      MATRIX_LOGARITHM_READY => ready_matrix_logarithm,

      MATRIX_LOGARITHM_DATA_IN_I_ENABLE => data_in_i_enable_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_IN_J_ENABLE => data_in_j_enable_matrix_logarithm,

      MATRIX_LOGARITHM_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logarithm,

      -- DATA
      MATRIX_LOGARITHM_SIZE_I_IN => size_i_in_matrix_logarithm,
      MATRIX_LOGARITHM_SIZE_J_IN => size_j_in_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_IN   => data_in_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_OUT  => data_out_matrix_logarithm,

      -- MATRIX LOGISTIC
      -- CONTROL
      MATRIX_LOGISTIC_START => start_matrix_logistic,
      MATRIX_LOGISTIC_READY => ready_matrix_logistic,

      MATRIX_LOGISTIC_DATA_IN_I_ENABLE => data_in_i_enable_matrix_logistic,
      MATRIX_LOGISTIC_DATA_IN_J_ENABLE => data_in_j_enable_matrix_logistic,

      MATRIX_LOGISTIC_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logistic,
      MATRIX_LOGISTIC_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logistic,

      -- DATA
      MATRIX_LOGISTIC_SIZE_I_IN => size_i_in_matrix_logistic,
      MATRIX_LOGISTIC_SIZE_J_IN => size_j_in_matrix_logistic,
      MATRIX_LOGISTIC_DATA_IN   => data_in_matrix_logistic,
      MATRIX_LOGISTIC_DATA_OUT  => data_out_matrix_logistic,

      -- MATRIX MULTIPLICATION
      -- CONTROL
      MATRIX_MULTIPLICATION_START => start_matrix_multiplication,
      MATRIX_MULTIPLICATION_READY => ready_matrix_multiplication,

      MATRIX_MULTIPLICATION_DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_multiplication,

      MATRIX_MULTIPLICATION_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_multiplication,

      -- DATA
      MATRIX_MULTIPLICATION_SIZE_I_IN => size_i_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_SIZE_J_IN => size_j_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_LENGTH_IN => length_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_IN   => data_in_matrix_multiplication,
      MATRIX_MULTIPLICATION_DATA_OUT  => data_out_matrix_multiplication,

      -- MATRIX ONEPLUS
      -- CONTROL
      MATRIX_ONEPLUS_START => start_matrix_oneplus,
      MATRIX_ONEPLUS_READY => ready_matrix_oneplus,

      MATRIX_ONEPLUS_DATA_IN_I_ENABLE => data_in_i_enable_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_IN_J_ENABLE => data_in_j_enable_matrix_oneplus,

      MATRIX_ONEPLUS_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_oneplus,

      -- DATA
      MATRIX_ONEPLUS_SIZE_I_IN => size_i_in_matrix_oneplus,
      MATRIX_ONEPLUS_SIZE_J_IN => size_j_in_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_IN   => data_in_matrix_oneplus,
      MATRIX_ONEPLUS_DATA_OUT  => data_out_matrix_oneplus,

      -- MATRIX SINH
      -- CONTROL
      MATRIX_SINH_START => start_matrix_sinh,
      MATRIX_SINH_READY => ready_matrix_sinh,

      MATRIX_SINH_DATA_IN_I_ENABLE => data_in_i_enable_matrix_sinh,
      MATRIX_SINH_DATA_IN_J_ENABLE => data_in_j_enable_matrix_sinh,

      MATRIX_SINH_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_sinh,
      MATRIX_SINH_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_sinh,

      -- DATA
      MATRIX_SINH_SIZE_I_IN => size_i_in_matrix_sinh,
      MATRIX_SINH_SIZE_J_IN => size_j_in_matrix_sinh,
      MATRIX_SINH_DATA_IN   => data_in_matrix_sinh,
      MATRIX_SINH_DATA_OUT  => data_out_matrix_sinh,

      -- MATRIX SOFTMAX
      -- CONTROL
      MATRIX_SOFTMAX_START => start_matrix_softmax,
      MATRIX_SOFTMAX_READY => ready_matrix_softmax,

      MATRIX_SOFTMAX_DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_softmax,

      MATRIX_SOFTMAX_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_softmax,

      -- DATA
      MATRIX_SOFTMAX_SIZE_I_IN => size_i_in_matrix_softmax,
      MATRIX_SOFTMAX_SIZE_J_IN => size_j_in_matrix_softmax,
      MATRIX_SOFTMAX_LENGTH_IN => length_in_matrix_softmax,
      MATRIX_SOFTMAX_DATA_IN   => data_in_matrix_softmax,
      MATRIX_SOFTMAX_DATA_OUT  => data_out_matrix_softmax,

      -- MATRIX SUMMATION
      -- CONTROL
      MATRIX_SUMMATION_START => start_matrix_summation,
      MATRIX_SUMMATION_READY => ready_matrix_summation,

      MATRIX_SUMMATION_DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_summation,

      MATRIX_SUMMATION_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_summation,
      MATRIX_SUMMATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_summation,

      -- DATA
      MATRIX_SUMMATION_SIZE_I_IN => size_i_in_matrix_summation,
      MATRIX_SUMMATION_SIZE_J_IN => size_j_in_matrix_summation,
      MATRIX_SUMMATION_LENGTH_IN => length_in_matrix_summation,
      MATRIX_SUMMATION_DATA_IN   => data_in_matrix_summation,
      MATRIX_SUMMATION_DATA_OUT  => data_out_matrix_summation,

      -- MATRIX TANH
      -- CONTROL
      MATRIX_TANH_START => start_matrix_tanh,
      MATRIX_TANH_READY => ready_matrix_tanh,

      MATRIX_TANH_DATA_IN_I_ENABLE => data_in_i_enable_matrix_tanh,
      MATRIX_TANH_DATA_IN_J_ENABLE => data_in_j_enable_matrix_tanh,

      MATRIX_TANH_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_tanh,
      MATRIX_TANH_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_tanh,

      -- DATA
      MATRIX_TANH_SIZE_I_IN => size_i_in_matrix_tanh,
      MATRIX_TANH_SIZE_J_IN => size_j_in_matrix_tanh,
      MATRIX_TANH_DATA_IN   => data_in_matrix_tanh,
      MATRIX_TANH_DATA_OUT  => data_out_matrix_tanh
      );

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR CONVOLUTION
  ntm_scalar_convolution_function_test : if (ENABLE_NTM_SCALAR_CONVOLUTION_TEST) generate
    scalar_convolution_function : ntm_scalar_convolution_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_convolution,
        READY => ready_scalar_convolution,

        DATA_A_IN_ENABLE => data_a_in_enable_scalar_convolution,
        DATA_B_IN_ENABLE => data_b_in_enable_scalar_convolution,

        DATA_OUT_ENABLE => data_out_enable_scalar_convolution,

        -- DATA
        LENGTH_IN => length_in_scalar_convolution,
        DATA_A_IN => data_a_in_scalar_convolution,
        DATA_B_IN => data_b_in_scalar_convolution,
        DATA_OUT  => data_out_scalar_convolution
        );
  end generate ntm_scalar_convolution_function_test;

  -- SCALAR COSH
  ntm_scalar_cosh_function_test : if (ENABLE_NTM_SCALAR_COSH_TEST) generate
    scalar_cosh_function : ntm_scalar_cosh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_cosh,
        READY => ready_scalar_cosh,

        -- DATA
        DATA_IN   => data_in_scalar_cosh,
        DATA_OUT  => data_out_scalar_cosh
        );
  end generate ntm_scalar_cosh_function_test;

  -- SCALAR COSINE SIMILARITY
  ntm_scalar_cosine_similarity_function_test : if (ENABLE_NTM_SCALAR_COSINE_SIMILARITY_TEST) generate
    scalar_cosine_similarity_function : ntm_scalar_cosine_similarity_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_cosine,
        READY => ready_scalar_cosine,

        DATA_A_IN_ENABLE => data_a_in_enable_scalar_cosine,
        DATA_B_IN_ENABLE => data_b_in_enable_scalar_cosine,

        DATA_OUT_ENABLE => data_out_enable_scalar_cosine,

        -- DATA
        LENGTH_IN => length_in_scalar_cosine,
        DATA_A_IN => data_a_in_scalar_cosine,
        DATA_B_IN => data_b_in_scalar_cosine,
        DATA_OUT  => data_out_scalar_cosine
        );
  end generate ntm_scalar_cosine_similarity_function_test;

  -- SCALAR DIFFERENTIATION
  ntm_scalar_differentiation_function_test : if (ENABLE_NTM_SCALAR_DIFFERENTIATION_TEST) generate
    scalar_differentiation_function : ntm_scalar_differentiation_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_differentiation,
        READY => ready_scalar_differentiation,

        DATA_IN_ENABLE => data_in_enable_scalar_differentiation,

        DATA_OUT_ENABLE => data_out_enable_scalar_differentiation,

        -- DATA
        PERIOD_IN => period_in_scalar_differentiation,
        LENGTH_IN => length_in_scalar_differentiation,
        DATA_IN   => data_in_scalar_differentiation,
        DATA_OUT  => data_out_scalar_differentiation
        );
  end generate ntm_scalar_differentiation_function_test;

  -- SCALAR EXPONENTIATOR
  ntm_scalar_exponentiator_test : if (ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST) generate
    scalar_exponentiator : ntm_scalar_exponentiator
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_exponentiator,
        READY => ready_scalar_exponentiator,

        -- DATA
        DATA_IN   => data_in_scalar_exponentiator,
        DATA_OUT  => data_out_scalar_exponentiator
        );
  end generate ntm_scalar_exponentiator_test;

  -- SCALAR LOGARITHM
  ntm_scalar_logarithm_function_test : if (ENABLE_NTM_SCALAR_LOGARITHM_TEST) generate
    scalar_logarithm_function : ntm_scalar_logarithm_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_logarithm,
        READY => ready_scalar_logarithm,

        -- DATA
        DATA_IN   => data_in_scalar_logarithm,
        DATA_OUT  => data_out_scalar_logarithm
        );
  end generate ntm_scalar_logarithm_function_test;

  -- SCALAR LOGISTIC
  ntm_scalar_logistic_function_test : if (ENABLE_NTM_SCALAR_LOGISTIC_TEST) generate
    scalar_logistic_function : ntm_scalar_logistic_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_logistic,
        READY => ready_scalar_logistic,

        -- DATA
        DATA_IN   => data_in_scalar_logistic,
        DATA_OUT  => data_out_scalar_logistic
        );
  end generate ntm_scalar_logistic_function_test;

  -- SCALAR MULTIPLICATION
  ntm_scalar_multiplication_function_test : if (ENABLE_NTM_SCALAR_MULTIPLICATION_TEST) generate
    scalar_multiplication_function : ntm_scalar_multiplication_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        LENGTH_IN => length_in_scalar_multiplication,
        DATA_IN   => data_in_scalar_multiplication,
        DATA_OUT  => data_out_scalar_multiplication
        );
  end generate ntm_scalar_multiplication_function_test;

  -- SCALAR ONEPLUS
  ntm_scalar_oneplus_function_test : if (ENABLE_NTM_SCALAR_ONEPLUS_TEST) generate
    scalar_oneplus_function : ntm_scalar_oneplus_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_oneplus,
        READY => ready_scalar_oneplus,

        -- DATA
        DATA_IN   => data_in_scalar_oneplus,
        DATA_OUT  => data_out_scalar_oneplus
        );
  end generate ntm_scalar_oneplus_function_test;

  -- SCALAR SINH
  ntm_scalar_sinh_function_test : if (ENABLE_NTM_SCALAR_SINH_TEST) generate
    scalar_sinh_function : ntm_scalar_sinh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_sinh,
        READY => ready_scalar_sinh,

        -- DATA
        DATA_IN   => data_in_scalar_sinh,
        DATA_OUT  => data_out_scalar_sinh
        );
  end generate ntm_scalar_sinh_function_test;

  -- SCALAR SOFTMAX
  ntm_scalar_softmax_function_test : if (ENABLE_NTM_SCALAR_SOFTMAX_TEST) generate
    scalar_softmax_function : ntm_scalar_softmax_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        LENGTH_IN => length_in_scalar_softmax,
        DATA_IN   => data_in_scalar_softmax,
        DATA_OUT  => data_out_scalar_softmax
        );
  end generate ntm_scalar_softmax_function_test;

  -- SCALAR SUMMATION
  ntm_scalar_summation_function_test : if (ENABLE_NTM_SCALAR_SUMMATION_TEST) generate
    scalar_summation_function : ntm_scalar_summation_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        LENGTH_IN => length_in_scalar_summation,
        DATA_IN   => data_in_scalar_summation,
        DATA_OUT  => data_out_scalar_summation
        );
  end generate ntm_scalar_summation_function_test;

  -- SCALAR TANH
  ntm_scalar_tanh_function_test : if (ENABLE_NTM_SCALAR_TANH_TEST) generate
    scalar_tanh_function : ntm_scalar_tanh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_tanh,
        READY => ready_scalar_tanh,

        -- DATA
        DATA_IN   => data_in_scalar_tanh,
        DATA_OUT  => data_out_scalar_tanh
        );
  end generate ntm_scalar_tanh_function_test;

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR CONVOLUTION
  ntm_vector_convolution_function_test : if (ENABLE_NTM_VECTOR_CONVOLUTION_TEST) generate
    vector_convolution_function : ntm_vector_convolution_function
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

        DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_vector_convolution,
        DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_vector_convolution,
        DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_vector_convolution,
        DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_vector_convolution,

        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_convolution,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_convolution,

        -- DATA
        SIZE_IN   => size_in_vector_convolution,
        LENGTH_IN => length_in_vector_convolution,
        DATA_A_IN => data_a_in_vector_convolution,
        DATA_B_IN => data_b_in_vector_convolution,
        DATA_OUT  => data_out_vector_convolution
        );
  end generate ntm_vector_convolution_function_test;

  -- VECTOR COSH
  ntm_vector_cosh_function_test : if (ENABLE_NTM_VECTOR_COSH_TEST) generate
    vector_cosh_function : ntm_vector_cosh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_IN   => size_in_vector_cosh,
        DATA_IN   => data_in_vector_cosh,
        DATA_OUT  => data_out_vector_cosh
        );
  end generate ntm_vector_cosh_function_test;

  -- VECTOR COSINE SIMILARITY
  ntm_vector_cosine_similarity_function_test : if (ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST) generate
    vector_cosine_similarity_function : ntm_vector_cosine_similarity_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_IN   => size_in_vector_cosine,
        LENGTH_IN => length_in_vector_cosine,
        DATA_A_IN => data_a_in_vector_cosine,
        DATA_B_IN => data_b_in_vector_cosine,
        DATA_OUT  => data_out_vector_cosine
        );
  end generate ntm_vector_cosine_similarity_function_test;

  -- VECTOR DIFFERENTIATION
  ntm_vector_differentiation_function_test : if (ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST) generate
    vector_differentiation_function : ntm_vector_differentiation_function
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

        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_differentiation,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_differentiation,

        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_differentiation,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_differentiation,

        -- DATA
        SIZE_IN   => size_in_vector_differentiation,
        PERIOD_IN => period_in_vector_differentiation,
        LENGTH_IN => length_in_vector_differentiation,
        DATA_IN   => data_in_vector_differentiation,
        DATA_OUT  => data_out_vector_differentiation
        );
  end generate ntm_vector_differentiation_function_test;

  -- VECTOR EXPONENTIATOR
  ntm_vector_exponentiator_test : if (ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST) generate
    vector_exponentiator : ntm_vector_exponentiator
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_exponentiator,
        READY => ready_vector_exponentiator,

        DATA_IN_ENABLE => data_in_enable_vector_exponentiator,

        DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

        -- DATA
        SIZE_IN   => size_in_vector_exponentiator,
        DATA_IN   => data_in_vector_exponentiator,
        DATA_OUT  => data_out_vector_exponentiator
        );
  end generate ntm_vector_exponentiator_test;

  -- VECTOR LOGARITHM
  ntm_vector_logarithm_function_test : if (ENABLE_NTM_VECTOR_LOGARITHM_TEST) generate
    vector_logarithm_function : ntm_vector_logarithm_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_logarithm,
        READY => ready_vector_logarithm,

        DATA_IN_ENABLE => data_in_enable_vector_logarithm,

        DATA_OUT_ENABLE => data_out_enable_vector_logarithm,

        -- DATA
        SIZE_IN   => size_in_vector_logarithm,
        DATA_IN   => data_in_vector_logarithm,
        DATA_OUT  => data_out_vector_logarithm
        );
  end generate ntm_vector_logarithm_function_test;

  -- VECTOR LOGISTIC
  ntm_vector_logistic_function_test : if (ENABLE_NTM_VECTOR_LOGISTIC_TEST) generate
    vector_logistic_function : ntm_vector_logistic_function
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
        SIZE_IN   => size_in_vector_logistic,
        DATA_IN   => data_in_vector_logistic,
        DATA_OUT  => data_out_vector_logistic
        );
  end generate ntm_vector_logistic_function_test;

  -- VECTOR MULTIPLICATION
  ntm_vector_multiplication_function_test : if (ENABLE_NTM_VECTOR_MULTIPLICATION_TEST) generate
    vector_multiplication_function : ntm_vector_multiplication_function
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

        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_multiplication,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_multiplication,

        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_multiplication,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_multiplication,

        -- DATA
        SIZE_IN   => size_in_vector_multiplication,
        LENGTH_IN => length_in_vector_multiplication,
        DATA_IN   => data_in_vector_multiplication,
        DATA_OUT  => data_out_vector_multiplication
        );
  end generate ntm_vector_multiplication_function_test;

  -- VECTOR ONEPLUS
  ntm_vector_oneplus_function_test : if (ENABLE_NTM_VECTOR_ONEPLUS_TEST) generate
    vector_oneplus_function : ntm_vector_oneplus_function
      generic map (

        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_IN   => size_in_vector_oneplus,
        DATA_IN   => data_in_vector_oneplus,
        DATA_OUT  => data_out_vector_oneplus
        );
  end generate ntm_vector_oneplus_function_test;

  -- VECTOR SINH
  ntm_vector_sinh_function_test : if (ENABLE_NTM_VECTOR_SINH_TEST) generate
    vector_sinh_function : ntm_vector_sinh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_IN   => size_in_vector_sinh,
        DATA_IN   => data_in_vector_sinh,
        DATA_OUT  => data_out_vector_sinh
        );
  end generate ntm_vector_sinh_function_test;

  -- VECTOR SOFTMAX
  ntm_vector_softmax_function_test : if (ENABLE_NTM_VECTOR_SOFTMAX_TEST) generate
    vector_softmax_function : ntm_vector_softmax_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_IN   => size_in_vector_softmax,
        LENGTH_IN => length_in_vector_softmax,
        DATA_IN   => data_in_vector_softmax,
        DATA_OUT  => data_out_vector_softmax
        );
  end generate ntm_vector_softmax_function_test;

  -- VECTOR SUMMATION
  ntm_vector_summation_function_test : if (ENABLE_NTM_VECTOR_SUMMATION_TEST) generate
    vector_summation_function : ntm_vector_summation_function
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

        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_summation,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_summation,

        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_summation,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_summation,

        -- DATA
        SIZE_IN   => size_in_vector_summation,
        LENGTH_IN => length_in_vector_summation,
        DATA_IN   => data_in_vector_summation,
        DATA_OUT  => data_out_vector_summation
        );
  end generate ntm_vector_summation_function_test;

  -- VECTOR TANH
  ntm_vector_tanh_function_test : if (ENABLE_NTM_VECTOR_TANH_TEST) generate
    vector_tanh_function : ntm_vector_tanh_function
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
        SIZE_IN   => size_in_vector_tanh,
        DATA_IN   => data_in_vector_tanh,
        DATA_OUT  => data_out_vector_tanh
        );
  end generate ntm_vector_tanh_function_test;

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX CONVOLUTION
  ntm_matrix_convolution_function_test : if (ENABLE_NTM_MATRIX_CONVOLUTION_TEST) generate
    matrix_convolution_function : ntm_matrix_convolution_function
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
        SIZE_I_IN => size_i_in_matrix_convolution,
        SIZE_J_IN => size_j_in_matrix_convolution,
        LENGTH_IN => length_in_matrix_convolution,
        DATA_A_IN => data_a_in_matrix_convolution,
        DATA_B_IN => data_b_in_matrix_convolution,
        DATA_OUT  => data_out_matrix_convolution
        );
  end generate ntm_matrix_convolution_function_test;

  -- MATRIX COSH
  ntm_matrix_cosh_function_test : if (ENABLE_NTM_MATRIX_COSH_TEST) generate
    matrix_cosh_function : ntm_matrix_cosh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_cosh,
        SIZE_J_IN => size_j_in_matrix_cosh,
        DATA_IN   => data_in_matrix_cosh,
        DATA_OUT  => data_out_matrix_cosh
        );
  end generate ntm_matrix_cosh_function_test;

  -- MATRIX COSINE SIMILARITY
  ntm_matrix_cosine_similarity_function_test : if (ENABLE_NTM_MATRIX_COSINE_SIMILARITY_TEST) generate
    matrix_cosine_similarity_function : ntm_matrix_cosine_similarity_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_cosine,
        SIZE_J_IN => size_j_in_matrix_cosine,
        LENGTH_IN => length_in_matrix_cosine,
        DATA_A_IN => data_a_in_matrix_cosine,
        DATA_B_IN => data_b_in_matrix_cosine,
        DATA_OUT  => data_out_matrix_cosine
        );
  end generate ntm_matrix_cosine_similarity_function_test;

  -- MATRIX DIFFERENTIATION
  ntm_matrix_differentiation_function_test : if (ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST) generate
    matrix_differentiation_function : ntm_matrix_differentiation_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_differentiation,
        READY => ready_matrix_differentiation,

        DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_differentiation,
        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_differentiation,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_differentiation,

        DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_differentiation,
        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_differentiation,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_differentiation,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_differentiation,
        SIZE_J_IN => size_j_in_matrix_differentiation,
        PERIOD_IN => period_in_matrix_differentiation,
        LENGTH_IN => length_in_matrix_differentiation,
        DATA_IN   => data_in_matrix_differentiation,
        DATA_OUT  => data_out_matrix_differentiation
        );
  end generate ntm_matrix_differentiation_function_test;

  -- MATRIX EXPONENTIATOR
  ntm_matrix_exponentiator_test : if (ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST) generate
    matrix_exponentiator : ntm_matrix_exponentiator
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_exponentiator,
        READY => ready_matrix_exponentiator,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_exponentiator,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_exponentiator,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_exponentiator,
        SIZE_J_IN => size_j_in_matrix_exponentiator,
        DATA_IN   => data_in_matrix_exponentiator,
        DATA_OUT  => data_out_matrix_exponentiator
        );
  end generate ntm_matrix_exponentiator_test;

  -- MATRIX LOGARITHM
  ntm_matrix_logarithm_function_test : if (ENABLE_NTM_MATRIX_LOGARITHM_TEST) generate
    matrix_logarithm_function : ntm_matrix_logarithm_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_logarithm,
        READY => ready_matrix_logarithm,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_logarithm,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_logarithm,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logarithm,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logarithm,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_logarithm,
        SIZE_J_IN => size_j_in_matrix_logarithm,
        DATA_IN   => data_in_matrix_logarithm,
        DATA_OUT  => data_out_matrix_logarithm
        );
  end generate ntm_matrix_logarithm_function_test;

  -- MATRIX LOGISTIC
  ntm_matrix_logistic_function_test : if (ENABLE_NTM_MATRIX_LOGISTIC_TEST) generate
    matrix_logistic_function : ntm_matrix_logistic_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_logistic,
        SIZE_J_IN => size_j_in_matrix_logistic,
        DATA_IN   => data_in_matrix_logistic,
        DATA_OUT  => data_out_matrix_logistic
        );
  end generate ntm_matrix_logistic_function_test;

  -- MATRIX MULTIPLICATION
  ntm_matrix_multiplication_function_test : if (ENABLE_NTM_MATRIX_MULTIPLICATION_TEST) generate
    matrix_multiplication_function : ntm_matrix_multiplication_function
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

        DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_multiplication,
        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_multiplication,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_multiplication,

        DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_multiplication,
        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_multiplication,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_multiplication,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_multiplication,
        SIZE_J_IN => size_j_in_matrix_multiplication,
        LENGTH_IN => length_in_matrix_multiplication,
        DATA_IN   => data_in_matrix_multiplication,
        DATA_OUT  => data_out_matrix_multiplication
        );
  end generate ntm_matrix_multiplication_function_test;

  -- MATRIX ONEPLUS
  ntm_matrix_oneplus_function_test : if (ENABLE_NTM_MATRIX_ONEPLUS_TEST) generate
    matrix_oneplus_function : ntm_matrix_oneplus_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_oneplus,
        SIZE_J_IN => size_j_in_matrix_oneplus,
        DATA_IN   => data_in_matrix_oneplus,
        DATA_OUT  => data_out_matrix_oneplus
        );
  end generate ntm_matrix_oneplus_function_test;

  -- MATRIX SINH
  ntm_matrix_sinh_function_test : if (ENABLE_NTM_MATRIX_SINH_TEST) generate
    matrix_sinh_function : ntm_matrix_sinh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_sinh,
        SIZE_J_IN => size_j_in_matrix_sinh,
        DATA_IN   => data_in_matrix_sinh,
        DATA_OUT  => data_out_matrix_sinh
        );
  end generate ntm_matrix_sinh_function_test;

  -- MATRIX SOFTMAX
  ntm_matrix_softmax_function_test : if (ENABLE_NTM_MATRIX_SOFTMAX_TEST) generate
    matrix_softmax_function : ntm_matrix_softmax_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_softmax,
        SIZE_J_IN => size_j_in_matrix_softmax,
        LENGTH_IN => length_in_matrix_softmax,
        DATA_IN   => data_in_matrix_softmax,
        DATA_OUT  => data_out_matrix_softmax
        );
  end generate ntm_matrix_softmax_function_test;

  -- MATRIX SUMMATION
  ntm_matrix_summation_function_test : if (ENABLE_NTM_MATRIX_SUMMATION_TEST) generate
    matrix_summation_function : ntm_matrix_summation_function
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

        DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_summation,
        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_summation,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_summation,

        DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_summation,
        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_summation,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_summation,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_summation,
        SIZE_J_IN => size_j_in_matrix_summation,
        LENGTH_IN => length_in_matrix_summation,
        DATA_IN   => data_in_matrix_summation,
        DATA_OUT  => data_out_matrix_summation
        );
  end generate ntm_matrix_summation_function_test;

  -- MATRIX TANH
  ntm_matrix_tanh_function_test : if (ENABLE_NTM_MATRIX_TANH_TEST) generate
    matrix_tanh_function : ntm_matrix_tanh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_I_IN => size_i_in_matrix_tanh,
        SIZE_J_IN => size_j_in_matrix_tanh,
        DATA_IN   => data_in_matrix_tanh,
        DATA_OUT  => data_out_matrix_tanh
        );
  end generate ntm_matrix_tanh_function_test;

end ntm_function_testbench_architecture;
