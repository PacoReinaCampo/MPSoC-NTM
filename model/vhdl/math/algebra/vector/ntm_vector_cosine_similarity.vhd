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

use ieee.math_real.all;
use ieee.float_pkg.all;

entity ntm_vector_cosine_similarity is
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

    DATA_A_IN_ENABLE : in std_logic;
    DATA_B_IN_ENABLE : in std_logic;

    DATA_ENABLE : out std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_vector_cosine_similarity_architecture of ntm_vector_cosine_similarity is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type cosine_similarity_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    ENDER_STATE,                        -- STEP 2
    COSINE_SIMILARITY_STATE,            -- STEP 3
    CLEAN_STATE,                        -- STEP 4
    OPERATION_STATE                     -- STEP 5
    );

  -- Buffer
  type vector_buffer is array (CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal cosine_similarity_ctrl_fsm_int : cosine_similarity_ctrl_fsm;

  -- Buffer
  signal vector_a_int : vector_buffer;
  signal vector_b_int : vector_buffer;

  signal vector_out_int : vector_buffer;

  -- Internal Signals
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_cosine_similarity_int : std_logic;
  signal data_b_in_cosine_similarity_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN · DATA_B_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
    variable data_a_int : std_logic_vector(DATA_SIZE-1 downto 0);
    variable data_b_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable data_p_int : vector_buffer;
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_ENABLE <= '0';

      DATA_OUT_ENABLE <= '0';

      -- Control Internal
      data_a_in_cosine_similarity_int <= '0';
      data_b_in_cosine_similarity_int <= '0';

      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case cosine_similarity_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_ENABLE <= '0';

          DATA_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (DATA_A_IN_ENABLE = '1') then
            -- Data Inputs
            vector_a_int(to_integer(unsigned(index_loop))) <= DATA_A_IN;

            -- Control Internal
            data_a_in_cosine_similarity_int <= '1';
          end if;

          if (DATA_B_IN_ENABLE = '1') then
            -- Data Inputs
            vector_b_int(to_integer(unsigned(index_loop))) <= DATA_B_IN;

            -- Control Internal
            data_b_in_cosine_similarity_int <= '1';
          end if;

          if (data_a_in_cosine_similarity_int = '1' and data_b_in_cosine_similarity_int = '1') then
            -- Control Internal
            data_a_in_cosine_similarity_int <= '0';
            data_b_in_cosine_similarity_int <= '0';

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= ENDER_STATE;
          end if;

          -- Control Outputs
          DATA_ENABLE <= '0';

        when ENDER_STATE =>             -- STEP 2

          if (unsigned(index_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= COSINE_SIMILARITY_STATE;
          else
            -- Control Internal
            index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

            -- Control Outputs
            DATA_ENABLE <= '1';

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= INPUT_STATE;
          end if;

          -- Data Outputs
          DATA_OUT <= ZERO_DATA;

        when COSINE_SIMILARITY_STATE =>  -- STEP 3

          -- Data Inputs
          data_a_int := ZERO_DATA;
          data_b_int := ZERO_DATA;

          for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
            data_p_int(i) := ZERO_DATA;
          end loop;

          for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
            data_a_int := std_logic_vector(to_float(to_real(to_float(data_a_int)) + (to_real(to_float(vector_a_int(i)))*to_real(to_float(vector_a_int(i))))));
            data_b_int := std_logic_vector(to_float(to_real(to_float(data_b_int)) + (to_real(to_float(vector_b_int(i)))*to_real(to_float(vector_b_int(i))))));

            data_p_int(i) := std_logic_vector(to_float(to_real(to_float(data_p_int(i))) + (to_real(to_float(vector_a_int(i)))*to_real(to_float(vector_b_int(i))))));
          end loop;

          for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
            vector_out_int(i) <= std_logic_vector(to_float(to_real(to_float(data_p_int(i)))/(to_real(to_float(data_a_int))*to_real(to_float(data_b_int)))));
          end loop;

          -- FSM Control
          cosine_similarity_ctrl_fsm_int <= CLEAN_STATE;

        when CLEAN_STATE =>             -- STEP 4

          -- Control Outputs
          DATA_ENABLE <= '0';

          DATA_OUT_ENABLE <= '0';

          -- FSM Control
          cosine_similarity_ctrl_fsm_int <= OPERATION_STATE;

        when OPERATION_STATE =>         -- STEP 5

          if (unsigned(index_loop) = unsigned(LENGTH_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            READY <= '1';

            -- Control Internal
            index_loop <= ZERO_CONTROL;

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            index_loop <= std_logic_vector(unsigned(index_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= CLEAN_STATE;
          end if;

          -- Data Outputs
          DATA_OUT <= vector_out_int(to_integer(unsigned(index_loop)));

          -- Control Outputs
          DATA_OUT_ENABLE <= '1';

        when others =>
          -- FSM Control
          cosine_similarity_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
