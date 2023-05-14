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

java application/arithmetic/matrix/test_matrix_arithmetic.java
java application/arithmetic/scalar/test_scalar_arithmetic.java
java application/arithmetic/tensor/test_tensor_arithmetic.java
java application/arithmetic/vector/test_vector_arithmetic.java
java application/controller/FNN/convolutional/ntm_controller.java
java application/controller/FNN/standard/ntm_controller.java
java application/controller/LSTM/convolutional/ntm_controller.java
java application/controller/LSTM/standard/ntm_controller.java
java application/controller/transformer/components/ntm_components.java
java application/controller/transformer/fnn/ntm_fnn.java
java application/controller/transformer/functions/ntm_functions.java
java application/controller/transformer/inputs/ntm_inputs.java
java application/controller/transformer/lstm/ntm_lstm.java
java application/controller/transformer/top/ntm_controller.java
java application/dnc/memory/dnc_memory.java
java application/dnc/top/dnc_top.java
java application/dnc/trained/dnc_trained_top.java
java application/math/algebra/matrix/test_matrix_algebra.java
java application/math/algebra/scalar/test_scalar_algebra.java
java application/math/algebra/tensor/test_tensor_algebra.java
java application/math/algebra/vector/test_vector_algebra.java
java application/math/calculus/matrix/test_matrix_calculus.java
java application/math/calculus/tensor/test_tensor_calculus.java
java application/math/calculus/vector/test_vector_calculus.java
java application/math/function/matrix/test_matrix_function.java
java application/math/function/scalar/test_scalar_function.java
java application/math/function/vector/test_vector_function.java
java application/math/statitics/matrix/test_matrix_statitics.java
java application/math/statitics/scalar/test_scalar_statitics.java
java application/math/statitics/vector/test_vector_statitics.java
java application/ntm/memory/ntm_addressing.java
java application/ntm/read_heads/ntm_reading.java
java application/ntm/top/ntm_top.java
java application/ntm/trained/ntm_trained_top.java
java application/ntm/write_heads/ntm_write_heads.java
java application/state/feedback/test_state_feedback.java
java application/state/outputs/test_state_outputs.java
java application/state/top/test_state_top.java
java application/trainer/differentiation/ntm_controller_differentiation.java
java application/trainer/FNN/ntm_fnn_trainer.java
java application/trainer/LSTM/activation/ntm_lstm_activation_trainer.java
java application/trainer/LSTM/forget/ntm_lstm_forget_trainer.java
java application/trainer/LSTM/input/ntm_lstm_input_trainer.java
java application/trainer/LSTM/output/ntm_lstm_output_trainer.java
