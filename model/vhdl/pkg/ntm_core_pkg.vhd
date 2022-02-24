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

package ntm_core_pkg is

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

  constant LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(0.001));

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Buffer
  type vector_buffer is array (CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type matrix_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type tensor_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);
  type array4_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- READ HEADS
  -----------------------------------------------------------------------

  component ntm_reading is
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

      W_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      W_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      R_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  component ntm_writing is
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

      M_IN_J_ENABLE : in std_logic;
      M_IN_K_ENABLE : in std_logic;

      W_IN_ENABLE : in std_logic;

      A_IN_ENABLE : in std_logic;

      W_OUT_ENABLE : out std_logic;

      A_OUT_ENABLE : out std_logic;

      M_OUT_J_ENABLE : out std_logic;
      M_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_erasing is
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

      M_IN_J_ENABLE : in std_logic;
      M_IN_K_ENABLE : in std_logic;

      W_IN_ENABLE : in std_logic;       -- for j in 0 to N-1

      E_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      W_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      E_OUT_ENABLE : in std_logic;      -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;
      M_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  component ntm_content_based_addressing is
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

      K_IN_ENABLE : in std_logic;

      K_OUT_ENABLE : out std_logic;

      M_IN_I_ENABLE : in std_logic;
      M_IN_J_ENABLE : in std_logic;

      M_OUT_I_ENABLE : out std_logic;
      M_OUT_J_ENABLE : out std_logic;

      C_OUT_ENABLE : out std_logic;

      -- DATA
      SIZE_I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      SIZE_J_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      M_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);

      C_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_addressing is
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
      S_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      K_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1
      S_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      W_IN_ENABLE  : in  std_logic;     -- for j in 0 to N-1
      W_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      G_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      S_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      GAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_IN  : in  std_logic_vector(DATA_SIZE-1 downto 0);
      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  -----------------------------------------------------------------------
  -- TOP
  -----------------------------------------------------------------------

  component ntm_top is
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

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

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

  component ntm_interface_vector is
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

      -- Key Vector
      WK_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      WK_IN_K_ENABLE : in std_logic;    -- for k in 0 to W-1

      WK_OUT_L_ENABLE : out std_logic;  -- for l in 0 to L-1
      WK_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

      K_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      -- Key Strength
      WBETA_IN_ENABLE : in std_logic;   -- for l in 0 to L-1

      WBETA_OUT_ENABLE : out std_logic;  -- for l in 0 to L-1

      -- Interpolation Gate
      WG_IN_ENABLE : in std_logic;      -- for l in 0 to L-1

      WG_OUT_ENABLE : out std_logic;    -- for l in 0 to L-1

      -- Shift Weighting
      WS_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      WS_IN_J_ENABLE : in std_logic;    -- for j in 0 to N-1

      WS_OUT_L_ENABLE : out std_logic;  -- for l in 0 to L-1
      WS_OUT_J_ENABLE : out std_logic;  -- for j in 0 to N-1

      S_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

      -- Sharpening
      WGAMMA_IN_ENABLE : in std_logic;  -- for l in 0 to L-1

      WGAMMA_OUT_ENABLE : out std_logic;  -- for l in 0 to L-1

      -- Hidden State
      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      WK_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      WBETA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      WG_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      WS_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      WGAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0);
      G_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      S_OUT     : out std_logic_vector(DATA_SIZE-1 downto 0);
      GAMMA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component ntm_output_vector is
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
  -- READ HEADS
  -----------------------------------------------------------------------

  function function_ntm_reading (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    matrix_m_input : matrix_buffer
    ) return matrix_buffer;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  function function_ntm_writing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_a_input : vector_buffer;
    vector_w_input : vector_buffer
    ) return matrix_buffer;

  function function_ntm_erasing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_e_input : vector_buffer;
    vector_w_input : vector_buffer
    ) return matrix_buffer;

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  function function_ntm_content_based_addressing (
    SIZE_I_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_J_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0);
    matrix_m_input    : matrix_buffer
    ) return vector_buffer;

  function function_ntm_addressing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input     : vector_buffer;
    scalar_beta_input  : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_g_input     : std_logic_vector(DATA_SIZE-1 downto 0);
    vector_s_input     : vector_buffer;
    scalar_gamma_input : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;

    vector_w_input : vector_buffer

    ) return vector_buffer;

  -----------------------------------------------------------------------
  -- TOP - INTERFACE
  -----------------------------------------------------------------------

  function function_ntm_interface_k_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_interface_beta_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector;

  function function_ntm_interface_g_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector;

  function function_ntm_interface_s_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_interface_gamma_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector;

  -----------------------------------------------------------------------
  -- TOP - OUTPUT
  -----------------------------------------------------------------------

  function function_ntm_output_vector (
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

  function function_ntm_top (
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

end ntm_core_pkg;

package body ntm_core_pkg is

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
  -- READ HEADS
  -----------------------------------------------------------------------

  function function_ntm_reading (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    matrix_m_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_r_output : matrix_buffer;

  begin

    -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_r_output(i, k) := ZERO_DATA;

        for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
          matrix_r_output(i, k) := std_logic_vector(to_float(to_real(to_float(matrix_r_output(i, k))) + (to_real(to_float(matrix_w_input(i, j)))*to_real(to_float(matrix_m_input(j, k))))));
        end loop;
      end loop;
    end loop;

    return matrix_r_output;
  end function function_ntm_reading;

  -----------------------------------------------------------------------
  -- WRITE HEADS
  -----------------------------------------------------------------------

  function function_ntm_writing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_a_input : vector_buffer;
    vector_w_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_m_output : matrix_buffer;

  begin

    -- M(t;j;k) = M(t;j;k) + w(t;j)·a(t;k)

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_m_output(j, k) := std_logic_vector(to_float(to_real(to_float(matrix_m_input(j, k))) + (to_real(to_float(vector_w_input(j)))*to_real(to_float(vector_a_input(k))))));
      end loop;
    end loop;

    return matrix_m_output;
  end function function_ntm_writing;

  function function_ntm_erasing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_e_input : vector_buffer;
    vector_w_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_m_output : matrix_buffer;

  begin

    -- M(t;j;k) = M(t;j;k)·(1 - w(t;j)·e(t;k))

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_m_output(j, k) := std_logic_vector(to_float(to_real(to_float(matrix_m_input(j, k)))*(1.0 - to_real(to_float(vector_w_input(j)))*to_real(to_float(vector_e_input(k))))));
      end loop;
    end loop;

    return matrix_m_output;
  end function function_ntm_erasing;

  -----------------------------------------------------------------------
  -- MEMORY
  -----------------------------------------------------------------------

  function function_ntm_content_based_addressing (
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

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      -- Dot product k,M[i,·]
      vector_operation_int(i) := ZERO_DATA;

      -- Module M[i,·]
      vector_m_operation_int(i) := ZERO_DATA;

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

    data_summation_int := ZERO_DATA;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      data_summation_int := std_logic_vector(to_float(to_real(to_float(data_summation_int)) + to_real(to_float(vector_operation_int(i)))));
    end loop;

    for i in 0 to to_integer(unsigned(SIZE_I_IN))-1 loop
      vector_c_output(i) := std_logic_vector(to_float(exp(to_real(to_float(vector_operation_int(i)))/to_real(to_float(data_summation_int)))));
    end loop;

    return vector_c_output;
  end function function_ntm_content_based_addressing;

  function function_ntm_addressing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input     : vector_buffer;
    scalar_beta_input  : std_logic_vector(DATA_SIZE-1 downto 0);
    scalar_g_input     : std_logic_vector(DATA_SIZE-1 downto 0);
    vector_s_input     : vector_buffer;
    scalar_gamma_input : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;

    vector_w_input : vector_buffer

    ) return vector_buffer is

    variable vector_wc_output : vector_buffer;
    variable vector_wg_output : vector_buffer;

    variable vector_w_output : vector_buffer;

    variable data_summation_int : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- wc(t;j) = C(M(t;j;k),k(t;k),beta(t))
    vector_wc_output := function_ntm_content_based_addressing (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_W_IN,

      vector_k_input    => vector_k_input,
      scalar_beta_input => scalar_beta_input,
      matrix_m_input    => matrix_m_input
      );

    -- wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)
    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_wg_output(j) := std_logic_vector(to_float(to_real(to_float(scalar_g_input))*to_real(to_float(vector_wc_output(j))) + (1.0 - to_real(to_float(scalar_g_input)))*to_real(to_float(vector_w_input(j)))));
    end loop;

    -- w(t;j) = wg(t;j)*s(t;k)
    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_w_output(j) := ZERO_DATA;

      for m in 0 to j loop
        vector_w_output(j) := std_logic_vector(to_float(to_real(to_float(vector_w_output(j))) + (to_real(to_float(vector_wg_output(m)))*to_real(to_float(vector_s_input(j-m))))));
      end loop;
    end loop;

    -- w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]
    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_w_output(j) := std_logic_vector(to_float(to_real(to_float(vector_w_output(j)))**to_real(to_float(scalar_gamma_input))));
    end loop;

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      data_summation_int := std_logic_vector(to_float(to_real(to_float(data_summation_int)) + to_real(to_float(vector_w_output(j)))));
    end loop;

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_w_output(j) := std_logic_vector(to_float(exp(to_real(to_float(vector_w_output(j)))/to_real(to_float(data_summation_int)))));
    end loop;

    return vector_w_output;
  end function function_ntm_addressing;

  -----------------------------------------------------------------------
  -- TOP - INTERFACE
  -----------------------------------------------------------------------

  function function_ntm_interface_k_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

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
  end function function_ntm_interface_k_vector;

  function function_ntm_interface_beta_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

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
  end function function_ntm_interface_beta_vector;

  function function_ntm_interface_g_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector is

    variable scalar_g_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- g(t) = U(t;l)·h(t;l)

    scalar_g_output := ZERO_DATA;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_g_output := std_logic_vector(to_float(to_real(to_float(scalar_g_output)) + (to_real(to_float(vector_wg_input(l)))*to_real(to_float(vector_h_input(l))))));
    end loop;

    return scalar_g_output;
  end function function_ntm_interface_g_vector;

  function function_ntm_interface_s_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_s_output : vector_buffer;

  begin

    -- s(t;j) = U(t;j;l)·h(t;l)

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_s_output(j) := ZERO_DATA;

      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_s_output(j) := std_logic_vector(to_float(to_real(to_float(vector_s_output(j))) + (to_real(to_float(matrix_ws_input(j, l)))*to_real(to_float(vector_h_input(l))))));
      end loop;
    end loop;

    return vector_s_output;
  end function function_ntm_interface_s_vector;

  function function_ntm_interface_gamma_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_wk_input     : matrix_buffer;
    vector_wbeta_input  : vector_buffer;
    vector_wg_input     : vector_buffer;
    matrix_ws_input     : matrix_buffer;
    vector_wgamma_input : vector_buffer;

    vector_h_input : vector_buffer
    ) return std_logic_vector is

    variable scalar_gamma_output : std_logic_vector(DATA_SIZE-1 downto 0);

  begin

    -- gamma(t) = U(t;l)·h(t;l)

    scalar_gamma_output := ZERO_DATA;

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_gamma_output := std_logic_vector(to_float(to_real(to_float(scalar_gamma_output)) + (to_real(to_float(vector_wgamma_input(l)))*to_real(to_float(vector_h_input(l))))));
    end loop;

    return scalar_gamma_output;
  end function function_ntm_interface_gamma_vector;

  -----------------------------------------------------------------------
  -- TOP - OUTPUT
  -----------------------------------------------------------------------

  function function_ntm_output_vector (
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
  end function function_ntm_output_vector;

  -----------------------------------------------------------------------
  -- TOP
  -----------------------------------------------------------------------

  function function_ntm_top (
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
    variable matrix_wk_int     : matrix_buffer;
    variable vector_wbeta_int  : vector_buffer;
    variable vector_wg_int     : vector_buffer;
    variable matrix_ws_int     : matrix_buffer;
    variable vector_wgamma_int : vector_buffer;

    variable tensor_k_int : tensor_buffer;
    variable matrix_u_int : matrix_buffer;

    variable tensor_kt_int : array4_buffer;
    variable matrix_ut_int : tensor_buffer;

    variable vector_xt_int : matrix_buffer;
    variable matrix_rt_int : tensor_buffer;
    variable vector_ht_int : matrix_buffer;

    -- Internal Variable
    variable matrix_m_in_int : matrix_buffer;
    variable matrix_w_in_int : matrix_buffer;

    variable matrix_wm_out_int : matrix_buffer;
    variable matrix_em_out_int : matrix_buffer;

    variable matrix_r_int : matrix_buffer;

    variable vector_w_in_int : vector_buffer;

    variable vector_w_out_int : vector_buffer;

    variable vector_a_int : vector_buffer;
    variable vector_e_int : vector_buffer;
    variable vector_h_int : vector_buffer;
    variable vector_k_int : vector_buffer;
    variable vector_s_int : vector_buffer;

    variable scalar_g_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_beta_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_gamma_int : std_logic_vector(DATA_SIZE-1 downto 0);

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

    -- INTERFACE_VECTOR_STATE

    -- xi(t;?) = U(t;?;l)·h(t;l)

    -- k(t;k) = U(t;k;l)·h(t;l)
    vector_k_int := function_ntm_interface_k_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input     => matrix_wk_int,
      vector_wbeta_input  => vector_wbeta_int,
      vector_wg_input     => vector_wg_int,
      matrix_ws_input     => matrix_ws_int,
      vector_wgamma_input => vector_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- beta(t) = U(t;l)·h(t;l)
    scalar_beta_int := function_ntm_interface_beta_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input     => matrix_wk_int,
      vector_wbeta_input  => vector_wbeta_int,
      vector_wg_input     => vector_wg_int,
      matrix_ws_input     => matrix_ws_int,
      vector_wgamma_input => vector_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- g(t) = U(t;l)·h(t;l)
    scalar_g_int := function_ntm_interface_g_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input     => matrix_wk_int,
      vector_wbeta_input  => vector_wbeta_int,
      vector_wg_input     => vector_wg_int,
      matrix_ws_input     => matrix_ws_int,
      vector_wgamma_input => vector_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- s(t;j) = U(t;j;l)·h(t;l)
    vector_s_int := function_ntm_interface_s_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input     => matrix_wk_int,
      vector_wbeta_input  => vector_wbeta_int,
      vector_wg_input     => vector_wg_int,
      matrix_ws_input     => matrix_ws_int,
      vector_wgamma_input => vector_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- gamma(t) = U(t;l)·h(t;l)
    scalar_gamma_int := function_ntm_interface_gamma_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      matrix_wk_input     => matrix_wk_int,
      vector_wbeta_input  => vector_wbeta_int,
      vector_wg_input     => vector_wg_int,
      matrix_ws_input     => matrix_ws_int,
      vector_wgamma_input => vector_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- READ_HEADS_STATE

    -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]
    matrix_r_int := function_ntm_reading (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_w_input => matrix_w_in_int,
      matrix_m_input => matrix_m_in_int
      );

    -- WRITE_HEADS_STATE

    -- M(t;j;k) = M(t;j;k) + w(t;j)·a(t;k)
    matrix_wm_out_int := function_ntm_writing (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_m_input => matrix_m_in_int,
      vector_a_input => vector_a_int,
      vector_w_input => vector_w_in_int
      );

    -- M(t;j;k) = M(t;j;k)·(1 - w(t;j)·e(t;k))
    matrix_em_out_int := function_ntm_erasing (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_m_input => matrix_m_in_int,
      vector_e_input => vector_e_int,
      vector_w_input => vector_w_in_int
      );

    -- MEMORY_STATE

    -- wc(t;j) = C(M(t1;j;k),k(t;k),beta(t))
    -- wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)
    -- w(t;j) = wg(t;j)*s(t;k)
    -- w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]

    vector_w_out_int := function_ntm_addressing (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      vector_k_input     => vector_k_int,
      scalar_beta_input  => scalar_beta_int,
      scalar_g_input     => scalar_g_int,
      vector_s_input     => vector_s_int,
      scalar_gamma_input => scalar_gamma_int,

      matrix_m_input => matrix_m_in_int,

      vector_w_input => vector_w_in_int
      );

    -- OUTPUT_VECTOR_STATE

    -- y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)
    vector_y_output := function_ntm_output_vector (
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

  end function function_ntm_top;

end ntm_core_pkg;
