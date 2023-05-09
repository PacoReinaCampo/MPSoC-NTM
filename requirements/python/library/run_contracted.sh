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

python3 ntm/memory/test_addressing_test.py
python3 ntm/memory/test_matrix_content_based_addressing_test.py
python3 ntm/memory/test_vector_content_based_addressing_test.py
python3 ntm/read_heads/test_reading_test.py
python3 ntm/top/test_interface_matrix_test.py
python3 ntm/top/test_interface_top_test.py
python3 ntm/top/test_interface_vector_test.py
python3 ntm/top/test_output_vector_test.py
python3 ntm/top/test_top_test.py
python3 ntm/trained/test_trained_top_test.py
python3 ntm/write_heads/test_erasing_test.py
python3 ntm/write_heads/test_writing_test.py

python3 dnc/memory/dnc_addressing_test.py
python3 dnc/memory/dnc_allocation_weighting_test.py
python3 dnc/memory/dnc_backward_weighting_test.py
python3 dnc/memory/dnc_forward_weighting_test.py
python3 dnc/memory/dnc_matrix_content_based_addressing_test.py
python3 dnc/memory/dnc_memory_matrix_test.py
python3 dnc/memory/dnc_memory_retention_vector_test.py
python3 dnc/memory/dnc_precedence_weighting_test.py
python3 dnc/memory/dnc_read_content_weighting_test.py
python3 dnc/memory/dnc_read_vectors_test.py
python3 dnc/memory/dnc_read_weighting_test.py
python3 dnc/memory/dnc_sort_vector_test.py
python3 dnc/memory/dnc_temporal_link_matrix_test.py
python3 dnc/memory/dnc_usage_vector_test.py
python3 dnc/memory/dnc_vector_content_based_addressing_test.py
python3 dnc/memory/dnc_write_content_weighting_test.py
python3 dnc/memory/dnc_write_weighting_test.py
python3 dnc/top/dnc_interface_matrix_test.py
python3 dnc/top/dnc_interface_top_test.py
python3 dnc/top/dnc_interface_vector_test.py
python3 dnc/top/dnc_output_vector_test.py
python3 dnc/top/dnc_top_test.py
python3 dnc/trained/dnc_trained_top_test.py

python3 trainer/differentiation/test_matrix_controller_differentiation_test.py
python3 trainer/differentiation/test_vector_controller_differentiation_test.py
python3 trainer/FNN/test_fnn_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_trainer_test.py
