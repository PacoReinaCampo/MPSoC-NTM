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

from vector import ntm_vector_algebra as vector_algebra

def test_vector_algebra():

  data_a_in = np.random.rand(3,1)
  data_b_in = np.random.rand(3,1)

  data_in = np.random.rand(3,1)

  length_in = 1.0

  math_algebra = vector_algebra.VectorAlgebra(data_a_in, data_b_in, data_in, length_in)
  test_algebra = vector_algebra.VectorAlgebra(data_a_in, data_b_in, data_in, length_in)

  np.testing.assert_array_equal(math_algebra.ntm_dot_product(), test_algebra.ntm_dot_product())

  np.testing.assert_array_equal(math_algebra.ntm_vector_convolution(), test_algebra.ntm_vector_convolution())

  np.testing.assert_array_equal(math_algebra.ntm_vector_cosine_similarity(), test_algebra.ntm_vector_cosine_similarity())

  np.testing.assert_array_equal(math_algebra.ntm_vector_module(), test_algebra.ntm_vector_module())

  np.testing.assert_array_equal(math_algebra.ntm_vector_multiplication(), test_algebra.ntm_vector_multiplication())

  np.testing.assert_array_equal(math_algebra.ntm_vector_summation(), test_algebra.ntm_vector_summation())

  math_calculus = vector_algebra.VectorAlgebra(data_a_in, data_b_in, data_in, length_in)
  test_calculus = vector_algebra.VectorAlgebra(data_a_in, data_b_in, data_in, length_in)

  np.testing.assert_array_equal(math_calculus.ntm_vector_differentiation(), test_calculus.ntm_vector_differentiation())

  np.testing.assert_array_equal(math_calculus.ntm_vector_integration(), test_calculus.ntm_vector_integration())

  np.testing.assert_array_equal(math_calculus.ntm_vector_softmax(), test_calculus.ntm_vector_softmax())


test_vector_algebra()
