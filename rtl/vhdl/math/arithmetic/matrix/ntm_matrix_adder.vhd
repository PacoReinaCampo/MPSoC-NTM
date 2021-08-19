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

entity ntm_matrix_adder is
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

    OPERATION : in std_logic_matrix(X-1 downto 0)(Y-1 downto 0);

    -- DATA
    MODULO    : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_matrix_adder_architecture of ntm_matrix_adder is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type adder_ctrl_fsm is (
    STARTER_ST,  -- STEP 0
    ENDER_ST     -- STEP 1
  );

  type adder_ctrl_fsm_matrix is array (X-1 downto 0, Y-1 downto 0) of adder_ctrl_fsm;

  type std_logic_matrix_of_vector is array (X-1 downto 0, Y-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal adder_ctrl_fsm_state : adder_ctrl_fsm_matrix;

  -- Internal Signals
  signal arithmetic_int : std_logic_matrix_of_vector;

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

          -- Assignations
          arithmetic_int(i,j) <= (others => '0');

        elsif (rising_edge(CLK)) then

          case adder_ctrl_fsm_state(i,j) is
            when STARTER_ST =>          -- STEP 0
              -- Control Outputs
              READY(i)(j) <= '0';

              if (START = '1') then
                -- Assignations
                if (OPERATION(i)(j) = '1') then
                  if (unsigned(DATA_A_IN(i)(j)) > unsigned(DATA_B_IN(i)(j))) then
                    arithmetic_int(i,j) <= std_logic_vector(('0' & unsigned(DATA_A_IN(i)(j))) - ('0' & unsigned(DATA_B_IN(i)(j))));
                  else
                    arithmetic_int(i,j) <= std_logic_vector(('0' & unsigned(DATA_B_IN(i)(j))) - ('0' & unsigned(DATA_A_IN(i)(j))));
                  end if;
                else
                  arithmetic_int(i,j) <= std_logic_vector(('0' & unsigned(DATA_A_IN(i)(j))) + ('0' & unsigned(DATA_B_IN(i)(j))));
                end if;

                -- FSM Control
                adder_ctrl_fsm_state(i,j) <= ENDER_ST;
              end if;

            when ENDER_ST =>            -- STEP 1

              if (unsigned(MODULO(i)(j)) > unsigned(ZERO)) then
                if (unsigned(DATA_A_IN(i)(j)) > unsigned(DATA_B_IN(i)(j))) then
                  if (unsigned(arithmetic_int(i,j)) = '0' & unsigned(MODULO(i)(j))) then
                    -- Data Outputs
                    DATA_OUT(i)(j) <= ZERO;

                    -- Control Outputs
                    READY(i)(j) <= '1';

                    -- FSM Control
                    adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                  elsif (unsigned(arithmetic_int(i,j)) < '0' & unsigned(MODULO(i)(j))) then
                    -- Data Outputs
                    DATA_OUT(i)(j) <= arithmetic_int(i,j)(DATA_SIZE-1 downto 0);

                    -- Control Outputs
                    READY(i)(j) <= '1';

                    -- FSM Control
                    adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                  else
                    -- Assignations
                    arithmetic_int(i,j) <= std_logic_vector(unsigned(arithmetic_int(i,j)) - ('0' & unsigned(MODULO(i)(j))));
                  end if;
                elsif (unsigned(DATA_A_IN(i)(j)) = unsigned(DATA_B_IN(i)(j))) then
                  if (OPERATION(i)(j) = '1') then
                    -- Data Outputs
                    DATA_OUT(i)(j) <= ZERO;

                    -- Control Outputs
                    READY(i)(j) <= '1';

                    -- FSM Control
                    adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                  else
                    if (unsigned(arithmetic_int(i,j)) = '0' & unsigned(MODULO(i)(j))) then
                      -- Data Outputs
                      DATA_OUT(i)(j) <= ZERO;

                      -- Control Outputs
                      READY(i)(j) <= '1';

                      -- FSM Control
                      adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                    elsif (unsigned(arithmetic_int(i,j)) < '0' & unsigned(MODULO(i)(j))) then
                      -- Data Outputs
                      DATA_OUT(i)(j) <= arithmetic_int(i,j)(DATA_SIZE-1 downto 0);

                      -- Control Outputs
                      READY(i)(j) <= '1';

                      -- FSM Control
                      adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                    else
                      -- Assignations
                      arithmetic_int(i,j) <= std_logic_vector(unsigned(arithmetic_int(i,j)) - ('0' & unsigned(MODULO(i)(j))));
                    end if;
                  end if;
                elsif (unsigned(DATA_A_IN(i)(j)) < unsigned(DATA_B_IN(i)(j))) then
                  if (OPERATION(i)(j) = '1') then
                    if (unsigned(arithmetic_int(i,j)) = '0' & unsigned(MODULO(i)(j))) then
                      -- Data Outputs
                      DATA_OUT(i)(j) <= ZERO;

                      -- Control Outputs
                      READY(i)(j) <= '1';

                      -- FSM Control
                      adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                    elsif (unsigned(arithmetic_int(i,j)) < '0' & unsigned(MODULO(i)(j))) then
                      -- Data Outputs
                      DATA_OUT(i)(j) <= std_logic_vector(unsigned(MODULO(i)(j)) - unsigned(arithmetic_int(i,j)(DATA_SIZE-1 downto 0)));

                      -- Control Outputs
                      READY(i)(j) <= '1';

                      -- FSM Control
                      adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                    else
                      -- Assignations
                      arithmetic_int(i,j) <= std_logic_vector(unsigned(arithmetic_int(i,j)) - ('0' & unsigned(MODULO(i)(j))));
                    end if;
                  else
                    if (unsigned(arithmetic_int(i,j)) = '0' & unsigned(MODULO(i)(j))) then
                      -- Data Outputs
                      DATA_OUT(i)(j) <= ZERO;

                      -- Control Outputs
                      READY(i)(j) <= '1';

                      -- FSM Control
                      adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                    elsif (unsigned(arithmetic_int(i,j)) < '0' & unsigned(MODULO(i)(j))) then
                      -- Data Outputs
                      DATA_OUT(i)(j) <= arithmetic_int(i,j)(DATA_SIZE-1 downto 0);

                      -- Control Outputs
                      READY(i)(j) <= '1';

                      -- FSM Control
                      adder_ctrl_fsm_state(i,j) <= STARTER_ST;
                    else
                      -- Assignations
                      arithmetic_int(i,j) <= std_logic_vector(unsigned(arithmetic_int(i,j)) - ('0' & unsigned(MODULO(i)(j))));
                    end if;
                  end if;
                end if;
              elsif (unsigned(MODULO(i)(j)) = unsigned(ZERO)) then
                -- Data Outputs
                DATA_OUT(i)(j) <= arithmetic_int(i,j)(DATA_SIZE-1 downto 0);

                -- Control Outputs
                READY(i)(j) <= '1';

                -- FSM Control
                adder_ctrl_fsm_state(i,j) <= STARTER_ST;
              end if;

            when others =>
              -- FSM Control
              adder_ctrl_fsm_state(i,j) <= STARTER_ST;
          end case;
        end if;
      end process;

    end generate X_LABEL;
  end generate Y_LABEL;

end architecture;
