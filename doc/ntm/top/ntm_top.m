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

function Y_OUT = ntm_top(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN, K_OUTPUT_IN, U_OUTPUT_IN)
  % Package
  addpath(genpath('../../math/algebra/matrix'));
  addpath(genpath('../../math/algebra/tensor'));
  addpath(genpath('../../math/function/vector'));

  addpath(genpath('../../controller/FNN/standard'));

  addpath(genpath('../memory'));
  addpath(genpath('../read_heads'));
  addpath(genpath('../write_heads'));

  % Constants
  SIZE_T_IN = 3;
  SIZE_X_IN = 3;
  SIZE_Y_IN = 3;
  SIZE_N_IN = 3;
  SIZE_W_IN = 3;
  SIZE_L_IN = 3;
  SIZE_R_IN = 3;

  SIZE_M_IN = SIZE_N_IN + 3*SIZE_W_IN + 3;
  SIZE_S_IN = SIZE_N_IN + 3*SIZE_W_IN + 3;

  % Signals
  matrix_r_int = zeros(SIZE_R_IN, SIZE_W_IN);

  % Body
  for t = 1:SIZE_T_IN
    if (t == 1)
      vector_w_int = zeros(SIZE_N_IN, 1);

      vector_h_int = zeros(SIZE_L_IN, 1);

      matrix_m_int = zeros(SIZE_N_IN, SIZE_W_IN);
    else
      % INTERFACE VECTOR
      matrix_operation_int = ntm_matrix_transpose(V_IN);

      vector_xi_int = ntm_interface_vector(matrix_operation_int, vector_h_int);

      vector_e_int = vector_xi_int(SIZE_N_IN+2*SIZE_W_IN+4:SIZE_N_IN+3*SIZE_W_IN+3);
      vector_a_int = vector_xi_int(SIZE_N_IN+SIZE_W_IN+4:SIZE_N_IN+2*SIZE_W_IN+3);

      vector_k_int = vector_xi_int(SIZE_N_IN+4:SIZE_N_IN+SIZE_W_IN+3);
      scalar_beta_int = vector_xi_int(SIZE_N_IN+3);
      scalar_g_int = vector_xi_int(SIZE_N_IN+2);
      vector_s_int = vector_xi_int(2:SIZE_N_IN+1);
      scalar_gamma_int = vector_xi_int(1);

      % INTERFACE MATRIX
      tensor_operation_int = ntm_tensor_transpose(D_IN);

      matrix_rho_int = ntm_interface_matrix(tensor_operation_int, vector_h_int);

      matrix_e_int = matrix_rho_int(:, SIZE_N_IN+2*SIZE_W_IN+4:SIZE_N_IN+3*SIZE_W_IN+3);
      matrix_a_int = matrix_rho_int(:, SIZE_N_IN+SIZE_W_IN+4:SIZE_N_IN+2*SIZE_W_IN+3);

      matrix_k_int = matrix_rho_int(:, SIZE_N_IN+4:SIZE_N_IN+SIZE_W_IN+3);
      vector_beta_int = matrix_rho_int(:, SIZE_N_IN+3);
      vector_g_int = matrix_rho_int(:, SIZE_N_IN+2);
      matrix_s_int = matrix_rho_int(:, 2:SIZE_N_IN+1);
      vector_gamma_int = matrix_rho_int(:, 1);

      % WRITING
      matrix_m_int = ntm_writing(matrix_m_int, vector_w_int, vector_a_int);

      % ERASING
      matrix_m_int = ntm_erasing(matrix_m_int, vector_w_int, vector_e_int);

      % READING
      vector_r_int = ntm_reading(vector_w_int, matrix_m_int);
      
      for i = 1:SIZE_R_IN
        matrix_r_int(i, :) = vector_r_int;
      end

      % ADDRESSING
      vector_w_int = ntm_addressing(vector_k_int, scalar_beta_int, scalar_g_int, vector_s_int, scalar_gamma_int, matrix_m_int, vector_w_int);

      % CONTROLLER
      vector_h_int = ntm_controller(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN, matrix_r_int, vector_xi_int, matrix_rho_int, vector_h_int);

      % OUTPUT VECTOR
      Y_OUT = ntm_output_vector(K_OUTPUT_IN, matrix_r_int, U_OUTPUT_IN, vector_h_int);
    end
  end
end