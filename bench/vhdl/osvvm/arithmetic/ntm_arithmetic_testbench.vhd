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

entity ntm_arithmetic_testbench is
end ntm_arithmetic_testbench;

architecture ntm_arithmetic_testbench_architecture of ntm_arithmetic_testbench is

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_scalar_mod is
    generic (
      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      MODULO   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_scalar_adder is
    generic (
      DATA_SIZE : integer := 512
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
      MODULO    : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_scalar_multiplier is
    generic (
      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      MODULO    : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_scalar_inverter is
    generic (
      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      MODULO   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_vector_mod is
    generic (
      X : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_vector(X-1 downto 0);

      -- DATA
      MODULO   : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_vector_adder is
    generic (
      X : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_vector(X-1 downto 0);

      OPERATION : in std_logic;

      -- DATA
      MODULO    : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_vector_multiplier is
    generic (
      X : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_vector(X-1 downto 0);

      -- DATA
      MODULO    : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_vector_inverter is
    generic (
      X : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_vector(X-1 downto 0);

      -- DATA
      MODULO   : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_matrix_mod is
    generic (
      X : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_vector(X-1 downto 0);

      -- DATA
      MODULO   : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_matrix_mod is
    generic (
      X : integer := 64,
      Y : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_arithmetic_scalar_matrix(X-1 downto 0)(Y-1 downto 0);

      -- DATA
      MODULO   : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_matrix_adder is
    generic (
      X : integer := 64,
      Y : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_arithmetic_scalar_matrix(X-1 downto 0)(Y-1 downto 0);

      OPERATION : in std_logic;

      -- DATA
      MODULO    : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_matrix_multiplier is
    generic (
      X : integer := 64,
      Y : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_arithmetic_scalar_matrix(X-1 downto 0)(Y-1 downto 0);

      -- DATA
      MODULO    : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component ntm_matrix_inverter is
    generic (
      X : integer := 64,
      Y : integer := 64,

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic_arithmetic_scalar_matrix(X-1 downto 0)(Y-1 downto 0);

      -- DATA
      MODULO   : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant X : integer := 64;
  constant Y : integer := 64;
  constant Z : integer := 64;

  constant DATA_SIZE : integer := 64;

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- CONTROL
  signal START : std_logic;

  -- Scalar
  signal SCALAR_READY : std_logic;

  -- Vector
  signal VECTOR_READY : std_logic_vector(X-1 downto 0);

  -- Matrix
  signal MATRIX_READY : std_logic_arithmetic_scalar_matrix(X-1 downto 0)(Y-1 downto 0);

  -- DATA

  -- Scalar

  -- Vector

  -- Matrix

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- SCALAR
  scalar_inverter : ntm_scalar_inverter
    generic map (
      X => X,
      Y => Y,
      Z => Z,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => START,
      READY => SCALAR_READY,

      -- DATA
      MODULO   => SCALAR_MODULO,
      DATA_IN  => SCALAR_DATA_IN,
      DATA_OUT => SCALAR_DATA_OUT
    );

  -- VECTOR
  vector_inverter : ntm_vector_inverter
    generic map (
      X => X,
      Y => Y,
      Z => Z,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => START,
      READY => VECTOR_READY,

      -- DATA
      MODULO   => VECTOR_MODULO,
      DATA_IN  => VECTOR_DATA_IN,
      DATA_OUT => VECTOR_DATA_OUT
    );

  -- MATRIX
  matrix_inverter : ntm_matrix_inverter
    generic map (
      X => X,
      Y => Y,
      Z => Z,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => START,
      READY => MATRIX_READY,

      -- DATA
      MODULO   => MATRIX_MODULO,
      DATA_IN  => MATRIX_DATA_IN,
      DATA_OUT => MATRIX_DATA_OUT
    );
end ntm_arithmetic_testbench_architecture;
