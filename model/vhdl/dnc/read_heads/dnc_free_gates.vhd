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

entity dnc_free_gates is
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

    F_IN_ENABLE : in std_logic;      -- for i in 0 to R-1

    F_OUT_ENABLE : out std_logic;    -- for i in 0 to R-1

    -- DATA
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_free_gates_urchitecture of dnc_free_gates is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- RHO_IN [R,M]

  -- Outputs:
  -- F_OUT [R]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type free_gates_inout_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_IN_STATE,                     -- STEP 2
    CLEAN_OUT_STATE,                    -- STEP 3
    OUTPUT_STATE                        -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal free_gates_inout_fsm_int : free_gates_inout_fsm;

  -- Buffer
  signal matrix_rho_int : matrix_buffer;

  signal vector_in_int : vector_buffer;

  signal vector_out_int : vector_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- f(t;i) = sigmoid(f^(t;i))

  -- CONTROL
  inout_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      F_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      F_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case free_gates_inout_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          F_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          F_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            free_gates_inout_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (F_IN_ENABLE = '1') then
            -- Data Inputs
            vector_in_int(to_integer(unsigned(index_i_loop))) <= F_IN;

            -- FSM Control
            free_gates_inout_fsm_int <= CLEAN_IN_STATE;
          end if;

          -- Control Outputs
          F_OUT_ENABLE <= '0';

        when CLEAN_IN_STATE =>          -- STEP 2

          if (unsigned(index_i_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Data Internal
            vector_out_int <= function_dnc_free_gates (
              SIZE_M_IN => SIZE_M_IN,
              SIZE_R_IN => SIZE_R_IN,

              matrix_rho_input => matrix_rho_int
              );

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            free_gates_inout_fsm_int <= CLEAN_OUT_STATE;
          elsif (unsigned(index_i_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            free_gates_inout_fsm_int <= INPUT_STATE;
          end if;

        when CLEAN_OUT_STATE =>         -- STEP 3

          -- Control Outputs
          F_OUT_ENABLE <= '0';

          -- FSM Control
          free_gates_inout_fsm_int <= OUTPUT_STATE;
          
        when OUTPUT_STATE =>            -- STEP 4

          if (unsigned(index_i_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            READY <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            free_gates_inout_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            free_gates_inout_fsm_int <= CLEAN_OUT_STATE;
          end if;

          -- Data Outputs
          F_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

          -- Control Outputs
          F_OUT_ENABLE <= '1';

        when others =>
          -- FSM Control
          free_gates_inout_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;