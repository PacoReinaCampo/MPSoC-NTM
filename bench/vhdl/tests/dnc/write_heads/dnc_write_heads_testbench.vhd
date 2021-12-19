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
use work.dnc_write_heads_pkg.all;

entity dnc_write_heads_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    ENABLE_DNC_WRITE_HEADS_TEST   : boolean := false;
    ENABLE_DNC_WRITE_HEADS_CASE_0 : boolean := false;
    ENABLE_DNC_WRITE_HEADS_CASE_1 : boolean := false
    );
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
  signal ga_out_allocation_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASE VECTOR
  -- CONTROL
  signal start_erase_vector : std_logic;
  signal ready_erase_vector : std_logic;

  signal e_in_enable_erase_vector : std_logic;

  signal e_out_enable_erase_vector : std_logic;

  -- DATA
  signal size_w_in_erase_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal e_in_erase_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_erase_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE GATE
  -- CONTROL
  signal start_write_gate : std_logic;
  signal ready_write_gate : std_logic;

  -- DATA
  signal gw_in_write_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE KEY
  -- CONTROL
  signal start_write_key : std_logic;
  signal ready_write_key : std_logic;

  signal k_in_enable_write_key : std_logic;

  signal k_out_enable_write_key : std_logic;

  -- DATA
  signal size_w_in_write_key : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_write_key  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_write_key : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE STRENGHT
  -- CONTROL
  signal start_write_strength : std_logic;
  signal ready_write_strength : std_logic;

  -- DATA
  signal beta_in_write_strength  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_strength : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE VECTOR
  -- CONTROL
  signal start_write_vector : std_logic;
  signal ready_write_vector : std_logic;

  signal v_in_enable_write_vector : std_logic;

  signal v_out_enable_write_vector : std_logic;

  -- DATA
  signal size_w_in_write_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal v_in_write_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_vector : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- STIMULUS
  write_heads_stimulus : dnc_write_heads_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- ALLOCATION GATE
      -- CONTROL
      DNC_ALLOCATION_GATE_START => start_allocation_gate,
      DNC_ALLOCATION_GATE_READY => ready_allocation_gate,

      -- DATA
      DNC_ALLOCATION_GATE_GA_IN => ga_in_allocation_gate,

      DNC_ALLOCATION_GATE_GA_OUT => ga_out_allocation_gate,

      -- ERASE VECTOR
      -- CONTROL
      DNC_ERASE_VECTOR_START => start_erase_vector,
      DNC_ERASE_VECTOR_READY => ready_erase_vector,

      DNC_ERASE_VECTOR_E_IN_ENABLE => e_in_enable_erase_vector,

      DNC_ERASE_VECTOR_E_OUT_ENABLE => e_out_enable_erase_vector,

      -- DATA
      DNC_ERASE_VECTOR_SIZE_W_IN => size_w_in_erase_vector,

      DNC_ERASE_VECTOR_E_IN => e_in_erase_vector,

      DNC_ERASE_VECTOR_E_OUT => e_out_erase_vector,

      -- WRITE GATE
      -- CONTROL
      DNC_WRITE_GATE_START => start_write_gate,
      DNC_WRITE_GATE_READY => ready_write_gate,

      -- DATA
      DNC_WRITE_GATE_GW_IN => gw_in_write_gate,

      DNC_WRITE_GATE_GW_OUT => gw_out_write_gate,

      -- WRITE KEY
      -- CONTROL
      DNC_WRITE_KEY_START => start_write_key,
      DNC_WRITE_KEY_READY => ready_write_key,

      DNC_WRITE_KEY_K_IN_ENABLE => k_in_enable_write_key,

      DNC_WRITE_KEY_K_OUT_ENABLE => k_out_enable_write_key,

      -- DATA
      DNC_WRITE_KEY_SIZE_W_IN => size_w_in_write_key,

      DNC_WRITE_KEY_K_IN => k_in_write_key,

      DNC_WRITE_KEY_K_OUT => k_out_write_key,

      -- WRITE STRENGTH
      -- CONTROL
      DNC_WRITE_STRENGTH_START => start_write_strength,
      DNC_WRITE_STRENGTH_READY => ready_write_strength,

      -- DATA
      DNC_WRITE_STRENGTH_BETA_IN => beta_in_write_strength,

      DNC_WRITE_STRENGTH_BETA_OUT => beta_out_write_strength,

      -- WRITE VECTOR
      -- CONTROL
      DNC_WRITE_VECTOR_START => start_write_vector,
      DNC_WRITE_VECTOR_READY => ready_write_vector,

      DNC_WRITE_VECTOR_V_IN_ENABLE => v_in_enable_write_vector,

      DNC_WRITE_VECTOR_V_OUT_ENABLE => v_out_enable_write_vector,

      -- DATA
      DNC_WRITE_VECTOR_SIZE_W_IN => size_w_in_write_vector,

      DNC_WRITE_VECTOR_V_IN => v_in_write_vector,

      DNC_WRITE_VECTOR_V_OUT => v_out_write_vector
      );

  -- ALLOCATION GATE
  allocation_gate : dnc_allocation_gate
    generic map (
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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

      GA_OUT => ga_out_allocation_gate
      );

  -- ERASE VECTOR
  erase_vector : dnc_erase_vector
    generic map (
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erase_vector,
      READY => ready_erase_vector,

      E_IN_ENABLE => e_in_enable_erase_vector,

      E_OUT_ENABLE => e_out_enable_erase_vector,

      -- DATA
      SIZE_W_IN => size_w_in_erase_vector,

      E_IN => e_in_erase_vector,

      E_OUT => e_out_erase_vector
      );

  -- WRITE GATE
  write_gate : dnc_write_gate
    generic map (
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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

      GW_OUT => gw_out_write_gate
      );

  -- WRITE KEY
  write_key : dnc_write_key
    generic map (
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_key,
      READY => ready_write_key,

      K_IN_ENABLE => k_in_enable_write_key,

      K_OUT_ENABLE => k_out_enable_write_key,

      -- DATA
      SIZE_W_IN => size_w_in_write_key,

      K_IN => k_in_write_key,

      K_OUT => k_out_write_key
      );

  -- WRITE STRENGTH
  write_strength : dnc_write_strength
    generic map (
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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

      BETA_OUT => beta_out_write_strength
      );

  -- WRITE VECTOR
  write_vector : dnc_write_vector
    generic map (
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_vector,
      READY => ready_write_vector,

      V_IN_ENABLE => v_in_enable_write_vector,

      V_OUT_ENABLE => v_out_enable_write_vector,

      -- DATA
      SIZE_W_IN => size_w_in_write_vector,

      V_IN => v_in_write_vector,

      V_OUT => v_out_write_vector
      );

end dnc_write_heads_testbench_architecture;
