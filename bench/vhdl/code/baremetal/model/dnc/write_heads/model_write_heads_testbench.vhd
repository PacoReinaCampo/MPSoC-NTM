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

use work.model_math_pkg.all;
use work.model_dnc_core_pkg.all;
use work.model_write_heads_pkg.all;

entity model_write_heads_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
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
end model_write_heads_testbench;

architecture model_write_heads_testbench_architecture of model_write_heads_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- WRITE HEADS
  -- CONTROL
  signal start_write_heads : std_logic;
  signal ready_WRITE_HEADS : std_logic;

  signal xi_in_enable_write_heads : std_logic;

  signal xi_out_enable_write_heads : std_logic;

  signal k_out_enable_write_heads : std_logic;
  signal e_out_enable_write_heads : std_logic;
  signal v_out_enable_write_heads : std_logic;

  -- DATA
  signal size_s_in_write_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_write_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal xi_in_write_heads : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_write_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_heads : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_write_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_write_heads   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_heads   : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  write_heads_stimulus : model_write_heads_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
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

      -- WRITE HEADS
      -- CONTROL
      DNC_WRITE_HEADS_START => start_write_heads,
      DNC_WRITE_HEADS_READY => ready_WRITE_HEADS,

      DNC_WRITE_HEADS_XI_IN_ENABLE => xi_in_enable_write_heads,

      DNC_WRITE_HEADS_XI_OUT_ENABLE => xi_out_enable_write_heads,

      DNC_WRITE_HEADS_K_OUT_ENABLE => k_out_enable_write_heads,
      DNC_WRITE_HEADS_E_OUT_ENABLE => e_out_enable_write_heads,
      DNC_WRITE_HEADS_V_OUT_ENABLE => v_out_enable_write_heads,

      -- DATA
      DNC_WRITE_HEADS_SIZE_S_IN => size_s_in_write_heads,
      DNC_WRITE_HEADS_SIZE_W_IN => size_w_in_write_heads,

      DNC_WRITE_HEADS_XI_IN => xi_in_write_heads,

      DNC_WRITE_HEADS_K_OUT    => k_out_write_heads,
      DNC_WRITE_HEADS_BETA_OUT => beta_out_write_heads,
      DNC_WRITE_HEADS_E_OUT    => e_out_write_heads,
      DNC_WRITE_HEADS_V_OUT    => v_out_write_heads,
      DNC_WRITE_HEADS_GA_OUT   => ga_out_write_heads,
      DNC_WRITE_HEADS_GW_OUT   => gw_out_write_heads
      );

  -- WRITE HEADS
  model_write_heads_test : if (ENABLE_DNC_WRITE_HEADS_TEST) generate
    WRITE_HEADS : model_write_heads
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_write_heads,
        READY => ready_WRITE_HEADS,

        XI_IN_ENABLE => xi_in_enable_write_heads,

        XI_OUT_ENABLE => xi_out_enable_write_heads,

        K_OUT_ENABLE => k_out_enable_write_heads,
        E_OUT_ENABLE => e_out_enable_write_heads,
        V_OUT_ENABLE => v_out_enable_write_heads,

        -- DATA
        SIZE_S_IN => size_s_in_write_heads,
        SIZE_W_IN => size_w_in_write_heads,

        XI_IN => xi_in_write_heads,

        K_OUT    => k_out_write_heads,
        BETA_OUT => beta_out_write_heads,
        E_OUT    => e_out_write_heads,
        V_OUT    => v_out_write_heads,
        GA_OUT   => ga_out_write_heads,
        GW_OUT   => gw_out_write_heads
        );
  end generate model_write_heads_test;

end model_write_heads_testbench_architecture;
