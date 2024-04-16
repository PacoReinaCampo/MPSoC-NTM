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

use work.accelerator_arithmetic_vhdl_pkg.all;
use work.accelerator_math_vhdl_pkg.all;
use work.accelerator_core_vhdl_pkg.all;

entity accelerator_addressing is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    BETA_IN_ENABLE : in std_logic;      -- for i in 0 to R-1

    G_IN_ENABLE : in std_logic;         -- for i in 0 to R-1

    S_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    S_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    GAMMA_IN_ENABLE : in std_logic;     -- for i in 0 to R-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    BETA_OUT_ENABLE : out std_logic;    -- for i in 0 to R-1

    G_OUT_ENABLE : out std_logic;       -- for i in 0 to R-1

    S_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    S_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    GAMMA_OUT_ENABLE : out std_logic;   -- for i in 0 to R-1

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    G_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    S_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    GAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_addressing_architecture of accelerator_addressing is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- K_IN [R,W]
  -- BETA_IN [R]
  -- G_IN [R]
  -- S_IN [R,N]
  -- GAMMA_IN [R]

  -- Outputs:
  -- W_OUT [R,N]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_K_STATE,                 -- STEP 2
    CLEAN_K_IN_I_STATE,                 -- STEP 3
    CLEAN_K_IN_K_STATE                  -- STEP 4
    );

  type controller_beta_in_fsm is (
    STARTER_BETA_IN_STATE,              -- STEP 0
    INPUT_BETA_IN_I_STATE,              -- STEP 1
    CLEAN_BETA_IN_I_STATE               -- STEP 3
    );

  type controller_g_in_fsm is (
    STARTER_G_IN_STATE,                 -- STEP 0
    INPUT_G_IN_I_STATE,                 -- STEP 1
    CLEAN_G_IN_I_STATE                  -- STEP 3
    );

  type controller_s_in_fsm is (
    STARTER_S_IN_STATE,                 -- STEP 0
    INPUT_S_IN_I_STATE,                 -- STEP 1
    INPUT_S_IN_J_STATE,                 -- STEP 2
    CLEAN_S_IN_I_STATE,                 -- STEP 3
    CLEAN_S_IN_J_STATE                  -- STEP 4
    );

  type controller_gamma_in_fsm is (
    STARTER_GAMMA_IN_STATE,             -- STEP 0
    INPUT_GAMMA_IN_I_STATE,             -- STEP 1
    CLEAN_GAMMA_IN_I_STATE              -- STEP 3
    );

  type controller_m_in_fsm is (
    STARTER_M_IN_STATE,                 -- STEP 0
    INPUT_M_IN_J_STATE,                 -- STEP 1
    INPUT_M_IN_K_STATE,                 -- STEP 2
    CLEAN_M_IN_J_STATE,                 -- STEP 3
    CLEAN_M_IN_K_STATE                  -- STEP 4
    );

  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_I_STATE,                 -- STEP 1
    INPUT_W_IN_J_STATE,                 -- STEP 2
    CLEAN_W_IN_I_STATE,                 -- STEP 3
    CLEAN_W_IN_J_STATE                  -- STEP 4
    );

  type controller_w_out_fsm is (
    STARTER_W_OUT_STATE,                -- STEP 0
    CLEAN_W_OUT_I_STATE,                -- STEP 1
    CLEAN_W_OUT_K_STATE,                -- STEP 2
    OUTPUT_W_OUT_I_STATE,               -- STEP 3
    OUTPUT_W_OUT_K_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_k_in_fsm_int     : controller_k_in_fsm;
  signal controller_beta_in_fsm_int  : controller_beta_in_fsm;
  signal controller_g_in_fsm_int     : controller_g_in_fsm;
  signal controller_s_in_fsm_int     : controller_s_in_fsm;
  signal controller_gamma_in_fsm_int : controller_gamma_in_fsm;

  signal controller_m_in_fsm_int : controller_m_in_fsm;
  signal controller_w_in_fsm_int : controller_w_in_fsm;

  signal controller_w_out_fsm_int : controller_w_out_fsm;

  -- Buffer
  signal matrix_k_in_int     : matrix_buffer;
  signal vector_beta_in_int  : vector_buffer;
  signal vector_g_in_int     : vector_buffer;
  signal matrix_s_in_int     : matrix_buffer;
  signal vector_gamma_in_int : vector_buffer;

  signal matrix_m_in_int : matrix_buffer;
  signal matrix_w_in_int : matrix_buffer;

  signal matrix_w_out_int : matrix_buffer;

  -- Control Internal
  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_beta_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_g_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_s_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_s_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_gamma_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_k_in_enable_int     : std_logic;
  signal data_beta_in_enable_int  : std_logic;
  signal data_g_in_enable_int     : std_logic;
  signal data_s_in_enable_int     : std_logic;
  signal data_gamma_in_enable_int : std_logic;

  signal data_m_in_enable_int : std_logic;
  signal data_w_in_enable_int : std_logic;

  -- VECTOR CONTENT BASED ADDRESSING
  -- CONTROL
  signal start_vector_content_based_addressing : std_logic;
  signal ready_vector_content_based_addressing : std_logic;

  signal k_in_enable_vector_content_based_addressing : std_logic;

  signal k_out_enable_vector_content_based_addressing : std_logic;

  signal m_in_i_enable_vector_content_based_addressing : std_logic;
  signal m_in_j_enable_vector_content_based_addressing : std_logic;

  signal m_out_i_enable_vector_content_based_addressing : std_logic;
  signal m_out_j_enable_vector_content_based_addressing : std_logic;

  signal c_out_enable_vector_content_based_addressing : std_logic;

  -- DATA
  signal size_i_in_vector_content_based_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_vector_content_based_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal k_in_vector_content_based_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_vector_content_based_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_vector_content_based_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_vector_content_based_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX FLOAT ADDER
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
  signal overflow_out_matrix_float_adder : std_logic;

  -- MATRIX FLOAT MULTIPLIER
  -- CONTROL
  signal start_matrix_float_multiplier : std_logic;
  signal ready_matrix_float_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_float_multiplier : std_logic;

  signal data_out_i_enable_matrix_float_multiplier : std_logic;
  signal data_out_j_enable_matrix_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_multiplier : std_logic;

  -- MATRIX FLOAT DIVIDER
  -- CONTROL
  signal start_matrix_float_divider : std_logic;
  signal ready_matrix_float_divider : std_logic;

  signal data_a_in_i_enable_matrix_float_divider : std_logic;
  signal data_a_in_j_enable_matrix_float_divider : std_logic;
  signal data_b_in_i_enable_matrix_float_divider : std_logic;
  signal data_b_in_j_enable_matrix_float_divider : std_logic;

  signal data_out_i_enable_matrix_float_divider : std_logic;
  signal data_out_j_enable_matrix_float_divider : std_logic;

  -- DATA
  signal size_i_in_matrix_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_divider : std_logic;

  -- MATRIX POWER
  -- CONTROL
  signal start_matrix_power_function : std_logic;
  signal ready_matrix_power_function : std_logic;

  signal data_a_in_i_enable_matrix_power_function : std_logic;
  signal data_a_in_j_enable_matrix_power_function : std_logic;
  signal data_b_in_i_enable_matrix_power_function : std_logic;
  signal data_b_in_j_enable_matrix_power_function : std_logic;

  signal data_out_i_enable_matrix_power_function : std_logic;
  signal data_out_j_enable_matrix_power_function : std_logic;

  -- DATA
  signal size_i_in_matrix_power_function : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_power_function : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_power_function : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_power_function : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_power_function  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TRANSPOSE VECTOR PRODUCT
  -- CONTROL
  signal start_transpose_vector_product : std_logic;
  signal ready_transpose_vector_product : std_logic;

  signal data_a_in_enable_transpose_vector_product : std_logic;
  signal data_b_in_enable_transpose_vector_product : std_logic;

  signal data_enable_transpose_vector_product : std_logic;

  signal data_out_i_enable_transpose_vector_product : std_logic;
  signal data_out_j_enable_transpose_vector_product : std_logic;

  -- DATA
  signal size_a_in_transpose_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_transpose_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_transpose_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_transpose_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_transpose_vector_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR CONVOLUTION
  -- CONTROL
  signal start_vector_convolution : std_logic;
  signal ready_vector_convolution : std_logic;

  signal data_a_in_enable_vector_convolution : std_logic;
  signal data_b_in_enable_vector_convolution : std_logic;

  signal data_out_enable_vector_convolution : std_logic;

  -- DATA
  signal length_in_vector_convolution : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_enable_length_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_enable_length_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- wc(t;i;j) = C(M(t;j;k),k(t;i;k),beta(t;i))

  -- wg(t;i;j) = g(t;i)·wc(t;i;j) + (1 - g(t;i))·w(t-1;i;j)

  -- w(t;i;j) = wg(t;i;j)*s(t;i;j)

  -- w(t;i;j) = exponentiation(w(t;i;j),gamma(t;i)) / summation(exponentiation(w(t;i;j),gamma(t;i)))[j in 0 to N-1]

  -- CONTROL
  k_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      K_OUT_I_ENABLE <= '0';
      K_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_k_in_loop <= ZERO_CONTROL;
      index_k_k_in_loop <= ZERO_CONTROL;

      data_k_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_in_fsm_int is
        when STARTER_K_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '0';

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          else
            -- Control Outputs
            K_OUT_I_ENABLE <= '0';
            K_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_K_IN_I_STATE =>      -- STEP 1

          if ((K_IN_I_ENABLE = '1') and (K_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            controller_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
          end if;

          -- Control Outputs
          K_OUT_I_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

        when INPUT_K_IN_K_STATE =>      -- STEP 2

          if (K_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_k_k_in_loop))) <= K_IN;

            -- FSM Control
            if (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          K_OUT_K_ENABLE <= '0';

        when CLEAN_K_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_k_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_k_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '1';

            -- FSM Control
            controller_k_in_fsm_int <= STARTER_K_IN_STATE;
          elsif ((unsigned(index_i_k_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= std_logic_vector(unsigned(index_i_k_in_loop) + unsigned(ONE_CONTROL));
            index_k_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          end if;

        when CLEAN_K_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_k_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_in_loop <= std_logic_vector(unsigned(index_k_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_in_fsm_int <= STARTER_K_IN_STATE;
      end case;
    end if;
  end process;

  beta_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      BETA_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_beta_in_loop <= ZERO_CONTROL;

      data_beta_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_beta_in_fsm_int is
        when STARTER_BETA_IN_STATE =>   -- STEP 0
          if (START = '1') then
            -- Control Outputs
            BETA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_beta_in_loop <= ZERO_CONTROL;

            data_beta_in_enable_int <= '0';

            -- FSM Control
            controller_beta_in_fsm_int <= INPUT_BETA_IN_I_STATE;
          else
            -- Control Outputs
            BETA_OUT_ENABLE <= '0';
          end if;

        when INPUT_BETA_IN_I_STATE =>   -- STEP 1

          if (BETA_IN_ENABLE = '1') then
            -- Data Inputs
            vector_beta_in_int(to_integer(unsigned(index_i_beta_in_loop))) <= BETA_IN;

            -- FSM Control
            controller_beta_in_fsm_int <= CLEAN_BETA_IN_I_STATE;
          end if;

          -- Control Outputs
          BETA_OUT_ENABLE <= '0';

        when CLEAN_BETA_IN_I_STATE =>   -- STEP 2

          if (unsigned(index_i_beta_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            BETA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_beta_in_loop <= ZERO_CONTROL;

            data_beta_in_enable_int <= '1';

            -- FSM Control
            controller_beta_in_fsm_int <= STARTER_BETA_IN_STATE;
          elsif (unsigned(index_i_beta_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            BETA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_beta_in_loop <= std_logic_vector(unsigned(index_i_beta_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_beta_in_fsm_int <= INPUT_BETA_IN_I_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_beta_in_fsm_int <= STARTER_BETA_IN_STATE;
      end case;
    end if;
  end process;

  g_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      G_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_g_in_loop <= ZERO_CONTROL;

      data_g_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_g_in_fsm_int is
        when STARTER_G_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            G_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_g_in_loop <= ZERO_CONTROL;

            data_g_in_enable_int <= '0';

            -- FSM Control
            controller_g_in_fsm_int <= INPUT_G_IN_I_STATE;
          else
            -- Control Outputs
            G_OUT_ENABLE <= '0';
          end if;

        when INPUT_G_IN_I_STATE =>      -- STEP 1

          if (G_IN_ENABLE = '1') then
            -- Data Inputs
            vector_g_in_int(to_integer(unsigned(index_i_g_in_loop))) <= G_IN;

            -- FSM Control
            controller_g_in_fsm_int <= CLEAN_G_IN_I_STATE;
          end if;

          -- Control Outputs
          G_OUT_ENABLE <= '0';

        when CLEAN_G_IN_I_STATE =>      -- STEP 2

          if (unsigned(index_i_g_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            G_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_g_in_loop <= ZERO_CONTROL;

            data_g_in_enable_int <= '1';

            -- FSM Control
            controller_g_in_fsm_int <= STARTER_G_IN_STATE;
          elsif (unsigned(index_i_g_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            G_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_g_in_loop <= std_logic_vector(unsigned(index_i_g_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_g_in_fsm_int <= INPUT_G_IN_I_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_g_in_fsm_int <= STARTER_G_IN_STATE;
      end case;
    end if;
  end process;

  s_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      S_OUT_I_ENABLE <= '0';
      S_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_s_in_loop <= ZERO_CONTROL;
      index_j_s_in_loop <= ZERO_CONTROL;

      data_s_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_s_in_fsm_int is
        when STARTER_S_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            S_OUT_I_ENABLE <= '1';
            S_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_s_in_loop <= ZERO_CONTROL;
            index_j_s_in_loop <= ZERO_CONTROL;

            data_s_in_enable_int <= '0';

            -- FSM Control
            controller_s_in_fsm_int <= INPUT_S_IN_I_STATE;
          else
            -- Control Outputs
            S_OUT_I_ENABLE <= '0';
            S_OUT_J_ENABLE <= '0';
          end if;

        when INPUT_S_IN_I_STATE =>      -- STEP 1

          if ((S_IN_I_ENABLE = '1') and (S_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_s_in_int(to_integer(unsigned(index_i_s_in_loop)), to_integer(unsigned(index_j_s_in_loop))) <= S_IN;

            -- FSM Control
            controller_s_in_fsm_int <= CLEAN_S_IN_J_STATE;
          end if;

          -- Control Outputs
          S_OUT_I_ENABLE <= '0';
          S_OUT_J_ENABLE <= '0';

        when INPUT_S_IN_J_STATE =>      -- STEP 2

          if (S_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_s_in_int(to_integer(unsigned(index_i_s_in_loop)), to_integer(unsigned(index_j_s_in_loop))) <= S_IN;

            -- FSM Control
            if (unsigned(index_j_s_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_s_in_fsm_int <= CLEAN_S_IN_I_STATE;
            else
              controller_s_in_fsm_int <= CLEAN_S_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          S_OUT_J_ENABLE <= '0';

        when CLEAN_S_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_s_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_s_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            S_OUT_I_ENABLE <= '1';
            S_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_s_in_loop <= ZERO_CONTROL;
            index_j_s_in_loop <= ZERO_CONTROL;

            data_s_in_enable_int <= '1';

            -- FSM Control
            controller_s_in_fsm_int <= STARTER_S_IN_STATE;
          elsif ((unsigned(index_i_s_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_s_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            S_OUT_I_ENABLE <= '1';
            S_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_s_in_loop <= std_logic_vector(unsigned(index_i_s_in_loop) + unsigned(ONE_CONTROL));
            index_j_s_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_s_in_fsm_int <= INPUT_S_IN_I_STATE;
          end if;

        when CLEAN_S_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_s_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            S_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_s_in_loop <= std_logic_vector(unsigned(index_j_s_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_s_in_fsm_int <= INPUT_S_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_s_in_fsm_int <= STARTER_S_IN_STATE;
      end case;
    end if;
  end process;

  gamma_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      GAMMA_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_gamma_in_loop <= ZERO_CONTROL;

      data_gamma_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_gamma_in_fsm_int is
        when STARTER_GAMMA_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            GAMMA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_gamma_in_loop <= ZERO_CONTROL;

            data_gamma_in_enable_int <= '0';

            -- FSM Control
            controller_gamma_in_fsm_int <= INPUT_GAMMA_IN_I_STATE;
          else
            -- Control Outputs
            GAMMA_OUT_ENABLE <= '0';
          end if;

        when INPUT_GAMMA_IN_I_STATE =>  -- STEP 1

          if (GAMMA_IN_ENABLE = '1') then
            -- Data Inputs
            vector_gamma_in_int(to_integer(unsigned(index_i_gamma_in_loop))) <= GAMMA_IN;

            -- FSM Control
            controller_gamma_in_fsm_int <= CLEAN_GAMMA_IN_I_STATE;
          end if;

          -- Control Outputs
          GAMMA_OUT_ENABLE <= '0';

        when CLEAN_GAMMA_IN_I_STATE =>  -- STEP 2

          if (unsigned(index_i_gamma_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            GAMMA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_gamma_in_loop <= ZERO_CONTROL;

            data_gamma_in_enable_int <= '1';

            -- FSM Control
            controller_gamma_in_fsm_int <= STARTER_GAMMA_IN_STATE;
          elsif (unsigned(index_i_gamma_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            GAMMA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_gamma_in_loop <= std_logic_vector(unsigned(index_i_gamma_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_gamma_in_fsm_int <= INPUT_GAMMA_IN_I_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_gamma_in_fsm_int <= STARTER_GAMMA_IN_STATE;
      end case;
    end if;
  end process;

  m_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      M_OUT_J_ENABLE <= '0';
      M_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_j_m_in_loop <= ZERO_CONTROL;
      index_k_m_in_loop <= ZERO_CONTROL;

      data_m_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_m_in_fsm_int is
        when STARTER_M_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_in_loop <= ZERO_CONTROL;
            index_k_m_in_loop <= ZERO_CONTROL;

            data_m_in_enable_int <= '0';

            -- FSM Control
            controller_m_in_fsm_int <= INPUT_M_IN_J_STATE;
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
            M_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_M_IN_J_STATE =>      -- STEP 1

          if ((M_IN_J_ENABLE = '1') and (M_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_m_in_int(to_integer(unsigned(index_j_m_in_loop)), to_integer(unsigned(index_k_m_in_loop))) <= M_IN;

            -- FSM Control
            controller_m_in_fsm_int <= CLEAN_M_IN_K_STATE;
          end if;

          -- Control Outputs
          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

        when INPUT_M_IN_K_STATE =>      -- STEP 2

          if (M_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_m_in_int(to_integer(unsigned(index_j_m_in_loop)), to_integer(unsigned(index_k_m_in_loop))) <= M_IN;

            -- FSM Control
            if (unsigned(index_k_m_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_m_in_fsm_int <= CLEAN_M_IN_J_STATE;
            else
              controller_m_in_fsm_int <= CLEAN_M_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          M_OUT_K_ENABLE <= '0';
          W_OUT_J_ENABLE <= '0';

        when CLEAN_M_IN_J_STATE =>      -- STEP 3

          if ((unsigned(index_j_m_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_m_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_in_loop <= ZERO_CONTROL;
            index_k_m_in_loop <= ZERO_CONTROL;

            data_m_in_enable_int <= '1';

            -- FSM Control
            controller_m_in_fsm_int <= STARTER_M_IN_STATE;
          elsif ((unsigned(index_j_m_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_m_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_in_loop <= std_logic_vector(unsigned(index_j_m_in_loop) + unsigned(ONE_CONTROL));
            index_k_m_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_m_in_fsm_int <= INPUT_M_IN_J_STATE;
          end if;

        when CLEAN_M_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_m_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_m_in_loop <= std_logic_vector(unsigned(index_k_m_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_m_in_fsm_int <= INPUT_M_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_m_in_fsm_int <= STARTER_M_IN_STATE;
      end case;
    end if;
  end process;

  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_I_ENABLE <= '0';
      W_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_w_in_loop <= ZERO_CONTROL;
      index_j_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= ZERO_CONTROL;
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_I_STATE;
          else
            -- Control Outputs
            W_OUT_I_ENABLE <= '0';
            W_OUT_J_ENABLE <= '0';
          end if;

        when INPUT_W_IN_I_STATE =>      -- STEP 1

          if ((W_IN_I_ENABLE = '1') and (W_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_i_w_in_loop)), to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
          end if;

          -- Control Outputs
          W_OUT_I_ENABLE <= '0';
          W_OUT_J_ENABLE <= '0';

        when INPUT_W_IN_J_STATE =>      -- STEP 2

          if (W_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_i_w_in_loop)), to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_I_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

        when CLEAN_W_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_w_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= ZERO_CONTROL;
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_i_w_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= std_logic_vector(unsigned(index_i_w_in_loop) + unsigned(ONE_CONTROL));
            index_j_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_I_STATE;
          end if;

        when CLEAN_W_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_w_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_w_in_loop <= std_logic_vector(unsigned(index_j_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_in_fsm_int <= STARTER_W_IN_STATE;
      end case;
    end if;
  end process;

  w_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      W_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_I_ENABLE <= '0';
      W_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_w_out_loop <= ZERO_CONTROL;
      index_k_w_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_w_out_fsm_int is
        when STARTER_W_OUT_STATE =>     -- STEP 0
          if (data_k_in_enable_int = '1' and data_beta_in_enable_int = '1' and data_g_in_enable_int = '1' and data_s_in_enable_int = '1' and data_gamma_in_enable_int = '1' and data_m_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_i_w_out_loop <= ZERO_CONTROL;
            index_k_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_I_STATE;
          end if;

        when CLEAN_W_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          W_OUT_I_ENABLE <= '0';
          W_OUT_J_ENABLE <= '0';

          -- FSM Control
          controller_w_out_fsm_int <= OUTPUT_W_OUT_K_STATE;

        when CLEAN_W_OUT_K_STATE =>     -- STEP 2

          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_k_w_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_w_out_fsm_int <= OUTPUT_W_OUT_I_STATE;
          else
            controller_w_out_fsm_int <= OUTPUT_W_OUT_K_STATE;
          end if;

        when OUTPUT_W_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_w_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_w_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_i_w_out_loop)), to_integer(unsigned(index_k_w_out_loop)));

            -- Control Outputs
            READY <= '1';

            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_out_loop <= ZERO_CONTROL;
            index_k_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
          elsif ((unsigned(index_i_w_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_w_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_i_w_out_loop)), to_integer(unsigned(index_k_w_out_loop)));

            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_out_loop <= std_logic_vector(unsigned(index_i_w_out_loop) + unsigned(ONE_CONTROL));
            index_k_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_I_STATE;
          end if;

        when OUTPUT_W_OUT_K_STATE =>    -- STEP 4

          if (unsigned(index_k_w_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_i_w_out_loop)), to_integer(unsigned(index_k_w_out_loop)));

            -- Control Outputs
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_k_w_out_loop <= std_logic_vector(unsigned(index_k_w_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
      end case;
    end if;
  end process;

  -- VECTOR CONTENT BASED ADDRESSING
  content_based_addressing : accelerator_content_based_addressing
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_content_based_addressing,
      READY => ready_vector_content_based_addressing,

      K_IN_ENABLE => k_in_enable_vector_content_based_addressing,

      K_OUT_ENABLE => k_out_enable_vector_content_based_addressing,

      M_IN_I_ENABLE => m_in_i_enable_vector_content_based_addressing,
      M_IN_J_ENABLE => m_in_j_enable_vector_content_based_addressing,

      M_OUT_I_ENABLE => m_out_i_enable_vector_content_based_addressing,
      M_OUT_J_ENABLE => m_out_j_enable_vector_content_based_addressing,

      C_OUT_ENABLE => c_out_enable_vector_content_based_addressing,

      -- DATA
      SIZE_I_IN => size_i_in_vector_content_based_addressing,
      SIZE_J_IN => size_j_in_vector_content_based_addressing,

      K_IN    => k_in_vector_content_based_addressing,
      BETA_IN => beta_in_vector_content_based_addressing,
      M_IN    => m_in_vector_content_based_addressing,

      C_OUT => c_out_vector_content_based_addressing
      );

  -- MATRIX FLOAT ADDER
  matrix_float_adder : accelerator_matrix_float_adder
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

      DATA_OUT     => data_out_matrix_float_adder,
      OVERFLOW_OUT => overflow_out_matrix_float_adder
      );

  -- MATRIX FLOAT MULTIPLIER
  matrix_float_multiplier : accelerator_matrix_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_float_multiplier,
      READY => ready_matrix_float_multiplier,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_float_multiplier,
      SIZE_J_IN => size_j_in_matrix_float_multiplier,
      DATA_A_IN => data_a_in_matrix_float_multiplier,
      DATA_B_IN => data_b_in_matrix_float_multiplier,

      DATA_OUT     => data_out_matrix_float_multiplier,
      OVERFLOW_OUT => overflow_out_matrix_float_multiplier
      );

  -- MATRIX FLOAT DIVIDER
  matrix_float_divider : accelerator_matrix_float_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_float_divider,
      READY => ready_matrix_float_divider,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_divider,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_divider,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_divider,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_divider,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_divider,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_divider,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_float_divider,
      SIZE_J_IN => size_j_in_matrix_float_divider,
      DATA_A_IN => data_a_in_matrix_float_divider,
      DATA_B_IN => data_b_in_matrix_float_divider,

      DATA_OUT     => data_out_matrix_float_divider,
      OVERFLOW_OUT => overflow_out_matrix_float_divider
      );

  -- MATRIX POWER
  matrix_power_function : accelerator_matrix_power_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_power_function,
      READY => ready_matrix_power_function,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_power_function,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_power_function,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_power_function,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_power_function,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_power_function,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_power_function,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_power_function,
      SIZE_J_IN => size_j_in_matrix_power_function,
      DATA_A_IN => data_a_in_matrix_power_function,
      DATA_B_IN => data_b_in_matrix_power_function,

      DATA_OUT => data_out_matrix_power_function
      );

  -- TRANSPOSE VECTOR PRODUCT
  transpose_vector_product : accelerator_transpose_vector_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_transpose_vector_product,
      READY => ready_transpose_vector_product,

      DATA_A_IN_ENABLE => data_a_in_enable_transpose_vector_product,
      DATA_B_IN_ENABLE => data_b_in_enable_transpose_vector_product,

      DATA_ENABLE => data_enable_transpose_vector_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_transpose_vector_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_transpose_vector_product,

      -- DATA
      SIZE_A_IN => size_a_in_transpose_vector_product,
      SIZE_B_IN => size_b_in_transpose_vector_product,

      DATA_A_IN => data_a_in_transpose_vector_product,
      DATA_B_IN => data_b_in_transpose_vector_product,
      DATA_OUT  => data_out_transpose_vector_product
      );

  -- VECTOR CONVOLUTION
  vector_convolution : accelerator_vector_convolution
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_convolution,
      READY => ready_vector_convolution,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_convolution,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_convolution,

      DATA_OUT_ENABLE => data_out_enable_vector_convolution,

      -- DATA
      LENGTH_IN => length_in_vector_convolution,
      DATA_A_IN => data_a_in_vector_convolution,
      DATA_B_IN => data_b_in_vector_convolution,
      DATA_OUT  => data_out_vector_convolution
      );

  -- VECTOR SUMMATION
  vector_summation : accelerator_vector_summation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      DATA_IN_LENGTH_ENABLE => data_in_enable_length_vector_summation,
      DATA_IN_ENABLE        => data_in_enable_vector_summation,

      DATA_LENGTH_ENABLE => data_enable_length_vector_summation,
      DATA_ENABLE        => data_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

end architecture;
