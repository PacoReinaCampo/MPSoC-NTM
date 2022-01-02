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

entity ntm_scalar_modular_multiplier is
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
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_modular_multiplier_architecture of ntm_scalar_modular_multiplier is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type multiplier_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    SET_DATA_B_STATE,                   -- STEP 1
    REDUCE_DATA_B_STATE,                -- STEP 2
    SET_PRODUCT_OUT_STATE,              -- STEP 3
    ENDER_STATE                         -- STEP 4
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
  signal multiplier_ctrl_fsm_int : multiplier_ctrl_fsm;

  -- Internal Signals
  signal u_int : std_logic_vector(DATA_SIZE downto 0);
  signal v_int : std_logic_vector(DATA_SIZE downto 0);

  signal multiplier_int : std_logic_vector(DATA_SIZE downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN · DATA_B_IN mod MODULO_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Assignation
      u_int <= (others => '0');
      v_int <= (others => '0');

      multiplier_int <= (others => '0');

    elsif (rising_edge(CLK)) then

      case multiplier_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignation
            u_int <= '0' & DATA_A_IN;
            v_int <= '0' & DATA_B_IN;

            if (DATA_A_IN(0) = '1') then
              multiplier_int <= '0' & DATA_B_IN;
            else
              multiplier_int <= (others => '0');
            end if;

            -- FSM Control
            multiplier_ctrl_fsm_int <= SET_DATA_B_STATE;
          end if;

        when SET_DATA_B_STATE =>  -- STEP 1

          -- Assignation
          u_int <= std_logic_vector(unsigned(u_int) srl 1);
          v_int <= std_logic_vector(unsigned(v_int) sll 1);

          -- FSM Control
          if ((unsigned(v_int) sll 1) < '0' & unsigned(MODULO_IN)) then
            multiplier_ctrl_fsm_int <= SET_PRODUCT_OUT_STATE;
          else
            multiplier_ctrl_fsm_int <= REDUCE_DATA_B_STATE;
          end if;

        when REDUCE_DATA_B_STATE =>  -- STEP 2

          if (unsigned(v_int) < '0' & unsigned(MODULO_IN)) then
            -- FSM Control
            multiplier_ctrl_fsm_int <= SET_PRODUCT_OUT_STATE;
          else
            -- Assignation
            v_int <= std_logic_vector(unsigned(v_int) - ('0' & unsigned(MODULO_IN)));
          end if;

        when SET_PRODUCT_OUT_STATE =>  -- STEP 3

          -- Assignation
          if (u_int(0) = '1') then
            if (unsigned(multiplier_int) + unsigned(v_int) < '0' & unsigned(MODULO_IN)) then
              multiplier_int <= std_logic_vector(unsigned(multiplier_int) + unsigned(v_int));
            else
              multiplier_int <= std_logic_vector(unsigned(multiplier_int) + unsigned(v_int) - ('0' & unsigned(MODULO_IN)));
            end if;
          else
            if (unsigned(multiplier_int) >= '0' & unsigned(MODULO_IN)) then
              multiplier_int <= std_logic_vector(unsigned(multiplier_int) - unsigned(MODULO_IN));
            end if;
          end if;

          -- FSM Control
          multiplier_ctrl_fsm_int <= ENDER_STATE;

        when ENDER_STATE =>  -- STEP 4

          if (unsigned(u_int) = '0' & unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_OUT <= multiplier_int(DATA_SIZE-1 downto 0);

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            multiplier_ctrl_fsm_int <= STARTER_STATE;
          else
            -- FSM Control
            multiplier_ctrl_fsm_int <= SET_DATA_B_STATE;
          end if;

        when others =>
          -- FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
