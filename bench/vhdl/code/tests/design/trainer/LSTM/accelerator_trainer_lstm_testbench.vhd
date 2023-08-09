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
use work.accelerator_trainer_lstm_pkg.all;

entity accelerator_trainer_lstm_testbench is
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
end accelerator_trainer_lstm_testbench;

architecture accelerator_trainer_lstm_testbench_architecture of accelerator_trainer_lstm_testbench is

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
  signal size_t_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
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

  -- ACTIVATION TRAINER
  -- CONTROL
  signal start_activation_trainer : std_logic;
  signal ready_activation_trainer : std_logic;

  signal x_in_t_enable_activation_trainer : std_logic;
  signal x_in_x_enable_activation_trainer : std_logic;

  signal x_out_t_enable_activation_trainer : std_logic;
  signal x_out_x_enable_activation_trainer : std_logic;

  signal r_in_t_enable_activation_trainer : std_logic;
  signal r_in_i_enable_activation_trainer : std_logic;
  signal r_in_k_enable_activation_trainer : std_logic;

  signal r_out_t_enable_activation_trainer : std_logic;
  signal r_out_i_enable_activation_trainer : std_logic;
  signal r_out_k_enable_activation_trainer : std_logic;

  signal rho_in_t_enable_activation_trainer : std_logic;
  signal rho_in_i_enable_activation_trainer : std_logic;
  signal rho_in_m_enable_activation_trainer : std_logic;

  signal rho_out_t_enable_activation_trainer : std_logic;
  signal rho_out_i_enable_activation_trainer : std_logic;
  signal rho_out_m_enable_activation_trainer : std_logic;

  signal xi_in_t_enable_activation_trainer : std_logic;
  signal xi_in_s_enable_activation_trainer : std_logic;

  signal xi_out_t_enable_activation_trainer : std_logic;
  signal xi_out_s_enable_activation_trainer : std_logic;

  signal h_in_t_enable_activation_trainer : std_logic;
  signal h_in_l_enable_activation_trainer : std_logic;

  signal h_out_t_enable_activation_trainer : std_logic;
  signal h_out_l_enable_activation_trainer : std_logic;

  signal a_in_t_enable_activation_trainer : std_logic;
  signal a_in_l_enable_activation_trainer : std_logic;

  signal a_out_t_enable_activation_trainer : std_logic;
  signal a_out_l_enable_activation_trainer : std_logic;

  signal i_in_t_enable_activation_trainer : std_logic;
  signal i_in_l_enable_activation_trainer : std_logic;

  signal i_out_t_enable_activation_trainer : std_logic;
  signal i_out_l_enable_activation_trainer : std_logic;

  signal s_in_t_enable_activation_trainer : std_logic;
  signal s_in_l_enable_activation_trainer : std_logic;

  signal s_out_t_enable_activation_trainer : std_logic;
  signal s_out_l_enable_activation_trainer : std_logic;

  signal w_out_l_enable_activation_trainer : std_logic;
  signal w_out_x_enable_activation_trainer : std_logic;

  signal k_out_i_enable_activation_trainer : std_logic;
  signal k_out_l_enable_activation_trainer : std_logic;
  signal k_out_k_enable_activation_trainer : std_logic;

  signal d_out_i_enable_activation_trainer : std_logic;
  signal d_out_l_enable_activation_trainer : std_logic;
  signal d_out_m_enable_activation_trainer : std_logic;

  signal u_out_l_enable_activation_trainer : std_logic;
  signal u_out_p_enable_activation_trainer : std_logic;

  signal v_out_l_enable_activation_trainer : std_logic;
  signal v_out_s_enable_activation_trainer : std_logic;

  signal b_out_l_enable_activation_trainer : std_logic;

  -- DATA
  signal size_t_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_x_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_s_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_m_in_activation_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_activation_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_activation_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rho_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal xi_in_activation_trainer  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_activation_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal i_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_activation_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INPUT TRAINER
  -- CONTROL
  signal start_input_trainer : std_logic;
  signal ready_input_trainer : std_logic;

  signal x_in_t_enable_input_trainer : std_logic;
  signal x_in_x_enable_input_trainer : std_logic;

  signal x_out_t_enable_input_trainer : std_logic;
  signal x_out_x_enable_input_trainer : std_logic;

  signal r_in_t_enable_input_trainer : std_logic;
  signal r_in_i_enable_input_trainer : std_logic;
  signal r_in_k_enable_input_trainer : std_logic;

  signal r_out_t_enable_input_trainer : std_logic;
  signal r_out_i_enable_input_trainer : std_logic;
  signal r_out_k_enable_input_trainer : std_logic;

  signal rho_in_t_enable_input_trainer : std_logic;
  signal rho_in_i_enable_input_trainer : std_logic;
  signal rho_in_m_enable_input_trainer : std_logic;

  signal rho_out_t_enable_input_trainer : std_logic;
  signal rho_out_i_enable_input_trainer : std_logic;
  signal rho_out_m_enable_input_trainer : std_logic;

  signal xi_in_t_enable_input_trainer : std_logic;
  signal xi_in_s_enable_input_trainer : std_logic;

  signal xi_out_t_enable_input_trainer : std_logic;
  signal xi_out_s_enable_input_trainer : std_logic;

  signal h_in_t_enable_input_trainer : std_logic;
  signal h_in_l_enable_input_trainer : std_logic;

  signal h_out_t_enable_input_trainer : std_logic;
  signal h_out_l_enable_input_trainer : std_logic;

  signal a_in_t_enable_input_trainer : std_logic;
  signal a_in_l_enable_input_trainer : std_logic;

  signal a_out_t_enable_input_trainer : std_logic;
  signal a_out_l_enable_input_trainer : std_logic;

  signal i_in_t_enable_input_trainer : std_logic;
  signal i_in_l_enable_input_trainer : std_logic;

  signal i_out_t_enable_input_trainer : std_logic;
  signal i_out_l_enable_input_trainer : std_logic;

  signal s_in_t_enable_input_trainer : std_logic;
  signal s_in_l_enable_input_trainer : std_logic;

  signal s_out_t_enable_input_trainer : std_logic;
  signal s_out_l_enable_input_trainer : std_logic;

  signal w_out_l_enable_input_trainer : std_logic;
  signal w_out_x_enable_input_trainer : std_logic;

  signal k_out_i_enable_input_trainer : std_logic;
  signal k_out_l_enable_input_trainer : std_logic;
  signal k_out_k_enable_input_trainer : std_logic;

  signal d_out_i_enable_input_trainer : std_logic;
  signal d_out_l_enable_input_trainer : std_logic;
  signal d_out_m_enable_input_trainer : std_logic;

  signal u_out_l_enable_input_trainer : std_logic;
  signal u_out_p_enable_input_trainer : std_logic;

  signal v_out_l_enable_input_trainer : std_logic;
  signal v_out_s_enable_input_trainer : std_logic;

  signal b_out_l_enable_input_trainer : std_logic;

  -- DATA
  signal size_t_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_x_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_s_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_m_in_input_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_input_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_input_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rho_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal xi_in_input_trainer  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_input_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal i_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_input_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT TRAINER
  -- CONTROL
  signal start_output_trainer : std_logic;
  signal ready_output_trainer : std_logic;

  signal x_in_t_enable_output_trainer : std_logic;
  signal x_in_x_enable_output_trainer : std_logic;

  signal x_out_t_enable_output_trainer : std_logic;
  signal x_out_x_enable_output_trainer : std_logic;

  signal r_in_t_enable_output_trainer : std_logic;
  signal r_in_i_enable_output_trainer : std_logic;
  signal r_in_k_enable_output_trainer : std_logic;

  signal r_out_t_enable_output_trainer : std_logic;
  signal r_out_i_enable_output_trainer : std_logic;
  signal r_out_k_enable_output_trainer : std_logic;

  signal rho_in_t_enable_output_trainer : std_logic;
  signal rho_in_i_enable_output_trainer : std_logic;
  signal rho_in_m_enable_output_trainer : std_logic;

  signal rho_out_t_enable_output_trainer : std_logic;
  signal rho_out_i_enable_output_trainer : std_logic;
  signal rho_out_m_enable_output_trainer : std_logic;

  signal xi_in_t_enable_output_trainer : std_logic;
  signal xi_in_s_enable_output_trainer : std_logic;

  signal xi_out_t_enable_output_trainer : std_logic;
  signal xi_out_s_enable_output_trainer : std_logic;

  signal h_in_t_enable_output_trainer : std_logic;
  signal h_in_l_enable_output_trainer : std_logic;

  signal h_out_t_enable_output_trainer : std_logic;
  signal h_out_l_enable_output_trainer : std_logic;

  signal a_in_t_enable_output_trainer : std_logic;
  signal a_in_l_enable_output_trainer : std_logic;

  signal a_out_t_enable_output_trainer : std_logic;
  signal a_out_l_enable_output_trainer : std_logic;

  signal o_in_t_enable_output_trainer : std_logic;
  signal o_in_l_enable_output_trainer : std_logic;

  signal o_out_t_enable_output_trainer : std_logic;
  signal o_out_l_enable_output_trainer : std_logic;

  signal w_out_l_enable_output_trainer : std_logic;
  signal w_out_x_enable_output_trainer : std_logic;

  signal k_out_i_enable_output_trainer : std_logic;
  signal k_out_l_enable_output_trainer : std_logic;
  signal k_out_k_enable_output_trainer : std_logic;

  signal d_out_i_enable_output_trainer : std_logic;
  signal d_out_l_enable_output_trainer : std_logic;
  signal d_out_m_enable_output_trainer : std_logic;

  signal u_out_l_enable_output_trainer : std_logic;
  signal u_out_p_enable_output_trainer : std_logic;

  signal v_out_l_enable_output_trainer : std_logic;
  signal v_out_s_enable_output_trainer : std_logic;

  signal b_out_l_enable_output_trainer : std_logic;

  -- DATA
  signal size_t_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_x_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_s_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_m_in_output_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_output_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rho_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal xi_in_output_trainer  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_output_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal o_in_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_output_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FORGET TRAINER
  -- CONTROL
  signal start_forget_trainer : std_logic;
  signal ready_forget_trainer : std_logic;

  signal x_in_t_enable_forget_trainer : std_logic;
  signal x_in_x_enable_forget_trainer : std_logic;

  signal x_out_t_enable_forget_trainer : std_logic;
  signal x_out_x_enable_forget_trainer : std_logic;

  signal r_in_t_enable_forget_trainer : std_logic;
  signal r_in_i_enable_forget_trainer : std_logic;
  signal r_in_k_enable_forget_trainer : std_logic;

  signal r_out_t_enable_forget_trainer : std_logic;
  signal r_out_i_enable_forget_trainer : std_logic;
  signal r_out_k_enable_forget_trainer : std_logic;

  signal rho_in_t_enable_forget_trainer : std_logic;
  signal rho_in_i_enable_forget_trainer : std_logic;
  signal rho_in_m_enable_forget_trainer : std_logic;

  signal rho_out_t_enable_forget_trainer : std_logic;
  signal rho_out_i_enable_forget_trainer : std_logic;
  signal rho_out_m_enable_forget_trainer : std_logic;

  signal xi_in_t_enable_forget_trainer : std_logic;
  signal xi_in_s_enable_forget_trainer : std_logic;

  signal xi_out_t_enable_forget_trainer : std_logic;
  signal xi_out_s_enable_forget_trainer : std_logic;

  signal h_in_t_enable_forget_trainer : std_logic;
  signal h_in_l_enable_forget_trainer : std_logic;

  signal h_out_t_enable_forget_trainer : std_logic;
  signal h_out_l_enable_forget_trainer : std_logic;

  signal f_in_t_enable_forget_trainer : std_logic;
  signal f_in_l_enable_forget_trainer : std_logic;

  signal f_out_t_enable_forget_trainer : std_logic;
  signal f_out_l_enable_forget_trainer : std_logic;

  signal s_in_t_enable_forget_trainer : std_logic;
  signal s_in_l_enable_forget_trainer : std_logic;

  signal s_out_t_enable_forget_trainer : std_logic;
  signal s_out_l_enable_forget_trainer : std_logic;

  signal w_out_l_enable_forget_trainer : std_logic;
  signal w_out_x_enable_forget_trainer : std_logic;

  signal k_out_i_enable_forget_trainer : std_logic;
  signal k_out_l_enable_forget_trainer : std_logic;
  signal k_out_k_enable_forget_trainer : std_logic;

  signal d_out_i_enable_forget_trainer : std_logic;
  signal d_out_l_enable_forget_trainer : std_logic;
  signal d_out_m_enable_forget_trainer : std_logic;

  signal u_out_l_enable_forget_trainer : std_logic;
  signal u_out_p_enable_forget_trainer : std_logic;

  signal v_out_l_enable_forget_trainer : std_logic;
  signal v_out_s_enable_forget_trainer : std_logic;

  signal b_out_l_enable_forget_trainer : std_logic;

  -- DATA
  signal size_t_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_x_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_s_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_m_in_forget_trainer : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal x_in_forget_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_forget_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rho_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal xi_in_forget_trainer  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_forget_trainer   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_forget_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  accelerator_trainer_lstm_stimulus_i : accelerator_trainer_lstm_stimulus
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
      ACCELERATOR_TRAINER_LSTM_START => start_controller,
      ACCELERATOR_TRAINER_LSTM_READY => ready_controller,

      ACCELERATOR_TRAINER_LSTM_W_IN_L_ENABLE => w_in_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_W_IN_X_ENABLE => w_in_x_enable_controller,

      ACCELERATOR_TRAINER_LSTM_W_OUT_L_ENABLE => w_out_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_W_OUT_X_ENABLE => w_out_x_enable_controller,

      ACCELERATOR_TRAINER_LSTM_K_IN_I_ENABLE => k_in_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_K_IN_L_ENABLE => k_in_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_K_IN_K_ENABLE => k_in_k_enable_controller,

      ACCELERATOR_TRAINER_LSTM_K_OUT_I_ENABLE => k_out_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_K_OUT_L_ENABLE => k_out_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_K_OUT_K_ENABLE => k_out_k_enable_controller,

      ACCELERATOR_TRAINER_LSTM_D_IN_I_ENABLE => d_in_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_D_IN_L_ENABLE => d_in_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_D_IN_M_ENABLE => d_in_m_enable_controller,

      ACCELERATOR_TRAINER_LSTM_D_OUT_I_ENABLE => d_out_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_D_OUT_L_ENABLE => d_out_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_D_OUT_M_ENABLE => d_out_m_enable_controller,

      ACCELERATOR_TRAINER_LSTM_U_IN_L_ENABLE => u_in_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_U_IN_P_ENABLE => u_in_p_enable_controller,

      ACCELERATOR_TRAINER_LSTM_U_OUT_L_ENABLE => u_out_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_U_OUT_P_ENABLE => u_out_p_enable_controller,

      ACCELERATOR_TRAINER_LSTM_V_IN_L_ENABLE => v_in_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_V_IN_S_ENABLE => v_in_s_enable_controller,

      ACCELERATOR_TRAINER_LSTM_V_OUT_L_ENABLE => v_out_l_enable_controller,
      ACCELERATOR_TRAINER_LSTM_V_OUT_S_ENABLE => v_out_s_enable_controller,

      ACCELERATOR_TRAINER_LSTM_B_IN_ENABLE => b_in_enable_controller,

      ACCELERATOR_TRAINER_LSTM_B_OUT_ENABLE => b_out_enable_controller,

      ACCELERATOR_TRAINER_LSTM_X_IN_ENABLE => x_in_enable_controller,

      ACCELERATOR_TRAINER_LSTM_X_OUT_ENABLE => x_out_enable_controller,

      ACCELERATOR_TRAINER_LSTM_R_IN_I_ENABLE => r_in_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_R_IN_K_ENABLE => r_in_k_enable_controller,

      ACCELERATOR_TRAINER_LSTM_R_OUT_I_ENABLE => r_out_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_R_OUT_K_ENABLE => r_out_k_enable_controller,

      ACCELERATOR_TRAINER_LSTM_RHO_IN_I_ENABLE => rho_in_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_RHO_IN_M_ENABLE => rho_in_m_enable_controller,

      ACCELERATOR_TRAINER_LSTM_RHO_OUT_I_ENABLE => rho_out_i_enable_controller,
      ACCELERATOR_TRAINER_LSTM_RHO_OUT_M_ENABLE => rho_out_m_enable_controller,

      ACCELERATOR_TRAINER_LSTM_XI_IN_ENABLE => xi_in_enable_controller,

      ACCELERATOR_TRAINER_LSTM_XI_OUT_ENABLE => xi_out_enable_controller,

      ACCELERATOR_TRAINER_LSTM_H_IN_ENABLE => h_in_enable_controller,

      ACCELERATOR_TRAINER_LSTM_H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      ACCELERATOR_TRAINER_LSTM_SIZE_X_IN => size_x_in_controller,
      ACCELERATOR_TRAINER_LSTM_SIZE_W_IN => size_w_in_controller,
      ACCELERATOR_TRAINER_LSTM_SIZE_L_IN => size_l_in_controller,
      ACCELERATOR_TRAINER_LSTM_SIZE_R_IN => size_r_in_controller,
      ACCELERATOR_TRAINER_LSTM_SIZE_S_IN => size_s_in_controller,
      ACCELERATOR_TRAINER_LSTM_SIZE_M_IN => size_m_in_controller,

      ACCELERATOR_TRAINER_LSTM_W_IN => w_in_controller,
      ACCELERATOR_TRAINER_LSTM_D_IN => d_in_controller,
      ACCELERATOR_TRAINER_LSTM_K_IN => k_in_controller,
      ACCELERATOR_TRAINER_LSTM_U_IN => u_in_controller,
      ACCELERATOR_TRAINER_LSTM_V_IN => v_in_controller,
      ACCELERATOR_TRAINER_LSTM_B_IN => b_in_controller,

      ACCELERATOR_TRAINER_LSTM_X_IN   => x_in_controller,
      ACCELERATOR_TRAINER_LSTM_R_IN   => r_in_controller,
      ACCELERATOR_TRAINER_LSTM_RHO_IN => rho_in_controller,
      ACCELERATOR_TRAINER_LSTM_XI_IN  => xi_in_controller,
      ACCELERATOR_TRAINER_LSTM_H_IN   => h_in_controller,

      ACCELERATOR_TRAINER_LSTM_H_OUT => h_out_controller
      );

  -- CONTROLLER
  controller : accelerator_controller
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

  -- ACTIVATION TRAINER
  activation_trainer : accelerator_activation_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_activation_trainer,
      READY => ready_activation_trainer,

      X_IN_T_ENABLE => x_in_t_enable_activation_trainer,
      X_IN_X_ENABLE => x_in_x_enable_activation_trainer,

      X_OUT_T_ENABLE => x_out_t_enable_activation_trainer,
      X_OUT_X_ENABLE => x_out_x_enable_activation_trainer,

      R_IN_T_ENABLE => r_in_t_enable_activation_trainer,
      R_IN_I_ENABLE => r_in_i_enable_activation_trainer,
      R_IN_K_ENABLE => r_in_k_enable_activation_trainer,

      R_OUT_T_ENABLE => r_out_t_enable_activation_trainer,
      R_OUT_I_ENABLE => r_out_i_enable_activation_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_activation_trainer,

      RHO_IN_T_ENABLE => rho_in_t_enable_activation_trainer,
      RHO_IN_I_ENABLE => rho_in_i_enable_activation_trainer,
      RHO_IN_M_ENABLE => rho_in_m_enable_activation_trainer,

      RHO_OUT_T_ENABLE => rho_out_t_enable_activation_trainer,
      RHO_OUT_I_ENABLE => rho_out_i_enable_activation_trainer,
      RHO_OUT_M_ENABLE => rho_out_m_enable_activation_trainer,

      XI_IN_T_ENABLE => xi_in_t_enable_activation_trainer,
      XI_IN_S_ENABLE => xi_in_s_enable_activation_trainer,

      XI_OUT_T_ENABLE => xi_out_t_enable_activation_trainer,
      XI_OUT_S_ENABLE => xi_out_s_enable_activation_trainer,

      H_IN_T_ENABLE => h_in_t_enable_activation_trainer,
      H_IN_L_ENABLE => h_in_l_enable_activation_trainer,

      H_OUT_T_ENABLE => h_out_t_enable_activation_trainer,
      H_OUT_L_ENABLE => h_out_l_enable_activation_trainer,

      A_IN_T_ENABLE => a_in_t_enable_activation_trainer,
      A_IN_L_ENABLE => a_in_l_enable_activation_trainer,

      A_OUT_T_ENABLE => a_out_t_enable_activation_trainer,
      A_OUT_L_ENABLE => a_out_l_enable_activation_trainer,

      I_IN_T_ENABLE => i_in_t_enable_activation_trainer,
      I_IN_L_ENABLE => i_in_l_enable_activation_trainer,

      I_OUT_T_ENABLE => i_out_t_enable_activation_trainer,
      I_OUT_L_ENABLE => i_out_l_enable_activation_trainer,

      S_IN_T_ENABLE => s_in_t_enable_activation_trainer,
      S_IN_L_ENABLE => s_in_l_enable_activation_trainer,

      S_OUT_T_ENABLE => s_out_t_enable_activation_trainer,
      S_OUT_L_ENABLE => s_out_l_enable_activation_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_activation_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_activation_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_activation_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_activation_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_activation_trainer,

      D_OUT_I_ENABLE => d_out_i_enable_activation_trainer,
      D_OUT_L_ENABLE => d_out_l_enable_activation_trainer,
      D_OUT_M_ENABLE => d_out_m_enable_activation_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_activation_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_activation_trainer,

      V_OUT_L_ENABLE => v_out_l_enable_activation_trainer,
      V_OUT_S_ENABLE => v_out_s_enable_activation_trainer,

      B_OUT_L_ENABLE => b_out_l_enable_activation_trainer,

      -- DATA
      SIZE_T_IN => size_t_in_activation_trainer,
      SIZE_X_IN => size_x_in_activation_trainer,
      SIZE_W_IN => size_w_in_activation_trainer,
      SIZE_L_IN => size_l_in_activation_trainer,
      SIZE_R_IN => size_r_in_activation_trainer,
      SIZE_S_IN => size_s_in_activation_trainer,
      SIZE_M_IN => size_m_in_activation_trainer,

      X_IN   => x_in_activation_trainer,
      R_IN   => r_in_activation_trainer,
      RHO_IN => rho_in_activation_trainer,
      XI_IN  => xi_in_activation_trainer,
      H_IN   => h_in_activation_trainer,

      A_IN => a_in_activation_trainer,
      I_IN => i_in_activation_trainer,
      S_IN => s_in_activation_trainer,

      W_OUT => w_out_activation_trainer,
      D_OUT => d_out_activation_trainer,
      K_OUT => k_out_activation_trainer,
      U_OUT => u_out_activation_trainer,
      V_OUT => v_out_activation_trainer,
      B_OUT => b_out_activation_trainer
      );

  -- INPUT TRAINER
  input_trainer : accelerator_input_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_input_trainer,
      READY => ready_input_trainer,

      X_IN_T_ENABLE => x_in_t_enable_input_trainer,
      X_IN_X_ENABLE => x_in_x_enable_input_trainer,

      X_OUT_T_ENABLE => x_out_t_enable_input_trainer,
      X_OUT_X_ENABLE => x_out_x_enable_input_trainer,

      R_IN_T_ENABLE => r_in_t_enable_input_trainer,
      R_IN_I_ENABLE => r_in_i_enable_input_trainer,
      R_IN_K_ENABLE => r_in_k_enable_input_trainer,

      R_OUT_T_ENABLE => r_out_t_enable_input_trainer,
      R_OUT_I_ENABLE => r_out_i_enable_input_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_input_trainer,

      RHO_IN_T_ENABLE => rho_in_t_enable_input_trainer,
      RHO_IN_I_ENABLE => rho_in_i_enable_input_trainer,
      RHO_IN_M_ENABLE => rho_in_m_enable_input_trainer,

      RHO_OUT_T_ENABLE => rho_out_t_enable_input_trainer,
      RHO_OUT_I_ENABLE => rho_out_i_enable_input_trainer,
      RHO_OUT_M_ENABLE => rho_out_m_enable_input_trainer,

      XI_IN_T_ENABLE => xi_in_t_enable_input_trainer,
      XI_IN_S_ENABLE => xi_in_s_enable_input_trainer,

      XI_OUT_T_ENABLE => xi_out_t_enable_input_trainer,
      XI_OUT_S_ENABLE => xi_out_s_enable_input_trainer,

      H_IN_T_ENABLE => h_in_t_enable_input_trainer,
      H_IN_L_ENABLE => h_in_l_enable_input_trainer,

      H_OUT_T_ENABLE => h_out_t_enable_input_trainer,
      H_OUT_L_ENABLE => h_out_l_enable_input_trainer,

      A_IN_T_ENABLE => a_in_t_enable_input_trainer,
      A_IN_L_ENABLE => a_in_l_enable_input_trainer,

      A_OUT_T_ENABLE => a_out_t_enable_input_trainer,
      A_OUT_L_ENABLE => a_out_l_enable_input_trainer,

      I_IN_T_ENABLE => i_in_t_enable_input_trainer,
      I_IN_L_ENABLE => i_in_l_enable_input_trainer,

      I_OUT_T_ENABLE => i_out_t_enable_input_trainer,
      I_OUT_L_ENABLE => i_out_l_enable_input_trainer,

      S_IN_T_ENABLE => s_in_t_enable_input_trainer,
      S_IN_L_ENABLE => s_in_l_enable_input_trainer,

      S_OUT_T_ENABLE => s_out_t_enable_input_trainer,
      S_OUT_L_ENABLE => s_out_l_enable_input_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_input_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_input_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_input_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_input_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_input_trainer,

      D_OUT_I_ENABLE => d_out_i_enable_input_trainer,
      D_OUT_L_ENABLE => d_out_l_enable_input_trainer,
      D_OUT_M_ENABLE => d_out_m_enable_input_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_input_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_input_trainer,

      V_OUT_L_ENABLE => v_out_l_enable_input_trainer,
      V_OUT_S_ENABLE => v_out_s_enable_input_trainer,

      B_OUT_L_ENABLE => b_out_l_enable_input_trainer,

      -- DATA
      SIZE_T_IN => size_t_in_input_trainer,
      SIZE_X_IN => size_x_in_input_trainer,
      SIZE_W_IN => size_w_in_input_trainer,
      SIZE_L_IN => size_l_in_input_trainer,
      SIZE_R_IN => size_r_in_input_trainer,
      SIZE_S_IN => size_s_in_input_trainer,
      SIZE_M_IN => size_m_in_input_trainer,

      X_IN   => x_in_input_trainer,
      R_IN   => r_in_input_trainer,
      RHO_IN => rho_in_input_trainer,
      XI_IN  => xi_in_input_trainer,
      H_IN   => h_in_input_trainer,

      A_IN => a_in_input_trainer,
      I_IN => i_in_input_trainer,
      S_IN => s_in_input_trainer,

      W_OUT => w_out_input_trainer,
      D_OUT => d_out_input_trainer,
      K_OUT => k_out_input_trainer,
      U_OUT => u_out_input_trainer,
      V_OUT => v_out_input_trainer,
      B_OUT => b_out_input_trainer
      );

  -- OUTPUT TRAINER
  output_trainer : accelerator_output_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_trainer,
      READY => ready_output_trainer,

      X_IN_T_ENABLE => x_in_t_enable_output_trainer,
      X_IN_X_ENABLE => x_in_x_enable_output_trainer,

      X_OUT_T_ENABLE => x_out_t_enable_output_trainer,
      X_OUT_X_ENABLE => x_out_x_enable_output_trainer,

      R_IN_T_ENABLE => r_in_t_enable_output_trainer,
      R_IN_I_ENABLE => r_in_i_enable_output_trainer,
      R_IN_K_ENABLE => r_in_k_enable_output_trainer,

      R_OUT_T_ENABLE => r_out_t_enable_output_trainer,
      R_OUT_I_ENABLE => r_out_i_enable_output_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_output_trainer,

      RHO_IN_T_ENABLE => rho_in_t_enable_output_trainer,
      RHO_IN_I_ENABLE => rho_in_i_enable_output_trainer,
      RHO_IN_M_ENABLE => rho_in_m_enable_output_trainer,

      RHO_OUT_T_ENABLE => rho_out_t_enable_output_trainer,
      RHO_OUT_I_ENABLE => rho_out_i_enable_output_trainer,
      RHO_OUT_M_ENABLE => rho_out_m_enable_output_trainer,

      XI_IN_T_ENABLE => xi_in_t_enable_output_trainer,
      XI_IN_S_ENABLE => xi_in_s_enable_output_trainer,

      XI_OUT_T_ENABLE => xi_out_t_enable_output_trainer,
      XI_OUT_S_ENABLE => xi_out_s_enable_output_trainer,

      H_IN_T_ENABLE => h_in_t_enable_output_trainer,
      H_IN_L_ENABLE => h_in_l_enable_output_trainer,

      H_OUT_T_ENABLE => h_out_t_enable_output_trainer,
      H_OUT_L_ENABLE => h_out_l_enable_output_trainer,

      A_IN_T_ENABLE => a_in_t_enable_output_trainer,
      A_IN_L_ENABLE => a_in_l_enable_output_trainer,

      A_OUT_T_ENABLE => a_out_t_enable_output_trainer,
      A_OUT_L_ENABLE => a_out_l_enable_output_trainer,

      O_IN_T_ENABLE => o_in_t_enable_output_trainer,
      O_IN_L_ENABLE => o_in_l_enable_output_trainer,

      O_OUT_T_ENABLE => o_out_t_enable_output_trainer,
      O_OUT_L_ENABLE => o_out_l_enable_output_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_output_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_output_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_output_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_output_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_output_trainer,

      D_OUT_I_ENABLE => d_out_i_enable_output_trainer,
      D_OUT_L_ENABLE => d_out_l_enable_output_trainer,
      D_OUT_M_ENABLE => d_out_m_enable_output_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_output_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_output_trainer,

      V_OUT_L_ENABLE => v_out_l_enable_output_trainer,
      V_OUT_S_ENABLE => v_out_s_enable_output_trainer,

      B_OUT_L_ENABLE => b_out_l_enable_output_trainer,

      -- DATA
      SIZE_T_IN => size_t_in_output_trainer,
      SIZE_X_IN => size_x_in_output_trainer,
      SIZE_W_IN => size_w_in_output_trainer,
      SIZE_L_IN => size_l_in_output_trainer,
      SIZE_R_IN => size_r_in_output_trainer,
      SIZE_S_IN => size_s_in_output_trainer,
      SIZE_M_IN => size_m_in_output_trainer,

      X_IN   => x_in_output_trainer,
      R_IN   => r_in_output_trainer,
      RHO_IN => rho_in_output_trainer,
      XI_IN  => xi_in_output_trainer,
      H_IN   => h_in_output_trainer,

      A_IN => a_in_output_trainer,
      O_IN => o_in_output_trainer,

      W_OUT => w_out_output_trainer,
      D_OUT => d_out_output_trainer,
      K_OUT => k_out_output_trainer,
      U_OUT => u_out_output_trainer,
      V_OUT => v_out_output_trainer,
      B_OUT => b_out_output_trainer
      );

  -- -- FORGET TRAINER
  forget_trainer : accelerator_forget_trainer
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_forget_trainer,
      READY => ready_forget_trainer,

      X_IN_T_ENABLE => x_in_t_enable_forget_trainer,
      X_IN_X_ENABLE => x_in_x_enable_forget_trainer,

      X_OUT_T_ENABLE => x_out_t_enable_forget_trainer,
      X_OUT_X_ENABLE => x_out_x_enable_forget_trainer,

      R_IN_T_ENABLE => r_in_t_enable_forget_trainer,
      R_IN_I_ENABLE => r_in_i_enable_forget_trainer,
      R_IN_K_ENABLE => r_in_k_enable_forget_trainer,

      R_OUT_T_ENABLE => r_out_t_enable_forget_trainer,
      R_OUT_I_ENABLE => r_out_i_enable_forget_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_forget_trainer,

      RHO_IN_T_ENABLE => rho_in_t_enable_forget_trainer,
      RHO_IN_I_ENABLE => rho_in_i_enable_forget_trainer,
      RHO_IN_M_ENABLE => rho_in_m_enable_forget_trainer,

      RHO_OUT_T_ENABLE => rho_out_t_enable_forget_trainer,
      RHO_OUT_I_ENABLE => rho_out_i_enable_forget_trainer,
      RHO_OUT_M_ENABLE => rho_out_m_enable_forget_trainer,

      XI_IN_T_ENABLE => xi_in_t_enable_forget_trainer,
      XI_IN_S_ENABLE => xi_in_s_enable_forget_trainer,

      XI_OUT_T_ENABLE => xi_out_t_enable_forget_trainer,
      XI_OUT_S_ENABLE => xi_out_s_enable_forget_trainer,

      H_IN_T_ENABLE => h_in_t_enable_forget_trainer,
      H_IN_L_ENABLE => h_in_l_enable_forget_trainer,

      H_OUT_T_ENABLE => h_out_t_enable_forget_trainer,
      H_OUT_L_ENABLE => h_out_l_enable_forget_trainer,

      F_IN_T_ENABLE => f_in_t_enable_forget_trainer,
      F_IN_L_ENABLE => f_in_l_enable_forget_trainer,

      F_OUT_T_ENABLE => f_out_t_enable_forget_trainer,
      F_OUT_L_ENABLE => f_out_l_enable_forget_trainer,

      S_IN_T_ENABLE => s_in_t_enable_forget_trainer,
      S_IN_L_ENABLE => s_in_l_enable_forget_trainer,

      S_OUT_T_ENABLE => s_out_t_enable_forget_trainer,
      S_OUT_L_ENABLE => s_out_l_enable_forget_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_forget_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_forget_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_forget_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_forget_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_forget_trainer,

      D_OUT_I_ENABLE => d_out_i_enable_forget_trainer,
      D_OUT_L_ENABLE => d_out_l_enable_forget_trainer,
      D_OUT_M_ENABLE => d_out_m_enable_forget_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_forget_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_forget_trainer,

      V_OUT_L_ENABLE => v_out_l_enable_forget_trainer,
      V_OUT_S_ENABLE => v_out_s_enable_forget_trainer,

      B_OUT_L_ENABLE => b_out_l_enable_forget_trainer,

      -- DATA
      SIZE_T_IN => size_t_in_forget_trainer,
      SIZE_X_IN => size_x_in_forget_trainer,
      SIZE_W_IN => size_w_in_forget_trainer,
      SIZE_L_IN => size_l_in_forget_trainer,
      SIZE_R_IN => size_r_in_forget_trainer,
      SIZE_S_IN => size_s_in_forget_trainer,
      SIZE_M_IN => size_m_in_forget_trainer,

      X_IN   => x_in_forget_trainer,
      R_IN   => r_in_forget_trainer,
      RHO_IN => rho_in_forget_trainer,
      XI_IN  => xi_in_forget_trainer,
      H_IN   => h_in_forget_trainer,

      F_IN => f_in_forget_trainer,
      S_IN => s_in_forget_trainer,

      W_OUT => w_out_forget_trainer,
      D_OUT => d_out_forget_trainer,
      K_OUT => k_out_forget_trainer,
      U_OUT => u_out_forget_trainer,
      V_OUT => v_out_forget_trainer,
      B_OUT => b_out_forget_trainer
      );

end accelerator_trainer_lstm_testbench_architecture;
