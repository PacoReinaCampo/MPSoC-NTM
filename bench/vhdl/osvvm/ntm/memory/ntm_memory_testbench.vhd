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
use work.ntm_core_pkg.all;

entity ntm_memory_testbench is
end ntm_memory_testbench;

architecture ntm_memory_testbench_architecture of ntm_memory_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- ADDRESSING CONTENT
  -- CONTROL
  signal start_addressing_content : std_logic;
  signal ready_addressing_content : std_logic;

  signal m_in_j_enable_addressing_content : std_logic;
  signal m_in_k_enable_addressing_content : std_logic;

  signal k_in_enable_addressing_content : std_logic;

  signal w_out_enable_addressing_content : std_logic;

  -- DATA
  signal k_in_addressing_content    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_addressing_content : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_addressing_content  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing_content : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDRESSING LOCATION
  -- CONTROL
  signal start_addressing_location : std_logic;
  signal ready_addressing_location : std_logic;

  signal w_in_enable_addressing_location  : std_logic;
  signal w_out_enable_addressing_location : std_logic;

  -- DATA
  signal g_in_addressing_location     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_addressing_location     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_in_addressing_location : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_addressing_location  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing_location : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal m_in_j_enable_addressing : std_logic;
  signal m_in_k_enable_addressing : std_logic;

  signal w_in_enable_addressing  : std_logic;
  signal w_out_enable_addressing : std_logic;

  -- DATA
  signal m_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- ADDRESSING CONTENT
  ntm_addressing_content_i : ntm_addressing_content
    generic map (
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing_content,
      READY => ready_addressing_content,

      M_IN_J_ENABLE => m_in_j_enable_addressing_content,
      M_IN_K_ENABLE => m_in_k_enable_addressing_content,

      K_IN_ENABLE => k_in_enable_addressing_content,

      W_OUT_ENABLE => w_out_enable_addressing_content,

      -- DATA
      K_IN    => k_in_addressing_content,
      BETA_IN => beta_in_addressing_content,

      M_IN  => m_in_addressing_content,
      W_OUT => w_out_addressing_content
    );

  -- ADDRESSING LOCATION
  ntm_addressing_location_i : ntm_addressing_location
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing_location,
      READY => ready_addressing_location,

      W_IN_ENABLE  => w_in_enable_addressing_location,
      W_OUT_ENABLE => w_out_enable_addressing_location,

      -- DATA
      G_IN     => g_in_addressing_location,
      S_IN     => s_in_addressing_location,
      GAMMA_IN => gamma_in_addressing_location,

      W_IN  => w_in_addressing_location,
      W_OUT => w_out_addressing_location
    );

  -- ADDRESSING
  ntm_addressing_i : ntm_addressing
    generic map (
      N => N,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      M_IN_J_ENABLE => m_in_j_enable_addressing,
      M_IN_K_ENABLE => m_in_k_enable_addressing,

      W_IN_ENABLE  => w_in_enable_addressing,
      W_OUT_ENABLE => w_out_enable_addressing,

      -- DATA
      M_IN => m_in_addressing,

      W_IN  => w_in_addressing,
      W_OUT => w_out_addressing
    );

end ntm_memory_testbench_architecture;
