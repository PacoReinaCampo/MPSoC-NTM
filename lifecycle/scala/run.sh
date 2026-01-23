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
##              QueenField                                                       ##
##              Multi-Processor System on Chip                                   ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2022-2025 by the author(s)                                      ##
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

scala application/algebra/matrix/test_matrix_algebra.scala
scala application/algebra/scalar/test_scalar_algebra.scala
scala application/algebra/tensor/test_tensor_algebra.scala
scala application/algebra/vector/test_vector_algebra.scala
scala application/arithmetic/matrix/test_matrix_arithmetic.scala
scala application/arithmetic/scalar/test_scalar_arithmetic.scala
scala application/arithmetic/tensor/test_tensor_arithmetic.scala
scala application/arithmetic/vector/test_vector_arithmetic.scala
scala application/math/matrix/test_matrix_math.scala
scala application/math/scalar/test_scalar_math.scala
scala application/math/vector/test_vector_math.scala
scala application/nn/ann/components/accelerator_components.scala
scala application/nn/ann/controller/fnn/accelerator_fnn.scala
scala application/nn/ann/controller/lstm/accelerator_lstm.scala
scala application/nn/ann/functions/accelerator_functions.scala
scala application/nn/ann/inputs/accelerator_inputs.scala
scala application/nn/ann/top/accelerator_controller.scala
scala application/nn/dnc/memory/accelerator_memory.scala
scala application/nn/dnc/read_heads/accelerator_read_heads.scala
scala application/nn/dnc/top/accelerator_top.scala
scala application/nn/dnc/trained/accelerator_trained_top.scala
scala application/nn/dnc/write_heads/accelerator_write_heads.scala
scala application/nn/fnn/convolutional/accelerator_controller.scala
scala application/nn/fnn/standard/accelerator_controller.scala
scala application/nn/lstm/convolutional/accelerator_controller.scala
scala application/nn/lstm/standard/accelerator_controller.scala
scala application/nn/ntm/memory/accelerator_addressing.scala
scala application/nn/ntm/read_heads/accelerator_reading.scala
scala application/nn/ntm/top/accelerator_top.scala
scala application/nn/ntm/trained/accelerator_trained_top.scala
scala application/nn/ntm/write_heads/accelerator_write_heads.scala
scala application/state/feedback/test_state_feedback.scala
scala application/state/outputs/test_state_outputs.scala
scala application/state/top/test_state_top.scala
scala application/trainer/differentiation/accelerator_controller_differentiation.scala
scala application/trainer/fnn/accelerator_fnn_trainer.scala
scala application/trainer/lstm/activation/accelerator_lstm_activation_trainer.scala
scala application/trainer/lstm/forget/accelerator_lstm_forget_trainer.scala
scala application/trainer/lstm/input/accelerator_lstm_input_trainer.scala
scala application/trainer/lstm/output/accelerator_lstm_output_trainer.scala
