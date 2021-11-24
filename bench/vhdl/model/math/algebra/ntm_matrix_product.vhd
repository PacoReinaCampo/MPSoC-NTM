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

entity ntm_matrix_product is
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
    MODULO_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_A_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_A_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_B_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_B_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_matrix_product_architecture of ntm_matrix_product is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    VECTOR_MULTIPLIER_STATE,            -- STEP 1
    VECTOR_ADDER_STATE                  -- STEP 2
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  signal data_a_in_enable_vector_adder : std_logic;
  signal data_b_in_enable_vector_adder : std_logic;

  signal data_out_enable_vector_adder : std_logic;

  -- DATA
  signal modulo_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_adder   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN · DATA_B_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Data Outputs
          DATA_OUT <= ZERO;

          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_i_loop <= ZERO;
          index_j_loop <= ZERO;

          if (START = '1') then
            -- Control Internal
            start_vector_multiplier <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          else
            -- Control Internal
            start_vector_multiplier <= '0';
          end if;

        when VECTOR_MULTIPLIER_STATE =>  -- STEP 1

          if (data_out_enable_vector_multiplier = '1') then
            -- Control Internal
            if ((index_i_loop = ZERO) and (index_j_loop = ZERO)) then
              start_vector_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_ADDER_STATE;
          else
            -- Control Internal
            start_vector_adder <= '0';
          end if;

        when VECTOR_ADDER_STATE =>  -- STEP 2

          if (data_out_enable_vector_multiplier = '1') then
            if ((unsigned(index_i_loop) < unsigned(SIZE_A_I_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_B_J_IN) - unsigned(ONE))) then
              -- Control Internal
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_vector_multiplier;

            -- Control Outputs
            DATA_OUT_I_ENABLE <= '1';
          else
            -- Control Outputs
            DATA_OUT_I_ENABLE <= '0';
          end if;

          if (data_out_enable_vector_multiplier = '1') then
            if ((unsigned(index_i_loop) = unsigned(SIZE_A_I_IN) - unsigned(ONE)) and (unsigned(index_j_loop) = unsigned(SIZE_B_J_IN) - unsigned(ONE))) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            elsif ((unsigned(index_i_loop) < unsigned(SIZE_A_I_IN) - unsigned(ONE)) and (unsigned(index_j_loop) < unsigned(SIZE_B_J_IN) - unsigned(ONE))) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
            end if;

            -- Data Outputs
            DATA_OUT <= data_out_vector_multiplier;

            -- Control Outputs
            DATA_OUT_J_ENABLE <= '1';
          else
            -- Control Outputs
            DATA_OUT_J_ENABLE <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  operation_vector_adder <= '0';

  data_a_in_enable_vector_adder <= DATA_A_IN_J_ENABLE;
  data_b_in_enable_vector_adder <= DATA_B_IN_I_ENABLE;

  -- VECTOR MULTIPLIER
  data_a_in_enable_vector_adder <= data_out_enable_vector_adder;
  data_b_in_enable_vector_adder <= data_out_enable_vector_multiplier;

  -- DATA
  -- VECTOR ADDER
  modulo_in_vector_adder <= FULL;
  size_in_vector_adder   <= SIZE_A_J_IN;
  data_a_in_vector_adder <= data_out_vector_adder;
  data_b_in_vector_adder <= data_out_vector_multiplier;

  -- VECTOR MULTIPLIER
  modulo_in_vector_multiplier <= FULL;
  size_in_vector_multiplier   <= SIZE_A_J_IN;
  data_a_in_vector_multiplier <= DATA_A_IN;
  data_b_in_vector_multiplier <= DATA_B_IN;

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_adder,

      -- DATA
      MODULO_IN => modulo_in_vector_adder,
      SIZE_IN   => size_in_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
      );

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

end architecture;
