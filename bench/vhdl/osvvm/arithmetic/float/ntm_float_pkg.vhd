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

package ntm_float_pkg is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 32;

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
  constant SIZE_I : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));
  constant SIZE_J : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));
  constant SIZE_K : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));

  constant SIZE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));

  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- i in 0 to R-1

  -- FLOATS
  constant P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"00000000";
  constant P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"3f8ccccd";
  constant P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"400ccccd";
  constant P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"40533333";
  constant P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"408ccccd";
  constant P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"40b00000";
  constant P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"40d33333";
  constant P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"40f66666";
  constant P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"410ccccd";
  constant P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"411e6666";
  constant P_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"7f800000";

  constant N_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"80000000";
  constant N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"bf8ccccd";
  constant N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"c00ccccd";
  constant N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0533333";
  constant N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c08ccccd";
  constant N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0b00000";
  constant N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0d33333";
  constant N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0f66666";
  constant N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"c10ccccd";
  constant N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c11e6666";
  constant N_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"ff800000";

  -- Integer Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((P_TWO, P_ONE, P_FOUR), (P_NINE, P_FOUR, P_TWO), (P_ONE, P_ONE, P_TWO)), ((P_EIGHT, P_SIX, P_TWO), (P_EIGHT, P_FIVE, P_TWO), (P_ONE, P_FOUR, P_ONE)), ((P_THREE, P_ONE, P_SIX), (P_FIVE, P_ZERO, P_FOUR), (P_FIVE, P_EIGHT, P_FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((P_ONE, P_THREE, P_ONE), (P_TWO, P_FOUR, P_EIGHT), (P_FOUR, P_ONE, P_TWO)), ((P_NINE, P_ONE, P_FIVE), (P_NINE, P_EIGHT, P_ONE), (P_FIVE, P_EIGHT, P_FOUR)), ((P_FIVE, P_FOUR, P_ONE), (P_THREE, P_FOUR, P_SIX), (P_ONE, P_EIGHT, P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((P_ONE, P_FOUR, P_ONE), (P_SEVEN, P_EIGHT, P_FOUR), (P_FIVE, P_THREE, P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((P_ONE, P_TWO, P_SIX), (P_ONE, P_THREE, P_SIX), (P_EIGHT, P_FOUR, P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (P_FOUR, P_SEVEN, N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (P_THREE, N_NINE, N_ONE);

  -- constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := P_NINE;
  -- constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := N_FOUR;

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := X"480C8021";
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := X"C3302020";

  -- ADDITION       = X"480C5419"
  -- SUSTRACTION    = X"480CAC29"
  -- MULTIPLICATION = X"CBC15371"
  -- DIVISION       = X"C44C3801"

  -- SCALAR-FUNCTIONALITY
  signal STIMULUS_NTM_SCALAR_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_SCALAR_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_SCALAR_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_SCALAR_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_SCALAR_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_SCALAR_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_SCALAR_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_SCALAR_DIVIDER_CASE_1    : boolean := false;

  signal STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_1    : boolean := false;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_NTM_VECTOR_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_VECTOR_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_VECTOR_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_CASE_1    : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_NTM_MATRIX_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_MATRIX_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_MATRIX_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_CASE_1    : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_NTM_TENSOR_FLOAT_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_TENSOR_FLOAT_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_TENSOR_FLOAT_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_CASE_1    : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_float_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64;

      X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- x in 0 to X-1
      Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- y in 0 to Y-1
      N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- j in 0 to N-1
      W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- k in 0 to W-1
      L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE));  -- l in 0 to L-1
      R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(32, DATA_SIZE))  -- i in 0 to R-1
      );
    port (
      -- GLOBAL
      CLK : out std_logic;
      RST : out std_logic;

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR FLOAT
      -----------------------------------------------------------------------

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

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR FLOAT
      -----------------------------------------------------------------------

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

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX FLOAT
      -----------------------------------------------------------------------

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

      -----------------------------------------------------------------------
      -- STIMULUS TENSOR FLOAT
      -----------------------------------------------------------------------

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

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_float_pkg;
