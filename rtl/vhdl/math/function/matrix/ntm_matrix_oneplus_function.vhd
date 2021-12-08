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

entity ntm_matrix_oneplus_function is
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
    SIZE_I_IN : in  std_logic_vector(INDEX_SIZE-1 downto 0);
    SIZE_J_IN : in  std_logic_vector(INDEX_SIZE-1 downto 0);
    DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_matrix_oneplus_function_architecture of ntm_matrix_oneplus_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type oneplus_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    ENDER_STATE                         -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants

  constant ZERO_INDEX : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_INDEX  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  constant ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal oneplus_ctrl_fsm_int : oneplus_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(INDEX_SIZE-1 downto 0);

  -- TANH
  -- CONTROL
  signal start_vector_oneplus : std_logic;
  signal ready_vector_oneplus : std_logic;

  signal data_in_enable_vector_oneplus : std_logic;

  signal data_out_enable_vector_oneplus : std_logic;

  -- DATA
  signal modulo_in_vector_oneplus : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_oneplus   : std_logic_vector(INDEX_SIZE-1 downto 0);
  signal data_in_vector_oneplus   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_oneplus  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      index_i_loop <= ZERO_INDEX;
      index_j_loop <= ZERO_INDEX;

    elsif (rising_edge(CLK)) then

      case oneplus_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignations
            index_i_loop <= ZERO_INDEX;
            index_j_loop <= ZERO_INDEX;

            -- FSM Control
            oneplus_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when INPUT_I_STATE =>  -- STEP 1

          if (DATA_IN_I_ENABLE = '1') then
            -- Data Inputs
            modulo_in_vector_oneplus <= MODULO_IN;

            data_in_vector_oneplus <= DATA_IN;

            if (index_i_loop = ZERO_INDEX) then
              -- Control Internal
              start_vector_oneplus <= '1';
            end if;

            data_in_enable_vector_oneplus <= '1';

            -- FSM Control
            oneplus_ctrl_fsm_int <= ENDER_STATE;
          else
            -- Control Internal
            data_in_enable_vector_oneplus <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';

        when INPUT_J_STATE =>  -- STEP 2

          if (DATA_IN_J_ENABLE = '1') then
            -- Data Inputs
            modulo_in_vector_oneplus <= MODULO_IN;
            size_in_vector_oneplus   <= SIZE_J_IN;

            data_in_vector_oneplus <= DATA_IN;

            if (index_j_loop = ZERO_INDEX) then
              -- Control Internal
              start_vector_oneplus <= '1';
            end if;

            data_in_enable_vector_oneplus <= '1';

            -- FSM Control
            oneplus_ctrl_fsm_int <= ENDER_STATE;
          else
            -- Control Internal
            data_in_enable_vector_oneplus <= '0';
          end if;

          -- Control Outputs
          DATA_OUT_J_ENABLE <= '0';

        when ENDER_STATE =>  -- STEP 3

          if (ready_vector_oneplus = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_I_IN)-unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_INDEX))) then
              -- Control Outputs
              READY <= '1';

              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              oneplus_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_INDEX)) and (unsigned(index_j_loop) = unsigned(SIZE_J_IN)-unsigned(ONE_INDEX))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_INDEX));
              index_j_loop <= ZERO_INDEX;

              -- Control Outputs
              DATA_OUT_I_ENABLE <= '1';
              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              oneplus_ctrl_fsm_int <= INPUT_I_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_I_IN)-unsigned(ONE_INDEX)) and (unsigned(index_j_loop) < unsigned(SIZE_J_IN)-unsigned(ONE_INDEX))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_INDEX));

              -- Control Outputs
              DATA_OUT_J_ENABLE <= '1';

              -- FSM Control
              oneplus_ctrl_fsm_int <= INPUT_J_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_vector_oneplus;
          else
            -- Control Internal
            start_vector_oneplus <= '0';
          end if;

        when others =>
          -- FSM Control
          oneplus_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- ONEPLUS
  vector_oneplus_function : ntm_vector_oneplus_function
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_oneplus,
      READY => ready_vector_oneplus,

      DATA_IN_ENABLE => data_in_enable_vector_oneplus,

      DATA_OUT_ENABLE => data_out_enable_vector_oneplus,

      -- DATA
      MODULO_IN => modulo_in_vector_oneplus,
      SIZE_IN   => size_in_vector_oneplus,
      DATA_IN   => data_in_vector_oneplus,
      DATA_OUT  => data_out_vector_oneplus
      );

end architecture;
