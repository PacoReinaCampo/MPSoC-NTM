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

from tensor import accelerator_tensor_algebra as tensor_algebra

def test_tensor_algebra():

  tensor_data_a_in = np.random.rand(3,3,3)
  tensor_data_b_in = np.random.rand(3,3,3)

  matrix_data_a_in = np.random.rand(3,3)
  matrix_data_b_in = np.random.rand(3,3)

  tensor_data_in = np.random.rand(3,3,3)
  array4_data_in = np.random.rand(3,3,3,3)

  data_in = np.random.rand(3,3,3)

  length_in = 1.0

  length_i_in = 1.0
  length_j_in = 1.0
  length_k_in = 1.0

  control = 0

  math_algebra = tensor_algebra.TensorAlgebra(tensor_data_a_in, tensor_data_b_in, matrix_data_a_in, matrix_data_b_in, tensor_data_in, array4_data_in, data_in, length_in, length_i_in, length_j_in, length_k_in, control)
  test_algebra = tensor_algebra.TensorAlgebra(tensor_data_a_in, tensor_data_b_in, matrix_data_a_in, matrix_data_b_in, tensor_data_in, array4_data_in, data_in, length_in, length_i_in, length_j_in, length_k_in, control)

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_convolution(), test_algebra.accelerator_tensor_convolution())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_inverse(), test_algebra.accelerator_tensor_inverse())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_matrix_convolution(), test_algebra.accelerator_tensor_matrix_convolution())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_matrix_product(), test_algebra.accelerator_tensor_matrix_product())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_multiplication(), test_algebra.accelerator_tensor_multiplication())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_product(), test_algebra.accelerator_tensor_product())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_summation(), test_algebra.accelerator_tensor_summation())

  np.testing.assert_array_equal(math_algebra.accelerator_tensor_transpose(), test_algebra.accelerator_tensor_transpose())

  math_calculus = tensor_algebra.TensorAlgebra(tensor_data_a_in, tensor_data_b_in, matrix_data_a_in, matrix_data_b_in, tensor_data_in, array4_data_in, data_in, length_in, length_i_in, length_j_in, length_k_in, control)
  test_calculus = tensor_algebra.TensorAlgebra(tensor_data_a_in, tensor_data_b_in, matrix_data_a_in, matrix_data_b_in, tensor_data_in, array4_data_in, data_in, length_in, length_i_in, length_j_in, length_k_in, control)

  np.testing.assert_array_equal(math_calculus.accelerator_tensor_differentiation(), test_calculus.accelerator_tensor_differentiation())

  np.testing.assert_array_equal(math_calculus.accelerator_tensor_integration(), test_calculus.accelerator_tensor_integration())

  np.testing.assert_array_equal(math_calculus.accelerator_tensor_softmax(), test_calculus.accelerator_tensor_softmax())


test_tensor_algebra()
