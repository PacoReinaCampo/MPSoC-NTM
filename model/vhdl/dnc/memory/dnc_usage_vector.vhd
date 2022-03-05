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

entity dnc_usage_vector is
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

    U_IN_ENABLE   : in std_logic;       -- for j in 0 to N-1
    W_IN_ENABLE   : in std_logic;       -- for j in 0 to N-1
    PSI_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

    U_OUT_ENABLE   : out std_logic;     -- for j in 0 to N-1
    W_OUT_ENABLE   : out std_logic;     -- for j in 0 to N-1
    PSI_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    U_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    PSI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_usage_vector_urchitecture of dnc_usage_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Buffer
  signal vector_u_int   : vector_buffer;
  signal vector_w_int   : vector_buffer;
  signal vector_psi_int : vector_buffer;

  signal vector_out_int : vector_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_u_in_state_int   : std_logic;
  signal data_w_in_state_int   : std_logic;
  signal data_psi_in_state_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      U_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      U_OUT_ENABLE   <= '0';
      W_OUT_ENABLE   <= '0';
      PSI_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          U_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          U_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            W_OUT_ENABLE   <= '1';
            PSI_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            W_OUT_ENABLE   <= '0';
            PSI_OUT_ENABLE <= '0';
          end if;

        when INPUT_STATE =>           -- STEP 1 u,w,psi

          if (U_IN_ENABLE = '1') then
            -- Data Inputs
            vector_u_int(to_integer(unsigned(index_i_loop))) <= U_IN;

            -- Control Internal
            data_u_in_state_int <= '1';
          end if;

          if (W_IN_ENABLE = '1') then
            -- Data Inputs
            vector_w_int(to_integer(unsigned(index_i_loop))) <= W_IN;

            -- Control Internal
            data_w_in_state_int <= '1';
          end if;

          if (PSI_IN_ENABLE = '1') then
            -- Data Inputs
            vector_psi_int(to_integer(unsigned(index_i_loop))) <= PSI_IN;

            -- Control Internal
            data_psi_in_state_int <= '1';
          end if;

          -- Control Outputs
          U_OUT_ENABLE   <= '0';
          W_OUT_ENABLE   <= '0';
          PSI_OUT_ENABLE <= '0';

          if (data_u_in_state_int = '1' and data_w_in_state_int = '1' and data_psi_in_state_int = '1') then
            -- Control Internal
            data_u_in_state_int   <= '0';
            data_w_in_state_int   <= '0';
            data_psi_in_state_int <= '0';

            -- Data Internal
            vector_out_int <= function_dnc_usage_vector (
              SIZE_N_IN => SIZE_N_IN,

              vector_u_input   => vector_u_int,
              vector_w_input   => vector_w_int,
              vector_psi_input => vector_psi_int
              );
    
            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_STATE;
          end if;

        when CLEAN_STATE =>           -- STEP 2

          if (unsigned(index_i_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            U_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            READY <= '1';

            U_OUT_ENABLE   <= '1';
            W_OUT_ENABLE   <= '1';
            PSI_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_i_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            U_OUT <= vector_out_int(to_integer(unsigned(index_i_loop)));

            -- Control Outputs
            U_OUT_ENABLE   <= '1';
            W_OUT_ENABLE   <= '1';
            PSI_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;