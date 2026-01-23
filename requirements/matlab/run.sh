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

cd application/arithmetic/matrix; octave accelerator_matrix_adder_test.m; cd ../../..
cd application/arithmetic/matrix; octave accelerator_matrix_divider_test.m; cd ../../..
cd application/arithmetic/matrix; octave accelerator_matrix_multiplier_test.m; cd ../../..
cd application/arithmetic/scalar; octave accelerator_scalar_adder_test.m; cd ../../..
cd application/arithmetic/scalar; octave accelerator_scalar_divider_test.m; cd ../../..
cd application/arithmetic/scalar; octave accelerator_scalar_multiplier_test.m; cd ../../..
cd application/arithmetic/tensor; octave accelerator_tensor_adder_test.m; cd ../../..
cd application/arithmetic/tensor; octave accelerator_tensor_divider_test.m; cd ../../..
cd application/arithmetic/tensor; octave accelerator_tensor_multiplier_test.m; cd ../../..
cd application/arithmetic/vector; octave accelerator_vector_adder_test.m; cd ../../..
cd application/arithmetic/vector; octave accelerator_vector_divider_test.m; cd ../../..
cd application/arithmetic/vector; octave accelerator_vector_multiplier_test.m; cd ../../..

cd application/algebra/matrix; octave accelerator_matrix_convolution_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_inverse_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_multiplication_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_product_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_summation_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_transpose_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_vector_convolution_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_vector_product_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_transpose_vector_product_test.m; cd ../../..
cd application/algebra/scalar; octave accelerator_scalar_multiplication_test.m; cd ../../..
cd application/algebra/scalar; octave accelerator_scalar_summation_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_convolution_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_inverse_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_matrix_convolution_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_matrix_product_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_multiplication_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_product_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_summation_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_transpose_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_dot_product_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_convolution_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_cosine_similarity_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_module_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_multiplication_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_summation_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_differentiation_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_integration_test.m; cd ../../..
cd application/algebra/matrix; octave accelerator_matrix_softmax_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_differentiation_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_integration_test.m; cd ../../..
cd application/algebra/tensor; octave accelerator_tensor_softmax_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_differentiation_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_integration_test.m; cd ../../..
cd application/algebra/vector; octave accelerator_vector_softmax_test.m; cd ../../..

cd application/math/matrix; octave accelerator_matrix_logistic_function_test.m; cd ../../..
cd application/math/matrix; octave accelerator_matrix_oneplus_function_test.m; cd ../../..
cd application/math/scalar; octave accelerator_scalar_logistic_function_test.m; cd ../../..
cd application/math/scalar; octave accelerator_scalar_oneplus_function_test.m; cd ../../..
cd application/math/vector; octave accelerator_vector_logistic_function_test.m; cd ../../..
cd application/math/vector; octave accelerator_vector_oneplus_function_test.m; cd ../../..
cd application/math/matrix; octave accelerator_matrix_deviation_function_test.m; cd ../../..
cd application/math/matrix; octave accelerator_matrix_mean_function_test.m; cd ../../..
cd application/math/scalar; octave accelerator_scalar_deviation_function_test.m; cd ../../..
cd application/math/scalar; octave accelerator_scalar_mean_function_test.m; cd ../../..
cd application/math/vector; octave accelerator_vector_deviation_function_test.m; cd ../../..
cd application/math/vector; octave accelerator_vector_mean_function_test.m; cd ../../..

cd application/state/feedback; octave accelerator_state_matrix_feedforward_test.m; cd ../../..
cd application/state/feedback; octave accelerator_state_matrix_input_test.m; cd ../../..
cd application/state/feedback; octave accelerator_state_matrix_output_test.m; cd ../../..
cd application/state/feedback; octave accelerator_state_matrix_state_test.m; cd ../../..
cd application/state/outputs; octave accelerator_state_vector_output_test.m; cd ../../..
cd application/state/outputs; octave accelerator_state_vector_state_test.m; cd ../../..
cd application/state/top; octave accelerator_state_top_test.m; cd ../../..

