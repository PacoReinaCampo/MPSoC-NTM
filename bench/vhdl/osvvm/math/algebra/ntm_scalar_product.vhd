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

use work.ntm_math_pkg.all;

entity ntm_scalar_product is
  generic (
    DATA_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_A_IN_ENABLE : in std_logic;
    DATA_B_IN_ENABLE : in std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_product_architecture of ntm_scalar_product is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    VECTOR_MULTIPLIER_STATE,            -- STEP 1
    SCALAR_ADDER_STATE                  -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_adder : std_logic;
  signal ready_scalar_adder : std_logic;

  signal operation_scalar_adder : std_logic;

  -- DATA
  signal modulo_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_multiplier : std_logic;
  signal ready_vector_multiplier : std_logic;

  signal data_a_in_enable_vector_multiplier : std_logic;
  signal data_b_in_enable_vector_multiplier : std_logic;

  signal data_out_enable_vector_multiplier : std_logic;

  -- DATA
  signal modulo_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_multiplier   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN · DATA_B_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_vector_multiplier <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          else
            -- Control Internal
            start_vector_multiplier <= '0';
          end if;

        when VECTOR_MULTIPLIER_STATE =>  -- STEP 1

          if (data_out_enable_vector_multiplier = '1') then
            -- Control Internal
            start_scalar_adder <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_ADDER_STATE;
          else
            -- Control Internal
            start_vector_multiplier <= '0';
          end if;

        when SCALAR_ADDER_STATE =>  -- STEP 2

          if (ready_scalar_adder = '1') then
            if (unsigned(index_loop) = unsigned(LENGTH_IN)-unsigned(ONE)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_scalar_adder;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';
          else
            -- Control Internal
            start_scalar_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR ADDER
  operation_scalar_adder <= '0';

  -- VECTOR MULTIPLIER
  data_a_in_enable_vector_multiplier <= DATA_A_IN_ENABLE;
  data_b_in_enable_vector_multiplier <= DATA_B_IN_ENABLE;

  -- DATA
  -- SCALAR ADDER
  modulo_in_scalar_adder <= MODULO_IN;
  data_a_in_scalar_adder <= data_out_vector_multiplier;
  data_b_in_scalar_adder <= data_out_scalar_adder;

  -- VECTOR MULTIPLIER
  modulo_in_vector_multiplier <= MODULO_IN;
  size_in_vector_multiplier   <= LENGTH_IN;
  data_a_in_vector_multiplier <= DATA_A_IN;
  data_b_in_vector_multiplier <= DATA_B_IN;

  -- SCALAR ADDER
  scalar_adder : ntm_scalar_adder
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_adder,
      READY => ready_scalar_adder,

      OPERATION => operation_scalar_adder,

      -- DATA
      MODULO_IN => modulo_in_scalar_adder,
      DATA_A_IN => data_a_in_scalar_adder,
      DATA_B_IN => data_b_in_scalar_adder,
      DATA_OUT  => data_out_scalar_adder
      );

  -- VECTOR MULTIPLIER
  vector_multiplier : ntm_vector_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplier,
      READY => ready_vector_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_multiplier,

      -- DATA
      MODULO_IN => modulo_in_vector_multiplier,
      SIZE_IN   => size_in_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
      );

end architecture;
