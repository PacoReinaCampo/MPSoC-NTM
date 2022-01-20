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
use work.ntm_calculus_pkg.all;

entity ntm_calculus_testbench is
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

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_INTEGRATION_TEST        : boolean := false;
    ENABLE_NTM_VECTOR_AVERAGE_TEST : boolean := false;
    ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST   : boolean := false;

    ENABLE_NTM_VECTOR_INTEGRATION_CASE_0        : boolean := false;
    ENABLE_NTM_VECTOR_AVERAGE_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_DIFFERENTIATION_CASE_0   : boolean := false;

    ENABLE_NTM_VECTOR_INTEGRATION_CASE_1        : boolean := false;
    ENABLE_NTM_VECTOR_AVERAGE_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_DIFFERENTIATION_CASE_1   : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_INTEGRATION_TEST     : boolean := false;
    ENABLE_NTM_MATRIX_AVERAGE_TEST : boolean := false;
    ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST   : boolean := false;

    ENABLE_NTM_MATRIX_INTEGRATION_CASE_0     : boolean := false;
    ENABLE_NTM_MATRIX_AVERAGE_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_DIFFERENTIATION_CASE_0   : boolean := false;

    ENABLE_NTM_MATRIX_INTEGRATION_CASE_1     : boolean := false;
    ENABLE_NTM_MATRIX_AVERAGE_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_DIFFERENTIATION_CASE_1   : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_INTEGRATION_TEST     : boolean := false;
    ENABLE_NTM_TENSOR_AVERAGE_TEST : boolean := false;
    ENABLE_NTM_TENSOR_DIFFERENTIATION_TEST   : boolean := false;

    ENABLE_NTM_TENSOR_INTEGRATION_CASE_0     : boolean := false;
    ENABLE_NTM_TENSOR_AVERAGE_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_DIFFERENTIATION_CASE_0   : boolean := false;

    ENABLE_NTM_TENSOR_INTEGRATION_CASE_1     : boolean := false;
    ENABLE_NTM_TENSOR_AVERAGE_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_DIFFERENTIATION_CASE_1   : boolean := false
    );
end ntm_calculus_testbench;

