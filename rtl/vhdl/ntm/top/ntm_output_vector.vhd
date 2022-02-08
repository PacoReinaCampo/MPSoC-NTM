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
use work.ntm_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity ntm_output_vector is
  generic (
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    K_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    K_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    R_IN_K_ENABLE : in std_logic;       -- for j in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    R_OUT_K_ENABLE : out std_logic;     -- for j in 0 to W-1

    U_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    U_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_output_vector_architecture of ntm_output_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_I_STATE,                -- STEP 1
    INPUT_FIRST_J_STATE,                -- STEP 2
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 3
    MATRIX_FIRST_PRODUCT_J_STATE,       -- STEP 4
    MATRIX_FIRST_ADDER_I_STATE,         -- STEP 5
    MATRIX_FIRST_ADDER_J_STATE,         -- STEP 6
    INPUT_SECOND_I_STATE,               -- STEP 7
    INPUT_SECOND_J_STATE,               -- STEP 8
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 9
    MATRIX_SECOND_PRODUCT_J_STATE,      -- STEP 10
    MATRIX_SECOND_ADDER_I_STATE,        -- STEP 11
    MATRIX_SECOND_ADDER_J_STATE         -- STEP 12
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

  signal data_a_int_i_product : std_logic;
  signal data_a_int_j_product : std_logic;
  signal data_b_int_i_product : std_logic;
  signal data_b_int_j_product : std_logic;

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_integer_adder : std_logic;
  signal ready_matrix_integer_adder : std_logic;

  signal operation_matrix_integer_adder : std_logic;

  signal data_a_in_i_enable_matrix_integer_adder : std_logic;
  signal data_a_in_j_enable_matrix_integer_adder : std_logic;
  signal data_b_in_i_enable_matrix_integer_adder : std_logic;
  signal data_b_in_j_enable_matrix_integer_adder : std_logic;

  signal data_out_i_enable_matrix_integer_adder : std_logic;
  signal data_out_j_enable_matrix_integer_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_integer_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

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
            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          end if;

        when INPUT_FIRST_I_STATE =>     -- STEP 1

          if (K_IN_Y_ENABLE = '1') then
            -- Data Inputs
            data_a_in_matrix_product <= K_IN;

            -- Control Internal
            data_a_in_i_enable_matrix_product <= '1';

            data_a_int_i_product <= '1';
          else
            -- Control Internal
            data_a_in_i_enable_matrix_product <= '0';
          end if;

          if (R_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_b_in_matrix_product <= R_IN;

            -- Control Internal
            data_b_in_i_enable_matrix_product <= '1';

            data_b_int_i_product <= '1';
          else
            -- Control Internal
            data_b_in_i_enable_matrix_product <= '0';
          end if;

          if (data_a_int_i_product = '1' and data_b_int_i_product = '1') then
            if (index_i_loop = ZERO_CONTROL) then
              -- Control Internal
              start_matrix_product <= '1';
            end if;

            data_a_int_i_product <= '0';
            data_b_int_i_product <= '0';

            -- Data Inputs
            size_a_i_in_matrix_product <= SIZE_Y_IN;
            size_b_i_in_matrix_product <= SIZE_W_IN;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_I_STATE;
          end if;

        when INPUT_FIRST_J_STATE =>     -- STEP 2

          if (K_IN_K_ENABLE = '1') then
            -- Data Inputs
            size_a_j_in_matrix_product <= SIZE_W_IN;
            size_b_j_in_matrix_product <= ONE_DATA;

            data_a_in_matrix_product <= K_IN;

            if (index_j_loop = ZERO_CONTROL) then
              -- Control Internal
              start_matrix_product <= '1';
            end if;

            data_a_in_j_enable_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
          else
            -- Control Internal
            data_a_in_j_enable_matrix_product <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 3

          if (data_out_i_enable_matrix_product = '1') then
            -- Data Outputs
            data_a_in_matrix_integer_adder <= ZERO_DATA;
            data_b_in_matrix_integer_adder <= ZERO_DATA;

            -- Control Outputs
            K_OUT_Y_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            data_a_in_i_enable_matrix_integer_adder <= '1';
            data_b_in_i_enable_matrix_integer_adder <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_ADDER_I_STATE;
          else
            -- Control Outputs
            data_a_in_i_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 4

          if (data_out_j_enable_matrix_product = '1') then
            -- Data Outputs
            data_a_in_matrix_integer_adder <= ZERO_DATA;
            data_b_in_matrix_integer_adder <= ZERO_DATA;

            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_ADDER_J_STATE;
          else
            -- Control Outputs
            data_a_in_j_enable_matrix_product <= '0';
          end if;

        when MATRIX_FIRST_ADDER_I_STATE =>  -- STEP 5

          if (data_out_i_enable_matrix_integer_adder = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_R_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SECOND_ADDER_I_STATE;
            end if;

            -- Data Outputs
            data_a_in_matrix_integer_adder <= ZERO_DATA;
            data_b_in_matrix_integer_adder <= ZERO_DATA;

            -- Control Outputs
            data_a_in_i_enable_matrix_integer_adder <= '1';
          else
            -- Control Outputs
            K_OUT_Y_ENABLE <= '0';
            R_OUT_K_ENABLE <= '0';

            data_a_in_i_enable_matrix_integer_adder <= '0';
          end if;

        when MATRIX_FIRST_ADDER_J_STATE =>  -- STEP 6

          if (data_out_j_enable_matrix_integer_adder = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_Y_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_R_IN) - unsigned(ONE_CONTROL))) then
              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SECOND_ADDER_J_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_R_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SECOND_ADDER_J_STATE;
            end if;

            -- Data Outputs
            data_a_in_matrix_integer_adder <= ZERO_DATA;
            data_b_in_matrix_integer_adder <= ZERO_DATA;

            -- Control Outputs
            data_a_in_j_enable_matrix_integer_adder <= '1';
            data_b_in_j_enable_matrix_integer_adder <= '1';
          else
            -- Control Outputs
            K_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_SECOND_I_STATE =>    -- STEP 7

          if (U_IN_Y_ENABLE = '1') then
            -- Data Inputs
            size_a_i_in_matrix_product <= SIZE_L_IN;
            size_b_i_in_matrix_product <= ONE_DATA;

            data_a_in_matrix_product <= U_IN;

            if (index_i_loop = ZERO_CONTROL) then
              -- Control Internal
              start_matrix_product <= '1';
            end if;

            data_a_in_i_enable_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_SECOND_PRODUCT_I_STATE;
          else
            -- Control Internal
            data_a_in_i_enable_matrix_product <= '0';
          end if;

        when INPUT_SECOND_J_STATE =>    -- STEP 8

          if (K_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_a_in_matrix_product <= K_IN;

            -- Control Internal
            data_a_in_j_enable_matrix_product <= '1';

            data_a_int_j_product <= '1';
          else
            -- Control Internal
            data_a_in_j_enable_matrix_product <= '0';
          end if;

          if (data_a_int_j_product = '1' and data_b_int_j_product = '1') then
            if (index_j_loop = ZERO_CONTROL) then
              -- Control Internal
              start_matrix_product <= '1';
            end if;

            data_a_int_j_product <= '0';
            data_b_int_j_product <= '0';

            -- Data Inputs
            size_a_j_in_matrix_product <= SIZE_W_IN;
            size_b_j_in_matrix_product <= SIZE_W_IN;

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_SECOND_PRODUCT_J_STATE;
          end if;

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 9

          if (data_out_i_enable_matrix_product = '1') then
            -- Data Outputs
            data_b_in_matrix_integer_adder <= data_out_matrix_product;

            -- Control Outputs
            U_OUT_Y_ENABLE <= '1';
            H_OUT_ENABLE   <= '1';

            data_b_in_i_enable_matrix_integer_adder <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_SECOND_ADDER_I_STATE;
          else
            -- Control Outputs
            data_b_in_i_enable_matrix_product <= '0';
          end if;

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 10

          if (data_out_j_enable_matrix_product = '1') then
            -- Data Outputs
            data_b_in_matrix_integer_adder <= data_out_matrix_product;

            -- Control Outputs
            U_OUT_L_ENABLE <= '1';

            data_b_in_j_enable_matrix_integer_adder <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_SECOND_ADDER_J_STATE;
          else
            -- Control Outputs
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when MATRIX_SECOND_ADDER_I_STATE =>  -- STEP 11

          if (data_out_i_enable_matrix_integer_adder = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_R_IN))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
            end if;

            -- Data Outputs
            Y_OUT <= data_out_matrix_integer_adder;

            -- Control Outputs
            Y_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            U_OUT_Y_ENABLE <= '0';
            H_OUT_ENABLE   <= '0';

            data_b_in_i_enable_matrix_product <= '0';
          end if;

        when MATRIX_SECOND_ADDER_J_STATE =>  -- STEP 12

          if (data_out_j_enable_matrix_integer_adder = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_Y_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_R_IN))) then
              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_R_IN))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
            end if;
          else
            -- Control Outputs
            U_OUT_L_ENABLE <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MATRIX ADDER
  matrix_integer_adder : ntm_matrix_integer_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_integer_adder,
      READY => ready_matrix_integer_adder,

      OPERATION => operation_matrix_integer_adder,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_adder,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_adder,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_adder,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_adder,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_adder,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_adder,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_integer_adder,
      SIZE_J_IN => size_j_in_matrix_integer_adder,
      DATA_A_IN => data_a_in_matrix_integer_adder,
      DATA_B_IN => data_b_in_matrix_integer_adder,
      DATA_OUT  => data_out_matrix_integer_adder
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
