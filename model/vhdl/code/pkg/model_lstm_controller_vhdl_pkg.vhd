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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;

package model_lstm_controller_vhdl_pkg is
  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type trainer_output is record
    matrix_w_output : matrix_buffer;
    tensor_k_output : tensor_buffer;
    matrix_v_output : matrix_buffer;
    tensor_d_output : tensor_buffer;
    matrix_u_output : matrix_buffer;
    vector_b_output : vector_buffer;
  end record trainer_output;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component model_activation_gate_vector is
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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
      CONTROL_SIZE : integer := 4
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

  function function_trainer_vector_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return matrix_buffer;

  function function_trainer_matrix_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- Controller
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
  -- Trainer
  ------------------------------------------------------------------------------

  function function_model_lstm_activation_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_activation_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_activation_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_activation_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_activation_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_activation_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return vector_buffer;

  function function_model_lstm_activation_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return trainer_output;

  function function_model_lstm_forget_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_forget_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_forget_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_forget_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_forget_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_forget_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return vector_buffer;

  function function_model_lstm_forget_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return trainer_output;

  function function_model_lstm_input_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_input_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_input_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_input_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_input_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_input_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return vector_buffer;

  function function_model_lstm_input_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return trainer_output;

  function function_model_lstm_output_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_output_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_output_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_output_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;
    vector_h_input  : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_lstm_output_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return tensor_buffer;

  function function_model_lstm_output_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return vector_buffer;

  function function_model_lstm_output_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return trainer_output;

end model_lstm_controller_vhdl_pkg;

