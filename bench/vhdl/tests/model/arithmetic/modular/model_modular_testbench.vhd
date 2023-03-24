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
use work.model_modular_pkg.all;

entity model_modular_testbench is
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
    ENABLE_NTM_SCALAR_MODULAR_MOD_TEST        : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_ADDER_TEST      : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_INVERTER_TEST   : boolean := false;

    ENABLE_NTM_SCALAR_MODULAR_MOD_CASE_0        : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_INVERTER_CASE_0   : boolean := false;

    ENABLE_NTM_SCALAR_MODULAR_MOD_CASE_1        : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_MODULAR_INVERTER_CASE_1   : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_MODULAR_MOD_TEST        : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_ADDER_TEST      : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_INVERTER_TEST   : boolean := false;

    ENABLE_NTM_VECTOR_MODULAR_MOD_CASE_0        : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_INVERTER_CASE_0   : boolean := false;

    ENABLE_NTM_VECTOR_MODULAR_MOD_CASE_1        : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_MODULAR_INVERTER_CASE_1   : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_MODULAR_MOD_TEST        : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_ADDER_TEST      : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_INVERTER_TEST   : boolean := false;

    ENABLE_NTM_MATRIX_MODULAR_MOD_CASE_0        : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_INVERTER_CASE_0   : boolean := false;

    ENABLE_NTM_MATRIX_MODULAR_MOD_CASE_1        : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_MODULAR_INVERTER_CASE_1   : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_MODULAR_MOD_TEST        : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_ADDER_TEST      : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_INVERTER_TEST   : boolean := false;

    ENABLE_NTM_TENSOR_MODULAR_MOD_CASE_0        : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_INVERTER_CASE_0   : boolean := false;

    ENABLE_NTM_TENSOR_MODULAR_MOD_CASE_1        : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_MODULAR_INVERTER_CASE_1   : boolean := false
    );
end model_modular_testbench;

