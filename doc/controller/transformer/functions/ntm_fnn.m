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

function H_OUT = ntm_fnn(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN, R_IN, XI_IN, RHO_IN)
  % Package
  addpath(genpath('../../../math/algebra/matrix'));
  addpath(genpath('../../../math/algebra/tensor'));
  addpath(genpath('../../../math/function/vector'));

  % Constants
  [SIZE_R_IN, SIZE_D_IN, SIZE_W_IN] = size(K_IN);

  [SIZE_N_IN, SIZE_R_IN, SIZE_M_IN] = size(RHO_IN);

  % Signals
  r_int = zeros(SIZE_R_IN, SIZE_W_IN);

  rho_int = zeros(SIZE_R_IN, SIZE_M_IN);

  H_OUT = zeros(SIZE_N_IN, SIZE_D_IN);

  % Body
  % h(n;d) = sigmoid(W(d;x)·x(n;x) + K(i;d;k)·r(n;i;k) + D(i;d;m)·rho(n;i;m) + V(d;s)·xi(n;s) + U(d;d)·h(n-1;d) + b(n))
  for n = 1:SIZE_N_IN
    if (n == 1)
      % h(n=0;d) = 0; h(n;d=0) = 0
      H_OUT(n, :) = zeros(SIZE_D_IN, 1);
    else
      % W(d;x)·x(n;x)
      vector_first_operation_int = ntm_matrix_vector_product(W_IN, X_IN(n, :));

      % K(i;d;k)·r(n;i;k)
      for i = 1:SIZE_R_IN
        for k = 1:SIZE_W_IN
          r_int(i, k) = R_IN(n, i, k);
        end
      end

      r_int = ntm_tensor_matrix_product(K_IN, r_int);

      for d = 1:SIZE_D_IN
        for i = 1:SIZE_R_IN
          vector_first_operation_int(d) = vector_first_operation_int(d) + r_int(i, d);
        end
      end

      % D(i;d;m)·rho(n;i;m)
      for i = 1:SIZE_R_IN
        for m = 1:SIZE_M_IN
          rho_int(i, m) = RHO_IN(n, i, m);
        end
      end

      rho_int = ntm_tensor_matrix_product(D_IN, rho_int);

      for d = 1:SIZE_D_IN
        for i = 1:SIZE_R_IN
          vector_first_operation_int(d) = vector_first_operation_int(d) + rho_int(i, d);
        end
      end

      % V(d;s)·xi(n;s)
      vector_second_operation_int = ntm_matrix_vector_product(V_IN, XI_IN(n, :));
      vector_second_operation_int = vector_second_operation_int + vector_first_operation_int;

      % U(d;d)·h(n-1;d)
      vector_first_operation_int = ntm_matrix_vector_product(U_IN, H_OUT(n-1, :));
      vector_first_operation_int = vector_first_operation_int + vector_second_operation_int;

      % b(n)
      vector_second_operation_int = vector_first_operation_int + B_IN;

      % sigmoid(.)
      H_OUT(n, :) = ntm_vector_logistic_function(vector_second_operation_int);
    end
  end
end