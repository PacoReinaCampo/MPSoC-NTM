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

package ntm_fnn_controller_pkg is

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_controller is
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

  component ntm_trainer is
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

      X_IN_ENABLE : in std_logic;         -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;       -- for x in 0 to X-1

      R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
      R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

      R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
      R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

      RHO_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1 (read heads flow)
      RHO_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

      RHO_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)
      RHO_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

      XI_IN_ENABLE : in std_logic;        -- for s in 0 to S-1

      XI_OUT_ENABLE : out std_logic;      -- for s in 0 to S-1

      H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

      H_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;     -- for x in 0 to X-1

      K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
      K_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
      K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

      D_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
      D_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
      D_OUT_M_ENABLE : out std_logic;     -- for s in 0 to M-1

      U_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
      U_OUT_P_ENABLE : out std_logic;     -- for p in 0 to L-1

      V_OUT_L_ENABLE : out std_logic;     -- for l in 0 to L-1
      V_OUT_S_ENABLE : out std_logic;     -- for s in 0 to S-1

      B_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

      -- DATA
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

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      D_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      U_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      V_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
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

  function function_matrix_controller_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return tensor_buffer;

  -----------------------------------------------------------------------
  -- Controller
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- CONVOLUTIONAL
  -----------------------------------------------------------------------

  function function_ntm_fnn_convolutional_controller (
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

  -----------------------------------------------------------------------
  -- STANDARD
  -----------------------------------------------------------------------

  function function_ntm_fnn_standard_controller (
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

  -----------------------------------------------------------------------
  -- Trainer
  -----------------------------------------------------------------------

  function function_ntm_fnn_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return tensor_buffer;

  function function_ntm_fnn_k_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return array4_buffer;

  function function_ntm_fnn_u_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return tensor_buffer;

  function function_ntm_fnn_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return tensor_buffer;

  function function_ntm_fnn_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return array4_buffer;

  function function_ntm_fnn_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return vector_buffer;

end ntm_fnn_controller_pkg;

package body ntm_fnn_controller_pkg is

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

  function function_matrix_controller_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return tensor_buffer is

    variable matrix_output : tensor_buffer;
  begin
    -- Data Inputs
    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
        for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          if (t = 0) then
            matrix_output(t, i, l) := std_logic_vector(to_float((to_real(to_float(matrix_input(t, i, l))) - to_real(to_float(matrix_input(t, i, l))))/to_real(to_float(LENGTH_IN))));
          else
            matrix_output(t, i, l) := std_logic_vector(to_float((to_real(to_float(matrix_input(t, i, l))) - to_real(to_float(matrix_input(t-1, i, l))))/to_real(to_float(LENGTH_IN))));
          end if;
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_matrix_controller_differentiation;

  -----------------------------------------------------------------------
  -- Controller
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- CONVOLUTIONAL
  -----------------------------------------------------------------------

  function function_ntm_fnn_convolutional_controller (
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

    -- h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(s;l)*xi(t;s) + U(l;l)*h(t-1;l) + b(t;l))

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
  end function function_ntm_fnn_convolutional_controller;

  -----------------------------------------------------------------------
  -- STANDARD
  -----------------------------------------------------------------------

  function function_ntm_fnn_standard_controller (
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

    -- h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + D(i;l;m)·rho(t;i;m) + V(l;s)·xi(t;s) + U(l;l)·h(t-1;l) + b(t;l))

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
  end function function_ntm_fnn_standard_controller;

  -----------------------------------------------------------------------
  -- Trainer
  -----------------------------------------------------------------------

  function function_ntm_fnn_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
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
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
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
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
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

  function function_ntm_fnn_v_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return tensor_buffer is

    variable vector_dh_int : matrix_buffer;

    variable matrix_v_output : tensor_buffer;

  begin

    -- dV(t;l;s) = summation(d*(t+1;l) · xi(t;s))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          matrix_v_output(t, l, s) := ZERO_DATA;
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
        for s in 0 to to_integer(unsigned(SIZE_S_IN))-1 loop
          matrix_v_output(t, l, s) := std_logic_vector(to_float(to_real(to_float(matrix_v_output(t, l, s))) + (to_real(to_float(vector_dh_int(t, l)))*to_real(to_float(vector_xi_input(t, s))))));
        end loop;
      end loop;
    end loop;

    return matrix_v_output;
  end function function_ntm_fnn_v_trainer;

  function function_ntm_fnn_d_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return array4_buffer is

    variable vector_dh_int : matrix_buffer;

    variable tensor_d_output : array4_buffer;

  begin

    -- dD(t;l;i;m) = summation(d*(t;l) · rho(t;i;m))[t in 0 to T-1]

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
          for m in 0 to to_integer(unsigned(SIZE_M_IN))-1 loop
            tensor_d_output(t, l, i, m) := ZERO_DATA;
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
          for m in 0 to to_integer(unsigned(SIZE_M_IN))-1 loop
            tensor_d_output(t, l, i, m) := std_logic_vector(to_float(to_real(to_float(tensor_d_output(t, l, i, m))) + (to_real(to_float(vector_dh_int(t, l)))*to_real(to_float(matrix_rho_input(t, i, m))))));
          end loop;
        end loop;
      end loop;
    end loop;

    return tensor_d_output;
  end function function_ntm_fnn_d_trainer;

  function function_ntm_fnn_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_S_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_M_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input   : matrix_buffer;
    matrix_r_input   : tensor_buffer;
    vector_xi_input  : matrix_buffer;
    matrix_rho_input : tensor_buffer;
    vector_h_input   : matrix_buffer
    ) return vector_buffer is

    variable vector_dh_int : matrix_buffer;

    variable vector_b_output : vector_buffer;

  begin

    -- db(l) = summation(d*(t;l))[t in 0 to T]

    vector_dh_int := function_vector_controller_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => LENGTH_IN,

      vector_input => vector_h_input
      );

    vector_b_output := function_vector_summation (
      SIZE_IN   => SIZE_L_IN,
      LENGTH_IN => SIZE_T_IN,

      vector_input => vector_dh_int
      );

    return vector_b_output;
  end function function_ntm_fnn_b_trainer;

end ntm_fnn_controller_pkg;
