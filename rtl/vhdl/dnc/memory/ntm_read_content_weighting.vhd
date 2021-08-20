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

use work.ntm_math_pkg.all;
use work.ntm_dnc_core_pkg.all;

entity ntm_read_content_weighting is
  generic (
    X : integer := 64;

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
    K_IN    : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
    M_IN    : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
    BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    MODULO : in  std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
    C_OUT  : out std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_read_content_weighting_architecture of ntm_read_content_weighting is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- VECTOR CONTENT BASED ADDRESSING
  -- CONTROL
  signal start_vector_content_based_addressing : std_logic;
  signal ready_vector_content_based_addressing : std_logic;

  -- DATA
  signal k_in_vector_content_based_addressing    : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal m_in_vector_content_based_addressing    : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal beta_in_vector_content_based_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal modulo_vector_content_based_addressing : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal c_out_vector_content_based_addressing  : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  ntm_content_based_addressing_i : ntm_content_based_addressing
    generic map (
      X => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_content_based_addressing,
      READY => ready_vector_content_based_addressing,

      -- DATA
      K_IN    => k_in_vector_content_based_addressing,
      M_IN    => m_in_vector_content_based_addressing,
      BETA_IN => beta_in_vector_content_based_addressing,

      MODULO => modulo_vector_content_based_addressing,
      C_OUT  => c_out_vector_content_based_addressing
    );

end architecture;