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

use work.accelerator_arithmetic_pkg.all;

package accelerator_float_pkg is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- SYSTEM-SIZE

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  signal MONITOR_TEST : string(70 downto 1) := "                                                                      ";
  signal MONITOR_CASE : string(70 downto 1) := "                                                                      ";

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

  -- FLOATS
  constant FLOAT_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"0000000000000000";
  constant FLOAT_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"3FF199999999999A";
  constant FLOAT_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"400199999999999A";
  constant FLOAT_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"400A666666666666";
  constant FLOAT_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"401199999999999A";
  constant FLOAT_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"4016000000000000";
  constant FLOAT_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"401A666666666666";
  constant FLOAT_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"401ECCCCCCCCCCCD";
  constant FLOAT_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"402199999999999A";
  constant FLOAT_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"4023CCCCCCCCCCCD";
  constant FLOAT_P_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"7FF0000000000000";

  constant FLOAT_N_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"8000000000000000";
  constant FLOAT_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"BFF199999999999A";
  constant FLOAT_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"C00199999999999A";
  constant FLOAT_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"C00A666666666666";
  constant FLOAT_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01199999999999A";
  constant FLOAT_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C016000000000000";
  constant FLOAT_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01A666666666666";
  constant FLOAT_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01ECCCCCCCCCCCD";
  constant FLOAT_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"C02199999999999A";
  constant FLOAT_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C023CCCCCCCCCCCD";
  constant FLOAT_N_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"FFF0000000000000";

  -- Float Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((FLOAT_P_TWO, FLOAT_P_ONE, FLOAT_P_THREE, FLOAT_P_FOUR), (FLOAT_P_TWO, FLOAT_P_ONE, FLOAT_P_ONE, FLOAT_P_TWO), (FLOAT_P_NINE, FLOAT_P_ONE, FLOAT_P_FOUR, FLOAT_P_TWO), (FLOAT_P_ONE, FLOAT_P_SIX, FLOAT_P_ONE, FLOAT_P_TWO)), ((FLOAT_P_FOUR, FLOAT_P_NINE, FLOAT_P_FOUR, FLOAT_P_EIGHT), (FLOAT_P_TWO, FLOAT_P_TWO, FLOAT_P_ONE, FLOAT_P_ONE), (FLOAT_P_THREE, FLOAT_P_ONE, FLOAT_P_SIX, FLOAT_P_FIVE), (FLOAT_P_FOUR, FLOAT_P_FOUR, FLOAT_P_FIVE, FLOAT_P_EIGHT)), ((FLOAT_P_EIGHT, FLOAT_P_ONE, FLOAT_P_SIX, FLOAT_P_TWO), (FLOAT_P_EIGHT, FLOAT_P_FIVE, FLOAT_P_SIX, FLOAT_P_TWO), (FLOAT_P_NINE, FLOAT_P_ONE, FLOAT_P_FIVE, FLOAT_P_NINE), (FLOAT_P_ONE, FLOAT_P_FOUR, FLOAT_P_ONE, FLOAT_P_FOUR)), ((FLOAT_P_ONE, FLOAT_P_THREE, FLOAT_P_ONE, FLOAT_P_TWO), (FLOAT_P_EIGHT, FLOAT_P_FOUR, FLOAT_P_ONE, FLOAT_P_EIGHT), (FLOAT_P_FIVE, FLOAT_P_EIGHT, FLOAT_P_THREE, FLOAT_P_FOUR), (FLOAT_P_ONE, FLOAT_P_FOUR, FLOAT_N_THREE, FLOAT_P_EIGHT)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((FLOAT_P_TWO, FLOAT_P_FIVE, FLOAT_P_THREE, FLOAT_P_ONE), (FLOAT_P_ONE, FLOAT_P_FOUR, FLOAT_P_ONE, FLOAT_P_FOUR), (FLOAT_P_TWO, FLOAT_P_FOUR, FLOAT_P_NINE, FLOAT_P_EIGHT), (FLOAT_P_FOUR, FLOAT_P_TWO, FLOAT_P_ONE, FLOAT_P_TWO)), ((FLOAT_P_THREE, FLOAT_P_ONE, FLOAT_P_FIVE, FLOAT_P_SIX), (FLOAT_P_FIVE, FLOAT_P_FOUR, FLOAT_P_EIGHT, FLOAT_P_FOUR), (FLOAT_P_FOUR, FLOAT_P_FIVE, FLOAT_P_FOUR, FLOAT_P_ONE), (FLOAT_P_FIVE, FLOAT_P_SIX, FLOAT_P_EIGHT, FLOAT_P_FIVE)), ((FLOAT_P_EIGHT, FLOAT_P_NINE, FLOAT_P_ONE, FLOAT_P_FIVE), (FLOAT_P_ONE, FLOAT_P_TWO, FLOAT_P_SIX, FLOAT_P_ONE), (FLOAT_P_NINE, FLOAT_P_FOUR, FLOAT_P_EIGHT, FLOAT_P_ONE), (FLOAT_P_FIVE, FLOAT_P_FOUR, FLOAT_P_EIGHT, FLOAT_P_FOUR)), ((FLOAT_P_FIVE, FLOAT_P_FOUR, FLOAT_N_NINE, FLOAT_P_ONE), (FLOAT_P_THREE, FLOAT_P_EIGHT, FLOAT_P_FOUR, FLOAT_P_FOUR), (FLOAT_P_THREE, FLOAT_P_six, FLOAT_P_FOUR, FLOAT_P_SIX), (FLOAT_P_ONE, FLOAT_P_EIGHT, FLOAT_N_ONE, FLOAT_P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((FLOAT_P_ONE, FLOAT_N_ONE, FLOAT_P_FOUR, FLOAT_P_ONE), (FLOAT_P_THREE, FLOAT_P_SIX, FLOAT_N_ONE, FLOAT_N_NINE), (FLOAT_P_SEVEN, FLOAT_P_FOUR, FLOAT_P_EIGHT, FLOAT_P_FOUR), (FLOAT_P_FIVE, FLOAT_P_SIX, FLOAT_P_THREE, FLOAT_P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((FLOAT_P_ONE, FLOAT_P_TWO, FLOAT_P_SEVEN, FLOAT_P_SIX), (FLOAT_P_FOUR, FLOAT_P_NINE, FLOAT_P_TWO, FLOAT_P_ONE), (FLOAT_P_ONE, FLOAT_P_FIVE, FLOAT_P_THREE, FLOAT_P_SIX), (FLOAT_P_EIGHT, FLOAT_P_FOUR, FLOAT_N_ONE, FLOAT_P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (FLOAT_P_FOUR, FLOAT_N_ONE, FLOAT_P_SEVEN, FLOAT_N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (FLOAT_P_THREE, FLOAT_P_SIX, FLOAT_N_NINE, FLOAT_N_ONE);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := FLOAT_P_NINE;
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := FLOAT_N_FOUR;

  -- SCALAR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_SCALAR_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_1    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_2      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_2 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_2    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_3      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_3 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_3    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_4      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_4 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_4    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_5      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_5 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_5    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_6      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_6 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_6    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_7      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_7 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_7    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_8      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_8 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_8    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_9      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_9 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_9    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_10      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_10 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_10    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_11      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_11 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_11    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_12      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_12 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_12    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_13      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_13 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_13    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_14      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_14 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_14    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_15      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_15 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_15    : boolean := false;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FLOAT_DIVIDER_CASE_1    : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FLOAT_DIVIDER_CASE_1    : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FLOAT_DIVIDER_CASE_1    : boolean := false;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component accelerator_float_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4;

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

      ------------------------------------------------------------------------------
      -- STIMULUS SCALAR FLOAT
      ------------------------------------------------------------------------------

      -- SCALAR FLOAT ADDER
      -- CONTROL
      SCALAR_FLOAT_ADDER_START : out std_logic;
      SCALAR_FLOAT_ADDER_READY : in  std_logic;

      SCALAR_FLOAT_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_FLOAT_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_ADDER_OVERFLOW_OUT : in  std_logic;

      -- SCALAR FLOAT MULTIPLIER
      -- CONTROL
      SCALAR_FLOAT_MULTIPLIER_START : out std_logic;
      SCALAR_FLOAT_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- SCALAR FLOAT DIVIDER
      -- CONTROL
      SCALAR_FLOAT_DIVIDER_START : out std_logic;
      SCALAR_FLOAT_DIVIDER_READY : in  std_logic;

      -- DATA
      SCALAR_FLOAT_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_DIVIDER_OVERFLOW_OUT : in  std_logic;

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR FLOAT
      ------------------------------------------------------------------------------

      -- VECTOR FLOAT ADDER
      -- CONTROL
      VECTOR_FLOAT_ADDER_START : out std_logic;
      VECTOR_FLOAT_ADDER_READY : in  std_logic;

      VECTOR_FLOAT_ADDER_OPERATION : out std_logic;

      VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_FLOAT_ADDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_FLOAT_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_ADDER_OVERFLOW_OUT : in  std_logic;

      -- VECTOR FLOAT MULTIPLIER
      -- CONTROL
      VECTOR_FLOAT_MULTIPLIER_START : out std_logic;
      VECTOR_FLOAT_MULTIPLIER_READY : in  std_logic;

      VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_FLOAT_MULTIPLIER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- VECTOR FLOAT DIVIDER
      -- CONTROL
      VECTOR_FLOAT_DIVIDER_START : out std_logic;
      VECTOR_FLOAT_DIVIDER_READY : in  std_logic;

      VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_FLOAT_DIVIDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_FLOAT_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FLOAT_DIVIDER_OVERFLOW_OUT : in  std_logic;

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX FLOAT
      ------------------------------------------------------------------------------

      -- MATRIX FLOAT ADDER
      -- CONTROL
      MATRIX_FLOAT_ADDER_START : out std_logic;
      MATRIX_FLOAT_ADDER_READY : in  std_logic;

      MATRIX_FLOAT_ADDER_OPERATION : out std_logic;

      MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_FLOAT_ADDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FLOAT_ADDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FLOAT_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_ADDER_OVERFLOW_OUT : in  std_logic;

      -- MATRIX FLOAT MULTIPLIER
      -- CONTROL
      MATRIX_FLOAT_MULTIPLIER_START : out std_logic;
      MATRIX_FLOAT_MULTIPLIER_READY : in  std_logic;

      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- MATRIX FLOAT DIVIDER
      -- CONTROL
      MATRIX_FLOAT_DIVIDER_START : out std_logic;
      MATRIX_FLOAT_DIVIDER_READY : in  std_logic;

      MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_FLOAT_DIVIDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FLOAT_DIVIDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FLOAT_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FLOAT_DIVIDER_OVERFLOW_OUT : in  std_logic;

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR FLOAT
      ------------------------------------------------------------------------------

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_FLOAT_ADDER_START : out std_logic;
      TENSOR_FLOAT_ADDER_READY : in  std_logic;

      TENSOR_FLOAT_ADDER_OPERATION : out std_logic;

      TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_FLOAT_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FLOAT_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_FLOAT_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FLOAT_ADDER_OVERFLOW_OUT : in std_logic;

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_FLOAT_MULTIPLIER_START : out std_logic;
      TENSOR_FLOAT_MULTIPLIER_READY : in  std_logic;

      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_FLOAT_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in std_logic;

      -- TENSOR DIVIDER
      -- CONTROL
      TENSOR_FLOAT_DIVIDER_START : out std_logic;
      TENSOR_FLOAT_DIVIDER_READY : in  std_logic;

      TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_FLOAT_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_DIVIDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FLOAT_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FLOAT_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_FLOAT_DIVIDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FLOAT_DIVIDER_OVERFLOW_OUT : in std_logic
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

end accelerator_float_pkg;
