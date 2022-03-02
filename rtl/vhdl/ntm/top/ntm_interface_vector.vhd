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

entity ntm_interface_vector is
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

    -- Key Vector
    WK_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WK_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    WK_OUT_L_ENABLE : out std_logic;    -- for l in 0 to L-1
    WK_OUT_K_ENABLE : out std_logic;    -- for k in 0 to W-1

    K_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Key Strength
    WBETA_IN_ENABLE : in std_logic;     -- for l in 0 to L-1

    WBETA_OUT_ENABLE : out std_logic;   -- for l in 0 to L-1

    -- Interpolation Gate
    WG_IN_ENABLE : in std_logic;        -- for l in 0 to L-1

    WG_OUT_ENABLE : out std_logic;      -- for l in 0 to L-1

    -- Shift Weighting
    WS_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WS_IN_J_ENABLE : in std_logic;      -- for j in 0 to N-1

    WS_OUT_L_ENABLE : out std_logic;    -- for l in 0 to L-1
    WS_OUT_J_ENABLE : out std_logic;    -- for j in 0 to N-1

    S_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- Sharpening
    WGAMMA_IN_ENABLE : in std_logic;    -- for l in 0 to L-1

    WGAMMA_OUT_ENABLE : out std_logic;  -- for l in 0 to L-1

    -- Hidden State
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    WK_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    WBETA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    WG_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    WS_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    WGAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);
    G_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    S_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    GAMMA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_interface_vector_architecture of ntm_interface_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_scalar_fsm is (
    STARTER_STATE,                      -- STEP 0
    SCALAR_FIRST_PRODUCT_STATE,         -- STEP 1
    SCALAR_SECOND_PRODUCT_STATE,        -- STEP 2
    SCALAR_THIRD_PRODUCT_STATE          -- STEP 3
    );

  type controller_ctrl_matrix_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_FIRST_STATE,                -- STEP 1
    INPUT_J_FIRST_STATE,                -- STEP 2
    MATRIX_FIRST_PRODUCT_I_STATE,       -- STEP 3
    MATRIX_FIRST_PRODUCT_j_STATE,       -- STEP 4
    INPUT_I_SECOND_STATE,               -- STEP 5
    INPUT_J_SECOND_STATE,               -- STEP 6
    MATRIX_SECOND_PRODUCT_I_STATE,      -- STEP 7
    MATRIX_SECOND_PRODUCT_J_STATE       -- STEP 8
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_scalar_fsm_int : controller_ctrl_scalar_fsm;
  signal controller_ctrl_matrix_fsm_int : controller_ctrl_matrix_fsm;

  -- SCALAR PRODUCT
  -- CONTROL
  signal start_dot_product : std_logic;
  signal ready_dot_product : std_logic;

  signal data_a_in_enable_dot_product : std_logic;
  signal data_b_in_enable_dot_product : std_logic;

  signal data_out_enable_dot_product : std_logic;

  -- DATA
  signal length_in_dot_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_dot_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_dot_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_dot_product  : std_logic_vector(DATA_SIZE-1 downto 0);

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- xi(t;?) = U(t;?;l)·h(t;l)

  -- CONTROL
  ctrl_scalar_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      BETA_OUT  <= ZERO_DATA;
      G_OUT     <= ZERO_DATA;
      GAMMA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_scalar_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_dot_product <= '1';

            -- FSM Control
            controller_ctrl_scalar_fsm_int <= SCALAR_FIRST_PRODUCT_STATE;
          else
            -- Control Internal
            start_dot_product <= '0';
          end if;

        when SCALAR_FIRST_PRODUCT_STATE =>  -- STEP 1

          -- beta(t) = Wbeta(t;l)·h(t;l)

          -- Control Inputs
          data_a_in_enable_dot_product <= WBETA_IN_ENABLE;
          data_b_in_enable_dot_product <= H_IN_ENABLE;

          -- Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WBETA_IN;
          data_b_in_dot_product <= H_IN;

          -- Data Outputs
          BETA_OUT <= data_out_dot_product;

        when SCALAR_SECOND_PRODUCT_STATE =>  -- STEP 2

          -- g(t) = Wg(t;l)·h(t;l)

          -- Control Inputs
          data_a_in_enable_dot_product <= WG_IN_ENABLE;
          data_b_in_enable_dot_product <= H_IN_ENABLE;

          -- Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WG_IN;
          data_b_in_dot_product <= H_IN;

          -- Data Outputs
          G_OUT <= data_out_dot_product;

        when SCALAR_THIRD_PRODUCT_STATE =>  -- STEP 3

          -- gamma(t) = Wgamma(t;l)·h(t;l)

          -- Control Inputs
          data_a_in_enable_dot_product <= WGAMMA_IN_ENABLE;
          data_b_in_enable_dot_product <= H_IN_ENABLE;

          -- Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WGAMMA_IN;
          data_b_in_dot_product <= H_IN;

          -- Data Outputs
          GAMMA_OUT <= data_out_dot_product;

        when others =>
          -- FSM Control
          controller_ctrl_scalar_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  ctrl_matrix_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      K_OUT <= ZERO_DATA;
      S_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_matrix_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            controller_ctrl_matrix_fsm_int <= INPUT_I_FIRST_STATE;
          end if;

        when INPUT_I_FIRST_STATE =>     -- STEP 1

        when INPUT_J_FIRST_STATE =>     -- STEP 2

        when MATRIX_FIRST_PRODUCT_I_STATE =>  -- STEP 3

        when MATRIX_FIRST_PRODUCT_J_STATE =>  -- STEP 4

          -- k(t;k) = Wk(t;l;k)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WK_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= WK_IN_K_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WK_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          K_OUT <= data_out_matrix_product;

        when INPUT_I_SECOND_STATE =>    -- STEP 5

        when INPUT_J_SECOND_STATE =>    -- STEP 6

        when MATRIX_SECOND_PRODUCT_I_STATE =>  -- STEP 7

        when MATRIX_SECOND_PRODUCT_J_STATE =>  -- STEP 8

          -- s(t;j) = Wk(t;l;j)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WS_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= WS_IN_J_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_N_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WS_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          S_OUT <= data_out_matrix_product;

        when others =>
          -- FSM Control
          controller_ctrl_matrix_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- DOT PRODUCT
  dot_product : ntm_dot_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_dot_product,
      READY => ready_dot_product,

      DATA_A_IN_ENABLE => data_a_in_enable_dot_product,
      DATA_B_IN_ENABLE => data_b_in_enable_dot_product,

      DATA_OUT_ENABLE => data_out_enable_dot_product,

      -- DATA
      LENGTH_IN => length_in_dot_product,
      DATA_A_IN => data_a_in_dot_product,
      DATA_B_IN => data_b_in_dot_product,
      DATA_OUT  => data_out_dot_product
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

end architecture;
