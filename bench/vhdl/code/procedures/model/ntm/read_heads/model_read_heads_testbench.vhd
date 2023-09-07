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
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, ENPRESS OR
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
use work.model_read_heads_pkg.all;

entity model_read_heads_testbench is
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
    ENABLE_NTM_READ_HEADS_TEST   : boolean := false;
    ENABLE_NTM_READ_HEADS_CASE_0 : boolean := false;
    ENABLE_NTM_READ_HEADS_CASE_1 : boolean := false
    );
end model_read_heads_testbench;

architecture model_read_heads_testbench_architecture of model_read_heads_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- READING
  -- CONTROL
  signal start_reading : std_logic;
  signal ready_reading : std_logic;

  signal m_in_j_enable_reading : std_logic;
  signal m_in_k_enable_reading : std_logic;

  signal w_in_i_enable_reading : std_logic;
  signal w_in_j_enable_reading : std_logic;

  signal m_out_j_enable_reading : std_logic;
  signal m_out_k_enable_reading : std_logic;

  signal w_out_i_enable_reading : std_logic;
  signal w_out_j_enable_reading : std_logic;

  signal r_out_i_enable_reading : std_logic;
  signal r_out_k_enable_reading : std_logic;

  -- DATA
  signal size_r_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_reading : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_reading : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_out_reading : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  read_heads_stimulus : model_read_heads_stimulus
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
      NTM_READ_HEADS_START => start_reading,
      NTM_READ_HEADS_READY => ready_reading,

      NTM_READ_HEADS_M_IN_J_ENABLE => m_in_j_enable_reading,
      NTM_READ_HEADS_M_IN_K_ENABLE => m_in_k_enable_reading,

      NTM_READ_HEADS_W_IN_I_ENABLE => w_in_i_enable_reading,
      NTM_READ_HEADS_W_IN_J_ENABLE => w_in_j_enable_reading,

      NTM_READ_HEADS_M_OUT_J_ENABLE => m_out_j_enable_reading,
      NTM_READ_HEADS_M_OUT_K_ENABLE => m_out_k_enable_reading,

      NTM_READ_HEADS_W_OUT_I_ENABLE => w_out_i_enable_reading,
      NTM_READ_HEADS_W_OUT_J_ENABLE => w_out_j_enable_reading,

      NTM_READ_HEADS_R_OUT_I_ENABLE => r_out_i_enable_reading,
      NTM_READ_HEADS_R_OUT_K_ENABLE => r_out_k_enable_reading,

      -- DATA
      NTM_READ_HEADS_SIZE_R_IN => size_r_in_reading,
      NTM_READ_HEADS_SIZE_N_IN => size_n_in_reading,
      NTM_READ_HEADS_SIZE_W_IN => size_w_in_reading,

      NTM_READ_HEADS_W_IN => w_in_reading,
      NTM_READ_HEADS_M_IN => m_in_reading,

      NTM_READ_HEADS_R_OUT => r_out_reading
      );

  -- READING
  reading : model_reading
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_reading,
      READY => ready_reading,

      M_IN_J_ENABLE => m_in_j_enable_reading,
      M_IN_K_ENABLE => m_in_k_enable_reading,

      W_IN_I_ENABLE => w_in_i_enable_reading,
      W_IN_J_ENABLE => w_in_j_enable_reading,

      M_OUT_J_ENABLE => m_out_j_enable_reading,
      M_OUT_K_ENABLE => m_out_k_enable_reading,

      W_OUT_I_ENABLE => w_out_i_enable_reading,
      W_OUT_J_ENABLE => w_out_j_enable_reading,

      R_OUT_I_ENABLE => r_out_i_enable_reading,
      R_OUT_K_ENABLE => r_out_k_enable_reading,

      -- DATA
      SIZE_R_IN => size_r_in_reading,
      SIZE_N_IN => size_n_in_reading,
      SIZE_W_IN => size_w_in_reading,

      W_IN => w_in_reading,
      M_IN => m_in_reading,

      R_OUT => r_out_reading
      );

end model_read_heads_testbench_architecture;
