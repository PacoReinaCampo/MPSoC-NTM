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
use work.dnc_core_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity dnc_write_interface_vector is
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

    -- Write Key
    WK_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WK_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    K_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Write Strength
    WBETA_IN_ENABLE : in std_logic;     -- for l in 0 to L-1

    -- Erase Vector
    WE_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WE_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    E_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Write Vector
    WV_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WV_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    V_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    -- Allocation Gate
    WGA_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

    -- Write Gate
    WGW_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

    -- Hidden State
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    -- DATA
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

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

  type controller_ctrl_fsm is (
    STARTER_STATE,  -- STEP 0
    MATRIX_FIRST_PRODUCT_STATE,  -- STEP 1
    MATRIX_SECOND_PRODUCT_STATE,  -- STEP 2
    MATRIX_THIRD_PRODUCT_STATE,  -- STEP 3
    SCALAR_FIRST_PRODUCT_STATE,  -- STEP 4
    SCALAR_SECOND_PRODUCT_STATE,  -- STEP 5
    SCALAR_THIRD_PRODUCT_STATE,  -- STEP 6
    ENDER_STATE  -- STEP 7
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

  -- SCALAR PRODUCT
  -- CONTROL
  signal start_scalar_product : std_logic;
  signal ready_scalar_product : std_logic;

  signal data_a_in_enable_scalar_product : std_logic;
  signal data_b_in_enable_scalar_product : std_logic;

  signal data_out_enable_scalar_product : std_logic;

  -- DATA
  signal modulo_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product  : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- xi(t;?) = U(t;?;l)·h(t;l)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      K_OUT    <= ZERO;
      BETA_OUT <= ZERO;
      E_OUT    <= ZERO;
      V_OUT    <= ZERO;
      GA_OUT   <= ZERO;
      GW_OUT   <= ZERO;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_PRODUCT_STATE;
          end if;

        when MATRIX_FIRST_PRODUCT_STATE =>  -- STEP 1

          -- Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= WK_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          K_OUT <= data_out_matrix_product;

        when MATRIX_SECOND_PRODUCT_STATE =>  -- STEP 2

          -- Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= WE_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          E_OUT <= data_out_matrix_product;

        when MATRIX_THIRD_PRODUCT_STATE =>  -- STEP 3

          -- Data Inputs
          modulo_in_matrix_product   <= FULL;
          size_a_i_in_matrix_product <= SIZE_W_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE;
          data_a_in_matrix_product   <= WV_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          V_OUT <= data_out_matrix_product;

        when SCALAR_FIRST_PRODUCT_STATE =>  -- STEP 4

          -- Data Inputs
          modulo_in_scalar_product <= FULL;
          length_in_scalar_product <= SIZE_L_IN;
          data_a_in_scalar_product <= WBETA_IN;
          data_b_in_scalar_product <= H_IN;

          -- Data Outputs
          BETA_OUT <= data_out_scalar_product;

        when SCALAR_SECOND_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          modulo_in_scalar_product <= FULL;
          length_in_scalar_product <= SIZE_L_IN;
          data_a_in_scalar_product <= WGA_IN;
          data_b_in_scalar_product <= H_IN;

          -- Data Outputs
          GA_OUT <= data_out_scalar_product;

        when SCALAR_THIRD_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          modulo_in_scalar_product <= FULL;
          length_in_scalar_product <= SIZE_L_IN;
          data_a_in_scalar_product <= WGW_IN;
          data_b_in_scalar_product <= H_IN;

          -- Data Outputs
          GW_OUT <= data_out_scalar_product;

        when ENDER_STATE =>  -- STEP 7

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR PRODUCT
  scalar_product : ntm_scalar_product
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product,
      READY => ready_scalar_product,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product,

      DATA_OUT_ENABLE => data_out_enable_scalar_product,

      -- DATA
      MODULO_IN => modulo_in_scalar_product,
      LENGTH_IN => length_in_scalar_product,
      DATA_A_IN => data_a_in_scalar_product,
      DATA_B_IN => data_b_in_scalar_product,
      DATA_OUT  => data_out_scalar_product
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
