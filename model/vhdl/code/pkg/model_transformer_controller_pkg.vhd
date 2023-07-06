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

package model_transformer_controller_pkg is

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- COMPOMENTS
  ------------------------------------------------------------------------------

  component model_masked_multi_head_attention is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      Q_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      Q_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      V_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      M_IN_M_ENABLE : in std_logic;     -- for n in 0 to N-1
      M_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1

      W_OH_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      W_OH_IN_D_ENABLE : in std_logic;  -- for d in 0 to D-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      Y_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      Y_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_H_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_masked_scaled_dot_product_attention is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      Q_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      Q_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      V_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      M_IN_M_ENABLE : in std_logic;     -- for n in 0 to N-1
      M_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      U_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      U_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_multi_head_attention is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      Q_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      Q_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      V_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      W_OH_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      W_OH_IN_D_ENABLE : in std_logic;  -- for d in 0 to D-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      Y_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      Y_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_H_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_scaled_dot_product_attention is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      Q_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      Q_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      V_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      U_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      U_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- INPUTS
  ------------------------------------------------------------------------------

  component model_inputs_vector is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      W_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      W_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      K_IN_R_ENABLE : in std_logic;     -- for r in 0 to R-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_W_ENABLE : in std_logic;     -- for w in 0 to W-1

      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      D_IN_R_ENABLE : in std_logic;     -- for r in 0 to R-1
      D_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      D_IN_P_ENABLE : in std_logic;     -- for p in 0 to P-1

      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      R_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      R_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      R_IN_R_ENABLE : in std_logic;     -- for r in 0 to R-1
      R_IN_W_ENABLE : in std_logic;     -- for w in 0 to W-1

      XI_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      XI_IN_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      XI_IN_S_ENABLE : in std_logic;    -- for s in 0 to S-1

      RHO_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1
      RHO_IN_N_ENABLE : in std_logic;   -- for n in 0 to N-1
      RHO_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      RHO_IN_P_ENABLE : in std_logic;   -- for p in 0 to P-1

      X_OUT_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      X_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      X_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_Q_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_P_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_keys_vector is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      K_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      K_OUT_K_ENABLE : in std_logic;    -- for k in 0 to K-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_queries_vector is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      Q_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      K_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      K_OUT_K_ENABLE : in std_logic;    -- for k in 0 to K-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_values_vector is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_V_ENABLE : in std_logic;     -- for v in 0 to V-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      V_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      V_OUT_V_ENABLE : in std_logic;    -- for v in 0 to V-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- FUNCTIONS
  ------------------------------------------------------------------------------

  component model_layer_norm is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      Z_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      Z_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      GAMMA_IN_N_ENABLE : in std_logic;  -- for n in 0 to N-1
      GAMMA_IN_D_ENABLE : in std_logic;  -- for d in 0 to D-1

      BETA_IN_N_ENABLE : in std_logic;  -- for n in 0 to N-1
      BETA_IN_D_ENABLE : in std_logic;  -- for d in 0 to D-1

      N_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      N_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      Z_IN     : in std_logic_vector(DATA_SIZE-1 downto 0);
      GAMMA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      BETA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);

      N_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_positional_encoding is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      PE_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      PE_IN_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      PE_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      Y_OUT_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      Y_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      Y_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      PE_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- FNN
  ------------------------------------------------------------------------------

  component model_fnn is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      W1_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1
      W1_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      B1_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1

      W2_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1
      W2_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1

      B2_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      Y_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      W2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      X_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- LSTM
  ------------------------------------------------------------------------------

  component model_activation_gate_vector is
    generic (
      DATA_SIZE    : integer := 64;
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

      D_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      D_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_ENABLE : in std_logic;      -- for s in 0 to S-1

      XI_OUT_ENABLE : out std_logic;    -- for s in 0 to S-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      A_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

      A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_activation_trainer is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to X-1
      X_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to X-1
      X_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      R_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_T_ENABLE : in std_logic;   -- for t in 0 to T-1
      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_T_ENABLE : in std_logic;    -- for t in 0 to T-1
      XI_IN_S_ENABLE : in std_logic;    -- for s in 0 to S-1

      XI_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      XI_OUT_S_ENABLE : out std_logic;  -- for s in 0 to S-1

      H_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      H_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      H_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      H_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      A_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      A_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      A_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      A_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      I_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      I_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      I_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      I_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      S_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      S_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      S_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      S_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_M_ENABLE : out std_logic;   -- for s in 0 to M-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_input_gate_vector is
    generic (
      DATA_SIZE    : integer := 64;
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

      D_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      D_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_ENABLE : in std_logic;      -- for s in 0 to S-1

      XI_OUT_ENABLE : out std_logic;    -- for s in 0 to S-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      I_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

      I_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_input_trainer is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to X-1
      X_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to X-1
      X_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      R_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_T_ENABLE : in std_logic;   -- for t in 0 to T-1
      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_T_ENABLE : in std_logic;    -- for t in 0 to T-1
      XI_IN_S_ENABLE : in std_logic;    -- for s in 0 to S-1

      XI_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      XI_OUT_S_ENABLE : out std_logic;  -- for s in 0 to S-1

      H_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      H_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      H_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      H_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      A_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      A_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      A_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      A_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      I_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      I_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      I_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      I_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      S_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      S_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      S_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      S_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_M_ENABLE : out std_logic;   -- for s in 0 to M-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_output_gate_vector is
    generic (
      DATA_SIZE    : integer := 64;
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

      D_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      D_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_ENABLE : in std_logic;      -- for s in 0 to S-1

      XI_OUT_ENABLE : out std_logic;    -- for s in 0 to S-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      O_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

      O_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_output_trainer is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to X-1
      X_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to X-1
      X_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      R_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_T_ENABLE : in std_logic;   -- for t in 0 to T-1
      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_T_ENABLE : in std_logic;    -- for t in 0 to T-1
      XI_IN_S_ENABLE : in std_logic;    -- for s in 0 to S-1

      XI_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      XI_OUT_S_ENABLE : out std_logic;  -- for s in 0 to S-1

      H_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      H_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      H_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      H_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      A_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      A_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      A_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      A_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      O_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      O_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      O_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      O_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_M_ENABLE : out std_logic;   -- for s in 0 to M-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_forget_gate_vector is
    generic (
      DATA_SIZE    : integer := 64;
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

      D_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      D_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_ENABLE : in std_logic;      -- for s in 0 to S-1

      XI_OUT_ENABLE : out std_logic;    -- for s in 0 to S-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      F_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

      F_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_forget_trainer is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to X-1
      X_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to X-1
      X_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      R_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_T_ENABLE : in std_logic;   -- for t in 0 to T-1
      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_T_ENABLE : in std_logic;    -- for t in 0 to T-1
      XI_IN_S_ENABLE : in std_logic;    -- for s in 0 to S-1

      XI_OUT_T_ENABLE : out std_logic;  -- for t in 0 to T-1
      XI_OUT_S_ENABLE : out std_logic;  -- for s in 0 to S-1

      H_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      H_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      H_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      H_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      F_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      F_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      F_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      F_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      S_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      S_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      S_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      S_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      K_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      K_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      K_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_M_ENABLE : out std_logic;   -- for s in 0 to M-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_state_gate_vector is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      I_IN_ENABLE : in std_logic;       -- for l in 0 to L-1
      F_IN_ENABLE : in std_logic;       -- for l in 0 to L-1
      A_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      I_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1
      F_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1
      A_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      S_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      S_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      I_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      S_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_hidden_gate_vector is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      S_IN_ENABLE : in std_logic;       -- for l in 0 to L-1
      O_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      S_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1
      O_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      S_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      O_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_lstm is
    generic (
      DATA_SIZE    : integer := 64;
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

      D_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      D_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      D_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      U_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      U_IN_P_ENABLE : in std_logic;     -- for p in 0 to L-1

      U_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;   -- for p in 0 to L-1

      V_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      V_IN_S_ENABLE : in std_logic;     -- for s in 0 to S-1

      V_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;   -- for s in 0 to S-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;     -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;   -- for k in 0 to W-1

      RHO_IN_I_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;   -- for m in 0 to M-1

      RHO_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;  -- for m in 0 to M-1

      XI_IN_ENABLE : in std_logic;      -- for s in 0 to S-1

      XI_OUT_ENABLE : out std_logic;    -- for s in 0 to S-1

      H_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      R_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
      RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      XI_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);

      H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

  component model_controller is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      W_I_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      W_I_IN_X_ENABLE : in std_logic;   -- for x in 0 to X-1

      K_I_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      K_I_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      K_I_IN_W_ENABLE : in std_logic;   -- for w in 0 to W-1

      V_I_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      V_I_IN_S_ENABLE : in std_logic;   -- for s in 0 to S-1

      D_I_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      D_I_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      D_I_IN_P_ENABLE : in std_logic;   -- for p in 0 to P-1

      X_I_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1
      X_I_IN_N_ENABLE : in std_logic;   -- for n in 0 to N-1
      X_I_IN_X_ENABLE : in std_logic;   -- for x in 0 to X-1

      R_I_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1
      R_I_IN_N_ENABLE : in std_logic;   -- for n in 0 to N-1
      R_I_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      R_I_IN_W_ENABLE : in std_logic;   -- for w in 0 to W-1

      XI_I_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      XI_I_IN_N_ENABLE : in std_logic;  -- for n in 0 to N-1
      XI_I_IN_S_ENABLE : in std_logic;  -- for s in 0 to S-1

      RHO_I_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      RHO_I_IN_N_ENABLE : in std_logic;  -- for n in 0 to N-1
      RHO_I_IN_R_ENABLE : in std_logic;  -- for r in 0 to R-1
      RHO_I_IN_P_ENABLE : in std_logic;  -- for p in 0 to P-1

      W_O_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      W_O_IN_X_ENABLE : in std_logic;   -- for x in 0 to X-1

      K_O_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      K_O_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      K_O_IN_W_ENABLE : in std_logic;   -- for w in 0 to W-1

      V_O_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      V_O_IN_S_ENABLE : in std_logic;   -- for s in 0 to S-1

      D_O_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      D_O_IN_D_ENABLE : in std_logic;   -- for d in 0 to D-1
      D_O_IN_P_ENABLE : in std_logic;   -- for p in 0 to P-1

      X_O_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1
      X_O_IN_N_ENABLE : in std_logic;   -- for n in 0 to N-1
      X_O_IN_X_ENABLE : in std_logic;   -- for x in 0 to X-1

      R_O_IN_L_ENABLE : in std_logic;   -- for l in 0 to L-1
      R_O_IN_N_ENABLE : in std_logic;   -- for n in 0 to N-1
      R_O_IN_R_ENABLE : in std_logic;   -- for r in 0 to R-1
      R_O_IN_W_ENABLE : in std_logic;   -- for w in 0 to W-1

      XI_O_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      XI_O_IN_N_ENABLE : in std_logic;  -- for n in 0 to N-1
      XI_O_IN_S_ENABLE : in std_logic;  -- for s in 0 to S-1

      RHO_O_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      RHO_O_IN_N_ENABLE : in std_logic;  -- for n in 0 to N-1
      RHO_O_IN_R_ENABLE : in std_logic;  -- for r in 0 to R-1
      RHO_O_IN_P_ENABLE : in std_logic;  -- for p in 0 to P-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_H_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Z_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Z_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_decoder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      Q_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      Q_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      V_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      W_OH_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      W_OH_IN_D_ENABLE : in std_logic;  -- for d in 0 to D-1

      W1_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1
      W1_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      B1_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1

      W2_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1
      W2_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1

      B2_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      X_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      X_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      Z_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      Z_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
      Z_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1

      Z_OUT_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      Z_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      Z_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_H_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B1_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B2_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      Z_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Z_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_encoder is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 64
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      K_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      K_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      K_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      Q_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      Q_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      Q_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      V_IN_H_ENABLE : in std_logic;     -- for h in 0 to H-1
      V_IN_D_ENABLE : in std_logic;     -- for d in 0 to D-1
      V_IN_K_ENABLE : in std_logic;     -- for k in 0 to K-1

      W_OH_IN_L_ENABLE : in std_logic;  -- for l in 0 to L-1
      W_OH_IN_D_ENABLE : in std_logic;  -- for d in 0 to D-1

      W1_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1
      W1_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      B1_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1

      W2_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1
      W2_IN_M_ENABLE : in std_logic;    -- for m in 0 to M-1

      B2_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      PE_IN_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      PE_IN_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      PE_IN_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      Z_OUT_L_ENABLE : in std_logic;    -- for l in 0 to L-1
      Z_OUT_N_ENABLE : in std_logic;    -- for n in 0 to N-1
      Z_OUT_D_ENABLE : in std_logic;    -- for d in 0 to D-1

      -- DATA
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_D_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_H_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_P_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      Q_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      V_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_OH_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W1_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      B1_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W2_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      B2_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      K_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      V_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_I_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      R_I_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      XI_I_IN  : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      RHO_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_O_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      K_O_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      V_O_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      D_O_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_O_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      R_O_IN   : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      XI_O_IN  : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      RHO_O_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      PE_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      Z_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- COMPOMENTS
  ------------------------------------------------------------------------------

  function function_model_masked_multi_head_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_m_input : matrix_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

  function function_model_masked_scaled_dot_product_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input : matrix_buffer;
    matrix_q_input : matrix_buffer;
    matrix_v_input : matrix_buffer;

    matrix_m_input : matrix_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

  function function_model_multi_head_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

  function function_model_scaled_dot_product_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- INPUTS
  ------------------------------------------------------------------------------

  function function_model_keys_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    matrix_k_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    matrix_d_input : matrix_buffer;
    matrix_x_input : matrix_buffer;
    tensor_r_input : tensor_buffer;
    matrix_xi_input : matrix_buffer;
    tensor_rho_input : tensor_buffer;
    ) return tensor_buffer;

  function function_model_queries_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_x_input : matrix_buffer;
    matrix_q_input : matrix_buffer;
    ) return matrix_buffer;

  function function_model_values_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_x_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- FUNCTIONS
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- FNN
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_fnn_convolutional_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_fnn_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- LSTM
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_activation_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_input_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_output_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_forget_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_state_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_i_input : vector_buffer;
    vector_f_input : vector_buffer;
    vector_a_input : vector_buffer
    ) return vector_buffer;

  function function_model_hidden_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_o_input : vector_buffer
    ) return vector_buffer;

  function function_model_lstm_convolutional_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_activation_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_input_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_output_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_forget_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  function function_model_state_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_i_input : vector_buffer;
    vector_f_input : vector_buffer;
    vector_a_input : vector_buffer
    ) return vector_buffer;

  function function_model_hidden_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_o_input : vector_buffer
    ) return vector_buffer;

  function function_model_lstm_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

