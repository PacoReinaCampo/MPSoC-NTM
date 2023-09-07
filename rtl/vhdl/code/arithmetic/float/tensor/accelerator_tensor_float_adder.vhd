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

use work.accelerator_arithmetic_vhdl_pkg.all;

entity accelerator_tensor_float_adder is
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

    OPERATION : in std_logic;

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_A_IN_K_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_B_IN_K_ENABLE : in std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;
    DATA_OUT_K_ENABLE : out std_logic;

    -- DATA
    SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
    OVERFLOW_OUT : out std_logic
    );
end entity;

architecture accelerator_tensor_float_adder_architecture of accelerator_tensor_float_adder is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type adder_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    INPUT_K_STATE,                      -- STEP 3
    ENDER_I_STATE,                      -- STEP 4
    ENDER_J_STATE,                      -- STEP 5
    ENDER_K_STATE                       -- STEP 6
    );

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal adder_ctrl_fsm_int : adder_ctrl_fsm;

  -- Data Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_float_adder_int : std_logic;
  signal data_a_in_j_float_adder_int : std_logic;
  signal data_a_in_k_float_adder_int : std_logic;
  signal data_b_in_i_float_adder_int : std_logic;
  signal data_b_in_j_float_adder_int : std_logic;
  signal data_b_in_k_float_adder_int : std_logic;

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_adder : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN ± DATA_B_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT     <= ZERO_DATA;
      OVERFLOW_OUT <= '0';

      -- Control Outputs
      READY <= '0';

      DATA_OUT_I_ENABLE <= '0';
      DATA_OUT_J_ENABLE <= '0';
      DATA_OUT_K_ENABLE <= '0';

      -- Control Internal
      start_scalar_float_adder <= '0';

      operation_scalar_float_adder <= '0';

      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;
      index_k_loop <= ZERO_CONTROL;

      data_a_in_i_float_adder_int <= '0';
      data_a_in_j_float_adder_int <= '0';
      data_a_in_k_float_adder_int <= '0';
      data_b_in_i_float_adder_int <= '0';
      data_b_in_j_float_adder_int <= '0';
      data_b_in_k_float_adder_int <= '0';

      -- Data Internal
      data_a_in_scalar_float_adder <= ZERO_DATA;
      data_b_in_scalar_float_adder <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case adder_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_OUT_I_ENABLE <= '1';
            DATA_OUT_J_ENABLE <= '1';
            DATA_OUT_K_ENABLE <= '1';

            -- Assignations
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            adder_ctrl_fsm_int <= INPUT_I_STATE;
          else
            -- Control Outputs
            DATA_OUT_I_ENABLE <= '0';
            DATA_OUT_J_ENABLE <= '0';
            DATA_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_I_STATE =>           -- STEP 1

          if ((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1') and (DATA_A_IN_K_ENABLE = '1')) then
            -- Data Inputs
            data_a_in_scalar_float_adder <= DATA_A_IN;

            -- Control Internal
            data_a_in_i_float_adder_int <= '1';
            data_a_in_j_float_adder_int <= '1';
            data_a_in_k_float_adder_int <= '1';
          end if;

          if ((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1') and (DATA_B_IN_K_ENABLE = '1')) then
            -- Data Inputs
            data_b_in_scalar_float_adder <= DATA_B_IN;

            -- Control Internal
            data_b_in_i_float_adder_int <= '1';
            data_b_in_j_float_adder_int <= '1';
            data_b_in_k_float_adder_int <= '1';
          end if;

          -- Control Outputs
          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          if (data_a_in_i_float_adder_int = '1' and data_a_in_j_float_adder_int = '1' and data_a_in_k_float_adder_int = '1' and data_b_in_i_float_adder_int = '1' and data_b_in_j_float_adder_int = '1' and data_b_in_k_float_adder_int = '1') then
            -- Control Internal
            start_scalar_float_adder <= '1';

            operation_scalar_float_adder <= OPERATION;

            data_a_in_i_float_adder_int <= '0';
            data_a_in_j_float_adder_int <= '0';
            data_a_in_k_float_adder_int <= '0';
            data_b_in_i_float_adder_int <= '0';
            data_b_in_j_float_adder_int <= '0';
            data_b_in_k_float_adder_int <= '0';

            -- FSM Control
            if ((unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL))) then
              adder_ctrl_fsm_int <= ENDER_I_STATE;
            elsif (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)) then
              adder_ctrl_fsm_int <= ENDER_J_STATE;
            else
              adder_ctrl_fsm_int <= ENDER_K_STATE;
            end if;
          end if;

        when INPUT_J_STATE =>           -- STEP 2

          if ((DATA_A_IN_J_ENABLE = '1') and (DATA_A_IN_K_ENABLE = '1')) then
            -- Data Inputs
            data_a_in_scalar_float_adder <= DATA_A_IN;

            -- Control Internal
            data_a_in_j_float_adder_int <= '1';
            data_a_in_k_float_adder_int <= '1';
          end if;

          if ((DATA_B_IN_J_ENABLE = '1') and (DATA_B_IN_K_ENABLE = '1')) then
            -- Data Inputs
            data_b_in_scalar_float_adder <= DATA_B_IN;

            -- Control Internal
            data_b_in_j_float_adder_int <= '1';
            data_b_in_k_float_adder_int <= '1';
          end if;

          -- Control Outputs
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          if (data_a_in_j_float_adder_int = '1' and data_a_in_k_float_adder_int = '1' and data_b_in_j_float_adder_int = '1' and data_b_in_k_float_adder_int = '1') then
            -- Control Internal
            start_scalar_float_adder <= '1';

            operation_scalar_float_adder <= OPERATION;

            data_a_in_j_float_adder_int <= '0';
            data_a_in_k_float_adder_int <= '0';
            data_b_in_j_float_adder_int <= '0';
            data_b_in_k_float_adder_int <= '0';

            -- FSM Control
            if ((unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL))) then
              adder_ctrl_fsm_int <= ENDER_I_STATE;
            elsif (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)) then
              adder_ctrl_fsm_int <= ENDER_J_STATE;
            else
              adder_ctrl_fsm_int <= ENDER_K_STATE;
            end if;
          end if;

        when INPUT_K_STATE =>           -- STEP 3

          if (DATA_A_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_a_in_scalar_float_adder <= DATA_A_IN;

            -- Control Internal
            data_a_in_k_float_adder_int <= '1';
          end if;

          if (DATA_B_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_b_in_scalar_float_adder <= DATA_B_IN;

            -- Control Internal
            data_b_in_k_float_adder_int <= '1';
          end if;

          -- Control Outputs
          DATA_OUT_K_ENABLE <= '0';

          if (data_a_in_k_float_adder_int = '1' and data_b_in_k_float_adder_int = '1') then
            -- Control Internal
            start_scalar_float_adder <= '1';

            operation_scalar_float_adder <= OPERATION;

            data_a_in_k_float_adder_int <= '0';
            data_b_in_k_float_adder_int <= '0';

            -- FSM Control
            if ((unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL))) then
              adder_ctrl_fsm_int <= ENDER_I_STATE;
            elsif (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)) then
              adder_ctrl_fsm_int <= ENDER_J_STATE;
            else
              adder_ctrl_fsm_int <= ENDER_K_STATE;
            end if;
          end if;

        when ENDER_I_STATE =>           -- STEP 4

          if (ready_scalar_float_adder = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)))) then
              -- Data Outputs
              DATA_OUT     <= data_out_scalar_float_adder;
              OVERFLOW_OUT <= overflow_out_scalar_float_adder;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';
              DATA_OUT_K_ENABLE <= '1';

              READY <= '1';

              -- Control Internal
              index_i_loop <= ZERO_CONTROL;
              index_j_loop <= ZERO_CONTROL;
              index_k_loop <= ZERO_CONTROL;

              -- FSM Control
              adder_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)))) then
              -- Data Outputs
              DATA_OUT     <= data_out_scalar_float_adder;
              OVERFLOW_OUT <= overflow_out_scalar_float_adder;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';
              DATA_OUT_K_ENABLE <= '1';

              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;
              index_k_loop <= ZERO_CONTROL;

              -- FSM Control
              adder_ctrl_fsm_int <= INPUT_I_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when ENDER_J_STATE =>           -- STEP 5

          if (ready_scalar_float_adder = '1') then
            if ((unsigned(index_j_loop) < unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)))) then
              -- Data Outputs
              DATA_OUT     <= data_out_scalar_float_adder;
              OVERFLOW_OUT <= overflow_out_scalar_float_adder;

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';
              DATA_OUT_K_ENABLE <= '1';

              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
              index_k_loop <= ZERO_CONTROL;

              -- FSM Control
              adder_ctrl_fsm_int <= INPUT_J_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when ENDER_K_STATE =>           -- STEP 6

          if (ready_scalar_float_adder = '1') then
            if (unsigned(index_k_loop) < unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT     <= data_out_scalar_float_adder;
              OVERFLOW_OUT <= overflow_out_scalar_float_adder;

              -- Control Outputs
              DATA_OUT_K_ENABLE <= '1';

              -- Control Internal
              index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              adder_ctrl_fsm_int <= INPUT_K_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          adder_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR ADDER
  scalar_float_adder : accelerator_scalar_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_adder,
      READY => ready_scalar_float_adder,

      OPERATION => operation_scalar_float_adder,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_adder,
      DATA_B_IN => data_b_in_scalar_float_adder,

      DATA_OUT     => data_out_scalar_float_adder,
      OVERFLOW_OUT => overflow_out_scalar_float_adder
      );

end architecture;
