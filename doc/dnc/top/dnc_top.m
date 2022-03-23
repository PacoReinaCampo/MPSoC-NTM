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

function Y_OUT = dnc_top(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN)
  [SIZE_L_IN, SIZE_X_IN] = size(W_IN);
  [SIZE_R_IN, SIZE_Y_IN, SIZE_N_IN] = size(K_IN);

  % CONTROLLER_BODY_STATE
  vector_h_int = zeros(SIZE_L_IN, 1);



  % TRAINER_STATE



  % INTERFACE_VECTOR_STATE

  % xi(t;s) = U(t;s;l)·h(t;l)
  XI_OUT = dnc_interface_vector(V_IN, vector_h_int);



  % INTERFACE_MATRIX_STATE MATRIX

  % rho(t;i;m) = U(t;i;m;l)·h(t;i;l)
  matrix_h_int = zeros(SIZE_R_IN, SIZE_L_IN);

  for i = 1:SIZE_R_IN
    for l = 1:SIZE_L_IN
      matrix_h_int(i, l) = vector_h_int(l);
    end
  end

  RHO_OUT = dnc_interface_matrix(D_IN, matrix_h_int);



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



  % OUTPUT_VECTOR_STATE

  % y(t;y) = K(t;i;y;k)·r(t;i;k) + U(t;y;l)·h(t;l)
  Y_OUT = dnc_output_vector(K_IN, matrix_r_int, U_IN, vector_h_int);
end