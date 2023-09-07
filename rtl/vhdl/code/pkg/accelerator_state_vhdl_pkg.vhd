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

use work.accelerator_arithmetic_vhdl_pkg.all;
use work.accelerator_math_vhdl_pkg.all;

package accelerator_state_vhdl_pkg is

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- STATE - TOP
  ------------------------------------------------------------------------------

  component accelerator_state_top is
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

  component accelerator_state_vector_output is
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

  component accelerator_state_vector_state is
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

  component accelerator_state_matrix_state is
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

  component accelerator_state_matrix_input is
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

  component accelerator_state_matrix_output is
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

  component accelerator_state_matrix_feedforward is
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

end accelerator_state_vhdl_pkg;
