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
use work.model_ntm_core_vhdl_pkg.all;

entity model_output_vector is
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

architecture model_output_vector_architecture of model_output_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- P_IN [R,Y,W], R_IN [Y,L]
  -- Q_IN [Y,L],   H_IN [L]

  -- Outputs:
  -- Y_OUT [Y]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_Y_STATE, CLEAN_IN_Y_STATE
  -- INPUT_L_STATE, CLEAN_IN_L_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_Y_STATE, CLEAN_OUT_Y_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_p_in_fsm is (
    STARTER_P_IN_STATE,                 -- STEP 0
    INPUT_P_IN_I_STATE,                 -- STEP 1
    INPUT_P_IN_Y_STATE,                 -- STEP 2
    INPUT_P_IN_K_STATE,                 -- STEP 3
    CLEAN_P_IN_I_STATE,                 -- STEP 4
    CLEAN_P_IN_Y_STATE,                 -- STEP 5
    CLEAN_P_IN_K_STATE                  -- STEP 6
    );

  type controller_r_in_fsm is (
    STARTER_R_IN_STATE,                 -- STEP 0
    INPUT_R_IN_I_STATE,                 -- STEP 1
    INPUT_R_IN_K_STATE,                 -- STEP 2
    CLEAN_R_IN_I_STATE,                 -- STEP 3
    CLEAN_R_IN_K_STATE                  -- STEP 4
    );

  type controller_q_in_fsm is (
    STARTER_Q_IN_STATE,                 -- STEP 0
    INPUT_Q_IN_Y_STATE,                 -- STEP 1
    INPUT_Q_IN_L_STATE,                 -- STEP 2
    CLEAN_Q_IN_Y_STATE,                 -- STEP 3
    CLEAN_Q_IN_L_STATE                  -- STEP 4
    );

  type controller_h_in_fsm is (
    STARTER_H_IN_STATE,                 -- STEP 0
    INPUT_H_IN_L_STATE,                 -- STEP 1
    CLEAN_H_IN_L_STATE                  -- STEP 2
    );

  type controller_y_out_fsm is (
    STARTER_Y_OUT_STATE,                -- STEP 0
    CLEAN_Y_OUT_Y_STATE,                -- STEP 1
    OUTPUT_Y_OUT_Y_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_p_in_fsm_int : controller_p_in_fsm;
  signal controller_r_in_fsm_int : controller_r_in_fsm;
  signal controller_q_in_fsm_int : controller_q_in_fsm;
  signal controller_h_in_fsm_int : controller_h_in_fsm;

  signal controller_y_out_fsm_int : controller_y_out_fsm;

  -- Buffer
  signal tensor_p_in_int : tensor_buffer;
  signal matrix_r_in_int : matrix_buffer;
  signal matrix_q_in_int : matrix_buffer;
  signal vector_h_in_int : vector_buffer;

  signal vector_y_out_int : vector_buffer;

  -- Control Internal
  signal index_i_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_y_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_p_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_y_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_q_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_h_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_y_y_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_p_in_enable_int : std_logic;
  signal data_r_in_enable_int : std_logic;
  signal data_q_in_enable_int : std_logic;
  signal data_h_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)

  -- CONTROL
  p_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      P_OUT_I_ENABLE <= '0';
      P_OUT_Y_ENABLE <= '0';
      P_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_p_in_loop <= ZERO_CONTROL;
      index_y_p_in_loop <= ZERO_CONTROL;
      index_k_p_in_loop <= ZERO_CONTROL;

      data_p_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_p_in_fsm_int is
        when STARTER_P_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= ZERO_CONTROL;
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            data_p_in_enable_int <= '0';

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_Y_STATE;
          else
            -- Control Outputs
            P_OUT_I_ENABLE <= '0';
            P_OUT_Y_ENABLE <= '0';
            P_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_P_IN_I_STATE =>      -- STEP 1

          if ((P_IN_I_ENABLE = '1') and (P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
          end if;

          -- Control Outputs
          P_OUT_I_ENABLE <= '0';
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_P_IN_Y_STATE =>      -- STEP 2

          if ((P_IN_Y_ENABLE = '1') and (P_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            if (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
            else
              controller_p_in_fsm_int <= CLEAN_P_IN_Y_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_Y_ENABLE <= '0';
          P_OUT_K_ENABLE <= '0';

        when INPUT_P_IN_K_STATE =>      -- STEP 3

          if (P_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_p_in_int(to_integer(unsigned(index_i_p_in_loop)), to_integer(unsigned(index_y_p_in_loop)), to_integer(unsigned(index_k_p_in_loop))) <= P_IN;

            -- FSM Control
            if ((unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              controller_p_in_fsm_int <= CLEAN_P_IN_I_STATE;
            elsif (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_p_in_fsm_int <= CLEAN_P_IN_Y_STATE;
            else
              controller_p_in_fsm_int <= CLEAN_P_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          P_OUT_K_ENABLE <= '0';

        when CLEAN_P_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_p_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= ZERO_CONTROL;
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            data_p_in_enable_int <= '1';

            -- FSM Control
            controller_p_in_fsm_int <= STARTER_P_IN_STATE;
          elsif ((unsigned(index_i_p_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_y_p_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_I_ENABLE <= '1';
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_p_in_loop <= std_logic_vector(unsigned(index_i_p_in_loop) + unsigned(ONE_CONTROL));
            index_y_p_in_loop <= ZERO_CONTROL;
            index_k_p_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_I_STATE;
          end if;

        when CLEAN_P_IN_Y_STATE =>      -- STEP 3

          if ((unsigned(index_y_p_in_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_p_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            P_OUT_Y_ENABLE <= '1';
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_y_p_in_loop <= std_logic_vector(unsigned(index_y_p_in_loop) + unsigned(ONE_CONTROL));
            index_k_p_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_Y_STATE;
          end if;

        when CLEAN_P_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_p_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            P_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_p_in_loop <= std_logic_vector(unsigned(index_k_p_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_p_in_fsm_int <= INPUT_P_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_p_in_fsm_int <= STARTER_P_IN_STATE;
      end case;
    end if;
  end process;

  r_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_r_in_loop <= ZERO_CONTROL;
      index_k_r_in_loop <= ZERO_CONTROL;

      data_r_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_r_in_fsm_int is
        when STARTER_R_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '0';

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          else
            -- Control Outputs
            R_OUT_I_ENABLE <= '0';
            R_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_R_IN_I_STATE =>      -- STEP 1

          if ((R_IN_I_ENABLE = '1') and (R_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_r_in_int(to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
          end if;

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

        when INPUT_R_IN_K_STATE =>      -- STEP 2

          if (R_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_r_in_int(to_integer(unsigned(index_i_r_in_loop)), to_integer(unsigned(index_k_r_in_loop))) <= R_IN;

            -- FSM Control
            if (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_r_in_fsm_int <= CLEAN_R_IN_I_STATE;
            else
              controller_r_in_fsm_int <= CLEAN_R_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

        when CLEAN_R_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_r_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= ZERO_CONTROL;
            index_k_r_in_loop <= ZERO_CONTROL;

            data_r_in_enable_int <= '1';

            -- FSM Control
            controller_r_in_fsm_int <= STARTER_R_IN_STATE;
          elsif ((unsigned(index_i_r_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_in_loop <= std_logic_vector(unsigned(index_i_r_in_loop) + unsigned(ONE_CONTROL));
            index_k_r_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_I_STATE;
          end if;

        when CLEAN_R_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_r_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_in_loop <= std_logic_vector(unsigned(index_k_r_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_r_in_fsm_int <= INPUT_R_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_r_in_fsm_int <= STARTER_R_IN_STATE;
      end case;
    end if;
  end process;

  q_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      Q_OUT_Y_ENABLE <= '0';
      Q_OUT_L_ENABLE <= '0';

      -- Control Internal
      index_y_q_in_loop <= ZERO_CONTROL;
      index_l_q_in_loop <= ZERO_CONTROL;

      data_q_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_q_in_fsm_int is
        when STARTER_Q_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= ZERO_CONTROL;
            index_l_q_in_loop <= ZERO_CONTROL;

            data_q_in_enable_int <= '0';

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_Y_STATE;
          else
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '0';
            Q_OUT_L_ENABLE <= '0';
          end if;

        when INPUT_Q_IN_Y_STATE =>      -- STEP 1

          if ((Q_IN_Y_ENABLE = '1') and (Q_IN_L_ENABLE = '1')) then
            -- Data Inputs
            matrix_q_in_int(to_integer(unsigned(index_y_q_in_loop)), to_integer(unsigned(index_l_q_in_loop))) <= Q_IN;

            -- FSM Control
            controller_q_in_fsm_int <= CLEAN_Q_IN_L_STATE;
          end if;

          -- Control Outputs
          Q_OUT_Y_ENABLE <= '0';
          Q_OUT_L_ENABLE <= '0';

        when INPUT_Q_IN_L_STATE =>      -- STEP 2

          if (Q_IN_L_ENABLE = '1') then
            -- Data Inputs
            matrix_q_in_int(to_integer(unsigned(index_y_q_in_loop)), to_integer(unsigned(index_l_q_in_loop))) <= Q_IN;

            -- FSM Control
            if (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              controller_q_in_fsm_int <= CLEAN_Q_IN_Y_STATE;
            else
              controller_q_in_fsm_int <= CLEAN_Q_IN_L_STATE;
            end if;
          end if;

          -- Control Outputs
          Q_OUT_L_ENABLE <= '0';

        when CLEAN_Q_IN_Y_STATE =>      -- STEP 3

          if ((unsigned(index_y_q_in_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= ZERO_CONTROL;
            index_l_q_in_loop <= ZERO_CONTROL;

            data_q_in_enable_int <= '1';

            -- FSM Control
            controller_q_in_fsm_int <= STARTER_Q_IN_STATE;
          elsif ((unsigned(index_y_q_in_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_q_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            Q_OUT_Y_ENABLE <= '1';
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_y_q_in_loop <= std_logic_vector(unsigned(index_y_q_in_loop) + unsigned(ONE_CONTROL));
            index_l_q_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_Y_STATE;
          end if;

        when CLEAN_Q_IN_L_STATE =>      -- STEP 4

          if (unsigned(index_l_q_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            Q_OUT_L_ENABLE <= '1';

            -- Control Internal
            index_l_q_in_loop <= std_logic_vector(unsigned(index_l_q_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_q_in_fsm_int <= INPUT_Q_IN_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_q_in_fsm_int <= STARTER_Q_IN_STATE;
      end case;
    end if;
  end process;

  h_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_in_loop <= ZERO_CONTROL;

      data_h_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_h_in_fsm_int is
        when STARTER_H_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '0';

            -- FSM Control
            controller_h_in_fsm_int <= INPUT_H_IN_L_STATE;
          else
            -- Control Outputs
            H_OUT_ENABLE <= '0';
          end if;

        when INPUT_H_IN_L_STATE =>      -- STEP 1

          if (H_IN_ENABLE = '1') then
            -- Data Inputs
            vector_h_in_int(to_integer(unsigned(index_l_h_in_loop))) <= H_IN;

            -- FSM Control
            controller_h_in_fsm_int <= CLEAN_H_IN_L_STATE;
          end if;

          -- Control Outputs
          H_OUT_ENABLE <= '0';

        when CLEAN_H_IN_L_STATE =>      -- STEP 2

          if (unsigned(index_l_h_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_in_loop <= ZERO_CONTROL;

            data_h_in_enable_int <= '1';

            -- FSM Control
            controller_h_in_fsm_int <= STARTER_H_IN_STATE;
          elsif (unsigned(index_l_h_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            H_OUT_ENABLE <= '1';

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

  y_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      Y_OUT_ENABLE <= '0';

      -- Control Internal
      index_y_y_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_y_out_fsm_int is
        when STARTER_Y_OUT_STATE =>     -- STEP 0
          if (data_p_in_enable_int = '1' and data_r_in_enable_int = '1' and data_q_in_enable_int = '1' and data_h_in_enable_int = '1') then
            -- Control Internal
            vector_y_out_int <= function_model_output_vector (
              SIZE_Y_IN => SIZE_Y_IN,
              SIZE_L_IN => SIZE_L_IN,
              SIZE_W_IN => SIZE_W_IN,
              SIZE_R_IN => SIZE_R_IN,

              tensor_p_input => tensor_p_in_int,
              matrix_r_input => matrix_r_in_int,

              matrix_q_input => matrix_q_in_int,
              vector_h_input => vector_h_in_int
              );

            -- Control Internal
            index_y_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_Y_STATE;
          end if;

        when CLEAN_Y_OUT_Y_STATE =>     -- STEP 1
          -- Control Outputs
          Y_OUT_ENABLE <= '0';

          -- FSM Control
          controller_y_out_fsm_int <= OUTPUT_Y_OUT_Y_STATE;

        when OUTPUT_Y_OUT_Y_STATE =>    -- STEP 2

          if (unsigned(index_y_y_out_loop) = unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_y_out_int(to_integer(unsigned(index_y_y_out_loop)));

            -- Control Outputs
            READY <= '1';

            Y_OUT_ENABLE <= '1';

            -- Control Internal
            index_y_y_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
          elsif (unsigned(index_y_y_out_loop) < unsigned(SIZE_Y_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            Y_OUT <= vector_y_out_int(to_integer(unsigned(index_y_y_out_loop)));

            -- Control Outputs
            Y_OUT_ENABLE <= '1';

            -- Control Internal
            index_y_y_out_loop <= std_logic_vector(unsigned(index_y_y_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_y_out_fsm_int <= CLEAN_Y_OUT_Y_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_y_out_fsm_int <= STARTER_Y_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
