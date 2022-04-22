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

entity ntm_activation_gate_vector is
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

    A_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

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

    A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_activation_gate_vector_architecture of ntm_activation_gate_vector is

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
  -- A_OUT [L]

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

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    MATRIX_I_FIRST_CONVOLUTION_STATE,   -- STEP 1
    MATRIX_J_FIRST_CONVOLUTION_STATE,   -- STEP 2
    VECTOR_FIRST_ADDER_STATE,           -- STEP 3
    MATRIX_I_SECOND_CONVOLUTION_STATE,  -- STEP 4
    MATRIX_J_SECOND_CONVOLUTION_STATE,  -- STEP 5
    VECTOR_SECOND_ADDER_STATE,          -- STEP 6
    MATRIX_I_THIRD_CONVOLUTION_STATE,   -- STEP 7
    MATRIX_J_THIRD_CONVOLUTION_STATE,   -- STEP 8
    VECTOR_THIRD_ADDER_STATE,           -- STEP 9
    MATRIX_I_FOURTH_CONVOLUTION_STATE,  -- STEP 10
    MATRIX_J_FOURTH_CONVOLUTION_STATE,  -- STEP 11
    VECTOR_FOURTH_ADDER_STATE,          -- STEP 12
    VECTOR_TANH_STATE                   -- STEP 13
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_float_adder : std_logic;
  signal ready_vector_float_adder : std_logic;

  signal operation_vector_float_adder : std_logic;

  signal data_a_in_enable_vector_float_adder : std_logic;
  signal data_b_in_enable_vector_float_adder : std_logic;

  signal data_out_enable_vector_float_adder : std_logic;

  -- DATA
  signal size_in_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR MATRIX CONVOLUTION
  -- CONTROL
  signal start_tensor_matrix_convolution : std_logic;
  signal ready_tensor_matrix_convolution : std_logic;

  signal data_a_in_i_enable_tensor_matrix_convolution : std_logic;
  signal data_a_in_j_enable_tensor_matrix_convolution : std_logic;
  signal data_a_in_k_enable_tensor_matrix_convolution : std_logic;
  signal data_b_in_i_enable_tensor_matrix_convolution : std_logic;
  signal data_b_in_j_enable_tensor_matrix_convolution : std_logic;

  signal data_i_enable_tensor_matrix_convolution : std_logic;
  signal data_j_enable_tensor_matrix_convolution : std_logic;
  signal data_k_enable_tensor_matrix_convolution : std_logic;

  signal data_out_i_enable_tensor_matrix_convolution : std_logic;
  signal data_out_j_enable_tensor_matrix_convolution : std_logic;

  -- DATA
  signal size_a_i_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_matrix_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_matrix_convolution   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_matrix_convolution    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX VECTOR CONVOLUTION
  -- CONTROL
  signal start_matrix_vector_convolution : std_logic;
  signal ready_matrix_vector_convolution : std_logic;

  signal data_a_in_i_enable_matrix_vector_convolution : std_logic;
  signal data_a_in_j_enable_matrix_vector_convolution : std_logic;
  signal data_b_in_enable_matrix_vector_convolution   : std_logic;

  signal data_i_enable_matrix_vector_convolution : std_logic;
  signal data_j_enable_matrix_vector_convolution : std_logic;

  signal data_out_enable_matrix_vector_convolution : std_logic;

  -- DATA
  signal size_a_i_in_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_matrix_vector_convolution   : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_matrix_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_vector_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal size_in_vector_tanh  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- a(t;l) = tanh(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      A_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Control Internal
            start_matrix_vector_convolution <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_FIRST_CONVOLUTION_STATE;
          end if;

        when MATRIX_I_FIRST_CONVOLUTION_STATE =>  -- STEP 1

          -- Data Inputs
          size_a_i_in_matrix_vector_convolution <= FULL;
          size_a_j_in_matrix_vector_convolution <= FULL;
          size_b_in_matrix_vector_convolution   <= FULL;

          data_a_in_matrix_vector_convolution <= W_IN;
          data_b_in_matrix_vector_convolution <= X_IN;

          if (data_i_enable_matrix_vector_convolution = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_FIRST_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_convolution <= '0';
          end if;

        when VECTOR_FIRST_ADDER_STATE =>  -- STEP 2

          -- Data Inputs
          size_in_vector_float_adder   <= FULL;
          data_a_in_vector_float_adder <= data_out_matrix_vector_convolution;
          data_b_in_vector_float_adder <= B_IN;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_convolution <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_SECOND_CONVOLUTION_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when MATRIX_I_SECOND_CONVOLUTION_STATE =>  -- STEP 3

          -- Data Inputs
          size_a_i_in_matrix_vector_convolution <= FULL;
          size_a_j_in_matrix_vector_convolution <= FULL;
          size_b_in_matrix_vector_convolution   <= FULL;

          data_a_in_matrix_vector_convolution <= K_IN;
          data_b_in_matrix_vector_convolution <= R_IN;

          if (data_i_enable_matrix_vector_convolution = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_SECOND_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_convolution <= '0';
          end if;

        when VECTOR_SECOND_ADDER_STATE =>  -- STEP 4

          -- Data Inputs
          size_in_vector_float_adder   <= FULL;
          data_a_in_vector_float_adder <= data_out_matrix_vector_convolution;
          data_b_in_vector_float_adder <= data_out_vector_float_adder;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_convolution <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_THIRD_CONVOLUTION_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when MATRIX_I_THIRD_CONVOLUTION_STATE =>  -- STEP 5

          -- Data Inputs
          size_a_i_in_matrix_vector_convolution <= FULL;
          size_a_j_in_matrix_vector_convolution <= FULL;
          size_b_in_matrix_vector_convolution   <= FULL;

          data_a_in_matrix_vector_convolution <= U_IN;
          data_b_in_matrix_vector_convolution <= H_IN;

          if (data_i_enable_matrix_vector_convolution = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_THIRD_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_convolution <= '0';
          end if;

        when VECTOR_THIRD_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          size_in_vector_float_adder   <= FULL;
          data_a_in_vector_float_adder <= data_out_matrix_vector_convolution;
          data_b_in_vector_float_adder <= data_out_vector_float_adder;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_convolution <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_FOURTH_CONVOLUTION_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when MATRIX_I_FOURTH_CONVOLUTION_STATE =>  -- STEP 7

          -- Data Inputs
          size_a_i_in_matrix_vector_convolution <= FULL;
          size_a_j_in_matrix_vector_convolution <= FULL;
          size_b_in_matrix_vector_convolution   <= FULL;

          data_a_in_matrix_vector_convolution <= U_IN;
          data_b_in_matrix_vector_convolution <= H_IN;

          if (data_i_enable_matrix_vector_convolution = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_FOURTH_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_convolution <= '0';
          end if;

        when VECTOR_FOURTH_ADDER_STATE =>  -- STEP 8

          -- Data Inputs
          size_in_vector_float_adder   <= FULL;
          data_a_in_vector_float_adder <= data_out_matrix_vector_convolution;
          data_b_in_vector_float_adder <= data_out_vector_float_adder;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_convolution <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_TANH_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when VECTOR_TANH_STATE =>       -- STEP 9

          -- Data Inputs
          size_in_vector_tanh <= FULL;
          data_in_vector_tanh <= FULL;

          if (data_out_enable_vector_tanh = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_L_IN) - unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_I_FIRST_CONVOLUTION_STATE;
            end if;

            -- Data Outputs
            A_OUT <= data_out_vector_tanh;

            -- Control Outputs
            A_OUT_ENABLE <= '1';

            -- Control Internal
            start_matrix_vector_convolution <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  vector_float_adder : ntm_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_adder,
      READY => ready_vector_float_adder,

      OPERATION => operation_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_vector_float_adder,
      DATA_A_IN => data_a_in_vector_float_adder,
      DATA_B_IN => data_b_in_vector_float_adder,
      DATA_OUT  => data_out_vector_float_adder
      );

  -- TENSOR MATRIX CONVOLUTION
  tensor_matrix_convolution : ntm_tensor_matrix_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_tensor_matrix_convolution,
      READY => ready_tensor_matrix_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_convolution,
      DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_matrix_convolution,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_convolution,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_convolution,

      DATA_I_ENABLE => data_i_enable_tensor_matrix_convolution,
      DATA_J_ENABLE => data_j_enable_tensor_matrix_convolution,
      DATA_K_ENABLE => data_k_enable_tensor_matrix_convolution,

      DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_convolution,
      DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_tensor_matrix_convolution,
      SIZE_A_J_IN => size_a_j_in_tensor_matrix_convolution,
      SIZE_A_K_IN => size_a_k_in_tensor_matrix_convolution,
      SIZE_B_I_IN => size_b_i_in_tensor_matrix_convolution,
      SIZE_B_J_IN => size_b_j_in_tensor_matrix_convolution,
      DATA_A_IN   => data_a_in_tensor_matrix_convolution,
      DATA_B_IN   => data_b_in_tensor_matrix_convolution,
      DATA_OUT    => data_out_tensor_matrix_convolution
      );

  -- MATRIX VECTOR CONVOLUTION
  matrix_vector_convolution : ntm_matrix_vector_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_vector_convolution,
      READY => ready_matrix_vector_convolution,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_convolution,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_convolution,
      DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_convolution,

      DATA_I_ENABLE => data_i_enable_matrix_vector_convolution,
      DATA_J_ENABLE => data_j_enable_matrix_vector_convolution,

      DATA_OUT_ENABLE => data_out_enable_matrix_vector_convolution,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_vector_convolution,
      SIZE_A_J_IN => size_a_j_in_matrix_vector_convolution,
      SIZE_B_IN   => size_b_in_matrix_vector_convolution,

      DATA_A_IN => data_a_in_matrix_vector_convolution,
      DATA_B_IN => data_b_in_matrix_vector_convolution,
      DATA_OUT  => data_out_matrix_vector_convolution
      );

  -- VECTOR TANH
  vector_tanh_function : ntm_vector_tanh_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_tanh,
      READY => ready_vector_tanh,

      DATA_IN_ENABLE => data_in_enable_vector_tanh,

      DATA_OUT_ENABLE => data_out_enable_vector_tanh,

      -- DATA
      SIZE_IN  => size_in_vector_tanh,
      DATA_IN  => data_in_vector_tanh,
      DATA_OUT => data_out_vector_tanh
      );

end architecture;
