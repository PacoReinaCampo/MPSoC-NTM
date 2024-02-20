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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;

use work.model_algebra_pkg.all;

entity model_algebra_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -- DOT PRODUCT
    -- CONTROL
    DOT_PRODUCT_START : out std_logic;
    DOT_PRODUCT_READY : in  std_logic;

    DOT_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
    DOT_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

    DOT_PRODUCT_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    DOT_PRODUCT_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    DOT_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DOT_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DOT_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR CONVOLUTION
    -- CONTROL
    VECTOR_CONVOLUTION_START : out std_logic;
    VECTOR_CONVOLUTION_READY : in  std_logic;

    VECTOR_CONVOLUTION_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_CONVOLUTION_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_CONVOLUTION_DATA_ENABLE : in std_logic;

    VECTOR_CONVOLUTION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_CONVOLUTION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_CONVOLUTION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR COSINE_SIMILARITY
    -- CONTROL
    VECTOR_COSINE_SIMILARITY_START : out std_logic;
    VECTOR_COSINE_SIMILARITY_READY : in  std_logic;

    VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_COSINE_SIMILARITY_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_COSINE_SIMILARITY_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR MULTIPLICATION
    -- CONTROL
    VECTOR_MULTIPLICATION_START : out std_logic;
    VECTOR_MULTIPLICATION_READY : in  std_logic;

    VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE : out std_logic;
    VECTOR_MULTIPLICATION_DATA_IN_ENABLE        : out std_logic;

    VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE : in std_logic;
    VECTOR_MULTIPLICATION_DATA_ENABLE        : in std_logic;

    VECTOR_MULTIPLICATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MULTIPLICATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR SUMMATION
    -- CONTROL
    VECTOR_SUMMATION_START : out std_logic;
    VECTOR_SUMMATION_READY : in  std_logic;

    VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE : out std_logic;
    VECTOR_SUMMATION_DATA_IN_ENABLE        : out std_logic;

    VECTOR_SUMMATION_DATA_LENGTH_ENABLE : in std_logic;
    VECTOR_SUMMATION_DATA_ENABLE        : in std_logic;

    VECTOR_SUMMATION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_SUMMATION_SIZE_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR MODULE
    -- CONTROL
    VECTOR_MODULE_START : out std_logic;
    VECTOR_MODULE_READY : in  std_logic;

    VECTOR_MODULE_DATA_IN_ENABLE : out std_logic;

    VECTOR_MODULE_DATA_ENABLE : in std_logic;

    VECTOR_MODULE_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_MODULE_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_MODULE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_MODULE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX CONVOLUTION
    -- CONTROL
    MATRIX_CONVOLUTION_START : out std_logic;
    MATRIX_CONVOLUTION_READY : in  std_logic;

    MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_CONVOLUTION_DATA_I_ENABLE : in std_logic;
    MATRIX_CONVOLUTION_DATA_J_ENABLE : in std_logic;

    MATRIX_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX VECTOR CONVOLUTION
    -- CONTROL
    MATRIX_VECTOR_CONVOLUTION_START : out std_logic;
    MATRIX_VECTOR_CONVOLUTION_READY : in  std_logic;

    MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   : out std_logic;

    MATRIX_VECTOR_CONVOLUTION_DATA_I_ENABLE : in std_logic;
    MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE : in std_logic;

    MATRIX_VECTOR_CONVOLUTION_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_VECTOR_CONVOLUTION_SIZE_B_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_VECTOR_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_VECTOR_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_VECTOR_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX INVERSE
    -- CONTROL
    MATRIX_INVERSE_START : out std_logic;
    MATRIX_INVERSE_READY : in  std_logic;

    MATRIX_INVERSE_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_INVERSE_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_INVERSE_DATA_I_ENABLE : in std_logic;
    MATRIX_INVERSE_DATA_J_ENABLE : in std_logic;

    MATRIX_INVERSE_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_INVERSE_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_INVERSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INVERSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_INVERSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_INVERSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX MULTIPLICATION
    -- CONTROL
    MATRIX_MULTIPLICATION_START : out std_logic;
    MATRIX_MULTIPLICATION_READY : in  std_logic;

    MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE : out std_logic;
    MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      : out std_logic;
    MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      : out std_logic;

    MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE : in std_logic;
    MATRIX_MULTIPLICATION_DATA_I_ENABLE      : in std_logic;
    MATRIX_MULTIPLICATION_DATA_J_ENABLE      : in std_logic;

    MATRIX_MULTIPLICATION_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_MULTIPLICATION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_MULTIPLICATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_MULTIPLICATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX PRODUCT
    -- CONTROL
    MATRIX_PRODUCT_START : out std_logic;
    MATRIX_PRODUCT_READY : in  std_logic;

    MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_PRODUCT_DATA_I_ENABLE : in std_logic;
    MATRIX_PRODUCT_DATA_J_ENABLE : in std_logic;

    MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX VECTOR PRODUCT
    -- CONTROL
    MATRIX_VECTOR_PRODUCT_START : out std_logic;
    MATRIX_VECTOR_PRODUCT_READY : in  std_logic;

    MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   : out std_logic;

    MATRIX_VECTOR_PRODUCT_DATA_I_ENABLE : in std_logic;
    MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE : in std_logic;

    MATRIX_VECTOR_PRODUCT_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_VECTOR_PRODUCT_SIZE_B_IN   : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_VECTOR_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_VECTOR_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_VECTOR_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX SUMMATION
    -- CONTROL
    MATRIX_SUMMATION_START : out std_logic;
    MATRIX_SUMMATION_READY : in  std_logic;

    MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE : out std_logic;
    MATRIX_SUMMATION_DATA_IN_I_ENABLE      : out std_logic;
    MATRIX_SUMMATION_DATA_IN_J_ENABLE      : out std_logic;

    MATRIX_SUMMATION_DATA_LENGTH_ENABLE : in std_logic;
    MATRIX_SUMMATION_DATA_I_ENABLE      : in std_logic;
    MATRIX_SUMMATION_DATA_J_ENABLE      : in std_logic;

    MATRIX_SUMMATION_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_SUMMATION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_SUMMATION_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SUMMATION_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SUMMATION_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_SUMMATION_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_SUMMATION_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TRANSPOSE
    -- CONTROL
    MATRIX_TRANSPOSE_START : out std_logic;
    MATRIX_TRANSPOSE_READY : in  std_logic;

    MATRIX_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_TRANSPOSE_DATA_I_ENABLE : in std_logic;
    MATRIX_TRANSPOSE_DATA_J_ENABLE : in std_logic;

    MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR CONVOLUTION
    -- CONTROL
    TENSOR_CONVOLUTION_START : out std_logic;
    TENSOR_CONVOLUTION_READY : in  std_logic;

    TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_CONVOLUTION_DATA_I_ENABLE : in std_logic;
    TENSOR_CONVOLUTION_DATA_J_ENABLE : in std_logic;
    TENSOR_CONVOLUTION_DATA_K_ENABLE : in std_logic;

    TENSOR_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_CONVOLUTION_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR MATRIX CONVOLUTION
    -- CONTROL
    TENSOR_MATRIX_CONVOLUTION_START : out std_logic;
    TENSOR_MATRIX_CONVOLUTION_READY : in  std_logic;

    TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE : out std_logic;

    TENSOR_MATRIX_CONVOLUTION_DATA_I_ENABLE : in std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE : in std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE : in std_logic;

    TENSOR_MATRIX_CONVOLUTION_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_MATRIX_CONVOLUTION_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_MATRIX_CONVOLUTION_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR INVERSE
    -- CONTROL
    TENSOR_INVERSE_START : out std_logic;
    TENSOR_INVERSE_READY : in  std_logic;

    TENSOR_INVERSE_DATA_IN_I_ENABLE : out std_logic;
    TENSOR_INVERSE_DATA_IN_J_ENABLE : out std_logic;
    TENSOR_INVERSE_DATA_IN_K_ENABLE : out std_logic;

    TENSOR_INVERSE_DATA_I_ENABLE : in std_logic;
    TENSOR_INVERSE_DATA_J_ENABLE : in std_logic;
    TENSOR_INVERSE_DATA_K_ENABLE : in std_logic;

    TENSOR_INVERSE_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_INVERSE_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_INVERSE_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_INVERSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INVERSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INVERSE_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_INVERSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_INVERSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR PRODUCT
    -- CONTROL
    TENSOR_PRODUCT_START : out std_logic;
    TENSOR_PRODUCT_READY : in  std_logic;

    TENSOR_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_PRODUCT_DATA_I_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_J_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_K_ENABLE : in std_logic;

    TENSOR_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR MATRIX PRODUCT
    -- CONTROL
    TENSOR_MATRIX_PRODUCT_START : out std_logic;
    TENSOR_MATRIX_PRODUCT_READY : in  std_logic;

    TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

    TENSOR_MATRIX_PRODUCT_DATA_I_ENABLE : in std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE : in std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE : in std_logic;

    TENSOR_MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR TRANSPOSE
    -- CONTROL
    TENSOR_TRANSPOSE_START : out std_logic;
    TENSOR_TRANSPOSE_READY : in  std_logic;

    TENSOR_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
    TENSOR_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;
    TENSOR_TRANSPOSE_DATA_IN_K_ENABLE : out std_logic;

    TENSOR_TRANSPOSE_DATA_I_ENABLE : in std_logic;
    TENSOR_TRANSPOSE_DATA_J_ENABLE : in std_logic;
    TENSOR_TRANSPOSE_DATA_K_ENABLE : in std_logic;

    TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_algebra_stimulus_architecture of model_algebra_stimulus is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_l_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  RST <= rst_int;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -- VECTOR-FUNCTIONALITY
  DOT_PRODUCT_START              <= start_int;
  VECTOR_CONVOLUTION_START       <= start_int;
  VECTOR_COSINE_SIMILARITY_START <= start_int;
  VECTOR_MULTIPLICATION_START    <= start_int;
  VECTOR_SUMMATION_START         <= start_int;
  VECTOR_MODULE_START            <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_CONVOLUTION_START        <= start_int;
  MATRIX_VECTOR_CONVOLUTION_START <= start_int;
  MATRIX_INVERSE_START            <= start_int;
  MATRIX_MULTIPLICATION_START     <= start_int;
  MATRIX_PRODUCT_START            <= start_int;
  MATRIX_VECTOR_PRODUCT_START     <= start_int;
  MATRIX_SUMMATION_START          <= start_int;
  MATRIX_TRANSPOSE_START          <= start_int;

  -- TENSOR-FUNCTIONALITY
  TENSOR_CONVOLUTION_START        <= start_int;
  TENSOR_MATRIX_CONVOLUTION_START <= start_int;
  TENSOR_INVERSE_START            <= start_int;
  TENSOR_PRODUCT_START            <= start_int;
  TENSOR_MATRIX_PRODUCT_START     <= start_int;
  TENSOR_TRANSPOSE_START          <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_NTM_DOT_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_DOT_PRODUCT_TEST                                       ";
      -------------------------------------------------------------------

      -- DATA
      DOT_PRODUCT_LENGTH_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_DOT_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_DOT_PRODUCT_CASE 0                                     ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DOT_PRODUCT_DATA_A_IN <= ZERO_DATA;
        DOT_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        DOT_PRODUCT_FIRST_RUN : loop
          if (DOT_PRODUCT_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DOT_PRODUCT_DATA_OUT_ENABLE = '1' or DOT_PRODUCT_START = '1') and (unsigned(index_i_loop) < unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '0';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit DOT_PRODUCT_FIRST_RUN when DOT_PRODUCT_READY = '1';
        end loop DOT_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_DOT_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_DOT_PRODUCT_CASE 1                                     ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DOT_PRODUCT_DATA_A_IN <= ZERO_DATA;
        DOT_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        DOT_PRODUCT_SECOND_RUN : loop
          if (DOT_PRODUCT_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DOT_PRODUCT_DATA_OUT_ENABLE = '1' or DOT_PRODUCT_START = '1') and (unsigned(index_i_loop) < unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '0';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit DOT_PRODUCT_SECOND_RUN when DOT_PRODUCT_READY = '1';
        end loop DOT_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_CONVOLUTION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_CONVOLUTION_TEST                                ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_CONVOLUTION_LENGTH_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_CONVOLUTION_CASE 0                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        VECTOR_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_CONVOLUTION_FIRST_RUN : loop
          if (VECTOR_CONVOLUTION_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_CONVOLUTION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
            VECTOR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_CONVOLUTION_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_CONVOLUTION_DATA_ENABLE = '1' or VECTOR_CONVOLUTION_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_CONVOLUTION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
            VECTOR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_CONVOLUTION_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_CONVOLUTION_DATA_A_IN_ENABLE <= '0';
            VECTOR_CONVOLUTION_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_CONVOLUTION_FIRST_RUN when VECTOR_CONVOLUTION_READY = '1';
        end loop VECTOR_CONVOLUTION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_CONVOLUTION_CASE 1                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        VECTOR_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_CONVOLUTION_SECOND_RUN : loop
          if (VECTOR_CONVOLUTION_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_CONVOLUTION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
            VECTOR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_CONVOLUTION_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_CONVOLUTION_DATA_ENABLE = '1' or VECTOR_CONVOLUTION_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_CONVOLUTION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_CONVOLUTION_DATA_A_IN_ENABLE <= '1';
            VECTOR_CONVOLUTION_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_CONVOLUTION_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_CONVOLUTION_DATA_A_IN_ENABLE <= '0';
            VECTOR_CONVOLUTION_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_CONVOLUTION_SECOND_RUN when VECTOR_CONVOLUTION_READY = '1';
        end loop VECTOR_CONVOLUTION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_COSINE_TEST                                     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_COSINE_SIMILARITY_LENGTH_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_COSINE_CASE 0                                   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_COSINE_SIMILARITY_DATA_A_IN <= ZERO_DATA;
        VECTOR_COSINE_SIMILARITY_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_COSINE_SIMILARITY_FIRST_RUN : loop
          if (VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_COSINE_SIMILARITY_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
            VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSINE_SIMILARITY_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_COSINE_SIMILARITY_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE = '1' or VECTOR_COSINE_SIMILARITY_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_COSINE_SIMILARITY_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
            VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSINE_SIMILARITY_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_COSINE_SIMILARITY_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '0';
            VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_COSINE_SIMILARITY_FIRST_RUN when VECTOR_COSINE_SIMILARITY_READY = '1';
        end loop VECTOR_COSINE_SIMILARITY_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_COSINE_CASE 1                                   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_COSINE_SIMILARITY_DATA_A_IN <= ZERO_DATA;
        VECTOR_COSINE_SIMILARITY_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_COSINE_SIMILARITY_SECOND_RUN : loop
          if (VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_COSINE_SIMILARITY_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
            VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSINE_SIMILARITY_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_COSINE_SIMILARITY_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_COSINE_SIMILARITY_DATA_OUT_ENABLE = '1' or VECTOR_COSINE_SIMILARITY_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_COSINE_SIMILARITY_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '1';
            VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_COSINE_SIMILARITY_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_COSINE_SIMILARITY_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_COSINE_SIMILARITY_DATA_A_IN_ENABLE <= '0';
            VECTOR_COSINE_SIMILARITY_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_COSINE_SIMILARITY_SECOND_RUN when VECTOR_COSINE_SIMILARITY_READY = '1';
        end loop VECTOR_COSINE_SIMILARITY_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_MULTIPLICATION_TEST                             ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MULTIPLICATION_LENGTH_IN <= FOUR_CONTROL;

      VECTOR_MULTIPLICATION_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_MULTIPLICATION_CASE 0                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_MULTIPLICATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        VECTOR_MULTIPLICATION_FIRST_RUN : loop
          if (VECTOR_MULTIPLICATION_DATA_ENABLE = '1' and VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_MULTIPLICATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_ENABLE        <= '1';
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_MULTIPLICATION_DATA_ENABLE = '1' and VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_MULTIPLICATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_ENABLE        <= '1';
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_MULTIPLICATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_ENABLE        <= '0';
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_MULTIPLICATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(VECTOR_MULTIPLICATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' or VECTOR_MULTIPLICATION_START = '1') and (unsigned(index_l_loop) < unsigned(VECTOR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_MULTIPLICATION_FIRST_RUN when VECTOR_MULTIPLICATION_READY = '1';
        end loop VECTOR_MULTIPLICATION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_MULTIPLICATION_CASE 1                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_MULTIPLICATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        VECTOR_MULTIPLICATION_SECOND_RUN : loop
          if (VECTOR_MULTIPLICATION_DATA_ENABLE = '1' and VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_MULTIPLICATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_ENABLE        <= '1';
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_MULTIPLICATION_DATA_ENABLE = '1' and VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_MULTIPLICATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_ENABLE        <= '1';
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_MULTIPLICATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            VECTOR_MULTIPLICATION_DATA_IN_ENABLE        <= '0';
            VECTOR_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_MULTIPLICATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(VECTOR_MULTIPLICATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((VECTOR_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' or VECTOR_MULTIPLICATION_START = '1') and (unsigned(index_l_loop) < unsigned(VECTOR_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_MULTIPLICATION_SECOND_RUN when VECTOR_MULTIPLICATION_READY = '1';
        end loop VECTOR_MULTIPLICATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_SUMMATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_SUMMATION_TEST                                  ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_SUMMATION_LENGTH_IN <= FOUR_CONTROL;

      VECTOR_SUMMATION_SIZE_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_SUMMATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_SUMMATION_CASE 0                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_SUMMATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        VECTOR_SUMMATION_FIRST_RUN : loop
          if (VECTOR_SUMMATION_DATA_ENABLE = '1' and VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_SUMMATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_ENABLE        <= '1';
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_SUMMATION_DATA_ENABLE = '1' and VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_SUMMATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_ENABLE        <= '1';
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_SUMMATION_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_ENABLE        <= '0';
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_SUMMATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(VECTOR_SUMMATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' or VECTOR_SUMMATION_START = '1') and (unsigned(index_l_loop) < unsigned(VECTOR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_SUMMATION_FIRST_RUN when VECTOR_SUMMATION_READY = '1';
        end loop VECTOR_SUMMATION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_SUMMATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_SUMMATION_CASE 1                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_SUMMATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        VECTOR_SUMMATION_SECOND_RUN : loop
          if (VECTOR_SUMMATION_DATA_ENABLE = '1' and VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_SUMMATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_ENABLE        <= '1';
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_SUMMATION_DATA_ENABLE = '1' and VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_SUMMATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_ENABLE        <= '1';
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            VECTOR_SUMMATION_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            VECTOR_SUMMATION_DATA_IN_ENABLE        <= '0';
            VECTOR_SUMMATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_SUMMATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(VECTOR_SUMMATION_SIZE_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(VECTOR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((VECTOR_SUMMATION_DATA_LENGTH_ENABLE = '1' or VECTOR_SUMMATION_START = '1') and (unsigned(index_l_loop) < unsigned(VECTOR_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_SUMMATION_SECOND_RUN when VECTOR_SUMMATION_READY = '1';
        end loop VECTOR_SUMMATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_MODULE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_VECTOR_MODULE_TEST                                     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_MODULE_LENGTH_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_VECTOR_MODULE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_MODULE_CASE 0                                   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_MODULE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_MODULE_FIRST_RUN : loop
          if (VECTOR_MODULE_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_MODULE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULE_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_MODULE_DATA_ENABLE = '1' or VECTOR_MODULE_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_MODULE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULE_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULE_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_MODULE_FIRST_RUN when VECTOR_MODULE_READY = '1';
        end loop VECTOR_MODULE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_MODULE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_VECTOR_MODULE_CASE 1                                   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_MODULE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_MODULE_SECOND_RUN : loop
          if ((VECTOR_MODULE_DATA_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_MODULE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULE_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_MODULE_DATA_ENABLE = '1') or (VECTOR_MODULE_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_MODULE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_MODULE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_MODULE_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_MODULE_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_MODULE_SECOND_RUN when VECTOR_MODULE_READY = '1';
        end loop VECTOR_MODULE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_CONVOLUTION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_CONVOLUTION_TEST                                ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_CONVOLUTION_SIZE_A_I_IN <= FOUR_CONTROL;
      MATRIX_CONVOLUTION_SIZE_A_J_IN <= FOUR_CONTROL;
      MATRIX_CONVOLUTION_SIZE_B_I_IN <= FOUR_CONTROL;
      MATRIX_CONVOLUTION_SIZE_B_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_CONVOLUTION_CASE 0                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        MATRIX_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_CONVOLUTION_FIRST_RUN : loop
          if (MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_CONVOLUTION_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_CONVOLUTION_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' or MATRIX_CONVOLUTION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_CONVOLUTION_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_CONVOLUTION_FIRST_RUN when MATRIX_CONVOLUTION_READY = '1';
        end loop MATRIX_CONVOLUTION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_CONVOLUTION_CASE 1                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        MATRIX_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_CONVOLUTION_SECOND_RUN : loop
          if (MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_CONVOLUTION_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_CONVOLUTION_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' or MATRIX_CONVOLUTION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_CONVOLUTION_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_CONVOLUTION_SECOND_RUN when MATRIX_CONVOLUTION_READY = '1';
        end loop MATRIX_CONVOLUTION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_VECTOR_CONVOLUTION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_VECTOR_CONVOLUT_TEST                            ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN <= FOUR_CONTROL;
      MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN <= FOUR_CONTROL;
      MATRIX_VECTOR_CONVOLUTION_SIZE_B_IN   <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_VECTOR_CONVOLUTION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_VECTOR_CONVOLUTION_CASE 0                       ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_VECTOR_CONVOLUTION_FIRST_RUN : loop
          if (MATRIX_VECTOR_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   <= '0';
          end if;

          -- LOOP
          if (MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' or MATRIX_VECTOR_CONVOLUTION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_VECTOR_CONVOLUTION_FIRST_RUN when MATRIX_VECTOR_CONVOLUTION_READY = '1';
        end loop MATRIX_VECTOR_CONVOLUTION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_VECTOR_CONVOLUTION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_VECTOR_CONVOL_CASE 1                            ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_VECTOR_CONVOLUTION_SECOND_RUN : loop
          if (MATRIX_VECTOR_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_CONVOLUTION_DATA_I_ENABLE = '1' and MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_VECTOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_VECTOR_CONVOLUTION_DATA_B_IN_ENABLE   <= '0';
          end if;

          -- LOOP
          if (MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_VECTOR_CONVOLUTION_DATA_J_ENABLE = '1' or MATRIX_VECTOR_CONVOLUTION_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_VECTOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_VECTOR_CONVOLUTION_SECOND_RUN when MATRIX_VECTOR_CONVOLUTION_READY = '1';
        end loop MATRIX_VECTOR_CONVOLUTION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_INVERSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_INVERSE_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_INVERSE_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_INVERSE_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_INVERSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_INVERSE_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INVERSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INVERSE_FIRST_RUN : loop
          if (MATRIX_INVERSE_DATA_I_ENABLE = '1' and MATRIX_INVERSE_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INVERSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INVERSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INVERSE_DATA_I_ENABLE = '1' and MATRIX_INVERSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INVERSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INVERSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INVERSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INVERSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INVERSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INVERSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INVERSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INVERSE_DATA_J_ENABLE = '1' or MATRIX_INVERSE_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INVERSE_FIRST_RUN when MATRIX_INVERSE_READY = '1';
        end loop MATRIX_INVERSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_INVERSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_INVERSE_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_INVERSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_INVERSE_SECOND_RUN : loop
          if (MATRIX_INVERSE_DATA_I_ENABLE = '1' and MATRIX_INVERSE_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INVERSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INVERSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INVERSE_DATA_I_ENABLE = '1' and MATRIX_INVERSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INVERSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INVERSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_INVERSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_INVERSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_INVERSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_INVERSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_INVERSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_INVERSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_INVERSE_DATA_J_ENABLE = '1' or MATRIX_INVERSE_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_INVERSE_SECOND_RUN when MATRIX_INVERSE_READY = '1';
        end loop MATRIX_INVERSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_MULTIPLICATION_TEST                             ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_MULTIPLICATION_LENGTH_IN <= FOUR_CONTROL;

      MATRIX_MULTIPLICATION_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_MULTIPLICATION_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_MULTIPLICATION_CASE 0                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_MULTIPLICATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        MATRIX_MULTIPLICATION_FIRST_RUN : loop
          if (MATRIX_MULTIPLICATION_DATA_I_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_J_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_MULTIPLICATION_DATA_I_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_J_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_MULTIPLICATION_DATA_J_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      <= '0';
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '0';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_MULTIPLICATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_MULTIPLICATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_MULTIPLICATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_MULTIPLICATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(MATRIX_MULTIPLICATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' or MATRIX_MULTIPLICATION_START = '1') and (unsigned(index_l_loop) < unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_MULTIPLICATION_FIRST_RUN when MATRIX_MULTIPLICATION_READY = '1';
        end loop MATRIX_MULTIPLICATION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_MULTIPLICATION_CASE 1                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_MULTIPLICATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        MATRIX_MULTIPLICATION_SECOND_RUN : loop
          if (MATRIX_MULTIPLICATION_DATA_I_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_J_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_MULTIPLICATION_DATA_I_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_J_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_MULTIPLICATION_DATA_J_ENABLE = '1' and MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_MULTIPLICATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_MULTIPLICATION_DATA_IN_I_ENABLE      <= '0';
            MATRIX_MULTIPLICATION_DATA_IN_J_ENABLE      <= '0';
            MATRIX_MULTIPLICATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_MULTIPLICATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_MULTIPLICATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_MULTIPLICATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_MULTIPLICATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(MATRIX_MULTIPLICATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((MATRIX_MULTIPLICATION_DATA_LENGTH_ENABLE = '1' or MATRIX_MULTIPLICATION_START = '1') and (unsigned(index_l_loop) < unsigned(MATRIX_MULTIPLICATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_MULTIPLICATION_SECOND_RUN when MATRIX_MULTIPLICATION_READY = '1';
        end loop MATRIX_MULTIPLICATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_PRODUCT_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_PRODUCT_SIZE_A_I_IN <= FOUR_CONTROL;
      MATRIX_PRODUCT_SIZE_A_J_IN <= FOUR_CONTROL;
      MATRIX_PRODUCT_SIZE_B_I_IN <= FOUR_CONTROL;
      MATRIX_PRODUCT_SIZE_B_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_PRODUCT_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_PRODUCT_DATA_A_IN <= ZERO_DATA;
        MATRIX_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_PRODUCT_FIRST_RUN : loop
          if (MATRIX_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_PRODUCT_DATA_J_ENABLE = '1' or MATRIX_PRODUCT_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_PRODUCT_FIRST_RUN when MATRIX_PRODUCT_READY = '1';
        end loop MATRIX_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_PRODUCT_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_PRODUCT_DATA_A_IN <= ZERO_DATA;
        MATRIX_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_PRODUCT_SECOND_RUN : loop
          if (MATRIX_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_PRODUCT_DATA_J_ENABLE = '1' or MATRIX_PRODUCT_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_PRODUCT_SECOND_RUN when MATRIX_PRODUCT_READY = '1';
        end loop MATRIX_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_VECTOR_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_VECTOR_PRODUCT_TEST                             ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN <= FOUR_CONTROL;
      MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN <= FOUR_CONTROL;
      MATRIX_VECTOR_PRODUCT_SIZE_B_IN   <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_VECTOR_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_VECTOR_PRODUCT_CASE 0                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_VECTOR_PRODUCT_DATA_A_IN <= ZERO_DATA;
        MATRIX_VECTOR_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_VECTOR_PRODUCT_FIRST_RUN : loop
          if (MATRIX_VECTOR_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   <= '0';
          end if;

          -- LOOP
          if (MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' or MATRIX_VECTOR_PRODUCT_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_VECTOR_PRODUCT_FIRST_RUN when MATRIX_VECTOR_PRODUCT_READY = '1';
        end loop MATRIX_VECTOR_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_VECTOR_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_VECTOR_PRODUCT_CASE 1                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_VECTOR_PRODUCT_DATA_A_IN <= ZERO_DATA;
        MATRIX_VECTOR_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_VECTOR_PRODUCT_SECOND_RUN : loop
          if (MATRIX_VECTOR_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_PRODUCT_DATA_I_ENABLE = '1' and MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   <= '1';
          elsif (MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_VECTOR_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_VECTOR_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_VECTOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_VECTOR_PRODUCT_DATA_B_IN_ENABLE   <= '0';
          end if;

          -- LOOP
          if (MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_VECTOR_PRODUCT_DATA_J_ENABLE = '1' or MATRIX_VECTOR_PRODUCT_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_VECTOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_VECTOR_PRODUCT_SECOND_RUN when MATRIX_VECTOR_PRODUCT_READY = '1';
        end loop MATRIX_VECTOR_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_SUMMATION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_SUMMATION_TEST                                  ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_SUMMATION_LENGTH_IN <= FOUR_CONTROL;

      MATRIX_SUMMATION_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_SUMMATION_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_SUMMATION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_SUMMATION_CASE 0                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_SUMMATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        MATRIX_SUMMATION_FIRST_RUN : loop
          if (MATRIX_SUMMATION_DATA_I_ENABLE = '1' and MATRIX_SUMMATION_DATA_J_ENABLE = '1' and MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_SUMMATION_DATA_I_ENABLE = '1' and MATRIX_SUMMATION_DATA_J_ENABLE = '1' and MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_SUMMATION_DATA_J_ENABLE = '1' and MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_I_ENABLE      <= '0';
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '0';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_SUMMATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SUMMATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_SUMMATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SUMMATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(MATRIX_SUMMATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' or MATRIX_SUMMATION_START = '1') and (unsigned(index_l_loop) < unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_SUMMATION_FIRST_RUN when MATRIX_SUMMATION_READY = '1';
        end loop MATRIX_SUMMATION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_SUMMATION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_SUMMATION_CASE 1                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_SUMMATION_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_l_loop <= ZERO_CONTROL;

        MATRIX_SUMMATION_SECOND_RUN : loop
          if (MATRIX_SUMMATION_DATA_I_ENABLE = '1' and MATRIX_SUMMATION_DATA_J_ENABLE = '1' and MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_SUMMATION_DATA_I_ENABLE = '1' and MATRIX_SUMMATION_DATA_J_ENABLE = '1' and MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_I_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_SUMMATION_DATA_J_ENABLE = '1' and MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '1';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          elsif (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and unsigned(index_l_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_SUMMATION_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_l_loop)));

            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_SUMMATION_DATA_IN_I_ENABLE      <= '0';
            MATRIX_SUMMATION_DATA_IN_J_ENABLE      <= '0';
            MATRIX_SUMMATION_DATA_IN_LENGTH_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_SUMMATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SUMMATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_SUMMATION_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_SUMMATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_l_loop <= ZERO_CONTROL;
          elsif (MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(MATRIX_SUMMATION_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_l_loop) = unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_l_loop <= ZERO_CONTROL;
          elsif ((MATRIX_SUMMATION_DATA_LENGTH_ENABLE = '1' or MATRIX_SUMMATION_START = '1') and (unsigned(index_l_loop) < unsigned(MATRIX_SUMMATION_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            index_l_loop <= std_logic_vector(unsigned(index_l_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_SUMMATION_SECOND_RUN when MATRIX_SUMMATION_READY = '1';
        end loop MATRIX_SUMMATION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_TRANSPOSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_MATRIX_TRANSPOSE_TEST                                  ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_TRANSPOSE_SIZE_I_IN <= FOUR_CONTROL;
      MATRIX_TRANSPOSE_SIZE_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_TRANSPOSE_CASE 0                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_TRANSPOSE_FIRST_RUN : loop
          if (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' or MATRIX_TRANSPOSE_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TRANSPOSE_FIRST_RUN when MATRIX_TRANSPOSE_READY = '1';
        end loop MATRIX_TRANSPOSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_MATRIX_TRANSPOSE_CASE 1                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_TRANSPOSE_SECOND_RUN : loop
          if (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' or MATRIX_TRANSPOSE_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TRANSPOSE_SECOND_RUN when MATRIX_TRANSPOSE_READY = '1';
        end loop MATRIX_TRANSPOSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_CONVOLUTION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_CONVOLUTION_TEST                                ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_CONVOLUTION_SIZE_A_I_IN <= FOUR_CONTROL;
      TENSOR_CONVOLUTION_SIZE_A_J_IN <= FOUR_CONTROL;
      TENSOR_CONVOLUTION_SIZE_A_K_IN <= FOUR_CONTROL;
      TENSOR_CONVOLUTION_SIZE_B_I_IN <= FOUR_CONTROL;
      TENSOR_CONVOLUTION_SIZE_B_J_IN <= FOUR_CONTROL;
      TENSOR_CONVOLUTION_SIZE_B_K_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_CONVOLUTION_CASE 0                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        TENSOR_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_CONVOLUTION_FIRST_RUN : loop
          if (TENSOR_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' or TENSOR_CONVOLUTION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_CONVOLUTION_FIRST_RUN when TENSOR_CONVOLUTION_READY = '1';
        end loop TENSOR_CONVOLUTION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_CONVOLUTION_CASE 1                              ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        TENSOR_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_CONVOLUTION_SECOND_RUN : loop
          if (TENSOR_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_CONVOLUTION_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_CONVOLUTION_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_CONVOLUTION_DATA_K_ENABLE = '1' or TENSOR_CONVOLUTION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_CONVOLUTION_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_CONVOLUTION_SECOND_RUN when TENSOR_CONVOLUTION_READY = '1';
        end loop TENSOR_CONVOLUTION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_MATRIX_CONVOLUTION_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_MATRIX_CONVOLUT_TEST                            ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_CONVOLUTION_SIZE_B_I_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_CONVOLUTION_SIZE_B_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_TENSOR_MATRIX_CONVOLUTION_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_MATRIX_CONVOLUTION_CASE 0                       ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_MATRIX_CONVOLUTION_FIRST_RUN : loop
          if (TENSOR_MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' or TENSOR_MATRIX_CONVOLUTION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_MATRIX_CONVOLUTION_FIRST_RUN when TENSOR_MATRIX_CONVOLUTION_READY = '1';
        end loop TENSOR_MATRIX_CONVOLUTION_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_MATRIX_CONVOLUTION_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_MATRIX_CONVOL_CASE 1                            ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= ZERO_DATA;
        TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_MATRIX_CONVOLUTION_SECOND_RUN : loop
          if (TENSOR_MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_I_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_J_ENABLE = '1' and TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_CONVOLUTION_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_MATRIX_CONVOLUTION_DATA_K_ENABLE = '1' or TENSOR_MATRIX_CONVOLUTION_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_MATRIX_CONVOLUTION_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_MATRIX_CONVOLUTION_SECOND_RUN when TENSOR_MATRIX_CONVOLUTION_READY = '1';
        end loop TENSOR_MATRIX_CONVOLUTION_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_INVERSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_INVERSE_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_INVERSE_SIZE_I_IN <= FOUR_CONTROL;
      TENSOR_INVERSE_SIZE_J_IN <= FOUR_CONTROL;
      TENSOR_INVERSE_SIZE_K_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_TENSOR_INVERSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_INVERSE_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INVERSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INVERSE_FIRST_RUN : loop
          if (TENSOR_INVERSE_DATA_I_ENABLE = '1' and TENSOR_INVERSE_DATA_J_ENABLE = '1' and TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INVERSE_DATA_I_ENABLE = '1' and TENSOR_INVERSE_DATA_J_ENABLE = '1' and TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INVERSE_DATA_J_ENABLE = '1' and TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INVERSE_DATA_IN_I_ENABLE <= '0';
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '0';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INVERSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INVERSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INVERSE_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INVERSE_DATA_K_ENABLE = '1' or TENSOR_INVERSE_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INVERSE_FIRST_RUN when TENSOR_INVERSE_READY = '1';
        end loop TENSOR_INVERSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_INVERSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_INVERSE_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_INVERSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_INVERSE_SECOND_RUN : loop
          if (TENSOR_INVERSE_DATA_I_ENABLE = '1' and TENSOR_INVERSE_DATA_J_ENABLE = '1' and TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INVERSE_DATA_I_ENABLE = '1' and TENSOR_INVERSE_DATA_J_ENABLE = '1' and TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INVERSE_DATA_J_ENABLE = '1' and TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_INVERSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_INVERSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_INVERSE_DATA_IN_I_ENABLE <= '0';
            TENSOR_INVERSE_DATA_IN_J_ENABLE <= '0';
            TENSOR_INVERSE_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_INVERSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INVERSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_INVERSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_INVERSE_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_INVERSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_INVERSE_DATA_K_ENABLE = '1' or TENSOR_INVERSE_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_INVERSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_INVERSE_SECOND_RUN when TENSOR_INVERSE_READY = '1';
        end loop TENSOR_INVERSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_PRODUCT_TEST                                    ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_PRODUCT_SIZE_A_I_IN <= FOUR_CONTROL;
      TENSOR_PRODUCT_SIZE_A_J_IN <= FOUR_CONTROL;
      TENSOR_PRODUCT_SIZE_A_K_IN <= FOUR_CONTROL;
      TENSOR_PRODUCT_SIZE_B_I_IN <= FOUR_CONTROL;
      TENSOR_PRODUCT_SIZE_B_J_IN <= FOUR_CONTROL;
      TENSOR_PRODUCT_SIZE_B_K_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_TENSOR_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_PRODUCT_CASE 0                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_PRODUCT_DATA_A_IN <= ZERO_DATA;
        TENSOR_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_PRODUCT_FIRST_RUN : loop
          if (TENSOR_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_K_ENABLE = '1' or TENSOR_PRODUCT_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_PRODUCT_FIRST_RUN when TENSOR_PRODUCT_READY = '1';
        end loop TENSOR_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_PRODUCT_CASE 1                                  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_PRODUCT_DATA_A_IN <= ZERO_DATA;
        TENSOR_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_PRODUCT_SECOND_RUN : loop
          if (TENSOR_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_PRODUCT_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_K_ENABLE = '1' or TENSOR_PRODUCT_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_PRODUCT_SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_PRODUCT_SECOND_RUN when TENSOR_PRODUCT_READY = '1';
        end loop TENSOR_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_MATRIX_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_MATRIX_PRODUCT_TEST                             ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_PRODUCT_SIZE_B_I_IN <= FOUR_CONTROL;
      TENSOR_MATRIX_PRODUCT_SIZE_B_J_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_TENSOR_MATRIX_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_MATRIX_PRODUCT_CASE 0                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_MATRIX_PRODUCT_DATA_A_IN <= ZERO_DATA;
        TENSOR_MATRIX_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_MATRIX_PRODUCT_FIRST_RUN : loop
          if (TENSOR_MATRIX_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' or TENSOR_MATRIX_PRODUCT_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_MATRIX_PRODUCT_FIRST_RUN when TENSOR_MATRIX_PRODUCT_READY = '1';
        end loop TENSOR_MATRIX_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_MATRIX_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_MATRIX_PRODUCT_CASE 1                           ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_MATRIX_PRODUCT_DATA_A_IN <= ZERO_DATA;
        TENSOR_MATRIX_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_MATRIX_PRODUCT_SECOND_RUN : loop
          if (TENSOR_MATRIX_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_PRODUCT_DATA_I_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_PRODUCT_DATA_J_ENABLE = '1' and TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
          elsif (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_MATRIX_PRODUCT_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_MATRIX_PRODUCT_DATA_K_ENABLE = '1' or TENSOR_MATRIX_PRODUCT_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_MATRIX_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_MATRIX_PRODUCT_SECOND_RUN when TENSOR_MATRIX_PRODUCT_READY = '1';
        end loop TENSOR_MATRIX_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_TRANSPOSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_MODEL_TENSOR_TRANSPOSE_TEST                                  ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_TRANSPOSE_SIZE_I_IN <= FOUR_CONTROL;
      TENSOR_TRANSPOSE_SIZE_J_IN <= FOUR_CONTROL;
      TENSOR_TRANSPOSE_SIZE_K_IN <= FOUR_CONTROL;

      if (STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_TRANSPOSE_CASE 0                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_TRANSPOSE_FIRST_RUN : loop
          if (TENSOR_TRANSPOSE_DATA_I_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_J_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_TRANSPOSE_DATA_I_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_J_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_TRANSPOSE_DATA_J_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' or TENSOR_TRANSPOSE_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_TRANSPOSE_FIRST_RUN when TENSOR_TRANSPOSE_READY = '1';
        end loop TENSOR_TRANSPOSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_MODEL_TENSOR_TRANSPOSE_CASE 1                                ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_TRANSPOSE_SECOND_RUN : loop
          if (TENSOR_TRANSPOSE_DATA_I_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_J_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_TRANSPOSE_DATA_I_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_J_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_TRANSPOSE_DATA_J_ENABLE = '1' and TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          elsif (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_K_ENABLE = '1' or TENSOR_TRANSPOSE_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_TRANSPOSE_SECOND_RUN when TENSOR_TRANSPOSE_READY = '1';
        end loop TENSOR_TRANSPOSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
