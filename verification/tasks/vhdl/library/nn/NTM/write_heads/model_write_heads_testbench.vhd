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

use work.model_math_vhdl_pkg.all;
use work.model_ntm_core_vhdl_pkg.all;
use work.model_write_heads_pkg.all;

entity model_write_heads_testbench is
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
    ENABLE_NTM_WRITE_HEADS_TEST   : boolean := false;
    ENABLE_NTM_WRITE_HEADS_CASE_0 : boolean := false;
    ENABLE_NTM_WRITE_HEADS_CASE_1 : boolean := false
    );
end model_write_heads_testbench;

architecture model_write_heads_testbench_architecture of model_write_heads_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- WRITING
  -- CONTROL
  signal start_writing : std_logic;
  signal ready_writing : std_logic;

  signal m_in_j_enable_writing : std_logic;
  signal m_in_k_enable_writing : std_logic;

  signal w_in_i_enable_writing : std_logic;
  signal w_in_j_enable_writing : std_logic;

  signal a_in_enable_writing : std_logic;

  signal w_out_i_enable_writing : std_logic;
  signal w_out_j_enable_writing : std_logic;

  signal a_out_enable_writing : std_logic;

  signal m_out_j_enable_writing : std_logic;
  signal m_out_k_enable_writing : std_logic;

  -- DATA
  signal size_r_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_writing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_writing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal a_in_writing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_out_writing : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASING
  -- CONTROL
  signal start_erasing : std_logic;
  signal ready_erasing : std_logic;

  signal m_in_j_enable_erasing : std_logic;
  signal m_in_k_enable_erasing : std_logic;

  signal w_in_i_enable_erasing : std_logic;
  signal w_in_j_enable_erasing : std_logic;

  signal e_in_enable_erasing : std_logic;

  signal w_out_i_enable_erasing : std_logic;
  signal w_out_j_enable_erasing : std_logic;

  signal e_out_enable_erasing : std_logic;

  signal m_out_j_enable_erasing : std_logic;
  signal m_out_k_enable_erasing : std_logic;

  -- DATA
  signal size_r_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_out_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

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

      -- CONTROL
      NTM_WRITE_HEADS_START => start_writing,
      NTM_WRITE_HEADS_READY => ready_writing,

      NTM_WRITE_HEADS_M_IN_J_ENABLE => m_in_j_enable_writing,
      NTM_WRITE_HEADS_M_IN_K_ENABLE => m_in_k_enable_writing,

      NTM_WRITE_HEADS_W_IN_I_ENABLE => w_in_i_enable_writing,
      NTM_WRITE_HEADS_W_IN_J_ENABLE => w_in_j_enable_writing,

      NTM_WRITE_HEADS_A_IN_ENABLE => a_in_enable_writing,

      NTM_WRITE_HEADS_W_OUT_I_ENABLE => w_out_i_enable_writing,
      NTM_WRITE_HEADS_W_OUT_J_ENABLE => w_out_j_enable_writing,

      NTM_WRITE_HEADS_A_OUT_ENABLE => a_out_enable_writing,

      NTM_WRITE_HEADS_M_OUT_J_ENABLE => m_out_j_enable_writing,
      NTM_WRITE_HEADS_M_OUT_K_ENABLE => m_out_k_enable_writing,

      -- DATA
      NTM_WRITE_HEADS_SIZE_R_IN => size_r_in_writing,
      NTM_WRITE_HEADS_SIZE_N_IN => size_n_in_writing,
      NTM_WRITE_HEADS_SIZE_W_IN => size_w_in_writing,

      NTM_WRITE_HEADS_W_IN => w_in_writing,
      NTM_WRITE_HEADS_M_IN => m_in_writing,
      NTM_WRITE_HEADS_A_IN => a_in_writing,

      NTM_WRITE_HEADS_M_OUT => m_out_writing
      );

  -- WRITING
  writing : model_writing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_writing,
      READY => ready_writing,

      M_IN_J_ENABLE => m_in_j_enable_writing,
      M_IN_K_ENABLE => m_in_k_enable_writing,

      W_IN_I_ENABLE => w_in_i_enable_writing,
      W_IN_J_ENABLE => w_in_j_enable_writing,

      A_IN_ENABLE => a_in_enable_writing,

      W_OUT_I_ENABLE => w_out_i_enable_writing,
      W_OUT_J_ENABLE => w_out_j_enable_writing,

      A_OUT_ENABLE => a_out_enable_writing,

      M_OUT_J_ENABLE => m_out_j_enable_writing,
      M_OUT_K_ENABLE => m_out_k_enable_writing,

      -- DATA
      SIZE_R_IN => size_r_in_writing,
      SIZE_N_IN => size_n_in_writing,
      SIZE_W_IN => size_w_in_writing,

      W_IN => w_in_writing,
      M_IN => m_in_writing,
      A_IN => a_in_writing,

      M_OUT => m_out_writing
      );

  -- ERASING
  erasing : model_erasing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erasing,
      READY => ready_erasing,

      M_IN_J_ENABLE => m_in_j_enable_erasing,
      M_IN_K_ENABLE => m_in_k_enable_erasing,

      W_IN_I_ENABLE => w_in_i_enable_erasing,
      W_IN_J_ENABLE => w_in_j_enable_erasing,

      E_IN_ENABLE => e_in_enable_erasing,

      W_OUT_I_ENABLE => w_out_i_enable_erasing,
      W_OUT_J_ENABLE => w_out_j_enable_erasing,

      E_OUT_ENABLE => e_out_enable_erasing,

      M_OUT_J_ENABLE => m_out_j_enable_erasing,
      M_OUT_K_ENABLE => m_out_k_enable_erasing,

      -- DATA
      SIZE_R_IN => size_r_in_erasing,
      SIZE_N_IN => size_n_in_erasing,
      SIZE_W_IN => size_w_in_erasing,

      W_IN => w_in_erasing,
      M_IN => m_in_erasing,
      E_IN => e_in_erasing,

      M_OUT => m_out_erasing
      );

end model_write_heads_testbench_architecture;
