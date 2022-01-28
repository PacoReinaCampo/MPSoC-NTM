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
  constant DATA_SIZE : integer := 512;

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
  constant P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
  constant P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(1, DATA_SIZE));
  constant P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(2, DATA_SIZE));
  constant P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(3, DATA_SIZE));
  constant P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(4, DATA_SIZE));
  constant P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(5, DATA_SIZE));
  constant P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(6, DATA_SIZE));
  constant P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(7, DATA_SIZE));
  constant P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(8, DATA_SIZE));
  constant P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(9, DATA_SIZE));

  constant N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-1, DATA_SIZE));
  constant N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-2, DATA_SIZE));
  constant N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-3, DATA_SIZE));
  constant N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-4, DATA_SIZE));
  constant N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-5, DATA_SIZE));
  constant N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-6, DATA_SIZE));
  constant N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-7, DATA_SIZE));
  constant N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-8, DATA_SIZE));
  constant N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-9, DATA_SIZE));

  -- Integer Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((P_TWO, P_ONE, P_FOUR), (P_NINE, P_FOUR, P_TWO), (P_ONE, P_ONE, P_TWO)), ((P_EIGHT, P_SIX, P_TWO), (P_EIGHT, P_FIVE, P_TWO), (P_ONE, P_FOUR, P_ONE)), ((P_THREE, P_ONE, P_SIX), (P_FIVE, P_ZERO, P_FOUR), (P_FIVE, P_EIGHT, P_FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((P_ONE, P_THREE, P_ONE), (P_TWO, P_FOUR, P_EIGHT), (P_FOUR, P_ONE, P_TWO)), ((P_NINE, P_ONE, P_FIVE), (P_NINE, P_EIGHT, P_ONE), (P_FIVE, P_EIGHT, P_FOUR)), ((P_FIVE, P_FOUR, P_ONE), (P_THREE, P_FOUR, P_SIX), (P_ONE, P_EIGHT, P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((P_ONE, P_FOUR, P_ONE), (P_ZERO, P_EIGHT, P_FOUR), (P_FIVE, P_THREE, P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((P_ONE, P_TWO, P_SIX), (P_ONE, P_THREE, P_SIX), (P_EIGHT, P_FOUR, P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (P_FOUR, P_SEVEN, N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (P_THREE, N_NINE, N_ONE);

  -- Float Buffer
  -- constant FLOAT_SAMPLE_A : std_logic_vector(31 downto 0) := X"480C8021";
  -- constant FLOAT_SAMPLE_B : std_logic_vector(31 downto 0) := X"C3302020";

  -- ADDITION       = X"480C5419"
  -- SUSTRACTION    = X"480CAC29"
  -- MULTIPLICATION = X"CBC15371"
  -- DIVISION       = X"C44C3801"

  constant FLOAT_SAMPLE_A : std_logic_vector(31 downto 0) := X"40400000";
  constant FLOAT_SAMPLE_B : std_logic_vector(31 downto 0) := X"40000000";

  -- ADDITION       = X"40A00000"
  -- SUSTRACTION    = X"3F800000"
  -- MULTIPLICATION = X"40C00000"
  -- DIVISION       = X"3FC00000"

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
  signal STIMULUS_NTM_VECTOR_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_VECTOR_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_VECTOR_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_VECTOR_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_VECTOR_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_VECTOR_DIVIDER_CASE_1    : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_NTM_MATRIX_ADDER_TEST      : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_NTM_MATRIX_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_NTM_MATRIX_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_NTM_MATRIX_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_NTM_MATRIX_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_NTM_MATRIX_DIVIDER_CASE_1    : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_float_stimulus is
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

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR
      -----------------------------------------------------------------------

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_ADDER_START : out std_logic;
      SCALAR_ADDER_READY : in  std_logic;

      SCALAR_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR FLOAT ADDER
      -- CONTROL
      SCALAR_FLOAT_ADDER_START : out std_logic;
      SCALAR_FLOAT_ADDER_READY : in  std_logic;

      SCALAR_FLOAT_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_FLOAT_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_MULTIPLIER_START : out std_logic;
      SCALAR_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR FLOAT MULTIPLIER
      -- CONTROL
      SCALAR_FLOAT_MULTIPLIER_START : out std_logic;
      SCALAR_FLOAT_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

      -- SCALAR DIVIDER
      -- CONTROL
      SCALAR_DIVIDER_START : out std_logic;
      SCALAR_DIVIDER_READY : in  std_logic;

      -- DATA
      SCALAR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

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
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_ADDER_START : out std_logic;
      VECTOR_ADDER_READY : in  std_logic;

      VECTOR_ADDER_OPERATION : out std_logic;

      VECTOR_ADDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_ADDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_ADDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_ADDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_MULTIPLIER_START : out std_logic;
      VECTOR_MULTIPLIER_READY : in  std_logic;

      VECTOR_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MULTIPLIER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR DIVIDER
      -- CONTROL
      VECTOR_DIVIDER_START : out std_logic;
      VECTOR_DIVIDER_READY : in  std_logic;

      VECTOR_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_DIVIDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_DIVIDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX
      -----------------------------------------------------------------------

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_ADDER_START : out std_logic;
      MATRIX_ADDER_READY : in  std_logic;

      MATRIX_ADDER_OPERATION : out std_logic;

      MATRIX_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_ADDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_MULTIPLIER_START : out std_logic;
      MATRIX_MULTIPLIER_READY : in  std_logic;

      MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX DIVIDER
      -- CONTROL
      MATRIX_DIVIDER_START : out std_logic;
      MATRIX_DIVIDER_READY : in  std_logic;

      MATRIX_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_float_pkg;
