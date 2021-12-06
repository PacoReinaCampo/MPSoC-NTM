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

package dnc_memory_pkg is

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

  constant X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
  constant Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
  constant N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
  constant W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
  constant L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
  constant R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

  -- FUNCTIONALITY
  signal STIMULUS_DNC_MEMORY_TEST   : boolean := false;
  signal STIMULUS_DNC_MEMORY_CASE_0 : boolean := false;
  signal STIMULUS_DNC_MEMORY_CASE_1 : boolean := false;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component dnc_memory_stimulus is
    generic (
      -- SYSTEM-SIZE
      DATA_SIZE  : integer := 512;
      INDEX_SIZE : integer := 512;

      X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
      Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
      N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
      W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
      L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
      R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))   -- i in 0 to R-1
      );
    port (
      -- GLOBAL
      CLK : out std_logic;
      RST : out std_logic;

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

      DNC_MEMORY_PI_READ_IN_ENABLE : out std_logic;  -- for i out 0 to R-1

      DNC_MEMORY_PI_READ_OUT_ENABLE : in std_logic;  -- for i out 0 to R-1

      DNC_MEMORY_K_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_E_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_V_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

      DNC_MEMORY_K_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_E_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1
      DNC_MEMORY_V_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

      DNC_MEMORY_R_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
      DNC_MEMORY_R_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

      -- DATA
      DNC_MEMORY_SIZE_R_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      DNC_MEMORY_SIZE_W_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

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

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

end dnc_memory_pkg;
