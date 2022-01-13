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
use work.ntm_algebra_pkg.all;

entity ntm_algebra_testbench is
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

    -- FUNCTIONALITY
    ENABLE_NTM_MATRIX_PRODUCT_TEST   : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_TEST : boolean := false;
    ENABLE_NTM_SCALAR_PRODUCT_TEST   : boolean := false;
    ENABLE_NTM_SCALAR_TRANSPOSE_TEST : boolean := false;
    ENABLE_NTM_TENSOR_PRODUCT_TEST   : boolean := false;
    ENABLE_NTM_TENSOR_TRANSPOSE_TEST : boolean := false;

    ENABLE_NTM_MATRIX_PRODUCT_CASE_0   : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_PRODUCT_CASE_0   : boolean := false;
    ENABLE_NTM_SCALAR_TRANSPOSE_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_PRODUCT_CASE_0   : boolean := false;
    ENABLE_NTM_TENSOR_TRANSPOSE_CASE_0 : boolean := false;

    ENABLE_NTM_MATRIX_PRODUCT_CASE_1   : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_PRODUCT_CASE_1   : boolean := false;
    ENABLE_NTM_SCALAR_TRANSPOSE_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_PRODUCT_CASE_1   : boolean := false;
    ENABLE_NTM_TENSOR_TRANSPOSE_CASE_1 : boolean := false
    );
end ntm_algebra_testbench;

