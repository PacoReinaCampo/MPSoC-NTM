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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_state_outputs_pkg.all;

entity model_state_outputs_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

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

    -- VECTOR STATE
    -- CONTROL
    NTM_VECTOR_STATE_START : out std_logic;
    NTM_VECTOR_STATE_READY : in  std_logic;

    NTM_VECTOR_STATE_DATA_A_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_A_IN_J_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_B_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_B_IN_J_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_C_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_C_IN_J_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_D_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_D_IN_J_ENABLE : out std_logic;

    NTM_VECTOR_STATE_DATA_A_I_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_A_J_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_B_I_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_B_J_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_C_I_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_C_J_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_D_I_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_D_J_ENABLE : in std_logic;

    NTM_VECTOR_STATE_DATA_K_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_STATE_DATA_K_IN_J_ENABLE : out std_logic;

    NTM_VECTOR_STATE_DATA_K_I_ENABLE : in std_logic;
    NTM_VECTOR_STATE_DATA_K_J_ENABLE : in std_logic;

    NTM_VECTOR_STATE_DATA_U_IN_ENABLE : out std_logic;

    NTM_VECTOR_STATE_DATA_U_ENABLE : in std_logic;

    NTM_VECTOR_STATE_DATA_X_OUT_ENABLE : in std_logic;

    -- DATA
    NTM_VECTOR_STATE_LENGTH_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    NTM_VECTOR_STATE_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_C_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_C_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_D_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_STATE_SIZE_D_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    NTM_VECTOR_STATE_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_VECTOR_STATE_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_VECTOR_STATE_DATA_C_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_VECTOR_STATE_DATA_D_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_VECTOR_STATE_DATA_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_VECTOR_STATE_DATA_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_VECTOR_STATE_DATA_X_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR OUTPUT
    -- CONTROL
    NTM_VECTOR_OUTPUT_START : out std_logic;
    NTM_VECTOR_OUTPUT_READY : in  std_logic;

    NTM_VECTOR_OUTPUT_DATA_A_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_A_IN_J_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_B_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_B_IN_J_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_C_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_C_IN_J_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_D_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_D_IN_J_ENABLE : out std_logic;

    NTM_VECTOR_OUTPUT_DATA_A_I_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_A_J_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_B_I_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_B_J_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_C_I_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_C_J_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_D_I_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_D_J_ENABLE : in std_logic;

    NTM_VECTOR_OUTPUT_DATA_K_IN_I_ENABLE : out std_logic;
    NTM_VECTOR_OUTPUT_DATA_K_IN_J_ENABLE : out std_logic;

    NTM_VECTOR_OUTPUT_DATA_K_I_ENABLE : in std_logic;
    NTM_VECTOR_OUTPUT_DATA_K_J_ENABLE : in std_logic;

    NTM_VECTOR_OUTPUT_DATA_U_IN_ENABLE : out std_logic;

    NTM_VECTOR_OUTPUT_DATA_U_ENABLE : in std_logic;

    NTM_VECTOR_OUTPUT_DATA_Y_OUT_ENABLE : in std_logic;

    -- DATA
    NTM_VECTOR_OUTPUT_LENGTH_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    NTM_VECTOR_OUTPUT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_C_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_C_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_D_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_SIZE_D_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    NTM_VECTOR_OUTPUT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_DATA_C_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_VECTOR_OUTPUT_DATA_D_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_VECTOR_OUTPUT_DATA_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_VECTOR_OUTPUT_DATA_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_VECTOR_OUTPUT_DATA_Y_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_state_outputs_stimulus_architecture of model_state_outputs_stimulus is

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
  NTM_VECTOR_STATE_START  <= start_int;
  NTM_VECTOR_OUTPUT_START <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_NTM_VECTOR_OUTPUT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_OUTPUT_TEST         ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_OUTPUT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_OUTPUT_CASE_0       ";
        -------------------------------------------------------------------

        NTM_VECTOR_OUTPUT_SIZE_A_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_A_J_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_B_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_B_J_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_C_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_C_J_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_D_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_D_J_IN <= THREE_CONTROL;

        NTM_VECTOR_OUTPUT_DATA_K_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_VECTOR_OUTPUT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_OUTPUT_CASE_1       ";
        -------------------------------------------------------------------

        NTM_VECTOR_OUTPUT_SIZE_A_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_A_J_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_B_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_B_J_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_C_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_C_J_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_D_I_IN <= THREE_CONTROL;
        NTM_VECTOR_OUTPUT_SIZE_D_J_IN <= THREE_CONTROL;

        NTM_VECTOR_OUTPUT_DATA_K_IN <= MAX_POSITIVE;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
