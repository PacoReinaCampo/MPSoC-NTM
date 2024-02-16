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

python3 arithmetic/test_matrix_arithmetic.py
python3 arithmetic/test_scalar_arithmetic.py
python3 arithmetic/test_tensor_arithmetic.py
python3 arithmetic/test_vector_arithmetic.py

python3 math/algebra/test_matrix_algebra.py
python3 math/algebra/test_scalar_algebra.py
python3 math/algebra/test_tensor_algebra.py
python3 math/algebra/test_vector_algebra.py
python3 math/calculus/test_matrix_calculus.py
python3 math/calculus/test_tensor_calculus.py
python3 math/calculus/test_vector_calculus.py
python3 math/function/test_matrix_function.py
python3 math/function/test_scalar_function.py
python3 math/function/test_vector_function.py
python3 math/statitics/test_matrix_statitics.py
python3 math/statitics/test_scalar_statitics.py
python3 math/statitics/test_vector_statitics.py

python3 state/test_state_feedback.py
python3 state/test_state_outputs.py
python3 state/test_state_top.py

python3 controller/FNN/test_convolutional_fnn_controller.py
python3 controller/FNN/test_standard_fnn_controller.py
python3 controller/LSTM/test_convolutional_lstm_controller.py
python3 controller/LSTM/test_standard_lstm_controller.py

python3 ntm/test_ntm_memory.py
python3 ntm/test_ntm_read_heads.py
python3 ntm/test_ntm_top.py
python3 ntm/test_ntm_trained.py
python3 ntm/test_ntm_write_heads.py

python3 dnc/test_dnc_memory.py
python3 dnc/test_dnc_top.py
python3 dnc/test_dnc_trained.py

python3 transformer/test_transformer_components.py
python3 transformer/test_transformer_controller.py
python3 transformer/test_transformer_functions.py
python3 transformer/test_transformer_inputs.py
python3 transformer/test_transformer_top.py

python3 trainer/test_trainer_differentiation.py
python3 trainer/test_trainer_fnn.py
python3 trainer/test_trainer_lstm.py
