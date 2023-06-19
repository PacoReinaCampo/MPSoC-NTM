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

entity accelerator_vector_integration is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_IN_ENABLE : in std_logic;

    DATA_ENABLE : out std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_vector_integration_architecture of accelerator_vector_integration is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type integration_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    ENDER_STATE,                        -- STEP 2
    CLEAN_STATE,                        -- STEP 3
    SCALAR_MULTIPLIER_STATE,            -- STEP 4
    SCALAR_ADDER_STATE                  -- STEP 5
    );

  -- Buffer
  type vector_buffer is array (CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal integration_ctrl_fsm_int : integration_ctrl_fsm;

  -- Buffer
  signal vector_int : vector_buffer;

  -- Control Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_adder : std_logic;

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_float_multiplier : std_logic;
  signal ready_scalar_float_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_multiplier : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = integration(DATA_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_ENABLE <= '0';

      DATA_OUT_ENABLE <= '0';

      -- Control Internal
      start_scalar_float_adder      <= '0';
      start_scalar_float_multiplier <= '0';

      operation_scalar_float_adder <= '0';

      index_loop <= ZERO_CONTROL;

      -- Data Internal
      data_a_in_scalar_float_adder <= ZERO_DATA;
      data_b_in_scalar_float_adder <= ZERO_DATA;

      data_a_in_scalar_float_multiplier <= ZERO_DATA;
      data_b_in_scalar_float_multiplier <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case integration_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_ENABLE <= '1';

            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            integration_ctrl_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            DATA_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (DATA_IN_ENABLE = '1') then
            -- Data Inputs
            vector_int(to_integer(unsigned(index_loop))) <= DATA_IN;

            -- FSM Control
            integration_ctrl_fsm_int <= ENDER_STATE;
          end if;

          -- Control Outputs
          DATA_ENABLE <= '0';

        when ENDER_STATE =>             -- STEP 2

          if (unsigned(index_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            integration_ctrl_fsm_int <= CLEAN_STATE;
          else
            -- Control Internal
            index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

            -- Control Outputs
            DATA_ENABLE <= '1';

            -- FSM Control
            integration_ctrl_fsm_int <= INPUT_STATE;
          end if;

          -- Data Outputs
          DATA_OUT <= vector_int(to_integer(unsigned(index_loop)));

        when CLEAN_STATE =>             -- STEP 3

          -- Data Inputs
          data_a_in_scalar_float_multiplier <= vector_int(to_integer(unsigned(index_loop)));
          data_b_in_scalar_float_multiplier <= LENGTH_IN;

          -- Control Outputs
          DATA_ENABLE <= '0';

          DATA_OUT_ENABLE <= '0';

          -- Control Internal
          start_scalar_float_multiplier <= '1';

          -- FSM Control
          integration_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;

        when SCALAR_MULTIPLIER_STATE =>  -- STEP 4

          if (ready_scalar_float_multiplier = '1') then
            -- Data Inputs
            data_a_in_scalar_float_adder <= data_out_scalar_float_multiplier;

            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              data_b_in_scalar_float_adder <= ZERO_DATA;
            else
              data_b_in_scalar_float_adder <= data_out_scalar_float_adder;
            end if;

            -- Control Internal
            start_scalar_float_adder <= '1';

            operation_scalar_float_adder <= '0';

            -- FSM Control
            integration_ctrl_fsm_int <= SCALAR_ADDER_STATE;
          else
            -- Control Internal
            start_scalar_float_multiplier <= '0';
          end if;

        when SCALAR_ADDER_STATE =>      -- STEP 5

          if (ready_scalar_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- Control Internal
              index_loop <= ZERO_CONTROL;

              -- FSM Control
              integration_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

              -- FSM Control
              integration_ctrl_fsm_int <= CLEAN_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_scalar_float_adder;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          integration_ctrl_fsm_int <= STARTER_STATE;
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

      DATA_OUT     => data_out_scalar_float_adder,
      OVERFLOW_OUT => overflow_out_scalar_float_adder
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

      DATA_OUT     => data_out_scalar_float_multiplier,
      OVERFLOW_OUT => overflow_out_scalar_float_multiplier
      );

end architecture;
