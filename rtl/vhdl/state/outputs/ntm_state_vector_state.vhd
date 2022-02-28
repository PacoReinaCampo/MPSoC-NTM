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
use work.ntm_state_pkg.all;

entity ntm_state_vector_state is
  generic (
    DATA_SIZE    : integer := 32;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_C_IN_I_ENABLE : in std_logic;
    DATA_C_IN_J_ENABLE : in std_logic;
    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_A_I_ENABLE : out std_logic;
    DATA_A_J_ENABLE : out std_logic;
    DATA_B_I_ENABLE : out std_logic;
    DATA_B_J_ENABLE : out std_logic;
    DATA_C_I_ENABLE : out std_logic;
    DATA_C_J_ENABLE : out std_logic;
    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_X_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_state_vector_state_architecture of ntm_state_vector_state is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type state_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_I_STATE,                -- STEP 1
    INPUT_FIRST_J_STATE,                -- STEP 2
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 3
    MATRIX_FIRST_PRODUCT_J_STATE,       -- STEP 4
    MATRIX_ADDER_I_STATE,               -- STEP 5
    MATRIX_ADDER_J_STATE,               -- STEP 6
    MATRIX_INVERSE_I_STATE,             -- STEP 7
    MATRIX_INVERSE_J_STATE,             -- STEP 8
    INPUT_SECOND_I_STATE,               -- STEP 9
    INPUT_SECOND_J_STATE,               -- STEP 10
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 11
    MATRIX_SECOND_PRODUCT_J_STATE       -- STEP 12
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal state_ctrl_fsm_int : state_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_state_int : std_logic;
  signal data_a_in_j_state_int : std_logic;
  signal data_b_in_i_state_int : std_logic;
  signal data_b_in_j_state_int : std_logic;

  signal ready_enable_matrix_state       : std_logic;
  signal ready_enable_matrix_input       : std_logic;
  signal ready_enable_matrix_output      : std_logic;
  signal ready_enable_matrix_feedforward : std_logic;

  -- MATRIX STATE
  -- CONTROL
  signal start_matrix_state : std_logic;
  signal ready_matrix_state : std_logic;

  signal data_a_in_i_enable_matrix_state : std_logic;
  signal data_a_in_j_enable_matrix_state : std_logic;
  signal data_b_in_i_enable_matrix_state : std_logic;
  signal data_b_in_j_enable_matrix_state : std_logic;
  signal data_c_in_i_enable_matrix_state : std_logic;
  signal data_c_in_j_enable_matrix_state : std_logic;
  signal data_d_in_i_enable_matrix_state : std_logic;
  signal data_d_in_j_enable_matrix_state : std_logic;

  signal data_a_i_enable_matrix_state : std_logic;
  signal data_a_j_enable_matrix_state : std_logic;
  signal data_b_i_enable_matrix_state : std_logic;
  signal data_b_j_enable_matrix_state : std_logic;
  signal data_c_i_enable_matrix_state : std_logic;
  signal data_c_j_enable_matrix_state : std_logic;
  signal data_d_i_enable_matrix_state : std_logic;
  signal data_d_j_enable_matrix_state : std_logic;

  signal data_k_in_i_enable_matrix_state : std_logic;
  signal data_k_in_j_enable_matrix_state : std_logic;

  signal data_k_i_enable_matrix_state : std_logic;
  signal data_k_j_enable_matrix_state : std_logic;

  signal data_a_out_i_enable_matrix_state : std_logic;
  signal data_a_out_j_enable_matrix_state : std_logic;

  -- DATA
  signal size_a_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_state : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_c_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_a_out_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INPUT
  -- CONTROL
  signal start_matrix_input : std_logic;
  signal ready_matrix_input : std_logic;

  signal data_b_in_i_enable_matrix_input : std_logic;
  signal data_b_in_j_enable_matrix_input : std_logic;
  signal data_d_in_i_enable_matrix_input : std_logic;
  signal data_d_in_j_enable_matrix_input : std_logic;

  signal data_b_i_enable_matrix_input : std_logic;
  signal data_b_j_enable_matrix_input : std_logic;
  signal data_d_i_enable_matrix_input : std_logic;
  signal data_d_j_enable_matrix_input : std_logic;

  signal data_k_in_i_enable_matrix_input : std_logic;
  signal data_k_in_j_enable_matrix_input : std_logic;

  signal data_k_i_enable_matrix_input : std_logic;
  signal data_k_j_enable_matrix_input : std_logic;

  signal data_b_out_i_enable_matrix_input : std_logic;
  signal data_b_out_j_enable_matrix_input : std_logic;

  -- DATA
  signal size_b_in_i_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_j_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_input : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_b_in_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_b_out_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX OUTPUT
  -- CONTROL
  signal start_matrix_output : std_logic;
  signal ready_matrix_output : std_logic;

  signal data_c_in_i_enable_matrix_output : std_logic;
  signal data_c_in_j_enable_matrix_output : std_logic;
  signal data_d_in_i_enable_matrix_output : std_logic;
  signal data_d_in_j_enable_matrix_output : std_logic;

  signal data_c_i_enable_matrix_output : std_logic;
  signal data_c_j_enable_matrix_output : std_logic;
  signal data_d_i_enable_matrix_output : std_logic;
  signal data_d_j_enable_matrix_output : std_logic;

  signal data_k_in_i_enable_matrix_output : std_logic;
  signal data_k_in_j_enable_matrix_output : std_logic;

  signal data_k_i_enable_matrix_output : std_logic;
  signal data_k_j_enable_matrix_output : std_logic;

  signal data_c_out_i_enable_matrix_output : std_logic;
  signal data_c_out_j_enable_matrix_output : std_logic;

  -- DATA
  signal size_c_in_i_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_c_in_j_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_i_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_output : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_c_in_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_d_in_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_c_out_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX FEEDFORWARD
  -- CONTROL
  signal start_matrix_feedforward : std_logic;
  signal ready_matrix_feedforward : std_logic;

  signal data_d_in_i_enable_matrix_feedforward : std_logic;
  signal data_d_in_j_enable_matrix_feedforward : std_logic;

  signal data_d_i_enable_matrix_feedforward : std_logic;
  signal data_d_j_enable_matrix_feedforward : std_logic;

  signal data_k_in_i_enable_matrix_feedforward : std_logic;
  signal data_k_in_j_enable_matrix_feedforward : std_logic;

  signal data_k_i_enable_matrix_feedforward : std_logic;
  signal data_k_j_enable_matrix_feedforward : std_logic;

  signal data_d_out_i_matrix_feedforward : std_logic;
  signal data_d_out_j_matrix_feedforward : std_logic;

  -- DATA
  signal size_d_in_i_matrix_feedforward : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_d_in_j_matrix_feedforward : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_d_in_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_k_in_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_d_out_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_float_adder : std_logic;
  signal ready_matrix_float_adder : std_logic;

  signal operation_matrix_float_adder : std_logic;

  signal data_a_in_i_enable_matrix_float_adder : std_logic;
  signal data_a_in_j_enable_matrix_float_adder : std_logic;
  signal data_b_in_i_enable_matrix_float_adder : std_logic;
  signal data_b_in_j_enable_matrix_float_adder : std_logic;

  signal data_out_i_enable_matrix_float_adder : std_logic;
  signal data_out_j_enable_matrix_float_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_i_enable_matrix_product : std_logic;
  signal data_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX EXPONENTIATOR
  -- CONTROL
  signal start_matrix_exponentiator : std_logic;
  signal ready_matrix_exponentiator : std_logic;

  signal data_in_i_enable_matrix_exponentiator : std_logic;
  signal data_in_j_enable_matrix_exponentiator : std_logic;

  signal data_out_i_enable_matrix_exponentiator : std_logic;
  signal data_out_j_enable_matrix_exponentiator : std_logic;

  -- DATA
  signal size_i_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- x(k+1) = A·x(k) + B·u(k)
  -- y(k) = C·x(k) + D·u(k)

  -- y(k) = C·exp(A,k)·x(0) + summation(C·exp(A,k-j)·B·u(j))[j in 0 to k-1] + D·u(k)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_X_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case state_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_i_loop <= ZERO_CONTROL;
          index_j_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- FSM Control
            state_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          end if;

        when INPUT_FIRST_I_STATE =>     -- STEP 1 D,K

        when INPUT_FIRST_J_STATE =>     -- STEP 2 D,K

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 3 (D·K)

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 4 (D·K)

        when MATRIX_ADDER_I_STATE =>    -- STEP 5 (I+D·K)

        when MATRIX_ADDER_J_STATE =>    -- STEP 6 (I+D·K)

        when MATRIX_INVERSE_I_STATE =>  -- STEP 7 inv(I+D·K)

        when MATRIX_INVERSE_J_STATE =>  -- STEP 8 inv(I+D·K)

        when INPUT_SECOND_I_STATE =>    -- STEP 9 C

        when INPUT_SECOND_J_STATE =>    -- STEP 10 C

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 11 inv(I+D·K)·C

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 12 inv(I+D·K)·C

        when others =>
          -- FSM Control
          state_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  DATA_A_I_ENABLE <= data_a_i_enable_matrix_state;
  DATA_A_J_ENABLE <= data_a_j_enable_matrix_state;
  DATA_B_I_ENABLE <= data_b_i_enable_matrix_state and data_b_i_enable_matrix_input;
  DATA_B_J_ENABLE <= data_b_j_enable_matrix_state and data_b_j_enable_matrix_input;
  DATA_C_I_ENABLE <= data_c_i_enable_matrix_state and data_c_i_enable_matrix_output;
  DATA_C_J_ENABLE <= data_c_j_enable_matrix_state and data_c_j_enable_matrix_output;
  DATA_D_I_ENABLE <= data_d_i_enable_matrix_state and data_d_i_enable_matrix_input and data_d_i_enable_matrix_output and data_d_i_enable_matrix_feedforward;
  DATA_D_J_ENABLE <= data_d_j_enable_matrix_state and data_d_j_enable_matrix_input and data_d_j_enable_matrix_output and data_d_j_enable_matrix_feedforward;

  -- MATRIX STATE
  -- CONTROL
  start_matrix_state <= START;

  ready_enable_matrix_state <= ready_matrix_state;

  data_a_in_i_enable_matrix_state <= DATA_A_IN_I_ENABLE;
  data_a_in_j_enable_matrix_state <= DATA_A_IN_J_ENABLE;
  data_b_in_i_enable_matrix_state <= DATA_B_IN_I_ENABLE;
  data_b_in_j_enable_matrix_state <= DATA_B_IN_J_ENABLE;
  data_c_in_i_enable_matrix_state <= DATA_C_IN_I_ENABLE;
  data_c_in_j_enable_matrix_state <= DATA_C_IN_J_ENABLE;
  data_d_in_i_enable_matrix_state <= DATA_D_IN_I_ENABLE;
  data_d_in_j_enable_matrix_state <= DATA_D_IN_J_ENABLE;

  data_k_in_i_enable_matrix_state <= DATA_K_IN_I_ENABLE;
  data_k_in_j_enable_matrix_state <= DATA_K_IN_J_ENABLE;

  --signal data_k_i_enable_matrix_state;
  --signal data_k_j_enable_matrix_state;

  --signal data_a_out_i_enable_matrix_state;
  --signal data_a_out_j_enable_matrix_state;

  -- DATA
  size_a_in_i_matrix_state <= SIZE_A_I_IN;
  size_a_in_j_matrix_state <= SIZE_A_J_IN;
  size_b_in_i_matrix_state <= SIZE_B_I_IN;
  size_b_in_j_matrix_state <= SIZE_B_J_IN;
  size_c_in_i_matrix_state <= SIZE_C_I_IN;
  size_c_in_j_matrix_state <= SIZE_C_J_IN;
  size_d_in_i_matrix_state <= SIZE_D_I_IN;
  size_d_in_j_matrix_state <= SIZE_D_J_IN;

  data_a_in_matrix_state <= DATA_A_IN;
  data_b_in_matrix_state <= DATA_B_IN;
  data_c_in_matrix_state <= DATA_C_IN;
  data_d_in_matrix_state <= DATA_D_IN;

  data_k_in_matrix_state <= DATA_K_IN;

  --signal data_a_out_matrix_state : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INPUT
  -- CONTROL
  start_matrix_input <= START;

  ready_enable_matrix_input <= ready_matrix_input;

  data_b_in_i_enable_matrix_input <= DATA_B_IN_I_ENABLE;
  data_b_in_j_enable_matrix_input <= DATA_B_IN_J_ENABLE;
  data_d_in_i_enable_matrix_input <= DATA_D_IN_I_ENABLE;
  data_d_in_j_enable_matrix_input <= DATA_D_IN_J_ENABLE;

  data_k_in_i_enable_matrix_input <= DATA_K_IN_I_ENABLE;
  data_k_in_j_enable_matrix_input <= DATA_K_IN_J_ENABLE;

  --signal data_k_i_enable_matrix_input : std_logic;
  --signal data_k_j_enable_matrix_input : std_logic;

  --signal data_b_out_i_enable_matrix_input : std_logic;
  --signal data_b_out_j_enable_matrix_input : std_logic;

  -- DATA
  size_b_in_i_matrix_input <= SIZE_B_I_IN;
  size_b_in_j_matrix_input <= SIZE_B_J_IN;
  size_d_in_i_matrix_input <= SIZE_C_I_IN;
  size_d_in_j_matrix_input <= SIZE_C_J_IN;

  data_b_in_matrix_input <= DATA_B_IN;
  data_d_in_matrix_input <= DATA_D_IN;

  data_k_in_matrix_input <= DATA_K_IN;

  --signal data_b_out_matrix_input : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX OUTPUT
  -- CONTROL
  start_matrix_output <= START;

  ready_enable_matrix_output <= ready_matrix_output;

  data_c_in_i_enable_matrix_output <= DATA_C_IN_I_ENABLE;
  data_c_in_j_enable_matrix_output <= DATA_C_IN_J_ENABLE;
  data_d_in_i_enable_matrix_output <= DATA_D_IN_I_ENABLE;
  data_d_in_j_enable_matrix_output <= DATA_D_IN_J_ENABLE;

  data_k_in_i_enable_matrix_output <= DATA_K_IN_I_ENABLE;
  data_k_in_j_enable_matrix_output <= DATA_K_IN_J_ENABLE;

  --signal data_k_i_enable_matrix_output : std_logic;
  --signal data_k_j_enable_matrix_output : std_logic;

  --signal data_c_out_i_enable_matrix_output : std_logic;
  --signal data_c_out_j_enable_matrix_output : std_logic;

  -- DATA
  size_c_in_i_matrix_output <= SIZE_C_I_IN;
  size_c_in_j_matrix_output <= SIZE_C_J_IN;
  size_d_in_i_matrix_output <= SIZE_D_I_IN;
  size_d_in_j_matrix_output <= SIZE_D_J_IN;

  data_c_in_matrix_output <= DATA_C_IN;
  data_d_in_matrix_output <= DATA_D_IN;

  data_k_in_matrix_output <= DATA_K_IN;

  --signal data_c_out_matrix_output : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX FEEDFORWARD
  -- CONTROL
  start_matrix_feedforward <= START;

  ready_enable_matrix_feedforward <= ready_matrix_feedforward;

  data_d_in_i_enable_matrix_feedforward <= DATA_D_IN_I_ENABLE;
  data_d_in_j_enable_matrix_feedforward <= DATA_D_IN_J_ENABLE;

  data_k_in_i_enable_matrix_feedforward <= DATA_K_IN_I_ENABLE;
  data_k_in_j_enable_matrix_feedforward <= DATA_K_IN_J_ENABLE;

  --signal data_k_i_enable_matrix_feedforward : std_logic;
  --signal data_k_j_enable_matrix_feedforward : std_logic;

  --signal data_d_out_i_matrix_feedforward : std_logic;
  --signal data_d_out_j_matrix_feedforward : std_logic;

  -- DATA
  size_d_in_i_matrix_feedforward <= SIZE_D_I_IN;
  size_d_in_j_matrix_feedforward <= SIZE_D_J_IN;

  data_d_in_matrix_feedforward <= DATA_D_IN;

  data_k_in_matrix_feedforward <= DATA_K_IN;

  --signal data_d_out_matrix_feedforward : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX STATE
  state_matrix_state : ntm_state_matrix_state
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_state,
      READY => ready_matrix_state,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_state,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_state,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_state,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_state,
      DATA_C_IN_I_ENABLE => data_c_in_i_enable_matrix_state,
      DATA_C_IN_J_ENABLE => data_c_in_j_enable_matrix_state,
      DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_state,
      DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_state,

      DATA_A_I_ENABLE => data_a_i_enable_matrix_state,
      DATA_A_J_ENABLE => data_a_j_enable_matrix_state,
      DATA_B_I_ENABLE => data_b_i_enable_matrix_state,
      DATA_B_J_ENABLE => data_b_j_enable_matrix_state,
      DATA_C_I_ENABLE => data_c_i_enable_matrix_state,
      DATA_C_J_ENABLE => data_c_j_enable_matrix_state,
      DATA_D_I_ENABLE => data_d_i_enable_matrix_state,
      DATA_D_J_ENABLE => data_d_j_enable_matrix_state,

      DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_state,
      DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_state,

      DATA_K_I_ENABLE => data_k_i_enable_matrix_state,
      DATA_K_J_ENABLE => data_k_j_enable_matrix_state,

      DATA_A_OUT_I_ENABLE => data_a_out_i_enable_matrix_state,
      DATA_A_OUT_J_ENABLE => data_a_out_j_enable_matrix_state,

      -- DATA
      SIZE_A_I_IN => size_a_in_i_matrix_state,
      SIZE_A_J_IN => size_a_in_j_matrix_state,
      SIZE_B_I_IN => size_b_in_i_matrix_state,
      SIZE_B_J_IN => size_b_in_j_matrix_state,
      SIZE_C_I_IN => size_c_in_i_matrix_state,
      SIZE_C_J_IN => size_c_in_j_matrix_state,
      SIZE_D_I_IN => size_d_in_i_matrix_state,
      SIZE_D_J_IN => size_d_in_j_matrix_state,

      DATA_A_IN => data_a_in_matrix_state,
      DATA_B_IN => data_b_in_matrix_state,
      DATA_C_IN => data_c_in_matrix_state,
      DATA_D_IN => data_d_in_matrix_state,

      DATA_K_IN => data_k_in_matrix_state,

      DATA_A_OUT => data_a_out_matrix_state
      );

  -- MATRIX INPUT
  state_matrix_input : ntm_state_matrix_input
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_input,
      READY => ready_matrix_input,

      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_input,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_input,
      DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_input,
      DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_input,

      DATA_B_I_ENABLE => data_b_i_enable_matrix_input,
      DATA_B_J_ENABLE => data_b_j_enable_matrix_input,
      DATA_D_I_ENABLE => data_d_i_enable_matrix_input,
      DATA_D_J_ENABLE => data_d_j_enable_matrix_input,

      DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_input,
      DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_input,

      DATA_K_I_ENABLE => data_k_i_enable_matrix_input,
      DATA_K_J_ENABLE => data_k_j_enable_matrix_input,

      DATA_B_OUT_I_ENABLE => data_b_out_i_enable_matrix_input,
      DATA_B_OUT_J_ENABLE => data_b_out_j_enable_matrix_input,

      -- DATA
      SIZE_B_I_IN => size_b_in_i_matrix_input,
      SIZE_B_J_IN => size_b_in_j_matrix_input,
      SIZE_D_I_IN => size_d_in_i_matrix_input,
      SIZE_D_J_IN => size_d_in_j_matrix_input,

      DATA_B_IN => data_b_in_matrix_input,
      DATA_D_IN => data_d_in_matrix_input,

      DATA_K_IN => data_k_in_matrix_input,

      DATA_B_OUT => data_b_out_matrix_input
      );

  -- MATRIX OUTPUT
  state_matrix_output : ntm_state_matrix_output
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_output,
      READY => ready_matrix_output,

      DATA_C_IN_I_ENABLE => data_c_in_i_enable_matrix_output,
      DATA_C_IN_J_ENABLE => data_c_in_j_enable_matrix_output,
      DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_output,
      DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_output,

      DATA_C_I_ENABLE => data_c_i_enable_matrix_output,
      DATA_C_J_ENABLE => data_c_j_enable_matrix_output,
      DATA_D_I_ENABLE => data_d_i_enable_matrix_output,
      DATA_D_J_ENABLE => data_d_j_enable_matrix_output,

      DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_output,
      DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_output,

      DATA_K_I_ENABLE => data_k_i_enable_matrix_output,
      DATA_K_J_ENABLE => data_k_j_enable_matrix_output,

      DATA_C_OUT_I_ENABLE => data_c_out_i_enable_matrix_output,
      DATA_C_OUT_J_ENABLE => data_c_out_j_enable_matrix_output,

      -- DATA
      SIZE_C_I_IN => size_c_in_i_matrix_output,
      SIZE_C_J_IN => size_c_in_j_matrix_output,
      SIZE_D_I_IN => size_d_in_i_matrix_output,
      SIZE_D_J_IN => size_d_in_j_matrix_output,

      DATA_C_IN => data_c_in_matrix_output,
      DATA_D_IN => data_d_in_matrix_output,

      DATA_K_IN => data_k_in_matrix_output,

      DATA_C_OUT => data_c_out_matrix_output
      );

  -- MATRIX FEEDFORWARD
  state_matrix_feedforward : ntm_state_matrix_feedforward
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_feedforward,
      READY => ready_matrix_feedforward,

      DATA_D_IN_I_ENABLE => data_d_in_i_enable_matrix_feedforward,
      DATA_D_IN_J_ENABLE => data_d_in_j_enable_matrix_feedforward,

      DATA_D_I_ENABLE => data_d_i_enable_matrix_feedforward,
      DATA_D_J_ENABLE => data_d_j_enable_matrix_feedforward,

      DATA_K_IN_I_ENABLE => data_k_in_i_enable_matrix_feedforward,
      DATA_K_IN_J_ENABLE => data_k_in_j_enable_matrix_feedforward,

      DATA_K_I_ENABLE => data_k_i_enable_matrix_feedforward,
      DATA_K_J_ENABLE => data_k_j_enable_matrix_feedforward,

      DATA_D_OUT_I_ENABLE => data_d_out_i_matrix_feedforward,
      DATA_D_OUT_J_ENABLE => data_d_out_j_matrix_feedforward,

      -- DATA
      SIZE_D_I_IN => size_d_in_i_matrix_feedforward,
      SIZE_D_J_IN => size_d_in_j_matrix_feedforward,

      DATA_D_IN => data_d_in_matrix_feedforward,

      DATA_K_IN => data_k_in_matrix_feedforward,

      DATA_D_OUT => data_d_out_matrix_feedforward
      );

  -- MATRIX ADDER
  matrix_float_adder : ntm_matrix_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_float_adder,
      READY => ready_matrix_float_adder,

      OPERATION => operation_matrix_float_adder,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_adder,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_adder,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_adder,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_adder,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_adder,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_adder,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_float_adder,
      SIZE_J_IN => size_j_in_matrix_float_adder,
      DATA_A_IN => data_a_in_matrix_float_adder,
      DATA_B_IN => data_b_in_matrix_float_adder,

      DATA_OUT => data_out_matrix_float_adder
      );

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_product,
      READY => ready_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      DATA_I_ENABLE => data_i_enable_matrix_product,
      DATA_J_ENABLE => data_j_enable_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_product,
      SIZE_A_J_IN => size_a_j_in_matrix_product,
      SIZE_B_I_IN => size_b_i_in_matrix_product,
      SIZE_B_J_IN => size_b_j_in_matrix_product,
      DATA_A_IN   => data_a_in_matrix_product,
      DATA_B_IN   => data_b_in_matrix_product,
      DATA_OUT    => data_out_matrix_product
      );

  -- MATRIX EXPONENTIATOR
  matrix_exponentiator_function : ntm_matrix_exponentiator_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_exponentiator,
      READY => ready_matrix_exponentiator,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_exponentiator,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_exponentiator,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_exponentiator,
      SIZE_J_IN => size_j_in_matrix_exponentiator,
      DATA_IN   => data_in_matrix_exponentiator,
      DATA_OUT  => data_out_matrix_exponentiator
      );

end architecture;
