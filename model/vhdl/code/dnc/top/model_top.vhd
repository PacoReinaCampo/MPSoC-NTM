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
use work.model_dnc_core_pkg.all;

entity model_top is
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

architecture model_top_architecture of model_top is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X],  X_IN [X]
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

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

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

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

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

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

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
            -- Control Internal
            vector_y_out_int <= function_model_top (
              SIZE_T_IN => THREE_CONTROL,
              SIZE_X_IN => SIZE_X_IN,
              SIZE_Y_IN => SIZE_Y_IN,
              SIZE_N_IN => SIZE_N_IN,
              SIZE_W_IN => SIZE_W_IN,
              SIZE_L_IN => SIZE_L_IN,
              SIZE_R_IN => SIZE_R_IN,

              matrix_w_input => matrix_w_in_int,
              tensor_k_input => tensor_k_in_int,
              matrix_u_input => matrix_u_in_int,
              matrix_v_input => matrix_v_in_int,
              tensor_d_input => tensor_d_in_int,
              vector_b_input => vector_b_in_int,

              vector_x_input => vector_x_in_int,

              tensor_p_input => tensor_p_in_int,
              matrix_q_input => matrix_q_in_int
              );

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

end architecture;
