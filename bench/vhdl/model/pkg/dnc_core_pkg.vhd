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

use work.ntm_math_pkg.all;

package dnc_core_pkg is

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant DATA_SIZE    : integer := 32;
  constant CONTROL_SIZE : integer := 64;

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(0.0));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(1.0));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(2.0));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(3.0));

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Buffer
  type vector_buffer is array (CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type tensor_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

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

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  function function_dnc_content_based_addressing (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0);
    matrix_m_input    : matrix_buffer
    ) return vector_buffer;

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
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    matrix_m_input    : matrix_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return vector_buffer;

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

    matrix_b_input : matrix_buffer;
    matrix_c_input : matrix_buffer;
    matrix_f_input : matrix_buffer
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
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_read_input    : matrix_buffer;
    vector_beta_read_input : vector_buffer;
    vector_f_read_input    : vector_buffer;
    vector_pi_read_input   : vector_buffer;

    matrix_k_write_input    : matrix_buffer;
    vector_beta_write_input : vector_buffer;
    vector_e_write_input    : vector_buffer;
    vector_v_write_input    : vector_buffer;
    scalar_ga_write_input   : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_gw_write_input   : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return matrix_buffer;

end dnc_core_pkg;

package body dnc_core_pkg is

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  function function_dnc_content_based_addressing (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

    -- C(M[i,·],k,beta)[i] = softmax(exponentiation(cosine_similarity(k,M[i,·])·beta))[i]

    -- Data Inputs
    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      vector_operation_int(i) := ZERO_DATA;

      vector_m_operation_int(i) := ZERO_DATA;
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
        -- Dot product k,M[i,·]
        vector_operation_int(i) := std_logic_vector(to_float(to_real(to_float(vector_operation_int(i))) + (to_real(to_float(vector_k_input(j)))*to_real(to_float(matrix_m_input(i, j))))));

        -- Module M[i,·]
        vector_m_operation_int(i) := std_logic_vector(to_float(to_real(to_float(vector_m_operation_int(i))) + (to_real(to_float(matrix_m_input(i, j)))*to_real(to_float(matrix_m_input(i, j))))));
      end loop;
    end loop;

    -- Module k
    for j in 0 to to_integer(unsigned(SIZE_J_IN))-1 loop
      scalar_k_operation_int := std_logic_vector(to_float(to_real(to_float(scalar_k_operation_int)) + (to_real(to_float(vector_k_input(j)))*to_real(to_float(vector_k_input(j))))));
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      vector_operation_int(i) := std_logic_vector(to_float(exp(to_real(to_float(vector_operation_int(i)))*to_real(to_float(scalar_beta_input))/(sqrt(to_real(to_float(scalar_k_operation_int)))*sqrt(to_real(to_float(vector_m_operation_int(i))))))));
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      data_summation_int := std_logic_vector(to_float(to_real(to_float(data_summation_int)) + to_real(to_float(vector_operation_int(i)))));
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      vector_c_output(i) := std_logic_vector(to_float(exp(to_real(to_float(vector_operation_int(i)))/to_real(to_float(data_summation_int)))));
    end loop;

    return vector_c_output;
  end function function_dnc_content_based_addressing;

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
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    matrix_m_input    : matrix_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return vector_buffer is

    variable vector_c_output : vector_buffer;

  begin

    -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))
    vector_c_output := function_dnc_content_based_addressing (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_W_IN,

      vector_k_input    => vector_k_input,
      scalar_beta_input => scalar_beta_input,
      matrix_m_input    => matrix_m_input
    );

    return vector_c_output;
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

    matrix_b_input : matrix_buffer;
    matrix_c_input : matrix_buffer;
    matrix_f_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_w_output : matrix_buffer;

  begin

    -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

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
    vector_c_output := function_dnc_content_based_addressing (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_W_IN,

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

    return vector_w_output;
  end function function_dnc_write_weighting;

  function function_dnc_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_read_input    : matrix_buffer;
    vector_beta_read_input : vector_buffer;
    vector_f_read_input    : vector_buffer;
    vector_pi_read_input   : vector_buffer;

    matrix_k_write_input    : matrix_buffer;
    vector_beta_write_input : vector_buffer;
    vector_e_write_input    : vector_buffer;
    vector_v_write_input    : vector_buffer;
    scalar_ga_write_input   : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_gw_write_input   : std_logic_vector(DATA_SIZE-1 downto 0)
    ) return matrix_buffer is

    variable matrix_r_output : matrix_buffer;

  begin

    -- PRECEDENCE_WEIGHTING

    -- p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
    -- p(t=0) = 0

    -- TEMPORAL_LINK_MATRIX

    -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
    -- L(t=0)[g,j] = 0

    -- BACKWARD_FORWARD_WEIGHTING

    -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

    -- f(t;i;j) = L(t;g;j)·w(t-1;i;j)

    -- MEMORY_RETENTION_VECTOR

    -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

    -- USAGE_VECTOR

    -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)

    -- ALLOCATION_WEIGHTING

    -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]

    -- READ_WRITE_CONTENT_WEIGHTING

    -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

    -- c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))

    -- READ_WRITE_WEIGHTING

    -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

    -- w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))

    -- MEMORY_MATRIX

    -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

    -- READ_VECTORS

    -- r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)

    return matrix_r_output;
  end function function_dnc_addressing;

end dnc_core_pkg;