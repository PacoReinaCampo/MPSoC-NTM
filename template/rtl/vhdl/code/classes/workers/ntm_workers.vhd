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
--              Peripheral-DNC for MPSoC                                      --
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;
use work.ntm_lstm_controller_pkg.all;
use work.dnc_core_pkg.all;
use work.dnc_top_pkg.all;

entity ntm_workers is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    NUMBER_PHILOSOPHER : integer := 64;
    NUMBER_SOLDIER     : integer := 64;
    NUMBER_WORKER      : integer := 64
    );
end ntm_workers;

architecture ntm_workers_architecture of ntm_workers is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- CONTROL
  signal start_top : std_logic;
  signal ready_top : std_logic;

  -- PHILOSOPHER
  signal w_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal w_in_x_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal w_out_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal w_out_x_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal k_in_i_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal k_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal k_in_k_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal k_out_i_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal k_out_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal k_out_k_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal u_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal u_in_p_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal u_out_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal u_out_p_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal v_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal v_in_s_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal v_out_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal v_out_s_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal d_in_i_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal d_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal d_in_m_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal d_out_i_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal d_out_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal d_out_m_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal b_in_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal b_out_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal x_in_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal x_out_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal p_in_i_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal p_in_y_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal p_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal p_out_i_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal p_out_y_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal p_out_k_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal q_in_y_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal q_in_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal q_out_y_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);
  signal q_out_l_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  signal y_out_enable_philosopher : std_logic_vector(NUMBER_PHILOSOPHER-1 downto 0);

  -- DATA
  signal size_x_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_y_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_n_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_w_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_l_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_r_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(CONTROL_SIZE-1 downto 0);

  signal w_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal d_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal x_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal p_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal q_in_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal y_out_philosopher : std_logic_matrix(NUMBER_PHILOSOPHER-1 downto 0)(DATA_SIZE-1 downto 0);

  -- SOLDIER
  signal w_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal w_in_x_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal w_out_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal w_out_x_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal k_in_i_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal k_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal k_in_k_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal k_out_i_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal k_out_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal k_out_k_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal u_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal u_in_p_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal u_out_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal u_out_p_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal v_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal v_in_s_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal v_out_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal v_out_s_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal d_in_i_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal d_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal d_in_m_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal d_out_i_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal d_out_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal d_out_m_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal b_in_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal b_out_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal x_in_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal x_out_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal p_in_i_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal p_in_y_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal p_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal p_out_i_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal p_out_y_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal p_out_k_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal q_in_y_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal q_in_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal q_out_y_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);
  signal q_out_l_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  signal y_out_enable_soldier : std_logic_vector(NUMBER_SOLDIER-1 downto 0);

  -- DATA
  signal size_x_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_y_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_n_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_w_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_l_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_r_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(CONTROL_SIZE-1 downto 0);

  signal w_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal d_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal x_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal p_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal q_in_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal y_out_soldier : std_logic_matrix(NUMBER_SOLDIER-1 downto 0)(DATA_SIZE-1 downto 0);

  -- WORKER
  signal w_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal w_in_x_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal w_out_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal w_out_x_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal k_in_i_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal k_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal k_in_k_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal k_out_i_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal k_out_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal k_out_k_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal u_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal u_in_p_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal u_out_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal u_out_p_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal v_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal v_in_s_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal v_out_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal v_out_s_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal d_in_i_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal d_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal d_in_m_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal d_out_i_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal d_out_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal d_out_m_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal b_in_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal b_out_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal x_in_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal x_out_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal p_in_i_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal p_in_y_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal p_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal p_out_i_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal p_out_y_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal p_out_k_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal q_in_y_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal q_in_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal q_out_y_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);
  signal q_out_l_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  signal y_out_enable_worker : std_logic_vector(NUMBER_WORKER-1 downto 0);

  -- DATA
  signal size_x_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_y_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_n_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_w_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_l_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(CONTROL_SIZE-1 downto 0);
  signal size_r_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(CONTROL_SIZE-1 downto 0);

  signal w_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal v_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal d_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal x_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal p_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);
  signal q_in_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);

  signal y_out_worker : std_logic_matrix(NUMBER_WORKER-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- PHILOSOPHER
  dnc_top_philosopher : for i in 0 to NUMBER_PHILOSOPHER-1 generate
    philosopher : dnc_top
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_top,
        READY => ready_top,

        W_IN_L_ENABLE => w_in_l_enable_philosopher(i),
        W_IN_X_ENABLE => w_in_x_enable_philosopher(i),

        W_OUT_L_ENABLE => w_out_l_enable_philosopher(i),
        W_OUT_X_ENABLE => w_out_x_enable_philosopher(i),

        K_IN_I_ENABLE => k_in_i_enable_philosopher(i),
        K_IN_L_ENABLE => k_in_l_enable_philosopher(i),
        K_IN_K_ENABLE => k_in_k_enable_philosopher(i),

        K_OUT_I_ENABLE => k_out_i_enable_philosopher(i),
        K_OUT_L_ENABLE => k_out_l_enable_philosopher(i),
        K_OUT_K_ENABLE => k_out_k_enable_philosopher(i),

        U_IN_L_ENABLE => u_in_l_enable_philosopher(i),
        U_IN_P_ENABLE => u_in_p_enable_philosopher(i),

        U_OUT_L_ENABLE => u_out_l_enable_philosopher(i),
        U_OUT_P_ENABLE => u_out_p_enable_philosopher(i),

        V_IN_L_ENABLE => v_in_l_enable_philosopher(i),
        V_IN_S_ENABLE => v_in_s_enable_philosopher(i),

        V_OUT_L_ENABLE => v_out_l_enable_philosopher(i),
        V_OUT_S_ENABLE => v_out_s_enable_philosopher(i),

        D_IN_I_ENABLE => d_in_i_enable_philosopher(i),
        D_IN_L_ENABLE => d_in_l_enable_philosopher(i),
        D_IN_M_ENABLE => d_in_m_enable_philosopher(i),

        D_OUT_I_ENABLE => d_out_i_enable_philosopher(i),
        D_OUT_L_ENABLE => d_out_l_enable_philosopher(i),
        D_OUT_M_ENABLE => d_out_m_enable_philosopher(i),

        B_IN_ENABLE => b_in_enable_philosopher(i),

        B_OUT_ENABLE => b_out_enable_philosopher(i),

        X_IN_ENABLE => x_in_enable_philosopher(i),

        X_OUT_ENABLE => x_out_enable_philosopher(i),

        P_IN_I_ENABLE => p_in_i_enable_philosopher(i),
        P_IN_Y_ENABLE => p_in_y_enable_philosopher(i),
        P_IN_K_ENABLE => p_in_l_enable_philosopher(i),

        P_OUT_I_ENABLE => p_out_i_enable_philosopher(i),
        P_OUT_Y_ENABLE => p_out_y_enable_philosopher(i),
        P_OUT_K_ENABLE => p_out_k_enable_philosopher(i),

        Q_IN_Y_ENABLE => q_in_y_enable_philosopher(i),
        Q_IN_L_ENABLE => q_in_l_enable_philosopher(i),

        Q_OUT_Y_ENABLE => q_out_y_enable_philosopher(i),
        Q_OUT_L_ENABLE => q_out_l_enable_philosopher(i),

        Y_OUT_ENABLE => y_out_enable_philosopher(i),

        -- DATA
        SIZE_X_IN => size_x_in_philosopher(i),
        SIZE_Y_IN => size_y_in_philosopher(i),
        SIZE_N_IN => size_n_in_philosopher(i),
        SIZE_W_IN => size_w_in_philosopher(i),
        SIZE_L_IN => size_l_in_philosopher(i),
        SIZE_R_IN => size_r_in_philosopher(i),

        W_IN => w_in_philosopher(i),
        K_IN => k_in_philosopher(i),
        U_IN => u_in_philosopher(i),
        V_IN => v_in_philosopher(i),
        D_IN => d_in_philosopher(i),
        B_IN => b_in_philosopher(i),

        X_IN => x_in_philosopher(i),

        P_IN => p_in_philosopher(i),
        Q_IN => q_in_philosopher(i),

        Y_OUT => y_out_philosopher(i)
        );
  end generate dnc_top_philosopher;

  -- SOLIDIER
  dnc_top_soldier : for i in 0 to NUMBER_SOLIDIER-1 generate
    soldier : dnc_top
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_top,
        READY => ready_top,

        W_IN_L_ENABLE => w_in_l_enable_soldier(i),
        W_IN_X_ENABLE => w_in_x_enable_soldier(i),

        W_OUT_L_ENABLE => w_out_l_enable_soldier(i),
        W_OUT_X_ENABLE => w_out_x_enable_soldier(i),

        K_IN_I_ENABLE => k_in_i_enable_soldier(i),
        K_IN_L_ENABLE => k_in_l_enable_soldier(i),
        K_IN_K_ENABLE => k_in_k_enable_soldier(i),

        K_OUT_I_ENABLE => k_out_i_enable_soldier(i),
        K_OUT_L_ENABLE => k_out_l_enable_soldier(i),
        K_OUT_K_ENABLE => k_out_k_enable_soldier(i),

        U_IN_L_ENABLE => u_in_l_enable_soldier(i),
        U_IN_P_ENABLE => u_in_p_enable_soldier(i),

        U_OUT_L_ENABLE => u_out_l_enable_soldier(i),
        U_OUT_P_ENABLE => u_out_p_enable_soldier(i),

        V_IN_L_ENABLE => v_in_l_enable_soldier(i),
        V_IN_S_ENABLE => v_in_s_enable_soldier(i),

        V_OUT_L_ENABLE => v_out_l_enable_soldier(i),
        V_OUT_S_ENABLE => v_out_s_enable_soldier(i),

        D_IN_I_ENABLE => d_in_i_enable_soldier(i),
        D_IN_L_ENABLE => d_in_l_enable_soldier(i),
        D_IN_M_ENABLE => d_in_m_enable_soldier(i),

        D_OUT_I_ENABLE => d_out_i_enable_soldier(i),
        D_OUT_L_ENABLE => d_out_l_enable_soldier(i),
        D_OUT_M_ENABLE => d_out_m_enable_soldier(i),

        B_IN_ENABLE => b_in_enable_soldier(i),

        B_OUT_ENABLE => b_out_enable_soldier(i),

        X_IN_ENABLE => x_in_enable_soldier(i),

        X_OUT_ENABLE => x_out_enable_soldier(i),

        P_IN_I_ENABLE => p_in_i_enable_soldier(i),
        P_IN_Y_ENABLE => p_in_y_enable_soldier(i),
        P_IN_K_ENABLE => p_in_l_enable_soldier(i),

        P_OUT_I_ENABLE => p_out_i_enable_soldier(i),
        P_OUT_Y_ENABLE => p_out_y_enable_soldier(i),
        P_OUT_K_ENABLE => p_out_k_enable_soldier(i),

        Q_IN_Y_ENABLE => q_in_y_enable_soldier(i),
        Q_IN_L_ENABLE => q_in_l_enable_soldier(i),

        Q_OUT_Y_ENABLE => q_out_y_enable_soldier(i),
        Q_OUT_L_ENABLE => q_out_l_enable_soldier(i),

        Y_OUT_ENABLE => y_out_enable_soldier(i),

        -- DATA
        SIZE_X_IN => size_x_in_soldier(i),
        SIZE_Y_IN => size_y_in_soldier(i),
        SIZE_N_IN => size_n_in_soldier(i),
        SIZE_W_IN => size_w_in_soldier(i),
        SIZE_L_IN => size_l_in_soldier(i),
        SIZE_R_IN => size_r_in_soldier(i),

        W_IN => w_in_soldier(i),
        K_IN => k_in_soldier(i),
        U_IN => u_in_soldier(i),
        V_IN => v_in_soldier(i),
        D_IN => d_in_soldier(i),
        B_IN => b_in_soldier(i),

        X_IN => x_in_soldier(i),

        P_IN => p_in_soldier(i),
        Q_IN => q_in_soldier(i),

        Y_OUT => y_out_soldier(i)
        );
  end generate dnc_top_soldier;

  -- WORKER
  dnc_top_worker : for i in 0 to NUMBER_WORKER-1 generate
    worker : dnc_top
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_top,
        READY => ready_top,

        W_IN_L_ENABLE => w_in_l_enable_worker(i),
        W_IN_X_ENABLE => w_in_x_enable_worker(i),

        W_OUT_L_ENABLE => w_out_l_enable_worker(i),
        W_OUT_X_ENABLE => w_out_x_enable_worker(i),

        K_IN_I_ENABLE => k_in_i_enable_worker(i),
        K_IN_L_ENABLE => k_in_l_enable_worker(i),
        K_IN_K_ENABLE => k_in_k_enable_worker(i),

        K_OUT_I_ENABLE => k_out_i_enable_worker(i),
        K_OUT_L_ENABLE => k_out_l_enable_worker(i),
        K_OUT_K_ENABLE => k_out_k_enable_worker(i),

        U_IN_L_ENABLE => u_in_l_enable_worker(i),
        U_IN_P_ENABLE => u_in_p_enable_worker(i),

        U_OUT_L_ENABLE => u_out_l_enable_worker(i),
        U_OUT_P_ENABLE => u_out_p_enable_worker(i),

        V_IN_L_ENABLE => v_in_l_enable_worker(i),
        V_IN_S_ENABLE => v_in_s_enable_worker(i),

        V_OUT_L_ENABLE => v_out_l_enable_worker(i),
        V_OUT_S_ENABLE => v_out_s_enable_worker(i),

        D_IN_I_ENABLE => d_in_i_enable_worker(i),
        D_IN_L_ENABLE => d_in_l_enable_worker(i),
        D_IN_M_ENABLE => d_in_m_enable_worker(i),

        D_OUT_I_ENABLE => d_out_i_enable_worker(i),
        D_OUT_L_ENABLE => d_out_l_enable_worker(i),
        D_OUT_M_ENABLE => d_out_m_enable_worker(i),

        B_IN_ENABLE => b_in_enable_worker(i),

        B_OUT_ENABLE => b_out_enable_worker(i),

        X_IN_ENABLE => x_in_enable_worker(i),

        X_OUT_ENABLE => x_out_enable_worker(i),

        P_IN_I_ENABLE => p_in_i_enable_worker(i),
        P_IN_Y_ENABLE => p_in_y_enable_worker(i),
        P_IN_K_ENABLE => p_in_l_enable_worker(i),

        P_OUT_I_ENABLE => p_out_i_enable_worker(i),
        P_OUT_Y_ENABLE => p_out_y_enable_worker(i),
        P_OUT_K_ENABLE => p_out_k_enable_worker(i),

        Q_IN_Y_ENABLE => q_in_y_enable_worker(i),
        Q_IN_L_ENABLE => q_in_l_enable_worker(i),

        Q_OUT_Y_ENABLE => q_out_y_enable_worker(i),
        Q_OUT_L_ENABLE => q_out_l_enable_worker(i),

        Y_OUT_ENABLE => y_out_enable_worker(i),

        -- DATA
        SIZE_X_IN => size_x_in_worker(i),
        SIZE_Y_IN => size_y_in_worker(i),
        SIZE_N_IN => size_n_in_worker(i),
        SIZE_W_IN => size_w_in_worker(i),
        SIZE_L_IN => size_l_in_worker(i),
        SIZE_R_IN => size_r_in_worker(i),

        W_IN => w_in_worker(i),
        K_IN => k_in_worker(i),
        U_IN => u_in_worker(i),
        V_IN => v_in_worker(i),
        D_IN => d_in_worker(i),
        B_IN => b_in_worker(i),

        X_IN => x_in_worker(i),

        P_IN => p_in_worker(i),
        Q_IN => q_in_worker(i),

        Y_OUT => y_out_worker(i)
        );
  end generate dnc_top_worker;

end ntm_workers_architecture;
