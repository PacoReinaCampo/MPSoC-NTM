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

function U_OUT = ntm_scaled_dot_product_attention(W_HQ_IN, W_HK_IN, W_HV_IN, W_IN, K_IN, V_IN, D_IN, X_IN, R_IN, XI_IN, RHO_IN)
  % Package
  addpath(genpath('../../../math/algebra/matrix'));

  addpath(genpath('../inputs'));

  % Constants
  [SIZE_D_IN, SIZE_K_IN] = size(W_HQ_IN);

  [SIZE_N_IN, SIZE_X_IN] = size(X_IN);

  % Body
  q_int = ntm_queries_vector(W_HQ_IN, W_IN, K_IN, V_IN, D_IN, X_IN, R_IN, XI_IN, RHO_IN);
  k_int = ntm_keys_vector(W_HK_IN, W_IN, K_IN, V_IN, D_IN, X_IN, R_IN, XI_IN, RHO_IN);

  matrix_operation_int = ntm_matrix_transpose(k_int);
  matrix_operation_int = ntm_matrix_product(q_int, matrix_operation_int);
  scalar_operation_int = sqrt(SIZE_K_IN);
  matrix_operation_int = matrix_operation_int/scalar_operation_int;

  v_int = ntm_values_vector(W_HV_IN, W_IN, K_IN, V_IN, D_IN, X_IN, R_IN, XI_IN, RHO_IN);

  U_OUT = zeros(SIZE_N_IN, SIZE_D_IN);
end