architecture ntm_calculus_testbench_architecture of ntm_calculus_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- DOT INTEGRATION
  -- CONTROL
  signal start_vector_integration : std_logic;
  signal ready_vector_integration : std_logic;

  signal data_a_in_enable_vector_integration : std_logic;
  signal data_b_in_enable_vector_integration : std_logic;

  signal data_out_enable_vector_integration : std_logic;

  -- DATA
  signal length_in_vector_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integration : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integration : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_integration  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR AVERAGE
  -- CONTROL
  signal start_vector_average : std_logic;
  signal ready_vector_average : std_logic;

  signal data_a_in_enable_vector_average : std_logic;
  signal data_b_in_enable_vector_average : std_logic;

  signal data_enable_vector_average : std_logic;

  signal data_out_enable_vector_average : std_logic;

  -- DATA
  signal length_in_vector_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_average : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_average : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_average  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_enable_vector_differentiation : std_logic;

  signal data_enable_vector_differentiation : std_logic;

  signal data_out_enable_vector_differentiation : std_logic;

  -- DATA
  signal length_in_vector_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INTEGRATION
  -- CONTROL
  signal start_matrix_integration : std_logic;
  signal ready_matrix_integration : std_logic;

  signal data_a_in_i_enable_matrix_integration : std_logic;
  signal data_a_in_j_enable_matrix_integration : std_logic;
  signal data_b_in_i_enable_matrix_integration : std_logic;
  signal data_b_in_j_enable_matrix_integration : std_logic;

  signal data_i_enable_matrix_integration : std_logic;
  signal data_j_enable_matrix_integration : std_logic;

  signal data_out_i_enable_matrix_integration : std_logic;
  signal data_out_j_enable_matrix_integration : std_logic;

  -- DATA
  signal size_a_i_in_matrix_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_integration    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX AVERAGE
  -- CONTROL
  signal start_matrix_average : std_logic;
  signal ready_matrix_average : std_logic;

  signal data_a_in_i_enable_matrix_average : std_logic;
  signal data_a_in_j_enable_matrix_average : std_logic;
  signal data_b_in_i_enable_matrix_average : std_logic;
  signal data_b_in_j_enable_matrix_average : std_logic;

  signal data_i_enable_matrix_average : std_logic;
  signal data_j_enable_matrix_average : std_logic;

  signal data_out_i_enable_matrix_average : std_logic;
  signal data_out_j_enable_matrix_average : std_logic;

  -- DATA
  signal size_a_i_in_matrix_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_average   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_average   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_average    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX DIFFERENTIATION
  -- CONTROL
  signal start_matrix_differentiation : std_logic;
  signal ready_matrix_differentiation : std_logic;

  signal data_in_i_enable_matrix_differentiation : std_logic;
  signal data_in_j_enable_matrix_differentiation : std_logic;

  signal data_i_enable_matrix_differentiation : std_logic;
  signal data_j_enable_matrix_differentiation : std_logic;

  signal data_out_i_enable_matrix_differentiation : std_logic;
  signal data_out_j_enable_matrix_differentiation : std_logic;

  -- DATA
  signal size_i_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR INTEGRATION
  -- CONTROL
  signal start_tensor_integration : std_logic;
  signal ready_tensor_integration : std_logic;

  signal data_a_in_i_enable_tensor_integration : std_logic;
  signal data_a_in_j_enable_tensor_integration : std_logic;
  signal data_a_in_k_enable_tensor_integration : std_logic;
  signal data_b_in_i_enable_tensor_integration : std_logic;
  signal data_b_in_j_enable_tensor_integration : std_logic;
  signal data_b_in_k_enable_tensor_integration : std_logic;

  signal data_i_enable_tensor_integration : std_logic;
  signal data_j_enable_tensor_integration : std_logic;
  signal data_k_enable_tensor_integration : std_logic;

  signal data_out_i_enable_tensor_integration : std_logic;
  signal data_out_j_enable_tensor_integration : std_logic;
  signal data_out_k_enable_tensor_integration : std_logic;

  -- DATA
  signal size_a_i_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_k_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_integration    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR AVERAGE
  -- CONTROL
  signal start_tensor_average : std_logic;
  signal ready_tensor_average : std_logic;

  signal data_a_in_i_enable_tensor_average : std_logic;
  signal data_a_in_j_enable_tensor_average : std_logic;
  signal data_a_in_k_enable_tensor_average : std_logic;
  signal data_b_in_i_enable_tensor_average : std_logic;
  signal data_b_in_j_enable_tensor_average : std_logic;
  signal data_b_in_k_enable_tensor_average : std_logic;

  signal data_i_enable_tensor_average : std_logic;
  signal data_j_enable_tensor_average : std_logic;
  signal data_k_enable_tensor_average : std_logic;

  signal data_out_i_enable_tensor_average : std_logic;
  signal data_out_j_enable_tensor_average : std_logic;
  signal data_out_k_enable_tensor_average : std_logic;

  -- DATA
  signal size_a_i_in_tensor_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_k_in_tensor_average : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_average   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_average   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_average    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR DIFFERENTIATION
  -- CONTROL
  signal start_tensor_differentiation : std_logic;
  signal ready_tensor_differentiation : std_logic;

  signal data_in_i_enable_tensor_differentiation : std_logic;
  signal data_in_j_enable_tensor_differentiation : std_logic;
  signal data_in_k_enable_tensor_differentiation : std_logic;

  signal data_i_enable_tensor_differentiation : std_logic;
  signal data_j_enable_tensor_differentiation : std_logic;
  signal data_k_enable_tensor_differentiation : std_logic;

  signal data_out_i_enable_tensor_differentiation : std_logic;
  signal data_out_j_enable_tensor_differentiation : std_logic;
  signal data_out_k_enable_tensor_differentiation : std_logic;

  -- DATA
  signal size_i_in_tensor_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  calculus_stimulus : ntm_calculus_stimulus
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

      -- DOT INTEGRATION
      -- CONTROL
      DOT_INTEGRATION_START => start_vector_integration,
      DOT_INTEGRATION_READY => ready_vector_integration,

      DOT_INTEGRATION_DATA_A_IN_ENABLE => data_a_in_enable_vector_integration,
      DOT_INTEGRATION_DATA_B_IN_ENABLE => data_b_in_enable_vector_integration,

      DOT_INTEGRATION_DATA_OUT_ENABLE => data_out_enable_vector_integration,

      -- DATA
      DOT_INTEGRATION_LENGTH_IN => length_in_vector_integration,
      DOT_INTEGRATION_DATA_A_IN => data_a_in_vector_integration,
      DOT_INTEGRATION_DATA_B_IN => data_b_in_vector_integration,
      DOT_INTEGRATION_DATA_OUT  => data_out_vector_integration,

      -- VECTOR AVERAGE
      -- CONTROL
      VECTOR_AVERAGE_START => start_vector_average,
      VECTOR_AVERAGE_READY => ready_vector_average,

      VECTOR_AVERAGE_DATA_A_IN_ENABLE => data_a_in_enable_vector_average,
      VECTOR_AVERAGE_DATA_B_IN_ENABLE => data_b_in_enable_vector_average,

      VECTOR_AVERAGE_DATA_OUT_ENABLE => data_out_enable_vector_average,

      -- DATA
      VECTOR_AVERAGE_LENGTH_IN => length_in_vector_average,
      VECTOR_AVERAGE_DATA_A_IN => data_a_in_vector_average,
      VECTOR_AVERAGE_DATA_B_IN => data_b_in_vector_average,
      VECTOR_AVERAGE_DATA_OUT  => data_out_vector_average,

      -- VECTOR DIFFERENTIATION
      -- CONTROL
      VECTOR_DIFFERENTIATION_START => start_vector_differentiation,
      VECTOR_DIFFERENTIATION_READY => ready_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_IN_ENABLE => data_in_enable_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_ENABLE => data_enable_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_OUT_ENABLE => data_out_enable_vector_differentiation,

      -- DATA
      VECTOR_DIFFERENTIATION_LENGTH_IN => length_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_IN   => data_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_OUT  => data_out_vector_differentiation,

      -- MATRIX INTEGRATION
      -- CONTROL
      MATRIX_INTEGRATION_START => start_matrix_integration,
      MATRIX_INTEGRATION_READY => ready_matrix_integration,

      MATRIX_INTEGRATION_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integration,

      MATRIX_INTEGRATION_DATA_I_ENABLE => data_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_J_ENABLE => data_j_enable_matrix_integration,

      MATRIX_INTEGRATION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integration,

      -- DATA
      MATRIX_INTEGRATION_SIZE_A_I_IN => size_a_i_in_matrix_integration,
      MATRIX_INTEGRATION_SIZE_A_J_IN => size_a_j_in_matrix_integration,
      MATRIX_INTEGRATION_SIZE_B_I_IN => size_b_i_in_matrix_integration,
      MATRIX_INTEGRATION_SIZE_B_J_IN => size_b_j_in_matrix_integration,
      MATRIX_INTEGRATION_DATA_A_IN   => data_a_in_matrix_integration,
      MATRIX_INTEGRATION_DATA_B_IN   => data_b_in_matrix_integration,
      MATRIX_INTEGRATION_DATA_OUT    => data_out_matrix_integration,

      -- MATRIX AVERAGE
      -- CONTROL
      MATRIX_AVERAGE_START => start_matrix_average,
      MATRIX_AVERAGE_READY => ready_matrix_average,

      MATRIX_AVERAGE_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_average,
      MATRIX_AVERAGE_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_average,
      MATRIX_AVERAGE_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_average,
      MATRIX_AVERAGE_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_average,

      MATRIX_AVERAGE_DATA_I_ENABLE => data_i_enable_matrix_average,
      MATRIX_AVERAGE_DATA_J_ENABLE => data_j_enable_matrix_average,

      MATRIX_AVERAGE_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_average,
      MATRIX_AVERAGE_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_average,

      -- DATA
      MATRIX_AVERAGE_SIZE_A_I_IN => size_a_i_in_matrix_average,
      MATRIX_AVERAGE_SIZE_A_J_IN => size_a_j_in_matrix_average,
      MATRIX_AVERAGE_SIZE_B_I_IN => size_b_i_in_matrix_average,
      MATRIX_AVERAGE_SIZE_B_J_IN => size_b_j_in_matrix_average,
      MATRIX_AVERAGE_DATA_A_IN   => data_a_in_matrix_average,
      MATRIX_AVERAGE_DATA_B_IN   => data_b_in_matrix_average,
      MATRIX_AVERAGE_DATA_OUT    => data_out_matrix_average,

      -- MATRIX DIFFERENTIATION
      -- CONTROL
      MATRIX_DIFFERENTIATION_START => start_matrix_differentiation,
      MATRIX_DIFFERENTIATION_READY => ready_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE => data_in_i_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE => data_in_j_enable_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_I_ENABLE => data_i_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_J_ENABLE => data_j_enable_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_differentiation,

      -- DATA
      MATRIX_DIFFERENTIATION_SIZE_I_IN => size_i_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_SIZE_J_IN => size_j_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN   => data_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT  => data_out_matrix_differentiation,

      -- TENSOR INTEGRATION
      -- CONTROL
      TENSOR_INTEGRATION_START => start_tensor_integration,
      TENSOR_INTEGRATION_READY => ready_tensor_integration,

      TENSOR_INTEGRATION_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integration,

      TENSOR_INTEGRATION_DATA_I_ENABLE => data_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_J_ENABLE => data_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_K_ENABLE => data_k_enable_tensor_integration,

      TENSOR_INTEGRATION_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integration,

      -- DATA
      TENSOR_INTEGRATION_SIZE_A_I_IN => size_a_i_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_A_J_IN => size_a_j_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_A_K_IN => size_a_k_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_B_I_IN => size_b_i_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_B_J_IN => size_b_j_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_B_K_IN => size_b_k_in_tensor_integration,
      TENSOR_INTEGRATION_DATA_A_IN   => data_a_in_tensor_integration,
      TENSOR_INTEGRATION_DATA_B_IN   => data_b_in_tensor_integration,
      TENSOR_INTEGRATION_DATA_OUT    => data_out_tensor_integration,

      -- TENSOR AVERAGE
      -- CONTROL
      TENSOR_AVERAGE_START => start_tensor_average,
      TENSOR_AVERAGE_READY => ready_tensor_average,

      TENSOR_AVERAGE_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_average,
      TENSOR_AVERAGE_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_average,
      TENSOR_AVERAGE_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_average,
      TENSOR_AVERAGE_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_average,
      TENSOR_AVERAGE_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_average,
      TENSOR_AVERAGE_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_average,

      TENSOR_AVERAGE_DATA_I_ENABLE => data_i_enable_tensor_average,
      TENSOR_AVERAGE_DATA_J_ENABLE => data_j_enable_tensor_average,
      TENSOR_AVERAGE_DATA_K_ENABLE => data_k_enable_tensor_average,

      TENSOR_AVERAGE_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_average,
      TENSOR_AVERAGE_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_average,
      TENSOR_AVERAGE_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_average,

      -- DATA
      TENSOR_AVERAGE_SIZE_A_I_IN => size_a_i_in_tensor_average,
      TENSOR_AVERAGE_SIZE_A_J_IN => size_a_j_in_tensor_average,
      TENSOR_AVERAGE_SIZE_A_K_IN => size_a_k_in_tensor_average,
      TENSOR_AVERAGE_SIZE_B_I_IN => size_b_i_in_tensor_average,
      TENSOR_AVERAGE_SIZE_B_J_IN => size_b_j_in_tensor_average,
      TENSOR_AVERAGE_SIZE_B_K_IN => size_b_k_in_tensor_average,
      TENSOR_AVERAGE_DATA_A_IN   => data_a_in_tensor_average,
      TENSOR_AVERAGE_DATA_B_IN   => data_b_in_tensor_average,
      TENSOR_AVERAGE_DATA_OUT    => data_out_tensor_average,

      -- TENSOR DIFFERENTIATION
      -- CONTROL
      TENSOR_DIFFERENTIATION_START => start_tensor_differentiation,
      TENSOR_DIFFERENTIATION_READY => ready_tensor_differentiation,

      TENSOR_DIFFERENTIATION_DATA_IN_I_ENABLE => data_in_i_enable_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_IN_J_ENABLE => data_in_j_enable_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_IN_K_ENABLE => data_in_k_enable_tensor_differentiation,

      TENSOR_DIFFERENTIATION_DATA_I_ENABLE => data_i_enable_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_J_ENABLE => data_j_enable_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_K_ENABLE => data_k_enable_tensor_differentiation,

      TENSOR_DIFFERENTIATION_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_differentiation,

      -- DATA
      TENSOR_DIFFERENTIATION_SIZE_I_IN => size_i_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_SIZE_J_IN => size_j_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_SIZE_K_IN => size_k_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_IN   => data_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_OUT  => data_out_tensor_differentiation
      );

  -- DOT INTEGRATION
  ntm_vector_integration_test : if (ENABLE_NTM_VECTOR_INTEGRATION_TEST) generate
    dot_integration : ntm_vector_integration
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_integration,
        READY => ready_vector_integration,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_integration,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_integration,

        DATA_OUT_ENABLE => data_out_enable_vector_integration,

        -- DATA
        LENGTH_IN => length_in_vector_integration,
        DATA_A_IN => data_a_in_vector_integration,
        DATA_B_IN => data_b_in_vector_integration,
        DATA_OUT  => data_out_vector_integration
        );
  end generate ntm_vector_integration_test;

  -- VECTOR AVERAGE
  ntm_vector_average_test : if (ENABLE_NTM_VECTOR_AVERAGE_TEST) generate
    vector_average : ntm_vector_average
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_average,
        READY => ready_vector_average,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_average,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_average,

        DATA_OUT_ENABLE => data_out_enable_vector_average,

        -- DATA
        LENGTH_IN => length_in_vector_average,
        DATA_A_IN => data_a_in_vector_average,
        DATA_B_IN => data_b_in_vector_average,
        DATA_OUT  => data_out_vector_average
        );
  end generate ntm_vector_average_test;

  -- VECTOR DIFFERENTIATION
  ntm_vector_differentiation_test : if (ENABLE_ntm_vector_differentiation_TEST) generate
    VECTOR_DIFFERENTIATION : ntm_vector_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_differentiation,
        READY => ready_vector_differentiation,

        DATA_IN_ENABLE => data_in_enable_vector_differentiation,

        DATA_ENABLE => data_enable_vector_differentiation,

        DATA_OUT_ENABLE => data_out_enable_vector_differentiation,

        -- DATA
        LENGTH_IN => length_in_vector_differentiation,
        DATA_IN   => data_in_vector_differentiation,
        DATA_OUT  => data_out_vector_differentiation
        );
  end generate ntm_vector_differentiation_test;

  -- MATRIX INTEGRATION
  ntm_matrix_integration_test : if (ENABLE_NTM_MATRIX_INTEGRATION_TEST) generate
    matrix_integration : ntm_matrix_integration
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integration,
        READY => ready_matrix_integration,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integration,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integration,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integration,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integration,

        DATA_I_ENABLE => data_i_enable_matrix_integration,
        DATA_J_ENABLE => data_j_enable_matrix_integration,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integration,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integration,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_matrix_integration,
        SIZE_A_J_IN => size_a_j_in_matrix_integration,
        SIZE_B_I_IN => size_b_i_in_matrix_integration,
        SIZE_B_J_IN => size_b_j_in_matrix_integration,
        DATA_A_IN   => data_a_in_matrix_integration,
        DATA_B_IN   => data_b_in_matrix_integration,
        DATA_OUT    => data_out_matrix_integration
        );
  end generate ntm_matrix_integration_test;

  -- MATRIX AVERAGE
  ntm_matrix_average_test : if (ENABLE_NTM_MATRIX_AVERAGE_TEST) generate
    matrix_average : ntm_matrix_average
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_average,
        READY => ready_matrix_average,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_average,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_average,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_average,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_average,

        DATA_I_ENABLE => data_i_enable_matrix_average,
        DATA_J_ENABLE => data_j_enable_matrix_average,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_average,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_average,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_matrix_average,
        SIZE_A_J_IN => size_a_j_in_matrix_average,
        SIZE_B_I_IN => size_b_i_in_matrix_average,
        SIZE_B_J_IN => size_b_j_in_matrix_average,
        DATA_A_IN   => data_a_in_matrix_average,
        DATA_B_IN   => data_b_in_matrix_average,
        DATA_OUT    => data_out_matrix_average
        );
  end generate ntm_matrix_average_test;

  -- MATRIX DIFFERENTIATION
  ntm_matrix_differentiation_test : if (ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST) generate
    matrix_differentiation : ntm_matrix_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_differentiation,
        READY => ready_matrix_differentiation,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_differentiation,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_differentiation,

        DATA_I_ENABLE => data_i_enable_matrix_differentiation,
        DATA_J_ENABLE => data_j_enable_matrix_differentiation,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_differentiation,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_differentiation,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_differentiation,
        SIZE_J_IN => size_j_in_matrix_differentiation,
        DATA_IN   => data_in_matrix_differentiation,
        DATA_OUT  => data_out_matrix_differentiation
        );
  end generate ntm_matrix_differentiation_test;

  -- TENSOR INTEGRATION
  ntm_tensor_integration_test : if (ENABLE_NTM_TENSOR_INTEGRATION_TEST) generate
    tensor_integration : ntm_tensor_integration
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integration,
        READY => ready_tensor_integration,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integration,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integration,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integration,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integration,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integration,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integration,

        DATA_I_ENABLE => data_i_enable_tensor_integration,
        DATA_J_ENABLE => data_j_enable_tensor_integration,
        DATA_K_ENABLE => data_k_enable_tensor_integration,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integration,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integration,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integration,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_tensor_integration,
        SIZE_A_J_IN => size_a_j_in_tensor_integration,
        SIZE_A_K_IN => size_a_k_in_tensor_integration,
        SIZE_B_I_IN => size_b_i_in_tensor_integration,
        SIZE_B_J_IN => size_b_j_in_tensor_integration,
        SIZE_B_K_IN => size_b_k_in_tensor_integration,
        DATA_A_IN   => data_a_in_tensor_integration,
        DATA_B_IN   => data_b_in_tensor_integration,
        DATA_OUT    => data_out_tensor_integration
        );
  end generate ntm_tensor_integration_test;

  -- TENSOR AVERAGE
  ntm_tensor_average_test : if (ENABLE_NTM_TENSOR_AVERAGE_TEST) generate
    tensor_average : ntm_tensor_average
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_average,
        READY => ready_tensor_average,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_average,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_average,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_average,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_average,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_average,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_average,

        DATA_I_ENABLE => data_i_enable_tensor_average,
        DATA_J_ENABLE => data_j_enable_tensor_average,
        DATA_K_ENABLE => data_k_enable_tensor_average,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_average,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_average,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_average,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_tensor_average,
        SIZE_A_J_IN => size_a_j_in_tensor_average,
        SIZE_A_K_IN => size_a_k_in_tensor_average,
        SIZE_B_I_IN => size_b_i_in_tensor_average,
        SIZE_B_J_IN => size_b_j_in_tensor_average,
        SIZE_B_K_IN => size_b_k_in_tensor_average,
        DATA_A_IN   => data_a_in_tensor_average,
        DATA_B_IN   => data_b_in_tensor_average,
        DATA_OUT    => data_out_tensor_average
        );
  end generate ntm_tensor_average_test;

  -- TENSOR DIFFERENTIATION
  ntm_tensor_differentiation_test : if (ENABLE_NTM_TENSOR_DIFFERENTIATION_TEST) generate
    tensor_differentiation : ntm_tensor_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_differentiation,
        READY => ready_tensor_differentiation,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_differentiation,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_differentiation,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_differentiation,

        DATA_I_ENABLE => data_i_enable_tensor_differentiation,
        DATA_J_ENABLE => data_j_enable_tensor_differentiation,
        DATA_K_ENABLE => data_k_enable_tensor_differentiation,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_differentiation,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_differentiation,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_differentiation,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_differentiation,
        SIZE_J_IN => size_j_in_tensor_differentiation,
        SIZE_K_IN => size_k_in_tensor_differentiation,
        DATA_IN   => data_in_tensor_differentiation,
        DATA_OUT  => data_out_tensor_differentiation
        );
  end generate ntm_tensor_differentiation_test;

end ntm_calculus_testbench_architecture;