architecture model_modular_testbench_architecture of model_modular_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR MOD
  -- CONTROL
  signal start_scalar_modular_mod : std_logic;
  signal ready_scalar_modular_mod : std_logic;

  -- DATA
  signal modulo_in_scalar_modular_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_modular_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_modular_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_modular_adder : std_logic;
  signal ready_scalar_modular_adder : std_logic;

  signal operation_scalar_modular_adder : std_logic;

  -- DATA
  signal modulo_in_scalar_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_modular_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_modular_multiplier : std_logic;
  signal ready_scalar_modular_multiplier : std_logic;

  -- DATA
  signal modulo_in_scalar_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_modular_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR INVERTER
  -- CONTROL
  signal start_scalar_modular_inverter : std_logic;
  signal ready_scalar_modular_inverter : std_logic;

  -- DATA
  signal modulo_in_scalar_modular_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_modular_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_modular_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR MOD
  -- CONTROL
  signal start_vector_modular_mod : std_logic;
  signal ready_vector_modular_mod : std_logic;

  signal data_in_enable_vector_modular_mod : std_logic;

  signal data_out_enable_vector_modular_mod : std_logic;

  -- DATA
  signal modulo_in_vector_modular_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_modular_mod   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_modular_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_modular_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_modular_adder : std_logic;
  signal ready_vector_modular_adder : std_logic;

  signal operation_vector_modular_adder : std_logic;

  signal data_a_in_enable_vector_modular_adder : std_logic;
  signal data_b_in_enable_vector_modular_adder : std_logic;

  signal data_out_enable_vector_modular_adder : std_logic;

  -- DATA
  signal modulo_in_vector_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_modular_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_modular_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_modular_multiplier : std_logic;
  signal ready_vector_modular_multiplier : std_logic;

  signal data_a_in_enable_vector_modular_multiplier : std_logic;
  signal data_b_in_enable_vector_modular_multiplier : std_logic;

  signal data_out_enable_vector_modular_multiplier : std_logic;

  -- DATA
  signal modulo_in_vector_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_modular_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_modular_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR INVERTER
  -- CONTROL
  signal start_vector_modular_inverter : std_logic;
  signal ready_vector_modular_inverter : std_logic;

  signal data_in_enable_vector_modular_inverter : std_logic;

  signal data_out_enable_vector_modular_inverter : std_logic;

  -- DATA
  signal modulo_in_vector_modular_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_modular_inverter   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_modular_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_modular_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX MOD
  -- CONTROL
  signal start_matrix_modular_mod : std_logic;
  signal ready_matrix_modular_mod : std_logic;

  signal data_in_i_enable_matrix_modular_mod : std_logic;
  signal data_in_j_enable_matrix_modular_mod : std_logic;

  signal data_out_i_enable_matrix_modular_mod : std_logic;
  signal data_out_j_enable_matrix_modular_mod : std_logic;

  -- DATA
  signal modulo_in_matrix_modular_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_modular_mod : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_modular_mod : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_modular_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_modular_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_modular_adder : std_logic;
  signal ready_matrix_modular_adder : std_logic;

  signal operation_matrix_modular_adder : std_logic;

  signal data_a_in_i_enable_matrix_modular_adder : std_logic;
  signal data_a_in_j_enable_matrix_modular_adder : std_logic;
  signal data_b_in_i_enable_matrix_modular_adder : std_logic;
  signal data_b_in_j_enable_matrix_modular_adder : std_logic;

  signal data_out_i_enable_matrix_modular_adder : std_logic;
  signal data_out_j_enable_matrix_modular_adder : std_logic;

  -- DATA
  signal modulo_in_matrix_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_modular_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_modular_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_modular_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_modular_multiplier : std_logic;
  signal ready_matrix_modular_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_modular_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_modular_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_modular_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_modular_multiplier : std_logic;

  signal data_out_i_enable_matrix_modular_multiplier : std_logic;
  signal data_out_j_enable_matrix_modular_multiplier : std_logic;

  -- DATA
  signal modulo_in_matrix_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_modular_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_modular_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_modular_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INVERTER
  -- CONTROL
  signal start_matrix_modular_inverter : std_logic;
  signal ready_matrix_modular_inverter : std_logic;

  signal data_in_i_enable_matrix_modular_inverter : std_logic;
  signal data_in_j_enable_matrix_modular_inverter : std_logic;

  signal data_out_i_enable_matrix_modular_inverter : std_logic;
  signal data_out_j_enable_matrix_modular_inverter : std_logic;

  -- DATA
  signal modulo_in_matrix_modular_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_modular_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_modular_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_modular_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_modular_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR MOD
  -- CONTROL
  signal start_tensor_modular_mod : std_logic;
  signal ready_tensor_modular_mod : std_logic;

  signal data_in_i_enable_tensor_modular_mod : std_logic;
  signal data_in_j_enable_tensor_modular_mod : std_logic;
  signal data_in_k_enable_tensor_modular_mod : std_logic;

  signal data_out_i_enable_tensor_modular_mod : std_logic;
  signal data_out_j_enable_tensor_modular_mod : std_logic;
  signal data_out_k_enable_tensor_modular_mod : std_logic;

  -- DATA
  signal modulo_in_tensor_modular_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_tensor_modular_mod : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_modular_mod : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_modular_mod : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_modular_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_modular_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR ADDER
  -- CONTROL
  signal start_tensor_modular_adder : std_logic;
  signal ready_tensor_modular_adder : std_logic;

  signal operation_tensor_modular_adder : std_logic;

  signal data_a_in_i_enable_tensor_modular_adder : std_logic;
  signal data_a_in_j_enable_tensor_modular_adder : std_logic;
  signal data_a_in_k_enable_tensor_modular_adder : std_logic;
  signal data_b_in_i_enable_tensor_modular_adder : std_logic;
  signal data_b_in_j_enable_tensor_modular_adder : std_logic;
  signal data_b_in_k_enable_tensor_modular_adder : std_logic;

  signal data_out_i_enable_tensor_modular_adder : std_logic;
  signal data_out_j_enable_tensor_modular_adder : std_logic;
  signal data_out_k_enable_tensor_modular_adder : std_logic;

  -- DATA
  signal modulo_in_tensor_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_tensor_modular_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_modular_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_modular_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_modular_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_modular_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR MULTIPLIER
  -- CONTROL
  signal start_tensor_modular_multiplier : std_logic;
  signal ready_tensor_modular_multiplier : std_logic;

  signal data_a_in_i_enable_tensor_modular_multiplier : std_logic;
  signal data_a_in_j_enable_tensor_modular_multiplier : std_logic;
  signal data_a_in_k_enable_tensor_modular_multiplier : std_logic;
  signal data_b_in_i_enable_tensor_modular_multiplier : std_logic;
  signal data_b_in_j_enable_tensor_modular_multiplier : std_logic;
  signal data_b_in_k_enable_tensor_modular_multiplier : std_logic;

  signal data_out_i_enable_tensor_modular_multiplier : std_logic;
  signal data_out_j_enable_tensor_modular_multiplier : std_logic;
  signal data_out_k_enable_tensor_modular_multiplier : std_logic;

  -- DATA
  signal modulo_in_tensor_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_tensor_modular_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_modular_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_modular_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_modular_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_modular_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR INVERTER
  -- CONTROL
  signal start_tensor_modular_inverter : std_logic;
  signal ready_tensor_modular_inverter : std_logic;

  signal data_in_i_enable_tensor_modular_inverter : std_logic;
  signal data_in_j_enable_tensor_modular_inverter : std_logic;
  signal data_in_k_enable_tensor_modular_inverter : std_logic;

  signal data_out_i_enable_tensor_modular_inverter : std_logic;
  signal data_out_j_enable_tensor_modular_inverter : std_logic;
  signal data_out_k_enable_tensor_modular_inverter : std_logic;

  -- DATA
  signal modulo_in_tensor_modular_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_tensor_modular_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_modular_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_modular_inverter : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_modular_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_modular_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  modular_stimulus : model_modular_stimulus
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

      -- SCALAR MOD
      -- CONTROL
      SCALAR_MODULAR_MOD_START => start_scalar_modular_mod,
      SCALAR_MODULAR_MOD_READY => ready_scalar_modular_mod,

      -- DATA
      SCALAR_MODULAR_MOD_MODULO_IN => modulo_in_scalar_modular_mod,
      SCALAR_MODULAR_MOD_DATA_IN   => data_in_scalar_modular_mod,
      SCALAR_MODULAR_MOD_DATA_OUT  => data_out_scalar_modular_mod,

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_MODULAR_ADDER_START => start_scalar_modular_adder,
      SCALAR_MODULAR_ADDER_READY => ready_scalar_modular_adder,

      SCALAR_MODULAR_ADDER_OPERATION => operation_scalar_modular_adder,

      -- DATA
      SCALAR_MODULAR_ADDER_MODULO_IN => modulo_in_scalar_modular_adder,
      SCALAR_MODULAR_ADDER_DATA_A_IN => data_a_in_scalar_modular_adder,
      SCALAR_MODULAR_ADDER_DATA_B_IN => data_b_in_scalar_modular_adder,
      SCALAR_MODULAR_ADDER_DATA_OUT  => data_out_scalar_modular_adder,

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_MODULAR_MULTIPLIER_START => start_scalar_modular_multiplier,
      SCALAR_MODULAR_MULTIPLIER_READY => ready_scalar_modular_multiplier,

      -- DATA
      SCALAR_MODULAR_MULTIPLIER_MODULO_IN => modulo_in_scalar_modular_multiplier,
      SCALAR_MODULAR_MULTIPLIER_DATA_A_IN => data_a_in_scalar_modular_multiplier,
      SCALAR_MODULAR_MULTIPLIER_DATA_B_IN => data_b_in_scalar_modular_multiplier,
      SCALAR_MODULAR_MULTIPLIER_DATA_OUT  => data_out_scalar_modular_multiplier,

      -- SCALAR INVERTER
      -- CONTROL
      SCALAR_MODULAR_INVERTER_START => start_scalar_modular_inverter,
      SCALAR_MODULAR_INVERTER_READY => ready_scalar_modular_inverter,

      -- DATA
      SCALAR_MODULAR_INVERTER_MODULO_IN => modulo_in_scalar_modular_inverter,
      SCALAR_MODULAR_INVERTER_DATA_IN   => data_in_scalar_modular_inverter,
      SCALAR_MODULAR_INVERTER_DATA_OUT  => data_out_scalar_modular_inverter,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR
      ------------------------------------------------------------------------------

      -- VECTOR MOD
      -- CONTROL
      VECTOR_MODULAR_MOD_START => start_vector_modular_mod,
      VECTOR_MODULAR_MOD_READY => ready_vector_modular_mod,

      VECTOR_MODULAR_MOD_DATA_IN_ENABLE => data_in_enable_vector_modular_mod,

      VECTOR_MODULAR_MOD_DATA_OUT_ENABLE => data_out_enable_vector_modular_mod,

      -- DATA
      VECTOR_MODULAR_MOD_MODULO_IN => modulo_in_vector_modular_mod,
      VECTOR_MODULAR_MOD_SIZE_IN   => size_in_vector_modular_mod,
      VECTOR_MODULAR_MOD_DATA_IN   => data_in_vector_modular_mod,
      VECTOR_MODULAR_MOD_DATA_OUT  => data_out_vector_modular_mod,

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_MODULAR_ADDER_START => start_vector_modular_adder,
      VECTOR_MODULAR_ADDER_READY => ready_vector_modular_adder,

      VECTOR_MODULAR_ADDER_OPERATION => operation_vector_modular_adder,

      VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_modular_adder,
      VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_modular_adder,

      VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_modular_adder,

      -- DATA
      VECTOR_MODULAR_ADDER_MODULO_IN => modulo_in_vector_modular_adder,
      VECTOR_MODULAR_ADDER_SIZE_IN   => size_in_vector_modular_adder,
      VECTOR_MODULAR_ADDER_DATA_A_IN => data_a_in_vector_modular_adder,
      VECTOR_MODULAR_ADDER_DATA_B_IN => data_b_in_vector_modular_adder,
      VECTOR_MODULAR_ADDER_DATA_OUT  => data_out_vector_modular_adder,

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_MODULAR_MULTIPLIER_START => start_vector_modular_multiplier,
      VECTOR_MODULAR_MULTIPLIER_READY => ready_vector_modular_multiplier,

      VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_modular_multiplier,
      VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_modular_multiplier,

      VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_modular_multiplier,

      -- DATA
      VECTOR_MODULAR_MULTIPLIER_MODULO_IN => modulo_in_vector_modular_multiplier,
      VECTOR_MODULAR_MULTIPLIER_SIZE_IN   => size_in_vector_modular_multiplier,
      VECTOR_MODULAR_MULTIPLIER_DATA_A_IN => data_a_in_vector_modular_multiplier,
      VECTOR_MODULAR_MULTIPLIER_DATA_B_IN => data_b_in_vector_modular_multiplier,
      VECTOR_MODULAR_MULTIPLIER_DATA_OUT  => data_out_vector_modular_multiplier,

      -- VECTOR INVERTER
      -- CONTROL
      VECTOR_MODULAR_INVERTER_START => start_vector_modular_inverter,
      VECTOR_MODULAR_INVERTER_READY => ready_vector_modular_inverter,

      VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE => data_in_enable_vector_modular_inverter,

      VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE => data_out_enable_vector_modular_inverter,

      -- DATA
      VECTOR_MODULAR_INVERTER_MODULO_IN => modulo_in_vector_modular_inverter,
      VECTOR_MODULAR_INVERTER_SIZE_IN   => size_in_vector_modular_inverter,
      VECTOR_MODULAR_INVERTER_DATA_IN   => data_in_vector_modular_inverter,
      VECTOR_MODULAR_INVERTER_DATA_OUT  => data_out_vector_modular_inverter,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX
      ------------------------------------------------------------------------------

      -- MATRIX MOD
      -- CONTROL
      MATRIX_MODULAR_MOD_START => start_matrix_modular_mod,
      MATRIX_MODULAR_MOD_READY => ready_matrix_modular_mod,

      MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE => data_in_i_enable_matrix_modular_mod,
      MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE => data_in_j_enable_matrix_modular_mod,

      MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_mod,
      MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_mod,

      -- DATA
      MATRIX_MODULAR_MOD_MODULO_IN => modulo_in_matrix_modular_mod,
      MATRIX_MODULAR_MOD_SIZE_I_IN => size_i_in_matrix_modular_mod,
      MATRIX_MODULAR_MOD_SIZE_J_IN => size_j_in_matrix_modular_mod,
      MATRIX_MODULAR_MOD_DATA_IN   => data_in_matrix_modular_mod,
      MATRIX_MODULAR_MOD_DATA_OUT  => data_out_matrix_modular_mod,

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_MODULAR_ADDER_START => start_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_READY => ready_matrix_modular_adder,

      MATRIX_MODULAR_ADDER_OPERATION => operation_matrix_modular_adder,

      MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_modular_adder,

      MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_adder,

      -- DATA
      MATRIX_MODULAR_ADDER_MODULO_IN => modulo_in_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_SIZE_I_IN => size_i_in_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_SIZE_J_IN => size_j_in_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_A_IN => data_a_in_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_B_IN => data_b_in_matrix_modular_adder,
      MATRIX_MODULAR_ADDER_DATA_OUT  => data_out_matrix_modular_adder,

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_MODULAR_MULTIPLIER_START => start_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_READY => ready_matrix_modular_multiplier,

      MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_modular_multiplier,

      MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_multiplier,

      -- DATA
      MATRIX_MODULAR_MULTIPLIER_MODULO_IN => modulo_in_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN => size_i_in_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN => size_j_in_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_A_IN => data_a_in_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_B_IN => data_b_in_matrix_modular_multiplier,
      MATRIX_MODULAR_MULTIPLIER_DATA_OUT  => data_out_matrix_modular_multiplier,

      -- MATRIX INVERTER
      -- CONTROL
      MATRIX_MODULAR_INVERTER_START => start_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_READY => ready_matrix_modular_inverter,

      MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE => data_in_i_enable_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE => data_in_j_enable_matrix_modular_inverter,

      MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_inverter,

      -- DATA
      MATRIX_MODULAR_INVERTER_MODULO_IN => modulo_in_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_SIZE_I_IN => size_i_in_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_SIZE_J_IN => size_j_in_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_DATA_IN   => data_in_matrix_modular_inverter,
      MATRIX_MODULAR_INVERTER_DATA_OUT  => data_out_matrix_modular_inverter,

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR MOD
      -- CONTROL
      TENSOR_MODULAR_MOD_START => start_tensor_modular_mod,
      TENSOR_MODULAR_MOD_READY => ready_tensor_modular_mod,

      TENSOR_MODULAR_MOD_DATA_IN_I_ENABLE => data_in_i_enable_tensor_modular_mod,
      TENSOR_MODULAR_MOD_DATA_IN_J_ENABLE => data_in_j_enable_tensor_modular_mod,
      TENSOR_MODULAR_MOD_DATA_IN_K_ENABLE => data_in_k_enable_tensor_modular_mod,

      TENSOR_MODULAR_MOD_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_mod,
      TENSOR_MODULAR_MOD_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_mod,
      TENSOR_MODULAR_MOD_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_mod,

      -- DATA
      TENSOR_MODULAR_MOD_MODULO_IN => modulo_in_tensor_modular_mod,
      TENSOR_MODULAR_MOD_SIZE_I_IN => size_i_in_tensor_modular_mod,
      TENSOR_MODULAR_MOD_SIZE_J_IN => size_j_in_tensor_modular_mod,
      TENSOR_MODULAR_MOD_SIZE_K_IN => size_k_in_tensor_modular_mod,
      TENSOR_MODULAR_MOD_DATA_IN   => data_in_tensor_modular_mod,
      TENSOR_MODULAR_MOD_DATA_OUT  => data_out_tensor_modular_mod,

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_MODULAR_ADDER_START => start_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_READY => ready_tensor_modular_adder,

      TENSOR_MODULAR_ADDER_OPERATION => operation_tensor_modular_adder,

      TENSOR_MODULAR_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_modular_adder,

      TENSOR_MODULAR_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_adder,

      -- DATA
      TENSOR_MODULAR_ADDER_MODULO_IN => modulo_in_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_SIZE_I_IN => size_i_in_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_SIZE_J_IN => size_j_in_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_SIZE_K_IN => size_k_in_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_A_IN => data_a_in_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_B_IN => data_b_in_tensor_modular_adder,
      TENSOR_MODULAR_ADDER_DATA_OUT  => data_out_tensor_modular_adder,

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_MODULAR_MULTIPLIER_START => start_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_READY => ready_tensor_modular_multiplier,

      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_modular_multiplier,

      TENSOR_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_multiplier,

      -- DATA
      TENSOR_MODULAR_MULTIPLIER_MODULO_IN => modulo_in_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_SIZE_I_IN => size_i_in_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_SIZE_J_IN => size_j_in_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_SIZE_K_IN => size_k_in_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_A_IN => data_a_in_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_B_IN => data_b_in_tensor_modular_multiplier,
      TENSOR_MODULAR_MULTIPLIER_DATA_OUT  => data_out_tensor_modular_multiplier,

      -- TENSOR INVERTER
      -- CONTROL
      TENSOR_MODULAR_INVERTER_START => start_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_READY => ready_tensor_modular_inverter,

      TENSOR_MODULAR_INVERTER_DATA_IN_I_ENABLE => data_in_i_enable_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_DATA_IN_J_ENABLE => data_in_j_enable_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_DATA_IN_K_ENABLE => data_in_k_enable_tensor_modular_inverter,

      TENSOR_MODULAR_INVERTER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_inverter,

      -- DATA
      TENSOR_MODULAR_INVERTER_MODULO_IN => modulo_in_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_SIZE_I_IN => size_i_in_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_SIZE_J_IN => size_j_in_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_SIZE_K_IN => size_k_in_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_DATA_IN   => data_in_tensor_modular_inverter,
      TENSOR_MODULAR_INVERTER_DATA_OUT  => data_out_tensor_modular_inverter
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR MOD
  model_scalar_modular_mod_test : if (ENABLE_NTM_SCALAR_MODULAR_MOD_TEST) generate
    scalar_modular_mod : model_scalar_modular_mod
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_modular_mod,
        READY => ready_scalar_modular_mod,

        -- DATA
        MODULO_IN => modulo_in_scalar_modular_mod,
        DATA_IN   => data_in_scalar_modular_mod,
        DATA_OUT  => data_out_scalar_modular_mod
        );
  end generate model_scalar_modular_mod_test;

  -- SCALAR ADDER
  model_scalar_modular_adder_test : if (ENABLE_NTM_SCALAR_MODULAR_ADDER_TEST) generate
    scalar_modular_adder : model_scalar_modular_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_modular_adder,
        READY => ready_scalar_modular_adder,

        OPERATION => operation_scalar_modular_adder,

        -- DATA
        MODULO_IN => modulo_in_scalar_modular_adder,
        DATA_A_IN => data_a_in_scalar_modular_adder,
        DATA_B_IN => data_b_in_scalar_modular_adder,
        DATA_OUT  => data_out_scalar_modular_adder
        );
  end generate model_scalar_modular_adder_test;

  -- SCALAR MULTIPLIER
  model_scalar_modular_multiplier_test : if (ENABLE_NTM_SCALAR_MODULAR_MULTIPLIER_TEST) generate
    scalar_modular_multiplier : model_scalar_modular_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_modular_multiplier,
        READY => ready_scalar_modular_adder,

        -- DATA
        MODULO_IN => modulo_in_scalar_modular_multiplier,
        DATA_A_IN => data_a_in_scalar_modular_multiplier,
        DATA_B_IN => data_b_in_scalar_modular_multiplier,
        DATA_OUT  => data_out_scalar_modular_multiplier
        );
  end generate model_scalar_modular_multiplier_test;

  -- SCALAR INVERTER
  model_scalar_modular_inverter_test : if (ENABLE_NTM_SCALAR_MODULAR_INVERTER_TEST) generate
    scalar_modular_inverter : model_scalar_modular_inverter
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_modular_inverter,
        READY => ready_scalar_modular_inverter,

        -- DATA
        MODULO_IN => modulo_in_scalar_modular_inverter,
        DATA_IN   => data_in_scalar_modular_inverter,
        DATA_OUT  => data_out_scalar_modular_inverter
        );
  end generate model_scalar_modular_inverter_test;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR MOD
  model_vector_modular_mod_test : if (ENABLE_NTM_VECTOR_MODULAR_MOD_TEST) generate
    vector_modular_mod : model_vector_modular_mod
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_modular_mod,
        READY => ready_vector_modular_mod,

        DATA_IN_ENABLE => data_in_enable_vector_modular_mod,

        DATA_OUT_ENABLE => data_out_enable_vector_modular_mod,

        -- DATA
        MODULO_IN => modulo_in_vector_modular_mod,
        SIZE_IN   => size_in_vector_modular_mod,
        DATA_IN   => data_in_vector_modular_mod,
        DATA_OUT  => data_out_vector_modular_mod
        );
  end generate model_vector_modular_mod_test;

  -- VECTOR ADDER
  model_vector_modular_adder_test : if (ENABLE_NTM_VECTOR_MODULAR_ADDER_TEST) generate
    vector_modular_adder : model_vector_modular_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_modular_adder,
        READY => ready_vector_modular_adder,

        OPERATION => operation_vector_modular_adder,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_modular_adder,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_modular_adder,

        DATA_OUT_ENABLE => data_out_enable_vector_modular_adder,

        -- DATA
        MODULO_IN => modulo_in_vector_modular_adder,
        SIZE_IN   => size_in_vector_modular_adder,
        DATA_A_IN => data_a_in_vector_modular_adder,
        DATA_B_IN => data_b_in_vector_modular_adder,
        DATA_OUT  => data_out_vector_modular_adder
        );
  end generate model_vector_modular_adder_test;

  -- VECTOR MULTIPLIER
  model_vector_modular_multiplier_test : if (ENABLE_NTM_VECTOR_MODULAR_MULTIPLIER_TEST) generate
    vector_modular_multiplier : model_vector_modular_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_modular_multiplier,
        READY => ready_vector_modular_multiplier,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_modular_multiplier,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_modular_multiplier,

        DATA_OUT_ENABLE => data_out_enable_vector_modular_multiplier,

        -- DATA
        MODULO_IN => modulo_in_vector_modular_multiplier,
        SIZE_IN   => size_in_vector_modular_multiplier,
        DATA_A_IN => data_a_in_vector_modular_multiplier,
        DATA_B_IN => data_b_in_vector_modular_multiplier,
        DATA_OUT  => data_out_vector_modular_multiplier
        );
  end generate model_vector_modular_multiplier_test;

  -- VECTOR INVERTER
  model_vector_modular_inverter_test : if (ENABLE_NTM_VECTOR_MODULAR_INVERTER_TEST) generate
    vector_modular_inverter : model_vector_modular_inverter
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_modular_inverter,
        READY => ready_vector_modular_inverter,

        DATA_IN_ENABLE => data_in_enable_vector_modular_inverter,

        DATA_OUT_ENABLE => data_out_enable_vector_modular_inverter,

        -- DATA
        MODULO_IN => modulo_in_vector_modular_inverter,
        SIZE_IN   => size_in_vector_modular_inverter,
        DATA_IN   => data_in_vector_modular_inverter,
        DATA_OUT  => data_out_vector_modular_inverter
        );
  end generate model_vector_modular_inverter_test;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX MOD
  model_matrix_modular_mod_test : if (ENABLE_NTM_MATRIX_MODULAR_MOD_TEST) generate
    matrix_modular_mod : model_matrix_modular_mod
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_modular_mod,
        READY => ready_matrix_modular_mod,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_modular_mod,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_modular_mod,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_mod,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_mod,

        -- DATA
        MODULO_IN => modulo_in_matrix_modular_mod,
        SIZE_I_IN => size_i_in_matrix_modular_mod,
        SIZE_J_IN => size_j_in_matrix_modular_mod,
        DATA_IN   => data_in_matrix_modular_mod,
        DATA_OUT  => data_out_matrix_modular_mod
        );
  end generate model_matrix_modular_mod_test;

  -- MATRIX ADDER
  model_matrix_modular_adder_test : if (ENABLE_NTM_MATRIX_MODULAR_ADDER_TEST) generate
    matrix_modular_adder : model_matrix_modular_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_modular_adder,
        READY => ready_matrix_modular_adder,

        OPERATION => operation_matrix_modular_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_modular_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_modular_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_modular_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_modular_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_adder,

        -- DATA
        MODULO_IN => modulo_in_matrix_modular_adder,
        SIZE_I_IN => size_i_in_matrix_modular_adder,
        SIZE_J_IN => size_j_in_matrix_modular_adder,
        DATA_A_IN => data_a_in_matrix_modular_adder,
        DATA_B_IN => data_b_in_matrix_modular_adder,
        DATA_OUT  => data_out_matrix_modular_adder
        );
  end generate model_matrix_modular_adder_test;

  -- MATRIX MULTIPLIER
  model_matrix_modular_multiplier_test : if (ENABLE_NTM_MATRIX_MODULAR_MULTIPLIER_TEST) generate
    matrix_modular_multiplier : model_matrix_modular_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_modular_multiplier,
        READY => ready_matrix_modular_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_modular_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_modular_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_modular_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_modular_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_multiplier,

        -- DATA
        MODULO_IN => modulo_in_matrix_modular_multiplier,
        SIZE_I_IN => size_i_in_matrix_modular_multiplier,
        SIZE_J_IN => size_j_in_matrix_modular_multiplier,
        DATA_A_IN => data_a_in_matrix_modular_multiplier,
        DATA_B_IN => data_b_in_matrix_modular_multiplier,
        DATA_OUT  => data_out_matrix_modular_multiplier
        );
  end generate model_matrix_modular_multiplier_test;

  -- MATRIX INVERTER
  model_matrix_modular_inverter_test : if (ENABLE_NTM_MATRIX_MODULAR_INVERTER_TEST) generate
    matrix_modular_inverter : model_matrix_modular_inverter
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_modular_inverter,
        READY => ready_matrix_modular_inverter,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_modular_inverter,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_modular_inverter,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_modular_inverter,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_modular_inverter,

        -- DATA
        MODULO_IN => modulo_in_matrix_modular_inverter,
        SIZE_I_IN => size_i_in_matrix_modular_inverter,
        SIZE_J_IN => size_j_in_matrix_modular_inverter,
        DATA_IN   => data_in_matrix_modular_inverter,
        DATA_OUT  => data_out_matrix_modular_inverter
        );
  end generate model_matrix_modular_inverter_test;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR MOD
  model_tensor_modular_mod_test : if (ENABLE_NTM_TENSOR_MODULAR_MOD_TEST) generate
    tensor_modular_mod : model_tensor_modular_mod
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_modular_mod,
        READY => ready_tensor_modular_mod,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_modular_mod,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_modular_mod,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_modular_mod,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_mod,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_mod,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_mod,

        -- DATA
        MODULO_IN => modulo_in_tensor_modular_mod,
        SIZE_I_IN => size_i_in_tensor_modular_mod,
        SIZE_J_IN => size_j_in_tensor_modular_mod,
        SIZE_K_IN => size_k_in_tensor_modular_mod,
        DATA_IN   => data_in_tensor_modular_mod,
        DATA_OUT  => data_out_tensor_modular_mod
        );
  end generate model_tensor_modular_mod_test;

  -- TENSOR ADDER
  model_tensor_modular_adder_test : if (ENABLE_NTM_TENSOR_MODULAR_ADDER_TEST) generate
    tensor_modular_adder : model_tensor_modular_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_modular_adder,
        READY => ready_tensor_modular_adder,

        OPERATION => operation_tensor_modular_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_modular_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_modular_adder,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_modular_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_modular_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_modular_adder,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_modular_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_adder,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_adder,

        -- DATA
        MODULO_IN => modulo_in_tensor_modular_adder,
        SIZE_I_IN => size_i_in_tensor_modular_adder,
        SIZE_J_IN => size_j_in_tensor_modular_adder,
        SIZE_K_IN => size_k_in_tensor_modular_adder,
        DATA_A_IN => data_a_in_tensor_modular_adder,
        DATA_B_IN => data_b_in_tensor_modular_adder,
        DATA_OUT  => data_out_tensor_modular_adder
        );
  end generate model_tensor_modular_adder_test;

  -- TENSOR MULTIPLIER
  model_tensor_modular_multiplier_test : if (ENABLE_NTM_TENSOR_MODULAR_MULTIPLIER_TEST) generate
    tensor_modular_multiplier : model_tensor_modular_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_modular_multiplier,
        READY => ready_tensor_modular_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_modular_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_modular_multiplier,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_modular_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_modular_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_modular_multiplier,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_modular_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_multiplier,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_multiplier,

        -- DATA
        MODULO_IN => modulo_in_tensor_modular_multiplier,
        SIZE_I_IN => size_i_in_tensor_modular_multiplier,
        SIZE_J_IN => size_j_in_tensor_modular_multiplier,
        SIZE_K_IN => size_k_in_tensor_modular_multiplier,
        DATA_A_IN => data_a_in_tensor_modular_multiplier,
        DATA_B_IN => data_b_in_tensor_modular_multiplier,
        DATA_OUT  => data_out_tensor_modular_multiplier
        );
  end generate model_tensor_modular_multiplier_test;

  -- TENSOR INVERTER
  model_tensor_modular_inverter_test : if (ENABLE_NTM_TENSOR_MODULAR_INVERTER_TEST) generate
    tensor_modular_inverter : model_tensor_modular_inverter
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_modular_inverter,
        READY => ready_tensor_modular_inverter,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_modular_inverter,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_modular_inverter,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_modular_inverter,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_modular_inverter,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_modular_inverter,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_modular_inverter,

        -- DATA
        MODULO_IN => modulo_in_tensor_modular_inverter,
        SIZE_I_IN => size_i_in_tensor_modular_inverter,
        SIZE_J_IN => size_j_in_tensor_modular_inverter,
        SIZE_K_IN => size_k_in_tensor_modular_inverter,
        DATA_IN   => data_in_tensor_modular_inverter,
        DATA_OUT  => data_out_tensor_modular_inverter
        );
  end generate model_tensor_modular_inverter_test;

end model_modular_testbench_architecture;
