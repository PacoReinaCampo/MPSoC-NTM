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
use work.model_float_pkg.all;

entity model_float_stimulus is
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

    ------------------------------------------------------------------------------
    -- STIMULUS SCALAR FLOAT
    ------------------------------------------------------------------------------

    -- SCALAR FLOAT ADDER
    -- CONTROL
    SCALAR_FLOAT_ADDER_START : out std_logic;
    SCALAR_FLOAT_ADDER_READY : in  std_logic;

    SCALAR_FLOAT_ADDER_OPERATION : out std_logic;

    -- DATA
    SCALAR_FLOAT_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_ADDER_OVERFLOW_OUT : in  std_logic;

    -- SCALAR FLOAT MULTIPLIER
    -- CONTROL
    SCALAR_FLOAT_MULTIPLIER_START : out std_logic;
    SCALAR_FLOAT_MULTIPLIER_READY : in  std_logic;

    -- DATA
    SCALAR_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

    -- SCALAR FLOAT DIVIDER
    -- CONTROL
    SCALAR_FLOAT_DIVIDER_START : out std_logic;
    SCALAR_FLOAT_DIVIDER_READY : in  std_logic;

    -- DATA
    SCALAR_FLOAT_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FLOAT_DIVIDER_OVERFLOW_OUT : in  std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS VECTOR FLOAT
    ------------------------------------------------------------------------------

    -- VECTOR FLOAT ADDER
    -- CONTROL
    VECTOR_FLOAT_ADDER_START : out std_logic;
    VECTOR_FLOAT_ADDER_READY : in  std_logic;

    VECTOR_FLOAT_ADDER_OPERATION : out std_logic;

    VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_FLOAT_ADDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_FLOAT_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_ADDER_OVERFLOW_OUT : in  std_logic;

    -- VECTOR FLOAT MULTIPLIER
    -- CONTROL
    VECTOR_FLOAT_MULTIPLIER_START : out std_logic;
    VECTOR_FLOAT_MULTIPLIER_READY : in  std_logic;

    VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_FLOAT_MULTIPLIER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

    -- VECTOR FLOAT DIVIDER
    -- CONTROL
    VECTOR_FLOAT_DIVIDER_START : out std_logic;
    VECTOR_FLOAT_DIVIDER_READY : in  std_logic;

    VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_FLOAT_DIVIDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_FLOAT_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FLOAT_DIVIDER_OVERFLOW_OUT : in  std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS MATRIX FLOAT
    ------------------------------------------------------------------------------

    -- MATRIX FLOAT ADDER
    -- CONTROL
    MATRIX_FLOAT_ADDER_START : out std_logic;
    MATRIX_FLOAT_ADDER_READY : in  std_logic;

    MATRIX_FLOAT_ADDER_OPERATION : out std_logic;

    MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_FLOAT_ADDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FLOAT_ADDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FLOAT_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_ADDER_OVERFLOW_OUT : in  std_logic;

    -- MATRIX FLOAT MULTIPLIER
    -- CONTROL
    MATRIX_FLOAT_MULTIPLIER_START : out std_logic;
    MATRIX_FLOAT_MULTIPLIER_READY : in  std_logic;

    MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FLOAT_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

    -- MATRIX FLOAT DIVIDER
    -- CONTROL
    MATRIX_FLOAT_DIVIDER_START : out std_logic;
    MATRIX_FLOAT_DIVIDER_READY : in  std_logic;

    MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_FLOAT_DIVIDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FLOAT_DIVIDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FLOAT_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FLOAT_DIVIDER_OVERFLOW_OUT : in  std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS TENSOR
    ------------------------------------------------------------------------------

    -- TENSOR ADDER
    -- CONTROL
    TENSOR_FLOAT_ADDER_START : out std_logic;
    TENSOR_FLOAT_ADDER_READY : in  std_logic;

    TENSOR_FLOAT_ADDER_OPERATION : out std_logic;

    TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_FLOAT_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FLOAT_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_FLOAT_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FLOAT_ADDER_OVERFLOW_OUT : in std_logic;

    -- TENSOR MULTIPLIER
    -- CONTROL
    TENSOR_FLOAT_MULTIPLIER_START : out std_logic;
    TENSOR_FLOAT_MULTIPLIER_READY : in  std_logic;

    TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FLOAT_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_FLOAT_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FLOAT_MULTIPLIER_OVERFLOW_OUT : in std_logic;

    -- TENSOR DIVIDER
    -- CONTROL
    TENSOR_FLOAT_DIVIDER_START : out std_logic;
    TENSOR_FLOAT_DIVIDER_READY : in  std_logic;

    TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_FLOAT_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_DIVIDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FLOAT_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FLOAT_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_FLOAT_DIVIDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FLOAT_DIVIDER_OVERFLOW_OUT : in std_logic
    );
