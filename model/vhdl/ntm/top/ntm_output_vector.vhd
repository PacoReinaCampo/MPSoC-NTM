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

entity ntm_output_vector is
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

    P_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    P_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    P_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    P_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    P_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    P_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    R_IN_K_ENABLE : in std_logic;       -- for j in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    R_OUT_K_ENABLE : out std_logic;     -- for j in 0 to W-1

    Q_IN_Y_ENABLE : in std_logic;       -- for y in 0 to Y-1
    Q_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1

    Q_OUT_Y_ENABLE : out std_logic;     -- for y in 0 to Y-1
    Q_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1

    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    Y_OUT_ENABLE : out std_logic;       -- for y in 0 to Y-1

    -- DATA
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_output_vector_architecture of ntm_output_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_I_STATE,                -- STEP 1
    INPUT_FIRST_J_STATE,                -- STEP 2
    CLEAN_FIRST_I_STATE,                -- STEP 3
    CLEAN_FIRST_J_STATE,                -- STEP 4
    INPUT_SECOND_I_STATE,               -- STEP 5
    INPUT_SECOND_J_STATE,               -- STEP 6
    CLEAN_SECOND_I_STATE,               -- STEP 7
    CLEAN_SECOND_J_STATE,               -- STEP 8
    INPUT_THIRD_I_STATE,                -- STEP 9
    INPUT_THIRD_J_STATE,                -- STEP 10
    INPUT_THIRD_K_STATE,                -- STEP 11
    CLEAN_THIRD_I_STATE,                -- STEP 12
    CLEAN_THIRD_J_STATE,                -- STEP 13
    CLEAN_THIRD_K_STATE,                -- STEP 14
    INPUT_FOURTH_STATE,                 -- STEP 15
    CLEAN_FOURTH_STATE                  -- STEP 16
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Buffer
  signal tensor_p_int : tensor_buffer;
  signal matrix_r_int : matrix_buffer;
  signal matrix_q_int : matrix_buffer;
  signal vector_h_int : vector_buffer;

  signal vector_out_int : vector_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_m_in_i_int : std_logic;
  signal data_m_in_j_int : std_logic;
  signal data_u_in_i_int : std_logic;
  signal data_u_in_j_int : std_logic;
  signal data_v_in_i_int : std_logic;
  signal data_v_in_j_int : std_logic;
  signal data_w_in_int   : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      P_OUT_I_ENABLE <= '0';
      P_OUT_Y_ENABLE <= '0';
      P_OUT_K_ENABLE <= '0';

      Q_OUT_Y_ENABLE <= '0';
      Q_OUT_L_ENABLE <= '0';

      H_OUT_ENABLE <= '0';

      Y_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          Y_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          Y_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          else
            -- Control Outputs
            R_OUT_I_ENABLE <= '0';
            R_OUT_K_ENABLE <= '0';

            P_OUT_I_ENABLE <= '0';
            P_OUT_Y_ENABLE <= '0';
            P_OUT_K_ENABLE <= '0';

            Q_OUT_Y_ENABLE <= '0';
            Q_OUT_L_ENABLE <= '0';

            H_OUT_ENABLE <= '0';
          end if;

        when INPUT_FIRST_I_STATE =>     -- STEP 1 R

          if ((R_IN_I_ENABLE = '1') and (R_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_r_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= R_IN;

            -- Control Internal
            controller_ctrl_fsm_int <= CLEAN_FIRST_J_STATE;
          end if;

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

        when INPUT_FIRST_J_STATE =>     -- STEP 2 R

          if (R_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_r_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= R_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_FIRST_I_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_FIRST_J_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

        when CLEAN_FIRST_I_STATE =>     -- STEP 3

          if ((unsigned(index_i_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          end if;

        when CLEAN_FIRST_J_STATE =>     -- STEP 4

          if (unsigned(index_j_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_J_STATE;
          end if;

        when INPUT_SECOND_I_STATE =>    -- STEP 5 U

          if ((Q_IN_Y_ENABLE = '1') and (Q_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_q_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= Q_IN;

            -- Control Internal
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

          -- Control Outputs
          Q_OUT_Y_ENABLE <= '0';
          Q_OUT_L_ENABLE <= '0';

        when INPUT_SECOND_J_STATE =>    -- STEP 6 U

          if (Q_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_q_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= Q_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_SECOND_I_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
            end if;
          end if;

          -- Control Outputs
          Q_OUT_L_ENABLE <= '0';

        when CLEAN_SECOND_I_STATE =>    -- STEP 7

          if ((unsigned(index_i_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          end if;

        when CLEAN_SECOND_J_STATE =>    -- STEP 8

          if (unsigned(index_j_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
          end if;

        when INPUT_THIRD_I_STATE =>     -- STEP 9 K

          if ((P_IN_I_ENABLE = '1') and (P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= P_IN;

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_THIRD_K_STATE;
          end if;

          -- Control Outputs
          P_OUT_I_ENABLE <= '0';
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_THIRD_J_STATE =>     -- STEP 10 K

          if ((P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= P_IN;

            -- FSM Control
            if (unsigned(index_k_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_THIRD_J_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_THIRD_K_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_I_ENABLE <= '0';
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_THIRD_K_STATE =>     -- STEP 11 K

          if (P_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_p_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= P_IN;

            -- FSM Control
            if ((unsigned(index_j_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_ctrl_fsm_int <= CLEAN_THIRD_I_STATE;
            elsif (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_THIRD_J_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_THIRD_K_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_I_ENABLE <= '0';
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when CLEAN_THIRD_I_STATE =>     -- STEP 12

          if ((unsigned(index_i_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_FOURTH_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop)+unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          end if;

        when CLEAN_THIRD_J_STATE =>     -- STEP 13

          if ((unsigned(index_j_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop)+unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_J_STATE;
          end if;

        when CLEAN_THIRD_K_STATE =>     -- STEP 14

          if (unsigned(index_k_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_loop <= std_logic_vector(unsigned(index_k_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_K_STATE;
          end if;

        when INPUT_FOURTH_STATE =>      -- STEP 15 h

          if (H_IN_ENABLE = '1') then
            -- Data Inputs
            vector_h_int(to_integer(unsigned(index_i_loop))) <= H_IN;

            -- Data Internal
            vector_out_int <= function_ntm_output_vector (
              SIZE_Y_IN => SIZE_Y_IN,
              SIZE_L_IN => SIZE_L_IN,
              SIZE_W_IN => SIZE_W_IN,
              SIZE_R_IN => SIZE_R_IN,

              tensor_p_input => tensor_p_int,
              matrix_r_input => matrix_r_int,

              matrix_q_input => matrix_q_int,
              vector_h_input => vector_h_int
              );

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_FOURTH_STATE;
          end if;

          -- Control Outputs
          Y_OUT_ENABLE <= '0';
          H_OUT_ENABLE <= '0';

        when CLEAN_FOURTH_STATE =>      -- STEP 16

          if (unsigned(index_i_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            READY <= '1';

            Y_OUT_ENABLE <= '1';
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_i_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            Y_OUT_ENABLE <= '1';
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FOURTH_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
