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
## Copyright (c) 2022-2023 by the author(s)                                      ##
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
##   Francisco Javier Reina Campo <frareicam@gmail.com>                          ##
##                                                                               ##
###################################################################################

function W_OUT = ntm_addressing(K_IN, BETA_IN, G_IN, S_IN, GAMMA_IN, M_IN, W_IN)
  [SIZE_N_IN, SIZE_W_IN] = size(M_IN);

  W_OUT = zeros(SIZE_W_IN, 1);

  # wc(t;j) = C(M(t;j;k),k(t;k),beta(t))
  W_OUT = ntm_content_based_addressing(K_IN, BETA_IN, M_IN);

  # wg(t;j) = g(t)·wc(t;j) + (1 - g(t))·w(t-1;j)

  # w(t;j) = wg(t;j)*s(t;k)

  # w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]

  data_summation_int = 0;

  for k = 1:SIZE_W_IN
    data_summation_int = data_summation_int + W_IN(k)^GAMMA_IN;
  endfor

  for j = 1:SIZE_N_IN
    for k = 1:SIZE_W_IN
      C_OUT(j) = exp(dot(K_IN, M_IN(j, :))*BETA_IN)/data_summation_int;
    endfor
  endfor

endfunction
