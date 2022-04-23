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

entity ntm_reading is
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

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_reading_architecture of ntm_reading is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- W_IN [R,N]
  -- M_IN [N,W]

  -- Outputs:
  -- M_OUT [R,W]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    VECTOR_MULTIPLIER_STATE,            -- STEP 2
    VECTOR_ADDER_STATE                  -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_reading_int : std_logic;
  signal data_b_in_reading_int : std_logic;

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

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_enable_vector_summation : std_logic;

  signal data_enable_vector_summation : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      R_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_I_ENABLE <= '0';
      R_OUT_I_ENABLE <= '0';

      M_OUT_J_ENABLE <= '0';
      M_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

      data_a_in_reading_int <= '0';
      data_b_in_reading_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          W_OUT_I_ENABLE <= '0';
          R_OUT_I_ENABLE <= '0';

          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

          -- Control Internal
          index_i_loop <= ZERO_CONTROL;
          index_j_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (W_IN_I_ENABLE = '1') then
            -- Data Inputs
            data_a_in_vector_float_multiplier <= W_IN;

            -- Control Internal
            data_a_in_enable_vector_float_multiplier <= '1';

            data_a_in_reading_int <= '1';
          else
            -- Control Internal
            data_a_in_enable_vector_float_multiplier <= '0';
          end if;

          if (M_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_b_in_vector_float_multiplier <= M_IN;

            -- Control Internal
            data_b_in_enable_vector_float_multiplier <= '1';

            data_b_in_reading_int <= '1';
          else
            -- Control Internal
            data_b_in_enable_vector_float_multiplier <= '0';
          end if;

          -- Control Outputs
          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

          if (data_a_in_reading_int = '1' and data_b_in_reading_int = '1') then
            -- Control Internal
            if (unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
              start_vector_float_multiplier <= '1';
            else
              start_vector_float_multiplier <= '0';
            end if;

            data_a_in_reading_int <= '0';
            data_b_in_reading_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          end if;

        when VECTOR_MULTIPLIER_STATE =>  -- STEP 2

          if (data_out_enable_vector_float_multiplier = '1') then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';

            -- Data Internal
            if (unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
              data_a_in_vector_float_adder <= ZERO_DATA;
            else
              data_a_in_vector_float_adder <= data_out_vector_float_adder;
            end if;

            data_b_in_vector_float_adder <= data_out_vector_float_multiplier;

            -- Control Internal
            if (unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
              start_vector_float_adder <= '1';
            else
              start_vector_float_adder <= '0';
            end if;

            operation_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '1';
            data_b_in_enable_vector_float_adder <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_ADDER_STATE;
          else
            -- Control Internal
            start_vector_float_multiplier <= '0';
          end if;

        when VECTOR_ADDER_STATE =>      -- STEP 5

          if (data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_i_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              if (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
                -- Control Internal
                index_i_loop <= ZERO_CONTROL;
                index_j_loop <= ZERO_CONTROL;

                -- FSM Control
                controller_ctrl_fsm_int <= STARTER_STATE;
              elsif (unsigned(index_j_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
                -- Control Internal
                index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

                -- FSM Control
                controller_ctrl_fsm_int <= INPUT_STATE;
              end if;

              -- Data Outputs
              R_OUT <= data_out_vector_float_adder;

              -- Control Outputs
              M_OUT_J_ENABLE <= '1';
              M_OUT_K_ENABLE <= '1';
            elsif (unsigned(index_i_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              if (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
                -- Control Internal
                index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
                index_j_loop <= ZERO_CONTROL;

                -- FSM Control
                controller_ctrl_fsm_int <= INPUT_STATE;
              elsif (unsigned(index_j_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
                -- Control Internal
                index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

                -- FSM Control
                controller_ctrl_fsm_int <= INPUT_STATE;
              end if;

              -- Control Outputs
              M_OUT_K_ENABLE <= '1';
            end if;
          else
            -- Control Outputs
            W_OUT_I_ENABLE <= '0';

            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MATRIX FLOAT MULTIPLIER
  matrix_float_multiplier : ntm_matrix_float_multiplier
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

      DATA_ENABLE => data_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

end architecture;
