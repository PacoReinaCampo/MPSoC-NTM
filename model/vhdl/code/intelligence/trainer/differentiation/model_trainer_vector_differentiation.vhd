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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;
use work.model_pnn_controller_vhdl_pkg.all;

entity model_trainer_vector_differentiation is
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
    X_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    X_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    X_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    Y_OUT_T_ENABLE : out std_logic;     -- for l in 0 to T-1
    Y_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- DATA
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_trainer_vector_differentiation_architecture of model_trainer_vector_differentiation is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_x_in_fsm is (
    STARTER_X_IN_STATE,                 -- STEP 0
    INPUT_X_IN_T_STATE,                 -- STEP 1
    INPUT_X_IN_L_STATE,                 -- STEP 2
    CLEAN_X_IN_T_STATE,                 -- STEP 3
    CLEAN_X_IN_L_STATE                  -- STEP 4
    );

  type controller_y_out_fsm is (
    STARTER_Y_OUT_STATE,                -- STEP 0
    CLEAN_Y_OUT_T_STATE,                -- STEP 1
    CLEAN_Y_OUT_L_STATE,                -- STEP 2
    OUTPUT_Y_OUT_T_STATE,               -- STEP 3
    OUTPUT_Y_OUT_L_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_x_in_fsm_int : controller_x_in_fsm;

  signal controller_y_out_fsm_int : controller_y_out_fsm;

  -- Buffer
  signal matrix_x_in_int : matrix_buffer;

  signal matrix_y_out_int : matrix_buffer;

  -- Control Internal
  signal index_t_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_y_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_y_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_x_in_enable_int : std_logic;

  signal data_y_out_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- CONTROL
  x_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      X_OUT_T_ENABLE <= '0';
      X_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_t_x_in_loop <= ZERO_CONTROL;
      index_l_x_in_loop <= ZERO_CONTROL;

      data_x_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_x_in_fsm_int is
        when STARTER_X_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= ZERO_CONTROL;
            index_l_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '0';

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_T_STATE;
          else
            -- Control Outputs
            X_OUT_T_ENABLE <= '0';
            X_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_X_IN_T_STATE =>      -- STEP 1

          if ((X_IN_T_ENABLE = '1') and (X_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_x_in_int(to_integer(unsigned(index_t_x_in_loop)), to_integer(unsigned(index_l_x_in_loop))) <= X_IN;

            -- FSM Control
            controller_x_in_fsm_int <= CLEAN_X_IN_L_STATE;
          end if;

          -- Control Outputs
          X_OUT_T_ENABLE <= '0';
          X_OUT_L_ENABLE <= '0';

        when INPUT_X_IN_L_STATE =>      -- STEP 2

          if (X_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_x_in_int(to_integer(unsigned(index_t_x_in_loop)), to_integer(unsigned(index_l_x_in_loop))) <= X_IN;

            -- FSM Control
            if (unsigned(index_l_x_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_x_in_fsm_int <= CLEAN_X_IN_T_STATE;
            else
              controller_x_in_fsm_int <= CLEAN_X_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          X_OUT_L_ENABLE <= '0';

        when CLEAN_X_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_x_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_x_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= ZERO_CONTROL;
            index_l_x_in_loop <= ZERO_CONTROL;

            data_x_in_enable_int <= '1';

            -- FSM Control
            controller_x_in_fsm_int <= STARTER_X_IN_STATE;
          elsif ((unsigned(index_t_x_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_x_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            X_OUT_T_ENABLE <= '1';
            X_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_x_in_loop <= std_logic_vector(unsigned(index_t_x_in_loop) + unsigned(ONE_CONTROL));
            index_l_x_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_T_STATE;
          end if;

        when CLEAN_X_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_x_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            X_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_x_in_loop <= std_logic_vector(unsigned(index_l_x_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_x_in_fsm_int <= INPUT_X_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_x_in_fsm_int <= STARTER_X_IN_STATE;
      end case;
    end if;
  end process;

  y_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      Y_OUT_T_ENABLE <= '0';
      Y_OUT_L_ENABLE <= '0';

      -- Control Internal
      data_y_out_enable_int <= '0';

      index_t_y_out_loop <= ZERO_CONTROL;
      index_l_y_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_y_out_fsm_int is
        when STARTER_Y_OUT_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Internal
            index_t_y_out_loop <= ZERO_CONTROL;
            index_l_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_T_STATE;
          end if;

          -- Control Outputs
          READY <= '0';

          Y_OUT_T_ENABLE <= '0';
          Y_OUT_L_ENABLE <= '0';

        when CLEAN_Y_OUT_T_STATE =>     -- STEP 1
          if (index_t_y_out_loop = ZERO_CONTROL and index_l_y_out_loop = ZERO_CONTROL) then
            if (data_x_in_enable_int = '1') then
              -- Data Internal
              matrix_y_out_int <= function_trainer_vector_differentiation (
                SIZE_T_IN => SIZE_T_IN,
                SIZE_L_IN => SIZE_L_IN,

                LENGTH_IN => LENGTH_IN,

                vector_input => matrix_x_in_int
                );

              -- Control Internal
              data_y_out_enable_int <= '0';

              index_t_y_out_loop <= ZERO_CONTROL;
              index_l_y_out_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_y_out_fsm_int <= OUTPUT_Y_OUT_L_STATE;
            end if;
          else
            -- FSM Control
            controller_y_out_fsm_int <= OUTPUT_Y_OUT_L_STATE;
          end if;

          -- Control Outputs
          Y_OUT_T_ENABLE <= '0';
          Y_OUT_L_ENABLE <= '0';

        when CLEAN_Y_OUT_L_STATE =>     -- STEP 2

          -- Control Outputs
          Y_OUT_L_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_l_y_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            controller_y_out_fsm_int <= OUTPUT_Y_OUT_T_STATE;
          else
            controller_y_out_fsm_int <= OUTPUT_Y_OUT_L_STATE;
          end if;

        when OUTPUT_Y_OUT_T_STATE =>    -- STEP 3

          if ((unsigned(index_t_y_out_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_y_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            Y_OUT <= matrix_y_out_int(to_integer(unsigned(index_t_y_out_loop)), to_integer(unsigned(index_l_y_out_loop)));

            -- Control Outputs
            READY <= '1';

            Y_OUT_T_ENABLE <= '1';
            Y_OUT_L_ENABLE <= '1';

            -- Control Internal
            data_y_out_enable_int <= '1';

            index_t_y_out_loop <= ZERO_CONTROL;
            index_l_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
          elsif ((unsigned(index_t_y_out_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_y_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            Y_OUT <= matrix_y_out_int(to_integer(unsigned(index_t_y_out_loop)), to_integer(unsigned(index_l_y_out_loop)));

            -- Control Outputs
            Y_OUT_T_ENABLE <= '1';
            Y_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_y_out_loop <= std_logic_vector(unsigned(index_t_y_out_loop) + unsigned(ONE_CONTROL));
            index_l_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_T_STATE;
          end if;

        when OUTPUT_Y_OUT_L_STATE =>    -- STEP 4

          if (unsigned(index_l_y_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= matrix_y_out_int(to_integer(unsigned(index_t_y_out_loop)), to_integer(unsigned(index_l_y_out_loop)));

            -- Control Outputs
            Y_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_y_out_loop <= std_logic_vector(unsigned(index_l_y_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
