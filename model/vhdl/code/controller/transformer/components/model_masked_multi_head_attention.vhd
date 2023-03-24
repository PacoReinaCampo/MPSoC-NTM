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

entity model_masked_multi_head_attention is
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

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_masked_multi_head_attention_architecture of model_masked_multi_head_attention is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X],   X_IN   [X]
  -- K_IN [R,L,W], R_IN   [R,W]
  -- D_IN [R,L,M], RHO_IN [R,M]
  -- V_IN [L,S],   XI_IN  [S]
  -- U_IN [L,L],   H_IN   [L]
  -- B_IN [L]

  -- Outputs:
  -- H_OUT [L]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE
  -- INPUT_X_STATE, CLEAN_IN_X_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type masked_multi_head_attention_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_L_STATE,                 -- STEP 1
    INPUT_W_IN_X_STATE,                 -- STEP 2
    CLEAN_W_IN_L_STATE,                 -- STEP 3
    CLEAN_W_IN_X_STATE                  -- STEP 4
    );

  type masked_multi_head_attention_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_L_STATE,                 -- STEP 2
    INPUT_K_IN_K_STATE,                 -- STEP 3
    CLEAN_K_IN_I_STATE,                 -- STEP 4
    CLEAN_K_IN_L_STATE,                 -- STEP 5
    CLEAN_K_IN_K_STATE                  -- STEP 6
    );

  type masked_multi_head_attention_u_in_fsm is (
    STARTER_U_IN_STATE,                 -- STEP 0
    INPUT_U_IN_L_STATE,                 -- STEP 1
    INPUT_U_IN_P_STATE,                 -- STEP 2
    CLEAN_U_IN_L_STATE,                 -- STEP 3
    CLEAN_U_IN_P_STATE                  -- STEP 4
    );

  type masked_multi_head_attention_v_in_fsm is (
    STARTER_V_IN_STATE,                 -- STEP 0
    INPUT_V_IN_L_STATE,                 -- STEP 1
    INPUT_V_IN_S_STATE,                 -- STEP 2
    CLEAN_V_IN_L_STATE,                 -- STEP 3
    CLEAN_V_IN_S_STATE                  -- STEP 4
    );

  type masked_multi_head_attention_d_in_fsm is (
    STARTER_D_IN_STATE,                 -- STEP 0
    INPUT_D_IN_I_STATE,                 -- STEP 1
    INPUT_D_IN_L_STATE,                 -- STEP 2
    INPUT_D_IN_M_STATE,                 -- STEP 3
    CLEAN_D_IN_I_STATE,                 -- STEP 4
    CLEAN_D_IN_L_STATE,                 -- STEP 5
    CLEAN_D_IN_M_STATE                  -- STEP 6
    );

  type masked_multi_head_attention_b_in_fsm is (
    STARTER_B_IN_STATE,                 -- STEP 0
    INPUT_B_IN_L_STATE,                 -- STEP 1
    CLEAN_B_IN_L_STATE                  -- STEP 2
    );

  type masked_multi_head_attention_x_in_fsm is (
    STARTER_X_IN_STATE,                 -- STEP 0
    INPUT_X_IN_X_STATE,                 -- STEP 1
    CLEAN_X_IN_X_STATE                  -- STEP 2
    );

  type masked_multi_head_attention_r_in_fsm is (
    STARTER_R_IN_STATE,                 -- STEP 0
    INPUT_R_IN_I_STATE,                 -- STEP 1
    INPUT_R_IN_K_STATE,                 -- STEP 2
    CLEAN_R_IN_I_STATE,                 -- STEP 3
    CLEAN_R_IN_K_STATE                  -- STEP 4
    );

  type masked_multi_head_attention_rho_in_fsm is (
    STARTER_RHO_IN_STATE,               -- STEP 0
    INPUT_RHO_IN_I_STATE,               -- STEP 1
    INPUT_RHO_IN_M_STATE,               -- STEP 2
    CLEAN_RHO_IN_I_STATE,               -- STEP 3
    CLEAN_RHO_IN_M_STATE                -- STEP 4
    );

  type masked_multi_head_attention_xi_in_fsm is (
    STARTER_XI_IN_STATE,                -- STEP 0
    INPUT_XI_IN_S_STATE,                -- STEP 1
    CLEAN_XI_IN_S_STATE                 -- STEP 2
    );

  type masked_multi_head_attention_h_in_fsm is (
    STARTER_H_IN_STATE,                 -- STEP 0
    CLEAN_H_IN_L_STATE,                 -- STEP 1
    INPUT_H_IN_L_STATE                  -- STEP 2
    );

  type masked_multi_head_attention_h_out_fsm is (
    STARTER_H_OUT_STATE,                -- STEP 0
    CLEAN_H_OUT_L_STATE,                -- STEP 1
    OUTPUT_H_OUT_L_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal masked_multi_head_attention_w_in_fsm_int : masked_multi_head_attention_w_in_fsm;
  signal masked_multi_head_attention_k_in_fsm_int : masked_multi_head_attention_k_in_fsm;
  signal masked_multi_head_attention_u_in_fsm_int : masked_multi_head_attention_u_in_fsm;
  signal masked_multi_head_attention_v_in_fsm_int : masked_multi_head_attention_v_in_fsm;
  signal masked_multi_head_attention_d_in_fsm_int : masked_multi_head_attention_d_in_fsm;
  signal masked_multi_head_attention_b_in_fsm_int : masked_multi_head_attention_b_in_fsm;

  signal masked_multi_head_attention_x_in_fsm_int   : masked_multi_head_attention_x_in_fsm;
  signal masked_multi_head_attention_r_in_fsm_int   : masked_multi_head_attention_r_in_fsm;
  signal masked_multi_head_attention_xi_in_fsm_int  : masked_multi_head_attention_xi_in_fsm;
  signal masked_multi_head_attention_rho_in_fsm_int : masked_multi_head_attention_rho_in_fsm;
  signal masked_multi_head_attention_h_in_fsm_int   : masked_multi_head_attention_h_in_fsm;

  signal masked_multi_head_attention_h_out_fsm_int : masked_multi_head_attention_h_out_fsm;

  -- Buffer
  signal matrix_w_in_int : matrix_buffer;
  signal tensor_k_in_int : tensor_buffer;
  signal matrix_u_in_int : matrix_buffer;
  signal matrix_v_in_int : matrix_buffer;
  signal tensor_d_in_int : tensor_buffer;
  signal vector_b_in_int : vector_buffer;

  signal vector_x_in_int   : vector_buffer;
  signal matrix_r_in_int   : matrix_buffer;
  signal vector_xi_in_int  : vector_buffer;
  signal matrix_rho_in_int : matrix_buffer;
  signal vector_h_in_int   : vector_buffer;

  signal vector_h_out_int : vector_buffer;

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

  signal index_i_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_s_xi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_h_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_w_in_enable_int : std_logic;
  signal data_k_in_enable_int : std_logic;
  signal data_u_in_enable_int : std_logic;
  signal data_v_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;

  signal data_x_in_enable_int   : std_logic;
  signal data_r_in_enable_int   : std_logic;
  signal data_xi_in_enable_int  : std_logic;
  signal data_rho_in_enable_int : std_logic;
  signal data_h_in_enable_int   : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

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

      case masked_multi_head_attention_w_in_fsm_int is
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
            masked_multi_head_attention_w_in_fsm_int <= INPUT_W_IN_X_STATE;
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
            masked_multi_head_attention_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
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
              masked_multi_head_attention_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
            else
              masked_multi_head_attention_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
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
            masked_multi_head_attention_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_x_w_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= std_logic_vector(unsigned(index_x_w_in_loop) + unsigned(ONE_CONTROL));
            index_l_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          end if;

        when CLEAN_W_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_w_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= std_logic_vector(unsigned(index_l_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_w_in_fsm_int <= INPUT_W_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_w_in_fsm_int <= STARTER_W_IN_STATE;
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

      case masked_multi_head_attention_k_in_fsm_int is
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
            masked_multi_head_attention_k_in_fsm_int <= INPUT_K_IN_L_STATE;
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
            masked_multi_head_attention_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
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
              masked_multi_head_attention_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              masked_multi_head_attention_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
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
              masked_multi_head_attention_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            elsif (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              masked_multi_head_attention_k_in_fsm_int <= CLEAN_K_IN_L_STATE;
            else
              masked_multi_head_attention_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
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
            masked_multi_head_attention_k_in_fsm_int <= STARTER_K_IN_STATE;
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
            masked_multi_head_attention_k_in_fsm_int <= INPUT_K_IN_I_STATE;
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
            masked_multi_head_attention_k_in_fsm_int <= INPUT_K_IN_L_STATE;
          end if;

        when CLEAN_K_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_k_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_in_loop <= std_logic_vector(unsigned(index_k_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_k_in_fsm_int <= INPUT_K_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_k_in_fsm_int <= STARTER_K_IN_STATE;
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

      case masked_multi_head_attention_u_in_fsm_int is
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
            masked_multi_head_attention_u_in_fsm_int <= INPUT_U_IN_L_STATE;
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
            masked_multi_head_attention_u_in_fsm_int <= CLEAN_U_IN_P_STATE;
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
              masked_multi_head_attention_u_in_fsm_int <= CLEAN_U_IN_L_STATE;
            else
              masked_multi_head_attention_u_in_fsm_int <= CLEAN_U_IN_P_STATE;
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
            masked_multi_head_attention_u_in_fsm_int <= STARTER_U_IN_STATE;
          elsif ((unsigned(index_l_u_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_u_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            U_OUT_L_ENABLE <= '1';
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_l_u_in_loop <= std_logic_vector(unsigned(index_l_u_in_loop) + unsigned(ONE_CONTROL));
            index_p_u_in_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_u_in_fsm_int <= INPUT_U_IN_L_STATE;
          end if;

        when CLEAN_U_IN_P_STATE =>      -- STEP 4

          if (unsigned(index_p_u_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            U_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_u_in_loop <= std_logic_vector(unsigned(index_p_u_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_u_in_fsm_int <= INPUT_U_IN_P_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_u_in_fsm_int <= STARTER_U_IN_STATE;
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

      case masked_multi_head_attention_v_in_fsm_int is
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
            masked_multi_head_attention_v_in_fsm_int <= INPUT_V_IN_L_STATE;
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
            masked_multi_head_attention_v_in_fsm_int <= CLEAN_V_IN_S_STATE;
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
              masked_multi_head_attention_v_in_fsm_int <= CLEAN_V_IN_L_STATE;
            else
              masked_multi_head_attention_v_in_fsm_int <= CLEAN_V_IN_S_STATE;
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
            masked_multi_head_attention_v_in_fsm_int <= STARTER_V_IN_STATE;
          elsif ((unsigned(index_l_v_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_s_v_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            V_OUT_L_ENABLE <= '1';
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_l_v_in_loop <= std_logic_vector(unsigned(index_l_v_in_loop) + unsigned(ONE_CONTROL));
            index_s_v_in_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_v_in_fsm_int <= INPUT_V_IN_L_STATE;
          end if;

        when CLEAN_V_IN_S_STATE =>      -- STEP 4

          if (unsigned(index_s_v_in_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_S_ENABLE <= '1';

            -- Control Internal
            index_s_v_in_loop <= std_logic_vector(unsigned(index_s_v_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_v_in_fsm_int <= INPUT_V_IN_S_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_v_in_fsm_int <= STARTER_V_IN_STATE;
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

      case masked_multi_head_attention_d_in_fsm_int is
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
            masked_multi_head_attention_d_in_fsm_int <= INPUT_D_IN_L_STATE;
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
            masked_multi_head_attention_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
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
            if (unsigned(index_m_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              masked_multi_head_attention_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            else
              masked_multi_head_attention_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
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
            if ((unsigned(index_l_d_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
              masked_multi_head_attention_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            elsif (unsigned(index_m_d_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              masked_multi_head_attention_d_in_fsm_int <= CLEAN_D_IN_L_STATE;
            else
              masked_multi_head_attention_d_in_fsm_int <= CLEAN_D_IN_M_STATE;
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
            masked_multi_head_attention_d_in_fsm_int <= STARTER_D_IN_STATE;
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
            masked_multi_head_attention_d_in_fsm_int <= INPUT_D_IN_I_STATE;
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
            masked_multi_head_attention_d_in_fsm_int <= INPUT_D_IN_L_STATE;
          end if;

        when CLEAN_D_IN_M_STATE =>      -- STEP 4

          if (unsigned(index_m_d_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            D_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_d_in_loop <= std_logic_vector(unsigned(index_m_d_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_d_in_fsm_int <= INPUT_D_IN_M_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_d_in_fsm_int <= STARTER_D_IN_STATE;
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

      case masked_multi_head_attention_b_in_fsm_int is
        when STARTER_B_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';

            -- FSM Control
            masked_multi_head_attention_b_in_fsm_int <= INPUT_B_IN_L_STATE;
          else
            -- Control Outputs
            B_OUT_ENABLE <= '0';
          end if;

        when INPUT_B_IN_L_STATE =>      -- STEP 1

          if (B_IN_ENABLE = '1') then
            -- Data Inputs
            vector_b_in_int(to_integer(unsigned(index_l_b_in_loop))) <= B_IN;

            -- FSM Control
            masked_multi_head_attention_b_in_fsm_int <= CLEAN_B_IN_L_STATE;
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
            masked_multi_head_attention_b_in_fsm_int <= STARTER_B_IN_STATE;
          elsif (unsigned(index_l_b_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_b_in_loop <= std_logic_vector(unsigned(index_l_b_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_b_in_fsm_int <= INPUT_B_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_b_in_fsm_int <= STARTER_B_IN_STATE;
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

      case masked_multi_head_attention_x_in_fsm_int is
        when STARTER_X_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '0';

            -- FSM Control
            masked_multi_head_attention_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          else
            -- Control Outputs
            X_OUT_ENABLE <= '0';
          end if;

        when INPUT_X_IN_X_STATE =>      -- STEP 1

          if (X_IN_ENABLE = '1') then
            -- Data Inputs
            vector_x_in_int(to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            masked_multi_head_attention_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
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
            masked_multi_head_attention_x_in_fsm_int <= STARTER_X_IN_STATE;
          elsif (unsigned(index_x_x_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= std_logic_vector(unsigned(index_x_x_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_x_in_fsm_int <= STARTER_X_IN_STATE;
      end case;
    end if;
  end process;

  r_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_r_in_loop <= ZERO_CONTROL;
      index_k_r_in_loop <= ZERO_CONTROL;

      data_r_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case masked_multi_head_attention_r_in_fsm_int is
        when STARTER_R_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '0';

            -- FSM Control
            masked_multi_head_attention_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          else
            -- Control Outputs
            R_OUT_I_ENABLE <= '0';
            R_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_R_IN_I_STATE =>      -- STEP 1

          if ((R_IN_I_ENABLE = '1') and (R_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_r_in_int(to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            masked_multi_head_attention_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
          end if;

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

        when INPUT_R_IN_K_STATE =>      -- STEP 2

          if (R_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_r_in_int(to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            if (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              masked_multi_head_attention_r_in_fsm_int <= CLEAN_R_IN_I_STATE;
            else
              masked_multi_head_attention_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

        when CLEAN_R_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_r_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '1';

            -- FSM Control
            masked_multi_head_attention_r_in_fsm_int <= STARTER_R_IN_STATE;
          elsif ((unsigned(index_i_r_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= std_logic_vector(unsigned(index_i_r_in_loop) + unsigned(ONE_CONTROL));
            index_k_r_in_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          end if;

        when CLEAN_R_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_r_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_in_loop <= std_logic_vector(unsigned(index_k_r_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_r_in_fsm_int <= INPUT_R_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_r_in_fsm_int <= STARTER_R_IN_STATE;
      end case;
    end if;
  end process;

  rho_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      RHO_OUT_I_ENABLE <= '0';
      RHO_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_i_rho_in_loop <= ZERO_CONTROL;
      index_m_rho_in_loop <= ZERO_CONTROL;

      data_rho_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case masked_multi_head_attention_rho_in_fsm_int is
        when STARTER_RHO_IN_STATE =>    -- STEP 0
          if (START = '1') then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '0';

            -- FSM Control
            masked_multi_head_attention_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          else
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '0';
            RHO_OUT_M_ENABLE <= '0';
          end if;

        when INPUT_RHO_IN_I_STATE =>    -- STEP 1

          if ((RHO_IN_I_ENABLE = '1') and (RHO_IN_M_ENABLE = '1')) then
            -- Data Inputs
            matrix_rho_in_int(to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            masked_multi_head_attention_rho_in_fsm_int <= CLEAN_RHO_IN_M_STATE;
          end if;

          -- Control Outputs
          RHO_OUT_I_ENABLE <= '0';
          RHO_OUT_M_ENABLE <= '0';

        when INPUT_RHO_IN_M_STATE =>    -- STEP 2

          if (RHO_IN_M_ENABLE = '1') then
            -- Data Inputs
            matrix_rho_in_int(to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            if (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
              masked_multi_head_attention_rho_in_fsm_int <= CLEAN_RHO_IN_I_STATE;
            else
              masked_multi_head_attention_rho_in_fsm_int <= CLEAN_RHO_IN_M_STATE;
            end if;
          end if;

          -- Control Outputs
          RHO_OUT_M_ENABLE <= '0';

        when CLEAN_RHO_IN_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_rho_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '1';

            -- FSM Control
            masked_multi_head_attention_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
          elsif ((unsigned(index_i_rho_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= std_logic_vector(unsigned(index_i_rho_in_loop) + unsigned(ONE_CONTROL));
            index_m_rho_in_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          end if;

        when CLEAN_RHO_IN_M_STATE =>    -- STEP 4

          if (unsigned(index_m_rho_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_rho_in_loop <= std_logic_vector(unsigned(index_m_rho_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_rho_in_fsm_int <= INPUT_RHO_IN_M_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
      end case;
    end if;
  end process;

  xi_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      XI_OUT_ENABLE <= '0';

      -- Control Internal
      index_s_xi_in_loop <= ZERO_CONTROL;

      data_xi_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case masked_multi_head_attention_xi_in_fsm_int is
        when STARTER_XI_IN_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Outputs
            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '0';

            -- FSM Control
            masked_multi_head_attention_xi_in_fsm_int <= INPUT_XI_IN_S_STATE;
          else
            -- Control Outputs
            XI_OUT_ENABLE <= '0';
          end if;

        when INPUT_XI_IN_S_STATE =>     -- STEP 1

          if (XI_IN_ENABLE = '1') then
            -- Data Inputs
            vector_xi_in_int(to_integer(unsigned(index_s_xi_in_loop))) <= XI_IN;

            -- FSM Control
            masked_multi_head_attention_xi_in_fsm_int <= CLEAN_XI_IN_S_STATE;
          end if;

          -- Control Outputs
          XI_OUT_ENABLE <= '0';

        when CLEAN_XI_IN_S_STATE =>     -- STEP 2

          if (unsigned(index_s_xi_in_loop) = unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '1';

            -- FSM Control
            masked_multi_head_attention_xi_in_fsm_int <= STARTER_XI_IN_STATE;
          elsif (unsigned(index_s_xi_in_loop) < unsigned(SIZE_S_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            XI_OUT_ENABLE <= '1';

            -- Control Internal
            index_s_xi_in_loop <= std_logic_vector(unsigned(index_s_xi_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_xi_in_fsm_int <= INPUT_XI_IN_S_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_xi_in_fsm_int <= STARTER_XI_IN_STATE;
      end case;
    end if;
  end process;

  h_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_in_loop <= ZERO_CONTROL;

      data_h_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case masked_multi_head_attention_h_in_fsm_int is
        when STARTER_H_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '0';

            -- FSM Control
            masked_multi_head_attention_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          else
            -- Control Outputs
            H_OUT_ENABLE <= '0';
          end if;

        when INPUT_H_IN_L_STATE =>      -- STEP 1

          if (H_IN_ENABLE = '1') then
            -- Data Inputs
            vector_h_in_int(to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            masked_multi_head_attention_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
          end if;

          -- Control Outputs
          H_OUT_ENABLE <= '0';

        when CLEAN_H_IN_L_STATE =>      -- STEP 2

          if (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '1';

            -- FSM Control
            masked_multi_head_attention_h_in_fsm_int <= STARTER_H_IN_STATE;
          elsif (unsigned(index_l_h_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= std_logic_vector(unsigned(index_l_h_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_h_in_fsm_int <= STARTER_H_IN_STATE;
      end case;
    end if;
  end process;

  h_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      H_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case masked_multi_head_attention_h_out_fsm_int is
        when STARTER_H_OUT_STATE =>     -- STEP 0
          if (data_w_in_enable_int = '1' and data_k_in_enable_int = '1' and data_u_in_enable_int = '1' and data_d_in_enable_int = '1' and data_b_in_enable_int = '1' and data_x_in_enable_int = '1' and data_xi_in_enable_int = '1' and data_rho_in_enable_int = '1' and data_h_in_enable_int = '1') then
            -- Data Internal
            vector_h_out_int <= function_model_masked_multi_head_attention_standard_masked_multi_head_attention (
              SIZE_X_IN => SIZE_X_IN,
              SIZE_W_IN => SIZE_W_IN,
              SIZE_L_IN => SIZE_L_IN,
              SIZE_R_IN => SIZE_R_IN,
              SIZE_S_IN => SIZE_S_IN,
              SIZE_M_IN => SIZE_M_IN,

              matrix_w_input => matrix_w_in_int,
              tensor_k_input => tensor_k_in_int,
              matrix_u_input => matrix_u_in_int,
              matrix_v_input => matrix_v_in_int,
              tensor_d_input => tensor_d_in_int,
              vector_b_input => vector_b_in_int,

              vector_x_input   => vector_x_in_int,
              matrix_r_input   => matrix_r_in_int,
              vector_xi_input  => vector_xi_in_int,
              matrix_rho_input => matrix_rho_in_int,
              vector_h_input   => vector_h_in_int
              );

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

        when CLEAN_H_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          H_OUT_ENABLE <= '0';

          -- FSM Control
          masked_multi_head_attention_h_out_fsm_int <= OUTPUT_H_OUT_L_STATE;

        when OUTPUT_H_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_h_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            H_OUT <= vector_h_out_int(to_integer(unsigned(index_l_h_out_loop)));

            -- Control Outputs
            READY <= '1';

            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            masked_multi_head_attention_h_out_fsm_int <= STARTER_H_OUT_STATE;
          elsif (unsigned(index_l_h_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            H_OUT <= vector_h_out_int(to_integer(unsigned(index_l_h_out_loop)));

            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_out_loop <= std_logic_vector(unsigned(index_l_h_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            masked_multi_head_attention_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          masked_multi_head_attention_h_out_fsm_int <= STARTER_H_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
