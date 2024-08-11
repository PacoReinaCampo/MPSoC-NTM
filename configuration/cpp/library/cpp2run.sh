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

rm -rf algebra/matrix/ntm_matrix_convolution.run
rm -rf algebra/matrix/ntm_matrix_differentiation.run
rm -rf algebra/matrix/ntm_matrix_integration.run
rm -rf algebra/matrix/ntm_matrix_inverse.run
rm -rf algebra/matrix/ntm_matrix_multiplication.run
rm -rf algebra/matrix/ntm_matrix_product.run
rm -rf algebra/matrix/ntm_matrix_softmax.run
rm -rf algebra/matrix/ntm_matrix_summation.run
rm -rf algebra/matrix/ntm_matrix_transpose.run
rm -rf algebra/matrix/ntm_matrix_vector_convolution.run
rm -rf algebra/matrix/ntm_matrix_vector_product.run
rm -rf algebra/matrix/ntm_transpose_vector_product.run
rm -rf algebra/scalar/ntm_scalar_multiplication.run
rm -rf algebra/scalar/ntm_scalar_summation.run
rm -rf algebra/tensor/ntm_tensor_convolution.run
rm -rf algebra/tensor/ntm_tensor_differentiation.run
rm -rf algebra/tensor/ntm_tensor_integration.run
rm -rf algebra/tensor/ntm_tensor_inverse.run
rm -rf algebra/tensor/ntm_tensor_matrix_convolution.run
rm -rf algebra/tensor/ntm_tensor_matrix_product.run
rm -rf algebra/tensor/ntm_tensor_multiplication.run
rm -rf algebra/tensor/ntm_tensor_product.run
rm -rf algebra/tensor/ntm_tensor_softmax.run
rm -rf algebra/tensor/ntm_tensor_summation.run
rm -rf algebra/tensor/ntm_tensor_transpose.run
rm -rf algebra/vector/ntm_dot_product.run
rm -rf algebra/vector/ntm_vector_convolution.run
rm -rf algebra/vector/ntm_vector_cosine_similarity.run
rm -rf algebra/vector/ntm_vector_differentiation.run
rm -rf algebra/vector/ntm_vector_integration.run
rm -rf algebra/vector/ntm_vector_module.run
rm -rf algebra/vector/ntm_vector_multiplication.run
rm -rf algebra/vector/ntm_vector_softmax.run
rm -rf algebra/vector/ntm_vector_summation.run
rm -rf arithmetic/matrix/ntm_matrix_adder.run
rm -rf arithmetic/matrix/ntm_matrix_divider.run
rm -rf arithmetic/matrix/ntm_matrix_multiplier.run
rm -rf arithmetic/scalar/ntm_scalar_adder.run
rm -rf arithmetic/scalar/ntm_scalar_divider.run
rm -rf arithmetic/scalar/ntm_scalar_multiplier.run
rm -rf arithmetic/tensor/ntm_tensor_adder.run
rm -rf arithmetic/tensor/ntm_tensor_divider.run
rm -rf arithmetic/tensor/ntm_tensor_multiplier.run
rm -rf arithmetic/vector/ntm_vector_adder.run
rm -rf arithmetic/vector/ntm_vector_divider.run
rm -rf arithmetic/vector/ntm_vector_multiplier.run
rm -rf math/matrix/ntm_matrix_deviation_function.run
rm -rf math/matrix/ntm_matrix_logistic_function.run
rm -rf math/matrix/ntm_matrix_mean_function.run
rm -rf math/matrix/ntm_matrix_oneplus_function.run
rm -rf math/scalar/ntm_scalar_deviation_function.run
rm -rf math/scalar/ntm_scalar_logistic_function.run
rm -rf math/scalar/ntm_scalar_mean_function.run
rm -rf math/scalar/ntm_scalar_oneplus_function.run
rm -rf math/vector/ntm_vector_deviation_function.run
rm -rf math/vector/ntm_vector_logistic_function.run
rm -rf math/vector/ntm_vector_mean_function.run
rm -rf math/vector/ntm_vector_oneplus_function.run
rm -rf nn/ann/components/ntm_masked_multi_head_attention.run
rm -rf nn/ann/components/ntm_masked_scaled_dot_product_attention.run
rm -rf nn/ann/components/ntm_multi_head_attention.run
rm -rf nn/ann/components/ntm_scaled_dot_product_attention.run
rm -rf nn/ann/controller/fnn/ntm_fnn.run
rm -rf nn/ann/controller/lstm/ntm_activation_gate_vector.run
rm -rf nn/ann/controller/lstm/ntm_forget_gate_vector.run
rm -rf nn/ann/controller/lstm/ntm_hidden_gate_vector.run
rm -rf nn/ann/controller/lstm/ntm_input_gate_vector.run
rm -rf nn/ann/controller/lstm/ntm_lstm.run
rm -rf nn/ann/controller/lstm/ntm_output_gate_vector.run
rm -rf nn/ann/controller/lstm/ntm_state_gate_vector.run
rm -rf nn/ann/functions/ntm_layer_norm.run
rm -rf nn/ann/functions/ntm_positional_encoding.run
rm -rf nn/ann/inputs/ntm_inputs_vector.run
rm -rf nn/ann/inputs/ntm_keys_vector.run
rm -rf nn/ann/inputs/ntm_queries_vector.run
rm -rf nn/ann/inputs/ntm_values_vector.run
rm -rf nn/ann/top/ntm_controller.run
rm -rf nn/ann/top/ntm_decoder.run
rm -rf nn/ann/top/ntm_encoder.run
rm -rf nn/dnc/memory/dnc_addressing.run
rm -rf nn/dnc/memory/dnc_allocation_weighting.run
rm -rf nn/dnc/memory/dnc_backward_weighting.run
rm -rf nn/dnc/memory/dnc_forward_weighting.run
rm -rf nn/dnc/memory/dnc_matrix_content_based_addressing.run
rm -rf nn/dnc/memory/dnc_memory_matrix.run
rm -rf nn/dnc/memory/dnc_memory_retention_vector.run
rm -rf nn/dnc/memory/dnc_precedence_weighting.run
rm -rf nn/dnc/memory/dnc_read_content_weighting.run
rm -rf nn/dnc/memory/dnc_read_vectors.run
rm -rf nn/dnc/memory/dnc_read_weighting.run
rm -rf nn/dnc/memory/dnc_sort_vector.run
rm -rf nn/dnc/memory/dnc_temporal_link_matrix.run
rm -rf nn/dnc/memory/dnc_usage_vector.run
rm -rf nn/dnc/memory/dnc_vector_content_based_addressing.run
rm -rf nn/dnc/memory/dnc_write_content_weighting.run
rm -rf nn/dnc/memory/dnc_write_weighting.run
rm -rf nn/dnc/top/dnc_interface_matrix.run
rm -rf nn/dnc/top/dnc_interface_top.run
rm -rf nn/dnc/top/dnc_interface_vector.run
rm -rf nn/dnc/top/dnc_output_vector.run
rm -rf nn/dnc/top/dnc_top.run
rm -rf nn/dnc/trained/dnc_trained_top.run
rm -rf nn/fnn/convolutional/ntm_controller.run
rm -rf nn/fnn/standard/ntm_controller.run
rm -rf nn/lstm/convolutional/ntm_activation_gate_vector.run
rm -rf nn/lstm/convolutional/ntm_controller.run
rm -rf nn/lstm/convolutional/ntm_forget_gate_vector.run
rm -rf nn/lstm/convolutional/ntm_hidden_gate_vector.run
rm -rf nn/lstm/convolutional/ntm_input_gate_vector.run
rm -rf nn/lstm/convolutional/ntm_output_gate_vector.run
rm -rf nn/lstm/convolutional/ntm_state_gate_vector.run
rm -rf nn/lstm/standard/ntm_activation_gate_vector.run
rm -rf nn/lstm/standard/ntm_controller.run
rm -rf nn/lstm/standard/ntm_forget_gate_vector.run
rm -rf nn/lstm/standard/ntm_hidden_gate_vector.run
rm -rf nn/lstm/standard/ntm_input_gate_vector.run
rm -rf nn/lstm/standard/ntm_output_gate_vector.run
rm -rf nn/lstm/standard/ntm_state_gate_vector.run
rm -rf nn/ntm/memory/ntm_addressing.run
rm -rf nn/ntm/memory/ntm_matrix_content_based_addressing.run
rm -rf nn/ntm/memory/ntm_vector_content_based_addressing.run
rm -rf nn/ntm/read_heads/ntm_reading.run
rm -rf nn/ntm/top/ntm_interface_matrix.run
rm -rf nn/ntm/top/ntm_interface_top.run
rm -rf nn/ntm/top/ntm_interface_vector.run
rm -rf nn/ntm/top/ntm_output_vector.run
rm -rf nn/ntm/top/ntm_top.run
rm -rf nn/ntm/trained/ntm_trained_top.run
rm -rf nn/ntm/write_heads/ntm_erasing.run
rm -rf nn/ntm/write_heads/ntm_writing.run
rm -rf state/feedback/ntm_state_matrix_feedforward.run
rm -rf state/feedback/ntm_state_matrix_input.run
rm -rf state/feedback/ntm_state_matrix_output.run
rm -rf state/feedback/ntm_state_matrix_state.run
rm -rf state/outputs/ntm_state_vector_output.run
rm -rf state/outputs/ntm_state_vector_state.run
rm -rf state/top/ntm_state_top.run
rm -rf trainer/differentiation/ntm_matrix_controller_differentiation.run
rm -rf trainer/differentiation/ntm_vector_controller_differentiation.run
rm -rf trainer/fnn/ntm_fnn_b_trainer.run
rm -rf trainer/fnn/ntm_fnn_d_trainer.run
rm -rf trainer/fnn/ntm_fnn_k_trainer.run
rm -rf trainer/fnn/ntm_fnn_trainer.run
rm -rf trainer/fnn/ntm_fnn_u_trainer.run
rm -rf trainer/fnn/ntm_fnn_v_trainer.run
rm -rf trainer/fnn/ntm_fnn_w_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_b_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_d_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_k_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_u_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_v_trainer.run
rm -rf trainer/lstm/activation/ntm_lstm_activation_w_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_b_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_d_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_k_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_u_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_v_trainer.run
rm -rf trainer/lstm/forget/ntm_lstm_forget_w_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_b_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_d_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_k_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_u_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_v_trainer.run
rm -rf trainer/lstm/input/ntm_lstm_input_w_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_b_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_d_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_k_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_u_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_v_trainer.run
rm -rf trainer/lstm/output/ntm_lstm_output_w_trainer.run

