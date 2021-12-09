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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;
use work.ntm_float_pkg.all;

entity ntm_float_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- SCALAR-FUNCTIONALITY
    ENABLE_NTM_SCALAR_ADDER_TEST         : boolean := false;
    ENABLE_NTM_SCALAR_MULTIPLIER_TEST    : boolean := false;
    ENABLE_NTM_SCALAR_INVERTER_TEST      : boolean := false;
    ENABLE_NTM_SCALAR_DIVIDER_TEST       : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST : boolean := false;

    ENABLE_NTM_SCALAR_ADDER_CASE_0         : boolean := false;
    ENABLE_NTM_SCALAR_MULTIPLIER_CASE_0    : boolean := false;
    ENABLE_NTM_SCALAR_INVERTER_CASE_0      : boolean := false;
    ENABLE_NTM_SCALAR_DIVIDER_CASE_0       : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_CASE_0 : boolean := false;

    ENABLE_NTM_SCALAR_ADDER_CASE_1         : boolean := false;
    ENABLE_NTM_SCALAR_MULTIPLIER_CASE_1    : boolean := false;
    ENABLE_NTM_SCALAR_INVERTER_CASE_1      : boolean := false;
    ENABLE_NTM_SCALAR_DIVIDER_CASE_1       : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_CASE_1 : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_ADDER_TEST         : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLIER_TEST    : boolean := false;
    ENABLE_NTM_VECTOR_INVERTER_TEST      : boolean := false;
    ENABLE_NTM_VECTOR_DIVIDER_TEST       : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST : boolean := false;

    ENABLE_NTM_VECTOR_ADDER_CASE_0         : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLIER_CASE_0    : boolean := false;
    ENABLE_NTM_VECTOR_INVERTER_CASE_0      : boolean := false;
    ENABLE_NTM_VECTOR_DIVIDER_CASE_0       : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_CASE_0 : boolean := false;

    ENABLE_NTM_VECTOR_ADDER_CASE_1         : boolean := false;
    ENABLE_NTM_VECTOR_MULTIPLIER_CASE_1    : boolean := false;
    ENABLE_NTM_VECTOR_INVERTER_CASE_1      : boolean := false;
    ENABLE_NTM_VECTOR_DIVIDER_CASE_1       : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_CASE_1 : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_ADDER_TEST         : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLIER_TEST    : boolean := false;
    ENABLE_NTM_MATRIX_INVERTER_TEST      : boolean := false;
    ENABLE_NTM_MATRIX_DIVIDER_TEST       : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST : boolean := false;

    ENABLE_NTM_MATRIX_ADDER_CASE_0         : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLIER_CASE_0    : boolean := false;
    ENABLE_NTM_MATRIX_INVERTER_CASE_0      : boolean := false;
    ENABLE_NTM_MATRIX_DIVIDER_CASE_0       : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_CASE_0 : boolean := false;

    ENABLE_NTM_MATRIX_ADDER_CASE_1         : boolean := false;
    ENABLE_NTM_MATRIX_MULTIPLIER_CASE_1    : boolean := false;
    ENABLE_NTM_MATRIX_INVERTER_CASE_1      : boolean := false;
    ENABLE_NTM_MATRIX_DIVIDER_CASE_1       : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_CASE_1 : boolean := false
    );
end ntm_float_testbench;

