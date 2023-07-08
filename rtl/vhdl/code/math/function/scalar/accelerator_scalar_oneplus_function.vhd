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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;

entity accelerator_scalar_oneplus_function is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- DATA
    DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_scalar_oneplus_function_architecture of accelerator_scalar_oneplus_function is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    SCALAR_EXPONENTIATOR_STATE,         -- STEP 1
    SCALAR_LOGARITHM_STATE,             -- STEP 2
    SCALAR_ADDER_STATE                  -- STEP 3
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR EXPONENTIATOR
  -- CONTROL
  signal start_scalar_exponentiator_function : std_logic;
  signal ready_scalar_exponentiator_function : std_logic;

  -- DATA
  signal data_in_scalar_exponentiator_function  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_exponentiator_function : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR LOGARITHM
  -- CONTROL
  signal start_scalar_logarithm_function : std_logic;
  signal ready_scalar_logarithm_function : std_logic;

  -- DATA
  signal data_in_scalar_logarithm_function  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logarithm_function : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = 1 + logarithm(1 + (exponentiation(DATA_IN)))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      start_scalar_float_adder <= '0';

      operation_scalar_float_adder <= '0';

      start_scalar_exponentiator_function <= '0';
      start_scalar_logarithm_function     <= '0';

      -- Data Internal
      data_a_in_scalar_float_adder <= ZERO_DATA;
      data_b_in_scalar_float_adder <= ZERO_DATA;

      data_in_scalar_exponentiator_function <= ZERO_DATA;
      data_in_scalar_logarithm_function     <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_scalar_exponentiator_function <= '1';

            -- Data Input
            data_in_scalar_exponentiator_function <= DATA_IN;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_EXPONENTIATOR_STATE;
          end if;

        when SCALAR_EXPONENTIATOR_STATE =>  -- STEP 1

          if (ready_scalar_exponentiator_function = '1') then
            -- Control Internal
            start_scalar_logarithm_function <= '1';

            -- Data Internal
            data_in_scalar_logarithm_function <= data_out_scalar_exponentiator_function;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_LOGARITHM_STATE;
          else
            -- Control Internal
            start_scalar_exponentiator_function <= '0';
          end if;

        when SCALAR_LOGARITHM_STATE =>  -- STEP 3

          if (ready_scalar_logarithm_function = '1') then
            -- Control Internal
            start_scalar_float_adder <= '1';

            operation_scalar_float_adder <= '0';

            -- Data Internal
            data_a_in_scalar_float_adder <= ONE_DATA;
            data_b_in_scalar_float_adder <= data_out_scalar_logarithm_function;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_ADDER_STATE;
          else
            -- Control Internal
            start_scalar_logarithm_function <= '0';
          end if;

        when SCALAR_ADDER_STATE =>      -- STEP 4

          if (ready_scalar_float_adder = '1') then
            -- Data Outputs
            DATA_OUT <= data_out_scalar_float_adder;

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR ADDER
  scalar_float_adder : accelerator_scalar_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_adder,
      READY => ready_scalar_float_adder,

      OPERATION => operation_scalar_float_adder,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_adder,
      DATA_B_IN => data_b_in_scalar_float_adder,
      DATA_OUT  => data_out_scalar_float_adder
      );

  -- SCALAR EXPONENTIATOR
  scalar_exponentiator_function : accelerator_scalar_exponentiator_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_exponentiator_function,
      READY => ready_scalar_exponentiator_function,

      -- DATA
      DATA_IN  => data_in_scalar_exponentiator_function,
      DATA_OUT => data_out_scalar_exponentiator_function
      );

  -- SCALAR LOGARITHM
  scalar_logarithm_function : accelerator_scalar_logarithm_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_logarithm_function,
      READY => ready_scalar_logarithm_function,

      -- DATA
      DATA_IN  => data_in_scalar_logarithm_function,
      DATA_OUT => data_out_scalar_logarithm_function
      );

end architecture;
