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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_float_pkg.all;

entity model_float_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- SCALAR-FUNCTIONALITY
    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_1    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_2      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_2 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_2    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_3      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_3 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_3    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_4      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_4 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_4    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_5      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_5 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_5    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_6      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_6 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_6    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_7      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_7 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_7    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_8      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_8 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_8    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_9      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_9 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_9    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_10      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_10 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_10    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_11      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_11 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_11    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_12      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_12 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_12    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_13      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_13 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_13    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_14      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_14 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_14    : boolean := false;

    ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_15      : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_15 : boolean := false;
    ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_15    : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_ACCELERATOR_VECTOR_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_ACCELERATOR_VECTOR_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_ACCELERATOR_VECTOR_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_FLOAT_DIVIDER_CASE_1    : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_ACCELERATOR_MATRIX_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_FLOAT_DIVIDER_CASE_1    : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_ACCELERATOR_TENSOR_FLOAT_ADDER_TEST      : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST    : boolean := false;

    ENABLE_ACCELERATOR_TENSOR_FLOAT_ADDER_CASE_0      : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_FLOAT_DIVIDER_CASE_0    : boolean := false;

    ENABLE_ACCELERATOR_TENSOR_FLOAT_ADDER_CASE_1      : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_FLOAT_DIVIDER_CASE_1    : boolean := false
    );
end model_float_testbench;

