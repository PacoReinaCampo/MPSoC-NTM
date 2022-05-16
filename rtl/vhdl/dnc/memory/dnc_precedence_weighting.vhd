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

entity dnc_precedence_weighting is
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

architecture dnc_precedence_weighting_architecture of dnc_precedence_weighting is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- W_IN [N]
  -- P_IN [N]

  -- Outputs:
  -- P_OUT [N]

  -- States:
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_in_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  -- Ops
  type controller_vector_summation_fsm is (
    STARTER_VECTOR_SUMMATION_STATE,       -- STEP 0
    INPUT_VECTOR_LENGTH_SUMMATION_STATE,  -- STEP 1
    INPUT_VECTOR_SIZE_SUMMATION_STATE,    -- STEP 2
    CLEAN_VECTOR_LENGTH_SUMMATION_STATE,  -- STEP 3
    CLEAN_VECTOR_SIZE_SUMMATION_STATE     -- STEP 4
    );

  type controller_vector_float_multiplier_fsm is (
    STARTER_VECTOR_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_VECTOR_FLOAT_MULTIPLIER_STATE,    -- STEP 2
    CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE     -- STEP 4
    );

  type controller_vector_float_adder_fsm is (
    STARTER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    INPUT_VECTOR_FLOAT_ADDER_STATE,     -- STEP 2
    CLEAN_VECTOR_FLOAT_ADDER_STATE      -- STEP 4
    );

  -- Output
  type controller_p_out_fsm is (
    STARTER_P_OUT_STATE,                -- STEP 0
    CLEAN_P_OUT_J_STATE,                -- STEP 1
    OUTPUT_P_OUT_J_STATE                -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_in_fsm_int : controller_in_fsm;

  -- Ops
  signal controller_vector_summation_fsm_int        : controller_vector_summation_fsm;
  signal controller_vector_float_adder_fsm_int      : controller_vector_float_adder_fsm;
  signal controller_vector_float_multiplier_fsm_int : controller_vector_float_multiplier_fsm;

  -- Output
  signal controller_p_out_fsm_int : controller_p_out_fsm;

  -- Buffer
  -- Input
  signal vector_w_in_int : vector_buffer;
  signal vector_p_in_int : vector_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_p_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_vector_summation_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_vector_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_float_adder_loop      : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_j_p_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_w_in_enable_int : std_logic;
  signal data_p_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

  -- Ops
  signal data_vector_summation_enable_int        : std_logic;
  signal data_vector_float_adder_enable_int      : std_logic;
  signal data_vector_float_multiplier_enable_int : std_logic;

  -- VECTOR SUMMATION
  -- CONTROL
  signal start_vector_summation : std_logic;
  signal ready_vector_summation : std_logic;

  signal data_in_enable_length_vector_summation : std_logic;
  signal data_in_enable_vector_summation        : std_logic;

  signal data_enable_length_vector_summation : std_logic;
  signal data_enable_vector_summation        : std_logic;

  signal data_out_enable_vector_summation : std_logic;

  -- DATA
  signal size_in_vector_summation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_summation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_summation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_summation  : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
  -- p(t=0) = 0

  -- INPUT CONTROL
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

  -- OPS CONTROL
  vector_summation_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_enable_length_vector_summation <= '0';
      data_in_enable_vector_summation        <= '0';

      data_vector_summation_enable_int <= '0';

      index_i_vector_summation_loop <= ZERO_CONTROL;
      index_j_vector_summation_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_summation_fsm_int is
        when STARTER_VECTOR_SUMMATION_STATE =>  -- STEP 0
          -- Control Internal
          data_in_enable_length_vector_summation <= '0';
          data_in_enable_vector_summation        <= '0';

          if (data_w_in_enable_int = '1' and data_p_in_enable_int = '1') then
            -- Data Inputs
            length_in_vector_summation <= SIZE_N_IN;
            size_in_vector_summation   <= SIZE_N_IN;

            -- Control Internal
            index_i_vector_summation_loop <= ZERO_CONTROL;
            index_j_vector_summation_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_summation_fsm_int <= INPUT_VECTOR_LENGTH_SUMMATION_STATE;
          end if;

          -- Control Internal
          data_vector_summation_enable_int <= '0';

        when INPUT_VECTOR_LENGTH_SUMMATION_STATE =>  -- STEP 1

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_i_vector_summation_loop)), to_integer(unsigned(index_j_vector_summation_loop)));

          -- Control Internal
          if (unsigned(index_i_vector_summation_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_vector_summation_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_summation <= '1';
          end if;

          data_in_enable_length_vector_summation <= '1';
          data_in_enable_vector_summation        <= '1';

          -- FSM Control
          controller_vector_summation_fsm_int <= CLEAN_VECTOR_SIZE_SUMMATION_STATE;

        when INPUT_VECTOR_SIZE_SUMMATION_STATE =>  -- STEP 2

          -- Data Inputs
          data_in_vector_summation <= matrix_operation_int(to_integer(unsigned(index_i_vector_summation_loop)), to_integer(unsigned(index_j_vector_summation_loop)));

          -- Control Internal
          data_in_enable_vector_summation <= '1';

          -- FSM Control
          if (unsigned(index_j_vector_summation_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_vector_summation_fsm_int <= CLEAN_VECTOR_LENGTH_SUMMATION_STATE;
          else
            controller_vector_summation_fsm_int <= CLEAN_VECTOR_SIZE_SUMMATION_STATE;
          end if;

        when CLEAN_VECTOR_LENGTH_SUMMATION_STATE =>  -- STEP 3

          if (data_enable_length_vector_summation = '1' and data_enable_vector_summation = '1') then
            if ((unsigned(index_i_vector_summation_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_vector_summation_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_vector_summation_loop <= ZERO_CONTROL;
              index_j_vector_summation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
            elsif ((unsigned(index_i_vector_summation_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_vector_summation_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Control Internal
              index_i_vector_summation_loop <= std_logic_vector(unsigned(index_i_vector_summation_loop) + unsigned(ONE_CONTROL));
              index_j_vector_summation_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_VECTOR_LENGTH_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_enable_length_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when CLEAN_VECTOR_SIZE_SUMMATION_STATE =>  -- STEP 4

          if (data_enable_vector_summation = '1') then
            if (unsigned(index_j_vector_summation_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Control Internal
              index_j_vector_summation_loop <= std_logic_vector(unsigned(index_j_vector_summation_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_summation_fsm_int <= INPUT_VECTOR_SIZE_SUMMATION_STATE;
            end if;
          else
            -- Control Internal
            start_vector_summation <= '0';

            data_in_enable_length_vector_summation <= '0';
            data_in_enable_vector_summation        <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_summation_fsm_int <= STARTER_VECTOR_SUMMATION_STATE;
      end case;
    end if;
  end process;

  vector_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_multiplier <= '0';
      data_b_in_enable_vector_float_multiplier <= '0';

      data_vector_float_multiplier_enable_int <= '0';

      index_vector_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_multiplier_fsm_int is
        when STARTER_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_multiplier <= '0';
          data_b_in_enable_vector_float_multiplier <= '0';

          data_vector_float_multiplier_enable_int <= '0';

          if (data_p_in_enable_int = '1' and data_p_in_enable_int = '1') then
            -- Data Inputs
            size_in_vector_float_multiplier <= SIZE_N_IN;

            -- Control Internal
            index_vector_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_float_multiplier_fsm_int <= INPUT_VECTOR_FLOAT_MULTIPLIER_STATE;
          end if;

        when INPUT_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 5

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
          controller_vector_float_multiplier_fsm_int <= CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE;

        when CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_multiplier = '1' and data_out_enable_vector_float_multiplier = '1') then
            if (unsigned(index_vector_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              data_vector_float_multiplier_enable_int <= '1';

              index_vector_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_multiplier_fsm_int <= STARTER_VECTOR_FLOAT_MULTIPLIER_STATE;
            elsif (unsigned(index_vector_float_multiplier_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              index_vector_float_multiplier_loop <= std_logic_vector(unsigned(index_vector_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_float_multiplier_fsm_int <= INPUT_VECTOR_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_multiplier <= '0';

            data_a_in_enable_vector_float_multiplier <= '0';
            data_b_in_enable_vector_float_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_float_multiplier_fsm_int <= STARTER_VECTOR_FLOAT_MULTIPLIER_STATE;
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

          if (data_p_in_enable_int = '1' and data_p_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_N_IN;

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
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
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

  -- VECTOR SUMMATION
  vector_summation : ntm_vector_summation
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_summation,
      READY => ready_vector_summation,

      DATA_IN_LENGTH_ENABLE => data_in_enable_length_vector_summation,
      DATA_IN_ENABLE        => data_in_enable_vector_summation,

      DATA_LENGTH_ENABLE => data_enable_length_vector_summation,
      DATA_ENABLE        => data_enable_vector_summation,

      DATA_OUT_ENABLE => data_out_enable_vector_summation,

      -- DATA
      SIZE_IN   => size_in_vector_summation,
      LENGTH_IN => length_in_vector_summation,
      DATA_IN   => data_in_vector_summation,
      DATA_OUT  => data_out_vector_summation
      );

  -- VECTOR ADDER
  vector_float_adder : ntm_vector_float_adder
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
  vector_float_multiplier : ntm_vector_float_multiplier
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