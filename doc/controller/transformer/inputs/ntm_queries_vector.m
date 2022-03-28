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

function Q_OUT = ntm_queries_vector(W_HQ_IN, W_IN, K_IN, V_IN, D_IN, X_IN, R_IN, XI_IN, RHO_IN)
  % Package
  addpath(genpath('../../../math/algebra/matrix'));
  
  % Constants
  [SIZE_N_IN, SIZE_R_IN, SIZE_W_IN] = size(R_IN);

  [SIZE_N_IN, SIZE_R_IN, SIZE_M_IN] = size(RHO_IN);

  [SIZE_D_IN, SIZE_N_IN] = size(W_HQ_IN);

  % Signals
  r_int = zeros(SIZE_N_IN, SIZE_R_IN, SIZE_W_IN);
  rho_int = zeros(SIZE_N_IN, SIZE_R_IN, SIZE_M_IN);

  x_int = zeros(SIZE_N_IN, SIZE_D_IN);

  Q_OUT = zeros(SIZE_N_IN, SIZE_D_IN);

  % Body
  % Q(n;d) = transpose(W(d;n))·x(n;d)

  % transpose(W(d;n))
  matrix_operation_int = ntm_matrix_transpose(W_HQ_IN);

  for n = 1:SIZE_N_IN
    for i = 1:SIZE_R_IN
      for k = 1:SIZE_W_IN
        r_int(i, k) = R_IN(n, i, k);
      end

      for m = 1:SIZE_M_IN
        rho_int(i, m) = RHO_IN(n, i, m);
      end
    end

    x_int(n, :) = ntm_inputs_vector(W_IN, K_IN, V_IN, D_IN, X_IN(n, :), r_int, XI_IN(n, :), rho_int);

    % transpose(W(d;n))·x(n;d)
    Q_OUT(n, :) = ntm_matrix_vector_product(matrix_operation_int, x_int(n, :));
  end
end