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

use work.accelerator_math_pkg.all;

entity accelerator_trainer_linear_stimulus is
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
    NTM_TRAINER_LINEAR_START : out std_logic;
    NTM_TRAINER_LINEAR_READY : in  std_logic;

    NTM_TRAINER_LINEAR_X_IN_T_ENABLE : out std_logic;  -- for t out 0 to T-1
    NTM_TRAINER_LINEAR_X_IN_X_ENABLE : out std_logic;  -- for x out 0 to X-1

    NTM_TRAINER_LINEAR_X_OUT_T_ENABLE : in std_logic;  -- for t out 0 to T-1
    NTM_TRAINER_LINEAR_X_OUT_X_ENABLE : in std_logic;  -- for x out 0 to X-1

    NTM_TRAINER_LINEAR_H_IN_T_ENABLE : out std_logic;  -- for t out 0 to T-1
    NTM_TRAINER_LINEAR_H_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1

    NTM_TRAINER_LINEAR_H_OUT_T_ENABLE : in std_logic;  -- for t out 0 to T-1
    NTM_TRAINER_LINEAR_H_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1

    NTM_TRAINER_LINEAR_W_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    NTM_TRAINER_LINEAR_W_OUT_X_ENABLE : in std_logic;  -- for x out 0 to X-1

    NTM_TRAINER_LINEAR_B_OUT_ENABLE : in std_logic;  -- for l out 0 to L-1

    -- DATA
    NTM_TRAINER_LINEAR_SIZE_T_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_TRAINER_LINEAR_SIZE_X_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    NTM_TRAINER_LINEAR_SIZE_L_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    NTM_TRAINER_LINEAR_X_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_TRAINER_LINEAR_H_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    NTM_TRAINER_LINEAR_W_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);
    NTM_TRAINER_LINEAR_B_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_trainer_linear_stimulus_architecture of accelerator_trainer_linear_stimulus is

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

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

end architecture;
