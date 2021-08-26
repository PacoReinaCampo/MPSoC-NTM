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

entity dnc_precedence_weighting is
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

    W_IN_ENABLE : in std_logic;
    P_IN_ENABLE : in std_logic;

    P_OUT_ENABLE : out std_logic;

    -- DATA
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
    P_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture dnc_precedence_weighting_architecture of dnc_precedence_weighting is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------
  -- VECTOR MULTIPLICATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  -- DATA
  signal modulo_vector_summation    : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_summation : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_summation : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic_vector(N-1 downto 0);

  signal operation_vector_adder : std_logic_vector(N-1 downto 0);

  -- DATA
  signal modulo_vector_adder    : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_multiplier : std_logic;
  signal ready_vector_multiplier : std_logic_vector(N-1 downto 0);

  -- DATA
  signal modulo_vector_multiplier    : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_arithmetic_vector_vector(N-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  ntm_vector_summation_function_i : ntm_vector_summation_function
    generic map (
      I => N,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      -- DATA
      MODULO    => modulo_vector_summation,
      DATA_A_IN => data_a_in_vector_summation,
      DATA_B_IN => data_b_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
    );

  ntm_vector_adder_i : ntm_vector_adder
    generic map (
      I => N,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      -- DATA
      MODULO    => modulo_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
    );

  ntm_vector_multiplier_i : ntm_vector_multiplier
    generic map (
      I => N,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplier,
      READY => ready_vector_multiplier,

      -- DATA
      MODULO    => modulo_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
    );

end architecture;
