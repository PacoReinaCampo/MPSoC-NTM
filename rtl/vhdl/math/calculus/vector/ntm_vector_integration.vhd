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

entity ntm_vector_integration is
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

    DATA_IN_VECTOR_ENABLE : in std_logic;
    DATA_IN_SCALAR_ENABLE : in std_logic;

    DATA_OUT_VECTOR_ENABLE : out std_logic;
    DATA_OUT_SCALAR_ENABLE : out std_logic;

    -- DATA
    SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    PERIOD_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_vector_integration_architecture of ntm_vector_integration is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type integration_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_VECTOR_STATE,                 -- STEP 1
    INPUT_SCALAR_STATE,                 -- STEP 2
    ENDER_VECTOR_STATE,                 -- STEP 3
    ENDER_SCALAR_STATE                  -- STEP 4
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
  signal integration_ctrl_fsm_int : integration_ctrl_fsm;

  -- Internal Signals
  signal index_vector_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_scalar_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- SCALAR integration
  -- CONTROL
  signal start_scalar_integration : std_logic;
  signal ready_scalar_integration : std_logic;

  signal data_in_enable_scalar_integration : std_logic;

  signal data_out_enable_scalar_integration : std_logic;

  -- DATA
  signal period_in_scalar_integration : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_integration  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT(t) = (DATA_IN(t+1) - DATA_IN(t))/PERIOD_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_VECTOR_ENABLE <= '0';
      DATA_OUT_SCALAR_ENABLE <= '0';

      -- Control Internal
      start_scalar_integration <= '0';

      index_vector_loop <= ZERO_CONTROL;
      index_scalar_loop <= ZERO_CONTROL;

      data_in_enable_scalar_integration <= '0';

      -- Data Internal
      period_in_scalar_integration <= ZERO_DATA;
      length_in_scalar_integration <= ZERO_CONTROL;
      data_in_scalar_integration   <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case integration_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_VECTOR_ENABLE <= '0';
          DATA_OUT_SCALAR_ENABLE <= '0';

          if (START = '1') then
            index_vector_loop <= ZERO_CONTROL;
            index_scalar_loop <= ZERO_CONTROL;

            -- FSM Control
            integration_ctrl_fsm_int <= INPUT_VECTOR_STATE;
          end if;

        when INPUT_VECTOR_STATE =>      -- STEP 1

          if (((DATA_IN_VECTOR_ENABLE = '1') and (DATA_IN_SCALAR_ENABLE = '1')) or (index_scalar_loop = ZERO_CONTROL)) then
            -- Data Inputs
            period_in_scalar_integration <= PERIOD_IN;
            length_in_scalar_integration <= LENGTH_IN;

            data_in_scalar_integration <= DATA_IN;

            -- Control Internal
            start_scalar_integration <= '1';

            data_in_enable_scalar_integration <= '1';

            -- FSM Control
            integration_ctrl_fsm_int <= ENDER_SCALAR_STATE;
          end if;

          -- Control Outputs
          DATA_OUT_VECTOR_ENABLE <= '0';
          DATA_OUT_SCALAR_ENABLE <= '0';

        when INPUT_SCALAR_STATE =>      -- STEP 2

          if (DATA_IN_SCALAR_ENABLE = '1') then
            -- Data Inputs
            data_in_scalar_integration <= DATA_IN;

            -- Control Internal
            data_in_enable_scalar_integration <= '1';

            -- FSM Control
            if (unsigned(index_scalar_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              integration_ctrl_fsm_int <= ENDER_VECTOR_STATE;
            else
              integration_ctrl_fsm_int <= ENDER_SCALAR_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_OUT_SCALAR_ENABLE <= '0';

        when ENDER_VECTOR_STATE =>      -- STEP 3

          if (data_out_enable_scalar_integration = '1') then
            if ((unsigned(index_vector_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_scalar_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_integration;

              -- Control Outputs
              DATA_OUT_VECTOR_ENABLE <= '1';
              DATA_OUT_SCALAR_ENABLE <= '1';

              READY <= '1';

              -- Control Internal
              index_vector_loop <= ZERO_CONTROL;
              index_scalar_loop <= ZERO_CONTROL;

              -- FSM Control
              integration_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_vector_loop) < unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_scalar_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_integration;

              -- Control Outputs
              DATA_OUT_VECTOR_ENABLE <= '1';
              DATA_OUT_SCALAR_ENABLE <= '1';

              -- Control Internal
              index_vector_loop <= std_logic_vector(unsigned(index_vector_loop) + unsigned(ONE_CONTROL));
              index_scalar_loop <= ZERO_CONTROL;

              -- FSM Control
              integration_ctrl_fsm_int <= INPUT_VECTOR_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_integration <= '0';

            data_in_enable_scalar_integration <= '0';
          end if;

        when ENDER_SCALAR_STATE =>      -- STEP 4

          if (data_out_enable_scalar_integration = '1') then
            if (unsigned(index_scalar_loop) < unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_integration;

              -- Control Outputs
              DATA_OUT_SCALAR_ENABLE <= '1';

              -- Control Internal
              index_scalar_loop <= std_logic_vector(unsigned(index_scalar_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              integration_ctrl_fsm_int <= INPUT_SCALAR_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_integration <= '0';

            data_in_enable_scalar_integration <= '0';
          end if;

        when others =>
          -- FSM Control
          integration_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR integration
  scalar_integration : ntm_scalar_integration
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_integration,
      READY => ready_scalar_integration,

      DATA_IN_ENABLE => data_in_enable_scalar_integration,

      DATA_OUT_ENABLE => data_out_enable_scalar_integration,

      -- DATA
      PERIOD_IN => period_in_scalar_integration,
      LENGTH_IN => length_in_scalar_integration,
      DATA_IN   => data_in_scalar_integration,
      DATA_OUT  => data_out_scalar_integration
      );

end architecture;
