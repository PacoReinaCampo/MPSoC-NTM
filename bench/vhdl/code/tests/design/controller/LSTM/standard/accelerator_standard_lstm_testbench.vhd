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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;
use work.accelerator_lstm_controller_pkg.all;
use work.accelerator_standard_lstm_pkg.all;

entity accelerator_standard_lstm_testbench is
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
end accelerator_standard_lstm_testbench;

architecture accelerator_standard_lstm_testbench_architecture of accelerator_standard_lstm_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  signal w_in_l_enable_controller : std_logic;
  signal w_in_x_enable_controller : std_logic;

  signal w_out_l_enable_controller : std_logic;
  signal w_out_x_enable_controller : std_logic;

  signal k_in_i_enable_controller : std_logic;
  signal k_in_l_enable_controller : std_logic;
  signal k_in_k_enable_controller : std_logic;

  signal k_out_i_enable_controller : std_logic;
  signal k_out_l_enable_controller : std_logic;
  signal k_out_k_enable_controller : std_logic;

  signal d_in_i_enable_controller : std_logic;
  signal d_in_l_enable_controller : std_logic;
  signal d_in_m_enable_controller : std_logic;

  signal d_out_i_enable_controller : std_logic;
  signal d_out_l_enable_controller : std_logic;
  signal d_out_m_enable_controller : std_logic;

  signal u_in_l_enable_controller : std_logic;
  signal u_in_p_enable_controller : std_logic;

  signal u_out_l_enable_controller : std_logic;
  signal u_out_p_enable_controller : std_logic;

  signal v_in_l_enable_controller : std_logic;
  signal v_in_s_enable_controller : std_logic;

  signal v_out_l_enable_controller : std_logic;
  signal v_out_s_enable_controller : std_logic;

  signal b_in_enable_controller : std_logic;

  signal b_out_enable_controller : std_logic;

  signal x_in_enable_controller : std_logic;

  signal x_out_enable_controller : std_logic;

  signal r_in_i_enable_controller : std_logic;
  signal r_in_k_enable_controller : std_logic;

  signal r_out_i_enable_controller : std_logic;
  signal r_out_k_enable_controller : std_logic;

  signal rho_in_i_enable_controller : std_logic;
  signal rho_in_m_enable_controller : std_logic;

  signal rho_out_i_enable_controller : std_logic;
  signal rho_out_m_enable_controller : std_logic;

  signal xi_in_enable_controller : std_logic;

  signal xi_out_enable_controller : std_logic;

  signal h_in_enable_controller : std_logic;

  signal h_out_enable_controller : std_logic;

  -- DATA
  signal size_x_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_s_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_m_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_controller   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_controller   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rho_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal xi_in_controller  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_controller   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  accelerator_standard_lstm_stimulus_i : accelerator_standard_lstm_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      STANDARD_LSTM_START => start_controller,
      STANDARD_LSTM_READY => ready_controller,

      STANDARD_LSTM_W_IN_L_ENABLE => w_in_l_enable_controller,
      STANDARD_LSTM_W_IN_X_ENABLE => w_in_x_enable_controller,

      STANDARD_LSTM_W_OUT_L_ENABLE => w_out_l_enable_controller,
      STANDARD_LSTM_W_OUT_X_ENABLE => w_out_x_enable_controller,

      STANDARD_LSTM_K_IN_I_ENABLE => k_in_i_enable_controller,
      STANDARD_LSTM_K_IN_L_ENABLE => k_in_l_enable_controller,
      STANDARD_LSTM_K_IN_K_ENABLE => k_in_k_enable_controller,

      STANDARD_LSTM_K_OUT_I_ENABLE => k_out_i_enable_controller,
      STANDARD_LSTM_K_OUT_L_ENABLE => k_out_l_enable_controller,
      STANDARD_LSTM_K_OUT_K_ENABLE => k_out_k_enable_controller,

      STANDARD_LSTM_D_IN_I_ENABLE => d_in_i_enable_controller,
      STANDARD_LSTM_D_IN_L_ENABLE => d_in_l_enable_controller,
      STANDARD_LSTM_D_IN_M_ENABLE => d_in_m_enable_controller,

      STANDARD_LSTM_D_OUT_I_ENABLE => d_out_i_enable_controller,
      STANDARD_LSTM_D_OUT_L_ENABLE => d_out_l_enable_controller,
      STANDARD_LSTM_D_OUT_M_ENABLE => d_out_m_enable_controller,

      STANDARD_LSTM_U_IN_L_ENABLE => u_in_l_enable_controller,
      STANDARD_LSTM_U_IN_P_ENABLE => u_in_p_enable_controller,

      STANDARD_LSTM_U_OUT_L_ENABLE => u_out_l_enable_controller,
      STANDARD_LSTM_U_OUT_P_ENABLE => u_out_p_enable_controller,

      STANDARD_LSTM_V_IN_L_ENABLE => v_in_l_enable_controller,
      STANDARD_LSTM_V_IN_S_ENABLE => v_in_s_enable_controller,

      STANDARD_LSTM_V_OUT_L_ENABLE => v_out_l_enable_controller,
      STANDARD_LSTM_V_OUT_S_ENABLE => v_out_s_enable_controller,

      STANDARD_LSTM_B_IN_ENABLE => b_in_enable_controller,

      STANDARD_LSTM_B_OUT_ENABLE => b_out_enable_controller,

      STANDARD_LSTM_X_IN_ENABLE => x_in_enable_controller,

      STANDARD_LSTM_X_OUT_ENABLE => x_out_enable_controller,

      STANDARD_LSTM_R_IN_I_ENABLE => r_in_i_enable_controller,
      STANDARD_LSTM_R_IN_K_ENABLE => r_in_k_enable_controller,

      STANDARD_LSTM_R_OUT_I_ENABLE => r_out_i_enable_controller,
      STANDARD_LSTM_R_OUT_K_ENABLE => r_out_k_enable_controller,

      STANDARD_LSTM_RHO_IN_I_ENABLE => rho_in_i_enable_controller,
      STANDARD_LSTM_RHO_IN_M_ENABLE => rho_in_m_enable_controller,

      STANDARD_LSTM_RHO_OUT_I_ENABLE => rho_out_i_enable_controller,
      STANDARD_LSTM_RHO_OUT_M_ENABLE => rho_out_m_enable_controller,

      STANDARD_LSTM_XI_IN_ENABLE => xi_in_enable_controller,

      STANDARD_LSTM_XI_OUT_ENABLE => xi_out_enable_controller,

      STANDARD_LSTM_H_IN_ENABLE => h_in_enable_controller,

      STANDARD_LSTM_H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      STANDARD_LSTM_SIZE_X_IN => size_x_in_controller,
      STANDARD_LSTM_SIZE_W_IN => size_w_in_controller,
      STANDARD_LSTM_SIZE_L_IN => size_l_in_controller,
      STANDARD_LSTM_SIZE_R_IN => size_r_in_controller,
      STANDARD_LSTM_SIZE_S_IN => size_s_in_controller,
      STANDARD_LSTM_SIZE_M_IN => size_m_in_controller,

      STANDARD_LSTM_W_IN => w_in_controller,
      STANDARD_LSTM_D_IN => d_in_controller,
      STANDARD_LSTM_K_IN => k_in_controller,
      STANDARD_LSTM_U_IN => u_in_controller,
      STANDARD_LSTM_V_IN => v_in_controller,
      STANDARD_LSTM_B_IN => b_in_controller,

      STANDARD_LSTM_X_IN   => x_in_controller,
      STANDARD_LSTM_R_IN   => r_in_controller,
      STANDARD_LSTM_RHO_IN => rho_in_controller,
      STANDARD_LSTM_XI_IN  => xi_in_controller,
      STANDARD_LSTM_H_IN   => h_in_controller,

      STANDARD_LSTM_H_OUT => h_out_controller
      );

  -- CONTROLLER
  accelerator_controller_i : accelerator_controller
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      W_IN_L_ENABLE => w_in_l_enable_controller,
      W_IN_X_ENABLE => w_in_x_enable_controller,

      W_OUT_L_ENABLE => w_out_l_enable_controller,
      W_OUT_X_ENABLE => w_out_x_enable_controller,

      K_IN_I_ENABLE => k_in_i_enable_controller,
      K_IN_L_ENABLE => k_in_l_enable_controller,
      K_IN_K_ENABLE => k_in_k_enable_controller,

      K_OUT_I_ENABLE => k_out_i_enable_controller,
      K_OUT_L_ENABLE => k_out_l_enable_controller,
      K_OUT_K_ENABLE => k_out_k_enable_controller,

      D_IN_I_ENABLE => d_in_i_enable_controller,
      D_IN_L_ENABLE => d_in_l_enable_controller,
      D_IN_M_ENABLE => d_in_m_enable_controller,

      D_OUT_I_ENABLE => d_out_i_enable_controller,
      D_OUT_L_ENABLE => d_out_l_enable_controller,
      D_OUT_M_ENABLE => d_out_m_enable_controller,

      U_IN_L_ENABLE => u_in_l_enable_controller,
      U_IN_P_ENABLE => u_in_p_enable_controller,

      U_OUT_L_ENABLE => u_out_l_enable_controller,
      U_OUT_P_ENABLE => u_out_p_enable_controller,

      V_IN_L_ENABLE => v_in_l_enable_controller,
      V_IN_S_ENABLE => v_in_s_enable_controller,

      V_OUT_L_ENABLE => v_out_l_enable_controller,
      V_OUT_S_ENABLE => v_out_s_enable_controller,

      B_IN_ENABLE => b_in_enable_controller,

      B_OUT_ENABLE => b_out_enable_controller,

      X_IN_ENABLE => x_in_enable_controller,

      X_OUT_ENABLE => x_out_enable_controller,

      R_IN_I_ENABLE => r_in_i_enable_controller,
      R_IN_K_ENABLE => r_in_k_enable_controller,

      R_OUT_I_ENABLE => r_out_i_enable_controller,
      R_OUT_K_ENABLE => r_out_k_enable_controller,

      RHO_IN_I_ENABLE => rho_in_i_enable_controller,
      RHO_IN_M_ENABLE => rho_in_m_enable_controller,

      RHO_OUT_I_ENABLE => rho_out_i_enable_controller,
      RHO_OUT_M_ENABLE => rho_out_m_enable_controller,

      XI_IN_ENABLE => xi_in_enable_controller,

      XI_OUT_ENABLE => xi_out_enable_controller,

      H_IN_ENABLE => h_in_enable_controller,

      H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      SIZE_X_IN => size_x_in_controller,
      SIZE_W_IN => size_w_in_controller,
      SIZE_L_IN => size_l_in_controller,
      SIZE_R_IN => size_r_in_controller,
      SIZE_S_IN => size_s_in_controller,
      SIZE_M_IN => size_m_in_controller,

      W_IN => w_in_controller,
      D_IN => d_in_controller,
      K_IN => k_in_controller,
      U_IN => u_in_controller,
      V_IN => v_in_controller,
      B_IN => b_in_controller,

      X_IN   => x_in_controller,
      R_IN   => r_in_controller,
      RHO_IN => rho_in_controller,
      XI_IN  => xi_in_controller,
      H_IN   => h_in_controller,

      H_OUT => h_out_controller
      );

end accelerator_standard_lstm_testbench_architecture;
