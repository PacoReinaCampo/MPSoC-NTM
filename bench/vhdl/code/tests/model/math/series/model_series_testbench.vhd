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

use work.model_math_pkg.all;
use work.model_series_pkg.all;

entity model_series_testbench is
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
    ENABLE_NTM_SCALAR_COSH_TEST          : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST : boolean := false;
    ENABLE_NTM_SCALAR_LOGARITHM_TEST     : boolean := false;
    ENABLE_NTM_SCALAR_SINH_TEST          : boolean := false;
    ENABLE_NTM_SCALAR_TANH_TEST          : boolean := false;

    ENABLE_NTM_SCALAR_COSH_CASE_0          : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_LOGARITHM_CASE_0     : boolean := false;
    ENABLE_NTM_SCALAR_SINH_CASE_0          : boolean := false;
    ENABLE_NTM_SCALAR_TANH_CASE_0          : boolean := false;

    ENABLE_NTM_SCALAR_COSH_CASE_1          : boolean := false;
    ENABLE_NTM_SCALAR_EXPONENTIATOR_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_LOGARITHM_CASE_1     : boolean := false;
    ENABLE_NTM_SCALAR_SINH_CASE_1          : boolean := false;
    ENABLE_NTM_SCALAR_TANH_CASE_1          : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_COSH_TEST          : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST : boolean := false;
    ENABLE_NTM_VECTOR_LOGARITHM_TEST     : boolean := false;
    ENABLE_NTM_VECTOR_SINH_TEST          : boolean := false;
    ENABLE_NTM_VECTOR_TANH_TEST          : boolean := false;

    ENABLE_NTM_VECTOR_COSH_CASE_0          : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_LOGARITHM_CASE_0     : boolean := false;
    ENABLE_NTM_VECTOR_SINH_CASE_0          : boolean := false;
    ENABLE_NTM_VECTOR_TANH_CASE_0          : boolean := false;

    ENABLE_NTM_VECTOR_COSH_CASE_1          : boolean := false;
    ENABLE_NTM_VECTOR_EXPONENTIATOR_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_LOGARITHM_CASE_1     : boolean := false;
    ENABLE_NTM_VECTOR_SINH_CASE_1          : boolean := false;
    ENABLE_NTM_VECTOR_TANH_CASE_1          : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_COSH_TEST          : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST : boolean := false;
    ENABLE_NTM_MATRIX_LOGARITHM_TEST     : boolean := false;
    ENABLE_NTM_MATRIX_SINH_TEST          : boolean := false;
    ENABLE_NTM_MATRIX_TANH_TEST          : boolean := false;

    ENABLE_NTM_MATRIX_COSH_CASE_0          : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_LOGARITHM_CASE_0     : boolean := false;
    ENABLE_NTM_MATRIX_SINH_CASE_0          : boolean := false;
    ENABLE_NTM_MATRIX_TANH_CASE_0          : boolean := false;

    ENABLE_NTM_MATRIX_COSH_CASE_1          : boolean := false;
    ENABLE_NTM_MATRIX_EXPONENTIATOR_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_LOGARITHM_CASE_1     : boolean := false;
    ENABLE_NTM_MATRIX_SINH_CASE_1          : boolean := false;
    ENABLE_NTM_MATRIX_TANH_CASE_1          : boolean := false
    );
end model_series_testbench;

