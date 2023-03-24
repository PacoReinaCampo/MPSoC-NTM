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

package model_memory_pkg is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant DATA_SIZE : integer := 64;

  constant CONTROL_X_SIZE : integer := 3;
  constant CONTROL_Y_SIZE : integer := 3;
  constant CONTROL_Z_SIZE : integer := 3;

  type tensor_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1, 0 to CONTROL_Z_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (0 to CONTROL_X_SIZE-1, 0 to CONTROL_Y_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);
  type vector_buffer is array (0 to CONTROL_X_SIZE-1) of std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  signal MONITOR_TEST : string(40 downto 1) := "                                        ";
  signal MONITOR_CASE : string(40 downto 1) := "                                        ";

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  -- SYSTEM-SIZE
  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

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
  constant FLOAT_P_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"0000000000000000";
  constant FLOAT_P_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"3FF199999999999A";
  constant FLOAT_P_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"400199999999999A";
  constant FLOAT_P_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"400A666666666666";
  constant FLOAT_P_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"401199999999999A";
  constant FLOAT_P_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"4016000000000000";
  constant FLOAT_P_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"401A666666666666";
  constant FLOAT_P_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"401ECCCCCCCCCCCD";
  constant FLOAT_P_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"402199999999999A";
  constant FLOAT_P_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"4023CCCCCCCCCCCD";
  constant FLOAT_P_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"7FF0000000000000";

  constant FLOAT_N_ZERO  : std_logic_vector(DATA_SIZE-1 downto 0) := X"8000000000000000";
  constant FLOAT_N_ONE   : std_logic_vector(DATA_SIZE-1 downto 0) := X"BFF199999999999A";
  constant FLOAT_N_TWO   : std_logic_vector(DATA_SIZE-1 downto 0) := X"C00199999999999A";
  constant FLOAT_N_THREE : std_logic_vector(DATA_SIZE-1 downto 0) := X"C00A666666666666";
  constant FLOAT_N_FOUR  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01199999999999A";
  constant FLOAT_N_FIVE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C016000000000000";
  constant FLOAT_N_SIX   : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01A666666666666";
  constant FLOAT_N_SEVEN : std_logic_vector(DATA_SIZE-1 downto 0) := X"C01ECCCCCCCCCCCD";
  constant FLOAT_N_EIGHT : std_logic_vector(DATA_SIZE-1 downto 0) := X"C02199999999999A";
  constant FLOAT_N_NINE  : std_logic_vector(DATA_SIZE-1 downto 0) := X"C023CCCCCCCCCCCD";
  constant FLOAT_N_INF   : std_logic_vector(DATA_SIZE-1 downto 0) := X"FFF0000000000000";

  -- Buffer
  constant TENSOR_SAMPLE_A : tensor_buffer := (((FLOAT_P_TWO, FLOAT_P_ONE, FLOAT_P_FOUR), (FLOAT_P_NINE, FLOAT_P_FOUR, FLOAT_P_TWO), (FLOAT_P_ONE, FLOAT_P_ONE, FLOAT_P_TWO)), ((FLOAT_P_EIGHT, FLOAT_P_SIX, FLOAT_P_TWO), (FLOAT_P_EIGHT, FLOAT_P_FIVE, FLOAT_P_TWO), (FLOAT_P_ONE, FLOAT_P_FOUR, FLOAT_P_ONE)), ((FLOAT_P_THREE, FLOAT_P_ONE, FLOAT_P_SIX), (FLOAT_P_FIVE, FLOAT_P_ZERO, FLOAT_P_FOUR), (FLOAT_P_FIVE, FLOAT_P_EIGHT, FLOAT_P_FIVE)));
  constant TENSOR_SAMPLE_B : tensor_buffer := (((FLOAT_P_ONE, FLOAT_P_THREE, FLOAT_P_ONE), (FLOAT_P_TWO, FLOAT_P_FOUR, FLOAT_P_EIGHT), (FLOAT_P_FOUR, FLOAT_P_ONE, FLOAT_P_TWO)), ((FLOAT_P_NINE, FLOAT_P_ONE, FLOAT_P_FIVE), (FLOAT_P_NINE, FLOAT_P_EIGHT, FLOAT_P_ONE), (FLOAT_P_FIVE, FLOAT_P_EIGHT, FLOAT_P_FOUR)), ((FLOAT_P_FIVE, FLOAT_P_FOUR, FLOAT_P_ONE), (FLOAT_P_THREE, FLOAT_P_FOUR, FLOAT_P_SIX), (FLOAT_P_ONE, FLOAT_P_EIGHT, FLOAT_P_EIGHT)));

  constant MATRIX_SAMPLE_A : matrix_buffer := ((FLOAT_P_ONE, FLOAT_P_FOUR, FLOAT_P_ONE), (FLOAT_P_ZERO, FLOAT_P_EIGHT, FLOAT_P_FOUR), (FLOAT_P_FIVE, FLOAT_P_THREE, FLOAT_P_NINE));
  constant MATRIX_SAMPLE_B : matrix_buffer := ((FLOAT_P_ONE, FLOAT_P_TWO, FLOAT_P_SIX), (FLOAT_P_ONE, FLOAT_P_THREE, FLOAT_P_SIX), (FLOAT_P_EIGHT, FLOAT_P_FOUR, FLOAT_P_FOUR));

  constant VECTOR_SAMPLE_A : vector_buffer := (FLOAT_P_FOUR, FLOAT_P_SEVEN, FLOAT_N_THREE);
  constant VECTOR_SAMPLE_B : vector_buffer := (FLOAT_P_THREE, FLOAT_N_NINE, FLOAT_N_ONE);

  constant SCALAR_SAMPLE_A : std_logic_vector(DATA_SIZE-1 downto 0) := FLOAT_P_NINE;
  constant SCALAR_SAMPLE_B : std_logic_vector(DATA_SIZE-1 downto 0) := FLOAT_N_FOUR;

  -- FUNCTIONALITY
  signal STIMULUS_DNC_MEMORY_FORWARD_WEIGHTING_TEST   : boolean := false;
  signal STIMULUS_DNC_MEMORY_FORWARD_WEIGHTING_CASE_0 : boolean := false;
  signal STIMULUS_DNC_MEMORY_FORWARD_WEIGHTING_CASE_1 : boolean := false;

  signal STIMULUS_DNC_MEMORY_SORT_VECTOR_TEST   : boolean := false;
  signal STIMULUS_DNC_MEMORY_SORT_VECTOR_CASE_0 : boolean := false;
  signal STIMULUS_DNC_MEMORY_SORT_VECTOR_CASE_1 : boolean := false;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component model_memory_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE    : integer := 128;
      CONTROL_SIZE : integer := 64;

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

      -- FORWARD WEIGHTING
      -- CONTROL
      DNC_MEMORY_FORWARD_WEIGHTING_START : out std_logic;
      DNC_MEMORY_FORWARD_WEIGHTING_READY : in  std_logic;

      DNC_MEMORY_FORWARD_WEIGHTING_L_IN_G_ENABLE : out std_logic;
      DNC_MEMORY_FORWARD_WEIGHTING_L_IN_J_ENABLE : out std_logic;

      DNC_MEMORY_FORWARD_WEIGHTING_L_OUT_G_ENABLE : in std_logic;
      DNC_MEMORY_FORWARD_WEIGHTING_L_OUT_J_ENABLE : in std_logic;

      DNC_MEMORY_FORWARD_WEIGHTING_W_IN_I_ENABLE : out std_logic;
      DNC_MEMORY_FORWARD_WEIGHTING_W_IN_J_ENABLE : out std_logic;

      DNC_MEMORY_FORWARD_WEIGHTING_W_OUT_I_ENABLE : in std_logic;
      DNC_MEMORY_FORWARD_WEIGHTING_W_OUT_J_ENABLE : in std_logic;

      DNC_MEMORY_FORWARD_WEIGHTING_F_OUT_I_ENABLE : in std_logic;
      DNC_MEMORY_FORWARD_WEIGHTING_F_OUT_J_ENABLE : in std_logic;

      -- DATA
      DNC_MEMORY_FORWARD_WEIGHTING_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      DNC_MEMORY_FORWARD_WEIGHTING_SIZE_N_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

      DNC_MEMORY_FORWARD_WEIGHTING_L_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      DNC_MEMORY_FORWARD_WEIGHTING_W_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      DNC_MEMORY_FORWARD_WEIGHTING_F_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      -- SORT VECTOR
      -- CONTROL
      DNC_MEMORY_SORT_VECTOR_START : out std_logic;
      DNC_MEMORY_SORT_VECTOR_READY : in  std_logic;

      DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE : out std_logic;  -- for j in 0 to N-1

      DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE : in std_logic;  -- for j in 0 to N-1

      DNC_MEMORY_SORT_VECTOR_PHI_OUT_ENABLE : in std_logic;  -- for j in 0 to N-1

      -- DATA
      DNC_MEMORY_SORT_VECTOR_SIZE_N_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

      DNC_MEMORY_SORT_VECTOR_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      DNC_MEMORY_SORT_VECTOR_PHI_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

      -- ADDRESSING
      -- CONTROL
      DNC_MEMORY_START : out std_logic;
      DNC_MEMORY_READY : in  std_logic;

      DNC_MEMORY_K_READ_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1
      DNC_MEMORY_K_READ_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

      DNC_MEMORY_K_READ_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
      DNC_MEMORY_K_READ_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

      DNC_MEMORY_BETA_READ_IN_ENABLE : out std_logic;  -- for i out 0 to R-1

      DNC_MEMORY_BETA_READ_OUT_ENABLE : in std_logic;  -- for i out 0 to R-1

      DNC_MEMORY_F_READ_IN_ENABLE : out std_logic;  -- for i out 0 to R-1

      DNC_MEMORY_F_READ_OUT_ENABLE : in std_logic;  -- for i out 0 to R-1

      DNC_MEMORY_PI_READ_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1
      DNC_MEMORY_PI_READ_IN_P_ENABLE : out std_logic;  -- for p out 0 to 2

      DNC_MEMORY_PI_READ_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
      DNC_MEMORY_PI_READ_OUT_P_ENABLE : in std_logic;  -- for p out 0 to 2

      DNC_MEMORY_K_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_E_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_V_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

      DNC_MEMORY_K_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_E_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_V_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

      DNC_MEMORY_R_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
      DNC_MEMORY_R_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

      -- DATA
      DNC_MEMORY_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      DNC_MEMORY_SIZE_N_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
      DNC_MEMORY_SIZE_W_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

      DNC_MEMORY_K_READ_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_BETA_READ_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_F_READ_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_PI_READ_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);

      DNC_MEMORY_K_WRITE_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_BETA_WRITE_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_E_WRITE_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_V_WRITE_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_GA_WRITE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_GW_WRITE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);

      DNC_MEMORY_R_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

end model_memory_pkg;
