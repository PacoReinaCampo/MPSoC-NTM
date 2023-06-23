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

use work.model_arithmetic_pkg.all;
use work.model_fixed_pkg.all;

entity model_fixed_testbench is
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
    ENABLE_NTM_SCALAR_FIXED_ADDER_TEST      : boolean := false;
    ENABLE_NTM_SCALAR_FIXED_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_SCALAR_FIXED_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_SCALAR_FIXED_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_SCALAR_FIXED_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_FIXED_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_SCALAR_FIXED_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_SCALAR_FIXED_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_FIXED_DIVIDER_CASE_1    : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_FIXED_ADDER_TEST      : boolean := false;
    ENABLE_NTM_VECTOR_FIXED_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_VECTOR_FIXED_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_VECTOR_FIXED_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_VECTOR_FIXED_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_FIXED_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_VECTOR_FIXED_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_VECTOR_FIXED_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_FIXED_DIVIDER_CASE_1    : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_FIXED_ADDER_TEST      : boolean := false;
    ENABLE_NTM_MATRIX_FIXED_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_MATRIX_FIXED_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_MATRIX_FIXED_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_MATRIX_FIXED_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_FIXED_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_MATRIX_FIXED_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_MATRIX_FIXED_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_FIXED_DIVIDER_CASE_1    : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_FIXED_ADDER_TEST      : boolean := false;
    ENABLE_NTM_TENSOR_FIXED_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_TENSOR_FIXED_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_TENSOR_FIXED_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_TENSOR_FIXED_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_FIXED_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_TENSOR_FIXED_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_TENSOR_FIXED_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_FIXED_DIVIDER_CASE_1    : boolean := false
    );
end model_fixed_testbench;

