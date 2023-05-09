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

python3 arithmetic/matrix/test_matrix_adder_test.py
python3 arithmetic/matrix/test_matrix_divider_test.py
python3 arithmetic/matrix/test_matrix_multiplier_test.py
python3 arithmetic/scalar/test_scalar_adder_test.py
python3 arithmetic/scalar/test_scalar_divider_test.py
python3 arithmetic/scalar/test_scalar_multiplier_test.py
python3 arithmetic/tensor/test_tensor_adder_test.py
python3 arithmetic/tensor/test_tensor_divider_test.py
python3 arithmetic/tensor/test_tensor_multiplier_test.py
python3 arithmetic/vector/test_vector_adder_test.py
python3 arithmetic/vector/test_vector_divider_test.py
python3 arithmetic/vector/test_vector_multiplier_test.py

python3 math/algebra/matrix/test_matrix_convolution_test.py
python3 math/algebra/matrix/test_matrix_inverse_test.py
python3 math/algebra/matrix/test_matrix_multiplication_test.py
python3 math/algebra/matrix/test_matrix_product_test.py
python3 math/algebra/matrix/test_matrix_summation_test.py
python3 math/algebra/matrix/test_matrix_transpose_test.py
python3 math/algebra/matrix/test_matrix_vector_convolution_test.py
python3 math/algebra/matrix/test_matrix_vector_product_test.py
python3 math/algebra/matrix/test_transpose_vector_product_test.py
python3 math/algebra/scalar/test_scalar_multiplication_test.py
python3 math/algebra/scalar/test_scalar_summation_test.py
python3 math/algebra/tensor/test_tensor_convolution_test.py
python3 math/algebra/tensor/test_tensor_inverse_test.py
python3 math/algebra/tensor/test_tensor_matrix_convolution_test.py
python3 math/algebra/tensor/test_tensor_matrix_product_test.py
python3 math/algebra/tensor/test_tensor_multiplication_test.py
python3 math/algebra/tensor/test_tensor_product_test.py
python3 math/algebra/tensor/test_tensor_summation_test.py
python3 math/algebra/tensor/test_tensor_transpose_test.py
python3 math/algebra/vector/test_dot_product_test.py
python3 math/algebra/vector/test_vector_convolution_test.py
python3 math/algebra/vector/test_vector_cosine_similarity_test.py
python3 math/algebra/vector/test_vector_module_test.py
python3 math/algebra/vector/test_vector_multiplication_test.py
python3 math/algebra/vector/test_vector_summation_test.py
python3 math/calculus/matrix/test_matrix_differentiation_test.py
python3 math/calculus/matrix/test_matrix_integration_test.py
python3 math/calculus/matrix/test_matrix_softmax_test.py
python3 math/calculus/tensor/test_tensor_differentiation_test.py
python3 math/calculus/tensor/test_tensor_integration_test.py
python3 math/calculus/tensor/test_tensor_softmax_test.py
python3 math/calculus/vector/test_vector_differentiation_test.py
python3 math/calculus/vector/test_vector_integration_test.py
python3 math/calculus/vector/test_vector_softmax_test.py
python3 math/function/matrix/test_matrix_logistic_function_test.py
python3 math/function/matrix/test_matrix_oneplus_function_test.py
python3 math/function/scalar/test_scalar_logistic_function_test.py
python3 math/function/scalar/test_scalar_oneplus_function_test.py
python3 math/function/vector/test_vector_logistic_function_test.py
python3 math/function/vector/test_vector_oneplus_function_test.py
python3 math/statitics/matrix/test_matrix_deviation_test.py
python3 math/statitics/matrix/test_matrix_mean_test.py
python3 math/statitics/scalar/test_scalar_deviation_test.py
python3 math/statitics/scalar/test_scalar_mean_test.py
python3 math/statitics/vector/test_vector_deviation_test.py
python3 math/statitics/vector/test_vector_mean_test.py

