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

def ntm_matrix_inverse(data_in):

  m, n = data_in.shape

  vector_in_int = np.zeros(n)
  matrix_in_int = np.zeros((m, 2*n))

  data_out = np.zeros((m, n))

  # Augmenting Identity Matrix of Order SIZE_IN
  for i in range(m):
    for j in range(n):
      matrix_in_int[i][j] = data_in[i][j]

      if i == j:
        matrix_in_int[i][j + n] = 1
      else:
        matrix_in_int[i][j + n] = 0

  for i in range(m):
    # Row swapping
    u = 1

    while data_in[i][i] == 0:
      for j in range(n):
        vector_in_int[j] = matrix_in_int[i][j]

      if i < m - 1:
        for j in range(n):
          matrix_in_int[i][j] = matrix_in_int[i + u][j]

        for j in range(n):
          matrix_in_int[i + u][j] = vector_in_int[j]
      else:
        for j in range(n):
          matrix_in_int[i][j] = matrix_in_int[i - u][j]

        for j in range(n):
          matrix_in_int[i - u][j] = vector_in_int[j]

      u += 1

    # Applying Gauss Jordan Elimination
    for j in range(n):
      if i != j:
        scalar_ratio_int = matrix_in_int[j][i] / matrix_in_int[i][i]

        for v in range(2*n):
          scalar_sum_int = scalar_ratio_int*matrix_in_int[i][v]

          matrix_in_int[j][v] -= scalar_sum_int

  # Row Operation to Make Principal Diagonal to 1
  for i in range(m):
    for j in range(n, 2*n):
      matrix_in_int[i][j] = matrix_in_int[i][j] / matrix_in_int[i][i]

  # Output
  for i in range(m):
    for j in range(n):
      data_out[i][j] = matrix_in_int[i][j + n]

  return data_out
