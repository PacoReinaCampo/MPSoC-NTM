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

entity ntm_vector_cosine_similarity_function is
  generic (
    I : integer := 64;

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
    SIZE_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_vector_cosine_similarity_function_architecture of ntm_vector_cosine_similarity_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type cosine_similarity_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    ENDER_STATE                         -- STEP 2
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
  signal cosine_similarity_ctrl_fsm_int : cosine_similarity_ctrl_fsm;

  -- Internal Signals
  signal index_loop : integer;

  signal data_a_in_cosine_similarity_int : std_logic;
  signal data_b_in_cosine_similarity_int : std_logic;

  -- COSINE SIMILARITY
  -- CONTROL
  signal start_scalar_cosine_similarity : std_logic;
  signal ready_scalar_cosine_similarity : std_logic;

  -- DATA
  signal modulo_in_scalar_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_scalar_cosine_similarity   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_cosine_similarity  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      index_loop <= 0;

      data_a_in_cosine_similarity_int <= '0';
      data_b_in_cosine_similarity_int <= '0';

    elsif (rising_edge(CLK)) then

      case cosine_similarity_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= INPUT_STATE;
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (data_a_in_cosine_similarity_int = '1' and data_b_in_cosine_similarity_int = '1') then
            -- Control Internal
            start_scalar_cosine_similarity <= '1';

            -- Data Inputs
            modulo_in_scalar_cosine_similarity <= MODULO_IN;
            size_in_scalar_cosine_similarity   <= SIZE_IN;

            -- FSM Control
            cosine_similarity_ctrl_fsm_int <= ENDER_STATE;
          end if;

          if (DATA_A_IN_ENABLE = '1') then
            -- Data Inputs
            data_a_in_scalar_cosine_similarity <= DATA_A_IN;

            -- Control Internal
            data_a_in_cosine_similarity_int <= '1';
          end if;

          if (DATA_B_IN_ENABLE = '1') then
            -- Data Inputs
            data_b_in_scalar_cosine_similarity <= DATA_B_IN;

            -- Control Internal
            data_b_in_cosine_similarity_int <= '1';
          end if;

          -- Control Outputs
          DATA_OUT_ENABLE <= '0';

        when ENDER_STATE =>             -- STEP 2

          if (ready_scalar_cosine_similarity = '1') then
            if (index_loop = I-1) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              cosine_similarity_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= index_loop + 1;

              -- FSM Control
              cosine_similarity_ctrl_fsm_int <= INPUT_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_scalar_cosine_similarity;

            -- Control Outputs
            DATA_OUT_ENABLE <= '1';
          else
            -- Control Internal
            start_scalar_cosine_similarity <= '0';

            data_a_in_cosine_similarity_int <= '0';
            data_b_in_cosine_similarity_int <= '0';
          end if;

        when others =>
          -- FSM Control
          cosine_similarity_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- COSINE SIMILARITY
  scalar_cosine_similarity_function : ntm_scalar_cosine_similarity_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_cosine_similarity,
      READY => ready_scalar_cosine_similarity,

      -- DATA
      MODULO_IN => modulo_in_scalar_cosine_similarity,
      SIZE_IN   => size_in_scalar_cosine_similarity,
      DATA_A_IN => data_a_in_scalar_cosine_similarity,
      DATA_B_IN => data_b_in_scalar_cosine_similarity,
      DATA_OUT  => data_out_scalar_cosine_similarity
      );

end architecture;
