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

    W_OUT_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    W_OUT_X_ENABLE : in std_logic;      -- for x in 0 to X-1

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : in std_logic;        -- for x in 0 to X-1

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    K_OUT_I_ENABLE : in std_logic;      -- for i in 0 to R-1 (read heads flow)
    K_OUT_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    K_OUT_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    R_OUT_I_ENABLE : in std_logic;      -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    U_IN_P_ENABLE : in std_logic;       -- for p in 0 to L-1

    U_OUT_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    U_OUT_P_ENABLE : in std_logic;      -- for p in 0 to L-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : in std_logic;        -- for l in 0 to L-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_OUT_ENABLE : in std_logic;        -- for l in 0 to L-1

    F_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_forget_gate_vector_architecture of ntm_forget_gate_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    MATRIX_I_FIRST_PRODUCT_STATE,       -- STEP 3
    MATRIX_J_FIRST_PRODUCT_STATE,       -- STEP 4
    VECTOR_FIRST_ADDER_STATE,           -- STEP 5
    MATRIX_I_SECOND_PRODUCT_STATE,      -- STEP 6
    MATRIX_J_SECOND_PRODUCT_STATE,      -- STEP 7
    VECTOR_SECOND_ADDER_STATE,          -- STEP 8
    MATRIX_I_THIRD_PRODUCT_STATE,       -- STEP 9
    MATRIX_J_THIRD_PRODUCT_STATE,       -- STEP 10
    VECTOR_THIRD_ADDER_STATE,           -- STEP 11
    MATRIX_I_FOURTH_PRODUCT_STATE,      -- STEP 12
    MATRIX_J_FOURTH_PRODUCT_STATE,      -- STEP 13
    VECTOR_FOURTH_ADDER_STATE,          -- STEP 14
    VECTOR_LOGISTIC_STATE               -- STEP 15
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

  -- TENSOR MATRIX PRODUCT
  -- CONTROL
  signal start_tensor_matrix_product : std_logic;
  signal ready_tensor_matrix_product : std_logic;

  signal data_a_in_i_enable_tensor_matrix_product : std_logic;
  signal data_a_in_j_enable_tensor_matrix_product : std_logic;
  signal data_a_in_k_enable_tensor_matrix_product : std_logic;
  signal data_b_in_i_enable_tensor_matrix_product : std_logic;
  signal data_b_in_j_enable_tensor_matrix_product : std_logic;

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

  signal data_out_i_enable_matrix_vector_product : std_logic;
  signal data_out_j_enable_matrix_vector_product : std_logic;

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

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + U(l-1;l-1)*h(t;l-1) + b(t;l))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      F_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      F_OUT_ENABLE <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          F_OUT_ENABLE <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Data Outputs
            F_OUT <= ZERO_DATA;

            -- Control Internal
            start_matrix_vector_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_I_STATE;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';
          end if;

        when INPUT_I_STATE =>           -- STEP 1

        when INPUT_J_STATE =>           -- STEP 2

        when MATRIX_I_FIRST_PRODUCT_STATE =>  -- STEP 3

          -- Control Inputs
          data_a_in_i_enable_matrix_vector_product <= W_IN_L_ENABLE;
          data_a_in_j_enable_matrix_vector_product <= W_IN_X_ENABLE;
          data_b_in_enable_matrix_vector_product   <= X_IN_ENABLE;

          -- Data Inputs
          size_a_i_in_matrix_vector_product <= SIZE_L_IN;
          size_a_j_in_matrix_vector_product <= SIZE_X_IN;
          size_b_in_matrix_vector_product   <= SIZE_X_IN;
          data_a_in_matrix_vector_product   <= W_IN;
          data_b_in_matrix_vector_product   <= X_IN;

          if (data_out_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_FIRST_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';
          end if;

        when MATRIX_J_FIRST_PRODUCT_STATE =>  -- STEP 4

        when VECTOR_FIRST_ADDER_STATE =>  -- STEP 5

          -- Control Inputs
          operation_vector_float_adder <= '0';

          data_a_in_enable_vector_float_adder <= data_out_i_enable_matrix_vector_product;
          data_b_in_enable_vector_float_adder <= B_IN_ENABLE;

          -- Data Inputs
          size_in_vector_float_adder   <= SIZE_L_IN;
          data_a_in_vector_float_adder <= data_out_matrix_vector_product;
          data_b_in_vector_float_adder <= B_IN;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_product <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_SECOND_PRODUCT_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when MATRIX_I_SECOND_PRODUCT_STATE =>  -- STEP 6

          -- Control Inputs
          data_a_in_i_enable_matrix_vector_product <= K_IN_L_ENABLE;
          data_a_in_j_enable_matrix_vector_product <= K_IN_K_ENABLE;
          data_b_in_enable_matrix_vector_product   <= R_IN_K_ENABLE;

          -- Data Inputs
          size_a_i_in_matrix_vector_product <= SIZE_L_IN;
          size_a_j_in_matrix_vector_product <= SIZE_W_IN;
          size_b_in_matrix_vector_product   <= SIZE_W_IN;
          data_a_in_matrix_vector_product   <= K_IN;
          data_b_in_matrix_vector_product   <= R_IN;

          if (data_out_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_SECOND_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';
          end if;

        when MATRIX_J_SECOND_PRODUCT_STATE =>  -- STEP 7

        when VECTOR_SECOND_ADDER_STATE =>  -- STEP 8

          -- Control Inputs
          operation_vector_float_adder <= '0';

          data_a_in_enable_vector_float_adder <= data_out_i_enable_matrix_vector_product;
          data_b_in_enable_vector_float_adder <= data_out_enable_vector_float_adder;

          -- Data Inputs
          size_in_vector_float_adder   <= SIZE_L_IN;
          data_a_in_vector_float_adder <= data_out_matrix_vector_product;
          data_b_in_vector_float_adder <= data_out_vector_float_adder;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_product <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_THIRD_PRODUCT_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when MATRIX_I_THIRD_PRODUCT_STATE =>  -- STEP 9

          -- Control Inputs
          data_a_in_i_enable_matrix_vector_product <= U_IN_L_ENABLE;
          data_a_in_j_enable_matrix_vector_product <= U_IN_P_ENABLE;
          data_b_in_enable_matrix_vector_product   <= H_IN_ENABLE;

          -- Data Inputs
          size_a_i_in_matrix_vector_product <= SIZE_L_IN;
          size_a_j_in_matrix_vector_product <= SIZE_L_IN;
          size_b_in_matrix_vector_product   <= SIZE_L_IN;
          data_a_in_matrix_vector_product   <= U_IN;
          data_b_in_matrix_vector_product   <= H_IN;

          if (data_out_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_THIRD_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';
          end if;

        when MATRIX_J_THIRD_PRODUCT_STATE =>  -- STEP 10

        when VECTOR_THIRD_ADDER_STATE =>  -- STEP 11

          -- Control Inputs
          operation_vector_float_adder <= '0';

          data_a_in_enable_vector_float_adder <= data_out_i_enable_matrix_vector_product;
          data_b_in_enable_vector_float_adder <= data_out_enable_vector_float_adder;

          -- Data Inputs
          size_in_vector_float_adder   <= SIZE_L_IN;
          data_a_in_vector_float_adder <= data_out_matrix_vector_product;
          data_b_in_vector_float_adder <= data_out_vector_float_adder;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_matrix_vector_product <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_I_FOURTH_PRODUCT_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when MATRIX_I_FOURTH_PRODUCT_STATE =>  -- STEP 12

          -- Control Inputs
          data_a_in_i_enable_matrix_vector_product <= U_IN_L_ENABLE;
          data_a_in_j_enable_matrix_vector_product <= U_IN_P_ENABLE;
          data_b_in_enable_matrix_vector_product   <= H_IN_ENABLE;

          -- Data Inputs
          size_a_i_in_matrix_vector_product <= SIZE_L_IN;
          size_a_j_in_matrix_vector_product <= SIZE_L_IN;
          size_b_in_matrix_vector_product   <= SIZE_L_IN;
          data_a_in_matrix_vector_product   <= U_IN;
          data_b_in_matrix_vector_product   <= H_IN;

          if (data_out_i_enable_matrix_vector_product = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_float_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_FOURTH_ADDER_STATE;
          else
            -- Control Internal
            start_matrix_vector_product <= '0';
          end if;

        when MATRIX_J_FOURTH_PRODUCT_STATE =>  -- STEP 13

        when VECTOR_FOURTH_ADDER_STATE =>  -- STEP 14

          -- Control Inputs
          operation_vector_float_adder <= '0';

          data_a_in_enable_vector_float_adder <= data_out_i_enable_matrix_vector_product;
          data_b_in_enable_vector_float_adder <= data_out_enable_vector_float_adder;

          -- Data Inputs
          size_in_vector_float_adder   <= SIZE_L_IN;
          data_a_in_vector_float_adder <= data_out_matrix_vector_product;
          data_b_in_vector_float_adder <= data_out_vector_float_adder;

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_logistic <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_LOGISTIC_STATE;
          else
            -- Control Internal
            start_vector_float_adder <= '0';
          end if;

        when VECTOR_LOGISTIC_STATE =>   -- STEP 15

          -- Control Internal
          data_in_enable_vector_logistic <= data_out_enable_vector_float_adder;

          -- Data Inputs
          size_in_vector_logistic <= SIZE_L_IN;
          data_in_vector_logistic <= data_out_vector_float_adder;

          if (data_out_enable_vector_logistic = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_L_IN) - unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_I_FIRST_PRODUCT_STATE;
            end if;

            -- Data Outputs
            F_OUT <= data_out_vector_logistic;

            -- Control Outputs
            F_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            F_OUT_ENABLE <= '0';

            -- Control Internal
            start_vector_logistic <= '0';
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

  -- TENSOR MATRIX PRODUCT
  tensor_matrix_product : ntm_tensor_matrix_product
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

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_vector_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_vector_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_vector_product,
      SIZE_A_J_IN => size_a_j_in_matrix_vector_product,
      SIZE_B_IN   => size_b_in_matrix_vector_product,
      DATA_A_IN   => data_a_in_matrix_vector_product,
      DATA_B_IN   => data_b_in_matrix_vector_product,
      DATA_OUT    => data_out_matrix_vector_product
      );

  -- VECTOR LOGISTIC
  vector_logistic_function : ntm_vector_logistic_function
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
