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

entity ntm_matrix_mod is
  generic (
    DATA_SIZE  : integer := 512;
    INDEX_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_IN_I_ENABLE : in std_logic;
    DATA_IN_J_ENABLE : in std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_matrix_mod_architecture of ntm_matrix_mod is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type mod_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    ENDER_STATE                         -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal mod_ctrl_fsm_int : mod_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(INDEX_SIZE-1 downto 0);

  signal data_in_i_mod_int : std_logic;
  signal data_in_j_mod_int : std_logic;

  -- MOD
  -- CONTROL
  signal start_vector_mod : std_logic;
  signal ready_vector_mod : std_logic;

  signal data_in_enable_vector_mod : std_logic;

  signal data_out_enable_vector_mod : std_logic;

  -- DATA
  signal modulo_in_vector_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_IN mod MODULO_IN

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

      -- Control Internal
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;

      data_in_i_mod_int <= '0';
      data_in_j_mod_int <= '0';

      -- Data Internal
      modulo_in_vector_mod <= ZERO;
      data_in_vector_mod   <= ZERO;

    elsif (rising_edge(CLK)) then

      case mod_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_i_loop <= ZERO;
            index_j_loop <= ZERO;

            -- FSM Control
            mod_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when INPUT_I_STATE =>  -- STEP 1

          if ((DATA_IN_I_ENABLE = '1') or (index_i_loop = ZERO)) then
            -- Data Inputs
            modulo_in_vector_mod <= MODULO_IN;

            data_in_vector_mod <= DATA_IN;

            if (index_i_loop = ZERO) then
              -- Control Internal
              start_vector_mod <= '1';
            end if;

            data_in_enable_vector_mod <= '1';

            data_in_i_mod_int <= '1';

            -- FSM Control
            mod_ctrl_fsm_int <= ENDER_STATE;
          else
            -- Control Outputs
            DATA_OUT_I_ENABLE <= '0';
            DATA_OUT_J_ENABLE <= '0';

            -- Control Internal
            data_in_enable_vector_mod <= '0';
          end if;

        when INPUT_J_STATE =>  -- STEP 2

          if ((DATA_IN_J_ENABLE = '1') or (index_j_loop = ZERO)) then
            -- Data Inputs
            modulo_in_vector_mod <= MODULO_IN;
            size_in_vector_mod   <= SIZE_J_IN;

            data_in_vector_mod <= DATA_IN;

            if (index_j_loop = ZERO) then
              -- Control Internal
              start_vector_mod <= '1';
            end if;

            data_in_enable_vector_mod <= '1';

            data_in_j_mod_int <= '1';

            -- FSM Control
            mod_ctrl_fsm_int <= ENDER_STATE;
          else
            -- Control Outputs
            DATA_OUT_J_ENABLE <= '0';

            -- Control Internal
            data_in_enable_vector_mod <= '0';
          end if;

        when ENDER_STATE =>  -- STEP 3

          if (ready_vector_mod = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(unsigned(SIZE_J_IN)-unsigned(ONE)))) then
              -- Control Outputs
              READY <= '1';

              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              mod_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(unsigned(SIZE_J_IN)-unsigned(ONE)))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              mod_ctrl_fsm_int <= INPUT_I_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(unsigned(SIZE_J_IN)-unsigned(ONE)))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              mod_ctrl_fsm_int <= INPUT_J_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_vector_mod;
          else
            -- Control Internal
            start_vector_mod <= '0';

            data_in_i_mod_int <= '0';
            data_in_j_mod_int <= '0';
          end if;

        when others =>
          -- FSM Control
          mod_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MOD
  vector_mod : ntm_vector_mod
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_mod,
      READY => ready_vector_mod,

      DATA_IN_ENABLE => data_in_enable_vector_mod,

      DATA_OUT_ENABLE => data_out_enable_vector_mod,

      -- DATA
      MODULO_IN => modulo_in_vector_mod,
      SIZE_IN   => size_in_vector_mod,
      DATA_IN   => data_in_vector_mod,
      DATA_OUT  => data_out_vector_mod
      );

end architecture;
