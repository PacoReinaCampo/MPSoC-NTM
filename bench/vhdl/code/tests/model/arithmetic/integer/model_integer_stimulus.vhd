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
use work.model_integer_pkg.all;

entity model_integer_stimulus is
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

    ------------------------------------------------------------------------------
    -- STIMULUS SCALAR
    ------------------------------------------------------------------------------

    -- SCALAR ADDER
    -- CONTROL
    SCALAR_INTEGER_ADDER_START : out std_logic;
    SCALAR_INTEGER_ADDER_READY : in  std_logic;

    SCALAR_INTEGER_ADDER_OPERATION : out std_logic;

    -- DATA
    SCALAR_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    SCALAR_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

    -- SCALAR MULTIPLIER
    -- CONTROL
    SCALAR_INTEGER_MULTIPLIER_START : out std_logic;
    SCALAR_INTEGER_MULTIPLIER_READY : in  std_logic;

    -- DATA
    SCALAR_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    SCALAR_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR DIVIDER
    -- CONTROL
    SCALAR_INTEGER_DIVIDER_START : out std_logic;
    SCALAR_INTEGER_DIVIDER_READY : in  std_logic;

    -- DATA
    SCALAR_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    SCALAR_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS VECTOR
    ------------------------------------------------------------------------------

    -- VECTOR ADDER
    -- CONTROL
    VECTOR_INTEGER_ADDER_START : out std_logic;
    VECTOR_INTEGER_ADDER_READY : in  std_logic;

    VECTOR_INTEGER_ADDER_OPERATION : out std_logic;

    VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_INTEGER_ADDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    VECTOR_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

    -- VECTOR MULTIPLIER
    -- CONTROL
    VECTOR_INTEGER_MULTIPLIER_START : out std_logic;
    VECTOR_INTEGER_MULTIPLIER_READY : in  std_logic;

    VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_INTEGER_MULTIPLIER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    VECTOR_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR DIVIDER
    -- CONTROL
    VECTOR_INTEGER_DIVIDER_START : out std_logic;
    VECTOR_INTEGER_DIVIDER_READY : in  std_logic;

    VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_INTEGER_DIVIDER_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    VECTOR_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS MATRIX
    ------------------------------------------------------------------------------

    -- MATRIX ADDER
    -- CONTROL
    MATRIX_INTEGER_ADDER_START : out std_logic;
    MATRIX_INTEGER_ADDER_READY : in  std_logic;

    MATRIX_INTEGER_ADDER_OPERATION : out std_logic;

    MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INTEGER_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGER_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    MATRIX_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

    -- MATRIX MULTIPLIER
    -- CONTROL
    MATRIX_INTEGER_MULTIPLIER_START : out std_logic;
    MATRIX_INTEGER_MULTIPLIER_READY : in  std_logic;

    MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    MATRIX_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX DIVIDER
    -- CONTROL
    MATRIX_INTEGER_DIVIDER_START : out std_logic;
    MATRIX_INTEGER_DIVIDER_READY : in  std_logic;

    MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INTEGER_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGER_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    MATRIX_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS TENSOR
    ------------------------------------------------------------------------------

    -- TENSOR ADDER
    -- CONTROL
    TENSOR_INTEGER_ADDER_START : out std_logic;
    TENSOR_INTEGER_ADDER_READY : in  std_logic;

    TENSOR_INTEGER_ADDER_OPERATION : out std_logic;

    TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_INTEGER_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGER_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_INTEGER_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGER_ADDER_OVERFLOW_OUT : in std_logic;

    -- TENSOR MULTIPLIER
    -- CONTROL
    TENSOR_INTEGER_MULTIPLIER_START : out std_logic;
    TENSOR_INTEGER_MULTIPLIER_READY : in  std_logic;

    TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGER_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_INTEGER_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGER_MULTIPLIER_OVERFLOW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR DIVIDER
    -- CONTROL
    TENSOR_INTEGER_DIVIDER_START : out std_logic;
    TENSOR_INTEGER_DIVIDER_READY : in  std_logic;

    TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_INTEGER_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_DIVIDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGER_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGER_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_INTEGER_DIVIDER_DATA_OUT      : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGER_DIVIDER_REMAINDER_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_integer_stimulus_architecture of model_integer_stimulus is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

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

  constant MAX_POSITIVE : std_logic_vector(DATA_SIZE-1 downto 0) := "0111111111111111111111111111111111111111111111111111111111111111";
  constant MIN_NEGATIVE : std_logic_vector(DATA_SIZE-1 downto 0) := "1000000000000000000000000000000000000000000000000000000000000000";

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

  -- SCALAR-FUNCTIONALITY
  SCALAR_INTEGER_ADDER_START      <= start_int;
  SCALAR_INTEGER_MULTIPLIER_START <= start_int;
  SCALAR_INTEGER_DIVIDER_START    <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_INTEGER_ADDER_START      <= start_int;
  VECTOR_INTEGER_MULTIPLIER_START <= start_int;
  VECTOR_INTEGER_DIVIDER_START    <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_INTEGER_ADDER_START      <= start_int;
  MATRIX_INTEGER_MULTIPLIER_START <= start_int;
  MATRIX_INTEGER_DIVIDER_START    <= start_int;

  -- TENSOR-FUNCTIONALITY
  TENSOR_INTEGER_ADDER_START      <= start_int;
  TENSOR_INTEGER_MULTIPLIER_START <= start_int;
  TENSOR_INTEGER_DIVIDER_START    <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-INTEGER
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      SCALAR_INTEGER_ADDER_OPERATION <= '0';

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= MAX_POSITIVE;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= MAX_POSITIVE;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= MIN_NEGATIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_2) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 2        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= MIN_NEGATIVE;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_3) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 3        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= MIN_NEGATIVE;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= MIN_NEGATIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_4) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 4        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= INT_P_NINE;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= INT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_5) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 5        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= INT_P_TWO;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= INT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_6) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 6        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= INT_N_SEVEN;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= INT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_7) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_ADDER_CASE 7        ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_ADDER_DATA_A_IN <= INT_N_FOUR;
        SCALAR_INTEGER_ADDER_DATA_B_IN <= INT_N_SIX;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= MAX_POSITIVE;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= MAX_POSITIVE;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= MIN_NEGATIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_2) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 2   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= MIN_NEGATIVE;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_3) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 3   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= MIN_NEGATIVE;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= MIN_NEGATIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_4) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 4   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= INT_P_NINE;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= INT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_5) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 5   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= INT_P_TWO;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= INT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_6) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 6   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= INT_N_SEVEN;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= INT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_7) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_MULTIPLIER_CASE 7   ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_MULTIPLIER_DATA_A_IN <= INT_N_FOUR;
        SCALAR_INTEGER_MULTIPLIER_DATA_B_IN <= INT_N_SIX;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= MAX_POSITIVE;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= MAX_POSITIVE;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= MIN_NEGATIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_2) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 2      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= MIN_NEGATIVE;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= MAX_POSITIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_3) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 3      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= MIN_NEGATIVE;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= MIN_NEGATIVE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_4) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 4      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= INT_P_NINE;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= INT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_5) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 5      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= INT_P_TWO;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= INT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_6) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 6      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= INT_N_SEVEN;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= INT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_7) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_DIVIDER_CASE 7      ";
        -------------------------------------------------------------------

        SCALAR_INTEGER_DIVIDER_DATA_A_IN <= INT_N_FOUR;
        SCALAR_INTEGER_DIVIDER_DATA_B_IN <= INT_N_SIX;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-INTEGER
    -------------------------------------------------------------------

    if (STIMULUS_NTM_VECTOR_INTEGER_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      VECTOR_INTEGER_ADDER_OPERATION <= '0';

      -- DATA
      VECTOR_INTEGER_ADDER_SIZE_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_INTEGER_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGER_ADDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_INTEGER_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGER_ADDER_FIRST_RUN : loop
          if (VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGER_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_ADDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_ADDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE = '1' or VECTOR_INTEGER_ADDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGER_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_ADDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_ADDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGER_ADDER_FIRST_RUN when VECTOR_INTEGER_ADDER_READY = '1';
        end loop VECTOR_INTEGER_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_INTEGER_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGER_ADDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_INTEGER_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGER_ADDER_SECOND_RUN : loop
          if (VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGER_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_ADDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_ADDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE = '1' or VECTOR_INTEGER_ADDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGER_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_ADDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_ADDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGER_ADDER_SECOND_RUN when VECTOR_INTEGER_ADDER_READY = '1';
        end loop VECTOR_INTEGER_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_INTEGER_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_INTEGER_MULTIPLIER_SIZE_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGER_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        VECTOR_INTEGER_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGER_MULTIPLIER_FIRST_RUN : loop
          if (VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGER_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE = '1' or VECTOR_INTEGER_MULTIPLIER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGER_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGER_MULTIPLIER_FIRST_RUN when VECTOR_INTEGER_MULTIPLIER_READY = '1';
        end loop VECTOR_INTEGER_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGER_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        VECTOR_INTEGER_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGER_MULTIPLIER_SECOND_RUN : loop
          if (VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGER_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE = '1' or VECTOR_INTEGER_MULTIPLIER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGER_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGER_MULTIPLIER_SECOND_RUN when VECTOR_INTEGER_MULTIPLIER_READY = '1';
        end loop VECTOR_INTEGER_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_INTEGER_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_INTEGER_DIVIDER_SIZE_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_INTEGER_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGER_DIVIDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_INTEGER_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGER_DIVIDER_FIRST_RUN : loop
          if (VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGER_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE = '1' or VECTOR_INTEGER_DIVIDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGER_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGER_DIVIDER_FIRST_RUN when VECTOR_INTEGER_DIVIDER_READY = '1';
        end loop VECTOR_INTEGER_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_INTEGER_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGER_DIVIDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_INTEGER_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGER_DIVIDER_SECOND_RUN : loop
          if (VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGER_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE = '1' or VECTOR_INTEGER_DIVIDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGER_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGER_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_INTEGER_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGER_DIVIDER_SECOND_RUN when VECTOR_INTEGER_DIVIDER_READY = '1';
        end loop VECTOR_INTEGER_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX-INTEGER
    -------------------------------------------------------------------

    if (STIMULUS_NTM_MATRIX_INTEGER_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      MATRIX_INTEGER_ADDER_OPERATION <= '0';

      -- DATA
      MATRIX_INTEGER_ADDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_INTEGER_ADDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_INTEGER_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGER_ADDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_INTEGER_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGER_ADDER_FIRST_RUN : loop
          if (MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' or MATRIX_INTEGER_ADDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGER_ADDER_FIRST_RUN when MATRIX_INTEGER_ADDER_READY = '1';
        end loop MATRIX_INTEGER_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_INTEGER_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGER_ADDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_INTEGER_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGER_ADDER_SECOND_RUN : loop
          if (MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' or MATRIX_INTEGER_ADDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGER_ADDER_SECOND_RUN when MATRIX_INTEGER_ADDER_READY = '1';
        end loop MATRIX_INTEGER_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_INTEGER_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGER_MULTIPLIER_FIRST_RUN : loop
          if (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' or MATRIX_INTEGER_MULTIPLIER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGER_MULTIPLIER_FIRST_RUN when MATRIX_INTEGER_MULTIPLIER_READY = '1';
        end loop MATRIX_INTEGER_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGER_MULTIPLIER_SECOND_RUN : loop
          if (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' or MATRIX_INTEGER_MULTIPLIER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGER_MULTIPLIER_SECOND_RUN when MATRIX_INTEGER_MULTIPLIER_READY = '1';
        end loop MATRIX_INTEGER_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_INTEGER_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_INTEGER_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_INTEGER_DIVIDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_INTEGER_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGER_DIVIDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_INTEGER_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGER_DIVIDER_FIRST_RUN : loop
          if (MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' or MATRIX_INTEGER_DIVIDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGER_DIVIDER_FIRST_RUN when MATRIX_INTEGER_DIVIDER_READY = '1';
        end loop MATRIX_INTEGER_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_INTEGER_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGER_DIVIDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_INTEGER_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGER_DIVIDER_SECOND_RUN : loop
          if (MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGER_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_INTEGER_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' or MATRIX_INTEGER_DIVIDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGER_DIVIDER_SECOND_RUN when MATRIX_INTEGER_DIVIDER_READY = '1';
        end loop MATRIX_INTEGER_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- TENSOR-INTEGER
    -------------------------------------------------------------------

    if (STIMULUS_NTM_TENSOR_INTEGER_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      TENSOR_INTEGER_ADDER_OPERATION <= '0';

      -- DATA
      TENSOR_INTEGER_ADDER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_INTEGER_ADDER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_INTEGER_ADDER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_INTEGER_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGER_ADDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_INTEGER_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGER_ADDER_FIRST_RUN : loop
          if (TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' or TENSOR_INTEGER_ADDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGER_ADDER_FIRST_RUN when TENSOR_INTEGER_ADDER_READY = '1';
        end loop TENSOR_INTEGER_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_INTEGER_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGER_ADDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_INTEGER_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGER_ADDER_SECOND_RUN : loop
          if (TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGER_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGER_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE = '1' or TENSOR_INTEGER_ADDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGER_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGER_ADDER_SECOND_RUN when TENSOR_INTEGER_ADDER_READY = '1';
        end loop TENSOR_INTEGER_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_INTEGER_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGER_MULTIPLIER_FIRST_RUN : loop
          if (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' or TENSOR_INTEGER_MULTIPLIER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGER_MULTIPLIER_FIRST_RUN when TENSOR_INTEGER_MULTIPLIER_READY = '1';
        end loop TENSOR_INTEGER_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGER_MULTIPLIER_SECOND_RUN : loop
          if (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE = '1' or TENSOR_INTEGER_MULTIPLIER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGER_MULTIPLIER_SECOND_RUN when TENSOR_INTEGER_MULTIPLIER_READY = '1';
        end loop TENSOR_INTEGER_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_INTEGER_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_INTEGER_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_INTEGER_DIVIDER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_INTEGER_DIVIDER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_INTEGER_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGER_DIVIDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_INTEGER_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGER_DIVIDER_FIRST_RUN : loop
          if (TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' or TENSOR_INTEGER_DIVIDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGER_DIVIDER_FIRST_RUN when TENSOR_INTEGER_DIVIDER_READY = '1';
        end loop TENSOR_INTEGER_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_INTEGER_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGER_DIVIDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_INTEGER_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGER_DIVIDER_SECOND_RUN : loop
          if (TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGER_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_INTEGER_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGER_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGER_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE = '1' or TENSOR_INTEGER_DIVIDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGER_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGER_DIVIDER_SECOND_RUN when TENSOR_INTEGER_DIVIDER_READY = '1';
        end loop TENSOR_INTEGER_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
