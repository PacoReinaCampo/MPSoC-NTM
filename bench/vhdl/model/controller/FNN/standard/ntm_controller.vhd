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
use work.ntm_fnn_controller_pkg.all;

entity ntm_controller is
  generic (
    DATA_SIZE  : integer := 512;
    INDEX_SIZE : integer := 512
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

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(INDEX_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(INDEX_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(INDEX_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(INDEX_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_controller_architecture of ntm_controller is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 1
    MATRIX_FIRST_PRODUCT_J_STATE,       -- STEP 2
    VECTOR_FIRST_ADDER_STATE,           -- STEP 3
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 4
    MATRIX_SECOND_PRODUCT_J_STATE,      -- STEP 5
    VECTOR_SECOND_ADDER_STATE,          -- STEP 6
    MATRIX_THIRD_PRODUCT_I_STATE,       -- STEP 7
    MATRIX_THIRD_PRODUCT_J_STATE,       -- STEP 8
    VECTOR_THIRD_ADDER_STATE,           -- STEP 9
    VECTOR_LOGISTIC_STATE               -- STEP 10
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_INDEX : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_INDEX  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(INDEX_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  signal data_a_in_enable_vector_adder : std_logic;
  signal data_b_in_enable_vector_adder : std_logic;

  signal data_out_enable_vector_adder : std_logic;

  -- DATA
  signal modulo_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_adder   : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal modulo_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_i_in_matrix_product : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal modulo_in_vector_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_logistic   : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal data_in_vector_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TRAINER
  -- CONTROL
  signal start_trainer : std_logic;
  signal ready_trainer : std_logic;

  signal x_in_enable_trainer : std_logic;

  signal x_out_enable_trainer : std_logic;

  signal r_in_i_enable_trainer : std_logic;
  signal r_in_k_enable_trainer : std_logic;

  signal r_out_i_enable_trainer : std_logic;
  signal r_out_k_enable_trainer : std_logic;

  signal h_in_enable_trainer : std_logic;

  signal h_out_enable_trainer : std_logic;

  signal w_out_l_enable_trainer : std_logic;
  signal w_out_x_enable_trainer : std_logic;

  signal k_out_i_enable_trainer : std_logic;
  signal k_out_l_enable_trainer : std_logic;
  signal k_out_k_enable_trainer : std_logic;

  signal u_out_l_enable_trainer : std_logic;
  signal u_out_p_enable_trainer : std_logic;

  signal b_out_enable_trainer : std_logic;

  -- DATA
  signal size_x_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_l_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_r_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal x_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal r_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal h_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(t;l))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      H_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_INDEX;
      index_j_loop <= ZERO_INDEX;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          H_OUT_ENABLE <= '0';

          -- Control Internal
          index_i_loop <= ZERO_INDEX;
          index_j_loop <= ZERO_INDEX;

          if (START = '1') then
            -- Control Internal
            start_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_I_STATE;
          else
            -- Control Internal
            start_matrix_product <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 1

          -- Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_L_IN;
          size_a_j_in_matrix_product <= SIZE_X_IN;
          size_b_i_in_matrix_product <= SIZE_X_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= W_IN;
          data_b_in_matrix_product   <= X_IN;

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= W_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= W_IN_X_ENABLE;
          data_b_in_i_enable_matrix_product <= X_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(ONE_INDEX) - unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_vector_adder <= data_out_matrix_product;

            -- Control Outputs
            data_a_in_enable_vector_adder <= '1';
          else
            -- Control Outputs
            data_a_in_enable_vector_adder <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 2

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(ONE_INDEX) - unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_vector_adder <= data_out_matrix_product;

            -- Control Outputs
            data_a_in_enable_vector_adder <= '1';
          else
            -- Control Outputs
            data_a_in_enable_vector_adder <= '0';
          end if;

        when VECTOR_FIRST_ADDER_STATE =>  -- STEP 3

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= SIZE_L_IN;
          data_a_in_vector_adder <= data_out_matrix_product;
          data_b_in_vector_adder <= B_IN;

          -- Control Inputs
          operation_vector_adder <= '0';

          data_a_in_enable_vector_adder <= data_out_enable_vector_adder;
          data_b_in_enable_vector_adder <= B_IN_ENABLE;

          if (data_out_enable_vector_adder = '1') then
            -- Control Internal
            start_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_SECOND_PRODUCT_I_STATE;
          else
            -- Control Internal
            start_vector_adder <= '0';
          end if;

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 4

          -- Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_L_IN;
          size_a_j_in_matrix_product <= SIZE_W_IN;
          size_b_i_in_matrix_product <= SIZE_W_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= K_IN;
          data_b_in_matrix_product   <= R_IN;

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= K_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= K_IN_K_ENABLE;
          data_b_in_i_enable_matrix_product <= X_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(ONE_INDEX) - unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_vector_adder <= data_out_matrix_product;

            -- Control Outputs
            data_a_in_enable_vector_adder <= '1';
          else
            -- Control Outputs
            data_a_in_enable_vector_adder <= '0';
          end if;

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 5

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(ONE_INDEX) - unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_vector_adder <= data_out_matrix_product;

            -- Control Outputs
            data_a_in_enable_vector_adder <= '1';
          else
            -- Control Outputs
            data_a_in_enable_vector_adder <= '0';
          end if;

        when VECTOR_SECOND_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= SIZE_L_IN;
          data_a_in_vector_adder <= data_out_matrix_product;
          data_b_in_vector_adder <= data_out_vector_adder;

          -- Control Inputs
          operation_vector_adder <= '0';

          data_a_in_enable_vector_adder <= data_out_i_enable_matrix_product;
          data_b_in_enable_vector_adder <= data_out_enable_vector_adder;

          if (data_out_enable_vector_adder = '1') then
            -- Control Internal
            start_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_THIRD_PRODUCT_I_STATE;
          else
            -- Control Internal
            start_vector_adder <= '0';
          end if;

        when MATRIX_THIRD_PRODUCT_I_STATE =>  -- STEP 7

          -- Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_L_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= U_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= U_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= U_IN_P_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(ONE_INDEX) - unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_vector_adder <= data_out_matrix_product;

            -- Control Outputs
            data_a_in_enable_vector_adder <= '1';
          else
            -- Control Outputs
            data_a_in_enable_vector_adder <= '0';
          end if;

        when MATRIX_THIRD_PRODUCT_J_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(ONE_INDEX) - unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_vector_adder <= data_out_matrix_product;

            -- Control Outputs
            data_a_in_enable_vector_adder <= '1';
          else
            -- Control Outputs
            data_a_in_enable_vector_adder <= '0';
          end if;

        when VECTOR_THIRD_ADDER_STATE =>  -- STEP 9

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= SIZE_L_IN;
          data_a_in_vector_adder <= data_out_matrix_product;
          data_b_in_vector_adder <= data_out_vector_adder;

          -- Control Inputs
          operation_vector_adder <= '0';

          data_a_in_enable_vector_adder <= data_out_i_enable_matrix_product;
          data_b_in_enable_vector_adder <= data_out_enable_vector_adder;

          if (data_out_enable_vector_adder = '1') then
            -- Control Internal
            start_vector_logistic <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_LOGISTIC_STATE;
          else
            -- Control Internal
            start_vector_adder <= '0';
          end if;

        when VECTOR_LOGISTIC_STATE =>  -- STEP 10

          -- Data Inputs
          modulo_in_vector_logistic <= FULL;
          size_in_vector_logistic   <= SIZE_L_IN;
          data_in_vector_logistic   <= data_out_vector_adder;

          -- Control Inputs
          data_in_enable_vector_logistic <= data_out_enable_vector_adder;

          if (ready_vector_logistic = '1') then
            if (unsigned(index_i_loop) = unsigned(SIZE_L_IN) - unsigned(ONE_INDEX)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_I_STATE;
            end if;

            -- Data Outputs
            H_OUT <= data_out_vector_logistic;

            -- Control Outputs
            H_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            H_OUT_ENABLE <= '0';

            -- Control Internal
            start_vector_logistic <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- TRAINER
  x_in_enable_trainer <= X_IN_ENABLE;

  r_in_i_enable_trainer <= R_IN_I_ENABLE;
  r_in_k_enable_trainer <= R_IN_K_ENABLE;

  h_in_enable_trainer <= H_IN_ENABLE;

  -- DATA
  -- TRAINER
  size_x_in_trainer <= SIZE_X_IN;
  size_w_in_trainer <= SIZE_W_IN;
  size_l_in_trainer <= SIZE_L_IN;
  size_r_in_trainer <= SIZE_R_IN;

  x_in_trainer <= X_IN;
  r_in_trainer <= R_IN;
  h_in_trainer <= H_IN;

  W_OUT <= w_out_trainer;
  K_OUT <= k_out_trainer;
  U_OUT <= u_out_trainer;
  B_OUT <= b_out_trainer;

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_adder,

      -- DATA
      MODULO_IN => modulo_in_vector_adder,
      SIZE_IN   => size_in_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
      );

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
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

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      MODULO_IN   => modulo_in_matrix_product,
      SIZE_A_I_IN => size_a_i_in_matrix_product,
      SIZE_A_J_IN => size_a_j_in_matrix_product,
      SIZE_B_I_IN => size_b_i_in_matrix_product,
      SIZE_B_J_IN => size_b_j_in_matrix_product,
      DATA_A_IN   => data_a_in_matrix_product,
      DATA_B_IN   => data_b_in_matrix_product,
      DATA_OUT    => data_out_matrix_product
      );

  -- VECTOR LOGISTIC
  vector_logistic_function : ntm_vector_logistic_function
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
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
      MODULO_IN => modulo_in_vector_logistic,
      SIZE_IN   => size_in_vector_logistic,
      DATA_IN   => data_in_vector_logistic,
      DATA_OUT  => data_out_vector_logistic
      );

  -- TRAINER
  trainer : ntm_trainer
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_trainer,
      READY => ready_trainer,

      X_IN_ENABLE => x_in_enable_trainer,

      X_OUT_ENABLE => x_out_enable_trainer,

      R_IN_I_ENABLE => r_in_i_enable_trainer,
      R_IN_K_ENABLE => r_in_k_enable_trainer,

      R_OUT_I_ENABLE => r_out_i_enable_trainer,
      R_OUT_K_ENABLE => r_out_k_enable_trainer,

      H_IN_ENABLE => h_in_enable_trainer,

      H_OUT_ENABLE => h_out_enable_trainer,

      W_OUT_L_ENABLE => w_out_l_enable_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_trainer,

      K_OUT_I_ENABLE => k_out_i_enable_trainer,
      K_OUT_L_ENABLE => k_out_l_enable_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_trainer,

      U_OUT_L_ENABLE => u_out_l_enable_trainer,
      U_OUT_P_ENABLE => u_out_p_enable_trainer,

      B_OUT_ENABLE => b_out_enable_trainer,

      -- DATA
      SIZE_X_IN => size_x_in_trainer,
      SIZE_W_IN => size_w_in_trainer,
      SIZE_L_IN => size_l_in_trainer,
      SIZE_R_IN => size_r_in_trainer,

      X_IN => x_in_trainer,
      R_IN => h_in_trainer,
      H_IN => h_in_trainer,

      W_OUT => w_out_trainer,
      K_OUT => k_out_trainer,
      U_OUT => u_out_trainer,
      B_OUT => b_out_trainer
      );

end architecture;
