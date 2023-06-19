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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;

entity accelerator_matrix_differentiation is
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

    CONTROL : in std_logic;

    DATA_IN_I_ENABLE : in std_logic;
    DATA_IN_J_ENABLE : in std_logic;

    DATA_I_ENABLE : out std_logic;
    DATA_J_ENABLE : out std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;

    -- DATA
    SIZE_I_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_IN     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_matrix_differentiation_architecture of accelerator_matrix_differentiation is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type differentiation_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    ENDER_I_STATE,                      -- STEP 3
    ENDER_J_STATE,                      -- STEP 4
    CLEAN_I_STATE,                      -- STEP 5
    CLEAN_J_STATE,                      -- STEP 6
    SCALAR_ADDER_I_STATE,               -- STEP 7
    SCALAR_ADDER_J_STATE,               -- STEP 8
    SCALAR_DIVIDER_I_STATE,             -- STEP 7
    SCALAR_DIVIDER_J_STATE              -- STEP 10
    );

  -- Buffer
  type matrix_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal differentiation_ctrl_fsm_int : differentiation_ctrl_fsm;

  -- Buffer
  signal matrix_int : matrix_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_float_divider : std_logic;
  signal ready_scalar_float_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_divider : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- DATA_OUT = differentiation(DATA_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_I_ENABLE <= '0';
      DATA_J_ENABLE <= '0';

      DATA_OUT_I_ENABLE <= '0';
      DATA_OUT_J_ENABLE <= '0';

      -- Control Internal
      start_scalar_float_adder   <= '0';
      start_scalar_float_divider <= '0';

      operation_scalar_float_adder <= '0';

      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

      -- Data Internal
      data_a_in_scalar_float_adder <= ZERO_DATA;
      data_b_in_scalar_float_adder <= ZERO_DATA;

      data_a_in_scalar_float_divider <= ZERO_DATA;
      data_b_in_scalar_float_divider <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case differentiation_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_I_ENABLE <= '1';
            DATA_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            differentiation_ctrl_fsm_int <= INPUT_I_STATE;
          else
            -- Control Outputs
            DATA_I_ENABLE <= '0';
            DATA_J_ENABLE <= '0';
          end if;

        when INPUT_I_STATE =>           -- STEP 1

          if ((DATA_IN_I_ENABLE = '1') and (DATA_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_IN;

            -- FSM Control
            differentiation_ctrl_fsm_int <= ENDER_J_STATE;
          end if;

          -- Control Outputs
          DATA_I_ENABLE <= '0';
          DATA_J_ENABLE <= '0';

        when INPUT_J_STATE =>           -- STEP 2

          if (DATA_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= DATA_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
              differentiation_ctrl_fsm_int <= ENDER_I_STATE;
            else
              differentiation_ctrl_fsm_int <= ENDER_J_STATE;
            end if;
          end if;

          -- Control Outputs
          DATA_I_ENABLE <= '0';
          DATA_J_ENABLE <= '0';

        when ENDER_I_STATE =>           -- STEP 3

          if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            differentiation_ctrl_fsm_int <= CLEAN_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            DATA_I_ENABLE <= '1';
            DATA_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop)+unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            differentiation_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when ENDER_J_STATE =>           -- STEP 4

          if (unsigned(index_j_loop) < unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_OUT <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            DATA_J_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            differentiation_ctrl_fsm_int <= INPUT_J_STATE;
          end if;

        when CLEAN_I_STATE =>           -- STEP 5

          -- Data Inputs
          data_a_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

          if (unsigned(index_i_loop) = unsigned(ZERO_CONTROL)) then
            data_b_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
          else
            if (CONTROL = '0') then
              data_b_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)-unsigned(ONE_CONTROL)), to_integer(unsigned(index_j_loop)));
            else
              data_b_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)-unsigned(ONE_CONTROL)));
            end if;
          end if;

          -- Control Outputs
          DATA_I_ENABLE <= '0';
          DATA_J_ENABLE <= '0';

          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

          -- Control Internal
          start_scalar_float_adder <= '1';

          operation_scalar_float_adder <= '1';

          -- FSM Control
          differentiation_ctrl_fsm_int <= SCALAR_ADDER_J_STATE;

        when CLEAN_J_STATE =>           -- STEP 6

          -- Data Inputs
          data_a_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

          if (unsigned(index_i_loop) = unsigned(ZERO_CONTROL)) then
            data_b_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
          else
            if (CONTROL = '0') then
              data_b_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)-unsigned(ONE_CONTROL)), to_integer(unsigned(index_j_loop)));
            else
              data_b_in_scalar_float_adder <= matrix_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)-unsigned(ONE_CONTROL)));
            end if;
          end if;

          -- Control Outputs
          DATA_I_ENABLE <= '0';
          DATA_J_ENABLE <= '0';

          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

          -- Control Internal
          start_scalar_float_adder <= '1';

          operation_scalar_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
            differentiation_ctrl_fsm_int <= SCALAR_ADDER_I_STATE;
          else
            differentiation_ctrl_fsm_int <= SCALAR_ADDER_J_STATE;
          end if;

        when SCALAR_ADDER_I_STATE =>    -- STEP 4

          if (ready_scalar_float_adder = '1') then
            -- Data Inputs
            data_a_in_scalar_float_divider <= data_out_scalar_float_adder;

            if (CONTROL = '0') then
              data_b_in_scalar_float_divider <= LENGTH_I_IN;
            else
              data_b_in_scalar_float_divider <= LENGTH_J_IN;
            end if;

            -- Control Internal
            start_scalar_float_divider <= '1';

            -- FSM Control
            differentiation_ctrl_fsm_int <= SCALAR_DIVIDER_I_STATE;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when SCALAR_ADDER_J_STATE =>    -- STEP 4

          if (ready_scalar_float_adder = '1') then
            -- Data Inputs
            data_a_in_scalar_float_divider <= data_out_scalar_float_adder;

            if (CONTROL = '0') then
              data_b_in_scalar_float_divider <= LENGTH_I_IN;
            else
              data_b_in_scalar_float_divider <= LENGTH_J_IN;
            end if;

            -- Control Internal
            start_scalar_float_divider <= '1';

            -- FSM Control
            differentiation_ctrl_fsm_int <= SCALAR_DIVIDER_J_STATE;
          else
            -- Control Internal
            start_scalar_float_adder <= '0';
          end if;

        when SCALAR_DIVIDER_I_STATE =>  -- STEP 7

          if (ready_scalar_float_divider = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_float_divider;

              -- Control Outputs
              READY <= '1';

              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              -- Control Internal
              index_i_loop <= ZERO_CONTROL;
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              differentiation_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_float_divider;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop)+unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              differentiation_ctrl_fsm_int <= CLEAN_I_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_float_divider <= '0';
          end if;

        when SCALAR_DIVIDER_J_STATE =>  -- STEP 8

          if (ready_scalar_float_divider = '1') then
            if (unsigned(index_j_loop) < unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT <= data_out_scalar_float_divider;

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';

              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop)+unsigned(ONE_CONTROL));

              -- FSM Control
              differentiation_ctrl_fsm_int <= CLEAN_J_STATE;
            end if;
          else
            -- Control Internal
            start_scalar_float_divider <= '0';
          end if;

        when others =>
          -- FSM Control
          differentiation_ctrl_fsm_int <= STARTER_STATE;
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

  -- SCALAR DIVIDER
  scalar_float_divider : accelerator_scalar_float_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_float_divider,
      READY => ready_scalar_float_divider,

      -- DATA
      DATA_A_IN => data_a_in_scalar_float_divider,
      DATA_B_IN => data_b_in_scalar_float_divider,

      DATA_OUT     => data_out_scalar_float_divider,
      OVERFLOW_OUT => overflow_out_scalar_float_divider
      );

end architecture;
