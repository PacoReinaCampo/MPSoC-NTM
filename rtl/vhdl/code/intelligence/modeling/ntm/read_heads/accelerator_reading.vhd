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

entity accelerator_reading is
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

architecture accelerator_reading_architecture of accelerator_reading is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

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

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_I_STATE,                 -- STEP 1
    INPUT_W_IN_J_STATE,                 -- STEP 2
    CLEAN_W_IN_I_STATE,                 -- STEP 3
    CLEAN_W_IN_J_STATE                  -- STEP 4
    );

  type controller_m_in_fsm is (
    STARTER_M_IN_STATE,                 -- STEP 0
    INPUT_M_IN_J_STATE,                 -- STEP 1
    INPUT_M_IN_K_STATE,                 -- STEP 2
    CLEAN_M_IN_J_STATE,                 -- STEP 3
    CLEAN_M_IN_K_STATE                  -- STEP 4
    );

  -- Ops
  type controller_matrix_float_multiplier_fsm is (
    STARTER_MATRIX_MULTIPLIER_STATE,    -- STEP 0
    INPUT_J_MATRIX_MULTIPLIER_STATE,    -- STEP 1
    INPUT_K_MATRIX_MULTIPLIER_STATE,    -- STEP 2
    CLEAN_J_MATRIX_MULTIPLIER_STATE,    -- STEP 3
    CLEAN_K_MATRIX_MULTIPLIER_STATE     -- STEP 4
    );

  type controller_vector_summation_fsm is (
    STARTER_VECTOR_SUMMATION_STATE,          -- STEP 0
    INPUT_IN_VECTOR_LENGTH_SUMMATION_STATE,  -- STEP 1
    INPUT_IN_VECTOR_SIZE_SUMMATION_STATE,    -- STEP 2
    CLEAN_IN_VECTOR_LENGTH_SUMMATION_STATE,  -- STEP 3
    CLEAN_IN_VECTOR_SIZE_SUMMATION_STATE,    -- STEP 4
    OUTPUT_OUT_VECTOR_SIZE_SUMMATION_STATE   -- STEP 5
    );

  -- Output
  type controller_r_out_fsm is (
    STARTER_R_OUT_STATE,                -- STEP 0
    MATRIX_RESHAPE_STATE,               -- STEP 1
    MATRIX_MULTIPLIER_STATE,            -- STEP 2
    VECTOR_SUMMATION_STATE,             -- STEP 3
    OUTPUT_R_OUT_I_STATE,               -- STEP 4
    OUTPUT_R_OUT_K_STATE                -- STEP 5
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_m_in_fsm_int : controller_m_in_fsm;

  -- Ops
  signal controller_matrix_float_multiplier_fsm_int : controller_matrix_float_multiplier_fsm;
  signal controller_vector_summation_fsm_int        : controller_vector_summation_fsm;

  -- Output
  signal controller_r_out_fsm_int : controller_r_out_fsm;

  -- Buffer
  -- Input
  signal matrix_w_in_int : matrix_buffer;
  signal matrix_m_in_int : matrix_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;

  -- Output
  signal vector_summation_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_i_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_j_matrix_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_matrix_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_r_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_w_in_enable_int : std_logic;
  signal data_m_in_enable_int : std_logic;

  -- Ops
  signal data_matrix_float_multiplier_start_int : std_logic;
  signal data_matrix_float_multiplier_ready_int : std_logic;

  -- Output
  signal data_vector_summation_start_int : std_logic;
  signal data_vector_summation_ready_int : std_logic;

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

  -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]

  -- INPUT CONTROL
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

  -- OPS CONTROL
  matrix_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_multiplier <= '0';
      data_a_in_j_enable_matrix_float_multiplier <= '0';
      data_b_in_i_enable_matrix_float_multiplier <= '0';
      data_b_in_j_enable_matrix_float_multiplier <= '0';

      data_matrix_float_multiplier_ready_int <= '0';

      index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;
      index_k_matrix_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_float_multiplier_fsm_int is
        when STARTER_MATRIX_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_multiplier <= '0';
          data_a_in_j_enable_matrix_float_multiplier <= '0';
          data_b_in_i_enable_matrix_float_multiplier <= '0';
          data_b_in_j_enable_matrix_float_multiplier <= '0';

          data_matrix_float_multiplier_ready_int <= '0';

          if (data_w_in_enable_int = '1' and data_m_in_enable_int = '1' and data_matrix_float_multiplier_start_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_multiplier <= SIZE_N_IN;
            size_j_in_matrix_float_multiplier <= SIZE_W_IN;

            -- Control Internal
            index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;
            index_k_matrix_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_float_multiplier_fsm_int <= INPUT_J_MATRIX_MULTIPLIER_STATE;
          end if;

        when INPUT_J_MATRIX_MULTIPLIER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop)));
          data_b_in_matrix_float_multiplier <= matrix_m_in_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop)));

          -- Control Internal
          if (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_matrix_float_multiplier_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_multiplier <= '1';
          end if;

          data_a_in_i_enable_matrix_float_multiplier <= '1';
          data_a_in_j_enable_matrix_float_multiplier <= '1';
          data_b_in_i_enable_matrix_float_multiplier <= '1';
          data_b_in_j_enable_matrix_float_multiplier <= '1';

          -- FSM Control
          controller_matrix_float_multiplier_fsm_int <= CLEAN_K_MATRIX_MULTIPLIER_STATE;

        when INPUT_K_MATRIX_MULTIPLIER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop)));
          data_b_in_matrix_float_multiplier <= matrix_m_in_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_multiplier <= '1';
          data_b_in_j_enable_matrix_float_multiplier <= '1';

          -- FSM Control
          if (unsigned(index_k_matrix_float_multiplier_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_float_multiplier_fsm_int <= CLEAN_J_MATRIX_MULTIPLIER_STATE;
          else
            controller_matrix_float_multiplier_fsm_int <= CLEAN_K_MATRIX_MULTIPLIER_STATE;
          end if;

        when CLEAN_J_MATRIX_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_multiplier = '1' and data_out_j_enable_matrix_float_multiplier = '1') then
            if ((unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_matrix_float_multiplier_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              data_matrix_float_multiplier_ready_int <= '1';

              index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;
              index_k_matrix_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= STARTER_MATRIX_MULTIPLIER_STATE;
            elsif ((unsigned(index_j_matrix_float_multiplier_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_matrix_float_multiplier_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              index_j_matrix_float_multiplier_loop <= std_logic_vector(unsigned(index_j_matrix_float_multiplier_loop) + unsigned(ONE_CONTROL));
              index_k_matrix_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= INPUT_J_MATRIX_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_multiplier <= '0';

            data_a_in_i_enable_matrix_float_multiplier <= '0';
            data_a_in_j_enable_matrix_float_multiplier <= '0';
            data_b_in_i_enable_matrix_float_multiplier <= '0';
            data_b_in_j_enable_matrix_float_multiplier <= '0';
          end if;

        when CLEAN_K_MATRIX_MULTIPLIER_STATE =>  -- STEP 8

          if (data_out_j_enable_matrix_float_multiplier = '1') then
            if (unsigned(index_k_matrix_float_multiplier_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_j_matrix_float_multiplier_loop)), to_integer(unsigned(index_k_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              index_k_matrix_float_multiplier_loop <= std_logic_vector(unsigned(index_k_matrix_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= INPUT_J_MATRIX_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_multiplier <= '0';

            data_a_in_i_enable_matrix_float_multiplier <= '0';
            data_a_in_j_enable_matrix_float_multiplier <= '0';
            data_b_in_i_enable_matrix_float_multiplier <= '0';
            data_b_in_j_enable_matrix_float_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_matrix_float_multiplier_fsm_int <= STARTER_MATRIX_MULTIPLIER_STATE;
      end case;
    end if;
  end process;

  vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_enable_length_vector_summation <= '0';
      data_in_enable_vector_summation        <= '0';

      data_vector_summation_ready_int <= '0';

      index_j_vector_summation_loop <= ZERO_CONTROL;
      index_k_vector_summation_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_summation_fsm_int is
        when STARTER_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_enable_length_vector_summation <= '0';
          data_in_enable_vector_summation        <= '0';

          if (data_w_in_enable_int = '1' and data_m_in_enable_int = '1' and data_vector_summation_start_int = '1') then
            -- Data Inputs
            length_in_vector_summation <= SIZE_R_IN;
            size_in_vector_summation   <= SIZE_W_IN;

            -- Control Internal
            index_j_vector_summation_loop <= ZERO_CONTROL;
            index_k_vector_summation_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_summation_fsm_int <= INPUT_IN_VECTOR_LENGTH_SUMMATION_STATE;
          end if;

          -- Control Internal
          data_vector_summation_ready_int <= '0';

        when INPUT_IN_VECTOR_LENGTH_SUMMATION_STATE =>  -- STEP 1

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_j_vector_summation_loop)), to_integer(unsigned(index_k_vector_summation_loop)));

          -- Control Internal
          if (unsigned(index_j_vector_summation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_vector_summation_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_summation <= '1';
          end if;

          data_in_enable_length_vector_summation <= '1';
          data_in_enable_vector_summation        <= '1';

          -- FSM Control
          controller_vector_summation_fsm_int <= CLEAN_IN_VECTOR_SIZE_SUMMATION_STATE;

        when INPUT_IN_VECTOR_SIZE_SUMMATION_STATE =>  -- STEP 2

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_j_vector_summation_loop)), to_integer(unsigned(index_k_vector_summation_loop)));

          -- Control Internal
          data_in_enable_vector_summation <= '1';

          -- FSM Control
          if (unsigned(index_k_vector_summation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_vector_summation_fsm_int <= CLEAN_IN_VECTOR_LENGTH_SUMMATION_STATE;
          else
            controller_vector_summation_fsm_int <= CLEAN_IN_VECTOR_SIZE_SUMMATION_STATE;
          end if;

        when CLEAN_IN_VECTOR_LENGTH_SUMMATION_STATE =>  -- STEP 3

          if (data_enable_length_vector_summation = '1' and data_enable_vector_summation = '1') then
            if ((unsigned(index_j_vector_summation_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_vector_summation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_vector_summation_loop <= ZERO_CONTROL;
              index_k_vector_summation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= OUTPUT_OUT_VECTOR_SIZE_SUMMATION_STATE;
            elsif ((unsigned(index_j_vector_summation_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_vector_summation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_j_vector_summation_loop <= std_logic_vector(unsigned(index_j_vector_summation_loop) + unsigned(ONE_CONTROL));
              index_k_vector_summation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_IN_VECTOR_LENGTH_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_enable_length_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when CLEAN_IN_VECTOR_SIZE_SUMMATION_STATE =>  -- STEP 4

          if (data_enable_vector_summation = '1') then
            if (unsigned(index_k_vector_summation_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_k_vector_summation_loop <= std_logic_vector(unsigned(index_k_vector_summation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_IN_VECTOR_LENGTH_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_enable_length_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when OUTPUT_OUT_VECTOR_SIZE_SUMMATION_STATE =>  -- STEP 5

          if (data_out_enable_vector_summation = '1') then
            if (unsigned(index_k_vector_summation_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_summation_int(to_integer(unsigned(index_k_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              data_vector_summation_ready_int <= '1';

              index_k_vector_summation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
            else
              -- Data Internal
              vector_summation_int(to_integer(unsigned(index_k_vector_summation_loop))) <= data_out_vector_summation;

              -- Control Internal
              index_k_vector_summation_loop <= std_logic_vector(unsigned(index_k_vector_summation_loop) + unsigned(ONE_CONTROL));
            end if;
          end if;

        when others =>
          -- FSM Control
          controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  r_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      R_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_r_out_loop <= ZERO_CONTROL;
      index_k_r_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_r_out_fsm_int is
        when STARTER_R_OUT_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Internal
            index_i_r_out_loop <= ZERO_CONTROL;
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_int <= MATRIX_RESHAPE_STATE;
          end if;

        when MATRIX_RESHAPE_STATE =>    -- STEP 1

          -- Data Internal
          for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
            for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
              matrix_operation_int(j, k) <= matrix_w_in_int(to_integer(unsigned(index_i_r_out_loop)), j);
            end loop;
          end loop;

          -- Control Internal
          data_matrix_float_multiplier_start_int <= '1';

          -- FSM Control
          controller_r_out_fsm_int <= MATRIX_MULTIPLIER_STATE;

        when MATRIX_MULTIPLIER_STATE =>  -- STEP 2

          if (data_matrix_float_multiplier_ready_int = '1') then
            -- Control Internal
            data_vector_summation_start_int <= '1';

            -- FSM Control
            controller_r_out_fsm_int <= VECTOR_SUMMATION_STATE;
          end if;

          -- Control Internal
          data_matrix_float_multiplier_start_int <= '0';

        when VECTOR_SUMMATION_STATE =>  -- STEP 3

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

          -- FSM Control
          if (data_vector_summation_ready_int = '1') then
            if (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_r_out_fsm_int <= OUTPUT_R_OUT_I_STATE;
            else
              controller_r_out_fsm_int <= OUTPUT_R_OUT_K_STATE;
            end if;
          end if;

          -- Control Internal
          data_vector_summation_start_int <= '0';

        when OUTPUT_R_OUT_I_STATE =>    -- STEP 6

          if ((unsigned(index_i_r_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= vector_summation_int(to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            READY <= '1';

            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_out_loop <= ZERO_CONTROL;
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_int <= STARTER_R_OUT_STATE;
          elsif ((unsigned(index_i_r_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= vector_summation_int(to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_out_loop <= std_logic_vector(unsigned(index_i_r_out_loop) + unsigned(ONE_CONTROL));
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_int <= MATRIX_RESHAPE_STATE;
          end if;

        when OUTPUT_R_OUT_K_STATE =>    -- STEP 7

          if (unsigned(index_k_r_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            R_OUT <= vector_summation_int(to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_out_loop <= std_logic_vector(unsigned(index_k_r_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_r_out_fsm_int <= MATRIX_RESHAPE_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_r_out_fsm_int <= STARTER_R_OUT_STATE;
      end case;
    end if;
  end process;

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
