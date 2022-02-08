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

entity dnc_write_vector is
  generic (
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    V_IN_ENABLE : in std_logic;

    V_ENABLE : out std_logic;

    V_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    V_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_write_vector_architecture of dnc_write_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type write_vector_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    ENDER_STATE,                        -- STEP 3
    CLEAN_STATE,                        -- STEP 5
    OPERATION_STATE                     -- STEP 8
    );

  -- Buffer
  type vector_buffer is array (CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal write_vector_ctrl_fsm_int : write_vector_ctrl_fsm;

  -- Buffer
  signal vector_int : vector_buffer;

  -- Control Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- v(t;k) = v^(t;k)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      V_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      V_ENABLE <= '0';

      V_OUT_ENABLE <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case write_vector_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          V_ENABLE <= '0';

          V_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            V_ENABLE <= '1';

            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            write_vector_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>             -- STEP 2

          if (V_IN_ENABLE = '1') then
            -- Data Inputs
            vector_int(to_integer(unsigned(index_loop))) <= V_IN;

            -- FSM Control
            write_vector_ctrl_fsm_int <= ENDER_STATE;
          end if;

          -- Control Outputs
          V_ENABLE <= '0';

        when ENDER_STATE =>             -- STEP 4

          if (unsigned(index_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            write_vector_ctrl_fsm_int <= CLEAN_STATE;
          else
            -- Control Internal
            index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

            -- Control Outputs
            V_ENABLE <= '1';

            -- FSM Control
            write_vector_ctrl_fsm_int <= INPUT_STATE;
          end if;

          -- Data Outputs
          V_OUT <= vector_int(to_integer(unsigned(index_loop)));

        when CLEAN_STATE =>             -- STEP 5

          -- Control Outputs
          V_ENABLE <= '0';

          V_OUT_ENABLE <= '0';

          -- FSM Control
          write_vector_ctrl_fsm_int <= OPERATION_STATE;

        when OPERATION_STATE =>         -- STEP 8

          if (unsigned(index_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            READY <= '1';

            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            write_vector_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            write_vector_ctrl_fsm_int <= CLEAN_STATE;
          end if;

          -- Data Outputs
          V_OUT <= vector_int(to_integer(unsigned(index_loop)));

          -- Control Outputs
          V_OUT_ENABLE <= '1';

        when others =>
          -- FSM Control
          write_vector_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
