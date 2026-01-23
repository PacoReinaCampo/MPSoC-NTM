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

from matrix import accelerator_matrix_convolution as matrix_convolution
from matrix import accelerator_matrix_inverse as matrix_inverse
from matrix import accelerator_matrix_multiplication as matrix_multiplication
from matrix import accelerator_matrix_product as matrix_product
from matrix import accelerator_matrix_summation as matrix_summation
from matrix import accelerator_matrix_transpose as matrix_transpose
from matrix import accelerator_matrix_vector_convolution as matrix_vector_convolution
from matrix import accelerator_matrix_vector_product as matrix_vector_product
from matrix import accelerator_transpose_vector_product as transpose_vector_product
from matrix import accelerator_matrix_differentiation as matrix_differentiation
from matrix import accelerator_matrix_integration as matrix_integration
from matrix import accelerator_matrix_softmax as matrix_softmax

def test_matrix_convolution():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_convolution.accelerator_matrix_convolution(data_a_in, data_b_in), matrix_convolution.accelerator_matrix_convolution(data_a_in, data_b_in))

def test_matrix_inverse():

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_inverse.accelerator_matrix_inverse(data_in), matrix_inverse.accelerator_matrix_inverse(data_in))

def test_matrix_multiplication():

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(matrix_multiplication.accelerator_matrix_multiplication(data_in), matrix_multiplication.accelerator_matrix_multiplication(data_in))

def test_matrix_product():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_product.accelerator_matrix_product(data_a_in, data_b_in), matrix_product.accelerator_matrix_product(data_a_in, data_b_in))

def test_matrix_summation():

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(matrix_summation.accelerator_matrix_summation(data_in), matrix_summation.accelerator_matrix_summation(data_in))

def test_matrix_transpose():

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_transpose.accelerator_matrix_transpose(data_in), matrix_transpose.accelerator_matrix_transpose(data_in))

def test_matrix_vector_convolution():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3)

  np.testing.assert_array_equal(matrix_vector_convolution.accelerator_matrix_vector_convolution(data_a_in, data_b_in), matrix_vector_convolution.accelerator_matrix_vector_convolution(data_a_in, data_b_in))

def test_matrix_vector_product():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3)

  np.testing.assert_array_equal(matrix_vector_product.accelerator_matrix_vector_product(data_a_in, data_b_in), matrix_vector_product.accelerator_matrix_vector_product(data_a_in, data_b_in))

def test_transpose_vector_product():

  data_a_in = np.random.rand(3)
  data_b_in = np.random.rand(3)

  np.testing.assert_array_equal(transpose_vector_product.accelerator_transpose_vector_product(data_a_in, data_b_in), transpose_vector_product.accelerator_transpose_vector_product(data_a_in, data_b_in))

def test_matrix_differentiation():

  control = 0

  length_i_in = 1.0
  length_j_in = 1.0

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_differentiation.accelerator_matrix_differentiation(data_in, length_i_in, length_j_in, control), matrix_differentiation.accelerator_matrix_differentiation(data_in, length_i_in, length_j_in, control))

def test_matrix_integration():

  length_in = 1.0

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_integration.accelerator_matrix_integration(data_in, length_in), matrix_integration.accelerator_matrix_integration(data_in, length_in))

def test_matrix_softmax():

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_softmax.accelerator_matrix_softmax(data_in), matrix_softmax.accelerator_matrix_softmax(data_in))


test_matrix_convolution()
test_matrix_inverse()
test_matrix_multiplication()
test_matrix_product()
test_matrix_summation()
test_matrix_transpose()
test_matrix_vector_convolution()
test_matrix_vector_product()
test_transpose_vector_product()
test_matrix_differentiation()
test_matrix_integration()
test_matrix_softmax()
