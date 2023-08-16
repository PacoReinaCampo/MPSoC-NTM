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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;

use work.accelerator_trainer_differentiation_pkg.all;

entity accelerator_trainer_differentiation_stimulus is
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

    -- VECTOR TRAINER DIFFERENTIATION
    -- CONTROL
    VECTOR_TRAINER_DIFFERENTIATION_START : out std_logic;
    VECTOR_TRAINER_DIFFERENTIATION_READY : in  std_logic;

    VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE : out std_logic;  -- for t out 0 to T-1
    VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE : out std_logic;  -- for x out 0 to L-1

    VECTOR_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE : in std_logic;  -- for t out 0 to T-1
    VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE : in std_logic;  -- for x out 0 to L-1

    VECTOR_TRAINER_DIFFERENTIATION_Y_OUT_T_ENABLE : in std_logic;  -- for t out 0 to T-1
    VECTOR_TRAINER_DIFFERENTIATION_Y_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1

    -- DATA
    VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    VECTOR_TRAINER_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    VECTOR_TRAINER_DIFFERENTIATION_X_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    VECTOR_TRAINER_DIFFERENTIATION_Y_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TRAINER DIFFERENTIATION
    -- CONTROL
    MATRIX_TRAINER_DIFFERENTIATION_START : out std_logic;
    MATRIX_TRAINER_DIFFERENTIATION_READY : in  std_logic;

    MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE : out std_logic;  -- for t out 0 to T-1
    MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1
    MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1

    MATRIX_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE : in std_logic;  -- for t out 0 to T-1
    MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
    MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1

    MATRIX_TRAINER_DIFFERENTIATION_Y_OUT_T_ENABLE : in std_logic;  -- for t out 0 to T-1
    MATRIX_TRAINER_DIFFERENTIATION_Y_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
    MATRIX_TRAINER_DIFFERENTIATION_Y_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1

    -- DATA
    MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    MATRIX_TRAINER_DIFFERENTIATION_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    MATRIX_TRAINER_DIFFERENTIATION_X_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    MATRIX_TRAINER_DIFFERENTIATION_Y_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_trainer_differentiation_stimulus_architecture of accelerator_trainer_differentiation_stimulus is

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
  signal index_x_t_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  VECTOR_TRAINER_DIFFERENTIATION_START <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_TRAINER_DIFFERENTIATION_START <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_TEST              ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN <= FOUR_CONTROL;
      VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN <= FOUR_CONTROL;

      VECTOR_TRAINER_DIFFERENTIATION_LENGTH_IN <= FOUR_UDATA;

      if (STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_CASE 0            ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_TRAINER_DIFFERENTIATION_X_IN <= ZERO_DATA;

        -- LOOP
        index_x_t_loop <= ZERO_CONTROL;
        index_x_l_loop <= ZERO_CONTROL;

        VECTOR_TRAINER_DIFFERENTIATION_FIRST_RUN : loop
          if (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_t_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_TRAINER_DIFFERENTIATION_X_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_TRAINER_DIFFERENTIATION_X_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_TRAINER_DIFFERENTIATION_X_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          else
            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '0';
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '0';
          end if;

          -- LOOP
          if (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) = unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= ZERO_CONTROL;
            index_x_l_loop <= ZERO_CONTROL;
          elsif (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) < unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= std_logic_vector(unsigned(index_x_t_loop) + unsigned(ONE_CONTROL));
            index_x_l_loop <= ZERO_CONTROL;
          elsif ((VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' or VECTOR_TRAINER_DIFFERENTIATION_START = '1') and (unsigned(index_x_l_loop) < unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_l_loop <= std_logic_vector(unsigned(index_x_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_TRAINER_DIFFERENTIATION_FIRST_RUN when VECTOR_TRAINER_DIFFERENTIATION_READY = '1';
        end loop VECTOR_TRAINER_DIFFERENTIATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_CASE 1            ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_TRAINER_DIFFERENTIATION_X_IN <= ZERO_DATA;

        -- LOOP
        index_x_t_loop <= ZERO_CONTROL;
        index_x_l_loop <= ZERO_CONTROL;

        VECTOR_TRAINER_DIFFERENTIATION_SECOND_RUN : loop
          if (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_t_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_TRAINER_DIFFERENTIATION_X_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_TRAINER_DIFFERENTIATION_X_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_TRAINER_DIFFERENTIATION_X_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          else
            -- CONTROL
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '0';
            VECTOR_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '0';
          end if;

          -- LOOP
          if (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) = unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= ZERO_CONTROL;
            index_x_l_loop <= ZERO_CONTROL;
          elsif (VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) < unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= std_logic_vector(unsigned(index_x_t_loop) + unsigned(ONE_CONTROL));
            index_x_l_loop <= ZERO_CONTROL;
          elsif ((VECTOR_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' or VECTOR_TRAINER_DIFFERENTIATION_START = '1') and (unsigned(index_x_l_loop) < unsigned(VECTOR_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_l_loop <= std_logic_vector(unsigned(index_x_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_TRAINER_DIFFERENTIATION_SECOND_RUN when VECTOR_TRAINER_DIFFERENTIATION_READY = '1';
        end loop VECTOR_TRAINER_DIFFERENTIATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_TEST                    ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN <= FOUR_CONTROL;
      MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN <= FOUR_CONTROL;
      MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN <= FOUR_CONTROL;

      MATRIX_TRAINER_DIFFERENTIATION_LENGTH_IN <= FOUR_UDATA;

      if (STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_CASE 0                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TRAINER_DIFFERENTIATION_X_IN <= ZERO_DATA;

        -- LOOP
        index_x_t_loop <= ZERO_CONTROL;
        index_x_i_loop <= ZERO_CONTROL;
        index_x_l_loop <= ZERO_CONTROL;

        MATRIX_TRAINER_DIFFERENTIATION_FIRST_RUN : loop
          if (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_t_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '0';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '0';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_i_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= ZERO_CONTROL;
            index_x_i_loop <= ZERO_CONTROL;
            index_x_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) < unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_i_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= std_logic_vector(unsigned(index_x_t_loop) + unsigned(ONE_CONTROL));
            index_x_i_loop <= ZERO_CONTROL;
            index_x_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_i_loop) < unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_i_loop <= std_logic_vector(unsigned(index_x_i_loop) + unsigned(ONE_CONTROL));
            index_x_l_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' or MATRIX_TRAINER_DIFFERENTIATION_START = '1') and (unsigned(index_x_l_loop) < unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_l_loop <= std_logic_vector(unsigned(index_x_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TRAINER_DIFFERENTIATION_FIRST_RUN when MATRIX_TRAINER_DIFFERENTIATION_READY = '1';
        end loop MATRIX_TRAINER_DIFFERENTIATION_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_CASE 1                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TRAINER_DIFFERENTIATION_X_IN <= ZERO_DATA;

        -- LOOP
        index_x_t_loop <= ZERO_CONTROL;
        index_x_i_loop <= ZERO_CONTROL;
        index_x_l_loop <= ZERO_CONTROL;

        MATRIX_TRAINER_DIFFERENTIATION_SECOND_RUN : loop
          if (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_t_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_T_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_I_ENABLE = '1' and MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '1';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and unsigned(index_x_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRAINER_DIFFERENTIATION_X_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_x_t_loop)), to_integer(unsigned(index_x_i_loop)), to_integer(unsigned(index_x_l_loop)));

            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_T_ENABLE <= '0';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_I_ENABLE <= '0';
            MATRIX_TRAINER_DIFFERENTIATION_X_IN_L_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_i_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= ZERO_CONTROL;
            index_x_i_loop <= ZERO_CONTROL;
            index_x_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_t_loop) < unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_i_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_t_loop <= std_logic_vector(unsigned(index_x_t_loop) + unsigned(ONE_CONTROL));
            index_x_i_loop <= ZERO_CONTROL;
            index_x_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' and (unsigned(index_x_i_loop) < unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_l_loop) = unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_i_loop <= std_logic_vector(unsigned(index_x_i_loop) + unsigned(ONE_CONTROL));
            index_x_l_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TRAINER_DIFFERENTIATION_X_OUT_L_ENABLE = '1' or MATRIX_TRAINER_DIFFERENTIATION_START = '1') and (unsigned(index_x_l_loop) < unsigned(MATRIX_TRAINER_DIFFERENTIATION_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_x_l_loop <= std_logic_vector(unsigned(index_x_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TRAINER_DIFFERENTIATION_SECOND_RUN when MATRIX_TRAINER_DIFFERENTIATION_READY = '1';
        end loop MATRIX_TRAINER_DIFFERENTIATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
