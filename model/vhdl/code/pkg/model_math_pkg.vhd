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

use ieee.math_real.all;
use ieee.fixed_pkg.all;
use ieee.float_pkg.all;

use work.model_arithmetic_pkg.all;

package model_math_pkg is

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- MATH - ALGEBRA
  ------------------------------------------------------------------------------

  -- VECTOR
  component model_dot_product is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_convolution is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_cosine_similarity is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_multiplication is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_LENGTH_ENABLE : in std_logic;
      DATA_IN_ENABLE        : in std_logic;

      DATA_LENGTH_ENABLE : out std_logic;
      DATA_ENABLE        : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_summation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_LENGTH_ENABLE : in std_logic;
      DATA_IN_ENABLE        : in std_logic;

      DATA_LENGTH_ENABLE : out std_logic;
      DATA_ENABLE        : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_module is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- MATRIX
  component model_matrix_convolution is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_vector_convolution is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_ENABLE   : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_inverse is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_multiplication is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_LENGTH_ENABLE : in std_logic;
      DATA_IN_I_ENABLE      : in std_logic;
      DATA_IN_J_ENABLE      : in std_logic;

      DATA_LENGTH_ENABLE : out std_logic;
      DATA_I_ENABLE      : out std_logic;
      DATA_J_ENABLE      : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_product is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_vector_product is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_ENABLE   : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_transpose_vector_product is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_summation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_LENGTH_ENABLE : in std_logic;
      DATA_IN_I_ENABLE      : in std_logic;
      DATA_IN_J_ENABLE      : in std_logic;

      DATA_LENGTH_ENABLE : out std_logic;
      DATA_I_ENABLE      : out std_logic;
      DATA_J_ENABLE      : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_transpose is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- TENSOR
  component model_tensor_convolution is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_matrix_convolution is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_inverse is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_product is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_B_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_matrix_product is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_A_IN_K_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_transpose is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- MATH - SERIES
  ------------------------------------------------------------------------------

  -- SCALAR
  component model_scalar_cosh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_exponentiator_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_logarithm_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_power_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_sinh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_sqrt_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_tanh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- VECTOR
  component model_vector_cosh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_exponentiator_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_logarithm_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_power_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_ENABLE : in std_logic;
      DATA_B_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_sinh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_sqrt_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_tanh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- MATRIX
  component model_matrix_cosh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_exponentiator_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_logarithm_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_power_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_A_IN_I_ENABLE : in std_logic;
      DATA_A_IN_J_ENABLE : in std_logic;
      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_sinh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_sqrt_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_tanh_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- MATH - FUNCTION
  ------------------------------------------------------------------------------

  -- SCALAR
  component model_scalar_logistic_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scalar_oneplus_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- VECTOR
  component model_vector_logistic_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_oneplus_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- MATRIX
  component model_matrix_logistic_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_oneplus_function is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- MATH - CALCULUS
  ------------------------------------------------------------------------------

  -- VECTOR
  component model_vector_differentiation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_integration is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_vector_softmax is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_ENABLE : in std_logic;

      DATA_ENABLE : out std_logic;

      DATA_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_IN  : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- MATRIX
  component model_matrix_differentiation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      CONTROL : in std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      LENGTH_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_integration is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_matrix_softmax is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -- TENSOR
  component model_tensor_differentiation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      CONTROL : in std_logic_vector(1 downto 0);

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN   : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_I_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      LENGTH_J_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      LENGTH_K_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN     : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_integration is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      LENGTH_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_tensor_softmax is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_IN_I_ENABLE : in std_logic;
      DATA_IN_J_ENABLE : in std_logic;
      DATA_IN_K_ENABLE : in std_logic;

      DATA_I_ENABLE : out std_logic;
      DATA_J_ENABLE : out std_logic;
      DATA_K_ENABLE : out std_logic;

      DATA_OUT_I_ENABLE : out std_logic;
      DATA_OUT_J_ENABLE : out std_logic;
      DATA_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_J_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in  std_logic_vector(CONTROL_SIZE-1 downto 0);
      DATA_IN   : in  std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- MATH - ALGEBRA
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_summation (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    scalar_input : vector_buffer

    ) return std_logic_vector;

  -- VECTOR
  function function_dot_product (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer;

  function function_vector_convolution (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer;

  function function_vector_cosine_similarity (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer;

  function function_vector_module (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_multiplication (
    SIZE_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : matrix_buffer

    ) return vector_buffer;

  function function_vector_summation (
    SIZE_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : matrix_buffer

    ) return vector_buffer;

  -- MATRIX
  function function_matrix_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_vector_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_matrix_inverse (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_multiplication (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : tensor_buffer

    ) return matrix_buffer;

  function function_matrix_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_vector_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer;

  function function_transpose_vector_product (
    SIZE_A_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return matrix_buffer;

  function function_matrix_summation (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : tensor_buffer

    ) return matrix_buffer;

  function function_matrix_transpose (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  -- TENSOR
  function function_tensor_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer

    ) return tensor_buffer;

  function function_tensor_matrix_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_tensor_inverse (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_input : tensor_buffer

    ) return tensor_buffer;

  function function_tensor_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer

    ) return tensor_buffer;

  function function_tensor_matrix_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer;

  function function_tensor_transpose (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_input : tensor_buffer

    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- MATH - FUNCTION
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_logistic (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_oneplus (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  -- VECTOR
  function function_vector_logistic (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer;

  function function_vector_oneplus (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer;

  -- MATRIX
  function function_matrix_logistic (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_oneplus (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- MATH - CALCULUS
  ------------------------------------------------------------------------------

  -- VECTOR
  function function_vector_differentiation (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer;

  function function_vector_integration (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer;

  function function_vector_softmax (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer;

  -- MATRIX
  function function_matrix_differentiation (
    CONTROL : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_I_IN : std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_J_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_integration (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer;

  function function_matrix_softmax (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer;

  -- TENSOR
  function function_tensor_differentiation (
    CONTROL : std_logic_vector(1 downto 0);

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_I_IN : std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_J_IN : std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_K_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_integration (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer;

  function function_tensor_softmax (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- MATH - SERIES
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_cosh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_exponentiator (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_sqrt (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_power (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_logarithm (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_sinh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  function function_scalar_tanh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector;

  -- VECTOR
  function function_vector_cosh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_exponentiator (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_sqrt (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_power (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer;

  function function_vector_logarithm (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_sinh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  function function_vector_tanh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer;

  -- MATRIX
  function function_matrix_cosh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_exponentiator (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_sqrt (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_power (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_logarithm (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_sinh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  function function_matrix_tanh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer

    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- MATH - STATITICS
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_model_scalar_mean (
    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    scalar_input : vector_buffer
    ) return std_logic_vector;

  function function_model_scalar_deviation (
    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    scalar_input : vector_buffer;
    scalar_mean  : std_logic_vector
    ) return std_logic_vector;

  -- VECTOR
  function function_model_vector_mean (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return vector_buffer;

  function function_model_vector_deviation (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer;
    vector_mean  : vector_buffer
    ) return vector_buffer;

  -- MATRIX
  function function_model_matrix_mean (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return matrix_buffer;

  function function_model_matrix_deviation (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer;
    matrix_mean  : matrix_buffer
    ) return matrix_buffer;

end model_math_pkg;

package body model_math_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- MATH - ALGEBRA
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_summation (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    scalar_input : vector_buffer

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := ZERO_DATA;

    for t in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      scalar_output := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_output,
        scalar_b_input => scalar_input(t)
        );
    end loop;

    return scalar_output;
  end function function_scalar_summation;

  -- VECTOR
  function function_dot_product (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    vector_output := (others => ZERO_DATA);

    for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      scalar_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_a_input(i),
        scalar_b_input => vector_b_input(i)
        );

      vector_output(i) := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_operation_int,
        scalar_b_input => vector_output(i)
        );
    end loop;

    return vector_output;
  end function function_dot_product;

  function function_vector_convolution (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      vector_output(i) := ZERO_DATA;

      for m in 0 to i loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(m),
          scalar_b_input => vector_b_input(i-m)
          );

        vector_output(i) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => scalar_operation_int,
          scalar_b_input => vector_output(i)
          );
      end loop;
    end loop;

    return vector_output;
  end function function_vector_convolution;

  function function_vector_cosine_similarity (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer is

    variable vector_a_int : vector_buffer;
    variable vector_b_int : vector_buffer;

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);
    variable vector_operation_int : vector_buffer;

    variable scalar_vector_int : vector_buffer;

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    vector_operation_int := function_dot_product (
      LENGTH_IN => LENGTH_IN,

      vector_a_input => vector_a_input,
      vector_b_input => vector_b_input
      );

    vector_a_int := function_vector_module (
      LENGTH_IN => LENGTH_IN,

      vector_input => vector_a_input
      );

    vector_b_int := function_vector_module (
      LENGTH_IN => LENGTH_IN,

      vector_input => vector_b_input
      );

    for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      scalar_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_a_int(i),
        scalar_b_input => vector_b_int(i)
        );

      scalar_vector_int(i) := scalar_operation_int;
    end loop;

    vector_output := function_vector_float_divider (
      SIZE_IN => LENGTH_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => scalar_vector_int
      );

    return vector_output;
  end function function_vector_cosine_similarity;

  function function_vector_module (
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer

    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    vector_output := (others => ZERO_DATA);

    for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      scalar_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_input(i),
        scalar_b_input => vector_input(i)
        );

      vector_output(i) := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_operation_int,
        scalar_b_input => vector_output(i)
        );
    end loop;

    for i in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      vector_output(i) := function_scalar_sqrt (
        scalar_input => vector_output(i)
        );
    end loop;

    return vector_output;
  end function function_vector_module;

  function function_vector_multiplication (
    SIZE_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : matrix_buffer

    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := ONE_DATA;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      for t in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
        vector_output(i) := function_scalar_float_multiplier (
          scalar_a_input => vector_output(i),
          scalar_b_input => vector_input(i, t)
          );
      end loop;
    end loop;

    return vector_output;
  end function function_vector_multiplication;

  function function_vector_summation (
    SIZE_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : matrix_buffer

    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    vector_output := (others => ZERO_DATA);

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      for t in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
        vector_output(i) := function_scalar_float_multiplier (
          scalar_a_input => vector_output(i),
          scalar_b_input => vector_input(i, t)
          );
      end loop;
    end loop;

    return vector_output;
  end function function_vector_summation;

  -- MATRIX
  function function_matrix_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
        matrix_output(i, j) := ZERO_DATA;

        for m in 0 to i loop
          for n in 0 to j loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => matrix_a_input(m, n),
              scalar_b_input => matrix_b_input(i-m, j-n)
              );

            matrix_output(i, j) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => matrix_output(i, j)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_convolution;

  function function_matrix_vector_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      vector_output(i) := ZERO_DATA;

      for j in 0 to to_integer(unsigned(SIZE_A_J_IN))-1 loop
        for m in 0 to i loop
          for n in 0 to j loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => matrix_a_input(m, n),
              scalar_b_input => vector_b_input(j-n)
              );

            vector_output(i) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => vector_output(i)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return vector_output;
  end function function_matrix_vector_convolution;

  function function_matrix_inverse (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    type augmented_vector_buffer is array (2*CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
    type augmented_matrix_buffer is array (CONTROL_SIZE-1 downto 0, 2*CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

    variable n : integer;

    variable matrix_output : matrix_buffer;

    variable vector_in_int : augmented_vector_buffer;
    variable matrix_in_int : augmented_matrix_buffer;

    variable scalar_ratio_int : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_sum_int   : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Augmenting Identity Matrix of Order SIZE_IN
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_in_int(i, j) := matrix_input(i, j);

        if (i = j) then
          matrix_in_int(i, j + to_integer(unsigned(SIZE_J_IN))) := ONE_DATA;
        else
          matrix_in_int(i, j + to_integer(unsigned(SIZE_J_IN))) := ZERO_DATA;
        end if;
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      -- Row swapping
      n := 1;

      while (matrix_input(i, i) = ZERO_DATA) loop
        for j in 0 to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
          vector_in_int(j) :=  matrix_in_int(i, j);
        end loop;

        if i < to_integer(unsigned(SIZE_I_IN))-1 then
          for j in 0 to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
            matrix_in_int(i, j) :=  matrix_in_int(i+n, j);
          end loop;

          for j in 0 to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
            matrix_in_int(i+n, j) := vector_in_int(j);
          end loop;
        else
          for j in 0 to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
            matrix_in_int(i, j) :=  matrix_in_int(i-n, j);
          end loop;

          for j in 0 to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
            matrix_in_int(i-n, j) := vector_in_int(j);
          end loop;
        end if;

        n := n + 1;
      end loop;

      -- Applying Gauss Jordan Elimination
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        if (i /= j) then
          scalar_ratio_int := function_scalar_float_divider (
            scalar_a_input => matrix_in_int(j, i),
            scalar_b_input => matrix_in_int(i, i)
            );

          for m in 0 to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
            scalar_sum_int := function_scalar_float_multiplier (
              scalar_a_input => scalar_ratio_int,
              scalar_b_input => matrix_in_int(i, m)
              );

            matrix_in_int(j, m) := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => matrix_in_int(j, m),
              scalar_b_input => scalar_sum_int
              );
          end loop;
        end if;
      end loop;
    end loop;

    -- Row Operation to Make Principal Diagonal to 1
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in to_integer(unsigned(SIZE_J_IN)) to 2*to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_in_int(i, j) := function_scalar_float_divider (
          scalar_a_input => matrix_in_int(i, j),
          scalar_b_input => matrix_in_int(i, i)
          );
      end loop;
    end loop;

    -- Output
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := matrix_in_int(i, j + to_integer(unsigned(SIZE_J_IN)));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_inverse;

  function function_matrix_multiplication (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := ONE_DATA;
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for t in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
          matrix_output(i, j) := function_scalar_float_multiplier (
            scalar_a_input => matrix_output(i, j),
            scalar_b_input => matrix_input(i, j, t)
            );
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_multiplication;

  function function_matrix_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
        matrix_output(i, j) := ZERO_DATA;

        for m in 0 to to_integer(unsigned(SIZE_A_J_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => matrix_a_input(i, m),
            scalar_b_input => matrix_b_input(m, j)
            );

          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_output(i, j)
            );
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_product;

  function function_matrix_vector_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_IN   : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    vector_b_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      vector_output(i) := ZERO_DATA;

      for m in 0 to to_integer(unsigned(SIZE_A_J_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => matrix_a_input(i, m),
          scalar_b_input => vector_b_input(m)
          );

        vector_output(i) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => scalar_operation_int,
          scalar_b_input => vector_output(i)
          );
      end loop;
    end loop;

    return vector_output;
  end function function_matrix_vector_product;

  function function_transpose_vector_product (
    SIZE_A_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_IN))-1 loop
        matrix_output(i, j) := ZERO_DATA;

        for m in 0 to to_integer(unsigned(SIZE_B_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_a_input(m),
            scalar_b_input => vector_b_input(m)
            );

          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_output(i, j)
            );
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_transpose_vector_product;

  function function_matrix_summation (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    LENGTH_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    matrix_output := (others => (others => ZERO_DATA));

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for t in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => matrix_output(i, j),
            scalar_b_input => matrix_input(i, j, t)
            );
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_summation;

  function function_matrix_transpose (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := matrix_input(j, i);
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_transpose;

  -- TENSOR
  function function_tensor_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_B_K_IN))-1 loop
          tensor_output(i, j, k) := ZERO_DATA;

          for m in 0 to i loop
            for n in 0 to j loop
              for p in 0 to k loop
                scalar_operation_int := function_scalar_float_multiplier (
                  scalar_a_input => tensor_a_input(m, n, p),
                  scalar_b_input => tensor_b_input(i-m, j-n, k-p)
                  );

                tensor_output(i, j, k) := function_scalar_float_adder (
                  OPERATION => '0',

                  scalar_a_input => scalar_operation_int,
                  scalar_b_input => tensor_output(i, j, k)
                  );
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_convolution;

  function function_tensor_matrix_convolution (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
        matrix_output(i, j) := ZERO_DATA;

        for k in 0 to to_integer(unsigned(SIZE_A_K_IN))-1 loop
          for m in 0 to i loop
            for n in 0 to j loop
              for p in 0 to k loop
                scalar_operation_int := function_scalar_float_multiplier (
                  scalar_a_input => tensor_a_input(m, n, p),
                  scalar_b_input => matrix_b_input(i-m, j-n)
                  );

                matrix_output(i, j) := function_scalar_float_adder (
                  OPERATION => '0',

                  scalar_a_input => scalar_operation_int,
                  scalar_b_input => matrix_output(i, j)
                  );
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_tensor_matrix_convolution;

  function function_tensor_inverse (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;

    variable tensor_in_int : tensor_buffer;

    variable data_interchange_in_int  : vector_buffer;
    variable data_interchange_out_int : vector_buffer;

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable data_quotient_int : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    tensor_in_int := tensor_input;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          if (i = j and j = k) then
            tensor_output(i, j, k) := ONE_DATA;
          else
            tensor_output(i, j, k) := ZERO_DATA;
          end if;
        end loop;
      end loop;
    end loop;

    for m in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      if (tensor_in_int(m, m, m) = ZERO_DATA) then
        for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
          if (tensor_in_int(i, m, m) /= ZERO_DATA) then
            for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
              if (tensor_in_int(i, j, m) /= ZERO_DATA) then
                for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
                  data_interchange_in_int(k)  := tensor_in_int(m, m, k);
                  data_interchange_out_int(k) := tensor_output(m, m, k);

                  tensor_in_int(m, m, k) := tensor_in_int(i, j, k);
                  tensor_output(m, m, k) := tensor_output(i, j, k);

                  tensor_in_int(i, j, k) := data_interchange_in_int(k);
                  tensor_output(i, j, k) := data_interchange_out_int(k);
                end loop;
              end if;
            end loop;
          end if;
        end loop;
      end if;

      for i in m+1 to to_integer(unsigned(SIZE_I_IN))-1 loop
        data_quotient_int := function_scalar_float_divider (
          scalar_a_input => tensor_in_int(i, m, m),
          scalar_b_input => tensor_in_int(m, m, m)
          );

        for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => data_quotient_int,
              scalar_b_input => tensor_in_int(m, j, k)
              );

            tensor_in_int(i, j, k) := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => tensor_in_int(i, j, k),
              scalar_b_input => scalar_operation_int
              );

            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => data_quotient_int,
              scalar_b_input => tensor_output(m, j, k)
              );

            tensor_output(i, j, k) := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => tensor_output(i, j, k),
              scalar_b_input => scalar_operation_int
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_inverse;

  function function_tensor_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    tensor_b_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_B_K_IN))-1 loop
          tensor_output(i, j, k) := ZERO_DATA;

          for m in 0 to to_integer(unsigned(SIZE_A_J_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => tensor_a_input(i, j, m),
              scalar_b_input => tensor_b_input(i, m, k)
              );

            tensor_output(i, j, k) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_output(i, j, k)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_product;

  function function_tensor_matrix_product (
    SIZE_A_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_a_input : tensor_buffer;
    matrix_b_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
        matrix_output(i, j) := ZERO_DATA;

        for m in 0 to to_integer(unsigned(SIZE_A_J_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => tensor_a_input(i, j, m),
            scalar_b_input => matrix_b_input(i, m)
            );

          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_output(i, j)
            );
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_tensor_matrix_product;

  function function_tensor_transpose (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := tensor_input(i, j, k);
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_transpose;

  ------------------------------------------------------------------------------
  -- MATH - FUNCTION
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_logistic (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_operation_int := function_scalar_exponentiator (
      scalar_input => scalar_input
      );

    scalar_operation_int := function_scalar_float_divider (
      scalar_a_input => ONE_DATA,
      scalar_b_input => scalar_operation_int
      );

    scalar_operation_int := function_scalar_float_adder (
      OPERATION => '0',

      scalar_a_input => ONE_DATA,
      scalar_b_input => scalar_operation_int
      );

    scalar_output := function_scalar_float_divider (
      scalar_a_input => ONE_DATA,
      scalar_b_input => scalar_operation_int
      );

    return scalar_output;
  end function function_scalar_logistic;

  function function_scalar_oneplus (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_operation_int := function_scalar_exponentiator (
      scalar_input => scalar_input
      );

    scalar_operation_int := function_scalar_float_adder (
      OPERATION => '0',

      scalar_a_input => ONE_DATA,
      scalar_b_input => scalar_operation_int
      );

    scalar_operation_int := function_scalar_logarithm (
      scalar_input => scalar_operation_int
      );

    scalar_output := function_scalar_float_adder (
      OPERATION => '0',

      scalar_a_input => ONE_DATA,
      scalar_b_input => scalar_operation_int
      );

    return scalar_output;
  end function function_scalar_oneplus;

  -- VECTOR
  function function_vector_logistic (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      scalar_operation_int := function_scalar_exponentiator (
        scalar_input => vector_input(i)
        );

      scalar_operation_int := function_scalar_float_divider (
        scalar_a_input => ONE_DATA,
        scalar_b_input => scalar_operation_int
        );

      scalar_operation_int := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => ONE_DATA,
        scalar_b_input => scalar_operation_int
        );

      vector_output(i) := function_scalar_float_divider (
        scalar_a_input => ONE_DATA,
        scalar_b_input => scalar_operation_int
        );
    end loop;

    return vector_output;
  end function function_vector_logistic;

  function function_vector_oneplus (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      scalar_operation_int := function_scalar_exponentiator (
        scalar_input => vector_input(i)
        );

      scalar_operation_int := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => ONE_DATA,
        scalar_b_input => scalar_operation_int
        );

      scalar_operation_int := function_scalar_logarithm (
        scalar_input => scalar_operation_int
        );

      vector_output(i) := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => ONE_DATA,
        scalar_b_input => scalar_operation_int
        );
    end loop;

    return vector_output;
  end function function_vector_oneplus;

  -- MATRIX
  function function_matrix_logistic (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        scalar_operation_int := function_scalar_exponentiator (
          scalar_input => matrix_input(i, j)
          );

        scalar_operation_int := function_scalar_float_divider (
          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        matrix_output(i, j) := function_scalar_float_divider (
          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_logistic;

  function function_matrix_oneplus (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        scalar_operation_int := function_scalar_exponentiator (
          scalar_input => matrix_input(i, j)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_logarithm (
          scalar_input => scalar_operation_int
          );

        matrix_output(i, j) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_oneplus;

  ------------------------------------------------------------------------------
  -- MATH - CALCULUS
  ------------------------------------------------------------------------------

  -- VECTOR
  function function_vector_differentiation (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      if (i = 0) then
        vector_output(i) := ZERO_DATA;
      else
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => vector_input(i),
          scalar_b_input => vector_input(i-1)
          );

        vector_output(i) := function_scalar_float_divider (
          scalar_a_input => scalar_operation_int,
          scalar_b_input => LENGTH_IN
          );
      end if;
    end loop;

    return vector_output;
  end function function_vector_differentiation;

  function function_vector_integration (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := ZERO_DATA;

      scalar_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_input(i),
        scalar_b_input => LENGTH_IN
        );

      vector_output(i) := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_operation_int,
        scalar_b_input => vector_output(i)
        );
    end loop;

    return vector_output;
  end function function_vector_integration;

  function function_vector_softmax (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable data_summation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    data_summation_int := ZERO_DATA;

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      scalar_operation_int := function_scalar_exponentiator (
        scalar_input => vector_input(i)
        );

      data_summation_int := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_operation_int,
        scalar_b_input => data_summation_int
        );

      vector_output(i) := function_scalar_float_divider (
        scalar_a_input => scalar_operation_int,
        scalar_b_input => data_summation_int
        );
    end loop;

    return vector_output;
  end function function_vector_softmax;

  -- MATRIX
  function function_matrix_differentiation (
    CONTROL : std_logic;

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_I_IN : std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_J_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        if (CONTROL = '0') then
          if (i = 0) then
            matrix_output(i, j) := ZERO_DATA;
          else
            scalar_operation_int := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => matrix_input(i, j),
              scalar_b_input => matrix_input(i-1, j)
              );

            matrix_output(i, j) := function_scalar_float_divider (
              scalar_a_input => scalar_operation_int,
              scalar_b_input => LENGTH_I_IN
              );
          end if;
        elsif (CONTROL = '1') then
          if (j = 0) then
            matrix_output(i, j) := ZERO_DATA;
          else
            scalar_operation_int := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => matrix_input(i, j),
              scalar_b_input => matrix_input(i, j-1)
              );

            matrix_output(i, j) := function_scalar_float_divider (
              scalar_a_input => scalar_operation_int,
              scalar_b_input => LENGTH_J_IN
              );
          end if;
        end if;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_differentiation;

  function function_matrix_integration (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := ZERO_DATA;

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => matrix_input(i, j),
          scalar_b_input => LENGTH_IN
          );

        matrix_output(i, j) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => scalar_operation_int,
          scalar_b_input => matrix_output(i, j)
          );
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_integration;

  function function_matrix_softmax (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable data_summation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    data_summation_int := ZERO_DATA;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        scalar_operation_int := function_scalar_exponentiator (
          scalar_input => matrix_input(i, j)
          );

        data_summation_int := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => scalar_operation_int,
          scalar_b_input => data_summation_int
          );

        matrix_output(i, j) := function_scalar_float_divider (
          scalar_a_input => scalar_operation_int,
          scalar_b_input => data_summation_int
          );
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_softmax;

  -- TENSOR
  function function_tensor_differentiation (
    CONTROL : std_logic_vector(1 downto 0);

    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_I_IN : std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_J_IN : std_logic_vector(DATA_SIZE-1 downto 0);
    LENGTH_K_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          if (CONTROL = "01") then
            if (i = 0) then
              tensor_output(i, j, k) := ZERO_DATA;
            else
              scalar_operation_int := function_scalar_float_adder (
                OPERATION => '1',

                scalar_a_input => tensor_input(i, j, k),
                scalar_b_input => tensor_input(i-1, j, k)
                );

              tensor_output(i, j, k) := function_scalar_float_divider (
                scalar_a_input => scalar_operation_int,
                scalar_b_input => LENGTH_I_IN
                );
            end if;
          elsif (CONTROL = "10") then
            if (j = 0) then
              tensor_output(i, j, k) := ZERO_DATA;
            else
              scalar_operation_int := function_scalar_float_adder (
                OPERATION => '1',

                scalar_a_input => tensor_input(i, j, k),
                scalar_b_input => tensor_input(i, j-1, k)
                );

              tensor_output(i, j, k) := function_scalar_float_divider (
                scalar_a_input => scalar_operation_int,
                scalar_b_input => LENGTH_J_IN
                );
            end if;
          elsif (CONTROL = "11") then
            if (k = 0) then
              tensor_output(i, j, k) := ZERO_DATA;
            else
              scalar_operation_int := function_scalar_float_adder (
                OPERATION => '1',

                scalar_a_input => tensor_input(i, j, k),
                scalar_b_input => tensor_input(i, j, k-1)
                );

              tensor_output(i, j, k) := function_scalar_float_divider (
                scalar_a_input => scalar_operation_int,
                scalar_b_input => LENGTH_K_IN
                );
            end if;
          end if;
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_differentiation;

  function function_tensor_integration (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          tensor_output(i, j, k) := ZERO_DATA;

          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => tensor_input(i, j, k),
            scalar_b_input => LENGTH_IN
            );

          tensor_output(i, j, k) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => tensor_output(i, j, k)
            );
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_integration;

  function function_tensor_softmax (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable data_summation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable tensor_output : tensor_buffer;
  begin
    -- Data Inputs
    data_summation_int := ZERO_DATA;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_K_IN))-1 loop
          scalar_operation_int := function_scalar_exponentiator (
            scalar_input => tensor_input(i, j, k)
            );

          data_summation_int := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => data_summation_int
            );

          tensor_output(i, j, k) := function_scalar_float_divider (
            scalar_a_input => scalar_operation_int,
            scalar_b_input => data_summation_int
            );
        end loop;
      end loop;
    end loop;

    return tensor_output;
  end function function_tensor_softmax;

  ------------------------------------------------------------------------------
  -- MATH - SERIES
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_scalar_cosh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(cosh(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_cosh;

  function function_scalar_exponentiator (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(exp(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_exponentiator;

  function function_scalar_sqrt (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(sqrt(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_sqrt;

  function function_scalar_power (
    scalar_a_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_b_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(to_real(to_float(scalar_a_input, float64'high, -float64'low))**to_real(to_float(scalar_b_input, float64'high, -float64'low))));

    return scalar_output;
  end function function_scalar_power;

  function function_scalar_logarithm (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(log(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_logarithm;

  function function_scalar_sinh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(sinh(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_sinh;

  function function_scalar_tanh (
    scalar_input : std_logic_vector(DATA_SIZE-1 downto 0)

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := std_logic_vector(to_float(tanh(to_real(to_float(scalar_input, float64'high, -float64'low))), float64'high, -float64'low));

    return scalar_output;
  end function function_scalar_tanh;

  -- VECTOR
  function function_vector_cosh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(cosh(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_cosh;

  function function_vector_exponentiator (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(exp(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_exponentiator;

  function function_vector_sqrt (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(sqrt(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_sqrt;

  function function_vector_power (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_b_input : vector_buffer

    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(to_real(to_float(vector_a_input(i), float64'high, -float64'low))**to_real(to_float(vector_b_input(i), float64'high, -float64'low))));
    end loop;

    return vector_output;
  end function function_vector_power;

  function function_vector_logarithm (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(log(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_logarithm;

  function function_vector_sinh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(sinh(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_sinh;

  function function_vector_tanh (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_input : vector_buffer
    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := std_logic_vector(to_float(tanh(to_real(to_float(vector_input(i), float64'high, -float64'low))), float64'high, -float64'low));
    end loop;

    return vector_output;
  end function function_vector_tanh;

  -- MATRIX
  function function_matrix_cosh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(cosh(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_cosh;

  function function_matrix_exponentiator (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(exp(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_exponentiator;

  function function_matrix_sqrt (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(sqrt(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_sqrt;

  function function_matrix_power (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_a_input : matrix_buffer;
    matrix_b_input : matrix_buffer

    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_a_input(i, j), float64'high, -float64'low))**to_real(to_float(matrix_b_input(i, j), float64'high, -float64'low))));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_power;

  function function_matrix_logarithm (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(log(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_logarithm;

  function function_matrix_sinh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(sinh(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_sinh;

  function function_matrix_tanh (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := std_logic_vector(to_float(tanh(to_real(to_float(matrix_input(i, j), float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_tanh;

  ------------------------------------------------------------------------------
  -- MATH - STATITICS
  ------------------------------------------------------------------------------

  -- SCALAR
  function function_model_scalar_mean (
    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    scalar_input : vector_buffer

    ) return std_logic_vector is

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := ZERO_DATA;

    for m in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      scalar_output := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_output,
        scalar_b_input => scalar_input(m)
        );
    end loop;

    scalar_output := function_scalar_float_divider (
      scalar_a_input => scalar_output,
      scalar_b_input => LENGTH_IN
      );

    return scalar_output;
  end function function_model_scalar_mean;

  function function_model_scalar_deviation (
    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    scalar_input : vector_buffer;
    scalar_mean  : std_logic_vector

    ) return std_logic_vector is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_output : std_logic_vector(DATA_SIZE-1 downto 0);
  begin
    -- Data Inputs
    scalar_output := ZERO_DATA;

    for m in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
      scalar_output := function_scalar_float_adder (
        OPERATION => '0',

        scalar_a_input => scalar_output,
        scalar_b_input => scalar_input(m)
        );

      scalar_operation_int := function_scalar_power (
        scalar_a_input => scalar_mean,
        scalar_b_input => TWO_DATA
        );

      scalar_output := function_scalar_float_adder (
        OPERATION => '1',

        scalar_a_input => scalar_output,
        scalar_b_input => scalar_operation_int
        );
    end loop;

    scalar_output := function_scalar_float_divider (
      scalar_a_input => scalar_output,
      scalar_b_input => LENGTH_IN
      );

    scalar_output := function_scalar_sqrt (
      scalar_input => scalar_output
      );

    return scalar_output;
  end function function_model_scalar_deviation;

  -- VECTOR
  function function_model_vector_mean (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer

    ) return vector_buffer is

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    vector_output := (others => ZERO_DATA);

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      for m in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
        vector_output(i) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => vector_output(i),
          scalar_b_input => vector_input(i, m)
          );
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := function_scalar_float_divider (
        scalar_a_input => vector_output(i),
        scalar_b_input => LENGTH_IN
        );
    end loop;

    return vector_output;
  end function function_model_vector_mean;

  function function_model_vector_deviation (
    SIZE_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer;
    vector_mean  : vector_buffer

    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : vector_buffer;
  begin
    -- Data Inputs
    vector_output := (others => ZERO_DATA);

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      for m in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
        vector_output(i) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => vector_output(i),
          scalar_b_input => vector_input(i, m)
          );

        scalar_operation_int := function_scalar_power (
          scalar_a_input => vector_mean(i),
          scalar_b_input => TWO_DATA
          );

        vector_output(i) := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => vector_output(i),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      vector_output(i) := function_scalar_float_divider (
        scalar_a_input => vector_output(i),
        scalar_b_input => LENGTH_IN
        );
    end loop;

    vector_output := function_vector_sqrt (
      SIZE_IN => SIZE_IN,

      vector_input => vector_output
      );

    return vector_output;
  end function function_model_vector_deviation;

  -- MATRIX
  function function_model_matrix_mean (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer

    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    matrix_output := (others => (others => ZERO_DATA));

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for m in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => matrix_output(i, j),
            scalar_b_input => matrix_input(i, j, m)
            );
        end loop;
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := function_scalar_float_divider (

          scalar_a_input => matrix_output(i, j),
          scalar_b_input => LENGTH_IN
          );
      end loop;
    end loop;

    return matrix_output;
  end function function_model_matrix_mean;

  function function_model_matrix_deviation (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer;
    matrix_mean  : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : matrix_buffer;
  begin
    -- Data Inputs
    matrix_output := (others => (others => ZERO_DATA));

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        for m in 0 to to_integer(unsigned(LENGTH_IN))-1 loop
          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => matrix_output(i, j),
            scalar_b_input => matrix_input(i, j, m)
            );

          scalar_operation_int := function_scalar_power (
            scalar_a_input => matrix_mean(i, j),
            scalar_b_input => TWO_DATA
            );

          matrix_output(i, j) := function_scalar_float_adder (
            OPERATION => '1',

            scalar_a_input => matrix_output(i, j),
            scalar_b_input => scalar_operation_int
            );
        end loop;
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        matrix_output(i, j) := function_scalar_float_divider (

          scalar_a_input => matrix_output(i, j),
          scalar_b_input => LENGTH_IN
          );
      end loop;
    end loop;

    matrix_output := function_matrix_sqrt (
      SIZE_I_IN => SIZE_I_IN,
      SIZE_J_IN => SIZE_J_IN,

      matrix_input => matrix_output
      );

    return matrix_output;
  end function function_model_matrix_deviation;

end model_math_pkg;
