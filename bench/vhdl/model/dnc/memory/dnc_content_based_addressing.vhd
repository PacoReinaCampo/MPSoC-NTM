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

entity dnc_content_based_addressing is
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

    K_IN_ENABLE : in std_logic;         -- for j in 0 to J-1

    K_OUT_ENABLE : out std_logic;       -- for j in 0 to J-1

    M_IN_I_ENABLE : in std_logic;       -- for i in 0 to I-1
    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to J-1

    M_OUT_I_ENABLE : out std_logic;     -- for i in 0 to I-1
    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to J-1

    C_OUT_ENABLE : out std_logic;       -- for i in 0 to I-1

    -- DATA
    SIZE_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);

    C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_content_based_addressing_architecture of dnc_content_based_addressing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_STATE,                  -- STEP 1
    VECTOR_COSINE_SIMILARITY_STATE,     -- STEP 2
    INPUT_SECOND_STATE,                 -- STEP 3
    VECTOR_MULTIPLIER_STATE,            -- STEP 4
    VECTOR_EXPONENTIATOR_STATE,         -- STEP 5
    VECTOR_SOFTMAX_STATE                -- STEP 6
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

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator_function : std_logic;
  signal ready_vector_exponentiator_function : std_logic;

  signal data_in_enable_vector_exponentiator_function : std_logic;

  signal data_out_enable_vector_exponentiator_function : std_logic;

  -- DATA
  signal size_in_vector_exponentiator_function  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_exponentiator_function  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator_function : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSINE SIMILARITY
  -- CONTROL
  signal start_vector_cosine_similarity : std_logic;
  signal ready_vector_cosine_similarity : std_logic;

  signal data_a_in_enable_vector_cosine_similarity : std_logic;
  signal data_b_in_enable_vector_cosine_similarity : std_logic;

  signal data_out_enable_vector_cosine_similarity : std_logic;

  -- DATA
  signal length_in_vector_cosine_similarity : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_cosine_similarity : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosine_similarity  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SOFTMAX
  -- CONTROL
  signal start_vector_softmax : std_logic;
  signal ready_vector_softmax : std_logic;

  signal data_in_enable_vector_softmax : std_logic;

  signal data_enable_vector_softmax : std_logic;

  signal data_out_enable_vector_softmax : std_logic;

  -- DATA
  signal size_in_vector_softmax  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- C(M,k,beta)[i] = softmax(exponentiation(EULER,cosine_similarity(k,M)·beta))[i]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      C_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      C_OUT_ENABLE <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          C_OUT_ENABLE <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            if (index_loop = ZERO_CONTROL) then
              -- Control Internal
              start_vector_cosine_similarity <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_STATE;
          else
            -- Control Internal
            start_vector_cosine_similarity <= '0';
          end if;

        when INPUT_FIRST_STATE =>       -- STEP 1

        when VECTOR_COSINE_SIMILARITY_STATE =>  -- STEP 2

          if (data_out_enable_vector_cosine_similarity = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_integer_multiplier <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          else
            -- Control Internal
            start_vector_cosine_similarity <= '0';
          end if;

        when INPUT_SECOND_STATE =>      -- STEP 3

        when VECTOR_MULTIPLIER_STATE =>  -- STEP 4

          if (data_out_enable_vector_integer_multiplier = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_exponentiator_function <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_EXPONENTIATOR_STATE;
          else
            -- Control Internal
            start_vector_integer_multiplier <= '0';
          end if;

        when VECTOR_EXPONENTIATOR_STATE =>  -- STEP 5

          if (data_out_enable_vector_exponentiator_function = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_softmax <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_SOFTMAX_STATE;
          else
            -- Control Internal
            start_vector_exponentiator_function <= '0';
          end if;

        when VECTOR_SOFTMAX_STATE =>    -- STEP 6

          if (data_out_enable_vector_softmax = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_I_IN) - unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_COSINE_SIMILARITY_STATE;
            end if;

            -- Data Outputs
            C_OUT <= data_out_vector_softmax;

            -- Control Outputs
            C_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            C_OUT_ENABLE <= '0';

            -- Control Internal
            start_vector_softmax <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- DATA
  -- VECTOR COSINE SIMILARITY
  length_in_vector_cosine_similarity <= SIZE_J_IN;
  data_a_in_vector_cosine_similarity <= K_IN;
  data_b_in_vector_cosine_similarity <= M_IN;

  -- VECTOR MULTIPLIER
  size_in_vector_integer_multiplier   <= SIZE_I_IN;
  data_a_in_vector_integer_multiplier <= data_out_vector_cosine_similarity;
  data_b_in_vector_integer_multiplier <= BETA_IN;

  -- VECTOR EXPONENTIATOR
  size_in_vector_exponentiator_function <= SIZE_I_IN;
  data_in_vector_exponentiator_function <= data_out_vector_integer_multiplier;

  -- VECTOR SOFTMAX
  size_in_vector_softmax <= SIZE_J_IN;
  data_in_vector_softmax <= data_out_vector_exponentiator_function;

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

  -- VECTOR EXPONENTIATOR
  vector_exponentiator_function : ntm_vector_exponentiator_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_exponentiator_function,
      READY => ready_vector_exponentiator_function,

      DATA_IN_ENABLE => data_in_enable_vector_exponentiator_function,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator_function,

      -- DATA
      SIZE_IN  => size_in_vector_exponentiator_function,
      DATA_IN  => data_in_vector_exponentiator_function,
      DATA_OUT => data_out_vector_exponentiator_function
      );

  -- VECTOR COSINE SIMILARITY
  vector_cosine_similarity : ntm_vector_cosine_similarity
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_cosine_similarity,
      READY => ready_vector_cosine_similarity,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_cosine_similarity,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_cosine_similarity,

      DATA_OUT_ENABLE => data_out_enable_vector_cosine_similarity,

      -- DATA
      LENGTH_IN => length_in_vector_cosine_similarity,
      DATA_A_IN => data_a_in_vector_cosine_similarity,
      DATA_B_IN => data_b_in_vector_cosine_similarity,
      DATA_OUT  => data_out_vector_cosine_similarity
      );

  -- VECTOR SOFTMAX
  vector_softmax : ntm_vector_softmax
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_softmax,
      READY => ready_vector_softmax,

      DATA_IN_ENABLE => data_in_enable_vector_softmax,

      DATA_ENABLE => data_enable_vector_softmax,

      DATA_OUT_ENABLE => data_out_enable_vector_softmax,

      -- DATA
      SIZE_IN  => size_in_vector_softmax,
      DATA_IN  => data_in_vector_softmax,
      DATA_OUT => data_out_vector_softmax
      );

end architecture;
