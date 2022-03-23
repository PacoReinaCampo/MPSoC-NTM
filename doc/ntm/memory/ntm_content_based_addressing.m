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

function C_OUT = ntm_content_based_addressing(K_IN, BETA_IN, M_IN)
  addpath(genpath('../../math/algebra/vector'));
  addpath(genpath('../../math/calculus/vector'));

  [SIZE_I_IN, SIZE_J_IN] = size(M_IN);

  vector_beta_int = zeros(SIZE_I_IN, 1);

  vector_i_operation_int = zeros(SIZE_I_IN, 1);
  vector_j_operation_int = zeros(SIZE_J_IN, 1);

  % C(M[i,·],k,beta)[i] = softmax(cosine_similarity(k,M[i,·])·beta)[i]

  for i = 1:SIZE_I_IN
    vector_beta_int(i) = BETA_IN;

    for j = 1:SIZE_J_IN
      vector_j_operation_int(j) = M_IN(i, j);
    end

    scalar_operation_int = ntm_vector_cosine_similarity(K_IN, vector_j_operation_int);

    vector_i_operation_int(i) = scalar_operation_int;
  end

  vector_i_operation_int = vector_i_operation_int.*vector_beta_int;

  C_OUT = ntm_vector_softmax(vector_i_operation_int);
end