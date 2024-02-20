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

use work.accelerator_math_vhdl_pkg.all;
use work.accelerator_calculus_pkg.all;

entity accelerator_calculus_testbench is
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

    -- VECTOR-FUNCTIONALITY
    ENABLE_ACCELERATOR_VECTOR_DIFFERENTIATION_TEST : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_INTEGRATION_TEST     : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_SOFTMAX_TEST         : boolean := false;

    ENABLE_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_INTEGRATION_CASE_0     : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_SOFTMAX_CASE_0         : boolean := false;

    ENABLE_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_INTEGRATION_CASE_1     : boolean := false;
    ENABLE_ACCELERATOR_VECTOR_SOFTMAX_CASE_1         : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_ACCELERATOR_MATRIX_DIFFERENTIATION_TEST : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_INTEGRATION_TEST     : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_SOFTMAX_TEST         : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_INTEGRATION_CASE_0     : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_SOFTMAX_CASE_0         : boolean := false;

    ENABLE_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_INTEGRATION_CASE_1     : boolean := false;
    ENABLE_ACCELERATOR_MATRIX_SOFTMAX_CASE_1         : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_ACCELERATOR_TENSOR_DIFFERENTIATION_TEST : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_INTEGRATION_TEST     : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_SOFTMAX_TEST         : boolean := false;

    ENABLE_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_0 : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_INTEGRATION_CASE_0     : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_SOFTMAX_CASE_0         : boolean := false;

    ENABLE_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_1 : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_INTEGRATION_CASE_1     : boolean := false;
    ENABLE_ACCELERATOR_TENSOR_SOFTMAX_CASE_1         : boolean := false
    );
end accelerator_calculus_testbench;

architecture accelerator_calculus_testbench_architecture of accelerator_calculus_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_enable_vector_differentiation : std_logic;

  signal data_enable_vector_differentiation : std_logic;

  signal data_out_enable_vector_differentiation : std_logic;

  -- DATA
  signal size_in_vector_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR INTEGRATION
  -- CONTROL
  signal start_vector_integration : std_logic;
  signal ready_vector_integration : std_logic;

  signal data_in_enable_vector_integration : std_logic;

  signal data_enable_vector_integration : std_logic;

  signal data_out_enable_vector_integration : std_logic;

  -- DATA
  signal size_in_vector_integration   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_vector_integration : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_integration  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SOFTMAX
  -- CONTROL
  signal start_vector_softmax : std_logic;
  signal ready_vector_softmax : std_logic;

  signal data_in_enable_vector_softmax : std_logic;

  signal data_enable_vector_softmax : std_logic;

  signal data_out_enable_vector_softmax : std_logic;

  -- DATA
  signal size_in_vector_softmax  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_softmax : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX DIFFERENTIATION
  -- CONTROL
  signal start_matrix_differentiation : std_logic;
  signal ready_matrix_differentiation : std_logic;

  signal control_matrix_differentiation : std_logic;

  signal data_in_i_enable_matrix_differentiation : std_logic;
  signal data_in_j_enable_matrix_differentiation : std_logic;

  signal data_i_enable_matrix_differentiation : std_logic;
  signal data_j_enable_matrix_differentiation : std_logic;

  signal data_out_i_enable_matrix_differentiation : std_logic;
  signal data_out_j_enable_matrix_differentiation : std_logic;

  -- DATA
  signal size_i_in_matrix_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_i_in_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_j_in_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_differentiation     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_differentiation    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INTEGRATION
  -- CONTROL
  signal start_matrix_integration : std_logic;
  signal ready_matrix_integration : std_logic;

  signal data_in_i_enable_matrix_integration : std_logic;
  signal data_in_j_enable_matrix_integration : std_logic;

  signal data_i_enable_matrix_integration : std_logic;
  signal data_j_enable_matrix_integration : std_logic;

  signal data_out_i_enable_matrix_integration : std_logic;
  signal data_out_j_enable_matrix_integration : std_logic;

  -- DATA
  signal size_i_in_matrix_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_matrix_integration : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_integration  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX SOFTMAX
  -- CONTROL
  signal start_matrix_softmax : std_logic;
  signal ready_matrix_softmax : std_logic;

  signal data_in_i_enable_matrix_softmax : std_logic;
  signal data_in_j_enable_matrix_softmax : std_logic;

  signal data_i_enable_matrix_softmax : std_logic;
  signal data_j_enable_matrix_softmax : std_logic;

  signal data_out_i_enable_matrix_softmax : std_logic;
  signal data_out_j_enable_matrix_softmax : std_logic;

  -- DATA
  signal size_i_in_matrix_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR DIFFERENTIATION
  -- CONTROL
  signal start_tensor_differentiation : std_logic;
  signal ready_tensor_differentiation : std_logic;

  signal control_tensor_differentiation : std_logic_vector(1 downto 0)
