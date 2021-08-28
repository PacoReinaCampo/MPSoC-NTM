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

package dnc_core_pkg is

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  component dnc_content_based_addressing is
    generic (
      I : integer := 64;
      J : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      K_IN    : in std_logic_arithmetic_vector_vector(J-1 downto 0)(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_arithmetic_vector_vector(J-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(I-1 downto 0)(DATA_SIZE-1 downto 0);
      C_OUT  : out std_logic_arithmetic_vector_vector(I-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_allocation_weighting is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      PHI_IN_ENABLE : in std_logic;
      U_IN_ENABLE   : in std_logic;

      A_OUT_ENABLE : out std_logic;

      -- DATA
      PHI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      A_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_backward_weighting is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      L_IN_ENABLE : in std_logic;
      W_IN_ENABLE : in std_logic;

      B_OUT_ENABLE : out std_logic;

      -- DATA
      L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_forward_weighting is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      L_IN_ENABLE : in std_logic;
      W_IN_ENABLE : in std_logic;

      F_OUT_ENABLE : out std_logic;

      -- DATA
      L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      F_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_memory_matrix is
    generic (
      N : integer := 64;
      W : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      M_IN_ENABLE : in std_logic;
      W_IN_ENABLE : in std_logic;

      M_OUT_ENABLE : out std_logic;

      -- DATA
      M_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      E_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      M_OUT  : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_memory_retention_vector is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      F_IN_ENABLE : in std_logic;
      W_IN_ENABLE : in std_logic;

      PSI_OUT_ENABLE : out std_logic;

      -- DATA
      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      PSI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_precedence_weighting is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      W_IN_ENABLE : in std_logic;
      P_IN_ENABLE : in std_logic;

      P_OUT_ENABLE : out std_logic;

      -- DATA
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      P_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_content_weighting is
    generic (
      N : integer := 64;
      W : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      C_OUT_ENABLE : out std_logic;

      -- DATA
      K_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      C_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_vectors is
    generic (
      N : integer := 64;
      W : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      M_IN_ENABLE : in std_logic;
      W_IN_ENABLE : in std_logic;

      -- DATA
      M_IN : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      R_OUT  : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_weighting is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      B_IN_ENABLE : in std_logic;
      C_IN_ENABLE : in std_logic;
      F_IN_ENABLE : in std_logic;

      W_OUT_ENABLE : out std_logic;

      -- DATA
      PI_IN : in std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);

      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      W_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_temporal_link_matrix is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      L_IN_ENABLE : in std_logic;

      WR_IN_ENABLE : in std_logic;
      WW_IN_ENABLE : in std_logic;
      P_IN_ENABLE  : in std_logic;

      L_OUT_ENABLE : out std_logic;

      -- DATA
      L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      WR_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      WW_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      P_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      L_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_usage_vector is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      U_IN_ENABLE   : in std_logic;
      W_IN_ENABLE   : in std_logic;
      PSI_IN_ENABLE : in std_logic;

      U_OUT_ENABLE : out std_logic;

      -- DATA
      U_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      PSI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_write_content_weighting is
    generic (
      N : integer := 64;
      W : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      BETA_IN_ENABLE : in std_logic;

      C_OUT_ENABLE : out std_logic;

      -- DATA
      K_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      C_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_write_weighting is
    generic (
      N : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      A_IN_ENABLE : in std_logic;
      C_IN_ENABLE : in std_logic;

      W_OUT_ENABLE : out std_logic;

      -- DATA
      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      G_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_vector(DATA_SIZE-1 downto 0);
      W_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_addressing is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      K_READ_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_READ_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      F_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      PI_READ_IN   : in std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);

      K_WRITE_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_WRITE_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      E_WRITE_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      V_WRITE_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      GA_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      GW_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      MODULO : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      R_OUT  : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component dnc_addressing;

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  component dnc_free_gates is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      F_IN_ENABLE : in std_logic;  -- for i in 0 to R-1

      F_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1

      -- DATA
      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_keys is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1
      K_IN_J_ENABLE : in std_logic;  -- for j in 0 to W-1

      K_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1
      K_OUT_J_ENABLE : out std_logic;  -- for j in 0 to W-1

      -- DATA
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_modes is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      PI_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1
      PI_IN_J_ENABLE : in std_logic;  -- for i in 0 to 2

      PI_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1
      PI_OUT_J_ENABLE : out std_logic;  -- for i in 0 to 2

      -- DATA
      PI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      PI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_strengths is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      BETA_IN_ENABLE : in std_logic;  -- for i in 0 to R-1

      BETA_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1

      -- DATA
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  component dnc_allocation_gate is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
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
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      E_IN_ENABLE : in std_logic;  -- for i in 0 to W-1

      E_OUT_ENABLE : out std_logic;  -- for i in 0 to W-1

      -- DATA
      E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      E_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_write_gate is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
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
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_ENABLE : in std_logic;  -- for j in 0 to W-1

      K_OUT_ENABLE : out std_logic;  -- for j in 0 to W-1

      -- DATA
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_write_strength is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
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
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;
      R : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      V_IN_ENABLE : in std_logic;  -- for i in 0 to W-1

      V_OUT_ENABLE : out std_logic;  -- for i in 0 to W-1

      -- DATA
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

  -----------------------------------------------------------------------
  -- TOP
  -----------------------------------------------------------------------

  component dnc_top is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      X_IN : in std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      Y_OUT  : out std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_output_vector is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      R_IN  : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      NU_IN : in std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);

      W_IN : in std_logic_arithmetic_vector_matrix(Y-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);

      MODULO : in  std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
      Y_OUT  : out std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_read_interface_vector is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      WK_IN    : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      WBETA_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
      WF_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
      WPI_IN   : out std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT    : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      F_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
      PI_OUT   : out std_logic_arithmetic_vector_vector(2 downto 0)(DATA_SIZE-1 downto 0)
    );
  end component;

  component dnc_write_interface_vector is
    generic (
      X : integer := 64;
      Y : integer := 64;
      N : integer := 64;
      W : integer := 64;
      L : integer := 64;

      DATA_SIZE : integer := 512
    );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      -- DATA
      WK_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      WBETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      WE_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      WV_IN    : in std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      WGA_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      WGW_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT    : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      E_OUT    : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      V_OUT    : out std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
      GA_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0);
      GW_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
  end component;

end dnc_core_pkg;
