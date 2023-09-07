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
use work.accelerator_math_vhdl_pkg.all;

entity accelerator_state_gate_vector is
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

    I_IN_ENABLE : in std_logic;         -- for l in 0 to L-1
    F_IN_ENABLE : in std_logic;         -- for l in 0 to L-1
    A_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    I_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1
    F_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1
    A_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    S_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    S_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    S_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_state_gate_vector_architecture of accelerator_state_gate_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- A_IN [L]
  -- I_IN [L]
  -- F_IN [L]
  -- S_IN [L]

  -- Outputs:
  -- S_OUT [L]

  -- States:
  -- INPUT_L_STATE, CLEAN_IN_L_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_in_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  -- Ops
  type controller_first_vector_float_multiplier_fsm is (
    STARTER_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE,    -- STEP 2
    CLEAN_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE     -- STEP 4
    );

  type controller_second_vector_float_multiplier_fsm is (
    STARTER_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE,    -- STEP 2
    CLEAN_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE     -- STEP 4
    );

  type controller_vector_float_adder_fsm is (
    STARTER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    INPUT_VECTOR_FLOAT_ADDER_STATE,     -- STEP 2
    CLEAN_VECTOR_FLOAT_ADDER_STATE      -- STEP 4
    );

  -- Output
  type controller_s_out_fsm is (
    STARTER_S_OUT_STATE,                -- STEP 0
    CLEAN_S_OUT_L_STATE,                -- STEP 1
    OUTPUT_S_OUT_L_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_in_fsm_int : controller_in_fsm;

  -- Ops
  signal controller_first_vector_float_multiplier_fsm_int  : controller_first_vector_float_multiplier_fsm;
  signal controller_second_vector_float_multiplier_fsm_int : controller_second_vector_float_multiplier_fsm;
  signal controller_vector_float_adder_fsm_int             : controller_vector_float_adder_fsm;

  -- Output
  signal controller_s_out_fsm_int : controller_s_out_fsm;

  -- Buffer
  -- Input
  signal vector_s_in_int : vector_buffer;
  signal vector_i_in_int : vector_buffer;
  signal vector_f_in_int : vector_buffer;
  signal vector_a_in_int : vector_buffer;

  -- Ops
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_s_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_vector_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_float_adder_loop      : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_l_s_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_s_in_enable_int : std_logic;
  signal data_i_in_enable_int : std_logic;
  signal data_f_in_enable_int : std_logic;
  signal data_a_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

  -- Ops
  signal data_first_vector_float_multiplier_enable_int  : std_logic;
  signal data_second_vector_float_multiplier_enable_int : std_logic;
  signal data_vector_float_adder_enable_int             : std_logic;

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_float_adder : std_logic;
  signal ready_vector_float_adder : std_logic;

  signal operation_vector_float_adder : std_logic;

  signal data_a_in_enable_vector_float_adder : std_logic;
  signal data_b_in_enable_vector_float_adder : std_logic;

  signal data_out_enable_vector_float_adder : std_logic;

  -- DATA
  signal size_in_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_float_multiplier : std_logic;
  signal ready_vector_float_multiplier : std_logic;

  signal data_a_in_enable_vector_float_multiplier : std_logic;
  signal data_b_in_enable_vector_float_multiplier : std_logic;

  signal data_out_enable_vector_float_multiplier : std_logic;

  -- DATA
  signal size_in_vector_float_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)

  -- s(t=0;l) = 0

  -- INPUT CONTROL
  in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      S_OUT_ENABLE <= '0';
      I_OUT_ENABLE <= '0';
      F_OUT_ENABLE <= '0';
      A_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_in_loop <= ZERO_CONTROL;

      data_s_in_enable_int <= '0';
      data_i_in_enable_int <= '0';
      data_f_in_enable_int <= '0';
      data_a_in_enable_int <= '0';

      data_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_in_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          if (START = '1') then
            -- Control Outputs
            S_OUT_ENABLE <= '1';
            I_OUT_ENABLE <= '1';
            F_OUT_ENABLE <= '1';
            A_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_in_loop <= ZERO_CONTROL;

            data_s_in_enable_int <= '0';
            data_i_in_enable_int <= '0';
            data_f_in_enable_int <= '0';
            data_a_in_enable_int <= '0';

            data_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            S_OUT_ENABLE <= '0';
            I_OUT_ENABLE <= '0';
            F_OUT_ENABLE <= '0';
            A_OUT_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1 i,f,a

          if (S_IN_ENABLE = '1') then
            -- Data Inputs
            vector_s_in_int(to_integer(unsigned(index_l_in_loop))) <= S_IN;

            -- Control Internal
            data_s_in_enable_int <= '1';
          end if;

          if (I_IN_ENABLE = '1') then
            -- Data Inputs
            vector_i_in_int(to_integer(unsigned(index_l_in_loop))) <= I_IN;

            -- Control Internal
            data_i_in_enable_int <= '1';
          end if;

          if (F_IN_ENABLE = '1') then
            -- Data Inputs
            vector_f_in_int(to_integer(unsigned(index_l_in_loop))) <= F_IN;

            -- Control Internal
            data_f_in_enable_int <= '1';
          end if;

          if (A_IN_ENABLE = '1') then
            -- Data Inputs
            vector_a_in_int(to_integer(unsigned(index_l_in_loop))) <= A_IN;

            -- Control Internal
            data_a_in_enable_int <= '1';
          end if;

          -- Control Outputs
          S_OUT_ENABLE <= '0';
          I_OUT_ENABLE <= '0';
          F_OUT_ENABLE <= '0';
          A_OUT_ENABLE <= '0';

          if (data_s_in_enable_int = '1' and data_i_in_enable_int = '1' and data_f_in_enable_int = '1' and data_a_in_enable_int = '1') then
            -- Control Internal
            data_s_in_enable_int <= '0';
            data_i_in_enable_int <= '0';
            data_f_in_enable_int <= '0';
            data_a_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= CLEAN_STATE;
          end if;

        when CLEAN_STATE =>             -- STEP 2

          if (unsigned(index_l_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            S_OUT_ENABLE <= '1';
            I_OUT_ENABLE <= '1';
            F_OUT_ENABLE <= '1';
            A_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_in_loop <= ZERO_CONTROL;

            data_in_enable_int <= '1';

            -- FSM Control
            controller_in_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_l_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            I_OUT_ENABLE <= '1';
            S_OUT_ENABLE <= '1';
            F_OUT_ENABLE <= '1';
            A_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_in_loop <= std_logic_vector(unsigned(index_l_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_in_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  first_vector_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_multiplier <= '0';
      data_b_in_enable_vector_float_multiplier <= '0';

      data_first_vector_float_multiplier_enable_int <= '0';

      index_vector_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_first_vector_float_multiplier_fsm_int is
        when STARTER_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_multiplier <= '0';
          data_b_in_enable_vector_float_multiplier <= '0';

          data_first_vector_float_multiplier_enable_int <= '0';

          if (data_f_in_enable_int = '1' and data_s_in_enable_int = '1') then
            -- Data Inputs
            size_in_vector_float_multiplier <= SIZE_L_IN;

            -- Control Internal
            index_vector_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_first_vector_float_multiplier_fsm_int <= INPUT_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE;
          end if;

        when INPUT_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_multiplier <= vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop)));
          data_b_in_vector_float_multiplier <= vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_multiplier_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_multiplier_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_multiplier <= '1';
          end if;

          data_a_in_enable_vector_float_multiplier <= '1';
          data_b_in_enable_vector_float_multiplier <= '1';

          -- FSM Control
          controller_first_vector_float_multiplier_fsm_int <= CLEAN_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE;

        when CLEAN_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_multiplier = '1' and data_out_enable_vector_float_multiplier = '1') then
            if (unsigned(index_vector_float_multiplier_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              data_first_vector_float_multiplier_enable_int <= '1';

              index_vector_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_vector_float_multiplier_fsm_int <= STARTER_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE;
            elsif (unsigned(index_vector_float_multiplier_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              index_vector_float_multiplier_loop <= std_logic_vector(unsigned(index_vector_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_first_vector_float_multiplier_fsm_int <= INPUT_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_multiplier <= '0';

            data_a_in_enable_vector_float_multiplier <= '0';
            data_b_in_enable_vector_float_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_first_vector_float_multiplier_fsm_int <= STARTER_FIRST_VECTOR_FLOAT_MULTIPLIER_STATE;
      end case;
    end if;
  end process;

  second_vector_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_multiplier <= '0';
      data_b_in_enable_vector_float_multiplier <= '0';

      data_second_vector_float_multiplier_enable_int <= '0';

      index_vector_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_second_vector_float_multiplier_fsm_int is
        when STARTER_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_multiplier <= '0';
          data_b_in_enable_vector_float_multiplier <= '0';

          data_second_vector_float_multiplier_enable_int <= '0';

          if (data_i_in_enable_int = '1' and data_a_in_enable_int = '1') then
            -- Data Inputs
            size_in_vector_float_multiplier <= SIZE_L_IN;

            -- Control Internal
            index_vector_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_second_vector_float_multiplier_fsm_int <= INPUT_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE;
          end if;

        when INPUT_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_multiplier <= vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop)));
          data_b_in_vector_float_multiplier <= vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_multiplier_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_multiplier_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_multiplier <= '1';
          end if;

          data_a_in_enable_vector_float_multiplier <= '1';
          data_b_in_enable_vector_float_multiplier <= '1';

          -- FSM Control
          controller_second_vector_float_multiplier_fsm_int <= CLEAN_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE;

        when CLEAN_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_multiplier = '1' and data_out_enable_vector_float_multiplier = '1') then
            if (unsigned(index_vector_float_multiplier_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              data_second_vector_float_multiplier_enable_int <= '1';

              index_vector_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_vector_float_multiplier_fsm_int <= STARTER_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE;
            elsif (unsigned(index_vector_float_multiplier_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              index_vector_float_multiplier_loop <= std_logic_vector(unsigned(index_vector_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_second_vector_float_multiplier_fsm_int <= INPUT_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_multiplier <= '0';

            data_a_in_enable_vector_float_multiplier <= '0';
            data_b_in_enable_vector_float_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_second_vector_float_multiplier_fsm_int <= STARTER_SECOND_VECTOR_FLOAT_MULTIPLIER_STATE;
      end case;
    end if;
  end process;

  vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_adder_fsm_int is
        when STARTER_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          data_vector_float_adder_enable_int <= '0';

          if (data_i_in_enable_int = '1' and data_a_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_L_IN;

            -- Control Internal
            index_vector_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when INPUT_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
          data_b_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_adder <= '1';
          end if;

          data_a_in_enable_vector_float_adder <= '1';
          data_b_in_enable_vector_float_adder <= '1';

          -- FSM Control
          controller_vector_float_adder_fsm_int <= CLEAN_VECTOR_FLOAT_ADDER_STATE;

        when CLEAN_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  s_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      S_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      S_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_s_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_s_out_fsm_int is
        when STARTER_S_OUT_STATE =>     -- STEP 0
          if (data_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_s_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_s_out_fsm_int <= CLEAN_S_OUT_L_STATE;
          end if;

        when CLEAN_S_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          S_OUT_ENABLE <= '0';

          -- FSM Control
          controller_s_out_fsm_int <= OUTPUT_S_OUT_L_STATE;

        when OUTPUT_S_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_s_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            S_OUT <= vector_s_out_int(to_integer(unsigned(index_l_s_out_loop)));

            -- Control Outputs
            READY <= '1';

            S_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_s_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_s_out_fsm_int <= STARTER_S_OUT_STATE;
          elsif (unsigned(index_l_s_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            S_OUT <= vector_s_out_int(to_integer(unsigned(index_l_s_out_loop)));

            -- Control Outputs
            S_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_s_out_loop <= std_logic_vector(unsigned(index_l_s_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_s_out_fsm_int <= CLEAN_S_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_s_out_fsm_int <= STARTER_S_OUT_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  vector_float_adder : accelerator_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_adder,
      READY => ready_vector_float_adder,

      OPERATION => operation_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_vector_float_adder,
      DATA_A_IN => data_a_in_vector_float_adder,
      DATA_B_IN => data_b_in_vector_float_adder,
      DATA_OUT  => data_out_vector_float_adder
      );

  -- VECTOR MULTIPLIER
  vector_float_multiplier : accelerator_vector_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_multiplier,
      READY => ready_vector_float_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

      -- DATA
      SIZE_IN   => size_in_vector_float_multiplier,
      DATA_A_IN => data_a_in_vector_float_multiplier,
      DATA_B_IN => data_b_in_vector_float_multiplier,
      DATA_OUT  => data_out_vector_float_multiplier
      );

end architecture;
