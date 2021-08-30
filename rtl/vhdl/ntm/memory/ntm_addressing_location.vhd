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

entity ntm_addressing_location is
  generic (
    DATA_SIZE : integer := 512
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    S_IN_ENABLE : in std_logic; -- for k in 0 to W-1

    W_IN_ENABLE  : in  std_logic; -- for j in 0 to N-1
    W_OUT_ENABLE : out std_logic; -- for j in 0 to N-1

    -- DATA
    G_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    S_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    GAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_addressing_location_architecture of ntm_addressing_location is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_adder : std_logic;
  signal ready_scalar_adder : std_logic;

  signal operation_scalar_adder : std_logic;

  -- DATA
  signal modulo_scalar_adder    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal base_enable_vector_exponentiator : std_logic;
  signal power_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal base_vector_exponentiator     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal power_vector_exponentiator    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_multiplier : std_logic;
  signal ready_vector_multiplier : std_logic;

  signal data_a_in_enable_vector_multiplier : std_logic;
  signal data_b_in_enable_vector_multiplier : std_logic;

  signal data_out_enable_vector_multiplier : std_logic;

  -- DATA
  signal modulo_vector_multiplier    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR CONVOLUTION
  -- CONTROL
  signal start_vector_convolution : std_logic;
  signal ready_vector_convolution : std_logic;

  signal data_a_in_enable_vector_convolution : std_logic;
  signal data_b_in_enable_vector_convolution : std_logic;

  signal data_out_enable_vector_convolution : std_logic;

  -- DATA
  signal modulo_vector_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);
begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- SCALAR ADDER
  scalar_adder : ntm_scalar_adder
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_adder,
      READY => ready_scalar_adder,

      OPERATION => operation_scalar_adder,

      -- DATA
      MODULO    => modulo_scalar_adder,
      DATA_A_IN => data_a_in_scalar_adder,
      DATA_B_IN => data_b_in_scalar_adder,
      DATA_OUT  => data_out_scalar_adder
    );

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

      BASE_EXPONENTIATION_ENABLE  => base_enable_vector_exponentiator,
      POWER_EXPONENTIATION_ENABLE => power_enable_vector_exponentiator,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      MODULO               => modulo_vector_exponentiator,
      BASE_EXPONENTIATION  => base_vector_exponentiator,
      POWER_EXPONENTIATION => power_vector_exponentiator,
      DATA_OUT             => data_out_vector_exponentiator
    );

  -- VECTOR MULTIPLIER
  vector_multiplier : ntm_vector_multiplier
    generic map (
      I => I,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplier,
      READY => ready_vector_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_multiplier,

      -- DATA
      MODULO    => modulo_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
    );

  -- VECTOR CONVOLUTION
  vector_convolution_function : ntm_vector_convolution_function
    generic map (
      I => I,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_convolution,
      READY => ready_vector_convolution,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_convolution,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_convolution,

      DATA_OUT_ENABLE => data_out_enable_vector_convolution,

      -- DATA
      MODULO    => modulo_vector_convolution,
      DATA_A_IN => data_a_in_vector_convolution,
      DATA_B_IN => data_b_in_vector_convolution,
      DATA_OUT  => data_out_vector_convolution
    );
    
end architecture;
