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

from matrix.adder import accelerator_matrix_adder as matrix_adder
from matrix.subtractor import accelerator_matrix_subtractor as matrix_subtractor
from matrix.multiplier import accelerator_matrix_multiplier as matrix_multiplier
from matrix.divider import accelerator_matrix_divider as matrix_divider

def test_matrix_adder():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_adder.accelerator_matrix_adder(data_a_in, data_b_in), data_a_in + data_b_in)

def test_matrix_subtractor():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_subtractor.accelerator_matrix_subtractor(data_a_in, data_b_in), data_a_in - data_b_in)

def test_matrix_multiplier():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_multiplier.accelerator_matrix_multiplier(data_a_in, data_b_in), data_a_in * data_b_in)

def test_matrix_divider():

  data_a_in = np.random.rand(3,3)
  data_b_in = np.random.rand(3,3)

  np.testing.assert_array_equal(matrix_divider.accelerator_matrix_divider(data_a_in, data_b_in), data_a_in / data_b_in)


test_matrix_adder()
test_matrix_subtractor()
test_matrix_multiplier()
test_matrix_divider()
