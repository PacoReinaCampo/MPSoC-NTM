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

entity ntm_state_matrix_feedforward is
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

    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_D_OUT_I_ENABLE : out std_logic;
    DATA_D_OUT_J_ENABLE : out std_logic;

    -- DATA
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_state_matrix_feedforward_architecture of ntm_state_matrix_feedforward is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type feedforward_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_I_STATE,                -- STEP 1
    INPUT_FIRST_J_STATE,                -- STEP 2
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 3
    MATRIX_FIRST_PRODUCT_J_STATE,       -- STEP 4
    MATRIX_ADDER_I_STATE,               -- STEP 5
    MATRIX_ADDER_J_STATE,               -- STEP 6
    MATRIX_INVERSE_I_STATE,             -- STEP 7
    MATRIX_INVERSE_J_STATE,             -- STEP 8
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 9
    MATRIX_SECOND_PRODUCT_J_STATE       -- STEP 10
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
  signal feedforward_ctrl_fsm_int : feedforward_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_feedforward_int : std_logic;
  signal data_a_in_j_feedforward_int : std_logic;
  signal data_b_in_i_feedforward_int : std_logic;
  signal data_b_in_j_feedforward_int : std_logic;

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

  signal data_out_matrix_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- MATRIX INVERSE
  -- CONTROL
  signal start_matrix_inverse : std_logic;
  signal ready_matrix_inverse : std_logic;

  signal data_in_i_enable_matrix_inverse : std_logic;
  signal data_in_j_enable_matrix_inverse : std_logic;

  signal data_i_enable_matrix_inverse : std_logic;
  signal data_j_enable_matrix_inverse : std_logic;

  signal data_out_i_enable_matrix_inverse : std_logic;
  signal data_out_j_enable_matrix_inverse : std_logic;

  -- DATA
  signal size_i_in_matrix_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_inverse   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inverse  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- d = inv(I+D·K)·D

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_D_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case feedforward_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_i_loop <= ZERO_CONTROL;
          index_j_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- FSM Control
            feedforward_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          end if;

        when INPUT_FIRST_I_STATE =>     -- STEP 1 D,K

          if ((DATA_D_IN_I_ENABLE = '1') and (DATA_D_IN_J_ENABLE = '1')) then
            -- Data Inputs
            data_a_in_matrix_product <= DATA_D_IN;

            -- Control Internal
            data_a_in_i_enable_matrix_product <= '1';
            data_a_in_j_enable_matrix_product <= '1';

            data_a_in_i_feedforward_int <= '1';
            data_a_in_j_feedforward_int <= '1';
          else
            -- Control Internal
            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
          end if;

          if ((DATA_K_IN_I_ENABLE = '1') and (DATA_K_IN_J_ENABLE = '1')) then
            -- Data Inputs
            data_b_in_matrix_product <= DATA_K_IN;

            -- Control Internal
            data_b_in_i_enable_matrix_product <= '1';
            data_b_in_j_enable_matrix_product <= '1';

            data_b_in_i_feedforward_int <= '1';
            data_b_in_j_feedforward_int <= '1';
          else
            -- Control Internal
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

          -- Control Outputs
          DATA_D_I_ENABLE <= '0';
          DATA_D_J_ENABLE <= '0';

          DATA_K_I_ENABLE <= '0';
          DATA_K_J_ENABLE <= '0';

          if (data_a_in_i_feedforward_int = '1' and data_a_in_j_feedforward_int = '1' and data_b_in_i_feedforward_int = '1' and data_b_in_j_feedforward_int = '1') then
            -- Control Internal
            data_a_in_i_feedforward_int <= '0';
            data_a_in_j_feedforward_int <= '0';
            data_b_in_i_feedforward_int <= '0';
            data_b_in_j_feedforward_int <= '0';

            -- FSM Control
            feedforward_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
          end if;

        when INPUT_FIRST_J_STATE =>     -- STEP 2 D,K

          if (DATA_D_IN_J_ENABLE = '1') then
            -- Data Inputs
            data_a_in_matrix_product <= DATA_D_IN;

            -- Control Internal
            data_a_in_j_enable_matrix_product <= '1';

            data_a_in_j_feedforward_int <= '1';
          else
            -- Control Internal
            data_a_in_j_enable_matrix_product <= '0';
          end if;

          if (DATA_K_IN_J_ENABLE = '1') then
            -- Data Inputs
            data_b_in_matrix_product <= DATA_K_IN;

            -- Control Internal
            data_b_in_j_enable_matrix_product <= '1';

            data_b_in_j_feedforward_int <= '1';
          else
            -- Control Internal
            data_b_in_j_enable_matrix_product <= '0';
          end if;

          -- Control Outputs
          DATA_D_J_ENABLE <= '0';

          DATA_K_J_ENABLE <= '0';

          if (data_a_in_j_feedforward_int = '1' and data_b_in_j_feedforward_int = '1') then
            -- Control Internal
            data_a_in_j_feedforward_int <= '0';
            data_b_in_j_feedforward_int <= '0';

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              feedforward_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_I_STATE;
            else
              feedforward_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;
          end if;

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 3 (D·K)

          if (data_out_i_enable_matrix_product = '1') then
            -- Data Outputs
            data_b_in_matrix_float_adder <= data_out_matrix_product;

            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            data_b_in_i_enable_matrix_float_adder <= '1';

            -- FSM Control
            feedforward_ctrl_fsm_int <= MATRIX_ADDER_J_STATE;
          end if;

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 4 (D·K)

          if (data_out_j_enable_matrix_product = '1') then
            -- Data Outputs
            data_b_in_matrix_float_adder <= data_out_matrix_product;

            -- Control Outputs
            DATA_D_J_ENABLE <= '1';

            DATA_K_J_ENABLE <= '1';

            data_b_in_i_enable_matrix_float_adder <= '1';

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              feedforward_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
            else
              feedforward_ctrl_fsm_int <= INPUT_FIRST_J_STATE;
            end if;
          end if;

        when MATRIX_ADDER_I_STATE =>    -- STEP 5 (I+D·K)

        when MATRIX_ADDER_J_STATE =>    -- STEP 6 (I+D·K)

        when MATRIX_INVERSE_I_STATE =>  -- STEP 7 inv(I+D·K)

        when MATRIX_INVERSE_J_STATE =>  -- STEP 8 inv(I+D·K)

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 9 inv(I+D·K)·D

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 10 inv(I+D·K)·D

        when others =>
          -- FSM Control
          feedforward_ctrl_fsm_int <= STARTER_STATE;
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

      DATA_OUT     => data_out_matrix_float_adder
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

  -- MATRIX INVERSE
  matrix_inverse : ntm_matrix_inverse
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_inverse,
      READY => ready_matrix_inverse,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverse,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverse,

      DATA_I_ENABLE => data_i_enable_matrix_inverse,
      DATA_J_ENABLE => data_j_enable_matrix_inverse,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverse,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverse,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_inverse,
      SIZE_J_IN => size_j_in_matrix_inverse,
      DATA_IN   => data_in_matrix_inverse,
      DATA_OUT  => data_out_matrix_inverse
      );

end architecture;
