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
-- out the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included out
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

use work.ntm_math_pkg.all;
use work.ntm_function_pkg.all;

entity ntm_function_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x out 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y out 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j out 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k out 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l out 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i out 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -----------------------------------------------------------------------
    -- STIMULUS SCALAR
    -----------------------------------------------------------------------

    -- SCALAR CONVOLUTION
    -- CONTROL
    SCALAR_CONVOLUTION_START : out std_logic;
    SCALAR_CONVOLUTION_READY : in  std_logic;

    SCALAR_CONVOLUTION_DATA_A_IN_ENABLE : out std_logic;
    SCALAR_CONVOLUTION_DATA_B_IN_ENABLE : out std_logic;

    SCALAR_CONVOLUTION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_CONVOLUTION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR COSH
    -- CONTROL
    SCALAR_COSH_START : out std_logic;
    SCALAR_COSH_READY : in  std_logic;

    -- DATA
    SCALAR_COSH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR COSINE SIMILARITY
    -- CONTROL
    SCALAR_COSINE_SIMILARITY_START : out std_logic;
    SCALAR_COSINE_SIMILARITY_READY : in  std_logic;

    SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE : out std_logic;
    SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE : out std_logic;

    SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR DIFFERENTIATION
    -- CONTROL
    SCALAR_DIFFERENTIATION_START : out std_logic;
    SCALAR_DIFFERENTIATION_READY : in  std_logic;

    SCALAR_DIFFERENTIATION_DATA_IN_ENABLE : out std_logic;

    SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_DIFFERENTIATION_PERIOD_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR EXPONENTIATOR
    -- CONTROL
    SCALAR_EXPONENTIATOR_START : out std_logic;
    SCALAR_EXPONENTIATOR_READY : in  std_logic;

    -- DATA
    SCALAR_EXPONENTIATOR_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_EXPONENTIATOR_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR LOGARITHM
    -- CONTROL
    SCALAR_LOGARITHM_START : out std_logic;
    SCALAR_LOGARITHM_READY : in  std_logic;

    -- DATA
    SCALAR_LOGARITHM_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LOGARITHM_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR LOGISTIC
    -- CONTROL
    SCALAR_LOGISTIC_START : out std_logic;
    SCALAR_LOGISTIC_READY : in  std_logic;

    -- DATA
    SCALAR_LOGISTIC_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LOGISTIC_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR MULTIPLICATION
    -- CONTROL
    SCALAR_MULTIPLICATION_START : out std_logic;
    SCALAR_MULTIPLICATION_READY : in  std_logic;

    SCALAR_MULTIPLICATION_DATA_IN_ENABLE : out std_logic;

    SCALAR_MULTIPLICATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR ONEPLUS
    -- CONTROL
    SCALAR_ONEPLUS_START : out std_logic;
    SCALAR_ONEPLUS_READY : in  std_logic;

    -- DATA
    SCALAR_ONEPLUS_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ONEPLUS_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SINH
    -- CONTROL
    SCALAR_SINH_START : out std_logic;
    SCALAR_SINH_READY : in  std_logic;

    -- DATA
    SCALAR_SINH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SINH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SOFTMAX
    -- CONTROL
    SCALAR_SOFTMAX_START : out std_logic;
    SCALAR_SOFTMAX_READY : in  std_logic;

    SCALAR_SOFTMAX_DATA_IN_ENABLE : out std_logic;

    SCALAR_SOFTMAX_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_SOFTMAX_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SUMMATION
    -- CONTROL
    SCALAR_SUMMATION_START : out std_logic;
    SCALAR_SUMMATION_READY : in  std_logic;

    SCALAR_SUMMATION_DATA_IN_ENABLE : out std_logic;

    SCALAR_SUMMATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    SCALAR_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    SCALAR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR TANH
    -- CONTROL
    SCALAR_TANH_START : out std_logic;
    SCALAR_TANH_READY : in  std_logic;

    -- DATA
    SCALAR_TANH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_TANH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS VECTOR
    -----------------------------------------------------------------------

    -- VECTOR CONVOLUTION
    -- CONTROL
    VECTOR_CONVOLUTION_START : out std_logic;
    VECTOR_CONVOLUTION_READY : in  std_logic;

    VECTOR_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_CONVOLUTION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_CONVOLUTION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_CONVOLUTION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR COSH
    -- CONTROL
    VECTOR_COSH_START : out std_logic;
    VECTOR_COSH_READY : in  std_logic;

    VECTOR_COSH_DATA_IN_ENABLE : out std_logic;

    VECTOR_COSH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_COSH_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_COSH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR COSINE SIMILARITY
    -- CONTROL
    VECTOR_COSINE_SIMILARITY_START : out std_logic;
    VECTOR_COSINE_SIMILARITY_READY : in  std_logic;

    VECTOR_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_COSINE_SIMILARITY_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR DIFFERENTIATION
    -- CONTROL
    VECTOR_DIFFERENTIATION_START : out std_logic;
    VECTOR_DIFFERENTIATION_READY : in  std_logic;

    VECTOR_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_DIFFERENTIATION_PERIOD_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR EXPONENTIATOR
    -- CONTROL
    VECTOR_EXPONENTIATOR_START : out std_logic;
    VECTOR_EXPONENTIATOR_READY : in  std_logic;

    VECTOR_EXPONENTIATOR_DATA_IN_ENABLE : out std_logic;

    VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_EXPONENTIATOR_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR LOGARITHM
    -- CONTROL
    VECTOR_LOGARITHM_START : out std_logic;
    VECTOR_LOGARITHM_READY : in  std_logic;

    VECTOR_LOGARITHM_DATA_IN_ENABLE : out std_logic;

    VECTOR_LOGARITHM_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_LOGARITHM_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_LOGARITHM_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGARITHM_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR LOGISTIC
    -- CONTROL
    VECTOR_LOGISTIC_START : out std_logic;
    VECTOR_LOGISTIC_READY : in  std_logic;

    VECTOR_LOGISTIC_DATA_IN_ENABLE : out std_logic;

    VECTOR_LOGISTIC_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_LOGISTIC_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_LOGISTIC_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGISTIC_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR MULTIPLICATION
    -- CONTROL
    VECTOR_MULTIPLICATION_START : out std_logic;
    VECTOR_MULTIPLICATION_READY : in  std_logic;

    VECTOR_MULTIPLICATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_MULTIPLICATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_MULTIPLICATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR ONEPLUS
    -- CONTROL
    VECTOR_ONEPLUS_START : out std_logic;
    VECTOR_ONEPLUS_READY : in  std_logic;

    VECTOR_ONEPLUS_DATA_IN_ENABLE : out std_logic;

    VECTOR_ONEPLUS_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_ONEPLUS_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_ONEPLUS_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ONEPLUS_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SINH
    -- CONTROL
    VECTOR_SINH_START : out std_logic;
    VECTOR_SINH_READY : in  std_logic;

    VECTOR_SINH_DATA_IN_ENABLE : out std_logic;

    VECTOR_SINH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_SINH_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SINH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SINH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SOFTMAX
    -- CONTROL
    VECTOR_SOFTMAX_START : out std_logic;
    VECTOR_SOFTMAX_READY : in  std_logic;

    VECTOR_SOFTMAX_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_SOFTMAX_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_SOFTMAX_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_SOFTMAX_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_SOFTMAX_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SOFTMAX_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SUMMATION
    -- CONTROL
    VECTOR_SUMMATION_START : out std_logic;
    VECTOR_SUMMATION_READY : in  std_logic;

    VECTOR_SUMMATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    VECTOR_SUMMATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    VECTOR_SUMMATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    VECTOR_SUMMATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    VECTOR_SUMMATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR TANH
    -- CONTROL
    VECTOR_TANH_START : out std_logic;
    VECTOR_TANH_READY : in  std_logic;

    VECTOR_TANH_DATA_IN_ENABLE : out std_logic;

    VECTOR_TANH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_TANH_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_TANH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_TANH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS MATRIX
    -----------------------------------------------------------------------

    -- MATRIX CONVOLUTION
    -- CONTROL
    MATRIX_CONVOLUTION_START : out std_logic;
    MATRIX_CONVOLUTION_READY : in  std_logic;

    MATRIX_CONVOLUTION_DATA_A_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_CONVOLUTION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_CONVOLUTION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_CONVOLUTION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_CONVOLUTION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX COSH
    -- CONTROL
    MATRIX_COSH_START : out std_logic;
    MATRIX_COSH_READY : in  std_logic;

    MATRIX_COSH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_COSH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_COSH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_COSH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_COSH_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSH_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX COSINE SIMILARITY
    -- CONTROL
    MATRIX_COSINE_SIMILARITY_START : out std_logic;
    MATRIX_COSINE_SIMILARITY_READY : in  std_logic;

    MATRIX_COSINE_SIMILARITY_DATA_A_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_B_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_COSINE_SIMILARITY_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_COSINE_SIMILARITY_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX DIFFERENTIATION
    -- CONTROL
    MATRIX_DIFFERENTIATION_START : out std_logic;
    MATRIX_DIFFERENTIATION_READY : in  std_logic;

    MATRIX_DIFFERENTIATION_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_DIFFERENTIATION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_DIFFERENTIATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_PERIOD_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX EXPONENTIATOR
    -- CONTROL
    MATRIX_EXPONENTIATOR_START : out std_logic;
    MATRIX_EXPONENTIATOR_READY : in  std_logic;

    MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_EXPONENTIATOR_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX LOGISTIC
    -- CONTROL
    MATRIX_LOGISTIC_START : out std_logic;
    MATRIX_LOGISTIC_READY : in  std_logic;

    MATRIX_LOGISTIC_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_LOGISTIC_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_LOGISTIC_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_LOGISTIC_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_LOGISTIC_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGISTIC_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGISTIC_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGISTIC_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX LOGARITHM
    -- CONTROL
    MATRIX_LOGARITHM_START : out std_logic;
    MATRIX_LOGARITHM_READY : in  std_logic;

    MATRIX_LOGARITHM_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_LOGARITHM_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_LOGARITHM_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_LOGARITHM_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_LOGARITHM_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGARITHM_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGARITHM_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGARITHM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX MULTIPLICATION
    -- CONTROL
    MATRIX_MULTIPLICATION_START : out std_logic;
    MATRIX_MULTIPLICATION_READY : in  std_logic;

    MATRIX_MULTIPLICATION_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_MULTIPLICATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_MULTIPLICATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_MULTIPLICATION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX ONEPLUS
    -- CONTROL
    MATRIX_ONEPLUS_START : out std_logic;
    MATRIX_ONEPLUS_READY : in  std_logic;

    MATRIX_ONEPLUS_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_ONEPLUS_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_ONEPLUS_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_ONEPLUS_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_ONEPLUS_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_ONEPLUS_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_ONEPLUS_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ONEPLUS_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SINH
    -- CONTROL
    MATRIX_SINH_START : out std_logic;
    MATRIX_SINH_READY : in  std_logic;

    MATRIX_SINH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_SINH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_SINH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_SINH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_SINH_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SINH_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SINH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SINH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SOFTMAX
    -- CONTROL
    MATRIX_SOFTMAX_START : out std_logic;
    MATRIX_SOFTMAX_READY : in  std_logic;

    MATRIX_SOFTMAX_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_SOFTMAX_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_SOFTMAX_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_SOFTMAX_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_SOFTMAX_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_SOFTMAX_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_SOFTMAX_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SOFTMAX_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SOFTMAX_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SUMMATION
    -- CONTROL
    MATRIX_SUMMATION_START : out std_logic;
    MATRIX_SUMMATION_READY : in  std_logic;

    MATRIX_SUMMATION_DATA_IN_MATRIX_ENABLE : out std_logic;
    MATRIX_SUMMATION_DATA_IN_VECTOR_ENABLE : out std_logic;
    MATRIX_SUMMATION_DATA_IN_SCALAR_ENABLE : out std_logic;

    MATRIX_SUMMATION_DATA_OUT_MATRIX_ENABLE : in std_logic;
    MATRIX_SUMMATION_DATA_OUT_VECTOR_ENABLE : in std_logic;
    MATRIX_SUMMATION_DATA_OUT_SCALAR_ENABLE : in std_logic;

    -- DATA
    MATRIX_SUMMATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SUMMATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TANH
    -- CONTROL
    MATRIX_TANH_START : out std_logic;
    MATRIX_TANH_READY : in  std_logic;

    MATRIX_TANH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_TANH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_TANH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_TANH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_TANH_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TANH_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TANH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TANH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_function_stimulus_architecture of ntm_function_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  RST <= rst_int;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -- SCALAR-FUNCTIONALITY
  SCALAR_CONVOLUTION_START       <= start_int;
  SCALAR_COSH_START              <= start_int;
  SCALAR_COSINE_SIMILARITY_START <= start_int;
  SCALAR_DIFFERENTIATION_START   <= start_int;
  SCALAR_EXPONENTIATOR_START     <= start_int;
  SCALAR_LOGARITHM_START         <= start_int;
  SCALAR_LOGISTIC_START          <= start_int;
  SCALAR_MULTIPLICATION_START    <= start_int;
  SCALAR_ONEPLUS_START           <= start_int;
  SCALAR_SINH_START              <= start_int;
  SCALAR_SOFTMAX_START           <= start_int;
  SCALAR_SUMMATION_START         <= start_int;
  SCALAR_TANH_START              <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_CONVOLUTION_START       <= start_int;
  VECTOR_COSH_START              <= start_int;
  VECTOR_COSINE_SIMILARITY_START <= start_int;
  VECTOR_DIFFERENTIATION_START   <= start_int;
  VECTOR_EXPONENTIATOR_START     <= start_int;
  VECTOR_LOGARITHM_START         <= start_int;
  VECTOR_LOGISTIC_START          <= start_int;
  VECTOR_MULTIPLICATION_START    <= start_int;
  VECTOR_ONEPLUS_START           <= start_int;
  VECTOR_SINH_START              <= start_int;
  VECTOR_SOFTMAX_START           <= start_int;
  VECTOR_SUMMATION_START         <= start_int;
  VECTOR_TANH_START              <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_CONVOLUTION_START       <= start_int;
  MATRIX_COSH_START              <= start_int;
  MATRIX_COSINE_SIMILARITY_START <= start_int;
  MATRIX_DIFFERENTIATION_START   <= start_int;
  MATRIX_EXPONENTIATOR_START     <= start_int;
  MATRIX_LOGARITHM_START         <= start_int;
  MATRIX_LOGISTIC_START          <= start_int;
  MATRIX_MULTIPLICATION_START    <= start_int;
  MATRIX_ONEPLUS_START           <= start_int;
  MATRIX_SINH_START              <= start_int;
  MATRIX_SOFTMAX_START           <= start_int;
  MATRIX_SUMMATION_START         <= start_int;
  MATRIX_TANH_START              <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_CONVOLUTION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_CONVOLUTION_TEST    ";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_CONVOLUTION_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_CONVOLUTION_CASE 0  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
        SCALAR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

        -- DATA
        SCALAR_CONVOLUTION_DATA_A_IN <= TWO_DATA;
        SCALAR_CONVOLUTION_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_CONVOLUTION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_CONVOLUTION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
            SCALAR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

            -- DATA
            SCALAR_CONVOLUTION_DATA_A_IN <= TWO_DATA;
            SCALAR_CONVOLUTION_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_CONVOLUTION_DATA_A_IN_ENABLE <= '0';
            SCALAR_CONVOLUTION_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_CONVOLUTION_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_CONVOLUTION_CASE 1  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
        SCALAR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

        -- DATA
        SCALAR_CONVOLUTION_DATA_A_IN <= TWO_DATA;
        SCALAR_CONVOLUTION_DATA_B_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_CONVOLUTION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_CONVOLUTION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
            SCALAR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

            -- DATA
            SCALAR_CONVOLUTION_DATA_A_IN <= TWO_DATA;
            SCALAR_CONVOLUTION_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_CONVOLUTION_DATA_A_IN_ENABLE <= '0';
            SCALAR_CONVOLUTION_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_CONVOLUTION_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_COSH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_COSH_TEST           ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_COSH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_COSH_CASE 0         ";
        -------------------------------------------------------------------

        SCALAR_COSH_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_COSH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_COSH_CASE 1         ";
        -------------------------------------------------------------------

        SCALAR_COSH_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_COSINE_TEST         ";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_COSINE_SIMILARITY_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_COSINE_CASE 0       ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
        SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

        -- DATA
        SCALAR_COSINE_SIMILARITY_DATA_A_IN <= TWO_DATA;
        SCALAR_COSINE_SIMILARITY_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_COSINE_SIMILARITY_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
            SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

            -- DATA
            SCALAR_COSINE_SIMILARITY_DATA_A_IN <= TWO_DATA;
            SCALAR_COSINE_SIMILARITY_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '0';
            SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_COSINE_SIMILARITY_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_COSINE_CASE 1       ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
        SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

        -- DATA
        SCALAR_COSINE_SIMILARITY_DATA_A_IN <= TWO_DATA;
        SCALAR_COSINE_SIMILARITY_DATA_B_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_COSINE_SIMILARITY_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
            SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

            -- DATA
            SCALAR_COSINE_SIMILARITY_DATA_A_IN <= TWO_DATA;
            SCALAR_COSINE_SIMILARITY_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '0';
            SCALAR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_COSINE_SIMILARITY_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_DIFFERENTIATION_PERIOD_IN <= ONE_DATA;
      SCALAR_DIFFERENTIATION_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIFFERENT_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_DIFFERENTIATION_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_DIFFERENTIATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_DIFFERENTIATION_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_DIFFERENTIATION_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIFFERENT_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_DIFFERENTIATION_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_DIFFERENTIATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_DIFFERENTIATION_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_DIFFERENTIATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_DIFFERENTIATION_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 0";
        -------------------------------------------------------------------

        SCALAR_EXPONENTIATOR_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 1";
        -------------------------------------------------------------------

        SCALAR_EXPONENTIATOR_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_LOGARITHM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_LOGARITHM_TEST      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_LOGARITHM_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LOGARITHM_CASE 0    ";
        -------------------------------------------------------------------

        SCALAR_LOGARITHM_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_LOGARITHM_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LOGARITHM_CASE 1    ";
        -------------------------------------------------------------------

        SCALAR_LOGARITHM_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_LOGISTIC_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_LOGISTIC_TEST       ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LOGISTIC_CASE 0     ";
        -------------------------------------------------------------------

        SCALAR_LOGISTIC_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LOGISTIC_CASE 1     ";
        -------------------------------------------------------------------

        SCALAR_LOGISTIC_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MULTIPLICATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_MULTIPLICATION_TEST ";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_MULTIPLICATION_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_MULTIPLICATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULT_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_MULTIPLICATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_MULTIPLICATION_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_MULTIPLICATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_MULTIPLICATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_MULTIPLICATION_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_MULTIPLICATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_MULTIPLICATION_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_MULTIPLICATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULT_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_MULTIPLICATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_MULTIPLICATION_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_MULTIPLICATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_MULTIPLICATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_MULTIPLICATION_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_MULTIPLICATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_MULTIPLICATION_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_ONEPLUS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_ONEPLUS_TEST        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ONEPLUS_CASE 0      ";
        -------------------------------------------------------------------

        SCALAR_ONEPLUS_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ONEPLUS_CASE 1      ";
        -------------------------------------------------------------------

        SCALAR_ONEPLUS_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_SINH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_SINH_TEST           ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_SINH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SINH_CASE 0         ";
        -------------------------------------------------------------------

        SCALAR_SINH_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_SINH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SINH_CASE 1         ";
        -------------------------------------------------------------------

        SCALAR_SINH_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_SOFTMAX_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_SOFTMAX_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_SOFTMAX_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_SOFTMAX_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SOFTMAX_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_SOFTMAX_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_SOFTMAX_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_SOFTMAX_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_SOFTMAX_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_SOFTMAX_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_SOFTMAX_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_SOFTMAX_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_SOFTMAX_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_SOFTMAX_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SOFTMAX_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_SOFTMAX_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_SOFTMAX_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_SOFTMAX_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_SOFTMAX_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_SOFTMAX_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_SOFTMAX_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_SOFTMAX_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_SOFTMAX_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_SUMMATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_SUMMATION_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      SCALAR_SUMMATION_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_SCALAR_SUMMATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SUMMATION_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_SUMMATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_SUMMATION_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_SUMMATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_SUMMATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_SUMMATION_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_SUMMATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_SUMMATION_READY = '1';
        end loop;
      end if;

      if (STIMULUS_NTM_SCALAR_SUMMATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SUMMATION_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        SCALAR_SUMMATION_DATA_IN_ENABLE <= '1';

        -- DATA
        SCALAR_SUMMATION_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((SCALAR_SUMMATION_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(SCALAR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            SCALAR_SUMMATION_DATA_IN_ENABLE <= '1';

            -- DATA
            SCALAR_SUMMATION_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            SCALAR_SUMMATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit when SCALAR_SUMMATION_READY = '1';
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_TANH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_TANH_TEST           ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_TANH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_TANH_CASE 0         ";
        -------------------------------------------------------------------

        SCALAR_TANH_DATA_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_TANH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_TANH_CASE 1         ";
        -------------------------------------------------------------------

        SCALAR_TANH_DATA_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-FUNCTION
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    -- MATRIX-FUNCTION
    -------------------------------------------------------------------

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
