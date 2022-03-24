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

function R_OUT = dnc_addressing(K_READ_IN, BETA_READ_IN, F_READ_IN, PI_READ_IN, K_WRITE_IN, BETA_WRITE_IN, E_WRITE_IN, V_WRITE_IN, GA_WRITE_IN, GW_WRITE_IN)

  SIZE_R_IN = 3;
  SIZE_N_IN = 3;
  SIZE_W_IN = 3;

  % t=0;
  vector_w_int = rand(SIZE_N_IN, 1);
  matrix_w_int = rand(SIZE_R_IN, SIZE_N_IN);

  vector_p_in_int = rand(SIZE_N_IN, 1);
  matrix_l_in_int = rand(SIZE_N_IN, SIZE_N_IN);
  matrix_m_in_int = rand(SIZE_N_IN, SIZE_W_IN);

  % PRECEDENCE_WEIGHTING
  % p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
  % p(t=0) = 0
  vector_p_out_int = dnc_precedence_weighting(vector_w_int, vector_p_in_int);

  % TEMPORAL_LINK_MATRIX
  % L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
  % L(t=0)[g,j] = 0
  matrix_l_out_int = dnc_temporal_link_matrix(matrix_l_in_int, vector_w_int, vector_p_out_int);

  % BACKWARD_FORWARD_WEIGHTING
  % b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)
  matrix_b_int = dnc_backward_weighting(matrix_l_out_int, matrix_w_int);

  % f(t;i;j) = L(t;g;j)·w(t-1;i;j)
  matrix_f_int = dnc_forward_weighting(matrix_l_out_int, matrix_w_int);

  % MEMORY_RETENTION_VECTOR
  % psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]
  vector_psi_int = dnc_memory_retention_vector(F_READ_IN, matrix_w_int);

  % USAGE_VECTOR
  % u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)
  vector_u_out_int = dnc_usage_vector(vector_u_in_int, vector_w_int, vector_psi_int);

  % ALLOCATION_WEIGHTING
  % a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]
  vector_a_int = dnc_allocation_weighting(vector_u_out_int);

  % READ_WRITE_CONTENT_WEIGHTING
  % c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))
  matrix_c_int = dnc_read_content_weighting(K_READ_IN, matrix_m_in_int, BETA_READ_IN);

  % c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))
  vector_c_int = dnc_write_content_weighting(K_WRITE_IN, matrix_m_in_int, BETA_WRITE_IN);

  % READ_WRITE_WEIGHTING
  % w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)
  matrix_w_int = dnc_read_weighting(PI_READ_IN, matrix_b_int, matrix_c_int, matrix_f_int);

  % w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))
  vector_w_int = dnc_write_weighting(vector_a_int, vector_c_int, GA_WRITE_IN, GW_WRITE_IN);

  % MEMORY_MATRIX
  % M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))
  matrix_m_out_int = dnc_memory_matrix(matrix_m_in_int, vector_w_int, V_WRITE_IN, E_WRITE_IN);

  % READ_VECTORS
  % r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)
  R_OUT = dnc_read_vectors(matrix_m_out_int, matrix_w_int);
end