# x86-64 ISA
g++ algebra/matrix/ntm_matrix_convolution.cpp -o algebra/matrix/ntm_matrix_convolution.run
g++ algebra/matrix/ntm_matrix_differentiation.cpp -o algebra/matrix/ntm_matrix_differentiation.run
g++ algebra/matrix/ntm_matrix_integration.cpp -o algebra/matrix/ntm_matrix_integration.run
g++ algebra/matrix/ntm_matrix_inverse.cpp -o algebra/matrix/ntm_matrix_inverse.run
g++ algebra/matrix/ntm_matrix_multiplication.cpp -o algebra/matrix/ntm_matrix_multiplication.run
g++ algebra/matrix/ntm_matrix_product.cpp -o algebra/matrix/ntm_matrix_product.run
g++ algebra/matrix/ntm_matrix_softmax.cpp -o algebra/matrix/ntm_matrix_softmax.run
g++ algebra/matrix/ntm_matrix_summation.cpp -o algebra/matrix/ntm_matrix_summation.run
g++ algebra/matrix/ntm_matrix_transpose.cpp -o algebra/matrix/ntm_matrix_transpose.run
g++ algebra/matrix/ntm_matrix_vector_convolution.cpp -o algebra/matrix/ntm_matrix_vector_convolution.run
g++ algebra/matrix/ntm_matrix_vector_product.cpp -o algebra/matrix/ntm_matrix_vector_product.run
g++ algebra/matrix/ntm_transpose_vector_product.cpp -o algebra/matrix/ntm_transpose_vector_product.run
g++ algebra/scalar/ntm_scalar_multiplication.cpp -o algebra/scalar/ntm_scalar_multiplication.run
g++ algebra/scalar/ntm_scalar_summation.cpp -o algebra/scalar/ntm_scalar_summation.run
g++ algebra/tensor/ntm_tensor_convolution.cpp -o algebra/tensor/ntm_tensor_convolution.run
g++ algebra/tensor/ntm_tensor_differentiation.cpp -o algebra/tensor/ntm_tensor_differentiation.run
g++ algebra/tensor/ntm_tensor_integration.cpp -o algebra/tensor/ntm_tensor_integration.run
g++ algebra/tensor/ntm_tensor_inverse.cpp -o algebra/tensor/ntm_tensor_inverse.run
g++ algebra/tensor/ntm_tensor_matrix_convolution.cpp -o algebra/tensor/ntm_tensor_matrix_convolution.run
g++ algebra/tensor/ntm_tensor_matrix_product.cpp -o algebra/tensor/ntm_tensor_matrix_product.run
g++ algebra/tensor/ntm_tensor_multiplication.cpp -o algebra/tensor/ntm_tensor_multiplication.run
g++ algebra/tensor/ntm_tensor_product.cpp -o algebra/tensor/ntm_tensor_product.run
g++ algebra/tensor/ntm_tensor_softmax.cpp -o algebra/tensor/ntm_tensor_softmax.run
g++ algebra/tensor/ntm_tensor_summation.cpp -o algebra/tensor/ntm_tensor_summation.run
g++ algebra/tensor/ntm_tensor_transpose.cpp -o algebra/tensor/ntm_tensor_transpose.run
g++ algebra/vector/ntm_dot_product.cpp -o algebra/vector/ntm_dot_product.run
g++ algebra/vector/ntm_vector_convolution.cpp -o algebra/vector/ntm_vector_convolution.run
g++ algebra/vector/ntm_vector_cosine_similarity.cpp -o algebra/vector/ntm_vector_cosine_similarity.run
g++ algebra/vector/ntm_vector_differentiation.cpp -o algebra/vector/ntm_vector_differentiation.run
g++ algebra/vector/ntm_vector_integration.cpp -o algebra/vector/ntm_vector_integration.run
g++ algebra/vector/ntm_vector_module.cpp -o algebra/vector/ntm_vector_module.run
g++ algebra/vector/ntm_vector_multiplication.cpp -o algebra/vector/ntm_vector_multiplication.run
g++ algebra/vector/ntm_vector_softmax.cpp -o algebra/vector/ntm_vector_softmax.run
g++ algebra/vector/ntm_vector_summation.cpp -o algebra/vector/ntm_vector_summation.run
g++ arithmetic/matrix/ntm_matrix_adder.cpp -o arithmetic/matrix/ntm_matrix_adder.run
g++ arithmetic/matrix/ntm_matrix_divider.cpp -o arithmetic/matrix/ntm_matrix_divider.run
g++ arithmetic/matrix/ntm_matrix_multiplier.cpp -o arithmetic/matrix/ntm_matrix_multiplier.run
g++ arithmetic/scalar/ntm_scalar_adder.cpp -o arithmetic/scalar/ntm_scalar_adder.run
g++ arithmetic/scalar/ntm_scalar_divider.cpp -o arithmetic/scalar/ntm_scalar_divider.run
g++ arithmetic/scalar/ntm_scalar_multiplier.cpp -o arithmetic/scalar/ntm_scalar_multiplier.run
g++ arithmetic/tensor/ntm_tensor_adder.cpp -o arithmetic/tensor/ntm_tensor_adder.run
g++ arithmetic/tensor/ntm_tensor_divider.cpp -o arithmetic/tensor/ntm_tensor_divider.run
g++ arithmetic/tensor/ntm_tensor_multiplier.cpp -o arithmetic/tensor/ntm_tensor_multiplier.run
g++ arithmetic/vector/ntm_vector_adder.cpp -o arithmetic/vector/ntm_vector_adder.run
g++ arithmetic/vector/ntm_vector_divider.cpp -o arithmetic/vector/ntm_vector_divider.run
g++ arithmetic/vector/ntm_vector_multiplier.cpp -o arithmetic/vector/ntm_vector_multiplier.run
g++ math/matrix/ntm_matrix_deviation_function.cpp -o math/matrix/ntm_matrix_deviation_function.run
g++ math/matrix/ntm_matrix_logistic_function.cpp -o math/matrix/ntm_matrix_logistic_function.run
g++ math/matrix/ntm_matrix_mean_function.cpp -o math/matrix/ntm_matrix_mean_function.run
g++ math/matrix/ntm_matrix_oneplus_function.cpp -o math/matrix/ntm_matrix_oneplus_function.run
g++ math/scalar/ntm_scalar_deviation_function.cpp -o math/scalar/ntm_scalar_deviation_function.run
g++ math/scalar/ntm_scalar_logistic_function.cpp -o math/scalar/ntm_scalar_logistic_function.run
g++ math/scalar/ntm_scalar_mean_function.cpp -o math/scalar/ntm_scalar_mean_function.run
g++ math/scalar/ntm_scalar_oneplus_function.cpp -o math/scalar/ntm_scalar_oneplus_function.run
g++ math/vector/ntm_vector_deviation_function.cpp -o math/vector/ntm_vector_deviation_function.run
g++ math/vector/ntm_vector_logistic_function.cpp -o math/vector/ntm_vector_logistic_function.run
g++ math/vector/ntm_vector_mean_function.cpp -o math/vector/ntm_vector_mean_function.run
g++ math/vector/ntm_vector_oneplus_function.cpp -o math/vector/ntm_vector_oneplus_function.run
g++ nn/ann/components/ntm_masked_multi_head_attention.cpp -o nn/ann/components/ntm_masked_multi_head_attention.run
g++ nn/ann/components/ntm_masked_scaled_dot_product_attention.cpp -o nn/ann/components/ntm_masked_scaled_dot_product_attention.run
g++ nn/ann/components/ntm_multi_head_attention.cpp -o nn/ann/components/ntm_multi_head_attention.run
g++ nn/ann/components/ntm_scaled_dot_product_attention.cpp -o nn/ann/components/ntm_scaled_dot_product_attention.run
g++ nn/ann/controller/fnn/ntm_fnn.cpp -o nn/ann/controller/fnn/ntm_fnn.run
g++ nn/ann/controller/lstm/ntm_activation_gate_vector.cpp -o nn/ann/controller/lstm/ntm_activation_gate_vector.run
g++ nn/ann/controller/lstm/ntm_forget_gate_vector.cpp -o nn/ann/controller/lstm/ntm_forget_gate_vector.run
g++ nn/ann/controller/lstm/ntm_hidden_gate_vector.cpp -o nn/ann/controller/lstm/ntm_hidden_gate_vector.run
g++ nn/ann/controller/lstm/ntm_input_gate_vector.cpp -o nn/ann/controller/lstm/ntm_input_gate_vector.run
g++ nn/ann/controller/lstm/ntm_lstm.cpp -o nn/ann/controller/lstm/ntm_lstm.run
g++ nn/ann/controller/lstm/ntm_output_gate_vector.cpp -o nn/ann/controller/lstm/ntm_output_gate_vector.run
g++ nn/ann/controller/lstm/ntm_state_gate_vector.cpp -o nn/ann/controller/lstm/ntm_state_gate_vector.run
g++ nn/ann/functions/ntm_layer_norm.cpp -o nn/ann/functions/ntm_layer_norm.run
g++ nn/ann/functions/ntm_positional_encoding.cpp -o nn/ann/functions/ntm_positional_encoding.run
g++ nn/ann/inputs/ntm_inputs_vector.cpp -o nn/ann/inputs/ntm_inputs_vector.run
g++ nn/ann/inputs/ntm_keys_vector.cpp -o nn/ann/inputs/ntm_keys_vector.run
g++ nn/ann/inputs/ntm_queries_vector.cpp -o nn/ann/inputs/ntm_queries_vector.run
g++ nn/ann/inputs/ntm_values_vector.cpp -o nn/ann/inputs/ntm_values_vector.run
g++ nn/ann/top/ntm_controller.cpp -o nn/ann/top/ntm_controller.run
g++ nn/ann/top/ntm_decoder.cpp -o nn/ann/top/ntm_decoder.run
g++ nn/ann/top/ntm_encoder.cpp -o nn/ann/top/ntm_encoder.run
g++ nn/dnc/memory/dnc_addressing.cpp -o nn/dnc/memory/dnc_addressing.run
g++ nn/dnc/memory/dnc_allocation_weighting.cpp -o nn/dnc/memory/dnc_allocation_weighting.run
g++ nn/dnc/memory/dnc_backward_weighting.cpp -o nn/dnc/memory/dnc_backward_weighting.run
g++ nn/dnc/memory/dnc_forward_weighting.cpp -o nn/dnc/memory/dnc_forward_weighting.run
g++ nn/dnc/memory/dnc_matrix_content_based_addressing.cpp -o nn/dnc/memory/dnc_matrix_content_based_addressing.run
g++ nn/dnc/memory/dnc_memory_matrix.cpp -o nn/dnc/memory/dnc_memory_matrix.run
g++ nn/dnc/memory/dnc_memory_retention_vector.cpp -o nn/dnc/memory/dnc_memory_retention_vector.run
g++ nn/dnc/memory/dnc_precedence_weighting.cpp -o nn/dnc/memory/dnc_precedence_weighting.run
g++ nn/dnc/memory/dnc_read_content_weighting.cpp -o nn/dnc/memory/dnc_read_content_weighting.run
g++ nn/dnc/memory/dnc_read_vectors.cpp -o nn/dnc/memory/dnc_read_vectors.run
g++ nn/dnc/memory/dnc_read_weighting.cpp -o nn/dnc/memory/dnc_read_weighting.run
g++ nn/dnc/memory/dnc_sort_vector.cpp -o nn/dnc/memory/dnc_sort_vector.run
g++ nn/dnc/memory/dnc_temporal_link_matrix.cpp -o nn/dnc/memory/dnc_temporal_link_matrix.run
g++ nn/dnc/memory/dnc_usage_vector.cpp -o nn/dnc/memory/dnc_usage_vector.run
g++ nn/dnc/memory/dnc_vector_content_based_addressing.cpp -o nn/dnc/memory/dnc_vector_content_based_addressing.run
g++ nn/dnc/memory/dnc_write_content_weighting.cpp -o nn/dnc/memory/dnc_write_content_weighting.run
g++ nn/dnc/memory/dnc_write_weighting.cpp -o nn/dnc/memory/dnc_write_weighting.run
g++ nn/dnc/top/dnc_interface_matrix.cpp -o nn/dnc/top/dnc_interface_matrix.run
g++ nn/dnc/top/dnc_interface_top.cpp -o nn/dnc/top/dnc_interface_top.run
g++ nn/dnc/top/dnc_interface_vector.cpp -o nn/dnc/top/dnc_interface_vector.run
g++ nn/dnc/top/dnc_output_vector.cpp -o nn/dnc/top/dnc_output_vector.run
g++ nn/dnc/top/dnc_top.cpp -o nn/dnc/top/dnc_top.run
g++ nn/dnc/trained/dnc_trained_top.cpp -o nn/dnc/trained/dnc_trained_top.run
g++ nn/fnn/convolutional/ntm_controller.cpp -o nn/fnn/convolutional/ntm_controller.run
g++ nn/fnn/standard/ntm_controller.cpp -o nn/fnn/standard/ntm_controller.run
g++ nn/lstm/convolutional/ntm_activation_gate_vector.cpp -o nn/lstm/convolutional/ntm_activation_gate_vector.run
g++ nn/lstm/convolutional/ntm_controller.cpp -o nn/lstm/convolutional/ntm_controller.run
g++ nn/lstm/convolutional/ntm_forget_gate_vector.cpp -o nn/lstm/convolutional/ntm_forget_gate_vector.run
g++ nn/lstm/convolutional/ntm_hidden_gate_vector.cpp -o nn/lstm/convolutional/ntm_hidden_gate_vector.run
g++ nn/lstm/convolutional/ntm_input_gate_vector.cpp -o nn/lstm/convolutional/ntm_input_gate_vector.run
g++ nn/lstm/convolutional/ntm_output_gate_vector.cpp -o nn/lstm/convolutional/ntm_output_gate_vector.run
g++ nn/lstm/convolutional/ntm_state_gate_vector.cpp -o nn/lstm/convolutional/ntm_state_gate_vector.run
g++ nn/lstm/standard/ntm_activation_gate_vector.cpp -o nn/lstm/standard/ntm_activation_gate_vector.run
g++ nn/lstm/standard/ntm_controller.cpp -o nn/lstm/standard/ntm_controller.run
g++ nn/lstm/standard/ntm_forget_gate_vector.cpp -o nn/lstm/standard/ntm_forget_gate_vector.run
g++ nn/lstm/standard/ntm_hidden_gate_vector.cpp -o nn/lstm/standard/ntm_hidden_gate_vector.run
g++ nn/lstm/standard/ntm_input_gate_vector.cpp -o nn/lstm/standard/ntm_input_gate_vector.run
g++ nn/lstm/standard/ntm_output_gate_vector.cpp -o nn/lstm/standard/ntm_output_gate_vector.run
g++ nn/lstm/standard/ntm_state_gate_vector.cpp -o nn/lstm/standard/ntm_state_gate_vector.run
g++ nn/ntm/memory/ntm_addressing.cpp -o nn/ntm/memory/ntm_addressing.run
g++ nn/ntm/memory/ntm_matrix_content_based_addressing.cpp -o nn/ntm/memory/ntm_matrix_content_based_addressing.run
g++ nn/ntm/memory/ntm_vector_content_based_addressing.cpp -o nn/ntm/memory/ntm_vector_content_based_addressing.run
g++ nn/ntm/read_heads/ntm_reading.cpp -o nn/ntm/read_heads/ntm_reading.run
g++ nn/ntm/top/ntm_interface_matrix.cpp -o nn/ntm/top/ntm_interface_matrix.run
g++ nn/ntm/top/ntm_interface_top.cpp -o nn/ntm/top/ntm_interface_top.run
g++ nn/ntm/top/ntm_interface_vector.cpp -o nn/ntm/top/ntm_interface_vector.run
g++ nn/ntm/top/ntm_output_vector.cpp -o nn/ntm/top/ntm_output_vector.run
g++ nn/ntm/top/ntm_top.cpp -o nn/ntm/top/ntm_top.run
g++ nn/ntm/trained/ntm_trained_top.cpp -o nn/ntm/trained/ntm_trained_top.run
g++ nn/ntm/write_heads/ntm_erasing.cpp -o nn/ntm/write_heads/ntm_erasing.run
g++ nn/ntm/write_heads/ntm_writing.cpp -o nn/ntm/write_heads/ntm_writing.run
g++ state/feedback/ntm_state_matrix_feedforward.cpp -o state/feedback/ntm_state_matrix_feedforward.run
g++ state/feedback/ntm_state_matrix_input.cpp -o state/feedback/ntm_state_matrix_input.run
g++ state/feedback/ntm_state_matrix_output.cpp -o state/feedback/ntm_state_matrix_output.run
g++ state/feedback/ntm_state_matrix_state.cpp -o state/feedback/ntm_state_matrix_state.run
g++ state/outputs/ntm_state_vector_output.cpp -o state/outputs/ntm_state_vector_output.run
g++ state/outputs/ntm_state_vector_state.cpp -o state/outputs/ntm_state_vector_state.run
g++ state/top/ntm_state_top.cpp -o state/top/ntm_state_top.run
g++ trainer/differentiation/ntm_matrix_controller_differentiation.cpp -o trainer/differentiation/ntm_matrix_controller_differentiation.run
g++ trainer/differentiation/ntm_vector_controller_differentiation.cpp -o trainer/differentiation/ntm_vector_controller_differentiation.run
g++ trainer/fnn/ntm_fnn_b_trainer.cpp -o trainer/fnn/ntm_fnn_b_trainer.run
g++ trainer/fnn/ntm_fnn_d_trainer.cpp -o trainer/fnn/ntm_fnn_d_trainer.run
g++ trainer/fnn/ntm_fnn_k_trainer.cpp -o trainer/fnn/ntm_fnn_k_trainer.run
g++ trainer/fnn/ntm_fnn_trainer.cpp -o trainer/fnn/ntm_fnn_trainer.run
g++ trainer/fnn/ntm_fnn_u_trainer.cpp -o trainer/fnn/ntm_fnn_u_trainer.run
g++ trainer/fnn/ntm_fnn_v_trainer.cpp -o trainer/fnn/ntm_fnn_v_trainer.run
g++ trainer/fnn/ntm_fnn_w_trainer.cpp -o trainer/fnn/ntm_fnn_w_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_b_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_b_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_d_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_d_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_k_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_k_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_u_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_u_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_v_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_v_trainer.run
g++ trainer/lstm/activation/ntm_lstm_activation_w_trainer.cpp -o trainer/lstm/activation/ntm_lstm_activation_w_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_b_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_b_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_d_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_d_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_k_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_k_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_u_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_u_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_v_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_v_trainer.run
g++ trainer/lstm/forget/ntm_lstm_forget_w_trainer.cpp -o trainer/lstm/forget/ntm_lstm_forget_w_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_b_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_b_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_d_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_d_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_k_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_k_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_u_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_u_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_v_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_v_trainer.run
g++ trainer/lstm/input/ntm_lstm_input_w_trainer.cpp -o trainer/lstm/input/ntm_lstm_input_w_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_b_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_b_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_d_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_d_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_k_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_k_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_u_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_u_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_v_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_v_trainer.run
g++ trainer/lstm/output/ntm_lstm_output_w_trainer.cpp -o trainer/lstm/output/ntm_lstm_output_w_trainer.run
