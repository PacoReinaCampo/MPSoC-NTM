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

entity model_sort_vector is
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

    PHI_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    PHI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_sort_vector_urchitecture of model_sort_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- U_IN [N]

  -- Outputs:
  -- PHI_OUT [N]

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

  type controller_phi_out_fsm is (
    STARTER_PHI_OUT_STATE,              -- STEP 0
    CLEAN_PHI_OUT_J_STATE,              -- STEP 1
    OUTPUT_PHI_OUT_J_STATE              -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_u_in_fsm_int : controller_u_in_fsm;

  signal controller_phi_out_fsm_int : controller_phi_out_fsm;

  -- Buffer
  signal vector_u_in_int : vector_buffer;

  signal vector_phi_out_int : vector_buffer;

  -- Control Internal
  signal index_j_u_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_phi_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_u_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- psi(t;j) = sort(u(t;j))

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
            vector_phi_out_int <= function_model_sort_vector (
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

  phi_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      PHI_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      PHI_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_phi_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_phi_out_fsm_int is
        when STARTER_PHI_OUT_STATE =>   -- STEP 0
          if (data_u_in_enable_int = '1') then
            -- Control Internal
            index_j_phi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_phi_out_fsm_int <= CLEAN_PHI_OUT_J_STATE;
          end if;

        when CLEAN_PHI_OUT_J_STATE =>   -- STEP 1
          -- Control Outputs
          PHI_OUT_ENABLE <= '0';

          -- FSM Control
          controller_phi_out_fsm_int <= OUTPUT_PHI_OUT_J_STATE;

        when OUTPUT_PHI_OUT_J_STATE =>  -- STEP 2

          if (unsigned(index_j_phi_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            PHI_OUT <= vector_phi_out_int(to_integer(unsigned(index_j_phi_out_loop)));

            -- Control Outputs
            READY <= '1';

            PHI_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_phi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_phi_out_fsm_int <= STARTER_PHI_OUT_STATE;
          elsif (unsigned(index_j_phi_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            PHI_OUT <= vector_phi_out_int(to_integer(unsigned(index_j_phi_out_loop)));

            -- Control Outputs
            PHI_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_phi_out_loop <= std_logic_vector(unsigned(index_j_phi_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_phi_out_fsm_int <= CLEAN_PHI_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_phi_out_fsm_int <= STARTER_PHI_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
