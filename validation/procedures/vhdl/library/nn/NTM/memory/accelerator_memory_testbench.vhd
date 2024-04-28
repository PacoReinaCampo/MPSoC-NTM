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

use work.accelerator_math_vhdl_pkg.all;
use work.accelerator_core_vhdl_pkg.all;
use work.accelerator_memory_pkg.all;

entity accelerator_memory_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    ENABLE_ACCELERATOR_MEMORY_TEST   : boolean := false;
    ENABLE_ACCELERATOR_MEMORY_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MEMORY_CASE_1 : boolean := false
    );
end accelerator_memory_testbench;

architecture accelerator_memory_testbench_architecture of accelerator_memory_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_in_i_enable_addressing : std_logic;
  signal k_in_k_enable_addressing : std_logic;

  signal beta_in_enable_addressing : std_logic;

  signal g_in_enable_addressing : std_logic;

  signal s_in_i_enable_addressing : std_logic;
  signal s_in_j_enable_addressing : std_logic;

  signal gamma_in_enable_addressing : std_logic;

  signal k_out_i_enable_addressing : std_logic;
  signal k_out_k_enable_addressing : std_logic;

  signal beta_out_enable_addressing : std_logic;

  signal g_out_enable_addressing : std_logic;

  signal s_out_i_enable_addressing : std_logic;
  signal s_out_j_enable_addressing : std_logic;

  signal gamma_out_enable_addressing : std_logic;

  signal m_in_j_enable_addressing : std_logic;
  signal m_in_k_enable_addressing : std_logic;

  signal m_out_j_enable_addressing : std_logic;
  signal m_out_k_enable_addressing : std_logic;

  signal w_in_i_enable_addressing : std_logic;
  signal w_in_j_enable_addressing : std_logic;

  signal w_out_i_enable_addressing : std_logic;
  signal w_out_j_enable_addressing : std_logic;

  -- DATA
  signal size_r_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal g_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  memory_stimulus : accelerator_memory_stimulus
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

      -- CONTROL
      ACCELERATOR_MEMORY_START => start_addressing,
      ACCELERATOR_MEMORY_READY => ready_addressing,

      ACCELERATOR_MEMORY_K_IN_I_ENABLE => k_in_i_enable_addressing,
      ACCELERATOR_MEMORY_K_IN_K_ENABLE => k_in_k_enable_addressing,

      ACCELERATOR_MEMORY_BETA_IN_ENABLE => beta_in_enable_addressing,

      ACCELERATOR_MEMORY_G_IN_ENABLE => g_in_enable_addressing,

      ACCELERATOR_MEMORY_S_IN_I_ENABLE => s_in_i_enable_addressing,
      ACCELERATOR_MEMORY_S_IN_J_ENABLE => s_in_j_enable_addressing,

      ACCELERATOR_MEMORY_GAMMA_IN_ENABLE => gamma_in_enable_addressing,

      ACCELERATOR_MEMORY_K_OUT_I_ENABLE => k_out_i_enable_addressing,
      ACCELERATOR_MEMORY_K_OUT_K_ENABLE => k_out_k_enable_addressing,

      ACCELERATOR_MEMORY_BETA_OUT_ENABLE => beta_out_enable_addressing,

      ACCELERATOR_MEMORY_G_OUT_ENABLE => g_out_enable_addressing,

      ACCELERATOR_MEMORY_S_OUT_I_ENABLE => s_out_i_enable_addressing,
      ACCELERATOR_MEMORY_S_OUT_J_ENABLE => s_out_j_enable_addressing,

      ACCELERATOR_MEMORY_GAMMA_OUT_ENABLE => gamma_out_enable_addressing,

      ACCELERATOR_MEMORY_M_IN_J_ENABLE => m_in_j_enable_addressing,
      ACCELERATOR_MEMORY_M_IN_K_ENABLE => m_in_k_enable_addressing,

      ACCELERATOR_MEMORY_M_OUT_J_ENABLE => m_out_j_enable_addressing,
      ACCELERATOR_MEMORY_M_OUT_K_ENABLE => m_out_k_enable_addressing,

      ACCELERATOR_MEMORY_W_IN_I_ENABLE => w_in_i_enable_addressing,
      ACCELERATOR_MEMORY_W_IN_J_ENABLE => w_in_j_enable_addressing,

      ACCELERATOR_MEMORY_W_OUT_I_ENABLE => w_out_i_enable_addressing,
      ACCELERATOR_MEMORY_W_OUT_J_ENABLE => w_out_j_enable_addressing,

      -- DATA
      ACCELERATOR_MEMORY_SIZE_R_IN => size_r_in_addressing,
      ACCELERATOR_MEMORY_SIZE_N_IN => size_n_in_addressing,
      ACCELERATOR_MEMORY_SIZE_W_IN => size_w_in_addressing,

      ACCELERATOR_MEMORY_K_IN     => k_in_addressing,
      ACCELERATOR_MEMORY_BETA_IN  => beta_in_addressing,
      ACCELERATOR_MEMORY_G_IN     => g_in_addressing,
      ACCELERATOR_MEMORY_S_IN     => s_in_addressing,
      ACCELERATOR_MEMORY_GAMMA_IN => gamma_in_addressing,

      ACCELERATOR_MEMORY_M_IN => m_in_addressing,

      ACCELERATOR_MEMORY_W_IN  => w_in_addressing,
      ACCELERATOR_MEMORY_W_OUT => w_out_addressing
      );

  -- ADDRESSING
  addressing : accelerator_addressing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      K_IN_I_ENABLE => k_in_i_enable_addressing,
      K_IN_K_ENABLE => k_in_k_enable_addressing,

      BETA_IN_ENABLE => beta_in_enable_addressing,

      G_IN_ENABLE => g_in_enable_addressing,

      S_IN_I_ENABLE => s_in_i_enable_addressing,
      S_IN_J_ENABLE => s_in_j_enable_addressing,

      GAMMA_IN_ENABLE => gamma_in_enable_addressing,

      K_OUT_I_ENABLE => k_out_i_enable_addressing,
      K_OUT_K_ENABLE => k_out_k_enable_addressing,

      BETA_OUT_ENABLE => beta_out_enable_addressing,

      G_OUT_ENABLE => g_out_enable_addressing,

      S_OUT_I_ENABLE => s_out_i_enable_addressing,
      S_OUT_J_ENABLE => s_out_j_enable_addressing,

      GAMMA_OUT_ENABLE => gamma_out_enable_addressing,

      M_IN_J_ENABLE => m_in_j_enable_addressing,
      M_IN_K_ENABLE => m_in_k_enable_addressing,

      M_OUT_J_ENABLE => m_out_j_enable_addressing,
      M_OUT_K_ENABLE => m_out_k_enable_addressing,

      W_IN_I_ENABLE => w_in_i_enable_addressing,
      W_IN_J_ENABLE => w_in_j_enable_addressing,

      W_OUT_I_ENABLE => w_out_i_enable_addressing,
      W_OUT_J_ENABLE => w_out_j_enable_addressing,

      -- DATA
      SIZE_R_IN => size_r_in_addressing,
      SIZE_N_IN => size_n_in_addressing,
      SIZE_W_IN => size_w_in_addressing,

      K_IN     => k_in_addressing,
      BETA_IN  => beta_in_addressing,
      G_IN     => g_in_addressing,
      S_IN     => s_in_addressing,
      GAMMA_IN => gamma_in_addressing,

      M_IN => m_in_addressing,

      W_IN  => w_in_addressing,
      W_OUT => w_out_addressing
      );

end accelerator_memory_testbench_architecture;
