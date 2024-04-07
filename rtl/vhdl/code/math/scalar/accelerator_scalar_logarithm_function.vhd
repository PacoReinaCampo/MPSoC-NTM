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

use ieee.float_pkg.all;

use work.accelerator_arithmetic_vhdl_pkg.all;
use work.accelerator_math_vhdl_pkg.all;

entity accelerator_scalar_logarithm_function is
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

architecture accelerator_scalar_logarithm_function_architecture of accelerator_scalar_logarithm_function is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    SCALAR_MULTIPLIER_STATE,            -- STEP 1
    SCALAR_DIVIDER_STATE,               -- STEP 2
    SCALAR_ADDER_STATE                  -- STEP 3
    );

  type vector_coefficients is array (4 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant COEFFICIENT_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(1.0, float64'high, -float64'low));
  constant COEFFICIENT_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(-2.0, float64'high, -float64'low));
  constant COEFFICIENT_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(3.0, float64'high, -float64'low));
  constant COEFFICIENT_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(-4.0, float64'high, -float64'low));
  constant COEFFICIENT_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(5.0, float64'high, -float64'low));

  constant LOGARITHM_COEFFICIENTS : vector_coefficients := (COEFFICIENT_FOUR, COEFFICIENT_THREE, COEFFICIENT_TWO, COEFFICIENT_ONE, COEFFICIENT_ZERO);

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Data Internal
  signal index_adder_loop      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_multiplier_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_float_multiplier : std_logic;
  signal ready_scalar_float_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_float_divider : std_logic;
  signal ready_scalar_float_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_float_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = logarithm(DATA_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      data_a_in_scalar_float_adder <= ZERO_DATA;
      data_b_in_scalar_float_adder <= ZERO_DATA;

      data_a_in_scalar_float_multiplier <= ZERO_DATA;
      data_b_in_scalar_float_multiplier <= ZERO_DATA;

      data_a_in_scalar_float_divider <= ZERO_DATA;
      data_b_in_scalar_float_divider <= ZERO_DATA;

      -- Control Internal
      start_scalar_float_adder      <= '0';
      start_scalar_float_multiplier <= '0';
      start_scalar_float_divider    <= '0';

      operation_scalar_float_adder <= '0';

      index_adder_loop      <= ZERO_UDATA;
      index_multiplier_loop <= ZERO_UDATA;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_scalar_float_multiplier <= '1';

            index_adder_loop      <= ZERO_UDATA;
            index_multiplier_loop <= ZERO_UDATA;

            -- Data Input
            data_a_in_scalar_float_multiplier <= DATA_IN;
            data_b_in_scalar_float_multiplier <= ONE_DATA;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;
          end if;

        when SCALAR_MULTIPLIER_STATE =>  -- STEP 1

          -- Exponential Part

          if (ready_scalar_float_multiplier = '1') then
            if (unsigned(index_multiplier_loop) = unsigned(index_adder_loop)+unsigned(ONE_UDATA)) then
              -- Control Internal
              start_scalar_float_divider <= '1';

              -- Data Internal
              data_a_in_scalar_float_divider <= data_out_scalar_float_multiplier;
              data_b_in_scalar_float_divider <= LOGARITHM_COEFFICIENTS(to_integer(unsigned(index_adder_loop)));

              -- FSM Control
              controller_ctrl_fsm_int <= SCALAR_DIVIDER_STATE;
            else
              -- Data Internal
              data_a_in_scalar_float_multiplier <= DATA_IN;

              if (unsigned(index_multiplier_loop) = unsigned(ZERO_UDATA)) then
                data_b_in_scalar_float_multiplier <= ONE_DATA;
              else
                data_b_in_scalar_float_multiplier <= data_out_scalar_float_multiplier;
              end if;

              -- Control Internal
              start_scalar_float_multiplier <= '1';

              index_multiplier_loop <= std_logic_vector(unsigned(index_multiplier_loop)+unsigned(ONE_UDATA));
            end if;
          else
            -- Control Internal
            start_scalar_float_multiplier <= '0';
          end if;

        when SCALAR_DIVIDER_STATE =>    -- STEP 2

          if (ready_scalar_float_divider = '1') then
            -- Control Internal
            start_scalar_float_adder <= '1';

            operation_scalar_float_adder <= '0';

            -- Data Internal
            data_a_in_scalar_float_adder <= data_out_scalar_float_divider;

            if (unsigned(index_adder_loop) = unsigned(ZERO_UDATA)) then
              data_b_in_scalar_float_adder <= ZERO_DATA;
            else
              data_b_in_scalar_float_adder <= data_out_scalar_float_adder;
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_ADDER_STATE;
          else
            -- Control Internal
            start_scalar_float_multiplier <= '0';
            start_scalar_float_divider    <= '0';
          end if;

        when SCALAR_ADDER_STATE =>      -- STEP 3

          if (ready_scalar_float_adder = '1') then
            if (unsigned(index_adder_loop) = unsigned(FOUR_UDATA)) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_float_adder;

              -- Control Outputs
              READY <= '1';

              -- Control Internal
              index_adder_loop <= ZERO_UDATA;

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              start_scalar_float_multiplier <= '1';

              index_adder_loop <= std_logic_vector(unsigned(index_adder_loop)+unsigned(ONE_UDATA));

              -- Data Input
              data_a_in_scalar_float_multiplier <= DATA_IN;
              data_b_in_scalar_float_multiplier <= ONE_DATA;

              -- FSM Control
              controller_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;
            end if;

            -- Control Internal
            index_multiplier_loop <= ZERO_UDATA;
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

  -- SCALAR MULTIPLIER
  scalar_float_multiplier : accelerator_scalar_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_multiplier,
      READY => ready_scalar_float_multiplier,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_multiplier,
      DATA_B_IN => data_b_in_scalar_float_multiplier,
      DATA_OUT  => data_out_scalar_float_multiplier
      );

  -- SCALAR DIVIDER
  scalar_float_divider : accelerator_scalar_float_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_divider,
      READY => ready_scalar_float_divider,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_divider,
      DATA_B_IN => data_b_in_scalar_float_divider,
      DATA_OUT  => data_out_scalar_float_divider
      );

end architecture;
