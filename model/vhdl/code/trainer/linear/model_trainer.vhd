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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_linear_controller_pkg.all;

entity model_trainer is
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

    H_IN_T_ENABLE : in std_logic;       -- for t in 0 to T-1
    H_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    H_OUT_T_ENABLE : out std_logic;     -- for t in 0 to T-1
    H_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
    W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

    B_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    -- DATA
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_trainer_architecture of model_trainer is

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
    INPUT_X_IN_X_STATE,                 -- STEP 2
    CLEAN_X_IN_T_STATE,                 -- STEP 3
    CLEAN_X_IN_X_STATE                  -- STEP 4
    );

  type controller_h_in_fsm is (
    STARTER_H_IN_STATE,                 -- STEP 0
    INPUT_H_IN_T_STATE,                 -- STEP 1
    INPUT_H_IN_L_STATE,                 -- STEP 2
    CLEAN_H_IN_T_STATE,                 -- STEP 3
    CLEAN_H_IN_L_STATE                  -- STEP 4
    );

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
  signal controller_x_in_fsm_int : controller_x_in_fsm;
  signal controller_h_in_fsm_int : controller_h_in_fsm;

  signal controller_w_out_fsm_int : controller_w_out_fsm;
  signal controller_b_out_fsm_int : controller_b_out_fsm;

  -- Buffer
  signal matrix_x_in_int : matrix_buffer;
  signal matrix_h_in_int : matrix_buffer;

  signal matrix_w_out_int : matrix_buffer;
  signal vector_b_out_int : vector_buffer;

  -- Control Internal
  signal index_t_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_x_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_t_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_x_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_x_in_enable_int : std_logic;
  signal data_h_in_enable_int : std_logic;

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

  h_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      H_OUT_T_ENABLE <= '0';
      H_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_t_h_in_loop <= ZERO_CONTROL;
      index_l_h_in_loop <= ZERO_CONTROL;

      data_h_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_h_in_fsm_int is
        when STARTER_H_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            H_OUT_T_ENABLE <= '1';
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_h_in_loop <= ZERO_CONTROL;
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '0';

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_T_STATE;
          else
            -- Control Outputs
            H_OUT_T_ENABLE <= '0';
            H_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_H_IN_T_STATE =>      -- STEP 1

          if ((H_IN_T_ENABLE = '1') and (H_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_h_in_int(to_integer(unsigned(index_t_h_in_loop)), to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
          end if;

          -- Control Outputs
          H_OUT_T_ENABLE <= '0';
          H_OUT_L_ENABLE <= '0';

        when INPUT_H_IN_L_STATE =>      -- STEP 2

          if (H_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_h_in_int(to_integer(unsigned(index_t_h_in_loop)), to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            if (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_h_in_fsm_int <= CLEAN_H_IN_T_STATE;
            else
              controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          H_OUT_L_ENABLE <= '0';

        when CLEAN_H_IN_T_STATE =>      -- STEP 3

          if ((unsigned(index_t_h_in_loop) = unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            H_OUT_T_ENABLE <= '1';
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_h_in_loop <= ZERO_CONTROL;
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '1';

            -- FSM Control
            controller_h_in_fsm_int <= STARTER_H_IN_STATE;
          elsif ((unsigned(index_t_h_in_loop) < unsigned(SIZE_T_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            H_OUT_T_ENABLE <= '1';
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_t_h_in_loop <= std_logic_vector(unsigned(index_t_h_in_loop) + unsigned(ONE_CONTROL));
            index_l_h_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_T_STATE;
          end if;

        when CLEAN_H_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_h_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= std_logic_vector(unsigned(index_l_h_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_h_in_fsm_int <= STARTER_H_IN_STATE;
      end case;
    end if;
  end process;

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
          if (data_x_in_enable_int = '1' and data_h_in_enable_int = '1') then
            -- Data Internal
            matrix_w_out_int <= function_model_linear_w_trainer (
              SIZE_T_IN => SIZE_T_IN,
              SIZE_X_IN => SIZE_X_IN,
              SIZE_L_IN => SIZE_L_IN,

              vector_x_input => matrix_x_in_int,
              vector_h_input => matrix_h_in_int
              );

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
          if (data_h_in_enable_int = '1') then
            -- Control Internal
            vector_b_out_int <= function_model_linear_b_trainer (
              SIZE_T_IN => SIZE_T_IN,
              SIZE_L_IN => SIZE_L_IN,

              vector_h_input => matrix_h_in_int
              );

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

end architecture;
