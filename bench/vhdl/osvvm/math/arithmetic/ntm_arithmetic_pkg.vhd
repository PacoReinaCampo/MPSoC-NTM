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

  constant STIMULUS_NTM_VECTOR_MOD_CASE_0           : boolean := false;
  constant STIMULUS_NTM_VECTOR_ADDER_CASE_0         : boolean := false;
  constant STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0    : boolean := false;
  constant STIMULUS_NTM_VECTOR_INVERTER_CASE_0      : boolean := false;
  constant STIMULUS_NTM_VECTOR_DIVIDER_CASE_0       : boolean := false;
  constant STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0 : boolean := false;
  constant STIMULUS_NTM_VECTOR_ROOT_CASE_0          : boolean := false;
  constant STIMULUS_NTM_VECTOR_LOGARITHM_CASE_0     : boolean := false;

  constant STIMULUS_NTM_VECTOR_MOD_CASE_1           : boolean := false;
  constant STIMULUS_NTM_VECTOR_ADDER_CASE_1         : boolean := false;
  constant STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1    : boolean := false;
  constant STIMULUS_NTM_VECTOR_INVERTER_CASE_1      : boolean := false;
  constant STIMULUS_NTM_VECTOR_DIVIDER_CASE_1       : boolean := false;
  constant STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1 : boolean := false;
  constant STIMULUS_NTM_VECTOR_ROOT_CASE_1          : boolean := false;
  constant STIMULUS_NTM_VECTOR_LOGARITHM_CASE_1     : boolean := false;

  -- MATRIX-FUNCTIONALITY
  constant STIMULUS_NTM_MATRIX_MOD_TEST           : boolean := false;
  constant STIMULUS_NTM_MATRIX_ADDER_TEST         : boolean := false;
  constant STIMULUS_NTM_MATRIX_MULTIPLIER_TEST    : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERTER_TEST      : boolean := false;
  constant STIMULUS_NTM_MATRIX_DIVIDER_TEST       : boolean := false;
  constant STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST : boolean := false;
  constant STIMULUS_NTM_MATRIX_ROOT_TEST          : boolean := false;
  constant STIMULUS_NTM_MATRIX_LOGARITHM_TEST     : boolean := false;

  constant STIMULUS_NTM_MATRIX_MOD_CASE_0           : boolean := false;
  constant STIMULUS_NTM_MATRIX_ADDER_CASE_0         : boolean := false;
  constant STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0    : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERTER_CASE_0      : boolean := false;
  constant STIMULUS_NTM_MATRIX_DIVIDER_CASE_0       : boolean := false;
  constant STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0 : boolean := false;
  constant STIMULUS_NTM_MATRIX_ROOT_CASE_0          : boolean := false;
  constant STIMULUS_NTM_MATRIX_LOGARITHM_CASE_0     : boolean := false;

  constant STIMULUS_NTM_MATRIX_MOD_CASE_1           : boolean := false;
  constant STIMULUS_NTM_MATRIX_ADDER_CASE_1         : boolean := false;
  constant STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1    : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERTER_CASE_1      : boolean := false;
  constant STIMULUS_NTM_MATRIX_DIVIDER_CASE_1       : boolean := false;
  constant STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1 : boolean := false;
  constant STIMULUS_NTM_MATRIX_ROOT_CASE_1          : boolean := false;
  constant STIMULUS_NTM_MATRIX_LOGARITHM_CASE_1     : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_arithmetic_stimulus is
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
      STIMULUS_NTM_SCALAR_MOD_TEST           : boolean := false;
      STIMULUS_NTM_SCALAR_ADDER_TEST         : boolean := false;
      STIMULUS_NTM_SCALAR_MULTIPLIER_TEST    : boolean := false;
      STIMULUS_NTM_SCALAR_INVERTER_TEST      : boolean := false;
      STIMULUS_NTM_SCALAR_DIVIDER_TEST       : boolean := false;
      STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST : boolean := false;
      STIMULUS_NTM_SCALAR_ROOT_TEST          : boolean := false;
      STIMULUS_NTM_SCALAR_LOGARITHM_TEST     : boolean := false;

      STIMULUS_NTM_SCALAR_MOD_CASE_0           : boolean := false;
      STIMULUS_NTM_SCALAR_ADDER_CASE_0         : boolean := false;
      STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0    : boolean := false;
      STIMULUS_NTM_SCALAR_INVERTER_CASE_0      : boolean := false;
      STIMULUS_NTM_SCALAR_DIVIDER_CASE_0       : boolean := false;
      STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0 : boolean := false;
      STIMULUS_NTM_SCALAR_ROOT_CASE_0          : boolean := false;
      STIMULUS_NTM_SCALAR_LOGARITHM_CASE_0     : boolean := false;

      STIMULUS_NTM_SCALAR_MOD_CASE_1           : boolean := false;
      STIMULUS_NTM_SCALAR_ADDER_CASE_1         : boolean := false;
      STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1    : boolean := false;
      STIMULUS_NTM_SCALAR_INVERTER_CASE_1      : boolean := false;
      STIMULUS_NTM_SCALAR_DIVIDER_CASE_1       : boolean := false;
      STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1 : boolean := false;
      STIMULUS_NTM_SCALAR_ROOT_CASE_1          : boolean := false;
      STIMULUS_NTM_SCALAR_LOGARITHM_CASE_1     : boolean := false;

      -- VECTOR-FUNCTIONALITY
      STIMULUS_NTM_VECTOR_MOD_TEST           : boolean := false;
      STIMULUS_NTM_VECTOR_ADDER_TEST         : boolean := false;
      STIMULUS_NTM_VECTOR_MULTIPLIER_TEST    : boolean := false;
      STIMULUS_NTM_VECTOR_INVERTER_TEST      : boolean := false;
      STIMULUS_NTM_VECTOR_DIVIDER_TEST       : boolean := false;
      STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST : boolean := false;
      STIMULUS_NTM_VECTOR_ROOT_TEST          : boolean := false;
      STIMULUS_NTM_VECTOR_LOGARITHM_TEST     : boolean := false;

      STIMULUS_NTM_VECTOR_MOD_CASE_0           : boolean := false;
      STIMULUS_NTM_VECTOR_ADDER_CASE_0         : boolean := false;
      STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0    : boolean := false;
      STIMULUS_NTM_VECTOR_INVERTER_CASE_0      : boolean := false;
      STIMULUS_NTM_VECTOR_DIVIDER_CASE_0       : boolean := false;
      STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0 : boolean := false;
      STIMULUS_NTM_VECTOR_ROOT_CASE_0          : boolean := false;
      STIMULUS_NTM_VECTOR_LOGARITHM_CASE_0     : boolean := false;

      STIMULUS_NTM_VECTOR_MOD_CASE_1           : boolean := false;
      STIMULUS_NTM_VECTOR_ADDER_CASE_1         : boolean := false;
      STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1    : boolean := false;
      STIMULUS_NTM_VECTOR_INVERTER_CASE_1      : boolean := false;
      STIMULUS_NTM_VECTOR_DIVIDER_CASE_1       : boolean := false;
      STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1 : boolean := false;
      STIMULUS_NTM_VECTOR_ROOT_CASE_1          : boolean := false;
      STIMULUS_NTM_VECTOR_LOGARITHM_CASE_1     : boolean := false;

      -- MATRIX-FUNCTIONALITY
      STIMULUS_NTM_MATRIX_MOD_TEST           : boolean := false;
      STIMULUS_NTM_MATRIX_ADDER_TEST         : boolean := false;
      STIMULUS_NTM_MATRIX_MULTIPLIER_TEST    : boolean := false;
      STIMULUS_NTM_MATRIX_INVERTER_TEST      : boolean := false;
      STIMULUS_NTM_MATRIX_DIVIDER_TEST       : boolean := false;
      STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST : boolean := false;
      STIMULUS_NTM_MATRIX_ROOT_TEST          : boolean := false;
      STIMULUS_NTM_MATRIX_LOGARITHM_TEST     : boolean := false;

      STIMULUS_NTM_MATRIX_MOD_CASE_0           : boolean := false;
      STIMULUS_NTM_MATRIX_ADDER_CASE_0         : boolean := false;
      STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0    : boolean := false;
      STIMULUS_NTM_MATRIX_INVERTER_CASE_0      : boolean := false;
      STIMULUS_NTM_MATRIX_DIVIDER_CASE_0       : boolean := false;
      STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0 : boolean := false;
      STIMULUS_NTM_MATRIX_ROOT_CASE_0          : boolean := false;
      STIMULUS_NTM_MATRIX_LOGARITHM_CASE_0     : boolean := false;

      STIMULUS_NTM_MATRIX_MOD_CASE_1           : boolean := false;
      STIMULUS_NTM_MATRIX_ADDER_CASE_1         : boolean := false;
      STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1    : boolean := false;
      STIMULUS_NTM_MATRIX_INVERTER_CASE_1      : boolean := false;
      STIMULUS_NTM_MATRIX_DIVIDER_CASE_1       : boolean := false;
      STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1 : boolean := false;
      STIMULUS_NTM_MATRIX_ROOT_CASE_1          : boolean := false;
      STIMULUS_NTM_MATRIX_LOGARITHM_CASE_1     : boolean := false
      );
    port (
      -- GLOBAL
      CLK : out std_logic;
      RST : out std_logic;

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR
      -----------------------------------------------------------------------

      -- SCALAR MOD
      -- CONTROL
      SCALAR_MOD_START : out std_logic;
      SCALAR_MOD_READY : in  std_logic;

      -- DATA
      SCALAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_ADDER_START : out std_logic;
      SCALAR_ADDER_READY : in  std_logic;

      SCALAR_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_MULTIPLIER_START : out std_logic;
      SCALAR_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR INVERTER
      -- CONTROL
      SCALAR_INVERTER_START : out std_logic;
      SCALAR_INVERTER_READY : in  std_logic;

      -- DATA
      SCALAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR DIVIDER
      -- CONTROL
      SCALAR_DIVIDER_START : out std_logic;
      SCALAR_DIVIDER_READY : in  std_logic;

      -- DATA
      SCALAR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR EXPONENTIATOR
      -- CONTROL
      SCALAR_EXPONENTIATOR_START : out std_logic;
      SCALAR_EXPONENTIATOR_READY : in  std_logic;

      -- DATA
      SCALAR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR ROOT
      -- CONTROL
      SCALAR_ROOT_START : out std_logic;
      SCALAR_ROOT_READY : in  std_logic;

      -- DATA
      SCALAR_ROOT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ROOT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ROOT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_ROOT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR LOGARITHM
      -- CONTROL
      SCALAR_LOGARITHM_START : out std_logic;
      SCALAR_LOGARITHM_READY : in  std_logic;

      -- DATA
      SCALAR_LOGARITHM_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGARITHM_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGARITHM_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_LOGARITHM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- VECTOR MOD
      -- CONTROL
      VECTOR_MOD_START : out std_logic;
      VECTOR_MOD_READY : in  std_logic;

      VECTOR_MOD_DATA_IN_ENABLE : out std_logic;

      VECTOR_MOD_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MOD_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_ADDER_START : out std_logic;
      VECTOR_ADDER_READY : in  std_logic;

      VECTOR_ADDER_OPERATION : out std_logic;

      VECTOR_ADDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_ADDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_ADDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ADDER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
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
      VECTOR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR INVERTER
      -- CONTROL
      VECTOR_INVERTER_START : out std_logic;
      VECTOR_INVERTER_READY : in  std_logic;

      VECTOR_INVERTER_DATA_IN_ENABLE : out std_logic;

      VECTOR_INVERTER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INVERTER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR DIVIDER
      -- CONTROL
      VECTOR_DIVIDER_START : out std_logic;
      VECTOR_DIVIDER_READY : in  std_logic;

      VECTOR_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_DIVIDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_DIVIDER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR EXPONENTIATOR
      -- CONTROL
      VECTOR_EXPONENTIATOR_START : out std_logic;
      VECTOR_EXPONENTIATOR_READY : in  std_logic;

      VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_EXPONENTIATOR_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR ROOT
      -- CONTROL
      VECTOR_ROOT_START : out std_logic;
      VECTOR_ROOT_READY : in  std_logic;

      VECTOR_ROOT_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_ROOT_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_ROOT_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_ROOT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ROOT_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ROOT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ROOT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_ROOT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR LOGARITHM
      -- CONTROL
      VECTOR_LOGARITHM_START : out std_logic;
      VECTOR_LOGARITHM_READY : in  std_logic;

      VECTOR_LOGARITHM_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_LOGARITHM_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_LOGARITHM_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_LOGARITHM_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGARITHM_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGARITHM_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGARITHM_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_LOGARITHM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX
      -----------------------------------------------------------------------

      -- MATRIX MOD
      -- CONTROL
      MATRIX_MOD_START : out std_logic;
      MATRIX_MOD_READY : in  std_logic;

      MATRIX_MOD_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_MOD_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_MOD_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MOD_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MOD_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MOD_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

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
      MATRIX_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ADDER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ADDER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
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
      MATRIX_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX INVERTER
      -- CONTROL
      MATRIX_INVERTER_START : out std_logic;
      MATRIX_INVERTER_READY : in  std_logic;

      MATRIX_INVERTER_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_INVERTER_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_INVERTER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INVERTER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERTER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERTER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

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
      MATRIX_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX EXPONENTIATOR
      -- CONTROL
      MATRIX_EXPONENTIATOR_START : out std_logic;
      MATRIX_EXPONENTIATOR_READY : in  std_logic;

      MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_EXPONENTIATOR_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_EXPONENTIATOR_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX ROOT
      -- CONTROL
      MATRIX_ROOT_START : out std_logic;
      MATRIX_ROOT_READY : in  std_logic;

      MATRIX_ROOT_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_ROOT_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_ROOT_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_ROOT_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_ROOT_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_ROOT_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_ROOT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ROOT_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ROOT_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ROOT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ROOT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_ROOT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX LOGARITHM
      -- CONTROL
      MATRIX_LOGARITHM_START : out std_logic;
      MATRIX_LOGARITHM_READY : in  std_logic;

      MATRIX_LOGARITHM_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_LOGARITHM_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_LOGARITHM_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_LOGARITHM_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_LOGARITHM_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_LOGARITHM_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_LOGARITHM_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGARITHM_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGARITHM_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGARITHM_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGARITHM_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_LOGARITHM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_arithmetic_pkg;