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

entity dnc_temporal_link_matrix is
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

    L_IN_G_ENABLE : in std_logic;       -- for g in 0 to N-1 (square matrix)
    L_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1 (square matrix)

    W_IN_ENABLE : in std_logic;         -- for j in 0 to N-1
    P_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    W_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1
    P_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    L_OUT_G_ENABLE : out std_logic;     -- for g in 0 to N-1 (square matrix)
    L_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1 (square matrix)

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    L_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_temporal_link_matrix_architecture of dnc_temporal_link_matrix is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- L_IN [N,N]
  -- W_IN [N]
  -- P_IN [N]

  -- Outputs:
  -- L_OUT [N,N]

  -- States:
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_P_STATE, CLEAN_OUT_P_STATE
  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_l_in_fsm is (
    STARTER_L_IN_STATE,                 -- STEP 0
    INPUT_L_IN_G_STATE,                 -- STEP 1
    INPUT_L_IN_J_STATE,                 -- STEP 2
    CLEAN_L_IN_G_STATE,                 -- STEP 3
    CLEAN_L_IN_J_STATE                  -- STEP 4
    );

  type controller_in_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  -- Ops
  type controller_first_matrix_float_adder_fsm is (
    STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 1
    INPUT_J_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 2
    CLEAN_I_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 3
    CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE   -- STEP 4
    );

  type controller_second_matrix_float_adder_fsm is (
    STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 1
    INPUT_J_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 2
    CLEAN_I_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 3
    CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE   -- STEP 4
    );

  type controller_matrix_float_multiplier_fsm is (
    STARTER_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 1
    INPUT_J_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 2
    CLEAN_I_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 3
    CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE   -- STEP 4
    );

  type controller_transpose_vector_product_fsm is (
    STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_third_matrix_float_adder_fsm is (
    STARTER_THIRD_MATRIX_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_I_THIRD_MATRIX_FLOAT_ADDER_STATE,  -- STEP 1
    INPUT_J_THIRD_MATRIX_FLOAT_ADDER_STATE,  -- STEP 2
    CLEAN_I_THIRD_MATRIX_FLOAT_ADDER_STATE,  -- STEP 3
    CLEAN_J_THIRD_MATRIX_FLOAT_ADDER_STATE   -- STEP 4
    );

  -- Output
  type controller_l_out_fsm is (
    STARTER_L_OUT_STATE,                -- STEP 0
    CLEAN_L_OUT_G_STATE,                -- STEP 1
    CLEAN_L_OUT_J_STATE,                -- STEP 2
    OUTPUT_L_OUT_G_STATE,               -- STEP 3
    OUTPUT_L_OUT_J_STATE                -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_l_in_fsm_int : controller_l_in_fsm;

  signal controller_in_fsm_int : controller_in_fsm;

  -- Ops
  signal controller_first_matrix_float_adder_fsm_int  : controller_first_matrix_float_adder_fsm;
  signal controller_second_matrix_float_adder_fsm_int : controller_second_matrix_float_adder_fsm;
  signal controller_matrix_float_multiplier_fsm_int   : controller_matrix_float_multiplier_fsm;
  signal controller_transpose_vector_product_fsm_int  : controller_transpose_vector_product_fsm;
  signal controller_third_matrix_float_adder_fsm_int  : controller_third_matrix_float_adder_fsm;

  -- Output
  signal controller_l_out_fsm_int : controller_l_out_fsm;

  -- Buffer
  -- Input
  signal matrix_l_in_int : matrix_buffer;
  signal vector_w_in_int : vector_buffer;
  signal vector_p_in_int : vector_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal matrix_l_out_int : matrix_buffer;

  -- Control Internal - Index
  -- Input
  signal index_g_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_matrix_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_matrix_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_transpose_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_transpose_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_g_l_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_l_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_l_in_enable_int : std_logic;

  signal data_w_in_enable_int : std_logic;
  signal data_p_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

  -- Ops
  signal data_first_matrix_float_adder_enable_int  : std_logic;
  signal data_second_matrix_float_adder_enable_int : std_logic;
  signal data_matrix_float_multiplier_enable_int   : std_logic;
  signal data_transpose_vector_product_enable_int  : std_logic;
  signal data_third_matrix_float_adder_enable_int  : std_logic;

  -- FLOAT MATRIX ADDER
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
  signal data_out_matrix_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FLOAT MATRIX MULTIPLIER
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
  signal data_out_matrix_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
  -- L(t=0)[g,j] = 0

  -- INPUT CONTROL
  l_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      L_OUT_G_ENABLE <= '0';
      L_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_g_l_in_loop <= ZERO_CONTROL;
      index_j_l_in_loop <= ZERO_CONTROL;

      data_l_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_l_in_fsm_int is
        when STARTER_L_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_g_l_in_loop <= ZERO_CONTROL;
            index_j_l_in_loop <= ZERO_CONTROL;

            data_l_in_enable_int <= '0';

            -- FSM Control
            controller_l_in_fsm_int <= INPUT_L_IN_G_STATE;
          else
            -- Control Outputs
            L_OUT_G_ENABLE <= '0';
            L_OUT_J_ENABLE <= '0';
          end if;

        when INPUT_L_IN_G_STATE =>      -- STEP 1

          if ((L_IN_G_ENABLE = '1') and (L_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_l_in_int(to_integer(unsigned(index_g_l_in_loop)), to_integer(unsigned(index_j_l_in_loop))) <= L_IN;

            -- FSM Control
            controller_l_in_fsm_int <= CLEAN_L_IN_J_STATE;
          end if;

          -- Control Outputs
          L_OUT_G_ENABLE <= '0';
          L_OUT_J_ENABLE <= '0';

        when INPUT_L_IN_J_STATE =>      -- STEP 2

          if (L_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_l_in_int(to_integer(unsigned(index_g_l_in_loop)), to_integer(unsigned(index_j_l_in_loop))) <= L_IN;

            -- FSM Control
            if (unsigned(index_j_l_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_l_in_fsm_int <= CLEAN_L_IN_G_STATE;
            else
              controller_l_in_fsm_int <= CLEAN_L_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          L_OUT_J_ENABLE <= '0';

        when CLEAN_L_IN_G_STATE =>      -- STEP 3

          if ((unsigned(index_g_l_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_l_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_g_l_in_loop <= ZERO_CONTROL;
            index_j_l_in_loop <= ZERO_CONTROL;

            data_l_in_enable_int <= '1';

            -- FSM Control
            controller_l_in_fsm_int <= STARTER_L_IN_STATE;
          elsif ((unsigned(index_g_l_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_l_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_g_l_in_loop <= std_logic_vector(unsigned(index_g_l_in_loop) + unsigned(ONE_CONTROL));
            index_j_l_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_l_in_fsm_int <= INPUT_L_IN_G_STATE;
          end if;

        when CLEAN_L_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_l_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_l_in_loop <= std_logic_vector(unsigned(index_j_l_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_l_in_fsm_int <= INPUT_L_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_l_in_fsm_int <= STARTER_L_IN_STATE;
      end case;
    end if;
  end process;

  in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_ENABLE <= '0';
      P_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';
      data_p_in_enable_int <= '0';

      data_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_in_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_ENABLE <= '1';
            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';
            data_p_in_enable_int <= '0';

            data_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            W_OUT_ENABLE <= '0';
            P_OUT_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (W_IN_ENABLE = '1') then
            -- Data Inputs
            vector_w_in_int(to_integer(unsigned(index_j_in_loop))) <= W_IN;

            -- Control Internal
            data_w_in_enable_int <= '1';
          end if;

          if (P_IN_ENABLE = '1') then
            -- Data Inputs
            vector_p_in_int(to_integer(unsigned(index_j_in_loop))) <= P_IN;

            -- Control Internal
            data_p_in_enable_int <= '1';
          end if;

          -- Control Outputs
          W_OUT_ENABLE <= '0';
          P_OUT_ENABLE <= '0';

          if (data_w_in_enable_int = '1' and data_p_in_enable_int = '1') then
            -- Control Internal
            data_w_in_enable_int <= '0';
            data_p_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= CLEAN_STATE;
          end if;

        when CLEAN_STATE =>             -- STEP 2

          if (unsigned(index_j_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_ENABLE <= '1';
            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= ZERO_CONTROL;

            data_in_enable_int <= '1';

            -- FSM Control
            controller_in_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_j_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_ENABLE <= '1';
            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= std_logic_vector(unsigned(index_j_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_in_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  first_matrix_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_adder <= '0';
      data_a_in_j_enable_matrix_float_adder <= '0';
      data_b_in_i_enable_matrix_float_adder <= '0';
      data_b_in_j_enable_matrix_float_adder <= '0';

      data_first_matrix_float_adder_enable_int <= '0';

      index_i_matrix_float_adder_loop <= ZERO_CONTROL;
      index_j_matrix_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_first_matrix_float_adder_fsm_int is
        when STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_adder <= '0';
          data_a_in_j_enable_matrix_float_adder <= '0';
          data_b_in_i_enable_matrix_float_adder <= '0';
          data_b_in_j_enable_matrix_float_adder <= '0';

          data_first_matrix_float_adder_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_adder <= SIZE_N_IN;
            size_j_in_matrix_float_adder <= SIZE_N_IN;

            -- Control Internal
            index_i_matrix_float_adder_loop <= ZERO_CONTROL;
            index_j_matrix_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_first_matrix_float_adder_fsm_int <= INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_adder <= '1';
          end if;

          data_a_in_i_enable_matrix_float_adder <= '1';
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_i_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          controller_first_matrix_float_adder_fsm_int <= CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE;

        when INPUT_J_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_first_matrix_float_adder_fsm_int <= CLEAN_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
          else
            controller_first_matrix_float_adder_fsm_int <= CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when CLEAN_I_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              data_first_matrix_float_adder_enable_int <= '1';

              index_i_matrix_float_adder_loop <= ZERO_CONTROL;
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_float_adder_fsm_int <= STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE;
            elsif ((unsigned(index_i_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_i_matrix_float_adder_loop <= std_logic_vector(unsigned(index_i_matrix_float_adder_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_float_adder_fsm_int <= INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_adder = '1') then
            if (unsigned(index_j_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_j_matrix_float_adder_loop <= std_logic_vector(unsigned(index_j_matrix_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_first_matrix_float_adder_fsm_int <= INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_first_matrix_float_adder_fsm_int <= STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  matrix_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_multiplier <= '0';
      data_a_in_j_enable_matrix_float_multiplier <= '0';
      data_b_in_i_enable_matrix_float_multiplier <= '0';
      data_b_in_j_enable_matrix_float_multiplier <= '0';

      data_matrix_float_multiplier_enable_int <= '0';

      index_i_matrix_float_multiplier_loop <= ZERO_CONTROL;
      index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_float_multiplier_fsm_int is
        when STARTER_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_multiplier <= '0';
          data_a_in_j_enable_matrix_float_multiplier <= '0';
          data_b_in_i_enable_matrix_float_multiplier <= '0';
          data_b_in_j_enable_matrix_float_multiplier <= '0';

          data_matrix_float_multiplier_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_multiplier <= SIZE_N_IN;
            size_j_in_matrix_float_multiplier <= SIZE_N_IN;

            -- Control Internal
            index_i_matrix_float_multiplier_loop <= ZERO_CONTROL;
            index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_float_multiplier_fsm_int <= INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE;
          end if;

        when INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));
          data_b_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_multiplier_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_multiplier_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_multiplier <= '1';
          end if;

          data_a_in_i_enable_matrix_float_multiplier <= '1';
          data_a_in_j_enable_matrix_float_multiplier <= '1';
          data_b_in_i_enable_matrix_float_multiplier <= '1';
          data_b_in_j_enable_matrix_float_multiplier <= '1';

          -- FSM Control
          controller_matrix_float_multiplier_fsm_int <= CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE;

        when INPUT_J_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));
          data_b_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_multiplier <= '1';
          data_b_in_j_enable_matrix_float_multiplier <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_float_multiplier_fsm_int <= CLEAN_I_MATRIX_FLOAT_MULTIPLIER_STATE;
          else
            controller_matrix_float_multiplier_fsm_int <= CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE;
          end if;

        when CLEAN_I_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_multiplier = '1' and data_out_i_enable_matrix_float_multiplier = '1') then
            if ((unsigned(index_i_matrix_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              data_matrix_float_multiplier_enable_int <= '1';

              index_i_matrix_float_multiplier_loop <= ZERO_CONTROL;
              index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= STARTER_MATRIX_FLOAT_MULTIPLIER_STATE;
            elsif ((unsigned(index_i_matrix_float_multiplier_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              index_i_matrix_float_multiplier_loop <= std_logic_vector(unsigned(index_i_matrix_float_multiplier_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_multiplier <= '0';

            data_a_in_i_enable_matrix_float_multiplier <= '0';
            data_a_in_j_enable_matrix_float_multiplier <= '0';
            data_b_in_i_enable_matrix_float_multiplier <= '0';
            data_b_in_j_enable_matrix_float_multiplier <= '0';
          end if;

        when CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_multiplier = '1') then
            if (unsigned(index_j_matrix_float_multiplier_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              index_j_matrix_float_multiplier_loop <= std_logic_vector(unsigned(index_j_matrix_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE;
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
          controller_matrix_float_multiplier_fsm_int <= STARTER_MATRIX_FLOAT_MULTIPLIER_STATE;
      end case;
    end if;
  end process;

  second_matrix_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_adder <= '0';
      data_a_in_j_enable_matrix_float_adder <= '0';
      data_b_in_i_enable_matrix_float_adder <= '0';
      data_b_in_j_enable_matrix_float_adder <= '0';

      data_second_matrix_float_adder_enable_int <= '0';

      index_i_matrix_float_adder_loop <= ZERO_CONTROL;
      index_j_matrix_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_second_matrix_float_adder_fsm_int is
        when STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_adder <= '0';
          data_a_in_j_enable_matrix_float_adder <= '0';
          data_b_in_i_enable_matrix_float_adder <= '0';
          data_b_in_j_enable_matrix_float_adder <= '0';

          data_second_matrix_float_adder_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_adder <= SIZE_N_IN;
            size_j_in_matrix_float_adder <= SIZE_N_IN;

            -- Control Internal
            index_i_matrix_float_adder_loop <= ZERO_CONTROL;
            index_j_matrix_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_second_matrix_float_adder_fsm_int <= INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_adder <= '1';
          end if;

          data_a_in_i_enable_matrix_float_adder <= '1';
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_i_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          controller_second_matrix_float_adder_fsm_int <= CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE;

        when INPUT_J_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_second_matrix_float_adder_fsm_int <= CLEAN_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
          else
            controller_second_matrix_float_adder_fsm_int <= CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when CLEAN_I_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              data_second_matrix_float_adder_enable_int <= '1';

              index_i_matrix_float_adder_loop <= ZERO_CONTROL;
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_float_adder_fsm_int <= STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE;
            elsif ((unsigned(index_i_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_i_matrix_float_adder_loop <= std_logic_vector(unsigned(index_i_matrix_float_adder_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_float_adder_fsm_int <= INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_adder = '1') then
            if (unsigned(index_j_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_j_matrix_float_adder_loop <= std_logic_vector(unsigned(index_j_matrix_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_second_matrix_float_adder_fsm_int <= INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_second_matrix_float_adder_fsm_int <= STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  transpose_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_transpose_vector_product <= '0';
      data_b_in_enable_transpose_vector_product <= '0';

      data_transpose_vector_product_enable_int <= '0';

      index_i_transpose_vector_product_loop <= ZERO_CONTROL;
      index_j_transpose_vector_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_transpose_vector_product_fsm_int is
        when STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_transpose_vector_product <= '0';
          data_b_in_enable_transpose_vector_product <= '0';

          data_transpose_vector_product_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_a_in_transpose_vector_product <= SIZE_N_IN;
            size_b_in_transpose_vector_product <= SIZE_N_IN;

            -- Control Internal
            index_i_transpose_vector_product_loop <= ZERO_CONTROL;
            index_j_transpose_vector_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_transpose_vector_product_fsm_int <= INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
          end if;

        when INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 1

          -- Data Inputs
          data_a_in_transpose_vector_product <= vector_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)));

          -- Control Internal
          if (unsigned(index_i_transpose_vector_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_transpose_vector_product_loop) = unsigned(ZERO_CONTROL)) then
            start_transpose_vector_product <= '1';
          end if;

          data_a_in_enable_transpose_vector_product <= '1';
          data_b_in_enable_transpose_vector_product <= '1';

          -- FSM Control
          controller_transpose_vector_product_fsm_int <= CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE;

        when INPUT_J_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 2

          -- Data Inputs
          data_a_in_transpose_vector_product <= vector_operation_int(to_integer(unsigned(index_j_transpose_vector_product_loop)));

          -- Control Internal
          data_b_in_enable_transpose_vector_product <= '1';

          -- FSM Control
          if (unsigned(index_j_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_transpose_vector_product_fsm_int <= CLEAN_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
          else
            controller_transpose_vector_product_fsm_int <= CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 3

          if (data_out_i_enable_transpose_vector_product = '1' and data_out_j_enable_transpose_vector_product = '1') then
            if ((unsigned(index_i_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)), to_integer(unsigned(index_j_transpose_vector_product_loop))) <= data_out_transpose_vector_product;

              -- Control Internal
              data_transpose_vector_product_enable_int <= '1';

              index_i_transpose_vector_product_loop <= ZERO_CONTROL;
              index_j_transpose_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_transpose_vector_product_fsm_int <= STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_transpose_vector_product_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)), to_integer(unsigned(index_j_transpose_vector_product_loop))) <= data_out_transpose_vector_product;

              -- Control Internal
              index_i_transpose_vector_product_loop <= std_logic_vector(unsigned(index_i_transpose_vector_product_loop) + unsigned(ONE_CONTROL));
              index_j_transpose_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_transpose_vector_product_fsm_int <= INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_transpose_vector_product <= '0';

            data_a_in_enable_transpose_vector_product <= '0';
            data_b_in_enable_transpose_vector_product <= '0';
          end if;

        when CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 4

          if (data_out_i_enable_transpose_vector_product = '1') then
            if (unsigned(index_j_transpose_vector_product_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)), to_integer(unsigned(index_j_transpose_vector_product_loop))) <= data_out_transpose_vector_product;

              -- Control Internal
              index_j_transpose_vector_product_loop <= std_logic_vector(unsigned(index_j_transpose_vector_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_transpose_vector_product_fsm_int <= INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_transpose_vector_product <= '0';

            data_a_in_enable_transpose_vector_product <= '0';
            data_b_in_enable_transpose_vector_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_transpose_vector_product_fsm_int <= STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

  third_matrix_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_adder <= '0';
      data_a_in_j_enable_matrix_float_adder <= '0';
      data_b_in_i_enable_matrix_float_adder <= '0';
      data_b_in_j_enable_matrix_float_adder <= '0';

      data_third_matrix_float_adder_enable_int <= '0';

      index_i_matrix_float_adder_loop <= ZERO_CONTROL;
      index_j_matrix_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_third_matrix_float_adder_fsm_int is
        when STARTER_THIRD_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_adder <= '0';
          data_a_in_j_enable_matrix_float_adder <= '0';
          data_b_in_i_enable_matrix_float_adder <= '0';
          data_b_in_j_enable_matrix_float_adder <= '0';

          data_third_matrix_float_adder_enable_int <= '0';

          if (data_w_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_adder <= SIZE_N_IN;
            size_j_in_matrix_float_adder <= SIZE_N_IN;

            -- Control Internal
            index_i_matrix_float_adder_loop <= ZERO_CONTROL;
            index_j_matrix_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_third_matrix_float_adder_fsm_int <= INPUT_I_THIRD_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when INPUT_I_THIRD_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_adder <= '1';
          end if;

          data_a_in_i_enable_matrix_float_adder <= '1';
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_i_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          controller_third_matrix_float_adder_fsm_int <= CLEAN_J_THIRD_MATRIX_FLOAT_ADDER_STATE;

        when INPUT_J_THIRD_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_third_matrix_float_adder_fsm_int <= CLEAN_I_THIRD_MATRIX_FLOAT_ADDER_STATE;
          else
            controller_third_matrix_float_adder_fsm_int <= CLEAN_J_THIRD_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when CLEAN_I_THIRD_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              data_third_matrix_float_adder_enable_int <= '1';

              index_i_matrix_float_adder_loop <= ZERO_CONTROL;
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_third_matrix_float_adder_fsm_int <= STARTER_THIRD_MATRIX_FLOAT_ADDER_STATE;
            elsif ((unsigned(index_i_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_i_matrix_float_adder_loop <= std_logic_vector(unsigned(index_i_matrix_float_adder_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_third_matrix_float_adder_fsm_int <= INPUT_I_THIRD_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when CLEAN_J_THIRD_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_adder = '1') then
            if (unsigned(index_j_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_j_matrix_float_adder_loop <= std_logic_vector(unsigned(index_j_matrix_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_third_matrix_float_adder_fsm_int <= INPUT_I_THIRD_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_third_matrix_float_adder_fsm_int <= STARTER_THIRD_MATRIX_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  l_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      L_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      L_OUT_G_ENABLE <= '0';
      L_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_g_l_out_loop <= ZERO_CONTROL;
      index_j_l_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_l_out_fsm_int is
        when STARTER_L_OUT_STATE =>     -- STEP 0
          if (data_w_in_enable_int = '1' and data_l_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_g_l_out_loop <= ZERO_CONTROL;
            index_j_l_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_l_out_fsm_int <= CLEAN_L_OUT_G_STATE;
          end if;

        when CLEAN_L_OUT_G_STATE =>     -- STEP 1
          -- Control Outputs
          L_OUT_G_ENABLE <= '0';
          L_OUT_J_ENABLE <= '0';

          -- FSM Control
          controller_l_out_fsm_int <= OUTPUT_L_OUT_J_STATE;

        when CLEAN_L_OUT_J_STATE =>     -- STEP 2

          -- Control Outputs
          L_OUT_J_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_j_l_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_l_out_fsm_int <= OUTPUT_L_OUT_G_STATE;
          else
            controller_l_out_fsm_int <= OUTPUT_L_OUT_J_STATE;
          end if;

        when OUTPUT_L_OUT_G_STATE =>    -- STEP 3

          if ((unsigned(index_g_l_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_l_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            L_OUT <= matrix_l_out_int(to_integer(unsigned(index_g_l_out_loop)), to_integer(unsigned(index_j_l_out_loop)));

            -- Control Outputs
            READY <= '1';

            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_g_l_out_loop <= ZERO_CONTROL;
            index_j_l_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_l_out_fsm_int <= STARTER_L_OUT_STATE;
          elsif ((unsigned(index_g_l_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_l_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            L_OUT <= matrix_l_out_int(to_integer(unsigned(index_g_l_out_loop)), to_integer(unsigned(index_j_l_out_loop)));

            -- Control Outputs
            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_g_l_out_loop <= std_logic_vector(unsigned(index_g_l_out_loop) + unsigned(ONE_CONTROL));
            index_j_l_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_l_out_fsm_int <= CLEAN_L_OUT_G_STATE;
          end if;

        when OUTPUT_L_OUT_J_STATE =>    -- STEP 4

          if (unsigned(index_j_l_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_l_out_loop <= std_logic_vector(unsigned(index_j_l_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_l_out_fsm_int <= CLEAN_L_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_l_out_fsm_int <= STARTER_L_OUT_STATE;
      end case;
    end if;
  end process;

  -- FLOAT MATRIX ADDER
  matrix_float_adder : ntm_matrix_float_adder
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
      DATA_OUT  => data_out_matrix_float_adder
      );

  -- FLOAT MATRIX MULTIPLIER
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
      DATA_OUT  => data_out_matrix_float_multiplier
      );

  -- TRANSPOSE VECTOR PRODUCT
  transpose_vector_product : ntm_transpose_vector_product
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

end architecture;
