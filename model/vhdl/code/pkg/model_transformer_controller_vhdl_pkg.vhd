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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;

package model_transformer_controller_vhdl_pkg is

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- COMPOMENTS
  ------------------------------------------------------------------------------

  component model_masked_multi_head_attention is
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
  -- CONTROLLER
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- FNN
  ------------------------------------------------------------------------------

  component accelerator_fnn is
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

  component accelerator_lstm is
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
  -- TOP
  ------------------------------------------------------------------------------

  component model_controller is
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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

  component model_trainer_vector_differentiation is
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

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      X_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      Y_OUT_T_ENABLE : out std_logic;   -- for l in 0 to T-1
      Y_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      LENGTH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_trainer_matrix_differentiation is
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

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      X_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      X_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      X_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      Y_OUT_T_ENABLE : out std_logic;   -- for l in 0 to T-1
      Y_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      Y_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      LENGTH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
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

    matrix_x_input : matrix_buffer
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

    matrix_x_input : matrix_buffer
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

    matrix_x_input : matrix_buffer
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

    matrix_x_input : matrix_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- INPUTS
  ------------------------------------------------------------------------------

  function function_model_inputs_vector (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_P_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;

    tensor_x_input   : tensor_buffer;
    array4_r_input   : array4_buffer;
    tensor_xi_input  : tensor_buffer;
    array4_rho_input : array4_buffer
    ) return tensor_buffer;

  function function_model_keys_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input : matrix_buffer;
    matrix_x_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_queries_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_x_input : matrix_buffer;
    matrix_q_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_values_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_x_input : matrix_buffer;
    matrix_v_input : matrix_buffer
    ) return matrix_buffer;

  ------------------------------------------------------------------------------
  -- FUNCTIONS
  ------------------------------------------------------------------------------

  function function_model_layer_norm (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_z_input     : matrix_buffer;
    matrix_gamma_input : matrix_buffer;
    matrix_beta_input  : matrix_buffer
    ) return matrix_buffer;

  function function_model_positional_encoding (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_x_input  : tensor_buffer;
    tensor_pe_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- FNN
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_fnn_convolutional_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_fnn_standard_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- LSTM
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_lstm_convolutional_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_lstm_standard_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

  function function_model_decoder (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    tensor_x_input : tensor_buffer;
    tensor_z_input : tensor_buffer
    ) return tensor_buffer;

  function function_model_encoder (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    tensor_x_input : tensor_buffer
    ) return tensor_buffer;

  function function_model_controller (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_P_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_OH_input : matrix_buffer;

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    matrix_w_i_input : matrix_buffer;
    tensor_k_i_input : tensor_buffer;
    matrix_v_i_input : matrix_buffer;
    tensor_d_i_input : tensor_buffer;

    tensor_x_i_input   : tensor_buffer;
    array4_r_i_input   : array4_buffer;
    tensor_xi_i_input  : tensor_buffer;
    array4_rho_i_input : array4_buffer;

    matrix_w_o_input : matrix_buffer;
    tensor_k_o_input : tensor_buffer;
    matrix_v_o_input : matrix_buffer;
    tensor_d_o_input : tensor_buffer;

    tensor_x_o_input   : tensor_buffer;
    array4_r_o_input   : array4_buffer;
    tensor_xi_o_input  : tensor_buffer;
    array4_rho_o_input : array4_buffer;

    tensor_pe_input : tensor_buffer
    ) return tensor_buffer;

end model_transformer_controller_vhdl_pkg;

package body model_transformer_controller_vhdl_pkg is

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

    matrix_x_input : matrix_buffer
    ) return matrix_buffer is

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

    matrix_x_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_k_int : matrix_buffer;
    variable matrix_q_int : matrix_buffer;
    variable matrix_v_int : matrix_buffer;

    variable matrix_operation_int : matrix_buffer;
    variable matrix_dimension_int : matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    matrix_k_int := function_model_keys_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_K_IN => SIZE_K_IN,

      matrix_k_input => matrix_k_input,
      matrix_x_input => matrix_x_input
      );

    matrix_q_int := function_model_keys_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_K_IN => SIZE_K_IN,

      matrix_k_input => matrix_q_input,
      matrix_x_input => matrix_x_input
      );

    matrix_operation_int := function_matrix_transpose (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_input => matrix_k_int
      );

    matrix_operation_int := function_matrix_product (
      SIZE_A_I_IN => SIZE_N_IN,
      SIZE_A_J_IN => SIZE_N_IN,
      SIZE_B_I_IN => SIZE_N_IN,
      SIZE_B_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_q_int,
      matrix_b_input => matrix_operation_int
      );

    matrix_operation_int := function_matrix_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_operation_int,
      matrix_b_input => matrix_m_input
      );

    for i in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
      for j in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        matrix_dimension_int(i, j) := std_logic_vector(to_float(sqrt(to_real(to_float(SIZE_D_IN, float64'high, -float64'low))), float64'high, -float64'low));
      end loop;
    end loop;

    matrix_operation_int := function_matrix_float_divider (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_operation_int,
      matrix_b_input => matrix_dimension_int
      );

    matrix_operation_int := function_matrix_softmax (
      SIZE_I_IN => SIZE_N_IN,
      SIZE_J_IN => SIZE_N_IN,

      matrix_input => matrix_operation_int
      );

    matrix_v_int := function_model_keys_vector (
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_K_IN => SIZE_K_IN,

      matrix_k_input => matrix_v_input,
      matrix_x_input => matrix_x_input
      );

    matrix_u_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_N_IN,
      SIZE_A_J_IN => SIZE_N_IN,
      SIZE_B_I_IN => SIZE_N_IN,
      SIZE_B_J_IN => SIZE_N_IN,

      matrix_a_input => matrix_operation_int,
      matrix_b_input => matrix_v_int
      );

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

    matrix_x_input : matrix_buffer
    ) return matrix_buffer is

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

    matrix_x_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_u_output : matrix_buffer;

  begin

    return matrix_u_output;
  end function function_model_scaled_dot_product_attention;

  ------------------------------------------------------------------------------
  -- INPUTS
  ------------------------------------------------------------------------------

  function function_model_inputs_vector (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_P_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    tensor_k_input : tensor_buffer;
    matrix_v_input : matrix_buffer;
    tensor_d_input : tensor_buffer;

    tensor_x_input   : tensor_buffer;
    array4_r_input   : array4_buffer;
    tensor_xi_input  : tensor_buffer;
    array4_rho_input : array4_buffer
    ) return tensor_buffer is

    variable matrix_x_int  : matrix_buffer;
    variable matrix_xi_int : matrix_buffer;

    variable tensor_r_int   : tensor_buffer;
    variable tensor_rho_int : tensor_buffer;

    variable tensor_x_output : tensor_buffer;

  begin

    -- X(l;n;d) = W(d;x)·x(l;n;x) + K(i;d;k)·r(l;n;i;k) + D(i;d;p)·rho(l;n;i;p) + V(d;s)·xi(l;n;s)

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      for n in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          matrix_x_int(n, x) := tensor_x_input(l, n, x);
        end loop;

        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            tensor_r_int(n, i, k) := array4_r_input(l, n, i, k);
          end loop;

          for p in 0 to to_integer(unsigned(SIZE_P_IN))-1 loop
            tensor_rho_int(n, i, p) := array4_rho_input(l, n, i, p);
          end loop;
        end loop;

        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          matrix_xi_int(n, s) := tensor_xi_input(l, n, s);
        end loop;

        -- W(d;x)·x(l;n;x)

        -- K(i;d;k)·r(l;n;i;k)
        for d in 0 to to_integer(unsigned(SIZE_D_IN))-1 loop
          for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop

          end loop;
        end loop;

        -- D(i;d;p)·rho(l;n;i;p)

      -- V(d;s)·xi(l;n;s)
      end loop;
    end loop;

    return tensor_x_output;
  end function function_model_inputs_vector;

  function function_model_keys_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_k_input : matrix_buffer;
    matrix_x_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_k_output : matrix_buffer;

  begin

    -- K(n;k) = X(n;d)·K(d;k)
    matrix_k_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_N_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_I_IN => SIZE_D_IN,
      SIZE_B_J_IN => SIZE_K_IN,

      matrix_a_input => matrix_x_input,
      matrix_b_input => matrix_k_input
      );

    return matrix_k_output;
  end function function_model_keys_vector;

  function function_model_queries_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_x_input : matrix_buffer;
    matrix_q_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_q_output : matrix_buffer;

  begin

    -- Q(n;k) = X(n;d)·Q(d;k)
    matrix_q_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_N_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_I_IN => SIZE_D_IN,
      SIZE_B_J_IN => SIZE_K_IN,

      matrix_a_input => matrix_x_input,
      matrix_b_input => matrix_q_input
      );

    return matrix_q_output;
  end function function_model_queries_vector;

  function function_model_values_vector (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_x_input : matrix_buffer;
    matrix_v_input : matrix_buffer
    ) return matrix_buffer is

    variable matrix_v_output : matrix_buffer;

  begin

    -- V(n;v) = X(n;d)·V(d;v)
    matrix_v_output := function_matrix_product (
      SIZE_A_I_IN => SIZE_N_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_I_IN => SIZE_D_IN,
      SIZE_B_J_IN => SIZE_V_IN,

      matrix_a_input => matrix_x_input,
      matrix_b_input => matrix_v_input
      );

    return matrix_v_output;
  end function function_model_values_vector;

  ------------------------------------------------------------------------------
  -- FUNCTIONS
  ------------------------------------------------------------------------------

  function function_model_layer_norm (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_z_input     : matrix_buffer;
    matrix_gamma_input : matrix_buffer;
    matrix_beta_input  : matrix_buffer
    ) return matrix_buffer is

    variable matrix_n_output : matrix_buffer;

  begin

    return matrix_n_output;
  end function function_model_layer_norm;

  function function_model_positional_encoding (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_x_input  : tensor_buffer;
    tensor_pe_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_one_int   : real;
    variable scalar_operation_two_int   : real;
    variable scalar_operation_three_int : real;

    variable tensor_y_output : tensor_buffer;

  begin

    scalar_operation_three_int := to_real(to_float(SIZE_D_IN, float64'high, -float64'low));

    -- Data Outputs
    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      for n in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        for d in 0 to to_integer(unsigned(SIZE_D_IN))-1 loop
          scalar_operation_one_int := to_real(to_float(tensor_pe_input(l, n, d), float64'high, -float64'low));
          scalar_operation_two_int := to_real(to_float(tensor_x_input(l, n, d), float64'high, -float64'low));

          if (tensor_x_input(l, n, d)(0) = '0') then
            tensor_y_output(l, n, d) := std_logic_vector(to_float(sin(scalar_operation_one_int/10000.0**(2.0*scalar_operation_two_int/scalar_operation_three_int)), float64'high, -float64'low));
          else
            tensor_y_output(l, n, d) := std_logic_vector(to_float(cos(scalar_operation_one_int/10000.0**(2.0*scalar_operation_two_int/scalar_operation_three_int)), float64'high, -float64'low));
          end if;
        end loop;
      end loop;
    end loop;

    return tensor_y_output;
  end function function_model_positional_encoding;

  ------------------------------------------------------------------------------
  -- CONTROLLER
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- FNN
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_fnn_convolutional_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    variable vector_operation_int : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- y(n;d) = W2(d;m)*(sigmoid(W1(m;d)*x(n;d) + b1(m))) + b2(d)

    -- W1(m;d)*x(n;d)
    vector_operation_int := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_M_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_IN   => SIZE_D_IN,

      matrix_a_input => matrix_w1_input,
      vector_b_input => vector_x_input
      );

    -- b1(m)
    vector_operation_int := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_M_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b1_input
      );

    -- sigmoid(.)
    vector_operation_int := function_vector_logistic (
      SIZE_IN => SIZE_M_IN,

      vector_input => vector_operation_int
      );

    -- W2(d;m)*sigmoid(.)
    vector_operation_int := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_D_IN,
      SIZE_A_J_IN => SIZE_M_IN,
      SIZE_B_IN   => SIZE_M_IN,

      matrix_a_input => matrix_w2_input,
      vector_b_input => vector_operation_int
      );

    -- b2(d)
    vector_y_output := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_D_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b2_input
      );

    return vector_y_output;
  end function function_model_fnn_convolutional_controller;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_fnn_standard_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    variable vector_operation_int : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- y(n;d) = W2(d;m)·(sigmoid(W1(m;d)·x(n;d) + b1(m))) + b2(d)

    -- W1(m;d)·x(n;d)
    vector_operation_int := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_M_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_IN   => SIZE_D_IN,

      matrix_a_input => matrix_w1_input,
      vector_b_input => vector_x_input
      );

    -- b1(m)
    vector_operation_int := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_M_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b1_input
      );

    -- sigmoid(.)
    vector_operation_int := function_vector_logistic (
      SIZE_IN => SIZE_M_IN,

      vector_input => vector_operation_int
      );

    -- W2(d;m)·sigmoid(.)
    vector_operation_int := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_D_IN,
      SIZE_A_J_IN => SIZE_M_IN,
      SIZE_B_IN   => SIZE_M_IN,

      matrix_a_input => matrix_w2_input,
      vector_b_input => vector_operation_int
      );

    -- b2(d)
    vector_y_output := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_D_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b2_input
      );

    return vector_y_output;
  end function function_model_fnn_standard_controller;

  ------------------------------------------------------------------------------
  -- LSTM
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_lstm_convolutional_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    variable vector_operation_int : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- y(n;d) = W2(d;m)*(sigmoid(W1(m;d)*x(n;d) + b1(m))) + b2(d)

    -- W1(m;d)*x(n;d)
    vector_operation_int := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_M_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_IN   => SIZE_D_IN,

      matrix_a_input => matrix_w1_input,
      vector_b_input => vector_x_input
      );

    -- b1(m)
    vector_operation_int := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_M_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b1_input
      );

    -- sigmoid(.)
    vector_operation_int := function_vector_logistic (
      SIZE_IN => SIZE_M_IN,

      vector_input => vector_operation_int
      );

    -- W2(d;m)*sigmoid(.)
    vector_operation_int := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_D_IN,
      SIZE_A_J_IN => SIZE_M_IN,
      SIZE_B_IN   => SIZE_M_IN,

      matrix_a_input => matrix_w2_input,
      vector_b_input => vector_operation_int
      );

    -- b2(d)
    vector_y_output := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_D_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b2_input
      );

    return vector_y_output;
  end function function_model_lstm_convolutional_controller;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_lstm_standard_controller (
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    variable vector_operation_int : vector_buffer;

    variable vector_y_output : vector_buffer;

  begin

    -- y(n;d) = W2(d;m)·(sigmoid(W1(m;d)·x(n;d) + b1(m))) + b2(d)

    -- W1(m;d)·x(n;d)
    vector_operation_int := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_M_IN,
      SIZE_A_J_IN => SIZE_D_IN,
      SIZE_B_IN   => SIZE_D_IN,

      matrix_a_input => matrix_w1_input,
      vector_b_input => vector_x_input
      );

    -- b1(m)
    vector_operation_int := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_M_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b1_input
      );

    -- sigmoid(.)
    vector_operation_int := function_vector_logistic (
      SIZE_IN => SIZE_M_IN,

      vector_input => vector_operation_int
      );

    -- W2(d;m)·sigmoid(.)
    vector_operation_int := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_D_IN,
      SIZE_A_J_IN => SIZE_M_IN,
      SIZE_B_IN   => SIZE_M_IN,

      matrix_a_input => matrix_w2_input,
      vector_b_input => vector_operation_int
      );

    -- b2(d)
    vector_y_output := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_D_IN,

      vector_a_input => vector_operation_int,
      vector_b_input => vector_b2_input
      );

    return vector_y_output;
  end function function_model_lstm_standard_controller;

  ------------------------------------------------------------------------------
  -- TOP
  ------------------------------------------------------------------------------

  function function_model_decoder (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    tensor_x_input : tensor_buffer;
    tensor_z_input : tensor_buffer
    ) return tensor_buffer is

    variable matrix_gamma_input : matrix_buffer;
    variable matrix_beta_input  : matrix_buffer;

    variable matrix_m_input : matrix_buffer;

    variable vector_x_int : vector_buffer;
    variable vector_y_int : vector_buffer;

    variable matrix_x_int : matrix_buffer;
    variable matrix_y_int : matrix_buffer;
    variable matrix_z_int : matrix_buffer;

    variable tensor_z_output : tensor_buffer;

  begin

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      for n in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        for d in 0 to to_integer(unsigned(SIZE_D_IN))-1 loop
          matrix_x_int(n, d) := tensor_x_input(l, n, d);
        end loop;
      end loop;

      matrix_y_int := function_model_masked_multi_head_attention (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,
        SIZE_K_IN => SIZE_K_IN,
        SIZE_V_IN => SIZE_V_IN,
        SIZE_H_IN => SIZE_H_IN,

        tensor_k_input => tensor_k_input,
        tensor_q_input => tensor_q_input,
        tensor_v_input => tensor_v_input,

        matrix_m_input => matrix_m_input,

        matrix_w_oh_input => matrix_w_oh_input,

        matrix_x_input => matrix_x_int
        );

      matrix_z_int := function_matrix_float_adder (
        OPERATION => '0',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_D_IN,

        matrix_a_input => matrix_x_int,
        matrix_b_input => matrix_y_int
        );

      matrix_x_int := function_model_layer_norm (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,

        matrix_z_input     => matrix_z_int,
        matrix_gamma_input => matrix_gamma_input,
        matrix_beta_input  => matrix_beta_input
        );

      for n in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        for d in 0 to to_integer(unsigned(SIZE_D_IN))-1 loop
          matrix_z_int(n, d) := tensor_z_input(l, n, d);
        end loop;
      end loop;

      matrix_y_int := function_model_multi_head_attention (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,
        SIZE_K_IN => SIZE_K_IN,
        SIZE_V_IN => SIZE_V_IN,
        SIZE_H_IN => SIZE_H_IN,

        tensor_k_input => tensor_k_input,
        tensor_q_input => tensor_q_input,
        tensor_v_input => tensor_v_input,

        matrix_w_oh_input => matrix_w_oh_input,

        matrix_x_input => matrix_x_int
        );

      matrix_z_int := function_matrix_float_adder (
        OPERATION => '0',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_D_IN,

        matrix_a_input => matrix_x_int,
        matrix_b_input => matrix_y_int
        );

      matrix_x_int := function_model_layer_norm (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,

        matrix_z_input     => matrix_z_int,
        matrix_gamma_input => matrix_gamma_input,
        matrix_beta_input  => matrix_beta_input
        );

      vector_y_int := function_model_fnn_standard_controller (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,
        SIZE_M_IN => SIZE_M_IN,

        matrix_w1_input => matrix_w1_input,
        vector_b1_input => vector_b1_input,

        matrix_w2_input => matrix_w2_input,
        vector_b2_input => vector_b2_input,

        vector_x_input => vector_x_int
        );

      matrix_z_int := function_matrix_float_adder (
        OPERATION => '0',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_D_IN,

        matrix_a_input => matrix_x_int,
        matrix_b_input => matrix_y_int
        );

      matrix_x_int := function_model_layer_norm (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,

        matrix_z_input     => matrix_z_int,
        matrix_gamma_input => matrix_gamma_input,
        matrix_beta_input  => matrix_beta_input
        );
    end loop;

    return tensor_z_output;
  end function function_model_decoder;

  function function_model_encoder (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_oh_input : matrix_buffer;

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    tensor_x_input : tensor_buffer
    ) return tensor_buffer is

    variable matrix_gamma_input : matrix_buffer;
    variable matrix_beta_input  : matrix_buffer;

    variable vector_x_int : vector_buffer;
    variable vector_y_int : vector_buffer;

    variable matrix_x_int : matrix_buffer;
    variable matrix_y_int : matrix_buffer;
    variable matrix_z_int : matrix_buffer;

    variable tensor_z_output : tensor_buffer;

  begin

    for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
      for n in 0 to to_integer(unsigned(SIZE_N_IN))-1 loop
        for d in 0 to to_integer(unsigned(SIZE_D_IN))-1 loop
          matrix_z_int(n, d) := tensor_x_input(l, n, d);
        end loop;
      end loop;

      matrix_y_int := function_model_multi_head_attention (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,
        SIZE_K_IN => SIZE_K_IN,
        SIZE_V_IN => SIZE_V_IN,
        SIZE_H_IN => SIZE_H_IN,

        tensor_k_input => tensor_k_input,
        tensor_q_input => tensor_q_input,
        tensor_v_input => tensor_v_input,

        matrix_w_oh_input => matrix_w_oh_input,

        matrix_x_input => matrix_x_int
        );

      matrix_z_int := function_matrix_float_adder (
        OPERATION => '0',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_D_IN,

        matrix_a_input => matrix_x_int,
        matrix_b_input => matrix_y_int
        );

      matrix_x_int := function_model_layer_norm (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,

        matrix_z_input     => matrix_z_int,
        matrix_gamma_input => matrix_gamma_input,
        matrix_beta_input  => matrix_beta_input
        );

      vector_y_int := function_model_fnn_standard_controller (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,
        SIZE_M_IN => SIZE_M_IN,

        matrix_w1_input => matrix_w1_input,
        vector_b1_input => vector_b1_input,

        matrix_w2_input => matrix_w2_input,
        vector_b2_input => vector_b2_input,

        vector_x_input => vector_x_int
        );

      matrix_z_int := function_matrix_float_adder (
        OPERATION => '0',

        SIZE_I_IN => SIZE_N_IN,
        SIZE_J_IN => SIZE_D_IN,

        matrix_a_input => matrix_x_int,
        matrix_b_input => matrix_y_int
        );

      matrix_x_int := function_model_layer_norm (
        SIZE_N_IN => SIZE_N_IN,
        SIZE_D_IN => SIZE_D_IN,

        matrix_z_input     => matrix_z_int,
        matrix_gamma_input => matrix_gamma_input,
        matrix_beta_input  => matrix_beta_input
        );
    end loop;

    return tensor_z_output;
  end function function_model_encoder;

  function function_model_controller (
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_K_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_V_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_H_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_P_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    tensor_k_input : tensor_buffer;
    tensor_q_input : tensor_buffer;
    tensor_v_input : tensor_buffer;

    matrix_w_OH_input : matrix_buffer;

    matrix_w1_input : matrix_buffer;
    vector_b1_input : vector_buffer;

    matrix_w2_input : matrix_buffer;
    vector_b2_input : vector_buffer;

    matrix_w_i_input : matrix_buffer;
    tensor_k_i_input : tensor_buffer;
    matrix_v_i_input : matrix_buffer;
    tensor_d_i_input : tensor_buffer;

    tensor_x_i_input   : tensor_buffer;
    array4_r_i_input   : array4_buffer;
    tensor_xi_i_input  : tensor_buffer;
    array4_rho_i_input : array4_buffer;

    matrix_w_o_input : matrix_buffer;
    tensor_k_o_input : tensor_buffer;
    matrix_v_o_input : matrix_buffer;
    tensor_d_o_input : tensor_buffer;

    tensor_x_o_input   : tensor_buffer;
    array4_r_o_input   : array4_buffer;
    tensor_xi_o_input  : tensor_buffer;
    array4_rho_o_input : array4_buffer;

    tensor_pe_input : tensor_buffer
    ) return tensor_buffer is

    variable tensor_x_in_int  : tensor_buffer;
    variable tensor_x_out_int : tensor_buffer;

    variable tensor_x_int : tensor_buffer;
    variable tensor_y_int : tensor_buffer;
    variable tensor_z_int : tensor_buffer;

    variable tensor_z_output : tensor_buffer;

  begin

    -- Input Embedding
    tensor_x_in_int := function_model_inputs_vector (
      SIZE_L_IN => SIZE_L_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_K_IN => SIZE_K_IN,
      SIZE_V_IN => SIZE_V_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_P_IN => SIZE_P_IN,
      SIZE_S_IN => SIZE_S_IN,

      matrix_w_input => matrix_w_i_input,
      tensor_k_input => tensor_k_i_input,
      matrix_v_input => matrix_v_i_input,
      tensor_d_input => tensor_d_i_input,

      tensor_x_input   => tensor_x_i_input,
      array4_r_input   => array4_r_i_input,
      tensor_xi_input  => tensor_xi_i_input,
      array4_rho_input => array4_rho_i_input
      );

    tensor_x_in_int := function_model_positional_encoding (
      SIZE_L_IN => SIZE_L_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,

      tensor_x_input  => tensor_x_in_int,
      tensor_pe_input => tensor_pe_input
      );

    tensor_x_in_int := function_tensor_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_L_IN,
      SIZE_J_IN => SIZE_N_IN,
      SIZE_K_IN => SIZE_D_IN,

      tensor_a_input => tensor_x_in_int,
      tensor_b_input => tensor_y_int
      );

    -- Output Embedding
    tensor_x_out_int := function_model_inputs_vector (
      SIZE_L_IN => SIZE_L_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_K_IN => SIZE_K_IN,
      SIZE_V_IN => SIZE_V_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_P_IN => SIZE_P_IN,
      SIZE_S_IN => SIZE_S_IN,

      matrix_w_input => matrix_w_o_input,
      tensor_k_input => tensor_k_o_input,
      matrix_v_input => matrix_v_o_input,
      tensor_d_input => tensor_d_o_input,

      tensor_x_input   => tensor_x_o_input,
      array4_r_input   => array4_r_o_input,
      tensor_xi_input  => tensor_xi_o_input,
      array4_rho_input => array4_rho_o_input
      );

    tensor_x_out_int := function_model_positional_encoding (
      SIZE_L_IN => SIZE_L_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,

      tensor_x_input  => tensor_x_out_int,
      tensor_pe_input => tensor_pe_input
      );

    tensor_x_out_int := function_tensor_float_adder (
      OPERATION => '0',

      SIZE_I_IN => SIZE_L_IN,
      SIZE_J_IN => SIZE_N_IN,
      SIZE_K_IN => SIZE_D_IN,

      tensor_a_input => tensor_x_out_int,
      tensor_b_input => tensor_y_int
      );

    -- Encoder
    tensor_z_output := function_model_encoder (
      SIZE_L_IN => SIZE_L_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_M_IN => SIZE_M_IN,
      SIZE_K_IN => SIZE_K_IN,
      SIZE_V_IN => SIZE_V_IN,
      SIZE_H_IN => SIZE_H_IN,

      tensor_k_input => tensor_k_input,
      tensor_q_input => tensor_q_input,
      tensor_v_input => tensor_v_input,

      matrix_w_oh_input => matrix_w_oh_input,

      matrix_w1_input => matrix_w1_input,
      vector_b1_input => vector_b1_input,

      matrix_w2_input => matrix_w2_input,
      vector_b2_input => vector_b2_input,

      tensor_x_input => tensor_x_int);

    -- Decoder
    tensor_z_output := function_model_decoder (
      SIZE_L_IN => SIZE_L_IN,
      SIZE_N_IN => SIZE_N_IN,
      SIZE_D_IN => SIZE_D_IN,
      SIZE_M_IN => SIZE_M_IN,
      SIZE_K_IN => SIZE_K_IN,
      SIZE_V_IN => SIZE_V_IN,
      SIZE_H_IN => SIZE_H_IN,

      tensor_k_input => tensor_k_input,
      tensor_q_input => tensor_q_input,
      tensor_v_input => tensor_v_input,

      matrix_w_oh_input => matrix_w_oh_input,

      matrix_w1_input => matrix_w1_input,
      vector_b1_input => vector_b1_input,

      matrix_w2_input => matrix_w2_input,
      vector_b2_input => vector_b2_input,

      tensor_x_input => tensor_x_out_int,
      tensor_z_input => tensor_z_int);

    return tensor_z_output;
  end function function_model_controller;

end model_transformer_controller_vhdl_pkg;
