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

entity ntm_writing is
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

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    A_IN_ENABLE : in std_logic;         -- for k in 0 to W-1

    W_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    A_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_writing_architecture of ntm_writing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_FIRST_STATE,                -- STEP 1
    INPUT_J_FIRST_STATE,                -- STEP 2
    MATRIX_MULTIPLIER_I_STATE,          -- STEP 3
    MATRIX_MULTIPLIER_J_STATE,          -- STEP 4
    INPUT_SECOND_I_STATE,               -- STEP 5
    INPUT_SECOND_J_STATE,               -- STEP 6
    MATRIX_ADDER_I_STATE,               -- STEP 7
    MATRIX_ADDER_J_STATE                -- STEP 8
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

  -- Internal Signals
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_adder : std_logic;
  signal ready_matrix_adder : std_logic;

  signal operation_matrix_adder : std_logic;

  signal data_a_in_i_enable_matrix_adder : std_logic;
  signal data_a_in_j_enable_matrix_adder : std_logic;
  signal data_b_in_i_enable_matrix_adder : std_logic;
  signal data_b_in_j_enable_matrix_adder : std_logic;

  signal data_out_i_enable_matrix_adder : std_logic;
  signal data_out_j_enable_matrix_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_adder : std_logic;

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_multiplier : std_logic;
  signal ready_matrix_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_multiplier : std_logic;

  signal data_out_i_enable_matrix_multiplier : std_logic;
  signal data_out_j_enable_matrix_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- M(t;j;k) = M(t;j;k) + w(t;j)·a(t;k)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      M_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      M_OUT_J_ENABLE <= '0';
      M_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

          -- Control Internal
          index_i_loop <= ZERO_CONTROL;
          index_j_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_I_FIRST_STATE;
          end if;

        when INPUT_I_FIRST_STATE =>     -- STEP 1

        when INPUT_J_FIRST_STATE =>     -- STEP 2

        when MATRIX_MULTIPLIER_I_STATE =>  -- STEP 3

        when MATRIX_MULTIPLIER_J_STATE =>  -- STEP 4

        when INPUT_SECOND_I_STATE =>    -- STEP 5

        when INPUT_SECOND_J_STATE =>    -- STEP 6

        when MATRIX_ADDER_I_STATE =>    -- STEP 7

        when MATRIX_ADDER_J_STATE =>    -- STEP 8

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- MATRIX ADDER
  matrix_adder : ntm_matrix_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_adder,
      READY => ready_matrix_adder,

      OPERATION => operation_matrix_adder,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_adder,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_adder,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_adder,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_adder,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_adder,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_adder,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_adder,
      SIZE_J_IN => size_j_in_matrix_adder,
      DATA_A_IN => data_a_in_matrix_adder,
      DATA_B_IN => data_b_in_matrix_adder,

      DATA_OUT     => data_out_matrix_adder,
      OVERFLOW_OUT => overflow_out_matrix_adder
      );

  -- MATRIX MULTIPLIER
  matrix_multiplier : ntm_matrix_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_multiplier,
      READY => ready_matrix_multiplier,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_multiplier,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_multiplier,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_multiplier,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_multiplier,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_multiplier,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_multiplier,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_multiplier,
      SIZE_J_IN => size_j_in_matrix_multiplier,
      DATA_A_IN => data_a_in_matrix_multiplier,
      DATA_B_IN => data_b_in_matrix_multiplier,

      DATA_OUT     => data_out_matrix_multiplier,
      OVERFLOW_OUT => overflow_out_matrix_multiplier
      );

end architecture;
