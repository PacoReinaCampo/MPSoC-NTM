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

import numpy as np

def accelerator_interface_top(W_IN, K_IN, V_IN, D_IN, U_IN, B_IN, P_IN, Q_IN, X_IN):
  # Constants
  SIZE_R_IN, SIZE_Y_IN, SIZE_W_IN = P_IN.shape

  SIZE_T_IN, _ = X_IN.shape

  SIZE_L_IN = B_IN.shape

  SIZE_N_IN = 3

  # Output Signals
  Y_OUT = np.zeros((SIZE_T_IN, SIZE_Y_IN))

  # Body
  for t in range(len(SIZE_T_IN)):
    if (t == 1):
      H_OUT = zeros(SIZE_L_IN, 1)

      matrix_m_int = np.zeros((SIZE_N_IN, SIZE_W_IN))
      matrix_l_int = np.zeros((SIZE_N_IN, SIZE_N_IN))
      vector_p_int = np.zeros(SIZE_N_IN)
      vector_u_int = np.zeros(SIZE_N_IN)

      vector_w_int = np.zeros(SIZE_N_IN)
      matrix_w_int = np.zeros((SIZE_R_IN, SIZE_N_IN))
    else:
      # INTERFACE_VECTOR_STATE

      # xi(t;s) = U(s;l)·h(t;l)
      matrix_operation_int = accelerator_matrix_transpose(V_IN)

      XI_OUT = accelerator_interface_vector(matrix_operation_int, H_OUT)



      # INTERFACE_MATRIX_STATE MATRIX

      # rho(t;i;m) = U(i;m;l)·h(t;i;l)
      tensor_operation_int = accelerator_tensor_transpose(D_IN)

      RHO_OUT = accelerator_interface_matrix(tensor_operation_int, H_OUT)



      # READ_HEADS_STATE

      # FREE_GATES_STATE

      # f(t;i) = sigmoid(f^(t;i))
      f_read_int = RHO_OUT[:, SIZE_W_IN + 5]

      # READ_KEYS_STATE

      # k(t;i;k) = k^(t;i;k)
      k_read_int = RHO_OUT[:, 5:SIZE_W_IN + 4]

      # READ_MODES_STATE

      # pi(t;i;p) = softmax(pi^(t;i;p))
      pi_read_int = RHO_OUT[:, 2:4]

      # READ_STRENGTHS_STATE

      # beta(t;i) = oneplus(beta^(t;i))
      beta_read_int = RHO_OUT[:, 1]



      # WRITE_HEADS_STATE

      # ALLOCATION_GATE_STATE

      # ga(t) = sigmoid(g^(t))
      ga_write_int = XI_OUT(3*SIZE_W_IN + 3)

      # ERASE_VECTOR_STATE

      # e(t;k) = sigmoid(e^(t;k))
      e_write_int = XI_OUT[2*SIZE_W_IN + 3:3*SIZE_W_IN + 2]

      # WRITE_GATE_STATE

      # gw(t) = sigmoid(gw^(t))
      gw_write_int = XI_OUT[2*SIZE_W_IN + 2]

      # WRITE_KEY_STATE

      # k(t;k) = k^(t;k)
      k_write_int = XI_OUT[SIZE_W_IN + 2:2*SIZE_W_IN + 1]

      # WRITE_STRENGTH_STATE

      # beta(t) = oneplus(beta^(t))
      beta_write_int = XI_OUT[SIZE_W_IN + 1]

      # WRITE_VECTOR_STATE

      # v(t;k) = v^(t;k)
      v_write_int = XI_OUT[1:SIZE_W_IN]



      # MEMORY_STATE
      # MEMORY_RETENTION_VECTOR
      # psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]
      vector_psi_int = accelerator_memory_retention_vector(matrix_w_int, f_read_int)

      # USAGE_VECTOR
      # u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)
      vector_u_int = accelerator_usage_vector(vector_u_int, vector_w_int, vector_psi_int)

      # ALLOCATION_WEIGHTING
      # a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]
      vector_a_int = accelerator_allocation_weighting(vector_u_int)

      # WRITE_CONTENT_WEIGHTING
      # c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))
      vector_c_int = accelerator_write_content_weighting(k_write_int, beta_write_int, matrix_m_int)

      # WRITE_WEIGHTING
      # w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))
      vector_w_int = accelerator_write_weighting(vector_a_int, vector_c_int, ga_write_int, gw_write_int)

      # MEMORY_MATRIX
      # M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))
      matrix_m_int = accelerator_memory_matrix(matrix_m_int, vector_w_int, v_write_int, e_write_int)

      # PRECEDENCE_WEIGHTING
      # p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
      vector_p_int = accelerator_precedence_weighting(vector_w_int, vector_p_int)

      # TEMPORAL_LINK_MATRIX
      # L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
      matrix_l_int = accelerator_temporal_link_matrix(matrix_l_int, vector_w_int, vector_p_int)

      # FORWARD_WEIGHTING
      # f(t;i;j) = L(t;g;j)·w(t-1;i;j)
      matrix_f_int = accelerator_forward_weighting(matrix_l_int, matrix_w_int)

      # BACKWARD_WEIGHTING
      # b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)
      matrix_b_int = accelerator_backward_weighting(matrix_l_int, matrix_w_int)

      # READ_CONTENT_WEIGHTING
      # c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))
      matrix_c_int = accelerator_read_content_weighting(k_read_int, beta_read_int, matrix_m_int)

      # READ_WEIGHTING
      # w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)
      matrix_w_int = accelerator_read_weighting(pi_read_int, matrix_b_int, matrix_c_int, matrix_f_int)

      # READ_VECTORS
      # r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)
      R_OUT = accelerator_read_vectors(matrix_m_int, matrix_w_int)



      # CONTROLLER_BODY_STATE
      H_OUT = accelerator_controller(W_IN, K_IN, V_IN, D_IN, U_IN, B_IN, R_OUT, XI_OUT, RHO_OUT, H_OUT, X_IN[t, :])

      # OUTPUT_VECTOR_STATE

      # y(t;y) = P(i;y;k)·r(t;i;k) + Q(y;l)·h(t;l)
      Y_OUT[t, :] = accelerator_output_vector(P_IN, R_OUT, Q_IN, H_OUT)

  return Y_OUT, R_OUT, XI_OUT, RHO_OUT, H_OUT
