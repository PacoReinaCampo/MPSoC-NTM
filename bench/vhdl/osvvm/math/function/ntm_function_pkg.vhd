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

package ntm_arithmetic_pkg is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 512;

  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

  -- SCALAR-FUNCTIONALITY
  constant STIMULUS_NTM_SCALAR_MOD_TEST           : boolean := false;
  constant STIMULUS_NTM_SCALAR_ADDER_TEST         : boolean := false;
  constant STIMULUS_NTM_SCALAR_MULTIPLIER_TEST    : boolean := false;
  constant STIMULUS_NTM_SCALAR_INVERTER_TEST      : boolean := false;
  constant STIMULUS_NTM_SCALAR_DIVIDER_TEST       : boolean := false;
  constant STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST : boolean := false;
  constant STIMULUS_NTM_SCALAR_ROOT_TEST          : boolean := false;
  constant STIMULUS_NTM_SCALAR_LOGARITHM_TEST     : boolean := false;

  constant STIMULUS_NTM_SCALAR_MOD_CASE_0           : boolean := false;
  constant STIMULUS_NTM_SCALAR_ADDER_CASE_0         : boolean := false;
  constant STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0    : boolean := false;
  constant STIMULUS_NTM_SCALAR_INVERTER_CASE_0      : boolean := false;
  constant STIMULUS_NTM_SCALAR_DIVIDER_CASE_0       : boolean := false;
  constant STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0 : boolean := false;
  constant STIMULUS_NTM_SCALAR_ROOT_CASE_0          : boolean := false;
  constant STIMULUS_NTM_SCALAR_LOGARITHM_CASE_0     : boolean := false;

  constant STIMULUS_NTM_SCALAR_MOD_CASE_1           : boolean := false;
  constant STIMULUS_NTM_SCALAR_ADDER_CASE_1         : boolean := false;
  constant STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1    : boolean := false;
  constant STIMULUS_NTM_SCALAR_INVERTER_CASE_1      : boolean := false;
  constant STIMULUS_NTM_SCALAR_DIVIDER_CASE_1       : boolean := false;
  constant STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1 : boolean := false;
  constant STIMULUS_NTM_SCALAR_ROOT_CASE_1          : boolean := false;
  constant STIMULUS_NTM_SCALAR_LOGARITHM_CASE_1     : boolean := false;

  -- VECTOR-FUNCTIONALITY
  constant STIMULUS_NTM_VECTOR_MOD_TEST           : boolean := false;
  constant STIMULUS_NTM_VECTOR_ADDER_TEST         : boolean := false;
  constant STIMULUS_NTM_VECTOR_MULTIPLIER_TEST    : boolean := false;
  constant STIMULUS_NTM_VECTOR_INVERTER_TEST      : boolean := false;
  constant STIMULUS_NTM_VECTOR_DIVIDER_TEST       : boolean := false;
  constant STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST : boolean := false;
  constant STIMULUS_NTM_VECTOR_ROOT_TEST          : boolean := false;
  constant STIMULUS_NTM_VECTOR_LOGARITHM_TEST     : boolean := false;

  -- MATRIX-FUNCTIONALITY
  constant STIMULUS_NTM_MATRIX_MOD_TEST           : boolean := false;
  constant STIMULUS_NTM_MATRIX_ADDER_TEST         : boolean := false;
  constant STIMULUS_NTM_MATRIX_MULTIPLIER_TEST    : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERTER_TEST      : boolean := false;
  constant STIMULUS_NTM_MATRIX_DIVIDER_TEST       : boolean := false;
  constant STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST : boolean := false;
  constant STIMULUS_NTM_MATRIX_ROOT_TEST          : boolean := false;
  constant STIMULUS_NTM_MATRIX_LOGARITHM_TEST     : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_function_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE : integer := 512;

      X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
      Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
      N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
      W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
      L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
      R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

      -- SCALAR-FUNCTIONALITY
      STIMULUS_NTM_SCALAR_CONVOLUTION_TEST       : boolean := false;
      STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_TEST : boolean := false;
      STIMULUS_NTM_SCALAR_COSH_TEST              : boolean := false;
      STIMULUS_NTM_SCALAR_SINH_TEST              : boolean := false;
      STIMULUS_NTM_SCALAR_TANH_TEST              : boolean := false;
      STIMULUS_NTM_SCALAR_LOGISTIC_TEST          : boolean := false;
      STIMULUS_NTM_SCALAR_SOFTMAX_TEST           : boolean := false;
      STIMULUS_NTM_SCALAR_ONEPLUS_TEST           : boolean := false;
      STIMULUS_NTM_SCALAR_SUMMATION_TEST         : boolean := false;

      STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_0       : boolean := false;
      STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_0 : boolean := false;
      STIMULUS_NTM_SCALAR_COSH_CASE_0              : boolean := false;
      STIMULUS_NTM_SCALAR_SINH_CASE_0              : boolean := false;
      STIMULUS_NTM_SCALAR_TANH_CASE_0              : boolean := false;
      STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0          : boolean := false;
      STIMULUS_NTM_SCALAR_SOFTMAX_CASE_0           : boolean := false;
      STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0           : boolean := false;
      STIMULUS_NTM_SCALAR_SUMMATION_CASE_0         : boolean := false;

      STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_1       : boolean := false;
      STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_CASE_1 : boolean := false;
      STIMULUS_NTM_SCALAR_COSH_CASE_1              : boolean := false;
      STIMULUS_NTM_SCALAR_SINH_CASE_1              : boolean := false;
      STIMULUS_NTM_SCALAR_TANH_CASE_1              : boolean := false;
      STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1          : boolean := false;
      STIMULUS_NTM_SCALAR_SOFTMAX_CASE_1           : boolean := false;
      STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1           : boolean := false;
      STIMULUS_NTM_SCALAR_SUMMATION_CASE_1         : boolean := false;

      -- VECTOR-FUNCTIONALITY
      STIMULUS_NTM_VECTOR_CONVOLUTION_TEST       : boolean := false;
      STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST : boolean := false;
      STIMULUS_NTM_VECTOR_COSH_TEST              : boolean := false;
      STIMULUS_NTM_VECTOR_SINH_TEST              : boolean := false;
      STIMULUS_NTM_VECTOR_TANH_TEST              : boolean := false;
      STIMULUS_NTM_VECTOR_LOGISTIC_TEST          : boolean := false;
      STIMULUS_NTM_VECTOR_SOFTMAX_TEST           : boolean := false;
      STIMULUS_NTM_VECTOR_ONEPLUS_TEST           : boolean := false;
      STIMULUS_NTM_VECTOR_SUMMATION_TEST         : boolean := false;

      STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0       : boolean := false;
      STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 : boolean := false;
      STIMULUS_NTM_VECTOR_COSH_CASE_0              : boolean := false;
      STIMULUS_NTM_VECTOR_SINH_CASE_0              : boolean := false;
      STIMULUS_NTM_VECTOR_TANH_CASE_0              : boolean := false;
      STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0          : boolean := false;
      STIMULUS_NTM_VECTOR_SOFTMAX_CASE_0           : boolean := false;
      STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0           : boolean := false;
      STIMULUS_NTM_VECTOR_SUMMATION_CASE_0         : boolean := false;

      STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1       : boolean := false;
      STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1 : boolean := false;
      STIMULUS_NTM_VECTOR_COSH_CASE_1              : boolean := false;
      STIMULUS_NTM_VECTOR_SINH_CASE_1              : boolean := false;
      STIMULUS_NTM_VECTOR_TANH_CASE_1              : boolean := false;
      STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1          : boolean := false;
      STIMULUS_NTM_VECTOR_SOFTMAX_CASE_1           : boolean := false;
      STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1           : boolean := false;
      STIMULUS_NTM_VECTOR_SUMMATION_CASE_1         : boolean := false;

      -- MATRIX-FUNCTIONALITY
      STIMULUS_NTM_MATRIX_CONVOLUTION_TEST       : boolean := false;
      STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_TEST : boolean := false;
      STIMULUS_NTM_MATRIX_COSH_TEST              : boolean := false;
      STIMULUS_NTM_MATRIX_SINH_TEST              : boolean := false;
      STIMULUS_NTM_MATRIX_TANH_TEST              : boolean := false;
      STIMULUS_NTM_MATRIX_LOGISTIC_TEST          : boolean := false;
      STIMULUS_NTM_MATRIX_SOFTMAX_TEST           : boolean := false;
      STIMULUS_NTM_MATRIX_ONEPLUS_TEST           : boolean := false;
      STIMULUS_NTM_MATRIX_SUMMATION_TEST         : boolean := false;

      STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0       : boolean := false;
      STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_0 : boolean := false;
      STIMULUS_NTM_MATRIX_COSH_CASE_0              : boolean := false;
      STIMULUS_NTM_MATRIX_SINH_CASE_0              : boolean := false;
      STIMULUS_NTM_MATRIX_TANH_CASE_0              : boolean := false;
      STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0          : boolean := false;
      STIMULUS_NTM_MATRIX_SOFTMAX_CASE_0           : boolean := false;
      STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0           : boolean := false;
      STIMULUS_NTM_MATRIX_SUMMATION_CASE_0         : boolean := false;

      STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1       : boolean := false;
      STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_CASE_1 : boolean := false;
      STIMULUS_NTM_MATRIX_COSH_CASE_1              : boolean := false;
      STIMULUS_NTM_MATRIX_SINH_CASE_1              : boolean := false;
      STIMULUS_NTM_MATRIX_TANH_CASE_1              : boolean := false;
      STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1          : boolean := false;
      STIMULUS_NTM_MATRIX_SOFTMAX_CASE_1           : boolean := false;
      STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1           : boolean := false;
      STIMULUS_NTM_MATRIX_SUMMATION_CASE_1         : boolean := false
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR
      -----------------------------------------------------------------------

      -- CONTROL
      SCALAR_CONVOLUTION_START : in  std_logic;
      SCALAR_CONVOLUTION_READY : out std_logic;

      DSCALAR_CONVOLUTION_ATA_IN_ENABLE : in std_logic;

      SCALAR_CONVOLUTION_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SCALAR_CONVOLUTION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_CONVOLUTION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_CONVOLUTION_DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_CONVOLUTION_DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_CONVOLUTION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_COSINE_SIMILARITY_START : in  std_logic;
      SCALAR_COSINE_SIMILARITY_READY : out std_logic;

      SCALAR_COSINE_SIMILARITY_DATA_IN_ENABLE : in std_logic;

      SCALAR_COSINE_SIMILARITY_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SCALAR_COSINE_SIMILARITY_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSINE_SIMILARITY_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSINE_SIMILARITY_DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSINE_SIMILARITY_DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSINE_SIMILARITY_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_MULTIPLICATION_START : in  std_logic;
      SCALAR_MULTIPLICATION_READY : out std_logic;

      SCALAR_MULTIPLICATION_DATA_IN_ENABLE : in std_logic;

      SCALAR_MULTIPLICATION_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SCALAR_MULTIPLICATION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLICATION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLICATION_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLICATION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_COSH_START : in  std_logic;
      SCALAR_COSH_READY : out std_logic;

      -- DATA
      SCALAR_COSH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_SINH_START : in  std_logic;
      SCALAR_SINH_READY : out std_logic;

      -- DATA
      SCALAR_SINH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SINH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SINH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_TANH_START : in  std_logic;
      SCALAR_TANH_READY : out std_logic;

      -- DATA
      SCALAR_TANH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_TANH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_TANH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_LOGISTIC_START : in  std_logic;
      SCALAR_LOGISTIC_READY : out std_logic;

      -- DATA
      SCALAR_LOGISTIC_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGISTIC_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGISTIC_DATA_OUT  : out std_logic;

      -- CONTROL
      SCALAR_SOFTMAX_START : in  std_logic;
      SCALAR_SOFTMAX_READY : out std_logic;

      SCALAR_SOFTMAX_DATA_IN_ENABLE : in std_logic;

      SCALAR_SOFTMAX_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SCALAR_SOFTMAX_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SOFTMAX_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SOFTMAX_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SOFTMAX_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_ONEPLUS_START : in  std_logic;
      SCALAR_ONEPLUS_READY : out std_logic;

      -- DATA
      SCALAR_ONEPLUS_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ONEPLUS_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ONEPLUS_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      SCALAR_SUMMATION_START : in  std_logic;
      SCALAR_SUMMATION_READY : out std_logic;

      SCALAR_SUMMATION_DATA_IN_ENABLE : in std_logic;

      SCALAR_SUMMATION_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SCALAR_SUMMATION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SUMMATION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SUMMATION_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_SUMMATION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- CONTROL
      VECTOR_COSINE_SIMILARITY_START : in  std_logic;
      VECTOR_COSINE_SIMILARITY_READY : out std_logic;

      VECTOR_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE : in std_logic;
      VECTOR_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE : in std_logic;
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE : in std_logic;
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE : in std_logic;

      VECTOR_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE : out std_logic;
      VECTOR_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      VECTOR_COSINE_SIMILARITY_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_MULTIPLICATION_START : in  std_logic;
      VECTOR_MULTIPLICATION_READY : out std_logic;

      VECTOR_MULTIPLICATION_DATA_IN_VECTOR_ENABLE : in std_logic;
      VECTOR_MULTIPLICATION_DATA_IN_SCALAR_ENABLE : in std_logic;

      VECTOR_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE : out std_logic;
      VECTOR_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      VECTOR_MULTIPLICATION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_COSH_START : in  std_logic;
      VECTOR_COSH_READY : out std_logic;

      VECTOR_COSH_DATA_IN_ENABLE : in std_logic;

      VECTOR_COSH_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      VECTOR_COSH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSH_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_SINH_START : in  std_logic;
      VECTOR_SINH_READY : out std_logic;

      VECTOR_SINH_DATA_IN_ENABLE : in std_logic;

      VECTOR_SINH_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      VECTOR_SINH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SINH_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SINH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SINH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_TANH_START : in  std_logic;
      VECTOR_TANH_READY : out std_logic;

      VECTOR_TANH_DATA_IN_ENABLE : in std_logic;

      VECTOR_TANH_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      VECTOR_TANH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_TANH_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_TANH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_TANH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_LOGISTIC_START : in  std_logic;
      VECTOR_LOGISTIC_READY : out std_logic;

      VECTOR_LOGISTIC_DATA_IN_ENABLE : in std_logic;

      VECTOR_LOGISTIC_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      VECTOR_LOGISTIC_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGISTIC_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGISTIC_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGISTIC_DATA_OUT  : out std_logic;

      -- CONTROL
      VECTOR_SOFTMAX_START : in  std_logic;
      VECTOR_SOFTMAX_READY : out std_logic;

      VECTOR_SOFTMAX_DATA_IN_VECTOR_ENABLE : in std_logic;
      VECTOR_SOFTMAX_DATA_IN_SCALAR_ENABLE : in std_logic;

      VECTOR_SOFTMAX_DATA_OUT_VECTOR_ENABLE : out std_logic;
      VECTOR_SOFTMAX_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      VECTOR_SOFTMAX_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SOFTMAX_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SOFTMAX_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SOFTMAX_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SOFTMAX_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_ONEPLUS_START : in  std_logic;
      VECTOR_ONEPLUS_READY : out std_logic;

      VECTOR_ONEPLUS_DATA_IN_ENABLE : in std_logic;

      VECTOR_ONEPLUS_DATA_OUT_ENABLE : out std_logic;

      -- DATA
      VECTOR_ONEPLUS_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ONEPLUS_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ONEPLUS_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ONEPLUS_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      VECTOR_SUMMATION_START : in  std_logic;
      VECTOR_SUMMATION_READY : out std_logic;

      VECTOR_SUMMATION_DATA_IN_VECTOR_ENABLE : in std_logic;
      VECTOR_SUMMATION_DATA_IN_SCALAR_ENABLE : in std_logic;

      VECTOR_SUMMATION_DATA_OUT_VECTOR_ENABLE : out std_logic;
      VECTOR_SUMMATION_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      VECTOR_SUMMATION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SUMMATION_SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SUMMATION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SUMMATION_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SUMMATION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- CONTROL
      MATRIX_CONVOLUTION_START : in  std_logic;
      MATRIX_CONVOLUTION_READY : out std_logic;

      MATRIX_CONVOLUTION_DATA_A_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_A_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_A_IN_SCALAR_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_SCALAR_ENABLE : in std_logic;

      MATRIX_CONVOLUTION_DATA_OUT_MATRIX_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_OUT_VECTOR_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      MATRIX_CONVOLUTION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_COSINE_SIMILARITY_START : in  std_logic;
      MATRIX_COSINE_SIMILARITY_READY : out std_logic;

      MATRIX_COSINE_SIMILARITY_DATA_A_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_A_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_A_IN_SCALAR_ENABLE : in std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_B_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_B_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_B_IN_SCALAR_ENABLE : in std_logic;

      MATRIX_COSINE_SIMILARITY_DATA_OUT_MATRIX_ENABLE : out std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_OUT_VECTOR_ENABLE : out std_logic;
      MATRIX_COSINE_SIMILARITY_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      MATRIX_COSINE_SIMILARITY_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSINE_SIMILARITY_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSINE_SIMILARITY_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSINE_SIMILARITY_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSINE_SIMILARITY_DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSINE_SIMILARITY_DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSINE_SIMILARITY_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_MULTIPLICATION_START : in  std_logic;
      MATRIX_MULTIPLICATION_READY : out std_logic;

      MATRIX_MULTIPLICATION_DATA_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_MULTIPLICATION_DATA_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_MULTIPLICATION_DATA_IN_SCALAR_ENABLE : in std_logic;

      MATRIX_MULTIPLICATION_DATA_OUT_MATRIX_ENABLE : out std_logic;
      MATRIX_MULTIPLICATION_DATA_OUT_VECTOR_ENABLE : out std_logic;
      MATRIX_MULTIPLICATION_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      MATRIX_MULTIPLICATION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_COSH_START : in  std_logic;
      MATRIX_COSH_READY : out std_logic;

      MATRIX_COSH_DATA_IN_I_ENABLE : in std_logic;
      MATRIX_COSH_DATA_IN_J_ENABLE : in std_logic;

      MATRIX_COSH_DATA_OUT_I_ENABLE : out std_logic;
      MATRIX_COSH_DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      MATRIX_COSH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSH_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSH_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_COSH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_SINH_START : in  std_logic;
      MATRIX_SINH_READY : out std_logic;

      MATRIX_SINH_DATA_IN_I_ENABLE : in std_logic;
      MATRIX_SINH_DATA_IN_J_ENABLE : in std_logic;

      MATRIX_SINH_DATA_OUT_I_ENABLE : out std_logic;
      MATRIX_SINH_DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      MATRIX_SINH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SINH_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SINH_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SINH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SINH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_TANH_START : in  std_logic;
      MATRIX_TANH_READY : out std_logic;

      MATRIX_TANH_DATA_IN_I_ENABLE : in std_logic;
      MATRIX_TANH_DATA_IN_J_ENABLE : in std_logic;

      MATRIX_TANH_DATA_OUT_I_ENABLE : out std_logic;
      MATRIX_TANH_DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      MATRIX_TANH_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TANH_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TANH_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TANH_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TANH_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_LOGISTIC_START : in  std_logic;
      MATRIX_LOGISTIC_READY : out std_logic;

      MATRIX_LOGISTIC_DATA_IN_I_ENABLE : in std_logic;
      MATRIX_LOGISTIC_DATA_IN_J_ENABLE : in std_logic;

      MATRIX_LOGISTIC_DATA_OUT_I_ENABLE : out std_logic;
      MATRIX_LOGISTIC_DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      MATRIX_LOGISTIC_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGISTIC_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGISTIC_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGISTIC_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGISTIC_DATA_OUT  : out std_logic;

      -- CONTROL
      MATRIX_SOFTMAX_START : in  std_logic;
      MATRIX_SOFTMAX_READY : out std_logic;

      MATRIX_SOFTMAX_DATA_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_SOFTMAX_DATA_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_SOFTMAX_DATA_IN_SCALAR_ENABLE : in std_logic;

      MATRIX_SOFTMAX_DATA_OUT_MATRIX_ENABLE : out std_logic;
      MATRIX_SOFTMAX_DATA_OUT_VECTOR_ENABLE : out std_logic;
      MATRIX_SOFTMAX_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      MATRIX_SOFTMAX_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SOFTMAX_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SOFTMAX_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SOFTMAX_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SOFTMAX_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SOFTMAX_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_ONEPLUS_START : in  std_logic;
      MATRIX_ONEPLUS_READY : out std_logic;

      MATRIX_ONEPLUS_DATA_IN_I_ENABLE : in std_logic;
      MATRIX_ONEPLUS_DATA_IN_J_ENABLE : in std_logic;

      MATRIX_ONEPLUS_DATA_OUT_I_ENABLE : out std_logic;
      MATRIX_ONEPLUS_DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      MATRIX_ONEPLUS_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ONEPLUS_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ONEPLUS_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ONEPLUS_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ONEPLUS_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);

      -- CONTROL
      MATRIX_SUMMATION_START : in  std_logic;
      MATRIX_SUMMATION_READY : out std_logic;

      MATRIX_SUMMATION_DATA_IN_MATRIX_ENABLE : in std_logic;
      MATRIX_SUMMATION_DATA_IN_VECTOR_ENABLE : in std_logic;
      MATRIX_SUMMATION_DATA_IN_SCALAR_ENABLE : in std_logic;

      MATRIX_SUMMATION_DATA_OUT_MATRIX_ENABLE : out std_logic;
      MATRIX_SUMMATION_DATA_OUT_VECTOR_ENABLE : out std_logic;
      MATRIX_SUMMATION_DATA_OUT_SCALAR_ENABLE : out std_logic;

      -- DATA
      MATRIX_SUMMATION_MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_arithmetic_pkg;

package body ntm_arithmetic_pkg is

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_arithmetic_pkg;
