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

python3 -B arithmetic/test_scalar_arithmetic.py
python3 -B arithmetic/test_vector_arithmetic.py
python3 -B arithmetic/test_matrix_arithmetic.py
python3 -B arithmetic/test_tensor_arithmetic.py

python3 -B algebra/test_scalar_algebra.py
python3 -B algebra/test_vector_algebra.py
python3 -B algebra/test_matrix_algebra.py
python3 -B algebra/test_tensor_algebra.py

python3 -B math/test_scalar_math.py
python3 -B math/test_vector_math.py
python3 -B math/test_matrix_math.py

python3 -B state/test_state_feedback.py
python3 -B state/test_state_outputs.py
python3 -B state/test_state_top.py

python3 -B nn/fnn/test_convolutional_fnn_controller.py
python3 -B nn/fnn/test_standard_fnn_controller.py
python3 -B nn/lstm/test_convolutional_lstm_controller.py
python3 -B nn/lstm/test_standard_lstm_controller.py
python3 -B nn/ntm/test_ntm_memory.py
python3 -B nn/ntm/test_ntm_read_heads.py
python3 -B nn/ntm/test_ntm_top.py
python3 -B nn/ntm/test_ntm_trained.py
python3 -B nn/ntm/test_ntm_write_heads.py
python3 -B nn/dnc/test_dnc_memory.py
python3 -B nn/dnc/test_dnc_read_heads.py
python3 -B nn/dnc/test_dnc_top.py
python3 -B nn/dnc/test_dnc_trained.py
python3 -B nn/dnc/test_dnc_write_heads.py
python3 -B nn/ann/test_ann_components.py
python3 -B nn/ann/test_ann_controller.py
python3 -B nn/ann/test_ann_functions.py
python3 -B nn/ann/test_ann_inputs.py
python3 -B nn/ann/test_ann_top.py

python3 -B trainer/test_trainer_differentiation.py
python3 -B trainer/test_trainer_fnn.py
python3 -B trainer/test_trainer_lstm.py
