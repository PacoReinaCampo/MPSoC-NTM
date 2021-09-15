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
    DATA_SIZE : integer := 512;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    ENABLE_NTM_MATRIX_DETERMINANT_TEST : boolean := false;
    ENABLE_NTM_MATRIX_INVERSION_TEST   : boolean := false;
    ENABLE_NTM_MATRIX_PRODUCT_TEST     : boolean := false;
    ENABLE_NTM_MATRIX_RANK_TEST        : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_TEST   : boolean := false;
    ENABLE_NTM_SCALAR_PRODUCT_TEST     : boolean := false;
    ENABLE_NTM_VECTOR_PRODUCT_TEST     : boolean := false;

    ENABLE_NTM_MATRIX_DETERMINANT_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_INVERSION_CASE_0   : boolean := false;
    ENABLE_NTM_MATRIX_PRODUCT_CASE_0     : boolean := false;
    ENABLE_NTM_MATRIX_RANK_CASE_0        : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_CASE_0   : boolean := false;
    ENABLE_NTM_SCALAR_PRODUCT_CASE_0     : boolean := false;
    ENABLE_NTM_VECTOR_PRODUCT_CASE_0     : boolean := false;

    ENABLE_NTM_MATRIX_DETERMINANT_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_INVERSION_CASE_1   : boolean := false;
    ENABLE_NTM_MATRIX_PRODUCT_CASE_1     : boolean := false;
    ENABLE_NTM_MATRIX_RANK_CASE_1        : boolean := false;
    ENABLE_NTM_MATRIX_TRANSPOSE_CASE_1   : boolean := false;
    ENABLE_NTM_SCALAR_PRODUCT_CASE_1     : boolean := false;
    ENABLE_NTM_VECTOR_PRODUCT_CASE_1     : boolean := false
    );
end ntm_algebra_testbench;

