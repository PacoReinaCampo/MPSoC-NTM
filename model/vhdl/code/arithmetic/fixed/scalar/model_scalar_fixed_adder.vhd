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
use ieee.fixed_pkg.all;

use work.model_arithmetic_pkg.all;

entity model_scalar_fixed_adder is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port(
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    OPERATION : in std_logic;

    -- DATA
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    OVERFLOW_OUT : out std_logic
    );
end model_scalar_fixed_adder;

architecture model_scalar_fixed_adder_architecture of model_scalar_fixed_adder is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type adder_ctrl_fsm is (
    STARTER_STATE,
    ENDER_STATE
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal adder_ctrl_fsm_int : adder_ctrl_fsm;

  -- Data Internal
  signal data_a_int : real;
  signal data_b_int : real;

begin

  ctrl_fsm : process (CLK, RST)
  begin
    if(RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      OVERFLOW_OUT <= '0';

      -- Control Outputs
      READY <= '0';

      -- Data Internal
      data_a_int <= ZERO_REAL;
      data_b_int <= ZERO_REAL;

    elsif rising_edge(CLK) then

      case adder_ctrl_fsm_int is
        when STARTER_STATE =>
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Data Internal
            data_a_int <= to_real(to_sfixed(DATA_A_IN, DATA_SIZE-1, 0));
            data_b_int <= to_real(to_sfixed(DATA_B_IN, DATA_SIZE-1, 0));

            -- FSM Control
            adder_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>

          -- Data Outputs
          if (OPERATION = '1') then
            DATA_OUT <= std_logic_vector(to_sfixed(data_a_int-data_b_int, DATA_SIZE-1, 0));
          else
            DATA_OUT <= std_logic_vector(to_sfixed(data_a_int+data_b_int, DATA_SIZE-1, 0));
          end if;

          OVERFLOW_OUT <= '0';

          -- Control Outputs
          READY <= '1';

          -- FSM Control
          adder_ctrl_fsm_int <= STARTER_STATE;

        when others =>
          -- FSM Control
          adder_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end model_scalar_fixed_adder_architecture;
