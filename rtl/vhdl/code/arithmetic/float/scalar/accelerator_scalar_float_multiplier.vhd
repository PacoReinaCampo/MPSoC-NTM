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

use work.accelerator_arithmetic_pkg.all;

entity accelerator_scalar_float_multiplier is
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

    -- DATA
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    OVERFLOW_OUT : out std_logic
    );
end accelerator_scalar_float_multiplier;

architecture accelerator_scalar_float_multiplier_architecture of accelerator_scalar_float_multiplier is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type multiplier_ctrl_fsm is (
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
  signal multiplier_ctrl_fsm_int : multiplier_ctrl_fsm;

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

      case multiplier_ctrl_fsm_int is
        when STARTER_STATE =>
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Data Internal
            data_a_int <= to_real(to_float(DATA_A_IN, float64'high, -float64'low));
            data_b_int <= to_real(to_float(DATA_B_IN, float64'high, -float64'low));

            -- FSM Control
            multiplier_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>

          -- Data Outputs
          DATA_OUT <= std_logic_vector(to_float(data_a_int*data_b_int, float64'high, -float64'low));

          OVERFLOW_OUT <= '0';

          -- Control Outputs
          READY <= '1';

          -- FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;

        when others =>
          -- FSM Control
          multiplier_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end accelerator_scalar_float_multiplier_architecture;