cd application/nn/fnn/convolutional; octave accelerator_controller_test.m; cd ../../../..
cd application/nn/fnn/standard; octave accelerator_controller_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_activation_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_controller_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_forget_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_hidden_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_input_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_output_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/convolutional; octave accelerator_state_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_activation_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_controller_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_forget_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_hidden_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_input_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_output_gate_vector_test.m; cd ../../../..
cd application/nn/lstm/standard; octave accelerator_state_gate_vector_test.m; cd ../../../..
cd application/nn/ann/components; octave accelerator_masked_multi_head_attention_test.m; cd ../../../..
cd application/nn/ann/components; octave accelerator_masked_scaled_dot_product_attention_test.m; cd ../../../..
cd application/nn/ann/components; octave accelerator_multi_head_attention_test.m; cd ../../../..
cd application/nn/ann/components; octave accelerator_scaled_dot_product_attention_test.m; cd ../../../..
cd application/nn/ann/controller/fnn; octave accelerator_fnn_test.m; cd ../../../../..
cd application/nn/ann/controller/lstm; octave accelerator_lstm_test.m; cd ../../../../..
cd application/nn/ann/functions; octave accelerator_layer_norm_test.m; cd ../../../..
cd application/nn/ann/functions; octave accelerator_positional_encoding_test.m; cd ../../../..
cd application/nn/ann/inputs; octave accelerator_inputs_vector_test.m; cd ../../../..
cd application/nn/ann/inputs; octave accelerator_keys_vector_test.m; cd ../../../..
cd application/nn/ann/inputs; octave accelerator_queries_vector_test.m; cd ../../../..
cd application/nn/ann/inputs; octave accelerator_values_vector_test.m; cd ../../../..
cd application/nn/ann/top; octave accelerator_controller_test.m; cd ../../../..
cd application/nn/ann/top; octave accelerator_decoder_test.m; cd ../../../..
cd application/nn/ann/top; octave accelerator_encoder_test.m; cd ../../../..

cd application/nn/ntm/memory; octave accelerator_addressing_test.m; cd ../../../..
cd application/nn/ntm/memory; octave accelerator_matrix_content_based_addressing_test.m; cd ../../../..
cd application/nn/ntm/memory; octave accelerator_vector_content_based_addressing_test.m; cd ../../../..
cd application/nn/ntm/read_heads; octave accelerator_reading_test.m; cd ../../../..
cd application/nn/ntm/top; octave accelerator_interface_matrix_test.m; cd ../../../..
cd application/nn/ntm/top; octave accelerator_interface_top_test.m; cd ../../../..
cd application/nn/ntm/top; octave accelerator_interface_vector_test.m; cd ../../../..
cd application/nn/ntm/top; octave accelerator_output_vector_test.m; cd ../../../..
cd application/nn/ntm/top; octave accelerator_top_test.m; cd ../../../..
cd application/nn/ntm/write_heads; octave accelerator_erasing_test.m; cd ../../../..
cd application/nn/ntm/write_heads; octave accelerator_writing_test.m; cd ../../../..
#cd application/nn/ntm/trained; octave accelerator_trained_top_test.m; cd ../../../..

cd application/nn/dnc/memory; octave accelerator_addressing_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_allocation_weighting_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_backward_weighting_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_forward_weighting_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_matrix_content_based_addressing_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_memory_matrix_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_memory_retention_vector_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_precedence_weighting_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_sort_vector_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_temporal_link_matrix_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_usage_vector_test.m; cd ../../../..
cd application/nn/dnc/memory; octave accelerator_vector_content_based_addressing_test.m; cd ../../../..
cd application/nn/dnc/read_heads; octave accelerator_read_content_weighting_test.m; cd ../../../..
cd application/nn/dnc/read_heads; octave accelerator_read_vectors_test.m; cd ../../../..
cd application/nn/dnc/read_heads; octave accelerator_read_weighting_test.m; cd ../../../..
cd application/nn/dnc/top; octave accelerator_interface_matrix_test.m; cd ../../../..
cd application/nn/dnc/top; octave accelerator_interface_top_test.m; cd ../../../..
cd application/nn/dnc/top; octave accelerator_interface_vector_test.m; cd ../../../..
cd application/nn/dnc/top; octave accelerator_output_vector_test.m; cd ../../../..
cd application/nn/dnc/top; octave accelerator_top_test.m; cd ../../../..
cd application/nn/dnc/write_heads; octave accelerator_write_content_weighting_test.m; cd ../../../..
cd application/nn/dnc/write_heads; octave accelerator_write_weighting_test.m; cd ../../../..
#cd application/nn/dnc/trained; octave accelerator_trained_top_test.m; cd ../../../..

cd application/trainer/differentiation; octave accelerator_matrix_controller_differentiation_test.m; cd ../../..
cd application/trainer/differentiation; octave accelerator_vector_controller_differentiation_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_b_trainer_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_d_trainer_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_k_trainer_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_trainer_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_u_trainer_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_v_trainer_test.m; cd ../../..
cd application/trainer/fnn; octave accelerator_fnn_w_trainer_test.m; cd ../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_b_trainer_test.m; cd ../../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_d_trainer_test.m; cd ../../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_k_trainer_test.m; cd ../../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_trainer_test.m; cd ../../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_u_trainer_test.m; cd ../../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_v_trainer_test.m; cd ../../../..
cd application/trainer/lstm/activation; octave accelerator_lstm_activation_w_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_b_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_d_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_k_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_u_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_v_trainer_test.m; cd ../../../..
cd application/trainer/lstm/forget; octave accelerator_lstm_forget_w_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_b_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_d_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_k_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_u_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_v_trainer_test.m; cd ../../../..
cd application/trainer/lstm/input; octave accelerator_lstm_input_w_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_b_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_d_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_k_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_u_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_v_trainer_test.m; cd ../../../..
cd application/trainer/lstm/output; octave accelerator_lstm_output_w_trainer_test.m; cd ../../../..
