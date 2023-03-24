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
use work.model_dnc_core_pkg.all;

entity model_temporal_link_matrix is
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

    L_OUT_G_ENABLE : out std_logic;     -- for g in 0 to N-1 (square matrix)
    L_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1 (square matrix)

    W_IN_ENABLE : in std_logic;         -- for j in 0 to N-1
    P_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    W_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1
    P_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    L_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_temporal_link_matrix_architecture of model_temporal_link_matrix is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

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

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
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

  type controller_l_out_fsm is (
    STARTER_L_OUT_STATE,                -- STEP 0
    CLEAN_L_OUT_G_STATE,                -- STEP 1
    CLEAN_L_OUT_J_STATE,                -- STEP 2
    OUTPUT_L_OUT_G_STATE,               -- STEP 3
    OUTPUT_L_OUT_J_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_l_in_fsm_int : controller_l_in_fsm;

  signal controller_in_fsm_int : controller_in_fsm;

  signal controller_l_out_fsm_int : controller_l_out_fsm;

  -- Buffer
  signal matrix_l_in_int : matrix_buffer;
  signal vector_w_in_int : vector_buffer;
  signal vector_p_in_int : vector_buffer;

  signal matrix_l_out_int : matrix_buffer;

  -- Control Internal
  signal index_g_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_g_l_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_l_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_l_in_enable_int : std_logic;

  signal data_w_in_enable_int : std_logic;
  signal data_p_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
  -- L(t=0)[g,j] = 0

  -- CONTROL
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
            matrix_l_out_int <= function_model_temporal_link_matrix (
              SIZE_N_IN => SIZE_N_IN,

              matrix_l_input => matrix_l_in_int,
              vector_w_input => vector_w_in_int,
              vector_p_input => vector_p_in_int
              );

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

end architecture;
