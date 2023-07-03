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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_math_pkg.all;

package accelerator_transformer_controller_pkg is

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- COMPOMENTS
  ------------------------------------------------------------------------------

  component accelerator_masked_multi_head_attention is
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

      M_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
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

  component accelerator_masked_scaled_dot_product_attention is
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

      M_IN_N_ENABLE : in std_logic;     -- for n in 0 to N-1
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

  component accelerator_multi_head_attention is
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

  component accelerator_scaled_dot_product_attention is
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

  component accelerator_inputs_vector is
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

  component accelerator_keys_vector is
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

  component accelerator_queries_vector is
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

  component accelerator_values_vector is
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

  component accelerator_layer_norm is
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

  component accelerator_positional_encoding is
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

      PE_IN_N_ENABLE : in std_logic;    -- for l in 0 to L-1
      PE_IN_D_ENABLE : in std_logic;    -- for n in 0 to N-1
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

  component accelerator_fnn is
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

  component accelerator_activation_gate_vector is
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

  component accelerator_activation_trainer is
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

  component accelerator_input_gate_vector is
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

  component accelerator_input_trainer is
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

  component accelerator_output_gate_vector is
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

  component accelerator_output_trainer is
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

  component accelerator_forget_gate_vector is
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

  component accelerator_forget_trainer is
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

  component accelerator_state_gate_vector is
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

  component accelerator_hidden_gate_vector is
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

  component accelerator_controller is
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

  component accelerator_controller is
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

  component accelerator_decoder is
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

  component accelerator_encoder is
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

end accelerator_transformer_controller_pkg;
