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

entity model_precedence_weighting is
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

    W_IN_ENABLE : in std_logic;         -- for j in 0 to N-1
    P_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    W_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1
    P_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    P_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_precedence_weighting_architecture of model_precedence_weighting is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [N]
  -- P_IN [N]

  -- Outputs:
  -- P_OUT [N]

  -- States:
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_in_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  type controller_p_out_fsm is (
    STARTER_P_OUT_STATE,                -- STEP 0
    CLEAN_P_OUT_J_STATE,                -- STEP 1
    OUTPUT_P_OUT_J_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_in_fsm_int : controller_in_fsm;

  signal controller_p_out_fsm_int : controller_p_out_fsm;

  -- Buffer
  signal vector_w_in_int : vector_buffer;
  signal vector_p_in_int : vector_buffer;

  signal vector_p_out_int : vector_buffer;

  -- Control Internal
  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_p_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_w_in_enable_int : std_logic;
  signal data_p_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- p(t;j) = (1 - summation(w(t;j))[j in 1 to N])·p(t-1;j) + w(t;j)
  -- p(t=0) = 0

  -- CONTROL
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

  p_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      P_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      P_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_p_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_p_out_fsm_int is
        when STARTER_P_OUT_STATE =>     -- STEP 0
          if (data_in_enable_int = '1') then
            -- Data Internal
            vector_p_out_int <= function_model_precedence_weighting (
              SIZE_N_IN => SIZE_N_IN,

              vector_w_input => vector_w_in_int,
              vector_p_input => vector_p_in_int
              );

            -- Control Internal
            index_j_p_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_out_fsm_int <= CLEAN_P_OUT_J_STATE;
          end if;

        when CLEAN_P_OUT_J_STATE =>     -- STEP 1
          -- Control Outputs
          P_OUT_ENABLE <= '0';

          -- FSM Control
          controller_p_out_fsm_int <= OUTPUT_P_OUT_J_STATE;

        when OUTPUT_P_OUT_J_STATE =>    -- STEP 2

          if (unsigned(index_j_p_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            P_OUT <= vector_p_out_int(to_integer(unsigned(index_j_p_out_loop)));

            -- Control Outputs
            READY <= '1';

            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_p_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_p_out_fsm_int <= STARTER_P_OUT_STATE;
          elsif (unsigned(index_j_p_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            P_OUT <= vector_p_out_int(to_integer(unsigned(index_j_p_out_loop)));

            -- Control Outputs
            P_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_p_out_loop <= std_logic_vector(unsigned(index_j_p_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_p_out_fsm_int <= CLEAN_P_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_p_out_fsm_int <= STARTER_P_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