;

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
  signal size_i_in_tensor_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_i_in_tensor_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_j_in_tensor_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_k_in_tensor_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_tensor_differentiation     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_differentiation    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR INTEGRATION
  -- CONTROL
  signal start_tensor_integration : std_logic;
  signal ready_tensor_integration : std_logic;

  signal data_in_i_enable_tensor_integration : std_logic;
  signal data_in_j_enable_tensor_integration : std_logic;
  signal data_in_k_enable_tensor_integration : std_logic;

  signal data_i_enable_tensor_integration : std_logic;
  signal data_j_enable_tensor_integration : std_logic;
  signal data_k_enable_tensor_integration : std_logic;

  signal data_out_i_enable_tensor_integration : std_logic;
  signal data_out_j_enable_tensor_integration : std_logic;
  signal data_out_k_enable_tensor_integration : std_logic;

  -- DATA
  signal size_i_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integration : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal length_in_tensor_integration : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_tensor_integration   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_integration  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR SOFTMAX
  -- CONTROL
  signal start_tensor_softmax : std_logic;
  signal ready_tensor_softmax : std_logic;

  signal data_in_i_enable_tensor_softmax : std_logic;
  signal data_in_j_enable_tensor_softmax : std_logic;
  signal data_in_k_enable_tensor_softmax : std_logic;

  signal data_i_enable_tensor_softmax : std_logic;
  signal data_j_enable_tensor_softmax : std_logic;
  signal data_k_enable_tensor_softmax : std_logic;

  signal data_out_i_enable_tensor_softmax : std_logic;
  signal data_out_j_enable_tensor_softmax : std_logic;
  signal data_out_k_enable_tensor_softmax : std_logic;

  -- DATA
  signal size_i_in_tensor_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_softmax : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_softmax   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_softmax  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  calculus_stimulus : accelerator_calculus_stimulus
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

      -- VECTOR DIFFERENTIATION
      -- CONTROL
      VECTOR_DIFFERENTIATION_START => start_vector_differentiation,
      VECTOR_DIFFERENTIATION_READY => ready_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_IN_ENABLE => data_in_enable_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_ENABLE => data_enable_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_OUT_ENABLE => data_out_enable_vector_differentiation,

      -- DATA
      VECTOR_DIFFERENTIATION_SIZE_IN   => size_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_LENGTH_IN => length_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_IN   => data_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_OUT  => data_out_vector_differentiation,

      -- VECTOR INTEGRATION
      -- CONTROL
      VECTOR_INTEGRATION_START => start_vector_integration,
      VECTOR_INTEGRATION_READY => ready_vector_integration,

      VECTOR_INTEGRATION_DATA_IN_ENABLE => data_in_enable_vector_integration,

      VECTOR_INTEGRATION_DATA_ENABLE => data_enable_vector_integration,

      VECTOR_INTEGRATION_DATA_OUT_ENABLE => data_out_enable_vector_integration,

      -- DATA
      VECTOR_INTEGRATION_SIZE_IN   => size_in_vector_integration,
      VECTOR_INTEGRATION_LENGTH_IN => length_in_vector_integration,
      VECTOR_INTEGRATION_DATA_IN   => data_in_vector_integration,
      VECTOR_INTEGRATION_DATA_OUT  => data_out_vector_integration,

      -- VECTOR SOFTMAX
      -- CONTROL
      VECTOR_SOFTMAX_START => start_vector_softmax,
      VECTOR_SOFTMAX_READY => ready_vector_softmax,

      VECTOR_SOFTMAX_DATA_IN_ENABLE => data_in_enable_vector_softmax,

      VECTOR_SOFTMAX_DATA_ENABLE => data_enable_vector_softmax,

      VECTOR_SOFTMAX_DATA_OUT_ENABLE => data_out_enable_vector_softmax,

      -- DATA
      VECTOR_SOFTMAX_SIZE_IN  => size_in_vector_softmax,
      VECTOR_SOFTMAX_DATA_IN  => data_in_vector_softmax,
      VECTOR_SOFTMAX_DATA_OUT => data_out_vector_softmax,

      -- MATRIX DIFFERENTIATION
      -- CONTROL
      MATRIX_DIFFERENTIATION_START => start_matrix_differentiation,
      MATRIX_DIFFERENTIATION_READY => ready_matrix_differentiation,

      MATRIX_DIFFERENTIATION_CONTROL => control_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE => data_in_i_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE => data_in_j_enable_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_I_ENABLE => data_i_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_J_ENABLE => data_j_enable_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_differentiation,

      -- DATA
      MATRIX_DIFFERENTIATION_SIZE_I_IN   => size_i_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_SIZE_J_IN   => size_j_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_LENGTH_I_IN => length_i_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_LENGTH_J_IN => length_j_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN     => data_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT    => data_out_matrix_differentiation,

      -- MATRIX INTEGRATION
      -- CONTROL
      MATRIX_INTEGRATION_START => start_matrix_integration,
      MATRIX_INTEGRATION_READY => ready_matrix_integration,

      MATRIX_INTEGRATION_DATA_IN_I_ENABLE => data_in_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_IN_J_ENABLE => data_in_j_enable_matrix_integration,

      MATRIX_INTEGRATION_DATA_I_ENABLE => data_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_J_ENABLE => data_j_enable_matrix_integration,

      MATRIX_INTEGRATION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integration,
      MATRIX_INTEGRATION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integration,

      -- DATA
      MATRIX_INTEGRATION_SIZE_I_IN => size_i_in_matrix_integration,
      MATRIX_INTEGRATION_SIZE_J_IN => size_j_in_matrix_integration,
      MATRIX_INTEGRATION_LENGTH_IN => length_in_matrix_integration,
      MATRIX_INTEGRATION_DATA_IN   => data_in_matrix_integration,
      MATRIX_INTEGRATION_DATA_OUT  => data_out_matrix_integration,

      -- MATRIX SOFTMAX
      -- CONTROL
      MATRIX_SOFTMAX_START => start_matrix_softmax,
      MATRIX_SOFTMAX_READY => ready_matrix_softmax,

      MATRIX_SOFTMAX_DATA_IN_I_ENABLE => data_in_i_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_IN_J_ENABLE => data_in_j_enable_matrix_softmax,

      MATRIX_SOFTMAX_DATA_I_ENABLE => data_i_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_J_ENABLE => data_j_enable_matrix_softmax,

      MATRIX_SOFTMAX_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_softmax,
      MATRIX_SOFTMAX_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_softmax,

      -- DATA
      MATRIX_SOFTMAX_SIZE_I_IN => size_i_in_matrix_softmax,
      MATRIX_SOFTMAX_SIZE_J_IN => size_j_in_matrix_softmax,
      MATRIX_SOFTMAX_DATA_IN   => data_in_matrix_softmax,
      MATRIX_SOFTMAX_DATA_OUT  => data_out_matrix_softmax,

      -- TENSOR DIFFERENTIATION
      -- CONTROL
      TENSOR_DIFFERENTIATION_START => start_tensor_differentiation,
      TENSOR_DIFFERENTIATION_READY => ready_tensor_differentiation,

      TENSOR_DIFFERENTIATION_CONTROL => control_tensor_differentiation,

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
      TENSOR_DIFFERENTIATION_SIZE_I_IN   => size_i_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_SIZE_J_IN   => size_j_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_SIZE_K_IN   => size_k_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_LENGTH_I_IN => length_i_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_LENGTH_J_IN => length_j_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_LENGTH_K_IN => length_k_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_IN     => data_in_tensor_differentiation,
      TENSOR_DIFFERENTIATION_DATA_OUT    => data_out_tensor_differentiation,

      -- TENSOR INTEGRATION
      -- CONTROL
      TENSOR_INTEGRATION_START => start_tensor_integration,
      TENSOR_INTEGRATION_READY => ready_tensor_integration,

      TENSOR_INTEGRATION_DATA_IN_I_ENABLE => data_in_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_IN_J_ENABLE => data_in_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_IN_K_ENABLE => data_in_k_enable_tensor_integration,

      TENSOR_INTEGRATION_DATA_I_ENABLE => data_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_J_ENABLE => data_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_K_ENABLE => data_k_enable_tensor_integration,

      TENSOR_INTEGRATION_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integration,
      TENSOR_INTEGRATION_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integration,

      -- DATA
      TENSOR_INTEGRATION_SIZE_I_IN => size_i_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_J_IN => size_j_in_tensor_integration,
      TENSOR_INTEGRATION_SIZE_K_IN => size_k_in_tensor_integration,
      TENSOR_INTEGRATION_LENGTH_IN => length_in_tensor_integration,
      TENSOR_INTEGRATION_DATA_IN   => data_in_tensor_integration,
      TENSOR_INTEGRATION_DATA_OUT  => data_out_tensor_integration,

      -- TENSOR SOFTMAX
      -- CONTROL
      TENSOR_SOFTMAX_START => start_tensor_softmax,
      TENSOR_SOFTMAX_READY => ready_tensor_softmax,

      TENSOR_SOFTMAX_DATA_IN_I_ENABLE => data_in_i_enable_tensor_softmax,
      TENSOR_SOFTMAX_DATA_IN_J_ENABLE => data_in_j_enable_tensor_softmax,
      TENSOR_SOFTMAX_DATA_IN_K_ENABLE => data_in_k_enable_tensor_softmax,

      TENSOR_SOFTMAX_DATA_I_ENABLE => data_i_enable_tensor_softmax,
      TENSOR_SOFTMAX_DATA_J_ENABLE => data_j_enable_tensor_softmax,
      TENSOR_SOFTMAX_DATA_K_ENABLE => data_k_enable_tensor_softmax,

      TENSOR_SOFTMAX_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_softmax,
      TENSOR_SOFTMAX_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_softmax,
      TENSOR_SOFTMAX_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_softmax,

      -- DATA
      TENSOR_SOFTMAX_SIZE_I_IN => size_i_in_tensor_softmax,
      TENSOR_SOFTMAX_SIZE_J_IN => size_j_in_tensor_softmax,
      TENSOR_SOFTMAX_SIZE_K_IN => size_k_in_tensor_softmax,
      TENSOR_SOFTMAX_DATA_IN   => data_in_tensor_softmax,
      TENSOR_SOFTMAX_DATA_OUT  => data_out_tensor_softmax
      );

  -- VECTOR DIFFERENTIATION
  accelerator_vector_differentiation_test : if (ENABLE_ACCELERATOR_VECTOR_DIFFERENTIATION_TEST) generate
    vector_differentiation : accelerator_vector_differentiation
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
        SIZE_IN   => size_in_vector_differentiation,
        LENGTH_IN => length_in_vector_differentiation,
        DATA_IN   => data_in_vector_differentiation,
        DATA_OUT  => data_out_vector_differentiation
        );
  end generate accelerator_vector_differentiation_test;

  -- VECTOR INTEGRATION
  accelerator_vector_integration_test : if (ENABLE_ACCELERATOR_VECTOR_INTEGRATION_TEST) generate
    VECTOR_INTEGRATION : accelerator_vector_integration
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

        DATA_IN_ENABLE => data_in_enable_vector_integration,

        DATA_ENABLE => data_enable_vector_integration,

        DATA_OUT_ENABLE => data_out_enable_vector_integration,

        -- DATA
        SIZE_IN   => size_in_vector_integration,
        LENGTH_IN => length_in_vector_integration,
        DATA_IN   => data_in_vector_integration,
        DATA_OUT  => data_out_vector_integration
        );
  end generate accelerator_vector_integration_test;

  -- VECTOR SOFTMAX
  accelerator_vector_softmax_test : if (ENABLE_ACCELERATOR_VECTOR_SOFTMAX_TEST) generate
    VECTOR_SOFTMAX : accelerator_vector_softmax
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_softmax,
        READY => ready_vector_softmax,

        DATA_IN_ENABLE => data_in_enable_vector_softmax,

        DATA_ENABLE => data_enable_vector_softmax,

        DATA_OUT_ENABLE => data_out_enable_vector_softmax,

        -- DATA
        SIZE_IN  => size_in_vector_softmax,
        DATA_IN  => data_in_vector_softmax,
        DATA_OUT => data_out_vector_softmax
        );
  end generate accelerator_vector_softmax_test;

  -- MATRIX DIFFERENTIATION
  accelerator_matrix_differentiation_test : if (ENABLE_ACCELERATOR_MATRIX_DIFFERENTIATION_TEST) generate
    matrix_differentiation : accelerator_matrix_differentiation
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

        CONTROL => control_matrix_differentiation,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_differentiation,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_differentiation,

        DATA_I_ENABLE => data_i_enable_matrix_differentiation,
        DATA_J_ENABLE => data_j_enable_matrix_differentiation,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_differentiation,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_differentiation,

        -- DATA
        SIZE_I_IN   => size_i_in_matrix_differentiation,
        SIZE_J_IN   => size_j_in_matrix_differentiation,
        LENGTH_I_IN => length_i_in_matrix_differentiation,
        LENGTH_J_IN => length_j_in_matrix_differentiation,
        DATA_IN     => data_in_matrix_differentiation,
        DATA_OUT    => data_out_matrix_differentiation
        );
  end generate accelerator_matrix_differentiation_test;

  -- MATRIX INTEGRATION
  accelerator_matrix_integration_test : if (ENABLE_ACCELERATOR_MATRIX_INTEGRATION_TEST) generate
    matrix_integration : accelerator_matrix_integration
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

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_integration,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_integration,

        DATA_I_ENABLE => data_i_enable_matrix_integration,
        DATA_J_ENABLE => data_j_enable_matrix_integration,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integration,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integration,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integration,
        SIZE_J_IN => size_j_in_matrix_integration,
        LENGTH_IN => length_in_matrix_integration,
        DATA_IN   => data_in_matrix_integration,
        DATA_OUT  => data_out_matrix_integration
        );
  end generate accelerator_matrix_integration_test;

  -- MATRIX SOFTMAX
  accelerator_matrix_softmax_test : if (ENABLE_ACCELERATOR_MATRIX_SOFTMAX_TEST) generate
    matrix_softmax : accelerator_matrix_softmax
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_softmax,
        READY => ready_matrix_softmax,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_softmax,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_softmax,

        DATA_I_ENABLE => data_i_enable_matrix_softmax,
        DATA_J_ENABLE => data_j_enable_matrix_softmax,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_softmax,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_softmax,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_softmax,
        SIZE_J_IN => size_j_in_matrix_softmax,
        DATA_IN   => data_in_matrix_softmax,
        DATA_OUT  => data_out_matrix_softmax
        );
  end generate accelerator_matrix_softmax_test;

  -- TENSOR DIFFERENTIATION
  accelerator_tensor_differentiation_test : if (ENABLE_ACCELERATOR_TENSOR_DIFFERENTIATION_TEST) generate
    tensor_differentiation : accelerator_tensor_differentiation
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

        CONTROL => control_tensor_differentiation,

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
        SIZE_I_IN   => size_i_in_tensor_differentiation,
        SIZE_J_IN   => size_j_in_tensor_differentiation,
        SIZE_K_IN   => size_k_in_tensor_differentiation,
        LENGTH_I_IN => length_i_in_tensor_differentiation,
        LENGTH_J_IN => length_j_in_tensor_differentiation,
        LENGTH_K_IN => length_k_in_tensor_differentiation,
        DATA_IN     => data_in_tensor_differentiation,
        DATA_OUT    => data_out_tensor_differentiation
        );
  end generate accelerator_tensor_differentiation_test;

  -- TENSOR INTEGRATION
  accelerator_tensor_integration_test : if (ENABLE_ACCELERATOR_TENSOR_INTEGRATION_TEST) generate
    tensor_integration : accelerator_tensor_integration
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

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_integration,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_integration,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_integration,

        DATA_I_ENABLE => data_i_enable_tensor_integration,
        DATA_J_ENABLE => data_j_enable_tensor_integration,
        DATA_K_ENABLE => data_k_enable_tensor_integration,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integration,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integration,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integration,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integration,
        SIZE_J_IN => size_j_in_tensor_integration,
        SIZE_K_IN => size_k_in_tensor_integration,
        LENGTH_IN => length_in_tensor_integration,
        DATA_IN   => data_in_tensor_integration,
        DATA_OUT  => data_out_tensor_integration
        );
  end generate accelerator_tensor_integration_test;

  -- TENSOR SOFTMAX
  accelerator_tensor_softmax_test : if (ENABLE_ACCELERATOR_TENSOR_SOFTMAX_TEST) generate
    tensor_softmax : accelerator_tensor_softmax
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_softmax,
        READY => ready_tensor_softmax,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_softmax,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_softmax,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_softmax,

        DATA_I_ENABLE => data_i_enable_tensor_softmax,
        DATA_J_ENABLE => data_j_enable_tensor_softmax,
        DATA_K_ENABLE => data_k_enable_tensor_softmax,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_softmax,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_softmax,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_softmax,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_softmax,
        SIZE_J_IN => size_j_in_tensor_softmax,
        SIZE_K_IN => size_k_in_tensor_softmax,
        DATA_IN   => data_in_tensor_softmax,
        DATA_OUT  => data_out_tensor_softmax
        );
  end generate accelerator_tensor_softmax_test;

end accelerator_calculus_testbench_architecture;
