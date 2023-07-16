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
-- out the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included out
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
use work.model_function_pkg.all;

entity model_function_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x out 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y out 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j out 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k out 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l out 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i out 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS SCALAR
    ------------------------------------------------------------------------------

    -- SCALAR LOGISTIC
    -- CONTROL
    SCALAR_LOGISTIC_START : out std_logic;
    SCALAR_LOGISTIC_READY : in  std_logic;

    -- DATA
    SCALAR_LOGISTIC_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LOGISTIC_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR ONEPLUS
    -- CONTROL
    SCALAR_ONEPLUS_START : out std_logic;
    SCALAR_ONEPLUS_READY : in  std_logic;

    -- DATA
    SCALAR_ONEPLUS_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_ONEPLUS_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS VECTOR
    ------------------------------------------------------------------------------

    -- VECTOR LOGISTIC
    -- CONTROL
    VECTOR_LOGISTIC_START : out std_logic;
    VECTOR_LOGISTIC_READY : in  std_logic;

    VECTOR_LOGISTIC_DATA_IN_ENABLE : out std_logic;

    VECTOR_LOGISTIC_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_LOGISTIC_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_LOGISTIC_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGISTIC_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR ONEPLUS
    -- CONTROL
    VECTOR_ONEPLUS_START : out std_logic;
    VECTOR_ONEPLUS_READY : in  std_logic;

    VECTOR_ONEPLUS_DATA_IN_ENABLE : out std_logic;

    VECTOR_ONEPLUS_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_ONEPLUS_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_ONEPLUS_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_ONEPLUS_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS MATRIX
    ------------------------------------------------------------------------------

    -- MATRIX LOGISTIC
    -- CONTROL
    MATRIX_LOGISTIC_START : out std_logic;
    MATRIX_LOGISTIC_READY : in  std_logic;

    MATRIX_LOGISTIC_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_LOGISTIC_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_LOGISTIC_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_LOGISTIC_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_LOGISTIC_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGISTIC_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGISTIC_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGISTIC_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX ONEPLUS
    -- CONTROL
    MATRIX_ONEPLUS_START : out std_logic;
    MATRIX_ONEPLUS_READY : in  std_logic;

    MATRIX_ONEPLUS_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_ONEPLUS_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_ONEPLUS_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_ONEPLUS_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_ONEPLUS_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_ONEPLUS_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_ONEPLUS_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_ONEPLUS_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_function_stimulus_architecture of model_function_stimulus is

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
  SCALAR_LOGISTIC_START <= start_int;
  SCALAR_ONEPLUS_START  <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_LOGISTIC_START <= start_int;
  VECTOR_ONEPLUS_START  <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_LOGISTIC_START <= start_int;
  MATRIX_ONEPLUS_START  <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_NTM_SCALAR_LOGISTIC_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_SCALAR_LOGISTIC_TEST                                   ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_SCALAR_LOGISTIC_CASE 0                                 ";
        -------------------------------------------------------------------

        SCALAR_LOGISTIC_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_SCALAR_LOGISTIC_CASE 1                                 ";
        -------------------------------------------------------------------

        SCALAR_LOGISTIC_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_SCALAR_ONEPLUS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_SCALAR_ONEPLUS_TEST                                    ";
      -------------------------------------------------------------------

      if (STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_SCALAR_ONEPLUS_CASE 0                                  ";
        -------------------------------------------------------------------

        SCALAR_ONEPLUS_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_SCALAR_ONEPLUS_CASE 1                                  ";
        -------------------------------------------------------------------

        SCALAR_ONEPLUS_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_NTM_VECTOR_LOGISTIC_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_LOGISTIC_TEST                                   ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_LOGISTIC_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_LOGISTIC_CASE 0                                 ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_LOGISTIC_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_LOGISTIC_FIRST_RUN : loop
          if (VECTOR_LOGISTIC_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_LOGISTIC_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGISTIC_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGISTIC_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_LOGISTIC_DATA_OUT_ENABLE = '1' or VECTOR_LOGISTIC_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_LOGISTIC_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGISTIC_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGISTIC_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_LOGISTIC_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_LOGISTIC_FIRST_RUN when VECTOR_LOGISTIC_READY = '1';
        end loop VECTOR_LOGISTIC_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_LOGISTIC_CASE 1                                 ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_LOGISTIC_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_LOGISTIC_SECOND_RUN : loop
          if ((VECTOR_LOGISTIC_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_LOGISTIC_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGISTIC_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGISTIC_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_LOGISTIC_DATA_OUT_ENABLE = '1') or (VECTOR_LOGISTIC_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_LOGISTIC_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGISTIC_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGISTIC_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_LOGISTIC_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_LOGISTIC_SECOND_RUN when VECTOR_LOGISTIC_READY = '1';
        end loop VECTOR_LOGISTIC_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_ONEPLUS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_ONEPLUS_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_ONEPLUS_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_ONEPLUS_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_ONEPLUS_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_ONEPLUS_FIRST_RUN : loop
          if (VECTOR_ONEPLUS_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_ONEPLUS_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_ONEPLUS_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_ONEPLUS_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_ONEPLUS_DATA_OUT_ENABLE = '1' or VECTOR_ONEPLUS_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_ONEPLUS_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_ONEPLUS_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_ONEPLUS_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_ONEPLUS_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_ONEPLUS_FIRST_RUN when VECTOR_ONEPLUS_READY = '1';
        end loop VECTOR_ONEPLUS_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_ONEPLUS_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_ONEPLUS_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_ONEPLUS_SECOND_RUN : loop
          if ((VECTOR_ONEPLUS_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_ONEPLUS_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_ONEPLUS_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_ONEPLUS_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_ONEPLUS_DATA_OUT_ENABLE = '1') or (VECTOR_ONEPLUS_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_ONEPLUS_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_ONEPLUS_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_ONEPLUS_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_ONEPLUS_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_ONEPLUS_SECOND_RUN when VECTOR_ONEPLUS_READY = '1';
        end loop VECTOR_ONEPLUS_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_NTM_MATRIX_LOGISTIC_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_LOGISTIC_TEST                                   ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_LOGISTIC_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_LOGISTIC_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_LOGISTIC_CASE 0                                 ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_LOGISTIC_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_LOGISTIC_FIRST_RUN : loop
          if (MATRIX_LOGISTIC_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGISTIC_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGISTIC_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGISTIC_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGISTIC_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_I_ENABLE <= '0';
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_LOGISTIC_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGISTIC_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_LOGISTIC_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGISTIC_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' or MATRIX_LOGISTIC_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_LOGISTIC_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_LOGISTIC_FIRST_RUN when MATRIX_LOGISTIC_READY = '1';
        end loop MATRIX_LOGISTIC_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_LOGISTIC_CASE 1                                 ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_LOGISTIC_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_LOGISTIC_SECOND_RUN : loop
          if (MATRIX_LOGISTIC_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGISTIC_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGISTIC_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGISTIC_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGISTIC_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_LOGISTIC_DATA_IN_I_ENABLE <= '0';
            MATRIX_LOGISTIC_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_LOGISTIC_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGISTIC_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_LOGISTIC_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGISTIC_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_LOGISTIC_DATA_OUT_J_ENABLE = '1' or MATRIX_LOGISTIC_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_LOGISTIC_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_LOGISTIC_SECOND_RUN when MATRIX_LOGISTIC_READY = '1';
        end loop MATRIX_LOGISTIC_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_ONEPLUS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_ONEPLUS_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_ONEPLUS_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_ONEPLUS_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_ONEPLUS_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_ONEPLUS_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_ONEPLUS_FIRST_RUN : loop
          if (MATRIX_ONEPLUS_DATA_OUT_I_ENABLE = '1' and MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_ONEPLUS_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_I_ENABLE <= '1';
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_ONEPLUS_DATA_OUT_I_ENABLE = '1' and MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_ONEPLUS_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_I_ENABLE <= '1';
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_ONEPLUS_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_I_ENABLE <= '0';
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_ONEPLUS_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_ONEPLUS_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_ONEPLUS_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_ONEPLUS_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' or MATRIX_ONEPLUS_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_ONEPLUS_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_ONEPLUS_FIRST_RUN when MATRIX_ONEPLUS_READY = '1';
        end loop MATRIX_ONEPLUS_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_ONEPLUS_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_ONEPLUS_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_ONEPLUS_SECOND_RUN : loop
          if (MATRIX_ONEPLUS_DATA_OUT_I_ENABLE = '1' and MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_ONEPLUS_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_I_ENABLE <= '1';
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_ONEPLUS_DATA_OUT_I_ENABLE = '1' and MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_ONEPLUS_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_I_ENABLE <= '1';
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_ONEPLUS_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_ONEPLUS_DATA_IN_I_ENABLE <= '0';
            MATRIX_ONEPLUS_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_ONEPLUS_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_ONEPLUS_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_ONEPLUS_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_ONEPLUS_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_ONEPLUS_DATA_OUT_J_ENABLE = '1' or MATRIX_ONEPLUS_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_ONEPLUS_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_ONEPLUS_SECOND_RUN when MATRIX_ONEPLUS_READY = '1';
        end loop MATRIX_ONEPLUS_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
