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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;
use work.accelerator_series_pkg.all;

entity accelerator_series_stimulus is
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

    -- SCALAR COSH
    -- CONTROL
    SCALAR_COSH_START : out std_logic;
    SCALAR_COSH_READY : in  std_logic;

    -- DATA
    SCALAR_COSH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_COSH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR EXPONENTIATOR
    -- CONTROL
    SCALAR_EXPONENTIATOR_START : out std_logic;
    SCALAR_EXPONENTIATOR_READY : in  std_logic;

    -- DATA
    SCALAR_EXPONENTIATOR_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_EXPONENTIATOR_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR LOGARITHM
    -- CONTROL
    SCALAR_LOGARITHM_START : out std_logic;
    SCALAR_LOGARITHM_READY : in  std_logic;

    -- DATA
    SCALAR_LOGARITHM_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_LOGARITHM_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR SINH
    -- CONTROL
    SCALAR_SINH_START : out std_logic;
    SCALAR_SINH_READY : in  std_logic;

    -- DATA
    SCALAR_SINH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_SINH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- SCALAR TANH
    -- CONTROL
    SCALAR_TANH_START : out std_logic;
    SCALAR_TANH_READY : in  std_logic;

    -- DATA
    SCALAR_TANH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_TANH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS VECTOR
    ------------------------------------------------------------------------------

    -- VECTOR COSH
    -- CONTROL
    VECTOR_COSH_START : out std_logic;
    VECTOR_COSH_READY : in  std_logic;

    VECTOR_COSH_DATA_IN_ENABLE : out std_logic;

    VECTOR_COSH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_COSH_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_COSH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR EXPONENTIATOR
    -- CONTROL
    VECTOR_EXPONENTIATOR_START : out std_logic;
    VECTOR_EXPONENTIATOR_READY : in  std_logic;

    VECTOR_EXPONENTIATOR_DATA_IN_ENABLE : out std_logic;

    VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_EXPONENTIATOR_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_EXPONENTIATOR_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR LOGARITHM
    -- CONTROL
    VECTOR_LOGARITHM_START : out std_logic;
    VECTOR_LOGARITHM_READY : in  std_logic;

    VECTOR_LOGARITHM_DATA_IN_ENABLE : out std_logic;

    VECTOR_LOGARITHM_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_LOGARITHM_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_LOGARITHM_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_LOGARITHM_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SINH
    -- CONTROL
    VECTOR_SINH_START : out std_logic;
    VECTOR_SINH_READY : in  std_logic;

    VECTOR_SINH_DATA_IN_ENABLE : out std_logic;

    VECTOR_SINH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_SINH_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SINH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SINH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR TANH
    -- CONTROL
    VECTOR_TANH_START : out std_logic;
    VECTOR_TANH_READY : in  std_logic;

    VECTOR_TANH_DATA_IN_ENABLE : out std_logic;

    VECTOR_TANH_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_TANH_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_TANH_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_TANH_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    ------------------------------------------------------------------------------
    -- STIMULUS MATRIX
    ------------------------------------------------------------------------------

    -- MATRIX COSH
    -- CONTROL
    MATRIX_COSH_START : out std_logic;
    MATRIX_COSH_READY : in  std_logic;

    MATRIX_COSH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_COSH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_COSH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_COSH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_COSH_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSH_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_COSH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_COSH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX EXPONENTIATOR
    -- CONTROL
    MATRIX_EXPONENTIATOR_START : out std_logic;
    MATRIX_EXPONENTIATOR_READY : in  std_logic;

    MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_EXPONENTIATOR_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_EXPONENTIATOR_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX LOGARITHM
    -- CONTROL
    MATRIX_LOGARITHM_START : out std_logic;
    MATRIX_LOGARITHM_READY : in  std_logic;

    MATRIX_LOGARITHM_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_LOGARITHM_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_LOGARITHM_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_LOGARITHM_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_LOGARITHM_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGARITHM_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_LOGARITHM_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_LOGARITHM_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SINH
    -- CONTROL
    MATRIX_SINH_START : out std_logic;
    MATRIX_SINH_READY : in  std_logic;

    MATRIX_SINH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_SINH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_SINH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_SINH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_SINH_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SINH_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SINH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SINH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TANH
    -- CONTROL
    MATRIX_TANH_START : out std_logic;
    MATRIX_TANH_READY : in  std_logic;

    MATRIX_TANH_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_TANH_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_TANH_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_TANH_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_TANH_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TANH_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TANH_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TANH_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_series_stimulus_architecture of accelerator_series_stimulus is

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
  SCALAR_COSH_START          <= start_int;
  SCALAR_EXPONENTIATOR_START <= start_int;
  SCALAR_LOGARITHM_START     <= start_int;
  SCALAR_SINH_START          <= start_int;
  SCALAR_TANH_START          <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_COSH_START          <= start_int;
  VECTOR_EXPONENTIATOR_START <= start_int;
  VECTOR_LOGARITHM_START     <= start_int;
  VECTOR_SINH_START          <= start_int;
  VECTOR_TANH_START          <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_COSH_START          <= start_int;
  MATRIX_EXPONENTIATOR_START <= start_int;
  MATRIX_LOGARITHM_START     <= start_int;
  MATRIX_SINH_START          <= start_int;
  MATRIX_TANH_START          <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_SCALAR_COSH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_COSH_TEST           ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_COSH_CASE 0         ";
        -------------------------------------------------------------------

        SCALAR_COSH_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_COSH_CASE 1         ";
        -------------------------------------------------------------------

        SCALAR_COSH_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 0";
        -------------------------------------------------------------------

        SCALAR_EXPONENTIATOR_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE 1";
        -------------------------------------------------------------------

        SCALAR_EXPONENTIATOR_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_LOGARITHM_TEST      ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LOGARITHM_CASE 0    ";
        -------------------------------------------------------------------

        SCALAR_LOGARITHM_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_LOGARITHM_CASE 1    ";
        -------------------------------------------------------------------

        SCALAR_LOGARITHM_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_SCALAR_SINH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_SINH_TEST           ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SINH_CASE 0         ";
        -------------------------------------------------------------------

        SCALAR_SINH_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_SINH_CASE 1         ";
        -------------------------------------------------------------------

        SCALAR_SINH_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_SCALAR_TANH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_TANH_TEST           ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_TANH_CASE 0         ";
        -------------------------------------------------------------------

        SCALAR_TANH_DATA_IN <= SCALAR_SAMPLE_A;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_TANH_CASE 1         ";
        -------------------------------------------------------------------

        SCALAR_TANH_DATA_IN <= SCALAR_SAMPLE_B;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_VECTOR_COSH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_COSH_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_COSH_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_COSH_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_COSH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_COSH_FIRST_RUN : loop
          if (VECTOR_COSH_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_COSH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSH_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_COSH_DATA_OUT_ENABLE = '1' or VECTOR_COSH_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_COSH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSH_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_COSH_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_COSH_FIRST_RUN when VECTOR_COSH_READY = '1';
        end loop VECTOR_COSH_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_COSH_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_COSH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_COSH_SECOND_RUN : loop
          if ((VECTOR_COSH_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_COSH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSH_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_COSH_DATA_OUT_ENABLE = '1') or (VECTOR_COSH_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_COSH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSH_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_COSH_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_COSH_SECOND_RUN when VECTOR_COSH_READY = '1';
        end loop VECTOR_COSH_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_EXPONENTIATOR_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE 0";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_EXPONENTIATOR_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_EXPONENTIATOR_FIRST_RUN : loop
          if (VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_EXPONENTIATOR_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE = '1' or VECTOR_EXPONENTIATOR_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_EXPONENTIATOR_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_EXPONENTIATOR_FIRST_RUN when VECTOR_EXPONENTIATOR_READY = '1';
        end loop VECTOR_EXPONENTIATOR_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE 1";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_EXPONENTIATOR_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_EXPONENTIATOR_SECOND_RUN : loop
          if ((VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_EXPONENTIATOR_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE = '1') or (VECTOR_EXPONENTIATOR_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_EXPONENTIATOR_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_EXPONENTIATOR_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_EXPONENTIATOR_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_EXPONENTIATOR_SECOND_RUN when VECTOR_EXPONENTIATOR_READY = '1';
        end loop VECTOR_EXPONENTIATOR_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_LOGARITHM_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_LOGARITHM_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_LOGARITHM_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_LOGARITHM_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_LOGARITHM_FIRST_RUN : loop
          if (VECTOR_LOGARITHM_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_LOGARITHM_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGARITHM_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGARITHM_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_LOGARITHM_DATA_OUT_ENABLE = '1' or VECTOR_LOGARITHM_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_LOGARITHM_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGARITHM_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGARITHM_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_LOGARITHM_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_LOGARITHM_FIRST_RUN when VECTOR_LOGARITHM_READY = '1';
        end loop VECTOR_LOGARITHM_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_LOGARITHM_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_LOGARITHM_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_LOGARITHM_SECOND_RUN : loop
          if ((VECTOR_LOGARITHM_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_LOGARITHM_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGARITHM_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGARITHM_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_LOGARITHM_DATA_OUT_ENABLE = '1') or (VECTOR_LOGARITHM_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_LOGARITHM_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_LOGARITHM_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_LOGARITHM_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_LOGARITHM_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_LOGARITHM_SECOND_RUN when VECTOR_LOGARITHM_READY = '1';
        end loop VECTOR_LOGARITHM_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_SINH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_SINH_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_SINH_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_SINH_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_SINH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_SINH_FIRST_RUN : loop
          if (VECTOR_SINH_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_SINH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SINH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SINH_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_SINH_DATA_OUT_ENABLE = '1' or VECTOR_SINH_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_SINH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SINH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SINH_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_SINH_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_SINH_FIRST_RUN when VECTOR_SINH_READY = '1';
        end loop VECTOR_SINH_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_SINH_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_SINH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_SINH_SECOND_RUN : loop
          if ((VECTOR_SINH_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_SINH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SINH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SINH_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_SINH_DATA_OUT_ENABLE = '1') or (VECTOR_SINH_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_SINH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SINH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SINH_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_SINH_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_SINH_SECOND_RUN when VECTOR_SINH_READY = '1';
        end loop VECTOR_SINH_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_TANH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_TANH_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_TANH_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_TANH_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_TANH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_TANH_FIRST_RUN : loop
          if (VECTOR_TANH_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_TANH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TANH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TANH_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_TANH_DATA_OUT_ENABLE = '1' or VECTOR_TANH_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_TANH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TANH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TANH_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_TANH_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_TANH_FIRST_RUN when VECTOR_TANH_READY = '1';
        end loop VECTOR_TANH_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_TANH_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_TANH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_TANH_SECOND_RUN : loop
          if ((VECTOR_TANH_DATA_OUT_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_TANH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TANH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TANH_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_TANH_DATA_OUT_ENABLE = '1') or (VECTOR_TANH_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_TANH_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TANH_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TANH_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_TANH_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_TANH_SECOND_RUN when VECTOR_TANH_READY = '1';
        end loop VECTOR_TANH_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX-FUNCTION
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_MATRIX_COSH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_COSH_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_COSH_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_COSH_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_COSH_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_COSH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_COSH_FIRST_RUN : loop
          if (MATRIX_COSH_DATA_OUT_I_ENABLE = '1' and MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_COSH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_COSH_DATA_IN_I_ENABLE <= '1';
            MATRIX_COSH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_COSH_DATA_OUT_I_ENABLE = '1' and MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_COSH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_COSH_DATA_IN_I_ENABLE <= '1';
            MATRIX_COSH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_COSH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_COSH_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_COSH_DATA_IN_I_ENABLE <= '0';
            MATRIX_COSH_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_COSH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_COSH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_COSH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_COSH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_COSH_DATA_OUT_J_ENABLE = '1' or MATRIX_COSH_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_COSH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_COSH_FIRST_RUN when MATRIX_COSH_READY = '1';
        end loop MATRIX_COSH_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_COSH_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_COSH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_COSH_SECOND_RUN : loop
          if (MATRIX_COSH_DATA_OUT_I_ENABLE = '1' and MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_COSH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_COSH_DATA_IN_I_ENABLE <= '1';
            MATRIX_COSH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_COSH_DATA_OUT_I_ENABLE = '1' and MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_COSH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_COSH_DATA_IN_I_ENABLE <= '1';
            MATRIX_COSH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_COSH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_COSH_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_COSH_DATA_IN_I_ENABLE <= '0';
            MATRIX_COSH_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_COSH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_COSH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_COSH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_COSH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_COSH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_COSH_DATA_OUT_J_ENABLE = '1' or MATRIX_COSH_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_COSH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_COSH_SECOND_RUN when MATRIX_COSH_READY = '1';
        end loop MATRIX_COSH_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST  ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_EXPONENTIATOR_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_EXPONENTIATOR_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE 0";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_EXPONENTIATOR_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_EXPONENTIATOR_FIRST_RUN : loop
          if (MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1' and MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_EXPONENTIATOR_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1' and MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_EXPONENTIATOR_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_EXPONENTIATOR_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' or MATRIX_EXPONENTIATOR_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_EXPONENTIATOR_FIRST_RUN when MATRIX_EXPONENTIATOR_READY = '1';
        end loop MATRIX_EXPONENTIATOR_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE 1";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_EXPONENTIATOR_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_EXPONENTIATOR_SECOND_RUN : loop
          if (MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1' and MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_EXPONENTIATOR_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE = '1' and MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_EXPONENTIATOR_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE <= '1';
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_EXPONENTIATOR_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE <= '0';
            MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE = '1' or MATRIX_EXPONENTIATOR_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_EXPONENTIATOR_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_EXPONENTIATOR_SECOND_RUN when MATRIX_EXPONENTIATOR_READY = '1';
        end loop MATRIX_EXPONENTIATOR_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_LOGARITHM_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_LOGARITHM_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_LOGARITHM_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_LOGARITHM_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_LOGARITHM_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_LOGARITHM_FIRST_RUN : loop
          if (MATRIX_LOGARITHM_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGARITHM_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGARITHM_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGARITHM_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGARITHM_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_I_ENABLE <= '0';
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_LOGARITHM_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGARITHM_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_LOGARITHM_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGARITHM_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' or MATRIX_LOGARITHM_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_LOGARITHM_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_LOGARITHM_FIRST_RUN when MATRIX_LOGARITHM_READY = '1';
        end loop MATRIX_LOGARITHM_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_LOGARITHM_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_LOGARITHM_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_LOGARITHM_SECOND_RUN : loop
          if (MATRIX_LOGARITHM_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGARITHM_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGARITHM_DATA_OUT_I_ENABLE = '1' and MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGARITHM_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_I_ENABLE <= '1';
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_LOGARITHM_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_LOGARITHM_DATA_IN_I_ENABLE <= '0';
            MATRIX_LOGARITHM_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_LOGARITHM_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGARITHM_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_LOGARITHM_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_LOGARITHM_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_LOGARITHM_DATA_OUT_J_ENABLE = '1' or MATRIX_LOGARITHM_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_LOGARITHM_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_LOGARITHM_SECOND_RUN when MATRIX_LOGARITHM_READY = '1';
        end loop MATRIX_LOGARITHM_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_SINH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_SINH_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_SINH_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_SINH_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_SINH_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_SINH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_SINH_FIRST_RUN : loop
          if (MATRIX_SINH_DATA_OUT_I_ENABLE = '1' and MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SINH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SINH_DATA_IN_I_ENABLE <= '1';
            MATRIX_SINH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SINH_DATA_OUT_I_ENABLE = '1' and MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SINH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SINH_DATA_IN_I_ENABLE <= '1';
            MATRIX_SINH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SINH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SINH_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_SINH_DATA_IN_I_ENABLE <= '0';
            MATRIX_SINH_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_SINH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SINH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_SINH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SINH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_SINH_DATA_OUT_J_ENABLE = '1' or MATRIX_SINH_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_SINH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_SINH_FIRST_RUN when MATRIX_SINH_READY = '1';
        end loop MATRIX_SINH_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_SINH_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_SINH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_SINH_SECOND_RUN : loop
          if (MATRIX_SINH_DATA_OUT_I_ENABLE = '1' and MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SINH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SINH_DATA_IN_I_ENABLE <= '1';
            MATRIX_SINH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SINH_DATA_OUT_I_ENABLE = '1' and MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SINH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SINH_DATA_IN_I_ENABLE <= '1';
            MATRIX_SINH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SINH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SINH_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_SINH_DATA_IN_I_ENABLE <= '0';
            MATRIX_SINH_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_SINH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SINH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_SINH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_SINH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SINH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_SINH_DATA_OUT_J_ENABLE = '1' or MATRIX_SINH_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_SINH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_SINH_SECOND_RUN when MATRIX_SINH_READY = '1';
        end loop MATRIX_SINH_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_TANH_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_TANH_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_TANH_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_TANH_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_TANH_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TANH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_TANH_FIRST_RUN : loop
          if (MATRIX_TANH_DATA_OUT_I_ENABLE = '1' and MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TANH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TANH_DATA_IN_I_ENABLE <= '1';
            MATRIX_TANH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TANH_DATA_OUT_I_ENABLE = '1' and MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TANH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TANH_DATA_IN_I_ENABLE <= '1';
            MATRIX_TANH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TANH_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TANH_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TANH_DATA_IN_I_ENABLE <= '0';
            MATRIX_TANH_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_TANH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TANH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_TANH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TANH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TANH_DATA_OUT_J_ENABLE = '1' or MATRIX_TANH_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_TANH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TANH_FIRST_RUN when MATRIX_TANH_READY = '1';
        end loop MATRIX_TANH_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_TANH_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TANH_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_TANH_SECOND_RUN : loop
          if (MATRIX_TANH_DATA_OUT_I_ENABLE = '1' and MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TANH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TANH_DATA_IN_I_ENABLE <= '1';
            MATRIX_TANH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TANH_DATA_OUT_I_ENABLE = '1' and MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TANH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TANH_DATA_IN_I_ENABLE <= '1';
            MATRIX_TANH_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TANH_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TANH_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TANH_DATA_IN_I_ENABLE <= '0';
            MATRIX_TANH_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_TANH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TANH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_TANH_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_TANH_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TANH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TANH_DATA_OUT_J_ENABLE = '1' or MATRIX_TANH_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_TANH_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TANH_SECOND_RUN when MATRIX_TANH_READY = '1';
        end loop MATRIX_TANH_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
