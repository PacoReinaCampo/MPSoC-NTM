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
use work.model_math_pkg.all;

use work.model_convolutional_linear_pkg.all;

entity model_convolutional_linear_stimulus is
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
    CONVOLUTIONAL_LINEAR_START : out std_logic;
    CONVOLUTIONAL_LINEAR_READY : in  std_logic;

    CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE : out std_logic;  -- for x out 0 to X-1

    CONVOLUTIONAL_LINEAR_W_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE : in std_logic;  -- for x out 0 to X-1

    CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

    CONVOLUTIONAL_LINEAR_K_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE : out std_logic;  -- for m out 0 to M-1

    CONVOLUTIONAL_LINEAR_D_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE : in std_logic;  -- for m out 0 to M-1

    CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE : out std_logic;  -- for p out 0 to L-1

    CONVOLUTIONAL_LINEAR_U_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE : in std_logic;  -- for p out 0 to L-1

    CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE : out std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE : out std_logic;  -- for s out 0 to S-1

    CONVOLUTIONAL_LINEAR_V_OUT_L_ENABLE : in std_logic;  -- for l out 0 to L-1
    CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE : in std_logic;  -- for s out 0 to S-1

    CONVOLUTIONAL_LINEAR_B_IN_ENABLE : out std_logic;  -- for l out 0 to L-1

    CONVOLUTIONAL_LINEAR_B_OUT_ENABLE : in std_logic;  -- for l out 0 to L-1

    CONVOLUTIONAL_LINEAR_X_IN_ENABLE : out std_logic;  -- for x out 0 to X-1

    CONVOLUTIONAL_LINEAR_X_OUT_ENABLE : in std_logic;  -- for x out 0 to X-1

    CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

    CONVOLUTIONAL_LINEAR_R_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE : out std_logic;  -- for m out 0 to M-1

    CONVOLUTIONAL_LINEAR_RHO_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1 (read heads flow)
    CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE : in std_logic;  -- for m out 0 to M-1

    CONVOLUTIONAL_LINEAR_XI_IN_ENABLE : out std_logic;  -- for s out 0 to S-1

    CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE : in std_logic;  -- for s out 0 to S-1

    CONVOLUTIONAL_LINEAR_H_IN_ENABLE : out std_logic;  -- for l out 0 to L-1

    CONVOLUTIONAL_LINEAR_H_OUT_ENABLE : in std_logic;  -- for l out 0 to L-1

    CONVOLUTIONAL_LINEAR_H_ENABLE : in std_logic;  -- for l out 0 to L-1

    -- DATA
    CONVOLUTIONAL_LINEAR_SIZE_X_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_SIZE_W_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_SIZE_L_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_SIZE_S_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_SIZE_M_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    CONVOLUTIONAL_LINEAR_W_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_D_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_V_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    CONVOLUTIONAL_LINEAR_X_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_R_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_RHO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_XI_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
    CONVOLUTIONAL_LINEAR_H_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);

    CONVOLUTIONAL_LINEAR_H_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_convolutional_linear_stimulus_architecture of model_convolutional_linear_stimulus is

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
  signal index_w_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_w_x_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_k_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_d_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_d_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_d_m_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_u_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_u_p_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_v_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_v_s_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_r_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_r_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_rho_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_rho_m_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_b_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_x_x_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_xi_s_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_h_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  CONVOLUTIONAL_LINEAR_START <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_MODEL_CONVOLUTIONAL_LINEAR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_CONVOLUTIONAL_LINEAR_TEST                                 ";
      -------------------------------------------------------------------

      -- DATA
      CONVOLUTIONAL_LINEAR_SIZE_X_IN <= FOUR_CONTROL;
      CONVOLUTIONAL_LINEAR_SIZE_W_IN <= FOUR_CONTROL;
      CONVOLUTIONAL_LINEAR_SIZE_L_IN <= FOUR_CONTROL;
      CONVOLUTIONAL_LINEAR_SIZE_R_IN <= FOUR_CONTROL;
      CONVOLUTIONAL_LINEAR_SIZE_S_IN <= FOUR_CONTROL;
      CONVOLUTIONAL_LINEAR_SIZE_M_IN <= FOUR_CONTROL;

      if (STIMULUS_MODEL_CONVOLUTIONAL_LINEAR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_CONVOLUTIONAL_LINEAR_CASE 0                               ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        CONVOLUTIONAL_LINEAR_W_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_D_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_K_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_U_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_V_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_B_IN <= ZERO_DATA;

        CONVOLUTIONAL_LINEAR_X_IN   <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_R_IN   <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_RHO_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_XI_IN  <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_H_IN   <= ZERO_DATA;

        -- LOOP
        index_w_l_loop <= ZERO_CONTROL;
        index_w_x_loop <= ZERO_CONTROL;

        index_k_i_loop <= ZERO_CONTROL;
        index_k_l_loop <= ZERO_CONTROL;
        index_k_k_loop <= ZERO_CONTROL;

        index_d_i_loop <= ZERO_CONTROL;
        index_d_l_loop <= ZERO_CONTROL;
        index_d_m_loop <= ZERO_CONTROL;

        index_u_l_loop <= ZERO_CONTROL;
        index_u_p_loop <= ZERO_CONTROL;

        index_v_l_loop <= ZERO_CONTROL;
        index_v_s_loop <= ZERO_CONTROL;

        index_r_i_loop <= ZERO_CONTROL;
        index_r_k_loop <= ZERO_CONTROL;

        index_rho_i_loop <= ZERO_CONTROL;
        index_rho_m_loop <= ZERO_CONTROL;

        index_b_l_loop <= ZERO_CONTROL;

        index_x_x_loop <= ZERO_CONTROL;

        index_xi_s_loop <= ZERO_CONTROL;

        index_h_l_loop <= ZERO_CONTROL;

        CONVOLUTIONAL_LINEAR_FIRST_RUN : loop
          if (CONVOLUTIONAL_LINEAR_W_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and unsigned(index_w_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_w_x_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_W_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_w_l_loop)), to_integer(unsigned(index_w_x_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_W_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and unsigned(index_w_x_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_W_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_w_l_loop)), to_integer(unsigned(index_w_x_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and unsigned(index_w_x_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_W_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_w_l_loop)), to_integer(unsigned(index_w_x_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_K_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_D_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_d_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_d_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_d_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_m_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_U_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and unsigned(index_u_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_u_p_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_U_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_u_l_loop)), to_integer(unsigned(index_u_p_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_U_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and unsigned(index_u_p_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_U_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_u_l_loop)), to_integer(unsigned(index_u_p_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and unsigned(index_u_p_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_U_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_u_l_loop)), to_integer(unsigned(index_u_p_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_V_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and unsigned(index_v_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_v_s_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_V_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_v_l_loop)), to_integer(unsigned(index_v_s_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_V_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and unsigned(index_v_s_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_V_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_v_l_loop)), to_integer(unsigned(index_v_s_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and unsigned(index_v_s_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_V_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_v_l_loop)), to_integer(unsigned(index_v_s_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_R_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and unsigned(index_r_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_r_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_R_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_r_i_loop)), to_integer(unsigned(index_r_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_R_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and unsigned(index_r_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_R_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_r_i_loop)), to_integer(unsigned(index_r_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and unsigned(index_r_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_R_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_r_i_loop)), to_integer(unsigned(index_r_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_RHO_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and unsigned(index_rho_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_rho_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_RHO_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_rho_i_loop)), to_integer(unsigned(index_rho_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_RHO_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and unsigned(index_rho_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_RHO_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_rho_i_loop)), to_integer(unsigned(index_rho_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and unsigned(index_rho_m_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_RHO_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_rho_i_loop)), to_integer(unsigned(index_rho_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' and (unsigned(index_b_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_B_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_b_l_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_b_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_B_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_b_l_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_B_IN_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' and (unsigned(index_x_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_X_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_X_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_x_x_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_x_x_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_X_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_X_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_x_x_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_X_IN_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' and (unsigned(index_xi_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_XI_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_XI_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_xi_s_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_xi_s_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_XI_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_XI_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_xi_s_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_XI_IN_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' and (unsigned(index_h_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_H_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_H_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_h_l_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_h_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_H_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_H_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_h_l_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_H_IN_ENABLE <= '0';
          end if;

          -- LOOP
          if (CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and (unsigned(index_w_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_w_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_w_l_loop <= ZERO_CONTROL;
            index_w_x_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and (unsigned(index_w_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_w_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_w_l_loop <= std_logic_vector(unsigned(index_w_l_loop) + unsigned(ONE_CONTROL));
            index_w_x_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_w_x_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_w_x_loop <= std_logic_vector(unsigned(index_w_x_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and (unsigned(index_k_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_i_loop <= ZERO_CONTROL;
            index_k_l_loop <= ZERO_CONTROL;
            index_k_k_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and (unsigned(index_k_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_i_loop <= std_logic_vector(unsigned(index_k_i_loop) + unsigned(ONE_CONTROL));
            index_k_l_loop <= ZERO_CONTROL;
            index_k_k_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and (unsigned(index_k_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_l_loop <= std_logic_vector(unsigned(index_k_l_loop) + unsigned(ONE_CONTROL));
            index_k_k_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_k_k_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_k_loop <= std_logic_vector(unsigned(index_k_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and (unsigned(index_d_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_i_loop <= ZERO_CONTROL;
            index_d_l_loop <= ZERO_CONTROL;
            index_d_m_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and (unsigned(index_d_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_i_loop <= std_logic_vector(unsigned(index_d_i_loop) + unsigned(ONE_CONTROL));
            index_d_l_loop <= ZERO_CONTROL;
            index_d_m_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and (unsigned(index_d_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_l_loop <= std_logic_vector(unsigned(index_d_l_loop) + unsigned(ONE_CONTROL));
            index_d_m_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_d_m_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_m_loop <= std_logic_vector(unsigned(index_d_m_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and (unsigned(index_u_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_u_p_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_u_l_loop <= ZERO_CONTROL;
            index_u_p_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and (unsigned(index_u_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_u_p_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_u_l_loop <= std_logic_vector(unsigned(index_u_l_loop) + unsigned(ONE_CONTROL));
            index_u_p_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_u_p_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_u_p_loop <= std_logic_vector(unsigned(index_u_p_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and (unsigned(index_v_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_v_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_v_l_loop <= ZERO_CONTROL;
            index_v_s_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and (unsigned(index_v_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_v_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_v_l_loop <= std_logic_vector(unsigned(index_v_l_loop) + unsigned(ONE_CONTROL));
            index_v_s_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_v_s_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_v_s_loop <= std_logic_vector(unsigned(index_v_s_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and (unsigned(index_r_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_r_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_r_i_loop <= ZERO_CONTROL;
            index_r_k_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and (unsigned(index_r_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_r_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_r_i_loop <= std_logic_vector(unsigned(index_r_i_loop) + unsigned(ONE_CONTROL));
            index_r_k_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_r_k_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_r_k_loop <= std_logic_vector(unsigned(index_r_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and (unsigned(index_rho_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_rho_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            index_rho_i_loop <= ZERO_CONTROL;
            index_rho_m_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and (unsigned(index_rho_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_rho_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            index_rho_i_loop <= std_logic_vector(unsigned(index_rho_i_loop) + unsigned(ONE_CONTROL));
            index_rho_m_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_rho_m_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            index_rho_m_loop <= std_logic_vector(unsigned(index_rho_m_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' and (unsigned(index_b_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_b_l_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_b_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_b_l_loop <= std_logic_vector(unsigned(index_b_l_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' and (unsigned(index_x_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_x_x_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_x_x_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_x_x_loop <= std_logic_vector(unsigned(index_x_x_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' and (unsigned(index_xi_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_xi_s_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_xi_s_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_xi_s_loop <= std_logic_vector(unsigned(index_xi_s_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' and (unsigned(index_h_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_h_l_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_h_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_h_l_loop <= std_logic_vector(unsigned(index_h_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit CONVOLUTIONAL_LINEAR_FIRST_RUN when CONVOLUTIONAL_LINEAR_READY = '1';
        end loop CONVOLUTIONAL_LINEAR_FIRST_RUN;
      end if;

      if (STIMULUS_MODEL_CONVOLUTIONAL_LINEAR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_CONVOLUTIONAL_LINEAR_CASE 1                               ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        CONVOLUTIONAL_LINEAR_W_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_D_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_K_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_U_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_V_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_B_IN <= ZERO_DATA;

        CONVOLUTIONAL_LINEAR_X_IN   <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_R_IN   <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_RHO_IN <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_XI_IN  <= ZERO_DATA;
        CONVOLUTIONAL_LINEAR_H_IN   <= ZERO_DATA;

        -- LOOP
        index_w_l_loop <= ZERO_CONTROL;
        index_w_x_loop <= ZERO_CONTROL;

        index_k_i_loop <= ZERO_CONTROL;
        index_k_l_loop <= ZERO_CONTROL;
        index_k_k_loop <= ZERO_CONTROL;

        index_d_i_loop <= ZERO_CONTROL;
        index_d_l_loop <= ZERO_CONTROL;
        index_d_m_loop <= ZERO_CONTROL;

        index_u_l_loop <= ZERO_CONTROL;
        index_u_p_loop <= ZERO_CONTROL;

        index_v_l_loop <= ZERO_CONTROL;
        index_v_s_loop <= ZERO_CONTROL;

        index_r_i_loop <= ZERO_CONTROL;
        index_r_k_loop <= ZERO_CONTROL;

        index_rho_i_loop <= ZERO_CONTROL;
        index_rho_m_loop <= ZERO_CONTROL;

        index_b_l_loop <= ZERO_CONTROL;

        index_x_x_loop <= ZERO_CONTROL;

        index_xi_s_loop <= ZERO_CONTROL;

        index_h_l_loop <= ZERO_CONTROL;

        CONVOLUTIONAL_LINEAR_SECOND_RUN : loop
          if (CONVOLUTIONAL_LINEAR_W_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and unsigned(index_w_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_w_x_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_W_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_w_l_loop)), to_integer(unsigned(index_w_x_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_W_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and unsigned(index_w_x_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_W_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_w_l_loop)), to_integer(unsigned(index_w_x_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and unsigned(index_w_x_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_W_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_w_l_loop)), to_integer(unsigned(index_w_x_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_W_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_W_IN_X_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_K_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and unsigned(index_k_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_K_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_k_i_loop)), to_integer(unsigned(index_k_l_loop)), to_integer(unsigned(index_k_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_K_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_K_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_K_IN_K_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_D_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_d_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_d_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_d_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and unsigned(index_d_m_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_D_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_d_i_loop)), to_integer(unsigned(index_d_l_loop)), to_integer(unsigned(index_d_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_D_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_D_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_D_IN_M_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_U_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and unsigned(index_u_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_u_p_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_U_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_u_l_loop)), to_integer(unsigned(index_u_p_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_U_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and unsigned(index_u_p_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_U_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_u_l_loop)), to_integer(unsigned(index_u_p_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and unsigned(index_u_p_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_U_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_u_l_loop)), to_integer(unsigned(index_u_p_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_U_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_U_IN_P_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_V_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and unsigned(index_v_l_loop) = unsigned(ZERO_CONTROL) and unsigned(index_v_s_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_V_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_v_l_loop)), to_integer(unsigned(index_v_s_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_V_OUT_L_ENABLE = '1' and CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and unsigned(index_v_s_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_V_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_v_l_loop)), to_integer(unsigned(index_v_s_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and unsigned(index_v_s_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_V_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_v_l_loop)), to_integer(unsigned(index_v_s_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_V_IN_L_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_V_IN_S_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_R_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and unsigned(index_r_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_r_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_R_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_r_i_loop)), to_integer(unsigned(index_r_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_R_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and unsigned(index_r_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_R_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_r_i_loop)), to_integer(unsigned(index_r_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and unsigned(index_r_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_R_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_r_i_loop)), to_integer(unsigned(index_r_k_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_R_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_R_IN_K_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_RHO_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and unsigned(index_rho_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_rho_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_RHO_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_rho_i_loop)), to_integer(unsigned(index_rho_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_RHO_OUT_I_ENABLE = '1' and CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and unsigned(index_rho_m_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_RHO_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_rho_i_loop)), to_integer(unsigned(index_rho_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE <= '1';
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '1';
          elsif (CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and unsigned(index_rho_m_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            CONVOLUTIONAL_LINEAR_RHO_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_rho_i_loop)), to_integer(unsigned(index_rho_m_loop)));

            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '1';
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_RHO_IN_I_ENABLE <= '0';
            CONVOLUTIONAL_LINEAR_RHO_IN_M_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' and (unsigned(index_b_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_B_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_b_l_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_b_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_B_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_b_l_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_B_IN_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' and (unsigned(index_x_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_X_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_X_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_x_x_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_x_x_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_X_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_X_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_x_x_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_X_IN_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' and (unsigned(index_xi_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_XI_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_XI_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_xi_s_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_xi_s_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_XI_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_XI_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_xi_s_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_XI_IN_ENABLE <= '0';
          end if;

          if (CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' and (unsigned(index_h_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_H_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_H_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_h_l_loop)));
          elsif ((CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_h_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            CONVOLUTIONAL_LINEAR_H_IN_ENABLE <= '1';

            -- DATA
            CONVOLUTIONAL_LINEAR_H_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_h_l_loop)));
          else
            -- CONTROL
            CONVOLUTIONAL_LINEAR_H_IN_ENABLE <= '0';
          end if;

          -- LOOP
          if (CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and (unsigned(index_w_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_w_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_w_l_loop <= ZERO_CONTROL;
            index_w_x_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' and (unsigned(index_w_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_w_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_w_l_loop <= std_logic_vector(unsigned(index_w_l_loop) + unsigned(ONE_CONTROL));
            index_w_x_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_W_OUT_X_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_w_x_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_w_x_loop <= std_logic_vector(unsigned(index_w_x_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and (unsigned(index_k_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_i_loop <= ZERO_CONTROL;
            index_k_l_loop <= ZERO_CONTROL;
            index_k_k_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and (unsigned(index_k_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_i_loop <= std_logic_vector(unsigned(index_k_i_loop) + unsigned(ONE_CONTROL));
            index_k_l_loop <= ZERO_CONTROL;
            index_k_k_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' and (unsigned(index_k_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_l_loop <= std_logic_vector(unsigned(index_k_l_loop) + unsigned(ONE_CONTROL));
            index_k_k_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_K_OUT_K_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_k_k_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_k_k_loop <= std_logic_vector(unsigned(index_k_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and (unsigned(index_d_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_i_loop <= ZERO_CONTROL;
            index_d_l_loop <= ZERO_CONTROL;
            index_d_m_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and (unsigned(index_d_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_i_loop <= std_logic_vector(unsigned(index_d_i_loop) + unsigned(ONE_CONTROL));
            index_d_l_loop <= ZERO_CONTROL;
            index_d_m_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' and (unsigned(index_d_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_d_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_l_loop <= std_logic_vector(unsigned(index_d_l_loop) + unsigned(ONE_CONTROL));
            index_d_m_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_D_OUT_M_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_d_m_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_d_m_loop <= std_logic_vector(unsigned(index_d_m_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and (unsigned(index_u_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_u_p_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_u_l_loop <= ZERO_CONTROL;
            index_u_p_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' and (unsigned(index_u_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_u_p_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_u_l_loop <= std_logic_vector(unsigned(index_u_l_loop) + unsigned(ONE_CONTROL));
            index_u_p_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_U_OUT_P_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_u_p_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_u_p_loop <= std_logic_vector(unsigned(index_u_p_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and (unsigned(index_v_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_v_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_v_l_loop <= ZERO_CONTROL;
            index_v_s_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' and (unsigned(index_v_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_v_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_v_l_loop <= std_logic_vector(unsigned(index_v_l_loop) + unsigned(ONE_CONTROL));
            index_v_s_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_V_OUT_S_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_v_s_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_v_s_loop <= std_logic_vector(unsigned(index_v_s_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and (unsigned(index_r_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_r_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_r_i_loop <= ZERO_CONTROL;
            index_r_k_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' and (unsigned(index_r_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_r_k_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_r_i_loop <= std_logic_vector(unsigned(index_r_i_loop) + unsigned(ONE_CONTROL));
            index_r_k_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_R_OUT_K_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_r_k_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            index_r_k_loop <= std_logic_vector(unsigned(index_r_k_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and (unsigned(index_rho_i_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_rho_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            index_rho_i_loop <= ZERO_CONTROL;
            index_rho_m_loop <= ZERO_CONTROL;
          elsif (CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' and (unsigned(index_rho_i_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_rho_m_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            index_rho_i_loop <= std_logic_vector(unsigned(index_rho_i_loop) + unsigned(ONE_CONTROL));
            index_rho_m_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_RHO_OUT_M_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_rho_m_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            index_rho_m_loop <= std_logic_vector(unsigned(index_rho_m_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' and (unsigned(index_b_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_b_l_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_B_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_b_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_b_l_loop <= std_logic_vector(unsigned(index_b_l_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' and (unsigned(index_x_x_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_x_x_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_X_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_x_x_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            index_x_x_loop <= std_logic_vector(unsigned(index_x_x_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' and (unsigned(index_xi_s_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_xi_s_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_XI_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_xi_s_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            index_xi_s_loop <= std_logic_vector(unsigned(index_xi_s_loop) + unsigned(ONE_CONTROL));
          end if;

          if (CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' and (unsigned(index_h_l_loop) = unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_h_l_loop <= ZERO_CONTROL;
          elsif ((CONVOLUTIONAL_LINEAR_H_OUT_ENABLE = '1' or CONVOLUTIONAL_LINEAR_START = '1') and (unsigned(index_h_l_loop) < unsigned(CONVOLUTIONAL_LINEAR_SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            index_h_l_loop <= std_logic_vector(unsigned(index_h_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit CONVOLUTIONAL_LINEAR_SECOND_RUN when CONVOLUTIONAL_LINEAR_READY = '1';
        end loop CONVOLUTIONAL_LINEAR_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