python3 state/feedback/test_state_matrix_feedforward_test.py
python3 state/feedback/test_state_matrix_input_test.py
python3 state/feedback/test_state_matrix_output_test.py
python3 state/feedback/test_state_matrix_state_test.py
python3 state/outputs/test_state_vector_output_test.py
python3 state/outputs/test_state_vector_state_test.py
python3 state/top/test_state_top_test.py

python3 controller/FNN/convolutional/test_controller_test.py
python3 controller/FNN/standard/test_controller_test.py
python3 controller/LSTM/convolutional/test_activation_gate_vector_test.py
python3 controller/LSTM/convolutional/test_controller_test.py
python3 controller/LSTM/convolutional/test_forget_gate_vector_test.py
python3 controller/LSTM/convolutional/test_hidden_gate_vector_test.py
python3 controller/LSTM/convolutional/test_input_gate_vector_test.py
python3 controller/LSTM/convolutional/test_output_gate_vector_test.py
python3 controller/LSTM/convolutional/test_state_gate_vector_test.py
python3 controller/LSTM/standard/test_activation_gate_vector_test.py
python3 controller/LSTM/standard/test_controller_test.py
python3 controller/LSTM/standard/test_forget_gate_vector_test.py
python3 controller/LSTM/standard/test_hidden_gate_vector_test.py
python3 controller/LSTM/standard/test_input_gate_vector_test.py
python3 controller/LSTM/standard/test_output_gate_vector_test.py
python3 controller/LSTM/standard/test_state_gate_vector_test.py
python3 controller/transformer/components/test_masked_multi_head_attention_test.py
python3 controller/transformer/components/test_masked_scaled_dot_product_attention_test.py
python3 controller/transformer/components/test_multi_head_attention_test.py
python3 controller/transformer/components/test_scaled_dot_product_attention_test.py
python3 controller/transformer/fnn/test_fnn_test.py
python3 controller/transformer/functions/test_layer_norm_test.py
python3 controller/transformer/functions/test_positional_encoding_test.py
python3 controller/transformer/inputs/test_inputs_vector_test.py
python3 controller/transformer/inputs/test_keys_vector_test.py
python3 controller/transformer/inputs/test_queries_vector_test.py
python3 controller/transformer/inputs/test_values_vector_test.py
python3 controller/transformer/lstm/test_activation_gate_vector_test.py
python3 controller/transformer/lstm/test_forget_gate_vector_test.py
python3 controller/transformer/lstm/test_hidden_gate_vector_test.py
python3 controller/transformer/lstm/test_input_gate_vector_test.py
python3 controller/transformer/lstm/test_lstm_test.py
python3 controller/transformer/lstm/test_output_gate_vector_test.py
python3 controller/transformer/lstm/test_state_gate_vector_test.py
python3 controller/transformer/top/test_controller_test.py
python3 controller/transformer/top/test_decoder_test.py
python3 controller/transformer/top/test_encoder_test.py

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
python3 trainer/FNN/test_fnn_b_trainer_test.py
python3 trainer/FNN/test_fnn_d_trainer_test.py
python3 trainer/FNN/test_fnn_k_trainer_test.py
python3 trainer/FNN/test_fnn_trainer_test.py
python3 trainer/FNN/test_fnn_u_trainer_test.py
python3 trainer/FNN/test_fnn_v_trainer_test.py
python3 trainer/FNN/test_fnn_w_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_b_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_d_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_k_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_u_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_v_trainer_test.py
python3 trainer/LSTM/activation/test_lstm_activation_w_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_b_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_d_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_k_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_u_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_v_trainer_test.py
python3 trainer/LSTM/forget/test_lstm_forget_w_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_b_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_d_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_k_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_u_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_v_trainer_test.py
python3 trainer/LSTM/input/test_lstm_input_w_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_b_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_d_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_k_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_u_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_v_trainer_test.py
python3 trainer/LSTM/output/test_lstm_output_w_trainer_test.py