architecture ntm_algebra_testbench_architecture of ntm_algebra_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_i_enable_matrix_product : std_logic;
  signal data_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TRANSPOSE
  -- CONTROL
  signal start_matrix_transpose : std_logic;
  signal ready_matrix_transpose : std_logic;

  signal data_in_i_enable_matrix_transpose : std_logic;
  signal data_in_j_enable_matrix_transpose : std_logic;

  signal data_i_enable_matrix_transpose : std_logic;
  signal data_j_enable_matrix_transpose : std_logic;

  signal data_out_i_enable_matrix_transpose : std_logic;
  signal data_out_j_enable_matrix_transpose : std_logic;

  -- DATA
  signal size_i_in_matrix_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_transpose   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_transpose  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT
  -- CONTROL
  signal start_scalar_product : std_logic;
  signal ready_scalar_product : std_logic;

  signal data_a_in_enable_scalar_product : std_logic;
  signal data_b_in_enable_scalar_product : std_logic;

  signal data_out_enable_scalar_product : std_logic;

  -- DATA
  signal length_in_scalar_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR TRANSPOSE
  -- CONTROL
  signal start_scalar_transpose : std_logic;
  signal ready_scalar_transpose : std_logic;

  signal data_in_enable_scalar_transpose : std_logic;

  signal data_enable_scalar_transpose : std_logic;

  signal data_out_enable_scalar_transpose : std_logic;

  -- DATA
  signal length_in_scalar_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_transpose   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_transpose  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR PRODUCT
  -- CONTROL
  signal start_tensor_product : std_logic;
  signal ready_tensor_product : std_logic;

  signal data_a_in_i_enable_tensor_product : std_logic;
  signal data_a_in_j_enable_tensor_product : std_logic;
  signal data_a_in_k_enable_tensor_product : std_logic;
  signal data_b_in_i_enable_tensor_product : std_logic;
  signal data_b_in_j_enable_tensor_product : std_logic;
  signal data_b_in_k_enable_tensor_product : std_logic;

  signal data_out_i_enable_tensor_product : std_logic;
  signal data_out_j_enable_tensor_product : std_logic;
  signal data_out_k_enable_tensor_product : std_logic;

  -- DATA
  signal size_a_i_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_k_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_k_in_tensor_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR TRANSPOSE
  -- CONTROL
  signal start_tensor_transpose : std_logic;
  signal ready_tensor_transpose : std_logic;

  signal data_in_i_enable_tensor_transpose : std_logic;
  signal data_in_j_enable_tensor_transpose : std_logic;
  signal data_in_k_enable_tensor_transpose : std_logic;

  signal data_out_i_enable_tensor_transpose : std_logic;
  signal data_out_j_enable_tensor_transpose : std_logic;
  signal data_out_k_enable_tensor_transpose : std_logic;

  -- DATA
  signal size_i_in_tensor_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_transpose : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_tensor_transpose   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_tensor_transpose  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  algebra_stimulus : ntm_algebra_stimulus
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

      -- MATRIX PRODUCT
      -- CONTROL
      MATRIX_PRODUCT_START => start_matrix_product,
      MATRIX_PRODUCT_READY => ready_matrix_product,

      MATRIX_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      MATRIX_PRODUCT_DATA_I_ENABLE => data_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_J_ENABLE => data_j_enable_matrix_product,

      MATRIX_PRODUCT_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      MATRIX_PRODUCT_SIZE_A_I_IN => size_a_i_in_matrix_product,
      MATRIX_PRODUCT_SIZE_A_J_IN => size_a_j_in_matrix_product,
      MATRIX_PRODUCT_SIZE_B_I_IN => size_b_i_in_matrix_product,
      MATRIX_PRODUCT_SIZE_B_J_IN => size_b_j_in_matrix_product,
      MATRIX_PRODUCT_DATA_A_IN   => data_a_in_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN   => data_b_in_matrix_product,
      MATRIX_PRODUCT_DATA_OUT    => data_out_matrix_product,

      -- MATRIX TRANSPOSE
      -- CONTROL
      MATRIX_TRANSPOSE_START => start_matrix_transpose,
      MATRIX_TRANSPOSE_READY => ready_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_IN_I_ENABLE => data_in_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_IN_J_ENABLE => data_in_j_enable_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_I_ENABLE => data_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_J_ENABLE => data_j_enable_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

      -- DATA
      MATRIX_TRANSPOSE_SIZE_I_IN => size_i_in_matrix_transpose,
      MATRIX_TRANSPOSE_SIZE_J_IN => size_j_in_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_IN   => data_in_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_OUT  => data_out_matrix_transpose,

      -- SCALAR PRODUCT
      -- CONTROL
      SCALAR_PRODUCT_START => start_scalar_product,
      SCALAR_PRODUCT_READY => ready_scalar_product,

      SCALAR_PRODUCT_DATA_A_IN_ENABLE => data_a_in_enable_scalar_product,
      SCALAR_PRODUCT_DATA_B_IN_ENABLE => data_b_in_enable_scalar_product,

      SCALAR_PRODUCT_DATA_OUT_ENABLE => data_out_enable_scalar_product,

      -- DATA
      SCALAR_PRODUCT_LENGTH_IN => length_in_scalar_product,
      SCALAR_PRODUCT_DATA_A_IN => data_a_in_scalar_product,
      SCALAR_PRODUCT_DATA_B_IN => data_b_in_scalar_product,
      SCALAR_PRODUCT_DATA_OUT  => data_out_scalar_product,

      -- SCALAR TRANSPOSE
      -- CONTROL
      SCALAR_TRANSPOSE_START => start_scalar_transpose,
      SCALAR_TRANSPOSE_READY => ready_scalar_transpose,

      SCALAR_TRANSPOSE_DATA_IN_ENABLE => data_in_enable_scalar_transpose,

      SCALAR_TRANSPOSE_DATA_ENABLE => data_enable_scalar_transpose,

      SCALAR_TRANSPOSE_DATA_OUT_ENABLE => data_out_enable_scalar_transpose,

      -- DATA
      SCALAR_TRANSPOSE_LENGTH_IN => length_in_scalar_transpose,
      SCALAR_TRANSPOSE_DATA_IN   => data_in_scalar_transpose,
      SCALAR_TRANSPOSE_DATA_OUT  => data_out_scalar_transpose,

      -- TENSOR PRODUCT
      -- CONTROL
      TENSOR_PRODUCT_START => start_tensor_product,
      TENSOR_PRODUCT_READY => ready_tensor_product,

      TENSOR_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_product,

      TENSOR_PRODUCT_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_product,
      TENSOR_PRODUCT_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_product,
      TENSOR_PRODUCT_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_product,

      -- DATA
      TENSOR_PRODUCT_SIZE_A_I_IN => size_a_i_in_tensor_product,
      TENSOR_PRODUCT_SIZE_A_J_IN => size_a_j_in_tensor_product,
      TENSOR_PRODUCT_SIZE_A_K_IN => size_a_k_in_tensor_product,
      TENSOR_PRODUCT_SIZE_B_I_IN => size_b_i_in_tensor_product,
      TENSOR_PRODUCT_SIZE_B_J_IN => size_b_j_in_tensor_product,
      TENSOR_PRODUCT_SIZE_B_K_IN => size_b_k_in_tensor_product,
      TENSOR_PRODUCT_DATA_A_IN   => data_a_in_tensor_product,
      TENSOR_PRODUCT_DATA_B_IN   => data_b_in_tensor_product,
      TENSOR_PRODUCT_DATA_OUT    => data_out_tensor_product,

      -- TENSOR TRANSPOSE
      -- CONTROL
      TENSOR_TRANSPOSE_START => start_tensor_transpose,
      TENSOR_TRANSPOSE_READY => ready_tensor_transpose,

      TENSOR_TRANSPOSE_DATA_IN_I_ENABLE => data_in_i_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_IN_J_ENABLE => data_in_j_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_IN_K_ENABLE => data_in_k_enable_tensor_transpose,

      TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_transpose,

      -- DATA
      TENSOR_TRANSPOSE_SIZE_I_IN => size_i_in_tensor_transpose,
      TENSOR_TRANSPOSE_SIZE_J_IN => size_j_in_tensor_transpose,
      TENSOR_TRANSPOSE_SIZE_K_IN => size_k_in_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_IN   => data_in_tensor_transpose,
      TENSOR_TRANSPOSE_DATA_OUT  => data_out_tensor_transpose
      );

  -- MATRIX PRODUCT
  ntm_matrix_product_test : if (ENABLE_NTM_MATRIX_PRODUCT_TEST) generate
    matrix_product : ntm_matrix_product
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_product,
        READY => ready_matrix_product,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

        DATA_I_ENABLE => data_i_enable_matrix_product,
        DATA_J_ENABLE => data_j_enable_matrix_product,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_matrix_product,
        SIZE_A_J_IN => size_a_j_in_matrix_product,
        SIZE_B_I_IN => size_b_i_in_matrix_product,
        SIZE_B_J_IN => size_b_j_in_matrix_product,
        DATA_A_IN   => data_a_in_matrix_product,
        DATA_B_IN   => data_b_in_matrix_product,
        DATA_OUT    => data_out_matrix_product
        );
  end generate ntm_matrix_product_test;

  -- MATRIX TRANSPOSE
  ntm_matrix_transpose_test : if (ENABLE_NTM_MATRIX_TRANSPOSE_TEST) generate
    matrix_transpose : ntm_matrix_transpose
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_transpose,
        READY => ready_matrix_transpose,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_transpose,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_transpose,

        DATA_I_ENABLE => data_i_enable_matrix_transpose,
        DATA_J_ENABLE => data_j_enable_matrix_transpose,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_transpose,
        SIZE_J_IN => size_j_in_matrix_transpose,
        DATA_IN   => data_in_matrix_transpose,
        DATA_OUT  => data_out_matrix_transpose
        );
  end generate ntm_matrix_transpose_test;

  -- SCALAR PRODUCT
  ntm_scalar_product_test : if (ENABLE_NTM_SCALAR_PRODUCT_TEST) generate
    scalar_product : ntm_scalar_product
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_product,
        READY => ready_scalar_product,

        DATA_A_IN_ENABLE => data_a_in_enable_scalar_product,
        DATA_B_IN_ENABLE => data_b_in_enable_scalar_product,

        DATA_OUT_ENABLE => data_out_enable_scalar_product,

        -- DATA
        LENGTH_IN => length_in_scalar_product,
        DATA_A_IN => data_a_in_scalar_product,
        DATA_B_IN => data_b_in_scalar_product,
        DATA_OUT  => data_out_scalar_product
        );
  end generate ntm_scalar_product_test;

  -- SCALAR TRANSPOSE
  ntm_scalar_transpose_test : if (ENABLE_NTM_SCALAR_TRANSPOSE_TEST) generate
    scalar_transpose : ntm_scalar_transpose
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_transpose,
        READY => ready_scalar_transpose,

        DATA_IN_ENABLE => data_in_enable_scalar_transpose,

        DATA_ENABLE => data_enable_scalar_transpose,

        DATA_OUT_ENABLE => data_out_enable_scalar_transpose,

        -- DATA
        LENGTH_IN => length_in_scalar_transpose,
        DATA_IN   => data_in_scalar_transpose,
        DATA_OUT  => data_out_scalar_transpose
        );
  end generate ntm_scalar_transpose_test;

  -- TENSOR PRODUCT
  ntm_tensor_product_test : if (ENABLE_NTM_TENSOR_PRODUCT_TEST) generate
    tensor_product : ntm_tensor_product
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_product,
        READY => ready_tensor_product,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_product,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_product,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_product,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_product,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_product,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_product,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_product,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_product,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_product,

        -- DATA
        SIZE_A_I_IN => size_a_i_in_tensor_product,
        SIZE_A_J_IN => size_a_j_in_tensor_product,
        SIZE_A_K_IN => size_a_k_in_tensor_product,
        SIZE_B_I_IN => size_b_i_in_tensor_product,
        SIZE_B_J_IN => size_b_j_in_tensor_product,
        SIZE_B_K_IN => size_b_k_in_tensor_product,
        DATA_A_IN   => data_a_in_tensor_product,
        DATA_B_IN   => data_b_in_tensor_product,
        DATA_OUT    => data_out_tensor_product
        );
  end generate ntm_tensor_product_test;

  -- TENSOR TRANSPOSE
  ntm_tensor_transpose_test : if (ENABLE_NTM_TENSOR_PRODUCT_TEST) generate
    tensor_transpose : ntm_tensor_transpose
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_transpose,
        READY => ready_tensor_transpose,

        DATA_IN_I_ENABLE => data_in_i_enable_tensor_transpose,
        DATA_IN_J_ENABLE => data_in_j_enable_tensor_transpose,
        DATA_IN_K_ENABLE => data_in_k_enable_tensor_transpose,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_transpose,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_transpose,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_transpose,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_transpose,
        SIZE_J_IN => size_j_in_tensor_transpose,
        SIZE_K_IN => size_k_in_tensor_transpose,
        DATA_IN   => data_in_tensor_transpose,
        DATA_OUT  => data_out_tensor_transpose
        );
  end generate ntm_tensor_transpose_test;

end ntm_algebra_testbench_architecture;
