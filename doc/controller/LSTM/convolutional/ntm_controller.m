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

  [SIZE_R_IN, SIZE_L_IN, SIZE_W_IN] = size(K_IN);

  [SIZE_T_IN, SIZE_R_IN, SIZE_M_IN] = size(RHO_IN);

  vector_a_int = zeros(SIZE_T_IN, SIZE_L_IN);
  vector_f_int = zeros(SIZE_T_IN, SIZE_L_IN);
  vector_i_int = zeros(SIZE_T_IN, SIZE_L_IN);
  vector_o_int = zeros(SIZE_T_IN, SIZE_L_IN);

  vector_s_int = zeros(SIZE_T_IN, SIZE_L_IN);

  r_int = zeros(SIZE_T_IN, SIZE_R_IN, SIZE_W_IN);
  rho_int = zeros(SIZE_T_IN, SIZE_R_IN, SIZE_M_IN);

  H_OUT = zeros(SIZE_T_IN, SIZE_L_IN);

  for t = 1:SIZE_T_IN
    if (t == 1)
      % h(t=0;l) = 0; h(t;l=0) = 0
      H_OUT(t, :) = zeros(SIZE_L_IN, 1);

      % s(t=0;l) = 0
      vector_s_int(t, :) = zeros(SIZE_L_IN, 1);
    else
      for i = 1:SIZE_R_IN
        for k = 1:SIZE_W_IN
          r_int(i, k) = R_IN(t, i, k);
        end

        for m = 1:SIZE_M_IN
          rho_int(i, m) = RHO_IN(t, i, m);
        end
      end

      % a(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
      vector_a_int(t, :) = ntm_activation_gate_vector(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN(t, :), r_int, XI_IN(t, :), rho_int, H_OUT(t-1, :));

      % f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
      vector_f_int(t, :) = ntm_forget_gate_vector(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN(t, :), r_int, XI_IN(t, :), rho_int, H_OUT(t-1, :));

      % i(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
      vector_i_int(t, :) = ntm_input_gate_vector(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN(t, :), r_int, XI_IN(t, :), rho_int, H_OUT(t-1, :));

      % s(t;l) = f(t;l) o s(t-1,l) + i(t;l) o a(t;l)
      vector_s_int(t, :) = ntm_state_gate_vector(vector_s_int(t-1, :), vector_i_int(t, :), vector_f_int(t, :), vector_a_int(t, :));

      % o(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
      vector_o_int(t, :) = ntm_output_gate_vector(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN(t, :), r_int, XI_IN(t, :), rho_int, H_OUT(t-1, :));

      % h(t;l) = o(t;l) o tanh(s(t;l))
      H_OUT(t, :) = ntm_hidden_gate_vector(vector_s_int(t, :), vector_o_int(t, :));
    end
  end
end