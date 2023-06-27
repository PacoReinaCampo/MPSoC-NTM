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

use work.model_arithmetic_pkg.all;
use work.model_integer_pkg.all;

entity model_integer_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- SCALAR-FUNCTIONALITY
    ENABLE_NTM_SCALAR_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_1    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_2      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_2 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_2    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_3      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_3 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_3    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_4      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_4 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_4    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_5      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_5 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_5    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_6      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_6 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_6    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_7      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_7 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_7    : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_VECTOR_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_VECTOR_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_DIVIDER_CASE_1    : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_MATRIX_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_MATRIX_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_DIVIDER_CASE_1    : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_TENSOR_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_TENSOR_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_DIVIDER_CASE_1    : boolean := false
    );
end model_integer_testbench;

architecture model_integer_testbench_architecture of model_integer_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_integer_adder : std_logic;
  signal ready_scalar_integer_adder : std_logic;

  signal operation_scalar_integer_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_integer_adder : std_logic;

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_integer_multiplier : std_logic;
  signal ready_scalar_integer_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_integer_divider : std_logic;
  signal ready_scalar_integer_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_scalar_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_integer_adder : std_logic;
  signal ready_vector_integer_adder : std_logic;

  signal operation_vector_integer_adder : std_logic;

  signal data_a_in_enable_vector_integer_adder : std_logic;
  signal data_b_in_enable_vector_integer_adder : std_logic;

  signal data_out_enable_vector_integer_adder : std_logic;

  -- DATA
  signal size_in_vector_integer_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_integer_adder : std_logic;

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

  signal data_out_vector_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIVIDER
  -- CONTROL
  signal start_vector_integer_divider : std_logic;
  signal ready_vector_integer_divider : std_logic;

  signal data_a_in_enable_vector_integer_divider : std_logic;
  signal data_b_in_enable_vector_integer_divider : std_logic;

  signal data_out_enable_vector_integer_divider : std_logic;

  -- DATA
  signal size_in_vector_integer_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_vector_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_integer_adder : std_logic;
  signal ready_matrix_integer_adder : std_logic;

  signal operation_matrix_integer_adder : std_logic;

  signal data_a_in_i_enable_matrix_integer_adder : std_logic;
  signal data_a_in_j_enable_matrix_integer_adder : std_logic;
  signal data_b_in_i_enable_matrix_integer_adder : std_logic;
  signal data_b_in_j_enable_matrix_integer_adder : std_logic;

  signal data_out_i_enable_matrix_integer_adder : std_logic;
  signal data_out_j_enable_matrix_integer_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_integer_adder : std_logic;

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_integer_multiplier : std_logic;
  signal ready_matrix_integer_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_integer_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_integer_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_integer_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_integer_multiplier : std_logic;

  signal data_out_i_enable_matrix_integer_multiplier : std_logic;
  signal data_out_j_enable_matrix_integer_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX DIVIDER
  -- CONTROL
  signal start_matrix_integer_divider : std_logic;
  signal ready_matrix_integer_divider : std_logic;

  signal data_a_in_i_enable_matrix_integer_divider : std_logic;
  signal data_a_in_j_enable_matrix_integer_divider : std_logic;
  signal data_b_in_i_enable_matrix_integer_divider : std_logic;
  signal data_b_in_j_enable_matrix_integer_divider : std_logic;

  signal data_out_i_enable_matrix_integer_divider : std_logic;
  signal data_out_j_enable_matrix_integer_divider : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_matrix_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR ADDER
  -- CONTROL
  signal start_tensor_integer_adder : std_logic;
  signal ready_tensor_integer_adder : std_logic;

  signal operation_tensor_integer_adder : std_logic;

  signal data_a_in_i_enable_tensor_integer_adder : std_logic;
  signal data_a_in_j_enable_tensor_integer_adder : std_logic;
  signal data_a_in_k_enable_tensor_integer_adder : std_logic;
  signal data_b_in_i_enable_tensor_integer_adder : std_logic;
  signal data_b_in_j_enable_tensor_integer_adder : std_logic;
  signal data_b_in_k_enable_tensor_integer_adder : std_logic;

  signal data_out_i_enable_tensor_integer_adder : std_logic;
  signal data_out_j_enable_tensor_integer_adder : std_logic;
  signal data_out_k_enable_tensor_integer_adder : std_logic;

  -- DATA
  signal size_i_in_tensor_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_integer_adder : std_logic;

  -- TENSOR MULTIPLIER
  -- CONTROL
  signal start_tensor_integer_multiplier : std_logic;
  signal ready_tensor_integer_multiplier : std_logic;

  signal data_a_in_i_enable_tensor_integer_multiplier : std_logic;
  signal data_a_in_j_enable_tensor_integer_multiplier : std_logic;
  signal data_a_in_k_enable_tensor_integer_multiplier : std_logic;
  signal data_b_in_i_enable_tensor_integer_multiplier : std_logic;
  signal data_b_in_j_enable_tensor_integer_multiplier : std_logic;
  signal data_b_in_k_enable_tensor_integer_multiplier : std_logic;

  signal data_out_i_enable_tensor_integer_multiplier : std_logic;
  signal data_out_j_enable_tensor_integer_multiplier : std_logic;
  signal data_out_k_enable_tensor_integer_multiplier : std_logic;

  -- DATA
  signal size_i_in_tensor_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR DIVIDER
  -- CONTROL
  signal start_tensor_integer_divider : std_logic;
  signal ready_tensor_integer_divider : std_logic;

  signal data_a_in_i_enable_tensor_integer_divider : std_logic;
  signal data_a_in_j_enable_tensor_integer_divider : std_logic;
  signal data_a_in_k_enable_tensor_integer_divider : std_logic;
  signal data_b_in_i_enable_tensor_integer_divider : std_logic;
  signal data_b_in_j_enable_tensor_integer_divider : std_logic;
  signal data_b_in_k_enable_tensor_integer_divider : std_logic;

  signal data_out_i_enable_tensor_integer_divider : std_logic;
  signal data_out_j_enable_tensor_integer_divider : std_logic;
  signal data_out_k_enable_tensor_integer_divider : std_logic;

  -- DATA
  signal size_i_in_tensor_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_tensor_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  integer_stimulus : model_integer_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
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

      ------------------------------------------------------------------------------
      -- STIMULUS SCALAR
      ------------------------------------------------------------------------------

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_INTEGER_ADDER_START => start_scalar_integer_adder,
      SCALAR_INTEGER_ADDER_READY => ready_scalar_integer_adder,

      SCALAR_INTEGER_ADDER_OPERATION => operation_scalar_integer_adder,

      -- DATA
      SCALAR_INTEGER_ADDER_DATA_A_IN => data_a_in_scalar_integer_adder,
      SCALAR_INTEGER_ADDER_DATA_B_IN => data_b_in_scalar_integer_adder,

      SCALAR_INTEGER_ADDER_DATA_OUT     => data_out_scalar_integer_adder,
      SCALAR_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_scalar_integer_adder,

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_INTEGER_MULTIPLIER_START => start_scalar_integer_multiplier,
      SCALAR_INTEGER_MULTIPLIER_READY => ready_scalar_integer_multiplier,

      -- DATA
      SCALAR_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_scalar_integer_multiplier,
      SCALAR_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_scalar_integer_multiplier,

      SCALAR_INTEGER_MULTIPLIER_DATA_OUT     => data_out_scalar_integer_multiplier,
      SCALAR_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_scalar_integer_multiplier,

      -- SCALAR DIVIDER
      -- CONTROL
      SCALAR_INTEGER_DIVIDER_START => start_scalar_integer_divider,
      SCALAR_INTEGER_DIVIDER_READY => ready_scalar_integer_divider,

      -- DATA
      SCALAR_INTEGER_DIVIDER_DATA_A_IN => data_a_in_scalar_integer_divider,
      SCALAR_INTEGER_DIVIDER_DATA_B_IN => data_b_in_scalar_integer_divider,

      SCALAR_INTEGER_DIVIDER_DATA_OUT      => data_out_scalar_integer_divider,
      SCALAR_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_scalar_integer_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR
      ------------------------------------------------------------------------------

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_INTEGER_ADDER_START => start_vector_integer_adder,
      VECTOR_INTEGER_ADDER_READY => ready_vector_integer_adder,

      VECTOR_INTEGER_ADDER_OPERATION => operation_vector_integer_adder,

      VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_adder,
      VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_adder,

      VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_integer_adder,

      -- DATA
      VECTOR_INTEGER_ADDER_SIZE_IN   => size_in_vector_integer_adder,
      VECTOR_INTEGER_ADDER_DATA_A_IN => data_a_in_vector_integer_adder,
      VECTOR_INTEGER_ADDER_DATA_B_IN => data_b_in_vector_integer_adder,

      VECTOR_INTEGER_ADDER_DATA_OUT     => data_out_vector_integer_adder,
      VECTOR_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_vector_integer_adder,

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_INTEGER_MULTIPLIER_START => start_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_READY => ready_vector_integer_multiplier,

      VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_multiplier,

      VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_integer_multiplier,

      -- DATA
      VECTOR_INTEGER_MULTIPLIER_SIZE_IN   => size_in_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_vector_integer_multiplier,

      VECTOR_INTEGER_MULTIPLIER_DATA_OUT     => data_out_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_vector_integer_multiplier,

      -- VECTOR DIVIDER
      -- CONTROL
      VECTOR_INTEGER_DIVIDER_START => start_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_READY => ready_vector_integer_divider,

      VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_divider,

      VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE => data_out_enable_vector_integer_divider,

      -- DATA
      VECTOR_INTEGER_DIVIDER_SIZE_IN   => size_in_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_DATA_A_IN => data_a_in_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_DATA_B_IN => data_b_in_vector_integer_divider,

      VECTOR_INTEGER_DIVIDER_DATA_OUT      => data_out_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_vector_integer_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX
      ------------------------------------------------------------------------------

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_INTEGER_ADDER_START => start_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_READY => ready_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_OPERATION => operation_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_adder,

      -- DATA
      MATRIX_INTEGER_ADDER_SIZE_I_IN => size_i_in_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_SIZE_J_IN => size_j_in_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_A_IN => data_a_in_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_B_IN => data_b_in_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_DATA_OUT     => data_out_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_matrix_integer_adder,

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_INTEGER_MULTIPLIER_START => start_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_READY => ready_matrix_integer_multiplier,

      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_multiplier,

      MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_multiplier,

      -- DATA
      MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN => size_i_in_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN => size_j_in_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_matrix_integer_multiplier,

      MATRIX_INTEGER_MULTIPLIER_DATA_OUT     => data_out_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_matrix_integer_multiplier,

      -- MATRIX DIVIDER
      -- CONTROL
      MATRIX_INTEGER_DIVIDER_START => start_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_READY => ready_matrix_integer_divider,

      MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_divider,

      MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_divider,

      -- DATA
      MATRIX_INTEGER_DIVIDER_SIZE_I_IN => size_i_in_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_SIZE_J_IN => size_j_in_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_A_IN => data_a_in_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_B_IN => data_b_in_matrix_integer_divider,

      MATRIX_INTEGER_DIVIDER_DATA_OUT      => data_out_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_matrix_integer_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_INTEGER_ADDER_START => start_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_READY => ready_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_OPERATION => operation_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_adder,

      -- DATA
      TENSOR_INTEGER_ADDER_SIZE_I_IN => size_i_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_SIZE_J_IN => size_j_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_SIZE_K_IN => size_k_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_A_IN => data_a_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN => data_b_in_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_DATA_OUT     => data_out_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_tensor_integer_adder,

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_INTEGER_MULTIPLIER_START => start_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_READY => ready_tensor_integer_multiplier,

      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_multiplier,

      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_multiplier,

      -- DATA
      TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN => size_i_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN => size_j_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN => size_k_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_tensor_integer_multiplier,

      TENSOR_INTEGER_MULTIPLIER_DATA_OUT     => data_out_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_tensor_integer_multiplier,

      -- TENSOR DIVIDER
      -- CONTROL
      TENSOR_INTEGER_DIVIDER_START => start_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_READY => ready_tensor_integer_divider,

      TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_divider,

      TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_divider,

      -- DATA
      TENSOR_INTEGER_DIVIDER_SIZE_I_IN => size_i_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_SIZE_J_IN => size_j_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_SIZE_K_IN => size_k_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_A_IN => data_a_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN => data_b_in_tensor_integer_divider,

      TENSOR_INTEGER_DIVIDER_DATA_OUT      => data_out_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_tensor_integer_divider
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR ADDER
  model_scalar_integer_adder_test : if (ENABLE_NTM_SCALAR_INTEGER_ADDER_TEST) generate
    scalar_integer_adder : model_scalar_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_integer_adder,
        READY => ready_scalar_integer_adder,

        OPERATION => operation_scalar_integer_adder,

        -- DATA
        DATA_A_IN => data_a_in_scalar_integer_adder,
        DATA_B_IN => data_b_in_scalar_integer_adder,

        DATA_OUT     => data_out_scalar_integer_adder,
        OVERFLOW_OUT => overflow_out_scalar_integer_adder
        );
  end generate model_scalar_integer_adder_test;

  -- SCALAR MULTIPLIER
  model_scalar_integer_multiplier_test : if (ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_TEST) generate
    scalar_integer_multiplier : model_scalar_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_integer_multiplier,
        READY => ready_scalar_integer_adder,

        -- DATA
        DATA_A_IN => data_a_in_scalar_integer_multiplier,
        DATA_B_IN => data_b_in_scalar_integer_multiplier,

        DATA_OUT     => data_out_scalar_integer_multiplier,
        OVERFLOW_OUT => overflow_out_scalar_integer_multiplier
        );
  end generate model_scalar_integer_multiplier_test;

  -- SCALAR DIVIDER
  model_scalar_integer_divider_test : if (ENABLE_NTM_SCALAR_INTEGER_DIVIDER_TEST) generate
    scalar_integer_divider : model_scalar_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_integer_divider,
        READY => ready_scalar_integer_divider,

        -- DATA
        DATA_A_IN => data_a_in_scalar_integer_divider,
        DATA_B_IN => data_b_in_scalar_integer_divider,

        DATA_OUT      => data_out_scalar_integer_divider,
        REMAINDER_OUT => remainder_out_scalar_integer_divider
        );
  end generate model_scalar_integer_divider_test;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR ADDER
  model_vector_integer_adder_test : if (ENABLE_NTM_VECTOR_INTEGER_ADDER_TEST) generate
    vector_integer_adder : model_vector_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_integer_adder,
        READY => ready_vector_integer_adder,

        OPERATION => operation_vector_integer_adder,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_adder,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_adder,

        DATA_OUT_ENABLE => data_out_enable_vector_integer_adder,

        -- DATA
        SIZE_IN   => size_in_vector_integer_adder,
        DATA_A_IN => data_a_in_vector_integer_adder,
        DATA_B_IN => data_b_in_vector_integer_adder,

        DATA_OUT     => data_out_vector_integer_adder,
        OVERFLOW_OUT => overflow_out_vector_integer_adder
        );
  end generate model_vector_integer_adder_test;

  -- VECTOR MULTIPLIER
  model_vector_integer_multiplier_test : if (ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_TEST) generate
    vector_integer_multiplier : model_vector_integer_multiplier
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

        DATA_OUT     => data_out_vector_integer_multiplier,
        OVERFLOW_OUT => overflow_out_vector_integer_multiplier
        );
  end generate model_vector_integer_multiplier_test;

  -- VECTOR DIVIDER
  model_vector_integer_divider_test : if (ENABLE_NTM_VECTOR_INTEGER_DIVIDER_TEST) generate
    vector_integer_divider : model_vector_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_integer_divider,
        READY => ready_vector_integer_divider,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_divider,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_divider,

        DATA_OUT_ENABLE => data_out_enable_vector_integer_divider,

        -- DATA
        SIZE_IN   => size_in_vector_integer_divider,
        DATA_A_IN => data_a_in_vector_integer_divider,
        DATA_B_IN => data_b_in_vector_integer_divider,

        DATA_OUT      => data_out_vector_integer_divider,
        REMAINDER_OUT => remainder_out_vector_integer_divider
        );
  end generate model_vector_integer_divider_test;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX ADDER
  model_matrix_integer_adder_test : if (ENABLE_NTM_MATRIX_INTEGER_ADDER_TEST) generate
    matrix_integer_adder : model_matrix_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integer_adder,
        READY => ready_matrix_integer_adder,

        OPERATION => operation_matrix_integer_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_adder,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integer_adder,
        SIZE_J_IN => size_j_in_matrix_integer_adder,
        DATA_A_IN => data_a_in_matrix_integer_adder,
        DATA_B_IN => data_b_in_matrix_integer_adder,

        DATA_OUT     => data_out_matrix_integer_adder,
        OVERFLOW_OUT => overflow_out_matrix_integer_adder
        );
  end generate model_matrix_integer_adder_test;

  -- MATRIX MULTIPLIER
  model_matrix_integer_multiplier_test : if (ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_TEST) generate
    matrix_integer_multiplier : model_matrix_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integer_multiplier,
        READY => ready_matrix_integer_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integer_multiplier,
        SIZE_J_IN => size_j_in_matrix_integer_multiplier,
        DATA_A_IN => data_a_in_matrix_integer_multiplier,
        DATA_B_IN => data_b_in_matrix_integer_multiplier,

        DATA_OUT     => data_out_matrix_integer_multiplier,
        OVERFLOW_OUT => overflow_out_matrix_integer_multiplier
        );
  end generate model_matrix_integer_multiplier_test;

  -- MATRIX DIVIDER
  model_matrix_integer_divider_test : if (ENABLE_NTM_MATRIX_INTEGER_DIVIDER_TEST) generate
    matrix_integer_divider : model_matrix_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integer_divider,
        READY => ready_matrix_integer_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_divider,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integer_divider,
        SIZE_J_IN => size_j_in_matrix_integer_divider,
        DATA_A_IN => data_a_in_matrix_integer_divider,
        DATA_B_IN => data_b_in_matrix_integer_divider,

        DATA_OUT      => data_out_matrix_integer_divider,
        REMAINDER_OUT => remainder_out_matrix_integer_divider
        );
  end generate model_matrix_integer_divider_test;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR ADDER
  model_tensor_integer_adder_test : if (ENABLE_NTM_TENSOR_INTEGER_ADDER_TEST) generate
    tensor_integer_adder : model_tensor_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integer_adder,
        READY => ready_tensor_integer_adder,

        OPERATION => operation_tensor_integer_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_adder,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_adder,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_adder,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_adder,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integer_adder,
        SIZE_J_IN => size_j_in_tensor_integer_adder,
        SIZE_K_IN => size_k_in_tensor_integer_adder,
        DATA_A_IN => data_a_in_tensor_integer_adder,
        DATA_B_IN => data_b_in_tensor_integer_adder,

        DATA_OUT     => data_out_tensor_integer_adder,
        OVERFLOW_OUT => overflow_out_tensor_integer_adder
        );
  end generate model_tensor_integer_adder_test;

  -- TENSOR MULTIPLIER
  model_tensor_integer_multiplier_test : if (ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_TEST) generate
    tensor_integer_multiplier : model_tensor_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integer_multiplier,
        READY => ready_tensor_integer_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_multiplier,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_multiplier,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_multiplier,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integer_multiplier,
        SIZE_J_IN => size_j_in_tensor_integer_multiplier,
        SIZE_K_IN => size_k_in_tensor_integer_multiplier,
        DATA_A_IN => data_a_in_tensor_integer_multiplier,
        DATA_B_IN => data_b_in_tensor_integer_multiplier,

        DATA_OUT     => data_out_tensor_integer_multiplier,
        OVERFLOW_OUT => overflow_out_tensor_integer_multiplier
        );
  end generate model_tensor_integer_multiplier_test;

  -- TENSOR DIVIDER
  model_tensor_integer_divider_test : if (ENABLE_NTM_TENSOR_INTEGER_DIVIDER_TEST) generate
    tensor_integer_divider : model_tensor_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integer_divider,
        READY => ready_tensor_integer_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_divider,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_divider,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_divider,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_divider,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integer_divider,
        SIZE_J_IN => size_j_in_tensor_integer_divider,
        SIZE_K_IN => size_k_in_tensor_integer_divider,
        DATA_A_IN => data_a_in_tensor_integer_divider,
        DATA_B_IN => data_b_in_tensor_integer_divider,

        DATA_OUT      => data_out_tensor_integer_divider,
        REMAINDER_OUT => remainder_out_tensor_integer_divider
        );
  end generate model_tensor_integer_divider_test;

end model_integer_testbench_architecture;
