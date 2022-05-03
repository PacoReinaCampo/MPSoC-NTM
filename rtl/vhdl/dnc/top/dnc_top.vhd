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
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Size
  signal SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Finite State Machine

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_read_in_i_enable_addressing : std_logic;
  signal k_read_in_k_enable_addressing : std_logic;

  signal k_read_out_i_enable_addressing : std_logic;
  signal k_read_out_k_enable_addressing : std_logic;

  signal beta_read_in_enable_addressing : std_logic;

  signal beta_read_out_enable_addressing : std_logic;

  signal f_read_in_enable_addressing : std_logic;

  signal f_read_out_enable_addressing : std_logic;

  signal pi_read_in_i_enable_addressing : std_logic;
  signal pi_read_in_p_enable_addressing : std_logic;

  signal pi_read_out_i_enable_addressing : std_logic;
  signal pi_read_out_p_enable_addressing : std_logic;

  signal k_write_in_k_enable_addressing : std_logic;
  signal e_write_in_k_enable_addressing : std_logic;
  signal v_write_in_k_enable_addressing : std_logic;

  signal k_write_out_k_enable_addressing : std_logic;
  signal e_write_out_k_enable_addressing : std_logic;
  signal v_write_out_k_enable_addressing : std_logic;

  signal r_out_i_enable_addressing : std_logic;
  signal r_out_k_enable_addressing : std_logic;

  -- DATA
  signal size_r_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_read_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_read_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_write_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- ADDRESSING
  addressing : dnc_addressing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      K_READ_IN_I_ENABLE => k_read_in_i_enable_addressing,
      K_READ_IN_K_ENABLE => k_read_in_k_enable_addressing,

      K_READ_OUT_I_ENABLE => k_read_out_i_enable_addressing,
      K_READ_OUT_K_ENABLE => k_read_out_k_enable_addressing,

      BETA_READ_IN_ENABLE => beta_read_in_enable_addressing,

      BETA_READ_OUT_ENABLE => beta_read_out_enable_addressing,

      F_READ_IN_ENABLE => f_read_in_enable_addressing,

      F_READ_OUT_ENABLE => f_read_out_enable_addressing,

      PI_READ_IN_I_ENABLE => pi_read_in_i_enable_addressing,
      PI_READ_IN_P_ENABLE => pi_read_in_p_enable_addressing,

      PI_READ_OUT_I_ENABLE => pi_read_out_i_enable_addressing,
      PI_READ_OUT_P_ENABLE => pi_read_out_p_enable_addressing,

      K_WRITE_IN_K_ENABLE => k_write_in_k_enable_addressing,
      E_WRITE_IN_K_ENABLE => e_write_in_k_enable_addressing,
      V_WRITE_IN_K_ENABLE => v_write_in_k_enable_addressing,

      K_WRITE_OUT_K_ENABLE => k_write_out_k_enable_addressing,
      E_WRITE_OUT_K_ENABLE => e_write_out_k_enable_addressing,
      V_WRITE_OUT_K_ENABLE => v_write_out_k_enable_addressing,

      R_OUT_I_ENABLE => r_out_i_enable_addressing,
      R_OUT_K_ENABLE => r_out_k_enable_addressing,

      -- DATA
      SIZE_R_IN => size_r_in_addressing,
      SIZE_N_IN => size_n_in_addressing,
      SIZE_W_IN => size_w_in_addressing,

      K_READ_IN    => k_read_in_addressing,
      BETA_READ_IN => beta_read_in_addressing,
      F_READ_IN    => f_read_in_addressing,
      PI_READ_IN   => pi_read_in_addressing,

      K_WRITE_IN    => k_write_in_addressing,
      BETA_WRITE_IN => beta_write_in_addressing,
      E_WRITE_IN    => e_write_in_addressing,
      V_WRITE_IN    => v_write_in_addressing,
      GA_WRITE_IN   => ga_write_in_addressing,
      GW_WRITE_IN   => gw_write_in_addressing,

      R_OUT => r_out_addressing
      );

end architecture;