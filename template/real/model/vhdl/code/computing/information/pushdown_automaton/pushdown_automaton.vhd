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

use ieee.math_real.all;
use ieee.float_pkg.all;

use work.accelerator_template_pkg.all;

entity accelerator_template is
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
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_X_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_template_architecture of accelerator_template is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type template_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    FIRST_STATE,                        -- STEP 1
    SECOND_STATE,                       -- STEP 2
    THIRD_STATE,                        -- STEP 3
    ENDER_STATE                         -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(0.0, float64'high, -float64'low));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(1.0, float64'high, -float64'low));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(2.0, float64'high, -float64'low));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(3.0, float64'high, -float64'low));

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal template_ctrl_fsm_int : template_ctrl_fsm;

  -- Data Internal
  signal variable_u_int : std_logic_vector(DATA_SIZE downto 0);
  signal variable_v_int : std_logic_vector(DATA_SIZE downto 0);

  signal template_int : std_logic_vector(DATA_SIZE downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN · DATA_B_IN mod DATA_X_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Assignation
      variable_u_int <= (others => '0');
      variable_v_int <= (others => '0');

      template_int <= (others => '0');

    elsif (rising_edge(CLK)) then

      case template_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignation
            variable_u_int <= '0' & DATA_A_IN;
            variable_v_int <= '0' & DATA_B_IN;

            if (DATA_A_IN(0) = '1') then
              template_int <= '0' & DATA_B_IN;
            else
              template_int <= (others => '0');
            end if;

            -- FSM Control
            template_ctrl_fsm_int <= FIRST_STATE;
          end if;

        when FIRST_STATE =>             -- STEP 1

          -- Assignation
          variable_u_int <= std_logic_vector(unsigned(variable_u_int) srl 1);
          variable_v_int <= std_logic_vector(unsigned(variable_v_int) sll 1);

          -- FSM Control
          if ((unsigned(variable_v_int) sll 1) < '0' & unsigned(DATA_X_IN)) then
            template_ctrl_fsm_int <= THIRD_STATE;
          else
            template_ctrl_fsm_int <= SECOND_STATE;
          end if;

        when SECOND_STATE =>            -- STEP 2

          if (unsigned(variable_v_int) < '0' & unsigned(DATA_X_IN)) then
            -- FSM Control
            template_ctrl_fsm_int <= THIRD_STATE;
          else
            -- Assignation
            variable_v_int <= std_logic_vector(unsigned(variable_v_int) - ('0' & unsigned(DATA_X_IN)));
          end if;

        when THIRD_STATE =>             -- STEP 3

          -- Assignation
          if (variable_u_int(0) = '1') then
            if (unsigned(template_int) + unsigned(variable_v_int) < '0' & unsigned(DATA_X_IN)) then
              template_int <= std_logic_vector(unsigned(template_int) + unsigned(variable_v_int));
            else
              template_int <= std_logic_vector(unsigned(template_int) + unsigned(variable_v_int) - ('0' & unsigned(DATA_X_IN)));
            end if;
          else
            if (unsigned(template_int) >= '0' & unsigned(DATA_X_IN)) then
              template_int <= std_logic_vector(unsigned(template_int) - unsigned(DATA_X_IN));
            end if;
          end if;

          -- FSM Control
          template_ctrl_fsm_int <= ENDER_STATE;

        when ENDER_STATE =>             -- STEP 4

          if (unsigned(variable_u_int) = '0' & unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_OUT <= template_int(DATA_SIZE-1 downto 0);

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            template_ctrl_fsm_int <= STARTER_STATE;
          else
            -- FSM Control
            template_ctrl_fsm_int <= FIRST_STATE;
          end if;

        when others =>
          -- FSM Control
          template_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
