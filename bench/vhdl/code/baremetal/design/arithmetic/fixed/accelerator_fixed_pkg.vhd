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

package accelerator_fixed_pkg is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- SYSTEM-SIZE

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

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

  -- FIXEDS
  constant FIXED_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"0000000000000000";
  constant FIXED_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"3FF199999999999A";
  constant FIXED_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"400199999999999A";
  constant FIXED_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"400A666666666666";
  constant FIXED_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"401199999999999A";
  constant FIXED_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"4016000000000000";
  constant FIXED_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"401A666666666666";
  constant FIXED_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"401ECCCCCCCCCCCD";
  constant FIXED_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"402199999999999A";
  constant FIXED_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"4023CCCCCCCCCCCD";
  constant FIXED_P_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"7FF0000000000000";

  constant FIXED_N_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"8000000000000000";
  constant FIXED_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"BFF199999999999A";
  constant FIXED_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"C00199999999999A";
  constant FIXED_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"C00A666666666666";
  constant FIXED_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01199999999999A";
  constant FIXED_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C016000000000000";
  constant FIXED_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01A666666666666";
  constant FIXED_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01ECCCCCCCCCCCD";
  constant FIXED_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"C02199999999999A";
  constant FIXED_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C023CCCCCCCCCCCD";
  constant FIXED_N_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"FFF0000000000000";

  -- Integer Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((FIXED_P_TWO, FIXED_P_ONE, FIXED_P_THREE, FIXED_P_FOUR), (FIXED_P_TWO, FIXED_P_ONE, FIXED_P_ONE, FIXED_P_TWO), (FIXED_P_NINE, FIXED_P_ONE, FIXED_P_FOUR, FIXED_P_TWO), (FIXED_P_ONE, FIXED_P_SIX, FIXED_P_ONE, FIXED_P_TWO)), ((FIXED_P_FOUR, FIXED_P_NINE, FIXED_P_FOUR, FIXED_P_EIGHT), (FIXED_P_TWO, FIXED_P_TWO, FIXED_P_ONE, FIXED_P_ONE), (FIXED_P_THREE, FIXED_P_ONE, FIXED_P_SIX, FIXED_P_FIVE), (FIXED_P_ZERO, FIXED_P_FOUR, FIXED_P_FIVE, FIXED_P_EIGHT)), ((FIXED_P_EIGHT, FIXED_P_ONE, FIXED_P_SIX, FIXED_P_TWO), (FIXED_P_EIGHT, FIXED_P_FIVE, FIXED_P_SIX, FIXED_P_TWO), (FIXED_P_NINE, FIXED_P_ONE, FIXED_P_FIVE, FIXED_P_NINE), (FIXED_P_ONE, FIXED_P_FOUR, FIXED_P_ONE, FIXED_P_FOUR)), ((FIXED_P_ONE, FIXED_P_THREE, FIXED_P_ONE, FIXED_P_TWO), (FIXED_P_EIGHT, FIXED_P_FOUR, FIXED_P_ONE, FIXED_P_EIGHT), (FIXED_P_FIVE, FIXED_P_EIGHT, FIXED_P_THREE, FIXED_P_FOUR), (FIXED_P_ONE, FIXED_P_FOUR, FIXED_N_THREE, FIXED_P_EIGHT)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((FIXED_P_TWO, FIXED_P_FIVE, FIXED_P_THREE, FIXED_P_ONE), (FIXED_P_ONE, FIXED_P_FOUR, FIXED_P_ONE, FIXED_P_ZERO), (FIXED_P_TWO, FIXED_P_FOUR, FIXED_P_NINE, FIXED_P_EIGHT), (FIXED_P_FOUR, FIXED_P_TWO, FIXED_P_ONE, FIXED_P_TWO)),((FIXED_P_THREE, FIXED_P_ONE, FIXED_P_FIVE, FIXED_P_SIX), (FIXED_P_FIVE, FIXED_P_ZERO, FIXED_P_EIGHT, FIXED_P_FOUR), (FIXED_P_FOUR, FIXED_P_FIVE, FIXED_P_FOUR, FIXED_P_ONE), (FIXED_P_FIVE, FIXED_P_SIX, FIXED_P_EIGHT, FIXED_P_FIVE)), ((FIXED_P_EIGHT, FIXED_P_NINE, FIXED_P_ONE, FIXED_P_FIVE), (FIXED_P_ONE, FIXED_P_TWO, FIXED_P_SIX, FIXED_P_ONE), (FIXED_P_NINE, FIXED_P_FOUR, FIXED_P_EIGHT, FIXED_P_ONE), (FIXED_P_FIVE, FIXED_P_FOUR, FIXED_P_EIGHT, FIXED_P_FOUR)), ((FIXED_P_FIVE, FIXED_P_FOUR, FIXED_N_NINE, FIXED_P_ONE), (FIXED_P_THREE, FIXED_P_EIGHT, FIXED_P_FOUR, FIXED_P_FOUR), (FIXED_P_THREE, FIXED_P_six, FIXED_P_FOUR, FIXED_P_SIX), (FIXED_P_ONE, FIXED_P_EIGHT, FIXED_N_ONE, FIXED_P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((FIXED_P_ONE, FIXED_N_ONE, FIXED_P_FOUR, FIXED_P_ONE), (FIXED_P_THREE, FIXED_P_SIX, FIXED_N_ONE, FIXED_N_NINE), (FIXED_P_SEVEN, FIXED_P_ZERO, FIXED_P_EIGHT, FIXED_P_FOUR), (FIXED_P_FIVE, FIXED_P_SIX, FIXED_P_THREE, FIXED_P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((FIXED_P_ONE, FIXED_P_TWO, FIXED_P_SEVEN, FIXED_P_SIX), (FIXED_P_FOUR, FIXED_P_NINE, FIXED_P_TWO, FIXED_P_ONE), (FIXED_P_ONE, FIXED_P_FIVE, FIXED_P_THREE, FIXED_P_SIX), (FIXED_P_EIGHT, FIXED_P_FOUR, FIXED_N_ONE, FIXED_P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (FIXED_P_FOUR, FIXED_N_ONE, FIXED_P_SEVEN, FIXED_N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (FIXED_P_THREE, FIXED_P_SIX, FIXED_N_NINE, FIXED_N_ONE);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := FIXED_P_NINE;
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := FIXED_N_FOUR;

  -- SCALAR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_SCALAR_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_CASE_1    : boolean := false;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_CASE_1    : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_CASE_1    : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_CASE_1    : boolean := false;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component accelerator_fixed_stimulus is
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
      -- STIMULUS SCALAR FIXED
      ------------------------------------------------------------------------------

      -- SCALAR FIXED ADDER
      -- CONTROL
      SCALAR_FIXED_ADDER_START : out std_logic;
      SCALAR_FIXED_ADDER_READY : in  std_logic;

      SCALAR_FIXED_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_FIXED_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_ADDER_OVERFLOW_OUT : in  std_logic;

      -- SCALAR FIXED MULTIPLIER
      -- CONTROL
      SCALAR_FIXED_MULTIPLIER_START : out std_logic;
      SCALAR_FIXED_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_FIXED_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- SCALAR FIXED DIVIDER
      -- CONTROL
      SCALAR_FIXED_DIVIDER_START : out std_logic;
      SCALAR_FIXED_DIVIDER_READY : in  std_logic;

      -- DATA
      SCALAR_FIXED_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FIXED_DIVIDER_OVERFLOW_OUT : in  std_logic;

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR FIXED
      ------------------------------------------------------------------------------

      -- VECTOR FIXED ADDER
      -- CONTROL
      VECTOR_FIXED_ADDER_START : out std_logic;
      VECTOR_FIXED_ADDER_READY : in  std_logic;

      VECTOR_FIXED_ADDER_OPERATION : out std_logic;

      VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_FIXED_ADDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_FIXED_ADDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_FIXED_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_ADDER_OVERFLOW_OUT : in  std_logic;

      -- VECTOR FIXED MULTIPLIER
      -- CONTROL
      VECTOR_FIXED_MULTIPLIER_START : out std_logic;
      VECTOR_FIXED_MULTIPLIER_READY : in  std_logic;

      VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_FIXED_MULTIPLIER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_FIXED_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- VECTOR FIXED DIVIDER
      -- CONTROL
      VECTOR_FIXED_DIVIDER_START : out std_logic;
      VECTOR_FIXED_DIVIDER_READY : in  std_logic;

      VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_FIXED_DIVIDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_FIXED_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_FIXED_DIVIDER_OVERFLOW_OUT : in  std_logic;

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX FIXED
      ------------------------------------------------------------------------------

      -- MATRIX FIXED ADDER
      -- CONTROL
      MATRIX_FIXED_ADDER_START : out std_logic;
      MATRIX_FIXED_ADDER_READY : in  std_logic;

      MATRIX_FIXED_ADDER_OPERATION : out std_logic;

      MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_FIXED_ADDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FIXED_ADDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FIXED_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_ADDER_OVERFLOW_OUT : in  std_logic;

      -- MATRIX FIXED MULTIPLIER
      -- CONTROL
      MATRIX_FIXED_MULTIPLIER_START : out std_logic;
      MATRIX_FIXED_MULTIPLIER_READY : in  std_logic;

      MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_FIXED_MULTIPLIER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FIXED_MULTIPLIER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FIXED_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- MATRIX FIXED DIVIDER
      -- CONTROL
      MATRIX_FIXED_DIVIDER_START : out std_logic;
      MATRIX_FIXED_DIVIDER_READY : in  std_logic;

      MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_FIXED_DIVIDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FIXED_DIVIDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_FIXED_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_FIXED_DIVIDER_OVERFLOW_OUT : in  std_logic;

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR FIXED
      ------------------------------------------------------------------------------

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_FIXED_ADDER_START : out std_logic;
      TENSOR_FIXED_ADDER_READY : in  std_logic;

      TENSOR_FIXED_ADDER_OPERATION : out std_logic;

      TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_FIXED_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FIXED_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_FIXED_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FIXED_ADDER_OVERFLOW_OUT : in std_logic;

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_FIXED_MULTIPLIER_START : out std_logic;
      TENSOR_FIXED_MULTIPLIER_READY : in  std_logic;

      TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_FIXED_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_FIXED_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FIXED_MULTIPLIER_OVERFLOW_OUT : in std_logic;

      -- TENSOR DIVIDER
      -- CONTROL
      TENSOR_FIXED_DIVIDER_START : out std_logic;
      TENSOR_FIXED_DIVIDER_READY : in  std_logic;

      TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_FIXED_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_DIVIDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_FIXED_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FIXED_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_FIXED_DIVIDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_FIXED_DIVIDER_OVERFLOW_OUT : in std_logic
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

end accelerator_fixed_pkg;
