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

entity ntm_scalar_inverter is
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
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_inverter_architecture of ntm_scalar_inverter is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type inverter_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    ENDER_STATE,                        -- STEP 1
    CHECK_U_STATE,                      -- STEP 2
    CHECK_V_STATE,                      -- STEP 3
    CHECK_D_STATE                       -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_DATA : std_logic_vector(DATA_SIZE downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE+1));
  constant ONE_DATA  : std_logic_vector(DATA_SIZE downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE+1));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal inverter_ctrl_fsm_int : inverter_ctrl_fsm;

  -- Internal Signals
  signal u_int : std_logic_vector(DATA_SIZE downto 0);
  signal v_int : std_logic_vector(DATA_SIZE downto 0);

  signal x_int : std_logic_vector(DATA_SIZE downto 0);
  signal y_int : std_logic_vector(DATA_SIZE downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = 1 / DATA_IN  = 1 / M_IN · 2^(E_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= (others => '0');

      -- Control Outputs
      READY <= '0';

      -- Assignation
      u_int <= ZERO_DATA;
      v_int <= ZERO_DATA;

      x_int <= ZERO_DATA;
      y_int <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case inverter_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignation
            u_int <= '0' & DATA_IN;
            v_int <= '0' & MODULO_IN;

            x_int <= ONE_DATA;
            y_int <= ZERO_DATA;

            -- FSM Control
            inverter_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>  -- STEP 1

          if(unsigned(u_int) = unsigned(ONE_DATA)) then
            if (unsigned(x_int) < '0' & unsigned(MODULO_IN)) then
              -- Data Outputs
              DATA_OUT <= x_int(DATA_SIZE-1 downto 0);

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              inverter_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Assignations
              x_int <= std_logic_vector(unsigned(x_int) - ('0' & unsigned(MODULO_IN)));
            end if;
          elsif(unsigned(v_int) = unsigned(ONE_DATA)) then
            if (unsigned(y_int) < '0' & unsigned(MODULO_IN)) then
              -- Data Outputs
              DATA_OUT <= y_int(DATA_SIZE-1 downto 0);

              -- Control Outputs
              READY <= '1';

              -- FSM Control
              inverter_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Assignations
              y_int <= std_logic_vector(unsigned(y_int) - ('0' & unsigned(MODULO_IN)));
            end if;
          elsif(u_int(0) = '0') then
            -- FSM Control
            inverter_ctrl_fsm_int <= CHECK_U_STATE;
          elsif(v_int(0) = '0') then
            -- FSM Control
            inverter_ctrl_fsm_int <= CHECK_V_STATE;
          else
            -- FSM Control
            inverter_ctrl_fsm_int <= CHECK_D_STATE;
          end if;

        when CHECK_U_STATE =>  -- STEP 2

          -- Assignation
          u_int <= std_logic_vector(unsigned(u_int) srl 1);

          if(x_int(0) = '0') then
            x_int <= std_logic_vector(unsigned(x_int) srl 1);
          else
            x_int <= std_logic_vector(unsigned(x_int) + ('0' & unsigned(MODULO_IN)) srl 1);
          end if;

          -- FSM Control
          if(v_int(0) = '0') then
            inverter_ctrl_fsm_int <= CHECK_V_STATE;
          else
            inverter_ctrl_fsm_int <= CHECK_D_STATE;
          end if;

        when CHECK_V_STATE =>  -- STEP 3

          -- Assignation
          v_int <= std_logic_vector(unsigned(v_int) srl 1);

          if(y_int(0) = '0') then
            y_int <= std_logic_vector(unsigned(y_int) srl 1);
          else
            y_int <= std_logic_vector(unsigned(y_int) + ('0' & unsigned(MODULO_IN)) srl 1);
          end if;

          -- FSM Control
          inverter_ctrl_fsm_int <= CHECK_D_STATE;

        when CHECK_D_STATE =>  -- STEP 4

          -- Assignation
          if(unsigned(u_int) < unsigned(v_int)) then
            v_int <= std_logic_vector(unsigned(v_int) - unsigned(u_int));

            if (unsigned(y_int) > unsigned(x_int)) then
              y_int <= std_logic_vector(unsigned(y_int) - unsigned(x_int));
            else
              y_int <= std_logic_vector(unsigned(y_int) - unsigned(x_int) + ('0' & unsigned(MODULO_IN)));
            end if;
          else
            u_int <= std_logic_vector(unsigned(u_int) - unsigned(v_int));

            if (unsigned(x_int) > unsigned(y_int)) then
              x_int <= std_logic_vector(unsigned(x_int) - unsigned(y_int));
            else
              x_int <= std_logic_vector(unsigned(x_int) - unsigned(y_int) + ('0' & unsigned(MODULO_IN)));
            end if;
          end if;

          -- FSM Control
          inverter_ctrl_fsm_int <= ENDER_STATE;

        when others =>
          -- FSM Control
          inverter_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;