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

entity dnc_memory_matrix is
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

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    V_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1
    E_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    V_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1
    E_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_memory_matrix_architecture of dnc_memory_matrix is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_FIRST_STATE,                -- STEP 1
    INPUT_J_FIRST_STATE,                -- STEP 2
    MATRIX_FIRST_TRANSPOSE_I_STATE,     -- STEP 3
    MATRIX_FIRST_TRANSPOSE_J_STATE,     -- STEP 4
    INPUT_I_SECOND_STATE,               -- STEP 5
    INPUT_J_SECOND_STATE,               -- STEP 6
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 7
    MATRIX_FIRST_PRODUCT_J_STATE,       -- STEP 8
    MATRIX_FIRST_ADDER_I_STATE,         -- STEP 9
    MATRIX_FIRST_ADDER_J_STATE,         -- STEP 10
    INPUT_I_THIRD_STATE,                -- STEP 11
    INPUT_J_THIRD_STATE,                -- STEP 12
    MATRIX_MULTIPLIER_I_STATE,          -- STEP 13
    MATRIX_MULTIPLIER_J_STATE,          -- STEP 14
    INPUT_I_FOURTH_STATE,               -- STEP 15
    INPUT_J_FOURTH_STATE,               -- STEP 16
    MATRIX_SECOND_TRANSPOSE_I_STATE,    -- STEP 17
    MATRIX_SECOND_TRANSPOSE_J_STATE,    -- STEP 18
    INPUT_I_FIFTH_STATE,                -- STEP 19
    INPUT_J_FIFTH_STATE,                -- STEP 20
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 21
    MATRIX_SECOND_PRODUCT_J_STATE,      -- STEP 22
    MATRIX_SECOND_ADDER_I_STATE,        -- STEP 23
    MATRIX_SECOND_ADDER_J_STATE         -- STEP 24
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal data_out_matrix_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_float_multiplier : std_logic;
  signal ready_matrix_float_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_float_multiplier : std_logic;

  signal data_out_i_enable_matrix_float_multiplier : std_logic;
  signal data_out_j_enable_matrix_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TRANSPOSE
  -- CONTROL
  signal start_matrix_transpose : std_logic;
  signal ready_matrix_transpose : std_logic;

  signal data_in_i_enable_matrix_transpose : std_logic;
  signal data_in_j_enable_matrix_transpose : std_logic;

  signal data_out_i_enable_matrix_transpose : std_logic;
  signal data_out_j_enable_matrix_transpose : std_logic;

  -- DATA
  signal size_i_in_matrix_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_transpose   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_transpose  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_a_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      M_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_i_loop <= ZERO_CONTROL;
          index_j_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Control Internal
            start_matrix_transpose <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_I_FIRST_STATE;
          else
            -- Control Internal
            start_matrix_transpose <= '0';
          end if;

        when INPUT_I_FIRST_STATE =>     -- STEP 1

        when INPUT_J_FIRST_STATE =>     -- STEP 2

        when MATRIX_FIRST_TRANSPOSE_I_STATE =>  -- STEP 3

          -- Control Inputs
          data_in_i_enable_matrix_transpose <= E_IN_K_ENABLE;
          data_in_j_enable_matrix_transpose <= '0';

          -- Data Inputs
          size_i_in_matrix_transpose <= SIZE_W_IN;
          size_j_in_matrix_transpose <= ONE_DATA;
          data_in_matrix_transpose   <= E_IN;

          if (data_out_i_enable_matrix_transpose = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_FIRST_TRANSPOSE_J_STATE =>  -- STEP 4

          -- Control Inputs
          data_in_i_enable_matrix_transpose <= E_IN_K_ENABLE;
          data_in_j_enable_matrix_transpose <= '0';

          -- Data Inputs
          size_i_in_matrix_transpose <= SIZE_W_IN;
          size_j_in_matrix_transpose <= ONE_DATA;
          data_in_matrix_transpose   <= E_IN;

          if (data_out_j_enable_matrix_transpose = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_I_SECOND_STATE =>    -- STEP 5

        when INPUT_J_SECOND_STATE =>    -- STEP 6

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 7

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= W_IN_J_ENABLE;
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= data_out_i_enable_matrix_transpose;
          data_b_in_j_enable_matrix_product <= data_out_j_enable_matrix_transpose;

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_N_IN;
          size_a_j_in_matrix_product <= ONE_DATA;
          size_b_i_in_matrix_product <= ONE_DATA;
          size_b_j_in_matrix_product <= SIZE_W_IN;
          data_a_in_matrix_product   <= W_IN;
          data_b_in_matrix_product   <= data_out_matrix_transpose;

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 8

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= W_IN_J_ENABLE;
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= data_out_i_enable_matrix_transpose;
          data_b_in_j_enable_matrix_product <= data_out_j_enable_matrix_transpose;

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_N_IN;
          size_a_j_in_matrix_product <= ONE_DATA;
          size_b_i_in_matrix_product <= ONE_DATA;
          size_b_j_in_matrix_product <= SIZE_W_IN;
          data_a_in_matrix_product   <= W_IN;
          data_b_in_matrix_product   <= data_out_matrix_transpose;

          if (data_out_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';
          end if;

        when MATRIX_FIRST_ADDER_I_STATE =>  -- STEP 9

          -- Control Inputs
          operation_matrix_float_adder <= '0';

          data_a_in_i_enable_matrix_float_adder <= data_a_in_i_enable_matrix_product;
          data_a_in_j_enable_matrix_float_adder <= data_a_in_j_enable_matrix_product;
          data_b_in_i_enable_matrix_float_adder <= data_b_in_i_enable_matrix_product;
          data_b_in_j_enable_matrix_float_adder <= data_b_in_j_enable_matrix_product;

          -- Data Inputs
          size_i_in_matrix_float_adder <= SIZE_N_IN;
          size_j_in_matrix_float_adder <= SIZE_W_IN;
          data_a_in_matrix_float_adder <= ONE_DATA;
          data_b_in_matrix_float_adder <= data_out_matrix_product;

          if (data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_FIRST_ADDER_J_STATE =>  -- STEP 10

          -- Control Inputs
          operation_matrix_float_adder <= '0';

          data_a_in_i_enable_matrix_float_adder <= data_a_in_i_enable_matrix_product;
          data_a_in_j_enable_matrix_float_adder <= data_a_in_j_enable_matrix_product;
          data_b_in_i_enable_matrix_float_adder <= data_b_in_i_enable_matrix_product;
          data_b_in_j_enable_matrix_float_adder <= data_b_in_j_enable_matrix_product;

          -- Data Inputs
          size_i_in_matrix_float_adder <= SIZE_N_IN;
          size_j_in_matrix_float_adder <= SIZE_W_IN;
          data_a_in_matrix_float_adder <= ONE_DATA;
          data_b_in_matrix_float_adder <= data_out_matrix_product;

          if (data_out_j_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_I_THIRD_STATE =>     -- STEP 11

        when INPUT_J_THIRD_STATE =>     -- STEP 12

        when MATRIX_MULTIPLIER_I_STATE =>  -- STEP 13

          -- Control Inputs
          data_a_in_i_enable_matrix_float_multiplier <= M_IN_J_ENABLE;
          data_a_in_j_enable_matrix_float_multiplier <= M_IN_K_ENABLE;
          data_b_in_i_enable_matrix_float_multiplier <= data_out_i_enable_matrix_float_adder;
          data_b_in_j_enable_matrix_float_multiplier <= data_out_j_enable_matrix_float_adder;

          -- Data Inputs
          size_i_in_matrix_float_multiplier <= SIZE_N_IN;
          size_j_in_matrix_float_multiplier <= SIZE_W_IN;
          data_a_in_matrix_float_multiplier <= M_IN;
          data_b_in_matrix_float_multiplier <= data_out_matrix_float_adder;

          if (data_out_i_enable_matrix_float_multiplier = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_MULTIPLIER_J_STATE =>  -- STEP 14

          -- Control Inputs
          data_a_in_i_enable_matrix_float_multiplier <= M_IN_J_ENABLE;
          data_a_in_j_enable_matrix_float_multiplier <= M_IN_K_ENABLE;
          data_b_in_i_enable_matrix_float_multiplier <= data_out_i_enable_matrix_float_adder;
          data_b_in_j_enable_matrix_float_multiplier <= data_out_j_enable_matrix_float_adder;

          -- Data Inputs
          size_i_in_matrix_float_multiplier <= SIZE_N_IN;
          size_j_in_matrix_float_multiplier <= SIZE_W_IN;
          data_a_in_matrix_float_multiplier <= M_IN;
          data_b_in_matrix_float_multiplier <= data_out_matrix_float_adder;

          if (data_out_j_enable_matrix_float_multiplier = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_I_FOURTH_STATE =>    -- STEP 15

        when INPUT_J_FOURTH_STATE =>    -- STEP 16

        when MATRIX_SECOND_TRANSPOSE_I_STATE =>  -- STEP 17

          -- Control Inputs
          data_in_i_enable_matrix_transpose <= V_IN_K_ENABLE;
          data_in_j_enable_matrix_transpose <= '0';

          -- Data Inputs
          size_i_in_matrix_transpose <= SIZE_W_IN;
          size_j_in_matrix_transpose <= ONE_DATA;
          data_in_matrix_transpose   <= V_IN;

          if (data_out_i_enable_matrix_transpose = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_SECOND_TRANSPOSE_J_STATE =>  -- STEP 18

          -- Control Inputs
          data_in_i_enable_matrix_transpose <= V_IN_K_ENABLE;
          data_in_j_enable_matrix_transpose <= '0';

          -- Data Inputs
          size_i_in_matrix_transpose <= SIZE_W_IN;
          size_j_in_matrix_transpose <= ONE_DATA;
          data_in_matrix_transpose   <= V_IN;

          if (data_out_j_enable_matrix_transpose = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';

            -- Control Internal
            start_matrix_transpose <= '0';
          end if;

        when INPUT_I_FIFTH_STATE =>     -- STEP 19

        when INPUT_J_FIFTH_STATE =>     -- STEP 20

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 21

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= W_IN_J_ENABLE;
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= data_out_i_enable_matrix_transpose;
          data_b_in_j_enable_matrix_product <= data_out_j_enable_matrix_transpose;

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_N_IN;
          size_a_j_in_matrix_product <= ONE_DATA;
          size_b_i_in_matrix_product <= ONE_DATA;
          size_b_j_in_matrix_product <= SIZE_W_IN;
          data_a_in_matrix_product   <= W_IN;
          data_b_in_matrix_product   <= data_out_matrix_transpose;

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 22

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= W_IN_J_ENABLE;
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= data_out_i_enable_matrix_transpose;
          data_b_in_j_enable_matrix_product <= data_out_j_enable_matrix_transpose;

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_N_IN;
          size_a_j_in_matrix_product <= ONE_DATA;
          size_b_i_in_matrix_product <= ONE_DATA;
          size_b_j_in_matrix_product <= SIZE_W_IN;
          data_a_in_matrix_product   <= W_IN;
          data_b_in_matrix_product   <= data_out_matrix_transpose;

          if (data_out_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';
          end if;

        when MATRIX_SECOND_ADDER_I_STATE =>  -- STEP 23

          -- Control Inputs
          operation_matrix_float_adder <= '1';

          data_a_in_i_enable_matrix_float_adder <= data_a_in_i_enable_matrix_float_multiplier;
          data_a_in_j_enable_matrix_float_adder <= data_a_in_j_enable_matrix_float_multiplier;
          data_b_in_i_enable_matrix_float_adder <= data_b_in_i_enable_matrix_product;
          data_b_in_j_enable_matrix_float_adder <= data_b_in_j_enable_matrix_product;

          -- Data Inputs
          size_i_in_matrix_float_adder <= SIZE_N_IN;
          size_j_in_matrix_float_adder <= SIZE_W_IN;
          data_a_in_matrix_float_adder <= data_out_matrix_float_multiplier;
          data_b_in_matrix_float_adder <= data_out_matrix_product;

          if (data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_J_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
          end if;

        when MATRIX_SECOND_ADDER_J_STATE =>  -- STEP 24

          -- Control Inputs
          operation_matrix_float_adder <= '1';

          data_a_in_i_enable_matrix_float_adder <= data_a_in_i_enable_matrix_float_multiplier;
          data_a_in_j_enable_matrix_float_adder <= data_a_in_j_enable_matrix_float_multiplier;
          data_b_in_i_enable_matrix_float_adder <= data_b_in_i_enable_matrix_product;
          data_b_in_j_enable_matrix_float_adder <= data_b_in_j_enable_matrix_product;

          -- Data Inputs
          size_i_in_matrix_float_adder <= SIZE_N_IN;
          size_j_in_matrix_float_adder <= SIZE_W_IN;
          data_a_in_matrix_float_adder <= data_out_matrix_float_multiplier;
          data_b_in_matrix_float_adder <= data_out_matrix_product;

          if (data_out_j_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_TRANSPOSE_I_STATE;
            end if;

            -- Data Outputs
            M_OUT <= data_out_matrix_float_adder;

            -- Control Outputs
            M_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            M_OUT_K_ENABLE <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

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
      DATA_OUT  => data_out_matrix_float_adder
      );

  -- MATRIX MULTIPLIER
  matrix_float_multiplier : ntm_matrix_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_float_multiplier,
      READY => ready_matrix_float_multiplier,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_float_multiplier,
      SIZE_J_IN => size_j_in_matrix_float_multiplier,
      DATA_A_IN => data_a_in_matrix_float_multiplier,
      DATA_B_IN => data_b_in_matrix_float_multiplier,
      DATA_OUT  => data_out_matrix_float_multiplier
      );

  -- MATRIX TRANSPOSE
  matrix_transpose : ntm_matrix_transpose
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_transpose,
      READY => ready_matrix_transpose,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_transpose,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_transpose,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_transpose,
      SIZE_J_IN => size_j_in_matrix_transpose,
      DATA_IN   => data_in_matrix_transpose,
      DATA_OUT  => data_out_matrix_transpose
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

end architecture;
