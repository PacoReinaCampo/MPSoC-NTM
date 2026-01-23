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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;
use work.model_calculus_pkg.all;

entity model_calculus_stimulus is
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

    -- VECTOR DIFFERENTIATION
    -- CONTROL
    VECTOR_DIFFERENTIATION_START : out std_logic;
    VECTOR_DIFFERENTIATION_READY : in  std_logic;

    VECTOR_DIFFERENTIATION_DATA_IN_ENABLE : out std_logic;

    VECTOR_DIFFERENTIATION_DATA_ENABLE : in std_logic;

    VECTOR_DIFFERENTIATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_DIFFERENTIATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_DIFFERENTIATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR INTEGRATION
    -- CONTROL
    VECTOR_INTEGRATION_START : out std_logic;
    VECTOR_INTEGRATION_READY : in  std_logic;

    VECTOR_INTEGRATION_DATA_IN_ENABLE : out std_logic;

    VECTOR_INTEGRATION_DATA_ENABLE : in std_logic;

    VECTOR_INTEGRATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_INTEGRATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_INTEGRATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGRATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_INTEGRATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SOFTMAX
    -- CONTROL
    VECTOR_SOFTMAX_START : out std_logic;
    VECTOR_SOFTMAX_READY : in  std_logic;

    VECTOR_SOFTMAX_DATA_IN_ENABLE : out std_logic;

    VECTOR_SOFTMAX_DATA_ENABLE : in std_logic;

    VECTOR_SOFTMAX_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_SOFTMAX_SIZE_IN  : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SOFTMAX_DATA_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SOFTMAX_DATA_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX DIFFERENTIATION
    -- CONTROL
    MATRIX_DIFFERENTIATION_START : out std_logic;
    MATRIX_DIFFERENTIATION_READY : in  std_logic;

    MATRIX_DIFFERENTIATION_CONTROL : out std_logic;

    MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_DIFFERENTIATION_DATA_I_ENABLE : in std_logic;
    MATRIX_DIFFERENTIATION_DATA_J_ENABLE : in std_logic;

    MATRIX_DIFFERENTIATION_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_DIFFERENTIATION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_DIFFERENTIATION_SIZE_I_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_SIZE_J_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_LENGTH_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_LENGTH_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_DATA_IN     : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_DIFFERENTIATION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX INTEGRATION
    -- CONTROL
    MATRIX_INTEGRATION_START : out std_logic;
    MATRIX_INTEGRATION_READY : in  std_logic;

    MATRIX_INTEGRATION_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_INTEGRATION_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_INTEGRATION_DATA_I_ENABLE : in std_logic;
    MATRIX_INTEGRATION_DATA_J_ENABLE : in std_logic;

    MATRIX_INTEGRATION_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INTEGRATION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INTEGRATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGRATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INTEGRATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGRATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INTEGRATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SOFTMAX
    -- CONTROL
    MATRIX_SOFTMAX_START : out std_logic;
    MATRIX_SOFTMAX_READY : in  std_logic;

    MATRIX_SOFTMAX_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_SOFTMAX_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_SOFTMAX_DATA_I_ENABLE : in std_logic;
    MATRIX_SOFTMAX_DATA_J_ENABLE : in std_logic;

    MATRIX_SOFTMAX_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_SOFTMAX_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_SOFTMAX_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SOFTMAX_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR DIFFERENTIATION
    -- CONTROL
    TENSOR_DIFFERENTIATION_START : out std_logic;
    TENSOR_DIFFERENTIATION_READY : in  std_logic;

    TENSOR_DIFFERENTIATION_CONTROL : out std_logic_vector(1 downto 0);

    TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE : out std_logic;
    TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE : out std_logic;
    TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE : out std_logic;

    TENSOR_DIFFERENTIATION_DATA_I_ENABLE : in std_logic;
    TENSOR_DIFFERENTIATION_DATA_J_ENABLE : in std_logic;
    TENSOR_DIFFERENTIATION_DATA_K_ENABLE : in std_logic;

    TENSOR_DIFFERENTIATION_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_DIFFERENTIATION_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_DIFFERENTIATION_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_DIFFERENTIATION_SIZE_I_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_SIZE_J_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_SIZE_K_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_LENGTH_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_LENGTH_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_LENGTH_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_DATA_IN     : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_DIFFERENTIATION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR INTEGRATION
    -- CONTROL
    TENSOR_INTEGRATION_START : out std_logic;
    TENSOR_INTEGRATION_READY : in  std_logic;

    TENSOR_INTEGRATION_DATA_IN_I_ENABLE : out std_logic;
    TENSOR_INTEGRATION_DATA_IN_J_ENABLE : out std_logic;
    TENSOR_INTEGRATION_DATA_IN_K_ENABLE : out std_logic;

    TENSOR_INTEGRATION_DATA_I_ENABLE : in std_logic;
    TENSOR_INTEGRATION_DATA_J_ENABLE : in std_logic;
    TENSOR_INTEGRATION_DATA_K_ENABLE : in std_logic;

    TENSOR_INTEGRATION_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_INTEGRATION_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_INTEGRATION_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_INTEGRATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGRATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGRATION_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INTEGRATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGRATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INTEGRATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR SOFTMAX
    -- CONTROL
    TENSOR_SOFTMAX_START : out std_logic;
    TENSOR_SOFTMAX_READY : in  std_logic;

    TENSOR_SOFTMAX_DATA_IN_I_ENABLE : out std_logic;
    TENSOR_SOFTMAX_DATA_IN_J_ENABLE : out std_logic;
    TENSOR_SOFTMAX_DATA_IN_K_ENABLE : out std_logic;

    TENSOR_SOFTMAX_DATA_I_ENABLE : in std_logic;
    TENSOR_SOFTMAX_DATA_J_ENABLE : in std_logic;
    TENSOR_SOFTMAX_DATA_K_ENABLE : in std_logic;

    TENSOR_SOFTMAX_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_SOFTMAX_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_SOFTMAX_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_SOFTMAX_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_SOFTMAX_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_SOFTMAX_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_SOFTMAX_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_SOFTMAX_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_calculus_stimulus_architecture of model_calculus_stimulus is

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

  -- VECTOR-FUNCTIONALITY
  VECTOR_DIFFERENTIATION_START <= start_int;
  VECTOR_INTEGRATION_START     <= start_int;
  VECTOR_SOFTMAX_START         <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_DIFFERENTIATION_START <= start_int;
  MATRIX_INTEGRATION_START     <= start_int;
  MATRIX_SOFTMAX_START         <= start_int;

  -- TENSOR-FUNCTIONALITY
  TENSOR_DIFFERENTIATION_START <= start_int;
  TENSOR_INTEGRATION_START     <= start_int;
  TENSOR_SOFTMAX_START         <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_DIFFERENTIATION_TEST                            ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_DIFFERENTIATION_SIZE_IN   <= THREE_CONTROL;
      VECTOR_DIFFERENTIATION_LENGTH_IN <= TWO_DATA;

      if (STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_DIFFERENTIATION_CASE 0                          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_DIFFERENTIATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_DIFFERENTIATION_FIRST_RUN : loop
          if (VECTOR_DIFFERENTIATION_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_DIFFERENTIATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_DIFFERENTIATION_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_DIFFERENTIATION_DATA_ENABLE = '1' or VECTOR_DIFFERENTIATION_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_DIFFERENTIATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_DIFFERENTIATION_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_DIFFERENTIATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_DIFFERENTIATION_FIRST_RUN when VECTOR_DIFFERENTIATION_READY = '1';
        end loop VECTOR_DIFFERENTIATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_DIFFERENTIATION_CASE 1                          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_DIFFERENTIATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_DIFFERENTIATION_SECOND_RUN : loop
          if ((VECTOR_DIFFERENTIATION_DATA_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_DIFFERENTIATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_DIFFERENTIATION_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_DIFFERENTIATION_DATA_ENABLE = '1') or (VECTOR_DIFFERENTIATION_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_DIFFERENTIATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_DIFFERENTIATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_DIFFERENTIATION_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_DIFFERENTIATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_DIFFERENTIATION_SECOND_RUN when VECTOR_DIFFERENTIATION_READY = '1';
        end loop VECTOR_DIFFERENTIATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_INTEGRATION_TEST                                ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_INTEGRATION_SIZE_IN   <= THREE_CONTROL;
      VECTOR_INTEGRATION_LENGTH_IN <= TWO_DATA;

      if (STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_INTEGRATION_CASE 0                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGRATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGRATION_FIRST_RUN : loop
          if (VECTOR_INTEGRATION_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGRATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGRATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGRATION_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_INTEGRATION_DATA_ENABLE = '1' or VECTOR_INTEGRATION_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGRATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGRATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGRATION_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGRATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGRATION_FIRST_RUN when VECTOR_INTEGRATION_READY = '1';
        end loop VECTOR_INTEGRATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_INTEGRATION_CASE 1                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_INTEGRATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_INTEGRATION_SECOND_RUN : loop
          if ((VECTOR_INTEGRATION_DATA_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_INTEGRATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGRATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGRATION_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_INTEGRATION_DATA_ENABLE = '1') or (VECTOR_INTEGRATION_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_INTEGRATION_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_INTEGRATION_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_INTEGRATION_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_INTEGRATION_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_INTEGRATION_SECOND_RUN when VECTOR_INTEGRATION_READY = '1';
        end loop VECTOR_INTEGRATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_SOFTMAX_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_SOFTMAX_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_SOFTMAX_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_SOFTMAX_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_SOFTMAX_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_SOFTMAX_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_SOFTMAX_FIRST_RUN : loop
          if (VECTOR_SOFTMAX_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_SOFTMAX_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SOFTMAX_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SOFTMAX_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_SOFTMAX_DATA_ENABLE = '1' or VECTOR_SOFTMAX_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_SOFTMAX_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SOFTMAX_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SOFTMAX_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_SOFTMAX_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_SOFTMAX_FIRST_RUN when VECTOR_SOFTMAX_READY = '1';
        end loop VECTOR_SOFTMAX_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_SOFTMAX_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_SOFTMAX_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_SOFTMAX_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_SOFTMAX_SECOND_RUN : loop
          if ((VECTOR_SOFTMAX_DATA_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_SOFTMAX_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SOFTMAX_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SOFTMAX_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_SOFTMAX_DATA_ENABLE = '1') or (VECTOR_SOFTMAX_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_SOFTMAX_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_SOFTMAX_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_SOFTMAX_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_SOFTMAX_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_SOFTMAX_SECOND_RUN when VECTOR_SOFTMAX_READY = '1';
        end loop VECTOR_SOFTMAX_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_DIFFERENTIATION_TEST                            ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_DIFFERENTIATION_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_DIFFERENTIATION_SIZE_J_IN <= FOUR_CONTROL;

      MATRIX_DIFFERENTIATION_LENGTH_I_IN <= TWO_DATA;
      MATRIX_DIFFERENTIATION_LENGTH_J_IN <= TWO_DATA;

      if (STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_DIFFERENTIATION_CASE 0                          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        MATRIX_DIFFERENTIATION_CONTROL <= '0';

        -- DATA
        MATRIX_DIFFERENTIATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_DIFFERENTIATION_FIRST_RUN : loop
          if (MATRIX_DIFFERENTIATION_DATA_I_ENABLE = '1' and MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_DIFFERENTIATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_DIFFERENTIATION_DATA_I_ENABLE = '1' and MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_DIFFERENTIATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_DIFFERENTIATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE <= '0';
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' or MATRIX_DIFFERENTIATION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_DIFFERENTIATION_FIRST_RUN when MATRIX_DIFFERENTIATION_READY = '1';
        end loop MATRIX_DIFFERENTIATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_DIFFERENTIATION_CASE 1                          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_DIFFERENTIATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_DIFFERENTIATION_SECOND_RUN : loop
          if (MATRIX_DIFFERENTIATION_DATA_I_ENABLE = '1' and MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_DIFFERENTIATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_DIFFERENTIATION_DATA_I_ENABLE = '1' and MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_DIFFERENTIATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_DIFFERENTIATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE <= '0';
            MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_DIFFERENTIATION_DATA_J_ENABLE = '1' or MATRIX_DIFFERENTIATION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_DIFFERENTIATION_SECOND_RUN when MATRIX_DIFFERENTIATION_READY = '1';
        end loop MATRIX_DIFFERENTIATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_INTEGRATION_TEST                                ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_INTEGRATION_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_INTEGRATION_SIZE_J_IN <= FOUR_CONTROL;

      MATRIX_INTEGRATION_LENGTH_IN <= TWO_DATA;

      if (STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_INTEGRATION_CASE 0                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGRATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGRATION_FIRST_RUN : loop
          if (MATRIX_INTEGRATION_DATA_I_ENABLE = '1' and MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGRATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGRATION_DATA_I_ENABLE = '1' and MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGRATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGRATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_I_ENABLE <= '0';
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGRATION_DATA_J_ENABLE = '1' or MATRIX_INTEGRATION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGRATION_FIRST_RUN when MATRIX_INTEGRATION_READY = '1';
        end loop MATRIX_INTEGRATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_INTEGRATION_CASE 1                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INTEGRATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INTEGRATION_SECOND_RUN : loop
          if (MATRIX_INTEGRATION_DATA_I_ENABLE = '1' and MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGRATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGRATION_DATA_I_ENABLE = '1' and MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGRATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INTEGRATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INTEGRATION_DATA_IN_I_ENABLE <= '0';
            MATRIX_INTEGRATION_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INTEGRATION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INTEGRATION_DATA_J_ENABLE = '1' or MATRIX_INTEGRATION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INTEGRATION_SECOND_RUN when MATRIX_INTEGRATION_READY = '1';
        end loop MATRIX_INTEGRATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_SOFTMAX_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_SOFTMAX_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_SOFTMAX_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_SOFTMAX_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_SOFTMAX_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_SOFTMAX_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_SOFTMAX_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_SOFTMAX_FIRST_RUN : loop
          if (MATRIX_SOFTMAX_DATA_I_ENABLE = '1' and MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SOFTMAX_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SOFTMAX_DATA_I_ENABLE = '1' and MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SOFTMAX_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SOFTMAX_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_I_ENABLE <= '0';
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_SOFTMAX_DATA_J_ENABLE = '1' or MATRIX_SOFTMAX_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_SOFTMAX_FIRST_RUN when MATRIX_SOFTMAX_READY = '1';
        end loop MATRIX_SOFTMAX_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_SOFTMAX_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_SOFTMAX_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_SOFTMAX_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_SOFTMAX_SECOND_RUN : loop
          if (MATRIX_SOFTMAX_DATA_I_ENABLE = '1' and MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SOFTMAX_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SOFTMAX_DATA_I_ENABLE = '1' and MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SOFTMAX_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SOFTMAX_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_SOFTMAX_DATA_IN_I_ENABLE <= '0';
            MATRIX_SOFTMAX_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_SOFTMAX_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_SOFTMAX_DATA_J_ENABLE = '1' or MATRIX_SOFTMAX_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_SOFTMAX_SECOND_RUN when MATRIX_SOFTMAX_READY = '1';
        end loop MATRIX_SOFTMAX_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_DIFFERENTIATION_TEST                            ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_DIFFERENTIATION_SIZE_I_IN <= FOUR_CONTROL;
      TENSOR_DIFFERENTIATION_SIZE_J_IN <= FOUR_CONTROL;
      TENSOR_DIFFERENTIATION_SIZE_K_IN <= FOUR_CONTROL;

      TENSOR_DIFFERENTIATION_LENGTH_I_IN <= TWO_DATA;
      TENSOR_DIFFERENTIATION_LENGTH_J_IN <= TWO_DATA;
      TENSOR_DIFFERENTIATION_LENGTH_K_IN <= TWO_DATA;

      if (STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_DIFFERENTIATION_CASE 0                          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- CONTROL
        TENSOR_DIFFERENTIATION_CONTROL <= "01";

        -- DATA
        TENSOR_DIFFERENTIATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_DIFFERENTIATION_FIRST_RUN : loop
          if (TENSOR_DIFFERENTIATION_DATA_I_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_J_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_DIFFERENTIATION_DATA_I_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_J_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_DIFFERENTIATION_DATA_J_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE <= '0';
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '0';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' or TENSOR_DIFFERENTIATION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_DIFFERENTIATION_FIRST_RUN when TENSOR_DIFFERENTIATION_READY = '1';
        end loop TENSOR_DIFFERENTIATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_DIFFERENTIATION_CASE 1                          ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_DIFFERENTIATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_DIFFERENTIATION_SECOND_RUN : loop
          if (TENSOR_DIFFERENTIATION_DATA_I_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_J_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_DIFFERENTIATION_DATA_I_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_J_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_DIFFERENTIATION_DATA_J_ENABLE = '1' and TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_DIFFERENTIATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE <= '0';
            TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE <= '0';
            TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_DIFFERENTIATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_DIFFERENTIATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_DIFFERENTIATION_DATA_K_ENABLE = '1' or TENSOR_DIFFERENTIATION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_DIFFERENTIATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_DIFFERENTIATION_SECOND_RUN when TENSOR_DIFFERENTIATION_READY = '1';
        end loop TENSOR_DIFFERENTIATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_INTEGRATION_TEST                                ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_INTEGRATION_SIZE_I_IN <= FOUR_CONTROL;
      TENSOR_INTEGRATION_SIZE_J_IN <= FOUR_CONTROL;
      TENSOR_INTEGRATION_SIZE_K_IN <= FOUR_CONTROL;

      TENSOR_INTEGRATION_LENGTH_IN <= TWO_DATA;

      if (STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_INTEGRATION_CASE 0                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGRATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGRATION_FIRST_RUN : loop
          if (TENSOR_INTEGRATION_DATA_I_ENABLE = '1' and TENSOR_INTEGRATION_DATA_J_ENABLE = '1' and TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGRATION_DATA_I_ENABLE = '1' and TENSOR_INTEGRATION_DATA_J_ENABLE = '1' and TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGRATION_DATA_J_ENABLE = '1' and TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_I_ENABLE <= '0';
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '0';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGRATION_DATA_K_ENABLE = '1' or TENSOR_INTEGRATION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGRATION_FIRST_RUN when TENSOR_INTEGRATION_READY = '1';
        end loop TENSOR_INTEGRATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_INTEGRATION_CASE 1                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INTEGRATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INTEGRATION_SECOND_RUN : loop
          if (TENSOR_INTEGRATION_DATA_I_ENABLE = '1' and TENSOR_INTEGRATION_DATA_J_ENABLE = '1' and TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGRATION_DATA_I_ENABLE = '1' and TENSOR_INTEGRATION_DATA_J_ENABLE = '1' and TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_I_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGRATION_DATA_J_ENABLE = '1' and TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '1';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INTEGRATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INTEGRATION_DATA_IN_I_ENABLE <= '0';
            TENSOR_INTEGRATION_DATA_IN_J_ENABLE <= '0';
            TENSOR_INTEGRATION_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INTEGRATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INTEGRATION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INTEGRATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INTEGRATION_DATA_K_ENABLE = '1' or TENSOR_INTEGRATION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INTEGRATION_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INTEGRATION_SECOND_RUN when TENSOR_INTEGRATION_READY = '1';
        end loop TENSOR_INTEGRATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_TENSOR_SOFTMAX_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_SOFTMAX_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_SOFTMAX_SIZE_I_IN <= FOUR_CONTROL;
      TENSOR_SOFTMAX_SIZE_J_IN <= FOUR_CONTROL;
      TENSOR_SOFTMAX_SIZE_K_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_TENSOR_SOFTMAX_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_SOFTMAX_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_SOFTMAX_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_SOFTMAX_FIRST_RUN : loop
          if (TENSOR_SOFTMAX_DATA_I_ENABLE = '1' and TENSOR_SOFTMAX_DATA_J_ENABLE = '1' and TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_SOFTMAX_DATA_I_ENABLE = '1' and TENSOR_SOFTMAX_DATA_J_ENABLE = '1' and TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_SOFTMAX_DATA_J_ENABLE = '1' and TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_I_ENABLE <= '0';
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '0';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_SOFTMAX_DATA_K_ENABLE = '1' or TENSOR_SOFTMAX_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_SOFTMAX_FIRST_RUN when TENSOR_SOFTMAX_READY = '1';
        end loop TENSOR_SOFTMAX_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_TENSOR_SOFTMAX_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_SOFTMAX_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_SOFTMAX_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_SOFTMAX_SECOND_RUN : loop
          if (TENSOR_SOFTMAX_DATA_I_ENABLE = '1' and TENSOR_SOFTMAX_DATA_J_ENABLE = '1' and TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_SOFTMAX_DATA_I_ENABLE = '1' and TENSOR_SOFTMAX_DATA_J_ENABLE = '1' and TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_I_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_SOFTMAX_DATA_J_ENABLE = '1' and TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '1';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_SOFTMAX_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_SOFTMAX_DATA_IN_I_ENABLE <= '0';
            TENSOR_SOFTMAX_DATA_IN_J_ENABLE <= '0';
            TENSOR_SOFTMAX_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_SOFTMAX_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_SOFTMAX_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_SOFTMAX_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_SOFTMAX_DATA_K_ENABLE = '1' or TENSOR_SOFTMAX_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_SOFTMAX_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_SOFTMAX_SECOND_RUN when TENSOR_SOFTMAX_READY = '1';
        end loop TENSOR_SOFTMAX_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
