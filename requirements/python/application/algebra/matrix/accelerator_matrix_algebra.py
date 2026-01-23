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

class MatrixAlgebra:
  def __init__(self, matrix_data_a_in, matrix_data_b_in, vector_data_a_in, vector_data_b_in, matrix_data_in, tensor_data_in, data_in, length_in, length_i_in, length_j_in, control):
    self.matrix_data_a_in = matrix_data_a_in
    self.matrix_data_b_in = matrix_data_b_in

    self.vector_data_a_in = vector_data_a_in
    self.vector_data_b_in = vector_data_b_in

    self.matrix_data_in = matrix_data_in
    self.tensor_data_in = tensor_data_in

    self.data_in = data_in

    self.length_in = length_in

    self.length_i_in = length_i_in
    self.length_j_in = length_j_in

    self.control = control

  def accelerator_matrix_convolution(self):

    a_in = np.array(self.matrix_data_a_in)
    b_in = np.array(self.matrix_data_b_in)

    data_out = []

    # calculating convolution
    for i in range(len(self.matrix_data_a_in)):
      data_out.append([])
      for j in range(len(self.matrix_data_b_in[i])):
        temporal = 0.0

        for m in range(i):
          for n in range(j):
            temporal += a_in[m][n] * b_in[i-m][j-n]

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_inverse(self):

    m, n = self.data_in.shape

    vector_in_int = np.zeros(n)
    matrix_in_int = np.zeros((m, 2*n))

    data_out = np.zeros((m, n))

    # Augmenting Identity Matrix of Order SIZE_IN
    for i in range(m):
      for j in range(n):
        matrix_in_int[i][j] = self.data_in[i][j]

        if i == j:
          matrix_in_int[i][j + n] = 1
        else:
          matrix_in_int[i][j + n] = 0

    for i in range(m):
      # Row swapping
      u = 1

      while self.data_in[i][i] == 0:
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

  def accelerator_matrix_multiplication(self):

    data_out = []

    # calculating summation
    for i in range(len(self.tensor_data_in)):
      data_out.append([])

      for j in range(len(self.tensor_data_in[i])):
        temporal = 1.0

        for k in range(len(self.tensor_data_in[i][j])):
          temporal *= self.tensor_data_in[i][j][k]

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_product(self):

    a_in = np.array(self.matrix_data_a_in)
    b_in = np.array(self.matrix_data_b_in)

    data_out = []

    # calculating product
    for i in range(len(self.matrix_data_a_in)):
      data_out.append([])
      for j in range(len(self.matrix_data_b_in[i])):
        temporal = 0.0

        for m in range(len(self.matrix_data_a_in[i])):
          temporal += a_in[i][m] * b_in[m][j]

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_summation(self):

    data_out = []

    # calculating summation
    for i in range(len(self.tensor_data_in)):
      data_out.append([])

      for j in range(len(self.tensor_data_in[i])):
        temporal = 0.0

        for k in range(len(self.tensor_data_in[i][j])):
          temporal += self.tensor_data_in[i][j][k]

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_transpose(self):

    data_out = []

    # calculating transpose
    for i in range(len(self.matrix_data_in)):
      data_out.append([])
      for j in range(len(self.matrix_data_in[i])):
        data_out[i].append(self.matrix_data_in[j][i])

    return data_out

  def accelerator_matrix_vector_convolution(self):

    a_in = np.array(self.matrix_data_a_in)
    b_in = np.array(self.vector_data_b_in)

    data_out = []

    # calculating convolution
    for i in range(len(self.matrix_data_a_in)):
      data_out.append([])
      for j in range(len(self.matrix_data_a_in[i])):
        temporal = 0.0

        for m in range(i):
          for n in range(j):
            temporal += a_in[m][n] * b_in[i-m]

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_vector_product(self):

    a_in = np.array(self.matrix_data_a_in)
    b_in = np.array(self.vector_data_b_in)

    data_out = []

    # calculating product
    for i in range(len(self.matrix_data_a_in)):
      data_out.append([])
      for j in range(len(self.matrix_data_a_in[i])):
        temporal = 0.0

        for m in range(len(self.vector_data_b_in)):
          temporal += a_in[i][m] * b_in[m]

        data_out[i].append(temporal)

    return data_out
  
  def accelerator_transpose_vector_product(self):

    a_in = np.array(self.vector_data_a_in)
    b_in = np.array(self.vector_data_b_in)

    data_out = []

    # calculating product
    for i in range(len(self.vector_data_a_in)):
      data_out.append([])
      for j in range(len(self.vector_data_b_in)):
        temporal = a_in[i] * b_in[j]

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_differentiation(self):
    temporal = 0.0

    data_out = []

    # calculating differentiation
    for i in range(len(self.data_in)):
      data_out.append([])
      for j in range(len(self.data_in[i])):
        if self.control == 0:
          temporal = (self.data_in[i][j] - self.data_in[i-1][j])/self.length_i_in
        else:
          temporal = (self.data_in[i][j] - self.data_in[i][j-1])/self.length_j_in

        data_out[i].append(temporal)

    return data_out

  def accelerator_matrix_integration(self):
    temporal = 0.0

    data_out = []

    # calculating integration
    for i in range(len(self.data_in)):
      data_out.append([])
      for j in range(len(self.data_in[i])):
        temporal += self.data_in[i][j]

        data_out[i].append(temporal*self.length_in)

    return data_out

  def accelerator_matrix_softmax(self):
    temporal0 = 0.0
    temporal1 = 0.0

    inputs = np.array(self.data_in)

    data_int = []

    data_out = []

    # calculating softmax
    for i in range(len(self.data_in)):
      data_int.append([])
      data_out.append([])
      for j in range(len(self.data_in[i])):
        temporal0 += np.exp(self.data_in[i][j])

        temporal1 = np.exp(self.data_in[i][j])

        data_int[i].append(temporal1)

      for j in range(len(self.data_in[i])):
        data_out[i].append(data_int[i][j]/temporal0)

    return data_out