package body model_lstm_controller_vhdl_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  function function_trainer_vector_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : matrix_buffer;
  begin
    -- Data Inputs
    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        if (t = 0) then
          vector_output(t, l) := ZERO_DATA;
        else
          scalar_operation_int := function_scalar_float_adder (
            OPERATION => '1',

            scalar_a_input => vector_input(t, l),
            scalar_b_input => vector_input(t-1, l)
            );

          vector_output(t, l) := function_scalar_float_multiplier (
            scalar_a_input => scalar_operation_int,
            scalar_b_input => LENGTH_IN
            );
        end if;
      end loop;
    end loop;

    return vector_output;
  end function function_trainer_vector_differentiation;

  function function_trainer_matrix_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : tensor_buffer;
  begin
    -- Data Inputs
    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
        for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          if (t = 0) then
            matrix_output(t, i, l) := ZERO_DATA;
          else
            scalar_operation_int := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => matrix_input(t, i, l),
              scalar_b_input => matrix_input(t-1, i, l)
              );

            matrix_output(t, i, l) := function_scalar_float_multiplier (
              scalar_a_input => scalar_operation_int,
              scalar_b_input => LENGTH_IN
              );
          end if;
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_trainer_matrix_differentiation;

  ------------------------------------------------------------------------------
  -- Controller
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
  -- Trainer
  ------------------------------------------------------------------------------

  function function_model_lstm_activation_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_da_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_w_output : matrix_buffer;

  begin

    -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

    matrix_w_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => vector_a_input(t, l)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_da_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dW(l;x) = summation(da(t;l) · x(t;x))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_da_int(t, l),
            scalar_b_input => vector_x_input(t, x)
            );

          matrix_w_output(l, x) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_w_output(l, x)
            );
        end loop;
      end loop;
    end loop;

    return matrix_w_output;
  end function function_model_lstm_activation_w_trainer;

  function function_model_lstm_activation_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_da_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable tensor_k_output : tensor_buffer;

  begin

    -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

    tensor_k_output := (others => (others => (others => ZERO_DATA)));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => vector_a_input(t, l)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_da_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dK(l;i;k) = summation(da(t;l) · r(t;i;k))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_da_int(t, l),
              scalar_b_input => matrix_r_input(t, i, k)
              );

            tensor_k_output(l, i, k) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_k_output(l, i, k)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_k_output;
  end function function_model_lstm_activation_k_trainer;

  function function_model_lstm_activation_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_da_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

    matrix_u_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => vector_a_input(t, l)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_da_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dU(l;m) = summation(da(t+1;l) · h(t;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_da_int(t, l),
            scalar_b_input => vector_h_input(t, m)
            );

          matrix_u_output(l, m) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_u_output(l, m)
            );
        end loop;
      end loop;
    end loop;

    return matrix_u_output;
  end function function_model_lstm_activation_u_trainer;

  function function_model_lstm_activation_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_da_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable tensor_d_output : tensor_buffer;

  begin

    -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

    tensor_d_output := (others => (others => (others => ZERO_DATA)));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => vector_a_input(t, l)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_da_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dD(l;i;m) = summation(da(t;l) · rho(t;i;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for m in 0 to to_integer(unsigned(SIZE_M_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_da_int(t, l),
              scalar_b_input => matrix_rho_input(t, i, m)
              );

            tensor_d_output(l, i, m) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_d_output(l, i, m)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_d_output;
  end function function_model_lstm_activation_d_trainer;

  function function_model_lstm_activation_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_da_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_v_output : matrix_buffer;

  begin

    -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

    matrix_v_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => vector_a_input(t, l)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_da_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dW(l;x) = summation(da(t;l) · xi(t;s))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_da_int(t, l),
            scalar_b_input => vector_xi_input(t, s)
            );

          matrix_v_output(l, s) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_v_output(l, s)
            );
        end loop;
      end loop;
    end loop;

    return matrix_v_output;
  end function function_model_lstm_activation_v_trainer;

  function function_model_lstm_activation_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_da_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable vector_b_output : vector_buffer;

  begin

    -- da(t;l) = ds(t;l) o i(t;l) o (1 - a(t;l)^2)

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => vector_a_input(t, l)
          );

        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_da_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- db(l) = summation(da(t;l))[t in 0 to T]

    vector_b_output := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_T_IN,

      vector_input => vector_da_int
      );

    return vector_b_output;
  end function function_model_lstm_activation_b_trainer;

  function function_model_lstm_activation_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return trainer_output is

    -- Trainer Variable
    variable matrix_w_output : matrix_buffer;
    variable tensor_k_output : tensor_buffer;
    variable matrix_u_output : matrix_buffer;
    variable matrix_v_output : matrix_buffer;
    variable tensor_d_output : tensor_buffer;
    variable vector_b_output : vector_buffer;

    variable trainer_lstm_output : trainer_output;

  begin

    -- TRAINER_STATE

    matrix_w_output := function_model_lstm_activation_w_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_x_input => vector_x_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    tensor_k_output := function_model_lstm_activation_k_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      matrix_r_input => matrix_r_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    tensor_d_output := function_model_lstm_activation_d_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_M_IN => SIZE_M_IN,

      matrix_rho_input => matrix_rho_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    matrix_v_output := function_model_lstm_activation_v_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_S_IN => SIZE_S_IN,

      vector_xi_input => vector_xi_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    matrix_u_output := function_model_lstm_activation_u_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_h_input => vector_h_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    vector_b_output := function_model_lstm_activation_b_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    trainer_lstm_output.matrix_w_output := matrix_w_output;
    trainer_lstm_output.tensor_k_output := tensor_k_output;
    trainer_lstm_output.matrix_v_output := matrix_v_output;
    trainer_lstm_output.tensor_d_output := tensor_d_output;
    trainer_lstm_output.matrix_u_output := matrix_u_output;
    trainer_lstm_output.vector_b_output := vector_b_output;

    return trainer_lstm_output;

  end function function_model_lstm_activation_trainer;

  function function_model_lstm_forget_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_df_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_w_output : matrix_buffer;

  begin

    -- df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

    matrix_w_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_f_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_f_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_s_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_df_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dW(l;x) = summation(df(t;l) · x(t;x))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_df_int(t, l),
            scalar_b_input => vector_x_input(t, x)
            );

          matrix_w_output(l, x) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_w_output(l, x)
            );
        end loop;
      end loop;
    end loop;

    return matrix_w_output;
  end function function_model_lstm_forget_w_trainer;

  function function_model_lstm_forget_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_df_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable tensor_k_output : tensor_buffer;

  begin

    -- df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

    tensor_k_output := (others => (others => (others => ZERO_DATA)));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_f_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_f_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_s_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_df_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dK(l;i;k) = summation(df(t;l) · r(t;i;k))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_df_int(t, l),
              scalar_b_input => matrix_r_input(t, i, k)
              );

            tensor_k_output(l, i, k) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_k_output(l, i, k)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_k_output;
  end function function_model_lstm_forget_k_trainer;

  function function_model_lstm_forget_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_df_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    -- df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

    matrix_u_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_f_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_f_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_s_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_df_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dU(l;m) = summation(df(t+1;l) · h(t;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_df_int(t, l),
            scalar_b_input => vector_h_input(t, m)
            );

          matrix_u_output(l, m) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_u_output(l, m)
            );
        end loop;
      end loop;
    end loop;

    return matrix_u_output;
  end function function_model_lstm_forget_u_trainer;

  function function_model_lstm_forget_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_df_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_v_output : matrix_buffer;

  begin

    -- df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

    matrix_v_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_f_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_f_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_s_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_df_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dV(l;s) = summation(df(t;l) · xi(t;s))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_df_int(t, l),
            scalar_b_input => vector_xi_input(t, s)
            );

          matrix_v_output(l, s) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_v_output(l, s)
            );
        end loop;
      end loop;
    end loop;

    return matrix_v_output;
  end function function_model_lstm_forget_v_trainer;

  function function_model_lstm_forget_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_df_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable tensor_d_output : tensor_buffer;

  begin

    -- df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

    tensor_d_output := (others => (others => (others => ZERO_DATA)));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_f_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_f_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_s_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_df_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dD(l;i;m) = summation(df(t;l) · rho(t;i;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for m in 0 to to_integer(unsigned(SIZE_M_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_df_int(t, l),
              scalar_b_input => matrix_rho_input(t, i, m)
              );

            tensor_d_output(l, i, m) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_d_output(l, i, m)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_d_output;
  end function function_model_lstm_forget_d_trainer;

  function function_model_lstm_forget_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_df_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable vector_b_output : vector_buffer;

  begin

    -- df(t;l) = ds(t;l) o s(t-1;l) o f(t;l) o (1 - f(t;l))

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_f_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_f_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_s_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_df_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- db(l) = summation(df(t;l))[t in 0 to T]

    vector_b_output := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_T_IN,

      vector_input => vector_df_int
      );

    return vector_b_output;
  end function function_model_lstm_forget_b_trainer;

  function function_model_lstm_forget_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_f_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return trainer_output is

    -- Trainer Variable
    variable matrix_w_output : matrix_buffer;
    variable tensor_k_output : tensor_buffer;
    variable matrix_u_output : matrix_buffer;
    variable matrix_v_output : matrix_buffer;
    variable tensor_d_output : tensor_buffer;
    variable vector_b_output : vector_buffer;

    variable trainer_lstm_output : trainer_output;

  begin

    -- TRAINER_STATE

    matrix_w_output := function_model_lstm_forget_w_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_x_input => vector_x_input,

      vector_f_input => vector_f_input,
      vector_s_input => vector_s_input
      );

    tensor_k_output := function_model_lstm_forget_k_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      matrix_r_input => matrix_r_input,

      vector_f_input => vector_f_input,
      vector_s_input => vector_s_input
      );

    tensor_d_output := function_model_lstm_forget_d_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_M_IN => SIZE_M_IN,

      matrix_rho_input => matrix_rho_input,

      vector_f_input => vector_f_input,
      vector_s_input => vector_s_input
      );

    matrix_v_output := function_model_lstm_forget_v_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_S_IN => SIZE_S_IN,

      vector_xi_input => vector_xi_input,

      vector_f_input => vector_f_input,
      vector_s_input => vector_s_input
      );

    matrix_u_output := function_model_lstm_forget_u_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_h_input => vector_h_input,

      vector_f_input => vector_f_input,
      vector_s_input => vector_s_input
      );

    vector_b_output := function_model_lstm_forget_b_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_f_input => vector_f_input,
      vector_s_input => vector_s_input
      );

    trainer_lstm_output.matrix_w_output := matrix_w_output;
    trainer_lstm_output.tensor_k_output := tensor_k_output;
    trainer_lstm_output.matrix_v_output := matrix_v_output;
    trainer_lstm_output.tensor_d_output := tensor_d_output;
    trainer_lstm_output.matrix_u_output := matrix_u_output;
    trainer_lstm_output.vector_b_output := vector_b_output;

    return trainer_lstm_output;

  end function function_model_lstm_forget_trainer;

  function function_model_lstm_input_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_di_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_w_output : matrix_buffer;

  begin

    -- di(t;l) = ds(t;l) o a(t;l) o i(t;l) o (1 - i(t;l))

    matrix_w_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_i_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_di_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dW(l;x) = summation(di(t;l) · x(t;x))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_di_int(t, l),
            scalar_b_input => vector_x_input(t, x)
            );

          matrix_w_output(l, x) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_w_output(l, x)
            );
        end loop;
      end loop;
    end loop;

    return matrix_w_output;
  end function function_model_lstm_input_w_trainer;

  function function_model_lstm_input_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_di_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable tensor_k_output : tensor_buffer;

  begin

    -- di(t;l) = ds(t;l) o a(t;l) o i(t;l) o (1 - i(t;l))

    tensor_k_output := (others => (others => (others => ZERO_DATA)));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_i_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_di_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dK(l;i;k) = summation(di(t;l) · r(t;i;k))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_di_int(t, l),
              scalar_b_input => matrix_r_input(t, i, k)
              );

            tensor_k_output(l, i, k) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_k_output(l, i, k)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_k_output;
  end function function_model_lstm_input_k_trainer;

  function function_model_lstm_input_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_di_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    -- di(t;l) = ds(t;l) o a(t;l) o i(t;l) o (1 - i(t;l))

    matrix_u_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_i_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_di_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dU(l;m) = summation(di(t+1;l) · h(t;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_di_int(t, l),
            scalar_b_input => vector_h_input(t, m)
            );

          matrix_u_output(l, m) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_u_output(l, m)
            );
        end loop;
      end loop;
    end loop;

    return matrix_u_output;
  end function function_model_lstm_input_u_trainer;

  function function_model_lstm_input_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_di_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable matrix_v_output : matrix_buffer;

  begin

    -- di(t;l) = ds(t;l) o a(t;l) o i(t;l) o (1 - i(t;l))

    matrix_v_output := (others => (others => ZERO_DATA));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_i_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_di_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dV(l;s) = summation(di(t;l) · xi(t;s))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_di_int(t, l),
            scalar_b_input => vector_xi_input(t, s)
            );

          matrix_v_output(l, s) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_v_output(l, s)
            );
        end loop;
      end loop;
    end loop;

    return matrix_v_output;
  end function function_model_lstm_input_v_trainer;

  function function_model_lstm_input_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_di_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable tensor_d_output : tensor_buffer;

  begin

    -- di(t;l) = ds(t;l) o a(t;l) o i(t;l) o (1 - i(t;l))

    tensor_d_output := (others => (others => (others => ZERO_DATA)));

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_i_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_di_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- dD(l;i;m) = summation(di(t;l) · rho(t;i;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for m in 0 to to_integer(unsigned(SIZE_M_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_di_int(t, l),
              scalar_b_input => matrix_rho_input(t, i, m)
              );

            tensor_d_output(l, i, m) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_d_output(l, i, m)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_d_output;
  end function function_model_lstm_input_d_trainer;

  function function_model_lstm_input_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return vector_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_di_int : matrix_buffer;
    variable vector_ds_int : matrix_buffer;

    variable vector_b_output : vector_buffer;

  begin

    -- di(t;l) = ds(t;l) o a(t;l) o i(t;l) o (1 - i(t;l))

    vector_ds_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_s_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_i_input(t, l)
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_i_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        scalar_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_a_input(t, l),
          scalar_b_input => scalar_operation_int
          );

        vector_di_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_ds_int(t, l),
          scalar_b_input => scalar_operation_int
          );
      end loop;
    end loop;

    -- db(l) = summation(di(t;l))[t in 0 to T]

    vector_b_output := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_T_IN,

      vector_input => vector_di_int
      );

    return vector_b_output;
  end function function_model_lstm_input_b_trainer;

  function function_model_lstm_input_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_Y_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_i_input : matrix_buffer;
    vector_s_input : matrix_buffer
    ) return trainer_output is

    -- Trainer Variable
    variable matrix_w_output : matrix_buffer;
    variable tensor_k_output : tensor_buffer;
    variable matrix_u_output : matrix_buffer;
    variable matrix_v_output : matrix_buffer;
    variable tensor_d_output : tensor_buffer;
    variable vector_b_output : vector_buffer;

    variable trainer_lstm_output : trainer_output;

  begin

    -- TRAINER_STATE

    matrix_w_output := function_model_lstm_input_w_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_x_input => vector_x_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    tensor_k_output := function_model_lstm_input_k_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      matrix_r_input => matrix_r_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    tensor_d_output := function_model_lstm_input_d_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_M_IN => SIZE_M_IN,

      matrix_rho_input => matrix_rho_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    matrix_v_output := function_model_lstm_input_v_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_S_IN => SIZE_S_IN,

      vector_xi_input => vector_xi_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    matrix_u_output := function_model_lstm_input_u_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_h_input => vector_h_input,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    vector_b_output := function_model_lstm_input_b_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_a_input => vector_a_input,
      vector_i_input => vector_i_input,
      vector_s_input => vector_s_input
      );

    trainer_lstm_output.matrix_w_output := matrix_w_output;
    trainer_lstm_output.tensor_k_output := tensor_k_output;
    trainer_lstm_output.matrix_v_output := matrix_v_output;
    trainer_lstm_output.tensor_d_output := tensor_d_output;
    trainer_lstm_output.matrix_u_output := matrix_u_output;
    trainer_lstm_output.vector_b_output := vector_b_output;

    return trainer_lstm_output;

  end function function_model_lstm_input_trainer;

  function function_model_lstm_output_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;
    variable vector_do_int : matrix_buffer;

    variable matrix_w_output : matrix_buffer;

  begin

    -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))

    matrix_w_output := (others => (others => ZERO_DATA));

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_first_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_o_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_o_input(t, l),
          scalar_b_input => scalar_first_operation_int
          );

        scalar_second_operation_int := function_scalar_tanh (
          scalar_input => vector_a_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => scalar_first_operation_int,
          scalar_b_input => scalar_second_operation_int
          );

        vector_do_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => scalar_first_operation_int
          );
      end loop;
    end loop;

    -- dW(l;x) = summation(do(t;l) · x(t;x))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_do_int(t, l),
            scalar_b_input => vector_x_input(t, x)
            );

          matrix_w_output(l, x) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_w_output(l, x)
            );
        end loop;
      end loop;
    end loop;

    return matrix_w_output;
  end function function_model_lstm_output_w_trainer;

  function function_model_lstm_output_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_r_input : tensor_buffer;
    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;
    variable vector_do_int : matrix_buffer;

    variable tensor_k_output : tensor_buffer;

  begin

    -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))

    tensor_k_output := (others => (others => (others => ZERO_DATA)));

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_first_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_o_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_o_input(t, l),
          scalar_b_input => scalar_first_operation_int
          );

        scalar_second_operation_int := function_scalar_tanh (
          scalar_input => vector_a_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => scalar_first_operation_int,
          scalar_b_input => scalar_second_operation_int
          );

        vector_do_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => scalar_first_operation_int
          );
      end loop;
    end loop;

    -- dK(l;i;k) = summation(do(t;l) · r(t;i;k))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for k in 0 to to_integer(unsigned(SIZE_W_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_do_int(t, l),
              scalar_b_input => matrix_r_input(t, i, k)
              );

            tensor_k_output(l, i, k) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_k_output(l, i, k)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_k_output;
  end function function_model_lstm_output_k_trainer;

  function function_model_lstm_output_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;
    variable vector_do_int : matrix_buffer;

    variable matrix_u_output : matrix_buffer;

  begin

    -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))

    matrix_u_output := (others => (others => ZERO_DATA));

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_first_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_o_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_o_input(t, l),
          scalar_b_input => scalar_first_operation_int
          );

        scalar_second_operation_int := function_scalar_tanh (
          scalar_input => vector_a_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => scalar_first_operation_int,
          scalar_b_input => scalar_second_operation_int
          );

        vector_do_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => scalar_first_operation_int
          );
      end loop;
    end loop;

    -- dU(l;m) = summation(do(t+1;l) · h(t;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for m in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_do_int(t, l),
            scalar_b_input => vector_h_input(t, m)
            );

          matrix_u_output(l, m) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_u_output(l, m)
            );
        end loop;
      end loop;
    end loop;

    return matrix_u_output;
  end function function_model_lstm_output_u_trainer;

  function function_model_lstm_output_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_xi_input : matrix_buffer;
    vector_h_input  : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;
    variable vector_do_int : matrix_buffer;

    variable matrix_v_output : matrix_buffer;

  begin

    -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))

    matrix_v_output := (others => (others => ZERO_DATA));

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_first_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_o_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_o_input(t, l),
          scalar_b_input => scalar_first_operation_int
          );

        scalar_second_operation_int := function_scalar_tanh (
          scalar_input => vector_a_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => scalar_first_operation_int,
          scalar_b_input => scalar_second_operation_int
          );

        vector_do_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => scalar_first_operation_int
          );
      end loop;
    end loop;

    -- dV(l;s) = summation(do(t;l) · xi(t;s))[t in 0 to T]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_do_int(t, l),
            scalar_b_input => vector_xi_input(t, s)
            );

          matrix_v_output(l, s) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_v_output(l, s)
            );
        end loop;
      end loop;
    end loop;

    return matrix_v_output;
  end function function_model_lstm_output_v_trainer;

  function function_model_lstm_output_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;
    variable vector_do_int : matrix_buffer;

    variable tensor_d_output : tensor_buffer;

  begin

    -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))

    tensor_d_output := (others => (others => (others => ZERO_DATA)));

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_first_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_o_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_o_input(t, l),
          scalar_b_input => scalar_first_operation_int
          );

        scalar_second_operation_int := function_scalar_tanh (
          scalar_input => vector_a_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => scalar_first_operation_int,
          scalar_b_input => scalar_second_operation_int
          );

        vector_do_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => scalar_first_operation_int
          );
      end loop;
    end loop;

    -- dD(l;i;m) = summation(do(t;l) · rho(t;i;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for m in 0 to to_integer(unsigned(SIZE_M_IN))-1 loop
            scalar_operation_int := function_scalar_float_multiplier (
              scalar_a_input => vector_do_int(t, l),
              scalar_b_input => matrix_rho_input(t, i, m)
              );

            tensor_d_output(l, i, m) := function_scalar_float_adder (
              OPERATION => '0',

              scalar_a_input => scalar_operation_int,
              scalar_b_input => tensor_d_output(l, i, m)
              );
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_d_output;
  end function function_model_lstm_output_d_trainer;

  function function_model_lstm_output_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return vector_buffer is

    variable scalar_first_operation_int  : std_logic_vector(DATA_SIZE-1 downto 0);
    variable scalar_second_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;
    variable vector_do_int : matrix_buffer;

    variable vector_b_output : vector_buffer;

  begin

    -- do(t;l) = dh(t;l) o tanh(a(t;l)) o o(t;l) o (1 - o(t;l))

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        scalar_first_operation_int := function_scalar_float_adder (
          OPERATION => '1',

          scalar_a_input => ONE_DATA,
          scalar_b_input => vector_o_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => vector_o_input(t, l),
          scalar_b_input => scalar_first_operation_int
          );

        scalar_second_operation_int := function_scalar_tanh (
          scalar_input => vector_a_input(t, l)
          );

        scalar_first_operation_int := function_scalar_float_multiplier (
          scalar_a_input => scalar_first_operation_int,
          scalar_b_input => scalar_second_operation_int
          );

        vector_do_int(t, l) := function_scalar_float_multiplier (
          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => scalar_first_operation_int
          );
      end loop;
    end loop;

    -- db(l) = summation(do(t;l))[t in 0 to T]

    vector_b_output := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_T_IN,

      vector_input => vector_do_int
      );

    return vector_b_output;
  end function function_model_lstm_output_b_trainer;

  function function_model_lstm_output_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer;

    vector_a_input : matrix_buffer;
    vector_o_input : matrix_buffer
    ) return trainer_output is

    -- Trainer Variable
    variable matrix_w_output : matrix_buffer;
    variable tensor_k_output : tensor_buffer;
    variable matrix_u_output : matrix_buffer;
    variable matrix_v_output : matrix_buffer;
    variable tensor_d_output : tensor_buffer;
    variable vector_b_output : vector_buffer;

    variable trainer_lstm_output : trainer_output;

  begin

    -- TRAINER_STATE

    matrix_w_output := function_model_lstm_output_w_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_x_input => vector_x_input,
      vector_h_input => vector_h_input,

      vector_a_input => vector_a_input,
      vector_o_input => vector_o_input
      );

    tensor_k_output := function_model_lstm_output_k_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_W_IN => SIZE_W_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,

      matrix_r_input => matrix_r_input,
      vector_h_input => vector_h_input,

      vector_a_input => vector_a_input,
      vector_o_input => vector_o_input
      );

    tensor_d_output := function_model_lstm_output_d_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_R_IN => SIZE_R_IN,
      SIZE_M_IN => SIZE_M_IN,

      matrix_rho_input => matrix_rho_input,
      vector_h_input   => vector_h_input,

      vector_a_input => vector_a_input,
      vector_o_input => vector_o_input
      );

    matrix_v_output := function_model_lstm_output_v_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,
      SIZE_S_IN => SIZE_S_IN,

      vector_xi_input => vector_xi_input,
      vector_h_input  => vector_h_input,

      vector_a_input => vector_a_input,
      vector_o_input => vector_o_input
      );

    matrix_u_output := function_model_lstm_output_u_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_h_input => vector_h_input,

      vector_a_input => vector_a_input,
      vector_o_input => vector_o_input
      );

    vector_b_output := function_model_lstm_output_b_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_h_input => vector_h_input,

      vector_a_input => vector_a_input,
      vector_o_input => vector_o_input
      );

    trainer_lstm_output.matrix_w_output := matrix_w_output;
    trainer_lstm_output.tensor_k_output := tensor_k_output;
    trainer_lstm_output.matrix_v_output := matrix_v_output;
    trainer_lstm_output.tensor_d_output := tensor_d_output;
    trainer_lstm_output.matrix_u_output := matrix_u_output;
    trainer_lstm_output.vector_b_output := vector_b_output;

    return trainer_lstm_output;

  end function function_model_lstm_output_trainer;

end model_lstm_controller_vhdl_pkg;
