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

package ntm_algebra_pkg is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 128;

  constant CONTROL_X_SIZE : integer := 3;
  constant CONTROL_Y_SIZE : integer := 3;
  constant CONTROL_Z_SIZE : integer := 3;

  type tensor_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1, 0 to CONTROL_Z_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type vector_buffer is array (0 to CONTROL_X_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant SIZE_I : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));
  constant SIZE_J : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));
  constant SIZE_K : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));

  constant SIZE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));

  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

  -- INTEGERS
  constant INT_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
  constant INT_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(1, DATA_SIZE));
  constant INT_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(2, DATA_SIZE));
  constant INT_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(3, DATA_SIZE));
  constant INT_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(4, DATA_SIZE));
  constant INT_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(5, DATA_SIZE));
  constant INT_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(6, DATA_SIZE));
  constant INT_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(7, DATA_SIZE));
  constant INT_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(8, DATA_SIZE));
  constant INT_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(9, DATA_SIZE));

  constant INT_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-1, DATA_SIZE));
  constant INT_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-2, DATA_SIZE));
  constant INT_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-3, DATA_SIZE));
  constant INT_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-4, DATA_SIZE));
  constant INT_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-5, DATA_SIZE));
  constant INT_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-6, DATA_SIZE));
  constant INT_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-7, DATA_SIZE));
  constant INT_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-8, DATA_SIZE));
  constant INT_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-9, DATA_SIZE));

  -- FLOATS
  constant FLOAT_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"00000000";
  constant FLOAT_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"3f8ccccd";
  constant FLOAT_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"400ccccd";
  constant FLOAT_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"40533333";
  constant FLOAT_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"408ccccd";
  constant FLOAT_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"40b00000";
  constant FLOAT_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"40d33333";
  constant FLOAT_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"40f66666";
  constant FLOAT_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"410ccccd";
  constant FLOAT_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"411e6666";
  constant FLOAT_P_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"7f800000";

  constant FLOAT_N_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"80000000";
  constant FLOAT_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"bf8ccccd";
  constant FLOAT_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"c00ccccd";
  constant FLOAT_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0533333";
  constant FLOAT_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c08ccccd";
  constant FLOAT_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0b00000";
  constant FLOAT_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0d33333";
  constant FLOAT_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0f66666";
  constant FLOAT_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"c10ccccd";
  constant FLOAT_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c11e6666";
  constant FLOAT_N_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"ff800000";

  -- Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((INT_P_TWO, INT_P_ONE, INT_P_FOUR), (INT_P_NINE, INT_P_FOUR, INT_P_TWO), (INT_P_ONE, INT_P_ONE, INT_P_TWO)), ((INT_P_EIGHT, INT_P_SIX, INT_P_TWO), (INT_P_EIGHT, INT_P_FIVE, INT_P_TWO), (INT_P_ONE, INT_P_FOUR, INT_P_ONE)), ((INT_P_THREE, INT_P_ONE, INT_P_SIX), (INT_P_FIVE, INT_P_ZERO, INT_P_FOUR), (INT_P_FIVE, INT_P_EIGHT, INT_P_FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((INT_P_ONE, INT_P_THREE, INT_P_ONE), (INT_P_TWO, INT_P_FOUR, INT_P_EIGHT), (INT_P_FOUR, INT_P_ONE, INT_P_TWO)), ((INT_P_NINE, INT_P_ONE, INT_P_FIVE), (INT_P_NINE, INT_P_EIGHT, INT_P_ONE), (INT_P_FIVE, INT_P_EIGHT, INT_P_FOUR)), ((INT_P_FIVE, INT_P_FOUR, INT_P_ONE), (INT_P_THREE, INT_P_FOUR, INT_P_SIX), (INT_P_ONE, INT_P_EIGHT, INT_P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((INT_P_ONE, INT_P_FOUR, INT_P_ONE), (INT_P_ZERO, INT_P_EIGHT, INT_P_FOUR), (INT_P_FIVE, INT_P_THREE, INT_P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((INT_P_ONE, INT_P_TWO, INT_P_SIX), (INT_P_ONE, INT_P_THREE, INT_P_SIX), (INT_P_EIGHT, INT_P_FOUR, INT_P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (INT_P_FOUR, INT_P_SEVEN, INT_N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (INT_P_THREE, INT_N_NINE, INT_N_ONE);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := INT_P_NINE;
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := INT_N_FOUR;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_NTM_DOT_PRODUCT_TEST              : boolean := false;
  signal STIMULUS_NTM_VECTOR_CONVOLUTION_TEST       : boolean := false;
  signal STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST    : boolean := false;
  signal STIMULUS_NTM_VECTOR_SUMMATION_TEST         : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULE_TEST            : boolean := false;

  signal STIMULUS_NTM_DOT_PRODUCT_CASE_0              : boolean := false;
  signal STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0       : boolean := false;
  signal STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0    : boolean := false;
  signal STIMULUS_NTM_VECTOR_SUMMATION_CASE_0         : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULE_CASE_0            : boolean := false;

  signal STIMULUS_NTM_DOT_PRODUCT_CASE_1              : boolean := false;
  signal STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1       : boolean := false;
  signal STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1 : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_1    : boolean := false;
  signal STIMULUS_NTM_VECTOR_SUMMATION_CASE_1         : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULE_CASE_1            : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_NTM_MATRIX_CONVOLUTION_TEST    : boolean := false;
  signal STIMULUS_NTM_MATRIX_INVERSE_TEST        : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST : boolean := false;
  signal STIMULUS_NTM_MATRIX_PRODUCT_TEST        : boolean := false;
  signal STIMULUS_NTM_MATRIX_SUMMATION_TEST      : boolean := false;
  signal STIMULUS_NTM_MATRIX_TRANSPOSE_TEST      : boolean := false;

  signal STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0    : boolean := false;
  signal STIMULUS_NTM_MATRIX_INVERSE_CASE_0        : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0 : boolean := false;
  signal STIMULUS_NTM_MATRIX_PRODUCT_CASE_0        : boolean := false;
  signal STIMULUS_NTM_MATRIX_SUMMATION_CASE_0      : boolean := false;
  signal STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0      : boolean := false;

  signal STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1    : boolean := false;
  signal STIMULUS_NTM_MATRIX_INVERSE_CASE_1        : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_1 : boolean := false;
  signal STIMULUS_NTM_MATRIX_PRODUCT_CASE_1        : boolean := false;
  signal STIMULUS_NTM_MATRIX_SUMMATION_CASE_1      : boolean := false;
  signal STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1      : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_NTM_TENSOR_CONVOLUTION_TEST    : boolean := false;
  signal STIMULUS_NTM_TENSOR_INVERSE_TEST        : boolean := false;
  signal STIMULUS_NTM_TENSOR_MULTIPLICATION_TEST : boolean := false;
  signal STIMULUS_NTM_TENSOR_PRODUCT_TEST        : boolean := false;
  signal STIMULUS_NTM_TENSOR_SUMMATION_TEST      : boolean := false;
  signal STIMULUS_NTM_TENSOR_TRANSPOSE_TEST      : boolean := false;

  signal STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0    : boolean := false;
  signal STIMULUS_NTM_TENSOR_INVERSE_CASE_0        : boolean := false;
  signal STIMULUS_NTM_TENSOR_MULTIPLICATION_CASE_0 : boolean := false;
  signal STIMULUS_NTM_TENSOR_PRODUCT_CASE_0        : boolean := false;
  signal STIMULUS_NTM_TENSOR_SUMMATION_CASE_0      : boolean := false;
  signal STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0      : boolean := false;

  signal STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_1    : boolean := false;
  signal STIMULUS_NTM_TENSOR_INVERSE_CASE_1        : boolean := false;
  signal STIMULUS_NTM_TENSOR_MULTIPLICATION_CASE_1 : boolean := false;
  signal STIMULUS_NTM_TENSOR_PRODUCT_CASE_1        : boolean := false;
  signal STIMULUS_NTM_TENSOR_SUMMATION_CASE_1      : boolean := false;
  signal STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_1      : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_algebra_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64;

      X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
      Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
      N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
      W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
      L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
      R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i in 0 to R-1
      );
    port (
      -- GLOBAL
      CLK : out std_logic;
      RST : out std_logic;

      -- DOT PRODUCT
      -- CONTROL
      DOT_PRODUCT_START : out std_logic;
      DOT_PRODUCT_READY : in  std_logic;

      DOT_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
      DOT_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

      DOT_PRODUCT_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      DOT_PRODUCT_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      DOT_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DOT_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DOT_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR CONVOLUTION
      -- CONTROL
      VECTOR_CONVOLUTION_START : out std_logic;
      VECTOR_CONVOLUTION_READY : in  std_logic;

      VECTOR_CONVOLUTION_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_CONVOLUTION_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_CONVOLUTION_DATA_ENABLE : in std_logic;

      VECTOR_CONVOLUTION_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_CONVOLUTION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR COSINE_SIMILARITY
      -- CONTROL
      VECTOR_COSINE_SIMILARITY_START : out std_logic;
      VECTOR_COSINE_SIMILARITY_READY : in  std_logic;

      VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR MULTIPLICATION
      -- CONTROL
      VECTOR_MULTIPLICATION_START : out std_logic;
      VECTOR_MULTIPLICATION_READY : in  std_logic;

      VECTOR_MULTIPLICATION_DATA_IN_ENABLE : out std_logic;

      VECTOR_MULTIPLICATION_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR SUMMATION
      -- CONTROL
      VECTOR_SUMMATION_START : out std_logic;
      VECTOR_SUMMATION_READY : in  std_logic;

      VECTOR_SUMMATION_DATA_IN_ENABLE : out std_logic;

      VECTOR_SUMMATION_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR MODULE
      -- CONTROL
      VECTOR_MODULE_START : out std_logic;
      VECTOR_MODULE_READY : in  std_logic;

      VECTOR_MODULE_DATA_IN_ENABLE : out std_logic;

      VECTOR_MODULE_DATA_ENABLE : in std_logic;

      VECTOR_MODULE_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MODULE_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MODULE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX CONVOLUTION
      -- CONTROL
      MATRIX_CONVOLUTION_START : out std_logic;
      MATRIX_CONVOLUTION_READY : in  std_logic;

      MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_CONVOLUTION_DATA_I_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_J_ENABLE : in std_logic;

      MATRIX_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX INVERSE
      -- CONTROL
      MATRIX_INVERSE_START : out std_logic;
      MATRIX_INVERSE_READY : in  std_logic;

      MATRIX_INVERSE_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_INVERSE_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_INVERSE_DATA_I_ENABLE : in std_logic;
      MATRIX_INVERSE_DATA_J_ENABLE : in std_logic;

      MATRIX_INVERSE_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INVERSE_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INVERSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INVERSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INVERSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX MULTIPLICATION
      -- CONTROL
      MATRIX_MULTIPLICATION_START : out std_logic;
      MATRIX_MULTIPLICATION_READY : in  std_logic;

      MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_MULTIPLICATION_DATA_I_ENABLE : in std_logic;
      MATRIX_MULTIPLICATION_DATA_J_ENABLE : in std_logic;

      MATRIX_MULTIPLICATION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MULTIPLICATION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX PRODUCT
      -- CONTROL
      MATRIX_PRODUCT_START : out std_logic;
      MATRIX_PRODUCT_READY : in  std_logic;

      MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_PRODUCT_DATA_I_ENABLE : in std_logic;
      MATRIX_PRODUCT_DATA_J_ENABLE : in std_logic;

      MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX SUMMATION
      -- CONTROL
      MATRIX_SUMMATION_START : out std_logic;
      MATRIX_SUMMATION_READY : in  std_logic;

      MATRIX_SUMMATION_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_SUMMATION_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_SUMMATION_DATA_I_ENABLE : in std_logic;
      MATRIX_SUMMATION_DATA_J_ENABLE : in std_logic;

      MATRIX_SUMMATION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_SUMMATION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_SUMMATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_SUMMATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX TRANSPOSE
      -- CONTROL
      MATRIX_TRANSPOSE_START : out std_logic;
      MATRIX_TRANSPOSE_READY : in  std_logic;

      MATRIX_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_TRANSPOSE_DATA_I_ENABLE : in std_logic;
      MATRIX_TRANSPOSE_DATA_J_ENABLE : in std_logic;

      MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR CONVOLUTION
      -- CONTROL
      TENSOR_CONVOLUTION_START : out std_logic;
      TENSOR_CONVOLUTION_READY : in  std_logic;

      TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_CONVOLUTION_DATA_I_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_J_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_K_ENABLE : in std_logic;

      TENSOR_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_CONVOLUTION_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR INVERSE
      -- CONTROL
      TENSOR_INVERSE_START : out std_logic;
      TENSOR_INVERSE_READY : in  std_logic;

      TENSOR_INVERSE_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_INVERSE_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_INVERSE_DATA_I_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_J_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_K_ENABLE : in std_logic;

      TENSOR_INVERSE_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_INVERSE_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_INVERSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INVERSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INVERSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR MULTIPLICATION
      -- CONTROL
      TENSOR_MULTIPLICATION_START : out std_logic;
      TENSOR_MULTIPLICATION_READY : in  std_logic;

      TENSOR_MULTIPLICATION_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_MULTIPLICATION_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_MULTIPLICATION_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_MULTIPLICATION_DATA_I_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_J_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_K_ENABLE : in std_logic;

      TENSOR_MULTIPLICATION_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_MULTIPLICATION_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR PRODUCT
      -- CONTROL
      TENSOR_PRODUCT_START : out std_logic;
      TENSOR_PRODUCT_READY : in  std_logic;

      TENSOR_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_PRODUCT_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_PRODUCT_DATA_I_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_J_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_K_ENABLE : in std_logic;

      TENSOR_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_PRODUCT_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR SUMMATION
      -- CONTROL
      TENSOR_SUMMATION_START : out std_logic;
      TENSOR_SUMMATION_READY : in  std_logic;

      TENSOR_SUMMATION_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_SUMMATION_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_SUMMATION_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_SUMMATION_DATA_I_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_J_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_K_ENABLE : in std_logic;

      TENSOR_SUMMATION_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_SUMMATION_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_SUMMATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_SUMMATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_SUMMATION_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR TRANSPOSE
      -- CONTROL
      TENSOR_TRANSPOSE_START : out std_logic;
      TENSOR_TRANSPOSE_READY : in  std_logic;

      TENSOR_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_TRANSPOSE_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_TRANSPOSE_DATA_I_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_J_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_K_ENABLE : in std_logic;

      TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- VECTOR
  component ntm_dot_product is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_vector_convolution is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_vector_cosine_similarity is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_vector_multiplication is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_vector_summation is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_vector_module is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- MATRIX
  component ntm_matrix_convolution is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
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

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_matrix_inverse is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_matrix_multiplication is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_matrix_product is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
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

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_matrix_summation is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_matrix_transpose is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- TENSOR
  component ntm_tensor_convolution is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
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
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_tensor_inverse is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_tensor_multiplication is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_tensor_product is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
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
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_tensor_summation is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_tensor_transpose is
    generic (
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_algebra_pkg;
