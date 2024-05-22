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

./application/arithmetic/scalar/scalar_arithmetic-x86.run

./application/arithmetic/vector/vector_arithmetic-x86.run

./application/arithmetic/matrix/matrix_arithmetic-x86.run

./application/arithmetic/tensor/tensor_arithmetic-x86.run


./application/math/scalar/scalar_math-x86.run

./application/math/vector/vector_math-x86.run

./application/math/matrix/matrix_math-x86.run


./application/algebra/scalar/scalar_algebra-x86.run

./application/algebra/vector/vector_algebra-x86.run

./application/algebra/matrix/matrix_algebra-x86.run

./application/algebra/tensor/tensor_algebra-x86.run


./application/state/top/state_top-x86.run

./application/state/outputs/state_outputs-x86.run

./application/state/feedback/state_feedback-x86.run


./application/nn/dnc/top/dnc_top-x86.run

./application/nn/ntm/top/ntm_top-x86.run

./application/nn/ann/inputs/ntm_inputs-x86.run

./application/nn/dnc/memory/dnc_memory-x86.run

./application/nn/ntm/read_heads/ntm_reading-x86.run

./application/nn/ann/functions/ntm_functions-x86.run

./application/nn/ann/components/ntm_components-x86.run

./application/nn/ann/top/ntm_controller-x86.run

./application/nn/dnc/read_heads/dnc_read_heads-x86.run

./application/nn/fnn/convolutional/ntm_controller-x86.run

./application/nn/fnn/standard/ntm_controller-x86.run

./application/nn/lstm/convolutional/ntm_controller-x86.run

./application/nn/lstm/standard/ntm_controller-x86.run

./application/nn/ntm/memory/ntm_addressing-x86.run

./application/nn/dnc/trained/dnc_trained_top-x86.run

./application/nn/dnc/write_heads/dnc_write_heads-x86.run

./application/nn/ntm/trained/ntm_trained_top-x86.run

./application/nn/ntm/write_heads/ntm_write_heads-x86.run

./application/nn/ann/controller/fnn/ntm_fnn-x86.run

./application/nn/ann/controller/lstm/ntm_lstm-x86.run


./application/trainer/fnn/ntm_fnn_trainer-x86.run

./application/trainer/differentiation/ntm_controller_differentiation-x86.run

./application/trainer/lstm/input/ntm_lstm_input_trainer-x86.run

./application/trainer/lstm/forget/ntm_lstm_forget_trainer-x86.run

./application/trainer/lstm/output/ntm_lstm_output_trainer-x86.run

./application/trainer/lstm/activation/ntm_lstm_activation_trainer-x86.run
