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

entity accelerator_scalar_integer_divider is
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

    -- DATA
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT      : out std_logic_vector(DATA_SIZE-1 downto 0);
    REMAINDER_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_scalar_integer_divider_architecture of accelerator_scalar_integer_divider is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type divider_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    ENDER_STATE                         -- STEP 1
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal divider_ctrl_fsm_int : divider_ctrl_fsm;

  -- Data Internal
  signal divider_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- Control Internal
  signal index_loop : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN / DATA_B_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT      <= ZERO_IDATA;
      REMAINDER_OUT <= ZERO_IDATA;

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      divider_int <= ZERO_IDATA;

      -- Control Internal
      index_loop <= ZERO_IDATA;

    elsif (rising_edge(CLK)) then

      case divider_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Data Internal
            divider_int <= ZERO_IDATA;

            -- Control Internal
            index_loop <= DATA_A_IN;

            -- FSM Control
            divider_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>             -- STEP 1

          if (signed(DATA_B_IN) = signed(ZERO_IDATA)) then
            -- Data Outputs
            DATA_OUT      <= ONE_IDATA;
            REMAINDER_OUT <= ZERO_IDATA;

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            divider_ctrl_fsm_int <= STARTER_STATE;
          elsif (DATA_A_IN(DATA_SIZE-1) = '0' and DATA_B_IN(DATA_SIZE-1) = '0') then
            if (signed(DATA_B_IN) > signed(index_loop)) then
              -- Data Outputs
              DATA_OUT      <= divider_int;
              REMAINDER_OUT <= index_loop;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              divider_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Data Internal
              divider_int <= std_logic_vector(signed(divider_int) + signed(ONE_IDATA));

              -- Control Internal
              index_loop <= std_logic_vector(signed(index_loop) - signed(DATA_B_IN));
            end if;
          elsif (DATA_A_IN(DATA_SIZE-1) = '1' and DATA_B_IN(DATA_SIZE-1) = '0') then
            if (signed(index_loop)+signed(DATA_B_IN) > signed(ZERO_IDATA)) then
              -- Data Outputs
              DATA_OUT      <= divider_int;
              REMAINDER_OUT <= index_loop;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              divider_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Data Internal
              divider_int <= std_logic_vector(signed(divider_int) - signed(ONE_IDATA));

              -- Control Internal
              index_loop <= std_logic_vector(signed(index_loop) + signed(DATA_B_IN));
            end if;
          elsif (DATA_A_IN(DATA_SIZE-1) = '0' and DATA_B_IN(DATA_SIZE-1) = '1') then
            if (signed(index_loop)+signed(DATA_B_IN) < signed(ZERO_IDATA)) then
              -- Data Outputs
              DATA_OUT      <= divider_int;
              REMAINDER_OUT <= index_loop;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              divider_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Data Internal
              divider_int <= std_logic_vector(signed(divider_int) - signed(ONE_IDATA));

              -- Control Internal
              index_loop <= std_logic_vector(signed(index_loop) + signed(DATA_B_IN));
            end if;
          elsif (DATA_A_IN(DATA_SIZE-1) = '1' and DATA_B_IN(DATA_SIZE-1) = '1') then
            if (signed(DATA_B_IN) < signed(index_loop)) then
              -- Data Outputs
              DATA_OUT      <= divider_int;
              REMAINDER_OUT <= index_loop;

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              divider_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Data Internal
              divider_int <= std_logic_vector(signed(divider_int) + signed(ONE_IDATA));

              -- Control Internal
              index_loop <= std_logic_vector(signed(index_loop) - signed(DATA_B_IN));
            end if;
          end if;

        when others =>
          -- FSM Control
          divider_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
