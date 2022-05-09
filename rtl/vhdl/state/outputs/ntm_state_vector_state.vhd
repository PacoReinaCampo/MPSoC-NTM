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

    DATA_U_IN_ENABLE : in std_logic;

    DATA_U_ENABLE : out std_logic;

    DATA_X_OUT_ENABLE : out std_logic;

    -- DATA
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

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

    DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_state_vector_state_architecture of ntm_state_vector_state is

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_a_in_fsm is (
    STARTER_A_IN_STATE,                 -- STEP 0
    INPUT_A_IN_I_STATE,                 -- STEP 1
    INPUT_A_IN_J_STATE,                 -- STEP 2
    CLEAN_A_IN_I_STATE,                 -- STEP 3
    CLEAN_A_IN_J_STATE                  -- STEP 4
    );

  type controller_b_in_fsm is (
    STARTER_B_IN_STATE,                 -- STEP 0
    INPUT_B_IN_I_STATE,                 -- STEP 1
    INPUT_B_IN_J_STATE,                 -- STEP 2
    CLEAN_B_IN_I_STATE,                 -- STEP 3
    CLEAN_B_IN_J_STATE                  -- STEP 4
    );

  type controller_c_in_fsm is (
    STARTER_C_IN_STATE,                 -- STEP 0
    INPUT_C_IN_I_STATE,                 -- STEP 1
    INPUT_C_IN_J_STATE,                 -- STEP 2
    CLEAN_C_IN_I_STATE,                 -- STEP 3
    CLEAN_C_IN_J_STATE                  -- STEP 4
    );

  type controller_d_in_fsm is (
    STARTER_D_IN_STATE,                 -- STEP 0
    INPUT_D_IN_I_STATE,                 -- STEP 1
    INPUT_D_IN_J_STATE,                 -- STEP 2
    CLEAN_D_IN_I_STATE,                 -- STEP 3
    CLEAN_D_IN_J_STATE                  -- STEP 4
    );

  type controller_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_J_STATE,                 -- STEP 2
    CLEAN_K_IN_I_STATE,                 -- STEP 3
    CLEAN_K_IN_J_STATE                  -- STEP 4
    );

  type controller_u_in_fsm is (
    STARTER_U_IN_STATE,                 -- STEP 0
    INPUT_U_IN_STATE,                   -- STEP 1
    CLEAN_U_IN_STATE                    -- STEP 2
    );

  type controller_x_out_fsm is (
    STARTER_X_OUT_STATE,                -- STEP 0
    CLEAN_X_OUT_STATE,                  -- STEP 2
    OUTPUT_X_OUT_STATE                  -- STEP 1
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_a_in_fsm_int : controller_a_in_fsm;
  signal controller_b_in_fsm_int : controller_b_in_fsm;
  signal controller_c_in_fsm_int : controller_c_in_fsm;
  signal controller_d_in_fsm_int : controller_d_in_fsm;

  signal controller_k_in_fsm_int : controller_k_in_fsm;

  signal controller_u_in_fsm_int : controller_u_in_fsm;

  signal controller_x_out_fsm_int : controller_x_out_fsm;

  -- Buffer
  signal matrix_a_in_int : matrix_buffer;
  signal matrix_b_in_int : matrix_buffer;
  signal matrix_c_in_int : matrix_buffer;
  signal matrix_d_in_int : matrix_buffer;

  signal matrix_k_in_int : matrix_buffer;

  signal vector_u_in_int : vector_buffer;

  signal vector_x_out_int : vector_buffer;

  -- Control Internal
  signal index_i_a_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_a_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_c_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_c_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_x_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;
  signal data_c_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;

  signal data_k_in_enable_int : std_logic;

  signal data_u_in_enable_int : std_logic;

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

  -- VECTOR FLOAT ADDER
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

  -- MATRIX VECTOR PRODUCT
  -- CONTROL
  signal start_matrix_vector_product : std_logic;
  signal ready_matrix_vector_product : std_logic;

  signal data_a_in_i_enable_matrix_vector_product : std_logic;
  signal data_a_in_j_enable_matrix_vector_product : std_logic;
  signal data_b_in_enable_matrix_vector_product   : std_logic;

  signal data_i_enable_matrix_vector_product : std_logic;
  signal data_j_enable_matrix_vector_product : std_logic;

  signal data_out_enable_matrix_vector_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_matrix_vector_product   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_vector_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_vector_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_vector_product    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- x(k+1) = A·x(k) + B·u(k)
  -- y(k) = C·x(k) + D·u(k)

  -- x(k) = exp(A,k)·x(0) + summation(exp(A,k-j-1)·B·u(j))[j in 0 to k-1]

  -- CONTROL
  a_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_A_I_ENABLE <= '0';
      DATA_A_J_ENABLE <= '0';

      -- Control Internal
      index_i_a_in_loop <= ZERO_CONTROL;
      index_j_a_in_loop <= ZERO_CONTROL;

      data_a_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_a_in_fsm_int is
        when STARTER_A_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_a_in_loop <= ZERO_CONTROL;
            index_j_a_in_loop <= ZERO_CONTROL;

            data_a_in_enable_int <= '0';

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_I_STATE;
          else
            -- Control Outputs
            DATA_A_I_ENABLE <= '0';
            DATA_A_J_ENABLE <= '0';
          end if;

        when INPUT_A_IN_I_STATE =>      -- STEP 1

          if ((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_a_in_int(to_integer(unsigned(index_i_a_in_loop)), to_integer(unsigned(index_j_a_in_loop))) <= DATA_A_IN;

            -- FSM Control
            controller_a_in_fsm_int <= CLEAN_A_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_A_I_ENABLE <= '0';
          DATA_A_J_ENABLE <= '0';

        when INPUT_A_IN_J_STATE =>      -- STEP 2

          if (DATA_A_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_a_in_int(to_integer(unsigned(index_i_a_in_loop)), to_integer(unsigned(index_j_a_in_loop))) <= DATA_A_IN;

            -- FSM Control
            if (unsigned(index_j_a_in_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
              controller_a_in_fsm_int <= CLEAN_A_IN_I_STATE;
            else
              controller_a_in_fsm_int <= CLEAN_A_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_A_J_ENABLE <= '0';

        when CLEAN_A_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_a_in_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_a_in_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_a_in_loop <= ZERO_CONTROL;
            index_j_a_in_loop <= ZERO_CONTROL;

            data_a_in_enable_int <= '1';

            -- FSM Control
            controller_a_in_fsm_int <= STARTER_A_IN_STATE;
          elsif ((unsigned(index_i_a_in_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_a_in_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_a_in_loop <= std_logic_vector(unsigned(index_i_a_in_loop) + unsigned(ONE_CONTROL));
            index_j_a_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_I_STATE;
          end if;

        when CLEAN_A_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_a_in_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_j_a_in_loop <= std_logic_vector(unsigned(index_j_a_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_a_in_fsm_int <= INPUT_A_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_a_in_fsm_int <= STARTER_A_IN_STATE;
      end case;
    end if;
  end process;

  b_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_B_I_ENABLE <= '0';
      DATA_B_J_ENABLE <= '0';

      -- Control Internal
      index_i_b_in_loop <= ZERO_CONTROL;
      index_j_b_in_loop <= ZERO_CONTROL;

      data_b_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_b_in_fsm_int is
        when STARTER_B_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= ZERO_CONTROL;
            index_j_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_I_STATE;
          else
            -- Control Outputs
            DATA_B_I_ENABLE <= '0';
            DATA_B_J_ENABLE <= '0';
          end if;

        when INPUT_B_IN_I_STATE =>      -- STEP 1

          if ((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_b_in_loop)), to_integer(unsigned(index_j_b_in_loop))) <= DATA_B_IN;

            -- FSM Control
            controller_b_in_fsm_int <= CLEAN_B_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_B_I_ENABLE <= '0';
          DATA_B_J_ENABLE <= '0';

        when INPUT_B_IN_J_STATE =>      -- STEP 2

          if (DATA_B_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_b_in_loop)), to_integer(unsigned(index_j_b_in_loop))) <= DATA_B_IN;

            -- FSM Control
            if (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
              controller_b_in_fsm_int <= CLEAN_B_IN_I_STATE;
            else
              controller_b_in_fsm_int <= CLEAN_B_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_B_J_ENABLE <= '0';

        when CLEAN_B_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_b_in_loop) = unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= ZERO_CONTROL;
            index_j_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '1';

            -- FSM Control
            controller_b_in_fsm_int <= STARTER_B_IN_STATE;
          elsif ((unsigned(index_i_b_in_loop) < unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= std_logic_vector(unsigned(index_i_b_in_loop) + unsigned(ONE_CONTROL));
            index_j_b_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_I_STATE;
          end if;

        when CLEAN_B_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_b_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_j_b_in_loop <= std_logic_vector(unsigned(index_j_b_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_in_fsm_int <= STARTER_B_IN_STATE;
      end case;
    end if;
  end process;

  c_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_C_I_ENABLE <= '0';
      DATA_C_J_ENABLE <= '0';

      -- Control Internal
      index_i_c_in_loop <= ZERO_CONTROL;
      index_j_c_in_loop <= ZERO_CONTROL;

      data_c_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_c_in_fsm_int is
        when STARTER_C_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_c_in_loop <= ZERO_CONTROL;
            index_j_c_in_loop <= ZERO_CONTROL;

            data_c_in_enable_int <= '0';

            -- FSM Control
            controller_c_in_fsm_int <= INPUT_C_IN_I_STATE;
          else
            -- Control Outputs
            DATA_C_I_ENABLE <= '0';
            DATA_C_J_ENABLE <= '0';
          end if;

        when INPUT_C_IN_I_STATE =>      -- STEP 1

          if ((DATA_C_IN_I_ENABLE = '1') and (DATA_C_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_c_in_int(to_integer(unsigned(index_i_c_in_loop)), to_integer(unsigned(index_j_c_in_loop))) <= DATA_C_IN;

            -- FSM Control
            controller_c_in_fsm_int <= CLEAN_C_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_C_I_ENABLE <= '0';
          DATA_C_J_ENABLE <= '0';

        when INPUT_C_IN_J_STATE =>      -- STEP 2

          if (DATA_C_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_c_in_int(to_integer(unsigned(index_i_c_in_loop)), to_integer(unsigned(index_j_c_in_loop))) <= DATA_C_IN;

            -- FSM Control
            if (unsigned(index_j_c_in_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL)) then
              controller_c_in_fsm_int <= CLEAN_C_IN_I_STATE;
            else
              controller_c_in_fsm_int <= CLEAN_C_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_C_J_ENABLE <= '0';

        when CLEAN_C_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_c_in_loop) = unsigned(SIZE_C_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_c_in_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_c_in_loop <= ZERO_CONTROL;
            index_j_c_in_loop <= ZERO_CONTROL;

            data_c_in_enable_int <= '1';

            -- FSM Control
            controller_c_in_fsm_int <= STARTER_C_IN_STATE;
          elsif ((unsigned(index_i_c_in_loop) < unsigned(SIZE_C_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_c_in_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_c_in_loop <= std_logic_vector(unsigned(index_i_c_in_loop) + unsigned(ONE_CONTROL));
            index_j_c_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_c_in_fsm_int <= INPUT_C_IN_I_STATE;
          end if;

        when CLEAN_C_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_c_in_loop) < unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_j_c_in_loop <= std_logic_vector(unsigned(index_j_c_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_c_in_fsm_int <= INPUT_C_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_c_in_fsm_int <= STARTER_C_IN_STATE;
      end case;
    end if;
  end process;

  d_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_D_I_ENABLE <= '0';
      DATA_D_J_ENABLE <= '0';

      -- Control Internal
      index_i_d_in_loop <= ZERO_CONTROL;
      index_j_d_in_loop <= ZERO_CONTROL;

      data_d_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_d_in_fsm_int is
        when STARTER_D_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_j_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '0';

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          else
            -- Control Outputs
            DATA_D_I_ENABLE <= '0';
            DATA_D_J_ENABLE <= '0';
          end if;

        when INPUT_D_IN_I_STATE =>      -- STEP 1

          if ((DATA_D_IN_I_ENABLE = '1') and (DATA_D_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_j_d_in_loop))) <= DATA_D_IN;

            -- FSM Control
            controller_d_in_fsm_int <= CLEAN_D_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_D_I_ENABLE <= '0';
          DATA_D_J_ENABLE <= '0';

        when INPUT_D_IN_J_STATE =>      -- STEP 2

          if (DATA_D_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_j_d_in_loop))) <= DATA_D_IN;

            -- FSM Control
            if (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_D_J_ENABLE <= '0';

        when CLEAN_D_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_d_in_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_j_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '1';

            -- FSM Control
            controller_d_in_fsm_int <= STARTER_D_IN_STATE;
          elsif ((unsigned(index_i_d_in_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= std_logic_vector(unsigned(index_i_d_in_loop) + unsigned(ONE_CONTROL));
            index_j_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          end if;

        when CLEAN_D_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_d_in_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_j_d_in_loop <= std_logic_vector(unsigned(index_j_d_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_in_fsm_int <= STARTER_D_IN_STATE;
      end case;
    end if;
  end process;

  k_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_K_I_ENABLE <= '0';
      DATA_K_J_ENABLE <= '0';

      -- Control Internal
      index_i_k_in_loop <= ZERO_CONTROL;
      index_j_k_in_loop <= ZERO_CONTROL;

      data_k_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_in_fsm_int is
        when STARTER_K_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_j_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '0';

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          else
            -- Control Outputs
            DATA_K_I_ENABLE <= '0';
            DATA_K_J_ENABLE <= '0';
          end if;

        when INPUT_K_IN_I_STATE =>      -- STEP 1

          if ((DATA_K_IN_I_ENABLE = '1') and (DATA_K_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_j_k_in_loop))) <= DATA_K_IN;

            -- FSM Control
            controller_k_in_fsm_int <= CLEAN_K_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_K_I_ENABLE <= '0';
          DATA_K_J_ENABLE <= '0';

        when INPUT_K_IN_J_STATE =>      -- STEP 2

          if (DATA_K_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_j_k_in_loop))) <= DATA_K_IN;

            -- FSM Control
            if (unsigned(index_j_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_K_J_ENABLE <= '0';

        when CLEAN_K_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_j_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '1';

            -- FSM Control
            controller_k_in_fsm_int <= STARTER_K_IN_STATE;
          elsif ((unsigned(index_i_k_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_k_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= std_logic_vector(unsigned(index_i_k_in_loop) + unsigned(ONE_CONTROL));
            index_j_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          end if;

        when CLEAN_K_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_k_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_j_k_in_loop <= std_logic_vector(unsigned(index_j_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_J_STATE;
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
      DATA_U_ENABLE <= '0';

      -- Control Internal
      index_u_in_loop <= ZERO_CONTROL;

      data_u_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_u_in_fsm_int is
        when STARTER_U_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_U_ENABLE <= '1';

            -- Control Internal
            index_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '0';

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_STATE;
          else
            -- Control Outputs
            DATA_U_ENABLE <= '0';
          end if;

        when INPUT_U_IN_STATE =>        -- STEP 1

          if (DATA_U_IN_ENABLE = '1') then
            -- Data Inputs
            vector_u_in_int(to_integer(unsigned(index_u_in_loop))) <= DATA_U_IN;

            -- FSM Control
            controller_u_in_fsm_int <= CLEAN_U_IN_STATE;
          end if;

          -- Control Outputs
          DATA_U_ENABLE <= '0';

        when CLEAN_U_IN_STATE =>        -- STEP 2

          if (unsigned(index_u_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_U_ENABLE <= '1';

            -- Control Internal
            index_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '1';

            -- FSM Control
            controller_u_in_fsm_int <= STARTER_U_IN_STATE;
          elsif (unsigned(index_u_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_U_ENABLE <= '1';

            -- Control Internal
            index_u_in_loop <= std_logic_vector(unsigned(index_u_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_u_in_fsm_int <= STARTER_U_IN_STATE;
      end case;
    end if;
  end process;

  x_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_X_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_X_OUT_ENABLE <= '0';

      -- Control Internal
      index_x_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_x_out_fsm_int is
        when STARTER_X_OUT_STATE =>     -- STEP 0
          if (data_a_in_enable_int = '1' and data_b_in_enable_int = '1' and data_c_in_enable_int = '1' and data_d_in_enable_int = '1' and data_k_in_enable_int = '1' and data_u_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_x_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_out_fsm_int <= CLEAN_X_OUT_STATE;
          end if;

        when CLEAN_X_OUT_STATE =>       -- STEP 1
          -- Control Outputs
          DATA_X_OUT_ENABLE <= '0';

          -- FSM Control
          controller_x_out_fsm_int <= OUTPUT_X_OUT_STATE;

        when OUTPUT_X_OUT_STATE =>      -- STEP 2

          if (unsigned(index_x_out_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_X_OUT <= vector_x_out_int(to_integer(unsigned(index_x_out_loop)));

            -- Control Outputs
            READY <= '1';

            DATA_X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_out_fsm_int <= STARTER_X_OUT_STATE;
          elsif (unsigned(index_x_out_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_X_OUT <= vector_x_out_int(to_integer(unsigned(index_x_out_loop)));

            -- Control Outputs
            DATA_X_OUT_ENABLE <= '1';

            -- Control Internal
            index_x_out_loop <= std_logic_vector(unsigned(index_x_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_x_out_fsm_int <= CLEAN_X_OUT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_x_out_fsm_int <= STARTER_X_OUT_STATE;
      end case;
    end if;
  end process;

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

  -- VECTOR FLOAT ADDER
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

  -- MATRIX VECTOR PRODUCT
  matrix_vector_product : ntm_matrix_vector_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_vector_product,
      READY => ready_matrix_vector_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_vector_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_vector_product,
      DATA_B_IN_ENABLE   => data_b_in_enable_matrix_vector_product,

      DATA_I_ENABLE => data_i_enable_matrix_vector_product,
      DATA_J_ENABLE => data_j_enable_matrix_vector_product,

      DATA_OUT_ENABLE => data_out_enable_matrix_vector_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_vector_product,
      SIZE_A_J_IN => size_a_j_in_matrix_vector_product,
      SIZE_B_IN   => size_b_in_matrix_vector_product,
      DATA_A_IN   => data_a_in_matrix_vector_product,
      DATA_B_IN   => data_b_in_matrix_vector_product,
      DATA_OUT    => data_out_matrix_vector_product
      );

end architecture;