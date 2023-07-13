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

entity accelerator_hidden_gate_vector is
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

    S_IN_ENABLE : in std_logic;         -- for l in 0 to L-1
    O_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    S_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1
    O_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture accelerator_hidden_gate_vector_architecture of accelerator_hidden_gate_vector is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- S_IN [L]
  -- O_IN [L]

  -- Outputs:
  -- H_OUT [L]

  -- States:
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_O_STATE, CLEAN_IN_O_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

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
  type controller_vector_tanh_fsm is (
    STARTER_VECTOR_TANH_STATE,          -- STEP 0
    INPUT_VECTOR_TANH_STATE,            -- STEP 2
    CLEAN_VECTOR_TANH_STATE             -- STEP 4
    );

  type controller_vector_float_multiplier_fsm is (
    STARTER_VECTOR_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_VECTOR_FLOAT_MULTIPLIER_STATE,    -- STEP 2
    CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE     -- STEP 4
    );

  -- Output
  type controller_h_out_fsm is (
    STARTER_H_OUT_STATE,                -- STEP 0
    CLEAN_H_OUT_L_STATE,                -- STEP 1
    OUTPUT_H_OUT_L_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_in_fsm_int : controller_in_fsm;

  -- Ops
  signal controller_vector_tanh_fsm_int             : controller_vector_tanh_fsm;
  signal controller_vector_float_multiplier_fsm_int : controller_vector_float_multiplier_fsm;

  -- Output
  signal controller_h_out_fsm_int : controller_h_out_fsm;

  -- Buffer
  -- Input
  signal vector_s_in_int : vector_buffer;
  signal vector_o_in_int : vector_buffer;

  -- Ops
  signal vector_operation_int : vector_buffer;

  -- Output
  signal vector_h_out_int : vector_buffer;

  -- Control Internal - Index
  -- Input
  signal index_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_vector_tanh_loop             : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_l_h_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_s_in_enable_int : std_logic;
  signal data_o_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

  -- Ops
  signal data_vector_float_multiplier_enable_int : std_logic;
  signal data_vector_tanh_enable_int             : std_logic;

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

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal size_in_vector_tanh  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- h(t;l) = o(t;l) o tanh(s(t;l))

  -- h(t=0;l) = 0; h(t;l=0) = 0

  -- INPUT CONTROL
  in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      S_OUT_ENABLE <= '0';
      O_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_in_loop <= ZERO_CONTROL;

      data_s_in_enable_int <= '0';
      data_o_in_enable_int <= '0';

      data_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_in_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          if (START = '1') then
            -- Control Outputs
            S_OUT_ENABLE <= '1';
            O_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_in_loop <= ZERO_CONTROL;

            data_s_in_enable_int <= '0';
            data_o_in_enable_int <= '0';

            data_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            S_OUT_ENABLE <= '0';
            O_OUT_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1 s,o

          if (S_IN_ENABLE = '1') then
            -- Data Inputs
            vector_s_in_int(to_integer(unsigned(index_l_in_loop))) <= S_IN;

            -- Control Internal
            data_s_in_enable_int <= '1';
          end if;

          if (O_IN_ENABLE = '1') then
            -- Data Inputs
            vector_o_in_int(to_integer(unsigned(index_l_in_loop))) <= O_IN;

            -- Control Internal
            data_o_in_enable_int <= '1';
          end if;

          -- Control Outputs
          S_OUT_ENABLE <= '0';
          O_OUT_ENABLE <= '0';

          if (data_s_in_enable_int = '1' and data_o_in_enable_int = '1') then
            -- Control Internal
            data_s_in_enable_int <= '0';
            data_o_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= CLEAN_STATE;
          end if;

        when CLEAN_STATE =>             -- STEP 2

          if (unsigned(index_l_in_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            S_OUT_ENABLE <= '1';
            O_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_in_loop <= ZERO_CONTROL;

            data_in_enable_int <= '1';

            -- FSM Control
            controller_in_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_l_in_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            S_OUT_ENABLE <= '1';
            O_OUT_ENABLE <= '1';

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
  vector_tanh_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_in_enable_vector_tanh <= '0';

      data_vector_tanh_enable_int <= '0';

      index_vector_tanh_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_tanh_fsm_int is
        when STARTER_VECTOR_TANH_STATE =>  -- STEP 0
          -- Control Internal
          data_in_enable_vector_tanh <= '0';

          data_vector_tanh_enable_int <= '0';

          if (data_s_in_enable_int = '1') then
            -- Data Inputs
            size_in_vector_tanh <= SIZE_L_IN;

            -- Control Internal
            index_vector_tanh_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_tanh_fsm_int <= INPUT_VECTOR_TANH_STATE;
          end if;

        when INPUT_VECTOR_TANH_STATE =>  -- STEP 5

          -- Data Inputs
          data_in_vector_tanh <= vector_operation_int(to_integer(unsigned(index_vector_tanh_loop)));

          -- Control Internal
          if (unsigned(index_vector_tanh_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_tanh_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_tanh <= '1';
          end if;

          data_in_enable_vector_tanh <= '1';

          -- FSM Control
          controller_vector_tanh_fsm_int <= CLEAN_VECTOR_TANH_STATE;

        when CLEAN_VECTOR_TANH_STATE =>  -- STEP 7

          if (data_out_enable_vector_tanh = '1' and data_out_enable_vector_tanh = '1') then
            if (unsigned(index_vector_tanh_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_tanh_loop))) <= data_out_vector_tanh;

              -- Control Internal
              data_vector_tanh_enable_int <= '1';

              index_vector_tanh_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_tanh_fsm_int <= STARTER_VECTOR_TANH_STATE;
            elsif (unsigned(index_vector_tanh_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_tanh_loop))) <= data_out_vector_tanh;

              -- Control Internal
              index_vector_tanh_loop <= std_logic_vector(unsigned(index_vector_tanh_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_tanh_fsm_int <= INPUT_VECTOR_TANH_STATE;
            end if;
          else
            -- Control Internal
            start_vector_tanh <= '0';

            data_in_enable_vector_tanh <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_tanh_fsm_int <= STARTER_VECTOR_TANH_STATE;
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

          if (data_o_in_enable_int = '1' and data_vector_tanh_enable_int = '1') then
            -- Data Inputs
            size_in_vector_float_multiplier <= SIZE_L_IN;

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
            if (unsigned(index_vector_float_multiplier_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              data_vector_float_multiplier_enable_int <= '1';

              index_vector_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_multiplier_fsm_int <= STARTER_VECTOR_FLOAT_MULTIPLIER_STATE;
            elsif (unsigned(index_vector_float_multiplier_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
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

  -- OUTPUT CONTROL
  h_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      H_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      H_OUT_ENABLE <= '0';

      -- Control Internal
      index_l_h_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_h_out_fsm_int is
        when STARTER_H_OUT_STATE =>     -- STEP 0
          if (data_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

        when CLEAN_H_OUT_L_STATE =>     -- STEP 1
          -- Control Outputs
          H_OUT_ENABLE <= '0';

          -- FSM Control
          controller_h_out_fsm_int <= OUTPUT_H_OUT_L_STATE;

        when OUTPUT_H_OUT_L_STATE =>    -- STEP 2

          if (unsigned(index_l_h_out_loop) = unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            H_OUT <= vector_h_out_int(to_integer(unsigned(index_l_h_out_loop)));

            -- Control Outputs
            READY <= '1';

            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
          elsif (unsigned(index_l_h_out_loop) < unsigned(SIZE_L_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            H_OUT <= vector_h_out_int(to_integer(unsigned(index_l_h_out_loop)));

            -- Control Outputs
            H_OUT_ENABLE <= '1';

            -- Control Internal
            index_l_h_out_loop <= std_logic_vector(unsigned(index_l_h_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_h_out_fsm_int <= CLEAN_H_OUT_L_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_h_out_fsm_int <= STARTER_H_OUT_STATE;
      end case;
    end if;
  end process;

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

  -- VECTOR TANH
  vector_tanh_function : accelerator_vector_tanh_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_tanh,
      READY => ready_vector_tanh,

      DATA_IN_ENABLE => data_in_enable_vector_tanh,

      DATA_OUT_ENABLE => data_out_enable_vector_tanh,

      -- DATA
      SIZE_IN  => size_in_vector_tanh,
      DATA_IN  => data_in_vector_tanh,
      DATA_OUT => data_out_vector_tanh
      );

end architecture;
