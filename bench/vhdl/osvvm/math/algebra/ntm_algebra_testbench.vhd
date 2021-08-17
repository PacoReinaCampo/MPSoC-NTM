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

use work.ntm_pkg.all;

entity ntm_arithmetic_testbench is
end ntm_arithmetic_testbench;

architecture ntm_arithmetic_testbench_architecture of ntm_arithmetic_testbench is

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

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- INVERTER
  -- CONTROL
  signal start_scalar_inverter : std_logic;
  signal ready_scalar_inverter : std_logic;

  -- DATA
  signal modulo_scalar_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_inverter : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  -- DATA
  signal modulo_vector_adder    : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

  -- INVERTER
  -- CONTROL
  signal start_vector_inverter : std_logic;
  signal ready_vector_inverter : std_logic;

  -- DATA
  signal modulo_vector_inverter   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_in_vector_inverter  : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_inverter : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- INVERTER
  -- CONTROL
  signal start_matrix_inverter : std_logic;
  signal ready_matrix_inverter : std_logic;

  -- DATA
  signal modulo_matrix_inverter   : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_in_matrix_inverter  : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inverter : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- SCALAR
  scalar_inverter : ntm_scalar_inverter
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_inverter,
      READY => ready_vector_adder,

      -- DATA
      MODULO   => modulo_scalar_inverter,
      DATA_IN  => data_in_scalar_inverter,
      DATA_OUT => data_out_scalar_inverter
    );

  -- VECTOR
  vector_inverter : ntm_vector_inverter
    generic map (
      X => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_inverter,
      READY => ready_vector_inverter,

      -- DATA
      MODULO   => modulo_vector_inverter,
      DATA_IN  => data_in_vector_inverter,
      DATA_OUT => data_out_vector_inverter
    );

  -- MATRIX
  matrix_inverter : ntm_matrix_inverter
    generic map (
      X => X,
      Y => Y,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_inverter,
      READY => ready_matrix_inverter,

      -- DATA
      MODULO   => modulo_matrix_inverter,
      DATA_IN  => data_in_matrix_inverter,
      DATA_OUT => data_out_matrix_inverter
    );
end ntm_arithmetic_testbench_architecture;