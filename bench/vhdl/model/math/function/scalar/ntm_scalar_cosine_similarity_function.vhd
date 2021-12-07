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

entity ntm_scalar_cosine_similarity_function is
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

    DATA_IN_ENABLE : in std_logic;

    DATA_OUT_ENABLE : out std_logic;

    -- DATA
    MODULO_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_IN : in  std_logic_vector(INDEX_SIZE-1 downto 0);
    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_scalar_cosine_similarity_function_architecture of ntm_scalar_cosine_similarity_function is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    SCALAR_PRODUCT_STATE,               -- STEP 1
    SCALAR_MULTIPLIER_STATE,            -- STEP 2
    SCALAR_DIVIDER_STATE                -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

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
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal data_int_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_multiplier : std_logic;
  signal ready_scalar_multiplier : std_logic;

  -- DATA
  signal modulo_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_divider : std_logic;
  signal ready_scalar_divider : std_logic;

  -- DATA
  signal modulo_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT AB
  -- CONTROL
  signal start_scalar_product_ab : std_logic;
  signal ready_scalar_product_ab : std_logic;

  signal data_a_in_enable_scalar_product_ab : std_logic;
  signal data_b_in_enable_scalar_product_ab : std_logic;

  signal data_out_enable_scalar_product_ab : std_logic;

  -- DATA
  signal modulo_in_scalar_product_ab : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_product_ab : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_product_ab : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product_ab : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product_ab  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT AA
  -- CONTROL
  signal start_scalar_product_aa : std_logic;
  signal ready_scalar_product_aa : std_logic;

  signal data_a_in_enable_scalar_product_aa : std_logic;
  signal data_b_in_enable_scalar_product_aa : std_logic;

  signal data_out_enable_scalar_product_aa : std_logic;

  -- DATA
  signal modulo_in_scalar_product_aa : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_product_aa : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_product_aa : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product_aa : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product_aa  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT BB
  -- CONTROL
  signal start_scalar_product_bb : std_logic;
  signal ready_scalar_product_bb : std_logic;

  signal data_a_in_enable_scalar_product_bb : std_logic;
  signal data_b_in_enable_scalar_product_bb : std_logic;

  signal data_out_enable_scalar_product_bb : std_logic;

  -- DATA
  signal modulo_in_scalar_product_bb : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_product_bb : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_product_bb : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product_bb : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product_bb  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = (DATA_A_IN · DATA_B_IN)/((DATA_A_IN · DATA_A_IN)(DATA_B_IN · DATA_B_IN))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Internal
            start_scalar_product_ab <= '1';
            start_scalar_product_aa <= '1';
            start_scalar_product_bb <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_PRODUCT_STATE;
          else
            -- Control Internal
            start_scalar_product_ab <= '0';
            start_scalar_product_aa <= '0';
            start_scalar_product_bb <= '0';
          end if;

        when SCALAR_PRODUCT_STATE =>  -- STEP 1

          if (ready_scalar_product_ab = '1' and ready_scalar_product_aa = '1' and ready_scalar_product_bb = '1') then
            -- Control Internal
            start_scalar_multiplier <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_MULTIPLIER_STATE;
          else
            -- Control Internal
            start_scalar_product_ab <= '0';
            start_scalar_product_aa <= '0';
            start_scalar_product_bb <= '0';
          end if;

        when SCALAR_MULTIPLIER_STATE =>  -- STEP 2

          if (ready_scalar_multiplier = '1') then
            -- Control Internal
            start_scalar_divider <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= SCALAR_DIVIDER_STATE;
          else
            -- Control Internal
            start_scalar_multiplier <= '0';
          end if;

        when SCALAR_DIVIDER_STATE =>  -- STEP 3

          if (ready_scalar_divider = '1') then
            -- Data Outputs
            DATA_OUT <= data_out_scalar_divider;

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          else
            -- Control Internal
            start_scalar_divider <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- SCALAR PRODUCT AB
  data_a_in_enable_scalar_product_ab <= DATA_IN_ENABLE;
  data_b_in_enable_scalar_product_ab <= DATA_IN_ENABLE;

  -- SCALAR PRODUCT AA
  data_a_in_enable_scalar_product_aa <= DATA_IN_ENABLE;
  data_b_in_enable_scalar_product_aa <= DATA_IN_ENABLE;

  -- SCALAR PRODUCT BB
  data_a_in_enable_scalar_product_bb <= DATA_IN_ENABLE;
  data_b_in_enable_scalar_product_bb <= DATA_IN_ENABLE;

  -- DATA
  -- SCALAR MULTIPLIER AB
  modulo_in_scalar_product_ab <= MODULO_IN;
  length_in_scalar_product_ab <= LENGTH_IN;
  data_a_in_scalar_product_ab <= DATA_A_IN;
  data_b_in_scalar_product_ab <= DATA_B_IN;

  -- SCALAR MULTIPLIER AA
  modulo_in_scalar_product_ab <= MODULO_IN;
  length_in_scalar_product_ab <= LENGTH_IN;
  data_a_in_scalar_product_ab <= DATA_A_IN;
  data_b_in_scalar_product_ab <= DATA_A_IN;

  -- SCALAR MULTIPLIER BB
  modulo_in_scalar_product_ab <= MODULO_IN;
  length_in_scalar_product_ab <= LENGTH_IN;
  data_a_in_scalar_product_ab <= DATA_B_IN;
  data_b_in_scalar_product_ab <= DATA_B_IN;

  -- SCALAR MULTIPLIER
  modulo_in_scalar_multiplier <= MODULO_IN;
  data_a_in_scalar_multiplier <= data_out_scalar_product_aa;
  data_b_in_scalar_multiplier <= data_out_scalar_product_bb;

  -- SCALAR DIVIDER
  modulo_in_scalar_divider <= MODULO_IN;
  data_a_in_scalar_divider <= data_out_scalar_product_ab;
  data_b_in_scalar_divider <= data_out_scalar_multiplier;

  -- SCALAR MULTIPLIER
  scalar_multiplier : ntm_scalar_multiplier
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_multiplier,
      READY => ready_scalar_multiplier,

      -- DATA
      MODULO_IN => modulo_in_scalar_multiplier,
      DATA_A_IN => data_a_in_scalar_multiplier,
      DATA_B_IN => data_b_in_scalar_multiplier,
      DATA_OUT  => data_out_scalar_multiplier
      );

  -- SCALAR DIVIDER
  scalar_divider : ntm_scalar_divider
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_divider,
      READY => ready_scalar_divider,

      -- DATA
      MODULO_IN => modulo_in_scalar_divider,
      DATA_A_IN => data_a_in_scalar_divider,
      DATA_B_IN => data_b_in_scalar_divider,
      DATA_OUT  => data_out_scalar_divider
      );

  -- SCALAR PRODUCT AB
  scalar_product_ab : ntm_scalar_product
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product_ab,
      READY => ready_scalar_product_ab,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product_ab,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product_ab,

      DATA_OUT_ENABLE => data_out_enable_scalar_product_ab,

      -- DATA
      MODULO_IN => modulo_in_scalar_product_ab,
      LENGTH_IN => length_in_scalar_product_ab,
      DATA_A_IN => data_a_in_scalar_product_ab,
      DATA_B_IN => data_b_in_scalar_product_ab,
      DATA_OUT  => data_out_scalar_product_ab
      );

  -- SCALAR PRODUCT AA
  scalar_product_aa : ntm_scalar_product
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product_aa,
      READY => ready_scalar_product_aa,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product_aa,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product_aa,

      DATA_OUT_ENABLE => data_out_enable_scalar_product_aa,

      -- DATA
      MODULO_IN => modulo_in_scalar_product_aa,
      LENGTH_IN => length_in_scalar_product_aa,
      DATA_A_IN => data_a_in_scalar_product_aa,
      DATA_B_IN => data_b_in_scalar_product_aa,
      DATA_OUT  => data_out_scalar_product_aa
      );

  -- SCALAR PRODUCT BB
  scalar_product_bb : ntm_scalar_product
    generic map (
      DATA_SIZE  => DATA_SIZE,
      INDEX_SIZE => INDEX_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product_bb,
      READY => ready_scalar_product_bb,

      DATA_A_IN_ENABLE => data_a_in_enable_scalar_product_bb,
      DATA_B_IN_ENABLE => data_b_in_enable_scalar_product_bb,

      DATA_OUT_ENABLE => data_out_enable_scalar_product_bb,

      -- DATA
      MODULO_IN => modulo_in_scalar_product_bb,
      LENGTH_IN => length_in_scalar_product_bb,
      DATA_A_IN => data_a_in_scalar_product_bb,
      DATA_B_IN => data_b_in_scalar_product_bb,
      DATA_OUT  => data_out_scalar_product_bb
      );

end architecture;
