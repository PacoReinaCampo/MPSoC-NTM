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

use work.ntm_pkg.all;

entity ntm_matrix_multiplier is
  generic (
    X : integer := 64;
    Y : integer := 64;

    DATA_SIZE : integer := 512
  );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic_matrix(X-1 downto 0)(Y-1 downto 0);

    -- DATA
    MODULO    : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_matrix_multiplier_architecture of ntm_matrix_multiplier is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type multiplier_ctrl_fsm is (
    STARTER_ST,          -- STEP 0
    SET_DATA_B_ST,       -- STEP 1
    REDUCE_DATA_B_ST,    -- STEP 2
    SET_PRODUCT_OUT_ST,  -- STEP 3
    ENDER_ST             -- STEP 4
  );

  type multiplier_ctrl_fsm_matrix is array (X-1 downto 0, Y-1 downto 0) of multiplier_ctrl_fsm;

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal multiplier_ctrl_fsm_state : multiplier_ctrl_fsm_matrix;

  -- Internal Signals
  signal u_int : std_logic_vector(DATA_SIZE downto 0);
  signal v_int : std_logic_vector(DATA_SIZE downto 0);

  signal product_int : std_logic_vector(DATA_SIZE downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  Y_LABEL : for i in Y-1 downto 0 generate
    X_LABEL : for j in X-1 downto 0 generate

      ctrl_fsm : process(CLK, RST)
      begin
        if (RST = '0') then
          -- Data Outputs
          DATA_OUT(i)(j) <= ZERO;

          -- Control Outputs
          READY(i)(j) <= '0';

          -- Assignation
          u_int <= (others => '0');
          v_int <= (others => '0');

          product_int <= (others => '0');

        elsif (rising_edge(CLK)) then

          case multiplier_ctrl_fsm_state(i,j) is
            when STARTER_ST =>          -- STEP 0
              -- Control Outputs
              READY(i)(j) <= '0';

              if (START = '1') then
                -- Assignation
                u_int <= '0' & DATA_A_IN(i)(j);
                v_int <= '0' & DATA_B_IN(i)(j);

                if (DATA_A_IN(i)(j)(0) = '1') then
                  product_int <= '0' & DATA_B_IN(i)(j);
                else
                  product_int <= (others => '0');
                end if;

                -- FSM Control
                multiplier_ctrl_fsm_state(i,j) <= SET_DATA_B_ST;
              end if;

            when SET_DATA_B_ST =>       -- STEP 1

              -- Assignation
              u_int <= std_logic_vector(unsigned(u_int) srl 1);
              v_int <= std_logic_vector(unsigned(v_int) sll 1);

              -- FSM Control
              if ((unsigned(v_int) sll 1) < '0' & unsigned(MODULO(i)(j))) then
                multiplier_ctrl_fsm_state(i,j) <= SET_PRODUCT_OUT_ST;
              else
                multiplier_ctrl_fsm_state(i,j) <= REDUCE_DATA_B_ST;
              end if;

            when REDUCE_DATA_B_ST =>    -- STEP 2

              if (unsigned(v_int) < '0' & unsigned(MODULO(i)(j))) then
                -- FSM Control
                multiplier_ctrl_fsm_state(i,j) <= SET_PRODUCT_OUT_ST;
              else
                -- Assignation
                v_int <= std_logic_vector(unsigned(v_int) - ('0' & unsigned(MODULO(i)(j))));
              end if;

            when SET_PRODUCT_OUT_ST =>  -- STEP 3

              -- Assignation
              if (u_int(0) = '1') then
                if (unsigned(product_int) + unsigned(v_int) < '0' & unsigned(MODULO(i)(j))) then
                  product_int <= std_logic_vector(unsigned(product_int) + unsigned(v_int));
                else
                  product_int <= std_logic_vector(unsigned(product_int) + unsigned(v_int) - ('0' & unsigned(MODULO(i)(j))));
                end if;
              else
                if (unsigned(product_int) >= '0' & unsigned(MODULO(i)(j))) then
                  product_int <= std_logic_vector(unsigned(product_int) - unsigned(MODULO(i)(j)));
                end if;
              end if;

              -- FSM Control
              multiplier_ctrl_fsm_state(i,j) <= ENDER_ST;

            when ENDER_ST =>            -- STEP 4

              if (unsigned(u_int) = '0' & unsigned(ONE)) then
                -- Data Outputs
                DATA_OUT(i)(j) <= product_int(DATA_SIZE-1 downto 0);

                -- Control Outputs
                READY(i)(j) <= '1';

                -- FSM Control
                multiplier_ctrl_fsm_state(i,j) <= STARTER_ST;
              else
                -- FSM Control
                multiplier_ctrl_fsm_state(i,j) <= SET_DATA_B_ST;
              end if;

            when others =>
              -- FSM Control
              multiplier_ctrl_fsm_state(i,j) <= STARTER_ST;
          end case;
        end if;
      end process;

    end generate X_LABEL;
  end generate Y_LABEL;

end architecture;
