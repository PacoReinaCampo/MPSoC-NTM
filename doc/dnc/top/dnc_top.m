%{
###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Peripheral-NTM for MPSoC                                         ##
##              Neural Turing Machine for MPSoC                                  ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2020-2024 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################
%}

function Y_OUT = dnc_top(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN, K_OUTPUT_IN, U_OUTPUT_IN)
  % Package
  addpath(genpath('../../controller/FNN/standard'));

  addpath(genpath('../memory'));

  % Constants
  SIZE_T_IN = 3;
  SIZE_X_IN = 3;
  SIZE_Y_IN = 3;
  SIZE_N_IN = 3;
  SIZE_W_IN = 3;
  SIZE_L_IN = 3;
  SIZE_R_IN = 3;

  % Body
  for t = 1:SIZE_T_IN
    if (t == 1)
      vector_w_int = zeros(SIZE_N_IN, 1);

      vector_h_int = zeros(SIZE_L_IN, 1);

      matrix_m_int = zeros(SIZE_N_IN, SIZE_W_IN);
    else
      % TRAINER_STATE

      % INTERFACE_VECTOR_STATE

      % xi(t;s) = U(t;s;l)·h(t;l)
      vector_xi_int = dnc_interface_vector(V_IN, vector_h_int);

      % INTERFACE_MATRIX_STATE MATRIX

      % rho(t;i;m) = U(t;i;m;l)·h(t;i;l)
      matrix_rho_int = dnc_interface_matrix(D_IN, vector_h_int);

      % READ_HEADS_STATE

      % FREE_GATES_STATE

      % f(t;i) = sigmoid(f^(t;i))

      % READ_KEYS_STATE

      % k(t;i;k) = k^(t;i;k)

      % READ_MODES_STATE

      % pi(t;i;p) = softmax(pi^(t;i;p))

      % READ_STRENGTHS_STATE

      % beta(t;i) = oneplus(beta^(t;i))

      % WRITE_HEADS_STATE

      % ALLOCATION_GATE_STATE

      % ga(t) = sigmoid(g^(t))

      % ERASE_VECTOR_STATE

      % e(t;k) = sigmoid(e^(t;k))

      % WRITE_GATE_STATE

      % gw(t) = sigmoid(gw^(t))

      % WRITE_KEY_STATE

      % k(t;k) = k^(t;k)

      % WRITE_STRENGTH_STATE

      % beta(t) = oneplus(beta^(t))

      % WRITE_VECTOR_STATE

      % v(t;k) = v^(t;k)

      % MEMORY_STATE
      K_READ_IN = rand(SIZE_T_IN, SIZE_R_IN, SIZE_W_IN);
      BETA_READ_IN = rand(SIZE_T_IN, SIZE_R_IN);
      F_READ_IN = rand(SIZE_T_IN, SIZE_R_IN);
      PI_READ_IN = rand(SIZE_T_IN, SIZE_R_IN, 3);

      K_WRITE_IN = rand(SIZE_T_IN, SIZE_W_IN);
      BETA_WRITE_IN = rand(SIZE_T_IN, 1);
      E_WRITE_IN = rand(SIZE_T_IN, SIZE_W_IN);
      V_WRITE_IN = rand(SIZE_T_IN, SIZE_W_IN);
      GA_WRITE_IN = rand(SIZE_T_IN, 1);
      GW_WRITE_IN = rand(SIZE_T_IN, 1);

      matrix_r_int = dnc_addressing(K_READ_IN, BETA_READ_IN, F_READ_IN, PI_READ_IN, K_WRITE_IN, BETA_WRITE_IN, E_WRITE_IN, V_WRITE_IN, GA_WRITE_IN, GW_WRITE_IN);

      % CONTROLLER_BODY_STATE
      vector_h_int = ntm_controller(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN, matrix_r_int, vector_xi_int, matrix_rho_int, vector_h_int);

      % OUTPUT_VECTOR_STATE

      % y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)
      Y_OUT = dnc_output_vector(K_IN, matrix_r_int, U_IN, vector_h_int);
    end
  end
end