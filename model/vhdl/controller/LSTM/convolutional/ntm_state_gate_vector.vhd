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

entity ntm_state_gate_vector is
  generic (
    DATA_SIZE    : integer := 32;
    CONTROL_SIZE : integer := 64
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

architecture ntm_state_gate_vector_architecture of ntm_state_gate_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    VECTOR_FIRST_MULTIPLIER_STATE,      -- STEP 1
    VECTOR_SECOND_MULTIPLIER_STATE,     -- STEP 2
    VECTOR_ADDER_STATE                  -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_int_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_integer_adder : std_logic;
  signal ready_vector_integer_adder : std_logic;

  signal operation_vector_integer_adder : std_logic;

  signal data_a_in_enable_vector_integer_adder : std_logic;
  signal data_b_in_enable_vector_integer_adder : std_logic;

  signal data_out_enable_vector_integer_adder : std_logic;

  -- DATA
  signal size_in_vector_integer_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_integer_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_integer_multiplier : std_logic;
  signal ready_vector_integer_multiplier : std_logic;

  signal data_a_in_enable_vector_integer_multiplier : std_logic;
  signal data_b_in_enable_vector_integer_multiplier : std_logic;

  signal data_out_enable_vector_integer_multiplier : std_logic;

  -- DATA
  signal size_in_vector_integer_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_integer_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)

  -- s(t=0;l) = 0

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      S_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      S_OUT_ENABLE <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          S_OUT_ENABLE <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Data Outputs
            S_OUT <= ZERO_DATA;

            -- Control Internal
            start_vector_integer_multiplier <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_FIRST_MULTIPLIER_STATE;
          end if;

        when VECTOR_FIRST_MULTIPLIER_STATE =>  -- STEP 1

          -- Control Inputs
          data_a_in_enable_vector_integer_multiplier <= F_IN_ENABLE;
          data_b_in_enable_vector_integer_multiplier <= S_IN_ENABLE;

          -- Data Inputs
          size_in_vector_integer_multiplier   <= SIZE_L_IN;
          data_a_in_vector_integer_multiplier <= F_IN;
          data_b_in_vector_integer_multiplier <= S_IN;

          if (data_out_enable_vector_integer_multiplier = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_integer_multiplier <= '1';
            end if;

            -- Data Internal
            data_int_vector_integer_multiplier <= data_out_vector_integer_multiplier;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_SECOND_MULTIPLIER_STATE;
          else
            -- Control Internal
            start_vector_integer_multiplier <= '0';
          end if;

        when VECTOR_SECOND_MULTIPLIER_STATE =>  -- STEP 2

          -- Control Inputs
          data_a_in_enable_vector_integer_multiplier <= I_IN_ENABLE;
          data_b_in_enable_vector_integer_multiplier <= A_IN_ENABLE;

          -- Data Inputs
          size_in_vector_integer_multiplier   <= SIZE_L_IN;
          data_a_in_vector_integer_multiplier <= I_IN;
          data_b_in_vector_integer_multiplier <= A_IN;

          if (data_out_enable_vector_integer_multiplier = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_integer_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_ADDER_STATE;
          else
            -- Control Internal
            start_vector_integer_multiplier <= '0';
          end if;

        when VECTOR_ADDER_STATE =>      -- STEP 3

          -- Control Inputs
          operation_vector_integer_adder <= '0';

          data_a_in_enable_vector_integer_adder <= data_out_enable_vector_integer_adder;
          data_b_in_enable_vector_integer_adder <= data_out_enable_vector_integer_multiplier;

          -- Data Inputs
          size_in_vector_integer_adder   <= SIZE_L_IN;
          data_a_in_vector_integer_adder <= data_int_vector_integer_multiplier;
          data_b_in_vector_integer_adder <= data_out_vector_integer_multiplier;

          if (data_out_enable_vector_integer_adder = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_L_IN) - unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              start_vector_integer_multiplier <= '1';

              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_FIRST_MULTIPLIER_STATE;
            end if;

            -- Data Outputs
            S_OUT <= data_out_vector_integer_adder;

            -- Control Outputs
            S_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            S_OUT_ENABLE <= '0';

            -- Control Internal
            start_vector_integer_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  vector_integer_adder : ntm_vector_integer_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_integer_adder,
      READY => ready_vector_integer_adder,

      OPERATION => operation_vector_integer_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_integer_adder,

      -- DATA
      SIZE_IN   => size_in_vector_integer_adder,
      DATA_A_IN => data_a_in_vector_integer_adder,
      DATA_B_IN => data_b_in_vector_integer_adder,
      DATA_OUT  => data_out_vector_integer_adder
      );

  -- VECTOR MULTIPLIER
  vector_integer_multiplier : ntm_vector_integer_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_integer_multiplier,
      READY => ready_vector_integer_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_integer_multiplier,

      -- DATA
      SIZE_IN   => size_in_vector_integer_multiplier,
      DATA_A_IN => data_a_in_vector_integer_multiplier,
      DATA_B_IN => data_b_in_vector_integer_multiplier,
      DATA_OUT  => data_out_vector_integer_multiplier
      );

end architecture;
