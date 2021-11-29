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

use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity dnc_top is
  generic (
    DATA_SIZE : integer := 512
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

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    X_IN_ENABLE  : in  std_logic;       -- for x in 0 to X-1
    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_top_architecture of dnc_top is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type top_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    CONTROLLER_STATE,                   -- STEP 1
    READ_HEADS_STATE,                   -- STEP 2
    WRITE_HEADS_STATE,                  -- STEP 3
    MEMORY_I_STATE,                     -- STEP 4
    MEMORY_J_STATE                      -- STEP 5
    );

  type controller_ctrl_fsm is (
    STARTER_CONTROLLER_STATE,           -- STEP 0
    CONTROLLER_BODY_STATE,              -- STEP 1
    OUTPUT_VECTOR_STATE                 -- STEP 2
    );

  type read_heads_ctrl_fsm is (
    STARTER_READ_HEADS_STATE,           -- STEP 0
    FREE_GATES_STATE,                   -- STEP 1
    READ_KEYS_STATE,                    -- STEP 2
    READ_MODES_STATE,                   -- STEP 3
    READ_STRENGTHS_STATE,               -- STEP 4
    READ_INTERFACE_VECTOR_STATE         -- STEP 5
    );

  type write_heads_ctrl_fsm is (
    STARTER_WRITE_HEADS_STATE,          -- STEP 0
    ALLOCATION_GATE_STATE,              -- STEP 1
    ERASE_VECTOR_STATE,                 -- STEP 2
    WRITE_GATE_STATE,                   -- STEP 3
    WRITE_KEY_STATE,                    -- STEP 4
    WRITE_STRENGTH_STATE,               -- STEP 5
    WRITE_VECTOR_STATE,                 -- STEP 6
    WRITE_INTERFACE_VECTOR_STATE        -- STEP 7
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal top_ctrl_fsm_int : top_ctrl_fsm;

  signal controller_ctrl_fsm_int  : controller_ctrl_fsm;
  signal read_heads_ctrl_fsm_int  : read_heads_ctrl_fsm;
  signal write_heads_ctrl_fsm_int : write_heads_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  signal w_in_l_enable_controller : std_logic;
  signal w_in_x_enable_controller : std_logic;

  signal k_in_i_enable_controller : std_logic;
  signal k_in_l_enable_controller : std_logic;
  signal k_in_k_enable_controller : std_logic;

  signal u_in_l_enable_controller : std_logic;
  signal u_in_p_enable_controller : std_logic;

  signal b_in_enable_controller : std_logic;

  signal x_in_enable_controller : std_logic;

  signal r_in_i_enable_controller : std_logic;
  signal r_in_k_enable_controller : std_logic;

  signal h_in_enable_controller : std_logic;

  signal w_out_l_enable_controller : std_logic;
  signal w_out_x_enable_controller : std_logic;

  signal k_out_i_enable_controller : std_logic;
  signal k_out_l_enable_controller : std_logic;
  signal k_out_k_enable_controller : std_logic;

  signal u_out_l_enable_controller : std_logic;
  signal u_out_p_enable_controller : std_logic;

  signal b_out_enable_controller : std_logic;

  signal h_out_enable_controller : std_logic;

  -- DATA
  signal size_x_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_out_controller : std_logic_vector(DATA_SIZE-1 downto 0);

  -- OUTPUT VECTOR
  -- CONTROL
  signal start_output_vector : std_logic;
  signal ready_output_vector : std_logic;

  signal k_in_i_enable_output_vector : std_logic;
  signal k_in_y_enable_output_vector : std_logic;
  signal k_in_k_enable_output_vector : std_logic;

  signal k_out_i_enable_output_vector : std_logic;
  signal k_out_y_enable_output_vector : std_logic;
  signal k_out_k_enable_output_vector : std_logic;

  signal r_in_i_enable_output_vector : std_logic;
  signal r_in_k_enable_output_vector : std_logic;

  signal r_out_i_enable_output_vector : std_logic;
  signal r_out_k_enable_output_vector : std_logic;

  signal u_in_y_enable_output_vector : std_logic;
  signal u_in_l_enable_output_vector : std_logic;

  signal u_out_y_enable_output_vector : std_logic;
  signal u_out_l_enable_output_vector : std_logic;

  signal h_in_enable_output_vector : std_logic;

  signal h_out_enable_output_vector : std_logic;

  signal y_in_enable_output_vector : std_logic;

  -- DATA
  signal size_y_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal y_out_output_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- FREE GATES
  -- CONTROL
  signal start_free_gates : std_logic;
  signal ready_free_gates : std_logic;

  signal f_in_enable_free_gates  : std_logic;
  signal f_out_enable_free_gates : std_logic;

  -- DATA
  signal size_r_in_free_gates : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_in_free_gates  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_free_gates : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ KEYS
  -- CONTROL
  signal start_read_keys : std_logic;
  signal ready_read_keys : std_logic;

  signal k_in_i_enable_read_keys : std_logic;
  signal k_in_k_enable_read_keys : std_logic;

  signal k_out_i_enable_read_keys : std_logic;
  signal k_out_k_enable_read_keys : std_logic;

  -- DATA
  signal size_r_in_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_read_keys  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ MODES
  -- CONTROL
  signal start_read_modes : std_logic;
  signal ready_read_modes : std_logic;

  signal pi_in_i_enable_read_modes : std_logic;
  signal pi_in_p_enable_read_modes : std_logic;

  signal pi_out_i_enable_read_modes : std_logic;
  signal pi_out_p_enable_read_modes : std_logic;

  -- DATA
  signal size_r_in_read_modes : std_logic_vector(DATA_SIZE-1 downto 0);

  signal pi_in_read_modes  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_modes : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ STRENGTHS
  -- CONTROL
  signal start_read_strengths : std_logic;
  signal ready_read_strengths : std_logic;

  signal beta_in_enable_read_strengths  : std_logic;
  signal beta_out_enable_read_strengths : std_logic;

  -- DATA
  signal size_r_in_read_strengths : std_logic_vector(DATA_SIZE-1 downto 0);

  signal beta_in_read_strengths  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_strengths : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ INTERFACE VECTOR
  -- CONTROL
  signal start_read_interface_vector : std_logic;
  signal ready_read_interface_vector : std_logic;

  -- Read Key
  signal wk_in_i_enable_read_interface_vector : std_logic;
  signal wk_in_l_enable_read_interface_vector : std_logic;
  signal wk_in_k_enable_read_interface_vector : std_logic;

  signal k_out_i_enable_read_interface_vector : std_logic;
  signal k_out_k_enable_read_interface_vector : std_logic;

  -- Read Strength
  signal wbeta_in_i_enable_read_interface_vector : std_logic;
  signal wbeta_in_l_enable_read_interface_vector : std_logic;

  signal beta_out_enable_read_interface_vector : std_logic;

  -- Free Gate
  signal wf_in_i_enable_read_interface_vector : std_logic;
  signal wf_in_l_enable_read_interface_vector : std_logic;

  signal f_out_enable_read_interface_vector : std_logic;

  -- Read Mode
  signal wpi_in_i_enable_read_interface_vector : std_logic;
  signal wpi_in_l_enable_read_interface_vector : std_logic;

  signal pi_out_enable_read_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_read_interface_vector : std_logic;

  -- DATA
  signal size_w_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal wk_in_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wbeta_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wf_in_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wpi_in_read_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_read_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- ALLOCATION GATE
  -- CONTROL
  signal start_allocation_gate : std_logic;
  signal ready_allocation_gate : std_logic;

  -- DATA
  signal ga_in_allocation_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_allocation_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ERASE VECTOR
  -- CONTROL
  signal start_erase_vector : std_logic;
  signal ready_erase_vector : std_logic;

  signal e_in_enable_erase_vector : std_logic;

  signal e_out_enable_erase_vector : std_logic;

  -- DATA
  signal size_w_in_erase_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal e_in_erase_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_erase_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE GATE
  -- CONTROL
  signal start_write_gate : std_logic;
  signal ready_write_gate : std_logic;

  -- DATA
  signal gw_in_write_gate  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_gate : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE KEY
  -- CONTROL
  signal start_write_key : std_logic;
  signal ready_write_key : std_logic;

  signal k_in_enable_write_key : std_logic;

  signal k_out_enable_write_key : std_logic;

  -- DATA
  signal size_w_in_write_key : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_write_key  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_write_key : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE STRENGHT
  -- CONTROL
  signal start_write_strength : std_logic;
  signal ready_write_strength : std_logic;

  -- DATA
  signal beta_in_write_strength  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_strength : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE VECTOR
  -- CONTROL
  signal start_write_vector : std_logic;
  signal ready_write_vector : std_logic;

  signal v_in_enable_write_vector : std_logic;

  signal v_out_enable_write_vector : std_logic;

  -- DATA
  signal size_w_in_write_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal v_in_write_vector  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE INTERFACE VECTOR
  -- CONTROL
  signal start_write_interface_vector : std_logic;
  signal ready_write_interface_vector : std_logic;

  -- Write Key
  signal wk_in_l_enable_write_interface_vector : std_logic;
  signal wk_in_k_enable_write_interface_vector : std_logic;

  signal k_out_enable_write_interface_vector : std_logic;

  -- Write Strength
  signal wbeta_in_enable_write_interface_vector : std_logic;

  -- Erase Vector
  signal we_in_l_enable_write_interface_vector : std_logic;
  signal we_in_k_enable_write_interface_vector : std_logic;

  signal e_out_enable_write_interface_vector : std_logic;

  -- Write Vector
  signal wv_in_l_enable_write_interface_vector : std_logic;
  signal wv_in_k_enable_write_interface_vector : std_logic;

  signal v_out_enable_write_interface_vector : std_logic;

  -- Allocation Gate
  signal wga_in_enable_write_interface_vector : std_logic;

  -- Write Gate
  signal wgw_in_enable_write_interface_vector : std_logic;

  -- Hidden State
  signal h_in_enable_write_interface_vector : std_logic;

  -- DATA
  signal size_w_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal wk_in_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wbeta_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal we_in_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wv_in_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wga_in_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal wgw_in_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal h_in_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_out_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_write_interface_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_out_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_out_write_interface_vector    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_out_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_out_write_interface_vector   : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_read_in_i_enable_addressing : std_logic;
  signal k_read_in_k_enable_addressing : std_logic;

  signal beta_read_in_enable_addressing : std_logic;

  signal f_read_in_enable_addressing : std_logic;

  signal pi_read_in_enable_addressing : std_logic;

  signal k_write_in_k_enable_addressing : std_logic;
  signal e_write_in_k_enable_addressing : std_logic;
  signal v_write_in_k_enable_addressing : std_logic;

  signal r_out_i_enable_addressing : std_logic;
  signal r_out_k_enable_addressing : std_logic;

  -- DATA
  signal size_r_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
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

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      Y_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case top_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          Y_OUT_ENABLE <= '0';

          -- Control Internal
          index_i_loop <= ZERO;
          index_j_loop <= ZERO;

          if (START = '1') then
            -- Control Internal
            start_controller <= '1';

            -- FSM Control
            top_ctrl_fsm_int <= CONTROLLER_STATE;
          else
            -- Control Internal
            start_controller <= '0';
          end if;

        when CONTROLLER_STATE =>  -- STEP 1

          case controller_ctrl_fsm_int is
            when STARTER_CONTROLLER_STATE =>  -- STEP 0

            when CONTROLLER_BODY_STATE =>  -- STEP 1

              -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + b(t;l))
              -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(t;l))

            when OUTPUT_VECTOR_STATE =>  -- STEP 2

              -- y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)

            when others =>
              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_CONTROLLER_STATE;
          end case;

        when READ_HEADS_STATE =>  -- STEP 2

          case read_heads_ctrl_fsm_int is
            when STARTER_READ_HEADS_STATE =>  -- STEP 0

            when FREE_GATES_STATE =>  -- STEP 1

              -- f(t;i) = sigmoid(f^(t;i))

            when READ_KEYS_STATE =>  -- STEP 2

              -- k(t;i;k) = k^(t;i;k)

            when READ_MODES_STATE =>  -- STEP 3

              -- pi(t;i;p) = softmax(pi^(t;i;p))

            when READ_STRENGTHS_STATE =>  -- STEP 4

              -- beta(t;i) = oneplus(beta^(t;i))

            when READ_INTERFACE_VECTOR_STATE =>  -- STEP 5

              -- xi(t;?) = U(t;?;l)·h(t;l)

              -- k(t;i;k) = Wk(t;i;l;k)·h(t;l)
              -- beta(t;i) = Wbeta(t;i;l)·h(t;l)
              -- f(t;i) = Wf(t;i;l)·h(t;l)
              -- pi(t;i) = Wpi(t;i;l)·h(t;l)

            when others =>
              -- FSM Control
              read_heads_ctrl_fsm_int <= STARTER_READ_HEADS_STATE;
          end case;

        when WRITE_HEADS_STATE =>  -- STEP 3

          case write_heads_ctrl_fsm_int is
            when STARTER_WRITE_HEADS_STATE =>  -- STEP 0

            when ALLOCATION_GATE_STATE =>  -- STEP 1

              -- ga(t) = sigmoid(g^(t))

            when ERASE_VECTOR_STATE =>  -- STEP 2

              -- e(t;k) = sigmoid(e^(t;k))

            when WRITE_GATE_STATE =>  -- STEP 3

              -- gw(t) = sigmoid(gw^(t))

            when WRITE_KEY_STATE =>  -- STEP 4

              -- k(t;k) = k^(t;k)

            when WRITE_STRENGTH_STATE =>  -- STEP 5

              -- beta(t) = oneplus(beta^(t))

            when WRITE_VECTOR_STATE =>  -- STEP 6

              -- v(t;k) = v^(t;k)

            when WRITE_INTERFACE_VECTOR_STATE =>  -- STEP 7

              -- xi(t;?) = U(t;?;l)·h(t;l)

              -- k(t;k) = Wk(t;l;k)·h(t;l)
              -- beta(t) = Wbeta(t;l)·h(t;l)
              -- e(t;k) = We(t;l;k)·h(t;l)
              -- v(t;k) = Wv(t;l;k)·h(t;l)
              -- ga(t) = Wga(t;l)·h(t;l)
              -- gw(t) = Wgw(t;l)·h(t;l)

            when others =>
              -- FSM Control
              write_heads_ctrl_fsm_int <= STARTER_WRITE_HEADS_STATE;
          end case;

        when MEMORY_I_STATE =>  -- STEP 4

          if (r_out_i_enable_addressing = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;

              -- FSM Control
              top_ctrl_fsm_int <= CONTROLLER_STATE;
            end if;
          end if;

        when MEMORY_J_STATE =>  -- STEP 5

          if (r_out_k_enable_addressing = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- FSM Control
              top_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

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
  k_in_i_enable_output_vector <= '0';
  k_in_y_enable_output_vector <= '0';
  k_in_k_enable_output_vector <= '0';

  r_in_i_enable_output_vector <= '0';
  r_in_k_enable_output_vector <= '0';

  u_in_y_enable_output_vector <= '0';
  u_in_l_enable_output_vector <= '0';

  h_in_enable_output_vector <= '0';

  y_in_enable_output_vector <= '0';

  -- FREE GATES
  f_in_enable_free_gates  <= '0';
  f_out_enable_free_gates <= '0';

  -- READ KEYS
  k_in_i_enable_read_keys <= '0';
  k_in_k_enable_read_keys <= '0';

  k_out_i_enable_read_keys <= '0';
  k_out_k_enable_read_keys <= '0';

  -- READ MODES
  pi_in_i_enable_read_modes <= '0';
  pi_in_p_enable_read_modes <= '0';

  pi_out_i_enable_read_modes <= '0';
  pi_out_p_enable_read_modes <= '0';

  -- READ STRENGTHS
  beta_in_enable_read_strengths  <= '0';
  beta_out_enable_read_strengths <= '0';

  -- READ INTERFACE VECTOR
  -- Read Key
  wk_in_i_enable_read_interface_vector <= '0';
  wk_in_l_enable_read_interface_vector <= '0';
  wk_in_k_enable_read_interface_vector <= '0';

  k_out_i_enable_read_interface_vector <= '0';
  k_out_k_enable_read_interface_vector <= '0';

  -- Read Strength
  wbeta_in_i_enable_read_interface_vector <= '0';
  wbeta_in_l_enable_read_interface_vector <= '0';

  beta_out_enable_read_interface_vector <= '0';

  -- Free Gate
  wf_in_i_enable_read_interface_vector <= '0';
  wf_in_l_enable_read_interface_vector <= '0';

  f_out_enable_read_interface_vector <= '0';

  -- Read Mode
  wpi_in_i_enable_read_interface_vector <= '0';
  wpi_in_l_enable_read_interface_vector <= '0';

  pi_out_enable_read_interface_vector <= '0';

  -- Hidden State
  h_in_enable_read_interface_vector <= '0';

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

  k_in_output_vector <= FULL;
  r_in_output_vector <= FULL;

  u_in_output_vector <= FULL;
  h_in_output_vector <= FULL;

  y_out_output_vector <= FULL;

  -- FREE GATES
  size_r_in_free_gates <= FULL;

  f_in_free_gates  <= FULL;
  f_out_free_gates <= FULL;

  -- READ KEYS
  size_r_in_read_keys <= FULL;
  size_w_in_read_keys <= FULL;

  k_in_read_keys  <= FULL;
  k_out_read_keys <= FULL;

  -- READ MODES
  size_r_in_read_modes <= FULL;

  pi_in_read_modes  <= FULL;
  pi_out_read_modes <= FULL;

  -- READ STRENGTHS
  size_r_in_read_strengths <= FULL;

  beta_in_read_strengths  <= FULL;
  beta_out_read_strengths <= FULL;

  -- READ INTERFACE VECTOR
  size_w_in_read_interface_vector <= FULL;
  size_l_in_read_interface_vector <= FULL;
  size_r_in_read_interface_vector <= FULL;

  wk_in_read_interface_vector    <= FULL;
  wbeta_in_read_interface_vector <= FULL;
  wf_in_read_interface_vector    <= FULL;
  wpi_in_read_interface_vector   <= FULL;

  h_in_read_interface_vector <= FULL;

  k_out_read_interface_vector    <= FULL;
  beta_out_read_interface_vector <= FULL;
  f_out_read_interface_vector    <= FULL;
  pi_out_read_interface_vector   <= FULL;

  -- ALLOCATION GATE
  ga_in_allocation_gate  <= FULL;
  ga_out_allocation_gate <= FULL;

  -- ERASE VECTOR
  size_w_in_erase_vector <= FULL;

  e_in_erase_vector  <= FULL;
  e_out_erase_vector <= FULL;

  -- WRITE GATE
  gw_in_write_gate  <= FULL;
  gw_out_write_gate <= FULL;

  -- WRITE KEY
  size_w_in_write_key <= FULL;

  k_in_write_key  <= FULL;
  k_out_write_key <= FULL;

  -- WRITE STRENGHT
  beta_in_write_strength  <= FULL;
  beta_out_write_strength <= FULL;

  -- WRITE VECTOR
  size_w_in_write_vector <= FULL;

  v_in_write_vector  <= FULL;
  v_out_write_vector <= FULL;

  -- WRITE INTERFACE VECTOR
  size_w_in_write_interface_vector <= FULL;
  size_l_in_write_interface_vector <= FULL;
  size_r_in_write_interface_vector <= FULL;

  wk_in_write_interface_vector    <= FULL;
  wbeta_in_write_interface_vector <= FULL;
  we_in_write_interface_vector    <= FULL;
  wv_in_write_interface_vector    <= FULL;
  wga_in_write_interface_vector   <= FULL;
  wgw_in_write_interface_vector   <= FULL;

  h_in_write_interface_vector <= FULL;

  k_out_write_interface_vector    <= FULL;
  beta_out_write_interface_vector <= FULL;
  e_out_write_interface_vector    <= FULL;
  v_out_write_interface_vector    <= FULL;
  ga_out_write_interface_vector   <= FULL;
  gw_out_write_interface_vector   <= FULL;

  -- ADDRESSING
  size_r_in_addressing <= FULL;
  size_w_in_addressing <= FULL;

  k_read_in_addressing    <= FULL;
  beta_read_in_addressing <= FULL;
  f_read_in_addressing    <= FULL;
  pi_read_in_addressing   <= FULL;

  k_write_in_addressing    <= FULL;
  beta_write_in_addressing <= FULL;
  e_write_in_addressing    <= FULL;
  v_write_in_addressing    <= FULL;
  ga_write_in_addressing   <= FULL;
  gw_write_in_addressing   <= FULL;

  r_out_addressing <= FULL;

  -----------------------------------------------------------------------
  -- CONTROLLER
  -----------------------------------------------------------------------

  -- CONTROLLER
  ntm_controller_i : ntm_controller
    generic map (
      DATA_SIZE => DATA_SIZE
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

      K_IN_I_ENABLE => k_in_i_enable_controller,
      K_IN_L_ENABLE => k_in_l_enable_controller,
      K_IN_K_ENABLE => k_in_k_enable_controller,

      U_IN_L_ENABLE => u_in_l_enable_controller,
      U_IN_P_ENABLE => u_in_p_enable_controller,

      B_IN_ENABLE => b_in_enable_controller,

      X_IN_ENABLE => x_in_enable_controller,

      R_IN_I_ENABLE => r_in_i_enable_controller,
      R_IN_K_ENABLE => r_in_k_enable_controller,

      H_IN_ENABLE => h_in_enable_controller,

      W_OUT_L_ENABLE => w_out_l_enable_controller,
      W_OUT_X_ENABLE => w_out_x_enable_controller,

      K_OUT_I_ENABLE => k_out_i_enable_controller,
      K_OUT_L_ENABLE => k_out_l_enable_controller,
      K_OUT_K_ENABLE => k_out_k_enable_controller,

      U_OUT_L_ENABLE => u_out_l_enable_controller,
      U_OUT_P_ENABLE => u_out_p_enable_controller,

      B_OUT_ENABLE => b_out_enable_controller,

      H_OUT_ENABLE => h_out_enable_controller,

      -- DATA
      SIZE_X_IN => size_x_in_controller,
      SIZE_W_IN => size_w_in_controller,
      SIZE_L_IN => size_l_in_controller,
      SIZE_R_IN => size_r_in_controller,

      W_IN => w_in_controller,
      K_IN => k_in_controller,
      U_IN => u_in_controller,
      B_IN => b_in_controller,

      X_IN => x_in_controller,
      R_IN => r_in_controller,
      H_IN => h_in_controller,

      W_OUT => w_out_controller,
      K_OUT => k_out_controller,
      U_OUT => u_out_controller,
      B_OUT => b_out_controller,

      H_OUT => h_out_controller
      );

  -- OUTPUT VECTOR
  output_vector_i : dnc_output_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_vector,
      READY => ready_output_vector,

      K_IN_I_ENABLE => k_in_i_enable_output_vector,
      K_IN_Y_ENABLE => k_in_y_enable_output_vector,
      K_IN_K_ENABLE => k_in_k_enable_output_vector,

      K_OUT_I_ENABLE => k_out_i_enable_output_vector,
      K_OUT_Y_ENABLE => k_out_y_enable_output_vector,
      K_OUT_K_ENABLE => k_out_k_enable_output_vector,

      R_IN_I_ENABLE => r_in_i_enable_output_vector,
      R_IN_K_ENABLE => r_in_k_enable_output_vector,

      R_OUT_I_ENABLE => r_out_i_enable_output_vector,
      R_OUT_K_ENABLE => r_out_k_enable_output_vector,

      U_IN_Y_ENABLE => u_in_y_enable_output_vector,
      U_IN_L_ENABLE => u_in_l_enable_output_vector,

      U_OUT_Y_ENABLE => u_out_y_enable_output_vector,
      U_OUT_L_ENABLE => u_out_l_enable_output_vector,

      H_IN_ENABLE => h_in_enable_output_vector,

      H_OUT_ENABLE => h_out_enable_output_vector,

      Y_OUT_ENABLE => y_in_enable_output_vector,

      -- DATA
      SIZE_Y_IN => size_y_in_output_vector,
      SIZE_L_IN => size_l_in_output_vector,
      SIZE_W_IN => size_w_in_output_vector,
      SIZE_R_IN => size_r_in_output_vector,

      K_IN => k_in_output_vector,
      R_IN => r_in_output_vector,

      U_IN => u_in_output_vector,
      H_IN => h_in_output_vector,

      Y_OUT => y_out_output_vector
      );

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  -- FREE GATES
  free_gates : dnc_free_gates
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_free_gates,
      READY => ready_free_gates,

      F_IN_ENABLE => f_in_enable_free_gates,

      F_OUT_ENABLE => f_out_enable_free_gates,

      -- DATA
      SIZE_R_IN => size_r_in_free_gates,

      F_IN => f_in_free_gates,

      F_OUT => f_out_free_gates
      );

  -- READ KEYS
  read_keys : dnc_read_keys
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_keys,
      READY => ready_read_keys,

      K_IN_I_ENABLE => k_in_i_enable_read_keys,
      K_IN_K_ENABLE => k_in_k_enable_read_keys,

      K_OUT_I_ENABLE => k_out_i_enable_read_keys,
      K_OUT_K_ENABLE => k_out_k_enable_read_keys,

      -- DATA
      SIZE_R_IN => size_r_in_read_keys,
      SIZE_W_IN => size_w_in_read_keys,

      K_IN => k_in_read_keys,

      K_OUT => k_out_read_keys
      );

  -- READ MODES
  read_modes : dnc_read_modes
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_modes,
      READY => ready_read_modes,

      PI_IN_I_ENABLE => pi_in_i_enable_read_modes,
      PI_IN_P_ENABLE => pi_in_p_enable_read_modes,

      PI_OUT_I_ENABLE => pi_out_i_enable_read_modes,
      PI_OUT_P_ENABLE => pi_out_p_enable_read_modes,

      -- DATA
      SIZE_R_IN => size_r_in_free_gates,

      PI_IN => pi_in_read_modes,

      PI_OUT => pi_out_read_modes
      );

  -- READ STRENGTHS
  read_strengths : dnc_read_strengths
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_strengths,
      READY => ready_read_strengths,

      BETA_IN_ENABLE  => beta_in_enable_read_strengths,
      BETA_OUT_ENABLE => beta_out_enable_read_strengths,

      -- DATA
      SIZE_R_IN => size_r_in_free_gates,

      BETA_IN => beta_in_read_strengths,

      BETA_OUT => beta_out_read_strengths
      );

  -- READ INTERFACE VECTOR
  read_interface_vector : dnc_read_interface_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_interface_vector,
      READY => ready_read_interface_vector,

      -- Read Key
      WK_IN_I_ENABLE => wk_in_i_enable_read_interface_vector,
      WK_IN_L_ENABLE => wk_in_l_enable_read_interface_vector,
      WK_IN_K_ENABLE => wk_in_k_enable_read_interface_vector,

      K_OUT_I_ENABLE => k_out_i_enable_read_interface_vector,
      K_OUT_K_ENABLE => k_out_k_enable_read_interface_vector,

      -- Read Strength
      WBETA_IN_I_ENABLE => wbeta_in_i_enable_read_interface_vector,
      WBETA_IN_L_ENABLE => wbeta_in_l_enable_read_interface_vector,

      BETA_OUT_ENABLE => beta_out_enable_read_interface_vector,

      -- Free Gate
      WF_IN_I_ENABLE => wf_in_i_enable_read_interface_vector,
      WF_IN_L_ENABLE => wf_in_l_enable_read_interface_vector,

      F_OUT_ENABLE => f_out_enable_read_interface_vector,

      -- Read Mode
      WPI_IN_I_ENABLE => wpi_in_i_enable_read_interface_vector,
      WPI_IN_L_ENABLE => wpi_in_l_enable_read_interface_vector,

      PI_OUT_ENABLE => pi_out_enable_read_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_read_interface_vector,

      -- DATA
      SIZE_W_IN => size_w_in_read_interface_vector,
      SIZE_L_IN => size_l_in_read_interface_vector,
      SIZE_R_IN => size_r_in_read_interface_vector,

      WK_IN    => wk_in_read_interface_vector,
      WBETA_IN => wbeta_in_read_interface_vector,
      WF_IN    => wf_in_read_interface_vector,
      WPI_IN   => wpi_in_read_interface_vector,

      H_IN => h_in_read_interface_vector,

      K_OUT    => k_out_read_interface_vector,
      BETA_OUT => beta_out_read_interface_vector,
      F_OUT    => f_out_read_interface_vector,
      PI_OUT   => pi_out_read_interface_vector
      );

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  -- ALLOCATION GATE
  allocation_gate : dnc_allocation_gate
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_allocation_gate,
      READY => ready_allocation_gate,

      -- DATA
      GA_IN => ga_in_allocation_gate,

      GA_OUT => ga_out_allocation_gate
      );

  -- ERASE VECTOR
  erase_vector : dnc_erase_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_erase_vector,
      READY => ready_erase_vector,

      E_IN_ENABLE => e_in_enable_erase_vector,

      E_OUT_ENABLE => e_out_enable_erase_vector,

      -- DATA
      SIZE_W_IN => size_w_in_erase_vector,

      E_IN => e_in_erase_vector,

      E_OUT => e_out_erase_vector
      );

  -- WRITE GATE
  write_gate : dnc_write_gate
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_gate,
      READY => ready_write_gate,

      -- DATA
      GW_IN => gw_in_write_gate,

      GW_OUT => gw_out_write_gate
      );

  -- WRITE KEY
  write_key : dnc_write_key
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_key,
      READY => ready_write_key,

      K_IN_ENABLE => k_in_enable_write_key,

      K_OUT_ENABLE => k_out_enable_write_key,

      -- DATA
      SIZE_W_IN => size_w_in_write_key,

      K_IN => k_in_write_key,

      K_OUT => k_out_write_key
      );

  -- WRITE STRENGTH
  write_strength : dnc_write_strength
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_strength,
      READY => ready_write_strength,

      -- DATA
      BETA_IN => beta_in_write_strength,

      BETA_OUT => beta_out_write_strength
      );

  -- WRITE VECTOR
  write_vector : dnc_write_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_vector,
      READY => ready_write_vector,

      V_IN_ENABLE => v_in_enable_write_vector,

      V_OUT_ENABLE => v_out_enable_write_vector,

      -- DATA
      SIZE_W_IN => size_w_in_write_vector,

      V_IN => v_in_write_vector,

      V_OUT => v_out_write_vector
      );

  -- WRITE INTERFACE VECTOR
  write_interface_vector : dnc_write_interface_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_interface_vector,
      READY => ready_write_interface_vector,

      -- Write Key
      WK_IN_L_ENABLE => wk_in_l_enable_write_interface_vector,
      WK_IN_K_ENABLE => wk_in_k_enable_write_interface_vector,

      K_OUT_ENABLE => k_out_enable_write_interface_vector,

      -- Write Strength
      WBETA_IN_ENABLE => wbeta_in_enable_write_interface_vector,

      -- Erase Vector
      WE_IN_L_ENABLE => we_in_l_enable_write_interface_vector,
      WE_IN_K_ENABLE => we_in_k_enable_write_interface_vector,

      E_OUT_ENABLE => e_out_enable_write_interface_vector,

      -- Write Vector
      WV_IN_L_ENABLE => wv_in_l_enable_write_interface_vector,
      WV_IN_K_ENABLE => wv_in_k_enable_write_interface_vector,

      V_OUT_ENABLE => v_out_enable_write_interface_vector,

      -- Allocation Gate
      WGA_IN_ENABLE => wga_in_enable_write_interface_vector,

      -- Write Gate
      WGW_IN_ENABLE => wgw_in_enable_write_interface_vector,

      -- Hidden State
      H_IN_ENABLE => h_in_enable_write_interface_vector,

      -- DATA
      SIZE_W_IN => size_w_in_write_interface_vector,
      SIZE_L_IN => size_l_in_write_interface_vector,
      SIZE_R_IN => size_r_in_write_interface_vector,

      WK_IN    => wk_in_write_interface_vector,
      WBETA_IN => wbeta_in_write_interface_vector,
      WE_IN    => we_in_write_interface_vector,
      WV_IN    => wv_in_write_interface_vector,
      WGA_IN   => wga_in_write_interface_vector,
      WGW_IN   => wgw_in_write_interface_vector,

      H_IN => h_in_write_interface_vector,

      K_OUT    => k_out_write_interface_vector,
      BETA_OUT => beta_out_write_interface_vector,
      E_OUT    => e_out_write_interface_vector,
      V_OUT    => v_out_write_interface_vector,
      GA_OUT   => ga_out_write_interface_vector,
      GW_OUT   => gw_out_write_interface_vector
      );

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  -- ADDRESSING
  addressing : dnc_addressing
    generic map (
      DATA_SIZE => DATA_SIZE
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

      BETA_READ_IN_ENABLE => beta_read_in_enable_addressing,

      F_READ_IN_ENABLE => f_read_in_enable_addressing,

      PI_READ_IN_ENABLE => pi_read_in_enable_addressing,

      K_WRITE_IN_K_ENABLE => k_write_in_k_enable_addressing,
      E_WRITE_IN_K_ENABLE => e_write_in_k_enable_addressing,
      V_WRITE_IN_K_ENABLE => v_write_in_k_enable_addressing,

      R_OUT_I_ENABLE => r_out_i_enable_addressing,
      R_OUT_K_ENABLE => r_out_k_enable_addressing,

      -- DATA
      SIZE_R_IN => size_r_in_addressing,
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