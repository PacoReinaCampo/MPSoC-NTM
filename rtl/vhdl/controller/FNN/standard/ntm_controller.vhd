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
    X : integer := 64;
    Y : integer := 64;
    N : integer := 64;
    W : integer := 64;
    L : integer := 64;
    R : integer := 64;

    DATA_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    H_OUT_ENABLE : in std_logic;        -- for l in 0 to L-1

    -- DATA
    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_controller_architecture of ntm_controller is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    VECTOR_SUMMATION_STATE,             -- STEP 1
    MATRIX_PRODUCT_STATE,               -- STEP 2
    ENDER_STATE                         -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_loop : integer;

  signal data_in_vector_summation_int : std_logic;

  signal data_a_in_i_matrix_product_int : std_logic;
  signal data_a_in_j_matrix_product_int : std_logic;
  signal data_b_in_i_matrix_product_int : std_logic;
  signal data_b_in_j_matrix_product_int : std_logic;

  signal data_in_vector_logistic_int : std_logic;

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_enable_vector_summation : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal modulo_in_vector_summation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal modulo_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGISTIC
  -- CONTROL
  signal start_vector_logistic : std_logic;
  signal ready_vector_logistic : std_logic;

  signal data_in_enable_vector_logistic : std_logic;

  signal data_out_enable_vector_logistic : std_logic;

  -- DATA
  signal modulo_in_vector_logistic : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_logistic   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logistic  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TRAINER
  -- CONTROL
  signal start_trainer : std_logic;
  signal ready_trainer : std_logic;

  signal h_in_enable_trainer : std_logic;

  signal w_out_i_enable_trainer : std_logic;
  signal w_out_l_enable_trainer : std_logic;
  signal w_out_x_enable_trainer : std_logic;

  signal k_out_l_enable_trainer : std_logic;
  signal k_out_k_enable_trainer : std_logic;

  signal b_out_enable_trainer : std_logic;

  -- DATA
  signal h_in_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_trainer : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + b(t;l))

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      H_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      index_loop <= 0;

      data_in_vector_summation_int <= '0';

      data_a_in_i_matrix_product_int <= '0';
      data_a_in_j_matrix_product_int <= '0';
      data_b_in_i_matrix_product_int <= '0';
      data_b_in_j_matrix_product_int <= '0';

      data_in_vector_logistic_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_SUMMATION_STATE;
          end if;

        when VECTOR_SUMMATION_STATE =>  -- STEP 1

        when MATRIX_PRODUCT_STATE =>    -- STEP 2

        when ENDER_STATE =>             -- STEP 3

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

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

      DATA_IN_ENABLE => data_in_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      MODULO_IN => modulo_in_vector_summation,
      SIZE_IN   => size_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      I => I,
      J => J,

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
      MODULO_IN => modulo_in_matrix_product,
      DATA_A_IN => data_a_in_matrix_product,
      DATA_B_IN => data_b_in_matrix_product,
      DATA_OUT  => data_out_matrix_product
      );

  -- VECTOR LOGISTIC
  vector_logistic_function : ntm_vector_logistic_function
    generic map (
      I => I,

      DATA_SIZE => DATA_SIZE
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
      DATA_IN   => data_in_vector_logistic,
      DATA_OUT  => data_out_vector_logistic
      );

  -- TRAINER
  ntm : ntm_trainer
    generic map (
      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_trainer,
      READY => ready_trainer,

      H_IN_ENABLE => h_in_enable_trainer,

      W_OUT_I_ENABLE => w_out_i_enable_trainer,
      W_OUT_L_ENABLE => w_out_l_enable_trainer,
      W_OUT_X_ENABLE => w_out_x_enable_trainer,

      K_OUT_L_ENABLE => k_out_l_enable_trainer,
      K_OUT_K_ENABLE => k_out_k_enable_trainer,

      B_OUT_ENABLE => b_out_enable_trainer,

      -- DATA
      H_IN => h_in_trainer,

      W_OUT => w_out_trainer,
      K_OUT => k_out_trainer,
      B_OUT => b_out_trainer
      );

end architecture;
