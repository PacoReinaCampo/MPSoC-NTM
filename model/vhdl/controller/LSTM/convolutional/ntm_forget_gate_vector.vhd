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
use work.ntm_lstm_controller_pkg.all;

entity ntm_forget_gate_vector is
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

    D_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    D_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    D_IN_M_ENABLE : in std_logic;       -- for m in 0 to M-1

    D_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    D_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    D_OUT_M_ENABLE : out std_logic;     -- for m in 0 to M-1

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    V_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    V_IN_S_ENABLE : in std_logic;       -- for s in 0 to S-1

    V_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    V_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    RHO_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
    RHO_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

    RHO_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
    RHO_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

    XI_IN_ENABLE : in std_logic;        -- for s in 0 to S-1

    XI_OUT_ENABLE : out std_logic;      -- for s in 0 to S-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    F_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

    F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_forget_gate_vector_architecture of ntm_forget_gate_vector is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X],   X_IN   [X]
  -- K_IN [R,L,W], R_IN   [R,W]
  -- D_IN [R,L,M], RHO_IN [R,M]
  -- V_IN [L,S],   XI_IN  [S]
  -- U_IN [L,L],   H_IN   [L]
  -- B_IN [L]

  -- Outputs:
  -- F_OUT [L]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE
  -- INPUT_X_STATE, CLEAN_IN_X_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_I_STATE,                -- STEP 1
    INPUT_FIRST_J_STATE,                -- STEP 2
    CLEAN_FIRST_I_STATE,                -- STEP 3
    CLEAN_FIRST_J_STATE,                -- STEP 4
    INPUT_SECOND_I_STATE,               -- STEP 5
    INPUT_SECOND_J_STATE,               -- STEP 6
    CLEAN_SECOND_I_STATE,               -- STEP 7
    CLEAN_SECOND_J_STATE,               -- STEP 8
    INPUT_THIRD_I_STATE,                -- STEP 9
    INPUT_THIRD_J_STATE,                -- STEP 10
    INPUT_THIRD_K_STATE,                -- STEP 11
    CLEAN_THIRD_I_STATE,                -- STEP 12
    CLEAN_THIRD_J_STATE,                -- STEP 13
    CLEAN_THIRD_K_STATE,                -- STEP 14
    INPUT_FOURTH_STATE,                 -- STEP 15
    CLEAN_FOURTH_STATE                  -- STEP 16
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Buffer
  signal matrix_w_int : matrix_buffer;
  signal tensor_k_int : tensor_buffer;
  signal matrix_u_int : matrix_buffer;
  signal matrix_v_int : matrix_buffer;
  signal tensor_d_int : tensor_buffer;
  signal vector_b_int : vector_buffer;

  signal vector_x_int   : vector_buffer;
  signal matrix_r_int   : matrix_buffer;
  signal vector_xi_int  : vector_buffer;
  signal matrix_rho_int : matrix_buffer;

  signal vector_h_int : vector_buffer;

  signal vector_out_int : vector_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_k_in_i_int : std_logic;
  signal data_k_in_j_int : std_logic;
  signal data_k_in_k_int : std_logic;
  signal data_d_in_i_int : std_logic;
  signal data_d_in_j_int : std_logic;
  signal data_d_in_k_int : std_logic;
  signal data_m_in_i_int : std_logic;
  signal data_m_in_j_int : std_logic;
  signal data_u_in_i_int : std_logic;
  signal data_u_in_j_int : std_logic;
  signal data_v_in_i_int : std_logic;
  signal data_v_in_j_int : std_logic;
  signal data_w_in_int   : std_logic;

  signal data_x_in_int  : std_logic;
  signal data_xi_in_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      F_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_L_ENABLE <= '0';
      W_OUT_X_ENABLE <= '0';

      K_OUT_I_ENABLE <= '0';
      K_OUT_L_ENABLE <= '0';
      K_OUT_K_ENABLE <= '0';

      U_OUT_L_ENABLE <= '0';
      U_OUT_P_ENABLE <= '0';

      V_OUT_L_ENABLE <= '0';
      V_OUT_S_ENABLE <= '0';

      B_OUT_ENABLE <= '0';

      X_OUT_ENABLE <= '0';

      F_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          F_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          F_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            B_OUT_ENABLE <= '1';

            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          else
            -- Control Outputs
            W_OUT_L_ENABLE <= '0';
            W_OUT_X_ENABLE <= '0';

            K_OUT_I_ENABLE <= '0';
            K_OUT_L_ENABLE <= '0';
            K_OUT_K_ENABLE <= '0';

            U_OUT_L_ENABLE <= '0';
            U_OUT_P_ENABLE <= '0';

            V_OUT_L_ENABLE <= '0';
            V_OUT_S_ENABLE <= '0';

            B_OUT_ENABLE <= '0';

            X_OUT_ENABLE <= '0';
          end if;

        when INPUT_FIRST_I_STATE =>     -- STEP 1 W,b

          if ((W_IN_L_ENABLE = '1') and (W_IN_X_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= W_IN;

            -- Control Internal
            data_m_in_i_int <= '1';
            data_m_in_j_int <= '1';
          end if;

          if (B_IN_ENABLE = '1') then
            -- Data Inputs
            vector_b_int(to_integer(unsigned(index_i_loop))) <= B_IN;

            -- Control Internal
            data_w_in_int <= '1';
          end if;

          -- Control Outputs
          W_OUT_L_ENABLE <= '0';
          W_OUT_X_ENABLE <= '0';
          B_OUT_ENABLE   <= '0';

          if (data_m_in_i_int = '1' and data_m_in_j_int = '1' and data_w_in_int = '1') then
            -- Control Internal
            data_m_in_i_int <= '0';
            data_m_in_j_int <= '0';
            data_w_in_int   <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_FIRST_J_STATE;
          end if;

        when INPUT_FIRST_J_STATE =>     -- STEP 2 W,b

          if (W_IN_X_ENABLE = '1') then
            -- Data Inputs
            matrix_w_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_FIRST_I_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_FIRST_J_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';

        when CLEAN_FIRST_I_STATE =>     -- STEP 3

          if ((unsigned(index_i_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';
            B_OUT_ENABLE   <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';
            B_OUT_ENABLE   <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          end if;

        when CLEAN_FIRST_J_STATE =>     -- STEP 4

          if (unsigned(index_j_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_J_STATE;
          end if;

        when INPUT_SECOND_I_STATE =>    -- STEP 5 U,V

          if ((U_IN_L_ENABLE = '1') and (U_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_u_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= U_IN;

            -- Control Internal
            data_u_in_i_int <= '1';
            data_u_in_j_int <= '1';
          end if;

          if ((V_IN_L_ENABLE = '1') and (V_IN_S_ENABLE = '1')) then
            -- Data Inputs
            matrix_v_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= V_IN;

            -- Control Internal
            data_v_in_i_int <= '1';
            data_v_in_j_int <= '1';
          end if;

          -- Control Outputs
          U_OUT_L_ENABLE <= '0';
          U_OUT_P_ENABLE <= '0';

          V_OUT_L_ENABLE <= '0';
          V_OUT_S_ENABLE <= '0';

          if (data_u_in_i_int = '1' and data_u_in_j_int = '1' and data_v_in_i_int = '1' and data_v_in_j_int = '1') then
            -- Control Internal
            data_u_in_i_int <= '0';
            data_u_in_j_int <= '0';

            data_v_in_i_int <= '0';
            data_v_in_j_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

        when INPUT_SECOND_J_STATE =>    -- STEP 6 U,V

          if (U_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_u_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= U_IN;

            -- Control Internal
            data_u_in_j_int <= '1';
          end if;

          if (V_IN_S_ENABLE = '1') then
            -- Data Inputs
            matrix_v_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= V_IN;

            -- Control Internal
            data_v_in_j_int <= '1';
          end if;

          -- Control Outputs
          U_OUT_P_ENABLE <= '0';

          V_OUT_S_ENABLE <= '0';

          if (data_u_in_j_int = '1' and data_v_in_j_int = '1') then
            -- Control Internal
            data_u_in_j_int <= '0';
            data_v_in_j_int <= '0';

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_SECOND_I_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
            end if;
          end if;

        when CLEAN_SECOND_I_STATE =>    -- STEP 7

          if ((unsigned(index_i_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          end if;

        when CLEAN_SECOND_J_STATE =>    -- STEP 8

          if (unsigned(index_j_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            U_OUT_P_ENABLE <= '1';

            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
          end if;

        when INPUT_THIRD_I_STATE =>     -- STEP 9 K,D

          if ((K_IN_I_ENABLE = '1') and (K_IN_L_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_k_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= K_IN;

            -- Control Internal
            data_k_in_i_int <= '1';
            data_k_in_j_int <= '1';
            data_k_in_k_int <= '1';
          end if;

          if ((D_IN_I_ENABLE = '1') and (D_IN_L_ENABLE = '1') and (D_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_d_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= D_IN;

            -- Control Internal
            data_d_in_i_int <= '1';
            data_d_in_j_int <= '1';
            data_d_in_k_int <= '1';
          end if;

          -- Control Outputs
          K_OUT_I_ENABLE <= '0';
          K_OUT_L_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

          D_OUT_I_ENABLE <= '0';
          D_OUT_L_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

          if (data_k_in_i_int = '1' and data_k_in_j_int = '1' and data_k_in_k_int = '1' and data_d_in_i_int = '1' and data_d_in_j_int = '1' and data_d_in_k_int = '1') then
            -- Control Internal
            data_k_in_i_int <= '0';
            data_k_in_j_int <= '0';
            data_k_in_k_int <= '0';

            data_d_in_i_int <= '0';
            data_d_in_j_int <= '0';
            data_d_in_k_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

        when INPUT_THIRD_J_STATE =>     -- STEP 10 K,D

          if ((K_IN_L_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_k_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= K_IN;

            -- Control Internal
            data_k_in_j_int <= '1';
            data_k_in_k_int <= '1';
          end if;

          if ((D_IN_L_ENABLE = '1') and (D_IN_M_ENABLE = '1')) then
            -- Data Inputs
            tensor_d_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= D_IN;

            -- Control Internal
            data_d_in_j_int <= '1';
            data_d_in_k_int <= '1';
          end if;

          -- Control Outputs
          K_OUT_L_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

          D_OUT_L_ENABLE <= '0';
          D_OUT_M_ENABLE <= '0';

          if (data_k_in_j_int = '1' and data_k_in_k_int = '1' and data_d_in_j_int = '1' and data_d_in_k_int = '1') then
            -- Control Internal
            data_k_in_j_int <= '0';
            data_k_in_k_int <= '0';

            data_d_in_j_int <= '0';
            data_d_in_k_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

        when INPUT_THIRD_K_STATE =>     -- STEP 11 K,D

          if (K_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_k_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= K_IN;

            -- Control Internal
            data_k_in_k_int <= '1';
          end if;

          if (D_IN_M_ENABLE = '1') then
            -- Data Inputs
            tensor_d_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= D_IN;

            -- Control Internal
            data_d_in_k_int <= '1';
          end if;

          -- Control Outputs
          K_OUT_K_ENABLE <= '0';

          D_OUT_M_ENABLE <= '0';

          if (data_k_in_k_int = '1' and data_d_in_k_int = '1') then
            -- Control Internal
            data_k_in_k_int <= '0';

            data_d_in_k_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

        when CLEAN_THIRD_I_STATE =>     -- STEP 12

          if ((unsigned(index_i_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_FOURTH_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop)+unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          end if;

        when CLEAN_THIRD_J_STATE =>     -- STEP 13

          if ((unsigned(index_j_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_L_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop)+unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_J_STATE;
          end if;

        when CLEAN_THIRD_K_STATE =>     -- STEP 14

          if (unsigned(index_k_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_loop <= std_logic_vector(unsigned(index_k_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_K_STATE;
          end if;

        when INPUT_FOURTH_STATE =>      -- STEP 15 x,xi

          if (X_IN_ENABLE = '1') then
            -- Data Inputs
            vector_x_int(to_integer(unsigned(index_i_loop))) <= X_IN;

            -- Control Internal
            data_x_in_int <= '1';
          end if;

          if (XI_IN_ENABLE = '1') then
            -- Data Inputs
            vector_xi_int(to_integer(unsigned(index_i_loop))) <= XI_IN;

            -- Control Internal
            data_xi_in_int <= '1';
          end if;

          if (data_x_in_int = '1' and data_xi_in_int = '1') then
            -- Control Internal
            data_x_in_int <= '0';

            data_xi_in_int <= '0';

            -- Data Internal
            vector_out_int <= function_ntm_forget_standard_gate_vector (
              SIZE_X_IN => SIZE_X_IN,
              SIZE_W_IN => SIZE_W_IN,
              SIZE_L_IN => SIZE_L_IN,
              SIZE_R_IN => SIZE_R_IN,
              SIZE_S_IN => SIZE_S_IN,
              SIZE_M_IN => SIZE_M_IN,

              matrix_w_input => matrix_w_int,
              tensor_k_input => tensor_k_int,
              matrix_u_input => matrix_u_int,
              matrix_v_input => matrix_v_int,
              tensor_d_input => tensor_d_int,
              vector_b_input => vector_b_int,

              vector_x_input   => vector_x_int,
              matrix_r_input   => matrix_r_int,
              vector_xi_input  => vector_xi_int,
              matrix_rho_input => matrix_rho_int,
              vector_h_input   => vector_h_int
              );

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

          -- Control Outputs
          F_OUT_ENABLE <= '0';

          X_OUT_ENABLE <= '0';

          XI_OUT_ENABLE <= '0';

        when CLEAN_FOURTH_STATE =>      -- STEP 16

          if (unsigned(index_i_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            F_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            READY <= '1';

            F_OUT_ENABLE <= '1';

            X_OUT_ENABLE <= '1';

            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_i_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            F_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            F_OUT_ENABLE <= '1';

            X_OUT_ENABLE <= '1';

            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FOURTH_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
