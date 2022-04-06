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

function W_OUT = ntm_addressing(K_IN, BETA_IN, G_IN, S_IN, GAMMA_IN, M_IN, W_IN)
  % Package
  addpath(genpath('../../math/algebra/vector'));

  % Constants
  SIZE_R_IN = length(GAMMA_IN);

  [SIZE_N_IN, SIZE_W_IN] = size(M_IN);

  % Signals
  W_OUT = zeros(SIZE_R_IN, SIZE_N_IN);

  % Body
  for i = 1:SIZE_R_IN
    % wc(t;j) = C(M(t;j;k),k(t;k),beta(t))
    vector_operation_int = ntm_content_based_addressing(K_IN(i, :), BETA_IN(i), M_IN);

    % wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)
    vector_operation_int = G_IN(i).*vector_operation_int + (1-G_IN(i)).*W_IN(i, :);

    % w(t;j) = wg(t;j)*s(t;k)
    vector_operation_int = ntm_vector_convolution(vector_operation_int, S_IN(i, :));

    % w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]
    data_summation_int = 0;

    for k = 1:SIZE_W_IN
      data_summation_int = data_summation_int + vector_operation_int(k)^GAMMA_IN(i);
    end

    for j = 1:SIZE_N_IN
      for k = 1:SIZE_W_IN
        W_OUT(i, j) = exp(dot(K_IN(i, :), M_IN(j, :))*BETA_IN(i))/data_summation_int;
      end
    end
  end
end