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
use work.ntm_arithmetic_pkg.all;

entity ntm_arithmetic_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE : integer := 512;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))   -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -----------------------------------------------------------------------
    -- STIMULUS SCALAR
    -----------------------------------------------------------------------

    -- SCALAR MOD
    -- CONTROL
    SCALAR_MOD_START : out std_logic;
    SCALAR_MOD_READY : in  std_logic;

    -- DATA
    SCALAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR ADDER
    -- CONTROL
    SCALAR_ADDER_START : out std_logic;
    SCALAR_ADDER_READY : in  std_logic;

    SCALAR_ADDER_OPERATION : out std_logic;

    -- DATA
    SCALAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR MULTIPLIER
    -- CONTROL
    SCALAR_MULTIPLIER_START : out std_logic;
    SCALAR_MULTIPLIER_READY : in  std_logic;

    -- DATA
    SCALAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR INVERTER
    -- CONTROL
    SCALAR_INVERTER_START : out std_logic;
    SCALAR_INVERTER_READY : in  std_logic;

    -- DATA
    SCALAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR DIVIDER
    -- CONTROL
    SCALAR_DIVIDER_START : out std_logic;
    SCALAR_DIVIDER_READY : in  std_logic;

    -- DATA
    SCALAR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR EXPONENTIATOR
    -- CONTROL
    SCALAR_EXPONENTIATOR_START : out std_logic;
    SCALAR_EXPONENTIATOR_READY : in  std_logic;

    -- DATA
    SCALAR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR LCM
    -- CONTROL
    SCALAR_LCM_START : out std_logic;
    SCALAR_LCM_READY : in  std_logic;

    -- DATA
    SCALAR_LCM_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LCM_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LCM_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LCM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR GCD
    -- CONTROL
    SCALAR_GCD_START : out std_logic;
    SCALAR_GCD_READY : in  std_logic;

    -- DATA
    SCALAR_GCD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_GCD_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_GCD_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_GCD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS VECTOR
    -----------------------------------------------------------------------

    -- VECTOR MOD
    -- CONTROL
    VECTOR_MOD_START : out std_logic;
    VECTOR_MOD_READY : in  std_logic;

    VECTOR_MOD_DATA_IN_ENABLE : out std_logic;

    VECTOR_MOD_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MOD_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR ADDER
    -- CONTROL
    VECTOR_ADDER_START : out std_logic;
    VECTOR_ADDER_READY : in  std_logic;

    VECTOR_ADDER_OPERATION : out std_logic;

    VECTOR_ADDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_ADDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_ADDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ADDER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR MULTIPLIER
    -- CONTROL
    VECTOR_MULTIPLIER_START : out std_logic;
    VECTOR_MULTIPLIER_READY : in  std_logic;

    VECTOR_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLIER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR INVERTER
    -- CONTROL
    VECTOR_INVERTER_START : out std_logic;
    VECTOR_INVERTER_READY : in  std_logic;

    VECTOR_INVERTER_DATA_IN_ENABLE : out std_logic;

    VECTOR_INVERTER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INVERTER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR DIVIDER
    -- CONTROL
    VECTOR_DIVIDER_START : out std_logic;
    VECTOR_DIVIDER_READY : in  std_logic;

    VECTOR_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_DIVIDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIVIDER_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR EXPONENTIATOR
    -- CONTROL
    VECTOR_EXPONENTIATOR_START : out std_logic;
    VECTOR_EXPONENTIATOR_READY : in  std_logic;

    VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR LCM
    -- CONTROL
    VECTOR_LCM_START : out std_logic;
    VECTOR_LCM_READY : in  std_logic;

    VECTOR_LCM_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_LCM_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_LCM_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_LCM_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LCM_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LCM_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LCM_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LCM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR GCD
    -- CONTROL
    VECTOR_GCD_START : out std_logic;
    VECTOR_GCD_READY : in  std_logic;

    VECTOR_GCD_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_GCD_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_GCD_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_GCD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_GCD_SIZE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_GCD_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_GCD_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_GCD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS MATRIX
    -----------------------------------------------------------------------

    -- MATRIX MOD
    -- CONTROL
    MATRIX_MOD_START : out std_logic;
    MATRIX_MOD_READY : in  std_logic;

    MATRIX_MOD_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_MOD_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_MOD_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MOD_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MOD_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MOD_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX ADDER
    -- CONTROL
    MATRIX_ADDER_START : out std_logic;
    MATRIX_ADDER_READY : in  std_logic;

    MATRIX_ADDER_OPERATION : out std_logic;

    MATRIX_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_ADDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ADDER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ADDER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX MULTIPLIER
    -- CONTROL
    MATRIX_MULTIPLIER_START : out std_logic;
    MATRIX_MULTIPLIER_READY : in  std_logic;

    MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLIER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLIER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX INVERTER
    -- CONTROL
    MATRIX_INVERTER_START : out std_logic;
    MATRIX_INVERTER_READY : in  std_logic;

    MATRIX_INVERTER_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_INVERTER_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_INVERTER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INVERTER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERTER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERTER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX DIVIDER
    -- CONTROL
    MATRIX_DIVIDER_START : out std_logic;
    MATRIX_DIVIDER_READY : in  std_logic;

    MATRIX_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIVIDER_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIVIDER_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX EXPONENTIATOR
    -- CONTROL
    MATRIX_EXPONENTIATOR_START : out std_logic;
    MATRIX_EXPONENTIATOR_READY : in  std_logic;

    MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX LCM
    -- CONTROL
    MATRIX_LCM_START : out std_logic;
    MATRIX_LCM_READY : in  std_logic;

    MATRIX_LCM_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_LCM_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_LCM_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_LCM_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_LCM_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_LCM_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_LCM_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LCM_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LCM_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LCM_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LCM_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LCM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX GCD
    -- CONTROL
    MATRIX_GCD_START : out std_logic;
    MATRIX_GCD_READY : in  std_logic;

    MATRIX_GCD_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_GCD_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_GCD_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_GCD_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_GCD_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_GCD_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_GCD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_GCD_SIZE_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_GCD_SIZE_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_GCD_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_GCD_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_GCD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_arithmetic_stimulus_architecture of ntm_arithmetic_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1000 ms;

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0) := ONE;

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

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

  -- SCALAR-FUNCTIONALITY
  SCALAR_MOD_START           <= start_int;
  SCALAR_ADDER_START         <= start_int;
  SCALAR_MULTIPLIER_START    <= start_int;
  SCALAR_INVERTER_START      <= start_int;
  SCALAR_DIVIDER_START       <= start_int;
  SCALAR_EXPONENTIATOR_START <= start_int;
  SCALAR_LCM_START           <= start_int;
  SCALAR_GCD_START           <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_MOD_START           <= start_int;
  VECTOR_ADDER_START         <= start_int;
  VECTOR_MULTIPLIER_START    <= start_int;
  VECTOR_INVERTER_START      <= start_int;
  VECTOR_DIVIDER_START       <= start_int;
  VECTOR_EXPONENTIATOR_START <= start_int;
  VECTOR_LCM_START           <= start_int;
  VECTOR_GCD_START           <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_MOD_START           <= start_int;
  MATRIX_ADDER_START         <= start_int;
  MATRIX_MULTIPLIER_START    <= start_int;
  MATRIX_INVERTER_START      <= start_int;
  MATRIX_DIVIDER_START       <= start_int;
  MATRIX_EXPONENTIATOR_START <= start_int;
  MATRIX_LCM_START           <= start_int;
  MATRIX_GCD_START           <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-ARITHMETIC
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_MOD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_MOD_TEST            ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MOD_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MOD_CASE_0) then
        SCALAR_MOD_MODULO_IN <= FULL;
        SCALAR_MOD_DATA_IN   <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MOD_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MOD_CASE_1) then
        SCALAR_MOD_MODULO_IN <= FULL;
        SCALAR_MOD_DATA_IN   <= TWO;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      SCALAR_ADDER_OPERATION <= '0';

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 0        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_ADDER_CASE_0) then
        SCALAR_ADDER_MODULO_IN <= FULL;
        SCALAR_ADDER_DATA_A_IN <= TWO;
        SCALAR_ADDER_DATA_B_IN <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 1        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_ADDER_CASE_1) then
        SCALAR_ADDER_MODULO_IN <= FULL;
        SCALAR_ADDER_DATA_A_IN <= TWO;
        SCALAR_ADDER_DATA_B_IN <= TWO;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 0   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0) then
        SCALAR_MULTIPLIER_MODULO_IN <= FULL;
        SCALAR_MULTIPLIER_DATA_A_IN <= TWO;
        SCALAR_MULTIPLIER_DATA_B_IN <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 1   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1) then
        SCALAR_MULTIPLIER_MODULO_IN <= FULL;
        SCALAR_MULTIPLIER_DATA_A_IN <= TWO;
        SCALAR_MULTIPLIER_DATA_B_IN <= TWO;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_INVERTER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_INVERTER_TEST       ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_INVERTER_CASE 0     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_INVERTER_CASE_0) then
        SCALAR_INVERTER_MODULO_IN <= FULL;
        SCALAR_INVERTER_DATA_IN   <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_INVERTER_CASE 1     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_INVERTER_CASE_1) then
        SCALAR_INVERTER_MODULO_IN <= FULL;
        SCALAR_INVERTER_DATA_IN   <= ONE;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 0      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_DIVIDER_CASE_0) then
        SCALAR_DIVIDER_MODULO_IN <= FULL;
        SCALAR_DIVIDER_DATA_A_IN <= TWO;
        SCALAR_DIVIDER_DATA_B_IN <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 1      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_DIVIDER_CASE_1) then
        SCALAR_DIVIDER_MODULO_IN <= FULL;
        SCALAR_DIVIDER_DATA_A_IN <= TWO;
        SCALAR_DIVIDER_DATA_B_IN <= TWO;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 0";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0) then
        SCALAR_EXPONENTIATOR_MODULO_IN <= FULL;
        SCALAR_EXPONENTIATOR_DATA_A_IN <= TWO;
        SCALAR_EXPONENTIATOR_DATA_B_IN <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 1";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1) then
        SCALAR_EXPONENTIATOR_MODULO_IN <= FULL;
        SCALAR_EXPONENTIATOR_DATA_A_IN <= TWO;
        SCALAR_EXPONENTIATOR_DATA_B_IN <= TWO;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_LCM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_LCM_TEST            ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LCM_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_LCM_CASE_0) then
        SCALAR_LCM_MODULO_IN <= FULL;
        SCALAR_LCM_DATA_A_IN <= TWO;
        SCALAR_LCM_DATA_B_IN <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LCM_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_LCM_CASE_1) then
        SCALAR_LCM_MODULO_IN <= FULL;
        SCALAR_LCM_DATA_A_IN <= TWO;
        SCALAR_LCM_DATA_B_IN <= TWO;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_GCD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_GCD_TEST            ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_GCD_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_GCD_CASE_0) then
        SCALAR_GCD_MODULO_IN <= FULL;
        SCALAR_GCD_DATA_A_IN <= TWO;
        SCALAR_GCD_DATA_B_IN <= ONE;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_SCALAR_GCD_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_GCD_CASE_1) then
        SCALAR_GCD_MODULO_IN <= FULL;
        SCALAR_GCD_DATA_A_IN <= TWO;
        SCALAR_GCD_DATA_B_IN <= TWO;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-ARITHMETIC
    -------------------------------------------------------------------

    if (STIMULUS_NTM_VECTOR_MOD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MOD_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MOD_MODULO_IN <= FULL;
      VECTOR_MOD_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MOD_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_MOD_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MOD_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MOD_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_MOD_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_MOD_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_MOD_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MOD_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_MOD_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MOD_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_MOD_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MOD_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MOD_DATA_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_MOD_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_MOD_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_MOD_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MOD_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_MOD_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- OPERATION
      VECTOR_ADDER_OPERATION <= '0';

      -- DATA
      VECTOR_ADDER_MODULO_IN <= FULL;
      VECTOR_ADDER_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 0        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_ADDER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_ADDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_ADDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_ADDER_DATA_A_IN <= TWO;
        VECTOR_ADDER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_ADDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_ADDER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_ADDER_DATA_A_IN <= TWO;
            VECTOR_ADDER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 1        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_ADDER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_ADDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_ADDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_ADDER_DATA_A_IN <= TWO;
        VECTOR_ADDER_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_ADDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_ADDER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_ADDER_DATA_A_IN <= TWO;
            VECTOR_ADDER_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MULTIPLIER_MODULO_IN <= FULL;
      VECTOR_MULTIPLIER_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 0   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MULTIPLIER_DATA_A_IN <= TWO;
        VECTOR_MULTIPLIER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_MULTIPLIER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_MULTIPLIER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MULTIPLIER_DATA_A_IN <= TWO;
            VECTOR_MULTIPLIER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 1   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MULTIPLIER_DATA_A_IN <= TWO;
        VECTOR_MULTIPLIER_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_MULTIPLIER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_MULTIPLIER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MULTIPLIER_DATA_A_IN <= TWO;
            VECTOR_MULTIPLIER_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_INVERTER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_INVERTER_TEST       ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_INVERTER_MODULO_IN <= FULL;
      VECTOR_INVERTER_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_INVERTER_CASE 0     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_INVERTER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_INVERTER_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_INVERTER_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_INVERTER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_INVERTER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_INVERTER_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INVERTER_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_INVERTER_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_INVERTER_CASE 1     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_INVERTER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_INVERTER_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_INVERTER_DATA_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_INVERTER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_INVERTER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_INVERTER_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INVERTER_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_INVERTER_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_DIVIDER_MODULO_IN <= FULL;
      VECTOR_DIVIDER_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 0      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_DIVIDER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_DIVIDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_DIVIDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_DIVIDER_DATA_A_IN <= TWO;
        VECTOR_DIVIDER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_DIVIDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_DIVIDER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_DIVIDER_DATA_A_IN <= TWO;
            VECTOR_DIVIDER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 1      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_DIVIDER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_DIVIDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_DIVIDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_DIVIDER_DATA_A_IN <= TWO;
        VECTOR_DIVIDER_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_DIVIDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_DIVIDER_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_DIVIDER_DATA_A_IN <= TWO;
            VECTOR_DIVIDER_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_EXPONENTIATOR_MODULO_IN <= FULL;
      VECTOR_EXPONENTIATOR_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE 0";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
        VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_EXPONENTIATOR_DATA_A_IN <= TWO;
        VECTOR_EXPONENTIATOR_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
            VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_EXPONENTIATOR_DATA_A_IN <= TWO;
            VECTOR_EXPONENTIATOR_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '0';
            VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE 1";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
        VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_EXPONENTIATOR_DATA_A_IN <= TWO;
        VECTOR_EXPONENTIATOR_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
            VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_EXPONENTIATOR_DATA_A_IN <= TWO;
            VECTOR_EXPONENTIATOR_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '0';
            VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_LCM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_LCM_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_LCM_MODULO_IN <= FULL;
      VECTOR_LCM_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_LCM_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_LCM_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_LCM_DATA_A_IN_ENABLE <= '1';
        VECTOR_LCM_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_LCM_DATA_A_IN <= TWO;
        VECTOR_LCM_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_LCM_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_LCM_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_LCM_DATA_A_IN_ENABLE <= '1';
            VECTOR_LCM_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LCM_DATA_A_IN <= TWO;
            VECTOR_LCM_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_LCM_DATA_A_IN_ENABLE <= '0';
            VECTOR_LCM_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_LCM_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_LCM_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_VECTOR_LCM_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_LCM_DATA_A_IN_ENABLE <= '1';
        VECTOR_LCM_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_LCM_DATA_A_IN <= TWO;
        VECTOR_LCM_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_LCM_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_LCM_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_LCM_DATA_A_IN_ENABLE <= '1';
            VECTOR_LCM_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LCM_DATA_A_IN <= TWO;
            VECTOR_LCM_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_LCM_DATA_A_IN_ENABLE <= '0';
            VECTOR_LCM_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_LCM_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_GCD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_GCD_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_GCD_MODULO_IN <= FULL;
      VECTOR_GCD_SIZE_IN   <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_GCD_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_GCD_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_GCD_DATA_A_IN_ENABLE <= '1';
        VECTOR_GCD_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_GCD_DATA_A_IN <= TWO;
        VECTOR_GCD_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_GCD_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_GCD_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_GCD_DATA_A_IN_ENABLE <= '1';
            VECTOR_GCD_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_GCD_DATA_A_IN <= TWO;
            VECTOR_GCD_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_GCD_DATA_A_IN_ENABLE <= '0';
            VECTOR_GCD_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_GCD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_VECTOR_GCD_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_GCD_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_GCD_DATA_A_IN_ENABLE <= '1';
        VECTOR_GCD_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_GCD_DATA_A_IN <= TWO;
        VECTOR_GCD_DATA_B_IN <= TWO;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

        loop
          if ((VECTOR_GCD_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(VECTOR_GCD_SIZE_IN)-unsigned(ONE))) then
            -- CONTROL
            VECTOR_GCD_DATA_A_IN_ENABLE <= '1';
            VECTOR_GCD_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_GCD_DATA_A_IN <= TWO;
            VECTOR_GCD_DATA_B_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
          else
            -- CONTROL
            VECTOR_GCD_DATA_A_IN_ENABLE <= '0';
            VECTOR_GCD_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_GCD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX-ARITHMETIC
    -------------------------------------------------------------------

    if (STIMULUS_NTM_MATRIX_MOD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MOD_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MOD_MODULO_IN <= FULL;
      MATRIX_MOD_SIZE_I_IN <= THREE;
      MATRIX_MOD_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MOD_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MOD_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MOD_DATA_IN_I_ENABLE <= '0';
        MATRIX_MOD_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MOD_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_MOD_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_MOD_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MOD_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MOD_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_MOD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_MOD_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MOD_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MOD_DATA_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_MOD_DATA_IN_I_ENABLE <= '0';
            MATRIX_MOD_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MOD_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MOD_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MOD_DATA_IN_I_ENABLE <= '0';
        MATRIX_MOD_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MOD_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_MOD_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_MOD_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MOD_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MOD_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_MOD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_MOD_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MOD_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MOD_DATA_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_MOD_DATA_IN_I_ENABLE <= '0';
            MATRIX_MOD_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      MATRIX_ADDER_OPERATION <= '0';

      -- DATA
      MATRIX_ADDER_MODULO_IN <= FULL;
      MATRIX_ADDER_SIZE_I_IN <= THREE;
      MATRIX_ADDER_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 0        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_ADDER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_ADDER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_ADDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_ADDER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_ADDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_ADDER_DATA_A_IN <= ONE;
        MATRIX_ADDER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_ADDER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_ADDER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_ADDER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_ADDER_DATA_A_IN <= ONE;
            MATRIX_ADDER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_ADDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_ADDER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_ADDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_ADDER_DATA_A_IN <= ONE;
            MATRIX_ADDER_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 1        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_ADDER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_ADDER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_ADDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_ADDER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_ADDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_ADDER_DATA_A_IN <= TWO;
        MATRIX_ADDER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_ADDER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_ADDER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_ADDER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_ADDER_DATA_A_IN <= TWO;
            MATRIX_ADDER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_ADDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_ADDER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_ADDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_ADDER_DATA_A_IN <= TWO;
            MATRIX_ADDER_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MULTIPLIER_MODULO_IN <= FULL;
      MATRIX_MULTIPLIER_SIZE_I_IN <= THREE;
      MATRIX_MULTIPLIER_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 0   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MULTIPLIER_DATA_A_IN <= ONE;
        MATRIX_MULTIPLIER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_MULTIPLIER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MULTIPLIER_DATA_A_IN <= ONE;
            MATRIX_MULTIPLIER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_MULTIPLIER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MULTIPLIER_DATA_A_IN <= ONE;
            MATRIX_MULTIPLIER_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 1   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MULTIPLIER_DATA_A_IN <= TWO;
        MATRIX_MULTIPLIER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_MULTIPLIER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MULTIPLIER_DATA_A_IN <= TWO;
            MATRIX_MULTIPLIER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_MULTIPLIER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MULTIPLIER_DATA_A_IN <= TWO;
            MATRIX_MULTIPLIER_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_INVERTER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_INVERTER_TEST       ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_INVERTER_MODULO_IN <= FULL;
      MATRIX_INVERTER_SIZE_I_IN <= THREE;
      MATRIX_INVERTER_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_INVERTER_CASE 0     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_INVERTER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_INVERTER_DATA_IN_I_ENABLE <= '0';
        MATRIX_INVERTER_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_INVERTER_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_INVERTER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_INVERTER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERTER_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_INVERTER_DATA_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_INVERTER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_INVERTER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERTER_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_INVERTER_DATA_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_INVERTER_DATA_IN_I_ENABLE <= '0';
            MATRIX_INVERTER_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_INVERTER_CASE 1     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_INVERTER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_INVERTER_DATA_IN_I_ENABLE <= '0';
        MATRIX_INVERTER_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_INVERTER_DATA_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_INVERTER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_INVERTER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERTER_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_INVERTER_DATA_IN <= TWO;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_INVERTER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_INVERTER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_INVERTER_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_INVERTER_DATA_IN <= TWO;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_INVERTER_DATA_IN_I_ENABLE <= '0';
            MATRIX_INVERTER_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_DIVIDER_MODULO_IN <= FULL;
      MATRIX_DIVIDER_SIZE_I_IN <= THREE;
      MATRIX_DIVIDER_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 0      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_DIVIDER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_DIVIDER_DATA_A_IN <= ONE;
        MATRIX_DIVIDER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_DIVIDER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_DIVIDER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_DIVIDER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_DIVIDER_DATA_A_IN <= ONE;
            MATRIX_DIVIDER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_DIVIDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_DIVIDER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_DIVIDER_DATA_A_IN <= ONE;
            MATRIX_DIVIDER_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 1      ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_DIVIDER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_DIVIDER_DATA_A_IN <= TWO;
        MATRIX_DIVIDER_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_DIVIDER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_DIVIDER_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_DIVIDER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_DIVIDER_DATA_A_IN <= TWO;
            MATRIX_DIVIDER_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_DIVIDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_DIVIDER_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_DIVIDER_DATA_A_IN <= TWO;
            MATRIX_DIVIDER_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_EXPONENTIATOR_MODULO_IN <= FULL;
      MATRIX_EXPONENTIATOR_SIZE_I_IN <= THREE;
      MATRIX_EXPONENTIATOR_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE 0";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_EXPONENTIATOR_DATA_A_IN <= ONE;
        MATRIX_EXPONENTIATOR_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_EXPONENTIATOR_DATA_A_IN <= ONE;
            MATRIX_EXPONENTIATOR_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_EXPONENTIATOR_DATA_A_IN <= ONE;
            MATRIX_EXPONENTIATOR_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE 1";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_EXPONENTIATOR_DATA_A_IN <= TWO;
        MATRIX_EXPONENTIATOR_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_EXPONENTIATOR_DATA_A_IN <= TWO;
            MATRIX_EXPONENTIATOR_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_EXPONENTIATOR_DATA_A_IN <= TWO;
            MATRIX_EXPONENTIATOR_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_LCM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_LCM_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_LCM_MODULO_IN <= FULL;
      MATRIX_LCM_SIZE_I_IN <= THREE;
      MATRIX_LCM_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_LCM_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_LCM_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_LCM_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_LCM_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_LCM_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_LCM_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_LCM_DATA_A_IN <= ONE;
        MATRIX_LCM_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_LCM_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_LCM_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_LCM_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_LCM_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_LCM_DATA_A_IN <= ONE;
            MATRIX_LCM_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_LCM_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_LCM_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_LCM_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_LCM_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_LCM_DATA_A_IN <= ONE;
            MATRIX_LCM_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_LCM_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_LCM_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_LCM_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_LCM_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_LCM_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_LCM_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_LCM_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_LCM_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_LCM_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_LCM_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_LCM_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_LCM_DATA_A_IN <= TWO;
        MATRIX_LCM_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_LCM_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_LCM_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_LCM_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_LCM_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_LCM_DATA_A_IN <= TWO;
            MATRIX_LCM_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_LCM_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_LCM_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_LCM_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_LCM_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_LCM_DATA_A_IN <= TWO;
            MATRIX_LCM_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_LCM_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_LCM_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_LCM_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_LCM_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_LCM_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_GCD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_GCD_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_GCD_MODULO_IN <= FULL;
      MATRIX_GCD_SIZE_I_IN <= THREE;
      MATRIX_GCD_SIZE_J_IN <= THREE;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_GCD_CASE 0          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_GCD_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_GCD_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_GCD_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_GCD_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_GCD_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_GCD_DATA_A_IN <= ONE;
        MATRIX_GCD_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_GCD_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_GCD_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_GCD_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_GCD_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_GCD_DATA_A_IN <= ONE;
            MATRIX_GCD_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_GCD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_GCD_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_GCD_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_GCD_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_GCD_DATA_A_IN <= ONE;
            MATRIX_GCD_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_GCD_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_GCD_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_GCD_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_GCD_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_GCD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_GCD_CASE 1          ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_GCD_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_GCD_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_GCD_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_GCD_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_GCD_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_GCD_DATA_A_IN <= TWO;
        MATRIX_GCD_DATA_B_IN <= ONE;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

        loop
          if ((MATRIX_GCD_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) > unsigned(ONE)) and (unsigned(index_i_loop) < unsigned(MATRIX_GCD_SIZE_I_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_GCD_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_GCD_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_GCD_DATA_A_IN <= TWO;
            MATRIX_GCD_DATA_B_IN <= ONE;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
            index_j_loop <= ZERO;
          elsif ((MATRIX_GCD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) > unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(MATRIX_GCD_SIZE_J_IN)-unsigned(ONE))) then
            -- CONTROL
            MATRIX_GCD_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_GCD_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_GCD_DATA_A_IN <= TWO;
            MATRIX_GCD_DATA_B_IN <= ONE;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
          else
            -- CONTROL
            MATRIX_GCD_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_GCD_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_GCD_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_GCD_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_GCD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
