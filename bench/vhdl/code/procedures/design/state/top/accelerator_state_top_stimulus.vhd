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

use work.accelerator_arithmetic_vhdl_pkg.all;
use work.accelerator_math_vhdl_pkg.all;
use work.accelerator_state_top_pkg.all;

entity accelerator_state_top_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -- CONTROL
    ACCELERATOR_STATE_TOP_START : out std_logic;
    ACCELERATOR_STATE_TOP_READY : in  std_logic;

    ACCELERATOR_STATE_TOP_DATA_A_IN_I_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_A_IN_J_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_B_IN_I_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_B_IN_J_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_C_IN_I_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_C_IN_J_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_D_IN_I_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_D_IN_J_ENABLE : out std_logic;

    ACCELERATOR_STATE_TOP_DATA_K_IN_I_ENABLE : out std_logic;
    ACCELERATOR_STATE_TOP_DATA_K_IN_J_ENABLE : out std_logic;

    ACCELERATOR_STATE_TOP_DATA_K_I_ENABLE : in std_logic;
    ACCELERATOR_STATE_TOP_DATA_K_J_ENABLE : in std_logic;

    ACCELERATOR_STATE_TOP_DATA_U_IN_ENABLE : out std_logic;

    ACCELERATOR_STATE_TOP_DATA_U_ENABLE : in std_logic;

    ACCELERATOR_STATE_TOP_DATA_Y_OUT_ENABLE : in std_logic;

    -- DATA
    ACCELERATOR_STATE_TOP_LENGTH_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    ACCELERATOR_STATE_TOP_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_C_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_C_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_D_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_SIZE_D_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    ACCELERATOR_STATE_TOP_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_DATA_C_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    ACCELERATOR_STATE_TOP_DATA_D_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    ACCELERATOR_STATE_TOP_DATA_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    ACCELERATOR_STATE_TOP_DATA_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    ACCELERATOR_STATE_TOP_DATA_Y_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_state_top_stimulus_architecture of accelerator_state_top_stimulus is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  RST <= rst_int;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -- FUNCTIONALITY
  ACCELERATOR_STATE_TOP_START <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_ACCELERATOR_STATE_TOP_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_STATE_TOP_TEST                                           ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_STATE_TOP_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_STATE_TOP_CASE_0                                 ";
        -------------------------------------------------------------------

        ACCELERATOR_STATE_TOP_SIZE_A_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_A_J_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_B_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_B_J_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_C_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_C_J_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_D_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_D_J_IN <= FOUR_CONTROL;

        ACCELERATOR_STATE_TOP_DATA_K_IN <= ZERO_DATA;
      end if;

      if (STIMULUS_ACCELERATOR_STATE_TOP_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_STATE_TOP_CASE_1                                 ";
        -------------------------------------------------------------------

        ACCELERATOR_STATE_TOP_SIZE_A_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_A_J_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_B_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_B_J_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_C_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_C_J_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_D_I_IN <= FOUR_CONTROL;
        ACCELERATOR_STATE_TOP_SIZE_D_J_IN <= FOUR_CONTROL;

        ACCELERATOR_STATE_TOP_DATA_K_IN <= ZERO_DATA;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
