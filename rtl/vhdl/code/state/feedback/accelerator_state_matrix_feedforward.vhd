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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;
use work.accelerator_state_pkg.all;

entity accelerator_state_matrix_feedforward is
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

    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_D_OUT_I_ENABLE : out std_logic;
    DATA_D_OUT_J_ENABLE : out std_logic;

    -- DATA
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_state_matrix_feedforward_architecture of accelerator_state_matrix_feedforward is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_d_in_fsm is (
    STARTER_D_IN_STATE,                 -- STEP 0
    INPUT_D_IN_I_STATE,                 -- STEP 1
    INPUT_D_IN_J_STATE,                 -- STEP 2
    CLEAN_D_IN_I_STATE,                 -- STEP 3
    CLEAN_D_IN_J_STATE                  -- STEP 4
    );

  type controller_k_in_fsm is (
    STARTER_K_IN_STATE,                 -- STEP 0
    INPUT_K_IN_I_STATE,                 -- STEP 1
    INPUT_K_IN_J_STATE,                 -- STEP 2
    CLEAN_K_IN_I_STATE,                 -- STEP 3
    CLEAN_K_IN_J_STATE                  -- STEP 4
    );

  -- Ops
  type controller_first_matrix_product_fsm is (
    STARTER_FIRST_MATRIX_PRODUCT_STATE,  -- STEP 0
    INPUT_I_FIRST_MATRIX_PRODUCT_STATE,  -- STEP 1
    INPUT_J_FIRST_MATRIX_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_FIRST_MATRIX_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_FIRST_MATRIX_PRODUCT_STATE   -- STEP 4
    );

  type controller_matrix_float_adder_fsm is (
    STARTER_MATRIX_FLOAT_ADDER_STATE,   -- STEP 0
    INPUT_I_MATRIX_FLOAT_ADDER_STATE,   -- STEP 1
    INPUT_J_MATRIX_FLOAT_ADDER_STATE,   -- STEP 2
    CLEAN_I_MATRIX_FLOAT_ADDER_STATE,   -- STEP 3
    CLEAN_J_MATRIX_FLOAT_ADDER_STATE    -- STEP 4
    );

  type controller_matrix_inverse_fsm is (
    STARTER_MATRIX_INVERSE_STATE,       -- STEP 0
    INPUT_I_MATRIX_INVERSE_STATE,       -- STEP 1
    INPUT_J_MATRIX_INVERSE_STATE,       -- STEP 2
    CLEAN_I_MATRIX_INVERSE_STATE,       -- STEP 3
    CLEAN_J_MATRIX_INVERSE_STATE        -- STEP 4
    );

  type controller_second_matrix_product_fsm is (
    STARTER_SECOND_MATRIX_PRODUCT_STATE,  -- STEP 0
    INPUT_I_SECOND_MATRIX_PRODUCT_STATE,  -- STEP 1
    INPUT_J_SECOND_MATRIX_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_SECOND_MATRIX_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_SECOND_MATRIX_PRODUCT_STATE   -- STEP 4
    );

  -- Output
  type controller_d_out_fsm is (
    STARTER_D_OUT_STATE,                -- STEP 0
    CLEAN_D_OUT_I_STATE,                -- STEP 1
    CLEAN_D_OUT_J_STATE,                -- STEP 2
    OUTPUT_D_OUT_I_STATE,               -- STEP 3
    OUTPUT_D_OUT_J_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_d_in_fsm_int : controller_d_in_fsm;
  signal controller_k_in_fsm_int : controller_k_in_fsm;

  -- Ops
  signal controller_first_matrix_product_fsm_int  : controller_first_matrix_product_fsm;
  signal controller_matrix_float_adder_fsm_int    : controller_matrix_float_adder_fsm;
  signal controller_matrix_inverse_fsm_int        : controller_matrix_inverse_fsm;
  signal controller_second_matrix_product_fsm_int : controller_second_matrix_product_fsm;

  -- Output
  signal controller_d_out_fsm_int : controller_d_out_fsm;

  -- Buffer
  -- Input
  signal matrix_d_in_int : matrix_buffer;
  signal matrix_k_in_int : matrix_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;

  -- Output
  signal matrix_d_out_int : matrix_buffer;

  -- Control Internal - Index
  -- Input
  signal index_i_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_matrix_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_matrix_inverse_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_inverse_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_i_d_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_d_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_d_in_enable_int : std_logic;
  signal data_k_in_enable_int : std_logic;

  -- Ops
  signal data_first_matrix_product_enable_int  : std_logic;
  signal data_matrix_float_adder_enable_int    : std_logic;
  signal data_matrix_inverse_enable_int        : std_logic;
  signal data_second_matrix_product_enable_int : std_logic;

  -- MATRIX ADDER
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

  signal data_out_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- MATRIX INVERSE
  -- CONTROL
  signal start_matrix_inverse : std_logic;
  signal ready_matrix_inverse : std_logic;

  signal data_in_i_enable_matrix_inverse : std_logic;
  signal data_in_j_enable_matrix_inverse : std_logic;

  signal data_i_enable_matrix_inverse : std_logic;
  signal data_j_enable_matrix_inverse : std_logic;

  signal data_out_i_enable_matrix_inverse : std_logic;
  signal data_out_j_enable_matrix_inverse : std_logic;

  -- DATA
  signal size_i_in_matrix_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_inverse : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_inverse   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inverse  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- d = inv(I+D·K)·D

  -- INPUT CONTROL
  d_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_D_I_ENABLE <= '0';
      DATA_D_J_ENABLE <= '0';

      -- Control Internal
      index_i_d_in_loop <= ZERO_CONTROL;
      index_j_d_in_loop <= ZERO_CONTROL;

      data_d_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_d_in_fsm_int is
        when STARTER_D_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_j_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '0';

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          else
            -- Control Outputs
            DATA_D_I_ENABLE <= '0';
            DATA_D_J_ENABLE <= '0';
          end if;

        when INPUT_D_IN_I_STATE =>      -- STEP 1

          if ((DATA_D_IN_I_ENABLE = '1') and (DATA_D_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_j_d_in_loop))) <= DATA_D_IN;

            -- FSM Control
            controller_d_in_fsm_int <= CLEAN_D_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_D_I_ENABLE <= '0';
          DATA_D_J_ENABLE <= '0';

        when INPUT_D_IN_J_STATE =>      -- STEP 2

          if (DATA_D_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_d_in_int(to_integer(unsigned(index_i_d_in_loop)), to_integer(unsigned(index_j_d_in_loop))) <= DATA_D_IN;

            -- FSM Control
            if (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              controller_d_in_fsm_int <= CLEAN_D_IN_I_STATE;
            else
              controller_d_in_fsm_int <= CLEAN_D_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_D_J_ENABLE <= '0';

        when CLEAN_D_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_d_in_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= ZERO_CONTROL;
            index_j_d_in_loop <= ZERO_CONTROL;

            data_d_in_enable_int <= '1';

            -- FSM Control
            controller_d_in_fsm_int <= STARTER_D_IN_STATE;
          elsif ((unsigned(index_i_d_in_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_in_loop <= std_logic_vector(unsigned(index_i_d_in_loop) + unsigned(ONE_CONTROL));
            index_j_d_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_I_STATE;
          end if;

        when CLEAN_D_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_d_in_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_D_J_ENABLE <= '1';

            -- Control Internal
            index_j_d_in_loop <= std_logic_vector(unsigned(index_j_d_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_in_fsm_int <= INPUT_D_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_in_fsm_int <= STARTER_D_IN_STATE;
      end case;
    end if;
  end process;

  k_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_K_I_ENABLE <= '0';
      DATA_K_J_ENABLE <= '0';

      -- Control Internal
      index_i_k_in_loop <= ZERO_CONTROL;
      index_j_k_in_loop <= ZERO_CONTROL;

      data_k_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_in_fsm_int is
        when STARTER_K_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_j_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '0';

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          else
            -- Control Outputs
            DATA_K_I_ENABLE <= '0';
            DATA_K_J_ENABLE <= '0';
          end if;

        when INPUT_K_IN_I_STATE =>      -- STEP 1

          if ((DATA_K_IN_I_ENABLE = '1') and (DATA_K_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_j_k_in_loop))) <= DATA_K_IN;

            -- FSM Control
            controller_k_in_fsm_int <= CLEAN_K_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_K_I_ENABLE <= '0';
          DATA_K_J_ENABLE <= '0';

        when INPUT_K_IN_J_STATE =>      -- STEP 2

          if (DATA_K_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_k_in_int(to_integer(unsigned(index_i_k_in_loop)), to_integer(unsigned(index_j_k_in_loop))) <= DATA_K_IN;

            -- FSM Control
            if (unsigned(index_j_k_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              controller_k_in_fsm_int <= CLEAN_K_IN_I_STATE;
            else
              controller_k_in_fsm_int <= CLEAN_K_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_K_J_ENABLE <= '0';

        when CLEAN_K_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_k_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_k_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= ZERO_CONTROL;
            index_j_k_in_loop <= ZERO_CONTROL;

            data_k_in_enable_int <= '1';

            -- FSM Control
            controller_k_in_fsm_int <= STARTER_K_IN_STATE;
          elsif ((unsigned(index_i_k_in_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_k_in_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_k_in_loop <= std_logic_vector(unsigned(index_i_k_in_loop) + unsigned(ONE_CONTROL));
            index_j_k_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_I_STATE;
          end if;

        when CLEAN_K_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_k_in_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_j_k_in_loop <= std_logic_vector(unsigned(index_j_k_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_in_fsm_int <= INPUT_K_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_in_fsm_int <= STARTER_K_IN_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  first_matrix_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_product <= '0';
      data_a_in_j_enable_matrix_product <= '0';
      data_b_in_i_enable_matrix_product <= '0';
      data_b_in_j_enable_matrix_product <= '0';

      data_first_matrix_product_enable_int <= '0';

      index_i_matrix_product_loop <= ZERO_CONTROL;
      index_j_matrix_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_first_matrix_product_fsm_int is
        when STARTER_FIRST_MATRIX_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_product <= '0';
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= '0';
          data_b_in_j_enable_matrix_product <= '0';

          data_first_matrix_product_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_product <= SIZE_D_I_IN;
            size_a_j_in_matrix_product <= SIZE_D_J_IN;
            size_b_i_in_matrix_product <= SIZE_D_I_IN;
            size_b_j_in_matrix_product <= SIZE_D_J_IN;

            -- Control Internal
            index_i_matrix_product_loop <= ZERO_CONTROL;
            index_j_matrix_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_first_matrix_product_fsm_int <= INPUT_I_FIRST_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_I_FIRST_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_product <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));
          data_b_in_matrix_product <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_product_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_product <= '1';
          end if;

          data_a_in_i_enable_matrix_product <= '1';
          data_a_in_j_enable_matrix_product <= '1';
          data_b_in_i_enable_matrix_product <= '1';
          data_b_in_j_enable_matrix_product <= '1';

          -- FSM Control
          controller_first_matrix_product_fsm_int <= CLEAN_J_FIRST_MATRIX_PRODUCT_STATE;

        when INPUT_J_FIRST_MATRIX_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_product <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));
          data_b_in_matrix_product <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_product <= '1';
          data_b_in_j_enable_matrix_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_first_matrix_product_fsm_int <= CLEAN_I_FIRST_MATRIX_PRODUCT_STATE;
          else
            controller_first_matrix_product_fsm_int <= CLEAN_J_FIRST_MATRIX_PRODUCT_STATE;
          end if;

        when CLEAN_I_FIRST_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_product = '1' and data_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_matrix_product_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              data_first_matrix_product_enable_int <= '1';

              index_i_matrix_product_loop <= ZERO_CONTROL;
              index_j_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_product_fsm_int <= STARTER_FIRST_MATRIX_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_product_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              index_i_matrix_product_loop <= std_logic_vector(unsigned(index_i_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_product_fsm_int <= INPUT_I_FIRST_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_product <= '0';

            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when CLEAN_J_FIRST_MATRIX_PRODUCT_STATE =>  -- STEP 8

          if (data_i_enable_matrix_product = '1') then
            if (unsigned(index_j_matrix_product_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              index_j_matrix_product_loop <= std_logic_vector(unsigned(index_j_matrix_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_first_matrix_product_fsm_int <= INPUT_I_FIRST_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_product <= '0';

            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_first_matrix_product_fsm_int <= STARTER_FIRST_MATRIX_PRODUCT_STATE;
      end case;
    end if;
  end process;

  matrix_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_adder <= '0';
      data_a_in_j_enable_matrix_float_adder <= '0';
      data_b_in_i_enable_matrix_float_adder <= '0';
      data_b_in_j_enable_matrix_float_adder <= '0';

      data_matrix_float_adder_enable_int <= '0';

      index_i_matrix_float_adder_loop <= ZERO_CONTROL;
      index_j_matrix_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_float_adder_fsm_int is
        when STARTER_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_adder <= '0';
          data_a_in_j_enable_matrix_float_adder <= '0';
          data_b_in_i_enable_matrix_float_adder <= '0';
          data_b_in_j_enable_matrix_float_adder <= '0';

          data_matrix_float_adder_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_adder <= SIZE_D_I_IN;
            size_j_in_matrix_float_adder <= SIZE_D_J_IN;

            -- Control Internal
            index_i_matrix_float_adder_loop <= ZERO_CONTROL;
            index_j_matrix_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_float_adder_fsm_int <= INPUT_I_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when INPUT_I_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_adder <= '1';
          end if;

          data_a_in_i_enable_matrix_float_adder <= '1';
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_i_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          controller_matrix_float_adder_fsm_int <= CLEAN_J_MATRIX_FLOAT_ADDER_STATE;

        when INPUT_J_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_float_adder_fsm_int <= CLEAN_I_MATRIX_FLOAT_ADDER_STATE;
          else
            controller_matrix_float_adder_fsm_int <= CLEAN_J_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when CLEAN_I_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_matrix_float_adder_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              data_matrix_float_adder_enable_int <= '1';

              index_i_matrix_float_adder_loop <= ZERO_CONTROL;
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_adder_fsm_int <= STARTER_MATRIX_FLOAT_ADDER_STATE;
            elsif ((unsigned(index_i_matrix_float_adder_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_i_matrix_float_adder_loop <= std_logic_vector(unsigned(index_i_matrix_float_adder_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_adder_fsm_int <= INPUT_I_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when CLEAN_J_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_adder = '1') then
            if (unsigned(index_j_matrix_float_adder_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_j_matrix_float_adder_loop <= std_logic_vector(unsigned(index_j_matrix_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_float_adder_fsm_int <= INPUT_I_MATRIX_FLOAT_ADDER_STATE;
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
          controller_matrix_float_adder_fsm_int <= STARTER_MATRIX_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  matrix_inverse_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_i_enable_matrix_inverse <= '0';
      data_in_j_enable_matrix_inverse <= '0';

      data_matrix_inverse_enable_int <= '0';

      index_i_matrix_inverse_loop <= ZERO_CONTROL;
      index_j_matrix_inverse_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_inverse_fsm_int is
        when STARTER_MATRIX_INVERSE_STATE =>  -- STEP 0
          -- Control Internal
          data_in_i_enable_matrix_inverse <= '0';
          data_in_j_enable_matrix_inverse <= '0';

          data_matrix_inverse_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_inverse <= SIZE_D_I_IN;
            size_j_in_matrix_inverse <= SIZE_D_J_IN;

            -- Control Internal
            index_i_matrix_inverse_loop <= ZERO_CONTROL;
            index_j_matrix_inverse_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_inverse_fsm_int <= INPUT_I_MATRIX_INVERSE_STATE;
          end if;

        when INPUT_I_MATRIX_INVERSE_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_matrix_inverse <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_inverse_loop)), to_integer(unsigned(index_j_matrix_inverse_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_inverse_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_inverse_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_inverse <= '1';
          end if;

          data_in_i_enable_matrix_inverse <= '1';
          data_in_j_enable_matrix_inverse <= '1';

          -- FSM Control
          controller_matrix_inverse_fsm_int <= CLEAN_J_MATRIX_INVERSE_STATE;

        when INPUT_J_MATRIX_INVERSE_STATE =>  -- STEP 6

          -- Data Inputs
          data_in_matrix_inverse <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_inverse_loop)), to_integer(unsigned(index_j_matrix_inverse_loop)));

          -- Control Internal
          data_in_j_enable_matrix_inverse <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_inverse_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_inverse_fsm_int <= CLEAN_I_MATRIX_INVERSE_STATE;
          else
            controller_matrix_inverse_fsm_int <= CLEAN_J_MATRIX_INVERSE_STATE;
          end if;

        when CLEAN_I_MATRIX_INVERSE_STATE =>  -- STEP 7

          if (data_i_enable_matrix_inverse = '1' and data_j_enable_matrix_inverse = '1') then
            if ((unsigned(index_i_matrix_inverse_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_inverse_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_inverse_loop)), to_integer(unsigned(index_j_matrix_inverse_loop))) <= data_out_matrix_inverse;

              -- Control Internal
              data_matrix_inverse_enable_int <= '1';

              index_i_matrix_inverse_loop <= ZERO_CONTROL;
              index_j_matrix_inverse_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_inverse_fsm_int <= STARTER_MATRIX_INVERSE_STATE;
            elsif ((unsigned(index_i_matrix_inverse_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_inverse_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_inverse_loop)), to_integer(unsigned(index_j_matrix_inverse_loop))) <= data_out_matrix_inverse;

              -- Control Internal
              index_i_matrix_inverse_loop <= std_logic_vector(unsigned(index_i_matrix_inverse_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_inverse_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_inverse_fsm_int <= INPUT_I_MATRIX_INVERSE_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_inverse <= '0';

            data_in_i_enable_matrix_inverse <= '0';
            data_in_j_enable_matrix_inverse <= '0';
          end if;

        when CLEAN_J_MATRIX_INVERSE_STATE =>  -- STEP 8

          if (data_i_enable_matrix_inverse = '1') then
            if (unsigned(index_j_matrix_inverse_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_inverse_loop)), to_integer(unsigned(index_j_matrix_inverse_loop))) <= data_out_matrix_inverse;

              -- Control Internal
              index_j_matrix_inverse_loop <= std_logic_vector(unsigned(index_j_matrix_inverse_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_inverse_fsm_int <= INPUT_I_MATRIX_INVERSE_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_inverse <= '0';

            data_in_i_enable_matrix_inverse <= '0';
            data_in_j_enable_matrix_inverse <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_matrix_inverse_fsm_int <= STARTER_MATRIX_INVERSE_STATE;
      end case;
    end if;
  end process;

  second_matrix_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_product <= '0';
      data_a_in_j_enable_matrix_product <= '0';
      data_b_in_i_enable_matrix_product <= '0';
      data_b_in_j_enable_matrix_product <= '0';

      data_second_matrix_product_enable_int <= '0';

      index_i_matrix_product_loop <= ZERO_CONTROL;
      index_j_matrix_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_second_matrix_product_fsm_int is
        when STARTER_SECOND_MATRIX_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_product <= '0';
          data_a_in_j_enable_matrix_product <= '0';
          data_b_in_i_enable_matrix_product <= '0';
          data_b_in_j_enable_matrix_product <= '0';

          data_second_matrix_product_enable_int <= '0';

          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Inputs
            size_a_i_in_matrix_product <= SIZE_D_I_IN;
            size_a_j_in_matrix_product <= SIZE_D_J_IN;
            size_b_i_in_matrix_product <= SIZE_D_I_IN;
            size_b_j_in_matrix_product <= SIZE_D_J_IN;

            -- Control Internal
            index_i_matrix_product_loop <= ZERO_CONTROL;
            index_j_matrix_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_second_matrix_product_fsm_int <= INPUT_I_SECOND_MATRIX_PRODUCT_STATE;
          end if;

        when INPUT_I_SECOND_MATRIX_PRODUCT_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_product <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));
          data_b_in_matrix_product <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_product_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_product <= '1';
          end if;

          data_a_in_i_enable_matrix_product <= '1';
          data_a_in_j_enable_matrix_product <= '1';
          data_b_in_i_enable_matrix_product <= '1';
          data_b_in_j_enable_matrix_product <= '1';

          -- FSM Control
          controller_second_matrix_product_fsm_int <= CLEAN_J_SECOND_MATRIX_PRODUCT_STATE;

        when INPUT_J_SECOND_MATRIX_PRODUCT_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_product <= matrix_d_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));
          data_b_in_matrix_product <= matrix_k_in_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_product <= '1';
          data_b_in_j_enable_matrix_product <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_second_matrix_product_fsm_int <= CLEAN_I_SECOND_MATRIX_PRODUCT_STATE;
          else
            controller_second_matrix_product_fsm_int <= CLEAN_J_SECOND_MATRIX_PRODUCT_STATE;
          end if;

        when CLEAN_I_SECOND_MATRIX_PRODUCT_STATE =>  -- STEP 7

          if (data_i_enable_matrix_product = '1' and data_j_enable_matrix_product = '1') then
            if ((unsigned(index_i_matrix_product_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              data_second_matrix_product_enable_int <= '1';

              index_i_matrix_product_loop <= ZERO_CONTROL;
              index_j_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_product_fsm_int <= STARTER_SECOND_MATRIX_PRODUCT_STATE;
            elsif ((unsigned(index_i_matrix_product_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_product_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              index_i_matrix_product_loop <= std_logic_vector(unsigned(index_i_matrix_product_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_product_fsm_int <= INPUT_I_SECOND_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_product <= '0';

            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when CLEAN_J_SECOND_MATRIX_PRODUCT_STATE =>  -- STEP 8

          if (data_i_enable_matrix_product = '1') then
            if (unsigned(index_j_matrix_product_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_product_loop)), to_integer(unsigned(index_j_matrix_product_loop))) <= data_out_matrix_product;

              -- Control Internal
              index_j_matrix_product_loop <= std_logic_vector(unsigned(index_j_matrix_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_second_matrix_product_fsm_int <= INPUT_I_SECOND_MATRIX_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_product <= '0';

            data_a_in_i_enable_matrix_product <= '0';
            data_a_in_j_enable_matrix_product <= '0';
            data_b_in_i_enable_matrix_product <= '0';
            data_b_in_j_enable_matrix_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_second_matrix_product_fsm_int <= STARTER_SECOND_MATRIX_PRODUCT_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  d_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_D_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_D_OUT_I_ENABLE <= '0';
      DATA_D_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_d_out_loop <= ZERO_CONTROL;
      index_j_d_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_d_out_fsm_int is
        when STARTER_D_OUT_STATE =>     -- STEP 0
          if (data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_i_d_out_loop <= ZERO_CONTROL;
            index_j_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_I_STATE;
          end if;

        when CLEAN_D_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          DATA_D_OUT_I_ENABLE <= '0';
          DATA_D_OUT_J_ENABLE <= '0';

          -- FSM Control
          controller_d_out_fsm_int <= OUTPUT_D_OUT_J_STATE;

        when CLEAN_D_OUT_J_STATE =>     -- STEP 2

          -- Control Outputs
          DATA_D_OUT_J_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_j_d_out_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_d_out_fsm_int <= OUTPUT_D_OUT_I_STATE;
          else
            controller_d_out_fsm_int <= OUTPUT_D_OUT_J_STATE;
          end if;

        when OUTPUT_D_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_d_out_loop) = unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_out_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_D_OUT <= matrix_d_out_int(to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_j_d_out_loop)));

            -- Control Outputs
            READY <= '1';

            DATA_D_OUT_I_ENABLE <= '1';
            DATA_D_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_out_loop <= ZERO_CONTROL;
            index_j_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= STARTER_D_OUT_STATE;
          elsif ((unsigned(index_i_d_out_loop) < unsigned(SIZE_D_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_d_out_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_D_OUT <= matrix_d_out_int(to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_j_d_out_loop)));

            -- Control Outputs
            DATA_D_OUT_I_ENABLE <= '1';
            DATA_D_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_d_out_loop <= std_logic_vector(unsigned(index_i_d_out_loop) + unsigned(ONE_CONTROL));
            index_j_d_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_I_STATE;
          end if;

        when OUTPUT_D_OUT_J_STATE =>    -- STEP 4

          if (unsigned(index_j_d_out_loop) < unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_D_OUT <= matrix_d_out_int(to_integer(unsigned(index_i_d_out_loop)), to_integer(unsigned(index_j_d_out_loop)));

            -- Control Outputs
            DATA_D_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_d_out_loop <= std_logic_vector(unsigned(index_j_d_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_d_out_fsm_int <= CLEAN_D_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_d_out_fsm_int <= STARTER_D_OUT_STATE;
      end case;
    end if;
  end process;

  -- MATRIX ADDER
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

      DATA_OUT => data_out_matrix_float_adder
      );

  -- MATRIX PRODUCT
  matrix_product : accelerator_matrix_product
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

  -- MATRIX INVERSE
  matrix_inverse : accelerator_matrix_inverse
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_inverse,
      READY => ready_matrix_inverse,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverse,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverse,

      DATA_I_ENABLE => data_i_enable_matrix_inverse,
      DATA_J_ENABLE => data_j_enable_matrix_inverse,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverse,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverse,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_inverse,
      SIZE_J_IN => size_j_in_matrix_inverse,
      DATA_IN   => data_in_matrix_inverse,
      DATA_OUT  => data_out_matrix_inverse
      );

end architecture;
