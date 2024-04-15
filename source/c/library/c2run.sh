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
rm -rf controller/fnn/convolutional/ntm_controller.run
rm -rf controller/fnn/standard/ntm_controller.run
rm -rf controller/lstm/convolutional/ntm_activation_gate_vector.run
rm -rf controller/lstm/convolutional/ntm_controller.run
rm -rf controller/lstm/convolutional/ntm_forget_gate_vector.run
rm -rf controller/lstm/convolutional/ntm_hidden_gate_vector.run
rm -rf controller/lstm/convolutional/ntm_input_gate_vector.run
rm -rf controller/lstm/convolutional/ntm_output_gate_vector.run
rm -rf controller/lstm/convolutional/ntm_state_gate_vector.run
rm -rf controller/lstm/standard/ntm_activation_gate_vector.run
rm -rf controller/lstm/standard/ntm_controller.run
rm -rf controller/lstm/standard/ntm_forget_gate_vector.run
rm -rf controller/lstm/standard/ntm_hidden_gate_vector.run
rm -rf controller/lstm/standard/ntm_input_gate_vector.run
rm -rf controller/lstm/standard/ntm_output_gate_vector.run
rm -rf controller/lstm/standard/ntm_state_gate_vector.run
rm -rf transformer/components/ntm_masked_multi_head_attention.run
rm -rf transformer/components/ntm_masked_scaled_dot_product_attention.run
rm -rf transformer/components/ntm_multi_head_attention.run
rm -rf transformer/components/ntm_scaled_dot_product_attention.run
rm -rf transformer/fnn/ntm_fnn.run
rm -rf transformer/functions/ntm_layer_norm.run
rm -rf transformer/functions/ntm_positional_encoding.run
rm -rf transformer/inputs/ntm_inputs_vector.run
rm -rf transformer/inputs/ntm_keys_vector.run
rm -rf transformer/inputs/ntm_queries_vector.run
rm -rf transformer/inputs/ntm_values_vector.run
rm -rf transformer/lstm/ntm_activation_gate_vector.run
rm -rf transformer/lstm/ntm_forget_gate_vector.run
rm -rf transformer/lstm/ntm_hidden_gate_vector.run
rm -rf transformer/lstm/ntm_input_gate_vector.run
rm -rf transformer/lstm/ntm_lstm.run
rm -rf transformer/lstm/ntm_output_gate_vector.run
rm -rf transformer/lstm/ntm_state_gate_vector.run
rm -rf transformer/top/ntm_controller.run
rm -rf transformer/top/ntm_decoder.run
rm -rf transformer/top/ntm_encoder.run
rm -rf dnc/memory/dnc_addressing.run
rm -rf dnc/memory/dnc_allocation_weighting.run
rm -rf dnc/memory/dnc_backward_weighting.run
rm -rf dnc/memory/dnc_forward_weighting.run
rm -rf dnc/memory/dnc_matrix_content_based_addressing.run
rm -rf dnc/memory/dnc_memory_matrix.run
rm -rf dnc/memory/dnc_memory_retention_vector.run
rm -rf dnc/memory/dnc_precedence_weighting.run
rm -rf dnc/memory/dnc_read_content_weighting.run
rm -rf dnc/memory/dnc_read_vectors.run
rm -rf dnc/memory/dnc_read_weighting.run
rm -rf dnc/memory/dnc_sort_vector.run
rm -rf dnc/memory/dnc_temporal_link_matrix.run
rm -rf dnc/memory/dnc_usage_vector.run
rm -rf dnc/memory/dnc_vector_content_based_addressing.run
rm -rf dnc/memory/dnc_write_content_weighting.run
rm -rf dnc/memory/dnc_write_weighting.run
rm -rf dnc/top/dnc_interface_matrix.run
rm -rf dnc/top/dnc_interface_top.run
rm -rf dnc/top/dnc_interface_vector.run
rm -rf dnc/top/dnc_output_vector.run
rm -rf dnc/top/dnc_top.run
rm -rf dnc/trained/dnc_trained_top.run
rm -rf algebra/matrix/ntm_matrix_convolution.run
rm -rf algebra/matrix/ntm_matrix_inverse.run
rm -rf algebra/matrix/ntm_matrix_multiplication.run
rm -rf algebra/matrix/ntm_matrix_product.run
rm -rf algebra/matrix/ntm_matrix_summation.run
rm -rf algebra/matrix/ntm_matrix_transpose.run
rm -rf algebra/matrix/ntm_matrix_vector_convolution.run
rm -rf algebra/matrix/ntm_matrix_vector_product.run
rm -rf algebra/matrix/ntm_transpose_vector_product.run
rm -rf algebra/scalar/ntm_scalar_multiplication.run
rm -rf algebra/scalar/ntm_scalar_summation.run
rm -rf algebra/tensor/ntm_tensor_convolution.run
rm -rf algebra/tensor/ntm_tensor_inverse.run
rm -rf algebra/tensor/ntm_tensor_matrix_convolution.run
rm -rf algebra/tensor/ntm_tensor_matrix_product.run
rm -rf algebra/tensor/ntm_tensor_multiplication.run
rm -rf algebra/tensor/ntm_tensor_product.run
rm -rf algebra/tensor/ntm_tensor_summation.run
rm -rf algebra/tensor/ntm_tensor_transpose.run
rm -rf algebra/vector/ntm_dot_product.run
rm -rf algebra/vector/ntm_vector_convolution.run
rm -rf algebra/vector/ntm_vector_cosine_similarity.run
rm -rf algebra/vector/ntm_vector_module.run
rm -rf algebra/vector/ntm_vector_multiplication.run
rm -rf algebra/vector/ntm_vector_summation.run
rm -rf algebra/matrix/ntm_matrix_differentiation.run
rm -rf algebra/matrix/ntm_matrix_integration.run
rm -rf algebra/matrix/ntm_matrix_softmax.run
rm -rf algebra/tensor/ntm_tensor_differentiation.run
rm -rf algebra/tensor/ntm_tensor_integration.run
rm -rf algebra/tensor/ntm_tensor_softmax.run
rm -rf algebra/vector/ntm_vector_differentiation.run
rm -rf algebra/vector/ntm_vector_integration.run
rm -rf algebra/vector/ntm_vector_softmax.run
rm -rf math/matrix/ntm_matrix_logistic_function.run
rm -rf math/matrix/ntm_matrix_oneplus_function.run
rm -rf math/scalar/ntm_scalar_logistic_function.run
rm -rf math/scalar/ntm_scalar_oneplus_function.run
rm -rf math/vector/ntm_vector_logistic_function.run
rm -rf math/vector/ntm_vector_oneplus_function.run
rm -rf math/matrix/ntm_matrix_deviation.run
rm -rf math/matrix/ntm_matrix_mean.run
rm -rf math/scalar/ntm_scalar_deviation.run
rm -rf math/scalar/ntm_scalar_mean.run
rm -rf math/vector/ntm_vector_deviation.run
rm -rf math/vector/ntm_vector_mean.run
rm -rf ntm/memory/ntm_addressing.run
rm -rf ntm/memory/ntm_matrix_content_based_addressing.run
rm -rf ntm/memory/ntm_vector_content_based_addressing.run
rm -rf ntm/read_heads/ntm_reading.run
rm -rf ntm/top/ntm_interface_matrix.run
rm -rf ntm/top/ntm_interface_top.run
rm -rf ntm/top/ntm_interface_vector.run
rm -rf ntm/top/ntm_output_vector.run
rm -rf ntm/top/ntm_top.run
rm -rf ntm/trained/ntm_trained_top.run
rm -rf ntm/write_heads/ntm_erasing.run
rm -rf ntm/write_heads/ntm_writing.run
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
gcc arithmetic/matrix/ntm_matrix_adder.c -o arithmetic/matrix/ntm_matrix_adder.run
gcc arithmetic/matrix/ntm_matrix_divider.c -o arithmetic/matrix/ntm_matrix_divider.run
gcc arithmetic/matrix/ntm_matrix_multiplier.c -o arithmetic/matrix/ntm_matrix_multiplier.run
gcc arithmetic/scalar/ntm_scalar_adder.c -o arithmetic/scalar/ntm_scalar_adder.run
gcc arithmetic/scalar/ntm_scalar_divider.c -o arithmetic/scalar/ntm_scalar_divider.run
gcc arithmetic/scalar/ntm_scalar_multiplier.c -o arithmetic/scalar/ntm_scalar_multiplier.run
gcc arithmetic/tensor/ntm_tensor_adder.c -o arithmetic/tensor/ntm_tensor_adder.run
gcc arithmetic/tensor/ntm_tensor_divider.c -o arithmetic/tensor/ntm_tensor_divider.run
gcc arithmetic/tensor/ntm_tensor_multiplier.c -o arithmetic/tensor/ntm_tensor_multiplier.run
gcc arithmetic/vector/ntm_vector_adder.c -o arithmetic/vector/ntm_vector_adder.run
gcc arithmetic/vector/ntm_vector_divider.c -o arithmetic/vector/ntm_vector_divider.run
gcc arithmetic/vector/ntm_vector_multiplier.c -o arithmetic/vector/ntm_vector_multiplier.run
gcc controller/fnn/convolutional/ntm_controller.c -o controller/fnn/convolutional/ntm_controller.run
gcc controller/fnn/standard/ntm_controller.c -o controller/fnn/standard/ntm_controller.run
gcc controller/lstm/convolutional/ntm_activation_gate_vector.c -o controller/lstm/convolutional/ntm_activation_gate_vector.run
gcc controller/lstm/convolutional/ntm_controller.c -o controller/lstm/convolutional/ntm_controller.run
gcc controller/lstm/convolutional/ntm_forget_gate_vector.c -o controller/lstm/convolutional/ntm_forget_gate_vector.run
gcc controller/lstm/convolutional/ntm_hidden_gate_vector.c -o controller/lstm/convolutional/ntm_hidden_gate_vector.run
gcc controller/lstm/convolutional/ntm_input_gate_vector.c -o controller/lstm/convolutional/ntm_input_gate_vector.run
gcc controller/lstm/convolutional/ntm_output_gate_vector.c -o controller/lstm/convolutional/ntm_output_gate_vector.run
gcc controller/lstm/convolutional/ntm_state_gate_vector.c -o controller/lstm/convolutional/ntm_state_gate_vector.run
gcc controller/lstm/standard/ntm_activation_gate_vector.c -o controller/lstm/standard/ntm_activation_gate_vector.run
gcc controller/lstm/standard/ntm_controller.c -o controller/lstm/standard/ntm_controller.run
gcc controller/lstm/standard/ntm_forget_gate_vector.c -o controller/lstm/standard/ntm_forget_gate_vector.run
gcc controller/lstm/standard/ntm_hidden_gate_vector.c -o controller/lstm/standard/ntm_hidden_gate_vector.run
gcc controller/lstm/standard/ntm_input_gate_vector.c -o controller/lstm/standard/ntm_input_gate_vector.run
gcc controller/lstm/standard/ntm_output_gate_vector.c -o controller/lstm/standard/ntm_output_gate_vector.run
gcc controller/lstm/standard/ntm_state_gate_vector.c -o controller/lstm/standard/ntm_state_gate_vector.run
gcc transformer/components/ntm_masked_multi_head_attention.c -o transformer/components/ntm_masked_multi_head_attention.run
gcc transformer/components/ntm_masked_scaled_dot_product_attention.c -o transformer/components/ntm_masked_scaled_dot_product_attention.run
gcc transformer/components/ntm_multi_head_attention.c -o transformer/components/ntm_multi_head_attention.run
gcc transformer/components/ntm_scaled_dot_product_attention.c -o transformer/components/ntm_scaled_dot_product_attention.run
gcc transformer/fnn/ntm_fnn.c -o transformer/fnn/ntm_fnn.run
gcc transformer/functions/ntm_layer_norm.c -o transformer/functions/ntm_layer_norm.run
gcc transformer/functions/ntm_positional_encoding.c -o transformer/functions/ntm_positional_encoding.run
gcc transformer/inputs/ntm_inputs_vector.c -o transformer/inputs/ntm_inputs_vector.run
gcc transformer/inputs/ntm_keys_vector.c -o transformer/inputs/ntm_keys_vector.run
gcc transformer/inputs/ntm_queries_vector.c -o transformer/inputs/ntm_queries_vector.run
gcc transformer/inputs/ntm_values_vector.c -o transformer/inputs/ntm_values_vector.run
gcc transformer/lstm/ntm_activation_gate_vector.c -o transformer/lstm/ntm_activation_gate_vector.run
gcc transformer/lstm/ntm_forget_gate_vector.c -o transformer/lstm/ntm_forget_gate_vector.run
gcc transformer/lstm/ntm_hidden_gate_vector.c -o transformer/lstm/ntm_hidden_gate_vector.run
gcc transformer/lstm/ntm_input_gate_vector.c -o transformer/lstm/ntm_input_gate_vector.run
gcc transformer/lstm/ntm_lstm.c -o transformer/lstm/ntm_lstm.run
gcc transformer/lstm/ntm_output_gate_vector.c -o transformer/lstm/ntm_output_gate_vector.run
gcc transformer/lstm/ntm_state_gate_vector.c -o transformer/lstm/ntm_state_gate_vector.run
gcc transformer/top/ntm_controller.c -o transformer/top/ntm_controller.run
gcc transformer/top/ntm_decoder.c -o transformer/top/ntm_decoder.run
gcc transformer/top/ntm_encoder.c -o transformer/top/ntm_encoder.run
gcc dnc/memory/dnc_addressing.c -o dnc/memory/dnc_addressing.run
gcc dnc/memory/dnc_allocation_weighting.c -o dnc/memory/dnc_allocation_weighting.run
gcc dnc/memory/dnc_backward_weighting.c -o dnc/memory/dnc_backward_weighting.run
gcc dnc/memory/dnc_forward_weighting.c -o dnc/memory/dnc_forward_weighting.run
gcc dnc/memory/dnc_matrix_content_based_addressing.c -o dnc/memory/dnc_matrix_content_based_addressing.run
gcc dnc/memory/dnc_memory_matrix.c -o dnc/memory/dnc_memory_matrix.run
gcc dnc/memory/dnc_memory_retention_vector.c -o dnc/memory/dnc_memory_retention_vector.run
gcc dnc/memory/dnc_precedence_weighting.c -o dnc/memory/dnc_precedence_weighting.run
gcc dnc/memory/dnc_read_content_weighting.c -o dnc/memory/dnc_read_content_weighting.run
gcc dnc/memory/dnc_read_vectors.c -o dnc/memory/dnc_read_vectors.run
gcc dnc/memory/dnc_read_weighting.c -o dnc/memory/dnc_read_weighting.run
gcc dnc/memory/dnc_sort_vector.c -o dnc/memory/dnc_sort_vector.run
gcc dnc/memory/dnc_temporal_link_matrix.c -o dnc/memory/dnc_temporal_link_matrix.run
gcc dnc/memory/dnc_usage_vector.c -o dnc/memory/dnc_usage_vector.run
gcc dnc/memory/dnc_vector_content_based_addressing.c -o dnc/memory/dnc_vector_content_based_addressing.run
gcc dnc/memory/dnc_write_content_weighting.c -o dnc/memory/dnc_write_content_weighting.run
gcc dnc/memory/dnc_write_weighting.c -o dnc/memory/dnc_write_weighting.run
gcc dnc/top/dnc_interface_matrix.c -o dnc/top/dnc_interface_matrix.run
gcc dnc/top/dnc_interface_top.c -o dnc/top/dnc_interface_top.run
gcc dnc/top/dnc_interface_vector.c -o dnc/top/dnc_interface_vector.run
gcc dnc/top/dnc_output_vector.c -o dnc/top/dnc_output_vector.run
gcc dnc/top/dnc_top.c -o dnc/top/dnc_top.run
gcc dnc/trained/dnc_trained_top.c -o dnc/trained/dnc_trained_top.run
gcc algebra/matrix/ntm_matrix_convolution.c -o algebra/matrix/ntm_matrix_convolution.run
gcc algebra/matrix/ntm_matrix_inverse.c -o algebra/matrix/ntm_matrix_inverse.run
gcc algebra/matrix/ntm_matrix_multiplication.c -o algebra/matrix/ntm_matrix_multiplication.run
gcc algebra/matrix/ntm_matrix_product.c -o algebra/matrix/ntm_matrix_product.run
gcc algebra/matrix/ntm_matrix_summation.c -o algebra/matrix/ntm_matrix_summation.run
gcc algebra/matrix/ntm_matrix_transpose.c -o algebra/matrix/ntm_matrix_transpose.run
gcc algebra/matrix/ntm_matrix_vector_convolution.c -o algebra/matrix/ntm_matrix_vector_convolution.run
gcc algebra/matrix/ntm_matrix_vector_product.c -o algebra/matrix/ntm_matrix_vector_product.run
gcc algebra/matrix/ntm_transpose_vector_product.c -o algebra/matrix/ntm_transpose_vector_product.run
gcc algebra/scalar/ntm_scalar_multiplication.c -o algebra/scalar/ntm_scalar_multiplication.run
gcc algebra/scalar/ntm_scalar_summation.c -o algebra/scalar/ntm_scalar_summation.run
gcc algebra/tensor/ntm_tensor_convolution.c -o algebra/tensor/ntm_tensor_convolution.run
gcc algebra/tensor/ntm_tensor_inverse.c -o algebra/tensor/ntm_tensor_inverse.run
gcc algebra/tensor/ntm_tensor_matrix_convolution.c -o algebra/tensor/ntm_tensor_matrix_convolution.run
gcc algebra/tensor/ntm_tensor_matrix_product.c -o algebra/tensor/ntm_tensor_matrix_product.run
gcc algebra/tensor/ntm_tensor_multiplication.c -o algebra/tensor/ntm_tensor_multiplication.run
gcc algebra/tensor/ntm_tensor_product.c -o algebra/tensor/ntm_tensor_product.run
gcc algebra/tensor/ntm_tensor_summation.c -o algebra/tensor/ntm_tensor_summation.run
gcc algebra/tensor/ntm_tensor_transpose.c -o algebra/tensor/ntm_tensor_transpose.run
gcc algebra/vector/ntm_dot_product.c -o algebra/vector/ntm_dot_product.run
gcc algebra/vector/ntm_vector_convolution.c -o algebra/vector/ntm_vector_convolution.run
gcc algebra/vector/ntm_vector_cosine_similarity.c -o algebra/vector/ntm_vector_cosine_similarity.run
gcc algebra/vector/ntm_vector_module.c -o algebra/vector/ntm_vector_module.run
gcc algebra/vector/ntm_vector_multiplication.c -o algebra/vector/ntm_vector_multiplication.run
gcc algebra/vector/ntm_vector_summation.c -o algebra/vector/ntm_vector_summation.run
gcc algebra/matrix/ntm_matrix_differentiation.c -o algebra/matrix/ntm_matrix_differentiation.run
gcc algebra/matrix/ntm_matrix_integration.c -o algebra/matrix/ntm_matrix_integration.run
gcc algebra/matrix/ntm_matrix_softmax.c -o algebra/matrix/ntm_matrix_softmax.run
gcc algebra/tensor/ntm_tensor_differentiation.c -o algebra/tensor/ntm_tensor_differentiation.run
gcc algebra/tensor/ntm_tensor_integration.c -o algebra/tensor/ntm_tensor_integration.run
gcc algebra/tensor/ntm_tensor_softmax.c -o algebra/tensor/ntm_tensor_softmax.run
gcc algebra/vector/ntm_vector_differentiation.c -o algebra/vector/ntm_vector_differentiation.run
gcc algebra/vector/ntm_vector_integration.c -o algebra/vector/ntm_vector_integration.run
gcc algebra/vector/ntm_vector_softmax.c -o algebra/vector/ntm_vector_softmax.run
gcc math/matrix/ntm_matrix_logistic_function.c -lm -o math/matrix/ntm_matrix_logistic_function.run
gcc math/matrix/ntm_matrix_oneplus_function.c -lm -o math/matrix/ntm_matrix_oneplus_function.run
gcc math/scalar/ntm_scalar_logistic_function.c -lm -o math/scalar/ntm_scalar_logistic_function.run
gcc math/scalar/ntm_scalar_oneplus_function.c -lm -o math/scalar/ntm_scalar_oneplus_function.run
gcc math/vector/ntm_vector_logistic_function.c -lm -o math/vector/ntm_vector_logistic_function.run
gcc math/vector/ntm_vector_oneplus_function.c -lm -o math/vector/ntm_vector_oneplus_function.run
gcc math/matrix/ntm_matrix_deviation.c -o math/matrix/ntm_matrix_deviation.run
gcc math/matrix/ntm_matrix_mean.c -o math/matrix/ntm_matrix_mean.run
gcc math/scalar/ntm_scalar_deviation.c -o math/scalar/ntm_scalar_deviation.run
gcc math/scalar/ntm_scalar_mean.c -o math/scalar/ntm_scalar_mean.run
gcc math/vector/ntm_vector_deviation.c -o math/vector/ntm_vector_deviation.run
gcc math/vector/ntm_vector_mean.c -o math/vector/ntm_vector_mean.run
gcc ntm/memory/ntm_addressing.c -o ntm/memory/ntm_addressing.run
gcc ntm/memory/ntm_matrix_content_based_addressing.c -o ntm/memory/ntm_matrix_content_based_addressing.run
gcc ntm/memory/ntm_vector_content_based_addressing.c -o ntm/memory/ntm_vector_content_based_addressing.run
gcc ntm/read_heads/ntm_reading.c -o ntm/read_heads/ntm_reading.run
gcc ntm/top/ntm_interface_matrix.c -o ntm/top/ntm_interface_matrix.run
gcc ntm/top/ntm_interface_top.c -o ntm/top/ntm_interface_top.run
gcc ntm/top/ntm_interface_vector.c -o ntm/top/ntm_interface_vector.run
gcc ntm/top/ntm_output_vector.c -o ntm/top/ntm_output_vector.run
gcc ntm/top/ntm_top.c -o ntm/top/ntm_top.run
gcc ntm/trained/ntm_trained_top.c -o ntm/trained/ntm_trained_top.run
gcc ntm/write_heads/ntm_erasing.c -o ntm/write_heads/ntm_erasing.run
gcc ntm/write_heads/ntm_writing.c -o ntm/write_heads/ntm_writing.run
#gcc state/feedback/ntm_state_matrix_feedforward.c -o state/feedback/ntm_state_matrix_feedforward.run
#gcc state/feedback/ntm_state_matrix_input.c -o state/feedback/ntm_state_matrix_input.run
#gcc state/feedback/ntm_state_matrix_output.c -o state/feedback/ntm_state_matrix_output.run
#gcc state/feedback/ntm_state_matrix_state.c -o state/feedback/ntm_state_matrix_state.run
#gcc state/outputs/ntm_state_vector_output.c -o state/outputs/ntm_state_vector_output.run
#gcc state/outputs/ntm_state_vector_state.c -o state/outputs/ntm_state_vector_state.run
#gcc state/top/ntm_state_top.c -o state/top/ntm_state_top.run
gcc trainer/differentiation/ntm_matrix_controller_differentiation.c -o trainer/differentiation/ntm_matrix_controller_differentiation.run
gcc trainer/differentiation/ntm_vector_controller_differentiation.c -o trainer/differentiation/ntm_vector_controller_differentiation.run
gcc trainer/fnn/ntm_fnn_b_trainer.c -o trainer/fnn/ntm_fnn_b_trainer.run
gcc trainer/fnn/ntm_fnn_d_trainer.c -o trainer/fnn/ntm_fnn_d_trainer.run
gcc trainer/fnn/ntm_fnn_k_trainer.c -o trainer/fnn/ntm_fnn_k_trainer.run
gcc trainer/fnn/ntm_fnn_trainer.c -o trainer/fnn/ntm_fnn_trainer.run
gcc trainer/fnn/ntm_fnn_u_trainer.c -o trainer/fnn/ntm_fnn_u_trainer.run
gcc trainer/fnn/ntm_fnn_v_trainer.c -o trainer/fnn/ntm_fnn_v_trainer.run
gcc trainer/fnn/ntm_fnn_w_trainer.c -o trainer/fnn/ntm_fnn_w_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_b_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_b_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_d_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_d_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_k_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_k_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_u_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_u_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_v_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_v_trainer.run
gcc trainer/lstm/activation/ntm_lstm_activation_w_trainer.c -o trainer/lstm/activation/ntm_lstm_activation_w_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_b_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_b_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_d_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_d_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_k_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_k_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_u_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_u_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_v_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_v_trainer.run
gcc trainer/lstm/forget/ntm_lstm_forget_w_trainer.c -o trainer/lstm/forget/ntm_lstm_forget_w_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_b_trainer.c -o trainer/lstm/input/ntm_lstm_input_b_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_d_trainer.c -o trainer/lstm/input/ntm_lstm_input_d_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_k_trainer.c -o trainer/lstm/input/ntm_lstm_input_k_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_trainer.c -o trainer/lstm/input/ntm_lstm_input_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_u_trainer.c -o trainer/lstm/input/ntm_lstm_input_u_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_v_trainer.c -o trainer/lstm/input/ntm_lstm_input_v_trainer.run
gcc trainer/lstm/input/ntm_lstm_input_w_trainer.c -o trainer/lstm/input/ntm_lstm_input_w_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_b_trainer.c -o trainer/lstm/output/ntm_lstm_output_b_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_d_trainer.c -o trainer/lstm/output/ntm_lstm_output_d_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_k_trainer.c -o trainer/lstm/output/ntm_lstm_output_k_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_trainer.c -o trainer/lstm/output/ntm_lstm_output_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_u_trainer.c -o trainer/lstm/output/ntm_lstm_output_u_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_v_trainer.c -o trainer/lstm/output/ntm_lstm_output_v_trainer.run
gcc trainer/lstm/output/ntm_lstm_output_w_trainer.c -o trainer/lstm/output/ntm_lstm_output_w_trainer.run
