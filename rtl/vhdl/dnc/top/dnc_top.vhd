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

use work.ntm_arithmetic_pkg.all;
use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity dnc_top is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    W_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    W_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    V_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    V_IN_S_ENABLE : in std_logic;       -- for s in 0 to S-1

    V_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    V_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1

    D_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    D_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    D_IN_M_ENABLE : in std_logic;       -- for m in 0 to M-1

    D_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    D_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    D_OUT_M_ENABLE : out std_logic;     -- for m in 0 to M-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    P_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    P_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    P_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    P_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    P_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    P_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    Q_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    Q_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    Q_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    Q_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_top_architecture of dnc_top is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X], X_IN [X]
  -- K_IN [R,L,W]
  -- D_IN [R,L,M]
  -- V_IN [L,S]
  -- U_IN [L,L]
  -- B_IN [L]

  -- P_IN [R,Y,W]
  -- Q_IN [Y,L]

  -- Outputs:
  -- Y_OUT [Y]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_Y_STATE, CLEAN_IN_Y_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE
  -- INPUT_X_STATE, CLEAN_IN_X_STATE

  -- OUTPUT_Y_STATE, CLEAN_OUT_Y_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_L_STATE,                 -- STEP 1
    INPUT_W_IN_X_STATE,                 -- STEP 2
    CLEAN_W_IN_L_STATE,                 -- STEP 3
    CLEAN_W_IN_X_STATE                  -- STEP 4
    );

  type controller_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_L_STATE,                 -- STEP 2
    INPUT_K_IN_K_STATE,                 -- STEP 3
    CLEAN_K_IN_I_STATE,                 -- STEP 4
    CLEAN_K_IN_L_STATE,                 -- STEP 5
    CLEAN_K_IN_K_STATE                  -- STEP 6
    );

  type controller_u_in_fsm is (
    STARTER_U_IN_STATE,                 -- STEP 0
    INPUT_U_IN_L_STATE,                 -- STEP 1
    INPUT_U_IN_P_STATE,                 -- STEP 2
    CLEAN_U_IN_L_STATE,                 -- STEP 3
    CLEAN_U_IN_P_STATE                  -- STEP 4
    );

  type controller_v_in_fsm is (
    STARTER_V_IN_STATE,                 -- STEP 0
    INPUT_V_IN_L_STATE,                 -- STEP 1
    INPUT_V_IN_S_STATE,                 -- STEP 2
    CLEAN_V_IN_L_STATE,                 -- STEP 3
    CLEAN_V_IN_S_STATE                  -- STEP 4
    );

  type controller_d_in_fsm is (
    STARTER_D_IN_STATE,                 -- STEP 0
    INPUT_D_IN_I_STATE,                 -- STEP 1
    INPUT_D_IN_L_STATE,                 -- STEP 2
    INPUT_D_IN_M_STATE,                 -- STEP 3
    CLEAN_D_IN_I_STATE,                 -- STEP 4
    CLEAN_D_IN_L_STATE,                 -- STEP 5
    CLEAN_D_IN_M_STATE                  -- STEP 6
    );

  type controller_b_in_fsm is (
    STARTER_B_IN_STATE,                 -- STEP 0
    INPUT_B_IN_L_STATE,                 -- STEP 1
    CLEAN_B_IN_L_STATE                  -- STEP 2
    );

  type controller_x_in_fsm is (
    STARTER_X_IN_STATE,                 -- STEP 0
    INPUT_X_IN_X_STATE,                 -- STEP 1
    CLEAN_X_IN_X_STATE                  -- STEP 2
    );

  type controller_p_in_fsm is (
    STARTER_P_IN_STATE,                 -- STEP 0
    INPUT_P_IN_I_STATE,                 -- STEP 1
    INPUT_P_IN_Y_STATE,                 -- STEP 2
    INPUT_P_IN_K_STATE,                 -- STEP 3
    CLEAN_P_IN_I_STATE,                 -- STEP 4
    CLEAN_P_IN_Y_STATE,                 -- STEP 5
    CLEAN_P_IN_K_STATE                  -- STEP 6
    );

  type controller_q_in_fsm is (
    STARTER_Q_IN_STATE,                 -- STEP 0
    INPUT_Q_IN_Y_STATE,                 -- STEP 1
    INPUT_Q_IN_L_STATE,                 -- STEP 2
    CLEAN_Q_IN_Y_STATE,                 -- STEP 3
    CLEAN_Q_IN_L_STATE                  -- STEP 4
    );

  type controller_y_out_fsm is (
    STARTER_Y_OUT_STATE,                -- STEP 0
    CLEAN_Y_OUT_Y_STATE,                -- STEP 1
    OUTPUT_Y_OUT_Y_STATE                -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Size
  signal SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Finite State Machine
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_k_in_fsm_int : controller_k_in_fsm;
  signal controller_u_in_fsm_int : controller_u_in_fsm;
  signal controller_v_in_fsm_int : controller_v_in_fsm;
  signal controller_d_in_fsm_int : controller_d_in_fsm;
  signal controller_b_in_fsm_int : controller_b_in_fsm;

  signal controller_x_in_fsm_int : controller_x_in_fsm;

  signal controller_p_in_fsm_int : controller_p_in_fsm;
  signal controller_q_in_fsm_int : controller_q_in_fsm;

  signal controller_y_out_fsm_int : controller_y_out_fsm;

  -- Buffer
  signal matrix_w_in_int : matrix_buffer;
  signal tensor_k_in_int : tensor_buffer;
  signal matrix_u_in_int : matrix_buffer;
  signal matrix_v_in_int : matrix_buffer;
  signal tensor_d_in_int : tensor_buffer;
  signal vector_b_in_int : vector_buffer;

  signal vector_x_in_int : vector_buffer;

  signal tensor_p_in_int : tensor_buffer;
  signal matrix_q_in_int : matrix_buffer;

  signal vector_y_out_int : vector_buffer;

  -- Control Internal
  signal index_l_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_v_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_s_v_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_x_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_y_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_y_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_y_y_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_w_in_enable_int : std_logic;
  signal data_k_in_enable_int : std_logic;
  signal data_u_in_enable_int : std_logic;
  signal data_v_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;

  signal data_x_in_enable_int : std_logic;

  signal data_p_in_enable_int : std_logic;
  signal data_q_in_enable_int : std_logic;

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

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
  signal size_n_in_controller : std_logic_vector(CONTROL_SIZE-1 downto 0);
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

  signal w_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal d_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT VECTOR
  -- CONTROL
  signal start_output_vector : std_logic;
  signal ready_output_vector : std_logic;

  signal p_in_i_enable_output_vector : std_logic;
  signal p_in_y_enable_output_vector : std_logic;
  signal p_in_k_enable_output_vector : std_logic;

  signal p_out_i_enable_output_vector : std_logic;
  signal p_out_y_enable_output_vector : std_logic;
  signal p_out_k_enable_output_vector : std_logic;

  signal r_in_i_enable_output_vector : std_logic;
  signal r_in_k_enable_output_vector : std_logic;

  signal r_out_i_enable_output_vector : std_logic;
  signal r_out_k_enable_output_vector : std_logic;

  signal q_in_y_enable_output_vector : std_logic;
  signal q_in_l_enable_output_vector : std_logic;

  signal q_out_y_enable_output_vector : std_logic;
  signal q_out_l_enable_output_vector : std_logic;

  signal h_in_enable_output_vector : std_logic;

  signal h_out_enable_output_vector : std_logic;

  signal y_in_enable_output_vector : std_logic;

  -- DATA
  signal size_y_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal p_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal q_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INTERFACE VECTOR
  -- CONTROL
  signal start_interface_vector : std_logic;
  signal ready_interface_vector : std_logic;

  -- Weight
  signal u_in_s_enable_interface_vector : std_logic;
  signal u_in_l_enable_interface_vector : std_logic;

  signal u_out_s_enable_interface_vector : std_logic;
  signal u_out_l_enable_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_interface_vector : std_logic;

  signal h_out_enable_interface_vector : std_logic;

  -- Interface
  signal xi_out_enable_interface_vector : std_logic;

  -- DATA
  signal size_s_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal xi_out_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- INTERFACE MATRIX
  -- CONTROL
  signal start_interface_matrix : std_logic;
  signal ready_interface_matrix : std_logic;

  -- Weight
  signal u_in_m_enable_interface_matrix : std_logic;
  signal u_in_l_enable_interface_matrix : std_logic;
  signal u_in_i_enable_interface_matrix : std_logic;

  signal u_out_m_enable_interface_matrix : std_logic;
  signal u_out_l_enable_interface_matrix : std_logic;
  signal u_out_i_enable_interface_matrix : std_logic;

  -- Hidden State
  signal h_in_i_enable_interface_matrix : std_logic;
  signal h_in_l_enable_interface_matrix : std_logic;

  signal h_out_i_enable_interface_matrix : std_logic;
  signal h_out_l_enable_interface_matrix : std_logic;

  -- Interface
  signal rho_out_i_enable_interface_matrix : std_logic;
  signal rho_out_m_enable_interface_matrix : std_logic;

  -- DATA
  signal size_m_in_interface_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_interface_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_interface_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_interface_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_interface_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal rho_out_interface_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- READ
  -- CONTROL
  signal start_read_heads : std_logic;
  signal ready_read_heads : std_logic;

  signal rho_in_i_enable_read_heads : std_logic;
  signal rho_in_m_enable_read_heads : std_logic;

  signal rho_out_i_enable_read_heads : std_logic;
  signal rho_out_m_enable_read_heads : std_logic;

  signal k_out_i_enable_read_heads : std_logic;
  signal k_out_k_enable_read_heads : std_logic;

  signal beta_out_enable_read_heads : std_logic;

  signal f_out_enable_read_heads : std_logic;

  signal pi_out_i_enable_read_heads : std_logic;
  signal pi_out_p_enable_read_heads : std_logic;

  -- DATA
  signal size_m_in_read_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_read_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_read_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal rho_in_read_heads : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_read_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_heads : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_read_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_heads   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- WRITE
  -- CONTROL
  signal start_write_heads : std_logic;
  signal ready_write_heads : std_logic;

  signal xi_in_enable_write_heads : std_logic;

  signal xi_out_enable_write_heads : std_logic;

  signal k_out_enable_write_heads : std_logic;
  signal e_out_enable_write_heads : std_logic;
  signal v_out_enable_write_heads : std_logic;

  -- DATA
  signal size_s_in_write_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_write_heads : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal xi_in_write_heads : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_write_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_heads : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_write_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_heads    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_write_heads   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_heads   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- ALLOCATION WEIGHTING
  -- CONTROL
  signal start_allocation_weighting : std_logic;
  signal ready_allocation_weighting : std_logic;

  signal u_in_enable_allocation_weighting : std_logic;

  signal u_out_enable_allocation_weighting : std_logic;

  signal a_out_enable_allocation_weighting : std_logic;

  -- DATA
  signal size_n_in_allocation_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_out_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- BACKWARD WEIGHTING
  -- CONTROL
  signal start_backward_weighting : std_logic;
  signal ready_backward_weighting : std_logic;

  signal l_in_g_enable_backward_weighting : std_logic;
  signal l_in_j_enable_backward_weighting : std_logic;

  signal l_out_g_enable_backward_weighting : std_logic;
  signal l_out_j_enable_backward_weighting : std_logic;

  signal w_in_i_enable_backward_weighting : std_logic;
  signal w_in_j_enable_backward_weighting : std_logic;

  signal w_out_i_enable_backward_weighting : std_logic;
  signal w_out_j_enable_backward_weighting : std_logic;

  signal b_out_i_enable_backward_weighting : std_logic;
  signal b_out_j_enable_backward_weighting : std_logic;

  -- DATA
  signal size_r_in_backward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_backward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal l_in_backward_weighting  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_backward_weighting  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FORWARD WEIGHTING
  -- CONTROL
  signal start_forward_weighting : std_logic;
  signal ready_forward_weighting : std_logic;

  signal l_in_g_enable_forward_weighting : std_logic;
  signal l_in_j_enable_forward_weighting : std_logic;

  signal l_out_g_enable_forward_weighting : std_logic;
  signal l_out_j_enable_forward_weighting : std_logic;

  signal w_in_i_enable_forward_weighting : std_logic;
  signal w_in_j_enable_forward_weighting : std_logic;

  signal w_out_i_enable_forward_weighting : std_logic;
  signal w_out_j_enable_forward_weighting : std_logic;

  signal f_out_i_enable_forward_weighting : std_logic;
  signal f_out_j_enable_forward_weighting : std_logic;

  -- DATA
  signal size_r_in_forward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_forward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal l_in_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_out_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MEMORY MATRIX
  -- CONTROL
  signal start_memory_matrix : std_logic;
  signal ready_memory_matrix : std_logic;

  signal m_in_j_enable_memory_matrix : std_logic;
  signal m_in_k_enable_memory_matrix : std_logic;

  signal w_in_j_enable_memory_matrix : std_logic;
  signal v_in_k_enable_memory_matrix : std_logic;
  signal e_in_k_enable_memory_matrix : std_logic;

  signal w_out_j_enable_memory_matrix : std_logic;
  signal v_out_k_enable_memory_matrix : std_logic;
  signal e_out_k_enable_memory_matrix : std_logic;

  signal m_out_j_enable_memory_matrix : std_logic;
  signal m_out_k_enable_memory_matrix : std_logic;

  -- DATA
  signal size_n_in_memory_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_memory_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal m_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_out_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MEMORY RETENTION VECTOR
  -- CONTROL
  signal start_memory_retention_vector : std_logic;
  signal ready_memory_retention_vector : std_logic;

  signal f_in_enable_memory_retention_vector : std_logic;

  signal f_out_enable_memory_retention_vector : std_logic;

  signal w_in_i_enable_memory_retention_vector : std_logic;
  signal w_in_j_enable_memory_retention_vector : std_logic;

  signal w_out_i_enable_memory_retention_vector : std_logic;
  signal w_out_j_enable_memory_retention_vector : std_logic;

  signal psi_out_enable_memory_retention_vector : std_logic;

  -- DATA
  signal size_r_in_memory_retention_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_memory_retention_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal f_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal psi_out_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- PRECEDENCE WEIGHTING
  -- CONTROL
  signal start_precedence_weighting : std_logic;
  signal ready_precedence_weighting : std_logic;

  signal w_in_enable_precedence_weighting : std_logic;
  signal p_in_enable_precedence_weighting : std_logic;

  signal w_out_enable_precedence_weighting : std_logic;
  signal p_out_enable_precedence_weighting : std_logic;

  -- DATA
  signal size_n_in_precedence_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal p_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal p_out_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ CONTENT WEIGHTING
  -- CONTROL
  signal start_read_content_weighting : std_logic;
  signal ready_read_content_weighting : std_logic;

  signal k_in_enable_read_content_weighting : std_logic;

  signal k_out_enable_read_content_weighting : std_logic;

  signal m_in_j_enable_read_content_weighting : std_logic;
  signal m_in_k_enable_read_content_weighting : std_logic;

  signal m_out_j_enable_read_content_weighting : std_logic;
  signal m_out_k_enable_read_content_weighting : std_logic;

  signal c_out_enable_read_content_weighting : std_logic;

  -- DATA
  signal size_n_in_read_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_read_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_read_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_read_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_read_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_read_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ VECTORS
  -- CONTROL
  signal start_read_vectors : std_logic;
  signal ready_read_vectors : std_logic;

  signal m_in_j_enable_read_vectors : std_logic;
  signal m_in_k_enable_read_vectors : std_logic;

  signal m_out_j_enable_read_vectors : std_logic;
  signal m_out_k_enable_read_vectors : std_logic;

  signal w_in_i_enable_read_vectors : std_logic;
  signal w_in_j_enable_read_vectors : std_logic;

  signal w_out_i_enable_read_vectors : std_logic;
  signal w_out_j_enable_read_vectors : std_logic;

  signal r_out_i_enable_read_vectors : std_logic;
  signal r_out_k_enable_read_vectors : std_logic;

  -- DATA
  signal size_r_in_read_vectors : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_read_vectors : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_read_vectors : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal m_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_out_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ WEIGHTING
  -- CONTROL
  signal start_read_weighting : std_logic;
  signal ready_read_weighting : std_logic;

  signal pi_in_i_enable_read_weighting : std_logic;
  signal pi_in_p_enable_read_weighting : std_logic;

  signal pi_out_i_enable_read_weighting : std_logic;
  signal pi_out_p_enable_read_weighting : std_logic;

  signal b_in_i_enable_read_weighting : std_logic;
  signal b_in_j_enable_read_weighting : std_logic;

  signal b_out_i_enable_read_weighting : std_logic;
  signal b_out_j_enable_read_weighting : std_logic;

  signal c_in_i_enable_read_weighting : std_logic;
  signal c_in_j_enable_read_weighting : std_logic;

  signal c_out_i_enable_read_weighting : std_logic;
  signal c_out_j_enable_read_weighting : std_logic;

  signal f_in_i_enable_read_weighting : std_logic;
  signal f_in_j_enable_read_weighting : std_logic;

  signal f_out_i_enable_read_weighting : std_logic;
  signal f_out_j_enable_read_weighting : std_logic;

  signal w_out_i_enable_read_weighting : std_logic;
  signal w_out_j_enable_read_weighting : std_logic;

  -- DATA
  signal size_r_in_read_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_read_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal pi_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SORT VECTOR
  -- CONTROL
  signal start_sort_vector : std_logic;
  signal ready_sort_vector : std_logic;

  signal u_in_enable_sort_vector : std_logic;

  signal u_out_enable_sort_vector : std_logic;

  signal phi_out_enable_sort_vector : std_logic;

  -- DATA
  signal size_n_in_sort_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal phi_out_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TEMPORAL LINK MATRIX
  -- CONTROL
  signal start_temporal_link_matrix : std_logic;
  signal ready_temporal_link_matrix : std_logic;

  signal l_in_g_enable_temporal_link_matrix : std_logic;
  signal l_in_j_enable_temporal_link_matrix : std_logic;

  signal l_out_g_enable_temporal_link_matrix : std_logic;
  signal l_out_j_enable_temporal_link_matrix : std_logic;

  signal w_in_enable_temporal_link_matrix : std_logic;
  signal p_in_enable_temporal_link_matrix : std_logic;

  signal w_out_enable_temporal_link_matrix : std_logic;
  signal p_out_enable_temporal_link_matrix : std_logic;

  -- DATA
  signal size_n_in_temporal_link_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal l_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal p_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal l_out_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -- USAGE VECTOR
  -- CONTROL
  signal start_usage_vector : std_logic;
  signal ready_usage_vector : std_logic;

  signal u_in_enable_usage_vector   : std_logic;
  signal w_in_enable_usage_vector   : std_logic;
  signal psi_in_enable_usage_vector : std_logic;

  signal u_out_enable_usage_vector   : std_logic;
  signal w_out_enable_usage_vector   : std_logic;
  signal psi_out_enable_usage_vector : std_logic;

  -- DATA
  signal size_n_in_usage_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_usage_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_usage_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal psi_in_usage_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_out_usage_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE CONTENT WEIGHTING
  -- CONTROL
  signal start_write_content_weighting : std_logic;
  signal ready_write_content_weighting : std_logic;

  signal k_in_enable_write_content_weighting : std_logic;

  signal k_out_enable_write_content_weighting : std_logic;

  signal m_in_j_enable_write_content_weighting : std_logic;
  signal m_in_k_enable_write_content_weighting : std_logic;

  signal m_out_j_enable_write_content_weighting : std_logic;
  signal m_out_k_enable_write_content_weighting : std_logic;

  signal c_out_enable_write_content_weighting : std_logic;

  -- DATA
  signal size_n_in_write_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_write_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_write_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_write_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE WEIGHTING
  -- CONTROL
  signal start_write_weighting : std_logic;
  signal ready_write_weighting : std_logic;

  signal a_in_enable_write_weighting : std_logic;
  signal c_in_enable_write_weighting : std_logic;

  signal a_out_enable_write_weighting : std_logic;
  signal c_out_enable_write_weighting : std_logic;

  signal w_out_enable_write_weighting : std_logic;

  -- DATA
  signal size_n_in_write_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal a_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal ga_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- SIZE
  -- ARITHMETIC M: [RHO] = W + 5
  SIZE_M_IN <= std_logic_vector(to_unsigned(5, CONTROL_SIZE) + unsigned(SIZE_W_IN));

  -- ARITHMETIC S: [XI] = 3·W + 3
  SIZE_S_IN <= std_logic_vector(to_unsigned(3, CONTROL_SIZE) + unsigned(SIZE_W_IN) + unsigned(SIZE_W_IN) + unsigned(SIZE_W_IN));

  -- CONTROL
  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_X_ENABLE <= '0';
      W_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_x_w_in_loop <= ZERO_CONTROL;
      index_l_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= ZERO_CONTROL;
            index_l_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          else
            -- Control Outputs
            W_OUT_X_ENABLE <= '0';
            W_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_W_IN_X_STATE =>      -- STEP 1

          if ((W_IN_X_ENABLE = '1') and (W_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_x_w_in_loop)), to_integer(unsigned(index_l_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
          end if;

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';
          W_OUT_L_ENABLE <= '0';

        when INPUT_W_IN_L_STATE =>      -- STEP 2

          if (W_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_x_w_in_loop)), to_integer(unsigned(index_l_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_L_ENABLE <= '0';

        when CLEAN_W_IN_X_STATE =>      -- STEP 3

          if ((unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= ZERO_CONTROL;
            index_l_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_x_w_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= std_logic_vector(unsigned(index_x_w_in_loop) + unsigned(ONE_CONTROL));
            index_l_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          end if;

        when CLEAN_W_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_w_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= std_logic_vector(unsigned(index_l_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_in_fsm_int <= STARTER_W_IN_STATE;
      end case;
    end if;
  end process;

  k_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      K_OUT_I_ENABLE <= '0';
      K_OUT_L_ENABLE <= '0';
      K_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_k_in_loop <= ZERO_CONTROL;
      index_l_k_in_loop <= ZERO_CONTROL;
      index_k_k_in_loop <= ZERO_CONTROL;

      data_k_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_in_fsm_int is
        when STARTER_K_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_l_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '0';

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_L_STATE;
          else
            -- Control Outputs
            K_OUT_I_ENABLE <= '0';
            K_OUT_L_ENABLE <= '0';
            K_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_K_IN_I_STATE =>      -- STEP 1

          if ((K_IN_I_ENABLE = '1') and (K_IN_L_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_l_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
          end if;

          -- Control Outputs
          K_OUT_I_ENABLE <= '0';
          K_OUT_L_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

        when INPUT_K_IN_L_STATE =>      -- STEP 2

          if ((K_IN_L_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_l_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            if (unsigned(index_k_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          K_OUT_L_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

        when INPUT_K_IN_K_STATE =>      -- STEP 3

          if (K_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_l_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            if ((unsigned(index_l_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            elsif (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          K_OUT_K_ENABLE <= '0';

        when CLEAN_K_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_k_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_l_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '1';

            -- FSM Control
            controller_k_in_fsm_int <= STARTER_K_IN_STATE;
          elsif ((unsigned(index_i_k_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_k_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= std_logic_vector(unsigned(index_i_k_in_loop) + unsigned(ONE_CONTROL));
            index_l_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          end if;

        when CLEAN_K_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_k_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_l_k_in_loop <= std_logic_vector(unsigned(index_l_k_in_loop) + unsigned(ONE_CONTROL));
            index_k_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_L_STATE;
          end if;

        when CLEAN_K_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_k_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_in_loop <= std_logic_vector(unsigned(index_k_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_in_fsm_int <= STARTER_K_IN_STATE;
      end case;
    end if;
  end process;

  u_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      U_OUT_L_ENABLE <= '0';
      U_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_l_u_in_loop <= ZERO_CONTROL;
      index_p_u_in_loop <= ZERO_CONTROL;

      data_u_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_u_in_fsm_int is
        when STARTER_U_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= ZERO_CONTROL;
            index_p_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '0';

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_L_STATE;
          else
            -- Control Outputs
            U_OUT_L_ENABLE <= '0';
            U_OUT_P_ENABLE <= '0';
          end if;

        when INPUT_U_IN_L_STATE =>      -- STEP 1

          if ((U_IN_L_ENABLE = '1') and (U_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_u_in_int(to_integer(unsigned(index_l_u_in_loop)), to_integer(unsigned(index_p_u_in_loop))) <= U_IN;

            -- FSM Control
            controller_u_in_fsm_int <= CLEAN_U_IN_P_STATE;
          end if;

          -- Control Outputs
          U_OUT_L_ENABLE <= '0';
          U_OUT_P_ENABLE <= '0';

        when INPUT_U_IN_P_STATE =>      -- STEP 2

          if (U_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_u_in_int(to_integer(unsigned(index_l_u_in_loop)), to_integer(unsigned(index_p_u_in_loop))) <= U_IN;

            -- FSM Control
            if (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_u_in_fsm_int <= CLEAN_U_IN_L_STATE;
            else
              controller_u_in_fsm_int <= CLEAN_U_IN_P_STATE;
            end if;
          end if;

          -- Control Outputs
          U_OUT_P_ENABLE <= '0';

        when CLEAN_U_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= ZERO_CONTROL;
            index_p_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '1';

            -- FSM Control
            controller_u_in_fsm_int <= STARTER_U_IN_STATE;
          elsif ((unsigned(index_l_u_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= std_logic_vector(unsigned(index_l_u_in_loop) + unsigned(ONE_CONTROL));
            index_p_u_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_L_STATE;
          end if;

        when CLEAN_U_IN_P_STATE =>      -- STEP 4

          if (unsigned(index_p_u_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_u_in_loop <= std_logic_vector(unsigned(index_p_u_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_u_in_fsm_int <= STARTER_U_IN_STATE;
      end case;
    end if;
  end process;

  v_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      V_OUT_L_ENABLE <= '0';
      V_OUT_S_ENABLE <= '0';

      -- Control Internal
      index_l_v_in_loop <= ZERO_CONTROL;
      index_s_v_in_loop <= ZERO_CONTROL;

      data_v_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_v_in_fsm_int is
        when STARTER_V_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= ZERO_CONTROL;
            index_s_v_in_loop <= ZERO_CONTROL;

            data_v_in_enable_int <= '0';

            -- FSM Control
            controller_v_in_fsm_int <= INPUT_V_IN_L_STATE;
          else
            -- Control Outputs
            V_OUT_L_ENABLE <= '0';
            V_OUT_S_ENABLE <= '0';
          end if;

        when INPUT_V_IN_L_STATE =>      -- STEP 1

          if ((V_IN_L_ENABLE = '1') and (V_IN_S_ENABLE = '1')) then
            -- Data Inputs
            matrix_v_in_int(to_integer(unsigned(index_l_v_in_loop)), to_integer(unsigned(index_s_v_in_loop))) <= V_IN;

            -- FSM Control
            controller_v_in_fsm_int <= CLEAN_V_IN_S_STATE;
          end if;

          -- Control Outputs
          V_OUT_L_ENABLE <= '0';
          V_OUT_S_ENABLE <= '0';

        when INPUT_V_IN_S_STATE =>      -- STEP 2

          if (V_IN_S_ENABLE = '1') then
            -- Data Inputs
            matrix_v_in_int(to_integer(unsigned(index_l_v_in_loop)), to_integer(unsigned(index_s_v_in_loop))) <= V_IN;

            -- FSM Control
            if (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
              controller_v_in_fsm_int <= CLEAN_V_IN_L_STATE;
            else
              controller_v_in_fsm_int <= CLEAN_V_IN_S_STATE;
            end if;
          end if;

          -- Control Outputs
          V_OUT_S_ENABLE <= '0';

        when CLEAN_V_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_v_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= ZERO_CONTROL;
            index_s_v_in_loop <= ZERO_CONTROL;

            data_v_in_enable_int <= '1';

            -- FSM Control
            controller_v_in_fsm_int <= STARTER_V_IN_STATE;
          elsif ((unsigned(index_l_v_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= std_logic_vector(unsigned(index_l_v_in_loop) + unsigned(ONE_CONTROL));
            index_s_v_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_in_fsm_int <= INPUT_V_IN_L_STATE;
          end if;

        when CLEAN_V_IN_S_STATE =>      -- STEP 4

          if (unsigned(index_s_v_in_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_s_v_in_loop <= std_logic_vector(unsigned(index_s_v_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_v_in_fsm_int <= INPUT_V_IN_S_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_v_in_fsm_int <= STARTER_V_IN_STATE;
      end case;
    end if;
  end process;

  d_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      D_OUT_I_ENABLE <= '0';
      D_OUT_L_ENABLE <= '0';
      D_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_i_d_in_loop <= ZERO_CONTROL;
      index_l_d_in_loop <= ZERO_CONTROL;
      index_m_d_in_loop <= ZERO_CONTROL;

      data_d_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_d_in_fsm_int is
        when STARTER_D_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_l_d_in_loop <= ZERO_CONTROL;
            index_m_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '0';

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_L_STATE;
          else
            -- Control Outputs
            D_OUT_I_ENABLE <= '0';
            D_OUT_L_ENABLE <= '0';
            D_OUT_M_ENABLE <= '0';
          end if;

        when INPUT_D_IN_I_STATE =>      -- STEP 1

          if ((D_IN_I_ENABLE = '1') and (D_IN_L_ENABLE = '1') and (D_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_l_d_in_loop)), to_integer(unsigned(index_m_d_in_loop))) <= D_IN;

            -- FSM Control
            controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
          end if;

          -- Control Outputs
          D_OUT_I_ENABLE <= '0';
          D_OUT_L_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

        when INPUT_D_IN_L_STATE =>      -- STEP 2

          if ((D_IN_L_ENABLE = '1') and (D_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_l_d_in_loop)), to_integer(unsigned(index_m_d_in_loop))) <= D_IN;

            -- FSM Control
            if (unsigned(index_m_d_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          D_OUT_L_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

        when INPUT_D_IN_M_STATE =>      -- STEP 3

          if (D_IN_M_ENABLE = '1') then
            -- Data Inputs
            tensor_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_l_d_in_loop)), to_integer(unsigned(index_m_d_in_loop))) <= D_IN;

            -- FSM Control
            if ((unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            elsif (unsigned(index_m_d_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_M_STATE;
            end if;
          end if;

          -- Control Outputs
          D_OUT_M_ENABLE <= '0';

        when CLEAN_D_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_d_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_l_d_in_loop <= ZERO_CONTROL;
            index_m_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '1';

            -- FSM Control
            controller_d_in_fsm_int <= STARTER_D_IN_STATE;
          elsif ((unsigned(index_i_d_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            D_OUT_I_ENABLE <= '1';
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= std_logic_vector(unsigned(index_i_d_in_loop) + unsigned(ONE_CONTROL));
            index_l_d_in_loop <= ZERO_CONTROL;
            index_m_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          end if;

        when CLEAN_D_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_d_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            D_OUT_L_ENABLE <= '1';
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_l_d_in_loop <= std_logic_vector(unsigned(index_l_d_in_loop) + unsigned(ONE_CONTROL));
            index_m_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_L_STATE;
          end if;

        when CLEAN_D_IN_M_STATE =>      -- STEP 4

          if (unsigned(index_m_d_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_d_in_loop <= std_logic_vector(unsigned(index_m_d_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_M_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_in_fsm_int <= STARTER_D_IN_STATE;
      end case;
    end if;
  end process;

  b_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      B_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_b_in_loop <= ZERO_CONTROL;

      data_b_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_b_in_fsm_int is
        when STARTER_B_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_L_STATE;
          else
            -- Control Outputs
            B_OUT_ENABLE <= '0';
          end if;

        when INPUT_B_IN_L_STATE =>      -- STEP 1

          if (B_IN_ENABLE = '1') then
            -- Data Inputs
            vector_b_in_int(to_integer(unsigned(index_l_b_in_loop))) <= B_IN;

            -- FSM Control
            controller_b_in_fsm_int <= CLEAN_B_IN_L_STATE;
          end if;

          -- Control Outputs
          B_OUT_ENABLE <= '0';

        when CLEAN_B_IN_L_STATE =>      -- STEP 2

          if (unsigned(index_l_b_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '1';

            -- FSM Control
            controller_b_in_fsm_int <= STARTER_B_IN_STATE;
          elsif (unsigned(index_l_b_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= std_logic_vector(unsigned(index_l_b_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_in_fsm_int <= STARTER_B_IN_STATE;
      end case;
    end if;
  end process;

  x_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      X_OUT_ENABLE <= '0';

      -- Control Internal
      index_x_x_in_loop <= ZERO_CONTROL;

      data_x_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_x_in_fsm_int is
        when STARTER_X_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '0';

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          else
            -- Control Outputs
            X_OUT_ENABLE <= '0';
          end if;

        when INPUT_X_IN_X_STATE =>      -- STEP 1

          if (X_IN_ENABLE = '1') then
            -- Data Inputs
            vector_x_in_int(to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            controller_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
          end if;

          -- Control Outputs
          X_OUT_ENABLE <= '0';

        when CLEAN_X_IN_X_STATE =>      -- STEP 2

          if (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '1';

            -- FSM Control
            controller_x_in_fsm_int <= STARTER_X_IN_STATE;
          elsif (unsigned(index_x_x_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= std_logic_vector(unsigned(index_x_x_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_x_in_fsm_int <= STARTER_X_IN_STATE;
      end case;
    end if;
  end process;

  p_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      P_OUT_I_ENABLE <= '0';
      P_OUT_Y_ENABLE <= '0';
      P_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_p_in_loop <= ZERO_CONTROL;
      index_y_p_in_loop <= ZERO_CONTROL;
      index_k_p_in_loop <= ZERO_CONTROL;

      data_p_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_p_in_fsm_int is
        when STARTER_P_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= ZERO_CONTROL;
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            data_p_in_enable_int <= '0';

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_Y_STATE;
          else
            -- Control Outputs
            P_OUT_I_ENABLE <= '0';
            P_OUT_Y_ENABLE <= '0';
            P_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_P_IN_I_STATE =>      -- STEP 1

          if ((P_IN_I_ENABLE = '1') and (P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
          end if;

          -- Control Outputs
          P_OUT_I_ENABLE <= '0';
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_P_IN_Y_STATE =>      -- STEP 2

          if ((P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            if (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
            else
              controller_p_in_fsm_int <= CLEAN_P_IN_Y_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_P_IN_K_STATE =>      -- STEP 3

          if (P_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            if ((unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
            elsif (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_p_in_fsm_int <= CLEAN_P_IN_Y_STATE;
            else
              controller_p_in_fsm_int <= CLEAN_P_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_K_ENABLE <= '0';

        when CLEAN_P_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_p_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= ZERO_CONTROL;
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            data_p_in_enable_int <= '1';

            -- FSM Control
            controller_p_in_fsm_int <= STARTER_P_IN_STATE;
          elsif ((unsigned(index_i_p_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= std_logic_vector(unsigned(index_i_p_in_loop) + unsigned(ONE_CONTROL));
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_I_STATE;
          end if;

        when CLEAN_P_IN_Y_STATE =>      -- STEP 3

          if ((unsigned(index_y_p_in_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_y_p_in_loop <= std_logic_vector(unsigned(index_y_p_in_loop) + unsigned(ONE_CONTROL));
            index_k_p_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_Y_STATE;
          end if;

        when CLEAN_P_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_p_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_p_in_loop <= std_logic_vector(unsigned(index_k_p_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_p_in_fsm_int <= STARTER_P_IN_STATE;
      end case;
    end if;
  end process;

  q_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      Q_OUT_Y_ENABLE <= '0';
      Q_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_y_q_in_loop <= ZERO_CONTROL;
      index_l_q_in_loop <= ZERO_CONTROL;

      data_q_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_q_in_fsm_int is
        when STARTER_Q_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= ZERO_CONTROL;
            index_l_q_in_loop <= ZERO_CONTROL;

            data_q_in_enable_int <= '0';

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_Y_STATE;
          else
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '0';
            Q_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_Q_IN_Y_STATE =>      -- STEP 1

          if ((Q_IN_Y_ENABLE = '1') and (Q_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_q_in_int(to_integer(unsigned(index_y_q_in_loop)), to_integer(unsigned(index_l_q_in_loop))) <= Q_IN;

            -- FSM Control
            controller_q_in_fsm_int <= CLEAN_Q_IN_L_STATE;
          end if;

          -- Control Outputs
          Q_OUT_Y_ENABLE <= '0';
          Q_OUT_L_ENABLE <= '0';

        when INPUT_Q_IN_L_STATE =>      -- STEP 2

          if (Q_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_q_in_int(to_integer(unsigned(index_y_q_in_loop)), to_integer(unsigned(index_l_q_in_loop))) <= Q_IN;

            -- FSM Control
            if (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_q_in_fsm_int <= CLEAN_Q_IN_Y_STATE;
            else
              controller_q_in_fsm_int <= CLEAN_Q_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          Q_OUT_L_ENABLE <= '0';

        when CLEAN_Q_IN_Y_STATE =>      -- STEP 3

          if ((unsigned(index_y_q_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= ZERO_CONTROL;
            index_l_q_in_loop <= ZERO_CONTROL;

            data_q_in_enable_int <= '1';

            -- FSM Control
            controller_q_in_fsm_int <= STARTER_Q_IN_STATE;
          elsif ((unsigned(index_y_q_in_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= std_logic_vector(unsigned(index_y_q_in_loop) + unsigned(ONE_CONTROL));
            index_l_q_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_Y_STATE;
          end if;

        when CLEAN_Q_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_q_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_q_in_loop <= std_logic_vector(unsigned(index_l_q_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_q_in_fsm_int <= STARTER_Q_IN_STATE;
      end case;
    end if;
  end process;

  -- INTERFACE_VECTOR_STATE

  -- xi(t;s) = U(s;l)·h(t;l)

  -- INTERFACE_MATRIX_STATE

  -- rho(t;i;m) = U(i;m;l)·h(t;i;l)



  -- READ_HEADS_STATE

  -- WRITE_HEADS_STATE



  -- MEMORY_STATE
  -- MEMORY_RETENTION_VECTOR

  -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

  -- USAGE_VECTOR

  -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)

  -- ALLOCATION_WEIGHTING

  -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]

  -- WRITE_CONTENT_WEIGHTING

  -- c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))

  -- WRITE_WEIGHTING

  -- w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))

  -- MEMORY_MATRIX

  -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

  -- PRECEDENCE_WEIGHTING

  -- p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
  -- p(t=0) = 0

  -- TEMPORAL_LINK_MATRIX

  -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
  -- L(t=0)[g,j] = 0

  -- FORWARD_WEIGHTING

  -- f(t;i;j) = L(t;g;j)·w(t-1;i;j)

  -- BACKWARD_WEIGHTING

  -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

  -- READ_CONTENT_WEIGHTING

  -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

  -- READ_WEIGHTING

  -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

  -- READ_VECTORS

  -- r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)



  -- CONTROLLER_BODY_STATE

  -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
  -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

  -- OUTPUT_VECTOR_STATE

  -- y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)
  y_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      Y_OUT_ENABLE <= '0';

      -- Control Internal
      index_y_y_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_y_out_fsm_int is
        when STARTER_Y_OUT_STATE =>     -- STEP 0
          if (data_w_in_enable_int = '1' and data_k_in_enable_int = '1' and data_u_in_enable_int = '1' and data_d_in_enable_int = '1' and data_b_in_enable_int = '1' and data_x_in_enable_int = '1' and data_p_in_enable_int = '1' and data_q_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_y_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_Y_STATE;
          end if;

        when CLEAN_Y_OUT_Y_STATE =>     -- STEP 1
          -- Control Outputs
          Y_OUT_ENABLE <= '0';

          -- FSM Control
          controller_y_out_fsm_int <= OUTPUT_Y_OUT_Y_STATE;

        when OUTPUT_Y_OUT_Y_STATE =>    -- STEP 2

          if (unsigned(index_y_y_out_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_y_out_int(to_integer(unsigned(index_y_y_out_loop)));

            -- Control Outputs
            READY <= '1';

            Y_OUT_ENABLE <= '1';

            -- Control Internal
            index_y_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
          elsif (unsigned(index_y_y_out_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_y_out_int(to_integer(unsigned(index_y_y_out_loop)));

            -- Control Outputs
            Y_OUT_ENABLE <= '1';

            -- Control Internal
            index_y_y_out_loop <= std_logic_vector(unsigned(index_y_y_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_Y_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
      end case;
    end if;
  end process;



  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  -- CONTROLLER
  ntm_controller_i : ntm_controller
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
      SIZE_N_IN => size_n_in_controller,
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

      W_OUT => w_out_controller,
      D_OUT => d_out_controller,
      K_OUT => k_out_controller,
      U_OUT => u_out_controller,
      V_OUT => v_out_controller,
      B_OUT => b_out_controller,

      H_OUT => h_out_controller
      );

  -- OUTPUT VECTOR
  output_vector_i : dnc_output_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_vector,
      READY => ready_output_vector,

      P_IN_I_ENABLE => p_in_i_enable_output_vector,
      P_IN_Y_ENABLE => p_in_y_enable_output_vector,
      P_IN_K_ENABLE => p_in_k_enable_output_vector,

      P_OUT_I_ENABLE => p_out_i_enable_output_vector,
      P_OUT_Y_ENABLE => p_out_y_enable_output_vector,
      P_OUT_K_ENABLE => p_out_k_enable_output_vector,

      R_IN_I_ENABLE => r_in_i_enable_output_vector,
      R_IN_K_ENABLE => r_in_k_enable_output_vector,

      R_OUT_I_ENABLE => r_out_i_enable_output_vector,
      R_OUT_K_ENABLE => r_out_k_enable_output_vector,

      Q_IN_Y_ENABLE => q_in_y_enable_output_vector,
      Q_IN_L_ENABLE => q_in_l_enable_output_vector,

      Q_OUT_Y_ENABLE => q_out_y_enable_output_vector,
      Q_OUT_L_ENABLE => q_out_l_enable_output_vector,

      H_IN_ENABLE => h_in_enable_output_vector,

      H_OUT_ENABLE => h_out_enable_output_vector,

      Y_OUT_ENABLE => y_in_enable_output_vector,

      -- DATA
      SIZE_Y_IN => size_y_in_output_vector,
      SIZE_L_IN => size_l_in_output_vector,
      SIZE_W_IN => size_w_in_output_vector,
      SIZE_R_IN => size_r_in_output_vector,

      P_IN => p_in_output_vector,
      R_IN => r_in_output_vector,

      Q_IN => q_in_output_vector,
      H_IN => h_in_output_vector,

      Y_OUT => y_out_output_vector
      );

  -- INTERFACE VECTOR
  interface_vector : dnc_interface_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_interface_vector,
      READY => ready_interface_vector,

      -- Weight
      U_IN_S_ENABLE => u_in_s_enable_interface_vector,
      U_IN_L_ENABLE => u_in_l_enable_interface_vector,

      U_OUT_S_ENABLE => u_out_s_enable_interface_vector,
      U_OUT_L_ENABLE => u_out_l_enable_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_interface_vector,

      H_OUT_ENABLE => h_out_enable_interface_vector,

      -- Interface
      XI_OUT_ENABLE => xi_out_enable_interface_vector,

      -- DATA
      SIZE_S_IN => size_s_in_interface_vector,
      SIZE_L_IN => size_l_in_interface_vector,

      U_IN => u_in_interface_vector,

      H_IN => h_in_interface_vector,

      XI_OUT => xi_out_interface_vector
      );

  -- INTERFACE MATRIX
  interface_matrix : dnc_interface_matrix
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_interface_matrix,
      READY => ready_interface_matrix,

      -- Weight
      U_IN_I_ENABLE => u_in_i_enable_interface_matrix,
      U_IN_M_ENABLE => u_in_m_enable_interface_matrix,
      U_IN_L_ENABLE => u_in_l_enable_interface_matrix,

      U_OUT_I_ENABLE => u_out_i_enable_interface_matrix,
      U_OUT_M_ENABLE => u_out_m_enable_interface_matrix,
      U_OUT_L_ENABLE => u_out_l_enable_interface_matrix,

      -- Hidden State
      H_IN_I_ENABLE => h_in_i_enable_interface_matrix,
      H_IN_L_ENABLE => h_in_l_enable_interface_matrix,

      H_OUT_I_ENABLE => h_out_i_enable_interface_matrix,
      H_OUT_L_ENABLE => h_out_l_enable_interface_matrix,

      -- Interface
      RHO_OUT_I_ENABLE => rho_out_i_enable_interface_matrix,
      RHO_OUT_M_ENABLE => rho_out_m_enable_interface_matrix,

      -- DATA
      SIZE_M_IN => size_m_in_interface_matrix,
      SIZE_R_IN => size_r_in_interface_matrix,
      SIZE_L_IN => size_l_in_interface_matrix,

      U_IN => u_in_interface_matrix,

      H_IN => h_in_interface_matrix,

      RHO_OUT => rho_out_interface_matrix
      );

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- READ
  read_heads : dnc_read_heads
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_heads,
      READY => ready_read_heads,

      RHO_IN_I_ENABLE => rho_in_i_enable_read_heads,
      RHO_IN_M_ENABLE => rho_in_m_enable_read_heads,

      RHO_OUT_I_ENABLE => rho_out_i_enable_read_heads,
      RHO_OUT_M_ENABLE => rho_out_m_enable_read_heads,

      K_OUT_I_ENABLE => k_out_i_enable_read_heads,
      K_OUT_K_ENABLE => k_out_k_enable_read_heads,

      BETA_OUT_ENABLE => beta_out_enable_read_heads,

      F_OUT_ENABLE => f_out_enable_read_heads,

      PI_OUT_I_ENABLE => pi_out_i_enable_read_heads,
      PI_OUT_P_ENABLE => pi_out_p_enable_read_heads,

      -- DATA
      SIZE_M_IN => size_m_in_read_heads,
      SIZE_R_IN => size_r_in_read_heads,
      SIZE_W_IN => size_w_in_read_heads,

      RHO_IN => rho_in_read_heads,

      K_OUT    => k_out_read_heads,
      BETA_OUT => beta_out_read_heads,
      F_OUT    => f_out_read_heads,
      PI_OUT   => pi_out_read_heads
      );

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- WRITE
  write_heads : dnc_write_heads
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_heads,
      READY => ready_write_heads,

      XI_IN_ENABLE => xi_in_enable_write_heads,

      XI_OUT_ENABLE => xi_out_enable_write_heads,

      K_OUT_ENABLE => k_out_enable_write_heads,
      E_OUT_ENABLE => e_out_enable_write_heads,
      V_OUT_ENABLE => v_out_enable_write_heads,

      -- DATA
      SIZE_S_IN => size_s_in_write_heads,
      SIZE_W_IN => size_w_in_write_heads,

      XI_IN => xi_in_write_heads,

      K_OUT    => k_out_write_heads,
      BETA_OUT => beta_out_write_heads,
      E_OUT    => e_out_write_heads,
      V_OUT    => v_out_write_heads,
      GA_OUT   => ga_out_write_heads,
      GW_OUT   => gw_out_write_heads
      );

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- ALLOCATION WEIGHTING
  allocation_weighting : dnc_allocation_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_allocation_weighting,
      READY => ready_allocation_weighting,

      U_IN_ENABLE => u_in_enable_allocation_weighting,

      U_OUT_ENABLE => u_out_enable_allocation_weighting,

      A_OUT_ENABLE => a_out_enable_allocation_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_allocation_weighting,

      U_IN => u_in_allocation_weighting,

      A_OUT => a_out_allocation_weighting
      );

  -- BACKWARD WEIGHTING
  backward_weighting : dnc_backward_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_backward_weighting,
      READY => ready_backward_weighting,

      L_IN_G_ENABLE => l_in_g_enable_backward_weighting,
      L_IN_J_ENABLE => l_in_j_enable_backward_weighting,

      L_OUT_G_ENABLE => l_out_g_enable_backward_weighting,
      L_OUT_J_ENABLE => l_out_j_enable_backward_weighting,

      W_IN_I_ENABLE => w_in_i_enable_backward_weighting,
      W_IN_J_ENABLE => w_in_j_enable_backward_weighting,

      W_OUT_I_ENABLE => w_out_i_enable_backward_weighting,
      W_OUT_J_ENABLE => w_out_j_enable_backward_weighting,

      B_OUT_I_ENABLE => b_out_i_enable_backward_weighting,
      B_OUT_J_ENABLE => b_out_j_enable_backward_weighting,

      -- DATA
      SIZE_R_IN => size_r_in_backward_weighting,
      SIZE_N_IN => size_n_in_backward_weighting,

      L_IN => l_in_backward_weighting,

      W_IN => w_in_backward_weighting,

      B_OUT => b_out_backward_weighting
      );

  -- FORWARD WEIGHTING
  forward_weighting : dnc_forward_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_forward_weighting,
      READY => ready_forward_weighting,

      L_IN_G_ENABLE => l_in_g_enable_forward_weighting,
      L_IN_J_ENABLE => l_in_j_enable_forward_weighting,

      L_OUT_G_ENABLE => l_out_g_enable_forward_weighting,
      L_OUT_J_ENABLE => l_out_j_enable_forward_weighting,

      W_IN_I_ENABLE => w_in_i_enable_forward_weighting,
      W_IN_J_ENABLE => w_in_j_enable_forward_weighting,

      W_OUT_I_ENABLE => w_out_i_enable_forward_weighting,
      W_OUT_J_ENABLE => w_out_j_enable_forward_weighting,

      F_OUT_I_ENABLE => f_out_i_enable_forward_weighting,
      F_OUT_J_ENABLE => f_out_j_enable_forward_weighting,

      -- DATA
      SIZE_R_IN => size_r_in_forward_weighting,
      SIZE_N_IN => size_n_in_forward_weighting,

      L_IN => l_in_forward_weighting,

      W_IN => w_in_forward_weighting,

      F_OUT => f_out_forward_weighting
      );

  -- MEMORY MATRIX
  memory_matrix : dnc_memory_matrix
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_memory_matrix,
      READY => ready_memory_matrix,

      M_IN_J_ENABLE => m_in_j_enable_memory_matrix,
      M_IN_K_ENABLE => m_in_k_enable_memory_matrix,

      W_IN_J_ENABLE => w_in_j_enable_memory_matrix,
      V_IN_K_ENABLE => v_in_k_enable_memory_matrix,
      E_IN_K_ENABLE => e_in_k_enable_memory_matrix,

      W_OUT_J_ENABLE => w_out_j_enable_memory_matrix,
      V_OUT_K_ENABLE => v_out_k_enable_memory_matrix,
      E_OUT_K_ENABLE => e_out_k_enable_memory_matrix,

      M_OUT_J_ENABLE => m_out_j_enable_memory_matrix,
      M_OUT_K_ENABLE => m_out_k_enable_memory_matrix,

      -- DATA
      SIZE_N_IN => size_n_in_memory_matrix,
      SIZE_W_IN => size_w_in_memory_matrix,

      M_IN => m_in_memory_matrix,

      W_IN => w_in_memory_matrix,
      V_IN => v_in_memory_matrix,
      E_IN => e_in_memory_matrix,

      M_OUT => m_out_memory_matrix
      );

  -- MEMORY RETENTION VECTOR
  memory_retention_vector : dnc_memory_retention_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_memory_retention_vector,
      READY => ready_memory_retention_vector,

      F_IN_ENABLE => f_in_enable_memory_retention_vector,

      F_OUT_ENABLE => f_out_enable_memory_retention_vector,

      W_IN_I_ENABLE => w_in_i_enable_memory_retention_vector,
      W_IN_J_ENABLE => w_in_j_enable_memory_retention_vector,

      W_OUT_I_ENABLE => w_out_i_enable_memory_retention_vector,
      W_OUT_J_ENABLE => w_out_j_enable_memory_retention_vector,

      PSI_OUT_ENABLE => psi_out_enable_memory_retention_vector,

      -- DATA
      SIZE_R_IN => size_r_in_memory_retention_vector,
      SIZE_N_IN => size_n_in_memory_retention_vector,

      F_IN => f_in_memory_retention_vector,
      W_IN => w_in_memory_retention_vector,

      PSI_OUT => psi_out_memory_retention_vector
      );

  -- PRECEDENCE WEIGHTING
  precedence_weighting : dnc_precedence_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_precedence_weighting,
      READY => ready_precedence_weighting,

      W_IN_ENABLE => w_in_enable_precedence_weighting,
      P_IN_ENABLE => p_in_enable_precedence_weighting,

      W_OUT_ENABLE => w_out_enable_precedence_weighting,
      P_OUT_ENABLE => p_out_enable_precedence_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_precedence_weighting,

      W_IN => w_in_precedence_weighting,
      P_IN => p_in_precedence_weighting,

      P_OUT => p_out_precedence_weighting
      );

  -- READ CONTENT WEIGHTING
  read_content_weighting : dnc_read_content_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_content_weighting,
      READY => ready_read_content_weighting,

      K_IN_ENABLE => k_in_enable_read_content_weighting,

      K_OUT_ENABLE => k_out_enable_read_content_weighting,

      M_IN_J_ENABLE => m_in_j_enable_read_content_weighting,
      M_IN_K_ENABLE => m_in_k_enable_read_content_weighting,

      M_OUT_J_ENABLE => m_out_j_enable_read_content_weighting,
      M_OUT_K_ENABLE => m_out_k_enable_read_content_weighting,

      C_OUT_ENABLE => c_out_enable_read_content_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_read_content_weighting,
      SIZE_W_IN => size_w_in_read_content_weighting,

      K_IN    => k_in_read_content_weighting,
      M_IN    => m_in_read_content_weighting,
      BETA_IN => beta_in_read_content_weighting,

      C_OUT => c_out_read_content_weighting
      );

  -- READ VECTORS
  read_vectors : dnc_read_vectors
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_vectors,
      READY => ready_read_vectors,

      M_IN_J_ENABLE => m_in_j_enable_read_vectors,
      M_IN_K_ENABLE => m_in_k_enable_read_vectors,

      M_OUT_J_ENABLE => m_out_j_enable_read_vectors,
      M_OUT_K_ENABLE => m_out_k_enable_read_vectors,

      W_IN_I_ENABLE => w_in_i_enable_read_vectors,
      W_IN_J_ENABLE => w_in_j_enable_read_vectors,

      W_OUT_I_ENABLE => w_out_i_enable_read_vectors,
      W_OUT_J_ENABLE => w_out_j_enable_read_vectors,

      R_OUT_I_ENABLE => r_out_i_enable_read_vectors,
      R_OUT_K_ENABLE => r_out_k_enable_read_vectors,

      -- DATA
      SIZE_R_IN => size_r_in_read_vectors,
      SIZE_N_IN => size_n_in_read_vectors,
      SIZE_W_IN => size_w_in_read_vectors,

      M_IN => m_in_read_vectors,
      W_IN => w_in_read_vectors,

      R_OUT => r_out_read_vectors
      );

  -- READ WEIGHTING
  read_weighting : dnc_read_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_weighting,
      READY => ready_read_weighting,

      PI_IN_I_ENABLE => pi_in_i_enable_read_weighting,
      PI_IN_P_ENABLE => pi_in_p_enable_read_weighting,

      PI_OUT_I_ENABLE => pi_out_i_enable_read_weighting,
      PI_OUT_P_ENABLE => pi_out_p_enable_read_weighting,

      B_IN_I_ENABLE => b_in_i_enable_read_weighting,
      B_IN_J_ENABLE => b_in_j_enable_read_weighting,

      B_OUT_I_ENABLE => b_out_i_enable_read_weighting,
      B_OUT_J_ENABLE => b_out_j_enable_read_weighting,

      C_IN_I_ENABLE => c_in_i_enable_read_weighting,
      C_IN_J_ENABLE => c_in_j_enable_read_weighting,

      C_OUT_I_ENABLE => c_out_i_enable_read_weighting,
      C_OUT_J_ENABLE => c_out_j_enable_read_weighting,

      F_IN_I_ENABLE => f_in_i_enable_read_weighting,
      F_IN_J_ENABLE => f_in_j_enable_read_weighting,

      F_OUT_I_ENABLE => f_out_i_enable_read_weighting,
      F_OUT_J_ENABLE => f_out_j_enable_read_weighting,

      W_OUT_I_ENABLE => w_out_i_enable_read_weighting,
      W_OUT_J_ENABLE => w_out_j_enable_read_weighting,

      -- DATA
      SIZE_R_IN => size_r_in_read_weighting,
      SIZE_N_IN => size_n_in_read_weighting,

      PI_IN => pi_in_read_weighting,

      B_IN => b_in_read_weighting,
      C_IN => c_in_read_weighting,
      F_IN => f_in_read_weighting,

      W_OUT => w_out_read_weighting
      );

  -- SORT VECTOR
  sort_vector : dnc_sort_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_sort_vector,
      READY => ready_sort_vector,

      U_IN_ENABLE => u_in_enable_sort_vector,

      U_OUT_ENABLE => u_out_enable_sort_vector,

      PHI_OUT_ENABLE => phi_out_enable_sort_vector,

      -- DATA
      SIZE_N_IN => size_n_in_sort_vector,

      U_IN => u_in_sort_vector,

      PHI_OUT => phi_out_sort_vector
      );

  -- TEMPORAL LINK MATRIX
  temporal_link_matrix : dnc_temporal_link_matrix
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_temporal_link_matrix,
      READY => ready_temporal_link_matrix,

      L_IN_G_ENABLE => l_in_g_enable_temporal_link_matrix,
      L_IN_J_ENABLE => l_in_j_enable_temporal_link_matrix,

      L_OUT_G_ENABLE => l_out_g_enable_temporal_link_matrix,
      L_OUT_J_ENABLE => l_out_j_enable_temporal_link_matrix,

      W_IN_ENABLE => w_in_enable_temporal_link_matrix,
      P_IN_ENABLE => p_in_enable_temporal_link_matrix,

      W_OUT_ENABLE => w_out_enable_temporal_link_matrix,
      P_OUT_ENABLE => p_out_enable_temporal_link_matrix,

      -- DATA
      SIZE_N_IN => size_n_in_temporal_link_matrix,

      L_IN => l_in_temporal_link_matrix,
      W_IN => w_in_temporal_link_matrix,
      P_IN => p_in_temporal_link_matrix,

      L_OUT => l_out_temporal_link_matrix
      );

  -- USAGE VECTOR
  usage_vector : dnc_usage_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_usage_vector,
      READY => ready_usage_vector,

      U_IN_ENABLE   => u_in_enable_usage_vector,
      W_IN_ENABLE   => w_in_enable_usage_vector,
      PSI_IN_ENABLE => psi_in_enable_usage_vector,

      U_OUT_ENABLE   => u_out_enable_usage_vector,
      W_OUT_ENABLE   => w_out_enable_usage_vector,
      PSI_OUT_ENABLE => psi_out_enable_usage_vector,

      -- DATA
      SIZE_N_IN => size_n_in_usage_vector,

      U_IN   => u_in_usage_vector,
      W_IN   => w_in_usage_vector,
      PSI_IN => psi_in_usage_vector,

      U_OUT => u_out_usage_vector
      );

  -- WRITE CONTENT WEIGHTING
  write_content_weighting : dnc_write_content_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_content_weighting,
      READY => ready_write_content_weighting,

      K_IN_ENABLE => k_in_enable_write_content_weighting,

      M_IN_J_ENABLE => m_in_j_enable_write_content_weighting,
      M_IN_K_ENABLE => m_in_k_enable_write_content_weighting,

      M_OUT_J_ENABLE => m_out_j_enable_write_content_weighting,
      M_OUT_K_ENABLE => m_out_k_enable_write_content_weighting,

      C_OUT_ENABLE => c_out_enable_write_content_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_write_content_weighting,
      SIZE_W_IN => size_w_in_write_content_weighting,

      K_IN    => k_in_write_content_weighting,
      M_IN    => m_in_write_content_weighting,
      BETA_IN => beta_in_write_content_weighting,

      C_OUT => c_out_content_weighting
      );

  -- WRITE WEIGHTING
  write_weighting : dnc_write_weighting
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_weighting,
      READY => ready_write_weighting,

      A_IN_ENABLE => a_in_enable_write_weighting,
      C_IN_ENABLE => c_in_enable_write_weighting,

      A_OUT_ENABLE => a_out_enable_write_weighting,
      C_OUT_ENABLE => c_out_enable_write_weighting,

      W_OUT_ENABLE => w_out_enable_write_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_write_weighting,

      A_IN => a_in_write_weighting,
      C_IN => c_in_write_weighting,

      GA_IN => ga_in_write_weighting,
      GW_IN => gw_in_write_weighting,

      W_OUT => w_out_write_weighting
      );

end architecture;
