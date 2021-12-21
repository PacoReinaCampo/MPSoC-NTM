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

entity ntm_tensor_divider is
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
    DATA_A_IN_K_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_B_IN_K_ENABLE : in std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;
    DATA_OUT_K_ENABLE : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_tensor_divider_architecture of ntm_tensor_divider is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type divider_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    INPUT_K_STATE,                      -- STEP 3
    ENDER_I_STATE,                      -- STEP 4
    ENDER_J_STATE,                      -- STEP 5
    ENDER_K_STATE                       -- STEP 6
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
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_divider_int : std_logic;
  signal data_a_in_j_divider_int : std_logic;
  signal data_a_in_k_divider_int : std_logic;
  signal data_b_in_i_divider_int : std_logic;
  signal data_b_in_j_divider_int : std_logic;
  signal data_b_in_k_divider_int : std_logic;

  -- MATRIX DIVIDER
  -- CONTROL
  signal start_matrix_divider : std_logic;
  signal ready_matrix_divider : std_logic;

  signal data_a_in_i_enable_matrix_divider : std_logic;
  signal data_a_in_j_enable_matrix_divider : std_logic;
  signal data_b_in_i_enable_matrix_divider : std_logic;
  signal data_b_in_j_enable_matrix_divider : std_logic;

  signal data_out_i_enable_matrix_divider : std_logic;
  signal data_out_j_enable_matrix_divider : std_logic;

  -- DATA
  signal modulo_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN / DATA_B_IN mod MODULO_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_I_ENABLE <= '0';
      DATA_OUT_J_ENABLE <= '0';
      DATA_OUT_K_ENABLE <= '0';

      -- Control Internal
      start_matrix_divider <= '0';

      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;
      index_k_loop <= ZERO_CONTROL;

      data_a_in_i_enable_matrix_divider <= '0';
      data_a_in_j_enable_matrix_divider <= '0';
      data_b_in_i_enable_matrix_divider <= '0';
      data_b_in_j_enable_matrix_divider <= '0';

      data_a_in_i_divider_int <= '0';
      data_a_in_j_divider_int <= '0';
      data_a_in_k_divider_int <= '0';
      data_b_in_i_divider_int <= '0';
      data_b_in_j_divider_int <= '0';
      data_b_in_k_divider_int <= '0';

      -- Data Internal
      modulo_in_matrix_divider <= ZERO_DATA;
      size_i_in_matrix_divider <= ZERO_CONTROL;
      size_j_in_matrix_divider <= ZERO_CONTROL;
      data_a_in_matrix_divider <= ZERO_DATA;
      data_b_in_matrix_divider <= ZERO_DATA;

    elsif (rising_edge(CLK)) then

      case divider_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          if (START = '1') then
            -- Assignations
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            divider_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when INPUT_I_STATE =>  -- STEP 1

          if (((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1') and (DATA_A_IN_K_ENABLE = '1')) or ((index_j_loop = ZERO_CONTROL) and (index_k_loop = ZERO_CONTROL))) then
            -- Data Inputs
            data_a_in_matrix_divider <= DATA_A_IN;

            -- Control Internal
            data_a_in_i_enable_matrix_divider <= '1';
            data_a_in_j_enable_matrix_divider <= '1';

            data_a_in_i_divider_int <= '1';
            data_a_in_j_divider_int <= '1';
            data_a_in_k_divider_int <= '1';
          else
            -- Control Internal
            data_a_in_i_enable_matrix_divider <= '0';
            data_a_in_j_enable_matrix_divider <= '0';
          end if;

          if (((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1') and (DATA_B_IN_K_ENABLE = '1')) or ((index_j_loop = ZERO_CONTROL) and (index_k_loop = ZERO_CONTROL))) then
            -- Data Inputs
            data_b_in_matrix_divider <= DATA_B_IN;

            -- Control Internal
            data_b_in_i_enable_matrix_divider <= '1';
            data_b_in_j_enable_matrix_divider <= '1';

            data_b_in_i_divider_int <= '1';
            data_b_in_j_divider_int <= '1';
            data_b_in_k_divider_int <= '1';
          else
            -- Control Internal
            data_b_in_i_enable_matrix_divider <= '0';
            data_b_in_j_enable_matrix_divider <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          if (data_a_in_i_divider_int = '1' and data_a_in_j_divider_int = '1' and data_a_in_k_divider_int = '1' and data_b_in_i_divider_int = '1' and data_b_in_j_divider_int = '1' and data_b_in_k_divider_int = '1') then
            -- Data Inputs
            modulo_in_matrix_divider <= MODULO_IN;
            size_i_in_matrix_divider <= SIZE_J_IN;
            size_j_in_matrix_divider <= SIZE_K_IN;

            -- Control Internal
            start_matrix_divider <= '1';

            data_a_in_i_enable_matrix_divider <= '0';
            data_a_in_j_enable_matrix_divider <= '0';
            data_b_in_i_enable_matrix_divider <= '0';
            data_b_in_j_enable_matrix_divider <= '0';

            data_a_in_i_divider_int <= '0';
            data_a_in_j_divider_int <= '0';
            data_a_in_k_divider_int <= '0';
            data_b_in_i_divider_int <= '0';
            data_b_in_j_divider_int <= '0';
            data_b_in_k_divider_int <= '0';

            -- FSM Control
           divider_ctrl_fsm_int <= ENDER_K_STATE;
          end if;

        when INPUT_J_STATE =>  -- STEP 2

          if (((DATA_A_IN_J_ENABLE = '1') and (DATA_A_IN_K_ENABLE = '1')) or (index_k_loop = ZERO_CONTROL)) then
            -- Data Inputs
            data_a_in_matrix_divider <= DATA_A_IN;

            -- Control Internal
            data_a_in_j_enable_matrix_divider <= '1';

            data_a_in_j_divider_int <= '1';
            data_a_in_k_divider_int <= '1';
          else
            -- Control Internal
            data_a_in_j_enable_matrix_divider <= '0';
          end if;

          if (((DATA_B_IN_J_ENABLE = '1') and (DATA_B_IN_K_ENABLE = '1')) or (index_k_loop = ZERO_CONTROL)) then
            -- Data Inputs
            data_b_in_matrix_divider <= DATA_B_IN;

            -- Control Internal
            data_b_in_j_enable_matrix_divider <= '1';

            data_b_in_j_divider_int <= '1';
            data_b_in_k_divider_int <= '1';
          else
            -- Control Internal
            data_b_in_j_enable_matrix_divider <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          if (data_a_in_j_divider_int = '1' and data_a_in_k_divider_int = '1' and data_b_in_j_divider_int = '1' and data_b_in_k_divider_int = '1') then
            -- Data Inputs
            data_a_in_j_enable_matrix_divider <= '0';
            data_b_in_j_enable_matrix_divider <= '0';

            data_a_in_j_divider_int <= '0';
            data_a_in_k_divider_int <= '0';
            data_b_in_j_divider_int <= '0';
            data_b_in_k_divider_int <= '0';

            -- FSM Control
           divider_ctrl_fsm_int <= ENDER_K_STATE;
          end if;

        when INPUT_K_STATE =>  -- STEP 3

          if (DATA_A_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_a_in_matrix_divider <= DATA_A_IN;

            -- Control Internal
            data_a_in_j_enable_matrix_divider <= '1';

            data_a_in_k_divider_int <= '1';
          else
            -- Control Internal
            data_a_in_j_enable_matrix_divider <= '0';
          end if;

          if (DATA_B_IN_K_ENABLE = '1') then
            -- Data Inputs
            data_b_in_matrix_divider <= DATA_B_IN;

            -- Control Internal
            data_b_in_j_enable_matrix_divider <= '1';

            data_b_in_k_divider_int <= '1';
          else
            -- Control Internal
            data_b_in_j_enable_matrix_divider <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_K_ENABLE <= '0';

          if (data_a_in_k_divider_int = '1' and data_b_in_k_divider_int = '1') then
            -- Control Internal
            data_a_in_j_enable_matrix_divider <= '0';
            data_b_in_j_enable_matrix_divider <= '0';

            data_a_in_k_divider_int <= '0';
            data_b_in_k_divider_int <= '0';

            -- FSM Control
            if (unsigned(index_k_loop) = unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)) then
              if (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) then
                divider_ctrl_fsm_int <= ENDER_I_STATE;
              else
                divider_ctrl_fsm_int <= ENDER_J_STATE;
              end if;
            else
              divider_ctrl_fsm_int <= ENDER_K_STATE;
            end if;
          end if;

        when ENDER_I_STATE =>  -- STEP 4

          if (data_out_i_enable_matrix_divider = '1' and data_out_j_enable_matrix_divider = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)))) then
              -- Data Outputs
              DATA_OUT <= data_out_matrix_divider;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';
              DATA_OUT_K_ENABLE <= '1';

              READY <= '1';

              -- Control Internal
              index_i_loop <= ZERO_CONTROL;
              index_j_loop <= ZERO_CONTROL;
              index_k_loop <= ZERO_CONTROL;

              -- FSM Control
             divider_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)))) then
              -- Data Outputs
              DATA_OUT <= data_out_matrix_divider;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';
              DATA_OUT_K_ENABLE <= '1';

              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
              index_j_loop <= ZERO_CONTROL;
              index_k_loop <= ZERO_CONTROL;

              -- FSM Control
             divider_ctrl_fsm_int <= INPUT_I_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_divider <= '0';
          end if;

        when ENDER_J_STATE =>  -- STEP 5

          if (data_out_j_enable_matrix_divider = '1') then
            if ((unsigned(index_j_loop) < unsigned(SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)))) then
              -- Data Outputs
              DATA_OUT <= data_out_matrix_divider;

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';
              DATA_OUT_K_ENABLE <= '1';

              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
              index_k_loop <= ZERO_CONTROL;

              -- FSM Control
              divider_ctrl_fsm_int <= INPUT_J_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_divider <= '0';
          end if;

        when ENDER_K_STATE =>  -- STEP 6

          if (data_out_j_enable_matrix_divider = '1') then
            if (unsigned(index_k_loop) < unsigned(SIZE_K_IN)-unsigned(ONE_CONTROL)) then
              -- Data Outputs
              DATA_OUT <= data_out_matrix_divider;

              -- Control Outputs
              DATA_OUT_K_ENABLE <= '1';

              -- Control Internal
              index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              divider_ctrl_fsm_int <= INPUT_K_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_divider <= '0';
          end if;

        when others =>
          -- FSM Control
          divider_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MATRIX DIVIDER
    matrix_divider : ntm_matrix_divider
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_divider,
        READY => ready_matrix_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_divider,

        -- DATA
        MODULO_IN => modulo_in_matrix_divider,
        SIZE_I_IN => size_i_in_matrix_divider,
        SIZE_J_IN => size_j_in_matrix_divider,
        DATA_A_IN => data_a_in_matrix_divider,
        DATA_B_IN => data_b_in_matrix_divider,
        DATA_OUT  => data_out_matrix_divider
        );

end architecture;
