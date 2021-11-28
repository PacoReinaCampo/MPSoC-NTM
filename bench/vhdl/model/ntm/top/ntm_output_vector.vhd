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
use work.ntm_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity ntm_output_vector is
  generic (
    DATA_SIZE : integer := 512
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

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    R_IN_K_ENABLE : in std_logic;       -- for j in 0 to W-1

    U_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    U_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    Y_OUT_ENABLE : in std_logic;        -- for y in 0 to Y-1

    -- DATA
    SIZE_Y_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

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
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 1
    MATRIX_FIRST_PRODUCT_J_STATE,       -- STEP 2
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 3
    MATRIX_SECOND_PRODUCT_J_STATE,      -- STEP 4
    MATRIX_SUMMATION_STATE              -- STEP 5
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_a_i_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_vector_enable_vector_summation : std_logic;
  signal data_in_scalar_enable_vector_summation : std_logic;

  signal data_out_vector_enable_vector_summation : std_logic;
  signal data_out_scalar_enable_vector_summation : std_logic;

  -- DATA
  signal modulo_in_vector_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

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
      Y_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_i_loop <= ZERO;
          index_j_loop <= ZERO;

          if (START = '1') then
            -- Control Internal
            start_vector_summation <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_I_STATE;

            -- Control Internal
            start_vector_summation <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 1

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_in_vector_summation <= data_out_matrix_product;

            -- Control Outputs
            data_in_vector_enable_vector_summation <= '1';
          else
            -- Control Outputs
            data_in_vector_enable_vector_summation <= '0';
          end if;

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 2

          if (data_out_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_Y_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SUMMATION_STATE;
            end if;

            -- Data Outputs
            data_in_vector_summation <= data_out_matrix_product;

            -- Control Outputs
            data_in_scalar_enable_vector_summation <= '1';
          else
            -- Control Outputs
            data_in_scalar_enable_vector_summation <= '0';
          end if;

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 3

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SECOND_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            data_in_vector_summation <= data_out_matrix_product;

            -- Control Outputs
            data_in_vector_enable_vector_summation <= '1';
          else
            -- Control Outputs
            data_in_vector_enable_vector_summation <= '0';
          end if;

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 4

          if (data_out_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_Y_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN) - unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_W_IN) - unsigned(ONE))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SUMMATION_STATE;
            end if;

            -- Data Outputs
            data_in_vector_summation <= data_out_matrix_product;

            -- Control Outputs
            data_in_scalar_enable_vector_summation <= '1';
          else
            -- Control Outputs
            data_in_scalar_enable_vector_summation <= '0';
          end if;

        when MATRIX_SUMMATION_STATE =>  -- STEP 5

          if (data_out_vector_enable_vector_summation = '1') then
            if (unsigned(index_i_loop) = unsigned(SIZE_Y_IN) - unsigned(ONE)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_SECOND_PRODUCT_I_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MATRIX PRODUCT
  data_a_in_i_enable_matrix_product <= K_IN_Y_ENABLE;
  data_a_in_j_enable_matrix_product <= K_IN_K_ENABLE;
  data_b_in_i_enable_matrix_product <= R_IN_K_ENABLE;
  data_b_in_j_enable_matrix_product <= '0';

  -- VECTOR SUMMATION
  data_in_vector_enable_vector_summation <= data_out_i_enable_matrix_product;
  data_in_scalar_enable_vector_summation <= data_out_j_enable_matrix_product;

  -- DATA
  -- MATRIX PRODUCT
  modulo_in_matrix_product   <= FULL;
  size_a_i_in_matrix_product <= SIZE_Y_IN;
  size_a_j_in_matrix_product <= SIZE_W_IN;
  size_b_i_in_matrix_product <= SIZE_W_IN;
  size_b_j_in_matrix_product <= SIZE_R_IN;
  data_a_in_matrix_product   <= K_IN;
  data_b_in_matrix_product   <= R_IN;

  -- VECTOR SUMMATION
  modulo_in_vector_summation <= FULL;
  size_in_vector_summation   <= SIZE_Y_IN;
  length_in_vector_summation <= SIZE_R_IN;
  data_in_vector_summation   <= data_out_matrix_product;

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      DATA_SIZE => DATA_SIZE
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

  -- VECTOR SUMMATION
  vector_summation_function : ntm_vector_summation_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_summation,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_summation,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_summation,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_summation,

      -- DATA
      MODULO_IN => modulo_in_vector_summation,
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

end architecture;
