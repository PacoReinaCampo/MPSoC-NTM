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
use work.ntm_core_pkg.all;

entity ntm_addressing is
  generic (
    N : integer := 64;

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
    MODULO : in  std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
    W_IN   : in  std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
    M_IN   : in  std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
    W_OUT  : out std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_addressing_architecture of ntm_addressing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- ADDRESSING CONTENT
  -- CONTROL
  signal start_addressing_content : std_logic;
  signal ready_addressing_content : std_logic;

  -- DATA
  signal modulo_addressing_content  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_in_addressing_content    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal m_in_addressing_content    : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal beta_in_addressing_content : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing_content   : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDRESSING LOCATION
  -- CONTROL
  signal start_addressing_location : std_logic;
  signal ready_addressing_location : std_logic;

  -- DATA
  signal modulo_addressing_location   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_addressing_location     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_in_addressing_location : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing_location    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

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

      -- DATA
      MODULO  => modulo_addressing_content,
      K_IN    => k_in_addressing_content,
      M_IN    => m_in_addressing_content,
      BETA_IN => beta_in_addressing_content,
      W_OUT   => w_out_addressing_content
    );

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

      -- DATA
      MODULO   => modulo_addressing_location,
      W_IN     => w_in_addressing_location,
      GAMMA_IN => gamma_in_addressing_location,
      W_OUT    => w_out_addressing_location
    );

end architecture;
