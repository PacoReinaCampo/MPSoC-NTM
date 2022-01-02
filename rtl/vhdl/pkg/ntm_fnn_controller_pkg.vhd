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

package ntm_fnn_controller_pkg is

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_controller is
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

      W_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      W_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      K_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      K_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

      H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_trainer is
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

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

end ntm_fnn_controller_pkg;