end model_transformer_controller_pkg;

package body model_transformer_controller_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- COMPOMENTS
  ------------------------------------------------------------------------------

  function function_model_masked_multi_head_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_m_input : matrix_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

    variable matrix_y_output : matrix_buffer;

  begin

    return matrix_y_output;
  end function function_model_masked_multi_head_attention;

  function function_model_masked_scaled_dot_product_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input : matrix_buffer;
    matrix_q_input : matrix_buffer;
    matrix_v_input : matrix_buffer;

    matrix_m_input : matrix_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    return matrix_u_output;
  end function function_model_masked_scaled_dot_product_attention;

  function function_model_multi_head_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

    variable matrix_y_output : matrix_buffer;

  begin

    return matrix_y_output;
  end function function_model_multi_head_attention;

  function function_model_scaled_dot_product_attention (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_x_input : matrix_buffer;
    ) return matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    return matrix_u_output;
  end function function_model_scaled_dot_product_attention;

  ------------------------------------------------------------------------------
  -- INPUTS
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- FUNCTIONS
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- FNN
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_fnn_convolutional_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_convolution : matrix_buffer;
    variable matrix_convolution : vector_buffer;
    variable vector_adder       : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

    -- K(i;l;k)*r(t;i;k)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- W(l;x)*x(t;x)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- V(l;s)*xi(t;s)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- D(i;l;m)*rho(t;i;m)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- U(l;l)*h(t-1;l)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- logistic(h(t;l))
    vector_h_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_h_output;
  end function function_model_fnn_convolutional_controller;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_fnn_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_product : matrix_buffer;
    variable matrix_product : vector_buffer;
    variable vector_adder   : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

    -- K(i;l;k)·r(t;i;k)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- W(l;x)·x(t;x)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- V(l;s)·xi(t;s)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- D(i;l;m)·rho(t;i;m)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- U(l;l)·h(t-1;l)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- logistic(h(t;l))
    vector_h_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_h_output;
  end function function_model_fnn_standard_controller;

  ------------------------------------------------------------------------------
  -- LSTM
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_activation_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_convolution : matrix_buffer;
    variable matrix_convolution : vector_buffer;
    variable vector_adder       : vector_buffer;

    variable vector_a_output : vector_buffer;

  begin

    -- a(t;l) = tanh(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

    -- K(i;l;k)*r(t;i;k)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- W(l;x)*x(t;x)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- V(l;s)*xi(t;s)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- D(i;l;m)*rho(t;i;m)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- U(l;l)*h(t-1;l)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- tanh(i(t;l))
    vector_a_output := function_vector_tanh (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_a_output;
  end function function_model_activation_convolutional_gate_vector;

  function function_model_input_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_convolution : matrix_buffer;
    variable matrix_convolution : vector_buffer;
    variable vector_adder       : vector_buffer;

    variable vector_i_output : vector_buffer;

  begin

    -- i(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

    -- K(i;l;k)*r(t;i;k)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- W(l;x)*x(t;x)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- V(l;s)*xi(t;s)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- D(i;l;m)*rho(t;i;m)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- U(l;l)*h(t-1;l)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- logistic(i(t;l))
    vector_i_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_i_output;
  end function function_model_input_convolutional_gate_vector;

  function function_model_output_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_convolution : matrix_buffer;
    variable matrix_convolution : vector_buffer;
    variable vector_adder       : vector_buffer;

    variable vector_o_output : vector_buffer;

  begin

    -- o(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

    -- K(i;l;k)*r(t;i;k)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- W(l;x)*x(t;x)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- V(l;s)*xi(t;s)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- D(i;l;m)*rho(t;i;m)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- U(l;l)*h(t-1;l)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- logistic(o(t;l))
    vector_o_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_o_output;
  end function function_model_output_convolutional_gate_vector;

  function function_model_forget_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_convolution : matrix_buffer;
    variable matrix_convolution : vector_buffer;
    variable vector_adder       : vector_buffer;

    variable vector_f_output : vector_buffer;

  begin

    -- f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))

    -- K(i;l;k)*r(t;i;k)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- W(l;x)*x(t;x)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- V(l;s)*xi(t;s)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- D(i;l;m)*rho(t;i;m)
    tensor_convolution := function_tensor_matrix_convolution (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_convolution
      );

    -- U(l;l)*h(t-1;l)
    matrix_convolution := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_convolution
      );

    -- logistic(f(t;l))
    vector_f_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_f_output;
  end function function_model_forget_convolutional_gate_vector;

  function function_model_state_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_i_input : vector_buffer;
    vector_f_input : vector_buffer;
    vector_a_input : vector_buffer
    ) return vector_buffer is

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_s_output : vector_buffer;

  begin

    -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)

    -- s(t=0;l) = 0

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_first_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_f_input(l),
        scalar_b_input => vector_s_input(l)
        );

      scalar_second_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_i_input(l),
        scalar_b_input => vector_a_input(l)
        );

      vector_s_output(l) := function_scalar_float_adder (
        OPERATION => '1',

        scalar_a_input => scalar_first_operation_int,
        scalar_b_input => scalar_second_operation_int
        );
    end loop;

    return vector_s_output;
  end function function_model_state_convolutional_gate_vector;

  function function_model_hidden_convolutional_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_o_input : vector_buffer
    ) return vector_buffer is

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = o(t;l) o tanh(s(t;l))

    -- h(t=0;l) = 0; h(t;l=0) = 0
    vector_h_output := function_vector_tanh (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_s_input
      );

    vector_h_output := function_vector_float_multiplier (
      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_o_input,
      vector_b_input => vector_h_output
      );

    return vector_h_output;
  end function function_model_hidden_convolutional_gate_vector;

  function function_model_lstm_convolutional_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable vector_a_int : vector_buffer;
    variable vector_f_int : vector_buffer;
    variable vector_i_int : vector_buffer;
    variable vector_o_int : vector_buffer;

    variable vector_s_in_int  : vector_buffer;
    variable vector_s_out_int : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- VECTOR_ACTIVATION_STATE

    -- a(t;l) = tanh(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
    vector_a_int := function_model_activation_convolutional_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_FORGET_STATE

    -- f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
    vector_f_int := function_model_forget_convolutional_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_INPUT_STATE

    -- i(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
    vector_i_int := function_model_input_convolutional_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_STATE_STATE

    -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)
    -- s(t=0;l) = 0
    vector_s_out_int := function_model_state_convolutional_gate_vector (
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_S_IN => SIZE_S_IN,
      SIZE_M_IN => SIZE_M_IN,

      vector_s_input => vector_s_in_int,
      vector_i_input => vector_i_int,
      vector_f_input => vector_f_int,
      vector_a_input => vector_a_int
      );

    -- VECTOR_OUTPUT_GATE

    -- o(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
    vector_o_int := function_model_output_convolutional_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_HIDDEN_GATE

    -- h(t;l) = o(t;l) o tanh(s(t;l))
    -- h(t=0;l) = 0; h(t;l=0) = 0
    vector_h_output := function_model_hidden_convolutional_gate_vector (
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_S_IN => SIZE_S_IN,
      SIZE_M_IN => SIZE_M_IN,

      vector_s_input => vector_s_out_int,
      vector_o_input => vector_o_int
      );

    return vector_h_output;
  end function function_model_lstm_convolutional_controller;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_activation_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_product : matrix_buffer;
    variable matrix_product : vector_buffer;
    variable vector_adder   : vector_buffer;

    variable vector_a_output : vector_buffer;

  begin

    -- a(t;l) = tanh(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

    -- K(i;l;k)·r(t;i;k)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- W(l;x)·x(t;x)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- V(l;s)·xi(t;s)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- D(i;l;m)·rho(t;i;m)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- U(l;l)·h(t-1;l)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- tanh(i(t;l))
    vector_a_output := function_vector_tanh (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_a_output;
  end function function_model_activation_standard_gate_vector;

  function function_model_input_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_product : matrix_buffer;
    variable matrix_product : vector_buffer;
    variable vector_adder   : vector_buffer;

    variable vector_i_output : vector_buffer;

  begin

    -- i(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

    -- K(i;l;k)·r(t;i;k)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- W(l;x)·x(t;x)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- V(l;s)·xi(t;s)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- D(i;l;m)·rho(t;i;m)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- U(l;l)·h(t-1;l)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- logistic(i(t;l))
    vector_i_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_i_output;
  end function function_model_input_standard_gate_vector;

  function function_model_output_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_product : matrix_buffer;
    variable matrix_product : vector_buffer;
    variable vector_adder   : vector_buffer;

    variable vector_o_output : vector_buffer;

  begin

    -- o(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

    -- K(i;l;k)·r(t;i;k)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- W(l;x)·x(t;x)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- V(l;s)·xi(t;s)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- D(i;l;m)·rho(t;i;m)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- U(l;l)·h(t-1;l)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- logistic(o(t;l))
    vector_o_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_o_output;
  end function function_model_output_standard_gate_vector;

  function function_model_forget_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable tensor_product : matrix_buffer;
    variable matrix_product : vector_buffer;
    variable vector_adder   : vector_buffer;

    variable vector_f_output : vector_buffer;

  begin

    -- f(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))

    -- K(i;l;k)·r(t;i;k)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_W_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_W_IN,

      tensor_a_input => tensor_k_input,
      matrix_b_input => matrix_r_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- W(l;x)·x(t;x)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- V(l;s)·xi(t;s)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_S_IN,
      SIZE_B_IN   => SIZE_S_IN,

      matrix_a_input => matrix_v_input,
      vector_b_input => vector_xi_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- D(i;l;m)·rho(t;i;m)
    tensor_product := function_tensor_matrix_product (
      SIZE_A_I_IN => SIZE_R_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_A_K_IN => SIZE_M_IN,
      SIZE_B_I_IN => SIZE_R_IN,
      SIZE_B_J_IN => SIZE_M_IN,

      tensor_a_input => tensor_d_input,
      matrix_b_input => matrix_rho_input
      );

    vector_adder := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_R_IN,

      vector_input => tensor_product
      );

    -- U(l;l)·h(t-1;l)
    matrix_product := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_L_IN,
      SIZE_B_IN   => SIZE_L_IN,

      matrix_a_input => matrix_u_input,
      vector_b_input => vector_h_input
      );

    vector_adder := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_adder,
      vector_b_input => matrix_product
      );

    -- logistic(f(t;l))
    vector_f_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_adder
      );

    return vector_f_output;
  end function function_model_forget_standard_gate_vector;

  function function_model_state_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_i_input : vector_buffer;
    vector_f_input : vector_buffer;
    vector_a_input : vector_buffer
    ) return vector_buffer is

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_s_output : vector_buffer;

  begin

    -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)

    -- s(t=0;l) = 0

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      scalar_first_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_f_input(l),
        scalar_b_input => vector_s_input(l)
        );

      scalar_second_operation_int := function_scalar_float_multiplier (
        scalar_a_input => vector_i_input(l),
        scalar_b_input => vector_a_input(l)
        );

      vector_s_output(l) := function_scalar_float_adder (
        OPERATION => '1',

        scalar_a_input => scalar_first_operation_int,
        scalar_b_input => scalar_second_operation_int
        );
    end loop;

    return vector_s_output;
  end function function_model_state_standard_gate_vector;

  function function_model_hidden_standard_gate_vector (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_s_input : vector_buffer;
    vector_o_input : vector_buffer
    ) return vector_buffer is

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = o(t;l) o tanh(s(t;l))

    -- h(t=0;l) = 0; h(t;l=0) = 0
    vector_h_output := function_vector_tanh (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_s_input
      );

    vector_h_output := function_vector_float_multiplier (
      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_o_input,
      vector_b_input => vector_h_output
      );

    return vector_h_output;
  end function function_model_hidden_standard_gate_vector;

  function function_model_lstm_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_u_input : matrix_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;
    vector_b_input : vector_buffer;

    vector_x_input   : vector_buffer;
    matrix_r_input   : matrix_buffer;
    vector_xi_input  : vector_buffer;
    matrix_rho_input : matrix_buffer;
    vector_h_input   : vector_buffer
    ) return vector_buffer is

    variable vector_a_int : vector_buffer;
    variable vector_f_int : vector_buffer;
    variable vector_i_int : vector_buffer;
    variable vector_o_int : vector_buffer;

    variable vector_s_in_int  : vector_buffer;
    variable vector_s_out_int : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- VECTOR_ACTIVATION_STATE

    -- a(t;l) = tanh(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))
    vector_a_int := function_model_activation_standard_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_FORGET_STATE

    -- f(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))
    vector_f_int := function_model_forget_standard_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_INPUT_STATE

    -- i(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))
    vector_i_int := function_model_input_standard_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_STATE_STATE

    -- s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)
    -- s(t=0;l) = 0
    vector_s_out_int := function_model_state_standard_gate_vector (
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_S_IN => SIZE_S_IN,
      SIZE_M_IN => SIZE_M_IN,

      vector_s_input => vector_s_in_int,
      vector_i_input => vector_i_int,
      vector_f_input => vector_f_int,
      vector_a_input => vector_a_int
      );

    -- VECTOR_OUTPUT_GATE

    -- o(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(l))
    vector_o_int := function_model_output_standard_gate_vector (
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
      matrix_r_input   => matrix_r_input,
      vector_xi_input  => vector_xi_input,
      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input
      );

    -- VECTOR_HIDDEN_GATE

    -- h(t;l) = o(t;l) o tanh(s(t;l))
    -- h(t=0;l) = 0; h(t;l=0) = 0
    vector_h_output := function_model_hidden_standard_gate_vector (
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_S_IN => SIZE_S_IN,
      SIZE_M_IN => SIZE_M_IN,

      vector_s_input => vector_s_out_int,
      vector_o_input => vector_o_int
      );

    return vector_h_output;
  end function function_model_lstm_standard_controller;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

end model_transformer_controller_pkg;
