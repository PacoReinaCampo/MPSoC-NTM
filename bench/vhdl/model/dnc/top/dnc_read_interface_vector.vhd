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

entity dnc_read_interface_vector is
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

    -- Read Key
    WK_IN_I_ENABLE : in std_logic;      -- for i in 0 to R-1
    WK_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1
    WK_IN_K_ENABLE : in std_logic;      -- for k in 0 to W-1

    WK_OUT_I_ENABLE : in std_logic;     -- for i in 0 to R-1
    WK_OUT_L_ENABLE : in std_logic;     -- for l in 0 to L-1
    WK_OUT_K_ENABLE : in std_logic;     -- for k in 0 to W-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- Read Strength
    WBETA_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1
    WBETA_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1

    WBETA_OUT_I_ENABLE : in std_logic;  -- for i in 0 to R-1
    WBETA_OUT_L_ENABLE : in std_logic;  -- for l in 0 to L-1

    BETA_OUT_ENABLE : out std_logic;    -- for i in 0 to R-1

    -- Free Gate
    WF_IN_I_ENABLE : in std_logic;      -- for i in 0 to R-1
    WF_IN_L_ENABLE : in std_logic;      -- for l in 0 to L-1

    WF_OUT_I_ENABLE : in std_logic;     -- for i in 0 to R-1
    WF_OUT_L_ENABLE : in std_logic;     -- for l in 0 to L-1

    F_OUT_ENABLE : out std_logic;       -- for i in 0 to R-1

    -- Read Mode
    WPI_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
    WPI_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

    WPI_OUT_I_ENABLE : in std_logic;    -- for i in 0 to R-1
    WPI_OUT_L_ENABLE : in std_logic;    -- for l in 0 to L-1

    PI_OUT_ENABLE : out std_logic;      -- for i in 0 to R-1

    -- Hidden State
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    WK_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WBETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    WF_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    WPI_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    F_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    PI_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_read_interface_vector_architecture of dnc_read_interface_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
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

  -- TENSOR PRODUCT
  -- CONTROL
  signal start_tensor_product : std_logic;
  signal ready_tensor_product : std_logic;

  signal data_a_in_i_enable_tensor_product : std_logic;
  signal data_a_in_j_enable_tensor_product : std_logic;
  signal data_a_in_k_enable_tensor_product : std_logic;
  signal data_b_in_i_enable_tensor_product : std_logic;
  signal data_b_in_j_enable_tensor_product : std_logic;
  signal data_b_in_k_enable_tensor_product : std_logic;

  signal data_out_i_enable_tensor_product : std_logic;
  signal data_out_j_enable_tensor_product : std_logic;
  signal data_out_k_enable_tensor_product : std_logic;

  -- DATA
  signal size_a_i_in_tensor_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_j_in_tensor_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_k_in_tensor_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_i_in_tensorproduct  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_j_in_tensor_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_k_in_tensor_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_tensor_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_product    : std_logic_vector(DATA_SIZE-1 downto 0);

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
      BETA_OUT <= ZERO_DATA;
      F_OUT    <= ZERO_DATA;
      PI_OUT   <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_matrix_product <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_I_FIRST_STATE;
          else
            -- Control Internal
            start_matrix_product <= '0';
          end if;

        when INPUT_I_FIRST_STATE =>  -- STEP 1

        when INPUT_J_FIRST_STATE =>  -- STEP 2

        when MATRIX_I_FIRST_PRODUCT_STATE =>  -- STEP 3

        when MATRIX_J_FIRST_PRODUCT_STATE =>  -- STEP 4

          -- beta(t;i) = Wbeta(t;i;l)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WBETA_IN_I_ENABLE;
          data_a_in_j_enable_matrix_product <= WBETA_IN_L_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_R_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WBETA_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          BETA_OUT <= data_out_matrix_product;

        when INPUT_I_SECOND_STATE =>  -- STEP 5

        when INPUT_J_SECOND_STATE =>  -- STEP 6

        when MATRIX_I_SECOND_PRODUCT_STATE =>  -- STEP 7

        when MATRIX_J_SECOND_PRODUCT_STATE =>  -- STEP 8

          -- f(t;i) = Wf(t;i;l)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WF_IN_I_ENABLE;
          data_a_in_j_enable_matrix_product <= WF_IN_L_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_R_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WF_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          F_OUT <= data_out_matrix_product;

        when INPUT_I_THIRD_STATE =>  -- STEP 9

        when INPUT_J_THIRD_STATE =>  -- STEP 10

        when MATRIX_I_THIRD_PRODUCT_STATE =>  -- STEP 11

        when MATRIX_J_THIRD_PRODUCT_STATE =>  -- STEP 12

          -- pi(t;i) = Wpi(t;i;l)·h(t;l)

          -- Control Inputs
          data_a_in_i_enable_matrix_product <= WPI_IN_I_ENABLE;
          data_a_in_j_enable_matrix_product <= WPI_IN_L_ENABLE;
          data_b_in_i_enable_matrix_product <= H_IN_ENABLE;
          data_b_in_j_enable_matrix_product <= '0';

          -- Data Inputs
          size_a_i_in_matrix_product <= SIZE_R_IN;
          size_a_j_in_matrix_product <= SIZE_L_IN;
          size_b_i_in_matrix_product <= SIZE_L_IN;
          size_b_j_in_matrix_product <= ONE_DATA;
          data_a_in_matrix_product   <= WPI_IN;
          data_b_in_matrix_product   <= H_IN;

          -- Data Outputs
          PI_OUT <= data_out_matrix_product;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- DATA
  -- TENSOR PRODUCT
  size_a_i_in_tensor_product <= SIZE_R_IN;
  size_a_j_in_tensor_product <= SIZE_L_IN;
  size_a_k_in_tensor_product <= SIZE_W_IN;
  size_b_i_in_tensorproduct  <= ONE_DATA;
  size_b_j_in_tensor_product <= SIZE_L_IN;
  size_b_k_in_tensor_product <= ONE_DATA;
  data_a_in_tensor_product   <= WK_IN;
  data_b_in_tensor_product   <= H_IN;

  K_OUT <= data_out_tensor_product;

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

  -- TENSOR PRODUCT
  tensor_product : ntm_tensor_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_tensor_product,
      READY => ready_tensor_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_product,
      DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_product,
      DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_tensor_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_tensor_product,
      DATA_OUT_K_ENABLE => data_out_k_enable_tensor_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_tensor_product,
      SIZE_A_J_IN => size_a_j_in_tensor_product,
      SIZE_A_K_IN => size_a_k_in_tensor_product,
      SIZE_B_I_IN => size_b_i_in_tensorproduct,
      SIZE_B_J_IN => size_b_j_in_tensor_product,
      SIZE_B_K_IN => size_b_k_in_tensor_product,
      DATA_A_IN   => data_a_in_tensor_product,
      DATA_B_IN   => data_b_in_tensor_product,
      DATA_OUT    => data_out_tensor_product
      );

end architecture;
