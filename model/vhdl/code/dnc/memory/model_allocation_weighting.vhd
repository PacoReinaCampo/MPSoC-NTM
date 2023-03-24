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

entity model_allocation_weighting is
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

    U_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    U_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    A_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_allocation_weighting_urchitecture of model_allocation_weighting is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- U_IN [N]

  -- Outputs:
  -- A_OUT [N]

  -- States:
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_u_in_fsm is (
    STARTER_U_IN_STATE,                 -- STEP 0
    INPUT_U_IN_J_STATE,                 -- STEP 1
    CLEAN_U_IN_J_STATE                  -- STEP 2
    );

  type controller_a_out_fsm is (
    STARTER_A_OUT_STATE,                -- STEP 0
    CLEAN_A_OUT_J_STATE,                -- STEP 1
    OUTPUT_A_OUT_J_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_u_in_fsm_int : controller_u_in_fsm;

  signal controller_a_out_fsm_int : controller_a_out_fsm;

  -- Buffer
  signal vector_u_in_int : vector_buffer;

  signal vector_a_out_int : vector_buffer;

  -- Control Internal
  signal index_j_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_a_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_u_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]

  -- CONTROL
  u_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      U_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_u_in_loop <= ZERO_CONTROL;

      data_u_in_enable_int <= '0';
    elsif (rising_edge(CLK)) then

      case controller_u_in_fsm_int is
        when STARTER_U_IN_STATE =>      -- STEP 0
          -- Control Outputs
          U_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_j_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '0';

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_J_STATE;
          end if;

        when INPUT_U_IN_J_STATE =>      -- STEP 1

          if (U_IN_ENABLE = '1') then
            -- Data Inputs
            vector_u_in_int(to_integer(unsigned(index_j_u_in_loop))) <= U_IN;

            -- FSM Control
            controller_u_in_fsm_int <= CLEAN_U_IN_J_STATE;
          end if;

          -- Control Outputs
          U_OUT_ENABLE <= '0';

        when CLEAN_U_IN_J_STATE =>      -- STEP 2

          if (unsigned(index_j_u_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Internal
            vector_a_out_int <= function_model_allocation_weighting (
              SIZE_N_IN => SIZE_N_IN,

              vector_u_input => vector_u_in_int
              );

            -- Control Internal
            index_j_u_in_loop <= ZERO_CONTROL;

            data_u_in_enable_int <= '1';

            -- FSM Control
            controller_u_in_fsm_int <= STARTER_U_IN_STATE;
          elsif (unsigned(index_j_u_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_j_u_in_loop <= std_logic_vector(unsigned(index_j_u_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_u_in_fsm_int <= INPUT_U_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_u_in_fsm_int <= STARTER_U_IN_STATE;
      end case;
    end if;
  end process;

  a_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      A_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      A_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_a_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_a_out_fsm_int is
        when STARTER_A_OUT_STATE =>     -- STEP 0
          if (data_u_in_enable_int = '1') then
            -- Control Internal
            index_j_a_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_a_out_fsm_int <= CLEAN_A_OUT_J_STATE;
          end if;

        when CLEAN_A_OUT_J_STATE =>     -- STEP 1
          -- Control Outputs
          A_OUT_ENABLE <= '0';

          -- FSM Control
          controller_a_out_fsm_int <= OUTPUT_A_OUT_J_STATE;

        when OUTPUT_A_OUT_J_STATE =>    -- STEP 2

          if (unsigned(index_j_a_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            A_OUT <= vector_a_out_int(to_integer(unsigned(index_j_a_out_loop)));

            -- Control Outputs
            READY <= '1';

            A_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_a_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_a_out_fsm_int <= STARTER_A_OUT_STATE;
          elsif (unsigned(index_j_a_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            A_OUT <= vector_a_out_int(to_integer(unsigned(index_j_a_out_loop)));

            -- Control Outputs
            A_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_a_out_loop <= std_logic_vector(unsigned(index_j_a_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_a_out_fsm_int <= CLEAN_A_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_a_out_fsm_int <= STARTER_A_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
