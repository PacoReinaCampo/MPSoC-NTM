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

entity ntm_matrix_gcd is
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

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_matrix_gcd_architecture of ntm_matrix_gcd is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type gcd_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    ENDER_STATE                         -- STEP 3
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
  signal gcd_ctrl_fsm_int : gcd_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_a_in_i_gcd_int : std_logic;
  signal data_a_in_j_gcd_int : std_logic;
  signal data_b_in_i_gcd_int : std_logic;
  signal data_b_in_j_gcd_int : std_logic;

  -- GCD
  -- CONTROL
  signal start_vector_gcd : std_logic;
  signal ready_vector_gcd : std_logic;

  signal data_a_in_enable_vector_gcd : std_logic;
  signal data_b_in_enable_vector_gcd : std_logic;

  signal data_out_enable_vector_gcd : std_logic;

  -- DATA
  signal modulo_in_vector_gcd : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_gcd   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_gcd : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_gcd : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_gcd  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_B_IN + DATA_A_IN mod MODULO_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      DATA_OUT_I_ENABLE <= '0';
      DATA_OUT_J_ENABLE <= '0';

      -- Assignations
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;

      data_a_in_i_gcd_int <= '0';
      data_a_in_j_gcd_int <= '0';
      data_b_in_i_gcd_int <= '0';
      data_b_in_j_gcd_int <= '0';

      -- Data Internal
      modulo_in_vector_gcd <= ZERO;
      data_a_in_vector_gcd <= ZERO;
      data_b_in_vector_gcd <= ZERO;

    elsif (rising_edge(CLK)) then

      case gcd_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignations
            index_i_loop <= ZERO;
            index_j_loop <= ZERO;

            -- FSM Control
            gcd_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when INPUT_I_STATE =>  -- STEP 1

          if (DATA_A_IN_I_ENABLE = '1') then
            -- Data Inputs
            data_a_in_vector_gcd <= DATA_A_IN;

            -- Control Internal
            data_a_in_enable_vector_gcd <= '1';

            data_a_in_i_gcd_int <= '1';
          else
            -- Control Outputs
            DATA_OUT_I_ENABLE <= '0';

            -- Control Internal
            data_a_in_enable_vector_gcd <= '0';
          end if;

          if (DATA_B_IN_I_ENABLE = '1') then
            -- Data Inputs
            data_b_in_vector_gcd <= DATA_B_IN;

            -- Control Internal
            data_b_in_enable_vector_gcd <= '1';

            data_b_in_i_gcd_int <= '1';
          else
            -- Control Outputs
            DATA_OUT_J_ENABLE <= '0';

            -- Control Internal
            data_b_in_enable_vector_gcd <= '0';
          end if;

          if (data_a_in_i_gcd_int = '1' and data_b_in_i_gcd_int = '1') then
            if (index_i_loop = ZERO) then
              -- Control Internal
              start_vector_gcd <= '1';
            end if;

            data_a_in_i_gcd_int <= '0';
            data_b_in_i_gcd_int <= '0';

            -- Data Inputs
            modulo_in_vector_gcd <= MODULO_IN;

            -- FSM Control
            gcd_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when INPUT_J_STATE =>  -- STEP 2

          if ((DATA_A_IN_J_ENABLE = '1') or (index_j_loop = ZERO)) then
            -- Data Inputs
            data_a_in_vector_gcd <= DATA_A_IN;

            -- Control Internal
            data_a_in_enable_vector_gcd <= '1';

            data_a_in_j_gcd_int <= '1';
          else
            -- Control Internal
            data_a_in_enable_vector_gcd <= '0';
          end if;

          if ((DATA_B_IN_J_ENABLE = '1') or (index_j_loop = ZERO)) then
            -- Data Inputs
            data_b_in_vector_gcd <= DATA_B_IN;

            -- Control Internal
            data_b_in_enable_vector_gcd <= '1';

            data_b_in_j_gcd_int <= '1';
          else
            -- Control Outputs
            DATA_OUT_J_ENABLE <= '0';

            -- Control Internal
            data_b_in_enable_vector_gcd <= '0';
          end if;

          if (data_a_in_j_gcd_int = '1' and data_b_in_j_gcd_int = '1') then
            if (index_j_loop = ZERO) then
              -- Control Internal
              start_vector_gcd <= '1';
            end if;

            data_a_in_j_gcd_int <= '0';
            data_b_in_j_gcd_int <= '0';

            -- Data Inputs
            modulo_in_vector_gcd <= MODULO_IN;
            size_in_vector_gcd   <= SIZE_J_IN;

            -- FSM Control
            gcd_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>  -- STEP 3

          if (ready_vector_gcd = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(unsigned(SIZE_J_IN)-unsigned(ONE)))) then
              -- Control Outputs
              READY <= '1';

              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              gcd_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(unsigned(SIZE_J_IN)-unsigned(ONE)))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              gcd_ctrl_fsm_int <= INPUT_I_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(unsigned(SIZE_J_IN)-unsigned(ONE)))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              gcd_ctrl_fsm_int <= INPUT_J_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_vector_gcd;
          else
            -- Control Internal
            start_vector_gcd <= '0';

            data_a_in_i_gcd_int <= '0';
            data_a_in_j_gcd_int <= '0';
            data_b_in_i_gcd_int <= '0';
            data_b_in_j_gcd_int <= '0';
          end if;

        when others =>
          -- FSM Control
          gcd_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- GCD
  vector_gcd : ntm_vector_gcd
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_gcd,
      READY => ready_vector_gcd,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_gcd,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_gcd,

      DATA_OUT_ENABLE => data_out_enable_vector_gcd,

      -- DATA
      MODULO_IN => modulo_in_vector_gcd,
      SIZE_IN   => size_in_vector_gcd,
      DATA_A_IN => data_a_in_vector_gcd,
      DATA_B_IN => data_b_in_vector_gcd,
      DATA_OUT  => data_out_vector_gcd
      );

end architecture;
