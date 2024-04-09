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

from vector import ntm_dot_product as dot_product
from vector import ntm_vector_convolution as vector_convolution
from vector import ntm_vector_cosine_similarity as vector_cosine_similarity
from vector import ntm_vector_module as vector_module
from vector import ntm_vector_multiplication as vector_multiplication
from vector import ntm_vector_summation as vector_summation
from vector import ntm_vector_differentiation as vector_differentiation
from vector import ntm_vector_integration as vector_integration
from vector import ntm_vector_softmax as vector_softmax

def test_dot_product():

  data_a_in = np.random.rand(3,1)
  data_b_in = np.random.rand(3,1)

  np.testing.assert_array_equal(dot_product.ntm_dot_product(data_a_in, data_b_in), dot_product.ntm_dot_product(data_a_in, data_b_in))

def test_vector_convolution():
  
  data_a_in = np.random.rand(3,1)
  data_b_in = np.random.rand(3,1)

  np.testing.assert_array_equal(vector_convolution.ntm_vector_convolution(data_a_in, data_b_in), vector_convolution.ntm_vector_convolution(data_a_in, data_b_in))

def test_vector_cosine_similarity():

  data_a_in = np.random.rand(3,1)
  data_b_in = np.random.rand(3,1)

  np.testing.assert_array_equal(vector_cosine_similarity.ntm_vector_cosine_similarity(data_a_in, data_b_in), vector_cosine_similarity.ntm_vector_cosine_similarity(data_a_in, data_b_in))

def test_vector_module():

  data_in = np.random.rand(3,1)

  np.testing.assert_array_equal(vector_module.ntm_vector_module(data_in), vector_module.ntm_vector_module(data_in))

def test_vector_multiplication():

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(vector_multiplication.ntm_vector_multiplication(data_in), vector_multiplication.ntm_vector_multiplication(data_in))

def test_vector_summation():

  data_in = np.random.rand(3,3)

  np.testing.assert_array_equal(vector_summation.ntm_vector_summation(data_in), vector_summation.ntm_vector_summation(data_in))

def test_vector_differentiation():

  length_in = 1.0

  data_in = np.random.rand(3,1)

  np.testing.assert_array_equal(vector_differentiation.ntm_vector_differentiation(data_in, length_in), vector_differentiation.ntm_vector_differentiation(data_in, length_in))

def test_vector_integration():

  length_in = 1.0

  data_in = np.random.rand(3,1)

  np.testing.assert_array_equal(vector_integration.ntm_vector_integration(data_in, length_in), vector_integration.ntm_vector_integration(data_in, length_in))

def test_vector_softmax():

  data_in = np.random.rand(3,1)

  np.testing.assert_array_equal(vector_softmax.ntm_vector_softmax(data_in), vector_softmax.ntm_vector_softmax(data_in))


test_dot_product()
test_vector_convolution()
test_vector_cosine_similarity()
test_vector_module()
test_vector_multiplication()
test_vector_summation()
test_vector_differentiation()
test_vector_integration()
test_vector_softmax()
