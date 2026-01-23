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
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

import numpy as np

def accelerator_tensor_inverse(data_in):

  m, n, p = data_in.shape

  matrix_in_int = np.zeros((n, p))
  tensor_in_int = np.zeros((m, n, 2*p))

  data_out = np.zeros((m, n, p))

  # Augmenting Identity Matrix of Order SIZE_IN
  for i in range(m):
    for j in range(n):
      for k in range(p):
        tensor_in_int[i][j][k] = data_in[i][j][k]

        if i == j and j == k and k == i:
          tensor_in_int[i][j][k + p] = 1
        else:
          tensor_in_int[i][j][k + p] = 0

  for i in range(m):
    # Row swapping
    u = 1

    while data_in[i][i][i] == 0:
      for j in range(n):
        for k in range(p):
          matrix_in_int[j][k] = tensor_in_int[i][j][k]

      if i < m - 1:
        for j in range(n):
          for k in range(p):
            tensor_in_int[i][j][k] = tensor_in_int[i + u][j][k]

        for j in range(n):
          for k in range(p):
            tensor_in_int[i + u][j][k] = matrix_in_int[j][k]
      else:
        for j in range(n):
          for k in range(p):
            tensor_in_int[i][j][k] = tensor_in_int[i - u][j][k]

        for j in range(n):
          for k in range(p):
            tensor_in_int[i - u][j][k] = matrix_in_int[j][k]

      u += 1

    # Applying Gauss Jordan Elimination
    for j in range(n):
      for k in range(p):
        if j != k:
          scalar_ratio_int = tensor_in_int[i][k][j] / tensor_in_int[i][j][j]

          for v in range(2*p):
            scalar_sum_int = scalar_ratio_int*tensor_in_int[i][j][v]

            tensor_in_int[i][j][v] -= scalar_sum_int

  # Row Operation to Make Principal Diagonal to 1
  for i in range(m):
    for j in range(n):
      for k in range(p, 2*p):
        tensor_in_int[i][j][k] = tensor_in_int[i][j][k] / tensor_in_int[i][i][i]

  # Output
  for i in range(m):
    for j in range(n):
      for k in range(p):
        data_out[i][j][k] = tensor_in_int[i][j][k + p]

  return data_out
