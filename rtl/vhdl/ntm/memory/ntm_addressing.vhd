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

entity ntm_addressing is
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

    K_IN_ENABLE : in std_logic;         -- for k in 0 to W-1
    S_IN_ENABLE : in std_logic;         -- for k in 0 to W-1

    K_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1
    S_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    W_IN_ENABLE  : in  std_logic;       -- for j in 0 to N-1
    W_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
    G_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    S_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
    GAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_addressing_architecture of ntm_addressing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                          -- STEP 0
    VECTOR_CONTENT_BASED_ADDRESSING_STATE,  -- STEP 1
    VECTOR_INTERPOLATION_STATE,             -- STEP 2
    VECTOR_CONVOLUTION_STATE,               -- STEP 3
    VECTOR_SHARPENING_STATE                 -- STEP 4
    );

  type controller_ctrl_interpolation_fsm is (
    STARTER_INTERPOLATION_STATE,                   -- STEP 0
    VECTOR_FIRST_MULTIPLIER_INTERPOLATION_STATE,   -- STEP 1
    VECTOR_FIRST_ADDER_INTERPOLATION_STATE,        -- STEP 2
    VECTOR_SECOND_MULTIPLIER_INTERPOLATION_STATE,  -- STEP 3
    VECTOR_SECOND_ADDER_INTERPOLATION_STATE        -- STEP 4
    );

  type controller_ctrl_sharpening_fsm is (
    STARTER_SHARPENING_STATE,               -- STEP 0
    VECTOR_EXPONENTIATOR_SHARPENING_STATE,  -- STEP 1
    VECTOR_SUMMATION_SHARPENING_STATE,      -- STEP 2
    VECTOR_DIVIDER_SHARPENING_STATE         -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  signal controller_ctrl_interpolation_fsm_int : controller_ctrl_interpolation_fsm;

  signal controller_ctrl_sharpening_fsm_int : controller_ctrl_sharpening_fsm;

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

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_float_adder : std_logic;
  signal ready_vector_float_adder : std_logic;

  signal operation_vector_float_adder : std_logic;

  signal data_a_in_enable_vector_float_adder : std_logic;
  signal data_b_in_enable_vector_float_adder : std_logic;

  signal data_out_enable_vector_float_adder : std_logic;

  -- DATA
  signal size_in_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_float_multiplier : std_logic;
  signal ready_vector_float_multiplier : std_logic;

  signal data_a_in_enable_vector_float_multiplier : std_logic;
  signal data_b_in_enable_vector_float_multiplier : std_logic;

  signal data_out_enable_vector_float_multiplier : std_logic;

  -- DATA
  signal size_in_vector_float_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIVIDER
  -- CONTROL
  signal start_vector_float_divider : std_logic;
  signal ready_vector_float_divider : std_logic;

  signal data_a_in_enable_vector_float_divider : std_logic;
  signal data_b_in_enable_vector_float_divider : std_logic;

  signal data_out_enable_vector_float_divider : std_logic;

  -- DATA
  signal size_in_vector_float_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator_function : std_logic;
  signal ready_vector_exponentiator_function : std_logic;

  signal data_in_enable_vector_exponentiator_function : std_logic;

  signal data_out_enable_vector_exponentiator_function : std_logic;

  -- DATA
  signal size_in_vector_exponentiator_function  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_exponentiator_function  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator_function : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_enable_vector_summation : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- wc(t;j) = C(M(t;j;k),k(t;k),beta(t))

  -- wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)

  -- w(t;j) = wg(t;j)*s(t;k)

  -- w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      W_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_ENABLE <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          W_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            start_vector_content_based_addressing <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_CONTENT_BASED_ADDRESSING_STATE;
          else
            -- Control Internal
            start_vector_content_based_addressing <= '0';
          end if;

        when VECTOR_CONTENT_BASED_ADDRESSING_STATE =>  -- STEP 1

          -- wc(t;j) = C(M(t1;j;k),k(t;k),beta(t))

        when VECTOR_INTERPOLATION_STATE =>  -- STEP 2

          -- wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)

          case controller_ctrl_interpolation_fsm_int is
            when STARTER_INTERPOLATION_STATE =>  -- STEP 0

            when VECTOR_FIRST_MULTIPLIER_INTERPOLATION_STATE =>  -- STEP 1

              -- Control Inputs
              data_a_in_enable_vector_float_multiplier <= '0';
              data_b_in_enable_vector_float_multiplier <= '0';

              -- Data Inputs
              size_in_vector_float_multiplier   <= FULL;
              data_a_in_vector_float_multiplier <= FULL;
              data_b_in_vector_float_multiplier <= FULL;

            when VECTOR_FIRST_ADDER_INTERPOLATION_STATE =>  -- STEP 2

              -- Control Inputs
              operation_vector_float_adder <= '0';

              data_a_in_enable_vector_float_adder <= '0';
              data_b_in_enable_vector_float_adder <= '0';

              -- Data Inputs
              size_in_vector_float_adder   <= FULL;
              data_a_in_vector_float_adder <= FULL;
              data_b_in_vector_float_adder <= FULL;

            when VECTOR_SECOND_MULTIPLIER_INTERPOLATION_STATE =>  -- STEP 3

              -- Control Inputs
              data_a_in_enable_vector_float_multiplier <= '0';
              data_b_in_enable_vector_float_multiplier <= '0';

              -- Data Inputs
              size_in_vector_float_multiplier   <= FULL;
              data_a_in_vector_float_multiplier <= FULL;
              data_b_in_vector_float_multiplier <= FULL;

            when VECTOR_SECOND_ADDER_INTERPOLATION_STATE =>  -- STEP 4

              -- Control Inputs
              operation_vector_float_adder <= '0';

              data_a_in_enable_vector_float_adder <= '0';
              data_b_in_enable_vector_float_adder <= '0';

              -- Data Inputs
              size_in_vector_float_adder   <= FULL;
              data_a_in_vector_float_adder <= FULL;
              data_b_in_vector_float_adder <= FULL;

            when others =>
              -- FSM Control
              controller_ctrl_interpolation_fsm_int <= STARTER_INTERPOLATION_STATE;
          end case;

        when VECTOR_CONVOLUTION_STATE =>  -- STEP 3

          -- w(t;j) = wg(t;j)*s(t;k)

        when VECTOR_SHARPENING_STATE =>  -- STEP 4

          -- w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]

          case controller_ctrl_sharpening_fsm_int is
            when STARTER_SHARPENING_STATE =>  -- STEP 0

            when VECTOR_EXPONENTIATOR_SHARPENING_STATE =>  -- STEP 1

            when VECTOR_SUMMATION_SHARPENING_STATE =>  -- STEP 2

            when VECTOR_DIVIDER_SHARPENING_STATE =>  -- STEP 3

            when others =>
              -- FSM Control
              controller_ctrl_sharpening_fsm_int <= STARTER_SHARPENING_STATE;
          end case;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- VECTOR CONTENT BASED ADDRESSING
  k_in_enable_vector_content_based_addressing <= '0';

  m_in_i_enable_vector_content_based_addressing <= '0';
  m_in_j_enable_vector_content_based_addressing <= '0';

  -- VECTOR CONVOLUTION
  data_a_in_enable_vector_convolution <= '0';
  data_b_in_enable_vector_convolution <= '0';

  -- VECTOR EXPONENTIATOR
  data_in_enable_vector_exponentiator_function <= '0';

  -- VECTOR SUMMATION
  data_in_enable_vector_summation <= '0';

  -- VECTOR DIVIDER
  data_a_in_enable_vector_float_divider <= '0';
  data_b_in_enable_vector_float_divider <= '0';

  -- DATA
  -- VECTOR CONTENT BASED ADDRESSING
  size_i_in_vector_content_based_addressing <= SIZE_N_IN;
  size_j_in_vector_content_based_addressing <= SIZE_W_IN;
  k_in_vector_content_based_addressing      <= K_IN;
  beta_in_vector_content_based_addressing   <= BETA_IN;
  m_in_vector_content_based_addressing      <= M_IN;

  -- VECTOR CONVOLUTION
  length_in_vector_convolution <= THREE_CONTROL;
  data_a_in_vector_convolution <= FULL;
  data_b_in_vector_convolution <= FULL;

  -- VECTOR EXPONENTIATOR
  size_in_vector_exponentiator_function <= THREE_CONTROL;
  data_in_vector_exponentiator_function <= FULL;

  -- VECTOR SUMMATION
  size_in_vector_summation   <= THREE_CONTROL;
  length_in_vector_summation <= THREE_CONTROL;
  data_in_vector_summation   <= FULL;

  -- VECTOR DIVIDER
  size_in_vector_float_divider   <= THREE_CONTROL;
  data_a_in_vector_float_divider <= FULL;
  data_b_in_vector_float_divider <= FULL;

  -- VECTOR CONTENT BASED ADDRESSING
  content_based_addressing : ntm_content_based_addressing
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

  -- VECTOR ADDER
  vector_float_adder : ntm_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_adder,
      READY => ready_vector_float_adder,

      OPERATION => operation_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_vector_float_adder,
      DATA_A_IN => data_a_in_vector_float_adder,
      DATA_B_IN => data_b_in_vector_float_adder,
      DATA_OUT  => data_out_vector_float_adder
      );

  -- VECTOR MULTIPLIER
  vecto_float_multiplier : ntm_vector_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_multiplier,
      READY => ready_vector_float_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

      -- DATA
      SIZE_IN   => size_in_vector_float_multiplier,
      DATA_A_IN => data_a_in_vector_float_multiplier,
      DATA_B_IN => data_b_in_vector_float_multiplier,
      DATA_OUT  => data_out_vector_float_multiplier
      );

  -- VECTOR DIVIDER
  vecto_float_divider : ntm_vector_float_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_divider,
      READY => ready_vector_float_divider,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_divider,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_divider,

      DATA_OUT_ENABLE => data_out_enable_vector_float_divider,

      -- DATA
      SIZE_IN   => size_in_vector_float_divider,
      DATA_A_IN => data_a_in_vector_float_divider,
      DATA_B_IN => data_b_in_vector_float_divider,
      DATA_OUT  => data_out_vector_float_divider
      );

  -- VECTOR EXPONENTIATOR
  vector_exponentiator_function : ntm_vector_exponentiator_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_exponentiator_function,
      READY => ready_vector_exponentiator_function,

      DATA_IN_ENABLE => data_in_enable_vector_exponentiator_function,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator_function,

      -- DATA
      SIZE_IN  => size_in_vector_exponentiator_function,
      DATA_IN  => data_in_vector_exponentiator_function,
      DATA_OUT => data_out_vector_exponentiator_function
      );

  -- VECTOR SUMMATION
  vector_summation : ntm_vector_summation
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

      DATA_IN_ENABLE => data_in_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

  -- VECTOR CONVOLUTION
  vector_convolution : ntm_vector_convolution
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

end architecture;
