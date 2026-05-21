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

use work.accelerator_arithmetic_vhdl_pkg.all;
use work.accelerator_math_vhdl_pkg.all;
use work.accelerator_core_vhdl_pkg.all;
use work.accelerator_lstm_controller_vhdl_pkg.all;

entity accelerator_output_vector is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    P_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    P_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    P_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    P_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    P_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    P_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    R_IN_K_ENABLE : in std_logic;       -- for j in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    R_OUT_K_ENABLE : out std_logic;     -- for j in 0 to W-1

    Q_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    Q_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    Q_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    Q_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_output_vector_architecture of accelerator_output_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- P_IN [R,Y,W], R_IN [Y,L]
  -- Q_IN [Y,L],   H_IN [L]

  -- Outputs:
  -- Y_OUT [Y]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_Y_STATE, CLEAN_IN_Y_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_Y_STATE, CLEAN_OUT_Y_STATE

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_p_in_fsm is (
    STARTER_P_IN_STATE,                 -- STEP 0
    INPUT_P_IN_I_STATE,                 -- STEP 1
    INPUT_P_IN_Y_STATE,                 -- STEP 2
    INPUT_P_IN_K_STATE,                 -- STEP 3
    CLEAN_P_IN_I_STATE,                 -- STEP 4
    CLEAN_P_IN_Y_STATE,                 -- STEP 5
    CLEAN_P_IN_K_STATE                  -- STEP 6
    );

  type controller_r_in_fsm is (
    STARTER_R_IN_STATE,                 -- STEP 0
    INPUT_R_IN_I_STATE,                 -- STEP 1
    INPUT_R_IN_K_STATE,                 -- STEP 2
    CLEAN_R_IN_I_STATE,                 -- STEP 3
    CLEAN_R_IN_K_STATE                  -- STEP 4
    );

  type controller_q_in_fsm is (
    STARTER_Q_IN_STATE,                 -- STEP 0
    INPUT_Q_IN_Y_STATE,                 -- STEP 1
    INPUT_Q_IN_L_STATE,                 -- STEP 2
    CLEAN_Q_IN_Y_STATE,                 -- STEP 3
    CLEAN_Q_IN_L_STATE                  -- STEP 4
    );

  type controller_h_in_fsm is (
    STARTER_H_IN_STATE,                 -- STEP 0
    INPUT_H_IN_L_STATE,                 -- STEP 1
    CLEAN_H_IN_L_STATE                  -- STEP 2
    );

  -- Ops
  type controller_tensor_matrix_product_fsm is (
    STARTER_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 0
    INPUT_I_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 1
    INPUT_J_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 2
    INPUT_K_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 3
    CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 4
    CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE,  -- STEP 5
    CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE   -- STEP 6
    );

  type controller_vector_summation_fsm is (
    STARTER_VECTOR_SUMMATION_STATE,       -- STEP 0
    INPUT_LENGTH_VECTOR_SUMMATION_STATE,  -- STEP 1
    INPUT_VECTOR_SUMMATION_STATE,         -- STEP 2
    CLEAN_LENGTH_VECTOR_SUMMATION_STATE,  -- STEP 3
    CLEAN_VECTOR_SUMMATION_STATE          -- STEP 4
    );

  type controller_matrix_vector_product_fsm is (
    STARTER_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_MATRIX_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_vector_float_adder_fsm is (
    STARTER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    INPUT_VECTOR_FLOAT_ADDER_STATE,     -- STEP 1
    CLEAN_VECTOR_FLOAT_ADDER_STATE      -- STEP 2
    );

  -- Output
  type controller_y_out_fsm is (
    STARTER_Y_OUT_STATE,                -- STEP 0
    CLEAN_Y_OUT_Y_STATE,                -- STEP 1
    OUTPUT_Y_OUT_Y_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_p_in_fsm_int : controller_p_in_fsm;
  signal controller_r_in_fsm_int : controller_r_in_fsm;
  signal controller_q_in_fsm_int : controller_q_in_fsm;
  signal controller_h_in_fsm_int : controller_h_in_fsm;

  -- Ops
  signal controller_tensor_matrix_product_fsm_int : controller_tensor_matrix_product_fsm;
  signal controller_vector_summation_fsm_int      : controller_vector_summation_fsm;
  signal controller_matrix_vector_product_fsm_int : controller_matrix_vector_product_fsm;
  signal controller_vector_float_adder_fsm_int    : controller_vector_float_adder_fsm;

  -- Output
  signal controller_y_out_fsm_int : controller_y_out_fsm;

  -- Buffer
  -- Input
  signal tensor_p_in_int : tensor_buffer;
  signal matrix_r_in_int : matrix_buffer;
  signal matrix_q_in_int : matrix_buffer;
  signal vector_h_in_int : vector_buffer;

  -- Ops
  signal tensor_operation_int : tensor_buffer;
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_y_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_i_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_y_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_y_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_tensor_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_length_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_summation_loop        : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_y_y_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_p_in_enable_int : std_logic;
  signal data_r_in_enable_int : std_logic;
  signal data_q_in_enable_int : std_logic;
  signal data_h_in_enable_int : std_logic;

  -- Ops
  signal data_tensor_matrix_product_enable_int : std_logic;
  signal data_vector_summation_enable_int      : std_logic;
  signal data_matrix_vector_product_enable_int : std_logic;
  signal data_vector_float_adder_enable_int    : std_logic;

  -- TENSOR MATRIX PRODUCT
  -- CONTROL
  signal start_tensor_matrix_product : std_logic;
  signal ready_tensor_matrix_product : std_logic;

  signal data_a_in_i_enable_tensor_matrix_product : std_logic;
  signal data_a_in_j_enable_tensor_matrix_product : std_logic;
  signal data_a_in_k_enable_tensor_matrix_product : std_logic;
  signal data_b_in_i_enable_tensor_matrix_product : std_logic;
  signal data_b_in_j_enable_tensor_matrix_product : std_logic;

  signal data_i_enable_tensor_matrix_product : std_logic;
  signal data_j_enable_tensor_matrix_product : std_logic;
  signal data_k_enable_tensor_matrix_product : std_logic;

  signal data_out_i_enable_tensor_matrix_product : std_logic;
  signal data_out_j_enable_tensor_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

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

  signal data_out_vector_float_adder       : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_divider : std_logic;

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_length_enable_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_enable_length_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)

  -- INPUT CONTROL
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

      case controller_r_in_fsm_int is
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
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
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
            controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
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
              controller_r_in_fsm_int <= CLEAN_R_IN_I_STATE;
            else
              controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
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
            controller_r_in_fsm_int <= STARTER_R_IN_STATE;
          elsif ((unsigned(index_i_r_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= std_logic_vector(unsigned(index_i_r_in_loop) + unsigned(ONE_CONTROL));
            index_k_r_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          end if;

        when CLEAN_R_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_r_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_in_loop <= std_logic_vector(unsigned(index_k_r_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_r_in_fsm_int <= STARTER_R_IN_STATE;
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

  h_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_in_loop <= ZERO_CONTROL;

      data_h_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_h_in_fsm_int is
        when STARTER_H_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '0';

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          else
            -- Control Outputs
            H_OUT_ENABLE <= '0';
          end if;

        when INPUT_H_IN_L_STATE =>      -- STEP 1

          if (H_IN_ENABLE = '1') then
            -- Data Inputs
            vector_h_in_int(to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
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
            controller_h_in_fsm_int <= STARTER_H_IN_STATE;
          elsif (unsigned(index_l_h_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= std_logic_vector(unsigned(index_l_h_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_h_in_fsm_int <= STARTER_H_IN_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  tensor_matrix_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_tensor_matrix_product <= '0';
      data_a_in_j_enable_tensor_matrix_product <= '0';
      data_a_in_k_enable_tensor_matrix_product <= '0';
      data_b_in_i_enable_tensor_matrix_product <= '0';
      data_b_in_j_enable_tensor_matrix_product <= '0';

      data_tensor_matrix_product_enable_int <= '0';

      index_i_tensor_matrix_product_loop <= ZERO_CONTROL;
      index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
      index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_tensor_matrix_product_fsm_int is
        when STARTER_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_tensor_matrix_product <= '0';
          data_a_in_j_enable_tensor_matrix_product <= '0';
          data_a_in_k_enable_tensor_matrix_product <= '0';
          data_b_in_i_enable_tensor_matrix_product <= '0';
          data_b_in_j_enable_tensor_matrix_product <= '0';

          data_tensor_matrix_product_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_r_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_tensor_matrix_product <= SIZE_R_IN;
            size_a_j_in_tensor_matrix_product <= SIZE_L_IN;
            size_a_k_in_tensor_matrix_product <= SIZE_W_IN;
            size_b_i_in_tensor_matrix_product <= SIZE_R_IN;
            size_b_j_in_tensor_matrix_product <= SIZE_L_IN;

            -- Control Internal
            index_i_tensor_matrix_product_loop <= ZERO_CONTROL;
            index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
            index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_tensor_matrix_product_fsm_int <= INPUT_I_TENSOR_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_I_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

          -- Control Internal
          if (unsigned(index_i_tensor_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_tensor_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_tensor_matrix_product_loop) = unsigned(ZERO_CONTROL)) then
            start_tensor_matrix_product <= '1';
          end if;

          data_a_in_i_enable_tensor_matrix_product <= '1';
          data_a_in_j_enable_tensor_matrix_product <= '1';
          data_a_in_k_enable_tensor_matrix_product <= '1';
          data_b_in_i_enable_tensor_matrix_product <= '1';
          data_b_in_j_enable_tensor_matrix_product <= '1';

          -- FSM Control
          controller_tensor_matrix_product_fsm_int <= CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE;

        when INPUT_J_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

          data_a_in_j_enable_tensor_matrix_product <= '1';
          data_a_in_k_enable_tensor_matrix_product <= '1';
          data_b_in_j_enable_tensor_matrix_product <= '1';

          -- FSM Control
          if (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_tensor_matrix_product_fsm_int <= CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE;
          else
            controller_tensor_matrix_product_fsm_int <= CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_K_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));
          data_b_in_tensor_matrix_product <= tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop)));

          -- Control Internal
          data_a_in_k_enable_tensor_matrix_product <= '1';

          -- FSM Control
          if ((unsigned(index_j_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            controller_tensor_matrix_product_fsm_int <= CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE;
          elsif (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_tensor_matrix_product_fsm_int <= CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE;
          else
            controller_tensor_matrix_product_fsm_int <= CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE;
          end if;

        when CLEAN_I_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_tensor_matrix_product = '1' and data_j_enable_tensor_matrix_product = '1' and data_k_enable_tensor_matrix_product = '1') then
            if ((unsigned(index_j_tensor_matrix_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              data_tensor_matrix_product_enable_int <= '1';

              index_i_tensor_matrix_product_loop <= ZERO_CONTROL;
              index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
              index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= STARTER_TENSOR_MATRIX_PRODUCT_STATE;
            elsif ((unsigned(index_j_tensor_matrix_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              index_i_tensor_matrix_product_loop <= std_logic_vector(unsigned(index_i_tensor_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_j_tensor_matrix_product_loop <= ZERO_CONTROL;
              index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= INPUT_J_TENSOR_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_tensor_matrix_product <= '0';

            data_a_in_i_enable_tensor_matrix_product <= '0';
            data_a_in_j_enable_tensor_matrix_product <= '0';
            data_a_in_k_enable_tensor_matrix_product <= '0';
            data_b_in_i_enable_tensor_matrix_product <= '0';
            data_b_in_j_enable_tensor_matrix_product <= '0';
          end if;

        when CLEAN_J_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_j_enable_tensor_matrix_product = '1' and data_k_enable_tensor_matrix_product = '1') then
            if ((unsigned(index_j_tensor_matrix_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_tensor_matrix_product_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              index_j_tensor_matrix_product_loop <= std_logic_vector(unsigned(index_j_tensor_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_k_tensor_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= INPUT_J_TENSOR_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_tensor_matrix_product <= '0';

            data_a_in_i_enable_tensor_matrix_product <= '0';
            data_a_in_j_enable_tensor_matrix_product <= '0';
            data_a_in_k_enable_tensor_matrix_product <= '0';
            data_b_in_i_enable_tensor_matrix_product <= '0';
            data_b_in_j_enable_tensor_matrix_product <= '0';
          end if;

        when CLEAN_K_TENSOR_MATRIX_PRODUCT_STATE =>  -- STEP 8

          if (data_k_enable_tensor_matrix_product = '1') then
            if (unsigned(index_k_tensor_matrix_product_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_tensor_matrix_product_loop)), to_integer(unsigned(index_j_tensor_matrix_product_loop)), to_integer(unsigned(index_k_tensor_matrix_product_loop))) <= data_out_tensor_matrix_product;

              -- Control Internal
              index_k_tensor_matrix_product_loop <= std_logic_vector(unsigned(index_k_tensor_matrix_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_tensor_matrix_product_fsm_int <= INPUT_J_TENSOR_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_tensor_matrix_product <= '0';

            data_a_in_i_enable_tensor_matrix_product <= '0';
            data_a_in_j_enable_tensor_matrix_product <= '0';
            data_a_in_k_enable_tensor_matrix_product <= '0';
            data_b_in_i_enable_tensor_matrix_product <= '0';
            data_b_in_j_enable_tensor_matrix_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_tensor_matrix_product_fsm_int <= STARTER_TENSOR_MATRIX_PRODUCT_STATE;
      end case;
    end if;
  end process;

  vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_length_enable_vector_summation <= '0';
      data_in_enable_vector_summation        <= '0';

      data_vector_summation_enable_int <= '0';

      index_length_vector_summation_loop <= ZERO_CONTROL;
      index_vector_summation_loop        <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_summation_fsm_int is
        when STARTER_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_length_enable_vector_summation <= '0';
          data_in_enable_vector_summation        <= '0';

          data_vector_summation_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_r_in_enable_int = '1') then
            -- Data Inputs
            length_in_vector_summation <= SIZE_L_IN;
            size_in_vector_summation   <= SIZE_R_IN;

            -- Control Internal
            index_length_vector_summation_loop <= ZERO_CONTROL;
            index_vector_summation_loop        <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_summation_fsm_int <= INPUT_LENGTH_VECTOR_SUMMATION_STATE;
          end if;

        when INPUT_LENGTH_VECTOR_SUMMATION_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_length_vector_summation_loop)), to_integer(unsigned(index_vector_summation_loop)));

          -- Control Internal
          if (unsigned(index_length_vector_summation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_summation_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_summation <= '1';
          end if;

          data_in_length_enable_vector_summation <= '1';
          data_in_enable_vector_summation        <= '1';

          -- FSM Control
          controller_vector_summation_fsm_int <= CLEAN_VECTOR_SUMMATION_STATE;

        when INPUT_VECTOR_SUMMATION_STATE =>  -- STEP 6

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_length_vector_summation_loop)), to_integer(unsigned(index_vector_summation_loop)));

          -- Control Internal
          data_in_enable_vector_summation <= '1';

          -- FSM Control
          if (unsigned(index_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            controller_vector_summation_fsm_int <= CLEAN_LENGTH_VECTOR_SUMMATION_STATE;
          else
            controller_vector_summation_fsm_int <= CLEAN_VECTOR_SUMMATION_STATE;
          end if;

        when CLEAN_LENGTH_VECTOR_SUMMATION_STATE =>  -- STEP 7

          if (data_enable_length_vector_summation = '1' and data_enable_vector_summation = '1') then
            if ((unsigned(index_length_vector_summation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_length_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              data_vector_summation_enable_int <= '1';

              index_length_vector_summation_loop <= ZERO_CONTROL;
              index_vector_summation_loop        <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
            elsif ((unsigned(index_length_vector_summation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_vector_summation_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_length_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              index_length_vector_summation_loop <= std_logic_vector(unsigned(index_length_vector_summation_loop) + unsigned(ONE_CONTROL));
              index_vector_summation_loop        <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_LENGTH_VECTOR_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_length_enable_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when CLEAN_VECTOR_SUMMATION_STATE =>  -- STEP 8

          if (data_enable_length_vector_summation = '1') then
            if (unsigned(index_vector_summation_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_vector_summation_loop <= std_logic_vector(unsigned(index_vector_summation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_VECTOR_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_length_enable_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  matrix_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_vector_product <= '0';
      data_a_in_j_enable_matrix_vector_product <= '0';
      data_b_in_enable_matrix_vector_product   <= '0';

      data_matrix_vector_product_enable_int <= '0';

      index_i_matrix_vector_product_loop <= ZERO_CONTROL;
      index_j_matrix_vector_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_vector_product_fsm_int is
        when STARTER_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_vector_product <= '0';
          data_a_in_j_enable_matrix_vector_product <= '0';
          data_b_in_enable_matrix_vector_product   <= '0';

          data_matrix_vector_product_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_r_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_vector_product <= SIZE_L_IN;
            size_a_j_in_matrix_vector_product <= SIZE_R_IN;
            size_b_in_matrix_vector_product   <= SIZE_L_IN;

            -- Control Internal
            index_i_matrix_vector_product_loop <= ZERO_CONTROL;
            index_j_matrix_vector_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_vector_product_fsm_int <= INPUT_I_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when INPUT_I_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_vector_product <= matrix_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
          data_b_in_matrix_vector_product <= vector_operation_int(to_integer(unsigned(index_j_matrix_vector_product_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_vector_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_vector_product_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_vector_product <= '1';
          end if;

          data_a_in_i_enable_matrix_vector_product <= '1';
          data_a_in_j_enable_matrix_vector_product <= '1';
          data_b_in_enable_matrix_vector_product   <= '1';

          -- FSM Control
          controller_matrix_vector_product_fsm_int <= CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE;

        when INPUT_J_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_vector_product <= matrix_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
          data_b_in_matrix_vector_product <= vector_operation_int(to_integer(unsigned(index_j_matrix_vector_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_vector_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_vector_product_fsm_int <= CLEAN_I_MATRIX_VECTOR_PRODUCT_STATE;
          else
            controller_matrix_vector_product_fsm_int <= CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              data_matrix_vector_product_enable_int <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_vector_product_fsm_int <= STARTER_MATRIX_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_i_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

              -- Control Internal
              index_i_matrix_vector_product_loop <= std_logic_vector(unsigned(index_i_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_vector_product_fsm_int <= INPUT_I_MATRIX_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';

            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

        when CLEAN_J_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 8

          if (data_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_j_matrix_vector_product_loop <= std_logic_vector(unsigned(index_j_matrix_vector_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_vector_product_fsm_int <= INPUT_I_MATRIX_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';

            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_matrix_vector_product_fsm_int <= STARTER_MATRIX_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

  vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_adder_fsm_int is
        when STARTER_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          data_vector_float_adder_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_q_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_L_IN;

            -- Control Internal
            index_vector_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when INPUT_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
          data_b_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_adder <= '1';
          end if;

          data_a_in_enable_vector_float_adder <= '1';
          data_b_in_enable_vector_float_adder <= '1';

          -- FSM Control
          controller_vector_float_adder_fsm_int <= CLEAN_VECTOR_FLOAT_ADDER_STATE;

        when CLEAN_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
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
          if (data_p_in_enable_int = '1' and data_r_in_enable_int = '1' and data_q_in_enable_int = '1' and data_h_in_enable_int = '1') then
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

  -- TENSOR MATRIX PRODUCT
  tensor_matrix_product : accelerator_tensor_matrix_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_tensor_matrix_product,
      READY => ready_tensor_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_matrix_product,
      DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_matrix_product,

      DATA_I_ENABLE => data_i_enable_tensor_matrix_product,
      DATA_J_ENABLE => data_j_enable_tensor_matrix_product,
      DATA_K_ENABLE => data_k_enable_tensor_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_tensor_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_tensor_matrix_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_tensor_matrix_product,
      SIZE_A_J_IN => size_a_j_in_tensor_matrix_product,
      SIZE_A_K_IN => size_a_k_in_tensor_matrix_product,
      SIZE_B_I_IN => size_b_i_in_tensor_matrix_product,
      SIZE_B_J_IN => size_b_j_in_tensor_matrix_product,
      DATA_A_IN   => data_a_in_tensor_matrix_product,
      DATA_B_IN   => data_b_in_tensor_matrix_product,
      DATA_OUT    => data_out_tensor_matrix_product
      );

  -- MATRIX VECTOR PRODUCT
  matrix_vector_product : accelerator_matrix_vector_product
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

  -- VECTOR FLOAT ADDER
  vector_float_adder : accelerator_vector_float_adder
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

      DATA_OUT     => data_out_vector_float_adder,
      OVERFLOW_OUT => overflow_out_vector_float_divider
      );

  -- VECTOR SUMMATION
  vector_summation : accelerator_vector_summation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      DATA_IN_LENGTH_ENABLE => data_in_length_enable_vector_summation,
      DATA_IN_ENABLE        => data_in_enable_vector_summation,

      DATA_LENGTH_ENABLE => data_enable_length_vector_summation,
      DATA_ENABLE        => data_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

end architecture;
