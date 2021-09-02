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

entity ntm_content_based_addressing is
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

    K_IN_ENABLE : in std_logic; -- for j in 0 to J-1

    M_IN_I_ENABLE : in std_logic; -- for i in 0 to I-1
    M_IN_J_ENABLE : in std_logic; -- for j in 0 to J-1

    C_OUT_ENABLE : out std_logic; -- for i in 0 to I-1

    -- DATA
    K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);

    C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_content_based_addressing_architecture of ntm_content_based_addressing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_a_in_enable_vector_exponentiator : std_logic;
  signal data_b_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_in_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_exponentiator     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_exponentiator    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSINE SIMILARITY
  -- CONTROL
  signal start_vector_cosine : std_logic;
  signal ready_vector_cosine : std_logic;

  signal data_a_in_enable_vector_cosine : std_logic;
  signal data_b_in_enable_vector_cosine : std_logic;

  signal data_out_enable_vector_cosine : std_logic;

  -- DATA
  signal modulo_in_vector_cosine    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_cosine   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SOFTMAX
  -- CONTROL
  signal start_vector_softmax : std_logic;
  signal ready_vector_softmax : std_logic;

  signal data_in_enable_vector_softmax : std_logic;

  signal data_out_enable_vector_softmax : std_logic;

  -- DATA
  signal modulo_in_vector_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- C(M,k,beta)[i] = softmax(exponentiation(e,cosine(k,M)·beta))[i]

  -- VECTOR EXPONENTIATOR
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

      DATA_A_IN_ENABLE  => data_a_in_enable_vector_exponentiator,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_exponentiator,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      MODULO_IN            => modulo_in_vector_exponentiator,
      DATA_A_IN  => data_a_in_vector_exponentiator,
      DATA_B_IN => data_b_in_vector_exponentiator,
      DATA_OUT             => data_out_vector_exponentiator
    );

  -- VECTOR COSINE SIMILARITY
  vector_cosine_similarity_function : ntm_vector_cosine_similarity_function
    generic map (
      I => I,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_cosine,
      READY => ready_vector_cosine,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_cosine,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_cosine,

      DATA_OUT_ENABLE => data_out_enable_vector_cosine,

      -- DATA
      MODULO_IN => modulo_in_vector_cosine,
      SIZE_IN   => size_in_vector_cosine,
      DATA_A_IN => data_a_in_vector_cosine,
      DATA_B_IN => data_b_in_vector_cosine,
      DATA_OUT  => data_out_vector_cosine
    );

  -- VECTOR SOFTMAX
  vector_softmax_function : ntm_vector_softmax_function
    generic map (
      I => I,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_softmax,
      READY => ready_vector_softmax,

      DATA_IN_ENABLE => data_in_enable_vector_softmax,

      DATA_OUT_ENABLE => data_out_enable_vector_softmax,

      -- DATA
      MODULO_IN   => modulo_in_vector_softmax,
      SIZE_IN  => size_in_vector_softmax,
      DATA_IN  => data_in_vector_softmax,
      DATA_OUT => data_out_vector_softmax
    );

end architecture;