architecture ntm_algebra_testbench_architecture of ntm_algebra_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- MATRIX DETERMINANT
  -- CONTROL
  signal start_matrix_determinant : std_logic;
  signal ready_matrix_determinant : std_logic;

  signal data_in_i_enable_matrix_determinant : std_logic;
  signal data_in_j_enable_matrix_determinant : std_logic;

  signal data_out_i_enable_matrix_determinant : std_logic;
  signal data_out_j_enable_matrix_determinant : std_logic;

  -- DATA
  signal modulo_in_matrix_determinant : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_determinant   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_determinant  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INVERSION
  -- CONTROL
  signal start_matrix_inversion : std_logic;
  signal ready_matrix_inversion : std_logic;

  signal data_in_i_enable_matrix_inversion : std_logic;
  signal data_in_j_enable_matrix_inversion : std_logic;

  signal data_out_i_enable_matrix_inversion : std_logic;
  signal data_out_j_enable_matrix_inversion : std_logic;

  -- DATA
  signal modulo_in_matrix_inversion : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_inversion   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inversion  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal modulo_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_i_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX RANK
  -- CONTROL
  signal start_matrix_rank : std_logic;
  signal ready_matrix_rank : std_logic;

  signal data_in_i_enable_matrix_rank : std_logic;
  signal data_in_j_enable_matrix_rank : std_logic;

  signal data_out_i_enable_matrix_rank : std_logic;
  signal data_out_j_enable_matrix_rank : std_logic;

  -- DATA
  signal modulo_in_matrix_rank : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_rank   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_rank  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TRANSPOSE
  -- CONTROL
  signal start_matrix_transpose : std_logic;
  signal ready_matrix_transpose : std_logic;

  signal data_in_i_enable_matrix_transpose : std_logic;
  signal data_in_j_enable_matrix_transpose : std_logic;

  signal data_out_i_enable_matrix_transpose : std_logic;
  signal data_out_j_enable_matrix_transpose : std_logic;

  -- DATA
  signal modulo_in_matrix_transpose : std_logic_vector(DATA_SIZE-1 downto 0);
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
  signal modulo_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR PRODUCT
  -- CONTROL
  signal start_vector_product : std_logic;
  signal ready_vector_product : std_logic;

  signal data_a_in_enable_vector_product : std_logic;
  signal data_b_in_enable_vector_product : std_logic;

  signal data_out_enable_vector_product : std_logic;

  -- DATA
  signal modulo_in_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_product  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  algebra_stimulus : ntm_algebra_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE => DATA_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R,

      -- FUNCTIONALITY
      STIMULUS_NTM_MATRIX_DETERMINANT_TEST => STIMULUS_NTM_MATRIX_DETERMINANT_TEST,
      STIMULUS_NTM_MATRIX_INVERSION_TEST   => STIMULUS_NTM_MATRIX_INVERSION_TEST,
      STIMULUS_NTM_MATRIX_PRODUCT_TEST     => STIMULUS_NTM_MATRIX_PRODUCT_TEST,
      STIMULUS_NTM_MATRIX_RANK_TEST        => STIMULUS_NTM_MATRIX_DETERMINANT_TEST,
      STIMULUS_NTM_MATRIX_TRANSPOSE_TEST   => STIMULUS_NTM_MATRIX_RANK_TEST,
      STIMULUS_NTM_SCALAR_PRODUCT_TEST     => STIMULUS_NTM_SCALAR_PRODUCT_TEST,
      STIMULUS_NTM_VECTOR_PRODUCT_TEST     => STIMULUS_NTM_VECTOR_PRODUCT_TEST,

      STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0 => STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0,
      STIMULUS_NTM_MATRIX_INVERSION_CASE_0   => STIMULUS_NTM_MATRIX_INVERSION_CASE_0,
      STIMULUS_NTM_MATRIX_PRODUCT_CASE_0     => STIMULUS_NTM_MATRIX_PRODUCT_CASE_0,
      STIMULUS_NTM_MATRIX_RANK_CASE_0        => STIMULUS_NTM_MATRIX_RANK_CASE_0,
      STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0   => STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0,
      STIMULUS_NTM_SCALAR_PRODUCT_CASE_0     => STIMULUS_NTM_SCALAR_PRODUCT_CASE_0,
      STIMULUS_NTM_VECTOR_PRODUCT_CASE_0     => STIMULUS_NTM_VECTOR_PRODUCT_CASE_0,

      STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1 => STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1,
      STIMULUS_NTM_MATRIX_INVERSION_CASE_1   => STIMULUS_NTM_MATRIX_INVERSION_CASE_1,
      STIMULUS_NTM_MATRIX_PRODUCT_CASE_1     => STIMULUS_NTM_MATRIX_PRODUCT_CASE_1,
      STIMULUS_NTM_MATRIX_RANK_CASE_1        => STIMULUS_NTM_MATRIX_RANK_CASE_1,
      STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1   => STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1,
      STIMULUS_NTM_SCALAR_PRODUCT_CASE_1     => STIMULUS_NTM_SCALAR_PRODUCT_CASE_1,
      STIMULUS_NTM_VECTOR_PRODUCT_CASE_1     => STIMULUS_NTM_VECTOR_PRODUCT_CASE_1
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- MATRIX DETERMINANT
      -- CONTROL
      MATRIX_DETERMINANT_START => start_matrix_determinant,
      MATRIX_DETERMINANT_READY => ready_matrix_determinant,

      MATRIX_DETERMINANT_DATA_IN_I_ENABLE => data_in_i_enable_matrix_determinant,
      MATRIX_DETERMINANT_DATA_IN_J_ENABLE => data_in_j_enable_matrix_determinant,

      MATRIX_DETERMINANT_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_determinant,
      MATRIX_DETERMINANT_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_determinant,

      -- DATA
      MATRIX_DETERMINANT_MODULO_IN => modulo_in_matrix_determinant,
      MATRIX_DETERMINANT_DATA_IN   => data_in_matrix_determinant,
      MATRIX_DETERMINANT_DATA_OUT  => data_out_matrix_determinant,

      -- MATRIX INVERSION
      -- CONTROL
      MATRIX_INVERSION_START => start_matrix_inversion,
      MATRIX_INVERSION_READY => ready_matrix_inversion,

      MATRIX_INVERSION_DATA_IN_I_ENABLE => data_in_i_enable_matrix_inversion,
      MATRIX_INVERSION_DATA_IN_J_ENABLE => data_in_j_enable_matrix_inversion,

      MATRIX_INVERSION_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inversion,
      MATRIX_INVERSION_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inversion,

      -- DATA
      MATRIX_INVERSION_MODULO_IN => modulo_in_matrix_inversion,
      MATRIX_INVERSION_DATA_IN   => data_in_matrix_inversion,
      MATRIX_INVERSION_DATA_OUT  => data_out_matrix_inversion,

      -- MATRIX PRODUCT
      -- CONTROL
      MATRIX_PRODUCT_START => start_matrix_product,
      MATRIX_PRODUCT_READY => ready_matrix_product,

      MATRIX_PRODUCT_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      MATRIX_PRODUCT_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      MATRIX_PRODUCT_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      MATRIX_PRODUCT_MODULO_IN   => modulo_in_matrix_product,
      MATRIX_PRODUCT_SIZE_A_I_IN => size_a_i_in_matrix_product,
      MATRIX_PRODUCT_SIZE_A_J_IN => size_a_j_in_matrix_product,
      MATRIX_PRODUCT_SIZE_B_I_IN => size_b_i_in_matrix_product,
      MATRIX_PRODUCT_SIZE_B_J_IN => size_b_j_in_matrix_product,
      MATRIX_PRODUCT_DATA_A_IN   => data_a_in_matrix_product,
      MATRIX_PRODUCT_DATA_B_IN   => data_b_in_matrix_product,
      MATRIX_PRODUCT_DATA_OUT    => data_out_matrix_product,

      -- MATRIX RANK
      -- CONTROL
      MATRIX_RANK_START => start_matrix_rank,
      MATRIX_RANK_READY => ready_matrix_rank,

      MATRIX_RANK_DATA_IN_I_ENABLE => data_in_i_enable_matrix_rank,
      MATRIX_RANK_DATA_IN_J_ENABLE => data_in_j_enable_matrix_rank,

      MATRIX_RANK_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_rank,
      MATRIX_RANK_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_rank,

      -- DATA
      MATRIX_RANK_MODULO_IN => modulo_in_matrix_rank,
      MATRIX_RANK_DATA_IN   => data_in_matrix_rank,
      MATRIX_RANK_DATA_OUT  => data_out_matrix_rank,

      -- MATRIX TRANSPOSE
      -- CONTROL
      MATRIX_TRANSPOSE_START => start_matrix_transpose,
      MATRIX_TRANSPOSE_READY => ready_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_IN_I_ENABLE => data_in_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_IN_J_ENABLE => data_in_j_enable_matrix_transpose,

      MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
      MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

      -- DATA
      MATRIX_TRANSPOSE_MODULO_IN => modulo_in_matrix_transpose,
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
      SCALAR_PRODUCT_MODULO_IN => modulo_in_scalar_product,
      SCALAR_PRODUCT_LENGTH_IN => length_in_scalar_product,
      SCALAR_PRODUCT_DATA_A_IN => data_a_in_scalar_product,
      SCALAR_PRODUCT_DATA_B_IN => data_b_in_matrix_product,
      SCALAR_PRODUCT_DATA_OUT  => data_out_matrix_product,

      -- VECTOR PRODUCT
      -- CONTROL
      VECTOR_PRODUCT_START => start_vector_product,
      VECTOR_PRODUCT_READY => ready_vector_product,

      VECTOR_PRODUCT_DATA_A_IN_ENABLE => data_a_in_enable_vector_product,
      VECTOR_PRODUCT_DATA_B_IN_ENABLE => data_b_in_enable_vector_product,

      VECTOR_PRODUCT_DATA_OUT_ENABLE => data_out_enable_vector_product,

      -- DATA
      VECTOR_PRODUCT_MODULO_IN => modulo_in_vector_product,
      VECTOR_PRODUCT_DATA_A_IN => data_a_in_vector_product,
      VECTOR_PRODUCT_DATA_B_IN => data_b_in_vector_product,
      VECTOR_PRODUCT_DATA_OUT  => data_out_vector_product
      );

  -- MATRIX DETERMINANT
  ntm_matrix_determinant_test : if (ENABLE_NTM_MATRIX_DETERMINANT_TEST) generate
    matrix_determinant : ntm_matrix_determinant
      generic map (
        DATA_SIZE => DATA_SIZE,

        SIZE_I => SIZE_I,
        SIZE_J => SIZE_J
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_determinant,
        READY => ready_matrix_determinant,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_determinant,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_determinant,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_determinant,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_determinant,

        -- DATA
        MODULO_IN => modulo_in_matrix_determinant,
        DATA_IN   => data_in_matrix_determinant,
        DATA_OUT  => data_out_matrix_determinant
        );
  end generate ntm_matrix_determinant_test;

  -- MATRIX INVERSION
  ntm_matrix_inversion_test : if (ENABLE_NTM_MATRIX_INVERSION_TEST) generate
    matrix_inversion : ntm_matrix_inversion
      generic map (
        DATA_SIZE => DATA_SIZE,

        SIZE_I => SIZE_I,
        SIZE_J => SIZE_J
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_inversion,
        READY => ready_matrix_inversion,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_inversion,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_inversion,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inversion,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inversion,

        -- DATA
        MODULO_IN => modulo_in_matrix_inversion,
        DATA_IN   => data_in_matrix_inversion,
        DATA_OUT  => data_out_matrix_inversion
        );
  end generate ntm_matrix_inversion_test;

  -- MATRIX PRODUCT
  ntm_matrix_product_test : if (ENABLE_NTM_MATRIX_PRODUCT_TEST) generate
    matrix_product : ntm_matrix_product
      generic map (
        DATA_SIZE => DATA_SIZE
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

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

        -- DATA
        MODULO_IN   => modulo_in_matrix_product,
        SIZE_A_I_IN => size_a_i_in_matrix_product,
        SIZE_A_J_IN => size_a_j_in_matrix_product,
        SIZE_B_I_IN => size_b_i_in_matrix_product,
        SIZE_B_J_IN => size_b_j_in_matrix_product,
        DATA_A_IN   => data_a_in_matrix_product,
        DATA_B_IN   => data_b_in_matrix_product,
        DATA_OUT    => data_out_matrix_product
        );
  end generate ntm_matrix_product_test;

  -- MATRIX RANK
  ntm_matrix_rank_test : if (ENABLE_NTM_MATRIX_RANK_TEST) generate
    matrix_rank : ntm_matrix_rank
      generic map (
        DATA_SIZE => DATA_SIZE,

        SIZE_I => SIZE_I,
        SIZE_J => SIZE_J
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_rank,
        READY => ready_matrix_rank,

        DATA_IN_I_ENABLE => data_in_i_enable_matrix_rank,
        DATA_IN_J_ENABLE => data_in_j_enable_matrix_rank,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_rank,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_rank,

        -- DATA
        MODULO_IN => modulo_in_matrix_rank,
        DATA_IN   => data_in_matrix_rank,
        DATA_OUT  => data_out_matrix_rank
        );
  end generate ntm_matrix_rank_test;

  -- MATRIX TRANSPOSE
  ntm_matrix_transpose_test : if (ENABLE_NTM_MATRIX_TRANSPOSE_TEST) generate
    matrix_transpose : ntm_matrix_transpose
      generic map (
        DATA_SIZE => DATA_SIZE,

        SIZE_I => SIZE_I,
        SIZE_J => SIZE_J
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

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_transpose,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_transpose,

        -- DATA
        MODULO_IN => modulo_in_matrix_transpose,
        DATA_IN   => data_in_matrix_transpose,
        DATA_OUT  => data_out_matrix_transpose
        );
  end generate ntm_matrix_transpose_test;

  -- SCALAR PRODUCT
  ntm_scalar_product_test : if (ENABLE_NTM_SCALAR_PRODUCT_TEST) generate
    scalar_product : ntm_scalar_product
      generic map (
        DATA_SIZE => DATA_SIZE
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
        MODULO_IN => modulo_in_scalar_product,
        LENGTH_IN => length_in_scalar_product,
        DATA_A_IN => data_a_in_scalar_product,
        DATA_B_IN => data_b_in_scalar_product,
        DATA_OUT  => data_out_scalar_product
        );
  end generate ntm_scalar_product_test;

  -- VECTOR PRODUCT
  ntm_vector_product_test : if (ENABLE_NTM_VECTOR_PRODUCT_TEST) generate
    vector_product : ntm_vector_product
      generic map (
        DATA_SIZE => DATA_SIZE,

        SIZE => SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_product,
        READY => ready_vector_product,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_product,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_product,

        DATA_OUT_ENABLE => data_out_enable_vector_product,

        -- DATA
        MODULO_IN => modulo_in_vector_product,
        DATA_A_IN => data_a_in_vector_product,
        DATA_B_IN => data_b_in_vector_product,
        DATA_OUT  => data_out_vector_product
        );
  end generate ntm_vector_product_test;

end ntm_algebra_testbench_architecture;
