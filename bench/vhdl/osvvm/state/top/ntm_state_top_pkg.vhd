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

package ntm_state_top_pkg is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 512;

  constant CONTROL_X_SIZE : integer := 3;
  constant CONTROL_Y_SIZE : integer := 3;
  constant CONTROL_Z_SIZE : integer := 3;

  type tensor_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1, 0 to CONTROL_Z_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type vector_buffer is array (0 to CONTROL_X_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -- INTEGERS
  constant INT_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(0, DATA_SIZE));
  constant INT_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(1, DATA_SIZE));
  constant INT_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(2, DATA_SIZE));
  constant INT_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(3, DATA_SIZE));
  constant INT_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(4, DATA_SIZE));
  constant INT_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(5, DATA_SIZE));
  constant INT_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(6, DATA_SIZE));
  constant INT_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(7, DATA_SIZE));
  constant INT_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(8, DATA_SIZE));
  constant INT_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(9, DATA_SIZE));

  constant INT_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-1, DATA_SIZE));
  constant INT_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-2, DATA_SIZE));
  constant INT_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-3, DATA_SIZE));
  constant INT_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-4, DATA_SIZE));
  constant INT_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-5, DATA_SIZE));
  constant INT_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-6, DATA_SIZE));
  constant INT_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-7, DATA_SIZE));
  constant INT_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-8, DATA_SIZE));
  constant INT_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_signed(-9, DATA_SIZE));

  -- FLOATS
  constant FLOAT_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"00000000";
  constant FLOAT_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"3f8ccccd";
  constant FLOAT_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"400ccccd";
  constant FLOAT_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"40533333";
  constant FLOAT_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"408ccccd";
  constant FLOAT_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"40b00000";
  constant FLOAT_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"40d33333";
  constant FLOAT_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"40f66666";
  constant FLOAT_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"410ccccd";
  constant FLOAT_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"411e6666";
  constant FLOAT_P_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"7f800000";

  constant FLOAT_N_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"80000000";
  constant FLOAT_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"bf8ccccd";
  constant FLOAT_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"c00ccccd";
  constant FLOAT_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0533333";
  constant FLOAT_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c08ccccd";
  constant FLOAT_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0b00000";
  constant FLOAT_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0d33333";
  constant FLOAT_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"c0f66666";
  constant FLOAT_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"c10ccccd";
  constant FLOAT_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"c11e6666";
  constant FLOAT_N_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"ff800000";

  -- Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((INT_P_TWO, INT_P_ONE, INT_P_FOUR), (INT_P_NINE, INT_P_FOUR, INT_P_TWO), (INT_P_ONE, INT_P_ONE, INT_P_TWO)), ((INT_P_EIGHT, INT_P_SIX, INT_P_TWO), (INT_P_EIGHT, INT_P_FIVE, INT_P_TWO), (INT_P_ONE, INT_P_FOUR, INT_P_ONE)), ((INT_P_THREE, INT_P_ONE, INT_P_SIX), (INT_P_FIVE, INT_P_ZERO, INT_P_FOUR), (INT_P_FIVE, INT_P_EIGHT, INT_P_FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((INT_P_ONE, INT_P_THREE, INT_P_ONE), (INT_P_TWO, INT_P_FOUR, INT_P_EIGHT), (INT_P_FOUR, INT_P_ONE, INT_P_TWO)), ((INT_P_NINE, INT_P_ONE, INT_P_FIVE), (INT_P_NINE, INT_P_EIGHT, INT_P_ONE), (INT_P_FIVE, INT_P_EIGHT, INT_P_FOUR)), ((INT_P_FIVE, INT_P_FOUR, INT_P_ONE), (INT_P_THREE, INT_P_FOUR, INT_P_SIX), (INT_P_ONE, INT_P_EIGHT, INT_P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((INT_P_ONE, INT_P_FOUR, INT_P_ONE), (INT_P_ZERO, INT_P_EIGHT, INT_P_FOUR), (INT_P_FIVE, INT_P_THREE, INT_P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((INT_P_ONE, INT_P_TWO, INT_P_SIX), (INT_P_ONE, INT_P_THREE, INT_P_SIX), (INT_P_EIGHT, INT_P_FOUR, INT_P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (INT_P_FOUR, INT_P_SEVEN, INT_N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (INT_P_THREE, INT_N_NINE, INT_N_ONE);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := INT_P_NINE;
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := INT_N_FOUR;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_state_top is
    generic (
      DATA_SIZE    : integer := 128;
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

      DATA_X_OUT_ENABLE : out std_logic;
      DATA_Y_OUT_ENABLE : out std_logic;

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

      DATA_X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      DATA_Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end ntm_state_top_pkg;