architecture model_series_testbench_architecture of model_series_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR COSH
  -- CONTROL
  signal start_scalar_cosh : std_logic;
  signal ready_scalar_cosh : std_logic;

  -- DATA
  signal data_in_scalar_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_cosh : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR EXPONENTIATOR
  -- CONTROL
  signal start_scalar_exponentiator : std_logic;
  signal ready_scalar_exponentiator : std_logic;

  -- DATA
  signal data_in_scalar_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR LOGARITHM
  -- CONTROL
  signal start_scalar_logarithm : std_logic;
  signal ready_scalar_logarithm : std_logic;

  -- DATA
  signal data_in_scalar_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR SINH
  -- CONTROL
  signal start_scalar_sinh : std_logic;
  signal ready_scalar_sinh : std_logic;

  -- DATA
  signal data_in_scalar_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_sinh : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR TANH
  -- CONTROL
  signal start_scalar_tanh : std_logic;
  signal ready_scalar_tanh : std_logic;

  -- DATA
  signal data_in_scalar_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_tanh : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR COSH
  -- CONTROL
  signal start_vector_cosh : std_logic;
  signal ready_vector_cosh : std_logic;

  signal data_in_enable_vector_cosh : std_logic;

  signal data_out_enable_vector_cosh : std_logic;

  -- DATA
  signal size_in_vector_cosh  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_cosh : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal size_in_vector_exponentiator  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGARITHM
  -- CONTROL
  signal start_vector_logarithm : std_logic;
  signal ready_vector_logarithm : std_logic;

  signal data_in_enable_vector_logarithm : std_logic;

  signal data_out_enable_vector_logarithm : std_logic;

  -- DATA
  signal size_in_vector_logarithm  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR SINH
  -- CONTROL
  signal start_vector_sinh : std_logic;
  signal ready_vector_sinh : std_logic;

  signal data_in_enable_vector_sinh : std_logic;

  signal data_out_enable_vector_sinh : std_logic;

  -- DATA
  signal size_in_vector_sinh  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_sinh : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal size_in_vector_tanh  : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX COSH
  -- CONTROL
  signal start_matrix_cosh : std_logic;
  signal ready_matrix_cosh : std_logic;

  signal data_in_i_enable_matrix_cosh : std_logic;
  signal data_in_j_enable_matrix_cosh : std_logic;

  signal data_out_i_enable_matrix_cosh : std_logic;
  signal data_out_j_enable_matrix_cosh : std_logic;

  -- DATA
  signal size_i_in_matrix_cosh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_cosh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_cosh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_cosh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX EXPONENTIATOR
  -- CONTROL
  signal start_matrix_exponentiator : std_logic;
  signal ready_matrix_exponentiator : std_logic;

  signal data_in_i_enable_matrix_exponentiator : std_logic;
  signal data_in_j_enable_matrix_exponentiator : std_logic;

  signal data_out_i_enable_matrix_exponentiator : std_logic;
  signal data_out_j_enable_matrix_exponentiator : std_logic;

  -- DATA
  signal size_i_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_exponentiator : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX LOGARITHM
  -- CONTROL
  signal start_matrix_logarithm : std_logic;
  signal ready_matrix_logarithm : std_logic;

  signal data_in_i_enable_matrix_logarithm : std_logic;
  signal data_in_j_enable_matrix_logarithm : std_logic;

  signal data_out_i_enable_matrix_logarithm : std_logic;
  signal data_out_j_enable_matrix_logarithm : std_logic;

  -- DATA
  signal size_i_in_matrix_logarithm : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_logarithm : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX SINH
  -- CONTROL
  signal start_matrix_sinh : std_logic;
  signal ready_matrix_sinh : std_logic;

  signal data_in_i_enable_matrix_sinh : std_logic;
  signal data_in_j_enable_matrix_sinh : std_logic;

  signal data_out_i_enable_matrix_sinh : std_logic;
  signal data_out_j_enable_matrix_sinh : std_logic;

  -- DATA
  signal size_i_in_matrix_sinh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_sinh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_sinh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_sinh  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TANH
  -- CONTROL
  signal start_matrix_tanh : std_logic;
  signal ready_matrix_tanh : std_logic;

  signal data_in_i_enable_matrix_tanh : std_logic;
  signal data_in_j_enable_matrix_tanh : std_logic;

  signal data_out_i_enable_matrix_tanh : std_logic;
  signal data_out_j_enable_matrix_tanh : std_logic;

  -- DATA
  signal size_i_in_matrix_tanh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_tanh : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  function_stimulus : model_series_stimulus
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

      -- SCALAR COSH
      -- CONTROL
      SCALAR_COSH_START => start_scalar_cosh,
      SCALAR_COSH_READY => ready_scalar_cosh,

      -- DATA
      SCALAR_COSH_DATA_IN  => data_in_scalar_cosh,
      SCALAR_COSH_DATA_OUT => data_out_scalar_cosh,

      -- SCALAR EXPONENTIATOR
      -- CONTROL
      SCALAR_EXPONENTIATOR_START => start_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_READY => ready_scalar_exponentiator,

      -- DATA
      SCALAR_EXPONENTIATOR_DATA_IN  => data_in_scalar_exponentiator,
      SCALAR_EXPONENTIATOR_DATA_OUT => data_out_scalar_exponentiator,

      -- SCALAR LOGARITHM
      -- CONTROL
      SCALAR_LOGARITHM_START => start_scalar_logarithm,
      SCALAR_LOGARITHM_READY => ready_scalar_logarithm,

      -- DATA
      SCALAR_LOGARITHM_DATA_IN  => data_in_scalar_logarithm,
      SCALAR_LOGARITHM_DATA_OUT => data_out_scalar_logarithm,

      -- SCALAR SINH
      -- CONTROL
      SCALAR_SINH_START => start_scalar_sinh,
      SCALAR_SINH_READY => ready_scalar_sinh,

      -- DATA
      SCALAR_SINH_DATA_IN  => data_in_scalar_sinh,
      SCALAR_SINH_DATA_OUT => data_out_scalar_sinh,

      -- SCALAR TANH
      -- CONTROL
      SCALAR_TANH_START => start_scalar_tanh,
      SCALAR_TANH_READY => ready_scalar_tanh,

      -- DATA
      SCALAR_TANH_DATA_IN  => data_in_scalar_tanh,
      SCALAR_TANH_DATA_OUT => data_out_scalar_tanh,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR
      ------------------------------------------------------------------------------

      -- VECTOR COSH
      -- CONTROL
      VECTOR_COSH_START => start_vector_cosh,
      VECTOR_COSH_READY => ready_vector_cosh,

      VECTOR_COSH_DATA_IN_ENABLE => data_in_enable_vector_cosh,

      VECTOR_COSH_DATA_OUT_ENABLE => data_out_enable_vector_cosh,

      -- DATA
      VECTOR_COSH_SIZE_IN  => size_in_vector_cosh,
      VECTOR_COSH_DATA_IN  => data_in_vector_cosh,
      VECTOR_COSH_DATA_OUT => data_out_vector_cosh,

      -- VECTOR EXPONENTIATOR
      -- CONTROL
      VECTOR_EXPONENTIATOR_START => start_vector_exponentiator,
      VECTOR_EXPONENTIATOR_READY => ready_vector_exponentiator,

      VECTOR_EXPONENTIATOR_DATA_IN_ENABLE => data_in_enable_vector_exponentiator,

      VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      VECTOR_EXPONENTIATOR_SIZE_IN  => size_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_IN  => data_in_vector_exponentiator,
      VECTOR_EXPONENTIATOR_DATA_OUT => data_out_vector_exponentiator,

      -- VECTOR LOGARITHM
      -- CONTROL
      VECTOR_LOGARITHM_START => start_vector_logarithm,
      VECTOR_LOGARITHM_READY => ready_vector_logarithm,

      VECTOR_LOGARITHM_DATA_IN_ENABLE => data_in_enable_vector_logarithm,

      VECTOR_LOGARITHM_DATA_OUT_ENABLE => data_out_enable_vector_logarithm,

      -- DATA
      VECTOR_LOGARITHM_SIZE_IN  => size_in_vector_logarithm,
      VECTOR_LOGARITHM_DATA_IN  => data_in_vector_logarithm,
      VECTOR_LOGARITHM_DATA_OUT => data_out_vector_logarithm,

      -- VECTOR SINH
      -- CONTROL
      VECTOR_SINH_START => start_vector_sinh,
      VECTOR_SINH_READY => ready_vector_sinh,

      VECTOR_SINH_DATA_IN_ENABLE => data_in_enable_vector_sinh,

      VECTOR_SINH_DATA_OUT_ENABLE => data_out_enable_vector_sinh,

      -- DATA
      VECTOR_SINH_SIZE_IN  => size_in_vector_sinh,
      VECTOR_SINH_DATA_IN  => data_in_vector_sinh,
      VECTOR_SINH_DATA_OUT => data_out_vector_sinh,

      -- VECTOR TANH
      -- CONTROL
      VECTOR_TANH_START => start_vector_tanh,
      VECTOR_TANH_READY => ready_vector_tanh,

      VECTOR_TANH_DATA_IN_ENABLE => data_in_enable_vector_tanh,

      VECTOR_TANH_DATA_OUT_ENABLE => data_out_enable_vector_tanh,

      -- DATA
      VECTOR_TANH_SIZE_IN  => size_in_vector_tanh,
      VECTOR_TANH_DATA_IN  => data_in_vector_tanh,
      VECTOR_TANH_DATA_OUT => data_out_vector_tanh,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX
      ------------------------------------------------------------------------------

      -- MATRIX COSH
      -- CONTROL
      MATRIX_COSH_START => start_matrix_cosh,
      MATRIX_COSH_READY => ready_matrix_cosh,

      MATRIX_COSH_DATA_IN_I_ENABLE => data_in_i_enable_matrix_cosh,
      MATRIX_COSH_DATA_IN_J_ENABLE => data_in_j_enable_matrix_cosh,

      MATRIX_COSH_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_cosh,
      MATRIX_COSH_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_cosh,

      -- DATA
      MATRIX_COSH_SIZE_I_IN => size_i_in_matrix_cosh,
      MATRIX_COSH_SIZE_J_IN => size_j_in_matrix_cosh,
      MATRIX_COSH_DATA_IN   => data_in_matrix_cosh,
      MATRIX_COSH_DATA_OUT  => data_out_matrix_cosh,

      -- MATRIX EXPONENTIATOR
      -- CONTROL
      MATRIX_EXPONENTIATOR_START => start_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_READY => ready_matrix_exponentiator,

      MATRIX_EXPONENTIATOR_DATA_IN_I_ENABLE => data_in_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_IN_J_ENABLE => data_in_j_enable_matrix_exponentiator,

      MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

      -- DATA
      MATRIX_EXPONENTIATOR_SIZE_I_IN => size_i_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_SIZE_J_IN => size_j_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_IN   => data_in_matrix_exponentiator,
      MATRIX_EXPONENTIATOR_DATA_OUT  => data_out_matrix_exponentiator,

      -- MATRIX LOGARITHM
      -- CONTROL
      MATRIX_LOGARITHM_START => start_matrix_logarithm,
      MATRIX_LOGARITHM_READY => ready_matrix_logarithm,

      MATRIX_LOGARITHM_DATA_IN_I_ENABLE => data_in_i_enable_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_IN_J_ENABLE => data_in_j_enable_matrix_logarithm,

      MATRIX_LOGARITHM_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logarithm,

      -- DATA
      MATRIX_LOGARITHM_SIZE_I_IN => size_i_in_matrix_logarithm,
      MATRIX_LOGARITHM_SIZE_J_IN => size_j_in_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_IN   => data_in_matrix_logarithm,
      MATRIX_LOGARITHM_DATA_OUT  => data_out_matrix_logarithm,

      -- MATRIX SINH
      -- CONTROL
      MATRIX_SINH_START => start_matrix_sinh,
      MATRIX_SINH_READY => ready_matrix_sinh,

      MATRIX_SINH_DATA_IN_I_ENABLE => data_in_i_enable_matrix_sinh,
      MATRIX_SINH_DATA_IN_J_ENABLE => data_in_j_enable_matrix_sinh,

      MATRIX_SINH_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_sinh,
      MATRIX_SINH_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_sinh,

      -- DATA
      MATRIX_SINH_SIZE_I_IN => size_i_in_matrix_sinh,
      MATRIX_SINH_SIZE_J_IN => size_j_in_matrix_sinh,
      MATRIX_SINH_DATA_IN   => data_in_matrix_sinh,
      MATRIX_SINH_DATA_OUT  => data_out_matrix_sinh,

      -- MATRIX TANH
      -- CONTROL
      MATRIX_TANH_START => start_matrix_tanh,
      MATRIX_TANH_READY => ready_matrix_tanh,

      MATRIX_TANH_DATA_IN_I_ENABLE => data_in_i_enable_matrix_tanh,
      MATRIX_TANH_DATA_IN_J_ENABLE => data_in_j_enable_matrix_tanh,

      MATRIX_TANH_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_tanh,
      MATRIX_TANH_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_tanh,

      -- DATA
      MATRIX_TANH_SIZE_I_IN => size_i_in_matrix_tanh,
      MATRIX_TANH_SIZE_J_IN => size_j_in_matrix_tanh,
      MATRIX_TANH_DATA_IN   => data_in_matrix_tanh,
      MATRIX_TANH_DATA_OUT  => data_out_matrix_tanh
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR COSH
  model_scalar_cosh_function_test : if (ENABLE_NTM_SCALAR_COSH_TEST) generate
    scalar_cosh_function : model_scalar_cosh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_cosh,
        READY => ready_scalar_cosh,

        -- DATA
        DATA_IN  => data_in_scalar_cosh,
        DATA_OUT => data_out_scalar_cosh
        );
  end generate model_scalar_cosh_function_test;

  -- SCALAR EXPONENTIATOR
  model_scalar_exponentiator_function_test : if (ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST) generate
    scalar_exponentiator_function : model_scalar_exponentiator_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
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
        DATA_IN  => data_in_scalar_exponentiator,
        DATA_OUT => data_out_scalar_exponentiator
        );
  end generate model_scalar_exponentiator_function_test;

  -- SCALAR LOGARITHM
  model_scalar_logarithm_function_test : if (ENABLE_NTM_SCALAR_LOGARITHM_TEST) generate
    scalar_logarithm_function : model_scalar_logarithm_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_logarithm,
        READY => ready_scalar_logarithm,

        -- DATA
        DATA_IN  => data_in_scalar_logarithm,
        DATA_OUT => data_out_scalar_logarithm
        );
  end generate model_scalar_logarithm_function_test;

  -- SCALAR SINH
  model_scalar_sinh_function_test : if (ENABLE_NTM_SCALAR_SINH_TEST) generate
    scalar_sinh_function : model_scalar_sinh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_sinh,
        READY => ready_scalar_sinh,

        -- DATA
        DATA_IN  => data_in_scalar_sinh,
        DATA_OUT => data_out_scalar_sinh
        );
  end generate model_scalar_sinh_function_test;

  -- SCALAR TANH
  model_scalar_tanh_function_test : if (ENABLE_NTM_SCALAR_TANH_TEST) generate
    scalar_tanh_function : model_scalar_tanh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_tanh,
        READY => ready_scalar_tanh,

        -- DATA
        DATA_IN  => data_in_scalar_tanh,
        DATA_OUT => data_out_scalar_tanh
        );
  end generate model_scalar_tanh_function_test;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR COSH
  model_vector_cosh_function_test : if (ENABLE_NTM_VECTOR_COSH_TEST) generate
    vector_cosh_function : model_vector_cosh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_cosh,
        READY => ready_vector_cosh,

        DATA_IN_ENABLE => data_in_enable_vector_cosh,

        DATA_OUT_ENABLE => data_out_enable_vector_cosh,

        -- DATA
        SIZE_IN  => size_in_vector_cosh,
        DATA_IN  => data_in_vector_cosh,
        DATA_OUT => data_out_vector_cosh
        );
  end generate model_vector_cosh_function_test;

  -- VECTOR EXPONENTIATOR
  model_vector_exponentiator_function_test : if (ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST) generate
    vector_exponentiator_function : model_vector_exponentiator_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_exponentiator,
        READY => ready_vector_exponentiator,

        DATA_IN_ENABLE => data_in_enable_vector_exponentiator,

        DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

        -- DATA
        SIZE_IN  => size_in_vector_exponentiator,
        DATA_IN  => data_in_vector_exponentiator,
        DATA_OUT => data_out_vector_exponentiator
        );
  end generate model_vector_exponentiator_function_test;

  -- VECTOR LOGARITHM
  model_vector_logarithm_function_test : if (ENABLE_NTM_VECTOR_LOGARITHM_TEST) generate
    vector_logarithm_function : model_vector_logarithm_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_logarithm,
        READY => ready_vector_logarithm,

        DATA_IN_ENABLE => data_in_enable_vector_logarithm,

        DATA_OUT_ENABLE => data_out_enable_vector_logarithm,

        -- DATA
        SIZE_IN  => size_in_vector_logarithm,
        DATA_IN  => data_in_vector_logarithm,
        DATA_OUT => data_out_vector_logarithm
        );
  end generate model_vector_logarithm_function_test;

  -- VECTOR SINH
  model_vector_sinh_function_test : if (ENABLE_NTM_VECTOR_SINH_TEST) generate
    vector_sinh_function : model_vector_sinh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_sinh,
        READY => ready_vector_sinh,

        DATA_IN_ENABLE => data_in_enable_vector_sinh,

        DATA_OUT_ENABLE => data_out_enable_vector_sinh,

        -- DATA
        SIZE_IN  => size_in_vector_sinh,
        DATA_IN  => data_in_vector_sinh,
        DATA_OUT => data_out_vector_sinh
        );
  end generate model_vector_sinh_function_test;

  -- VECTOR TANH
  model_vector_tanh_function_test : if (ENABLE_NTM_VECTOR_TANH_TEST) generate
    vector_tanh_function : model_vector_tanh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_tanh,
        READY => ready_vector_tanh,

        DATA_IN_ENABLE => data_in_enable_vector_tanh,

        DATA_OUT_ENABLE => data_out_enable_vector_tanh,

        -- DATA
        SIZE_IN  => size_in_vector_tanh,
        DATA_IN  => data_in_vector_tanh,
        DATA_OUT => data_out_vector_tanh
        );
  end generate model_vector_tanh_function_test;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX COSH
  model_matrix_cosh_function_test : if (ENABLE_NTM_MATRIX_COSH_TEST) generate
    matrix_cosh_function : model_matrix_cosh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_cosh,
        READY => ready_matrix_cosh,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_cosh,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_cosh,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_cosh,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_cosh,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_cosh,
        SIZE_J_IN => size_j_in_matrix_cosh,
        DATA_IN   => data_in_matrix_cosh,
        DATA_OUT  => data_out_matrix_cosh
        );
  end generate model_matrix_cosh_function_test;

  -- MATRIX EXPONENTIATOR
  model_matrix_exponentiator_function_test : if (ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST) generate
    matrix_exponentiator_function : model_matrix_exponentiator_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_exponentiator,
        READY => ready_matrix_exponentiator,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_exponentiator,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_exponentiator,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_exponentiator,
        SIZE_J_IN => size_j_in_matrix_exponentiator,
        DATA_IN   => data_in_matrix_exponentiator,
        DATA_OUT  => data_out_matrix_exponentiator
        );
  end generate model_matrix_exponentiator_function_test;

  -- MATRIX LOGARITHM
  model_matrix_logarithm_function_test : if (ENABLE_NTM_MATRIX_LOGARITHM_TEST) generate
    matrix_logarithm_function : model_matrix_logarithm_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_logarithm,
        READY => ready_matrix_logarithm,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_logarithm,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_logarithm,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logarithm,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logarithm,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_logarithm,
        SIZE_J_IN => size_j_in_matrix_logarithm,
        DATA_IN   => data_in_matrix_logarithm,
        DATA_OUT  => data_out_matrix_logarithm
        );
  end generate model_matrix_logarithm_function_test;

  -- MATRIX SINH
  model_matrix_sinh_function_test : if (ENABLE_NTM_MATRIX_SINH_TEST) generate
    matrix_sinh_function : model_matrix_sinh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_sinh,
        READY => ready_matrix_sinh,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_sinh,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_sinh,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_sinh,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_sinh,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_sinh,
        SIZE_J_IN => size_j_in_matrix_sinh,
        DATA_IN   => data_in_matrix_sinh,
        DATA_OUT  => data_out_matrix_sinh
        );
  end generate model_matrix_sinh_function_test;

  -- MATRIX TANH
  model_matrix_tanh_function_test : if (ENABLE_NTM_MATRIX_TANH_TEST) generate
    matrix_tanh_function : model_matrix_tanh_function
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_tanh,
        READY => ready_matrix_tanh,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_tanh,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_tanh,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_tanh,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_tanh,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_tanh,
        SIZE_J_IN => size_j_in_matrix_tanh,
        DATA_IN   => data_in_matrix_tanh,
        DATA_OUT  => data_out_matrix_tanh
        );
  end generate model_matrix_tanh_function_test;

end model_series_testbench_architecture;
