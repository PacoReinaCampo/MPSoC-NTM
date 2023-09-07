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
use work.accelerator_linear_controller_vhdl_pkg.all;

entity accelerator_trainer is
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

    X_IN_T_ENABLE : in std_logic;       -- for t in 0 to T-1
    X_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1

    X_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    X_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    B_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- DATA
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_trainer_architecture of accelerator_trainer is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_x_in_fsm is (
    STARTER_X_IN_STATE,                 -- STEP 0
    INPUT_X_IN_T_STATE,                 -- STEP 1
    INPUT_X_IN_X_STATE,                 -- STEP 2
    CLEAN_X_IN_T_STATE,                 -- STEP 3
    CLEAN_X_IN_X_STATE                  -- STEP 4
    );

  -- Ops
  type controller_differentiation_fsm is (
    STARTER_DIFFERENTIATION_STATE,      -- STEP 0
    INPUT_I_DIFFERENTIATION_STATE,      -- STEP 1
    INPUT_J_DIFFERENTIATION_STATE,      -- STEP 2
    INPUT_K_DIFFERENTIATION_STATE,      -- STEP 3
    CLEAN_I_DIFFERENTIATION_STATE,      -- STEP 4
    CLEAN_J_DIFFERENTIATION_STATE,      -- STEP 5
    CLEAN_K_DIFFERENTIATION_STATE       -- STEP 6
    );

  -- Output
  type controller_w_out_fsm is (
    STARTER_W_OUT_STATE,                -- STEP 0
    CLEAN_W_OUT_L_STATE,                -- STEP 1
    CLEAN_W_OUT_X_STATE,                -- STEP 2
    OUTPUT_W_OUT_L_STATE,               -- STEP 3
    OUTPUT_W_OUT_X_STATE                -- STEP 4
    );

  type controller_b_out_fsm is (
    STARTER_B_OUT_STATE,                -- STEP 0
    CLEAN_B_OUT_T_STATE,                -- STEP 1
    CLEAN_B_OUT_L_STATE,                -- STEP 2
    OUTPUT_B_OUT_T_STATE,               -- STEP 3
    OUTPUT_B_OUT_L_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_x_in_fsm_int : controller_x_in_fsm;

  -- Ops
  signal controller_differentiation_fsm_int : controller_differentiation_fsm;

  -- Output
  signal controller_w_out_fsm_int : controller_w_out_fsm;
  signal controller_b_out_fsm_int : controller_b_out_fsm;

  -- Buffer
  -- Input
  signal matrix_x_in_int : matrix_buffer;

  -- Ops
  signal tensor_operation_int : tensor_buffer;

  -- Output
  signal matrix_w_out_int : matrix_buffer;
  signal vector_b_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_t_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_differentiation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_differentiation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_differentiation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_l_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_x_in_enable_int : std_logic;

  -- Ops
  signal data_differentiation_enable_int : std_logic;

  -- DIFFERENTIATION
  -- CONTROL
  signal start_differentiation : std_logic;
  signal ready_differentiation : std_logic;

  signal data_in_i_enable_differentiation : std_logic;
  signal data_in_j_enable_differentiation : std_logic;
  signal data_in_k_enable_differentiation : std_logic;

  signal data_i_enable_differentiation : std_logic;
  signal data_j_enable_differentiation : std_logic;
  signal data_k_enable_differentiation : std_logic;

  signal data_out_i_enable_differentiation : std_logic;
  signal data_out_j_enable_differentiation : std_logic;

  -- DATA
  signal size_i_in_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR FLOAT ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_adder : std_logic;

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_length_enable_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_enable_length_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR FLOAT MULTIPLIER
  -- CONTROL
  signal start_scalar_float_multiplier : std_logic;
  signal ready_scalar_float_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_multiplier : std_logic;

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_enable_vector_differentiation : std_logic;

  signal data_out_enable_vector_differentiation : std_logic;

  -- DATA
  signal size_in_vector_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- INPUT CONTROL
  x_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      X_OUT_T_ENABLE <= '0';
      X_OUT_X_ENABLE <= '0';

      -- Control Internal
      index_t_x_in_loop <= ZERO_CONTROL;
      index_x_x_in_loop <= ZERO_CONTROL;

      data_x_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_x_in_fsm_int is
        when STARTER_X_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= ZERO_CONTROL;
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '0';

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_T_STATE;
          else
            -- Control Outputs
            X_OUT_T_ENABLE <= '0';
            X_OUT_X_ENABLE <= '0';
          end if;

        when INPUT_X_IN_T_STATE =>      -- STEP 1

          if ((X_IN_T_ENABLE = '1') and (X_IN_X_ENABLE = '1')) then
            -- Data Inputs
            matrix_x_in_int(to_integer(unsigned(index_t_x_in_loop)), to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            controller_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
          end if;

          -- Control Outputs
          X_OUT_T_ENABLE <= '0';
          X_OUT_X_ENABLE <= '0';

        when INPUT_X_IN_X_STATE =>      -- STEP 2

          if (X_IN_X_ENABLE = '1') then
            -- Data Inputs
            matrix_x_in_int(to_integer(unsigned(index_t_x_in_loop)), to_integer(unsigned(index_x_x_in_loop))) <= X_IN;

            -- FSM Control
            if (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              controller_x_in_fsm_int <= CLEAN_X_IN_T_STATE;
            else
              controller_x_in_fsm_int <= CLEAN_X_IN_X_STATE;
            end if;
          end if;

          -- Control Outputs
          X_OUT_X_ENABLE <= '0';

        when CLEAN_X_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_x_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= ZERO_CONTROL;
            index_x_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '1';

            -- FSM Control
            controller_x_in_fsm_int <= STARTER_X_IN_STATE;
          elsif ((unsigned(index_t_x_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_x_in_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= std_logic_vector(unsigned(index_t_x_in_loop) + unsigned(ONE_CONTROL));
            index_x_x_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_T_STATE;
          end if;

        when CLEAN_X_IN_X_STATE =>      -- STEP 4

          if (unsigned(index_x_x_in_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_x_x_in_loop <= std_logic_vector(unsigned(index_x_x_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_x_in_fsm_int <= STARTER_X_IN_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  differentiation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_i_enable_differentiation <= '0';
      data_in_j_enable_differentiation <= '0';
      data_in_k_enable_differentiation <= '0';

      data_differentiation_enable_int <= '0';

      index_i_differentiation_loop <= ZERO_CONTROL;
      index_j_differentiation_loop <= ZERO_CONTROL;
      index_k_differentiation_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_differentiation_fsm_int is
        when STARTER_DIFFERENTIATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_i_enable_differentiation <= '0';
          data_in_j_enable_differentiation <= '0';
          data_in_k_enable_differentiation <= '0';

          data_differentiation_enable_int <= '0';

          if (START = '1') then
            -- Data Inputs
            size_i_in_differentiation <= SIZE_T_IN;
            size_j_in_differentiation <= SIZE_L_IN;
            size_k_in_differentiation <= SIZE_X_IN;

            -- Control Internal
            index_i_differentiation_loop <= ZERO_CONTROL;
            index_j_differentiation_loop <= ZERO_CONTROL;
            index_k_differentiation_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_differentiation_fsm_int <= INPUT_I_DIFFERENTIATION_STATE;
          end if;

        when INPUT_I_DIFFERENTIATION_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_differentiation <= tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop)));

          -- Control Internal
          if (unsigned(index_i_differentiation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_differentiation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_differentiation_loop) = unsigned(ZERO_CONTROL)) then
            start_differentiation <= '1';
          end if;

          data_in_i_enable_differentiation <= '1';
          data_in_j_enable_differentiation <= '1';
          data_in_k_enable_differentiation <= '1';

          -- FSM Control
          controller_differentiation_fsm_int <= CLEAN_K_DIFFERENTIATION_STATE;

        when INPUT_J_DIFFERENTIATION_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_differentiation <= tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop)));

          data_in_j_enable_differentiation <= '1';
          data_in_k_enable_differentiation <= '1';

          -- FSM Control
          if (unsigned(index_k_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            controller_differentiation_fsm_int <= CLEAN_J_DIFFERENTIATION_STATE;
          else
            controller_differentiation_fsm_int <= CLEAN_K_DIFFERENTIATION_STATE;
          end if;

        when INPUT_K_DIFFERENTIATION_STATE =>  -- STEP 6

          -- Data Inputs
          data_in_differentiation <= tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop)));

          -- Control Internal
          data_in_k_enable_differentiation <= '1';

          -- FSM Control
          if ((unsigned(index_j_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            controller_differentiation_fsm_int <= CLEAN_I_DIFFERENTIATION_STATE;
          elsif (unsigned(index_k_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            controller_differentiation_fsm_int <= CLEAN_J_DIFFERENTIATION_STATE;
          else
            controller_differentiation_fsm_int <= CLEAN_K_DIFFERENTIATION_STATE;
          end if;

        when CLEAN_I_DIFFERENTIATION_STATE =>  -- STEP 7

          if (data_i_enable_differentiation = '1' and data_j_enable_differentiation = '1' and data_k_enable_differentiation = '1') then
            if ((unsigned(index_j_differentiation_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              data_differentiation_enable_int <= '1';

              index_i_differentiation_loop <= ZERO_CONTROL;
              index_j_differentiation_loop <= ZERO_CONTROL;
              index_k_differentiation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_differentiation_fsm_int <= STARTER_DIFFERENTIATION_STATE;
            elsif ((unsigned(index_j_differentiation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              index_i_differentiation_loop <= std_logic_vector(unsigned(index_i_differentiation_loop) + unsigned(ONE_CONTROL));
              index_j_differentiation_loop <= ZERO_CONTROL;
              index_k_differentiation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_differentiation_fsm_int <= INPUT_J_DIFFERENTIATION_STATE;
            end if;
          else
            -- Control Internal
            start_differentiation <= '0';

            data_in_i_enable_differentiation <= '0';
            data_in_j_enable_differentiation <= '0';
            data_in_k_enable_differentiation <= '0';
          end if;

        when CLEAN_J_DIFFERENTIATION_STATE =>  -- STEP 7

          if (data_j_enable_differentiation = '1' and data_k_enable_differentiation = '1') then
            if ((unsigned(index_j_differentiation_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_differentiation_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              index_j_differentiation_loop <= std_logic_vector(unsigned(index_j_differentiation_loop) + unsigned(ONE_CONTROL));
              index_k_differentiation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_differentiation_fsm_int <= INPUT_J_DIFFERENTIATION_STATE;
            end if;
          else
            -- Control Internal
            start_differentiation <= '0';

            data_in_i_enable_differentiation <= '0';
            data_in_j_enable_differentiation <= '0';
            data_in_k_enable_differentiation <= '0';
          end if;

        when CLEAN_K_DIFFERENTIATION_STATE =>  -- STEP 8

          if (data_k_enable_differentiation = '1') then
            if (unsigned(index_k_differentiation_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              tensor_operation_int(to_integer(unsigned(index_i_differentiation_loop)), to_integer(unsigned(index_j_differentiation_loop)), to_integer(unsigned(index_k_differentiation_loop))) <= data_out_differentiation;

              -- Control Internal
              index_k_differentiation_loop <= std_logic_vector(unsigned(index_k_differentiation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_differentiation_fsm_int <= INPUT_J_DIFFERENTIATION_STATE;
            end if;
          else
            -- Control Internal
            start_differentiation <= '0';

            data_in_i_enable_differentiation <= '0';
            data_in_j_enable_differentiation <= '0';
            data_in_k_enable_differentiation <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_differentiation_fsm_int <= STARTER_DIFFERENTIATION_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  -- dW(l;x) = summation(d*(t;l) · x(t;x))[t in 0 to T]
  w_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      W_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_L_ENABLE <= '0';
      W_OUT_X_ENABLE <= '0';

      -- Control Internal
      index_l_w_out_loop <= ZERO_CONTROL;
      index_x_w_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_w_out_fsm_int is
        when STARTER_W_OUT_STATE =>     -- STEP 0
          if (data_x_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_w_out_loop <= ZERO_CONTROL;
            index_x_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_L_STATE;
          end if;

        when CLEAN_W_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          W_OUT_L_ENABLE <= '0';
          W_OUT_X_ENABLE <= '0';

          -- FSM Control
          controller_w_out_fsm_int <= OUTPUT_W_OUT_X_STATE;

        when CLEAN_W_OUT_X_STATE =>     -- STEP 2

          -- Control Outputs
          W_OUT_X_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_x_w_out_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            controller_w_out_fsm_int <= OUTPUT_W_OUT_L_STATE;
          else
            controller_w_out_fsm_int <= OUTPUT_W_OUT_X_STATE;
          end if;

        when OUTPUT_W_OUT_L_STATE =>    -- STEP 3

          if ((unsigned(index_l_w_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_out_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_l_w_out_loop)), to_integer(unsigned(index_x_w_out_loop)));

            -- Control Outputs
            READY <= '1';

            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_out_loop <= ZERO_CONTROL;
            index_x_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
          elsif ((unsigned(index_l_w_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_x_w_out_loop) = unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_l_w_out_loop)), to_integer(unsigned(index_x_w_out_loop)));

            -- Control Outputs
            W_OUT_L_ENABLE <= '1';
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_l_w_out_loop <= std_logic_vector(unsigned(index_l_w_out_loop) + unsigned(ONE_CONTROL));
            index_x_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_L_STATE;
          end if;

        when OUTPUT_W_OUT_X_STATE =>    -- STEP 4

          if (unsigned(index_x_w_out_loop) < unsigned(SIZE_X_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_X_ENABLE <= '1';

            -- Control Internal
            index_x_w_out_loop <= std_logic_vector(unsigned(index_x_w_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_X_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
      end case;
    end if;
  end process;

  -- db(l) = summation(d*(t;l))[t in 0 to T]
  b_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      B_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      B_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_l_b_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_b_out_fsm_int is
        when STARTER_B_OUT_STATE =>     -- STEP 0
          if (data_x_in_enable_int = '1') then
            -- Control Internal

            -- Control Internal
            index_l_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_L_STATE;
          end if;

        when CLEAN_B_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          B_OUT_L_ENABLE <= '0';

          -- FSM Control
          controller_b_out_fsm_int <= OUTPUT_B_OUT_L_STATE;

        when OUTPUT_B_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_b_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            B_OUT <= vector_b_out_int(to_integer(unsigned(index_l_b_out_loop)));

            -- Control Outputs
            READY <= '1';

            B_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
          elsif (unsigned(index_l_b_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            B_OUT <= vector_b_out_int(to_integer(unsigned(index_l_b_out_loop)));

            -- Control Outputs
            B_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_b_out_loop <= std_logic_vector(unsigned(index_l_b_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
      end case;
    end if;
  end process;

  -- SCALAR ADDER
  scalar_float_adder : accelerator_scalar_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_adder,
      READY => ready_scalar_float_adder,

      OPERATION => operation_scalar_float_adder,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_adder,
      DATA_B_IN => data_b_in_scalar_float_adder,

      DATA_OUT     => data_out_scalar_float_adder,
      OVERFLOW_OUT => overflow_out_scalar_float_adder
      );

  -- SCALAR MULTIPLIER
  scalar_float_multiplier : accelerator_scalar_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_multiplier,
      READY => ready_scalar_float_multiplier,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_multiplier,
      DATA_B_IN => data_b_in_scalar_float_multiplier,

      DATA_OUT     => data_out_scalar_float_multiplier,
      OVERFLOW_OUT => overflow_out_scalar_float_multiplier
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

      DATA_IN_LENGTH_ENABLE => data_in_length_enable_vector_summation,
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

  -- VECTOR DIFFERENTIATION
  vector_differentiation : accelerator_vector_differentiation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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
      SIZE_IN   => size_in_vector_differentiation,
      LENGTH_IN => length_in_vector_differentiation,
      DATA_IN   => data_in_vector_differentiation,
      DATA_OUT  => data_out_vector_differentiation
      );

end architecture;
