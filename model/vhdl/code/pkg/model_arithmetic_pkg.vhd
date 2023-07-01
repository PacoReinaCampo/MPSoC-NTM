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

use ieee.math_real.all;
use ieee.fixed_pkg.all;
use ieee.float_pkg.all;

package model_arithmetic_pkg is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant DATA_SIZE    : integer := 64;
  constant CONTROL_SIZE : integer := 64;

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_UDATA  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_UDATA   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_UDATA   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_UDATA : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));
  constant FOUR_UDATA  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(4, DATA_SIZE));
  constant FIVE_UDATA  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(5, DATA_SIZE));

  constant ZERO_SDATA  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
  constant ONE_SDATA   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_signed(1, DATA_SIZE));
  constant TWO_SDATA   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_signed(2, DATA_SIZE));
  constant THREE_SDATA : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_signed(3, DATA_SIZE));
  constant FOUR_SDATA  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_signed(4, DATA_SIZE));
  constant FIVE_SDATA  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_signed(5, DATA_SIZE));

  constant ZERO_REAL  : real := 0.0;
  constant ONE_REAL   : real := 1.0;
  constant TWO_REAL   : real := 2.0;
  constant THREE_REAL : real := 3.0;
  constant FOUR_REAL  : real := 4.0;
  constant FIVE_REAL  : real := 5.0;

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(ZERO_REAL, float64'high, -float64'low));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(ONE_REAL, float64'high, -float64'low));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(TWO_REAL, float64'high, -float64'low));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(THREE_REAL, float64'high, -float64'low));
  constant FOUR_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(FOUR_REAL, float64'high, -float64'low));
  constant FIVE_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(FIVE_REAL, float64'high, -float64'low));

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Buffer
  type vector_buffer is array (CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type tensor_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- ARITHMETIC - INTEGER
  ------------------------------------------------------------------------------

  -- SCALAR
  component model_scalar_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_scalar_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT      : out std_logic_vector(DATA_SIZE-1 downto 0);
      REMAINDER_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- VECTOR
  component model_vector_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_vector_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
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
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT      : out std_logic_vector(DATA_SIZE-1 downto 0);
      REMAINDER_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- MATRIX
  component model_matrix_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_matrix_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT      : out std_logic_vector(DATA_SIZE-1 downto 0);
      REMAINDER_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- TENSOR
  component model_tensor_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_tensor_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT      : out std_logic_vector(DATA_SIZE-1 downto 0);
      REMAINDER_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- ARITHMETIC - FLOAT
  ------------------------------------------------------------------------------

  -- SCALAR
  component model_scalar_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_scalar_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_scalar_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  -- VECTOR
  component model_vector_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_vector_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_vector_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
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
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  -- MATRIX
  component model_matrix_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_matrix_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_matrix_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  -- TENSOR
  component model_tensor_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_tensor_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_tensor_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  ------------------------------------------------------------------------------
  -- ARITHMETIC - FIXED
  ------------------------------------------------------------------------------

  -- SCALAR
  component model_scalar_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_scalar_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_scalar_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  -- VECTOR
  component model_vector_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_vector_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_vector_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
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
      SIZE_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  -- MATRIX
  component model_matrix_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_matrix_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_matrix_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  -- TENSOR
  component model_tensor_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      OPERATION : in std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_tensor_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  component model_tensor_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
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

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      OVERFLOW_OUT : out std_logic
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- ARITHMETIC - INTEGER
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_integer_adder (
    OPERATION : std_logic;

    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_scalar_integer_multiplier (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_scalar_integer_divider (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  -- VECTOR
  function function_vector_integer_adder (
    OPERATION : std_logic;

    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_vector_integer_multiplier (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_vector_integer_divider (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  -- MATRIX
  function function_matrix_integer_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_integer_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_integer_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  -- TENSOR
  function function_tensor_integer_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_integer_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_integer_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- ARITHMETIC - FLOAT
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_float_adder (
    OPERATION : std_logic;

    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_scalar_float_multiplier (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_scalar_float_divider (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  -- VECTOR
  function function_vector_float_adder (
    OPERATION : std_logic;

    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_vector_float_multiplier (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_vector_float_divider (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  -- MATRIX
  function function_matrix_float_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_float_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_float_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  -- TENSOR
  function function_tensor_float_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_float_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_float_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- ARITHMETIC - FIXED
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_fixed_adder (
    OPERATION : std_logic;

    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_scalar_fixed_multiplier (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_scalar_fixed_divider (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  -- VECTOR
  function function_vector_fixed_adder (
    OPERATION : std_logic;

    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_vector_fixed_multiplier (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_vector_fixed_divider (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  -- MATRIX
  function function_matrix_fixed_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_fixed_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_fixed_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  -- TENSOR
  function function_tensor_fixed_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_fixed_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_fixed_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- MATH - SERIES
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_cosh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_exponentiator (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_sqrt (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_power (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_logarithm (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_sinh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_tanh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  -- VECTOR
  function function_vector_cosh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_exponentiator (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_sqrt (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_power (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer;

  function function_vector_logarithm (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_sinh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_tanh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  -- MATRIX
  function function_matrix_cosh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_exponentiator (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_sqrt (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_power (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_logarithm (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_sinh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_tanh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

end model_arithmetic_pkg;

package body model_arithmetic_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- ARITHMETIC - INTEGER
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_integer_adder (
    OPERATION : std_logic;

    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    if (OPERATION = '1') then
      scalar_output := std_logic_vector(signed(scalar_a_input) - signed(scalar_b_input));
    else
      scalar_output := std_logic_vector(signed(scalar_a_input) + signed(scalar_b_input));
    end if;

    return scalar_output;
  end function function_scalar_integer_adder;

  function function_scalar_integer_multiplier (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(resize(signed(scalar_a_input), DATA_SIZE/2)*resize(signed(scalar_b_input), DATA_SIZE/2));

    return scalar_output;
  end function function_scalar_integer_multiplier;

  function function_scalar_integer_divider (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(signed(scalar_a_input)/signed(scalar_b_input));

    return scalar_output;
  end function function_scalar_integer_divider;

  -- VECTOR
  function function_vector_integer_adder (
    OPERATION : std_logic;

    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      if (OPERATION = '1') then
        vector_output(i) := std_logic_vector(signed(vector_a_input(i)) - signed(vector_b_input(i)));
      else
        vector_output(i) := std_logic_vector(signed(vector_a_input(i)) + signed(vector_b_input(i)));
      end if;
    end loop;

    return vector_output;
  end function function_vector_integer_adder;

  function function_vector_integer_multiplier (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(resize(signed(vector_a_input(i)), DATA_SIZE/2)*resize(signed(vector_b_input(i)), DATA_SIZE/2));
    end loop;

    return vector_output;
  end function function_vector_integer_multiplier;

  function function_vector_integer_divider (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(signed(vector_a_input(i))/signed(vector_b_input(i)));
    end loop;

    return vector_output;
  end function function_vector_integer_divider;

  -- MATRIX
  function function_matrix_integer_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        if (OPERATION = '1') then
          matrix_output(i, j) := std_logic_vector(signed(matrix_a_input(i, j)) - signed(matrix_b_input(i, j)));
        else
          matrix_output(i, j) := std_logic_vector(signed(matrix_a_input(i, j)) + signed(matrix_b_input(i, j)));
        end if;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_integer_adder;

  function function_matrix_integer_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(resize(signed(matrix_a_input(i, j)), DATA_SIZE/2)*resize(signed(matrix_b_input(i, j)), DATA_SIZE/2));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_integer_multiplier;

  function function_matrix_integer_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(signed(matrix_a_input(i, j))/signed(matrix_b_input(i, j)));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_integer_divider;

  -- TENSOR
  function function_tensor_integer_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          if (OPERATION = '1') then
            tensor_output(i, j, k) := std_logic_vector(signed(tensor_a_input(i, j, k)) - signed(tensor_b_input(i, j, k)));
          else
            tensor_output(i, j, k) := std_logic_vector(signed(tensor_a_input(i, j, k)) + signed(tensor_b_input(i, j, k)));
          end if;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_integer_adder;

  function function_tensor_integer_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := std_logic_vector(resize(signed(tensor_a_input(i, j, k)), DATA_SIZE/2)*resize(signed(tensor_b_input(i, j, k)), DATA_SIZE/2));
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_integer_multiplier;

  function function_tensor_integer_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := std_logic_vector(signed(tensor_a_input(i, j, k))/signed(tensor_b_input(i, j, k)));
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_integer_divider;

  ------------------------------------------------------------------------------
  -- ARITHMETIC - FLOAT
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_float_adder (
    OPERATION : std_logic;

    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    if (OPERATION = '1') then
      scalar_output := std_logic_vector(to_float(to_real(to_float(scalar_a_input, float64'high, -float64'low)) - to_real(to_float(scalar_b_input, float64'high, -float64'low)), float64'high, -float64'low));
    else
      scalar_output := std_logic_vector(to_float(to_real(to_float(scalar_a_input, float64'high, -float64'low)) + to_real(to_float(scalar_b_input, float64'high, -float64'low)), float64'high, -float64'low));
    end if;

    return scalar_output;
  end function function_scalar_float_adder;

  function function_scalar_float_multiplier (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(to_real(to_float(scalar_a_input, float64'high, -float64'low))*to_real(to_float(scalar_b_input, float64'high, -float64'low)), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_float_multiplier;

  function function_scalar_float_divider (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(to_real(to_float(scalar_a_input, float64'high, -float64'low))/to_real(to_float(scalar_b_input, float64'high, -float64'low)), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_float_divider;

  -- VECTOR
  function function_vector_float_adder (
    OPERATION : std_logic;

    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      if (OPERATION = '1') then
        vector_output(i) := std_logic_vector(to_float(to_real(to_float(vector_a_input(i), float64'high, -float64'low)) - to_real(to_float(vector_b_input(i), float64'high, -float64'low)), float64'high, -float64'low));
      else
        vector_output(i) := std_logic_vector(to_float(to_real(to_float(vector_a_input(i), float64'high, -float64'low)) + to_real(to_float(vector_b_input(i), float64'high, -float64'low)), float64'high, -float64'low));
      end if;
    end loop;

    return vector_output;
  end function function_vector_float_adder;

  function function_vector_float_multiplier (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(to_real(to_float(vector_a_input(i), float64'high, -float64'low))*to_real(to_float(vector_b_input(i), float64'high, -float64'low)), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_float_multiplier;

  function function_vector_float_divider (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(to_real(to_float(vector_a_input(i), float64'high, -float64'low))/to_real(to_float(vector_b_input(i), float64'high, -float64'low)), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_float_divider;

  -- MATRIX
  function function_matrix_float_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        if (OPERATION = '1') then
          matrix_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_a_input(i, j), float64'high, -float64'low)) - to_real(to_float(matrix_b_input(i, j), float64'high, -float64'low)), float64'high, -float64'low));
        else
          matrix_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_a_input(i, j), float64'high, -float64'low)) + to_real(to_float(matrix_b_input(i, j), float64'high, -float64'low)), float64'high, -float64'low));
        end if;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_float_adder;

  function function_matrix_float_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_a_input(i, j), float64'high, -float64'low))*to_real(to_float(matrix_b_input(i, j), float64'high, -float64'low)), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_float_multiplier;

  function function_matrix_float_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_a_input(i, j), float64'high, -float64'low))/to_real(to_float(matrix_b_input(i, j), float64'high, -float64'low)), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_float_divider;

  -- TENSOR
  function function_tensor_float_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          if (OPERATION = '1') then
            tensor_output(i, j, k) := std_logic_vector(to_float(to_real(to_float(tensor_a_input(i, j, k), float64'high, -float64'low)) - to_real(to_float(tensor_b_input(i, j, k), float64'high, -float64'low)), float64'high, -float64'low));
          else
            tensor_output(i, j, k) := std_logic_vector(to_float(to_real(to_float(tensor_a_input(i, j, k), float64'high, -float64'low)) + to_real(to_float(tensor_b_input(i, j, k), float64'high, -float64'low)), float64'high, -float64'low));
          end if;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_float_adder;

  function function_tensor_float_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := std_logic_vector(to_float(to_real(to_float(tensor_a_input(i, j, k), float64'high, -float64'low))*to_real(to_float(tensor_b_input(i, j, k), float64'high, -float64'low)), float64'high, -float64'low));
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_float_multiplier;

  function function_tensor_float_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := std_logic_vector(to_float(to_real(to_float(tensor_a_input(i, j, k), float64'high, -float64'low))/to_real(to_float(tensor_b_input(i, j, k), float64'high, -float64'low)), float64'high, -float64'low));
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_float_divider;

  ------------------------------------------------------------------------------
  -- ARITHMETIC - FIXED
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_fixed_adder (
    OPERATION : std_logic;

    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    if (OPERATION = '1') then
      scalar_output := std_logic_vector(to_sfixed(to_real(to_sfixed(scalar_a_input, DATA_SIZE-1, 0)) - to_real(to_sfixed(scalar_b_input, DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
    else
      scalar_output := std_logic_vector(to_sfixed(to_real(to_sfixed(scalar_a_input, DATA_SIZE-1, 0)) + to_real(to_sfixed(scalar_b_input, DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
    end if;

    return scalar_output;
  end function function_scalar_fixed_adder;

  function function_scalar_fixed_multiplier (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_sfixed(to_real(to_sfixed(scalar_a_input, DATA_SIZE-1, 0))*to_real(to_sfixed(scalar_b_input, DATA_SIZE-1, 0)), DATA_SIZE-1, 0));

    return scalar_output;
  end function function_scalar_fixed_multiplier;

  function function_scalar_fixed_divider (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_sfixed(to_real(to_sfixed(scalar_a_input, DATA_SIZE-1, 0))/to_real(to_sfixed(scalar_b_input, DATA_SIZE-1, 0)), DATA_SIZE-1, 0));

    return scalar_output;
  end function function_scalar_fixed_divider;

  -- VECTOR
  function function_vector_fixed_adder (
    OPERATION : std_logic;

    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      if (OPERATION = '1') then
        vector_output(i) := std_logic_vector(to_sfixed(to_real(to_sfixed(vector_a_input(i), DATA_SIZE-1, 0)) - to_real(to_sfixed(vector_b_input(i), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
      else
        vector_output(i) := std_logic_vector(to_sfixed(to_real(to_sfixed(vector_a_input(i), DATA_SIZE-1, 0)) + to_real(to_sfixed(vector_b_input(i), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
      end if;
    end loop;

    return vector_output;
  end function function_vector_fixed_adder;

  function function_vector_fixed_multiplier (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_sfixed(to_real(to_sfixed(vector_a_input(i), DATA_SIZE-1, 0))*to_real(to_sfixed(vector_b_input(i), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
    end loop;

    return vector_output;
  end function function_vector_fixed_multiplier;

  function function_vector_fixed_divider (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_sfixed(to_real(to_sfixed(vector_a_input(i), DATA_SIZE-1, 0))/to_real(to_sfixed(vector_b_input(i), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
    end loop;

    return vector_output;
  end function function_vector_fixed_divider;

  -- MATRIX
  function function_matrix_fixed_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        if (OPERATION = '1') then
          matrix_output(i, j) := std_logic_vector(to_sfixed(to_real(to_sfixed(matrix_a_input(i, j), DATA_SIZE-1, 0)) - to_real(to_sfixed(matrix_b_input(i, j), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
        else
          matrix_output(i, j) := std_logic_vector(to_sfixed(to_real(to_sfixed(matrix_a_input(i, j), DATA_SIZE-1, 0)) + to_real(to_sfixed(matrix_b_input(i, j), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
        end if;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_fixed_adder;

  function function_matrix_fixed_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_sfixed(to_real(to_sfixed(matrix_a_input(i, j), DATA_SIZE-1, 0))*to_real(to_sfixed(matrix_b_input(i, j), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_fixed_multiplier;

  function function_matrix_fixed_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_sfixed(to_real(to_sfixed(matrix_a_input(i, j), DATA_SIZE-1, 0))/to_real(to_sfixed(matrix_b_input(i, j), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_fixed_divider;

  -- TENSOR
  function function_tensor_fixed_adder (
    OPERATION : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          if (OPERATION = '1') then
            tensor_output(i, j, k) := std_logic_vector(to_sfixed(to_real(to_sfixed(tensor_a_input(i, j, k), DATA_SIZE-1, 0)) - to_real(to_sfixed(tensor_b_input(i, j, k), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
          else
            tensor_output(i, j, k) := std_logic_vector(to_sfixed(to_real(to_sfixed(tensor_a_input(i, j, k), DATA_SIZE-1, 0)) + to_real(to_sfixed(tensor_b_input(i, j, k), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
          end if;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_fixed_adder;

  function function_tensor_fixed_multiplier (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := std_logic_vector(to_sfixed(to_real(to_sfixed(tensor_a_input(i, j, k), DATA_SIZE-1, 0))*to_real(to_sfixed(tensor_b_input(i, j, k), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_fixed_multiplier;

  function function_tensor_fixed_divider (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := std_logic_vector(to_sfixed(to_real(to_sfixed(tensor_a_input(i, j, k), DATA_SIZE-1, 0))/to_real(to_sfixed(tensor_b_input(i, j, k), DATA_SIZE-1, 0)), DATA_SIZE-1, 0));
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_fixed_divider;

  ------------------------------------------------------------------------------
  -- MATH - SERIES
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_cosh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(cosh(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_cosh;

  function function_scalar_exponentiator (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(exp(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_exponentiator;

  function function_scalar_sqrt (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(sqrt(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_sqrt;

  function function_scalar_power (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(to_real(to_float(scalar_a_input, float64'high, -float64'low))**to_real(to_float(scalar_b_input, float64'high, -float64'low))));

    return scalar_output;
  end function function_scalar_power;

  function function_scalar_logarithm (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(log(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_logarithm;

  function function_scalar_sinh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(sinh(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_sinh;

  function function_scalar_tanh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(tanh(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_tanh;

  -- VECTOR
  function function_vector_cosh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(cosh(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_cosh;

  function function_vector_exponentiator (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(exp(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_exponentiator;

  function function_vector_sqrt (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(sqrt(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_sqrt;

  function function_vector_power (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(to_real(to_float(vector_a_input(i), float64'high, -float64'low))**to_real(to_float(vector_b_input(i), float64'high, -float64'low))));
    end loop;

    return vector_output;
  end function function_vector_power;

  function function_vector_logarithm (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(log(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_logarithm;

  function function_vector_sinh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(sinh(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_sinh;

  function function_vector_tanh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(tanh(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_tanh;

  -- MATRIX
  function function_matrix_cosh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(cosh(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_cosh;

  function function_matrix_exponentiator (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(exp(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_exponentiator;

  function function_matrix_sqrt (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(sqrt(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_sqrt;

  function function_matrix_power (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer

    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_a_input(i, j), float64'high, -float64'low))**to_real(to_float(matrix_b_input(i, j), float64'high, -float64'low))));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_power;

  function function_matrix_logarithm (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(log(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_logarithm;

  function function_matrix_sinh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(sinh(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_sinh;

  function function_matrix_tanh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(tanh(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_tanh;

end model_arithmetic_pkg;
