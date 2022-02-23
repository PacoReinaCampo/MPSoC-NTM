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
  -- TOP
  -----------------------------------------------------------------------

  function function_ntm_top (
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

  function function_ntm_interface_k_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer;

  function function_ntm_interface_beta_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_interface_g_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_ntm_interface_s_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer;

  function function_ntm_interface_gamma_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

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

end ntm_core_pkg;

package body ntm_core_pkg is

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

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
  -- TOP
  -----------------------------------------------------------------------

  function function_ntm_top (
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

    variable tensor_wk_int     : tensor_buffer;
    variable matrix_wbeta_int  : matrix_buffer;
    variable matrix_wg_int     : matrix_buffer;
    variable tensor_ws_int     : tensor_buffer;
    variable matrix_wgamma_int : matrix_buffer;

    variable tensor_k_int : tensor_buffer;

    variable matrix_m_in_int : matrix_buffer;
    variable matrix_w_in_int : matrix_buffer;

    variable matrix_wm_out_int : matrix_buffer;
    variable matrix_em_out_int : matrix_buffer;

    variable matrix_k_int : matrix_buffer;
    variable matrix_r_int : matrix_buffer;
    variable matrix_s_int : matrix_buffer;
    variable matrix_u_int : matrix_buffer;

    variable vector_w_in_int : vector_buffer;

    variable vector_w_out_int : vector_buffer;

    variable vector_a_int : vector_buffer;
    variable vector_e_int : vector_buffer;
    variable vector_h_int : vector_buffer;
    variable vector_g_int : vector_buffer;
    variable vector_k_int : vector_buffer;
    variable vector_r_int : vector_buffer;
    variable vector_s_int : vector_buffer;

    variable vector_beta_int  : vector_buffer;
    variable vector_gamma_int : vector_buffer;

    variable scalar_g_int : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_s_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_beta_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_gamma_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_y_output : vector_buffer;

  begin

    -- CONTROLLER_BODY_STATE

    -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + b(t;l))
    -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(t;l))
    
    -- INTERFACE_VECTOR_STATE

    -- xi(t;?) = U(t;?;l)·h(t;l)

    -- k(t;i;k) = U(t;i;k;l)·h(t;l)
    matrix_k_int := function_ntm_interface_k_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input     => tensor_wk_int,
      matrix_wbeta_input  => matrix_wbeta_int,
      matrix_wg_input     => matrix_wg_int,
      tensor_ws_input     => tensor_ws_int,
      matrix_wgamma_input => matrix_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- beta(t) = U(t;l)·h(t;l)
    vector_beta_int := function_ntm_interface_beta_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input     => tensor_wk_int,
      matrix_wbeta_input  => matrix_wbeta_int,
      matrix_wg_input     => matrix_wg_int,
      tensor_ws_input     => tensor_ws_int,
      matrix_wgamma_input => matrix_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- g(t) = U(t;l)·h(t;l)
    vector_g_int := function_ntm_interface_g_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input     => tensor_wk_int,
      matrix_wbeta_input  => matrix_wbeta_int,
      matrix_wg_input     => matrix_wg_int,
      tensor_ws_input     => tensor_ws_int,
      matrix_wgamma_input => matrix_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- s(t;i;j) = U(t;i;j;l)·h(t;l)
    matrix_s_int := function_ntm_interface_s_vector (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input     => tensor_wk_int,
      matrix_wbeta_input  => matrix_wbeta_int,
      matrix_wg_input     => matrix_wg_int,
      tensor_ws_input     => tensor_ws_int,
      matrix_wgamma_input => matrix_wgamma_int,

      vector_h_input => vector_h_int
      );

    -- gamma(t) = U(t;l)·h(t;l)
    vector_gamma_int := function_ntm_interface_gamma_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,

      tensor_wk_input     => tensor_wk_int,
      matrix_wbeta_input  => matrix_wbeta_int,
      matrix_wg_input     => matrix_wg_int,
      tensor_ws_input     => tensor_ws_int,
      matrix_wgamma_input => matrix_wgamma_int,

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

  function function_ntm_interface_k_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

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
  end function function_ntm_interface_k_vector;

  function function_ntm_interface_beta_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_beta_output : vector_buffer;

  begin

    -- beta(t;l) = U(t;l;m)·h(t;m)

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_beta_output(l) := ZERO_DATA;

      for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_beta_output(l) := std_logic_vector(to_float(to_real(to_float(vector_beta_output(l))) + (to_real(to_float(matrix_wbeta_input(l, m)))*to_real(to_float(vector_h_input(m))))));
      end loop;
    end loop;
      
    return vector_beta_output;
  end function function_ntm_interface_beta_vector;

  function function_ntm_interface_g_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_g_output : vector_buffer;

  begin

    -- g(t;l) = U(t;l;m)·h(t;m)

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_g_output(l) := ZERO_DATA;

      for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_g_output(l) := std_logic_vector(to_float(to_real(to_float(vector_g_output(l))) + (to_real(to_float(matrix_wg_input(l, m)))*to_real(to_float(vector_h_input(m))))));
      end loop;
    end loop;
      
    return vector_g_output;
  end function function_ntm_interface_g_vector;

  function function_ntm_interface_s_vector (
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_s_output : matrix_buffer;

  begin

    -- s(t;i;j) = U(t;i;j;l)·h(t;l)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_s_output(i, j) := ZERO_DATA;

        for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          matrix_s_output(i, j) := std_logic_vector(to_float(to_real(to_float(matrix_s_output(i, j))) + (to_real(to_float(tensor_ws_input(i, j, l)))*to_real(to_float(vector_h_input(l))))));
        end loop;
      end loop;
    end loop;
      
    return matrix_s_output;
  end function function_ntm_interface_s_vector;

  function function_ntm_interface_gamma_vector (
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_wk_input     : tensor_buffer;
    matrix_wbeta_input  : matrix_buffer;
    matrix_wg_input     : matrix_buffer;
    tensor_ws_input     : tensor_buffer;
    matrix_wgamma_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_gamma_output : vector_buffer;

  begin

    -- gamma(t;l) = U(t;l;m)·h(t;m)

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      vector_gamma_output(l) := ZERO_DATA;

      for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_gamma_output(l) := std_logic_vector(to_float(to_real(to_float(vector_gamma_output(l))) + (to_real(to_float(matrix_wgamma_input(l, m)))*to_real(to_float(vector_h_input(m))))));
      end loop;
    end loop;
      
    return vector_gamma_output;
  end function function_ntm_interface_gamma_vector;

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

end ntm_core_pkg;