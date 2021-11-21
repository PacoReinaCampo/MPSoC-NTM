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
use work.ntm_lstm_controller_pkg.all;

entity ntm_activation_trainer is
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

    X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    A_IN_ENABLE : in std_logic;         -- for l in 0 to L-1
    I_IN_ENABLE : in std_logic;         -- for l in 0 to L-1
    S_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

    B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_activation_trainer_architecture of ntm_activation_trainer is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    VECTOR_DIFFERENTIATION_A_STATE,     -- STEP 1
    VECTOR_DIFFERENTIATION_W_STATE,     -- STEP 2
    VECTOR_DIFFERENTIATION_K_STATE,     -- STEP 3
    VECTOR_DIFFERENTIATION_U_STATE,     -- STEP 4
    VECTOR_DIFFERENTIATION_B_STATE      -- STEP 5
    );

  type differentiation_a_ctrl_fsm is (
    STARTER_DA_STATE,                   -- STEP 0
    VECTOR_EXPONENTIATOR_DA_STATE,      -- STEP 1
    VECTOR_ADDER_DA_STATE,              -- STEP 2
    VECTOR_FIRST_MULTIPLIER_DA_STATE,   -- STEP 3
    VECTOR_SECOND_MULTIPLIER_DA_STATE   -- STEP 4
    );

  type differentiation_w_ctrl_fsm is (
    STARTER_DW_STATE,                   -- STEP 0
    VECTOR_DIFFERENTIATION_DW_STATE,    -- STEP 1
    MATRIX_PRODUCT_DW_STATE,            -- STEP 2
    VECTOR_SUMMATION_DW_STATE           -- STEP 3
    );

  type differentiation_k_ctrl_fsm is (
    STARTER_DK_STATE,                   -- STEP 0
    VECTOR_DIFFERENTIATION_DK_STATE,    -- STEP 1
    MATRIX_PRODUCT_DK_STATE,            -- STEP 2
    VECTOR_SUMMATION_DK_STATE           -- STEP 3
    );

  type differentiation_u_ctrl_fsm is (
    STARTER_DU_STATE,                   -- STEP 0
    VECTOR_DIFFERENTIATION_DU_STATE,    -- STEP 1
    MATRIX_PRODUCT_DU_STATE,            -- STEP 2
    VECTOR_SUMMATION_DU_STATE           -- STEP 3
    );

  type differentiation_b_ctrl_fsm is (
    STARTER_DB_STATE,                   -- STEP 0
    VECTOR_DIFFERENTIATION_DB_STATE,    -- STEP 1
    VECTOR_SUMMATION_DB_STATE           -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  signal differentiation_a_ctrl_fsm_int : differentiation_a_ctrl_fsm;
  signal differentiation_w_ctrl_fsm_int : differentiation_w_ctrl_fsm;
  signal differentiation_k_ctrl_fsm_int : differentiation_k_ctrl_fsm;
  signal differentiation_u_ctrl_fsm_int : differentiation_u_ctrl_fsm;
  signal differentiation_b_ctrl_fsm_int : differentiation_b_ctrl_fsm;

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

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_multiplier : std_logic;
  signal ready_vector_multiplier : std_logic;

  signal data_a_in_enable_vector_multiplier : std_logic;
  signal data_b_in_enable_vector_multiplier : std_logic;

  signal data_out_enable_vector_multiplier : std_logic;

  -- DATA
  signal modulo_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_multiplier   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal size_in_vector_adder   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_a_in_enable_vector_exponentiator : std_logic;
  signal data_b_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_enable_vector_differentiation : std_logic;

  signal data_out_enable_vector_differentiation : std_logic;

  -- DATA
  signal modulo_in_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

  -- dW(t;l) = summation(da(t;l) · x(t;x))[t in 0 to T]
  -- dK(t;l) = summation(da(t;l) · r(t;i;k))[t in 0 to T-1]
  -- dU(t;l) = summation(da(t+1;l) · h(t;l))[t in 0 to T-1]
  -- db(t;l) = summation(da(t;l))[t in 0 to T]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      W_OUT <= ZERO;
      K_OUT <= ZERO;
      U_OUT <= ZERO;
      B_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_DIFFERENTIATION_A_STATE;
          end if;

        when VECTOR_DIFFERENTIATION_A_STATE =>  -- STEP 1

          -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

          case differentiation_a_ctrl_fsm_int is
            when STARTER_DA_STATE =>    -- STEP 0

            when VECTOR_EXPONENTIATOR_DA_STATE =>  -- STEP 1

              -- Control Inputs
              data_a_in_enable_vector_exponentiator <= '0';
              data_b_in_enable_vector_exponentiator <= '0';

              -- Data Inputs
              modulo_in_vector_exponentiator <= FULL;
              size_in_vector_exponentiator   <= FULL;
              data_a_in_vector_exponentiator <= FULL;
              data_b_in_vector_exponentiator <= FULL;

            when VECTOR_ADDER_DA_STATE =>  -- STEP 2

              -- Control Inputs
              operation_vector_adder <= '0';

              data_a_in_enable_vector_adder <= '0';
              data_b_in_enable_vector_adder <= '0';

              -- Data Inputs
              modulo_in_vector_adder <= FULL;
              size_in_vector_adder   <= FULL;
              data_a_in_vector_adder <= FULL;
              data_b_in_vector_adder <= FULL;

            when VECTOR_FIRST_MULTIPLIER_DA_STATE =>  -- STEP 3

              -- Control Inputs
              data_a_in_enable_vector_multiplier <= '0';
              data_b_in_enable_vector_multiplier <= '0';

              -- Data Inputs
              modulo_in_vector_multiplier <= FULL;
              size_in_vector_multiplier   <= FULL;
              data_a_in_vector_multiplier <= FULL;
              data_b_in_vector_multiplier <= FULL;

            when VECTOR_SECOND_MULTIPLIER_DA_STATE =>  -- STEP 4

              -- Control Inputs
              data_a_in_enable_vector_multiplier <= '0';
              data_b_in_enable_vector_multiplier <= '0';

              -- Data Inputs
              modulo_in_vector_multiplier <= FULL;
              size_in_vector_multiplier   <= FULL;
              data_a_in_vector_multiplier <= FULL;
              data_b_in_vector_multiplier <= FULL;

            when others =>
              -- FSM Control
              differentiation_a_ctrl_fsm_int <= STARTER_DA_STATE;
          end case;

        when VECTOR_DIFFERENTIATION_W_STATE =>  -- STEP 1

          -- dW(t;l) = summation(da(t;l) · x(t;x))[t in 0 to T]

          case differentiation_w_ctrl_fsm_int is
            when STARTER_DW_STATE =>    -- STEP 0

            when VECTOR_DIFFERENTIATION_DW_STATE =>  -- STEP 1

              -- Control Inputs
              data_in_enable_vector_differentiation <= '0';

              -- Data Inputs
              modulo_in_vector_differentiation <= FULL;
              size_in_vector_differentiation   <= FULL;
              data_in_vector_differentiation   <= FULL;

            when MATRIX_PRODUCT_DW_STATE =>  -- STEP 2

              -- Control Inputs
              data_a_in_i_enable_matrix_product <= '0';
              data_a_in_j_enable_matrix_product <= '0';
              data_b_in_i_enable_matrix_product <= '0';
              data_b_in_j_enable_matrix_product <= '0';

              -- Data Inputs
              modulo_in_matrix_product   <= FULL;
              size_a_i_in_matrix_product <= FULL;
              size_a_j_in_matrix_product <= FULL;
              size_b_i_in_matrix_product <= FULL;
              size_b_j_in_matrix_product <= FULL;
              data_a_in_matrix_product   <= FULL;
              data_b_in_matrix_product   <= FULL;

            when VECTOR_SUMMATION_DW_STATE =>  -- STEP 3

              -- Control Inputs
              data_in_vector_enable_vector_summation <= '0';
              data_in_scalar_enable_vector_summation <= '0';

              -- Data Inputs
              modulo_in_vector_summation <= FULL;
              size_in_vector_summation   <= FULL;
              length_in_vector_summation <= FULL;
              data_in_vector_summation   <= FULL;

            when others =>
              -- FSM Control
              differentiation_w_ctrl_fsm_int <= STARTER_DW_STATE;
          end case;

        when VECTOR_DIFFERENTIATION_K_STATE =>  -- STEP 2

          -- dK(t;l) = summation(df(t;i;l) · r(t;i;k))[t in 0 to T-1]

          case differentiation_k_ctrl_fsm_int is
            when STARTER_DK_STATE =>    -- STEP 0

            when VECTOR_DIFFERENTIATION_DK_STATE =>  -- STEP 1

              -- Control Inputs
              data_in_enable_vector_differentiation <= '0';

              -- Data Inputs
              modulo_in_vector_differentiation <= FULL;
              size_in_vector_differentiation   <= FULL;
              data_in_vector_differentiation   <= FULL;

            when MATRIX_PRODUCT_DK_STATE =>  -- STEP 2

              -- Control Inputs
              data_a_in_i_enable_matrix_product <= '0';
              data_a_in_j_enable_matrix_product <= '0';
              data_b_in_i_enable_matrix_product <= '0';
              data_b_in_j_enable_matrix_product <= '0';

              -- Data Inputs
              modulo_in_matrix_product   <= FULL;
              size_a_i_in_matrix_product <= FULL;
              size_a_j_in_matrix_product <= FULL;
              size_b_i_in_matrix_product <= FULL;
              size_b_j_in_matrix_product <= FULL;
              data_a_in_matrix_product   <= FULL;
              data_b_in_matrix_product   <= FULL;

            when VECTOR_SUMMATION_DK_STATE =>  -- STEP 3

              -- Control Inputs
              data_in_vector_enable_vector_summation <= '0';
              data_in_scalar_enable_vector_summation <= '0';

              -- Data Inputs
              modulo_in_vector_summation <= FULL;
              size_in_vector_summation   <= FULL;
              length_in_vector_summation <= FULL;
              data_in_vector_summation   <= FULL;

            when others =>
              -- FSM Control
              differentiation_k_ctrl_fsm_int <= STARTER_DK_STATE;
          end case;

        when VECTOR_DIFFERENTIATION_U_STATE =>  -- STEP 3

          -- dU(t;l) = summation(da(t+1;l) · h(t;l))[t in 0 to T-1]

          case differentiation_u_ctrl_fsm_int is
            when STARTER_DU_STATE =>    -- STEP 0

            when VECTOR_DIFFERENTIATION_DU_STATE =>  -- STEP 1

              -- Control Inputs
              data_in_enable_vector_differentiation <= '0';

              -- Data Inputs
              modulo_in_vector_differentiation <= FULL;
              size_in_vector_differentiation   <= FULL;
              data_in_vector_differentiation   <= FULL;

            when MATRIX_PRODUCT_DU_STATE =>  -- STEP 2

              -- Control Inputs
              data_a_in_i_enable_matrix_product <= '0';
              data_a_in_j_enable_matrix_product <= '0';
              data_b_in_i_enable_matrix_product <= '0';
              data_b_in_j_enable_matrix_product <= '0';

              -- Data Inputs
              modulo_in_matrix_product   <= FULL;
              size_a_i_in_matrix_product <= FULL;
              size_a_j_in_matrix_product <= FULL;
              size_b_i_in_matrix_product <= FULL;
              size_b_j_in_matrix_product <= FULL;
              data_a_in_matrix_product   <= FULL;
              data_b_in_matrix_product   <= FULL;

            when VECTOR_SUMMATION_DU_STATE =>  -- STEP 3

              -- Control Inputs
              data_in_vector_enable_vector_summation <= '0';
              data_in_scalar_enable_vector_summation <= '0';

              -- Data Inputs
              modulo_in_vector_summation <= FULL;
              size_in_vector_summation   <= FULL;
              length_in_vector_summation <= FULL;
              data_in_vector_summation   <= FULL;

            when others =>
              -- FSM Control
              differentiation_u_ctrl_fsm_int <= STARTER_DU_STATE;
          end case;

        when VECTOR_DIFFERENTIATION_B_STATE =>  -- STEP 4

          -- db(t;l) = summation(da(t;l))[t in 0 to T]

          case differentiation_b_ctrl_fsm_int is
            when STARTER_DB_STATE =>    -- STEP 0

            when VECTOR_DIFFERENTIATION_DB_STATE =>  -- STEP 1

              -- Control Inputs
              data_in_enable_vector_differentiation <= '0';

              -- Data Inputs
              modulo_in_vector_differentiation <= FULL;
              size_in_vector_differentiation   <= FULL;
              data_in_vector_differentiation   <= FULL;

            when VECTOR_SUMMATION_DB_STATE =>  -- STEP 2

              -- Control Inputs
              data_in_vector_enable_vector_summation <= '0';
              data_in_scalar_enable_vector_summation <= '0';

              -- Data Inputs
              modulo_in_vector_summation <= FULL;
              size_in_vector_summation   <= FULL;
              length_in_vector_summation <= FULL;
              data_in_vector_summation   <= FULL;

            when others =>
              -- FSM Control
              differentiation_b_ctrl_fsm_int <= STARTER_DB_STATE;
          end case;

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

  -- VECTOR MULTIPLIER
  vector_multiplier : ntm_vector_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplier,
      READY => ready_vector_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_multiplier,

      -- DATA
      MODULO_IN => modulo_in_vector_multiplier,
      SIZE_IN   => size_in_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
      );

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE => DATA_SIZE
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

  -- VECTOR EXPONENTIATOR
  vector_exponentiator : ntm_vector_exponentiator
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_exponentiator,
      READY => ready_vector_exponentiator,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_exponentiator,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_exponentiator,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      MODULO_IN => modulo_in_vector_exponentiator,
      SIZE_IN   => size_in_vector_exponentiator,
      DATA_A_IN => data_a_in_vector_exponentiator,
      DATA_B_IN => data_b_in_vector_exponentiator,
      DATA_OUT  => data_out_vector_exponentiator
      );

  -- VECTOR DIFFERENTIATION
  vector_differentiation_function : ntm_vector_differentiation_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_differentiation,
      READY => ready_vector_differentiation,

      DATA_IN_ENABLE => data_in_enable_vector_differentiation,

      DATA_OUT_ENABLE => data_out_enable_vector_differentiation,

      -- DATA
      MODULO_IN => modulo_in_vector_differentiation,
      SIZE_IN   => size_in_vector_differentiation,
      DATA_IN   => data_in_vector_differentiation,
      DATA_OUT  => data_out_vector_differentiation
      );

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

end architecture;
