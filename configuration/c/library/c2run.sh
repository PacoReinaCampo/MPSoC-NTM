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

rm -rf algebra/matrix/accelerator_matrix_convolution.run
rm -rf algebra/matrix/accelerator_matrix_differentiation.run
rm -rf algebra/matrix/accelerator_matrix_integration.run
rm -rf algebra/matrix/accelerator_matrix_inverse.run
rm -rf algebra/matrix/accelerator_matrix_multiplication.run
rm -rf algebra/matrix/accelerator_matrix_product.run
rm -rf algebra/matrix/accelerator_matrix_softmax.run
rm -rf algebra/matrix/accelerator_matrix_summation.run
rm -rf algebra/matrix/accelerator_matrix_transpose.run
rm -rf algebra/matrix/accelerator_matrix_vector_convolution.run
rm -rf algebra/matrix/accelerator_matrix_vector_product.run
rm -rf algebra/matrix/accelerator_transpose_vector_product.run
rm -rf algebra/scalar/accelerator_scalar_multiplication.run
rm -rf algebra/scalar/accelerator_scalar_summation.run
rm -rf algebra/tensor/accelerator_tensor_convolution.run
rm -rf algebra/tensor/accelerator_tensor_differentiation.run
rm -rf algebra/tensor/accelerator_tensor_integration.run
rm -rf algebra/tensor/accelerator_tensor_inverse.run
rm -rf algebra/tensor/accelerator_tensor_matrix_convolution.run
rm -rf algebra/tensor/accelerator_tensor_matrix_product.run
rm -rf algebra/tensor/accelerator_tensor_multiplication.run
rm -rf algebra/tensor/accelerator_tensor_product.run
rm -rf algebra/tensor/accelerator_tensor_softmax.run
rm -rf algebra/tensor/accelerator_tensor_summation.run
rm -rf algebra/tensor/accelerator_tensor_transpose.run
rm -rf algebra/vector/accelerator_dot_product.run
rm -rf algebra/vector/accelerator_vector_convolution.run
rm -rf algebra/vector/accelerator_vector_cosine_similarity.run
rm -rf algebra/vector/accelerator_vector_differentiation.run
rm -rf algebra/vector/accelerator_vector_integration.run
rm -rf algebra/vector/accelerator_vector_module.run
rm -rf algebra/vector/accelerator_vector_multiplication.run
rm -rf algebra/vector/accelerator_vector_softmax.run
rm -rf algebra/vector/accelerator_vector_summation.run
rm -rf arithmetic/matrix/accelerator_matrix_adder.run
rm -rf arithmetic/matrix/accelerator_matrix_subtractor.run
rm -rf arithmetic/matrix/accelerator_matrix_divider.run
rm -rf arithmetic/matrix/accelerator_matrix_multiplier.run
rm -rf arithmetic/scalar/accelerator_scalar_adder.run
rm -rf arithmetic/scalar/accelerator_scalar_subtractor.run
rm -rf arithmetic/scalar/accelerator_scalar_divider.run
rm -rf arithmetic/scalar/accelerator_scalar_multiplier.run
rm -rf arithmetic/tensor/accelerator_tensor_adder.run
rm -rf arithmetic/tensor/accelerator_tensor_subtractor.run
rm -rf arithmetic/tensor/accelerator_tensor_divider.run
rm -rf arithmetic/tensor/accelerator_tensor_multiplier.run
rm -rf arithmetic/vector/accelerator_vector_adder.run
rm -rf arithmetic/vector/accelerator_vector_subtractor.run
rm -rf arithmetic/vector/accelerator_vector_divider.run
rm -rf arithmetic/vector/accelerator_vector_multiplier.run
rm -rf math/matrix/accelerator_matrix_deviation_function.run
rm -rf math/matrix/accelerator_matrix_logistic_function.run
rm -rf math/matrix/accelerator_matrix_mean_function.run
rm -rf math/matrix/accelerator_matrix_oneplus_function.run
rm -rf math/scalar/accelerator_scalar_deviation_function.run
rm -rf math/scalar/accelerator_scalar_logistic_function.run
rm -rf math/scalar/accelerator_scalar_mean_function.run
rm -rf math/scalar/accelerator_scalar_oneplus_function.run
rm -rf math/vector/accelerator_vector_deviation_function.run
rm -rf math/vector/accelerator_vector_logistic_function.run
rm -rf math/vector/accelerator_vector_mean_function.run
rm -rf math/vector/accelerator_vector_oneplus_function.run
rm -rf nn/ann/components/accelerator_masked_multi_head_attention.run
rm -rf nn/ann/components/accelerator_masked_scaled_dot_product_attention.run
rm -rf nn/ann/components/accelerator_multi_head_attention.run
rm -rf nn/ann/components/accelerator_scaled_dot_product_attention.run
rm -rf nn/ann/fnn/accelerator_fnn.run
rm -rf nn/ann/functions/accelerator_layer_norm.run
rm -rf nn/ann/functions/accelerator_positional_encoding.run
rm -rf nn/ann/inputs/accelerator_inputs_vector.run
rm -rf nn/ann/inputs/accelerator_keys_vector.run
rm -rf nn/ann/inputs/accelerator_queries_vector.run
rm -rf nn/ann/inputs/accelerator_values_vector.run
rm -rf nn/ann/lstm/accelerator_activation_gate_vector.run
rm -rf nn/ann/lstm/accelerator_forget_gate_vector.run
rm -rf nn/ann/lstm/accelerator_hidden_gate_vector.run
rm -rf nn/ann/lstm/accelerator_input_gate_vector.run
rm -rf nn/ann/lstm/accelerator_lstm.run
rm -rf nn/ann/lstm/accelerator_output_gate_vector.run
rm -rf nn/ann/lstm/accelerator_state_gate_vector.run
rm -rf nn/ann/top/accelerator_controller.run
rm -rf nn/ann/top/accelerator_decoder.run
rm -rf nn/ann/top/accelerator_encoder.run
rm -rf nn/dnc/memory/accelerator_addressing.run
rm -rf nn/dnc/memory/accelerator_allocation_weighting.run
rm -rf nn/dnc/memory/accelerator_backward_weighting.run
rm -rf nn/dnc/memory/accelerator_forward_weighting.run
rm -rf nn/dnc/memory/accelerator_matrix_content_based_addressing.run
rm -rf nn/dnc/memory/accelerator_memory_matrix.run
rm -rf nn/dnc/memory/accelerator_memory_retention_vector.run
rm -rf nn/dnc/memory/accelerator_precedence_weighting.run
rm -rf nn/dnc/memory/accelerator_sort_vector.run
rm -rf nn/dnc/memory/accelerator_temporal_link_matrix.run
rm -rf nn/dnc/memory/accelerator_usage_vector.run
rm -rf nn/dnc/memory/accelerator_vector_content_based_addressing.run
rm -rf nn/dnc/read_heads/accelerator_read_content_weighting.run
rm -rf nn/dnc/read_heads/accelerator_read_vectors.run
rm -rf nn/dnc/read_heads/accelerator_read_weighting.run
rm -rf nn/dnc/top/accelerator_interface_matrix.run
rm -rf nn/dnc/top/accelerator_interface_top.run
rm -rf nn/dnc/top/accelerator_interface_vector.run
rm -rf nn/dnc/top/accelerator_output_vector.run
rm -rf nn/dnc/top/accelerator_top.run
rm -rf nn/dnc/trained/accelerator_trained_top.run
rm -rf nn/dnc/write_heads/accelerator_write_content_weighting.run
rm -rf nn/dnc/write_heads/accelerator_write_weighting.run
rm -rf nn/fnn/convolutional/accelerator_controller.run
rm -rf nn/fnn/standard/accelerator_controller.run
rm -rf nn/lstm/convolutional/accelerator_activation_gate_vector.run
rm -rf nn/lstm/convolutional/accelerator_controller.run
rm -rf nn/lstm/convolutional/accelerator_forget_gate_vector.run
rm -rf nn/lstm/convolutional/accelerator_hidden_gate_vector.run
rm -rf nn/lstm/convolutional/accelerator_input_gate_vector.run
rm -rf nn/lstm/convolutional/accelerator_output_gate_vector.run
rm -rf nn/lstm/convolutional/accelerator_state_gate_vector.run
rm -rf nn/lstm/standard/accelerator_activation_gate_vector.run
rm -rf nn/lstm/standard/accelerator_controller.run
rm -rf nn/lstm/standard/accelerator_forget_gate_vector.run
rm -rf nn/lstm/standard/accelerator_hidden_gate_vector.run
rm -rf nn/lstm/standard/accelerator_input_gate_vector.run
rm -rf nn/lstm/standard/accelerator_output_gate_vector.run
rm -rf nn/lstm/standard/accelerator_state_gate_vector.run
rm -rf nn/ntm/memory/accelerator_addressing.run
rm -rf nn/ntm/memory/accelerator_matrix_content_based_addressing.run
rm -rf nn/ntm/memory/accelerator_vector_content_based_addressing.run
rm -rf nn/ntm/read_heads/accelerator_reading.run
rm -rf nn/ntm/top/accelerator_interface_matrix.run
rm -rf nn/ntm/top/accelerator_interface_top.run
rm -rf nn/ntm/top/accelerator_interface_vector.run
rm -rf nn/ntm/top/accelerator_output_vector.run
rm -rf nn/ntm/top/accelerator_top.run
rm -rf nn/ntm/trained/accelerator_trained_top.run
rm -rf nn/ntm/write_heads/accelerator_erasing.run
rm -rf nn/ntm/write_heads/accelerator_writing.run
rm -rf state/feedback/accelerator_state_matrix_feedforward.run
rm -rf state/feedback/accelerator_state_matrix_input.run
rm -rf state/feedback/accelerator_state_matrix_output.run
rm -rf state/feedback/accelerator_state_matrix_state.run
rm -rf state/outputs/accelerator_state_vector_output.run
rm -rf state/outputs/accelerator_state_vector_state.run
rm -rf state/top/accelerator_state_top.run
rm -rf trainer/differentiation/accelerator_matrix_controller_differentiation.run
rm -rf trainer/differentiation/accelerator_vector_controller_differentiation.run
rm -rf trainer/fnn/accelerator_fnn_b_trainer.run
rm -rf trainer/fnn/accelerator_fnn_d_trainer.run
rm -rf trainer/fnn/accelerator_fnn_k_trainer.run
rm -rf trainer/fnn/accelerator_fnn_trainer.run
rm -rf trainer/fnn/accelerator_fnn_u_trainer.run
rm -rf trainer/fnn/accelerator_fnn_v_trainer.run
rm -rf trainer/fnn/accelerator_fnn_w_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_b_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_d_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_k_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_u_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_v_trainer.run
rm -rf trainer/lstm/activation/accelerator_lstm_activation_w_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_b_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_d_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_k_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_u_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_v_trainer.run
rm -rf trainer/lstm/forget/accelerator_lstm_forget_w_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_b_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_d_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_k_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_u_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_v_trainer.run
rm -rf trainer/lstm/input/accelerator_lstm_input_w_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_b_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_d_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_k_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_u_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_v_trainer.run
rm -rf trainer/lstm/output/accelerator_lstm_output_w_trainer.run