architecture model_float_testbench_architecture of model_float_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR FLOAT ADDER
  -- CONTROL
  signal start_scalar_float_adder : std_logic;
  signal ready_scalar_float_adder : std_logic;

  signal operation_scalar_float_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_adder : std_logic;

  -- SCALAR FLOAT MULTIPLIER
  -- CONTROL
  signal start_scalar_float_multiplier : std_logic;
  signal ready_scalar_float_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_multiplier : std_logic;

  -- SCALAR FLOAT DIVIDER
  -- CONTROL
  signal start_scalar_float_divider : std_logic;
  signal ready_scalar_float_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_float_divider : std_logic;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR FLOAT ADDER
  -- CONTROL
  signal start_vector_float_adder : std_logic;
  signal ready_vector_float_adder : std_logic;

  signal operation_vector_float_adder : std_logic;

  signal data_a_in_enable_vector_float_adder : std_logic;
  signal data_b_in_enable_vector_float_adder : std_logic;

  signal data_out_enable_vector_float_adder : std_logic;

  -- DATA
  signal size_in_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_adder : std_logic;

  -- VECTOR FLOAT MULTIPLIER
  -- CONTROL
  signal start_vector_float_multiplier : std_logic;
  signal ready_vector_float_multiplier : std_logic;

  signal data_a_in_enable_vector_float_multiplier : std_logic;
  signal data_b_in_enable_vector_float_multiplier : std_logic;

  signal data_out_enable_vector_float_multiplier : std_logic;

  -- DATA
  signal size_in_vector_float_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_multiplier : std_logic;

  -- VECTOR FLOAT DIVIDER
  -- CONTROL
  signal start_vector_float_divider : std_logic;
  signal ready_vector_float_divider : std_logic;

  signal data_a_in_enable_vector_float_divider : std_logic;
  signal data_b_in_enable_vector_float_divider : std_logic;

  signal data_out_enable_vector_float_divider : std_logic;

  -- DATA
  signal size_in_vector_float_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_float_divider : std_logic;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX FLOAT ADDER
  -- CONTROL
  signal start_matrix_float_adder : std_logic;
  signal ready_matrix_float_adder : std_logic;

  signal operation_matrix_float_adder : std_logic;

  signal data_a_in_i_enable_matrix_float_adder : std_logic;
  signal data_a_in_j_enable_matrix_float_adder : std_logic;
  signal data_b_in_i_enable_matrix_float_adder : std_logic;
  signal data_b_in_j_enable_matrix_float_adder : std_logic;

  signal data_out_i_enable_matrix_float_adder : std_logic;
  signal data_out_j_enable_matrix_float_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_adder : std_logic;

  -- MATRIX FLOAT MULTIPLIER
  -- CONTROL
  signal start_matrix_float_multiplier : std_logic;
  signal ready_matrix_float_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_float_multiplier : std_logic;

  signal data_out_i_enable_matrix_float_multiplier : std_logic;
  signal data_out_j_enable_matrix_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_multiplier : std_logic;

  -- MATRIX FLOAT DIVIDER
  -- CONTROL
  signal start_matrix_float_divider : std_logic;
  signal ready_matrix_float_divider : std_logic;

  signal data_a_in_i_enable_matrix_float_divider : std_logic;
  signal data_a_in_j_enable_matrix_float_divider : std_logic;
  signal data_b_in_i_enable_matrix_float_divider : std_logic;
  signal data_b_in_j_enable_matrix_float_divider : std_logic;

  signal data_out_i_enable_matrix_float_divider : std_logic;
  signal data_out_j_enable_matrix_float_divider : std_logic;

  -- DATA
  signal size_i_in_matrix_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_float_divider : std_logic;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR FLOAT ADDER
  -- CONTROL
  signal start_tensor_float_adder : std_logic;
  signal ready_tensor_float_adder : std_logic;

  signal operation_tensor_float_adder : std_logic;

  signal data_a_in_i_enable_tensor_float_adder : std_logic;
  signal data_a_in_j_enable_tensor_float_adder : std_logic;
  signal data_a_in_k_enable_tensor_float_adder : std_logic;
  signal data_b_in_i_enable_tensor_float_adder : std_logic;
  signal data_b_in_j_enable_tensor_float_adder : std_logic;
  signal data_b_in_k_enable_tensor_float_adder : std_logic;

  signal data_out_i_enable_tensor_float_adder : std_logic;
  signal data_out_j_enable_tensor_float_adder : std_logic;
  signal data_out_k_enable_tensor_float_adder : std_logic;

  -- DATA
  signal size_i_in_tensor_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_float_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_float_adder : std_logic;

  -- TENSOR FLOAT MULTIPLIER
  -- CONTROL
  signal start_tensor_float_multiplier : std_logic;
  signal ready_tensor_float_multiplier : std_logic;

  signal data_a_in_i_enable_tensor_float_multiplier : std_logic;
  signal data_a_in_j_enable_tensor_float_multiplier : std_logic;
  signal data_a_in_k_enable_tensor_float_multiplier : std_logic;
  signal data_b_in_i_enable_tensor_float_multiplier : std_logic;
  signal data_b_in_j_enable_tensor_float_multiplier : std_logic;
  signal data_b_in_k_enable_tensor_float_multiplier : std_logic;

  signal data_out_i_enable_tensor_float_multiplier : std_logic;
  signal data_out_j_enable_tensor_float_multiplier : std_logic;
  signal data_out_k_enable_tensor_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_tensor_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_float_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_float_multiplier : std_logic;

  -- TENSOR FLOAT DIVIDER
  -- CONTROL
  signal start_tensor_float_divider : std_logic;
  signal ready_tensor_float_divider : std_logic;

  signal data_a_in_i_enable_tensor_float_divider : std_logic;
  signal data_a_in_j_enable_tensor_float_divider : std_logic;
  signal data_a_in_k_enable_tensor_float_divider : std_logic;
  signal data_b_in_i_enable_tensor_float_divider : std_logic;
  signal data_b_in_j_enable_tensor_float_divider : std_logic;
  signal data_b_in_k_enable_tensor_float_divider : std_logic;

  signal data_out_i_enable_tensor_float_divider : std_logic;
  signal data_out_j_enable_tensor_float_divider : std_logic;
  signal data_out_k_enable_tensor_float_divider : std_logic;

  -- DATA
  signal size_i_in_tensor_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_float_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_float_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_float_divider     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_float_divider : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  float_stimulus : model_float_stimulus
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
      -- STIMULUS SCALAR FLOAT
      ------------------------------------------------------------------------------

      -- SCALAR FLOAT ADDER
      -- CONTROL
      SCALAR_FLOAT_ADDER_START => start_scalar_float_adder,
      SCALAR_FLOAT_ADDER_READY => ready_scalar_float_adder,

      SCALAR_FLOAT_ADDER_OPERATION => operation_scalar_float_adder,

      -- DATA
      SCALAR_FLOAT_ADDER_DATA_A_IN    => data_a_in_scalar_float_adder,
      SCALAR_FLOAT_ADDER_DATA_B_IN    => data_b_in_scalar_float_adder,
      SCALAR_FLOAT_ADDER_DATA_OUT     => data_out_scalar_float_adder,
      SCALAR_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_scalar_float_adder,

      -- SCALAR FLOAT MULTIPLIER
      -- CONTROL
      SCALAR_FLOAT_MULTIPLIER_START => start_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_READY => ready_scalar_float_multiplier,

      -- DATA
      SCALAR_FLOAT_MULTIPLIER_DATA_A_IN    => data_a_in_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_DATA_B_IN    => data_b_in_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_DATA_OUT     => data_out_scalar_float_multiplier,
      SCALAR_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_scalar_float_multiplier,

      -- SCALAR FLOAT DIVIDER
      -- CONTROL
      SCALAR_FLOAT_DIVIDER_START => start_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_READY => ready_scalar_float_divider,

      -- DATA
      SCALAR_FLOAT_DIVIDER_DATA_A_IN    => data_a_in_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_DATA_B_IN    => data_b_in_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_DATA_OUT     => data_out_scalar_float_divider,
      SCALAR_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_scalar_float_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR FLOAT
      ------------------------------------------------------------------------------

      -- VECTOR FLOAT ADDER
      -- CONTROL
      VECTOR_FLOAT_ADDER_START => start_vector_float_adder,
      VECTOR_FLOAT_ADDER_READY => ready_vector_float_adder,

      VECTOR_FLOAT_ADDER_OPERATION => operation_vector_float_adder,

      VECTOR_FLOAT_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      VECTOR_FLOAT_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      VECTOR_FLOAT_ADDER_SIZE_IN      => size_in_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_A_IN    => data_a_in_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_B_IN    => data_b_in_vector_float_adder,
      VECTOR_FLOAT_ADDER_DATA_OUT     => data_out_vector_float_adder,
      VECTOR_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_vector_float_adder,

      -- VECTOR FLOAT MULTIPLIER
      -- CONTROL
      VECTOR_FLOAT_MULTIPLIER_START => start_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_READY => ready_vector_float_multiplier,

      VECTOR_FLOAT_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

      VECTOR_FLOAT_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

      -- DATA
      VECTOR_FLOAT_MULTIPLIER_SIZE_IN      => size_in_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_A_IN    => data_a_in_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_B_IN    => data_b_in_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_DATA_OUT     => data_out_vector_float_multiplier,
      VECTOR_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_vector_float_multiplier,

      -- VECTOR FLOAT DIVIDER
      -- CONTROL
      VECTOR_FLOAT_DIVIDER_START => start_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_READY => ready_vector_float_divider,

      VECTOR_FLOAT_DIVIDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_float_divider,

      VECTOR_FLOAT_DIVIDER_DATA_OUT_ENABLE => data_out_enable_vector_float_divider,

      -- DATA
      VECTOR_FLOAT_DIVIDER_SIZE_IN      => size_in_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_A_IN    => data_a_in_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_B_IN    => data_b_in_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_DATA_OUT     => data_out_vector_float_divider,
      VECTOR_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_vector_float_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX FLOAT
      ------------------------------------------------------------------------------

      -- MATRIX FLOAT ADDER
      -- CONTROL
      MATRIX_FLOAT_ADDER_START => start_matrix_float_adder,
      MATRIX_FLOAT_ADDER_READY => ready_matrix_float_adder,

      MATRIX_FLOAT_ADDER_OPERATION => operation_matrix_float_adder,

      MATRIX_FLOAT_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_adder,

      MATRIX_FLOAT_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_adder,

      -- DATA
      MATRIX_FLOAT_ADDER_SIZE_I_IN    => size_i_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_SIZE_J_IN    => size_j_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_A_IN    => data_a_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_B_IN    => data_b_in_matrix_float_adder,
      MATRIX_FLOAT_ADDER_DATA_OUT     => data_out_matrix_float_adder,
      MATRIX_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_matrix_float_adder,

      -- MATRIX FLOAT MULTIPLIER
      -- CONTROL
      MATRIX_FLOAT_MULTIPLIER_START => start_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_READY => ready_matrix_float_multiplier,

      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

      MATRIX_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

      -- DATA
      MATRIX_FLOAT_MULTIPLIER_SIZE_I_IN    => size_i_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_SIZE_J_IN    => size_j_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_A_IN    => data_a_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_B_IN    => data_b_in_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_DATA_OUT     => data_out_matrix_float_multiplier,
      MATRIX_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_matrix_float_multiplier,

      -- MATRIX FLOAT DIVIDER
      -- CONTROL
      MATRIX_FLOAT_DIVIDER_START => start_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_READY => ready_matrix_float_divider,

      MATRIX_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_divider,

      MATRIX_FLOAT_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_divider,

      -- DATA
      MATRIX_FLOAT_DIVIDER_SIZE_I_IN    => size_i_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_SIZE_J_IN    => size_j_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_A_IN    => data_a_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_B_IN    => data_b_in_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_DATA_OUT     => data_out_matrix_float_divider,
      MATRIX_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_matrix_float_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR FLOAT ADDER
      -- CONTROL
      TENSOR_FLOAT_ADDER_START => start_tensor_float_adder,
      TENSOR_FLOAT_ADDER_READY => ready_tensor_float_adder,

      TENSOR_FLOAT_ADDER_OPERATION => operation_tensor_float_adder,

      TENSOR_FLOAT_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_adder,

      TENSOR_FLOAT_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_adder,

      -- DATA
      TENSOR_FLOAT_ADDER_SIZE_I_IN => size_i_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_SIZE_J_IN => size_j_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_SIZE_K_IN => size_k_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_A_IN => data_a_in_tensor_float_adder,
      TENSOR_FLOAT_ADDER_DATA_B_IN => data_b_in_tensor_float_adder,

      TENSOR_FLOAT_ADDER_DATA_OUT     => data_out_tensor_float_adder,
      TENSOR_FLOAT_ADDER_OVERFLOW_OUT => overflow_out_tensor_float_adder,

      -- TENSOR FLOAT MULTIPLIER
      -- CONTROL
      TENSOR_FLOAT_MULTIPLIER_START => start_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_READY => ready_tensor_float_multiplier,

      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_multiplier,

      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_multiplier,

      -- DATA
      TENSOR_FLOAT_MULTIPLIER_SIZE_I_IN => size_i_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_SIZE_J_IN => size_j_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_SIZE_K_IN => size_k_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_A_IN => data_a_in_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_DATA_B_IN => data_b_in_tensor_float_multiplier,

      TENSOR_FLOAT_MULTIPLIER_DATA_OUT     => data_out_tensor_float_multiplier,
      TENSOR_FLOAT_MULTIPLIER_OVERFLOW_OUT => overflow_out_tensor_float_multiplier,

      -- TENSOR FLOAT DIVIDER
      -- CONTROL
      TENSOR_FLOAT_DIVIDER_START => start_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_READY => ready_tensor_float_divider,

      TENSOR_FLOAT_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_divider,

      TENSOR_FLOAT_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_divider,

      -- DATA
      TENSOR_FLOAT_DIVIDER_SIZE_I_IN => size_i_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_SIZE_J_IN => size_j_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_SIZE_K_IN => size_k_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_A_IN => data_a_in_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_DATA_B_IN => data_b_in_tensor_float_divider,

      TENSOR_FLOAT_DIVIDER_DATA_OUT     => data_out_tensor_float_divider,
      TENSOR_FLOAT_DIVIDER_OVERFLOW_OUT => overflow_out_tensor_float_divider
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR FLOAT ADDER
  model_scalar_float_adder_test : if (ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_TEST) generate
    scalar_float_adder : model_scalar_float_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_float_adder,
        READY => ready_scalar_float_adder,

        OPERATION => operation_scalar_float_adder,

        -- DATA
        DATA_A_IN => data_a_in_scalar_float_adder,
        DATA_B_IN => data_b_in_scalar_float_adder,

        DATA_OUT => data_out_scalar_float_adder
        );
  end generate model_scalar_float_adder_test;

  -- SCALAR FLOAT MULTIPLIER
  model_scalar_float_multiplier_test : if (ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST) generate
    scalar_float_multiplier : model_scalar_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_float_multiplier,
        READY => ready_scalar_float_multiplier,

        -- DATA
        DATA_A_IN => data_a_in_scalar_float_multiplier,
        DATA_B_IN => data_b_in_scalar_float_multiplier,

        DATA_OUT     => data_out_scalar_float_multiplier,
        OVERFLOW_OUT => overflow_out_scalar_float_multiplier
        );
  end generate model_scalar_float_multiplier_test;

  -- SCALAR FLOAT DIVIDER
  model_scalar_float_divider_test : if (ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST) generate
    scalar_float_divider : model_scalar_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_float_divider,
        READY => ready_scalar_float_divider,

        -- DATA
        DATA_A_IN => data_a_in_scalar_float_divider,
        DATA_B_IN => data_b_in_scalar_float_divider,

        DATA_OUT     => data_out_scalar_float_divider,
        OVERFLOW_OUT => overflow_out_scalar_float_divider
        );
  end generate model_scalar_float_divider_test;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR FLOAT ADDER
  model_vector_float_adder_test : if (ENABLE_ACCELERATOR_VECTOR_FLOAT_ADDER_TEST) generate
    vector_float_adder : model_vector_float_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_float_adder,
        READY => ready_vector_float_adder,

        OPERATION => operation_vector_float_adder,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

        DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

        -- DATA
        SIZE_IN   => size_in_vector_float_adder,
        DATA_A_IN => data_a_in_vector_float_adder,
        DATA_B_IN => data_b_in_vector_float_adder,

        DATA_OUT     => data_out_vector_float_adder,
        OVERFLOW_OUT => overflow_out_vector_float_adder
        );
  end generate model_vector_float_adder_test;

  -- VECTOR FLOAT MULTIPLIER
  model_vector_float_multiplier_test : if (ENABLE_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST) generate
    vector_float_multiplier : model_vector_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_float_multiplier,
        READY => ready_vector_float_multiplier,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

        DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

        -- DATA
        SIZE_IN   => size_in_vector_float_multiplier,
        DATA_A_IN => data_a_in_vector_float_multiplier,
        DATA_B_IN => data_b_in_vector_float_multiplier,

        DATA_OUT     => data_out_vector_float_multiplier,
        OVERFLOW_OUT => overflow_out_vector_float_multiplier
        );
  end generate model_vector_float_multiplier_test;

  -- VECTOR FLOAT DIVIDER
  model_vector_float_divider_test : if (ENABLE_ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST) generate
    vector_float_divider : model_vector_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_float_divider,
        READY => ready_vector_float_divider,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_float_divider,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_float_divider,

        DATA_OUT_ENABLE => data_out_enable_vector_float_divider,

        -- DATA
        SIZE_IN   => size_in_vector_float_divider,
        DATA_A_IN => data_a_in_vector_float_divider,
        DATA_B_IN => data_b_in_vector_float_divider,

        DATA_OUT     => data_out_vector_float_divider,
        OVERFLOW_OUT => overflow_out_vector_float_divider
        );
  end generate model_vector_float_divider_test;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX FLOAT ADDER
  model_matrix_float_adder_test : if (ENABLE_ACCELERATOR_MATRIX_FLOAT_ADDER_TEST) generate
    matrix_float_adder : model_matrix_float_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_float_adder,
        READY => ready_matrix_float_adder,

        OPERATION => operation_matrix_float_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_adder,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_float_adder,
        SIZE_J_IN => size_j_in_matrix_float_adder,
        DATA_A_IN => data_a_in_matrix_float_adder,
        DATA_B_IN => data_b_in_matrix_float_adder,

        DATA_OUT     => data_out_matrix_float_adder,
        OVERFLOW_OUT => overflow_out_matrix_float_adder
        );
  end generate model_matrix_float_adder_test;

  -- MATRIX FLOAT MULTIPLIER
  model_matrix_float_multiplier_test : if (ENABLE_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST) generate
    matrix_float_multiplier : model_matrix_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_float_multiplier,
        READY => ready_matrix_float_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_float_multiplier,
        SIZE_J_IN => size_j_in_matrix_float_multiplier,
        DATA_A_IN => data_a_in_matrix_float_multiplier,
        DATA_B_IN => data_b_in_matrix_float_multiplier,

        DATA_OUT     => data_out_matrix_float_multiplier,
        OVERFLOW_OUT => overflow_out_matrix_float_multiplier
        );
  end generate model_matrix_float_multiplier_test;

  -- MATRIX FLOAT DIVIDER
  model_matrix_float_divider_test : if (ENABLE_ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST) generate
    matrix_float_divider : model_matrix_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_float_divider,
        READY => ready_matrix_float_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_divider,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_float_divider,
        SIZE_J_IN => size_j_in_matrix_float_divider,
        DATA_A_IN => data_a_in_matrix_float_divider,
        DATA_B_IN => data_b_in_matrix_float_divider,

        DATA_OUT     => data_out_matrix_float_divider,
        OVERFLOW_OUT => overflow_out_matrix_float_divider
        );
  end generate model_matrix_float_divider_test;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR FLOAT ADDER
  model_tensor_float_adder_test : if (ENABLE_ACCELERATOR_TENSOR_FLOAT_ADDER_TEST) generate
    tensor_float_adder : model_tensor_float_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_float_adder,
        READY => ready_tensor_float_adder,

        OPERATION => operation_tensor_float_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_adder,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_adder,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_adder,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_adder,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_float_adder,
        SIZE_J_IN => size_j_in_tensor_float_adder,
        SIZE_K_IN => size_k_in_tensor_float_adder,
        DATA_A_IN => data_a_in_tensor_float_adder,
        DATA_B_IN => data_b_in_tensor_float_adder,

        DATA_OUT     => data_out_tensor_float_adder,
        OVERFLOW_OUT => overflow_out_tensor_float_adder
        );
  end generate model_tensor_float_adder_test;

  -- TENSOR FLOAT MULTIPLIER
  model_tensor_float_multiplier_test : if (ENABLE_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST) generate
    tensor_float_multiplier : model_tensor_float_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_float_multiplier,
        READY => ready_tensor_float_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_multiplier,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_multiplier,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_multiplier,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_float_multiplier,
        SIZE_J_IN => size_j_in_tensor_float_multiplier,
        SIZE_K_IN => size_k_in_tensor_float_multiplier,
        DATA_A_IN => data_a_in_tensor_float_multiplier,
        DATA_B_IN => data_b_in_tensor_float_multiplier,

        DATA_OUT     => data_out_tensor_float_multiplier,
        OVERFLOW_OUT => overflow_out_tensor_float_multiplier
        );
  end generate model_tensor_float_multiplier_test;

  -- TENSOR FLOAT DIVIDER
  model_tensor_float_divider_test : if (ENABLE_ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST) generate
    tensor_float_divider : model_tensor_float_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_float_divider,
        READY => ready_tensor_float_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_float_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_float_divider,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_float_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_float_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_float_divider,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_float_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_float_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_float_divider,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_float_divider,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_float_divider,
        SIZE_J_IN => size_j_in_tensor_float_divider,
        SIZE_K_IN => size_k_in_tensor_float_divider,
        DATA_A_IN => data_a_in_tensor_float_divider,
        DATA_B_IN => data_b_in_tensor_float_divider,

        DATA_OUT     => data_out_tensor_float_divider,
        OVERFLOW_OUT => overflow_out_tensor_float_divider
        );
  end generate model_tensor_float_divider_test;

end model_float_testbench_architecture;
