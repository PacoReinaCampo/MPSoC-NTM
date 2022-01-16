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

entity ntm_matrix_divider is
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

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;

    -- DATA
    SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    REST_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_matrix_divider_architecture of ntm_matrix_divider is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type divider_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    ENDER_I_STATE,                      -- STEP 3
    ENDER_J_STATE                       -- STEP 4
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
  signal divider_ctrl_fsm_int : divider_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_divider_int : std_logic;
  signal data_a_in_j_divider_int : std_logic;
  signal data_b_in_i_divider_int : std_logic;
  signal data_b_in_j_divider_int : std_logic;

  -- VECTOR DIVIDER
  -- CONTROL
  signal start_vector_divider : std_logic;
  signal ready_vector_divider : std_logic;

  signal data_a_in_enable_vector_divider : std_logic;
  signal data_b_in_enable_vector_divider : std_logic;

  signal data_out_enable_vector_divider : std_logic;

  -- DATA
  signal size_in_vector_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal rest_out_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN / DATA_B_IN = M_A_IN / M_B_IN · 2^(E_A_IN - E_B_IN)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;
      REST_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_I_ENABLE <= '0';
      DATA_OUT_J_ENABLE <= '0';

      -- Control Internal
      start_vector_divider <= '0';

      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

      data_a_in_enable_vector_divider <= '0';
      data_b_in_enable_vector_divider <= '0';

      data_a_in_i_divider_int <= '0';
      data_a_in_j_divider_int <= '0';
      data_b_in_i_divider_int <= '0';
      data_b_in_j_divider_int <= '0';

      -- Data Internal
      size_in_vector_divider   <= ZERO_CONTROL;
      data_a_in_vector_divider <= ZERO_DATA;
      data_b_in_vector_divider <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case divider_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

          if (START = '1') then
            -- Assignations
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            divider_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when INPUT_I_STATE =>           -- STEP 1

          if (((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1')) or (unsigned(index_j_loop) = unsigned(ZERO_CONTROL))) then
            -- Data Inputs
            data_a_in_vector_divider <= DATA_A_IN;

            -- Control Internal
            data_a_in_enable_vector_divider <= '1';

            data_a_in_i_divider_int <= '1';
            data_a_in_j_divider_int <= '1';
          else
            -- Control Internal
            data_a_in_enable_vector_divider <= '0';
          end if;

          if (((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1')) or (unsigned(index_j_loop) = unsigned(ZERO_CONTROL))) then
            -- Data Inputs
            data_b_in_vector_divider <= DATA_B_IN;

            -- Control Internal
            data_b_in_enable_vector_divider <= '1';

            data_b_in_i_divider_int <= '1';
            data_b_in_j_divider_int <= '1';
          else
            -- Control Internal
            data_b_in_enable_vector_divider <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

          if (data_a_in_i_divider_int = '1' and data_a_in_j_divider_int = '1' and data_b_in_i_divider_int = '1' and data_b_in_j_divider_int = '1') then
            -- Data Inputs
            size_in_vector_divider <= SIZE_J_IN;

            -- Control Internal
            start_vector_divider <= '1';

            data_a_in_enable_vector_divider <= '0';
            data_b_in_enable_vector_divider <= '0';

            data_a_in_i_divider_int <= '0';
            data_a_in_j_divider_int <= '0';
            data_b_in_i_divider_int <= '0';
            data_b_in_j_divider_int <= '0';

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
              divider_ctrl_fsm_int <= ENDER_I_STATE;
            else
              divider_ctrl_fsm_int <= ENDER_J_STATE;
            end if;
          end if;

        when INPUT_J_STATE =>           -- STEP 2

          if (DATA_A_IN_J_ENABLE = '1') then
            -- Data Inputs
            data_a_in_vector_divider <= DATA_A_IN;

            -- Control Internal
            data_a_in_enable_vector_divider <= '1';

            data_a_in_j_divider_int <= '1';
          else
            -- Control Internal
            data_a_in_enable_vector_divider <= '0';
          end if;

          if (DATA_B_IN_J_ENABLE = '1') then
            -- Data Inputs
            data_b_in_vector_divider <= DATA_B_IN;

            -- Control Internal
            data_b_in_enable_vector_divider <= '1';

            data_b_in_j_divider_int <= '1';
          else
            -- Control Internal
            data_b_in_enable_vector_divider <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_J_ENABLE <= '0';

          if (data_a_in_j_divider_int = '1' and data_b_in_j_divider_int = '1') then
            -- Control Internal
            data_a_in_enable_vector_divider <= '0';
            data_b_in_enable_vector_divider <= '0';

            data_a_in_j_divider_int <= '0';
            data_b_in_j_divider_int <= '0';

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
              divider_ctrl_fsm_int <= ENDER_I_STATE;
            else
              divider_ctrl_fsm_int <= ENDER_J_STATE;
            end if;
          end if;

        when ENDER_I_STATE =>           -- STEP 3

          if (data_out_enable_vector_divider = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_vector_divider;
              REST_OUT <= rest_out_vector_divider;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              READY <= '1';

              -- Control Internal
              index_i_loop <= ZERO_CONTROL;
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              divider_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL))) then
              -- Data Outputs
              DATA_OUT <= data_out_vector_divider;
              REST_OUT <= rest_out_vector_divider;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;

              -- FSM Control
              divider_ctrl_fsm_int <= INPUT_I_STATE;
            end if;
          else
            -- Control Internal
            start_vector_divider <= '0';
          end if;

        when ENDER_J_STATE =>           -- STEP 3

          if (data_out_enable_vector_divider = '1') then
            if (unsigned(index_j_loop) < unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT <= data_out_vector_divider;
              REST_OUT <= rest_out_vector_divider;

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';

              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              divider_ctrl_fsm_int <= INPUT_J_STATE;
            end if;
          else
            -- Control Internal
            start_vector_divider <= '0';
          end if;

        when others =>
          -- FSM Control
          divider_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- VECTOR DIVIDER
  vector_divider : ntm_vector_divider
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_divider,
      READY => ready_vector_divider,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_divider,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_divider,

      DATA_OUT_ENABLE => data_out_enable_vector_divider,

      -- DATA
      SIZE_IN   => size_in_vector_divider,
      DATA_A_IN => data_a_in_vector_divider,
      DATA_B_IN => data_b_in_vector_divider,

      DATA_OUT => data_out_vector_divider,
      REST_OUT => rest_out_vector_divider
      );

end architecture;