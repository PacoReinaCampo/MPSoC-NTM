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

function x_int = ntm_inputs_vector(W_IN, K_IN, V_IN, D_IN, X_IN, R_IN, XI_IN, RHO_IN)
  % Package
  addpath(genpath('../../../math/algebra/matrix'));
  addpath(genpath('../../../math/algebra/tensor'));

  % Constants
  [SIZE_R_IN, SIZE_D_IN, SIZE_W_IN] = size(K_IN);

  % Body
  % X(n;d) = W(d;x)·x(n;x) + K(i;d;k)·r(n;i;k) + D(i;d;m)·rho(n;i;m) + V(d;s)·xi(n;s)

  % W(d;x)·x(n;x)
  vector_operation_int = ntm_matrix_vector_product(W_IN, X_IN);

  % K(i;d;k)·r(n;i;k)
  matrix_operation_int = ntm_tensor_matrix_product(K_IN, R_IN);

  for d = 1:SIZE_D_IN
    for i = 1:SIZE_R_IN
      vector_operation_int(d) = vector_operation_int(d) + matrix_operation_int(i, d);
    end
  end

  % D(i;d;m)·rho(n;i;m)
  matrix_operation_int = ntm_tensor_matrix_product(D_IN, RHO_IN);

  for d = 1:SIZE_D_IN
    for i = 1:SIZE_R_IN
      vector_operation_int(d) = vector_operation_int(d) + matrix_operation_int(i, d);
    end
  end

  % V(d;s)·xi(n;s)
  x_int = ntm_matrix_vector_product(V_IN, XI_IN);

  x_int = x_int + vector_operation_int;
end