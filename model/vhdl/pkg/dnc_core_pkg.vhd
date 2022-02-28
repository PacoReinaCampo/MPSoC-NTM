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
use ieee.float_pkg.all;

use work.ntm_arithmetic_pkg.all;
use work.ntm_math_pkg.all;

package dnc_core_pkg is

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  component dnc_content_based_addressing is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_ENABLE : in std_logic;       -- for j in 0 to J-1

      K_OUT_ENABLE : out std_logic;     -- for j in 0 to J-1

      M_IN_I_ENABLE : in std_logic;     -- for i in 0 to I-1
      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to J-1

      M_OUT_I_ENABLE : out std_logic;   -- for i in 0 to I-1
      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to J-1

      C_OUT_ENABLE : out std_logic;     -- for i in 0 to I-1

      -- DATA
      SIZE_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_allocation_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      U_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      U_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      A_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      U_IN      : in std_logic_vector(DATA_SIZE-1 downto 0);

      A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_backward_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      L_IN_G_ENABLE : in std_logic;     -- for g in 0 to N-1 (square matrix)
      L_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1 (square matrix)

      L_OUT_G_ENABLE : out std_logic;   -- for g in 0 to N-1 (square matrix)
      L_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1 (square matrix)

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      B_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      B_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_forward_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      L_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      L_IN_G_ENABLE : in std_logic;     -- for g in 0 to N-1 (square matrix)
      L_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1 (square matrix)

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      F_I_ENABLE : out std_logic;       -- for i in 0 to R-1 (read heads flow)
      F_J_ENABLE : out std_logic;       -- for j in 0 to N-1

      F_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      F_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_memory_matrix is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1
      E_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      V_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1
      E_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_memory_retention_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      F_IN_ENABLE : in std_logic;       -- for i in 0 to R-1

      F_OUT_ENABLE : out std_logic;     -- for i in 0 to R-1

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      PSI_OUT_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      PSI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_precedence_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      W_IN_ENABLE : in std_logic;       -- for j in 0 to N-1
      P_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      W_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1
      P_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      P_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_content_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      K_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      C_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_vectors is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      PI_IN_I_ENABLE : in std_logic;    -- for i in 0 to R-1
      PI_IN_P_ENABLE : in std_logic;    -- for p in 0 to 2

      PI_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1
      PI_OUT_P_ENABLE : out std_logic;  -- for p in 0 to 2

      B_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      B_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      B_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      B_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      C_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      C_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      C_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      C_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      F_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      F_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      F_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      F_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      PI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_sort_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      U_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      U_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      PHI_OUT_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      PHI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_temporal_link_matrix is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      L_IN_G_ENABLE : in std_logic;     -- for g in 0 to N-1 (square matrix)
      L_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1 (square matrix)

      W_IN_ENABLE : in std_logic;       -- for j in 0 to N-1
      P_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      W_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1
      P_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      L_OUT_G_ENABLE : out std_logic;   -- for g in 0 to N-1 (square matrix)
      L_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1 (square matrix)

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      L_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_usage_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      U_IN_ENABLE   : in std_logic;     -- for j in 0 to N-1
      W_IN_ENABLE   : in std_logic;     -- for j in 0 to N-1
      PSI_IN_ENABLE : in std_logic;     -- for j in 0 to N-1

      U_OUT_ENABLE   : out std_logic;   -- for j in 0 to N-1
      W_OUT_ENABLE   : out std_logic;   -- for j in 0 to N-1
      PSI_OUT_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      U_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      PSI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_content_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      K_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      C_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_weighting is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      A_IN_ENABLE : in std_logic;       -- for j in 0 to N-1
      C_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      A_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1
      C_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      W_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      GA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      GW_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_addressing is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_READ_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)
      K_READ_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

      K_READ_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      K_READ_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

      BETA_READ_IN_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)

      BETA_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

      F_READ_IN_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)

      F_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

      PI_READ_IN_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)

      PI_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

      K_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
      E_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
      V_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

      K_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
      E_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
      V_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_READ_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      F_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      PI_READ_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_WRITE_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      E_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      GA_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GW_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component dnc_addressing;

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  component dnc_free_gates is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      F_IN_ENABLE : in std_logic;       -- for i in 0 to R-1

      F_OUT_ENABLE : out std_logic;     -- for i in 0 to R-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_keys is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      K_I_ENABLE : out std_logic;       -- for i in 0 to R-1
      K_K_ENABLE : out std_logic;       -- for k in 0 to W-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_modes is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      PI_IN_I_ENABLE : in std_logic;    -- for i in 0 to R-1
      PI_IN_P_ENABLE : in std_logic;    -- for i in 0 to 2

      PI_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1
      PI_OUT_P_ENABLE : out std_logic;  -- for i in 0 to 2

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      PI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      PI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_strengths is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      BETA_IN_ENABLE : in std_logic;    -- for i in 0 to R-1

      BETA_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  component dnc_allocation_gate is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      GA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      GA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_erase_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      E_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      E_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- DATA
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      E_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_gate is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      GW_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      GW_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_key is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      K_ENABLE : out std_logic;         -- for k in 0 to W-1

      K_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- DATA
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_strength is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      V_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      V_ENABLE : out std_logic;         -- for k in 0 to W-1

      V_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- DATA
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- TOP
  -----------------------------------------------------------------------

  component dnc_top is
    generic (
      DATA_SIZE    : integer := 32;
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

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      K_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE  : in  std_logic;     -- for x in 0 to X-1
      Y_OUT_ENABLE : out std_logic;     -- for y in 0 to Y-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_output_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      K_IN_Y_ENABLE : in std_logic;     -- for y in 0 to Y-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      K_OUT_Y_ENABLE : out std_logic;   -- for y in 0 to Y-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      R_IN_K_ENABLE : in std_logic;     -- for j in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      R_OUT_K_ENABLE : out std_logic;   -- for j in 0 to W-1

      U_IN_Y_ENABLE : in std_logic;     -- for y in 0 to Y-1
      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      U_OUT_Y_ENABLE : out std_logic;   -- for y in 0 to Y-1
      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      Y_OUT_ENABLE : out std_logic;     -- for y in 0 to Y-1

      -- DATA
      SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_read_interface_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- Read Key
      WK_IN_I_ENABLE : in std_logic;    -- for i in 0 to R-1
      WK_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      WK_IN_K_ENABLE : in std_logic;    -- for k in 0 to W-1

      WK_OUT_I_ENABLE : in std_logic;   -- for i in 0 to R-1
      WK_OUT_L_ENABLE : in std_logic;   -- for l in 0 to L-1
      WK_OUT_K_ENABLE : in std_logic;   -- for k in 0 to W-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      -- Read Strength
      WBETA_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1
      WBETA_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1

      WBETA_OUT_I_ENABLE : in std_logic;  -- for i in 0 to R-1
      WBETA_OUT_L_ENABLE : in std_logic;  -- for l in 0 to L-1

      BETA_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1

      -- Free Gate
      WF_IN_I_ENABLE : in std_logic;    -- for i in 0 to R-1
      WF_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1

      WF_OUT_I_ENABLE : in std_logic;   -- for i in 0 to R-1
      WF_OUT_L_ENABLE : in std_logic;   -- for l in 0 to L-1

      F_OUT_ENABLE : out std_logic;     -- for i in 0 to R-1

      -- Read Mode
      WPI_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1
      WPI_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1

      WPI_OUT_I_ENABLE : in std_logic;  -- for i in 0 to R-1
      WPI_OUT_L_ENABLE : in std_logic;  -- for l in 0 to L-1

      PI_OUT_ENABLE : out std_logic;    -- for i in 0 to R-1

      -- Hidden State
      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      WK_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      WBETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      WF_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      WPI_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      F_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
      PI_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component dnc_write_interface_vector is
    generic (
      DATA_SIZE    : integer := 32;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- Write Key
      WK_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      WK_IN_K_ENABLE : in std_logic;    -- for k in 0 to W-1

      WK_OUT_L_ENABLE : out std_logic;  -- for l in 0 to L-1
      WK_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

      K_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- Write Strength
      WBETA_IN_ENABLE : in std_logic;   -- for l in 0 to L-1

      WBETA_OUT_ENABLE : out std_logic;  -- for l in 0 to L-1

      -- Erase Vector
      WE_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      WE_IN_K_ENABLE : in std_logic;    -- for k in 0 to W-1

      WE_OUT_L_ENABLE : out std_logic;  -- for l in 0 to L-1
      WE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

      E_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- Write Vector
      WV_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      WV_IN_K_ENABLE : in std_logic;    -- for k in 0 to W-1

      WV_OUT_L_ENABLE : out std_logic;  -- for l in 0 to L-1
      WV_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

      V_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- Allocation Gate
      WGA_IN_ENABLE : in std_logic;     -- for l in 0 to L-1

      WGA_OUT_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- Write Gate
      WGW_IN_ENABLE : in std_logic;     -- for l in 0 to L-1

      WGW_OUT_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- Hidden State
      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      WK_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      WBETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      WE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      WV_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      WGA_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      WGW_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      E_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
      GA_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0);
      GW_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

  function function_vector_controller_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return matrix_buffer;

  -----------------------------------------------------------------------
  -- CONTROLLER TEMPLATE
  -----------------------------------------------------------------------

  function function_ntm_fnn_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer;
    matrix_r_input : matrix_buffer;
    vector_h_input : vector_buffer
    ) return vector_buffer;

  -----------------------------------------------------------------------
  -- TRAINER TEMPLATE
  -----------------------------------------------------------------------

  function function_ntm_fnn_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return tensor_buffer;

  function function_ntm_fnn_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return array4_buffer;

  function function_ntm_fnn_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return tensor_buffer;

  function function_ntm_fnn_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return matrix_buffer;

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  function function_dnc_vector_content_based_addressing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0);
    matrix_m_input    : matrix_buffer
    ) return vector_buffer;

  function function_dnc_matrix_content_based_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input    : matrix_buffer;
    vector_beta_input : vector_buffer;
    matrix_m_input    : matrix_buffer
    ) return matrix_buffer;

  function function_dnc_allocation_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_u_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_backward_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_l_input : matrix_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer;

  function function_dnc_forward_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_l_input : matrix_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer;

  function function_dnc_memory_matrix (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;

    vector_w_input : vector_buffer;
    vector_v_input : vector_buffer;
    vector_e_input : vector_buffer
    ) return matrix_buffer;

  function function_dnc_memory_retention_vector (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_f_input : vector_buffer;
    matrix_w_input : matrix_buffer
    ) return vector_buffer;

  function function_dnc_precedence_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_w_input : vector_buffer;
    vector_p_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_read_content_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input    : matrix_buffer;
    matrix_m_input    : matrix_buffer;
    vector_beta_input : vector_buffer
    ) return matrix_buffer;

  function function_dnc_read_vectors (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer;

  function function_dnc_read_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_pi_input : matrix_buffer;

    vector_b_input : vector_buffer;
    matrix_c_input : matrix_buffer;
    vector_f_input : vector_buffer
    ) return matrix_buffer;

  function function_dnc_sort_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_u_input : vector_buffer

    ) return vector_buffer;

  function function_dnc_temporal_link_matrix (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_l_input : matrix_buffer;
    vector_w_input : vector_buffer;
    vector_p_input : vector_buffer
    ) return matrix_buffer;

  function function_dnc_usage_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_u_input   : vector_buffer;
    vector_w_input   : vector_buffer;
    vector_psi_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_write_content_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    matrix_m_input    : matrix_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return vector_buffer;

  function function_dnc_write_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_c_input : vector_buffer;

    scalar_ga_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_gw_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return vector_buffer;

  function function_dnc_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_read_input    : matrix_buffer;
    vector_beta_read_input : vector_buffer;
    vector_f_read_input    : vector_buffer;
    matrix_pi_read_input   : matrix_buffer;

    vector_k_write_input    : vector_buffer;
    scalar_beta_write_input : std_logic_vector(DATA_SIZE-1 downto 0);
    vector_e_write_input    : vector_buffer;
    vector_v_write_input    : vector_buffer;
    scalar_ga_write_input   : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_gw_write_input   : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return matrix_buffer;

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  function function_dnc_free_gates (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_f_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_read_keys (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input : matrix_buffer
    ) return matrix_buffer;

  function function_dnc_read_modes (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_pi_input : matrix_buffer
    ) return matrix_buffer;

  function function_dnc_read_strengths (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_beta_input : vector_buffer
    ) return vector_buffer;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  function function_dnc_allocation_gate (
    scalar_ga_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_dnc_erase_vector (
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_e_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_write_gate (
    scalar_gw_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_dnc_write_key (
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_write_strength (
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector;

  function function_dnc_write_vector (
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_v_input : vector_buffer
    ) return vector_buffer;

  -----------------------------------------------------------------------
  -- TOP - READ_INTERFACE
  -----------------------------------------------------------------------

  function function_dnc_read_interface_k_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer;

  function function_dnc_read_interface_beta_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_read_interface_f_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_dnc_read_interface_pi_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer;

  -----------------------------------------------------------------------
  -- TOP - WRITE_INTERFACE
  -----------------------------------------------------------------------

  function function_ntm_write_interface_k_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_write_interface_beta_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector;

  function function_ntm_write_interface_e_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_write_interface_v_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_write_interface_ga_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector;

  function function_ntm_write_interface_gw_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector;

  -----------------------------------------------------------------------
  -- TOP - OUTPUT
  -----------------------------------------------------------------------

  function function_dnc_output_vector (
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    matrix_r_input : matrix_buffer;

    matrix_u_input : matrix_buffer;
    vector_h_input : vector_buffer
    ) return vector_buffer;

  -----------------------------------------------------------------------
  -- TOP
  -----------------------------------------------------------------------

  function function_dnc_top (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

end dnc_core_pkg;

package body dnc_core_pkg is

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

  function function_vector_controller_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return matrix_buffer is

    variable vector_output : matrix_buffer;
  begin
    -- Data Inputs
    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        if (t = 0) then
          vector_output(t, l) := std_logic_vector(to_float((to_real(to_float(vector_input(t, l))) - to_real(to_float(vector_input(t, l))))/to_real(to_float(LENGTH_IN))));
        else
          vector_output(t, l) := std_logic_vector(to_float((to_real(to_float(vector_input(t, l))) - to_real(to_float(vector_input(t-1, l))))/to_real(to_float(LENGTH_IN))));
        end if;
      end loop;
    end loop;

    return vector_output;
  end function function_vector_controller_differentiation;

  -----------------------------------------------------------------------
  -- CONTROLLER TEMPLATE
  -----------------------------------------------------------------------

  function function_ntm_fnn_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer;
    matrix_r_input : matrix_buffer;
    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable tensor_product : matrix_buffer;
    variable matrix_product : vector_buffer;
    variable vector_adder   : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + b(t;l))

    -- Data Inputs
    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_adder(l) := ZERO_DATA;
    end loop;

    -- K(i;l;k)·r(t;i;k)
    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        tensor_product(i, l) := ZERO_DATA;

        for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
          for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
            tensor_product(i, l) := std_logic_vector(to_float(to_real(to_float(tensor_product(i, l))) + (to_real(to_float(tensor_k_input(i, l, m)))*to_real(to_float(matrix_r_input(i, m))))));
          end loop;
        end loop;
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_adder(l) := std_logic_vector(to_float(to_real(to_float(vector_adder(l))) + to_real(to_float(tensor_product(i, l)))));
      end loop;
    end loop;

    -- W(l;x)·x(t;x)
    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      matrix_product(l) := ZERO_DATA;

      for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
        matrix_product(l) := std_logic_vector(to_float(to_real(to_float(matrix_product(l))) + (to_real(to_float(matrix_w_input(l, x)))*to_real(to_float(vector_x_input(x))))));
      end loop;
    end loop;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_adder(l) := std_logic_vector(to_float(to_real(to_float(vector_adder(l))) + to_real(to_float(matrix_product(l)))));
    end loop;

    -- U(l;l)·h(t-1;l)
    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      matrix_product(l) := ZERO_DATA;

      for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        matrix_product(l) := std_logic_vector(to_float(to_real(to_float(matrix_product(l))) + (to_real(to_float(matrix_u_input(l, m)))*to_real(to_float(vector_h_input(m))))));
      end loop;
    end loop;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_adder(l) := std_logic_vector(to_float(to_real(to_float(vector_adder(l))) + to_real(to_float(matrix_product(l)))));
    end loop;

    -- logistic(h(t;l))
    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_h_output(l) := std_logic_vector(to_float(1.0/(1.0+1.0/exp(to_real(to_float(vector_adder(l)))))));
    end loop;

    return vector_h_output;
  end function function_ntm_fnn_standard_controller;

  -----------------------------------------------------------------------
  -- TRAINER TEMPLATE
  -----------------------------------------------------------------------

  function function_ntm_fnn_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return tensor_buffer is

    variable vector_dh_int : matrix_buffer;

    variable matrix_w_output : tensor_buffer;

  begin

    -- dW(t;l;x) = summation(d*(t;l) · x(t;x))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          matrix_w_output(t, l, x) := ZERO_DATA;
        end loop;
      end loop;
    end loop;

    vector_dh_int := function_vector_controller_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => LENGTH_IN,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          matrix_w_output(t, l, x) := std_logic_vector(to_float(to_real(to_float(matrix_w_output(t, l, x))) + (to_real(to_float(vector_dh_int(t, l)))*to_real(to_float(vector_x_input(t, x))))));
        end loop;
      end loop;
    end loop;

    return matrix_w_output;
  end function function_ntm_fnn_w_trainer;

  function function_ntm_fnn_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return array4_buffer is

    variable vector_dh_int : matrix_buffer;

    variable tensor_k_output : array4_buffer;

  begin

    -- dK(t;l;i;k) = summation(d*(t;l) · r(t;i;k))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            tensor_k_output(t, l, i, k) := ZERO_DATA;
          end loop;
        end loop;
      end loop;
    end loop;

    vector_dh_int := function_vector_controller_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => LENGTH_IN,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            tensor_k_output(t, l, i, k) := std_logic_vector(to_float(to_real(to_float(tensor_k_output(t, l, i, k))) + (to_real(to_float(vector_dh_int(t, l)))*to_real(to_float(matrix_r_input(t, i, k))))));
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_k_output;
  end function function_ntm_fnn_k_trainer;

  function function_ntm_fnn_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return tensor_buffer is

    variable vector_dh_int : matrix_buffer;

    variable matrix_u_output : tensor_buffer;

  begin

    -- dU(t;l;m) = summation(d*(t+1;l) · h(t;l))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          matrix_u_output(t, l, m) := ZERO_DATA;
        end loop;
      end loop;
    end loop;

    vector_dh_int := function_vector_controller_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => LENGTH_IN,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          matrix_u_output(t, l, m) := std_logic_vector(to_float(to_real(to_float(matrix_u_output(t, l, m))) + (to_real(to_float(vector_dh_int(t, l)))*to_real(to_float(vector_h_input(t, m))))));
        end loop;
      end loop;
    end loop;

    return matrix_u_output;
  end function function_ntm_fnn_u_trainer;

  function function_ntm_fnn_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer
    ) return matrix_buffer is

    variable vector_dh_int : matrix_buffer;

    variable vector_b_output : matrix_buffer;

  begin

    -- db(t;l) = summation(d*(t;l))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_b_output(t, l) := ZERO_DATA;
      end loop;
    end loop;

    vector_dh_int := function_vector_controller_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => LENGTH_IN,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_b_output(t, l) := std_logic_vector(to_float(to_real(to_float(vector_b_output(t, l))) + to_real(to_float(vector_dh_int(t, l)))));
      end loop;
    end loop;

    return vector_b_output;
  end function function_ntm_fnn_b_trainer;

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  function function_dnc_vector_content_based_addressing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0);
    matrix_m_input    : matrix_buffer
    ) return vector_buffer is

    variable vector_operation_int : vector_buffer;

    variable vector_m_operation_int : vector_buffer;
    variable scalar_k_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable data_summation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_c_output : vector_buffer;

  begin

    -- C(M[j,·],k,beta)[j] = softmax(exponentiation(cosine_similarity(k,M[j,·])·beta))[j]

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      -- Dot product k,M[j,·]
      vector_operation_int(j) := ZERO_DATA;

      -- Module M[j,·]
      vector_m_operation_int(j) := ZERO_DATA;

      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        -- Dot product k,M[j,·]
        vector_operation_int(j) := std_logic_vector(to_float(to_real(to_float(vector_operation_int(j))) + (to_real(to_float(vector_k_input(k)))*to_real(to_float(matrix_m_input(j, k))))));

        -- Module M[j,·]
        vector_m_operation_int(j) := std_logic_vector(to_float(to_real(to_float(vector_m_operation_int(j))) + (to_real(to_float(matrix_m_input(j, k)))*to_real(to_float(matrix_m_input(j, k))))));
      end loop;
    end loop;

    -- Module k
    for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
      scalar_k_operation_int := std_logic_vector(to_float(to_real(to_float(scalar_k_operation_int)) + (to_real(to_float(vector_k_input(k)))*to_real(to_float(vector_k_input(k))))));
    end loop;

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_operation_int(j) := std_logic_vector(to_float(exp(to_real(to_float(vector_operation_int(j)))*to_real(to_float(scalar_beta_input))/(sqrt(to_real(to_float(scalar_k_operation_int)))*sqrt(to_real(to_float(vector_m_operation_int(j))))))));
    end loop;

    data_summation_int := ZERO_DATA;

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      data_summation_int := std_logic_vector(to_float(to_real(to_float(data_summation_int)) + to_real(to_float(vector_operation_int(j)))));
    end loop;

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_c_output(j) := std_logic_vector(to_float(exp(to_real(to_float(vector_operation_int(j)))/to_real(to_float(data_summation_int)))));
    end loop;

    return vector_c_output;
  end function function_dnc_vector_content_based_addressing;

  function function_dnc_matrix_content_based_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input    : matrix_buffer;
    vector_beta_input : vector_buffer;
    matrix_m_input    : matrix_buffer
    ) return matrix_buffer is

    variable matrix_operation_int : matrix_buffer;

    variable matrix_m_operation_int : matrix_buffer;
    variable vector_k_operation_int : vector_buffer;

    variable data_summation_int : vector_buffer;

    variable matrix_c_output : matrix_buffer;

  begin

    -- C(M[j,·],k,beta)[j] = softmax(exponentiation(cosine_similarity(k,M[j,·])·beta))[j]

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        -- Dot product k,M[j,·]
        matrix_operation_int(i, j) := ZERO_DATA;

        -- Module M[j,·]
        matrix_m_operation_int(i, j) := ZERO_DATA;

        for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
          -- Dot product k,M[j,·]
          matrix_operation_int(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_operation_int(i, j))) + (to_real(to_float(matrix_k_input(i, k)))*to_real(to_float(matrix_m_input(j, k))))));

          -- Module M[j,·]
          matrix_m_operation_int(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_m_operation_int(i, j))) + (to_real(to_float(matrix_m_input(j, k)))*to_real(to_float(matrix_m_input(j, k))))));
        end loop;
      end loop;
    end loop;

    -- Module k
    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      vector_k_operation_int(i) := ZERO_DATA;

      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        vector_k_operation_int(i) := std_logic_vector(to_float(to_real(to_float(vector_k_operation_int(i))) + (to_real(to_float(matrix_k_input(i, k)))*to_real(to_float(matrix_k_input(i, k))))));
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_operation_int(i, j) := std_logic_vector(to_float(exp(to_real(to_float(matrix_operation_int(i, j)))*to_real(to_float(vector_beta_input(i)))/(sqrt(to_real(to_float(vector_k_operation_int(i))))*sqrt(to_real(to_float(matrix_m_operation_int(i, j))))))));
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      data_summation_int(i) := ZERO_DATA;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        data_summation_int(i) := std_logic_vector(to_float(to_real(to_float(data_summation_int(i))) + to_real(to_float(matrix_operation_int(i, j)))));
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_c_output(i, j) := std_logic_vector(to_float(exp(to_real(to_float(matrix_operation_int(i, j)))/to_real(to_float(data_summation_int(i))))));
      end loop;
    end loop;

    return matrix_c_output;
  end function function_dnc_matrix_content_based_addressing;

  function function_dnc_allocation_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_u_input : vector_buffer
    ) return vector_buffer is

    variable vector_a_output : vector_buffer;

  begin

    -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]

    return vector_a_output;
  end function function_dnc_allocation_weighting;

  function function_dnc_backward_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_l_input : matrix_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer is

    variable vector_operation_int : vector_buffer;
    variable matrix_operation_int : matrix_buffer;

    variable matrix_b_output : matrix_buffer;

  begin

    -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

    for g in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_operation_int(g, j) := matrix_l_input(j, g);
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        vector_operation_int(j) := ZERO_DATA;

        for g in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
          matrix_b_output(i, j) := std_logic_vector(to_float(to_real(to_float(vector_operation_int(j))) + (to_real(to_float(matrix_operation_int(j, g)))*to_real(to_float(matrix_w_input(i, j))))));
        end loop;
      end loop;
    end loop;

    return matrix_b_output;
  end function function_dnc_backward_weighting;

  function function_dnc_forward_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_l_input : matrix_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer is

    variable vector_operation_int : vector_buffer;

    variable matrix_f_output : matrix_buffer;

  begin

    -- f(t;i;j) = L(t;g;j)·w(t-1;i;j)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for g in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        vector_operation_int(g) := ZERO_DATA;

        for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
          matrix_f_output(i, j) := std_logic_vector(to_float(to_real(to_float(vector_operation_int(g))) + (to_real(to_float(matrix_l_input(g, j)))*to_real(to_float(matrix_w_input(i, j))))));
        end loop;
      end loop;
    end loop;

    return matrix_f_output;
  end function function_dnc_forward_weighting;

  function function_dnc_memory_matrix (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;

    vector_w_input : vector_buffer;
    vector_v_input : vector_buffer;
    vector_e_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_m_output : matrix_buffer;

  begin

    -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_m_output(j, k) := std_logic_vector(to_float(to_real(to_float(matrix_m_input(j, k)))*(1.0 - to_real(to_float(vector_w_input(j)))*to_real(to_float(vector_e_input(k)))) + to_real(to_float(vector_w_input(j)))*to_real(to_float(vector_v_input(k)))));
      end loop;
    end loop;

    return matrix_m_output;
  end function function_dnc_memory_matrix;

  function function_dnc_memory_retention_vector (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_f_input : vector_buffer;
    matrix_w_input : matrix_buffer
    ) return vector_buffer is

    variable vector_psi_output : vector_buffer;

  begin

    -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
        vector_psi_output(j) := std_logic_vector(to_float(1.0 - to_real(to_float(vector_f_input(i)))*to_real(to_float(matrix_w_input(i, j)))));
      end loop;
    end loop;

    return vector_psi_output;
  end function function_dnc_memory_retention_vector;

  function function_dnc_precedence_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_w_input : vector_buffer;
    vector_p_input : vector_buffer
    ) return vector_buffer is

    variable data_summation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_p_output : vector_buffer;

  begin

    -- p(t;j) = (1 - summation(w(t;j))[j in 1 to N])·p(t-1;j) + w(t;j)

    -- p(t=0) = 0

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      data_summation_int := std_logic_vector(to_float(to_real(to_float(data_summation_int)) + to_real(to_float(vector_w_input(j)))));
    end loop;

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_p_output(j) := std_logic_vector(to_float((1.0 - to_real(to_float(data_summation_int)))*to_real(to_float(vector_p_input(j))) + to_real(to_float(vector_w_input(j)))));
    end loop;

    return vector_p_output;
  end function function_dnc_precedence_weighting;

  function function_dnc_read_content_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input    : matrix_buffer;
    matrix_m_input    : matrix_buffer;
    vector_beta_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_c_output : matrix_buffer;

  begin

    -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))
    matrix_c_output := function_dnc_matrix_content_based_addressing (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_k_input    => matrix_k_input,
      vector_beta_input => vector_beta_input,
      matrix_m_input    => matrix_m_input
      );

    return matrix_c_output;
  end function function_dnc_read_content_weighting;

  function function_dnc_read_vectors (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer is

    variable vector_operation_int : vector_buffer;
    variable matrix_operation_int : matrix_buffer;

    variable matrix_r_output : matrix_buffer;

  begin

    -- r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_operation_int(j, k) := matrix_m_input(k, j);
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        vector_operation_int(k) := ZERO_DATA;

        for j in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
          matrix_r_output(i, k) := std_logic_vector(to_float(to_real(to_float(vector_operation_int(k))) + (to_real(to_float(matrix_operation_int(k, j)))*to_real(to_float(matrix_w_input(i, j))))));
        end loop;
      end loop;
    end loop;

    return matrix_r_output;
  end function function_dnc_read_vectors;

  function function_dnc_read_weighting (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_pi_input : matrix_buffer;

    vector_b_input : vector_buffer;
    matrix_c_input : matrix_buffer;
    vector_f_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_w_output : matrix_buffer;

  begin

    -- w(t;i,j) = pi(t;i)[1]·b(t;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;j)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_w_output(i, j) := std_logic_vector(to_float((to_real(to_float(matrix_pi_input(i, 0)))*to_real(to_float(vector_b_input(j)))) + (to_real(to_float(matrix_pi_input(i, 1)))*to_real(to_float(matrix_c_input(i, j)))) + (to_real(to_float(matrix_pi_input(i, 2)))*to_real(to_float(vector_f_input(j))))));
      end loop;
    end loop;

    return matrix_w_output;
  end function function_dnc_read_weighting;

  function function_dnc_sort_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_u_input : vector_buffer

    ) return vector_buffer is

    variable vector_phi_output : vector_buffer;

  begin

    -- PHI_OUT = sort(U_IN)

    return vector_phi_output;
  end function function_dnc_sort_vector;

  function function_dnc_temporal_link_matrix (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_l_input : matrix_buffer;
    vector_w_input : vector_buffer;
    vector_p_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_l_output : matrix_buffer;

  begin

    -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]

    -- L(t=0)[g,j] = 0

    for g in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_l_output(g, j) := std_logic_vector(to_float((1.0 - to_real(to_float(vector_w_input(g))) - to_real(to_float(vector_w_input(j))))*to_real(to_float(matrix_l_input(g, j))) + (to_real(to_float(vector_w_input(j)))*to_real(to_float(vector_p_input(j))))));
      end loop;
    end loop;

    return matrix_l_output;
  end function function_dnc_temporal_link_matrix;

  function function_dnc_usage_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_u_input   : vector_buffer;
    vector_w_input   : vector_buffer;
    vector_psi_input : vector_buffer
    ) return vector_buffer is

    variable vector_u_output : vector_buffer;

  begin

    -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_u_output(j) := std_logic_vector(to_float((to_real(to_float(vector_u_input(j))) + to_real(to_float(vector_w_input(j))) - (to_real(to_float(vector_u_input(j)))*to_real(to_float(vector_w_input(j)))))*to_real(to_float(vector_psi_input(j)))));
    end loop;

    return vector_u_output;
  end function function_dnc_usage_vector;

  function function_dnc_write_content_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    matrix_m_input    : matrix_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return vector_buffer is

    variable vector_c_output : vector_buffer;

  begin

    -- c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))
    vector_c_output := function_dnc_vector_content_based_addressing (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      vector_k_input    => vector_k_input,
      scalar_beta_input => scalar_beta_input,
      matrix_m_input    => matrix_m_input
      );

    return vector_c_output;
  end function function_dnc_write_content_weighting;

  function function_dnc_write_weighting (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : vector_buffer;
    vector_c_input : vector_buffer;

    scalar_ga_input : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_gw_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return vector_buffer is

    variable vector_w_output : vector_buffer;

  begin

    -- w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_w_output(j) := std_logic_vector(to_float(to_real(to_float(scalar_gw_input))*((to_real(to_float(scalar_ga_input))*to_real(to_float(vector_a_input(j)))) + ((1.0 - to_real(to_float(scalar_ga_input)))*to_real(to_float(vector_c_input(j)))))));
    end loop;

    return vector_w_output;
  end function function_dnc_write_weighting;

  function function_dnc_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_read_input    : matrix_buffer;
    vector_beta_read_input : vector_buffer;
    vector_f_read_input    : vector_buffer;
    matrix_pi_read_input   : matrix_buffer;

    vector_k_write_input    : vector_buffer;
    scalar_beta_write_input : std_logic_vector(DATA_SIZE-1 downto 0);
    vector_e_write_input    : vector_buffer;
    vector_v_write_input    : vector_buffer;
    scalar_ga_write_input   : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_gw_write_input   : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return matrix_buffer is

    variable matrix_l_in_int : matrix_buffer;
    variable matrix_m_in_int : matrix_buffer;

    variable matrix_l_out_int : matrix_buffer;
    variable matrix_m_out_int : matrix_buffer;

    variable matrix_b_int : matrix_buffer;
    variable matrix_c_int : matrix_buffer;
    variable matrix_f_int : matrix_buffer;
    variable matrix_w_int : matrix_buffer;

    variable vector_p_in_int : vector_buffer;
    variable vector_u_in_int : vector_buffer;

    variable vector_p_out_int : vector_buffer;
    variable vector_u_out_int : vector_buffer;

    variable vector_a_int : vector_buffer;
    variable vector_b_int : vector_buffer;
    variable vector_c_int : vector_buffer;
    variable vector_w_int : vector_buffer;

    variable vector_psi_int : vector_buffer;

    variable matrix_r_output : matrix_buffer;

  begin

    -- PRECEDENCE_WEIGHTING

    -- p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
    -- p(t=0) = 0
    vector_p_out_int := function_dnc_precedence_weighting (
      SIZE_N_IN => SIZE_N_IN,

      vector_w_input => vector_w_int,
      vector_p_input => vector_p_in_int
      );

    -- TEMPORAL_LINK_MATRIX

    -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
    -- L(t=0)[g,j] = 0
    matrix_l_out_int := function_dnc_temporal_link_matrix (
      SIZE_N_IN => SIZE_N_IN,

      matrix_l_input => matrix_l_in_int,
      vector_w_input => vector_w_int,
      vector_p_input => vector_p_out_int
      );

    -- BACKWARD_FORWARD_WEIGHTING

    -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)
    matrix_b_int := function_dnc_backward_weighting (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,

      matrix_l_input => matrix_l_out_int,
      matrix_w_input => matrix_w_int
      );

    -- f(t;i;j) = L(t;g;j)·w(t-1;i;j)
    matrix_f_int := function_dnc_forward_weighting (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,

      matrix_l_input => matrix_l_out_int,
      matrix_w_input => matrix_w_int
      );

    -- MEMORY_RETENTION_VECTOR

    -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]
    vector_psi_int := function_dnc_memory_retention_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,

      vector_f_input => vector_f_read_input,
      matrix_w_input => matrix_w_int
      );

    -- USAGE_VECTOR

    -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)
    vector_u_out_int := function_dnc_usage_vector (
      SIZE_N_IN => SIZE_N_IN,

      vector_u_input   => vector_u_in_int,
      vector_w_input   => vector_w_int,
      vector_psi_input => vector_psi_int
      );

    -- ALLOCATION_WEIGHTING

    -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]
    vector_a_int := function_dnc_allocation_weighting (
      SIZE_N_IN => SIZE_N_IN,

      vector_u_input => vector_u_out_int
      );

    -- READ_WRITE_CONTENT_WEIGHTING

    -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))
    matrix_c_int := function_dnc_read_content_weighting (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_k_input    => matrix_k_read_input,
      matrix_m_input    => matrix_m_in_int,
      vector_beta_input => vector_beta_read_input
      );

    -- c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))
    vector_c_int := function_dnc_write_content_weighting (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      vector_k_input    => vector_k_write_input,
      matrix_m_input    => matrix_m_in_int,
      scalar_beta_input => scalar_beta_write_input
      );

    -- READ_WRITE_WEIGHTING

    -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)
    matrix_w_int := function_dnc_read_weighting (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,

      matrix_pi_input => matrix_pi_read_input,

      vector_b_input => vector_b_int,
      matrix_c_input => matrix_c_int,
      vector_f_input => vector_f_read_input
      );

    -- w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))
    vector_w_int := function_dnc_write_weighting (
      SIZE_N_IN => SIZE_N_IN,

      vector_a_input => vector_a_int,
      vector_c_input => vector_c_int,

      scalar_ga_input => scalar_ga_write_input,
      scalar_gw_input => scalar_gw_write_input
      );

    -- MEMORY_MATRIX

    -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))
    matrix_m_out_int := function_dnc_memory_matrix (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_m_input => matrix_m_in_int,

      vector_w_input => vector_w_int,
      vector_v_input => vector_v_write_input,
      vector_e_input => vector_e_write_input
      );

    -- READ_VECTORS

    -- r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)
    matrix_r_output := function_dnc_read_vectors (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_m_input => matrix_m_out_int,
      matrix_w_input => matrix_w_int
      );

    return matrix_r_output;
  end function function_dnc_addressing;

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  function function_dnc_free_gates (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_f_input : vector_buffer
    ) return vector_buffer is

    variable vector_f_output : vector_buffer;

  begin

    -- f(t;i) = sigmoid(f^(t;i))

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      vector_f_output(i) := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(vector_f_input(i)))))));
    end loop;

    return vector_f_output;
  end function function_dnc_free_gates;

  function function_dnc_read_keys (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_f_output : matrix_buffer;

  begin

    -- k(t;i;k) = k^(t;i;k)

    matrix_f_output := matrix_k_input;

    return matrix_f_output;
  end function function_dnc_read_keys;

  function function_dnc_read_modes (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_pi_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_pi_output : matrix_buffer;

  begin

    -- pi(t;i;p) = softmax(pi^(t;i;p))

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for p in 0 to to_integer(unsigned(TWO_CONTROL)) loop
        matrix_pi_output(i, p) := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(matrix_pi_input(i, p)))))));
      end loop;
    end loop;

    return matrix_pi_output;
  end function function_dnc_read_modes;

  function function_dnc_read_strengths (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_beta_input : vector_buffer
    ) return vector_buffer is

    variable vector_beta_output : vector_buffer;

  begin

    -- beta(t;i) = oneplus(beta^(t;i))

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      vector_beta_output(i) := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(vector_beta_input(i)))))));
    end loop;

    return vector_beta_output;
  end function function_dnc_read_strengths;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  function function_dnc_allocation_gate (
    scalar_ga_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_ga_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- ga(t) = sigmoid(g^(t))

    scalar_ga_output := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(scalar_ga_input))))));

    return scalar_ga_output;
  end function function_dnc_allocation_gate;

  function function_dnc_erase_vector (
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_e_input : vector_buffer
    ) return vector_buffer is

    variable vector_e_output : vector_buffer;

  begin

    -- e(t;k) = sigmoid(e^(t;k))

    for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
      vector_e_output(k) := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(vector_e_input(k)))))));
    end loop;

    return vector_e_output;
  end function function_dnc_erase_vector;

  function function_dnc_write_gate (
    scalar_gw_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_gw_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- gw(t) = sigmoid(gw^(t))

    scalar_gw_output := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(scalar_gw_input))))));

    return scalar_gw_output;
  end function function_dnc_write_gate;

  function function_dnc_write_key (
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input : vector_buffer
    ) return vector_buffer is

    variable vector_k_output : vector_buffer;

  begin

    -- k(t;k) = k^(t;k)

    vector_k_output := vector_k_input;

    return vector_k_output;
  end function function_dnc_write_key;

  function function_dnc_write_strength (
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return std_logic_vector is

    variable scalar_beta_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- beta(t) = oneplus(beta^(t))

    scalar_beta_output := std_logic_vector(to_float(1.0+log(1.0+1.0+exp(to_real(to_float(scalar_beta_input))))));

    return scalar_beta_output;
  end function function_dnc_write_strength;

  function function_dnc_write_vector (
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_v_input : vector_buffer
    ) return vector_buffer is

    variable vector_v_output : vector_buffer;

  begin

    -- v(t;k) = v^(t;k)

    vector_v_output := vector_v_input;

    return vector_v_output;
  end function function_dnc_write_vector;

  -----------------------------------------------------------------------
  -- TOP - READ_INTERFACE
  -----------------------------------------------------------------------

  function function_dnc_read_interface_k_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_k_output : matrix_buffer;

  begin

    -- k(t;i;k) = U(t;i;k;l)·h(t;l)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_k_output(i, k) := ZERO_DATA;

        for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          matrix_k_output(i, k) := std_logic_vector(to_float(to_real(to_float(matrix_k_output(i, k))) + (to_real(to_float(tensor_wk_input(i, k, l)))*to_real(to_float(vector_h_input(l))))));
        end loop;
      end loop;
    end loop;

    return matrix_k_output;
  end function function_dnc_read_interface_k_vector;

  function function_dnc_read_interface_beta_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_beta_output : vector_buffer;

  begin

    -- beta(t;i) = U(t;i;l)·h(t;l)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      vector_beta_output(i) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_beta_output(i) := std_logic_vector(to_float(to_real(to_float(vector_beta_output(i))) + (to_real(to_float(matrix_wbeta_input(i, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    return vector_beta_output;
  end function function_dnc_read_interface_beta_vector;

  function function_dnc_read_interface_f_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_f_output : vector_buffer;

  begin

    -- f(t;i) = U(t;i;l)·h(t;l)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      vector_f_output(i) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_f_output(i) := std_logic_vector(to_float(to_real(to_float(vector_f_output(i))) + (to_real(to_float(matrix_wf_input(i, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    return vector_f_output;
  end function function_dnc_read_interface_f_vector;

  function function_dnc_read_interface_pi_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input    : tensor_buffer;
    matrix_wbeta_input : matrix_buffer;
    matrix_wf_input    : matrix_buffer;
    tensor_wpi_input   : tensor_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_pi_output : matrix_buffer;

  begin

    -- pi(t;i;m) = U(t;i;m;l)·h(t;l)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for m in 0 to to_integer(unsigned(THREE_CONTROL))-1 loop
        matrix_pi_output(i, m) := ZERO_DATA;

        for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          matrix_pi_output(i, m) := std_logic_vector(to_float(to_real(to_float(matrix_pi_output(i, m))) + (to_real(to_float(tensor_wpi_input(i, m, l)))*to_real(to_float(vector_h_input(l))))));
        end loop;
      end loop;
    end loop;

    return matrix_pi_output;
  end function function_dnc_read_interface_pi_vector;

  -----------------------------------------------------------------------
  -- TOP - WRITE_INTERFACE
  -----------------------------------------------------------------------

  function function_ntm_write_interface_k_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_k_output : vector_buffer;

  begin

    -- k(t;k) = U(t;k;l)·h(t;l)

    for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
      vector_k_output(k) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_k_output(k) := std_logic_vector(to_float(to_real(to_float(vector_k_output(k))) + (to_real(to_float(matrix_wk_input(k, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    return vector_k_output;
  end function function_ntm_write_interface_k_vector;

  function function_ntm_write_interface_beta_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector is

    variable scalar_beta_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- beta(t) = U(t;l)·h(t;l)

    scalar_beta_output := ZERO_DATA;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_beta_output := std_logic_vector(to_float(to_real(to_float(scalar_beta_output)) + (to_real(to_float(vector_wbeta_input(l)))*to_real(to_float(vector_h_input(l))))));
    end loop;

    return scalar_beta_output;
  end function function_ntm_write_interface_beta_vector;

  function function_ntm_write_interface_e_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_e_output : vector_buffer;

  begin

    -- e(t;k) = U(t;k;l)·h(t;l)

    for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
      vector_e_output(k) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_e_output(k) := std_logic_vector(to_float(to_real(to_float(vector_e_output(k))) + (to_real(to_float(matrix_we_input(k, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    return vector_e_output;
  end function function_ntm_write_interface_e_vector;

  function function_ntm_write_interface_v_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_v_output : vector_buffer;

  begin

    -- v(t;k) = U(t;k;l)·h(t;l)

    for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
      vector_v_output(k) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_v_output(k) := std_logic_vector(to_float(to_real(to_float(vector_v_output(k))) + (to_real(to_float(matrix_wv_input(k, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    return vector_v_output;
  end function function_ntm_write_interface_v_vector;

  function function_ntm_write_interface_ga_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector is

    variable scalar_ga_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- ga(t;l) = U(t;l;m)·h(t;m)

    scalar_ga_output := ZERO_DATA;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_ga_output := std_logic_vector(to_float(to_real(to_float(scalar_ga_output)) + (to_real(to_float(vector_wga_input(l)))*to_real(to_float(vector_h_input(l))))));
    end loop;

    return scalar_ga_output;
  end function function_ntm_write_interface_ga_vector;

  function function_ntm_write_interface_gw_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input    : matrix_buffer;
    vector_wbeta_input : vector_buffer;
    matrix_we_input    : matrix_buffer;
    matrix_wv_input    : matrix_buffer;
    vector_wga_input   : vector_buffer;
    vector_wgw_input   : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector is

    variable scalar_gw_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- gw(t;l) = U(t;l;m)·h(t;m)

    scalar_gw_output := ZERO_DATA;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_gw_output := std_logic_vector(to_float(to_real(to_float(scalar_gw_output)) + (to_real(to_float(vector_wgw_input(l)))*to_real(to_float(vector_h_input(l))))));
    end loop;

    return scalar_gw_output;
  end function function_ntm_write_interface_gw_vector;

  -----------------------------------------------------------------------
  -- TOP - OUTPUT
  -----------------------------------------------------------------------

  function function_dnc_output_vector (
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    matrix_r_input : matrix_buffer;

    matrix_u_input : matrix_buffer;
    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable data_summation_int : matrix_buffer;
    variable data_product_int   : vector_buffer;
    variable data_addition_int  : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)

    for y in 0 to to_integer(unsigned(SIZE_Y_IN))-1 loop
      data_product_int(y)  := ZERO_DATA;
      data_addition_int(y) := ZERO_DATA;

      vector_y_output(y) := ZERO_DATA;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for y in 0 to to_integer(unsigned(SIZE_Y_IN))-1 loop
        data_summation_int(i, y) := ZERO_DATA;

        for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
          data_summation_int(i, y) := std_logic_vector(to_float(to_real(to_float(data_summation_int(i, y))) + (to_real(to_float(tensor_k_input(i, y, k)))*to_real(to_float(matrix_r_input(i, k))))));
        end loop;
      end loop;
    end loop;

    for y in 0 to to_integer(unsigned(SIZE_Y_IN))-1 loop
      data_product_int(y) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        data_product_int(y) := std_logic_vector(to_float(to_real(to_float(data_product_int(y))) + (to_real(to_float(matrix_u_input(y, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for y in 0 to to_integer(unsigned(SIZE_Y_IN))-1 loop
        data_addition_int(y) := std_logic_vector(to_float(to_real(to_float(data_addition_int(y))) + to_real(to_float(data_summation_int(i, y)))));
      end loop;
    end loop;

    for y in 0 to to_integer(unsigned(SIZE_Y_IN))-1 loop
      vector_y_output(y) := std_logic_vector(to_float(to_real(to_float(data_addition_int(y))) + to_real(to_float(data_product_int(y)))));
    end loop;

    return vector_y_output;
  end function function_dnc_output_vector;

  -----------------------------------------------------------------------
  -- TOP
  -----------------------------------------------------------------------

  function function_dnc_top (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    -- Trainer Variable
    variable tensor_wk_int    : tensor_buffer;
    variable matrix_wbeta_int : matrix_buffer;
    variable matrix_wf_int    : matrix_buffer;
    variable tensor_wpi_int   : tensor_buffer;

    variable matrix_k_int    : matrix_buffer;
    variable vector_beta_int : vector_buffer;
    variable vector_f_int    : vector_buffer;
    variable matrix_pi_int   : matrix_buffer;

    variable matrix_k_read_int    : matrix_buffer;
    variable vector_beta_read_int : vector_buffer;
    variable vector_f_read_int    : vector_buffer;
    variable matrix_pi_read_int   : matrix_buffer;

    variable matrix_wk_int    : matrix_buffer;
    variable vector_wbeta_int : vector_buffer;
    variable matrix_we_int    : matrix_buffer;
    variable matrix_wv_int    : matrix_buffer;
    variable vector_wga_int   : vector_buffer;
    variable vector_wgw_int   : vector_buffer;

    variable vector_k_int    : vector_buffer;
    variable scalar_beta_int : std_logic_vector(DATA_SIZE-1 downto 0);
    variable vector_e_int    : vector_buffer;
    variable vector_v_int    : vector_buffer;
    variable scalar_ga_int   : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_gw_int   : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_k_write_int    : vector_buffer;
    variable scalar_beta_write_int : std_logic_vector(DATA_SIZE-1 downto 0);
    variable vector_e_write_int    : vector_buffer;
    variable vector_v_write_int    : vector_buffer;
    variable scalar_ga_write_int   : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_gw_write_int   : std_logic_vector(DATA_SIZE-1 downto 0);

    variable tensor_k_int : tensor_buffer;
    variable matrix_u_int : matrix_buffer;

    variable tensor_kt_int : array4_buffer;
    variable matrix_ut_int : tensor_buffer;

    variable vector_xt_int : matrix_buffer;
    variable matrix_rt_int : tensor_buffer;
    variable vector_ht_int : matrix_buffer;

    -- Internal Variable
    variable matrix_r_int : matrix_buffer;

    variable vector_h_int : vector_buffer;

    -- Output Variable
    variable vector_y_output : vector_buffer;

  begin

    -- CONTROLLER_BODY_STATE

    -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + b(t;l))
    -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(t;l))

    vector_h_int := function_ntm_fnn_standard_controller (
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      matrix_w_input => matrix_w_input,
      tensor_k_input => tensor_k_input,
      matrix_u_input => matrix_u_input,
      vector_b_input => vector_b_input,

      vector_x_input => vector_x_input,
      matrix_r_input => matrix_r_int,
      vector_h_input => vector_h_int
      );



    -- TRAINER_STATE

    tensor_kt_int := function_ntm_fnn_k_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      vector_x_input => vector_xt_int,
      matrix_r_input => matrix_rt_int,
      vector_h_input => vector_ht_int
      );

    matrix_ut_int := function_ntm_fnn_u_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      vector_x_input => vector_xt_int,
      matrix_r_input => matrix_rt_int,
      vector_h_input => vector_ht_int
      );



    -- READ_HEADS_STATE

    -- FREE_GATES_STATE

    -- f(t;i) = sigmoid(f^(t;i))

    -- READ_KEYS_STATE

    -- k(t;i;k) = k^(t;i;k)

    -- READ_MODES_STATE

    -- pi(t;i;p) = softmax(pi^(t;i;p))

    -- READ_STRENGTHS_STATE

    -- beta(t;i) = oneplus(beta^(t;i))



    -- READ_INTERFACE_VECTOR_STATE

    -- xi(t;?) = U(t;?;l)·h(t;l)

    -- k(t;i;k) = Wk(t;i;l;k)·h(t;l)
    matrix_k_int := function_dnc_read_interface_k_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input    => tensor_wk_int,
      matrix_wbeta_input => matrix_wbeta_int,
      matrix_wf_input    => matrix_wf_int,
      tensor_wpi_input   => tensor_wpi_int,

      vector_h_input => vector_h_int
      );

    -- beta(t;i) = Wbeta(t;i;l)·h(t;l)
    vector_beta_int := function_dnc_read_interface_beta_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input    => tensor_wk_int,
      matrix_wbeta_input => matrix_wbeta_int,
      matrix_wf_input    => matrix_wf_int,
      tensor_wpi_input   => tensor_wpi_int,

      vector_h_input => vector_h_int
      );

    -- f(t;i) = Wf(t;i;l)·h(t;l)
    vector_f_int := function_dnc_read_interface_f_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input    => tensor_wk_int,
      matrix_wbeta_input => matrix_wbeta_int,
      matrix_wf_input    => matrix_wf_int,
      tensor_wpi_input   => tensor_wpi_int,

      vector_h_input => vector_h_int
      );

    -- pi(t;i) = Wpi(t;i;l)·h(t;l)
    matrix_pi_int := function_dnc_read_interface_pi_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input    => tensor_wk_int,
      matrix_wbeta_input => matrix_wbeta_int,
      matrix_wf_input    => matrix_wf_int,
      tensor_wpi_input   => tensor_wpi_int,

      vector_h_input => vector_h_int
      );



    -- WRITE_HEADS_STATE

    -- ALLOCATION_GATE_STATE

    -- ga(t) = sigmoid(g^(t))

    -- ERASE_VECTOR_STATE

    -- e(t;k) = sigmoid(e^(t;k))

    -- WRITE_GATE_STATE

    -- gw(t) = sigmoid(gw^(t))

    -- WRITE_KEY_STATE

    -- k(t;k) = k^(t;k)

    -- WRITE_STRENGTH_STATE

    -- beta(t) = oneplus(beta^(t))

    -- WRITE_VECTOR_STATE

    -- v(t;k) = v^(t;k)



    -- WRITE_INTERFACE_VECTOR_STATE

    -- xi(t;?) = U(t;?;l)·h(t;l)

    -- k(t;k) = Wk(t;l;k)·h(t;l)
    vector_k_int := function_ntm_write_interface_k_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input    => matrix_wk_int,
      vector_wbeta_input => vector_wbeta_int,
      matrix_we_input    => matrix_we_int,
      matrix_wv_input    => matrix_wv_int,
      vector_wga_input   => vector_wga_int,
      vector_wgw_input   => vector_wgw_int,

      vector_h_input => vector_h_int
      );

    -- beta(t) = Wbeta(t;l)·h(t;l)
    scalar_beta_int := function_ntm_write_interface_beta_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input    => matrix_wk_int,
      vector_wbeta_input => vector_wbeta_int,
      matrix_we_input    => matrix_we_int,
      matrix_wv_input    => matrix_wv_int,
      vector_wga_input   => vector_wga_int,
      vector_wgw_input   => vector_wgw_int,

      vector_h_input => vector_h_int
      );

    -- e(t;k) = We(t;l;k)·h(t;l)
    vector_e_int := function_ntm_write_interface_e_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input    => matrix_wk_int,
      vector_wbeta_input => vector_wbeta_int,
      matrix_we_input    => matrix_we_int,
      matrix_wv_input    => matrix_wv_int,
      vector_wga_input   => vector_wga_int,
      vector_wgw_input   => vector_wgw_int,

      vector_h_input => vector_h_int
      );

    -- v(t;k) = Wv(t;l;k)·h(t;l)
    vector_v_int := function_ntm_write_interface_v_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input    => matrix_wk_int,
      vector_wbeta_input => vector_wbeta_int,
      matrix_we_input    => matrix_we_int,
      matrix_wv_input    => matrix_wv_int,
      vector_wga_input   => vector_wga_int,
      vector_wgw_input   => vector_wgw_int,

      vector_h_input => vector_h_int
      );

    -- ga(t) = Wga(t;l)·h(t;l)
    scalar_ga_int := function_ntm_write_interface_ga_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input    => matrix_wk_int,
      vector_wbeta_input => vector_wbeta_int,
      matrix_we_input    => matrix_we_int,
      matrix_wv_input    => matrix_wv_int,
      vector_wga_input   => vector_wga_int,
      vector_wgw_input   => vector_wgw_int,

      vector_h_input => vector_h_int
      );

    -- gw(t) = Wgw(t;l)·h(t;l)
    scalar_gw_int := function_ntm_write_interface_gw_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input    => matrix_wk_int,
      vector_wbeta_input => vector_wbeta_int,
      matrix_we_input    => matrix_we_int,
      matrix_wv_input    => matrix_wv_int,
      vector_wga_input   => vector_wga_int,
      vector_wgw_input   => vector_wgw_int,

      vector_h_input => vector_h_int
      );



    -- MEMORY_STATE
    matrix_r_int := function_dnc_addressing (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_k_read_input    => matrix_k_read_int,
      vector_beta_read_input => vector_beta_read_int,
      vector_f_read_input    => vector_f_read_int,
      matrix_pi_read_input   => matrix_pi_read_int,

      vector_k_write_input    => vector_k_write_int,
      scalar_beta_write_input => scalar_beta_write_int,
      vector_e_write_input    => vector_e_write_int,
      vector_v_write_input    => vector_v_write_int,
      scalar_ga_write_input   => scalar_ga_write_int,
      scalar_gw_write_input   => scalar_gw_write_int
      );



    -- OUTPUT_VECTOR_STATE

    -- y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)
    vector_y_output := function_dnc_output_vector (
      SIZE_Y_IN => SIZE_Y_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_R_IN => SIZE_R_IN,

      tensor_k_input => tensor_k_int,
      matrix_r_input => matrix_r_int,

      matrix_u_input => matrix_u_int,
      vector_h_input => vector_h_int
      );

    return vector_y_output;
  end function function_dnc_top;

end dnc_core_pkg;
