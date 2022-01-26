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

use work.ntm_arithmetic_pkg.all;

entity ntm_scalar_exponentiator_function is
  generic (
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64
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

architecture ntm_scalar_exponentiator_function_architecture of ntm_scalar_exponentiator_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    SCALAR_FIRST_MULTIPLIER_STATE,      -- STEP 1
    SCALAR_SECOND_MULTIPLIER_STATE,     -- STEP 2
    SCALAR_DIVIDER_STATE,               -- STEP 3
    SCALAR_ADDER_STATE                  -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Data Internal
  signal data_int_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal index_adder_loop             : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_first_multiplier_loop  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_second_multiplier_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_adder : std_logic;
  signal ready_scalar_adder : std_logic;

  signal operation_scalar_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_multiplier : std_logic;
  signal ready_scalar_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_divider : std_logic;
  signal ready_scalar_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = exponentiator(DATA_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      data_a_in_scalar_adder <= ZERO_DATA;
      data_b_in_scalar_adder <= ZERO_DATA;

      data_a_in_scalar_multiplier <= ZERO_DATA;
      data_b_in_scalar_multiplier <= ZERO_DATA;

      data_a_in_scalar_divider <= ZERO_DATA;
      data_b_in_scalar_divider <= ZERO_DATA;

      data_int_scalar_multiplier <= ZERO_DATA;

      -- Control Internal
      start_scalar_adder      <= '0';
      start_scalar_multiplier <= '0';
      start_scalar_divider    <= '0';

      operation_scalar_adder <= '0';

      index_adder_loop             <= ZERO_DATA;
      index_first_multiplier_loop  <= ZERO_DATA;
      index_second_multiplier_loop <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_scalar_multiplier <= '1';

            index_adder_loop             <= ZERO_DATA;
            index_first_multiplier_loop  <= ZERO_DATA;
            index_second_multiplier_loop <= ZERO_DATA;

            -- Data Internal
            data_int_scalar_multiplier <= ZERO_DATA;

            -- Data Input
            data_a_in_scalar_multiplier <= DATA_IN;
            data_b_in_scalar_multiplier <= ONE_DATA;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_FIRST_MULTIPLIER_STATE;
          end if;

        when SCALAR_FIRST_MULTIPLIER_STATE =>  -- STEP 1

          if (ready_scalar_multiplier = '1') then
            if (unsigned(index_first_multiplier_loop) = unsigned(index_adder_loop)) then
              -- Control Internal
              start_scalar_multiplier <= '1';

              -- Data Internal
              data_a_in_scalar_multiplier <= ONE_DATA;
              data_b_in_scalar_multiplier <= ONE_DATA;

              data_int_scalar_multiplier <= data_out_scalar_multiplier;

              index_first_multiplier_loop <= ZERO_DATA;

              -- FSM Control
              controller_ctrl_fsm_int <= SCALAR_SECOND_MULTIPLIER_STATE;
            else
              -- Data Internal
              data_b_in_scalar_multiplier <= data_out_scalar_multiplier;

              -- Control Internal
              start_scalar_multiplier <= '1';

              index_first_multiplier_loop <= std_logic_vector(unsigned(index_first_multiplier_loop)+unsigned(ONE_DATA));
            end if;
          else
            -- Control Internal
            start_scalar_multiplier <= '0';
          end if;

        when SCALAR_SECOND_MULTIPLIER_STATE =>  -- STEP 2

          if (ready_scalar_multiplier = '1') then
            if (unsigned(index_second_multiplier_loop) = unsigned(index_adder_loop)) then
              -- Control Internal
              start_scalar_divider <= '1';

              -- Data Internal
              data_a_in_scalar_divider <= data_int_scalar_multiplier;
              data_b_in_scalar_divider <= data_out_scalar_multiplier;

              index_second_multiplier_loop <= ZERO_DATA;

              -- FSM Control
              controller_ctrl_fsm_int <= SCALAR_DIVIDER_STATE;
            else
              -- Data Internal
              data_a_in_scalar_multiplier <= index_second_multiplier_loop;
              data_b_in_scalar_multiplier <= data_out_scalar_multiplier;

              -- Control Internal
              start_scalar_multiplier <= '1';

              index_second_multiplier_loop <= std_logic_vector(unsigned(index_second_multiplier_loop)+unsigned(ONE_DATA));
            end if;
          else
            -- Control Internal
            start_scalar_multiplier <= '0';
          end if;

        when SCALAR_DIVIDER_STATE =>    -- STEP 3

          if (ready_scalar_divider = '1') then
            -- Control Internal
            start_scalar_adder <= '1';

            operation_scalar_adder <= '0';

            -- Data Internal
            data_a_in_scalar_adder <= data_out_scalar_divider;

            if (unsigned(index_adder_loop) = unsigned(ONE_DATA)) then
              data_b_in_scalar_adder <= ZERO_DATA;
            else
              data_b_in_scalar_adder <= data_out_scalar_adder;
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_ADDER_STATE;
          else
            -- Control Internal
            start_scalar_divider <= '0';
          end if;

        when SCALAR_ADDER_STATE =>      -- STEP 4

          if (ready_scalar_adder = '1') then
            if (unsigned(index_adder_loop) = unsigned(EULER)) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_adder;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              start_scalar_multiplier <= '1';

              index_adder_loop <= std_logic_vector(unsigned(index_adder_loop)+unsigned(ONE_DATA));

              -- Data Input
              data_a_in_scalar_multiplier <= DATA_IN;
              data_b_in_scalar_multiplier <= ONE_DATA;

              -- FSM Control
              controller_ctrl_fsm_int <= SCALAR_FIRST_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR ADDER
  scalar_adder : ntm_scalar_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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
      DATA_A_IN => data_a_in_scalar_adder,
      DATA_B_IN => data_b_in_scalar_adder,
      DATA_OUT  => data_out_scalar_adder
      );

  -- SCALAR MULTIPLIER
  scalar_multiplier : ntm_scalar_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_multiplier,
      READY => ready_scalar_multiplier,

      -- DATA
      DATA_A_IN => data_a_in_scalar_multiplier,
      DATA_B_IN => data_b_in_scalar_multiplier,
      DATA_OUT  => data_out_scalar_multiplier
      );

  -- SCALAR DIVIDER
  scalar_divider : ntm_scalar_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_divider,
      READY => ready_scalar_divider,

      -- DATA
      DATA_A_IN => data_a_in_scalar_divider,
      DATA_B_IN => data_b_in_scalar_divider,
      DATA_OUT  => data_out_scalar_divider
      );

end architecture;
