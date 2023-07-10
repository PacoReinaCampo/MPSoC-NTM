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

cd application/arithmetic/matrix; octave ntm_matrix_adder_test.m; cd ../../..
cd application/arithmetic/matrix; octave ntm_matrix_divider_test.m; cd ../../..
cd application/arithmetic/matrix; octave ntm_matrix_multiplier_test.m; cd ../../..
cd application/arithmetic/scalar; octave ntm_scalar_adder_test.m; cd ../../..
cd application/arithmetic/scalar; octave ntm_scalar_divider_test.m; cd ../../..
cd application/arithmetic/scalar; octave ntm_scalar_multiplier_test.m; cd ../../..
cd application/arithmetic/tensor; octave ntm_tensor_adder_test.m; cd ../../..
cd application/arithmetic/tensor; octave ntm_tensor_divider_test.m; cd ../../..
cd application/arithmetic/tensor; octave ntm_tensor_multiplier_test.m; cd ../../..
cd application/arithmetic/vector; octave ntm_vector_adder_test.m; cd ../../..
cd application/arithmetic/vector; octave ntm_vector_divider_test.m; cd ../../..
cd application/arithmetic/vector; octave ntm_vector_multiplier_test.m; cd ../../..

cd application/math/algebra/matrix; octave ntm_matrix_convolution_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_inverse_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_multiplication_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_product_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_summation_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_transpose_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_vector_convolution_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_matrix_vector_product_test.m; cd ../../../..
cd application/math/algebra/matrix; octave ntm_transpose_vector_product_test.m; cd ../../../..
cd application/math/algebra/scalar; octave ntm_scalar_multiplication_test.m; cd ../../../..
cd application/math/algebra/scalar; octave ntm_scalar_summation_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_convolution_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_inverse_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_matrix_convolution_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_matrix_product_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_multiplication_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_product_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_summation_test.m; cd ../../../..
cd application/math/algebra/tensor; octave ntm_tensor_transpose_test.m; cd ../../../..
cd application/math/algebra/vector; octave ntm_dot_product_test.m; cd ../../../..
cd application/math/algebra/vector; octave ntm_vector_convolution_test.m; cd ../../../..
cd application/math/algebra/vector; octave ntm_vector_cosine_similarity_test.m; cd ../../../..
cd application/math/algebra/vector; octave ntm_vector_module_test.m; cd ../../../..
cd application/math/algebra/vector; octave ntm_vector_multiplication_test.m; cd ../../../..
cd application/math/algebra/vector; octave ntm_vector_summation_test.m; cd ../../../..
cd application/math/calculus/matrix; octave ntm_matrix_differentiation_test.m; cd ../../../..
cd application/math/calculus/matrix; octave ntm_matrix_integration_test.m; cd ../../../..
cd application/math/calculus/matrix; octave ntm_matrix_softmax_test.m; cd ../../../..
cd application/math/calculus/tensor; octave ntm_tensor_differentiation_test.m; cd ../../../..
cd application/math/calculus/tensor; octave ntm_tensor_integration_test.m; cd ../../../..
cd application/math/calculus/tensor; octave ntm_tensor_softmax_test.m; cd ../../../..
cd application/math/calculus/vector; octave ntm_vector_differentiation_test.m; cd ../../../..
cd application/math/calculus/vector; octave ntm_vector_integration_test.m; cd ../../../..
cd application/math/calculus/vector; octave ntm_vector_softmax_test.m; cd ../../../..
cd application/math/function/matrix; octave ntm_matrix_logistic_function_test.m; cd ../../../..
cd application/math/function/matrix; octave ntm_matrix_oneplus_function_test.m; cd ../../../..
cd application/math/function/scalar; octave ntm_scalar_logistic_function_test.m; cd ../../../..
cd application/math/function/scalar; octave ntm_scalar_oneplus_function_test.m; cd ../../../..
cd application/math/function/vector; octave ntm_vector_logistic_function_test.m; cd ../../../..
cd application/math/function/vector; octave ntm_vector_oneplus_function_test.m; cd ../../../..
cd application/math/statitics/matrix; octave ntm_matrix_deviation_test.m; cd ../../../..
cd application/math/statitics/matrix; octave ntm_matrix_mean_test.m; cd ../../../..
cd application/math/statitics/scalar; octave ntm_scalar_deviation_test.m; cd ../../../..
cd application/math/statitics/scalar; octave ntm_scalar_mean_test.m; cd ../../../..
cd application/math/statitics/vector; octave ntm_vector_deviation_test.m; cd ../../../..
cd application/math/statitics/vector; octave ntm_vector_mean_test.m; cd ../../../..

cd application/state/feedback; octave ntm_state_matrix_feedforward_test.m; cd ../../..
cd application/state/feedback; octave ntm_state_matrix_input_test.m; cd ../../..
cd application/state/feedback; octave ntm_state_matrix_output_test.m; cd ../../..
cd application/state/feedback; octave ntm_state_matrix_state_test.m; cd ../../..
cd application/state/outputs; octave ntm_state_vector_output_test.m; cd ../../..
cd application/state/outputs; octave ntm_state_vector_state_test.m; cd ../../..
cd application/state/top; octave ntm_state_top_test.m; cd ../../..

