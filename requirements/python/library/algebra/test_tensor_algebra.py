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

from tensor import accelerator_tensor_convolution as tensor_convolution
from tensor import accelerator_tensor_inverse as tensor_inverse
from tensor import accelerator_tensor_matrix_convolution as tensor_matrix_convolution
from tensor import accelerator_tensor_matrix_product as tensor_matrix_product
from tensor import accelerator_tensor_multiplication as tensor_multiplication
from tensor import accelerator_tensor_product as tensor_product
from tensor import accelerator_tensor_summation as tensor_summation
from tensor import accelerator_tensor_transpose as tensor_transpose
from tensor import accelerator_tensor_differentiation as tensor_differentiation
from tensor import accelerator_tensor_integration as tensor_integration
from tensor import accelerator_tensor_softmax as tensor_softmax

def test_tensor_convolution():

  data_a_in = np.random.rand(3,3,3)
  data_b_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_convolution.accelerator_tensor_convolution(data_a_in, data_b_in), tensor_convolution.accelerator_tensor_convolution(data_a_in, data_b_in))

def test_tensor_inverse():

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_inverse.accelerator_tensor_inverse(data_in), tensor_inverse.accelerator_tensor_inverse(data_in))

def test_tensor_matrix_convolution():

  data_a_in = np.random.rand(3,3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(tensor_matrix_convolution.accelerator_tensor_matrix_convolution(data_a_in, data_b_in), tensor_matrix_convolution.accelerator_tensor_matrix_convolution(data_a_in, data_b_in))

def test_tensor_matrix_product():

  data_a_in = np.random.rand(3,3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(tensor_matrix_product.accelerator_tensor_matrix_product(data_a_in, data_b_in), tensor_matrix_product.accelerator_tensor_matrix_product(data_a_in, data_b_in))

def test_tensor_multiplication():

  data_in = np.random.rand(3,3,3,3)

  np.testing.assert_array_equal(tensor_multiplication.accelerator_tensor_multiplication(data_in), tensor_multiplication.accelerator_tensor_multiplication(data_in))

def test_tensor_product():

  data_a_in = np.random.rand(3,3,3)
  data_b_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_product.accelerator_tensor_product(data_a_in, data_b_in), tensor_product.accelerator_tensor_product(data_a_in, data_b_in))

def test_tensor_summation():

  data_in = np.random.rand(3,3,3,3)

  np.testing.assert_array_equal(tensor_summation.accelerator_tensor_summation(data_in), tensor_summation.accelerator_tensor_summation(data_in))

def test_tensor_transpose():

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_transpose.accelerator_tensor_transpose(data_in), tensor_transpose.accelerator_tensor_transpose(data_in))

def test_tensor_differentiation():

  control = 0

  length_i_in = 1.0
  length_j_in = 1.0
  length_k_in = 1.0

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_differentiation.accelerator_tensor_differentiation(data_in, length_i_in, length_j_in, length_k_in, control), tensor_differentiation.accelerator_tensor_differentiation(data_in, length_i_in, length_j_in, length_k_in, control))

def test_tensor_integration():

  length_in = 1.0

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_integration.accelerator_tensor_integration(data_in, length_in), tensor_integration.accelerator_tensor_integration(data_in, length_in))

def test_tensor_softmax():

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(tensor_softmax.accelerator_tensor_softmax(data_in), tensor_softmax.accelerator_tensor_softmax(data_in))


test_tensor_convolution()
test_tensor_inverse()
test_tensor_matrix_convolution()
test_tensor_matrix_product()
test_tensor_multiplication()
test_tensor_product()
test_tensor_summation()
test_tensor_transpose()
test_tensor_differentiation()
test_tensor_integration()
test_tensor_softmax()
