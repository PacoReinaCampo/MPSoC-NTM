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
use work.ntm_function_pkg.all;

entity ntm_function_testbench is
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
    ENABLE_NTM_SCALAR_DIFFERENTIATION_TEST   : boolean := false;

    ENABLE_NTM_SCALAR_DIFFERENTIATION_CASE_0   : boolean := false;

    ENABLE_NTM_SCALAR_DIFFERENTIATION_CASE_1   : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST   : boolean := false;

    ENABLE_NTM_VECTOR_DIFFERENTIATION_CASE_0   : boolean := false;

    ENABLE_NTM_VECTOR_DIFFERENTIATION_CASE_1   : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST   : boolean := false;

    ENABLE_NTM_MATRIX_DIFFERENTIATION_CASE_0   : boolean := false;

    ENABLE_NTM_MATRIX_DIFFERENTIATION_CASE_1   : boolean := false
    );
end ntm_function_testbench;

architecture ntm_function_testbench_architecture of ntm_function_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR DIFFERENTIATION
  -- CONTROL
  signal start_scalar_differentiation : std_logic;
  signal ready_scalar_differentiation : std_logic;

  signal data_in_enable_scalar_differentiation  : std_logic;
  signal data_out_enable_scalar_differentiation : std_logic;

  -- DATA
  signal size_in_scalar_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal period_in_scalar_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_scalar_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_scalar_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR DIFFERENTIATION
  -- CONTROL
  signal start_vector_differentiation : std_logic;
  signal ready_vector_differentiation : std_logic;

  signal data_in_vector_enable_vector_differentiation : std_logic;
  signal data_in_scalar_enable_vector_differentiation : std_logic;

  signal data_out_vector_enable_vector_differentiation : std_logic;
  signal data_out_scalar_enable_vector_differentiation : std_logic;

  -- DATA
  signal size_in_vector_differentiation   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal period_in_vector_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX DIFFERENTIATION
  -- CONTROL
  signal start_matrix_differentiation : std_logic;
  signal ready_matrix_differentiation : std_logic;

  signal data_in_matrix_enable_matrix_differentiation : std_logic;
  signal data_in_vector_enable_matrix_differentiation : std_logic;
  signal data_in_scalar_enable_matrix_differentiation : std_logic;

  signal data_out_matrix_enable_matrix_differentiation : std_logic;
  signal data_out_vector_enable_matrix_differentiation : std_logic;
  signal data_out_scalar_enable_matrix_differentiation : std_logic;

  -- DATA
  signal size_i_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal period_in_matrix_differentiation : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_differentiation : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_matrix_differentiation   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_differentiation  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  function_stimulus : ntm_function_stimulus
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

      -----------------------------------------------------------------------
      -- STIMULUS SCALAR
      -----------------------------------------------------------------------

      -- SCALAR DIFFERENTIATION
      -- CONTROL
      SCALAR_DIFFERENTIATION_START => start_scalar_differentiation,
      SCALAR_DIFFERENTIATION_READY => ready_scalar_differentiation,

      SCALAR_DIFFERENTIATION_DATA_IN_ENABLE => data_in_enable_scalar_differentiation,

      SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE => data_out_enable_scalar_differentiation,

      -- DATA
      SCALAR_DIFFERENTIATION_PERIOD_IN => period_in_scalar_differentiation,
      SCALAR_DIFFERENTIATION_LENGTH_IN => length_in_scalar_differentiation,
      SCALAR_DIFFERENTIATION_DATA_IN   => data_in_scalar_differentiation,
      SCALAR_DIFFERENTIATION_DATA_OUT  => data_out_scalar_differentiation,

      -----------------------------------------------------------------------
      -- STIMULUS VECTOR
      -----------------------------------------------------------------------

      -- VECTOR DIFFERENTIATION
      -- CONTROL
      VECTOR_DIFFERENTIATION_START => start_vector_differentiation,
      VECTOR_DIFFERENTIATION_READY => ready_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_differentiation,

      VECTOR_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_differentiation,

      -- DATA
      VECTOR_DIFFERENTIATION_SIZE_IN   => size_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_LENGTH_IN => length_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_IN   => data_in_vector_differentiation,
      VECTOR_DIFFERENTIATION_DATA_OUT  => data_out_vector_differentiation,

      -----------------------------------------------------------------------
      -- STIMULUS MATRIX
      -----------------------------------------------------------------------

      -- MATRIX DIFFERENTIATION
      -- CONTROL
      MATRIX_DIFFERENTIATION_START => start_matrix_differentiation,
      MATRIX_DIFFERENTIATION_READY => ready_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_differentiation,

      MATRIX_DIFFERENTIATION_DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_differentiation,

      -- DATA
      MATRIX_DIFFERENTIATION_SIZE_I_IN => size_i_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_SIZE_J_IN => size_j_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_PERIOD_IN => period_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_LENGTH_IN => length_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_IN   => data_in_matrix_differentiation,
      MATRIX_DIFFERENTIATION_DATA_OUT  => data_out_matrix_differentiation
      );

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR DIFFERENTIATION
  ntm_scalar_differentiation_test : if (ENABLE_NTM_SCALAR_DIFFERENTIATION_TEST) generate
    scalar_differentiation : ntm_scalar_differentiation
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_differentiation,
        READY => ready_scalar_differentiation,

        DATA_IN_ENABLE => data_in_enable_scalar_differentiation,

        DATA_OUT_ENABLE => data_out_enable_scalar_differentiation,

        -- DATA
        PERIOD_IN => period_in_scalar_differentiation,
        LENGTH_IN => length_in_scalar_differentiation,
        DATA_IN   => data_in_scalar_differentiation,
        DATA_OUT  => data_out_scalar_differentiation
        );
  end generate ntm_scalar_differentiation_test;

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR DIFFERENTIATION
  ntm_vector_differentiation_test : if (ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST) generate
    vector_differentiation : ntm_vector_differentiation
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

        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_differentiation,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_differentiation,

        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_differentiation,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_differentiation,

        -- DATA
        SIZE_IN   => size_in_vector_differentiation,
        PERIOD_IN => period_in_vector_differentiation,
        LENGTH_IN => length_in_vector_differentiation,
        DATA_IN   => data_in_vector_differentiation,
        DATA_OUT  => data_out_vector_differentiation
        );
  end generate ntm_vector_differentiation_test;

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

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

        DATA_IN_MATRIX_ENABLE => data_in_matrix_enable_matrix_differentiation,
        DATA_IN_VECTOR_ENABLE => data_in_vector_enable_matrix_differentiation,
        DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_matrix_differentiation,

        DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_differentiation,
        DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_differentiation,
        DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_differentiation,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_differentiation,
        SIZE_J_IN => size_j_in_matrix_differentiation,
        PERIOD_IN => period_in_matrix_differentiation,
        LENGTH_IN => length_in_matrix_differentiation,
        DATA_IN   => data_in_matrix_differentiation,
        DATA_OUT  => data_out_matrix_differentiation
        );
  end generate ntm_matrix_differentiation_test;

end ntm_function_testbench_architecture;