cd application/controller/FNN/convolutional; octave ntm_controller_test.m; cd ../../../..
cd application/controller/FNN/standard; octave ntm_controller_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_activation_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_controller_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_forget_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_hidden_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_input_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_output_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/convolutional; octave ntm_state_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_activation_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_controller_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_forget_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_hidden_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_input_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_output_gate_vector_test.m; cd ../../../..
cd application/controller/LSTM/standard; octave ntm_state_gate_vector_test.m; cd ../../../..
cd application/transformer/components; octave ntm_masked_multi_head_attention_test.m; cd ../../../..
cd application/transformer/components; octave ntm_masked_scaled_dot_product_attention_test.m; cd ../../../..
cd application/transformer/components; octave ntm_multi_head_attention_test.m; cd ../../../..
cd application/transformer/components; octave ntm_scaled_dot_product_attention_test.m; cd ../../../..
cd application/transformer/fnn; octave ntm_fnn_test.m; cd ../../../..
cd application/transformer/functions; octave ntm_layer_norm_test.m; cd ../../../..
cd application/transformer/functions; octave ntm_positional_encoding_test.m; cd ../../../..
cd application/transformer/inputs; octave ntm_inputs_vector_test.m; cd ../../../..
cd application/transformer/inputs; octave ntm_keys_vector_test.m; cd ../../../..
cd application/transformer/inputs; octave ntm_queries_vector_test.m; cd ../../../..
cd application/transformer/inputs; octave ntm_values_vector_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_activation_gate_vector_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_forget_gate_vector_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_hidden_gate_vector_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_input_gate_vector_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_lstm_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_output_gate_vector_test.m; cd ../../../..
cd application/transformer/lstm; octave ntm_state_gate_vector_test.m; cd ../../../..
cd application/transformer/top; octave ntm_controller_test.m; cd ../../../..
cd application/transformer/top; octave ntm_decoder_test.m; cd ../../../..
cd application/transformer/top; octave ntm_encoder_test.m; cd ../../../..

cd application/ntm/memory; octave ntm_addressing_test.m; cd ../../..
cd application/ntm/memory; octave ntm_matrix_content_based_addressing_test.m; cd ../../..
cd application/ntm/memory; octave ntm_vector_content_based_addressing_test.m; cd ../../..
cd application/ntm/read_heads; octave ntm_reading_test.m; cd ../../..
cd application/ntm/top; octave ntm_interface_matrix_test.m; cd ../../..
cd application/ntm/top; octave ntm_interface_top_test.m; cd ../../..
cd application/ntm/top; octave ntm_interface_vector_test.m; cd ../../..
cd application/ntm/top; octave ntm_output_vector_test.m; cd ../../..
cd application/ntm/top; octave ntm_top_test.m; cd ../../..
#cd application/ntm/trained; octave ntm_trained_top_test.m; cd ../../..
cd application/ntm/write_heads; octave ntm_erasing_test.m; cd ../../..
cd application/ntm/write_heads; octave ntm_writing_test.m; cd ../../..

cd application/dnc/memory; octave dnc_addressing_test.m; cd ../../..
cd application/dnc/memory; octave dnc_allocation_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_backward_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_forward_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_matrix_content_based_addressing_test.m; cd ../../..
cd application/dnc/memory; octave dnc_memory_matrix_test.m; cd ../../..
cd application/dnc/memory; octave dnc_memory_retention_vector_test.m; cd ../../..
cd application/dnc/memory; octave dnc_precedence_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_read_content_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_read_vectors_test.m; cd ../../..
cd application/dnc/memory; octave dnc_read_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_sort_vector_test.m; cd ../../..
cd application/dnc/memory; octave dnc_temporal_link_matrix_test.m; cd ../../..
cd application/dnc/memory; octave dnc_usage_vector_test.m; cd ../../..
cd application/dnc/memory; octave dnc_vector_content_based_addressing_test.m; cd ../../..
cd application/dnc/memory; octave dnc_write_content_weighting_test.m; cd ../../..
cd application/dnc/memory; octave dnc_write_weighting_test.m; cd ../../..
cd application/dnc/top; octave dnc_interface_matrix_test.m; cd ../../..
cd application/dnc/top; octave dnc_interface_top_test.m; cd ../../..
cd application/dnc/top; octave dnc_interface_vector_test.m; cd ../../..
cd application/dnc/top; octave dnc_output_vector_test.m; cd ../../..
cd application/dnc/top; octave dnc_top_test.m; cd ../../..
#cd application/dnc/trained; octave dnc_trained_top_test.m; cd ../../..

cd application/trainer/differentiation; octave ntm_matrix_controller_differentiation_test.m; cd ../../..
cd application/trainer/differentiation; octave ntm_vector_controller_differentiation_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_b_trainer_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_d_trainer_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_k_trainer_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_trainer_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_u_trainer_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_v_trainer_test.m; cd ../../..
cd application/trainer/FNN; octave ntm_fnn_w_trainer_test.m; cd ../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_b_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_d_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_k_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_u_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_v_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/activation; octave ntm_lstm_activation_w_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_b_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_d_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_k_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_u_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_v_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/forget; octave ntm_lstm_forget_w_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_b_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_d_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_k_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_u_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_v_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/input; octave ntm_lstm_input_w_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_b_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_d_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_k_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_u_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_v_trainer_test.m; cd ../../../..
cd application/trainer/LSTM/output; octave ntm_lstm_output_w_trainer_test.m; cd ../../../..
