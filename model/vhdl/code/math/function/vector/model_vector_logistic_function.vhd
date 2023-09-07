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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;

entity model_vector_logistic_function is
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

    DATA_IN_ENABLE : in std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_vector_logistic_function_architecture of model_vector_logistic_function is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type logistic_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    ENDER_STATE                         -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal logistic_ctrl_fsm_int : logistic_ctrl_fsm;

  -- Data Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- SCALAR LOGISTIC
  -- CONTROL
  signal start_scalar_logistic_function : std_logic;
  signal ready_scalar_logistic_function : std_logic;

  -- DATA
  signal data_in_scalar_logistic_function  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logistic_function : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = 1/(1 + inverter(exponentiation(DATA_IN)))

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
      start_scalar_logistic_function <= '0';

      index_loop <= ZERO_CONTROL;

      -- Data Internal
      data_in_scalar_logistic_function <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case logistic_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_OUT_ENABLE <= '1';

            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            logistic_ctrl_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            DATA_OUT_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (DATA_IN_ENABLE = '1') then
            -- Data Inputs
            data_in_scalar_logistic_function <= DATA_IN;

            -- Control Internal
            start_scalar_logistic_function <= '1';

            -- FSM Control
            logistic_ctrl_fsm_int <= ENDER_STATE;
          end if;

          -- Control Outputs
          DATA_OUT_ENABLE <= '0';

        when ENDER_STATE =>             -- STEP 2

          if (ready_scalar_logistic_function = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_IN)-unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- Control Internal
              index_loop <= ZERO_CONTROL;

              -- FSM Control
              logistic_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

              -- FSM Control
              logistic_ctrl_fsm_int <= INPUT_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_scalar_logistic_function;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';
          else
            -- Control Internal
            start_scalar_logistic_function <= '0';
          end if;

        when others =>
          -- FSM Control
          logistic_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR LOGISTIC
  scalar_logistic_function : model_scalar_logistic_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_logistic_function,
      READY => ready_scalar_logistic_function,

      -- DATA
      DATA_IN  => data_in_scalar_logistic_function,
      DATA_OUT => data_out_scalar_logistic_function
      );

end architecture;
