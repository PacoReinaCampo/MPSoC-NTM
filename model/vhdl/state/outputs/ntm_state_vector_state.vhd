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

use work.ntm_state_pkg.all;

entity ntm_state_vector_state is
  generic (
    DATA_SIZE    : integer := 32;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_C_IN_I_ENABLE : in std_logic;
    DATA_C_IN_J_ENABLE : in std_logic;
    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_A_I_ENABLE : out std_logic;
    DATA_A_J_ENABLE : out std_logic;
    DATA_B_I_ENABLE : out std_logic;
    DATA_B_J_ENABLE : out std_logic;
    DATA_C_I_ENABLE : out std_logic;
    DATA_C_J_ENABLE : out std_logic;
    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_U_IN_ENABLE : in std_logic;

    DATA_U_ENABLE : out std_logic;

    DATA_X_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_state_vector_state_architecture of ntm_state_vector_state is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type state_ctrl_fsm is (
    STARTER_STATE,             -- STEP 0
    INPUT_FIRST_I_STATE,       -- STEP 1
    INPUT_FIRST_J_STATE,       -- STEP 2
    CLEAN_FIRST_I_STATE,       -- STEP 3
    CLEAN_FIRST_J_STATE,       -- STEP 4
    INPUT_SECOND_I_STATE,      -- STEP 5
    INPUT_SECOND_J_STATE,      -- STEP 6
    CLEAN_SECOND_I_STATE,      -- STEP 7
    CLEAN_SECOND_J_STATE,      -- STEP 8
    INPUT_THIRD_I_STATE,       -- STEP 9
    INPUT_THIRD_J_STATE,       -- STEP 10
    CLEAN_THIRD_I_STATE,       -- STEP 11
    CLEAN_THIRD_J_STATE        -- STEP 12
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal state_ctrl_fsm_int : state_ctrl_fsm;

  -- Buffer
  signal matrix_a_int : matrix_buffer;
  signal matrix_b_int : matrix_buffer;
  signal matrix_c_int : matrix_buffer;
  signal matrix_d_int : matrix_buffer;
  signal matrix_k_int : matrix_buffer;

  signal vector_u_int : vector_buffer;

  signal vector_out_int : vector_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_b_in_i_state_int : std_logic;
  signal data_b_in_j_state_int : std_logic;

  signal data_u_in_state_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- x(k+1) = A·x(k) + B·u(k)
  -- y(k) = C·x(k) + D·u(k)

  -- x(k) = exp(A,k)·x(0) + summation(exp(A,k-j-1)·B·u(j))[j in 0 to k-1]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_X_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_A_I_ENABLE <= '1';
      DATA_A_J_ENABLE <= '1';
      DATA_B_I_ENABLE <= '1';
      DATA_B_J_ENABLE <= '1';
      DATA_C_I_ENABLE <= '1';
      DATA_C_J_ENABLE <= '1';
      DATA_D_I_ENABLE <= '1';
      DATA_D_J_ENABLE <= '1';

      DATA_K_I_ENABLE <= '1';
      DATA_K_J_ENABLE <= '1';

      DATA_X_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case state_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_X_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          else
            -- Control Outputs
            DATA_A_I_ENABLE <= '0';
            DATA_A_J_ENABLE <= '0';
            DATA_B_I_ENABLE <= '0';
            DATA_B_J_ENABLE <= '0';
            DATA_C_I_ENABLE <= '0';
            DATA_C_J_ENABLE <= '0';
            DATA_D_I_ENABLE <= '0';
            DATA_D_J_ENABLE <= '0';

            DATA_K_I_ENABLE <= '0';
            DATA_K_J_ENABLE <= '0';
          end if;

        when INPUT_FIRST_I_STATE =>  -- STEP 1 A

          if ((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_A_IN;

            -- FSM Control
            state_ctrl_fsm_int <= CLEAN_FIRST_J_STATE;
          end if;

          -- Control Outputs
          DATA_A_I_ENABLE <= '0';
          DATA_A_J_ENABLE <= '0';

        when INPUT_FIRST_J_STATE =>  -- STEP 2 A

          if (DATA_A_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_A_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
              state_ctrl_fsm_int <= CLEAN_FIRST_I_STATE;
            else
              state_ctrl_fsm_int <= CLEAN_FIRST_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_A_J_ENABLE <= '0';

        when CLEAN_FIRST_I_STATE =>  -- STEP 3

          if ((unsigned(index_i_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          end if;

        when CLEAN_FIRST_J_STATE =>  -- STEP 4

          if (unsigned(index_j_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_A_J_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_FIRST_J_STATE;
          end if;

        when INPUT_SECOND_I_STATE =>  -- STEP 5 C

          if ((DATA_C_IN_I_ENABLE = '1') and (DATA_C_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_c_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_C_IN;

            -- FSM Control
            state_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

          -- Control Outputs
          DATA_C_I_ENABLE <= '0';
          DATA_C_J_ENABLE <= '0';

        when INPUT_SECOND_J_STATE =>  -- STEP 6 C

          if (DATA_C_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_c_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_C_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL)) then
              state_ctrl_fsm_int <= CLEAN_SECOND_I_STATE;
            else
              state_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_C_J_ENABLE <= '0';

        when CLEAN_SECOND_I_STATE =>  -- STEP 7

          if ((unsigned(index_i_loop) = unsigned(SIZE_C_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_C_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          end if;

          -- Control Outputs
          DATA_C_J_ENABLE <= '0';

        when CLEAN_SECOND_J_STATE =>  -- STEP 8

          if (DATA_C_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_c_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_C_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_C_J_IN)-unsigned(ONE_CONTROL)) then
              state_ctrl_fsm_int <= CLEAN_SECOND_I_STATE;
            else
              state_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
            end if;
          end if;

        when INPUT_THIRD_I_STATE =>  -- STEP 9 B, u

          if ((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_b_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_B_IN;

            -- Control Internal
            data_b_in_i_state_int <= '1';
            data_b_in_j_state_int <= '1';
          end if;

          if (DATA_U_IN_ENABLE = '1') then
            -- Data Inputs
            vector_u_int(to_integer(unsigned(index_i_loop))) <= DATA_U_IN;

            -- Control Internal
            data_u_in_state_int <= '1';
          end if;

          -- Control Outputs
          DATA_B_I_ENABLE <= '0';
          DATA_B_J_ENABLE <= '0';

          DATA_U_ENABLE <= '0';

          if (data_b_in_i_state_int = '1' and data_b_in_j_state_int = '1' and data_u_in_state_int = '1') then
            -- Control Internal
            data_b_in_i_state_int <= '0';
            data_b_in_j_state_int <= '0';

            data_u_in_state_int <= '0';

            -- FSM Control
            state_ctrl_fsm_int <= CLEAN_THIRD_J_STATE;
          end if;

        when INPUT_THIRD_J_STATE =>  -- STEP 10 B

          if (DATA_B_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_b_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_B_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
              state_ctrl_fsm_int <= CLEAN_THIRD_I_STATE;
            else
              state_ctrl_fsm_int <= CLEAN_THIRD_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_B_J_ENABLE <= '0';

        when CLEAN_THIRD_I_STATE =>  -- STEP 11

          if ((unsigned(index_i_loop) = unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_X_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            READY <= '1';

            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            DATA_X_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_B_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_X_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';

            DATA_X_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          end if;

        when CLEAN_THIRD_J_STATE =>  -- STEP 12

          if (unsigned(index_j_loop) < unsigned(SIZE_B_J_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            DATA_B_J_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            state_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
          end if;

        when others =>
          -- FSM Control
          state_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;