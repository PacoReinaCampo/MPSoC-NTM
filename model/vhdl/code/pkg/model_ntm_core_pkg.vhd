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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_fnn_controller_pkg.all;

package model_ntm_core_pkg is

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- READ HEADS
  ------------------------------------------------------------------------------

  component model_reading is
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

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- WRITE HEADS
  ------------------------------------------------------------------------------

  component model_writing is
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

      M_IN_J_ENABLE : in std_logic;
      M_IN_K_ENABLE : in std_logic;

      W_IN_I_ENABLE : in std_logic;
      W_IN_J_ENABLE : in std_logic;

      A_IN_ENABLE : in std_logic;

      W_OUT_I_ENABLE : out std_logic;
      W_OUT_J_ENABLE : out std_logic;

      A_OUT_ENABLE : out std_logic;

      M_OUT_J_ENABLE : out std_logic;
      M_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_erasing is
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

      M_IN_J_ENABLE : in std_logic;
      M_IN_K_ENABLE : in std_logic;

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      E_IN_ENABLE : in std_logic;       -- for k in 0 to W-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      E_OUT_ENABLE : out std_logic;     -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;
      M_OUT_K_ENABLE : out std_logic;

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- MEMORY
  ------------------------------------------------------------------------------

  component model_content_based_addressing is
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

  component model_addressing is
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

      K_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      BETA_IN_ENABLE : in std_logic;    -- for i in 0 to R-1

      G_IN_ENABLE : in std_logic;       -- for i in 0 to R-1

      S_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      S_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      GAMMA_IN_ENABLE : in std_logic;   -- for i in 0 to R-1

      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      BETA_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1

      G_OUT_ENABLE : out std_logic;     -- for i in 0 to R-1

      S_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      S_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      GAMMA_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1

      M_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1
      M_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      M_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1
      M_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      W_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      W_IN_J_ENABLE : in std_logic;     -- for j in 0 to N-1

      W_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      W_OUT_J_ENABLE : out std_logic;   -- for j in 0 to N-1

      -- DATA
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
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

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

  component model_top is
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

      V_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      D_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      D_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      P_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      P_IN_Y_ENABLE : in std_logic;     -- for y in 0 to Y-1
      P_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      P_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      P_OUT_Y_ENABLE : out std_logic;   -- for y in 0 to Y-1
      P_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      Q_IN_Y_ENABLE : in std_logic;     -- for y in 0 to Y-1
      Q_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      Q_OUT_Y_ENABLE : out std_logic;   -- for y in 0 to Y-1
      Q_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

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
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_interface_vector is
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

      -- Weight
      U_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1
      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      U_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1
      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- Hidden State
      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : in std_logic;      -- for l in 0 to L-1

      -- Interface
      XI_OUT_ENABLE : in std_logic;     -- for s in 0 to S-1

      -- DATA
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      XI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_interface_matrix is
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

      -- Weight
      U_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      U_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1
      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      U_OUT_I_ENABLE : in  std_logic;   -- for i in 0 to R-1
      U_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1
      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- Hidden State
      H_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      H_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      H_OUT_I_ENABLE : in std_logic;    -- for i in 0 to R-1
      H_OUT_L_ENABLE : in std_logic;    -- for l in 0 to L-1

      -- Interface
      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      -- DATA
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      RHO_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_output_vector is
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

      P_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      P_IN_Y_ENABLE : in std_logic;     -- for y in 0 to Y-1
      P_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      P_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      P_OUT_Y_ENABLE : out std_logic;   -- for y in 0 to Y-1
      P_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      R_IN_K_ENABLE : in std_logic;     -- for j in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      R_OUT_K_ENABLE : out std_logic;   -- for j in 0 to W-1

      Q_IN_Y_ENABLE : in std_logic;     -- for y in 0 to Y-1
      Q_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      Q_OUT_Y_ENABLE : out std_logic;   -- for y in 0 to Y-1
      Q_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      Y_OUT_ENABLE : out std_logic;     -- for y in 0 to Y-1

      -- DATA
      SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      P_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- READ HEADS
  ------------------------------------------------------------------------------

  function function_model_reading (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    matrix_m_input : matrix_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- WRITE HEADS
  ------------------------------------------------------------------------------

  function function_model_writing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_a_input : vector_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_erasing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_e_input : vector_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- MEMORY
  ------------------------------------------------------------------------------

  function function_model_vector_content_based_addressing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0);
    matrix_m_input    : matrix_buffer
    ) return vector_buffer;

  function function_model_matrix_content_based_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input    : matrix_buffer;
    vector_beta_input : vector_buffer;
    matrix_m_input    : matrix_buffer
    ) return matrix_buffer;

  function function_model_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input     : matrix_buffer;
    vector_beta_input  : vector_buffer;
    vector_g_input     : vector_buffer;
    matrix_s_input     : matrix_buffer;
    vector_gamma_input : vector_buffer;

    matrix_m_input : matrix_buffer;

    matrix_w_input : matrix_buffer

    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- TOP - INTERFACE
  ------------------------------------------------------------------------------

  function function_model_interface_vector (
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_u_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer;

  function function_model_interface_matrix (
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_u_input : tensor_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- TOP - OUTPUT
  ------------------------------------------------------------------------------

  function function_model_output_vector (
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_p_input : tensor_buffer;
    matrix_r_input : matrix_buffer;

    matrix_q_input : matrix_buffer;
    vector_h_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

  function function_model_top (
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
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer;

    tensor_p_input : tensor_buffer;
    matrix_q_input : matrix_buffer
    ) return vector_buffer;

end model_ntm_core_pkg;

package body model_ntm_core_pkg is

  ------------------------------------------------------------------------------
  -- READ HEADS
  ------------------------------------------------------------------------------

  function function_model_reading (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    matrix_m_input : matrix_buffer
    ) return matrix_buffer is

    variable vector_summation_int : vector_buffer;

    variable matrix_operation_int : matrix_buffer;

    variable matrix_r_output : matrix_buffer;

  begin

    -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
          matrix_operation_int(j, k) := matrix_w_input(i, j);
        end loop;
      end loop;

      matrix_operation_int := function_matrix_float_multiplier (
        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_W_IN,

        matrix_a_input => matrix_operation_int,
        matrix_b_input => matrix_m_input
        );

      vector_summation_int := function_vector_summation (
        SIZE_IN   => SIZE_N_IN,
        LENGTH_IN => SIZE_W_IN,

        vector_input => matrix_operation_int
        );

      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        matrix_r_output(i, k) := vector_summation_int(k);
      end loop;
    end loop;

    return matrix_r_output;
  end function function_model_reading;

  ------------------------------------------------------------------------------
  -- WRITE HEADS
  ------------------------------------------------------------------------------

  function function_model_writing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_a_input : vector_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_first_operation_int  : matrix_buffer;
    variable matrix_second_operation_int : matrix_buffer;

    variable vector_w_int : vector_buffer;

    variable matrix_m_output : matrix_buffer;

  begin

    -- M(t;j;k) = M(t;j;k) + w(t;i;j)·a(t;k)
    matrix_first_operation_int := (others => (others => ZERO_DATA));

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        vector_w_int(j) := matrix_w_input(i, j);
      end loop;

      matrix_second_operation_int := function_transpose_vector_product (
        SIZE_A_IN => SIZE_N_IN,
        SIZE_B_IN => SIZE_W_IN,

        vector_a_input => vector_w_int,
        vector_b_input => vector_a_input
        );

      matrix_first_operation_int := function_matrix_float_adder (
        OPERATION => '0',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_W_IN,

        matrix_a_input => matrix_first_operation_int,
        matrix_b_input => matrix_second_operation_int
        );
    end loop;

    matrix_m_output := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_W_IN,

      matrix_a_input => matrix_m_input,
      matrix_b_input => matrix_first_operation_int
      );

    return matrix_m_output;
  end function function_model_writing;

  function function_model_erasing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_m_input : matrix_buffer;
    vector_e_input : vector_buffer;
    matrix_w_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_first_operation_int  : matrix_buffer;
    variable matrix_second_operation_int : matrix_buffer;

    variable vector_w_int : vector_buffer;

    variable matrix_m_output : matrix_buffer;

  begin

    -- M(t;j;k) = M(t;j;k)·(1 - w(t;i;j)·e(t;k))
    matrix_first_operation_int := (others => (others => ONE_DATA));

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        vector_w_int(j) := matrix_w_input(i, j);
      end loop;

      matrix_second_operation_int := function_transpose_vector_product (
        SIZE_A_IN => SIZE_N_IN,
        SIZE_B_IN => SIZE_W_IN,

        vector_a_input => vector_w_int,
        vector_b_input => vector_e_input
        );

      matrix_first_operation_int := function_matrix_float_adder (
        OPERATION => '1',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_W_IN,

        matrix_a_input => matrix_first_operation_int,
        matrix_b_input => matrix_second_operation_int
        );
    end loop;

    matrix_m_output := function_matrix_float_multiplier (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_W_IN,

      matrix_a_input => matrix_m_input,
      matrix_b_input => matrix_first_operation_int
      );

    return matrix_m_output;
  end function function_model_erasing;

  ------------------------------------------------------------------------------
  -- MEMORY
  ------------------------------------------------------------------------------

  function function_model_vector_content_based_addressing (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_k_input    : vector_buffer;
    scalar_beta_input : std_logic_vector(DATA_SIZE-1 downto 0);
    matrix_m_input    : matrix_buffer
    ) return vector_buffer is

    variable vector_j_operation_int : vector_buffer;
    variable vector_k_operation_int : vector_buffer;

    variable vector_beta_int : vector_buffer;

    variable vector_c_output : vector_buffer;

  begin

    -- C(M[j,·],k,beta)[j] = softmax(cosine_similarity(k,M[j,·])·beta)[j]

    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_beta_int(j) := scalar_beta_input;

      for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
        vector_k_operation_int(k) := matrix_m_input(j, k);
      end loop;

      vector_k_operation_int := function_vector_cosine_similarity (
        LENGTH_IN => SIZE_W_IN,

        vector_a_input => vector_k_input,
        vector_b_input => vector_k_operation_int
        );

      vector_j_operation_int(j) := vector_k_operation_int(to_integer(unsigned(SIZE_W_IN))-1);
    end loop;

    vector_j_operation_int := function_vector_float_multiplier (
      SIZE_IN => SIZE_N_IN,

      vector_a_input => vector_j_operation_int,
      vector_b_input => vector_beta_int
      );

    vector_c_output := function_vector_softmax (
      SIZE_IN => SIZE_N_IN,

      vector_input => vector_j_operation_int
      );

    return vector_c_output;
  end function function_model_vector_content_based_addressing;

  function function_model_matrix_content_based_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input    : matrix_buffer;
    vector_beta_input : vector_buffer;
    matrix_m_input    : matrix_buffer
    ) return matrix_buffer is

    variable vector_k_input : vector_buffer;

    variable matrix_j_operation_int : matrix_buffer;
    variable vector_k_operation_int : vector_buffer;

    variable matrix_beta_int : matrix_buffer;

    variable matrix_c_output : matrix_buffer;

  begin

    -- C(M[j,·],k,beta)[j] = softmax(cosine_similarity(k,M[j,·])·beta)[j]

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_beta_int(i, j) := vector_beta_input(i);

        for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
          vector_k_operation_int(k) := matrix_m_input(j, k);

          vector_k_input(k) := matrix_k_input(i, k);
        end loop;

        vector_k_operation_int := function_vector_cosine_similarity (
          LENGTH_IN => SIZE_W_IN,

          vector_a_input => vector_k_input,
          vector_b_input => vector_k_operation_int
          );

        matrix_j_operation_int(i, j) := vector_k_operation_int(to_integer(unsigned(SIZE_W_IN))-1);
      end loop;
    end loop;

    matrix_j_operation_int := function_matrix_float_multiplier (
      SIZE_I_IN => SIZE_R_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_j_operation_int,
      matrix_b_input => matrix_beta_int
      );

    matrix_c_output := function_matrix_softmax (
      SIZE_I_IN => SIZE_R_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_input => matrix_j_operation_int
      );

    return matrix_c_output;
  end function function_model_matrix_content_based_addressing;

  function function_model_addressing (
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input     : matrix_buffer;
    vector_beta_input  : vector_buffer;
    vector_g_input     : vector_buffer;
    matrix_s_input     : matrix_buffer;
    vector_gamma_input : vector_buffer;

    matrix_m_input : matrix_buffer;

    matrix_w_input : matrix_buffer

    ) return matrix_buffer is

    variable matrix_wc_output : matrix_buffer;

    variable vector_wg_output : vector_buffer;
    variable matrix_wg_output : matrix_buffer;

    variable matrix_operation_int : matrix_buffer;

    variable vector_one_int : vector_buffer;

    variable vector_summation_int : vector_buffer;
    variable matrix_summation_int : matrix_buffer;

    variable vector_s_input     : vector_buffer;
    variable matrix_gamma_input : matrix_buffer;

    variable vector_w_output : vector_buffer;
    variable matrix_w_output : matrix_buffer;

  begin

    -- wc(t;i;j) = C(M(t;j;k),k(t;i;k),beta(t;i))
    matrix_wc_output := function_model_matrix_content_based_addressing (
      SIZE_R_IN => SIZE_R_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_W_IN => SIZE_W_IN,

      matrix_k_input    => matrix_k_input,
      vector_beta_input => vector_beta_input,
      matrix_m_input    => matrix_m_input
      );

    -- wg(t;i;j) = g(t;i)·wc(t;i;j) + (1 - g(t;i))·w(t-1;i;j)
    for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      vector_one_int(j) := ONE_DATA;
    end loop;

    -- 1 - g(t;i)
    matrix_operation_int := function_transpose_vector_product (
      SIZE_A_IN => SIZE_R_IN,
      SIZE_B_IN => SIZE_N_IN,

      vector_a_input => vector_g_input,
      vector_b_input => vector_one_int
      );

    -- (1 - g(t;i))·w(t-1;i;j)
    matrix_operation_int := function_matrix_float_multiplier (
      SIZE_I_IN => SIZE_R_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_operation_int,
      matrix_b_input => matrix_w_input
      );

    -- g(t;i)
    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_operation_int(i, j) := vector_g_input(j);
      end loop;
    end loop;

    -- g(t;i)·wc(t;i;j)
    matrix_wg_output := function_matrix_float_multiplier (
      SIZE_I_IN => SIZE_R_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_operation_int,
      matrix_b_input => matrix_wc_output
      );

    -- w(t;i;j) = wg(t;i;j)*s(t;i;j)
    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        vector_wg_output(j) := matrix_wg_output(i, j);
        vector_s_input(j)   := matrix_s_input(i, j);
      end loop;

      vector_w_output := function_vector_convolution (
        LENGTH_IN => SIZE_N_IN,

        vector_a_input => vector_wg_output,
        vector_b_input => vector_s_input
        );

      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_w_output(i, j) := vector_w_output(j);
      end loop;
    end loop;

    -- w(t;i;j) = exponentiation(w(t;i;j),gamma(t;i)) / summation(exponentiation(w(t;i;j),gamma(t;i)))[j in 0 to N-1]
    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_gamma_input(i, j) := vector_gamma_input(i);
      end loop;
    end loop;

    matrix_w_output := function_matrix_power (
      SIZE_I_IN => SIZE_R_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_w_output,
      matrix_b_input => matrix_gamma_input
      );

    vector_summation_int := function_vector_summation (
      SIZE_IN   => SIZE_R_IN,
      LENGTH_IN => SIZE_N_IN,

      vector_input => matrix_w_output
      );

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_summation_int(i, j) := vector_summation_int(i);
      end loop;
    end loop;

    matrix_w_output := function_matrix_float_divider (
      SIZE_I_IN => SIZE_R_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_w_output,
      matrix_b_input => matrix_summation_int
      );

    return matrix_w_output;
  end function function_model_addressing;

  ------------------------------------------------------------------------------
  -- TOP - INTERFACE
  ------------------------------------------------------------------------------

  function function_model_interface_vector (
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_u_input : matrix_buffer;

    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable vector_xi_output : vector_buffer;

  begin

    -- xi(t;s) = U(s;l)·h(t;l)

    vector_xi_output := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_S_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    return vector_xi_output;
  end function function_model_interface_vector;

  function function_model_interface_matrix (
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_u_input : tensor_buffer;

    vector_h_input : vector_buffer
    ) return matrix_buffer is

    variable matrix_h_int : matrix_buffer;

    variable matrix_rho_output : matrix_buffer;

  begin

    -- rho(t;i;m) = U(i;m;l)·h(t;i;l)

    for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        matrix_h_int(i, l) := vector_h_input(l);
      end loop;
    end loop;

    matrix_rho_output := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_M_IN,
      SIZE_A_K_IN => SIZE_L_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_L_IN,

      tensor_a_input => tensor_u_input,
      matrix_b_input => matrix_h_int
      );

    return matrix_rho_output;
  end function function_model_interface_matrix;

  ------------------------------------------------------------------------------
  -- TOP - OUTPUT
  ------------------------------------------------------------------------------

  function function_model_output_vector (
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_p_input : tensor_buffer;
    matrix_r_input : matrix_buffer;

    matrix_q_input : matrix_buffer;
    vector_h_input : vector_buffer
    ) return vector_buffer is

    variable data_summation_int : matrix_buffer;
    variable data_product_int   : vector_buffer;
    variable data_addition_int  : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)

    data_product_int  := (others => ZERO_DATA);
    data_addition_int := (others => ZERO_DATA);

    vector_y_output := (others => ZERO_DATA);

    data_summation_int := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_Y_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_Y_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_p_input,
      matrix_b_input => matrix_r_input
      );

    data_addition_int := function_vector_summation (
      SIZE_IN   => SIZE_R_IN,
      LENGTH_IN => SIZE_Y_IN,

      vector_input => data_summation_int
      );

    data_product_int := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_Y_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_q_input,
      vector_b_input => vector_h_input
      );

    vector_y_output := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_Y_IN,

      vector_a_input => data_addition_int,
      vector_b_input => data_product_int
      );

    return vector_y_output;
  end function function_model_output_vector;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

  function function_model_top (
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
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer;

    tensor_p_input : tensor_buffer;
    matrix_q_input : matrix_buffer
    ) return vector_buffer is

    -- Internal Variable
    variable matrix_m_int : matrix_buffer;

    variable matrix_r_int : matrix_buffer;

    variable matrix_w_int : matrix_buffer;

    variable vector_xi_int  : vector_buffer;
    variable matrix_rho_int : matrix_buffer;

    variable vector_a_int : vector_buffer;
    variable vector_e_int : vector_buffer;
    variable vector_h_int : vector_buffer;

    variable matrix_k_int     : matrix_buffer;
    variable vector_beta_int  : vector_buffer;
    variable vector_g_int     : vector_buffer;
    variable matrix_s_int     : matrix_buffer;
    variable vector_gamma_int : vector_buffer;

    variable SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    variable SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    -- Output Variable
    variable vector_y_output : vector_buffer;

  begin

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      if (t = 0) then
        vector_h_int := (others => ZERO_DATA);

        matrix_m_int := (others => (others => ZERO_DATA));

        matrix_w_int := (others => (others => ZERO_DATA));
      else
        -- ARITHMETIC S: [XI] = 2·W
        SIZE_S_IN := function_scalar_integer_multiplier (
          scalar_a_input => TWO_CONTROL,
          scalar_b_input => SIZE_W_IN
          );

        -- ARITHMETIC M: [RHO] = N + W + 3
        SIZE_M_IN := function_scalar_integer_adder (
          OPERATION => '0',

          scalar_a_input => SIZE_N_IN,
          scalar_b_input => SIZE_W_IN
          );

        SIZE_M_IN := function_scalar_integer_adder (
          OPERATION => '0',

          scalar_a_input => SIZE_M_IN,
          scalar_b_input => THREE_CONTROL
          );

        -- INTERFACE_VECTOR_STATE

        -- xi(t;s) = U(s;l)·h(t;l)
        vector_xi_int := function_model_interface_vector (
          SIZE_S_IN => SIZE_S_IN,
          SIZE_L_IN => SIZE_L_IN,

          matrix_u_input => matrix_v_input,

          vector_h_input => vector_h_int
          );

        vector_e_int := vector_xi_int(to_integer(unsigned(SIZE_N_IN)) + 3*to_integer(unsigned(SIZE_W_IN)) + 2 downto to_integer(unsigned(SIZE_N_IN)) + 2*to_integer(unsigned(SIZE_W_IN)) + 3);
        vector_a_int := vector_xi_int(to_integer(unsigned(SIZE_N_IN)) + 2*to_integer(unsigned(SIZE_W_IN)) + 2 downto to_integer(unsigned(SIZE_N_IN)) + to_integer(unsigned(SIZE_W_IN)) + 3);

        -- INTERFACE_MATRIX_STATE

        -- rho(t;i;m) = U(i;m;l)·h(t;i;l)
        matrix_rho_int := function_model_interface_matrix (
          SIZE_M_IN => SIZE_S_IN,
          SIZE_R_IN => SIZE_R_IN,
          SIZE_L_IN => SIZE_L_IN,

          tensor_u_input => tensor_d_input,

          vector_h_input => vector_h_int
          );

        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for j in to_integer(unsigned(SIZE_N_IN)) + 3 to to_integer(unsigned(SIZE_N_IN)) + to_integer(unsigned(SIZE_W_IN)) + 2 loop
            matrix_k_int(i, j) := matrix_rho_int(i, j);
          end loop;

          vector_beta_int(i) := matrix_rho_int(i, to_integer(unsigned(SIZE_N_IN)) + 2);
          vector_g_int(i)    := matrix_rho_int(i, to_integer(unsigned(SIZE_N_IN)) + 1);

          for j in 1 to to_integer(unsigned(SIZE_N_IN)) loop
            matrix_s_int(i, j) := matrix_rho_int(i, j);
          end loop;

          vector_gamma_int(i) := matrix_rho_int(i, 0);
        end loop;

        -- WRITE_HEADS_STATE

        -- M(t;j;k) = M(t;j;k)·(1 - w(t;i;j)·e(t;k))
        matrix_m_int := function_model_erasing (
          SIZE_R_IN => SIZE_R_IN,
          SIZE_N_IN => SIZE_N_IN,
          SIZE_W_IN => SIZE_W_IN,

          matrix_m_input => matrix_m_int,
          vector_e_input => vector_e_int,
          matrix_w_input => matrix_w_int
          );

        -- M(t;j;k) = M(t;j;k) + w(t;i;j)·a(t;k)
        matrix_m_int := function_model_writing (
          SIZE_R_IN => SIZE_R_IN,
          SIZE_N_IN => SIZE_N_IN,
          SIZE_W_IN => SIZE_W_IN,

          matrix_m_input => matrix_m_int,
          vector_a_input => vector_a_int,
          matrix_w_input => matrix_w_int
          );

        -- READ_HEADS_STATE

        -- r(t;i;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]
        matrix_r_int := function_model_reading (
          SIZE_R_IN => SIZE_R_IN,
          SIZE_N_IN => SIZE_N_IN,
          SIZE_W_IN => SIZE_W_IN,

          matrix_w_input => matrix_w_int,
          matrix_m_input => matrix_m_int
          );

        -- MEMORY_STATE

        -- wc(t;i;j) = C(M(t;j;k),k(t;i;k),beta(t;i))
        -- wg(t;i;j) = g(t;i)·wc(t;i;j) + (1 - g(t;i))·w(t-1;i;j)
        -- w(t;i;j) = wg(t;i;j)*s(t;i;j)
        -- w(t;i;j) = exponentiation(w(t;i;j),gamma(t;i)) / summation(exponentiation(w(t;i;j),gamma(t;i)))[j in 0 to N-1]

        matrix_w_int := function_model_addressing (
          SIZE_R_IN => SIZE_R_IN,
          SIZE_N_IN => SIZE_N_IN,
          SIZE_W_IN => SIZE_W_IN,

          matrix_k_input     => matrix_k_int,
          vector_beta_input  => vector_beta_int,
          vector_g_input     => vector_g_int,
          matrix_s_input     => matrix_s_int,
          vector_gamma_input => vector_gamma_int,

          matrix_m_input => matrix_m_int,

          matrix_w_input => matrix_w_int
          );

        -- CONTROLLER_BODY_STATE

        -- FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
        -- FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

        vector_h_int := function_model_fnn_standard_controller (
          SIZE_X_IN => SIZE_X_IN,
          SIZE_W_IN => SIZE_W_IN,
          SIZE_L_IN => SIZE_L_IN,
          SIZE_R_IN => SIZE_R_IN,
          SIZE_S_IN => SIZE_S_IN,
          SIZE_M_IN => SIZE_M_IN,

          matrix_w_input => matrix_w_input,
          tensor_k_input => tensor_k_input,
          matrix_u_input => matrix_u_input,
          matrix_v_input => matrix_v_input,
          tensor_d_input => tensor_d_input,
          vector_b_input => vector_b_input,

          vector_x_input   => vector_x_input,
          matrix_r_input   => matrix_r_int,
          vector_xi_input  => vector_xi_int,
          matrix_rho_input => matrix_rho_int,
          vector_h_input   => vector_h_int
          );

        -- OUTPUT_VECTOR_STATE

        -- y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)
        vector_y_output := function_model_output_vector (
          SIZE_Y_IN => SIZE_Y_IN,
          SIZE_L_IN => SIZE_L_IN,
          SIZE_W_IN => SIZE_W_IN,
          SIZE_R_IN => SIZE_R_IN,

          tensor_p_input => tensor_p_input,
          matrix_r_input => matrix_r_int,

          matrix_q_input => matrix_q_input,
          vector_h_input => vector_h_int
          );

        return vector_y_output;
      end if;
    end loop;
  end function function_model_top;

end model_ntm_core_pkg;
