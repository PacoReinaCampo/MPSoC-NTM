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

use work.accelerator_arithmetic_vhdl_pkg.all;

package accelerator_integer_pkg is

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

  -- Seeds
  constant TENSOR_SAMPLE_A_SEED1 : integer := 1;
  constant TENSOR_SAMPLE_A_SEED2 : integer := 2;

  constant TENSOR_SAMPLE_B_SEED1 : integer := 3;
  constant TENSOR_SAMPLE_B_SEED2 : integer := 4;

  constant MATRIX_SAMPLE_A_SEED1 : integer := 5;
  constant MATRIX_SAMPLE_A_SEED2 : integer := 6;

  constant MATRIX_SAMPLE_B_SEED1 : integer := 7;
  constant MATRIX_SAMPLE_B_SEED2 : integer := 8;

  constant VECTOR_SAMPLE_A_SEED1 : integer := 9;
  constant VECTOR_SAMPLE_A_SEED2 : integer := 10;

  constant VECTOR_SAMPLE_B_SEED1 : integer := 11;
  constant VECTOR_SAMPLE_B_SEED2 : integer := 12;

  constant SCALAR_SAMPLE_A_SEED1 : integer := 13;
  constant SCALAR_SAMPLE_A_SEED2 : integer := 14;

  constant SCALAR_SAMPLE_B_SEED1 : integer := 15;
  constant SCALAR_SAMPLE_B_SEED2 : integer := 16;

  -- Integer Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := tensor_randomness_generation(CONTROL_SIZE, CONTROL_SIZE, CONTROL_SIZE, TENSOR_SAMPLE_A_SEED1, TENSOR_SAMPLE_A_SEED2);
  constant TENSOR_SAMPLE_B : tensor_buffer := tensor_randomness_generation(CONTROL_SIZE, CONTROL_SIZE, CONTROL_SIZE, TENSOR_SAMPLE_A_SEED1, TENSOR_SAMPLE_A_SEED2);

  constant MATRIX_SAMPLE_A : matrix_buffer := matrix_randomness_generation(CONTROL_SIZE, CONTROL_SIZE, MATRIX_SAMPLE_A_SEED1, MATRIX_SAMPLE_A_SEED2);
  constant MATRIX_SAMPLE_B : matrix_buffer := matrix_randomness_generation(CONTROL_SIZE, CONTROL_SIZE, MATRIX_SAMPLE_A_SEED1, MATRIX_SAMPLE_A_SEED2);

  constant VECTOR_SAMPLE_A : vector_buffer := vector_randomness_generation(CONTROL_SIZE, VECTOR_SAMPLE_A_SEED1, VECTOR_SAMPLE_A_SEED2);
  constant VECTOR_SAMPLE_B : vector_buffer := vector_randomness_generation(CONTROL_SIZE, VECTOR_SAMPLE_B_SEED1, VECTOR_SAMPLE_B_SEED2);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := scalar_randomness_generation(SCALAR_SAMPLE_A_SEED1, SCALAR_SAMPLE_A_SEED2);
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := scalar_randomness_generation(SCALAR_SAMPLE_B_SEED1, SCALAR_SAMPLE_B_SEED2);

  -- SCALAR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_1    : boolean := false;

  -- VECTOR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_1    : boolean := false;

  -- MATRIX-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_1    : boolean := false;

  -- TENSOR-FUNCTIONALITY
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_ADDER_TEST      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_TEST : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_DIVIDER_TEST    : boolean := false;

  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_ADDER_CASE_0      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_DIVIDER_CASE_0    : boolean := false;

  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_ADDER_CASE_1      : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
  signal STIMULUS_ACCELERATOR_TENSOR_INTEGER_DIVIDER_CASE_1    : boolean := false;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component accelerator_integer_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE    : integer := 128;
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
      -- STIMULUS INTEGER SCALAR
      ------------------------------------------------------------------------------

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_INTEGER_ADDER_START : out std_logic;
      SCALAR_INTEGER_ADDER_READY : in  std_logic;

      SCALAR_INTEGER_ADDER_OPERATION : out std_logic;

      -- DATA
      SCALAR_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      SCALAR_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_INTEGER_MULTIPLIER_START : out std_logic;
      SCALAR_INTEGER_MULTIPLIER_READY : in  std_logic;

      -- DATA
      SCALAR_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      SCALAR_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR DIVIDER
      -- CONTROL
      SCALAR_INTEGER_DIVIDER_START : out std_logic;
      SCALAR_INTEGER_DIVIDER_READY : in  std_logic;

      -- DATA
      SCALAR_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      SCALAR_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      ------------------------------------------------------------------------------
      -- STIMULUS INTEGER VECTOR
      ------------------------------------------------------------------------------

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_INTEGER_ADDER_START : out std_logic;
      VECTOR_INTEGER_ADDER_READY : in  std_logic;

      VECTOR_INTEGER_ADDER_OPERATION : out std_logic;

      VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_INTEGER_ADDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      VECTOR_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_INTEGER_MULTIPLIER_START : out std_logic;
      VECTOR_INTEGER_MULTIPLIER_READY : in  std_logic;

      VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_INTEGER_MULTIPLIER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      VECTOR_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR DIVIDER
      -- CONTROL
      VECTOR_INTEGER_DIVIDER_START : out std_logic;
      VECTOR_INTEGER_DIVIDER_READY : in  std_logic;

      VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_INTEGER_DIVIDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      VECTOR_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      VECTOR_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      ------------------------------------------------------------------------------
      -- STIMULUS INTEGER MATRIX
      ------------------------------------------------------------------------------

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_INTEGER_ADDER_START : out std_logic;
      MATRIX_INTEGER_ADDER_READY : in  std_logic;

      MATRIX_INTEGER_ADDER_OPERATION : out std_logic;

      MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INTEGER_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INTEGER_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      MATRIX_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_INTEGER_MULTIPLIER_START : out std_logic;
      MATRIX_INTEGER_MULTIPLIER_READY : in  std_logic;

      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      MATRIX_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX DIVIDER
      -- CONTROL
      MATRIX_INTEGER_DIVIDER_START : out std_logic;
      MATRIX_INTEGER_DIVIDER_READY : in  std_logic;

      MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INTEGER_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INTEGER_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      MATRIX_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      MATRIX_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      ------------------------------------------------------------------------------
      -- STIMULUS INTEGER TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_INTEGER_ADDER_START : out std_logic;
      TENSOR_INTEGER_ADDER_READY : in  std_logic;

      TENSOR_INTEGER_ADDER_OPERATION : out std_logic;

      TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_INTEGER_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_INTEGER_MULTIPLIER_START : out std_logic;
      TENSOR_INTEGER_MULTIPLIER_READY : in  std_logic;

      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      -- TENSOR DIVIDER
      -- CONTROL
      TENSOR_INTEGER_DIVIDER_START : out std_logic;
      TENSOR_INTEGER_DIVIDER_READY : in  std_logic;

      TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE : out std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE : out std_logic;

      TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;
      TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE : in std_logic;

      -- DATA
      TENSOR_INTEGER_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_DIVIDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      TENSOR_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      TENSOR_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
      TENSOR_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

end accelerator_integer_pkg;
