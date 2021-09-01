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

entity ntm_matrix_exponentiator is
  generic (
    I : integer := 64;
    J : integer := 64;

    DATA_SIZE : integer := 512
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    BASE_EXPONENTIATION_I_ENABLE  : in std_logic;
    BASE_EXPONENTIATION_J_ENABLE  : in std_logic;
    POWER_EXPONENTIATION_I_ENABLE : in std_logic;
    POWER_EXPONENTIATION_J_ENABLE : in std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;

    -- DATA
    MODULO_IN            : in  std_logic_vector(DATA_SIZE-1 downto 0);
    BASE_EXPONENTIATION  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    POWER_EXPONENTIATION : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT             : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_matrix_exponentiator_architecture of ntm_matrix_exponentiator is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal base_enable_vector_exponentiator : std_logic;
  signal power_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_in_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal base_vector_exponentiator     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal power_vector_exponentiator    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- EXPONENTIATION
  vector_exponentiator : ntm_vector_exponentiator
    generic map (
      I => I,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_exponentiator,
      READY => ready_vector_exponentiator,

      BASE_EXPONENTIATION_ENABLE  => base_enable_vector_exponentiator,
      POWER_EXPONENTIATION_ENABLE => power_enable_vector_exponentiator,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      MODULO_IN            => modulo_in_vector_exponentiator,
      BASE_EXPONENTIATION  => base_vector_exponentiator,
      POWER_EXPONENTIATION => power_vector_exponentiator,
      DATA_OUT             => data_out_vector_exponentiator
    );

end architecture;
