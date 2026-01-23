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

from matrix import accelerator_matrix_logistic_function as matrix_logistic_function
from matrix import accelerator_matrix_oneplus_function as matrix_oneplus_function
from matrix import accelerator_matrix_mean_function as matrix_mean
from matrix import accelerator_matrix_deviation_function as matrix_deviation

def test_matrix_logistic_function():

  data_in = np.random.rand(3,3)

  ones = np.ones(data_in.shape)

  np.testing.assert_array_equal(matrix_logistic_function.accelerator_matrix_logistic_function(data_in), ones/(ones + ones/np.exp(data_in)))

def test_matrix_oneplus_function():

  data_in = np.random.rand(3,3)

  ones = np.ones(data_in.shape)

  np.testing.assert_array_equal(matrix_oneplus_function.accelerator_matrix_oneplus_function(data_in), ones + np.log(ones + np.exp(data_in)))

def test_matrix_mean():

  data_in = np.random.rand(3,3,3)

  np.testing.assert_array_equal(matrix_mean.accelerator_matrix_mean_function(data_in), matrix_mean.accelerator_matrix_mean_function(data_in))

def test_matrix_deviation():

  data_in = np.random.rand(3,3,3)
  mean_in = np.zeros((3,3))

  np.testing.assert_array_equal(matrix_deviation.accelerator_matrix_deviation_function(data_in, mean_in), matrix_deviation.accelerator_matrix_deviation_function(data_in, mean_in))


test_matrix_logistic_function()
test_matrix_oneplus_function()
test_matrix_mean()
test_matrix_deviation()
