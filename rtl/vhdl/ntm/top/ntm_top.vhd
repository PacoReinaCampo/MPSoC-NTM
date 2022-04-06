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
use work.ntm_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity ntm_top is
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

architecture ntm_top_architecture of ntm_top is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type top_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    CONTROLLER_STATE,                   -- STEP 1
    READ_HEADS_STATE,                   -- STEP 2
    WRITE_HEADS_STATE,                  -- STEP 3
    MEMORY_STATE                        -- STEP 4
    );

  type controller_ctrl_fsm is (
    STARTER_CONTROLLER_STATE,           -- STEP 0
    CONTROLLER_BODY_STATE,              -- STEP 1
    OUTPUT_VECTOR_STATE,                -- STEP 2
    INTERFACE_VECTOR_STATE              -- STEP 3
    );

  type write_heads_ctrl_fsm is (
    STARTER_WRITE_HEADS_STATE,          -- STEP 0
    WRITING_STATE,                      -- STEP 1
    ERASING_STATE                       -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal top_ctrl_fsm_int : top_ctrl_fsm;

  signal controller_ctrl_fsm_int  : controller_ctrl_fsm;
  signal write_heads_ctrl_fsm_int : write_heads_ctrl_fsm;

  -- Internal Signals
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_y_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_r_in_output_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_s_in_interface_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_l_in_interface_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

  -- READING
  -- CONTROL
  signal start_reading : std_logic;
  signal ready_reading : std_logic;

  signal m_in_j_enable_reading : std_logic;
  signal m_in_k_enable_reading : std_logic;

  signal w_in_enable_reading : std_logic;

  signal m_out_j_enable_reading : std_logic;
  signal m_out_k_enable_reading : std_logic;

  signal w_out_enable_reading : std_logic;

  signal r_out_enable_reading : std_logic;

  -- DATA
  signal size_n_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_reading : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal w_in_reading  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_reading  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_out_reading : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- WRITING
  -- CONTROL
  signal start_writing : std_logic;
  signal ready_writing : std_logic;

  signal m_in_j_enable_writing : std_logic;
  signal m_in_k_enable_writing : std_logic;

  signal w_in_enable_writing : std_logic;

  signal a_in_enable_writing : std_logic;

  signal w_out_enable_writing : std_logic;

  signal a_out_enable_writing : std_logic;

  signal m_out_j_enable_writing : std_logic;
  signal m_out_k_enable_writing : std_logic;

  -- DATA
  signal size_n_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_writing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal m_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal a_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_writing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_out_writing : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASING
  -- CONTROL
  signal start_erasing : std_logic;
  signal ready_erasing : std_logic;

  signal m_in_j_enable_erasing : std_logic;
  signal m_in_k_enable_erasing : std_logic;

  signal w_in_enable_erasing : std_logic;

  signal e_in_enable_erasing : std_logic;

  signal w_out_enable_erasing : std_logic;

  signal e_out_enable_erasing : std_logic;

  signal m_out_j_enable_erasing : std_logic;
  signal m_out_k_enable_erasing : std_logic;

  -- DATA
  signal size_n_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_erasing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal m_in_erasing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_erasing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_erasing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_out_erasing : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_in_enable_addressing : std_logic;
  signal s_in_enable_addressing : std_logic;

  signal k_out_enable_addressing : std_logic;
  signal s_out_enable_addressing : std_logic;

  signal m_in_j_enable_addressing : std_logic;
  signal m_in_k_enable_addressing : std_logic;

  signal m_out_j_enable_addressing : std_logic;
  signal m_out_k_enable_addressing : std_logic;

  signal w_in_enable_addressing  : std_logic;
  signal w_out_enable_addressing : std_logic;

  -- DATA
  signal size_n_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal g_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal s_in_addressing     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gamma_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_addressing  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      Y_OUT_ENABLE <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case top_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          Y_OUT_ENABLE <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Control Internal
            start_controller <= '1';

            -- FSM Control
            top_ctrl_fsm_int <= CONTROLLER_STATE;
          else
            -- Control Internal
            start_controller <= '0';
          end if;

        when CONTROLLER_STATE =>        -- STEP 1

          case controller_ctrl_fsm_int is
            when STARTER_CONTROLLER_STATE =>  -- STEP 0

            when CONTROLLER_BODY_STATE =>  -- STEP 1

              -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + b(l))
              -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(l))

            when OUTPUT_VECTOR_STATE =>  -- STEP 2

              -- y(t;y) = K(i;y;k)·r(t;i;k) + U(y;l)·h(t;l)

            when INTERFACE_VECTOR_STATE =>  -- STEP 3

              -- xi(t;?) = U(t;?;l)·h(t;l)

              -- k(t;k) = Wk(t;l;k)·h(t;l)
              -- beta(t) = Wbeta(t;l)·h(t;l)
              -- g(t) = Wg(t;l)·h(t;l)
              -- s(t;j) = Wk(t;l;j)·h(t;l)
              -- gamma(t) = Wgamma(t;l)·h(t;l)

            when others =>
              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_CONTROLLER_STATE;
          end case;

        when READ_HEADS_STATE =>        -- STEP 2

          -- r(t;k) = summation(w(t;j)·M(t;j;k))[j in 1 to N]

        when WRITE_HEADS_STATE =>       -- STEP 3

          case write_heads_ctrl_fsm_int is
            when STARTER_WRITE_HEADS_STATE =>  -- STEP 0

            when WRITING_STATE =>       -- STEP 1

              -- M(t;j;k) = M(t;j;k) + w(t;j)·a(t;k)

            when ERASING_STATE =>       -- STEP 2

              -- M(t;j;k) = M(t;j;k)·(1 - w(t;j)·e(t;k))

            when others =>
              -- FSM Control
              write_heads_ctrl_fsm_int <= STARTER_WRITE_HEADS_STATE;
          end case;

        when MEMORY_STATE =>            -- STEP 4

          -- wc(t;j) = C(M(t1;j;k),k(t;k),beta(t))

          -- wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)

          -- w(t;j) = wg(t;j)*s(t;k)

          -- w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]

          if (w_out_enable_addressing = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) then
              -- FSM Control
              top_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              top_ctrl_fsm_int <= CONTROLLER_STATE;
            end if;
          end if;

        when others =>
          -- FSM Control
          top_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- CONTROLLER
  w_in_l_enable_controller <= '0';
  w_in_x_enable_controller <= '0';

  k_in_i_enable_controller <= '0';
  k_in_l_enable_controller <= '0';
  k_in_k_enable_controller <= '0';

  b_in_enable_controller <= '0';

  x_in_enable_controller <= '0';

  r_in_i_enable_controller <= '0';
  r_in_k_enable_controller <= '0';

  w_out_l_enable_controller <= '0';
  w_out_x_enable_controller <= '0';

  k_out_i_enable_controller <= '0';
  k_out_l_enable_controller <= '0';
  k_out_k_enable_controller <= '0';

  b_out_enable_controller <= '0';

  h_out_enable_controller <= '0';

  -- OUTPUT VECTOR
  p_in_i_enable_output_vector <= '0';
  p_in_y_enable_output_vector <= '0';
  p_in_k_enable_output_vector <= '0';

  r_in_i_enable_output_vector <= '0';
  r_in_k_enable_output_vector <= '0';

  q_in_y_enable_output_vector <= '0';
  q_in_l_enable_output_vector <= '0';

  h_in_enable_output_vector <= '0';

  y_in_enable_output_vector <= '0';

  -- INTERFACE VECTOR
  -- Weight
  u_in_s_enable_interface_vector <= '0';
  u_in_l_enable_interface_vector <= '0';

  -- Hidden State
  h_in_enable_interface_vector <= '0';

  -- READING
  m_in_j_enable_reading <= '0';
  m_in_k_enable_reading <= '0';

  r_out_enable_reading <= '0';

  -- WRITING
  m_in_j_enable_writing <= '0';
  m_in_k_enable_writing <= '0';

  w_in_enable_writing <= '0';

  a_in_enable_writing <= '0';

  m_out_j_enable_writing <= '0';
  m_out_k_enable_writing <= '0';

  -- ERASING
  m_in_j_enable_erasing <= '0';
  m_in_k_enable_erasing <= '0';

  e_in_enable_erasing <= '0';

  m_out_j_enable_erasing <= '0';
  m_out_k_enable_erasing <= '0';

  -- ADDRESSING
  k_in_enable_addressing <= '0';
  s_in_enable_addressing <= '0';

  m_in_j_enable_addressing <= '0';
  m_in_k_enable_addressing <= '0';

  w_in_enable_addressing  <= '0';
  w_out_enable_addressing <= '0';

  -- DATA
  -- CONTROLLER
  size_x_in_controller <= FULL;
  size_w_in_controller <= FULL;
  size_l_in_controller <= FULL;
  size_r_in_controller <= FULL;

  w_in_controller <= FULL;
  k_in_controller <= FULL;
  b_in_controller <= FULL;

  x_in_controller <= FULL;
  r_in_controller <= FULL;

  w_out_controller <= FULL;
  k_out_controller <= FULL;
  b_out_controller <= FULL;

  h_out_controller <= FULL;

  -- OUTPUT VECTOR
  size_y_in_output_vector <= FULL;
  size_l_in_output_vector <= FULL;
  size_w_in_output_vector <= FULL;
  size_r_in_output_vector <= FULL;

  p_in_output_vector <= FULL;
  r_in_output_vector <= FULL;

  q_in_output_vector <= FULL;
  h_in_output_vector <= FULL;

  y_out_output_vector <= FULL;

  -- INTERFACE VECTOR
  size_s_in_interface_vector <= FULL;
  size_l_in_interface_vector <= FULL;

  u_in_interface_vector <= FULL;

  h_in_interface_vector <= FULL;

  -- READING
  size_n_in_reading <= FULL;
  size_w_in_reading <= FULL;

  w_in_reading  <= FULL;
  m_in_reading  <= FULL;
  r_out_reading <= FULL;

  -- WRITING
  size_n_in_writing <= FULL;
  size_w_in_writing <= FULL;

  m_in_writing  <= FULL;
  a_in_writing  <= FULL;
  w_in_writing  <= FULL;
  m_out_writing <= FULL;

  -- ERASING
  size_n_in_erasing <= FULL;
  size_w_in_erasing <= FULL;

  m_in_erasing <= FULL;
  e_in_erasing <= FULL;
  w_in_erasing <= FULL;

  m_out_erasing <= FULL;

  -- ADDRESSING
  size_n_in_addressing <= FULL;
  size_w_in_addressing <= FULL;

  k_in_addressing     <= FULL;
  beta_in_addressing  <= FULL;
  g_in_addressing     <= FULL;
  s_in_addressing     <= FULL;
  gamma_in_addressing <= FULL;

  m_in_addressing <= FULL;

  w_in_addressing  <= FULL;
  w_out_addressing <= FULL;

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  -- CONTROLLER
  controller : ntm_controller
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

      W_OUT => w_out_controller,
      D_OUT => d_out_controller,
      K_OUT => k_out_controller,
      U_OUT => u_out_controller,
      V_OUT => v_out_controller,
      B_OUT => b_out_controller,

      H_OUT => h_out_controller
      );

  -- OUTPUT VECTOR
  output_vector : ntm_output_vector
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
  interface_vector : ntm_interface_vector
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
  interface_matrix : ntm_interface_matrix
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

  -- READING
  reading : ntm_reading
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_reading,
      READY => ready_reading,

      M_IN_J_ENABLE => m_in_j_enable_reading,
      M_IN_K_ENABLE => m_in_k_enable_reading,

      W_IN_ENABLE => w_in_enable_reading,

      M_OUT_J_ENABLE => m_out_j_enable_reading,
      M_OUT_K_ENABLE => m_out_k_enable_reading,

      W_OUT_ENABLE => w_out_enable_reading,

      R_OUT_ENABLE => r_out_enable_reading,

      -- DATA
      SIZE_N_IN => size_n_in_reading,
      SIZE_W_IN => size_w_in_reading,

      W_IN  => w_in_reading,
      M_IN  => m_in_reading,
      R_OUT => r_out_reading
      );

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- WRITING
  writing : ntm_writing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_writing,
      READY => ready_writing,

      M_IN_J_ENABLE => m_in_j_enable_writing,
      M_IN_K_ENABLE => m_in_k_enable_writing,

      W_IN_ENABLE => w_in_enable_writing,

      A_IN_ENABLE => a_in_enable_writing,

      W_OUT_ENABLE => w_out_enable_writing,

      A_OUT_ENABLE => a_out_enable_writing,

      M_OUT_J_ENABLE => m_out_j_enable_writing,
      M_OUT_K_ENABLE => m_out_k_enable_writing,

      -- DATA
      SIZE_N_IN => size_n_in_writing,
      SIZE_W_IN => size_w_in_writing,

      M_IN  => m_in_writing,
      A_IN  => a_in_writing,
      W_IN  => w_in_writing,
      M_OUT => m_out_writing
      );

  -- ERASING
  erasing : ntm_erasing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erasing,
      READY => ready_erasing,

      M_IN_J_ENABLE => m_in_j_enable_erasing,
      M_IN_K_ENABLE => m_in_k_enable_erasing,

      W_IN_ENABLE => w_in_enable_erasing,

      E_IN_ENABLE => e_in_enable_erasing,

      W_OUT_ENABLE => w_out_enable_erasing,

      E_OUT_ENABLE => e_out_enable_erasing,

      M_OUT_J_ENABLE => m_out_j_enable_erasing,
      M_OUT_K_ENABLE => m_out_k_enable_erasing,

      -- DATA
      SIZE_N_IN => size_n_in_erasing,
      SIZE_W_IN => size_w_in_erasing,

      M_IN  => m_in_erasing,
      E_IN  => e_in_erasing,
      W_IN  => w_in_erasing,
      M_OUT => m_out_erasing
      );

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- ADDRESSING
  addressing : ntm_addressing
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

      K_IN_ENABLE => k_in_enable_addressing,
      S_IN_ENABLE => s_in_enable_addressing,

      K_OUT_ENABLE => k_out_enable_addressing,
      S_OUT_ENABLE => s_out_enable_addressing,

      M_IN_J_ENABLE => m_in_j_enable_addressing,
      M_IN_K_ENABLE => m_in_k_enable_addressing,

      M_OUT_J_ENABLE => m_out_j_enable_addressing,
      M_OUT_K_ENABLE => m_out_k_enable_addressing,

      W_IN_ENABLE  => w_in_enable_addressing,
      W_OUT_ENABLE => w_out_enable_addressing,

      -- DATA
      SIZE_N_IN => size_n_in_addressing,
      SIZE_W_IN => size_w_in_addressing,

      K_IN     => k_in_addressing,
      BETA_IN  => beta_in_addressing,
      G_IN     => g_in_addressing,
      S_IN     => s_in_addressing,
      GAMMA_IN => gamma_in_addressing,

      M_IN => m_in_addressing,

      W_IN  => w_in_addressing,
      W_OUT => w_out_addressing
      );

end architecture;
