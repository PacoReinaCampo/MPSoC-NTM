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

package ntm_function_pkg is

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
  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));
  constant FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(4, DATA_SIZE));
  constant FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(5, DATA_SIZE));
  constant SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(6, DATA_SIZE));
  constant SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(7, DATA_SIZE));
  constant EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(8, DATA_SIZE));
  constant NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(9, DATA_SIZE));

  -- Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((TWO, ONE, FOUR), (NINE, FOUR, TWO), (ONE, ONE, TWO)), ((EIGHT, SIX, TWO), (EIGHT, FIVE, TWO), (ONE, FOUR, ONE)), ((THREE, ONE, SIX), (FIVE, ZERO, FOUR), (FIVE, EIGHT, FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((ONE, THREE, ONE), (TWO, FOUR, EIGHT), (FOUR, ONE, TWO)), ((NINE, ONE, FIVE), (NINE, EIGHT, ONE), (FIVE, EIGHT, FOUR)), ((FIVE, FOUR, ONE), (THREE, FOUR, SIX), (ONE, EIGHT, EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((ONE, FOUR, ONE), (ZERO, EIGHT, FOUR), (FIVE, THREE, NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((ONE, TWO, SIX), (ONE, THREE, SIX), (EIGHT, FOUR, FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (FOUR, NINE, THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (THREE, NINE, ZERO);

  -- SCALAR-FUNCTIONALITY
  signal STIMULUS_NTM_SCALAR_COSH_TEST              : boolean := false;
  signal STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST     : boolean := false;
  signal STIMULUS_NTM_SCALAR_LOGARITHM_TEST         : boolean := false;
  signal STIMULUS_NTM_SCALAR_LOGISTIC_TEST          : boolean := false;
  signal STIMULUS_NTM_SCALAR_ONEPLUS_TEST           : boolean := false;
  signal STIMULUS_NTM_SCALAR_SINH_TEST              : boolean := false;
  signal STIMULUS_NTM_SCALAR_TANH_TEST              : boolean := false;

  signal STIMULUS_NTM_SCALAR_COSH_CASE_0              : boolean := false;
  signal STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0     : boolean := false;
  signal STIMULUS_NTM_SCALAR_LOGARITHM_CASE_0         : boolean := false;
  signal STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0          : boolean := false;
  signal STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0           : boolean := false;
  signal STIMULUS_NTM_SCALAR_SINH_CASE_0              : boolean := false;
  signal STIMULUS_NTM_SCALAR_TANH_CASE_0              : boolean := false;

  signal STIMULUS_NTM_SCALAR_COSH_CASE_1              : boolean := false;
  signal STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1     : boolean := false;
  signal STIMULUS_NTM_SCALAR_LOGARITHM_CASE_1         : boolean := false;
  signal STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1          : boolean := false;
  signal STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1           : boolean := false;
  signal STIMULUS_NTM_SCALAR_SINH_CASE_1              : boolean := false;
  signal STIMULUS_NTM_SCALAR_TANH_CASE_1              : boolean := false;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_NTM_VECTOR_COSH_TEST              : boolean := false;
  signal STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST     : boolean := false;
  signal STIMULUS_NTM_VECTOR_LOGARITHM_TEST         : boolean := false;
  signal STIMULUS_NTM_VECTOR_LOGISTIC_TEST          : boolean := false;
  signal STIMULUS_NTM_VECTOR_ONEPLUS_TEST           : boolean := false;
  signal STIMULUS_NTM_VECTOR_SINH_TEST              : boolean := false;
  signal STIMULUS_NTM_VECTOR_TANH_TEST              : boolean := false;

  signal STIMULUS_NTM_VECTOR_COSH_CASE_0              : boolean := false;
  signal STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0     : boolean := false;
  signal STIMULUS_NTM_VECTOR_LOGARITHM_CASE_0         : boolean := false;
  signal STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0          : boolean := false;
  signal STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0           : boolean := false;
  signal STIMULUS_NTM_VECTOR_SINH_CASE_0              : boolean := false;
  signal STIMULUS_NTM_VECTOR_TANH_CASE_0              : boolean := false;

  signal STIMULUS_NTM_VECTOR_COSH_CASE_1              : boolean := false;
  signal STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1     : boolean := false;
  signal STIMULUS_NTM_VECTOR_LOGARITHM_CASE_1         : boolean := false;
  signal STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1          : boolean := false;
  signal STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1           : boolean := false;
  signal STIMULUS_NTM_VECTOR_SINH_CASE_1              : boolean := false;
  signal STIMULUS_NTM_VECTOR_TANH_CASE_1              : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_NTM_MATRIX_COSH_TEST              : boolean := false;
  signal STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST     : boolean := false;
  signal STIMULUS_NTM_MATRIX_LOGARITHM_TEST         : boolean := false;
  signal STIMULUS_NTM_MATRIX_LOGISTIC_TEST          : boolean := false;
  signal STIMULUS_NTM_MATRIX_ONEPLUS_TEST           : boolean := false;
  signal STIMULUS_NTM_MATRIX_SINH_TEST              : boolean := false;
  signal STIMULUS_NTM_MATRIX_TANH_TEST              : boolean := false;

  signal STIMULUS_NTM_MATRIX_COSH_CASE_0              : boolean := false;
  signal STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0     : boolean := false;
  signal STIMULUS_NTM_MATRIX_LOGARITHM_CASE_0         : boolean := false;
  signal STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0          : boolean := false;
  signal STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0           : boolean := false;
  signal STIMULUS_NTM_MATRIX_SINH_CASE_0              : boolean := false;
  signal STIMULUS_NTM_MATRIX_TANH_CASE_0              : boolean := false;

  signal STIMULUS_NTM_MATRIX_COSH_CASE_1              : boolean := false;
  signal STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1     : boolean := false;
  signal STIMULUS_NTM_MATRIX_LOGARITHM_CASE_1         : boolean := false;
  signal STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1          : boolean := false;
  signal STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1           : boolean := false;
  signal STIMULUS_NTM_MATRIX_SINH_CASE_1              : boolean := false;
  signal STIMULUS_NTM_MATRIX_TANH_CASE_1              : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_function_stimulus is
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

      -- SCALAR COSH
      -- CONTROL
      SCALAR_COSH_START : out std_logic;
      SCALAR_COSH_READY : in  std_logic;

      -- DATA
      SCALAR_COSH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_COSH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR EXPONENTIATOR
      -- CONTROL
      SCALAR_EXPONENTIATOR_START : out std_logic;
      SCALAR_EXPONENTIATOR_READY : in  std_logic;

      -- DATA
      SCALAR_EXPONENTIATOR_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_EXPONENTIATOR_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR LOGISTIC
      -- CONTROL
      SCALAR_LOGISTIC_START : out std_logic;
      SCALAR_LOGISTIC_READY : in  std_logic;

      -- DATA
      SCALAR_LOGISTIC_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGISTIC_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR LOGARITHM
      -- CONTROL
      SCALAR_LOGARITHM_START : out std_logic;
      SCALAR_LOGARITHM_READY : in  std_logic;

      -- DATA
      SCALAR_LOGARITHM_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGARITHM_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

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
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_function_pkg;
