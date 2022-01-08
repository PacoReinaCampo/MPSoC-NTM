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

entity ntm_scalar_convolution_function is
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

    DATA_A_IN_ENABLE : in std_logic;
    DATA_B_IN_ENABLE : in std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_convolution_function_architecture of ntm_scalar_convolution_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    SCALAR_MULTIPLIER_STATE,            -- STEP 2
    SCALAR_ADDER_STATE                  -- STEP 3
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

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_multiplier_int : std_logic;
  signal data_b_in_multiplier_int : std_logic;

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN * DATA_B_IN = summation(DATA_A_IN[LENGTH_IN-i] · DATA_B_IN[i] [i in 0 to LENGTH_IN-1])

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_ENABLE <= '0';

      -- Control Internal
      start_scalar_adder      <= '0';
      start_scalar_multiplier <= '0';

      index_loop <= ZERO_CONTROL;

      data_a_in_multiplier_int <= '0';
      data_b_in_multiplier_int <= '0';

      -- Data Internal
      data_a_in_scalar_multiplier <= ZERO_DATA;
      data_b_in_scalar_multiplier <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>  -- STEP 1

          if ((DATA_A_IN_ENABLE = '1') or (unsigned(index_loop) = unsigned(ZERO_CONTROL))) then
            -- Data Inputs
            data_a_in_scalar_multiplier <= DATA_A_IN;

            -- Control Internal
            data_a_in_multiplier_int <= '1';
          end if;

          if ((DATA_B_IN_ENABLE = '1') or (unsigned(index_loop) = unsigned(ZERO_CONTROL))) then
            -- Data Inputs
            data_b_in_scalar_multiplier <= DATA_B_IN;

            -- Control Internal
            data_b_in_multiplier_int <= '1';
          end if;

          if (data_a_in_multiplier_int = '1' and data_b_in_multiplier_int = '1') then
            -- Control Internal
            start_scalar_multiplier <= '1';

            data_a_in_multiplier_int <= '0';
            data_b_in_multiplier_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;
          end if;

          -- Control Outputs
          DATA_OUT_ENABLE <= '0';

        when SCALAR_MULTIPLIER_STATE =>  -- STEP 2

          if (ready_scalar_multiplier = '1') then
            -- Control Internal
            start_scalar_adder <= '1';

            operation_scalar_adder <= '0';

            -- Data Internal
            data_a_in_scalar_adder <= data_out_scalar_multiplier;
            
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              data_b_in_scalar_adder <= ZERO_DATA;
            else
              data_b_in_scalar_adder <= data_out_scalar_adder;
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_ADDER_STATE;
          else
            -- Control Internal
            start_scalar_multiplier <= '0';

            data_a_in_multiplier_int <= '0';
            data_b_in_multiplier_int <= '0';
          end if;

        when SCALAR_ADDER_STATE =>  -- STEP 3

          if (ready_scalar_adder = '1') then
            if (unsigned(index_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_adder;

              -- Control Outputs
              READY <= '1';

              -- Control Internal
              index_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= INPUT_STATE;
            end if;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';
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

end architecture;
