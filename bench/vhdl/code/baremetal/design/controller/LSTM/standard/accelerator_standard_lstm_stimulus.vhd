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

use work.accelerator_standard_lstm_pkg.all;

entity accelerator_standard_lstm_stimulus is
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
    STANDARD_LSTM_START : out std_logic;
    STANDARD_LSTM_READY : in  std_logic;

    STANDARD_LSTM_W_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_W_IN_X_ENABLE : out std_logic;  -- for x out 0 to X-1

    STANDARD_LSTM_W_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_W_OUT_X_ENABLE : in std_logic;  -- for x out 0 to X-1

    STANDARD_LSTM_K_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_K_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_K_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

    STANDARD_LSTM_K_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_K_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_K_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    STANDARD_LSTM_D_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_D_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_D_IN_M_ENABLE : out std_logic;  -- for m out 0 to M-1

    STANDARD_LSTM_D_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_D_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_D_OUT_M_ENABLE : in std_logic;  -- for m out 0 to M-1

    STANDARD_LSTM_U_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_U_IN_P_ENABLE : out std_logic;  -- for p out 0 to L-1

    STANDARD_LSTM_U_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_U_OUT_P_ENABLE : in std_logic;  -- for p out 0 to L-1

    STANDARD_LSTM_V_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_V_IN_S_ENABLE : out std_logic;  -- for s out 0 to S-1

    STANDARD_LSTM_V_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    STANDARD_LSTM_V_OUT_S_ENABLE : in std_logic;  -- for s out 0 to S-1

    STANDARD_LSTM_B_IN_ENABLE : out std_logic;  -- for l out 0 to L-1

    STANDARD_LSTM_B_OUT_ENABLE : in std_logic;  -- for l out 0 to L-1

    STANDARD_LSTM_X_IN_ENABLE : out std_logic;  -- for x out 0 to X-1

    STANDARD_LSTM_X_OUT_ENABLE : in std_logic;  -- for x out 0 to X-1

    STANDARD_LSTM_R_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_R_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

    STANDARD_LSTM_R_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_R_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    STANDARD_LSTM_RHO_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_RHO_IN_M_ENABLE : out std_logic;  -- for m out 0 to M-1

    STANDARD_LSTM_RHO_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    STANDARD_LSTM_RHO_OUT_M_ENABLE : in std_logic;  -- for m out 0 to M-1

    STANDARD_LSTM_XI_IN_ENABLE : out std_logic;  -- for s out 0 to S-1

    STANDARD_LSTM_XI_OUT_ENABLE : in std_logic;  -- for s out 0 to S-1

    STANDARD_LSTM_H_IN_ENABLE : out std_logic;  -- for l out 0 to L-1

    STANDARD_LSTM_H_OUT_ENABLE : in std_logic;  -- for l out 0 to L-1

    -- DATA
    STANDARD_LSTM_SIZE_X_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    STANDARD_LSTM_SIZE_W_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    STANDARD_LSTM_SIZE_L_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    STANDARD_LSTM_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    STANDARD_LSTM_SIZE_S_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    STANDARD_LSTM_SIZE_M_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    STANDARD_LSTM_W_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_D_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_V_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    STANDARD_LSTM_X_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_R_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_RHO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_XI_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    STANDARD_LSTM_H_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);

    STANDARD_LSTM_H_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_standard_lstm_stimulus_architecture of accelerator_standard_lstm_stimulus is

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
  STANDARD_LSTM_START <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_ACCELERATOR_STANDARD_LSTM_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_ACCELERATOR_STANDARD_LSTM_TEST                               ";
      -------------------------------------------------------------------

      -- DATA
      STANDARD_LSTM_SIZE_X_IN <= FOUR_CONTROL;
      STANDARD_LSTM_SIZE_W_IN <= FOUR_CONTROL;
      STANDARD_LSTM_SIZE_L_IN <= FOUR_CONTROL;
      STANDARD_LSTM_SIZE_R_IN <= FOUR_CONTROL;
      STANDARD_LSTM_SIZE_S_IN <= FOUR_CONTROL;
      STANDARD_LSTM_SIZE_M_IN <= FOUR_CONTROL;

      if (STIMULUS_ACCELERATOR_STANDARD_LSTM_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_STANDARD_LSTM_CASE 0                             ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        STANDARD_LSTM_W_IN <= ZERO_DATA;
        STANDARD_LSTM_D_IN <= ZERO_DATA;
        STANDARD_LSTM_K_IN <= ZERO_DATA;
        STANDARD_LSTM_U_IN <= ZERO_DATA;
        STANDARD_LSTM_V_IN <= ZERO_DATA;
        STANDARD_LSTM_B_IN <= ZERO_DATA;

        STANDARD_LSTM_X_IN   <= ZERO_DATA;
        STANDARD_LSTM_R_IN   <= ZERO_DATA;
        STANDARD_LSTM_RHO_IN <= ZERO_DATA;
        STANDARD_LSTM_XI_IN  <= ZERO_DATA;
        STANDARD_LSTM_H_IN   <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        STANDARD_LSTM_FIRST_RUN : loop
          if (STANDARD_LSTM_W_OUT_L_ENABLE = '1' and STANDARD_LSTM_W_OUT_X_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_W_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_W_IN_L_ENABLE <= '1';
            STANDARD_LSTM_W_IN_X_ENABLE <= '1';
          elsif (STANDARD_LSTM_W_OUT_L_ENABLE = '1' and STANDARD_LSTM_W_OUT_X_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_W_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_W_IN_L_ENABLE <= '1';
            STANDARD_LSTM_W_IN_X_ENABLE <= '1';
          elsif (STANDARD_LSTM_W_OUT_X_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_W_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_W_IN_X_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_W_IN_L_ENABLE <= '0';
            STANDARD_LSTM_W_IN_X_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_K_OUT_I_ENABLE = '1' and STANDARD_LSTM_K_OUT_L_ENABLE = '1' and STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_I_ENABLE <= '1';
            STANDARD_LSTM_K_IN_L_ENABLE <= '1';
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_K_OUT_I_ENABLE = '1' and STANDARD_LSTM_K_OUT_L_ENABLE = '1' and STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_I_ENABLE <= '1';
            STANDARD_LSTM_K_IN_L_ENABLE <= '1';
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_K_OUT_L_ENABLE = '1' and STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_L_ENABLE <= '1';
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_K_IN_I_ENABLE <= '0';
            STANDARD_LSTM_K_IN_L_ENABLE <= '0';
            STANDARD_LSTM_K_IN_K_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_D_OUT_I_ENABLE = '1' and STANDARD_LSTM_D_OUT_L_ENABLE = '1' and STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_I_ENABLE <= '1';
            STANDARD_LSTM_D_IN_L_ENABLE <= '1';
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_D_OUT_I_ENABLE = '1' and STANDARD_LSTM_D_OUT_L_ENABLE = '1' and STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_I_ENABLE <= '1';
            STANDARD_LSTM_D_IN_L_ENABLE <= '1';
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_D_OUT_L_ENABLE = '1' and STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_L_ENABLE <= '1';
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_D_IN_I_ENABLE <= '0';
            STANDARD_LSTM_D_IN_L_ENABLE <= '0';
            STANDARD_LSTM_D_IN_M_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_U_OUT_L_ENABLE = '1' and STANDARD_LSTM_U_OUT_P_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_U_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_U_IN_L_ENABLE <= '1';
            STANDARD_LSTM_U_IN_P_ENABLE <= '1';
          elsif (STANDARD_LSTM_U_OUT_L_ENABLE = '1' and STANDARD_LSTM_U_OUT_P_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_U_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_U_IN_L_ENABLE <= '1';
            STANDARD_LSTM_U_IN_P_ENABLE <= '1';
          elsif (STANDARD_LSTM_U_OUT_P_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_U_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_U_IN_P_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_U_IN_L_ENABLE <= '0';
            STANDARD_LSTM_U_IN_P_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_V_OUT_L_ENABLE = '1' and STANDARD_LSTM_V_OUT_S_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_V_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_V_IN_L_ENABLE <= '1';
            STANDARD_LSTM_V_IN_S_ENABLE <= '1';
          elsif (STANDARD_LSTM_V_OUT_L_ENABLE = '1' and STANDARD_LSTM_V_OUT_S_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_V_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_V_IN_L_ENABLE <= '1';
            STANDARD_LSTM_V_IN_S_ENABLE <= '1';
          elsif (STANDARD_LSTM_V_OUT_S_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_V_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_V_IN_S_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_V_IN_L_ENABLE <= '0';
            STANDARD_LSTM_V_IN_S_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_R_OUT_I_ENABLE = '1' and STANDARD_LSTM_R_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_R_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_R_IN_I_ENABLE <= '1';
            STANDARD_LSTM_R_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_R_OUT_I_ENABLE = '1' and STANDARD_LSTM_R_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_R_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_R_IN_I_ENABLE <= '1';
            STANDARD_LSTM_R_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_R_OUT_K_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_R_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_R_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_R_IN_I_ENABLE <= '0';
            STANDARD_LSTM_R_IN_K_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_RHO_OUT_I_ENABLE = '1' and STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_RHO_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_RHO_IN_I_ENABLE <= '1';
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_RHO_OUT_I_ENABLE = '1' and STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_RHO_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_RHO_IN_I_ENABLE <= '1';
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_RHO_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_RHO_IN_I_ENABLE <= '0';
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_B_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_B_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
          elsif ((STANDARD_LSTM_B_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_B_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
          else
            -- CONTROL
            STANDARD_LSTM_B_IN_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_X_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_X_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_X_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
          elsif ((STANDARD_LSTM_X_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_X_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_X_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
          else
            -- CONTROL
            STANDARD_LSTM_X_IN_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_XI_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_XI_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_XI_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
          elsif ((STANDARD_LSTM_XI_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_XI_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_XI_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
          else
            -- CONTROL
            STANDARD_LSTM_XI_IN_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_H_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_H_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_H_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_H_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_H_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_H_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            STANDARD_LSTM_H_IN_ENABLE <= '0';
          end if;

          -- LOOP
          if (STANDARD_LSTM_W_OUT_X_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_W_OUT_X_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_W_OUT_X_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_K_OUT_K_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_k_loop) < unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_D_OUT_M_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_k_loop) < unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_U_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_U_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_U_OUT_P_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_V_OUT_S_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_V_OUT_S_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_V_OUT_S_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_R_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_R_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_R_OUT_K_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_B_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_B_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_X_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_X_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_XI_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_XI_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_H_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_H_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit STANDARD_LSTM_FIRST_RUN when STANDARD_LSTM_READY = '1';
        end loop STANDARD_LSTM_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_STANDARD_LSTM_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_ACCELERATOR_STANDARD_LSTM_CASE 1                             ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        STANDARD_LSTM_W_IN <= ZERO_DATA;
        STANDARD_LSTM_D_IN <= ZERO_DATA;
        STANDARD_LSTM_K_IN <= ZERO_DATA;
        STANDARD_LSTM_U_IN <= ZERO_DATA;
        STANDARD_LSTM_V_IN <= ZERO_DATA;
        STANDARD_LSTM_B_IN <= ZERO_DATA;

        STANDARD_LSTM_X_IN   <= ZERO_DATA;
        STANDARD_LSTM_R_IN   <= ZERO_DATA;
        STANDARD_LSTM_RHO_IN <= ZERO_DATA;
        STANDARD_LSTM_XI_IN  <= ZERO_DATA;
        STANDARD_LSTM_H_IN   <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        STANDARD_LSTM_SECOND_RUN : loop
          if (STANDARD_LSTM_W_OUT_L_ENABLE = '1' and STANDARD_LSTM_W_OUT_X_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_W_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_W_IN_L_ENABLE <= '1';
            STANDARD_LSTM_W_IN_X_ENABLE <= '1';
          elsif (STANDARD_LSTM_W_OUT_L_ENABLE = '1' and STANDARD_LSTM_W_OUT_X_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_W_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_W_IN_L_ENABLE <= '1';
            STANDARD_LSTM_W_IN_X_ENABLE <= '1';
          elsif (STANDARD_LSTM_W_OUT_X_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_W_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_W_IN_X_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_W_IN_L_ENABLE <= '0';
            STANDARD_LSTM_W_IN_X_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_K_OUT_I_ENABLE = '1' and STANDARD_LSTM_K_OUT_L_ENABLE = '1' and STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_I_ENABLE <= '1';
            STANDARD_LSTM_K_IN_L_ENABLE <= '1';
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_K_OUT_I_ENABLE = '1' and STANDARD_LSTM_K_OUT_L_ENABLE = '1' and STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_I_ENABLE <= '1';
            STANDARD_LSTM_K_IN_L_ENABLE <= '1';
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_K_OUT_L_ENABLE = '1' and STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_L_ENABLE <= '1';
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_K_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_K_IN_I_ENABLE <= '0';
            STANDARD_LSTM_K_IN_L_ENABLE <= '0';
            STANDARD_LSTM_K_IN_K_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_D_OUT_I_ENABLE = '1' and STANDARD_LSTM_D_OUT_L_ENABLE = '1' and STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_I_ENABLE <= '1';
            STANDARD_LSTM_D_IN_L_ENABLE <= '1';
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_D_OUT_I_ENABLE = '1' and STANDARD_LSTM_D_OUT_L_ENABLE = '1' and STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_I_ENABLE <= '1';
            STANDARD_LSTM_D_IN_L_ENABLE <= '1';
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_D_OUT_L_ENABLE = '1' and STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_L_ENABLE <= '1';
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            STANDARD_LSTM_D_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_D_IN_I_ENABLE <= '0';
            STANDARD_LSTM_D_IN_L_ENABLE <= '0';
            STANDARD_LSTM_D_IN_M_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_U_OUT_L_ENABLE = '1' and STANDARD_LSTM_U_OUT_P_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_U_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_U_IN_L_ENABLE <= '1';
            STANDARD_LSTM_U_IN_P_ENABLE <= '1';
          elsif (STANDARD_LSTM_U_OUT_L_ENABLE = '1' and STANDARD_LSTM_U_OUT_P_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_U_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_U_IN_L_ENABLE <= '1';
            STANDARD_LSTM_U_IN_P_ENABLE <= '1';
          elsif (STANDARD_LSTM_U_OUT_P_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_U_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_U_IN_P_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_U_IN_L_ENABLE <= '0';
            STANDARD_LSTM_U_IN_P_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_V_OUT_L_ENABLE = '1' and STANDARD_LSTM_V_OUT_S_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_V_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_V_IN_L_ENABLE <= '1';
            STANDARD_LSTM_V_IN_S_ENABLE <= '1';
          elsif (STANDARD_LSTM_V_OUT_L_ENABLE = '1' and STANDARD_LSTM_V_OUT_S_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_V_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_V_IN_L_ENABLE <= '1';
            STANDARD_LSTM_V_IN_S_ENABLE <= '1';
          elsif (STANDARD_LSTM_V_OUT_S_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_V_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_V_IN_S_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_V_IN_L_ENABLE <= '0';
            STANDARD_LSTM_V_IN_S_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_R_OUT_I_ENABLE = '1' and STANDARD_LSTM_R_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_R_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_R_IN_I_ENABLE <= '1';
            STANDARD_LSTM_R_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_R_OUT_I_ENABLE = '1' and STANDARD_LSTM_R_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_R_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_R_IN_I_ENABLE <= '1';
            STANDARD_LSTM_R_IN_K_ENABLE <= '1';
          elsif (STANDARD_LSTM_R_OUT_K_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_R_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_R_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_R_IN_I_ENABLE <= '0';
            STANDARD_LSTM_R_IN_K_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_RHO_OUT_I_ENABLE = '1' and STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_RHO_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_RHO_IN_I_ENABLE <= '1';
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_RHO_OUT_I_ENABLE = '1' and STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_RHO_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_RHO_IN_I_ENABLE <= '1';
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '1';
          elsif (STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            STANDARD_LSTM_RHO_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            STANDARD_LSTM_RHO_IN_I_ENABLE <= '0';
            STANDARD_LSTM_RHO_IN_M_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_B_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_B_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
          elsif ((STANDARD_LSTM_B_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_B_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
          else
            -- CONTROL
            STANDARD_LSTM_B_IN_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_X_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_X_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_X_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
          elsif ((STANDARD_LSTM_X_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_X_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_X_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
          else
            -- CONTROL
            STANDARD_LSTM_X_IN_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_XI_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_XI_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_XI_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
          elsif ((STANDARD_LSTM_XI_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_XI_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_XI_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
          else
            -- CONTROL
            STANDARD_LSTM_XI_IN_ENABLE <= '0';
          end if;

          if (STANDARD_LSTM_H_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_H_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_H_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_H_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            STANDARD_LSTM_H_IN_ENABLE <= '1';

            -- DATA
            STANDARD_LSTM_H_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            STANDARD_LSTM_H_IN_ENABLE <= '0';
          end if;

          -- LOOP
          if (STANDARD_LSTM_W_OUT_X_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_W_OUT_X_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_W_OUT_X_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_K_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_K_OUT_K_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_k_loop) < unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_D_OUT_M_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_D_OUT_M_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_k_loop) < unsigned(STANDARD_LSTM_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_U_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_U_OUT_P_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_U_OUT_P_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_V_OUT_S_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_V_OUT_S_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_V_OUT_S_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_R_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_R_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_R_OUT_K_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_RHO_OUT_M_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_j_loop) < unsigned(STANDARD_LSTM_SIZE_R_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_B_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_B_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_X_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_X_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_XI_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_XI_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          if (STANDARD_LSTM_H_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
          elsif ((STANDARD_LSTM_H_OUT_ENABLE = '1' or STANDARD_LSTM_START = '1') and (unsigned(index_i_loop) < unsigned(STANDARD_LSTM_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit STANDARD_LSTM_SECOND_RUN when STANDARD_LSTM_READY = '1';
        end loop STANDARD_LSTM_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
