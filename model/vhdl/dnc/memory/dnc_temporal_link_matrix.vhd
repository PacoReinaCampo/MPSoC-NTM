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
use work.dnc_core_pkg.all;

entity dnc_temporal_link_matrix is
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

    W_IN_ENABLE : in std_logic;         -- for j in 0 to N-1
    P_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    W_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1
    P_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    L_OUT_G_ENABLE : out std_logic;     -- for g in 0 to N-1 (square matrix)
    L_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1 (square matrix)

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    L_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_temporal_link_matrix_architecture of dnc_temporal_link_matrix is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    CLEAN_I_STATE,                      -- STEP 3
    CLEAN_J_STATE                       -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Buffer
  signal matrix_l_int : matrix_buffer;
  signal vector_w_int : vector_buffer;
  signal vector_p_int : vector_buffer;

  signal matrix_out_int : matrix_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_l_in_i_int : std_logic;
  signal data_l_in_j_int : std_logic;
  signal data_w_in_int         : std_logic;
  signal data_p_in_int         : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]

  -- L(t=0)[g,j] = 0

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      L_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      L_OUT_G_ENABLE <= '0';
      L_OUT_J_ENABLE <= '0';

      W_OUT_ENABLE <= '0';
      P_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          L_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          L_OUT_G_ENABLE <= '0';
          L_OUT_J_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            W_OUT_ENABLE <= '0';
            P_OUT_ENABLE <= '0';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_I_STATE;
          else
            -- Control Outputs
            W_OUT_ENABLE <= '0';
            P_OUT_ENABLE <= '0';
          end if;

        when INPUT_I_STATE =>           -- STEP 1 L,w,p

          if ((L_IN_G_ENABLE = '1') and (L_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_l_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= L_IN;

            -- Control Internal
            data_l_in_i_int <= '1';
            data_l_in_j_int <= '1';
          end if;

          if (W_IN_ENABLE = '1') then
            -- Data Inputs
            vector_w_int(to_integer(unsigned(index_i_loop))) <= W_IN;

            -- Control Internal
            data_w_in_int <= '1';
          end if;

          if (P_IN_ENABLE = '1') then
            -- Data Inputs
            vector_p_int(to_integer(unsigned(index_i_loop))) <= P_IN;

            -- Control Internal
            data_p_in_int <= '1';
          end if;

          -- Control Outputs
          L_OUT_G_ENABLE <= '0';
          L_OUT_J_ENABLE <= '0';

          W_OUT_ENABLE <= '0';
          P_OUT_ENABLE <= '0';

          if (data_l_in_i_int = '1' and data_l_in_j_int = '1' and data_w_in_int = '1' and data_p_in_int = '1') then
            -- Control Internal
            data_l_in_i_int <= '0';
            data_l_in_j_int <= '0';
            data_w_in_int         <= '0';
            data_p_in_int         <= '0';

            -- Data Internal
            matrix_out_int <= function_dnc_temporal_link_matrix (
              SIZE_N_IN => SIZE_N_IN,

              matrix_l_input => matrix_l_int,
              vector_w_input => vector_w_int,
              vector_p_input => vector_p_int
              );

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_J_STATE;
          end if;

        when INPUT_J_STATE =>           -- STEP 2 L,w,p

          if (L_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_l_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= L_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_I_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          L_OUT_J_ENABLE <= '0';

        when CLEAN_I_STATE =>           -- STEP 3

          if ((unsigned(index_i_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            L_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            READY <= '1';

            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            W_OUT_ENABLE <= '1';
            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            L_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            L_OUT_G_ENABLE <= '1';
            L_OUT_J_ENABLE <= '1';

            W_OUT_ENABLE <= '1';
            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when CLEAN_J_STATE =>           -- STEP 4

          if (unsigned(index_j_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then  -- Data Outputs
            -- Data Outputs
            L_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            L_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
