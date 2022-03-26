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

function H_OUT = ntm_controller(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN, R_IN, XI_IN, RHO_IN)
  addpath(genpath('../../../math/algebra/matrix'));
  addpath(genpath('../../../math/algebra/tensor'));
  addpath(genpath('../../../math/function/vector'));

  [SIZE_R_IN, SIZE_L_IN, SIZE_W_IN] = size(K_IN);

  [SIZE_T_IN, SIZE_R_IN, SIZE_M_IN] = size(RHO_IN);

  r_int = zeros(SIZE_R_IN, SIZE_W_IN);

  rho_int = zeros(SIZE_R_IN, SIZE_M_IN);

  H_OUT = zeros(SIZE_T_IN, SIZE_L_IN);

  % h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(t))
  for t = 1:SIZE_T_IN
    if (t == 1)
      % h(t=0;l) = 0; h(t;l=0) = 0
      H_OUT(t, :) = zeros(SIZE_L_IN, 1);
    else
      % W(l;x)*x(t;x)
      vector_first_operation_int = ntm_matrix_vector_convolution(W_IN, X_IN(t, :));

      % K(i;l;k)*r(t;i;k)
      for i = 1:SIZE_R_IN
        for k = 1:SIZE_W_IN
          r_int(i, k) = R_IN(t, i, k);
        end
      end

      r_int = ntm_tensor_matrix_convolution(K_IN, r_int);

      for l = 1:SIZE_L_IN
        for i = 1:SIZE_R_IN
          vector_first_operation_int(l) = vector_first_operation_int(l) + r_int(i, l);
        end
      end

      % D(i;l;m)*rho(t;i;m)
      for i = 1:SIZE_R_IN
        for m = 1:SIZE_M_IN
          rho_int(i, m) = RHO_IN(t, i, m);
        end
      end

      rho_int = ntm_tensor_matrix_convolution(D_IN, rho_int);

      for l = 1:SIZE_L_IN
        for i = 1:SIZE_R_IN
          vector_first_operation_int(l) = vector_first_operation_int(l) + rho_int(i, l);
        end
      end

      % V(l;s)*xi(t;s)
      vector_second_operation_int = ntm_matrix_vector_convolution(V_IN, XI_IN(t, :));
      vector_second_operation_int = vector_second_operation_int + vector_first_operation_int;

      % U(l;l)*h(t-1;l)
      vector_first_operation_int = ntm_matrix_vector_convolution(U_IN, H_OUT(t-1, :));
      vector_first_operation_int = vector_first_operation_int + vector_second_operation_int;

      % b(t)
      vector_second_operation_int = vector_first_operation_int + B_IN;

      % sigmoid(.)
      H_OUT(t, :) = ntm_vector_logistic_function(vector_second_operation_int);
    end
  end
end