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

package accelerator_arithmetic_vhdl_pkg is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant DATA_SIZE    : integer := 64;
  constant CONTROL_SIZE : integer := 4;

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));
  constant FOUR_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(4, CONTROL_SIZE));
  constant FIVE_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(5, CONTROL_SIZE));

  constant ZERO_UDATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_UDATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_UDATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_UDATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));
  constant FOUR_UDATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(4, DATA_SIZE));
  constant FIVE_UDATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(5, DATA_SIZE));

  constant ZERO_SDATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
  constant ONE_SDATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(1, DATA_SIZE));
  constant TWO_SDATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(2, DATA_SIZE));
  constant THREE_SDATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(3, DATA_SIZE));
  constant FOUR_SDATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(4, DATA_SIZE));
  constant FIVE_SDATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(5, DATA_SIZE));

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
  component accelerator_scalar_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_scalar_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_scalar_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_vector_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_vector_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_vector_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_matrix_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_matrix_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_matrix_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_tensor_integer_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_tensor_integer_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_tensor_integer_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_scalar_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_scalar_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_scalar_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_vector_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_vector_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_vector_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_matrix_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_matrix_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_matrix_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_tensor_float_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_tensor_float_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_tensor_float_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_scalar_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_scalar_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_scalar_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_vector_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_vector_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_vector_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_matrix_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_matrix_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_matrix_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  component accelerator_tensor_fixed_adder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_tensor_fixed_multiplier is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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

  component accelerator_tensor_fixed_divider is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
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
  -- MATH - RANDOM
  ------------------------------------------------------------------------------

  -- SCALAR
  function scalar_randomness_generation (
    seed1_in : integer;
    seed2_in : integer
    ) return std_logic_vector;

  -- VECTOR
  function vector_randomness_generation (
    DATA_L_IN : integer;

    seed1_in : integer;
    seed2_in : integer
    ) return vector_buffer;

  -- MATRIX
  function matrix_randomness_generation (
    DATA_I_IN : integer;
    DATA_J_IN : integer;

    seed1_in : integer;
    seed2_in : integer
    ) return matrix_buffer;

  -- TENSOR
  function tensor_randomness_generation (
    DATA_I_IN : integer;
    DATA_J_IN : integer;
    DATA_K_IN : integer;

    seed1_in : integer;
    seed2_in : integer
    ) return tensor_buffer;

end accelerator_arithmetic_vhdl_pkg;

package body accelerator_arithmetic_vhdl_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- MATH - RANDOM
  ------------------------------------------------------------------------------

  -- SCALAR
  function scalar_randomness_generation (
    seed1_in : integer;
    seed2_in : integer
    ) return std_logic_vector is

    variable seed1 : integer;
    variable seed2 : integer;

    variable r : real;

    variable random_sample : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    seed1 := seed1_in;
    seed2 := seed2_in;

    -- randomness generation
    for m in 0 to DATA_SIZE-1 loop
      uniform(seed1, seed2, r);

      random_sample(m) := '1' when r > 0.5 else '0';
    end loop;

    return random_sample;
  end function scalar_randomness_generation;

  -- VECTOR
  function vector_randomness_generation (
    DATA_L_IN : integer;

    seed1_in : integer;
    seed2_in : integer
    ) return vector_buffer is

    variable seed1 : integer;
    variable seed2 : integer;

    variable r : real;

    variable random_sample : vector_buffer;

  begin

    seed1 := seed1_in;
    seed2 := seed2_in;

    -- randomness generation
    for l in 0 to DATA_L_IN-1 loop
      for m in 0 to DATA_SIZE-1 loop
        uniform(seed1, seed2, r);

        random_sample(l)(m) := '1' when r > 0.5 else '0';
      end loop;
    end loop;

    return random_sample;
  end function vector_randomness_generation;

  -- MATRIX
  function matrix_randomness_generation (
    DATA_I_IN : integer;
    DATA_J_IN : integer;

    seed1_in : integer;
    seed2_in : integer
    ) return matrix_buffer is

    variable seed1 : integer;
    variable seed2 : integer;

    variable r : real;

    variable random_sample : matrix_buffer;

  begin

    seed1 := seed1_in;
    seed2 := seed2_in;

    -- randomness generation
    for i in 0 to DATA_I_IN-1 loop
      for j in 0 to DATA_J_IN-1 loop
        for m in 0 to DATA_SIZE-1 loop
          uniform(seed1, seed2, r);

          random_sample(i, j)(m) := '1' when r > 0.5 else '0';
        end loop;
      end loop;
    end loop;

    return random_sample;
  end function matrix_randomness_generation;

  -- TENSOR
  function tensor_randomness_generation (
    DATA_I_IN : integer;
    DATA_J_IN : integer;
    DATA_K_IN : integer;

    seed1_in : integer;
    seed2_in : integer
    ) return tensor_buffer is

    variable seed1 : integer;
    variable seed2 : integer;

    variable r : real;

    variable random_sample : tensor_buffer;

  begin

    seed1 := seed1_in;
    seed2 := seed2_in;

    -- randomness generation
    for i in 0 to DATA_I_IN-1 loop
      for j in 0 to DATA_J_IN-1 loop
        for k in 0 to DATA_K_IN-1 loop
          for m in 0 to DATA_SIZE-1 loop
            uniform(seed1, seed2, r);

            random_sample(i, j, k)(m) := '1' when r > 0.5 else '0';
          end loop;
        end loop;
      end loop;
    end loop;

    return random_sample;
  end function tensor_randomness_generation;

end accelerator_arithmetic_vhdl_pkg;