end entity;

architecture model_float_stimulus_architecture of model_float_stimulus is

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
  SCALAR_FLOAT_ADDER_START      <= start_int;
  SCALAR_FLOAT_MULTIPLIER_START <= start_int;
  SCALAR_FLOAT_DIVIDER_START    <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_FLOAT_ADDER_START      <= start_int;
  VECTOR_FLOAT_MULTIPLIER_START <= start_int;
  VECTOR_FLOAT_DIVIDER_START    <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_FLOAT_ADDER_START      <= start_int;
  MATRIX_FLOAT_MULTIPLIER_START <= start_int;
  MATRIX_FLOAT_DIVIDER_START    <= start_int;

  -- TENSOR-FUNCTIONALITY
  TENSOR_FLOAT_ADDER_START      <= start_int;
  TENSOR_FLOAT_MULTIPLIER_START <= start_int;
  TENSOR_FLOAT_DIVIDER_START    <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-FLOAT
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_TEST    ";
      -------------------------------------------------------------------

      -- CONTROL
      SCALAR_FLOAT_ADDER_OPERATION <= '0';

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 0  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 1  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_2) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 2  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_3) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 3  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_4) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 4  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_NINE;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_5) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 5  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_TWO;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_6) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 6  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_SEVEN;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_7) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 7  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_FOUR;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_SIX;
      end if;

      -- CONTROL
      SCALAR_FLOAT_ADDER_OPERATION <= '1';

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_8) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 8  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_9) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 9  ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_10) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 10 ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_11) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 11 ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_12) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 12 ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_NINE;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_13) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 13 ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_P_TWO;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_14) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 14 ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_SEVEN;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_15) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE 15 ";
        -------------------------------------------------------------------

        SCALAR_FLOAT_ADDER_DATA_A_IN <= FLOAT_N_FOUR;
        SCALAR_FLOAT_ADDER_DATA_B_IN <= FLOAT_N_SIX;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIE_TEST";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 0";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 1";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_2) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 2";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_3) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 3";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_4) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 4";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_5) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 5";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_6) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 6";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_7) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 7";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_8) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 8";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_NINE;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_9) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIPL_CASE 9";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_TWO;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_10) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIP_CASE 10";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_SEVEN;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_11) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIP_CASE 11";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_FOUR;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_SIX;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_12) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIP_CASE 12";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_NINE;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_13) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIP_CASE 13";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_N_TWO;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_14) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIP_CASE 14";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_SEVEN;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_N_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_15) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_MULTIP_CASE 15";
        -------------------------------------------------------------------

        SCALAR_FLOAT_MULTIPLIER_DATA_A_IN <= FLOAT_P_FOUR;
        SCALAR_FLOAT_MULTIPLIER_DATA_B_IN <= FLOAT_P_SIX;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_TEST  ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 0";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 1";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_INF;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_2) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 2";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_3) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 3";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_INF;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_INF;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_4) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 4";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_ZERO;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_5) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 5";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_ZERO;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_6) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 6";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_ZERO;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_7) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 7";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_ZERO;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_ZERO;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_8) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 8";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_NINE;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_9) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE 9";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_TWO;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_10) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDE_CASE 10";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_SEVEN;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_11) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDE_CASE 11";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_FOUR;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_SIX;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_12) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDE_CASE 12";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_NINE;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_ONE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_13) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDE_CASE 13";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_N_TWO;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_EIGHT;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_14) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDE_CASE 14";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_SEVEN;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_N_THREE;
      end if;

      if (STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_15) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FLOAT_DIVIDE_CASE 15";
        -------------------------------------------------------------------

        SCALAR_FLOAT_DIVIDER_DATA_A_IN <= FLOAT_P_FOUR;
        SCALAR_FLOAT_DIVIDER_DATA_B_IN <= FLOAT_P_SIX;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-FLOAT
    -------------------------------------------------------------------

    if (STIMULUS_NTM_VECTOR_FLOAT_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- OPERATION
      VECTOR_FLOAT_ADDER_OPERATION <= '0';

      -- DATA
      VECTOR_FLOAT_ADDER_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_FLOAT_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FLOAT_ADDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FLOAT_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FLOAT_ADDER_FIRST_RUN : loop
          if (VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FLOAT_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_ADDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_ADDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE = '1' or VECTOR_FLOAT_ADDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FLOAT_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_ADDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_ADDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FLOAT_ADDER_FIRST_RUN when VECTOR_FLOAT_ADDER_READY = '1';
        end loop VECTOR_FLOAT_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_FLOAT_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FLOAT_ADDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FLOAT_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FLOAT_ADDER_SECOND_RUN : loop
          if (VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FLOAT_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_ADDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_ADDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE = '1' or VECTOR_FLOAT_ADDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FLOAT_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_ADDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_ADDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FLOAT_ADDER_SECOND_RUN when VECTOR_FLOAT_ADDER_READY = '1';
        end loop VECTOR_FLOAT_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_FLOAT_MULTIPLIER_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FLOAT_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FLOAT_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FLOAT_MULTIPLIER_FIRST_RUN : loop
          if (VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FLOAT_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE = '1' or VECTOR_FLOAT_MULTIPLIER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FLOAT_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FLOAT_MULTIPLIER_FIRST_RUN when VECTOR_FLOAT_MULTIPLIER_READY = '1';
        end loop VECTOR_FLOAT_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FLOAT_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FLOAT_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FLOAT_MULTIPLIER_SECOND_RUN : loop
          if (VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FLOAT_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE = '1' or VECTOR_FLOAT_MULTIPLIER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FLOAT_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FLOAT_MULTIPLIER_SECOND_RUN when VECTOR_FLOAT_MULTIPLIER_READY = '1';
        end loop VECTOR_FLOAT_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_FLOAT_DIVIDER_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FLOAT_DIVIDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FLOAT_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FLOAT_DIVIDER_FIRST_RUN : loop
          if (VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FLOAT_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE = '1' or VECTOR_FLOAT_DIVIDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FLOAT_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FLOAT_DIVIDER_FIRST_RUN when VECTOR_FLOAT_DIVIDER_READY = '1';
        end loop VECTOR_FLOAT_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FLOAT_DIVIDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FLOAT_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FLOAT_DIVIDER_SECOND_RUN : loop
          if (VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FLOAT_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE = '1' or VECTOR_FLOAT_DIVIDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FLOAT_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FLOAT_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FLOAT_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FLOAT_DIVIDER_SECOND_RUN when VECTOR_FLOAT_DIVIDER_READY = '1';
        end loop VECTOR_FLOAT_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX-FLOAT
    -------------------------------------------------------------------

    if (STIMULUS_NTM_MATRIX_FLOAT_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      MATRIX_FLOAT_ADDER_OPERATION <= '0';

      -- DATA
      MATRIX_FLOAT_ADDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_FLOAT_ADDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_FLOAT_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FLOAT_ADDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FLOAT_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FLOAT_ADDER_FIRST_RUN : loop
          if (MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FLOAT_ADDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FLOAT_ADDER_FIRST_RUN when MATRIX_FLOAT_ADDER_READY = '1';
        end loop MATRIX_FLOAT_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_FLOAT_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FLOAT_ADDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FLOAT_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FLOAT_ADDER_SECOND_RUN : loop
          if (MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FLOAT_ADDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FLOAT_ADDER_SECOND_RUN when MATRIX_FLOAT_ADDER_READY = '1';
        end loop MATRIX_FLOAT_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FLOAT_MULTIPLIER_FIRST_RUN : loop
          if (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' or MATRIX_FLOAT_MULTIPLIER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FLOAT_MULTIPLIER_FIRST_RUN when MATRIX_FLOAT_MULTIPLIER_READY = '1';
        end loop MATRIX_FLOAT_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FLOAT_MULTIPLIER_SECOND_RUN : loop
          if (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' or MATRIX_FLOAT_MULTIPLIER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FLOAT_MULTIPLIER_SECOND_RUN when MATRIX_FLOAT_MULTIPLIER_READY = '1';
        end loop MATRIX_FLOAT_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_FLOAT_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_FLOAT_DIVIDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FLOAT_DIVIDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FLOAT_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FLOAT_DIVIDER_FIRST_RUN : loop
          if (MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FLOAT_DIVIDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FLOAT_DIVIDER_FIRST_RUN when MATRIX_FLOAT_DIVIDER_READY = '1';
        end loop MATRIX_FLOAT_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FLOAT_DIVIDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FLOAT_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FLOAT_DIVIDER_SECOND_RUN : loop
          if (MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FLOAT_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FLOAT_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FLOAT_DIVIDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FLOAT_DIVIDER_SECOND_RUN when MATRIX_FLOAT_DIVIDER_READY = '1';
        end loop MATRIX_FLOAT_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- TENSOR-FLOAT
    -------------------------------------------------------------------

    if (STIMULUS_NTM_TENSOR_FLOAT_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      TENSOR_FLOAT_ADDER_OPERATION <= '0';

      -- DATA
      TENSOR_FLOAT_ADDER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_FLOAT_ADDER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_FLOAT_ADDER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_FLOAT_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FLOAT_ADDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FLOAT_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FLOAT_ADDER_FIRST_RUN : loop
          if (TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FLOAT_ADDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FLOAT_ADDER_FIRST_RUN when TENSOR_FLOAT_ADDER_READY = '1';
        end loop TENSOR_FLOAT_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_FLOAT_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FLOAT_ADDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FLOAT_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FLOAT_ADDER_SECOND_RUN : loop
          if (TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FLOAT_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FLOAT_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FLOAT_ADDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FLOAT_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FLOAT_ADDER_SECOND_RUN when TENSOR_FLOAT_ADDER_READY = '1';
        end loop TENSOR_FLOAT_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FLOAT_MULTIPLIER_FIRST_RUN : loop
          if (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' or TENSOR_FLOAT_MULTIPLIER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FLOAT_MULTIPLIER_FIRST_RUN when TENSOR_FLOAT_MULTIPLIER_READY = '1';
        end loop TENSOR_FLOAT_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FLOAT_MULTIPLIER_SECOND_RUN : loop
          if (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE = '1' or TENSOR_FLOAT_MULTIPLIER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FLOAT_MULTIPLIER_SECOND_RUN when TENSOR_FLOAT_MULTIPLIER_READY = '1';
        end loop TENSOR_FLOAT_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_FLOAT_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_FLOAT_DIVIDER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_FLOAT_DIVIDER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FLOAT_DIVIDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FLOAT_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FLOAT_DIVIDER_FIRST_RUN : loop
          if (TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FLOAT_DIVIDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FLOAT_DIVIDER_FIRST_RUN when TENSOR_FLOAT_DIVIDER_READY = '1';
        end loop TENSOR_FLOAT_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FLOAT_DIVIDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FLOAT_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FLOAT_DIVIDER_SECOND_RUN : loop
          if (TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FLOAT_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FLOAT_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FLOAT_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FLOAT_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FLOAT_DIVIDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FLOAT_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FLOAT_DIVIDER_SECOND_RUN when TENSOR_FLOAT_DIVIDER_READY = '1';
        end loop TENSOR_FLOAT_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
