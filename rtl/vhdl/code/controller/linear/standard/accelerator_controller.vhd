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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;
use work.accelerator_linear_controller_pkg.all;

entity accelerator_controller is
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

    W_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    W_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_controller_architecture of accelerator_controller is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [L,X],   X_IN   [X]
  -- B_IN [L]

  -- Outputs:
  -- H_OUT [L]

  -- States:
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_X_STATE, CLEAN_IN_X_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_L_STATE,                 -- STEP 1
    INPUT_W_IN_X_STATE,                 -- STEP 2
    CLEAN_W_IN_L_STATE,                 -- STEP 3
    CLEAN_W_IN_X_STATE                  -- STEP 4
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

  -- Ops

  -- W(l;x)·x(t;x)
  type controller_matrix_vector_product_fsm is (
    STARTER_MATRIX_VECTOR_PRODUCT_STATE,   -- STEP 0
    ENABLER_MATRIX_VECTOR_PRODUCT_STATE,   -- STEP 1
    OPERATION_MATRIX_VECTOR_PRODUCT_STATE  -- STEP 2
    );

  -- b(l)
  type controller_vector_float_adder_fsm is (
    STARTER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    ENABLER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 1
    OPERATION_VECTOR_FLOAT_ADDER_STATE  -- STEP 2
    );

  -- logistic(h(t;l))
  type controller_vector_logistic_fsm is (
    STARTER_VECTOR_LOGISTIC_STATE,      -- STEP 0
    ENABLER_VECTOR_LOGISTIC_STATE,      -- STEP 1
    OPERATION_VECTOR_LOGISTIC_STATE     -- STEP 2
    );

  -- Output
  type controller_h_out_fsm is (
    STARTER_H_OUT_STATE,                -- STEP 0
    ENABLER_H_OUT_STATE,                -- STEP 1
    CLEAN_H_OUT_L_STATE,                -- STEP 2
    OUTPUT_H_OUT_L_STATE                -- STEP 3
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_b_in_fsm_int : controller_b_in_fsm;

  signal controller_x_in_fsm_int : controller_x_in_fsm;

  -- Ops
  signal controller_matrix_vector_product_fsm_int : controller_matrix_vector_product_fsm;
  signal controller_vector_float_adder_fsm_int    : controller_vector_float_adder_fsm;
  signal controller_vector_logistic_fsm_int       : controller_vector_logistic_fsm;

  -- Output
  signal controller_h_out_fsm_int : controller_h_out_fsm;

  -- Buffer
  -- Input
  signal matrix_w_in_int : matrix_buffer;
  signal vector_b_in_int : vector_buffer;

  signal vector_x_in_int : vector_buffer;

  -- Ops
  signal vector_one_operation_int   : vector_buffer;
  signal vector_two_operation_int   : vector_buffer;
  signal vector_three_operation_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_l_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_x_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_matrix_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_logistic_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_l_h_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_w_in_enable_int : std_logic;
  signal data_b_in_enable_int : std_logic;

  signal data_x_in_enable_int : std_logic;

  -- Ops
  signal data_matrix_vector_product_enable_int : std_logic;
  signal data_vector_float_adder_enable_int    : std_logic;
  signal data_vector_logistic_enable_int       : std_logic;

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

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal size_in_vector_logistic  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- h(t;l) = sigmoid(W(l;x)·x(t;x) + b(l))

  -- W(l;x)·x(t;x)
  --   vector_one_operation_int = matrix_vector_product_fsm(W, x) [data_w_in_enable_int, data_x_in_enable_int]

  -- b(l)
  --   vector_two_operation_int = vector_float_adder_fsm(vector_one_operation_int, b) [data_matrix_vector_product_enable_int, data_b_in_enable_int]

  -- logistic(h(t;l))
  --   vector_three_operation_int = vector_logistic_fsm(vector_two_operation_int) [data_vector_float_adder_enable_int]

  -- INPUT CONTROL
  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_L_ENABLE <= '0';
      W_OUT_X_ENABLE <= '0';

      -- Control Internal
      index_l_w_in_loop <= ZERO_CONTROL;
      index_x_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= ZERO_CONTROL;
            index_x_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_L_STATE;
          else
            -- Control Outputs
            W_OUT_L_ENABLE <= '0';
            W_OUT_X_ENABLE <= '0';
          end if;

        when INPUT_W_IN_L_STATE =>      -- STEP 1

          if ((W_IN_L_ENABLE = '1') and (W_IN_X_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_l_w_in_loop)), to_integer(unsigned(index_x_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
          end if;

          -- Control Outputs
          W_OUT_L_ENABLE <= '0';
          W_OUT_X_ENABLE <= '0';

        when INPUT_W_IN_X_STATE =>      -- STEP 2

          if (W_IN_X_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_l_w_in_loop)), to_integer(unsigned(index_x_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_L_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_X_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';

        when CLEAN_W_IN_L_STATE =>      -- STEP 3

          if ((unsigned(index_l_w_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= ZERO_CONTROL;
            index_x_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_l_w_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_in_loop <= std_logic_vector(unsigned(index_l_w_in_loop) + unsigned(ONE_CONTROL));
            index_x_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_L_STATE;
          end if;

        when CLEAN_W_IN_X_STATE =>      -- STEP 4

          if (unsigned(index_x_w_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_x_w_in_loop <= std_logic_vector(unsigned(index_x_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_in_fsm_int <= STARTER_W_IN_STATE;
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
          else
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
          else
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

  -- OPS CONTROL

  -- W(l;x)·x(t;x)
  matrix_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_matrix_vector_product <= '0';

      data_a_in_i_enable_matrix_vector_product <= '0';
      data_a_in_j_enable_matrix_vector_product <= '0';
      data_b_in_enable_matrix_vector_product   <= '0';

      data_matrix_vector_product_enable_int <= '0';

      index_i_matrix_vector_product_loop <= ZERO_CONTROL;
      index_j_matrix_vector_product_loop <= ZERO_CONTROL;

      index_matrix_vector_product_loop <= ZERO_CONTROL;

      -- Data Internal
      size_a_i_in_matrix_vector_product <= ZERO_CONTROL;
      size_a_j_in_matrix_vector_product <= ZERO_CONTROL;
      size_b_in_matrix_vector_product   <= ZERO_CONTROL;

      data_a_in_matrix_vector_product <= ZERO_DATA;
      data_b_in_matrix_vector_product <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_matrix_vector_product_fsm_int is
        when STARTER_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          start_matrix_vector_product <= '0';

          data_a_in_i_enable_matrix_vector_product <= '0';
          data_a_in_j_enable_matrix_vector_product <= '0';
          data_b_in_enable_matrix_vector_product   <= '0';

          -- Data Internal
          data_a_in_matrix_vector_product <= ZERO_DATA;
          data_b_in_matrix_vector_product <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_matrix_vector_product_enable_int <= '0';

            -- FSM Control
            controller_matrix_vector_product_fsm_int <= ENABLER_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when ENABLER_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 1

          if (data_w_in_enable_int = '1' and data_x_in_enable_int = '1') then
            if (unsigned(index_i_matrix_vector_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_vector_product_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_product <= '1';

              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
              index_j_matrix_vector_product_loop <= ZERO_CONTROL;

              index_matrix_vector_product_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_a_i_in_matrix_vector_product <= SIZE_L_IN;
              size_a_j_in_matrix_vector_product <= SIZE_X_IN;
              size_b_in_matrix_vector_product   <= SIZE_X_IN;
            end if;

            -- FSM Control
            controller_matrix_vector_product_fsm_int <= OPERATION_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when OPERATION_MATRIX_VECTOR_PRODUCT_STATE =>  -- STEP 2

          if (data_i_enable_matrix_vector_product = '1' and data_j_enable_matrix_vector_product = '1') then
            -- Data Inputs
            data_a_in_matrix_vector_product <= matrix_w_in_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));
            data_b_in_matrix_vector_product <= vector_x_in_int(to_integer(unsigned(index_i_matrix_vector_product_loop)));

            -- Control Internal
            data_a_in_i_enable_matrix_vector_product <= '1';
            data_a_in_j_enable_matrix_vector_product <= '1';
            data_b_in_enable_matrix_vector_product   <= '1';

            if ((unsigned(index_i_matrix_vector_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              index_i_matrix_vector_product_loop <= ZERO_CONTROL;
            elsif ((unsigned(index_i_matrix_vector_product_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_vector_product_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              index_i_matrix_vector_product_loop <= std_logic_vector(unsigned(index_i_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
            end if;

            index_j_matrix_vector_product_loop <= ZERO_CONTROL;

          elsif (data_j_enable_matrix_vector_product = '1') then
            -- Data Inputs
            data_a_in_matrix_vector_product <= matrix_w_in_int(to_integer(unsigned(index_i_matrix_vector_product_loop)), to_integer(unsigned(index_j_matrix_vector_product_loop)));

            -- Control Internal
            data_a_in_j_enable_matrix_vector_product <= '1';

            if (unsigned(index_j_matrix_vector_product_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              index_j_matrix_vector_product_loop <= std_logic_vector(unsigned(index_j_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
            end if;
          else
            -- Control Internal
            data_a_in_i_enable_matrix_vector_product <= '0';
            data_a_in_j_enable_matrix_vector_product <= '0';
            data_b_in_enable_matrix_vector_product   <= '0';
          end if;

          if (data_out_enable_matrix_vector_product = '1') then
            -- Data Internal
            vector_one_operation_int(to_integer(unsigned(index_matrix_vector_product_loop))) <= data_out_matrix_vector_product;

            -- Control Internal
            if (unsigned(index_matrix_vector_product_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              index_matrix_vector_product_loop <= ZERO_CONTROL;
            else
              index_matrix_vector_product_loop <= std_logic_vector(unsigned(index_matrix_vector_product_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

          -- Control Internal
          start_matrix_vector_product <= '0';

          if (ready_matrix_vector_product = '1') then
            -- Control Internal
            data_matrix_vector_product_enable_int <= '1';

            -- FSM Control
            controller_matrix_vector_product_fsm_int <= STARTER_MATRIX_VECTOR_PRODUCT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_matrix_vector_product_fsm_int <= STARTER_MATRIX_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

  -- b(l)
  vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_vector_float_adder <= '0';

      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

      -- Data Internal
      operation_vector_float_adder <= '0';

      size_in_vector_float_adder <= ZERO_CONTROL;

      data_a_in_vector_float_adder <= ZERO_DATA;
      data_b_in_vector_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_adder_fsm_int is
        when STARTER_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          start_vector_float_adder <= '0';

          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          if (ready_vector_float_adder = '1') then
            data_vector_float_adder_enable_int <= '1';
          end if;

          -- Data Internal
          data_a_in_vector_float_adder <= ZERO_DATA;
          data_b_in_vector_float_adder <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_vector_float_adder_enable_int <= '0';

            -- FSM Control
            controller_vector_float_adder_fsm_int <= ENABLER_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when ENABLER_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 1

          if (data_matrix_vector_product_enable_int = '1' and data_b_in_enable_int = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- Data Inputs
              operation_vector_float_adder <= '0';

              size_in_vector_float_adder <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_vector_float_adder_fsm_int <= OPERATION_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when OPERATION_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_a_in_vector_float_adder <= vector_one_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
              data_b_in_vector_float_adder <= vector_b_in_int(to_integer(unsigned(index_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_vector_float_adder <= '1';
              data_b_in_enable_vector_float_adder <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
            else
              -- Data Inputs
              data_a_in_vector_float_adder <= vector_one_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
              data_b_in_vector_float_adder <= vector_b_in_int(to_integer(unsigned(index_vector_float_adder_loop)));

              -- Control Internal
              data_a_in_enable_vector_float_adder <= '1';
              data_b_in_enable_vector_float_adder <= '1';

              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_two_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;
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

  -- logistic(h(t;l))
  vector_logistic_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      start_vector_logistic <= '0';

      data_in_enable_vector_logistic <= '0';

      data_vector_logistic_enable_int <= '0';

      index_vector_logistic_loop <= ZERO_CONTROL;

      -- Data Internal
      size_in_vector_logistic <= ZERO_CONTROL;

      data_in_vector_logistic <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case controller_vector_logistic_fsm_int is
        when STARTER_VECTOR_LOGISTIC_STATE =>  -- STEP 0
          -- Control Internal
          start_vector_logistic <= '0';

          data_in_enable_vector_logistic <= '0';

          if (ready_vector_logistic = '1') then
            data_vector_logistic_enable_int <= '1';
          end if;

          -- Data Internal
          data_in_vector_logistic <= ZERO_DATA;

          if (START = '1') then
            -- Control Internal
            data_vector_logistic_enable_int <= '0';

            -- FSM Control
            controller_vector_logistic_fsm_int <= ENABLER_VECTOR_LOGISTIC_STATE;
          end if;

        when ENABLER_VECTOR_LOGISTIC_STATE =>  -- STEP 1

          if (data_vector_float_adder_enable_int = '1') then
            if (unsigned(index_vector_logistic_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_logistic_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_logistic <= '1';

              index_vector_logistic_loop <= ZERO_CONTROL;

              -- Data Inputs
              size_in_vector_logistic <= SIZE_L_IN;
            end if;

            -- FSM Control
            controller_vector_logistic_fsm_int <= OPERATION_VECTOR_LOGISTIC_STATE;
          end if;

        when OPERATION_VECTOR_LOGISTIC_STATE =>  -- STEP 2

          if (data_out_enable_vector_logistic = '1') then
            if (unsigned(index_vector_logistic_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Inputs
              data_in_vector_logistic <= vector_two_operation_int(to_integer(unsigned(index_vector_logistic_loop)));

              -- Control Internal
              data_in_enable_vector_logistic <= '1';

              index_vector_logistic_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_logistic_fsm_int <= STARTER_VECTOR_LOGISTIC_STATE;
            else
              -- Data Inputs
              data_in_vector_logistic <= vector_two_operation_int(to_integer(unsigned(index_vector_logistic_loop)));

              -- Control Internal
              data_in_enable_vector_logistic <= '1';

              index_vector_logistic_loop <= std_logic_vector(unsigned(index_vector_logistic_loop) + unsigned(ONE_CONTROL));
            end if;

            -- Data Internal
            vector_three_operation_int(to_integer(unsigned(index_vector_logistic_loop))) <= data_out_vector_logistic;
          else
            -- Control Internal
            start_vector_logistic <= '0';

            data_in_enable_vector_logistic <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_logistic_fsm_int <= STARTER_VECTOR_LOGISTIC_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
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

      case controller_h_out_fsm_int is
        when STARTER_H_OUT_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

          -- Control Outputs
          READY <= '0';

          H_OUT_ENABLE <= '0';

        when CLEAN_H_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          H_OUT_ENABLE <= '0';

          -- FSM Control
          if (data_vector_logistic_enable_int = '1') then
            controller_h_out_fsm_int <= OUTPUT_H_OUT_L_STATE;
          end if;

        when OUTPUT_H_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_h_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            READY <= '1';

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
          else
            -- Control Internal
            index_l_h_out_loop <= std_logic_vector(unsigned(index_l_h_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

          -- Data Outputs
          H_OUT <= vector_three_operation_int(to_integer(unsigned(index_l_h_out_loop)));

          -- Control Outputs
          H_OUT_ENABLE <= '1';

        when others =>
          -- FSM Control
          controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
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
      DATA_OUT  => data_out_vector_float_adder
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

  -- VECTOR LOGISTIC
  vector_logistic_function : accelerator_vector_logistic_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_logistic,
      READY => ready_vector_logistic,

      DATA_IN_ENABLE => data_in_enable_vector_logistic,

      DATA_OUT_ENABLE => data_out_enable_vector_logistic,

      -- DATA
      SIZE_IN  => size_in_vector_logistic,
      DATA_IN  => data_in_vector_logistic,
      DATA_OUT => data_out_vector_logistic
      );

end architecture;
