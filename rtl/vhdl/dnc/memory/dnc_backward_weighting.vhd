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

entity dnc_backward_weighting is
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

    L_IN_G_ENABLE : in std_logic;       -- for g in 0 to N-1 (square matrix)
    L_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1 (square matrix)

    L_OUT_G_ENABLE : out std_logic;     -- for g in 0 to N-1 (square matrix)
    L_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1 (square matrix)

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    B_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    B_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_backward_weighting_architecture of dnc_backward_weighting is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    MATRIX_TRANSPOSE_I_STATE,           -- STEP 1
    MATRIX_TRANSPOSE_J_STATE,           -- STEP 2
    MATRIX_PRODUCT_I_STATE,             -- STEP 3
    MATRIX_PRODUCT_J_STATE              -- STEP 4
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

  -- MATRIX TRANSPOSE
  -- CONTROL
  signal start_matrix_transpose : std_logic;
  signal ready_matrix_transpose : std_logic;

  signal data_in_i_enable_matrix_transpose : std_logic;
  signal data_in_j_enable_matrix_transpose : std_logic;

  signal data_out_i_enable_matrix_transpose : std_logic;
  signal data_out_j_enable_matrix_transpose : std_logic;

  -- DATA
  signal modulo_in_matrix_transpose : std_logic_vector(DATA_SIZE-1 downto 0);
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
  signal modulo_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
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

  -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      B_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      B_OUT_I_ENABLE <= '0';
      B_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          B_OUT_I_ENABLE <= '0';
          B_OUT_J_ENABLE <= '0';

          -- Control Internal
          index_i_loop <= ZERO_CONTROL;
          index_j_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Control Internal
            start_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_TRANSPOSE_I_STATE;
          else
            -- Control Internal
            start_matrix_product <= '0';
          end if;

        when MATRIX_TRANSPOSE_I_STATE =>  -- STEP 1

        when MATRIX_TRANSPOSE_J_STATE =>  -- STEP 2

        when MATRIX_PRODUCT_I_STATE =>  -- STEP 3

          if (data_out_i_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_R_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_PRODUCT_J_STATE;
            end if;

            -- Data Outputs
            B_OUT <= data_out_matrix_product;

            -- Control Outputs
            B_OUT_I_ENABLE <= '1';
          else
            -- Control Outputs
            B_OUT_I_ENABLE <= '0';
          end if;

        when MATRIX_PRODUCT_J_STATE =>  -- STEP 4

          if (data_out_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_R_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_R_IN) - unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) < unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_PRODUCT_I_STATE;
            end if;

            -- Data Outputs
            B_OUT <= data_out_matrix_product;

            -- Control Outputs
            B_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            B_OUT_J_ENABLE <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MATRIX TRANSPOSE
  data_in_i_enable_matrix_transpose <= L_IN_G_ENABLE;
  data_in_j_enable_matrix_transpose <= L_IN_J_ENABLE;

  -- MATRIX PRODUCT
  data_a_in_i_enable_matrix_product <= data_out_i_enable_matrix_transpose;
  data_a_in_j_enable_matrix_product <= data_out_j_enable_matrix_transpose;
  data_b_in_i_enable_matrix_product <= W_IN_J_ENABLE;
  data_b_in_j_enable_matrix_product <= '0';

  -- DATA
  -- MATRIX TRANSPOSE
  modulo_in_matrix_transpose <= FULL;
  size_i_in_matrix_transpose <= SIZE_N_IN;
  size_j_in_matrix_transpose <= SIZE_N_IN;
  data_in_matrix_transpose   <= L_IN;

  -- MATRIX PRODUCT
  modulo_in_matrix_product   <= FULL;
  size_a_i_in_matrix_product <= SIZE_N_IN;
  size_a_j_in_matrix_product <= SIZE_N_IN;
  size_b_i_in_matrix_product <= SIZE_N_IN;
  size_b_j_in_matrix_product <= ONE_CONTROL;
  data_a_in_matrix_product   <= data_out_matrix_transpose;
  data_b_in_matrix_product   <= W_IN;

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
      MODULO_IN => modulo_in_matrix_transpose,
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
      MODULO_IN   => modulo_in_matrix_product,
      SIZE_A_I_IN => size_a_i_in_matrix_product,
      SIZE_A_J_IN => size_a_j_in_matrix_product,
      SIZE_B_I_IN => size_b_i_in_matrix_product,
      SIZE_B_J_IN => size_b_j_in_matrix_product,
      DATA_A_IN   => data_a_in_matrix_product,
      DATA_B_IN   => data_b_in_matrix_product,
      DATA_OUT    => data_out_matrix_product
      );

end architecture;