architecture model_fixed_testbench_architecture of model_fixed_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR FIXED ADDER
  -- CONTROL
  signal start_scalar_fixed_adder : std_logic;
  signal ready_scalar_fixed_adder : std_logic;

  signal operation_scalar_fixed_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_fixed_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_fixed_adder : std_logic;

  -- SCALAR FIXED MULTIPLIER
  -- CONTROL
  signal start_scalar_fixed_multiplier : std_logic;
  signal ready_scalar_fixed_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_fixed_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_fixed_multiplier : std_logic;

  -- SCALAR FIXED DIVIDER
  -- CONTROL
  signal start_scalar_fixed_divider : std_logic;
  signal ready_scalar_fixed_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_fixed_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_fixed_divider : std_logic;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR FIXED ADDER
  -- CONTROL
  signal start_vector_fixed_adder : std_logic;
  signal ready_vector_fixed_adder : std_logic;

  signal operation_vector_fixed_adder : std_logic;

  signal data_a_in_enable_vector_fixed_adder : std_logic;
  signal data_b_in_enable_vector_fixed_adder : std_logic;

  signal data_out_enable_vector_fixed_adder : std_logic;

  -- DATA
  signal size_in_vector_fixed_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_fixed_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_fixed_adder : std_logic;

  -- VECTOR FIXED MULTIPLIER
  -- CONTROL
  signal start_vector_fixed_multiplier : std_logic;
  signal ready_vector_fixed_multiplier : std_logic;

  signal data_a_in_enable_vector_fixed_multiplier : std_logic;
  signal data_b_in_enable_vector_fixed_multiplier : std_logic;

  signal data_out_enable_vector_fixed_multiplier : std_logic;

  -- DATA
  signal size_in_vector_fixed_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_fixed_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_fixed_multiplier : std_logic;

  -- VECTOR FIXED DIVIDER
  -- CONTROL
  signal start_vector_fixed_divider : std_logic;
  signal ready_vector_fixed_divider : std_logic;

  signal data_a_in_enable_vector_fixed_divider : std_logic;
  signal data_b_in_enable_vector_fixed_divider : std_logic;

  signal data_out_enable_vector_fixed_divider : std_logic;

  -- DATA
  signal size_in_vector_fixed_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_fixed_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_fixed_divider : std_logic;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX FIXED ADDER
  -- CONTROL
  signal start_matrix_fixed_adder : std_logic;
  signal ready_matrix_fixed_adder : std_logic;

  signal operation_matrix_fixed_adder : std_logic;

  signal data_a_in_i_enable_matrix_fixed_adder : std_logic;
  signal data_a_in_j_enable_matrix_fixed_adder : std_logic;
  signal data_b_in_i_enable_matrix_fixed_adder : std_logic;
  signal data_b_in_j_enable_matrix_fixed_adder : std_logic;

  signal data_out_i_enable_matrix_fixed_adder : std_logic;
  signal data_out_j_enable_matrix_fixed_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_fixed_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_fixed_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_fixed_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_fixed_adder : std_logic;

  -- MATRIX FIXED MULTIPLIER
  -- CONTROL
  signal start_matrix_fixed_multiplier : std_logic;
  signal ready_matrix_fixed_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_fixed_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_fixed_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_fixed_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_fixed_multiplier : std_logic;

  signal data_out_i_enable_matrix_fixed_multiplier : std_logic;
  signal data_out_j_enable_matrix_fixed_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_fixed_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_fixed_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_fixed_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_fixed_multiplier : std_logic;

  -- MATRIX FIXED DIVIDER
  -- CONTROL
  signal start_matrix_fixed_divider : std_logic;
  signal ready_matrix_fixed_divider : std_logic;

  signal data_a_in_i_enable_matrix_fixed_divider : std_logic;
  signal data_a_in_j_enable_matrix_fixed_divider : std_logic;
  signal data_b_in_i_enable_matrix_fixed_divider : std_logic;
  signal data_b_in_j_enable_matrix_fixed_divider : std_logic;

  signal data_out_i_enable_matrix_fixed_divider : std_logic;
  signal data_out_j_enable_matrix_fixed_divider : std_logic;

  -- DATA
  signal size_i_in_matrix_fixed_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_fixed_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_fixed_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_fixed_divider : std_logic;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR FIXED ADDER
  -- CONTROL
  signal start_tensor_fixed_adder : std_logic;
  signal ready_tensor_fixed_adder : std_logic;

  signal operation_tensor_fixed_adder : std_logic;

  signal data_a_in_i_enable_tensor_fixed_adder : std_logic;
  signal data_a_in_j_enable_tensor_fixed_adder : std_logic;
  signal data_a_in_k_enable_tensor_fixed_adder : std_logic;
  signal data_b_in_i_enable_tensor_fixed_adder : std_logic;
  signal data_b_in_j_enable_tensor_fixed_adder : std_logic;
  signal data_b_in_k_enable_tensor_fixed_adder : std_logic;

  signal data_out_i_enable_tensor_fixed_adder : std_logic;
  signal data_out_j_enable_tensor_fixed_adder : std_logic;
  signal data_out_k_enable_tensor_fixed_adder : std_logic;

  -- DATA
  signal size_i_in_tensor_fixed_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_fixed_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_fixed_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_fixed_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_fixed_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_fixed_adder : std_logic;

  -- TENSOR FIXED MULTIPLIER
  -- CONTROL
  signal start_tensor_fixed_multiplier : std_logic;
  signal ready_tensor_fixed_multiplier : std_logic;

  signal data_a_in_i_enable_tensor_fixed_multiplier : std_logic;
  signal data_a_in_j_enable_tensor_fixed_multiplier : std_logic;
  signal data_a_in_k_enable_tensor_fixed_multiplier : std_logic;
  signal data_b_in_i_enable_tensor_fixed_multiplier : std_logic;
  signal data_b_in_j_enable_tensor_fixed_multiplier : std_logic;
  signal data_b_in_k_enable_tensor_fixed_multiplier : std_logic;

  signal data_out_i_enable_tensor_fixed_multiplier : std_logic;
  signal data_out_j_enable_tensor_fixed_multiplier : std_logic;
  signal data_out_k_enable_tensor_fixed_multiplier : std_logic;

  -- DATA
  signal size_i_in_tensor_fixed_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_fixed_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_fixed_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_fixed_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_fixed_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_fixed_multiplier : std_logic;

  -- TENSOR FIXED DIVIDER
  -- CONTROL
  signal start_tensor_fixed_divider : std_logic;
  signal ready_tensor_fixed_divider : std_logic;

  signal data_a_in_i_enable_tensor_fixed_divider : std_logic;
  signal data_a_in_j_enable_tensor_fixed_divider : std_logic;
  signal data_a_in_k_enable_tensor_fixed_divider : std_logic;
  signal data_b_in_i_enable_tensor_fixed_divider : std_logic;
  signal data_b_in_j_enable_tensor_fixed_divider : std_logic;
  signal data_b_in_k_enable_tensor_fixed_divider : std_logic;

  signal data_out_i_enable_tensor_fixed_divider : std_logic;
  signal data_out_j_enable_tensor_fixed_divider : std_logic;
  signal data_out_k_enable_tensor_fixed_divider : std_logic;

  -- DATA
  signal size_i_in_tensor_fixed_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_fixed_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_fixed_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_fixed_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_fixed_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_fixed_divider : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  fixed_stimulus : model_fixed_stimulus
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
      -- STIMULUS SCALAR FIXED
      ------------------------------------------------------------------------------

      -- SCALAR FIXED ADDER
      -- CONTROL
      SCALAR_FIXED_ADDER_START => start_scalar_fixed_adder,
      SCALAR_FIXED_ADDER_READY => ready_scalar_fixed_adder,

      SCALAR_FIXED_ADDER_OPERATION => operation_scalar_fixed_adder,

      -- DATA
      SCALAR_FIXED_ADDER_DATA_A_IN    => data_a_in_scalar_fixed_adder,
      SCALAR_FIXED_ADDER_DATA_B_IN    => data_b_in_scalar_fixed_adder,
      SCALAR_FIXED_ADDER_DATA_OUT     => data_out_scalar_fixed_adder,
      SCALAR_FIXED_ADDER_OVERFLOW_OUT => overflow_out_scalar_fixed_adder,

      -- SCALAR FIXED MULTIPLIER
      -- CONTROL
      SCALAR_FIXED_MULTIPLIER_START => start_scalar_fixed_multiplier,
      SCALAR_FIXED_MULTIPLIER_READY => ready_scalar_fixed_multiplier,

      -- DATA
      SCALAR_FIXED_MULTIPLIER_DATA_A_IN    => data_a_in_scalar_fixed_multiplier,
      SCALAR_FIXED_MULTIPLIER_DATA_B_IN    => data_b_in_scalar_fixed_multiplier,
      SCALAR_FIXED_MULTIPLIER_DATA_OUT     => data_out_scalar_fixed_multiplier,
      SCALAR_FIXED_MULTIPLIER_OVERFLOW_OUT => overflow_out_scalar_fixed_multiplier,

      -- SCALAR FIXED DIVIDER
      -- CONTROL
      SCALAR_FIXED_DIVIDER_START => start_scalar_fixed_divider,
      SCALAR_FIXED_DIVIDER_READY => ready_scalar_fixed_divider,

      -- DATA
      SCALAR_FIXED_DIVIDER_DATA_A_IN    => data_a_in_scalar_fixed_divider,
      SCALAR_FIXED_DIVIDER_DATA_B_IN    => data_b_in_scalar_fixed_divider,
      SCALAR_FIXED_DIVIDER_DATA_OUT     => data_out_scalar_fixed_divider,
      SCALAR_FIXED_DIVIDER_OVERFLOW_OUT => overflow_out_scalar_fixed_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR FIXED
      ------------------------------------------------------------------------------

      -- VECTOR FIXED ADDER
      -- CONTROL
      VECTOR_FIXED_ADDER_START => start_vector_fixed_adder,
      VECTOR_FIXED_ADDER_READY => ready_vector_fixed_adder,

      VECTOR_FIXED_ADDER_OPERATION => operation_vector_fixed_adder,

      VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_fixed_adder,
      VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_fixed_adder,

      VECTOR_FIXED_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_fixed_adder,

      -- DATA
      VECTOR_FIXED_ADDER_SIZE_IN      => size_in_vector_fixed_adder,
      VECTOR_FIXED_ADDER_DATA_A_IN    => data_a_in_vector_fixed_adder,
      VECTOR_FIXED_ADDER_DATA_B_IN    => data_b_in_vector_fixed_adder,
      VECTOR_FIXED_ADDER_DATA_OUT     => data_out_vector_fixed_adder,
      VECTOR_FIXED_ADDER_OVERFLOW_OUT => overflow_out_vector_fixed_adder,

      -- VECTOR FIXED MULTIPLIER
      -- CONTROL
      VECTOR_FIXED_MULTIPLIER_START => start_vector_fixed_multiplier,
      VECTOR_FIXED_MULTIPLIER_READY => ready_vector_fixed_multiplier,

      VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_fixed_multiplier,
      VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_fixed_multiplier,

      VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_fixed_multiplier,

      -- DATA
      VECTOR_FIXED_MULTIPLIER_SIZE_IN      => size_in_vector_fixed_multiplier,
      VECTOR_FIXED_MULTIPLIER_DATA_A_IN    => data_a_in_vector_fixed_multiplier,
      VECTOR_FIXED_MULTIPLIER_DATA_B_IN    => data_b_in_vector_fixed_multiplier,
      VECTOR_FIXED_MULTIPLIER_DATA_OUT     => data_out_vector_fixed_multiplier,
      VECTOR_FIXED_MULTIPLIER_OVERFLOW_OUT => overflow_out_vector_fixed_multiplier,

      -- VECTOR FIXED DIVIDER
      -- CONTROL
      VECTOR_FIXED_DIVIDER_START => start_vector_fixed_divider,
      VECTOR_FIXED_DIVIDER_READY => ready_vector_fixed_divider,

      VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_fixed_divider,
      VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_fixed_divider,

      VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE => data_out_enable_vector_fixed_divider,

      -- DATA
      VECTOR_FIXED_DIVIDER_SIZE_IN      => size_in_vector_fixed_divider,
      VECTOR_FIXED_DIVIDER_DATA_A_IN    => data_a_in_vector_fixed_divider,
      VECTOR_FIXED_DIVIDER_DATA_B_IN    => data_b_in_vector_fixed_divider,
      VECTOR_FIXED_DIVIDER_DATA_OUT     => data_out_vector_fixed_divider,
      VECTOR_FIXED_DIVIDER_OVERFLOW_OUT => overflow_out_vector_fixed_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX FIXED
      ------------------------------------------------------------------------------

      -- MATRIX FIXED ADDER
      -- CONTROL
      MATRIX_FIXED_ADDER_START => start_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_READY => ready_matrix_fixed_adder,

      MATRIX_FIXED_ADDER_OPERATION => operation_matrix_fixed_adder,

      MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_fixed_adder,

      MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_fixed_adder,

      -- DATA
      MATRIX_FIXED_ADDER_SIZE_I_IN    => size_i_in_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_SIZE_J_IN    => size_j_in_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_A_IN    => data_a_in_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_B_IN    => data_b_in_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_DATA_OUT     => data_out_matrix_fixed_adder,
      MATRIX_FIXED_ADDER_OVERFLOW_OUT => overflow_out_matrix_fixed_adder,

      -- MATRIX FIXED MULTIPLIER
      -- CONTROL
      MATRIX_FIXED_MULTIPLIER_START => start_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_READY => ready_matrix_fixed_multiplier,

      MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_fixed_multiplier,

      MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_fixed_multiplier,

      -- DATA
      MATRIX_FIXED_MULTIPLIER_SIZE_I_IN    => size_i_in_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_SIZE_J_IN    => size_j_in_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_A_IN    => data_a_in_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_B_IN    => data_b_in_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_DATA_OUT     => data_out_matrix_fixed_multiplier,
      MATRIX_FIXED_MULTIPLIER_OVERFLOW_OUT => overflow_out_matrix_fixed_multiplier,

      -- MATRIX FIXED DIVIDER
      -- CONTROL
      MATRIX_FIXED_DIVIDER_START => start_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_READY => ready_matrix_fixed_divider,

      MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_fixed_divider,

      MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_fixed_divider,

      -- DATA
      MATRIX_FIXED_DIVIDER_SIZE_I_IN    => size_i_in_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_SIZE_J_IN    => size_j_in_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_A_IN    => data_a_in_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_B_IN    => data_b_in_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_DATA_OUT     => data_out_matrix_fixed_divider,
      MATRIX_FIXED_DIVIDER_OVERFLOW_OUT => overflow_out_matrix_fixed_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR FIXED ADDER
      -- CONTROL
      TENSOR_FIXED_ADDER_START => start_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_READY => ready_tensor_fixed_adder,

      TENSOR_FIXED_ADDER_OPERATION => operation_tensor_fixed_adder,

      TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_fixed_adder,

      TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_fixed_adder,

      -- DATA
      TENSOR_FIXED_ADDER_SIZE_I_IN => size_i_in_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_SIZE_J_IN => size_j_in_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_SIZE_K_IN => size_k_in_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_A_IN => data_a_in_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_DATA_B_IN => data_b_in_tensor_fixed_adder,

      TENSOR_FIXED_ADDER_DATA_OUT     => data_out_tensor_fixed_adder,
      TENSOR_FIXED_ADDER_OVERFLOW_OUT => overflow_out_tensor_fixed_adder,

      -- TENSOR FIXED MULTIPLIER
      -- CONTROL
      TENSOR_FIXED_MULTIPLIER_START => start_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_READY => ready_tensor_fixed_multiplier,

      TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_fixed_multiplier,

      TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_fixed_multiplier,

      -- DATA
      TENSOR_FIXED_MULTIPLIER_SIZE_I_IN => size_i_in_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_SIZE_J_IN => size_j_in_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_SIZE_K_IN => size_k_in_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_A_IN => data_a_in_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_DATA_B_IN => data_b_in_tensor_fixed_multiplier,

      TENSOR_FIXED_MULTIPLIER_DATA_OUT     => data_out_tensor_fixed_multiplier,
      TENSOR_FIXED_MULTIPLIER_OVERFLOW_OUT => overflow_out_tensor_fixed_multiplier,

      -- TENSOR FIXED DIVIDER
      -- CONTROL
      TENSOR_FIXED_DIVIDER_START => start_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_READY => ready_tensor_fixed_divider,

      TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_fixed_divider,

      TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_fixed_divider,

      -- DATA
      TENSOR_FIXED_DIVIDER_SIZE_I_IN => size_i_in_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_SIZE_J_IN => size_j_in_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_SIZE_K_IN => size_k_in_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_A_IN => data_a_in_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_DATA_B_IN => data_b_in_tensor_fixed_divider,

      TENSOR_FIXED_DIVIDER_DATA_OUT     => data_out_tensor_fixed_divider,
      TENSOR_FIXED_DIVIDER_OVERFLOW_OUT => overflow_out_tensor_fixed_divider
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR FIXED ADDER
  model_scalar_fixed_adder_test : if (ENABLE_NTM_SCALAR_FIXED_ADDER_TEST) generate
    scalar_fixed_adder : model_scalar_fixed_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_fixed_adder,
        READY => ready_scalar_fixed_adder,

        OPERATION => operation_scalar_fixed_adder,

        -- DATA
        DATA_A_IN => data_a_in_scalar_fixed_adder,
        DATA_B_IN => data_b_in_scalar_fixed_adder,

        DATA_OUT => data_out_scalar_fixed_adder
        );
  end generate model_scalar_fixed_adder_test;

  -- SCALAR FIXED MULTIPLIER
  model_scalar_fixed_multiplier_test : if (ENABLE_NTM_SCALAR_FIXED_MULTIPLIER_TEST) generate
    scalar_fixed_multiplier : model_scalar_fixed_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_fixed_multiplier,
        READY => ready_scalar_fixed_multiplier,

        -- DATA
        DATA_A_IN => data_a_in_scalar_fixed_multiplier,
        DATA_B_IN => data_b_in_scalar_fixed_multiplier,

        DATA_OUT     => data_out_scalar_fixed_multiplier,
        OVERFLOW_OUT => overflow_out_scalar_fixed_multiplier
        );
  end generate model_scalar_fixed_multiplier_test;

  -- SCALAR FIXED DIVIDER
  model_scalar_fixed_divider_test : if (ENABLE_NTM_SCALAR_FIXED_DIVIDER_TEST) generate
    scalar_fixed_divider : model_scalar_fixed_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_fixed_divider,
        READY => ready_scalar_fixed_divider,

        -- DATA
        DATA_A_IN => data_a_in_scalar_fixed_divider,
        DATA_B_IN => data_b_in_scalar_fixed_divider,

        DATA_OUT     => data_out_scalar_fixed_divider,
        OVERFLOW_OUT => overflow_out_scalar_fixed_divider
        );
  end generate model_scalar_fixed_divider_test;

  scalar_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_scalar_fixed_adder = '1') then
        assert data_out_scalar_fixed_adder = function_scalar_fixed_adder(operation_scalar_fixed_adder, data_a_in_scalar_fixed_adder, data_b_in_scalar_fixed_adder)
          report "SCALAR ADDER: " & to_string(to_integer(signed(data_out_scalar_fixed_adder)))
          severity error;
      end if;

      if (ready_scalar_fixed_multiplier = '1') then
        assert data_out_scalar_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_scalar_fixed_multiplier, data_b_in_scalar_fixed_multiplier)
          report "SCALAR MULTIPLIER: " & to_string(to_integer(signed(data_out_scalar_fixed_multiplier)))
          severity error;
      end if;

      if (ready_scalar_fixed_divider = '1') then
        assert data_out_scalar_fixed_divider = function_scalar_fixed_divider(data_a_in_scalar_fixed_divider, data_b_in_scalar_fixed_divider)
          report "SCALAR DIVIDER: " & to_string(to_integer(signed(data_out_scalar_fixed_divider)))
          severity error;
      end if;
    end if;
  end process scalar_assertion;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR FIXED ADDER
  model_vector_fixed_adder_test : if (ENABLE_NTM_VECTOR_FIXED_ADDER_TEST) generate
    vector_fixed_adder : model_vector_fixed_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_fixed_adder,
        READY => ready_vector_fixed_adder,

        OPERATION => operation_vector_fixed_adder,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_fixed_adder,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_fixed_adder,

        DATA_OUT_ENABLE => data_out_enable_vector_fixed_adder,

        -- DATA
        SIZE_IN   => size_in_vector_fixed_adder,
        DATA_A_IN => data_a_in_vector_fixed_adder,
        DATA_B_IN => data_b_in_vector_fixed_adder,

        DATA_OUT     => data_out_vector_fixed_adder,
        OVERFLOW_OUT => overflow_out_vector_fixed_adder
        );
  end generate model_vector_fixed_adder_test;

  -- VECTOR FIXED MULTIPLIER
  model_vector_fixed_multiplier_test : if (ENABLE_NTM_VECTOR_FIXED_MULTIPLIER_TEST) generate
    vector_fixed_multiplier : model_vector_fixed_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_fixed_multiplier,
        READY => ready_vector_fixed_multiplier,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_fixed_multiplier,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_fixed_multiplier,

        DATA_OUT_ENABLE => data_out_enable_vector_fixed_multiplier,

        -- DATA
        SIZE_IN   => size_in_vector_fixed_multiplier,
        DATA_A_IN => data_a_in_vector_fixed_multiplier,
        DATA_B_IN => data_b_in_vector_fixed_multiplier,

        DATA_OUT     => data_out_vector_fixed_multiplier,
        OVERFLOW_OUT => overflow_out_vector_fixed_multiplier
        );
  end generate model_vector_fixed_multiplier_test;

  -- VECTOR FIXED DIVIDER
  model_vector_fixed_divider_test : if (ENABLE_NTM_VECTOR_FIXED_DIVIDER_TEST) generate
    vector_fixed_divider : model_vector_fixed_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_fixed_divider,
        READY => ready_vector_fixed_divider,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_fixed_divider,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_fixed_divider,

        DATA_OUT_ENABLE => data_out_enable_vector_fixed_divider,

        -- DATA
        SIZE_IN   => size_in_vector_fixed_divider,
        DATA_A_IN => data_a_in_vector_fixed_divider,
        DATA_B_IN => data_b_in_vector_fixed_divider,

        DATA_OUT     => data_out_vector_fixed_divider,
        OVERFLOW_OUT => overflow_out_vector_fixed_divider
        );
  end generate model_vector_fixed_divider_test;

  vector_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_vector_fixed_adder = '1' and data_out_enable_vector_fixed_adder = '1') then
        assert data_out_vector_fixed_adder = function_scalar_fixed_adder(operation_vector_fixed_adder, data_a_in_vector_fixed_adder, data_b_in_vector_fixed_adder)
          report "VECTOR ADDER: " & to_string(to_integer(signed(data_out_vector_fixed_adder)))
          severity error;
      elsif (data_out_enable_vector_fixed_adder = '1') then
        assert data_out_vector_fixed_adder = function_scalar_fixed_adder(operation_vector_fixed_adder, data_a_in_vector_fixed_adder, data_b_in_vector_fixed_adder)
          report "VECTOR ADDER: " & to_string(to_integer(signed(data_out_vector_fixed_adder)))
          severity error;
      end if;

      if (ready_vector_fixed_multiplier = '1' and data_out_enable_vector_fixed_multiplier = '1') then
        assert data_out_vector_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_vector_fixed_multiplier, data_b_in_vector_fixed_multiplier)
          report "VECTOR MULTIPLIER: " & to_string(to_integer(signed(data_out_vector_fixed_multiplier)))
          severity error;
      elsif (data_out_enable_vector_fixed_multiplier = '1') then
        assert data_out_vector_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_vector_fixed_multiplier, data_b_in_vector_fixed_multiplier)
          report "VECTOR MULTIPLIER: " & to_string(to_integer(signed(data_out_vector_fixed_multiplier)))
          severity error;
      end if;

      if (ready_vector_fixed_divider = '1' and data_out_enable_vector_fixed_divider = '1') then
        assert data_out_vector_fixed_divider = function_scalar_fixed_divider(data_a_in_vector_fixed_divider, data_b_in_vector_fixed_divider)
          report "VECTOR DIVIDER: " & to_string(to_integer(signed(data_out_vector_fixed_divider)))
          severity error;
      elsif (data_out_enable_vector_fixed_divider = '1') then
        assert data_out_vector_fixed_divider = function_scalar_fixed_divider(data_a_in_vector_fixed_divider, data_b_in_vector_fixed_divider)
          report "VECTOR DIVIDER: " & to_string(to_integer(signed(data_out_vector_fixed_divider)))
          severity error;
      end if;
    end if;
  end process vector_assertion;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX FIXED ADDER
  model_matrix_fixed_adder_test : if (ENABLE_NTM_MATRIX_FIXED_ADDER_TEST) generate
    matrix_fixed_adder : model_matrix_fixed_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_fixed_adder,
        READY => ready_matrix_fixed_adder,

        OPERATION => operation_matrix_fixed_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_fixed_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_fixed_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_fixed_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_fixed_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_fixed_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_fixed_adder,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_fixed_adder,
        SIZE_J_IN => size_j_in_matrix_fixed_adder,
        DATA_A_IN => data_a_in_matrix_fixed_adder,
        DATA_B_IN => data_b_in_matrix_fixed_adder,

        DATA_OUT     => data_out_matrix_fixed_adder,
        OVERFLOW_OUT => overflow_out_matrix_fixed_adder
        );
  end generate model_matrix_fixed_adder_test;

  -- MATRIX FIXED MULTIPLIER
  model_matrix_fixed_multiplier_test : if (ENABLE_NTM_MATRIX_FIXED_MULTIPLIER_TEST) generate
    matrix_fixed_multiplier : model_matrix_fixed_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_fixed_multiplier,
        READY => ready_matrix_fixed_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_fixed_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_fixed_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_fixed_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_fixed_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_fixed_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_fixed_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_fixed_multiplier,
        SIZE_J_IN => size_j_in_matrix_fixed_multiplier,
        DATA_A_IN => data_a_in_matrix_fixed_multiplier,
        DATA_B_IN => data_b_in_matrix_fixed_multiplier,

        DATA_OUT     => data_out_matrix_fixed_multiplier,
        OVERFLOW_OUT => overflow_out_matrix_fixed_multiplier
        );
  end generate model_matrix_fixed_multiplier_test;

  -- MATRIX FIXED DIVIDER
  model_matrix_fixed_divider_test : if (ENABLE_NTM_MATRIX_FIXED_DIVIDER_TEST) generate
    matrix_fixed_divider : model_matrix_fixed_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_fixed_divider,
        READY => ready_matrix_fixed_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_fixed_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_fixed_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_fixed_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_fixed_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_fixed_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_fixed_divider,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_fixed_divider,
        SIZE_J_IN => size_j_in_matrix_fixed_divider,
        DATA_A_IN => data_a_in_matrix_fixed_divider,
        DATA_B_IN => data_b_in_matrix_fixed_divider,

        DATA_OUT     => data_out_matrix_fixed_divider,
        OVERFLOW_OUT => overflow_out_matrix_fixed_divider
        );
  end generate model_matrix_fixed_divider_test;

  matrix_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_matrix_fixed_adder = '1' and data_out_i_enable_matrix_fixed_adder = '1' and data_out_j_enable_matrix_fixed_adder = '1') then
        assert data_out_matrix_fixed_adder = function_scalar_fixed_adder(operation_matrix_fixed_adder, data_a_in_matrix_fixed_adder, data_b_in_matrix_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_matrix_fixed_adder)))
          severity error;
      elsif (data_out_i_enable_matrix_fixed_adder = '1' and data_out_j_enable_matrix_fixed_adder = '1') then
        assert data_out_matrix_fixed_adder = function_scalar_fixed_adder(operation_matrix_fixed_adder, data_a_in_matrix_fixed_adder, data_b_in_matrix_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_matrix_fixed_adder)))
          severity error;
      elsif (data_out_j_enable_matrix_fixed_adder = '1') then
        assert data_out_matrix_fixed_adder = function_scalar_fixed_adder(operation_matrix_fixed_adder, data_a_in_matrix_fixed_adder, data_b_in_matrix_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_matrix_fixed_adder)))
          severity error;
      end if;

      if (ready_matrix_fixed_multiplier = '1' and data_out_i_enable_matrix_fixed_multiplier = '1' and data_out_j_enable_matrix_fixed_multiplier = '1') then
        assert data_out_matrix_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_matrix_fixed_multiplier, data_b_in_matrix_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_matrix_fixed_multiplier)))
          severity error;
      elsif (data_out_i_enable_matrix_fixed_multiplier = '1' and data_out_j_enable_matrix_fixed_multiplier = '1') then
        assert data_out_matrix_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_matrix_fixed_multiplier, data_b_in_matrix_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_matrix_fixed_multiplier)))
          severity error;
      elsif (data_out_j_enable_matrix_fixed_multiplier = '1') then
        assert data_out_matrix_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_matrix_fixed_multiplier, data_b_in_matrix_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_matrix_fixed_multiplier)))
          severity error;
      end if;

      if (ready_matrix_fixed_divider = '1' and data_out_i_enable_matrix_fixed_divider = '1' and data_out_j_enable_matrix_fixed_divider = '1') then
        assert data_out_matrix_fixed_divider = function_scalar_fixed_divider(data_a_in_matrix_fixed_divider, data_b_in_matrix_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_matrix_fixed_divider)))
          severity error;
      elsif (data_out_i_enable_matrix_fixed_divider = '1' and data_out_j_enable_matrix_fixed_divider = '1') then
        assert data_out_matrix_fixed_divider = function_scalar_fixed_divider(data_a_in_matrix_fixed_divider, data_b_in_matrix_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_matrix_fixed_divider)))
          severity error;
      elsif (data_out_j_enable_matrix_fixed_divider = '1') then
        assert data_out_matrix_fixed_divider = function_scalar_fixed_divider(data_a_in_matrix_fixed_divider, data_b_in_matrix_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_matrix_fixed_divider)))
          severity error;
      end if;
    end if;
  end process matrix_assertion;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR FIXED ADDER
  model_tensor_fixed_adder_test : if (ENABLE_NTM_TENSOR_FIXED_ADDER_TEST) generate
    tensor_fixed_adder : model_tensor_fixed_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_fixed_adder,
        READY => ready_tensor_fixed_adder,

        OPERATION => operation_tensor_fixed_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_fixed_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_fixed_adder,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_fixed_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_fixed_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_fixed_adder,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_fixed_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_fixed_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_fixed_adder,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_fixed_adder,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_fixed_adder,
        SIZE_J_IN => size_j_in_tensor_fixed_adder,
        SIZE_K_IN => size_k_in_tensor_fixed_adder,
        DATA_A_IN => data_a_in_tensor_fixed_adder,
        DATA_B_IN => data_b_in_tensor_fixed_adder,

        DATA_OUT     => data_out_tensor_fixed_adder,
        OVERFLOW_OUT => overflow_out_tensor_fixed_adder
        );
  end generate model_tensor_fixed_adder_test;

  -- TENSOR FIXED MULTIPLIER
  model_tensor_fixed_multiplier_test : if (ENABLE_NTM_TENSOR_FIXED_MULTIPLIER_TEST) generate
    tensor_fixed_multiplier : model_tensor_fixed_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_fixed_multiplier,
        READY => ready_tensor_fixed_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_fixed_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_fixed_multiplier,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_fixed_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_fixed_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_fixed_multiplier,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_fixed_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_fixed_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_fixed_multiplier,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_fixed_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_fixed_multiplier,
        SIZE_J_IN => size_j_in_tensor_fixed_multiplier,
        SIZE_K_IN => size_k_in_tensor_fixed_multiplier,
        DATA_A_IN => data_a_in_tensor_fixed_multiplier,
        DATA_B_IN => data_b_in_tensor_fixed_multiplier,

        DATA_OUT     => data_out_tensor_fixed_multiplier,
        OVERFLOW_OUT => overflow_out_tensor_fixed_multiplier
        );
  end generate model_tensor_fixed_multiplier_test;

  -- TENSOR FIXED DIVIDER
  model_tensor_fixed_divider_test : if (ENABLE_NTM_TENSOR_FIXED_DIVIDER_TEST) generate
    tensor_fixed_divider : model_tensor_fixed_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_fixed_divider,
        READY => ready_tensor_fixed_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_fixed_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_fixed_divider,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_fixed_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_fixed_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_fixed_divider,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_fixed_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_fixed_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_fixed_divider,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_fixed_divider,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_fixed_divider,
        SIZE_J_IN => size_j_in_tensor_fixed_divider,
        SIZE_K_IN => size_k_in_tensor_fixed_divider,
        DATA_A_IN => data_a_in_tensor_fixed_divider,
        DATA_B_IN => data_b_in_tensor_fixed_divider,

        DATA_OUT     => data_out_tensor_fixed_divider,
        OVERFLOW_OUT => overflow_out_tensor_fixed_divider
        );
  end generate model_tensor_fixed_divider_test;

  tensor_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_tensor_fixed_adder = '1' and data_out_i_enable_tensor_fixed_adder = '1' and data_out_j_enable_tensor_fixed_adder = '1' and data_out_k_enable_tensor_fixed_adder = '1') then
        assert data_out_tensor_fixed_adder = function_scalar_fixed_adder(operation_tensor_fixed_adder, data_a_in_tensor_fixed_adder, data_b_in_tensor_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_tensor_fixed_adder)))
          severity error;
      elsif (data_out_i_enable_tensor_fixed_adder = '1' and data_out_j_enable_tensor_fixed_adder = '1' and data_out_k_enable_tensor_fixed_adder = '1') then
        assert data_out_tensor_fixed_adder = function_scalar_fixed_adder(operation_tensor_fixed_adder, data_a_in_tensor_fixed_adder, data_b_in_tensor_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_tensor_fixed_adder)))
          severity error;
      elsif (data_out_j_enable_tensor_fixed_adder = '1' and data_out_k_enable_tensor_fixed_adder = '1') then
        assert data_out_tensor_fixed_adder = function_scalar_fixed_adder(operation_tensor_fixed_adder, data_a_in_tensor_fixed_adder, data_b_in_tensor_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_tensor_fixed_adder)))
          severity error;
      elsif (data_out_k_enable_tensor_fixed_adder = '1') then
        assert data_out_tensor_fixed_adder = function_scalar_fixed_adder(operation_tensor_fixed_adder, data_a_in_tensor_fixed_adder, data_b_in_tensor_fixed_adder)
          report "MATRIX ADDER: " & to_string(to_integer(signed(data_out_tensor_fixed_adder)))
          severity error;
      end if;

      if (ready_tensor_fixed_multiplier = '1' and data_out_i_enable_tensor_fixed_multiplier = '1' and data_out_j_enable_tensor_fixed_multiplier = '1' and data_out_k_enable_tensor_fixed_multiplier = '1') then
        assert data_out_tensor_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_tensor_fixed_multiplier, data_b_in_tensor_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_tensor_fixed_multiplier)))
          severity error;
      elsif (data_out_i_enable_tensor_fixed_multiplier = '1' and data_out_j_enable_tensor_fixed_multiplier = '1' and data_out_k_enable_tensor_fixed_multiplier = '1') then
        assert data_out_tensor_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_tensor_fixed_multiplier, data_b_in_tensor_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_tensor_fixed_multiplier)))
          severity error;
      elsif (data_out_j_enable_tensor_fixed_multiplier = '1' and data_out_k_enable_tensor_fixed_multiplier = '1') then
        assert data_out_tensor_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_tensor_fixed_multiplier, data_b_in_tensor_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_tensor_fixed_multiplier)))
          severity error;
      elsif (data_out_k_enable_tensor_fixed_multiplier = '1') then
        assert data_out_tensor_fixed_multiplier = function_scalar_fixed_multiplier(data_a_in_tensor_fixed_multiplier, data_b_in_tensor_fixed_multiplier)
          report "MATRIX MULTIPLIER: " & to_string(to_integer(signed(data_out_tensor_fixed_multiplier)))
          severity error;
      end if;

      if (ready_tensor_fixed_divider = '1' and data_out_i_enable_tensor_fixed_divider = '1' and data_out_j_enable_tensor_fixed_divider = '1' and data_out_k_enable_tensor_fixed_divider = '1') then
        assert data_out_tensor_fixed_divider = function_scalar_fixed_divider(data_a_in_tensor_fixed_divider, data_b_in_tensor_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_tensor_fixed_divider)))
          severity error;
      elsif (data_out_i_enable_tensor_fixed_divider = '1' and data_out_j_enable_tensor_fixed_divider = '1' and data_out_k_enable_tensor_fixed_divider = '1') then
        assert data_out_tensor_fixed_divider = function_scalar_fixed_divider(data_a_in_tensor_fixed_divider, data_b_in_tensor_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_tensor_fixed_divider)))
          severity error;
      elsif (data_out_j_enable_tensor_fixed_divider = '1' and data_out_k_enable_tensor_fixed_divider = '1') then
        assert data_out_tensor_fixed_divider = function_scalar_fixed_divider(data_a_in_tensor_fixed_divider, data_b_in_tensor_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_tensor_fixed_divider)))
          severity error;
      elsif (data_out_k_enable_tensor_fixed_divider = '1') then
        assert data_out_tensor_fixed_divider = function_scalar_fixed_divider(data_a_in_tensor_fixed_divider, data_b_in_tensor_fixed_divider)
          report "MATRIX DIVIDER: " & to_string(to_integer(signed(data_out_tensor_fixed_divider)))
          severity error;
      end if;
    end if;
  end process tensor_assertion;

end model_fixed_testbench_architecture;
