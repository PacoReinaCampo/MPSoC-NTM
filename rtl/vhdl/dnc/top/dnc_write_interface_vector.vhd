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
use work.dnc_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity dnc_write_interface_vector is
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

    -- Write Key
    WK_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WK_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    WK_OUT_L_ENABLE : out std_logic;    -- for l in 0 to L-1
    WK_OUT_K_ENABLE : out std_logic;    -- for k in 0 to W-1

    K_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Write Strength
    WBETA_IN_ENABLE : in std_logic;     -- for l in 0 to L-1

    WBETA_OUT_ENABLE : out std_logic;   -- for l in 0 to L-1

    -- Erase Vector
    WE_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WE_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    WE_OUT_L_ENABLE : out std_logic;    -- for l in 0 to L-1
    WE_OUT_K_ENABLE : out std_logic;    -- for k in 0 to W-1

    E_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Write Vector
    WV_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WV_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    WV_OUT_L_ENABLE : out std_logic;    -- for l in 0 to L-1
    WV_OUT_K_ENABLE : out std_logic;    -- for k in 0 to W-1

    V_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Allocation Gate
    WGA_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

    WGA_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- Write Gate
    WGW_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

    WGW_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- Hidden State
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    WK_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WBETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    WE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WV_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WGA_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    WGW_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    E_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    V_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    GA_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0);
    GW_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_write_interface_vector_architecture of dnc_write_interface_vector is

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
    MATRIX_I_FIRST_PRODUCT_STATE,       -- STEP 3
    MATRIX_J_FIRST_PRODUCT_STATE,       -- STEP 4
    INPUT_I_SECOND_STATE,               -- STEP 5
    INPUT_J_SECOND_STATE,               -- STEP 6
    MATRIX_I_SECOND_PRODUCT_STATE,      -- STEP 7
    MATRIX_J_SECOND_PRODUCT_STATE,      -- STEP 8
    INPUT_I_THIRD_STATE,                -- STEP 9
    INPUT_J_THIRD_STATE,                -- STEP 10
    MATRIX_I_THIRD_PRODUCT_STATE,       -- STEP 11
    MATRIX_J_THIRD_PRODUCT_STATE        -- STEP 12
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
  signal length_in_dot_product : std_logic_vector(DATA_SIZE-1 downto 0);
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
      BETA_OUT <= ZERO_DATA;
      GA_OUT   <= ZERO_DATA;
      GW_OUT   <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_scalar_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            controller_ctrl_scalar_fsm_int <= SCALAR_FIRST_PRODUCT_STATE;
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

          -- ga(t) = Wga(t;l)·h(t;l)

          -- Control Inputs
          data_a_in_enable_dot_product <= WGA_IN_ENABLE;
          data_b_in_enable_dot_product <= H_IN_ENABLE;

          -- Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WGA_IN;
          data_b_in_dot_product <= H_IN;

          -- Data Outputs
          GA_OUT <= data_out_dot_product;

        when SCALAR_THIRD_PRODUCT_STATE =>  -- STEP 3

          -- gw(t) = Wgw(t;l)·h(t;l)

          -- Control Inputs
          data_a_in_enable_dot_product <= WGW_IN_ENABLE;
          data_b_in_enable_dot_product <= H_IN_ENABLE;

          -- Data Inputs
          length_in_dot_product <= SIZE_L_IN;
          data_a_in_dot_product <= WGW_IN;
          data_b_in_dot_product <= H_IN;

          -- Data Outputs
          GW_OUT <= data_out_dot_product;

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
      E_OUT <= ZERO_DATA;
      V_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_matrix_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_matrix_fsm_int <= INPUT_I_FIRST_STATE;
          else
            -- Control Internal
            start_matrix_product <= '0';
          end if;

        when INPUT_I_FIRST_STATE =>     -- STEP 1

        when INPUT_J_FIRST_STATE =>     -- STEP 2

        when MATRIX_I_FIRST_PRODUCT_STATE =>  -- STEP 3

        when MATRIX_J_FIRST_PRODUCT_STATE =>  -- STEP 4

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

        when MATRIX_I_SECOND_PRODUCT_STATE =>  -- STEP 7

        when MATRIX_J_SECOND_PRODUCT_STATE =>  -- STEP 8

          -- e(t;k) = We(t;l;k)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WE_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= WE_IN_K_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WE_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          E_OUT <= data_out_matrix_product;

        when INPUT_I_THIRD_STATE =>     -- STEP 9

        when INPUT_J_THIRD_STATE =>     -- STEP 10

        when MATRIX_I_THIRD_PRODUCT_STATE =>  -- STEP 11

        when MATRIX_J_THIRD_PRODUCT_STATE =>  -- STEP 12

          -- v(t;k) = Wv(t;l;k)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WV_IN_L_ENABLE;
          data_a_in_j_enable_matrix_product <= WV_IN_K_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WV_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          V_OUT <= data_out_matrix_product;

        when others =>
          -- FSM Control
          controller_ctrl_matrix_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR PRODUCT
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
