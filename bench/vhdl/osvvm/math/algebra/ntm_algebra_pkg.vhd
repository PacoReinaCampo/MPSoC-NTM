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

package ntm_algebra_pkg is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 512;

  constant SIZE_I : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));
  constant SIZE_J : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));

  constant SIZE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));

  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

  -- FUNCTIONALITY
  constant STIMULUS_NTM_MATRIX_DETERMINANT_TEST : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERSION_TEST   : boolean := false;
  constant STIMULUS_NTM_MATRIX_PRODUCT_TEST     : boolean := false;
  constant STIMULUS_NTM_MATRIX_RANK_TEST        : boolean := false;
  constant STIMULUS_NTM_MATRIX_TRANSPOSE_TEST   : boolean := false;
  constant STIMULUS_NTM_SCALAR_PRODUCT_TEST     : boolean := false;
  constant STIMULUS_NTM_VECTOR_PRODUCT_TEST     : boolean := false;

  constant STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0 : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERSION_CASE_0   : boolean := false;
  constant STIMULUS_NTM_MATRIX_PRODUCT_CASE_0     : boolean := false;
  constant STIMULUS_NTM_MATRIX_RANK_CASE_0        : boolean := false;
  constant STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0   : boolean := false;
  constant STIMULUS_NTM_SCALAR_PRODUCT_CASE_0     : boolean := false;
  constant STIMULUS_NTM_VECTOR_PRODUCT_CASE_0     : boolean := false;

  constant STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1 : boolean := false;
  constant STIMULUS_NTM_MATRIX_INVERSION_CASE_1   : boolean := false;
  constant STIMULUS_NTM_MATRIX_PRODUCT_CASE_1     : boolean := false;
  constant STIMULUS_NTM_MATRIX_RANK_CASE_1        : boolean := false;
  constant STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1   : boolean := false;
  constant STIMULUS_NTM_SCALAR_PRODUCT_CASE_1     : boolean := false;
  constant STIMULUS_NTM_VECTOR_PRODUCT_CASE_1     : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_algebra_stimulus is
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
      STIMULUS_NTM_MATRIX_DETERMINANT_TEST : boolean := false;
      STIMULUS_NTM_MATRIX_INVERSION_TEST   : boolean := false;
      STIMULUS_NTM_MATRIX_PRODUCT_TEST     : boolean := false;
      STIMULUS_NTM_MATRIX_RANK_TEST        : boolean := false;
      STIMULUS_NTM_MATRIX_TRANSPOSE_TEST   : boolean := false;
      STIMULUS_NTM_SCALAR_PRODUCT_TEST     : boolean := false;
      STIMULUS_NTM_VECTOR_PRODUCT_TEST     : boolean := false;

      STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0 : boolean := false;
      STIMULUS_NTM_MATRIX_INVERSION_CASE_0   : boolean := false;
      STIMULUS_NTM_MATRIX_PRODUCT_CASE_0     : boolean := false;
      STIMULUS_NTM_MATRIX_RANK_CASE_0        : boolean := false;
      STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0   : boolean := false;
      STIMULUS_NTM_SCALAR_PRODUCT_CASE_0     : boolean := false;
      STIMULUS_NTM_VECTOR_PRODUCT_CASE_0     : boolean := false;

      STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1 : boolean := false;
      STIMULUS_NTM_MATRIX_INVERSION_CASE_1   : boolean := false;
      STIMULUS_NTM_MATRIX_PRODUCT_CASE_1     : boolean := false;
      STIMULUS_NTM_MATRIX_RANK_CASE_1        : boolean := false;
      STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1   : boolean := false;
      STIMULUS_NTM_SCALAR_PRODUCT_CASE_1     : boolean := false;
      STIMULUS_NTM_VECTOR_PRODUCT_CASE_1     : boolean := false
      );
    port (
      -- GLOBAL
      CLK : out std_logic;
      RST : out std_logic;

      -- MATRIX DETERMINANT
      -- CONTROL
      MATRIX_DETERMINANT_START : out std_logic;
      MATRIX_DETERMINANT_READY : in  std_logic;

      MATRIX_DETERMINANT_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_DETERMINANT_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_DETERMINANT_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_DETERMINANT_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_DETERMINANT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DETERMINANT_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_DETERMINANT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX INVERSION
      -- CONTROL
      MATRIX_INVERSION_START : out std_logic;
      MATRIX_INVERSION_READY : in  std_logic;

      MATRIX_INVERSION_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_INVERSION_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_INVERSION_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_INVERSION_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_INVERSION_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERSION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_INVERSION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX PRODUCT
      -- CONTROL
      MATRIX_PRODUCT_START : out std_logic;
      MATRIX_PRODUCT_READY : in  std_logic;

      MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
      MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

      MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_PRODUCT_MODULO_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX RANK
      -- CONTROL
      MATRIX_RANK_START : out std_logic;
      MATRIX_RANK_READY : in  std_logic;

      MATRIX_RANK_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_RANK_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_RANK_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_RANK_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_RANK_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_RANK_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_RANK_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- MATRIX TRANSPOSE
      -- CONTROL
      MATRIX_TRANSPOSE_START : out std_logic;
      MATRIX_TRANSPOSE_READY : in  std_logic;

      MATRIX_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
      MATRIX_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;

      MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
      MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;

      -- DATA
      MATRIX_TRANSPOSE_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      MATRIX_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- SCALAR PRODUCT
      -- CONTROL
      SCALAR_PRODUCT_START : out std_logic;
      SCALAR_PRODUCT_READY : in  std_logic;

      SCALAR_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
      SCALAR_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

      SCALAR_PRODUCT_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      SCALAR_PRODUCT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_PRODUCT_LENGTH_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      SCALAR_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

      -- VECTOR PRODUCT
      -- CONTROL
      VECTOR_PRODUCT_START : out std_logic;
      VECTOR_PRODUCT_READY : in  std_logic;

      VECTOR_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
      VECTOR_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

      VECTOR_PRODUCT_DATA_OUT_ENABLE : in std_logic;

      -- DATA
      VECTOR_PRODUCT_MODULO_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      VECTOR_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_algebra_pkg;