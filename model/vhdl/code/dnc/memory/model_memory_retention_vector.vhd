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

entity model_memory_retention_vector is
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

    F_IN_ENABLE : in std_logic;         -- for i in 0 to R-1

    F_OUT_ENABLE : out std_logic;       -- for i in 0 to R-1

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    PSI_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    PSI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_memory_retention_vector_urchitecture of model_memory_retention_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- W_IN [R,N]
  -- F_IN [R]

  -- Outputs:
  -- PSI_OUT [N]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_f_in_fsm is (
    STARTER_F_IN_STATE,                 -- STEP 0
    INPUT_F_IN_J_STATE,                 -- STEP 1
    CLEAN_F_IN_J_STATE                  -- STEP 2
    );

  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_I_STATE,                 -- STEP 1
    INPUT_W_IN_J_STATE,                 -- STEP 2
    CLEAN_W_IN_I_STATE,                 -- STEP 3
    CLEAN_W_IN_J_STATE                  -- STEP 4
    );

  type controller_psi_out_fsm is (
    STARTER_PSI_OUT_STATE,              -- STEP 0
    CLEAN_PSI_OUT_J_STATE,              -- STEP 1
    OUTPUT_PSI_OUT_J_STATE              -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_f_in_fsm_int : controller_f_in_fsm;
  signal controller_w_in_fsm_int : controller_w_in_fsm;

  signal controller_psi_out_fsm_int : controller_psi_out_fsm;

  -- Buffer
  signal vector_f_in_int : vector_buffer;
  signal matrix_w_in_int : matrix_buffer;

  signal vector_psi_out_int : vector_buffer;

  -- Control Internal
  signal index_j_f_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_psi_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_f_in_enable_int : std_logic;
  signal data_w_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

  -- CONTROL
  u_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      F_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_f_in_loop <= ZERO_CONTROL;

      data_f_in_enable_int <= '0';
    elsif (rising_edge(CLK)) then

      case controller_f_in_fsm_int is
        when STARTER_F_IN_STATE =>      -- STEP 0
          -- Control Outputs
          F_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_j_f_in_loop <= ZERO_CONTROL;

            data_f_in_enable_int <= '0';

            -- FSM Control
            controller_f_in_fsm_int <= INPUT_F_IN_J_STATE;
          end if;

        when INPUT_F_IN_J_STATE =>      -- STEP 1

          if (F_IN_ENABLE = '1') then
            -- Data Inputs
            vector_f_in_int(to_integer(unsigned(index_j_f_in_loop))) <= F_IN;

            -- FSM Control
            controller_f_in_fsm_int <= CLEAN_F_IN_J_STATE;
          end if;

          -- Control Outputs
          F_OUT_ENABLE <= '0';

        when CLEAN_F_IN_J_STATE =>      -- STEP 2

          if (unsigned(index_j_f_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_j_f_in_loop <= ZERO_CONTROL;

            data_f_in_enable_int <= '1';

            -- FSM Control
            controller_f_in_fsm_int <= STARTER_F_IN_STATE;
          elsif (unsigned(index_j_f_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_j_f_in_loop <= std_logic_vector(unsigned(index_j_f_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_f_in_fsm_int <= INPUT_F_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_f_in_fsm_int <= STARTER_F_IN_STATE;
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

  psi_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      PSI_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      PSI_OUT_ENABLE <= '0';

      -- Control Internal
      index_j_psi_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_psi_out_fsm_int is
        when STARTER_PSI_OUT_STATE =>   -- STEP 0
          if (data_f_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Internal
            vector_psi_out_int <= function_model_memory_retention_vector (
              SIZE_R_IN => SIZE_R_IN,
              SIZE_N_IN => SIZE_N_IN,

              vector_f_input => vector_f_in_int,
              matrix_w_input => matrix_w_in_int
              );

            -- Control Internal
            index_j_psi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_psi_out_fsm_int <= CLEAN_PSI_OUT_J_STATE;
          end if;

        when CLEAN_PSI_OUT_J_STATE =>   -- STEP 1
          -- Control Outputs
          PSI_OUT_ENABLE <= '0';

          -- FSM Control
          controller_psi_out_fsm_int <= OUTPUT_PSI_OUT_J_STATE;

        when OUTPUT_PSI_OUT_J_STATE =>  -- STEP 2

          if (unsigned(index_j_psi_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            PSI_OUT <= vector_psi_out_int(to_integer(unsigned(index_j_psi_out_loop)));

            -- Control Outputs
            READY <= '1';

            PSI_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_psi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_psi_out_fsm_int <= STARTER_PSI_OUT_STATE;
          elsif (unsigned(index_j_psi_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            PSI_OUT <= vector_psi_out_int(to_integer(unsigned(index_j_psi_out_loop)));

            -- Control Outputs
            PSI_OUT_ENABLE <= '1';

            -- Control Internal
            index_j_psi_out_loop <= std_logic_vector(unsigned(index_j_psi_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_psi_out_fsm_int <= CLEAN_PSI_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_psi_out_fsm_int <= STARTER_PSI_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
