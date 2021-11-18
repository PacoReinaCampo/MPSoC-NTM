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

package ntm_standard_fnn_pkg is

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_standard_fnn_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE : integer := 512;

      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64
      );
    port (
      -- GLOBAL
      CLK : out std_logic;
      RST : out std_logic;

      -- CONTROL
      NTM_STANDARD_FNN_START : out std_logic;
      NTM_STANDARD_FNN_READY : in  std_logic;

      NTM_STANDARD_FNN_W_IN_L_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_W_IN_X_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_K_IN_I_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_K_IN_L_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_K_IN_K_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_B_IN_ENABLE    : out std_logic;
      NTM_STANDARD_FNN_X_IN_ENABLE    : out std_logic;
      NTM_STANDARD_FNN_R_IN_I_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_R_IN_K_ENABLE  : out std_logic;
      NTM_STANDARD_FNN_W_OUT_L_ENABLE : in  std_logic;
      NTM_STANDARD_FNN_W_OUT_X_ENABLE : in  std_logic;
      NTM_STANDARD_FNN_K_OUT_I_ENABLE : in  std_logic;
      NTM_STANDARD_FNN_K_OUT_L_ENABLE : in  std_logic;
      NTM_STANDARD_FNN_K_OUT_K_ENABLE : in  std_logic;
      NTM_STANDARD_FNN_B_OUT_ENABLE   : in  std_logic;
      NTM_STANDARD_FNN_H_OUT_ENABLE   : in  std_logic;

      -- DATA
      NTM_STANDARD_FNN_SIZE_X_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_SIZE_W_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_SIZE_L_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_SIZE_R_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

      NTM_STANDARD_FNN_W_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_K_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_B_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_X_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_R_IN  : out std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_W_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_K_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_B_OUT : in  std_logic_vector(DATA_SIZE-1 downto 0);
      NTM_STANDARD_FNN_H_OUT : in  std_logic
      );
  end component;

end ntm_standard_fnn_pkg;