architecture ntm_float_testbench_architecture of ntm_float_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_adder : std_logic;
  signal ready_scalar_adder : std_logic;

  signal operation_scalar_adder : std_logic;

  -- DATA
  signal modulo_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_multiplier : std_logic;
  signal ready_scalar_multiplier : std_logic;

  -- DATA
  signal modulo_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR INVERTER
  -- CONTROL
  signal start_scalar_inverter : std_logic;
  signal ready_scalar_inverter : std_logic;

  -- DATA
  signal modulo_in_scalar_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_divider : std_logic;
  signal ready_scalar_divider : std_logic;

  -- DATA
  signal modulo_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR EXPONENTIATOR
  -- CONTROL
  signal start_scalar_exponentiator : std_logic;
  signal ready_scalar_exponentiator : std_logic;

  -- DATA
  signal modulo_in_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

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
  signal size_in_vector_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
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
  signal size_in_vector_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR INVERTER
  -- CONTROL
  signal start_vector_inverter : std_logic;
  signal ready_vector_inverter : std_logic;

  signal data_in_enable_vector_inverter : std_logic;

  signal data_out_enable_vector_inverter : std_logic;

  -- DATA
  signal modulo_in_vector_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_inverter   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIVIDER
  -- CONTROL
  signal start_vector_divider : std_logic;
  signal ready_vector_divider : std_logic;

  signal data_a_in_enable_vector_divider : std_logic;
  signal data_b_in_enable_vector_divider : std_logic;

  signal data_out_enable_vector_divider : std_logic;

  -- DATA
  signal modulo_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_a_in_enable_vector_exponentiator : std_logic;
  signal data_b_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_exponentiator   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

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
  signal modulo_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

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
  signal modulo_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INVERTER
  -- CONTROL
  signal start_matrix_inverter : std_logic;
  signal ready_matrix_inverter : std_logic;

  signal data_in_i_enable_matrix_inverter : std_logic;
  signal data_in_j_enable_matrix_inverter : std_logic;

  signal data_out_i_enable_matrix_inverter : std_logic;
  signal data_out_j_enable_matrix_inverter : std_logic;

  -- DATA
  signal modulo_in_matrix_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

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

  -- MATRIX EXPONENTIATOR
  -- CONTROL
  signal start_matrix_exponentiator : std_logic;
  signal ready_matrix_exponentiator : std_logic;

  signal data_a_in_i_enable_matrix_exponentiator : std_logic;
  signal data_a_in_j_enable_matrix_exponentiator : std_logic;
  signal data_b_in_i_enable_matrix_exponentiator : std_logic;
  signal data_b_in_j_enable_matrix_exponentiator : std_logic;

  signal data_out_i_enable_matrix_exponentiator : std_logic;
  signal data_out_j_enable_matrix_exponentiator : std_logic;

  -- DATA
  signal modulo_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  float_stimulus : ntm_float_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR
      -----------------------------------------------------------------------

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_ADDER_START => start_scalar_adder,
      SCALAR_ADDER_READY => ready_scalar_adder,

      SCALAR_ADDER_OPERATION => operation_scalar_adder,

      -- DATA
      SCALAR_ADDER_DATA_A_IN => data_a_in_scalar_adder,
      SCALAR_ADDER_DATA_B_IN => data_b_in_scalar_adder,
      SCALAR_ADDER_DATA_OUT  => data_out_scalar_adder,

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_MULTIPLIER_START => start_scalar_multiplier,
      SCALAR_MULTIPLIER_READY => ready_scalar_multiplier,

      -- DATA
      SCALAR_MULTIPLIER_DATA_A_IN => data_a_in_scalar_multiplier,
      SCALAR_MULTIPLIER_DATA_B_IN => data_b_in_scalar_multiplier,
      SCALAR_MULTIPLIER_DATA_OUT  => data_out_scalar_multiplier,

      -- SCALAR INVERTER
      -- CONTROL
      SCALAR_INVERTER_START => start_scalar_inverter,
      SCALAR_INVERTER_READY => ready_scalar_inverter,

      -- DATA
      SCALAR_INVERTER_DATA_IN   => data_in_scalar_inverter,
      SCALAR_INVERTER_DATA_OUT  => data_out_scalar_inverter,

      -- SCALAR DIVIDER
      -- CONTROL
      SCALAR_DIVIDER_START => start_scalar_divider,
      SCALAR_DIVIDER_READY => ready_scalar_divider,

      -- DATA
      SCALAR_DIVIDER_DATA_A_IN => data_a_in_scalar_divider,
      SCALAR_DIVIDER_DATA_B_IN => data_b_in_scalar_divider,
      SCALAR_DIVIDER_DATA_OUT  => data_out_scalar_divider,

      -- SCALAR EXPONENTIATOR
      -- CONTROL
      SCALAR_EXPONENTIATOR_START => start_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_READY => ready_scalar_exponentiator,

      -- DATA
      SCALAR_EXPONENTIATOR_DATA_A_IN => data_a_in_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_DATA_B_IN => data_b_in_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_DATA_OUT  => data_out_scalar_exponentiator,
      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_ADDER_START => start_vector_adder,
      VECTOR_ADDER_READY => ready_vector_adder,

      VECTOR_ADDER_OPERATION => operation_vector_adder,

      VECTOR_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_adder,
      VECTOR_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_adder,

      VECTOR_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_adder,

      -- DATA
      VECTOR_ADDER_SIZE_IN   => size_in_vector_adder,
      VECTOR_ADDER_DATA_A_IN => data_a_in_vector_adder,
      VECTOR_ADDER_DATA_B_IN => data_b_in_vector_adder,
      VECTOR_ADDER_DATA_OUT  => data_out_vector_adder,

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_MULTIPLIER_START => start_vector_multiplier,
      VECTOR_MULTIPLIER_READY => ready_vector_multiplier,

      VECTOR_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_multiplier,
      VECTOR_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_multiplier,

      VECTOR_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_multiplier,

      -- DATA
      VECTOR_MULTIPLIER_SIZE_IN   => size_in_vector_multiplier,
      VECTOR_MULTIPLIER_DATA_A_IN => data_a_in_vector_multiplier,
      VECTOR_MULTIPLIER_DATA_B_IN => data_b_in_vector_multiplier,
      VECTOR_MULTIPLIER_DATA_OUT  => data_out_vector_multiplier,

      -- VECTOR INVERTER
      -- CONTROL
      VECTOR_INVERTER_START => start_vector_inverter,
      VECTOR_INVERTER_READY => ready_vector_inverter,

      VECTOR_INVERTER_DATA_IN_ENABLE => data_in_enable_vector_inverter,

      VECTOR_INVERTER_DATA_OUT_ENABLE => data_out_enable_vector_inverter,

      -- DATA
      VECTOR_INVERTER_SIZE_IN   => size_in_vector_inverter,
      VECTOR_INVERTER_DATA_IN   => data_in_vector_inverter,
      VECTOR_INVERTER_DATA_OUT  => data_out_vector_inverter,

      -- VECTOR DIVIDER
      -- CONTROL
      VECTOR_DIVIDER_START => start_vector_divider,
      VECTOR_DIVIDER_READY => ready_vector_divider,

      VECTOR_DIVIDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_divider,
      VECTOR_DIVIDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_divider,

      VECTOR_DIVIDER_DATA_OUT_ENABLE => data_out_enable_vector_divider,

      -- DATA
      VECTOR_DIVIDER_SIZE_IN   => size_in_vector_divider,
      VECTOR_DIVIDER_DATA_A_IN => data_a_in_vector_divider,
      VECTOR_DIVIDER_DATA_B_IN => data_b_in_vector_divider,
      VECTOR_DIVIDER_DATA_OUT  => data_out_vector_divider,

      -- VECTOR EXPONENTIATOR
      -- CONTROL
      VECTOR_EXPONENTIATOR_START => start_vector_exponentiator,
      VECTOR_EXPONENTIATOR_READY => ready_vector_exponentiator,

      VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE => data_a_in_enable_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE => data_b_in_enable_vector_exponentiator,

      VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      VECTOR_EXPONENTIATOR_SIZE_IN   => size_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_A_IN => data_a_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_B_IN => data_b_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_OUT  => data_out_vector_exponentiator,

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX
      -----------------------------------------------------------------------

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_ADDER_START => start_matrix_adder,
      MATRIX_ADDER_READY => ready_matrix_adder,

      MATRIX_ADDER_OPERATION => operation_matrix_adder,

      MATRIX_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_adder,
      MATRIX_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_adder,
      MATRIX_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_adder,
      MATRIX_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_adder,

      MATRIX_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_adder,
      MATRIX_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_adder,

      -- DATA
      MATRIX_ADDER_SIZE_I_IN => size_i_in_matrix_adder,
      MATRIX_ADDER_SIZE_J_IN => size_j_in_matrix_adder,
      MATRIX_ADDER_DATA_A_IN => data_a_in_matrix_adder,
      MATRIX_ADDER_DATA_B_IN => data_b_in_matrix_adder,
      MATRIX_ADDER_DATA_OUT  => data_out_matrix_adder,

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_MULTIPLIER_START => start_matrix_multiplier,
      MATRIX_MULTIPLIER_READY => ready_matrix_multiplier,

      MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_multiplier,

      MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_multiplier,

      -- DATA
      MATRIX_MULTIPLIER_SIZE_I_IN => size_i_in_matrix_multiplier,
      MATRIX_MULTIPLIER_SIZE_J_IN => size_j_in_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_A_IN => data_a_in_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_B_IN => data_b_in_matrix_multiplier,
      MATRIX_MULTIPLIER_DATA_OUT  => data_out_matrix_multiplier,

      -- MATRIX INVERTER
      -- CONTROL
      MATRIX_INVERTER_START => start_matrix_inverter,
      MATRIX_INVERTER_READY => ready_matrix_inverter,

      MATRIX_INVERTER_DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverter,
      MATRIX_INVERTER_DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverter,

      MATRIX_INVERTER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverter,
      MATRIX_INVERTER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverter,

      -- DATA
      MATRIX_INVERTER_SIZE_I_IN => size_i_in_matrix_inverter,
      MATRIX_INVERTER_SIZE_J_IN => size_j_in_matrix_inverter,
      MATRIX_INVERTER_DATA_IN   => data_in_matrix_inverter,
      MATRIX_INVERTER_DATA_OUT  => data_out_matrix_inverter,

      -- MATRIX DIVIDER
      -- CONTROL
      MATRIX_DIVIDER_START => start_matrix_divider,
      MATRIX_DIVIDER_READY => ready_matrix_divider,

      MATRIX_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_divider,
      MATRIX_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_divider,
      MATRIX_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_divider,
      MATRIX_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_divider,

      MATRIX_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_divider,
      MATRIX_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_divider,

      -- DATA
      MATRIX_DIVIDER_SIZE_I_IN => size_i_in_matrix_divider,
      MATRIX_DIVIDER_SIZE_J_IN => size_j_in_matrix_divider,
      MATRIX_DIVIDER_DATA_A_IN => data_a_in_matrix_divider,
      MATRIX_DIVIDER_DATA_B_IN => data_b_in_matrix_divider,
      MATRIX_DIVIDER_DATA_OUT  => data_out_matrix_divider,

      -- MATRIX EXPONENTIATOR
      -- CONTROL
      MATRIX_EXPONENTIATOR_START => start_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_READY => ready_matrix_exponentiator,

      MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_exponentiator,

      MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

      -- DATA
      MATRIX_EXPONENTIATOR_SIZE_I_IN => size_i_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_SIZE_J_IN => size_j_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_A_IN => data_a_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_B_IN => data_b_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_OUT  => data_out_matrix_exponentiator
      );

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR ADDER
  ntm_scalar_adder_test : if (ENABLE_NTM_SCALAR_ADDER_TEST) generate
    scalar_adder : ntm_scalar_adder
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_adder,
        READY => ready_scalar_adder,

        OPERATION => operation_scalar_adder,

        -- DATA
        MODULO_IN => modulo_in_scalar_adder,
        DATA_A_IN => data_a_in_scalar_adder,
        DATA_B_IN => data_b_in_scalar_adder,
        DATA_OUT  => data_out_scalar_adder
        );
  end generate ntm_scalar_adder_test;

  -- SCALAR MULTIPLIER
  ntm_scalar_multiplier_test : if (ENABLE_NTM_SCALAR_MULTIPLIER_TEST) generate
    scalar_multiplier : ntm_scalar_multiplier
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_multiplier,
        READY => ready_scalar_adder,

        -- DATA
        MODULO_IN => modulo_in_scalar_multiplier,
        DATA_A_IN => data_a_in_scalar_multiplier,
        DATA_B_IN => data_b_in_scalar_multiplier,
        DATA_OUT  => data_out_scalar_multiplier
        );
  end generate ntm_scalar_multiplier_test;

  -- SCALAR INVERTER
  ntm_scalar_inverter_test : if (ENABLE_NTM_SCALAR_INVERTER_TEST) generate
    scalar_inverter : ntm_scalar_inverter
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_inverter,
        READY => ready_scalar_inverter,

        -- DATA
        MODULO_IN => modulo_in_scalar_inverter,
        DATA_IN   => data_in_scalar_inverter,
        DATA_OUT  => data_out_scalar_inverter
        );
  end generate ntm_scalar_inverter_test;

  -- SCALAR DIVIDER
  ntm_scalar_divider_test : if (ENABLE_NTM_SCALAR_DIVIDER_TEST) generate
    scalar_divider : ntm_scalar_divider
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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
  end generate ntm_scalar_divider_test;

  -- SCALAR EXPONENTIATOR
  ntm_scalar_exponentiator_test : if (ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST) generate
    scalar_exponentiator : ntm_scalar_exponentiator
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_exponentiator,
        READY => ready_scalar_exponentiator,

        -- DATA
        MODULO_IN => modulo_in_scalar_exponentiator,
        DATA_A_IN => data_a_in_scalar_exponentiator,
        DATA_B_IN => data_b_in_scalar_exponentiator,
        DATA_OUT  => data_out_scalar_exponentiator
        );
  end generate ntm_scalar_exponentiator_test;

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR ADDER
  ntm_vector_adder_test : if (ENABLE_NTM_VECTOR_ADDER_TEST) generate
    vector_adder : ntm_vector_adder
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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
  end generate ntm_vector_adder_test;

  -- VECTOR MULTIPLIER
  ntm_vector_multiplier_test : if (ENABLE_NTM_VECTOR_MULTIPLIER_TEST) generate
    vector_multiplier : ntm_vector_multiplier
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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
  end generate ntm_vector_multiplier_test;

  -- VECTOR INVERTER
  ntm_vector_inverter_test : if (ENABLE_NTM_VECTOR_INVERTER_TEST) generate
    vector_inverter : ntm_vector_inverter
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_inverter,
        READY => ready_vector_inverter,

        DATA_IN_ENABLE => data_in_enable_vector_inverter,

        DATA_OUT_ENABLE => data_out_enable_vector_inverter,

        -- DATA
        MODULO_IN => modulo_in_vector_inverter,
        SIZE_IN   => size_in_vector_inverter,
        DATA_IN   => data_in_vector_inverter,
        DATA_OUT  => data_out_vector_inverter
        );
  end generate ntm_vector_inverter_test;

  -- VECTOR DIVIDER
  ntm_vector_divider_test : if (ENABLE_NTM_VECTOR_DIVIDER_TEST) generate
    vector_divider : ntm_vector_divider
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_divider,
        READY => ready_vector_divider,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_divider,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_divider,

        DATA_OUT_ENABLE => data_out_enable_vector_divider,

        -- DATA
        MODULO_IN => modulo_in_vector_divider,
        SIZE_IN   => size_in_vector_divider,
        DATA_A_IN => data_a_in_vector_divider,
        DATA_B_IN => data_b_in_vector_divider,
        DATA_OUT  => data_out_vector_divider
        );
  end generate ntm_vector_divider_test;

  -- VECTOR EXPONENTIATOR
  ntm_vector_exponentiator_test : if (ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST) generate
    vector_exponentiator : ntm_vector_exponentiator
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
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
  end generate ntm_vector_exponentiator_test;

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX ADDER
  ntm_matrix_adder_test : if (ENABLE_NTM_MATRIX_ADDER_TEST) generate
    matrix_adder : ntm_matrix_adder
      generic map (
        DATA_SIZE  => DATA_SIZE,
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
        MODULO_IN => modulo_in_matrix_adder,
        SIZE_I_IN => size_i_in_matrix_adder,
        SIZE_J_IN => size_j_in_matrix_adder,
        DATA_A_IN => data_a_in_matrix_adder,
        DATA_B_IN => data_b_in_matrix_adder,
        DATA_OUT  => data_out_matrix_adder
        );
  end generate ntm_matrix_adder_test;

  -- MATRIX MULTIPLIER
  ntm_matrix_multiplier_test : if (ENABLE_NTM_MATRIX_MULTIPLIER_TEST) generate
    matrix_multiplier : ntm_matrix_multiplier
      generic map (
        DATA_SIZE  => DATA_SIZE,
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
        MODULO_IN => modulo_in_matrix_multiplier,
        SIZE_I_IN => size_i_in_matrix_multiplier,
        SIZE_J_IN => size_j_in_matrix_multiplier,
        DATA_A_IN => data_a_in_matrix_multiplier,
        DATA_B_IN => data_b_in_matrix_multiplier,
        DATA_OUT  => data_out_matrix_multiplier
        );
  end generate ntm_matrix_multiplier_test;

  -- MATRIX INVERTER
  ntm_matrix_inverter_test : if (ENABLE_NTM_MATRIX_INVERTER_TEST) generate
    matrix_inverter : ntm_matrix_inverter
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_inverter,
        READY => ready_matrix_inverter,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverter,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverter,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverter,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverter,

        -- DATA
        MODULO_IN => modulo_in_matrix_inverter,
        SIZE_I_IN => size_i_in_matrix_inverter,
        SIZE_J_IN => size_j_in_matrix_inverter,
        DATA_IN   => data_in_matrix_inverter,
        DATA_OUT  => data_out_matrix_inverter
        );
  end generate ntm_matrix_inverter_test;

  -- MATRIX DIVIDER
  ntm_matrix_divider_test : if (ENABLE_NTM_MATRIX_DIVIDER_TEST) generate
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
  end generate ntm_matrix_divider_test;

  -- MATRIX EXPONENTIATOR
  ntm_matrix_exponentiator_test : if (ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST) generate
    matrix_exponentiator : ntm_matrix_exponentiator
      generic map (
        DATA_SIZE  => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_exponentiator,
        READY => ready_matrix_exponentiator,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_exponentiator,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_exponentiator,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_exponentiator,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_exponentiator,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

        -- DATA
        MODULO_IN => modulo_in_matrix_exponentiator,
        SIZE_I_IN => size_i_in_matrix_exponentiator,
        SIZE_J_IN => size_j_in_matrix_exponentiator,
        DATA_A_IN => data_a_in_matrix_exponentiator,
        DATA_B_IN => data_b_in_matrix_exponentiator,
        DATA_OUT  => data_out_matrix_exponentiator
        );
  end generate ntm_matrix_exponentiator_test;

end ntm_float_testbench_architecture;
