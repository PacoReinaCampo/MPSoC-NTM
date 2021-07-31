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

entity ntm_point_doubler is
  generic (
    DATA_SIZE : integer := 256
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    -- DATA
    POINT_IN_PX  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    POINT_IN_PY  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    POINT_OUT_RX : out std_logic_vector(DATA_SIZE-1 downto 0);
    POINT_OUT_RY : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_point_doubler_architecture of ntm_point_doubler is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type point_doubler_ctrl_fsm_type is (
    STARTER_ST,             -- STEP 0
    MULTIPLIER_FIRST_ST,    -- STEP 1
    MULTIPLIER_SECOND_ST,   -- STEP 2
    ADDER_FIRST_ST,         -- STEP 3
    MULTIPLIER_THIRD_ST,    -- STEP 4
    INVERTER_ST,            -- STEP 5
    MULTIPLIER_FOURTH_ST,   -- STEP 6
    MULTIPLIER_FIFTH_ST,    -- STEP 7
    MULTIPLIER_SIXTH_ST,    -- STEP 8
    ADDER_SECOND_ST,        -- STEP 9
    ADDER_THIRD_ST,         -- STEP 10
    MULTIPLIER_SEVENTH_ST,  -- STEP 11
    ENDER_ST                -- STEP 12
  );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal point_doubler_ctrl_fsm_st : point_doubler_ctrl_fsm_type;

  -- Internal Signals
  signal s_int        : std_logic_vector(DATA_SIZE-1 downto 0);
  signal t_int        : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_rx_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDER
  -- Control Signals
  signal start_adder : std_logic;
  signal ready_adder : std_logic;

  signal operation_adder : std_logic;

  -- Data Signals
  signal data_in_a_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_b_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INVERTER
  -- Control Signals
  signal start_inverter : std_logic;
  signal ready_inverter : std_logic;

  -- Data Signals
  signal data_in_inverter_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_inverter_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MULTIPLIER
  -- Control Signals
  signal start_multiplier : std_logic;
  signal ready_multiplier : std_logic;

  -- Data Signals
  signal data_in_a_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_b_multiplier_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_multiplier_int  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- s = (3*Px*Px) + A / (2*Py)

  -- Rx = s*s - 2*Px
  -- Ry = s*(Px - Rx) - Py

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      POINT_OUT_RX <= ZERO;
      POINT_OUT_RY <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      s_int        <= ZERO;
      t_int        <= ZERO;
      point_rx_int <= ZERO;

      start_adder <= '0';

      operation_adder <= '0';

      data_in_a_adder_int <= ZERO;
      data_in_b_adder_int <= ZERO;

      start_inverter <= '0';

      data_in_inverter_int  <= ZERO;

      start_multiplier <= '0';

      data_in_a_multiplier_int <= ZERO;
      data_in_b_multiplier_int <= ZERO;

    elsif (rising_edge(CLK)) then

      case point_doubler_ctrl_fsm_st is
        when STARTER_ST =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            if (POINT_IN_PX = ZERO and POINT_IN_PY = ZERO) then
              -- Data Outputs
              POINT_OUT_RX <= ZERO;
              POINT_OUT_RY <= ZERO;

              -- Data Outputs
              READY <= '1';
            else
              -- Assignations for next state
              start_multiplier         <= '1';
              data_in_a_multiplier_int <= THREE;
              data_in_b_multiplier_int <= POINT_IN_PX;
      
              -- FSM Control
              point_doubler_ctrl_fsm_st <= MULTIPLIER_FIRST_ST;
            end if;
          end if;

        when MULTIPLIER_FIRST_ST =>  -- STEP 1

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_multiplier         <= '1';
            data_in_a_multiplier_int <= data_out_multiplier_int;
            data_in_b_multiplier_int <= POINT_IN_PX;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= MULTIPLIER_SECOND_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when MULTIPLIER_SECOND_ST =>  -- STEP 2

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_adder <= '1';

            operation_adder <= '0';
            
            data_in_a_adder_int <= data_out_multiplier_int;
            data_in_b_adder_int <= BLACKPOOL512_A;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= ADDER_FIRST_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when ADDER_FIRST_ST =>  -- STEP 3

          if (ready_adder = '1') then
            -- Assignations for next state
            start_multiplier         <= '1';
            data_in_a_multiplier_int <= TWO;
            data_in_b_multiplier_int <= POINT_IN_PY;

            -- Assignations
            s_int <= data_out_adder_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= MULTIPLIER_THIRD_ST;
          else
            -- Assignations for next state
            start_adder <= '0';
          end if;

        when MULTIPLIER_THIRD_ST =>  -- STEP 4

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_inverter <= '1';
            
            data_in_inverter_int <= data_out_multiplier_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= INVERTER_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when INVERTER_ST =>  -- STEP 5

          if (ready_inverter = '1') then
            -- Assignations for next state
            start_multiplier         <= '1';
            data_in_a_multiplier_int <= s_int;
            data_in_b_multiplier_int <= data_out_inverter_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= MULTIPLIER_FOURTH_ST;
          else
            -- Assignations for next state
            start_inverter <= '0';
          end if;

        when MULTIPLIER_FOURTH_ST =>  -- STEP 6

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_multiplier         <= '1';
            data_in_a_multiplier_int <= data_out_multiplier_int;
            data_in_b_multiplier_int <= data_out_multiplier_int;

            -- Assignations
            s_int <= data_out_multiplier_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= MULTIPLIER_FIFTH_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when MULTIPLIER_FIFTH_ST =>  -- STEP 7

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_multiplier <= '1';
            data_in_a_multiplier_int <= TWO;
            data_in_b_multiplier_int <= POINT_IN_PX;

            -- Assignations
            t_int <= data_out_multiplier_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= MULTIPLIER_SIXTH_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when MULTIPLIER_SIXTH_ST =>  -- STEP 8

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_adder <= '1';

            operation_adder <= '1';

            data_in_a_adder_int <= t_int;
            data_in_b_adder_int <= data_out_multiplier_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= ADDER_SECOND_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when ADDER_SECOND_ST =>  -- STEP 9

          if (ready_adder = '1') then
            -- Assignations for next state
            start_adder <= '1';

            operation_adder <= '1';

            data_in_a_adder_int <= POINT_IN_PX;
            data_in_b_adder_int <= data_out_adder_int;

            -- Assignations
            point_rx_int <= data_out_adder_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= ADDER_THIRD_ST;
          else
            -- Assignations for next state
            start_adder <= '0';
          end if;

        when ADDER_THIRD_ST =>  -- STEP 10

          if (ready_adder = '1') then
            -- Assignations for next state
            start_multiplier <= '1';

            data_in_a_multiplier_int <= s_int;
            data_in_b_multiplier_int <= data_out_adder_int;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= MULTIPLIER_SEVENTH_ST;
          else
            -- Assignations for next state
            start_adder <= '0';
          end if;

        when MULTIPLIER_SEVENTH_ST =>  -- STEP 11

          if (ready_multiplier = '1') then
            -- Assignations for next state
            start_adder <= '1';

            operation_adder <= '1';

            data_in_a_adder_int <= data_out_multiplier_int;
            data_in_b_adder_int <= POINT_IN_PY;

            -- FSM Control
            point_doubler_ctrl_fsm_st <= ENDER_ST;
          else
            -- Assignations for next state
            start_multiplier <= '0';
          end if;

        when ENDER_ST =>  -- STEP 12

          if (ready_adder = '1') then
            -- Data Outputs
            POINT_OUT_RX <= point_rx_int;
            POINT_OUT_RY <= data_out_adder_int;

            -- Data Outputs
            READY <= '1';

            -- FSM Control
            point_doubler_ctrl_fsm_st <= STARTER_ST;
          else
            -- Assignations for next state
            start_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          point_doubler_ctrl_fsm_st <= STARTER_ST;
      end case;
    end if;
  end process;

  -----------------------------------------------------------------------
  -- Adder
  -----------------------------------------------------------------------

  ntm_adder_i : ntm_adder
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_adder,
      READY => ready_adder,

      OPERATION => operation_adder,

      -- DATA
      MODULO    => BLACKPOOL512_P,
      DATA_A_IN => data_in_a_adder_int,
      DATA_B_IN => data_in_b_adder_int,
      DATA_OUT  => data_out_adder_int
    );

  -----------------------------------------------------------------------
  -- Inverter
  -----------------------------------------------------------------------

  ntm_inverter_i : ntm_inverter
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_inverter,
      READY => ready_inverter,

      -- DATA
      MODULO   => BLACKPOOL512_P,
      DATA_IN  => data_in_inverter_int,
      DATA_OUT => data_out_inverter_int
    );

  -----------------------------------------------------------------------
  -- Multiplier
  -----------------------------------------------------------------------

  ntm_multiplier_i : ntm_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_multiplier,
      READY => ready_multiplier,

      -- DATA
      MODULO    => BLACKPOOL512_P,
      DATA_A_IN => data_in_a_multiplier_int,
      DATA_B_IN => data_in_b_multiplier_int,
      DATA_OUT  => data_out_multiplier_int
    );

end architecture;
