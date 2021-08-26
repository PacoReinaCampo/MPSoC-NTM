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

use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;

entity dnc_write_heads_testbench is
end dnc_write_heads_testbench;

architecture dnc_write_heads_testbench_architecture of dnc_write_heads_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- ALLOCATION GATE
  -- CONTROL
  signal start_allocation_gate : std_logic;
  signal ready_allocation_gate : std_logic;

  -- DATA
  signal ga_in_allocation_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_allocation_gate : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_allocation_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASE VECTOR
  -- CONTROL
  signal start_erase_vector : std_logic;
  signal ready_erase_vector : std_logic;

  -- DATA
  signal e_in_erase_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_erase_vector : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal e_out_erase_vector  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WRITE GATE
  -- CONTROL
  signal start_write_gate : std_logic;
  signal ready_write_gate : std_logic;

  -- DATA
  signal gw_in_write_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_write_gate : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE KEY
  -- CONTROL
  signal start_write_key : std_logic;
  signal ready_write_key : std_logic;

  -- DATA
  signal k_in_write_key   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_write_key : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_out_write_key  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WRITE STRENGHT
  -- CONTROL
  signal start_write_strength : std_logic;
  signal ready_write_strength : std_logic;

  -- DATA
  signal beta_in_write_strength  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_write_strength   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_strength : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE VECTOR
  -- CONTROL
  signal start_write_vector : std_logic;
  signal ready_write_vector : std_logic;

  -- DATA
  signal v_in_write_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_write_vector : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_out_write_vector  : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- ALLOCATION GATE
  allocation_gate : dnc_allocation_gate
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_allocation_gate,
      READY => ready_allocation_gate,

      -- DATA
      GA_IN => ga_in_allocation_gate,

      MODULO => modulo_allocation_gate,
      GA_OUT => ga_out_allocation_gate
    );

  -- ERASE VECTOR
  erase_vector : dnc_erase_vector
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erase_vector,
      READY => ready_erase_vector,

      -- DATA
      E_IN => e_in_erase_vector,

      MODULO => modulo_erase_vector,
      E_OUT  => e_out_erase_vector
    );

  -- WRITE GATE
  write_gate : dnc_write_gate
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_gate,
      READY => ready_write_gate,

      -- DATA
      GW_IN => gw_in_write_gate,

      MODULO => modulo_write_gate,
      GW_OUT => gw_out_write_gate
    );

  -- WRITE KEY
  write_key : dnc_write_key
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_key,
      READY => ready_write_key,

      -- DATA
      K_IN => k_in_write_key,

      MODULO => modulo_write_key,
      K_OUT  => k_out_write_key
    );

  -- WRITE STRENGTH
  write_strength : dnc_write_strength
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_strength,
      READY => ready_write_strength,

      -- DATA
      BETA_IN => beta_in_write_strength,

      MODULO   => modulo_write_strength,
      BETA_OUT => beta_out_write_strength
    );

  -- WRITE VECTOR
  write_vector : dnc_write_vector
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_vector,
      READY => ready_write_vector,

      -- DATA
      V_IN => v_in_write_vector,

      MODULO => modulo_write_vector,
      V_OUT  => v_out_write_vector
    );

end dnc_write_heads_testbench_architecture;
