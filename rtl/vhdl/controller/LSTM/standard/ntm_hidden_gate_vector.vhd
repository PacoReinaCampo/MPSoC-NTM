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

entity ntm_hidden_gate_vector is
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

architecture ntm_hidden_gate_vector_architecture of ntm_hidden_gate_vector is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- S_IN [L]
  -- O_IN [L]

  -- Outputs:
  -- H_OUT [L]

  -- States:
  -- INPUT_S_STATE, CLEAN_IN_S_STATE
  -- INPUT_O_STATE, CLEAN_IN_O_STATE

  -- OUTPUT_L_STATE, CLEAN_OUT_L_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_in_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  type controller_h_out_fsm is (
    STARTER_H_OUT_STATE,                -- STEP 0
    CLEAN_H_OUT_L_STATE,                -- STEP 1
    OUTPUT_H_OUT_L_STATE                -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_in_fsm_int : controller_in_fsm;

  signal controller_h_out_fsm_int : controller_h_out_fsm;

  -- Buffer
  signal vector_s_in_int : vector_buffer;
  signal vector_o_in_int : vector_buffer;

  signal vector_h_out_int : vector_buffer;

  -- Control Internal
  signal index_l_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_l_h_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_s_in_enable_int : std_logic;
  signal data_o_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

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

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- h(t;l) = o(t;l) o tanh(s(t;l))

  -- h(t=0;l) = 0; h(t;l=0) = 0

  -- CONTROL
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

  -- VECTOR TANH
  vector_tanh_function : ntm_vector_tanh_function
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
