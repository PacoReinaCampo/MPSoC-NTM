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
rm -rf arithmetic/matrix/adder/ntm_matrix_adder.run
rm -rf arithmetic/matrix/divider/ntm_matrix_divider.run
rm -rf arithmetic/matrix/multiplier/ntm_matrix_multiplier.run
rm -rf arithmetic/matrix/subtractor/ntm_matrix_subtractor.run
rm -rf arithmetic/scalar/adder/ntm_scalar_adder.run
rm -rf arithmetic/scalar/divider/ntm_scalar_divider.run
rm -rf arithmetic/scalar/multiplier/ntm_scalar_multiplier.run
rm -rf arithmetic/scalar/subtractor/ntm_scalar_subtractor.run
rm -rf arithmetic/tensor/adder/ntm_tensor_adder.run
rm -rf arithmetic/tensor/divider/ntm_tensor_divider.run
rm -rf arithmetic/tensor/multiplier/ntm_tensor_multiplier.run
rm -rf arithmetic/tensor/subtractor/ntm_tensor_subtractor.run
rm -rf arithmetic/vector/adder/ntm_vector_adder.run
rm -rf arithmetic/vector/divider/ntm_vector_divider.run
rm -rf arithmetic/vector/multiplier/ntm_vector_multiplier.run
rm -rf arithmetic/vector/subtractor/ntm_vector_subtractor.run
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
rm -rf nn/ann/controller/lstm/ntm_lstm.run
rm -rf nn/ann/functions/ntm_layer_norm.run
rm -rf nn/ann/functions/ntm_positional_encoding.run
rm -rf nn/ann/inputs/ntm_inputs_vector.run
rm -rf nn/ann/inputs/ntm_keys_vector.run
rm -rf nn/ann/inputs/ntm_queries_vector.run
rm -rf nn/ann/inputs/ntm_values_vector.run
rm -rf nn/ann/top/ntm_controller.run
rm -rf nn/ann/top/ntm_decoder.run
rm -rf nn/ann/top/ntm_encoder.run
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