# x86-64 ISA
gcc algebra/matrix/accelerator_matrix_convolution.c -o algebra/matrix/accelerator_matrix_convolution.run
gcc algebra/matrix/accelerator_matrix_differentiation.c -o algebra/matrix/accelerator_matrix_differentiation.run
gcc algebra/matrix/accelerator_matrix_integration.c -o algebra/matrix/accelerator_matrix_integration.run
gcc algebra/matrix/accelerator_matrix_inverse.c -o algebra/matrix/accelerator_matrix_inverse.run
gcc algebra/matrix/accelerator_matrix_multiplication.c -o algebra/matrix/accelerator_matrix_multiplication.run
gcc algebra/matrix/accelerator_matrix_product.c -o algebra/matrix/accelerator_matrix_product.run
gcc algebra/matrix/accelerator_matrix_softmax.c -o algebra/matrix/accelerator_matrix_softmax.run
gcc algebra/matrix/accelerator_matrix_summation.c -o algebra/matrix/accelerator_matrix_summation.run
gcc algebra/matrix/accelerator_matrix_transpose.c -o algebra/matrix/accelerator_matrix_transpose.run
gcc algebra/matrix/accelerator_matrix_vector_convolution.c -o algebra/matrix/accelerator_matrix_vector_convolution.run
gcc algebra/matrix/accelerator_matrix_vector_product.c -o algebra/matrix/accelerator_matrix_vector_product.run
gcc algebra/matrix/accelerator_transpose_vector_product.c -o algebra/matrix/accelerator_transpose_vector_product.run
gcc algebra/scalar/accelerator_scalar_multiplication.c -o algebra/scalar/accelerator_scalar_multiplication.run
gcc algebra/scalar/accelerator_scalar_summation.c -o algebra/scalar/accelerator_scalar_summation.run
gcc algebra/tensor/accelerator_tensor_convolution.c -o algebra/tensor/accelerator_tensor_convolution.run
gcc algebra/tensor/accelerator_tensor_differentiation.c -o algebra/tensor/accelerator_tensor_differentiation.run
gcc algebra/tensor/accelerator_tensor_integration.c -o algebra/tensor/accelerator_tensor_integration.run
gcc algebra/tensor/accelerator_tensor_inverse.c -o algebra/tensor/accelerator_tensor_inverse.run
gcc algebra/tensor/accelerator_tensor_matrix_convolution.c -o algebra/tensor/accelerator_tensor_matrix_convolution.run
gcc algebra/tensor/accelerator_tensor_matrix_product.c -o algebra/tensor/accelerator_tensor_matrix_product.run
gcc algebra/tensor/accelerator_tensor_multiplication.c -o algebra/tensor/accelerator_tensor_multiplication.run
gcc algebra/tensor/accelerator_tensor_product.c -o algebra/tensor/accelerator_tensor_product.run
gcc algebra/tensor/accelerator_tensor_softmax.c -o algebra/tensor/accelerator_tensor_softmax.run
gcc algebra/tensor/accelerator_tensor_summation.c -o algebra/tensor/accelerator_tensor_summation.run
gcc algebra/tensor/accelerator_tensor_transpose.c -o algebra/tensor/accelerator_tensor_transpose.run
gcc algebra/vector/accelerator_dot_product.c -o algebra/vector/accelerator_dot_product.run
gcc algebra/vector/accelerator_vector_convolution.c -o algebra/vector/accelerator_vector_convolution.run
gcc algebra/vector/accelerator_vector_cosine_similarity.c -o algebra/vector/accelerator_vector_cosine_similarity.run
gcc algebra/vector/accelerator_vector_differentiation.c -o algebra/vector/accelerator_vector_differentiation.run
gcc algebra/vector/accelerator_vector_integration.c -o algebra/vector/accelerator_vector_integration.run
gcc algebra/vector/accelerator_vector_module.c -o algebra/vector/accelerator_vector_module.run
gcc algebra/vector/accelerator_vector_multiplication.c -o algebra/vector/accelerator_vector_multiplication.run
gcc algebra/vector/accelerator_vector_softmax.c -o algebra/vector/accelerator_vector_softmax.run
gcc algebra/vector/accelerator_vector_summation.c -o algebra/vector/accelerator_vector_summation.run
gcc arithmetic/matrix/accelerator_matrix_adder.c -o arithmetic/matrix/accelerator_matrix_adder.run
gcc arithmetic/matrix/accelerator_matrix_subtractor.c -o arithmetic/matrix/accelerator_matrix_subtractor.run
gcc arithmetic/matrix/accelerator_matrix_divider.c -o arithmetic/matrix/accelerator_matrix_divider.run
gcc arithmetic/matrix/accelerator_matrix_multiplier.c -o arithmetic/matrix/accelerator_matrix_multiplier.run
gcc arithmetic/scalar/accelerator_scalar_adder.c -o arithmetic/scalar/accelerator_scalar_adder.run
gcc arithmetic/scalar/accelerator_scalar_subtractor.c -o arithmetic/scalar/accelerator_scalar_subtractor.run
gcc arithmetic/scalar/accelerator_scalar_divider.c -o arithmetic/scalar/accelerator_scalar_divider.run
gcc arithmetic/scalar/accelerator_scalar_multiplier.c -o arithmetic/scalar/accelerator_scalar_multiplier.run
gcc arithmetic/tensor/accelerator_tensor_adder.c -o arithmetic/tensor/accelerator_tensor_adder.run
gcc arithmetic/tensor/accelerator_tensor_subtractor.c -o arithmetic/tensor/accelerator_tensor_subtractor.run
gcc arithmetic/tensor/accelerator_tensor_divider.c -o arithmetic/tensor/accelerator_tensor_divider.run
gcc arithmetic/tensor/accelerator_tensor_multiplier.c -o arithmetic/tensor/accelerator_tensor_multiplier.run
gcc arithmetic/vector/accelerator_vector_adder.c -o arithmetic/vector/accelerator_vector_adder.run
gcc arithmetic/vector/accelerator_vector_subtractor.c -o arithmetic/vector/accelerator_vector_subtractor.run
gcc arithmetic/vector/accelerator_vector_divider.c -o arithmetic/vector/accelerator_vector_divider.run
gcc arithmetic/vector/accelerator_vector_multiplier.c -o arithmetic/vector/accelerator_vector_multiplier.run
gcc math/matrix/accelerator_matrix_deviation_function.c -o math/matrix/accelerator_matrix_deviation_function.run
gcc math/matrix/accelerator_matrix_logistic_function.c -lm -o math/matrix/accelerator_matrix_logistic_function.run
gcc math/matrix/accelerator_matrix_mean_function.c -o math/matrix/accelerator_matrix_mean_function.run
gcc math/matrix/accelerator_matrix_oneplus_function.c -lm -o math/matrix/accelerator_matrix_oneplus_function.run
gcc math/scalar/accelerator_scalar_deviation_function.c -o math/scalar/accelerator_scalar_deviation_function.run
gcc math/scalar/accelerator_scalar_logistic_function.c -lm -o math/scalar/accelerator_scalar_logistic_function.run
gcc math/scalar/accelerator_scalar_mean_function.c -o math/scalar/accelerator_scalar_mean_function.run
gcc math/scalar/accelerator_scalar_oneplus_function.c -lm -o math/scalar/accelerator_scalar_oneplus_function.run
gcc math/vector/accelerator_vector_deviation_function.c -o math/vector/accelerator_vector_deviation_function.run
gcc math/vector/accelerator_vector_logistic_function.c -lm -o math/vector/accelerator_vector_logistic_function.run
gcc math/vector/accelerator_vector_mean_function.c -o math/vector/accelerator_vector_mean_function.run
gcc math/vector/accelerator_vector_oneplus_function.c -lm -o math/vector/accelerator_vector_oneplus_function.run
gcc nn/ann/components/accelerator_masked_multi_head_attention.c -o nn/ann/components/accelerator_masked_multi_head_attention.run
gcc nn/ann/components/accelerator_masked_scaled_dot_product_attention.c -o nn/ann/components/accelerator_masked_scaled_dot_product_attention.run
gcc nn/ann/components/accelerator_multi_head_attention.c -o nn/ann/components/accelerator_multi_head_attention.run
gcc nn/ann/components/accelerator_scaled_dot_product_attention.c -o nn/ann/components/accelerator_scaled_dot_product_attention.run
gcc nn/ann/fnn/accelerator_fnn.c -o nn/ann/fnn/accelerator_fnn.run
gcc nn/ann/functions/accelerator_layer_norm.c -o nn/ann/functions/accelerator_layer_norm.run
gcc nn/ann/functions/accelerator_positional_encoding.c -o nn/ann/functions/accelerator_positional_encoding.run
gcc nn/ann/inputs/accelerator_inputs_vector.c -o nn/ann/inputs/accelerator_inputs_vector.run
gcc nn/ann/inputs/accelerator_keys_vector.c -o nn/ann/inputs/accelerator_keys_vector.run
gcc nn/ann/inputs/accelerator_queries_vector.c -o nn/ann/inputs/accelerator_queries_vector.run
gcc nn/ann/inputs/accelerator_values_vector.c -o nn/ann/inputs/accelerator_values_vector.run
gcc nn/ann/lstm/accelerator_activation_gate_vector.c -o nn/ann/lstm/accelerator_activation_gate_vector.run
gcc nn/ann/lstm/accelerator_forget_gate_vector.c -o nn/ann/lstm/accelerator_forget_gate_vector.run
gcc nn/ann/lstm/accelerator_hidden_gate_vector.c -o nn/ann/lstm/accelerator_hidden_gate_vector.run
gcc nn/ann/lstm/accelerator_input_gate_vector.c -o nn/ann/lstm/accelerator_input_gate_vector.run
gcc nn/ann/lstm/accelerator_lstm.c -o nn/ann/lstm/accelerator_lstm.run
gcc nn/ann/lstm/accelerator_output_gate_vector.c -o nn/ann/lstm/accelerator_output_gate_vector.run
gcc nn/ann/lstm/accelerator_state_gate_vector.c -o nn/ann/lstm/accelerator_state_gate_vector.run
gcc nn/ann/top/accelerator_controller.c -o nn/ann/top/accelerator_controller.run
gcc nn/ann/top/accelerator_decoder.c -o nn/ann/top/accelerator_decoder.run
gcc nn/ann/top/accelerator_encoder.c -o nn/ann/top/accelerator_encoder.run
gcc nn/dnc/memory/accelerator_addressing.c -o nn/dnc/memory/accelerator_addressing.run
gcc nn/dnc/memory/accelerator_allocation_weighting.c -o nn/dnc/memory/accelerator_allocation_weighting.run
gcc nn/dnc/memory/accelerator_backward_weighting.c -o nn/dnc/memory/accelerator_backward_weighting.run
gcc nn/dnc/memory/accelerator_forward_weighting.c -o nn/dnc/memory/accelerator_forward_weighting.run
gcc nn/dnc/memory/accelerator_matrix_content_based_addressing.c -o nn/dnc/memory/accelerator_matrix_content_based_addressing.run
gcc nn/dnc/memory/accelerator_memory_matrix.c -o nn/dnc/memory/accelerator_memory_matrix.run
gcc nn/dnc/memory/accelerator_memory_retention_vector.c -o nn/dnc/memory/accelerator_memory_retention_vector.run
gcc nn/dnc/memory/accelerator_precedence_weighting.c -o nn/dnc/memory/accelerator_precedence_weighting.run
gcc nn/dnc/memory/accelerator_sort_vector.c -o nn/dnc/memory/accelerator_sort_vector.run
gcc nn/dnc/memory/accelerator_temporal_link_matrix.c -o nn/dnc/memory/accelerator_temporal_link_matrix.run
gcc nn/dnc/memory/accelerator_usage_vector.c -o nn/dnc/memory/accelerator_usage_vector.run
gcc nn/dnc/memory/accelerator_vector_content_based_addressing.c -o nn/dnc/memory/accelerator_vector_content_based_addressing.run
gcc nn/dnc/read_heads/accelerator_read_content_weighting.c -o nn/dnc/read_heads/accelerator_read_content_weighting.run
gcc nn/dnc/read_heads/accelerator_read_vectors.c -o nn/dnc/read_heads/accelerator_read_vectors.run
gcc nn/dnc/read_heads/accelerator_read_weighting.c -o nn/dnc/read_heads/accelerator_read_weighting.run
gcc nn/dnc/top/accelerator_interface_matrix.c -o nn/dnc/top/accelerator_interface_matrix.run
gcc nn/dnc/top/accelerator_interface_top.c -o nn/dnc/top/accelerator_interface_top.run
gcc nn/dnc/top/accelerator_interface_vector.c -o nn/dnc/top/accelerator_interface_vector.run
gcc nn/dnc/top/accelerator_output_vector.c -o nn/dnc/top/accelerator_output_vector.run
gcc nn/dnc/top/accelerator_top.c -o nn/dnc/top/accelerator_top.run
gcc nn/dnc/trained/accelerator_trained_top.c -o nn/dnc/trained/accelerator_trained_top.run
gcc nn/dnc/write_heads/accelerator_write_content_weighting.c -o nn/dnc/write_heads/accelerator_write_content_weighting.run
gcc nn/dnc/write_heads/accelerator_write_weighting.c -o nn/dnc/write_heads/accelerator_write_weighting.run
gcc nn/fnn/convolutional/accelerator_controller.c -o nn/fnn/convolutional/accelerator_controller.run
gcc nn/fnn/standard/accelerator_controller.c -o nn/fnn/standard/accelerator_controller.run
gcc nn/lstm/convolutional/accelerator_activation_gate_vector.c -o nn/lstm/convolutional/accelerator_activation_gate_vector.run
gcc nn/lstm/convolutional/accelerator_controller.c -o nn/lstm/convolutional/accelerator_controller.run
gcc nn/lstm/convolutional/accelerator_forget_gate_vector.c -o nn/lstm/convolutional/accelerator_forget_gate_vector.run
gcc nn/lstm/convolutional/accelerator_hidden_gate_vector.c -o nn/lstm/convolutional/accelerator_hidden_gate_vector.run
gcc nn/lstm/convolutional/accelerator_input_gate_vector.c -o nn/lstm/convolutional/accelerator_input_gate_vector.run
gcc nn/lstm/convolutional/accelerator_output_gate_vector.c -o nn/lstm/convolutional/accelerator_output_gate_vector.run
gcc nn/lstm/convolutional/accelerator_state_gate_vector.c -o nn/lstm/convolutional/accelerator_state_gate_vector.run
gcc nn/lstm/standard/accelerator_activation_gate_vector.c -o nn/lstm/standard/accelerator_activation_gate_vector.run
gcc nn/lstm/standard/accelerator_controller.c -o nn/lstm/standard/accelerator_controller.run
gcc nn/lstm/standard/accelerator_forget_gate_vector.c -o nn/lstm/standard/accelerator_forget_gate_vector.run
gcc nn/lstm/standard/accelerator_hidden_gate_vector.c -o nn/lstm/standard/accelerator_hidden_gate_vector.run
gcc nn/lstm/standard/accelerator_input_gate_vector.c -o nn/lstm/standard/accelerator_input_gate_vector.run
gcc nn/lstm/standard/accelerator_output_gate_vector.c -o nn/lstm/standard/accelerator_output_gate_vector.run
gcc nn/lstm/standard/accelerator_state_gate_vector.c -o nn/lstm/standard/accelerator_state_gate_vector.run
gcc nn/ntm/memory/accelerator_addressing.c -o nn/ntm/memory/accelerator_addressing.run
gcc nn/ntm/memory/accelerator_matrix_content_based_addressing.c -o nn/ntm/memory/accelerator_matrix_content_based_addressing.run
gcc nn/ntm/memory/accelerator_vector_content_based_addressing.c -o nn/ntm/memory/accelerator_vector_content_based_addressing.run
gcc nn/ntm/read_heads/accelerator_reading.c -o nn/ntm/read_heads/accelerator_reading.run
gcc nn/ntm/top/accelerator_interface_matrix.c -o nn/ntm/top/accelerator_interface_matrix.run
gcc nn/ntm/top/accelerator_interface_top.c -o nn/ntm/top/accelerator_interface_top.run
gcc nn/ntm/top/accelerator_interface_vector.c -o nn/ntm/top/accelerator_interface_vector.run
gcc nn/ntm/top/accelerator_output_vector.c -o nn/ntm/top/accelerator_output_vector.run
gcc nn/ntm/top/accelerator_top.c -o nn/ntm/top/accelerator_top.run
gcc nn/ntm/trained/accelerator_trained_top.c -o nn/ntm/trained/accelerator_trained_top.run
gcc nn/ntm/write_heads/accelerator_erasing.c -o nn/ntm/write_heads/accelerator_erasing.run
gcc nn/ntm/write_heads/accelerator_writing.c -o nn/ntm/write_heads/accelerator_writing.run
#gcc state/feedback/accelerator_state_matrix_feedforward.c -o state/feedback/accelerator_state_matrix_feedforward.run
#gcc state/feedback/accelerator_state_matrix_input.c -o state/feedback/accelerator_state_matrix_input.run
#gcc state/feedback/accelerator_state_matrix_output.c -o state/feedback/accelerator_state_matrix_output.run
#gcc state/feedback/accelerator_state_matrix_state.c -o state/feedback/accelerator_state_matrix_state.run
#gcc state/outputs/accelerator_state_vector_output.c -o state/outputs/accelerator_state_vector_output.run
#gcc state/outputs/accelerator_state_vector_state.c -o state/outputs/accelerator_state_vector_state.run
#gcc state/top/accelerator_state_top.c -o state/top/accelerator_state_top.run
gcc trainer/differentiation/accelerator_matrix_controller_differentiation.c -o trainer/differentiation/accelerator_matrix_controller_differentiation.run
gcc trainer/differentiation/accelerator_vector_controller_differentiation.c -o trainer/differentiation/accelerator_vector_controller_differentiation.run
gcc trainer/fnn/accelerator_fnn_b_trainer.c -o trainer/fnn/accelerator_fnn_b_trainer.run
gcc trainer/fnn/accelerator_fnn_d_trainer.c -o trainer/fnn/accelerator_fnn_d_trainer.run
gcc trainer/fnn/accelerator_fnn_k_trainer.c -o trainer/fnn/accelerator_fnn_k_trainer.run
gcc trainer/fnn/accelerator_fnn_trainer.c -o trainer/fnn/accelerator_fnn_trainer.run
gcc trainer/fnn/accelerator_fnn_u_trainer.c -o trainer/fnn/accelerator_fnn_u_trainer.run
gcc trainer/fnn/accelerator_fnn_v_trainer.c -o trainer/fnn/accelerator_fnn_v_trainer.run
gcc trainer/fnn/accelerator_fnn_w_trainer.c -o trainer/fnn/accelerator_fnn_w_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_b_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_b_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_d_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_d_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_k_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_k_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_u_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_u_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_v_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_v_trainer.run
gcc trainer/lstm/activation/accelerator_lstm_activation_w_trainer.c -o trainer/lstm/activation/accelerator_lstm_activation_w_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_b_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_b_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_d_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_d_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_k_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_k_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_u_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_u_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_v_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_v_trainer.run
gcc trainer/lstm/forget/accelerator_lstm_forget_w_trainer.c -o trainer/lstm/forget/accelerator_lstm_forget_w_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_b_trainer.c -o trainer/lstm/input/accelerator_lstm_input_b_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_d_trainer.c -o trainer/lstm/input/accelerator_lstm_input_d_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_k_trainer.c -o trainer/lstm/input/accelerator_lstm_input_k_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_trainer.c -o trainer/lstm/input/accelerator_lstm_input_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_u_trainer.c -o trainer/lstm/input/accelerator_lstm_input_u_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_v_trainer.c -o trainer/lstm/input/accelerator_lstm_input_v_trainer.run
gcc trainer/lstm/input/accelerator_lstm_input_w_trainer.c -o trainer/lstm/input/accelerator_lstm_input_w_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_b_trainer.c -o trainer/lstm/output/accelerator_lstm_output_b_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_d_trainer.c -o trainer/lstm/output/accelerator_lstm_output_d_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_k_trainer.c -o trainer/lstm/output/accelerator_lstm_output_k_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_trainer.c -o trainer/lstm/output/accelerator_lstm_output_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_u_trainer.c -o trainer/lstm/output/accelerator_lstm_output_u_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_v_trainer.c -o trainer/lstm/output/accelerator_lstm_output_v_trainer.run
gcc trainer/lstm/output/accelerator_lstm_output_w_trainer.c -o trainer/lstm/output/accelerator_lstm_output_w_trainer.run
