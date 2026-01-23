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

rm -rf arithmetic/matrix/accelerator_matrix_adder.run
rm -rf arithmetic/matrix/accelerator_matrix_divider.run
rm -rf arithmetic/matrix/accelerator_matrix_multiplier.run
rm -rf arithmetic/scalar/accelerator_scalar_subtractor.run
rm -rf arithmetic/scalar/accelerator_scalar_adder.run
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
rm -rf controller/fnn/convolutional/accelerator_controller.run
rm -rf controller/fnn/standard/accelerator_controller.run
rm -rf controller/lstm/convolutional/accelerator_activation_gate_vector.run
rm -rf controller/lstm/convolutional/accelerator_controller.run
rm -rf controller/lstm/convolutional/accelerator_forget_gate_vector.run
rm -rf controller/lstm/convolutional/accelerator_hidden_gate_vector.run
rm -rf controller/lstm/convolutional/accelerator_input_gate_vector.run
rm -rf controller/lstm/convolutional/accelerator_output_gate_vector.run
rm -rf controller/lstm/convolutional/accelerator_state_gate_vector.run
rm -rf controller/lstm/standard/accelerator_activation_gate_vector.run
rm -rf controller/lstm/standard/accelerator_controller.run
rm -rf controller/lstm/standard/accelerator_forget_gate_vector.run
rm -rf controller/lstm/standard/accelerator_hidden_gate_vector.run
rm -rf controller/lstm/standard/accelerator_input_gate_vector.run
rm -rf controller/lstm/standard/accelerator_output_gate_vector.run
rm -rf controller/lstm/standard/accelerator_state_gate_vector.run
rm -rf transformer/components/accelerator_masked_multi_head_attention.run
rm -rf transformer/components/accelerator_masked_scaled_dot_product_attention.run
rm -rf transformer/components/accelerator_multi_head_attention.run
rm -rf transformer/components/accelerator_scaled_dot_product_attention.run
rm -rf transformer/fnn/accelerator_fnn.run
rm -rf transformer/functions/accelerator_layer_norm.run
rm -rf transformer/functions/accelerator_positional_encoding.run
rm -rf transformer/inputs/accelerator_inputs_vector.run
rm -rf transformer/inputs/accelerator_keys_vector.run
rm -rf transformer/inputs/accelerator_queries_vector.run
rm -rf transformer/inputs/accelerator_values_vector.run
rm -rf transformer/lstm/accelerator_activation_gate_vector.run
rm -rf transformer/lstm/accelerator_forget_gate_vector.run
rm -rf transformer/lstm/accelerator_hidden_gate_vector.run
rm -rf transformer/lstm/accelerator_input_gate_vector.run
rm -rf transformer/lstm/accelerator_lstm.run
rm -rf transformer/lstm/accelerator_output_gate_vector.run
rm -rf transformer/lstm/accelerator_state_gate_vector.run
rm -rf transformer/top/accelerator_controller.run
rm -rf transformer/top/accelerator_decoder.run
rm -rf transformer/top/accelerator_encoder.run
rm -rf dnc/memory/accelerator_addressing.run
rm -rf dnc/memory/accelerator_allocation_weighting.run
rm -rf dnc/memory/accelerator_backward_weighting.run
rm -rf dnc/memory/accelerator_forward_weighting.run
rm -rf dnc/memory/accelerator_matrix_content_based_addressing.run
rm -rf dnc/memory/accelerator_memory_matrix.run
rm -rf dnc/memory/accelerator_memory_retention_vector.run
rm -rf dnc/memory/accelerator_precedence_weighting.run
rm -rf dnc/memory/accelerator_read_content_weighting.run
rm -rf dnc/memory/accelerator_read_vectors.run
rm -rf dnc/memory/accelerator_read_weighting.run
rm -rf dnc/memory/accelerator_sort_vector.run
rm -rf dnc/memory/accelerator_temporal_link_matrix.run
rm -rf dnc/memory/accelerator_usage_vector.run
rm -rf dnc/memory/accelerator_vector_content_based_addressing.run
rm -rf dnc/memory/accelerator_write_content_weighting.run
rm -rf dnc/memory/accelerator_write_weighting.run
rm -rf dnc/top/accelerator_interface_matrix.run
rm -rf dnc/top/accelerator_interface_top.run
rm -rf dnc/top/accelerator_interface_vector.run
rm -rf dnc/top/accelerator_output_vector.run
rm -rf dnc/top/accelerator_top.run
rm -rf dnc/trained/accelerator_trained_top.run
rm -rf algebra/matrix/accelerator_matrix_convolution.run
rm -rf algebra/matrix/accelerator_matrix_inverse.run
rm -rf algebra/matrix/accelerator_matrix_multiplication.run
rm -rf algebra/matrix/accelerator_matrix_product.run
rm -rf algebra/matrix/accelerator_matrix_summation.run
rm -rf algebra/matrix/accelerator_matrix_transpose.run
rm -rf algebra/matrix/accelerator_matrix_vector_convolution.run
rm -rf algebra/matrix/accelerator_matrix_vector_product.run
rm -rf algebra/matrix/accelerator_transpose_vector_product.run
rm -rf algebra/scalar/accelerator_scalar_multiplication.run
rm -rf algebra/scalar/accelerator_scalar_summation.run
rm -rf algebra/tensor/accelerator_tensor_convolution.run
rm -rf algebra/tensor/accelerator_tensor_inverse.run
rm -rf algebra/tensor/accelerator_tensor_matrix_convolution.run
rm -rf algebra/tensor/accelerator_tensor_matrix_product.run
rm -rf algebra/tensor/accelerator_tensor_multiplication.run
rm -rf algebra/tensor/accelerator_tensor_product.run
rm -rf algebra/tensor/accelerator_tensor_summation.run
rm -rf algebra/tensor/accelerator_tensor_transpose.run
rm -rf algebra/vector/accelerator_dot_product.run
rm -rf algebra/vector/accelerator_vector_convolution.run
rm -rf algebra/vector/accelerator_vector_cosine_similarity.run
rm -rf algebra/vector/accelerator_vector_module.run
rm -rf algebra/vector/accelerator_vector_multiplication.run
rm -rf algebra/vector/accelerator_vector_summation.run
rm -rf algebra/matrix/accelerator_matrix_differentiation.run
rm -rf algebra/matrix/accelerator_matrix_integration.run
rm -rf algebra/matrix/accelerator_matrix_softmax.run
rm -rf algebra/tensor/accelerator_tensor_differentiation.run
rm -rf algebra/tensor/accelerator_tensor_integration.run
rm -rf algebra/tensor/accelerator_tensor_softmax.run
rm -rf algebra/vector/accelerator_vector_differentiation.run
rm -rf algebra/vector/accelerator_vector_integration.run
rm -rf algebra/vector/accelerator_vector_softmax.run
rm -rf math/matrix/accelerator_matrix_logistic_function.run
rm -rf math/matrix/accelerator_matrix_oneplus_function.run
rm -rf math/scalar/accelerator_scalar_logistic_function.run
rm -rf math/scalar/accelerator_scalar_oneplus_function.run
rm -rf math/vector/accelerator_vector_logistic_function.run
rm -rf math/vector/accelerator_vector_oneplus_function.run
rm -rf math/matrix/accelerator_matrix_deviation_function.run
rm -rf math/matrix/accelerator_matrix_mean_function.run
rm -rf math/scalar/accelerator_scalar_deviation_function.run
rm -rf math/scalar/accelerator_scalar_mean_function.run
rm -rf math/vector/accelerator_vector_deviation_function.run
rm -rf math/vector/accelerator_vector_mean_function.run
rm -rf ntm/memory/accelerator_addressing.run
rm -rf ntm/memory/accelerator_matrix_content_based_addressing.run
rm -rf ntm/memory/accelerator_vector_content_based_addressing.run
rm -rf ntm/read_heads/accelerator_reading.run
rm -rf ntm/top/accelerator_interface_matrix.run
rm -rf ntm/top/accelerator_interface_top.run
rm -rf ntm/top/accelerator_interface_vector.run
rm -rf ntm/top/accelerator_output_vector.run
rm -rf ntm/top/accelerator_top.run
rm -rf ntm/trained/accelerator_trained_top.run
rm -rf ntm/write_heads/accelerator_erasing.run
rm -rf ntm/write_heads/accelerator_writing.run
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
