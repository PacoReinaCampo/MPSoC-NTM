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
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ntm_modular_pkg is

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
  signal STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST           : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST         : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST    : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST      : boolean := false;

  signal STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0           : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0         : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0    : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0      : boolean := false;

  signal STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_1           : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_1         : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1    : boolean := false;
  signal STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_1      : boolean := false;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST           : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST         : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST    : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST      : boolean := false;

  signal STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0           : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0         : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0    : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0      : boolean := false;

  signal STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_1           : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_1         : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1    : boolean := false;
  signal STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_1      : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST           : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST         : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST    : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST      : boolean := false;

  signal STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0           : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0         : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0    : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0      : boolean := false;

  signal STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_1           : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_1         : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1    : boolean := false;
  signal STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_1      : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_NTM_TENSOR_MODULAR_MOD_TEST           : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_ADDER_TEST         : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_MULTIPLIER_TEST    : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_INVERTER_TEST      : boolean := false;

  signal STIMULUS_NTM_TENSOR_MODULAR_MOD_CASE_0           : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_ADDER_CASE_0         : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_MULTIPLIER_CASE_0    : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_INVERTER_CASE_0      : boolean := false;

  signal STIMULUS_NTM_TENSOR_MODULAR_MOD_CASE_1           : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_ADDER_CASE_1         : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_MULTIPLIER_CASE_1    : boolean := false;
  signal STIMULUS_NTM_TENSOR_MODULAR_INVERTER_CASE_1      : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_modular_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64;

      X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
      Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
      N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
      W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
      L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
      R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))   -- i in 0 to R-1
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
      SCALAR_MODULAR_MOD_START : out std_logic;
      SCALAR_MODULAR_MOD_READY : in  std_logic;

      -- DATA
      SCALAR_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_MODULAR_ADDER_START : out std_logic;
      SCALAR_MODULAR_ADDER_READY : in  std_logic;

      SCALAR_MODULAR_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_MODULAR_MULTIPLIER_START : out std_logic;
      SCALAR_MODULAR_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR INVERTER
      -- CONTROL
      SCALAR_MODULAR_INVERTER_START : out std_logic;
      SCALAR_MODULAR_INVERTER_READY : in  std_logic;

      -- DATA
      SCALAR_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- VECTOR MOD
      -- CONTROL
      VECTOR_MODULAR_MOD_START : out std_logic;
      VECTOR_MODULAR_MOD_READY : in  std_logic;

      VECTOR_MODULAR_MOD_DATA_IN_ENABLE : out std_logic;

      VECTOR_MODULAR_MOD_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_MOD_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_MODULAR_ADDER_START : out std_logic;
      VECTOR_MODULAR_ADDER_READY : in  std_logic;

      VECTOR_MODULAR_ADDER_OPERATION : out std_logic;

      VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_ADDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_MODULAR_MULTIPLIER_START : out std_logic;
      VECTOR_MODULAR_MULTIPLIER_READY : in  std_logic;

      VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_MULTIPLIER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR INVERTER
      -- CONTROL
      VECTOR_MODULAR_INVERTER_START : out std_logic;
      VECTOR_MODULAR_INVERTER_READY : in  std_logic;

      VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE : out std_logic;

      VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_INVERTER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX
      -----------------------------------------------------------------------

      -- MATRIX MOD
      -- CONTROL
      MATRIX_MODULAR_MOD_START : out std_logic;
      MATRIX_MODULAR_MOD_READY : in  std_logic;

      MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_MOD_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_MOD_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_MODULAR_ADDER_START : out std_logic;
      MATRIX_MODULAR_ADDER_READY : in  std_logic;

      MATRIX_MODULAR_ADDER_OPERATION : out std_logic;

      MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_MODULAR_MULTIPLIER_START : out std_logic;
      MATRIX_MODULAR_MULTIPLIER_READY : in  std_logic;

      MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX INVERTER
      -- CONTROL
      MATRIX_MODULAR_INVERTER_START : out std_logic;
      MATRIX_MODULAR_INVERTER_READY : in  std_logic;

      MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_INVERTER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_INVERTER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -----------------------------------------------------------------------
      -- STIMULUS TENSOR
      -----------------------------------------------------------------------

      -- TENSOR MOD
      -- CONTROL
      TENSOR_MODULAR_MOD_START : out std_logic;
      TENSOR_MODULAR_MOD_READY : in  std_logic;

      TENSOR_MODULAR_MOD_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_MODULAR_MOD_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_MODULAR_MOD_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_MODULAR_MOD_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_MODULAR_MOD_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_MODULAR_MOD_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_MOD_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_MOD_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_MOD_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_MODULAR_ADDER_START : out std_logic;
      TENSOR_MODULAR_ADDER_READY : in  std_logic;

      TENSOR_MODULAR_ADDER_OPERATION : out std_logic;

      TENSOR_MODULAR_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_MODULAR_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_MODULAR_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_MODULAR_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_MODULAR_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_MODULAR_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_MODULAR_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_MODULAR_ADDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_MODULAR_ADDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_MODULAR_MULTIPLIER_START : out std_logic;
      TENSOR_MODULAR_MULTIPLIER_READY : in  std_logic;

      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_MODULAR_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR INVERTER
      -- CONTROL
      TENSOR_MODULAR_INVERTER_START : out std_logic;
      TENSOR_MODULAR_INVERTER_READY : in  std_logic;

      TENSOR_MODULAR_INVERTER_DATA_IN_I_ENABLE : out std_logic;
      TENSOR_MODULAR_INVERTER_DATA_IN_J_ENABLE : out std_logic;
      TENSOR_MODULAR_INVERTER_DATA_IN_K_ENABLE : out std_logic;

      TENSOR_MODULAR_INVERTER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_MODULAR_INVERTER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_MODULAR_INVERTER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_INVERTER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_INVERTER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_INVERTER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_modular_pkg;
