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
use work.ntm_modular_pkg.all;

entity ntm_modular_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

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
    SCALAR_MODULAR_MOD_START : out std_logic;
    SCALAR_MODULAR_MOD_READY : in  std_logic;

    -- DATA
    SCALAR_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR ADDER
    -- CONTROL
    SCALAR_MODULAR_ADDER_START : out std_logic;
    SCALAR_MODULAR_ADDER_READY : in  std_logic;

    SCALAR_MODULAR_ADDER_OPERATION : out std_logic;

    -- DATA
    SCALAR_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR MULTIPLIER
    -- CONTROL
    SCALAR_MODULAR_MULTIPLIER_START : out std_logic;
    SCALAR_MODULAR_MULTIPLIER_READY : in  std_logic;

    -- DATA
    SCALAR_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR INVERTER
    -- CONTROL
    SCALAR_MODULAR_INVERTER_START : out std_logic;
    SCALAR_MODULAR_INVERTER_READY : in  std_logic;

    -- DATA
    SCALAR_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR DIVIDER
    -- CONTROL
    SCALAR_MODULAR_DIVIDER_START : out std_logic;
    SCALAR_MODULAR_DIVIDER_READY : in  std_logic;

    -- DATA
    SCALAR_MODULAR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR EXPONENTIATOR
    -- CONTROL
    SCALAR_MODULAR_EXPONENTIATOR_START : out std_logic;
    SCALAR_MODULAR_EXPONENTIATOR_READY : in  std_logic;

    -- DATA
    SCALAR_MODULAR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_MODULAR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS VECTOR
    -----------------------------------------------------------------------

    -- VECTOR MOD
    -- CONTROL
    VECTOR_MODULAR_MOD_START : out std_logic;
    VECTOR_MODULAR_MOD_READY : in  std_logic;

    VECTOR_MODULAR_MOD_DATA_IN_ENABLE : out std_logic;

    VECTOR_MODULAR_MOD_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_MOD_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR ADDER
    -- CONTROL
    VECTOR_MODULAR_ADDER_START : out std_logic;
    VECTOR_MODULAR_ADDER_READY : in  std_logic;

    VECTOR_MODULAR_ADDER_OPERATION : out std_logic;

    VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_ADDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR MULTIPLIER
    -- CONTROL
    VECTOR_MODULAR_MULTIPLIER_START : out std_logic;
    VECTOR_MODULAR_MULTIPLIER_READY : in  std_logic;

    VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_MULTIPLIER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR INVERTER
    -- CONTROL
    VECTOR_MODULAR_INVERTER_START : out std_logic;
    VECTOR_MODULAR_INVERTER_READY : in  std_logic;

    VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE : out std_logic;

    VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_INVERTER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR DIVIDER
    -- CONTROL
    VECTOR_MODULAR_DIVIDER_START : out std_logic;
    VECTOR_MODULAR_DIVIDER_READY : in  std_logic;

    VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_MODULAR_DIVIDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULAR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_DIVIDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULAR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR EXPONENTIATOR
    -- CONTROL
    VECTOR_MODULAR_EXPONENTIATOR_START : out std_logic;
    VECTOR_MODULAR_EXPONENTIATOR_READY : in  std_logic;

    VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_MODULAR_EXPONENTIATOR_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULAR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_EXPONENTIATOR_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULAR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -----------------------------------------------------------------------
    -- STIMULUS MATRIX
    -----------------------------------------------------------------------

    -- MATRIX MOD
    -- CONTROL
    MATRIX_MODULAR_MOD_START : out std_logic;
    MATRIX_MODULAR_MOD_READY : in  std_logic;

    MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MODULAR_MOD_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_MOD_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_MOD_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_MOD_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_MOD_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX ADDER
    -- CONTROL
    MATRIX_MODULAR_ADDER_START : out std_logic;
    MATRIX_MODULAR_ADDER_READY : in  std_logic;

    MATRIX_MODULAR_ADDER_OPERATION : out std_logic;

    MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MODULAR_ADDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_ADDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX MULTIPLIER
    -- CONTROL
    MATRIX_MODULAR_MULTIPLIER_START : out std_logic;
    MATRIX_MODULAR_MULTIPLIER_READY : in  std_logic;

    MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MODULAR_MULTIPLIER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_MULTIPLIER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX INVERTER
    -- CONTROL
    MATRIX_MODULAR_INVERTER_START : out std_logic;
    MATRIX_MODULAR_INVERTER_READY : in  std_logic;

    MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MODULAR_INVERTER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_INVERTER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_INVERTER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_INVERTER_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_INVERTER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX DIVIDER
    -- CONTROL
    MATRIX_MODULAR_DIVIDER_START : out std_logic;
    MATRIX_MODULAR_DIVIDER_READY : in  std_logic;

    MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_MODULAR_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MODULAR_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MODULAR_DIVIDER_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_DIVIDER_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX EXPONENTIATOR
    -- CONTROL
    MATRIX_MODULAR_EXPONENTIATOR_START : out std_logic;
    MATRIX_MODULAR_EXPONENTIATOR_READY : in  std_logic;

    MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MODULAR_EXPONENTIATOR_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_EXPONENTIATOR_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_EXPONENTIATOR_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_modular_stimulus_architecture of ntm_modular_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

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

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0) := ZERO_CONTROL;

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
  SCALAR_MODULAR_MOD_START           <= start_int;
  SCALAR_MODULAR_ADDER_START         <= start_int;
  SCALAR_MODULAR_MULTIPLIER_START    <= start_int;
  SCALAR_MODULAR_INVERTER_START      <= start_int;
  SCALAR_MODULAR_DIVIDER_START       <= start_int;
  SCALAR_MODULAR_EXPONENTIATOR_START <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_MODULAR_MOD_START           <= start_int;
  VECTOR_MODULAR_ADDER_START         <= start_int;
  VECTOR_MODULAR_MULTIPLIER_START    <= start_int;
  VECTOR_MODULAR_INVERTER_START      <= start_int;
  VECTOR_MODULAR_DIVIDER_START       <= start_int;
  VECTOR_MODULAR_EXPONENTIATOR_START <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_MODULAR_MOD_START           <= start_int;
  MATRIX_MODULAR_ADDER_START         <= start_int;
  MATRIX_MODULAR_MULTIPLIER_START    <= start_int;
  MATRIX_MODULAR_INVERTER_START      <= start_int;
  MATRIX_MODULAR_DIVIDER_START       <= start_int;
  MATRIX_MODULAR_EXPONENTIATOR_START <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-MODULAR
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_MOD_TEST            ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MOD_CASE 0          ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_MOD_MODULO_IN <= FULL;
        SCALAR_MODULAR_MOD_DATA_IN   <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MOD_CASE 1          ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_MOD_MODULO_IN <= FULL;
        SCALAR_MODULAR_MOD_DATA_IN   <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      SCALAR_MODULAR_ADDER_OPERATION <= '0';

      if (STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_ADDER_MODULO_IN <= FULL;
        SCALAR_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_ADDER_MODULO_IN <= FULL;
        SCALAR_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_ADDER_DATA_B_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_MULTIPLIER_MODULO_IN <= FULL;
        SCALAR_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_MULTIPLIER_MODULO_IN <= FULL;
        SCALAR_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_MULTIPLIER_DATA_B_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_INVERTER_TEST       ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_INVERTER_CASE 0     ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_INVERTER_MODULO_IN <= FULL;
        SCALAR_MODULAR_INVERTER_DATA_IN   <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_INVERTER_CASE 1     ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_INVERTER_MODULO_IN <= FULL;
        SCALAR_MODULAR_INVERTER_DATA_IN   <= ONE_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MODULAR_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MODULAR_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_DIVIDER_MODULO_IN <= FULL;
        SCALAR_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_MODULAR_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        SCALAR_MODULAR_DIVIDER_MODULO_IN <= FULL;
        SCALAR_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_DIVIDER_DATA_B_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_MODULAR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_MODULAR_EXPONENTIATOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 0";
        -------------------------------------------------------------------

        SCALAR_MODULAR_EXPONENTIATOR_MODULO_IN <= FULL;
        SCALAR_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;
      end if;

      if (STIMULUS_NTM_SCALAR_MODULAR_EXPONENTIATOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 1";
        -------------------------------------------------------------------

        SCALAR_MODULAR_EXPONENTIATOR_MODULO_IN <= FULL;
        SCALAR_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
        SCALAR_MODULAR_EXPONENTIATOR_DATA_B_IN <= TWO_DATA;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-MODULAR
    -------------------------------------------------------------------

    if (STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MOD_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MODULAR_MOD_MODULO_IN <= FULL;
      VECTOR_MODULAR_MOD_SIZE_IN   <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MOD_CASE 0          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_MOD_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_MOD_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_MOD_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_MOD_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_MOD_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_MOD_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_MOD_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MOD_CASE 1          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_MOD_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_MOD_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_MOD_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_MOD_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_MOD_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_MOD_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_MOD_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- OPERATION
      VECTOR_MODULAR_ADDER_OPERATION <= '0';

      -- DATA
      VECTOR_MODULAR_ADDER_MODULO_IN <= FULL;
      VECTOR_MODULAR_ADDER_SIZE_IN   <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_ADDER_DATA_B_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_ADDER_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MODULAR_MULTIPLIER_MODULO_IN <= FULL;
      VECTOR_MODULAR_MULTIPLIER_SIZE_IN   <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_MULTIPLIER_DATA_B_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_MULTIPLIER_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_INVERTER_TEST       ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MODULAR_INVERTER_MODULO_IN <= FULL;
      VECTOR_MODULAR_INVERTER_SIZE_IN   <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_INVERTER_CASE 0     ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_INVERTER_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_INVERTER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_INVERTER_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_INVERTER_CASE 1     ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_INVERTER_DATA_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_INVERTER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_INVERTER_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MODULAR_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MODULAR_DIVIDER_MODULO_IN <= FULL;
      VECTOR_MODULAR_DIVIDER_SIZE_IN   <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULAR_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_DIVIDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULAR_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_DIVIDER_DATA_B_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_DIVIDER_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_DIVIDER_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MODULAR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MODULAR_EXPONENTIATOR_MODULO_IN <= FULL;
      VECTOR_MODULAR_EXPONENTIATOR_SIZE_IN   <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULAR_EXPONENTIATOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE 0";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_EXPONENTIATOR_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULAR_EXPONENTIATOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE 1";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
        VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

        -- DATA
        VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
        VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN <= TWO_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

        loop
          if ((VECTOR_MODULAR_EXPONENTIATOR_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(VECTOR_MODULAR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '1';
            VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
            VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULAR_EXPONENTIATOR_DATA_A_IN_ENABLE <= '0';
            VECTOR_MODULAR_EXPONENTIATOR_DATA_B_IN_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when VECTOR_MODULAR_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX-MODULAR
    -------------------------------------------------------------------

    if (STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MOD_TEST            ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MODULAR_MOD_MODULO_IN <= FULL;
      MATRIX_MODULAR_MOD_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_MODULAR_MOD_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MOD_CASE 0          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_MOD_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_MOD_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MOD_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_MOD_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MOD_DATA_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MOD_CASE 1          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_MOD_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_MOD_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MOD_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_MOD_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MOD_DATA_IN <= TWO_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_MOD_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      MATRIX_MODULAR_ADDER_OPERATION <= '0';

      -- DATA
      MATRIX_MODULAR_ADDER_MODULO_IN <= FULL;
      MATRIX_MODULAR_ADDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_MODULAR_ADDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_ADDER_DATA_A_IN <= ONE_DATA;
        MATRIX_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_ADDER_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_ADDER_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
        MATRIX_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_ADDER_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_ADDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_ADDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MODULAR_MULTIPLIER_MODULO_IN <= FULL;
      MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 0   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_MULTIPLIER_DATA_A_IN <= ONE_DATA;
        MATRIX_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 1   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
        MATRIX_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_MULTIPLIER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_INVERTER_TEST       ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MODULAR_INVERTER_MODULO_IN <= FULL;
      MATRIX_MODULAR_INVERTER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_MODULAR_INVERTER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_INVERTER_CASE 0     ";
        -------------------------------------------------------------------

      -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_INVERTER_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_INVERTER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_INVERTER_DATA_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_INVERTER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_INVERTER_DATA_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_INVERTER_CASE 1     ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_INVERTER_DATA_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_INVERTER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_INVERTER_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_INVERTER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_INVERTER_DATA_IN <= TWO_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_INVERTER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MODULAR_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MODULAR_DIVIDER_MODULO_IN <= FULL;
      MATRIX_MODULAR_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_MODULAR_DIVIDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_MODULAR_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_DIVIDER_DATA_A_IN <= ONE_DATA;
        MATRIX_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_DIVIDER_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_DIVIDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_DIVIDER_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_DIVIDER_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_DIVIDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_DIVIDER_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      if (STIMULUS_NTM_MATRIX_MODULAR_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
        MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
        MATRIX_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_DIVIDER_DATA_OUT_I_ENABLE = '1') and (MATRIX_MODULAR_DIVIDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_DIVIDER_DATA_OUT_I_ENABLE = '0') and (MATRIX_MODULAR_DIVIDER_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_DIVIDER_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_DIVIDER_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_DIVIDER_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MODULAR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MODULAR_EXPONENTIATOR_MODULO_IN <= FULL;
      MATRIX_MODULAR_EXPONENTIATOR_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_MODULAR_EXPONENTIATOR_SIZE_J_IN <= THREE_CONTROL;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE 0";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MODULAR_EXPONENTIATOR_CASE_0) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN <= ONE_DATA;
        MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN <= ONE_DATA;
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_EXPONENTIATOR_READY = '1';

          -- GLOBAL
          wait until rising_edge(clk_int);
        end loop;
      end if;

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE 1";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_MATRIX_MODULAR_EXPONENTIATOR_CASE_1) then
        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
        MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
        MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

        -- DATA
        MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
        MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

        -- LOOP
        index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

        loop
          if ((MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1') and (unsigned(index_i_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_i_loop) <= unsigned(MATRIX_MODULAR_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MODULAR_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1') and (unsigned(index_j_loop) >= unsigned(ZERO_CONTROL)) and (unsigned(index_j_loop) <= unsigned(MATRIX_MODULAR_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN <= TWO_DATA;
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_MODULAR_EXPONENTIATOR_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- CONTROL
          exit when MATRIX_MODULAR_EXPONENTIATOR_READY = '1';

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
