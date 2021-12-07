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

entity ntm_scalar_adder is
  generic (
    DATA_SIZE  : integer := 512;
    INDEX_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    OPERATION : in std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_adder_architecture of ntm_scalar_adder is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type adder_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    ENDER_STATE                         -- STEP 1
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_INDEX : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_INDEX  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal adder_ctrl_fsm_int : adder_ctrl_fsm;

  -- Internal Signals
  signal adder_int : std_logic_vector(DATA_SIZE downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_B_IN + DATA_A_IN mod MODULO_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      adder_int <= (others => '0');

    elsif (rising_edge(CLK)) then

      case adder_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignations
            if (OPERATION = '1') then
              if (unsigned(DATA_A_IN) > unsigned(DATA_B_IN)) then
                adder_int <= std_logic_vector(('0' & unsigned(DATA_A_IN)) - ('0' & unsigned(DATA_B_IN)));
              else
                adder_int <= std_logic_vector(('0' & unsigned(DATA_B_IN)) - ('0' & unsigned(DATA_A_IN)));
              end if;
            else
              adder_int <= std_logic_vector(('0' & unsigned(DATA_A_IN)) + ('0' & unsigned(DATA_B_IN)));
            end if;

            -- FSM Control
            adder_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>  -- STEP 1

          if (unsigned(MODULO_IN) > unsigned(ZERO)) then
            if (unsigned(DATA_A_IN) > unsigned(DATA_B_IN)) then
              if (unsigned(adder_int) = '0' & unsigned(MODULO_IN)) then
                -- Data Outputs
                DATA_OUT <= ZERO;

                -- Control Outputs
                READY <= '1';

                -- FSM Control
                adder_ctrl_fsm_int <= STARTER_STATE;
              elsif (unsigned(adder_int) < '0' & unsigned(MODULO_IN)) then
                -- Data Outputs
                DATA_OUT <= adder_int(DATA_SIZE-1 downto 0);

                -- Control Outputs
                READY <= '1';

                -- FSM Control
                adder_ctrl_fsm_int <= STARTER_STATE;
              else
                -- Assignations
                adder_int <= std_logic_vector(unsigned(adder_int) - ('0' & unsigned(MODULO_IN)));
              end if;
            elsif (unsigned(DATA_A_IN) = unsigned(DATA_B_IN)) then
              if (OPERATION = '1') then
                -- Data Outputs
                DATA_OUT <= ZERO;

                -- Control Outputs
                READY <= '1';

                -- FSM Control
                adder_ctrl_fsm_int <= STARTER_STATE;
              else
                if (unsigned(adder_int) = '0' & unsigned(MODULO_IN)) then
                  -- Data Outputs
                  DATA_OUT <= ZERO;

                  -- Control Outputs
                  READY <= '1';

                  -- FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                elsif (unsigned(adder_int) < '0' & unsigned(MODULO_IN)) then
                  -- Data Outputs
                  DATA_OUT <= adder_int(DATA_SIZE-1 downto 0);

                  -- Control Outputs
                  READY <= '1';

                  -- FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                else
                  -- Assignations
                  adder_int <= std_logic_vector(unsigned(adder_int) - ('0' & unsigned(MODULO_IN)));
                end if;
              end if;
            elsif (unsigned(DATA_A_IN) < unsigned(DATA_B_IN)) then
              if (OPERATION = '1') then
                if (unsigned(adder_int) = '0' & unsigned(MODULO_IN)) then
                  -- Data Outputs
                  DATA_OUT <= ZERO;

                  -- Control Outputs
                  READY <= '1';

                  -- FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                elsif (unsigned(adder_int) < '0' & unsigned(MODULO_IN)) then
                  -- Data Outputs
                  DATA_OUT <= std_logic_vector(unsigned(MODULO_IN) - unsigned(adder_int(DATA_SIZE-1 downto 0)));

                  -- Control Outputs
                  READY <= '1';

                  -- FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                else
                  -- Assignations
                  adder_int <= std_logic_vector(unsigned(adder_int) - ('0' & unsigned(MODULO_IN)));
                end if;
              else
                if (unsigned(adder_int) = '0' & unsigned(MODULO_IN)) then
                  -- Data Outputs
                  DATA_OUT <= ZERO;

                  -- Control Outputs
                  READY <= '1';

                  -- FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                elsif (unsigned(adder_int) < '0' & unsigned(MODULO_IN)) then
                  -- Data Outputs
                  DATA_OUT <= adder_int(DATA_SIZE-1 downto 0);

                  -- Control Outputs
                  READY <= '1';

                  -- FSM Control
                  adder_ctrl_fsm_int <= STARTER_STATE;
                else
                  -- Assignations
                  adder_int <= std_logic_vector(unsigned(adder_int) - ('0' & unsigned(MODULO_IN)));
                end if;
              end if;
            end if;
          elsif (unsigned(MODULO_IN) = unsigned(ZERO)) then
            -- Data Outputs
            DATA_OUT <= adder_int(DATA_SIZE-1 downto 0);

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            adder_ctrl_fsm_int <= STARTER_STATE;
          end if;

        when others =>
          -- FSM Control
          adder_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
