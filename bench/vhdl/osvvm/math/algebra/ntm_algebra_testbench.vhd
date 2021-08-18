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

use work.ntm_pkg.all;

entity ntm_algebra_testbench is
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

  -- DATA
  signal modulo_matrix_determinant   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_determinant  : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_determinant : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INVERSION
  -- CONTROL
  signal start_matrix_inversion : std_logic;
  signal ready_matrix_inversion : std_logic;

  -- DATA
  signal modulo_matrix_inversion   : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_in_matrix_inversion  : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inversion : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  -- DATA
  signal modulo_matrix_product    : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_product : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product  : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  
  -- MATRIX RANK
  -- CONTROL
  signal start_matrix_rank : std_logic;
  signal ready_matrix_rank : std_logic;

  -- DATA
  signal modulo_matrix_rank   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_rank  : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_rank : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX TRANSPOSE
  -- CONTROL
  signal start_matrix_transpose : std_logic;
  signal ready_matrix_transpose : std_logic;

  -- DATA
  signal modulo_matrix_transpose   : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_in_matrix_transpose  : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_matrix_transpose : std_logic_arithmetic_vector_matrix(X-1 downto 0)(Y-1 downto 0)(DATA_SIZE-1 downto 0);

  -- SCALAR PRODUCT
  -- CONTROL
  signal start_scalar_product : std_logic;
  signal ready_scalar_product : std_logic;

  -- DATA
  signal modulo_scalar_product    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_product : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_product : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_scalar_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR PRODUCT
  -- CONTROL
  signal start_vector_product : std_logic;
  signal ready_vector_product : std_logic;

  -- DATA
  signal modulo_vector_product    : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_product : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_product : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal data_out_vector_product  : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- MATRIX DETERMINANT
  matrix_determinant : ntm_matrix_determinant
    generic map (
      X => X,
      Y => Y,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_determinant,
      READY => ready_matrix_determinant,

      -- DATA
      MODULO   => modulo_matrix_determinant,
      DATA_IN  => data_in_matrix_determinant,
      DATA_OUT => data_out_matrix_determinant
    );

  -- MATRIX INVERSION
  matrix_inversion : ntm_matrix_inversion
    generic map (
      X => X,
      Y => Y,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_inversion,
      READY => ready_matrix_inversion,

      -- DATA
      MODULO   => modulo_matrix_inversion,
      DATA_IN  => data_in_matrix_inversion,
      DATA_OUT => data_out_matrix_inversion
    );

  -- MATRIX RANK
  matrix_rank : ntm_matrix_rank
    generic map (
      X => X,
      Y => Y,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_rank,
      READY => ready_matrix_rank,

      -- DATA
      MODULO   => modulo_matrix_rank,
      DATA_IN  => data_in_matrix_rank,
      DATA_OUT => data_out_matrix_rank
    );

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      X => X,
      Y => Y,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_product,
      READY => ready_matrix_product,

      -- DATA
      MODULO    => modulo_matrix_product,
      DATA_A_IN => data_a_in_matrix_product,
      DATA_B_IN => data_b_in_matrix_product,
      DATA_OUT  => data_out_matrix_product
    );

  -- MATRIX TRANSPOSE
  matrix_transpose : ntm_matrix_transpose
    generic map (
      X => X,
      Y => Y,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_transpose,
      READY => ready_matrix_transpose,

      -- DATA
      MODULO   => modulo_matrix_transpose,
      DATA_IN  => data_in_matrix_transpose,
      DATA_OUT => data_out_matrix_transpose
    );

  -- SCALAR PRODUCT
  scalar_product : ntm_scalar_product
    generic map (
      X => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_product,
      READY => ready_scalar_product,

      -- DATA
      MODULO    => modulo_scalar_product,
      DATA_A_IN => data_a_in_scalar_product,
      DATA_B_IN => data_b_in_scalar_product,
      DATA_OUT  => data_out_scalar_product
    );

  -- VECTOR PRODUCT
  vector_product : ntm_vector_product
    generic map (
      X => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_product,
      READY => ready_vector_product,

      -- DATA
      MODULO    => modulo_vector_product,
      DATA_A_IN => data_a_in_vector_product,
      DATA_B_IN => data_b_in_vector_product,
      DATA_OUT  => data_out_vector_product
    );

end ntm_algebra_testbench_architecture;