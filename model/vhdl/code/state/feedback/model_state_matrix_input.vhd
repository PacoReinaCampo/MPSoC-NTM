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

use work.model_state_pkg.all;

entity model_state_matrix_input is
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

    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_B_I_ENABLE : out std_logic;
    DATA_B_J_ENABLE : out std_logic;
    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_B_OUT_I_ENABLE : out std_logic;
    DATA_B_OUT_J_ENABLE : out std_logic;

    -- DATA
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_state_matrix_input_architecture of model_state_matrix_input is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_b_in_fsm is (
    STARTER_B_IN_STATE,                 -- STEP 0
    INPUT_B_IN_I_STATE,                 -- STEP 1
    INPUT_B_IN_J_STATE,                 -- STEP 2
    CLEAN_B_IN_I_STATE,                 -- STEP 3
    CLEAN_B_IN_J_STATE                  -- STEP 4
    );

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

  type controller_b_out_fsm is (
    STARTER_B_OUT_STATE,                -- STEP 0
    CLEAN_B_OUT_I_STATE,                -- STEP 1
    CLEAN_B_OUT_J_STATE,                -- STEP 2
    OUTPUT_B_OUT_I_STATE,               -- STEP 3
    OUTPUT_B_OUT_J_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_b_in_fsm_int : controller_b_in_fsm;
  signal controller_d_in_fsm_int : controller_d_in_fsm;

  signal controller_k_in_fsm_int : controller_k_in_fsm;

  signal controller_b_out_fsm_int : controller_b_out_fsm;

  -- Buffer
  signal matrix_b_in_int : matrix_buffer;
  signal matrix_d_in_int : matrix_buffer;

  signal matrix_k_in_int : matrix_buffer;

  signal matrix_b_out_int : matrix_buffer;

  -- Control Internal
  signal index_i_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_b_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_d_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_k_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_b_in_enable_int : std_logic;
  signal data_d_in_enable_int : std_logic;

  signal data_k_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- b = B·(I-K·inv(I+D·K)·D)

  -- CONTROL
  b_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      DATA_B_I_ENABLE <= '0';
      DATA_B_J_ENABLE <= '0';

      -- Control Internal
      index_i_b_in_loop <= ZERO_CONTROL;
      index_j_b_in_loop <= ZERO_CONTROL;

      data_b_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_b_in_fsm_int is
        when STARTER_B_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= ZERO_CONTROL;
            index_j_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_I_STATE;
          else
            -- Control Outputs
            DATA_B_I_ENABLE <= '0';
            DATA_B_J_ENABLE <= '0';
          end if;

        when INPUT_B_IN_I_STATE =>      -- STEP 1

          if ((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_b_in_loop)), to_integer(unsigned(index_j_b_in_loop))) <= DATA_B_IN;

            -- FSM Control
            controller_b_in_fsm_int <= CLEAN_B_IN_J_STATE;
          end if;

          -- Control Outputs
          DATA_B_I_ENABLE <= '0';
          DATA_B_J_ENABLE <= '0';

        when INPUT_B_IN_J_STATE =>      -- STEP 2

          if (DATA_B_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_b_in_loop)), to_integer(unsigned(index_j_b_in_loop))) <= DATA_B_IN;

            -- FSM Control
            if (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
              controller_b_in_fsm_int <= CLEAN_B_IN_I_STATE;
            else
              controller_b_in_fsm_int <= CLEAN_B_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_B_J_ENABLE <= '0';

        when CLEAN_B_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_b_in_loop) = unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= ZERO_CONTROL;
            index_j_b_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '1';

            -- FSM Control
            controller_b_in_fsm_int <= STARTER_B_IN_STATE;
          elsif ((unsigned(index_i_b_in_loop) < unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_in_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_in_loop <= std_logic_vector(unsigned(index_i_b_in_loop) + unsigned(ONE_CONTROL));
            index_j_b_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_I_STATE;
          end if;

        when CLEAN_B_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_b_in_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_j_b_in_loop <= std_logic_vector(unsigned(index_j_b_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_in_fsm_int <= INPUT_B_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_in_fsm_int <= STARTER_B_IN_STATE;
      end case;
    end if;
  end process;

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

  c_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_B_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_B_OUT_I_ENABLE <= '0';
      DATA_B_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_b_out_loop <= ZERO_CONTROL;
      index_j_b_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_b_out_fsm_int is
        when STARTER_B_OUT_STATE =>     -- STEP 0
          if (data_b_in_enable_int = '1' and data_d_in_enable_int = '1' and data_k_in_enable_int = '1') then
            -- Data Internal
            matrix_b_out_int <= function_state_matrix_input (
              SIZE_B_I_IN => SIZE_B_I_IN,
              SIZE_B_J_IN => SIZE_B_J_IN,
              SIZE_D_I_IN => SIZE_D_I_IN,
              SIZE_D_J_IN => SIZE_D_J_IN,

              SIZE_K_I_IN => SIZE_D_J_IN,
              SIZE_K_J_IN => SIZE_D_J_IN,

              matrix_data_b_input => matrix_b_in_int,
              matrix_data_d_input => matrix_d_in_int,

              matrix_data_k_input => matrix_k_in_int
              );

            -- Control Internal
            index_i_b_out_loop <= ZERO_CONTROL;
            index_j_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_I_STATE;
          end if;

        when CLEAN_B_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          DATA_B_OUT_I_ENABLE <= '0';
          DATA_B_OUT_J_ENABLE <= '0';

          -- FSM Control
          controller_b_out_fsm_int <= OUTPUT_B_OUT_J_STATE;

        when CLEAN_B_OUT_J_STATE =>     -- STEP 2

          -- Control Outputs
          DATA_B_OUT_J_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_j_b_out_loop) = unsigned(SIZE_D_J_IN)-unsigned(ONE_CONTROL)) then
            controller_b_out_fsm_int <= OUTPUT_B_OUT_I_STATE;
          else
            controller_b_out_fsm_int <= OUTPUT_B_OUT_J_STATE;
          end if;

        when OUTPUT_B_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_b_out_loop) = unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_out_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_B_OUT <= matrix_b_out_int(to_integer(unsigned(index_i_b_out_loop)), to_integer(unsigned(index_j_b_out_loop)));

            -- Control Outputs
            READY <= '1';

            DATA_B_OUT_I_ENABLE <= '1';
            DATA_B_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_out_loop <= ZERO_CONTROL;
            index_j_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
          elsif ((unsigned(index_i_b_out_loop) < unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_out_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_B_OUT <= matrix_b_out_int(to_integer(unsigned(index_i_b_out_loop)), to_integer(unsigned(index_j_b_out_loop)));

            -- Control Outputs
            DATA_B_OUT_I_ENABLE <= '1';
            DATA_B_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_out_loop <= std_logic_vector(unsigned(index_i_b_out_loop) + unsigned(ONE_CONTROL));
            index_j_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_I_STATE;
          end if;

        when OUTPUT_B_OUT_J_STATE =>    -- STEP 4

          if (unsigned(index_j_b_out_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_B_OUT <= matrix_b_out_int(to_integer(unsigned(index_i_b_out_loop)), to_integer(unsigned(index_j_b_out_loop)));

            -- Control Outputs
            DATA_B_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_b_out_loop <= std_logic_vector(unsigned(index_j_b_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
