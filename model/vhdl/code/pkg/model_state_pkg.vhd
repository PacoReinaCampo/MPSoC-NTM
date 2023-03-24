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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;

package model_state_pkg is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  constant INITIAL_X : vector_buffer := (others => (others => '0'));

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- STATE - TOP
  ------------------------------------------------------------------------------

  component model_state_top is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
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
      DATA_C_IN_I_ENABLE : in std_logic;
      DATA_C_IN_J_ENABLE : in std_logic;
      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_A_I_ENABLE : out std_logic;
      DATA_A_J_ENABLE : out std_logic;
      DATA_B_I_ENABLE : out std_logic;
      DATA_B_J_ENABLE : out std_logic;
      DATA_C_I_ENABLE : out std_logic;
      DATA_C_J_ENABLE : out std_logic;
      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_U_IN_ENABLE : in std_logic;

      DATA_U_ENABLE : out std_logic;

      DATA_Y_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- STATE - OUTPUTS
  ------------------------------------------------------------------------------

  component model_state_vector_output is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
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
      DATA_C_IN_I_ENABLE : in std_logic;
      DATA_C_IN_J_ENABLE : in std_logic;
      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_A_I_ENABLE : out std_logic;
      DATA_A_J_ENABLE : out std_logic;
      DATA_B_I_ENABLE : out std_logic;
      DATA_B_J_ENABLE : out std_logic;
      DATA_C_I_ENABLE : out std_logic;
      DATA_C_J_ENABLE : out std_logic;
      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_U_IN_ENABLE : in std_logic;

      DATA_U_ENABLE : out std_logic;

      DATA_Y_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_state_vector_state is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
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
      DATA_C_IN_I_ENABLE : in std_logic;
      DATA_C_IN_J_ENABLE : in std_logic;
      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_A_I_ENABLE : out std_logic;
      DATA_A_J_ENABLE : out std_logic;
      DATA_B_I_ENABLE : out std_logic;
      DATA_B_J_ENABLE : out std_logic;
      DATA_C_I_ENABLE : out std_logic;
      DATA_C_J_ENABLE : out std_logic;
      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_U_IN_ENABLE : in std_logic;

      DATA_U_ENABLE : out std_logic;

      DATA_X_OUT_ENABLE : out std_logic;

      -- DATA
      LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- STATE - FEEDBACK
  ------------------------------------------------------------------------------

  component model_state_matrix_state is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
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
      DATA_C_IN_I_ENABLE : in std_logic;
      DATA_C_IN_J_ENABLE : in std_logic;
      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_A_I_ENABLE : out std_logic;
      DATA_A_J_ENABLE : out std_logic;
      DATA_B_I_ENABLE : out std_logic;
      DATA_B_J_ENABLE : out std_logic;
      DATA_C_I_ENABLE : out std_logic;
      DATA_C_J_ENABLE : out std_logic;
      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_A_OUT_I_ENABLE : out std_logic;
      DATA_A_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_state_matrix_input is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_B_IN_I_ENABLE : in std_logic;
      DATA_B_IN_J_ENABLE : in std_logic;
      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_B_I_ENABLE : out std_logic;
      DATA_B_J_ENABLE : out std_logic;
      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_B_OUT_I_ENABLE : out std_logic;
      DATA_B_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_state_matrix_output is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_C_IN_I_ENABLE : in std_logic;
      DATA_C_IN_J_ENABLE : in std_logic;
      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_C_I_ENABLE : out std_logic;
      DATA_C_J_ENABLE : out std_logic;
      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_C_OUT_I_ENABLE : out std_logic;
      DATA_C_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_state_matrix_feedforward is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      DATA_D_IN_I_ENABLE : in std_logic;
      DATA_D_IN_J_ENABLE : in std_logic;

      DATA_D_I_ENABLE : out std_logic;
      DATA_D_J_ENABLE : out std_logic;

      DATA_K_IN_I_ENABLE : in std_logic;
      DATA_K_IN_J_ENABLE : in std_logic;

      DATA_K_I_ENABLE : out std_logic;
      DATA_K_J_ENABLE : out std_logic;

      DATA_D_OUT_I_ENABLE : out std_logic;
      DATA_D_OUT_J_ENABLE : out std_logic;

      -- DATA
      SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      DATA_D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  function function_matrix_identity (
    SIZE_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0)
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- STATE - FEEDBACK
  ------------------------------------------------------------------------------

  function function_state_matrix_state (
    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer;

  function function_state_matrix_input (
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_b_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer;

  function function_state_matrix_output (
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer;

  function function_state_matrix_feedforward (
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- STATE - OUTPUTS
  ------------------------------------------------------------------------------

  function function_state_vector_output (
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;

    matrix_data_k_input : in matrix_buffer;

    vector_data_u_input : in vector_buffer
    ) return vector_buffer;

  function function_state_vector_state (
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;

    matrix_data_k_input : in matrix_buffer;

    vector_data_u_input : in vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- STATE - TOP
  ------------------------------------------------------------------------------

  function function_state_top (
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;

    matrix_data_k_input : in matrix_buffer;

    vector_data_u_input : in vector_buffer
    ) return vector_buffer;

end model_state_pkg;

package body model_state_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  function function_matrix_identity (
    SIZE_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0)
    ) return matrix_buffer is

    variable matrix_output : matrix_buffer;

  begin

    for i in 0 to to_integer(unsigned(SIZE_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_IN))-1 loop
        if i = j then
          matrix_output(i, j) := ONE_DATA;
        else
          matrix_output(i, j) := ZERO_DATA;
        end if;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_identity;

  ------------------------------------------------------------------------------
  -- STATE - FEEDBACK
  ------------------------------------------------------------------------------

  function function_state_matrix_state (
    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer is

    variable MATRIX_IDENTITY : matrix_buffer;

    variable matrix_first_product  : matrix_buffer;
    variable matrix_second_product : matrix_buffer;
    variable matrix_adder          : matrix_buffer;
    variable matrix_inverse        : matrix_buffer;

    variable matrix_a_output : matrix_buffer;

  begin

    -- a = A-B·K·inv(I+D·K)·C

    MATRIX_IDENTITY := function_matrix_identity(SIZE_D_I_IN);

    matrix_first_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_D_I_IN,
      SIZE_A_J_IN => SIZE_D_J_IN,
      SIZE_B_I_IN => SIZE_K_I_IN,
      SIZE_B_J_IN => SIZE_K_J_IN,

      matrix_a_input => matrix_data_d_input,
      matrix_b_input => matrix_data_k_input
      );

    matrix_adder := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_a_input => MATRIX_IDENTITY,
      matrix_b_input => matrix_first_product
      );

    matrix_inverse := function_matrix_inverse (
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_input => matrix_adder
      );

    matrix_first_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_K_I_IN,
      SIZE_A_J_IN => SIZE_K_J_IN,
      SIZE_B_I_IN => SIZE_K_J_IN,
      SIZE_B_J_IN => SIZE_D_I_IN,

      matrix_a_input => matrix_data_k_input,
      matrix_b_input => matrix_inverse
      );

    matrix_second_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_B_I_IN,
      SIZE_A_J_IN => SIZE_B_J_IN,
      SIZE_B_I_IN => SIZE_K_I_IN,
      SIZE_B_J_IN => SIZE_K_J_IN,

      matrix_a_input => matrix_data_b_input,
      matrix_b_input => matrix_first_product
      );

    matrix_first_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_B_I_IN,
      SIZE_A_J_IN => SIZE_K_J_IN,
      SIZE_B_I_IN => SIZE_C_I_IN,
      SIZE_B_J_IN => SIZE_C_J_IN,

      matrix_a_input => matrix_second_product,
      matrix_b_input => matrix_data_c_input
      );

    matrix_a_output := function_matrix_float_adder (
      OPERATION => '1',

      SIZE_I_IN => SIZE_B_I_IN,
      SIZE_J_IN => SIZE_C_J_IN,

      matrix_a_input => matrix_data_a_input,
      matrix_b_input => matrix_first_product
      );

    return matrix_a_output;
  end function function_state_matrix_state;

  function function_state_matrix_input (
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_b_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer is

    variable MATRIX_IDENTITY : matrix_buffer;

    variable matrix_first_product  : matrix_buffer;
    variable matrix_second_product : matrix_buffer;
    variable matrix_adder          : matrix_buffer;
    variable matrix_inverse        : matrix_buffer;

    variable matrix_b_output : matrix_buffer;

  begin

    -- b = B·(I-K·inv(I+D·K)·D)

    MATRIX_IDENTITY := function_matrix_identity(SIZE_D_I_IN);

    matrix_first_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_D_I_IN,
      SIZE_A_J_IN => SIZE_D_J_IN,
      SIZE_B_I_IN => SIZE_K_I_IN,
      SIZE_B_J_IN => SIZE_K_J_IN,

      matrix_a_input => matrix_data_d_input,
      matrix_b_input => matrix_data_k_input
      );

    matrix_adder := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_a_input => MATRIX_IDENTITY,
      matrix_b_input => matrix_first_product
      );

    matrix_inverse := function_matrix_inverse (
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_input => matrix_adder
      );

    matrix_first_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_K_I_IN,
      SIZE_A_J_IN => SIZE_K_J_IN,
      SIZE_B_I_IN => SIZE_K_J_IN,
      SIZE_B_J_IN => SIZE_D_I_IN,

      matrix_a_input => matrix_data_k_input,
      matrix_b_input => matrix_inverse
      );

    matrix_second_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_K_I_IN,
      SIZE_A_J_IN => SIZE_K_J_IN,
      SIZE_B_I_IN => SIZE_D_I_IN,
      SIZE_B_J_IN => SIZE_D_J_IN,

      matrix_a_input => matrix_first_product,
      matrix_b_input => matrix_data_d_input
      );

    matrix_adder := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_K_I_IN,
      SIZE_J_IN => SIZE_D_J_IN,

      matrix_a_input => MATRIX_IDENTITY,
      matrix_b_input => matrix_second_product
      );

    matrix_b_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_B_I_IN,
      SIZE_A_J_IN => SIZE_B_J_IN,
      SIZE_B_I_IN => SIZE_K_I_IN,
      SIZE_B_J_IN => SIZE_B_J_IN,

      matrix_a_input => matrix_data_b_input,
      matrix_b_input => matrix_adder
      );

    return matrix_b_output;
  end function function_state_matrix_input;

  function function_state_matrix_output (
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer is

    variable MATRIX_IDENTITY : matrix_buffer;

    variable matrix_product : matrix_buffer;
    variable matrix_adder   : matrix_buffer;
    variable matrix_inverse : matrix_buffer;

    variable matrix_c_output : matrix_buffer;

  begin

    -- c = inv(I+D·K)·C

    MATRIX_IDENTITY := function_matrix_identity(SIZE_D_I_IN);

    matrix_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_D_I_IN,
      SIZE_A_J_IN => SIZE_D_J_IN,
      SIZE_B_I_IN => SIZE_K_I_IN,
      SIZE_B_J_IN => SIZE_K_J_IN,

      matrix_a_input => matrix_data_d_input,
      matrix_b_input => matrix_data_k_input
      );

    matrix_adder := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_a_input => MATRIX_IDENTITY,
      matrix_b_input => matrix_product
      );

    matrix_inverse := function_matrix_inverse (
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_input => matrix_adder
      );

    matrix_c_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_K_J_IN,
      SIZE_A_J_IN => SIZE_D_I_IN,
      SIZE_B_I_IN => SIZE_C_I_IN,
      SIZE_B_J_IN => SIZE_C_J_IN,

      matrix_a_input => matrix_inverse,
      matrix_b_input => matrix_data_c_input
      );

    return matrix_c_output;
  end function function_state_matrix_output;

  function function_state_matrix_feedforward (
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_d_input : in matrix_buffer;
    matrix_data_k_input : in matrix_buffer
    ) return matrix_buffer is

    variable MATRIX_IDENTITY : matrix_buffer;

    variable matrix_product : matrix_buffer;
    variable matrix_adder   : matrix_buffer;
    variable matrix_inverse : matrix_buffer;

    variable matrix_d_output : matrix_buffer;

  begin

    -- d = inv(I+D·K)·D

    MATRIX_IDENTITY := function_matrix_identity(SIZE_D_I_IN);

    matrix_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_D_I_IN,
      SIZE_A_J_IN => SIZE_D_J_IN,
      SIZE_B_I_IN => SIZE_K_I_IN,
      SIZE_B_J_IN => SIZE_K_J_IN,

      matrix_a_input => matrix_data_d_input,
      matrix_b_input => matrix_data_k_input
      );

    matrix_adder := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_a_input => MATRIX_IDENTITY,
      matrix_b_input => matrix_product
      );

    matrix_inverse := function_matrix_inverse (
      SIZE_I_IN => SIZE_D_I_IN,
      SIZE_J_IN => SIZE_K_J_IN,

      matrix_input => matrix_adder
      );

    matrix_d_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_K_J_IN,
      SIZE_A_J_IN => SIZE_D_I_IN,
      SIZE_B_I_IN => SIZE_D_I_IN,
      SIZE_B_J_IN => SIZE_D_J_IN,

      matrix_a_input => matrix_inverse,
      matrix_b_input => matrix_data_d_input
      );

    return matrix_d_output;
  end function function_state_matrix_feedforward;

  ------------------------------------------------------------------------------
  -- STATE - OUTPUTS
  ------------------------------------------------------------------------------

  function function_state_vector_output (
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;

    matrix_data_k_input : in matrix_buffer;

    vector_data_u_input : in vector_buffer
    ) return vector_buffer is

    variable matrix_data_a_int : matrix_buffer;
    variable matrix_data_b_int : matrix_buffer;
    variable matrix_data_c_int : matrix_buffer;
    variable matrix_data_d_int : matrix_buffer;

    variable matrix_exponent : matrix_buffer;

    variable matrix_first_product  : matrix_buffer;
    variable matrix_second_product : matrix_buffer;

    variable vector_product : vector_buffer;

    variable data_summation_int : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- x(k+1) = A·x(k) + B·u(k)
    -- y(k) = C·x(k) + D·u(k)

    matrix_data_a_int := function_state_matrix_state (
      SIZE_A_I_IN => SIZE_A_I_IN,
      SIZE_A_J_IN => SIZE_A_J_IN,
      SIZE_B_I_IN => SIZE_B_I_IN,
      SIZE_B_J_IN => SIZE_B_J_IN,
      SIZE_C_I_IN => SIZE_C_I_IN,
      SIZE_C_J_IN => SIZE_C_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_a_input => matrix_data_a_input,
      matrix_data_b_input => matrix_data_b_input,
      matrix_data_c_input => matrix_data_c_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    matrix_data_b_int := function_state_matrix_input (
      SIZE_B_I_IN => SIZE_B_I_IN,
      SIZE_B_J_IN => SIZE_B_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_b_input => matrix_data_b_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    matrix_data_c_int := function_state_matrix_output (
      SIZE_C_I_IN => SIZE_C_I_IN,
      SIZE_C_J_IN => SIZE_C_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_c_input => matrix_data_c_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    matrix_data_d_int := function_state_matrix_feedforward (
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    -- y(k) = C·exp(A,k)·x(0) + summation(C·exp(A,k-j)·B·u(j))[j in 0 to k-1] + D·u(k)

    matrix_exponent := matrix_data_a_int;

    for i in 0 to to_integer(unsigned(LENGTH_K_IN))-1 loop
      matrix_exponent := function_matrix_product (
        SIZE_A_I_IN => SIZE_A_I_IN,
        SIZE_A_J_IN => SIZE_A_J_IN,
        SIZE_B_I_IN => SIZE_A_I_IN,
        SIZE_B_J_IN => SIZE_A_J_IN,

        matrix_a_input => matrix_data_a_int,
        matrix_b_input => matrix_exponent
        );
    end loop;

    matrix_first_product := function_matrix_product (
      SIZE_A_I_IN => SIZE_C_I_IN,
      SIZE_A_J_IN => SIZE_C_J_IN,
      SIZE_B_I_IN => SIZE_A_I_IN,
      SIZE_B_J_IN => SIZE_A_J_IN,

      matrix_a_input => matrix_data_c_int,
      matrix_b_input => matrix_exponent
      );

    vector_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_C_I_IN,
      SIZE_A_J_IN => SIZE_A_J_IN,
      SIZE_B_IN   => SIZE_A_J_IN,

      matrix_a_input => matrix_first_product,
      vector_b_input => INITIAL_X
      );

    -- Initial Summation
    data_summation_int := vector_product;

    -- Summation
    for j in 0 to to_integer(unsigned(LENGTH_K_IN))-1 loop

      matrix_exponent := matrix_data_a_int;

      for i in 0 to to_integer(unsigned(LENGTH_K_IN))-j loop
        matrix_exponent := function_matrix_product (
          SIZE_A_I_IN => SIZE_A_I_IN,
          SIZE_A_J_IN => SIZE_A_J_IN,
          SIZE_B_I_IN => SIZE_A_I_IN,
          SIZE_B_J_IN => SIZE_A_J_IN,

          matrix_a_input => matrix_data_a_int,
          matrix_b_input => matrix_exponent
          );
      end loop;

      matrix_first_product := function_matrix_product (
        SIZE_A_I_IN => SIZE_C_I_IN,
        SIZE_A_J_IN => SIZE_C_J_IN,
        SIZE_B_I_IN => SIZE_A_I_IN,
        SIZE_B_J_IN => SIZE_A_J_IN,

        matrix_a_input => matrix_data_c_int,
        matrix_b_input => matrix_exponent
        );

      matrix_second_product := function_matrix_product (
        SIZE_A_I_IN => SIZE_C_I_IN,
        SIZE_A_J_IN => SIZE_A_J_IN,
        SIZE_B_I_IN => SIZE_B_I_IN,
        SIZE_B_J_IN => SIZE_B_J_IN,

        matrix_a_input => matrix_first_product,
        matrix_b_input => matrix_data_b_int
        );

      vector_product := function_matrix_vector_product (
        SIZE_A_I_IN => SIZE_C_I_IN,
        SIZE_A_J_IN => SIZE_A_J_IN,
        SIZE_B_IN   => SIZE_A_J_IN,

        matrix_a_input => matrix_second_product,
        vector_b_input => vector_data_u_input
        );

      data_summation_int := function_vector_float_adder (
        OPERATION => '0',

        SIZE_IN => SIZE_A_J_IN,

        vector_a_input => data_summation_int,
        vector_b_input => vector_product
        );

    end loop;

    vector_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_D_I_IN,
      SIZE_A_J_IN => SIZE_D_J_IN,
      SIZE_B_IN   => SIZE_D_J_IN,

      matrix_a_input => matrix_data_d_int,
      vector_b_input => vector_data_u_input
      );

    vector_y_output := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_A_J_IN,

      vector_a_input => data_summation_int,
      vector_b_input => vector_product
      );

    return vector_y_output;
  end function function_state_vector_output;

  function function_state_vector_state (
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;

    matrix_data_k_input : in matrix_buffer;

    vector_data_u_input : in vector_buffer
    ) return vector_buffer is

    variable matrix_data_a_int : matrix_buffer;
    variable matrix_data_b_int : matrix_buffer;
    variable matrix_data_c_int : matrix_buffer;
    variable matrix_data_d_int : matrix_buffer;

    variable matrix_exponent : matrix_buffer;
    variable matrix_product  : matrix_buffer;

    variable vector_product : vector_buffer;

    variable vector_x_output : vector_buffer;

  begin

    -- x(k+1) = A·x(k) + B·u(k)
    -- y(k) = C·x(k) + D·u(k)

    matrix_data_a_int := function_state_matrix_state (
      SIZE_A_I_IN => SIZE_A_I_IN,
      SIZE_A_J_IN => SIZE_A_J_IN,
      SIZE_B_I_IN => SIZE_B_I_IN,
      SIZE_B_J_IN => SIZE_B_J_IN,
      SIZE_C_I_IN => SIZE_C_I_IN,
      SIZE_C_J_IN => SIZE_C_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_a_input => matrix_data_a_input,
      matrix_data_b_input => matrix_data_b_input,
      matrix_data_c_input => matrix_data_c_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    matrix_data_b_int := function_state_matrix_input (
      SIZE_B_I_IN => SIZE_B_I_IN,
      SIZE_B_J_IN => SIZE_B_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_b_input => matrix_data_b_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    matrix_data_c_int := function_state_matrix_output (
      SIZE_C_I_IN => SIZE_C_I_IN,
      SIZE_C_J_IN => SIZE_C_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_c_input => matrix_data_c_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    matrix_data_d_int := function_state_matrix_feedforward (
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input
      );

    -- x(k) = exp(A,k)·x(0) + summation(exp(A,k-j-1)·B·u(j))[j in 0 to k-1]

    matrix_exponent := matrix_data_a_int;

    for i in 0 to to_integer(unsigned(LENGTH_K_IN))-1 loop
      matrix_exponent := function_matrix_product (
        SIZE_A_I_IN => SIZE_A_I_IN,
        SIZE_A_J_IN => SIZE_A_J_IN,
        SIZE_B_I_IN => SIZE_A_I_IN,
        SIZE_B_J_IN => SIZE_A_J_IN,

        matrix_a_input => matrix_data_a_int,
        matrix_b_input => matrix_exponent
        );
    end loop;

    vector_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_C_I_IN,
      SIZE_A_J_IN => SIZE_A_J_IN,
      SIZE_B_IN   => SIZE_A_J_IN,

      matrix_a_input => matrix_exponent,
      vector_b_input => INITIAL_X
      );

    -- Initial Summation
    vector_x_output := vector_product;

    -- Summation
    for j in 0 to to_integer(unsigned(LENGTH_K_IN))-1 loop

      matrix_exponent := matrix_data_a_int;

      for i in 0 to to_integer(unsigned(LENGTH_K_IN))-j loop
        matrix_exponent := function_matrix_product (
          SIZE_A_I_IN => SIZE_A_I_IN,
          SIZE_A_J_IN => SIZE_A_J_IN,
          SIZE_B_I_IN => SIZE_A_I_IN,
          SIZE_B_J_IN => SIZE_A_J_IN,

          matrix_a_input => matrix_data_a_int,
          matrix_b_input => matrix_exponent
          );
      end loop;

      matrix_product := function_matrix_product (
        SIZE_A_I_IN => SIZE_A_I_IN,
        SIZE_A_J_IN => SIZE_A_J_IN,
        SIZE_B_I_IN => SIZE_B_I_IN,
        SIZE_B_J_IN => SIZE_B_J_IN,

        matrix_a_input => matrix_exponent,
        matrix_b_input => matrix_data_b_int
        );

      vector_product := function_matrix_vector_product (
        SIZE_A_I_IN => SIZE_A_I_IN,
        SIZE_A_J_IN => SIZE_B_J_IN,
        SIZE_B_IN   => SIZE_B_J_IN,

        matrix_a_input => matrix_product,
        vector_b_input => vector_data_u_input
        );

      vector_x_output := function_vector_float_adder (
        OPERATION => '0',

        SIZE_IN => SIZE_A_J_IN,

        vector_a_input => vector_x_output,
        vector_b_input => vector_product
        );

    end loop;

    return vector_x_output;
  end function function_state_vector_state;

  ------------------------------------------------------------------------------
  -- STATE - TOP
  ------------------------------------------------------------------------------

  function function_state_top (
    LENGTH_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    SIZE_K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_data_a_input : in matrix_buffer;
    matrix_data_b_input : in matrix_buffer;
    matrix_data_c_input : in matrix_buffer;
    matrix_data_d_input : in matrix_buffer;

    matrix_data_k_input : in matrix_buffer;

    vector_data_u_input : in vector_buffer
    ) return vector_buffer is

    variable vector_y_output : vector_buffer;

  begin

    -- x(k+1) = A·x(k) + B·u(k)
    -- y(k) = C·x(k) + D·u(k)

    -- x(k) = exp(A,k)·x(0) + summation(exp(A,k-j-1)·B·u(j))[j in 0 to k-1]
    -- y(k) = C·exp(A,k)·x(0) + summation(C·exp(A,k-j)·B·u(j))[j in 0 to k-1] + D·u(k)

    -- SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P]; K[P,P]; x[N,1]; y[Q,1]; u[P,1];

    vector_y_output := function_state_vector_output (
      LENGTH_K_IN => LENGTH_K_IN,

      SIZE_A_I_IN => SIZE_A_I_IN,
      SIZE_A_J_IN => SIZE_A_J_IN,
      SIZE_B_I_IN => SIZE_B_I_IN,
      SIZE_B_J_IN => SIZE_B_J_IN,
      SIZE_C_I_IN => SIZE_C_I_IN,
      SIZE_C_J_IN => SIZE_C_J_IN,
      SIZE_D_I_IN => SIZE_D_I_IN,
      SIZE_D_J_IN => SIZE_D_J_IN,

      SIZE_K_I_IN => SIZE_K_I_IN,
      SIZE_K_J_IN => SIZE_K_J_IN,

      matrix_data_a_input => matrix_data_a_input,
      matrix_data_b_input => matrix_data_b_input,
      matrix_data_c_input => matrix_data_c_input,
      matrix_data_d_input => matrix_data_d_input,

      matrix_data_k_input => matrix_data_k_input,

      vector_data_u_input => vector_data_u_input
      );

    return vector_y_output;
  end function function_state_top;

end model_state_pkg;
