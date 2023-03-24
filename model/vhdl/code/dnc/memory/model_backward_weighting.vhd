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

entity model_backward_weighting is
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

    L_IN_G_ENABLE : in std_logic;       -- for g in 0 to N-1 (square tensor)
    L_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1 (square tensor)

    L_OUT_G_ENABLE : out std_logic;     -- for g in 0 to N-1 (square tensor)
    L_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1 (square tensor)

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    B_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    B_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_backward_weighting_architecture of model_backward_weighting is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [R,N]
  -- L_IN [N,N]

  -- Outputs:
  -- B_OUT [R,N]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
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

  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_I_STATE,                 -- STEP 1
    INPUT_W_IN_J_STATE,                 -- STEP 2
    CLEAN_W_IN_I_STATE,                 -- STEP 3
    CLEAN_W_IN_J_STATE                  -- STEP 4
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
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_l_in_fsm_int : controller_l_in_fsm;

  signal controller_b_out_fsm_int : controller_b_out_fsm;

  -- Buffer
  signal matrix_w_in_int : matrix_buffer;
  signal matrix_l_in_int : matrix_buffer;

  signal matrix_b_out_int : matrix_buffer;

  -- Control Internal
  signal index_g_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_b_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_l_in_enable_int : std_logic;
  signal data_w_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

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

  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_I_ENABLE <= '0';
      W_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_w_in_loop <= ZERO_CONTROL;
      index_j_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= ZERO_CONTROL;
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_I_STATE;
          else
            -- Control Outputs
            W_OUT_I_ENABLE <= '0';
            W_OUT_J_ENABLE <= '0';
          end if;

        when INPUT_W_IN_I_STATE =>      -- STEP 1

          if ((W_IN_I_ENABLE = '1') and (W_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_i_w_in_loop)), to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
          end if;

          -- Control Outputs
          W_OUT_I_ENABLE <= '0';
          W_OUT_J_ENABLE <= '0';

        when INPUT_W_IN_J_STATE =>      -- STEP 2

          if (W_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_i_w_in_loop)), to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_I_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

        when CLEAN_W_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_w_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= ZERO_CONTROL;
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_i_w_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= std_logic_vector(unsigned(index_i_w_in_loop) + unsigned(ONE_CONTROL));
            index_j_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_I_STATE;
          end if;

        when CLEAN_W_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_w_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_w_in_loop <= std_logic_vector(unsigned(index_j_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_in_fsm_int <= STARTER_W_IN_STATE;
      end case;
    end if;
  end process;

  b_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      B_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      B_OUT_I_ENABLE <= '0';
      B_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_b_out_loop <= ZERO_CONTROL;
      index_j_b_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_b_out_fsm_int is
        when STARTER_B_OUT_STATE =>     -- STEP 0
          if (data_w_in_enable_int = '1' and data_l_in_enable_int = '1') then
            -- Data Internal
            matrix_b_out_int <= function_model_backward_weighting (
              SIZE_R_IN => SIZE_R_IN,
              SIZE_N_IN => SIZE_N_IN,

              matrix_l_input => matrix_l_in_int,
              matrix_w_input => matrix_w_in_int
              );

            -- Control Internal
            index_i_b_out_loop <= ZERO_CONTROL;
            index_j_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_I_STATE;
          end if;

        when CLEAN_B_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          B_OUT_I_ENABLE <= '0';
          B_OUT_J_ENABLE <= '0';

          -- FSM Control
          controller_b_out_fsm_int <= OUTPUT_B_OUT_J_STATE;

        when CLEAN_B_OUT_J_STATE =>     -- STEP 2

          -- Control Outputs
          B_OUT_J_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_j_b_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_b_out_fsm_int <= OUTPUT_B_OUT_I_STATE;
          else
            controller_b_out_fsm_int <= OUTPUT_B_OUT_J_STATE;
          end if;

        when OUTPUT_B_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_b_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            B_OUT <= matrix_b_out_int(to_integer(unsigned(index_i_b_out_loop)), to_integer(unsigned(index_j_b_out_loop)));

            -- Control Outputs
            READY <= '1';

            B_OUT_I_ENABLE <= '1';
            B_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_out_loop <= ZERO_CONTROL;
            index_j_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= STARTER_B_OUT_STATE;
          elsif ((unsigned(index_i_b_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_b_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            B_OUT <= matrix_b_out_int(to_integer(unsigned(index_i_b_out_loop)), to_integer(unsigned(index_j_b_out_loop)));

            -- Control Outputs
            B_OUT_I_ENABLE <= '1';
            B_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_b_out_loop <= std_logic_vector(unsigned(index_i_b_out_loop) + unsigned(ONE_CONTROL));
            index_j_b_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_b_out_fsm_int <= CLEAN_B_OUT_I_STATE;
          end if;

        when OUTPUT_B_OUT_J_STATE =>    -- STEP 4

          if (unsigned(index_j_b_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_J_ENABLE <= '1';

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
