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

-- Copyright (c) 2023-2024 by the author(s)
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

use work.computing_pkg.all;

entity logic_circuits is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    OPERATION : in std_logic_vector(3 downto 0);

    -- DATA
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture logic_circuits_architecture of logic_circuits is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = function(DATA_A_IN, DATA_B_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;
    elsif (rising_edge(CLK)) then

      case OPERATION is
        when "0000" =>                  -- STEP 0
          -- Control Outputs
          DATA_OUT <= ZERO_DATA;
        when "0001" =>                  -- STEP 1
          -- Data Outputs
          DATA_OUT <= DATA_A_IN and DATA_B_IN;
        when "0010" =>                  -- STEP 2
          -- Data Outputs
          DATA_OUT <= DATA_A_IN and not DATA_B_IN;
        when "0011" =>                  -- STEP 3
          -- Data Outputs
          DATA_OUT <= DATA_A_IN
        when "0100" =>                  -- STEP 4
          -- Data Outputs
          DATA_OUT <= not DATA_A_IN and DATA_B_IN;
        when "0101" =>                  -- STEP 5
          -- Data Outputs
          DATA_OUT <= DATA_B_IN;
        when "0110" =>                  -- STEP 6
          -- Data Outputs
          DATA_OUT <= DATA_A_IN xor DATA_B_IN;
        when "0111" =>                  -- STEP 7
          -- Data Outputs
          DATA_OUT <= DATA_A_IN or DATA_B_IN;
        when "1000" =>                  -- STEP 8
          -- Data Outputs
          DATA_OUT <= DATA_A_IN nor DATA_B_IN;
        when "1001" =>                  -- STEP 9
          -- Data Outputs
          DATA_OUT <= DATA_A_IN xnor DATA_B_IN;
        when "1010" =>                  -- STEP 10
          -- Data Outputs
          DATA_OUT <= not DATA_B_IN;
        when "1011" =>                  -- STEP 11
          -- Data Outputs
          DATA_OUT <= not DATA_B_IN or DATA_A_IN;
        when "1100" =>                  -- STEP 12
          -- Data Outputs
          DATA_OUT <= not DATA_A_IN;
        when "1101" =>                  -- STEP 13
          -- Data Outputs
          DATA_OUT <= not DATA_A_IN or DATA_B_IN;
        when "1110" =>                  -- STEP 14
          -- Data Outputs
          DATA_OUT <= DATA_A_IN nand DATA_B_IN;
        when "1111" =>                  -- STEP 15
          -- Data Outputs
          DATA_OUT <= FULL_DATA;
        when others =>
          -- FSM Control
          DATA_OUT <= ZERO_DATA;
      end case;
    end if;
  end process;

end architecture;
