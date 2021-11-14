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

entity dnc_content_based_addressing is
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

    K_IN_ENABLE : in std_logic;         -- for j in 0 to J-1

    M_IN_I_ENABLE : in std_logic;       -- for i in 0 to I-1
    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to J-1

    C_OUT_ENABLE : out std_logic;       -- for i in 0 to I-1

    -- DATA
    SIZE_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_J_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

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
    STARTER_STATE,  -- STEP 0
    VECTOR_COSINE_SIMILARITY_STATE,  -- STEP 1
    VECTOR_EXPONENTIATOR_STATE,  -- STEP 2
    VECTOR_SOFTMAX_STATE,  -- STEP 3
    ENDER_STATE  -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_loop : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_a_in_enable_vector_exponentiator : std_logic;
  signal data_b_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR COSINE SIMILARITY
  -- CONTROL
  signal start_vector_cosine : std_logic;
  signal ready_vector_cosine : std_logic;

  signal data_a_in_vector_enable_vector_cosine : std_logic;
  signal data_a_in_scalar_enable_vector_cosine : std_logic;
  signal data_b_in_vector_enable_vector_cosine : std_logic;
  signal data_b_in_scalar_enable_vector_cosine : std_logic;

  signal data_out_vector_enable_vector_cosine : std_logic;
  signal data_out_scalar_enable_vector_cosine : std_logic;

  -- DATA
  signal modulo_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_cosine   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_cosine : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosine  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SOFTMAX
  -- CONTROL
  signal start_vector_softmax : std_logic;
  signal ready_vector_softmax : std_logic;

  signal data_in_vector_enable_vector_softmax : std_logic;
  signal data_in_scalar_enable_vector_softmax : std_logic;

  signal data_out_vector_enable_vector_softmax : std_logic;
  signal data_out_scalar_enable_vector_softmax : std_logic;

  -- DATA
  signal modulo_in_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- C(M,k,beta)[i] = softmax(exponentiation(e,cosine(k,M)·beta))[i]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      C_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_loop <= ZERO;

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_COSINE_SIMILARITY_STATE;
          end if;

        when VECTOR_COSINE_SIMILARITY_STATE =>  -- STEP 1

        when VECTOR_EXPONENTIATOR_STATE =>  -- STEP 2

        when VECTOR_SOFTMAX_STATE =>  -- STEP 3

        when ENDER_STATE =>  -- STEP 4

          if (data_out_vector_enable_vector_softmax = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_I_IN) - unsigned(ONE)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_COSINE_SIMILARITY_STATE;
            end if;

            -- Control Outputs
            C_OUT_ENABLE <= '1';
          end if;

          -- Data Outputs
          C_OUT <= data_out_vector_softmax;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- DATA
  -- VECTOR COSINE SIMILARITY
  modulo_in_vector_cosine <= FULL;
  size_in_vector_cosine   <= SIZE_I_IN;
  length_in_vector_cosine <= SIZE_J_IN;
  data_a_in_vector_cosine <= K_IN;
  data_b_in_vector_cosine <= M_IN;

  -- VECTOR MULTIPLIER
  modulo_in_vector_multiplier <= FULL;
  size_in_vector_multiplier   <= SIZE_I_IN;
  data_a_in_vector_multiplier <= data_out_vector_cosine;
  data_b_in_vector_multiplier <= BETA_IN;

  -- VECTOR EXPONENTIATOR
  modulo_in_vector_exponentiator <= FULL;
  size_in_vector_exponentiator   <= SIZE_I_IN;
  data_a_in_vector_exponentiator <= FULL;
  data_b_in_vector_exponentiator <= data_out_vector_multiplier;

  -- VECTOR SOFTMAX
  modulo_in_vector_softmax <= FULL;
  size_in_vector_softmax   <= SIZE_I_IN;
  length_in_vector_softmax <= SIZE_J_IN;
  data_in_vector_softmax   <= data_out_vector_exponentiator;

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

  -- VECTOR EXPONENTIATOR
  vector_exponentiator : ntm_vector_exponentiator
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_exponentiator,
      READY => ready_vector_exponentiator,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_exponentiator,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_exponentiator,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      MODULO_IN => modulo_in_vector_exponentiator,
      SIZE_IN   => size_in_vector_exponentiator,
      DATA_A_IN => data_a_in_vector_exponentiator,
      DATA_B_IN => data_b_in_vector_exponentiator,
      DATA_OUT  => data_out_vector_exponentiator
      );

  -- VECTOR COSINE SIMILARITY
  vector_cosine_similarity_function : ntm_vector_cosine_similarity_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_cosine,
      READY => ready_vector_cosine,

      DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_vector_cosine,
      DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_vector_cosine,
      DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_vector_cosine,
      DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_vector_cosine,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_cosine,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_cosine,

      -- DATA
      MODULO_IN => modulo_in_vector_cosine,
      SIZE_IN   => size_in_vector_cosine,
      LENGTH_IN => length_in_vector_cosine,
      DATA_A_IN => data_a_in_vector_cosine,
      DATA_B_IN => data_b_in_vector_cosine,
      DATA_OUT  => data_out_vector_cosine
      );

  -- VECTOR SOFTMAX
  vector_softmax_function : ntm_vector_softmax_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_softmax,
      READY => ready_vector_softmax,

      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_softmax,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_softmax,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_softmax,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_softmax,

      -- DATA
      MODULO_IN => modulo_in_vector_softmax,
      SIZE_IN   => size_in_vector_softmax,
      LENGTH_IN => length_in_vector_softmax,
      DATA_IN   => data_in_vector_softmax,
      DATA_OUT  => data_out_vector_softmax
      );

end architecture;
