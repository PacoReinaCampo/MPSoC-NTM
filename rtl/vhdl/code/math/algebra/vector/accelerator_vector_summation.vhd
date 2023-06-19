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

entity accelerator_vector_summation is
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

    DATA_IN_LENGTH_ENABLE : in std_logic;
    DATA_IN_ENABLE        : in std_logic;

    DATA_LENGTH_ENABLE : out std_logic;
    DATA_ENABLE        : out std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_vector_summation_architecture of accelerator_vector_summation is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type summation_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    INPUT_LENGTH_STATE,                 -- STEP 2
    ENDER_STATE,                        -- STEP 3
    ENDER_LENGTH_STATE,                 -- STEP 4
    CLEAN_STATE,                        -- STEP 5
    SCALAR_ADDER_STATE                  -- STEP 6
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
  signal summation_ctrl_fsm_int : summation_ctrl_fsm;

  -- Buffer
  signal vector_int : vector_buffer;

  -- Control Internal
  signal index_loop   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = summation(DATA_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_ENABLE        <= '0';
      DATA_LENGTH_ENABLE <= '0';

      DATA_OUT_ENABLE <= '0';

      -- Control Internal
      start_scalar_float_adder <= '0';

      operation_scalar_float_adder <= '0';

      index_loop   <= ZERO_CONTROL;
      index_l_loop <= ZERO_CONTROL;

      -- Data Internal
      data_a_in_scalar_float_adder <= ZERO_DATA;
      data_b_in_scalar_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case summation_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_ENABLE        <= '1';
            DATA_LENGTH_ENABLE <= '1';

            -- Control Internal
            index_loop   <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;

            -- FSM Control
            summation_ctrl_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            DATA_ENABLE        <= '0';
            DATA_LENGTH_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1

          if ((DATA_IN_ENABLE = '1') and (DATA_IN_LENGTH_ENABLE = '1')) then
            -- Data Inputs
            vector_int(to_integer(unsigned(index_loop))) <= DATA_IN;

            -- FSM Control
            summation_ctrl_fsm_int <= ENDER_LENGTH_STATE;
          end if;

          -- Control Outputs
          DATA_ENABLE        <= '0';
          DATA_LENGTH_ENABLE <= '0';

        when INPUT_LENGTH_STATE =>      -- STEP 2

          if (DATA_IN_LENGTH_ENABLE = '1') then
            -- Data Inputs
            vector_int(to_integer(unsigned(index_loop))) <= DATA_IN;

            -- FSM Control
            if (unsigned(index_l_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
              summation_ctrl_fsm_int <= ENDER_STATE;
            else
              summation_ctrl_fsm_int <= ENDER_LENGTH_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_ENABLE        <= '0';
          DATA_LENGTH_ENABLE <= '0';

        when ENDER_STATE =>             -- STEP 3

          if ((unsigned(index_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= vector_int(to_integer(unsigned(index_loop)));

            -- Control Internal
            index_loop   <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;

            -- FSM Control
            summation_ctrl_fsm_int <= CLEAN_STATE;
          elsif ((unsigned(index_loop) < unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= vector_int(to_integer(unsigned(index_loop)));

            -- Control Outputs
            DATA_ENABLE        <= '1';
            DATA_LENGTH_ENABLE <= '1';

            -- Control Internal
            index_loop   <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;

            -- FSM Control
            summation_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when ENDER_LENGTH_STATE =>      -- STEP 4

          if (unsigned(index_l_loop) < unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_OUT <= vector_int(to_integer(unsigned(index_loop)));

            -- Control Outputs
            DATA_LENGTH_ENABLE <= '1';

            -- Control Internal
            index_l_loop <= std_logic_vector(unsigned(index_l_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            summation_ctrl_fsm_int <= INPUT_LENGTH_STATE;
          end if;

        when CLEAN_STATE =>             -- STEP 5

          -- Data Inputs
          data_a_in_scalar_float_adder <= vector_int(to_integer(unsigned(index_loop)));

          if (unsigned(index_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            data_b_in_scalar_float_adder <= ZERO_DATA;
          else
            data_b_in_scalar_float_adder <= data_out_scalar_float_adder;
          end if;

          -- Control Outputs
          DATA_ENABLE        <= '0';
          DATA_LENGTH_ENABLE <= '0';

          DATA_OUT_ENABLE <= '0';

          -- Control Internal
          start_scalar_float_adder <= '1';

          operation_scalar_float_adder <= '0';

          -- FSM Control
          summation_ctrl_fsm_int <= SCALAR_ADDER_STATE;

        when SCALAR_ADDER_STATE =>      -- STEP 7

          if (ready_scalar_float_adder = '1') then
            if ((unsigned(index_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_float_adder;

              -- Control Outputs
              READY <= '1';

              DATA_OUT_ENABLE <= '1';

              -- Control Internal
              index_loop <= ZERO_CONTROL;

              -- FSM Control
              summation_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_loop) < unsigned(SIZE_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_float_adder;

              -- Control Outputs
              DATA_OUT_ENABLE <= '1';

              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

              -- FSM Control
              summation_ctrl_fsm_int <= CLEAN_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          summation_ctrl_fsm_int <= STARTER_STATE;
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

end architecture;
