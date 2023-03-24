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
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_dnc_core_pkg.all;

entity model_read_content_weighting is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    K_IN_ENABLE : in std_logic;         -- for k in 0 to W-1

    K_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    C_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_read_content_weighting_architecture of model_read_content_weighting is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- VECTOR CONTENT BASED ADDRESSING
  -- CONTROL
  signal start_vector_content_based_addressing : std_logic;
  signal ready_vector_content_based_addressing : std_logic;

  signal k_in_enable_vector_content_based_addressing : std_logic;

  signal k_out_enable_vector_content_based_addressing : std_logic;

  signal m_in_i_enable_vector_content_based_addressing : std_logic;
  signal m_in_j_enable_vector_content_based_addressing : std_logic;

  signal m_out_i_enable_vector_content_based_addressing : std_logic;
  signal m_out_j_enable_vector_content_based_addressing : std_logic;

  signal c_out_enable_vector_content_based_addressing : std_logic;

  -- DATA
  signal size_i_in_vector_content_based_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_vector_content_based_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_vector_content_based_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_vector_content_based_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_vector_content_based_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_vector_content_based_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

  -- ASSIGNATIONS
  -- CONTROL
  start_vector_content_based_addressing <= START;

  READY <= ready_vector_content_based_addressing;

  k_in_enable_vector_content_based_addressing <= K_IN_ENABLE;

  K_OUT_ENABLE <= k_out_enable_vector_content_based_addressing;

  m_in_i_enable_vector_content_based_addressing <= M_IN_J_ENABLE;
  m_in_j_enable_vector_content_based_addressing <= M_IN_K_ENABLE;

  M_OUT_J_ENABLE <= m_out_i_enable_vector_content_based_addressing;
  M_OUT_K_ENABLE <= m_out_j_enable_vector_content_based_addressing;

  C_OUT_ENABLE <= c_out_enable_vector_content_based_addressing;

  -- DATA
  size_i_in_vector_content_based_addressing <= SIZE_N_IN;
  size_j_in_vector_content_based_addressing <= SIZE_N_IN;

  k_in_vector_content_based_addressing    <= K_IN;
  m_in_vector_content_based_addressing    <= M_IN;
  beta_in_vector_content_based_addressing <= BETA_IN;

  C_OUT <= c_out_vector_content_based_addressing;

  -- VECTOR CONTENT BASED ADDRESSING
  content_based_addressing : model_content_based_addressing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_content_based_addressing,
      READY => ready_vector_content_based_addressing,

      K_IN_ENABLE => k_in_enable_vector_content_based_addressing,

      K_OUT_ENABLE => k_out_enable_vector_content_based_addressing,

      M_IN_I_ENABLE => m_in_i_enable_vector_content_based_addressing,
      M_IN_J_ENABLE => m_in_j_enable_vector_content_based_addressing,

      M_OUT_I_ENABLE => m_out_i_enable_vector_content_based_addressing,
      M_OUT_J_ENABLE => m_out_j_enable_vector_content_based_addressing,

      C_OUT_ENABLE => c_out_enable_vector_content_based_addressing,

      -- DATA
      SIZE_I_IN => size_i_in_vector_content_based_addressing,
      SIZE_J_IN => size_j_in_vector_content_based_addressing,

      K_IN    => k_in_vector_content_based_addressing,
      M_IN    => m_in_vector_content_based_addressing,
      BETA_IN => beta_in_vector_content_based_addressing,

      C_OUT => c_out_vector_content_based_addressing
      );

end architecture;
