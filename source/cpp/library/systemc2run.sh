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
rm -rf controller/FNN/convolutional/ntm_controller.run
rm -rf controller/FNN/standard/ntm_controller.run
rm -rf controller/LSTM/convolutional/ntm_activation_gate_vector.run
rm -rf controller/LSTM/convolutional/ntm_controller.run
rm -rf controller/LSTM/convolutional/ntm_forget_gate_vector.run
rm -rf controller/LSTM/convolutional/ntm_hidden_gate_vector.run
rm -rf controller/LSTM/convolutional/ntm_input_gate_vector.run
rm -rf controller/LSTM/convolutional/ntm_output_gate_vector.run
rm -rf controller/LSTM/convolutional/ntm_state_gate_vector.run
rm -rf controller/LSTM/standard/ntm_activation_gate_vector.run
rm -rf controller/LSTM/standard/ntm_controller.run
rm -rf controller/LSTM/standard/ntm_forget_gate_vector.run
rm -rf controller/LSTM/standard/ntm_hidden_gate_vector.run
rm -rf controller/LSTM/standard/ntm_input_gate_vector.run
rm -rf controller/LSTM/standard/ntm_output_gate_vector.run
rm -rf controller/LSTM/standard/ntm_state_gate_vector.run
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
rm -rf math/algebra/matrix/ntm_matrix_convolution.run
rm -rf math/algebra/matrix/ntm_matrix_inverse.run
rm -rf math/algebra/matrix/ntm_matrix_multiplication.run
rm -rf math/algebra/matrix/ntm_matrix_product.run
rm -rf math/algebra/matrix/ntm_matrix_summation.run
rm -rf math/algebra/matrix/ntm_matrix_transpose.run
rm -rf math/algebra/matrix/ntm_matrix_vector_convolution.run
rm -rf math/algebra/matrix/ntm_matrix_vector_product.run
rm -rf math/algebra/matrix/ntm_transpose_vector_product.run
rm -rf math/algebra/scalar/ntm_scalar_multiplication.run
rm -rf math/algebra/scalar/ntm_scalar_summation.run
rm -rf math/algebra/tensor/ntm_tensor_convolution.run
rm -rf math/algebra/tensor/ntm_tensor_inverse.run
rm -rf math/algebra/tensor/ntm_tensor_matrix_convolution.run
rm -rf math/algebra/tensor/ntm_tensor_matrix_product.run
rm -rf math/algebra/tensor/ntm_tensor_multiplication.run
rm -rf math/algebra/tensor/ntm_tensor_product.run
rm -rf math/algebra/tensor/ntm_tensor_summation.run
rm -rf math/algebra/tensor/ntm_tensor_transpose.run
rm -rf math/algebra/vector/ntm_dot_product.run
rm -rf math/algebra/vector/ntm_vector_convolution.run
rm -rf math/algebra/vector/ntm_vector_cosine_similarity.run
rm -rf math/algebra/vector/ntm_vector_module.run
rm -rf math/algebra/vector/ntm_vector_multiplication.run
rm -rf math/algebra/vector/ntm_vector_summation.run
rm -rf math/calculus/matrix/ntm_matrix_differentiation.run
rm -rf math/calculus/matrix/ntm_matrix_integration.run
rm -rf math/calculus/matrix/ntm_matrix_softmax.run
rm -rf math/calculus/tensor/ntm_tensor_differentiation.run
rm -rf math/calculus/tensor/ntm_tensor_integration.run
rm -rf math/calculus/tensor/ntm_tensor_softmax.run
rm -rf math/calculus/vector/ntm_vector_differentiation.run
rm -rf math/calculus/vector/ntm_vector_integration.run
rm -rf math/calculus/vector/ntm_vector_softmax.run
rm -rf math/function/matrix/ntm_matrix_logistic_function.run
rm -rf math/function/matrix/ntm_matrix_oneplus_function.run
rm -rf math/function/scalar/ntm_scalar_logistic_function.run
rm -rf math/function/scalar/ntm_scalar_oneplus_function.run
rm -rf math/function/vector/ntm_vector_logistic_function.run
rm -rf math/function/vector/ntm_vector_oneplus_function.run
rm -rf math/statitics/matrix/ntm_matrix_deviation.run
rm -rf math/statitics/matrix/ntm_matrix_mean.run
rm -rf math/statitics/scalar/ntm_scalar_deviation.run
rm -rf math/statitics/scalar/ntm_scalar_mean.run
rm -rf math/statitics/vector/ntm_vector_deviation.run
rm -rf math/statitics/vector/ntm_vector_mean.run
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
rm -rf trainer/FNN/ntm_fnn_b_trainer.run
rm -rf trainer/FNN/ntm_fnn_d_trainer.run
rm -rf trainer/FNN/ntm_fnn_k_trainer.run
rm -rf trainer/FNN/ntm_fnn_trainer.run
rm -rf trainer/FNN/ntm_fnn_u_trainer.run
rm -rf trainer/FNN/ntm_fnn_v_trainer.run
rm -rf trainer/FNN/ntm_fnn_w_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_b_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_d_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_k_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_u_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_v_trainer.run
rm -rf trainer/LSTM/activation/ntm_lstm_activation_w_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_b_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_d_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_k_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_u_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_v_trainer.run
rm -rf trainer/LSTM/forget/ntm_lstm_forget_w_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_b_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_d_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_k_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_u_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_v_trainer.run
rm -rf trainer/LSTM/input/ntm_lstm_input_w_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_b_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_d_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_k_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_u_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_v_trainer.run
rm -rf trainer/LSTM/output/ntm_lstm_output_w_trainer.run
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
rm -rf transformer/lstm/ntm_lstm.run
rm -rf transformer/top/ntm_controller.run
rm -rf transformer/top/ntm_decoder.run
rm -rf transformer/top/ntm_encoder.run

# x86-64 ISA
g++ arithmetic/matrix/adder/ntm_matrix_adder_testbench.cpp arithmetic/matrix/adder/ntm_matrix_adder_design.cpp -o arithmetic/matrix/adder/ntm_matrix_adder.run -lsystemc
g++ arithmetic/matrix/divider/ntm_matrix_divider_testbench.cpp arithmetic/matrix/divider/ntm_matrix_divider_design.cpp -o arithmetic/matrix/divider/ntm_matrix_divider.run -lsystemc
g++ arithmetic/matrix/multiplier/ntm_matrix_multiplier_testbench.cpp arithmetic/matrix/multiplier/ntm_matrix_multiplier_design.cpp -o arithmetic/matrix/multiplier/ntm_matrix_multiplier.run -lsystemc
g++ arithmetic/matrix/subtractor/ntm_matrix_subtractor_testbench.cpp arithmetic/matrix/subtractor/ntm_matrix_subtractor_design.cpp -o arithmetic/matrix/subtractor/ntm_matrix_subtractor.run -lsystemc
g++ arithmetic/scalar/adder/ntm_scalar_adder_testbench.cpp arithmetic/scalar/adder/ntm_scalar_adder_design.cpp -o arithmetic/scalar/adder/ntm_scalar_adder.run -lsystemc
g++ arithmetic/scalar/divider/ntm_scalar_divider_testbench.cpp arithmetic/scalar/divider/ntm_scalar_divider_design.cpp -o arithmetic/scalar/divider/ntm_scalar_divider.run -lsystemc
g++ arithmetic/scalar/multiplier/ntm_scalar_multiplier_testbench.cpp arithmetic/scalar/multiplier/ntm_scalar_multiplier_design.cpp -o arithmetic/scalar/multiplier/ntm_scalar_multiplier.run -lsystemc
g++ arithmetic/scalar/subtractor/ntm_scalar_subtractor_testbench.cpp arithmetic/scalar/subtractor/ntm_scalar_subtractor_design.cpp -o arithmetic/scalar/subtractor/ntm_scalar_subtractor.run -lsystemc
g++ arithmetic/tensor/adder/ntm_tensor_adder_testbench.cpp arithmetic/tensor/adder/ntm_tensor_adder_design.cpp -o arithmetic/tensor/adder/ntm_tensor_adder.run -lsystemc
g++ arithmetic/tensor/divider/ntm_tensor_divider_testbench.cpp arithmetic/tensor/divider/ntm_tensor_divider_design.cpp -o arithmetic/tensor/divider/ntm_tensor_divider.run -lsystemc
g++ arithmetic/tensor/multiplier/ntm_tensor_multiplier_testbench.cpp arithmetic/tensor/multiplier/ntm_tensor_multiplier_design.cpp -o arithmetic/tensor/multiplier/ntm_tensor_multiplier.run -lsystemc
g++ arithmetic/tensor/subtractor/ntm_tensor_subtractor_testbench.cpp arithmetic/tensor/subtractor/ntm_tensor_subtractor_design.cpp -o arithmetic/tensor/subtractor/ntm_tensor_subtractor.run -lsystemc
g++ arithmetic/vector/adder/ntm_vector_adder_testbench.cpp arithmetic/vector/adder/ntm_vector_adder_design.cpp -o arithmetic/vector/adder/ntm_vector_adder.run -lsystemc
g++ arithmetic/vector/divider/ntm_vector_divider_testbench.cpp arithmetic/vector/divider/ntm_vector_divider_design.cpp -o arithmetic/vector/divider/ntm_vector_divider.run -lsystemc
g++ arithmetic/vector/multiplier/ntm_vector_multiplier_testbench.cpp arithmetic/vector/multiplier/ntm_vector_multiplier_design.cpp -o arithmetic/vector/multiplier/ntm_vector_multiplier.run -lsystemc
g++ arithmetic/vector/subtractor/ntm_vector_subtractor_testbench.cpp arithmetic/vector/subtractor/ntm_vector_subtractor_design.cpp -o arithmetic/vector/subtractor/ntm_vector_subtractor.run -lsystemc
#g++ controller/FNN/convolutional/ntm_controller_testbench.cpp controller/FNN/convolutional/ntm_controller_design.cpp -o controller/FNN/convolutional/ntm_controller.run -lsystemc
#g++ controller/FNN/standard/ntm_controller_testbench.cpp controller/FNN/standard/ntm_controller_design.cpp -o controller/FNN/standard/ntm_controller.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_activation_gate_vector_testbench.cpp controller/LSTM/convolutional/ntm_activation_gate_vector_design.cpp -o controller/LSTM/convolutional/ntm_activation_gate_vector.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_controller_testbench.cpp controller/LSTM/convolutional/ntm_controller_design.cpp -o controller/LSTM/convolutional/ntm_controller.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_forget_gate_vector_testbench.cpp controller/LSTM/convolutional/ntm_forget_gate_vector_design.cpp -o controller/LSTM/convolutional/ntm_forget_gate_vector.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_hidden_gate_vector_testbench.cpp controller/LSTM/convolutional/ntm_hidden_gate_vector_design.cpp -o controller/LSTM/convolutional/ntm_hidden_gate_vector.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_input_gate_vector_testbench.cpp controller/LSTM/convolutional/ntm_input_gate_vector_design.cpp -o controller/LSTM/convolutional/ntm_input_gate_vector.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_output_gate_vector_testbench.cpp controller/LSTM/convolutional/ntm_output_gate_vector_design.cpp -o controller/LSTM/convolutional/ntm_output_gate_vector.run -lsystemc
#g++ controller/LSTM/convolutional/ntm_state_gate_vector_testbench.cpp controller/LSTM/convolutional/ntm_state_gate_vector_design.cpp -o controller/LSTM/convolutional/ntm_state_gate_vector.run -lsystemc
#g++ controller/LSTM/standard/ntm_activation_gate_vector_testbench.cpp controller/LSTM/standard/ntm_activation_gate_vector_design.cpp -o controller/LSTM/standard/ntm_activation_gate_vector.run -lsystemc
#g++ controller/LSTM/standard/ntm_controller_testbench.cpp controller/LSTM/standard/ntm_controller_design.cpp -o controller/LSTM/standard/ntm_controller.run -lsystemc
#g++ controller/LSTM/standard/ntm_forget_gate_vector_testbench.cpp controller/LSTM/standard/ntm_forget_gate_vector_design.cpp -o controller/LSTM/standard/ntm_forget_gate_vector.run -lsystemc
#g++ controller/LSTM/standard/ntm_hidden_gate_vector_testbench.cpp controller/LSTM/standard/ntm_hidden_gate_vector_design.cpp -o controller/LSTM/standard/ntm_hidden_gate_vector.run -lsystemc
#g++ controller/LSTM/standard/ntm_input_gate_vector_testbench.cpp controller/LSTM/standard/ntm_input_gate_vector_design.cpp -o controller/LSTM/standard/ntm_input_gate_vector.run -lsystemc
#g++ controller/LSTM/standard/ntm_output_gate_vector_testbench.cpp controller/LSTM/standard/ntm_output_gate_vector_design.cpp -o controller/LSTM/standard/ntm_output_gate_vector.run -lsystemc
#g++ controller/LSTM/standard/ntm_state_gate_vector_testbench.cpp controller/LSTM/standard/ntm_state_gate_vector_design.cpp -o controller/LSTM/standard/ntm_state_gate_vector.run -lsystemc
#g++ dnc/memory/dnc_addressing_testbench.cpp dnc/memory/dnc_addressing_design.cpp -o dnc/memory/dnc_addressing.run -lsystemc
#g++ dnc/memory/dnc_allocation_weighting_testbench.cpp dnc/memory/dnc_allocation_weighting_design.cpp -o dnc/memory/dnc_allocation_weighting.run -lsystemc
#g++ dnc/memory/dnc_backward_weighting_testbench.cpp dnc/memory/dnc_backward_weighting_design.cpp -o dnc/memory/dnc_backward_weighting.run -lsystemc
#g++ dnc/memory/dnc_forward_weighting_testbench.cpp dnc/memory/dnc_forward_weighting_design.cpp -o dnc/memory/dnc_forward_weighting.run -lsystemc
#g++ dnc/memory/dnc_matrix_content_based_addressing_testbench.cpp dnc/memory/dnc_matrix_content_based_addressing_design.cpp -o dnc/memory/dnc_matrix_content_based_addressing.run -lsystemc
#g++ dnc/memory/dnc_memory_matrix_testbench.cpp dnc/memory/dnc_memory_matrix_design.cpp -o dnc/memory/dnc_memory_matrix.run -lsystemc
#g++ dnc/memory/dnc_memory_retention_vector_testbench.cpp dnc/memory/dnc_memory_retention_vector_design.cpp -o dnc/memory/dnc_memory_retention_vector.run -lsystemc
#g++ dnc/memory/dnc_precedence_weighting_testbench.cpp dnc/memory/dnc_precedence_weighting_design.cpp -o dnc/memory/dnc_precedence_weighting.run -lsystemc
#g++ dnc/memory/dnc_read_content_weighting_testbench.cpp dnc/memory/dnc_read_content_weighting_design.cpp -o dnc/memory/dnc_read_content_weighting.run -lsystemc
#g++ dnc/memory/dnc_read_vectors_testbench.cpp dnc/memory/dnc_read_vectors_design.cpp -o dnc/memory/dnc_read_vectors.run -lsystemc
#g++ dnc/memory/dnc_read_weighting_testbench.cpp dnc/memory/dnc_read_weighting_design.cpp -o dnc/memory/dnc_read_weighting.run -lsystemc
#g++ dnc/memory/dnc_sort_vector_testbench.cpp dnc/memory/dnc_sort_vector_design.cpp -o dnc/memory/dnc_sort_vector.run -lsystemc
#g++ dnc/memory/dnc_temporal_link_matrix_testbench.cpp dnc/memory/dnc_temporal_link_matrix_design.cpp -o dnc/memory/dnc_temporal_link_matrix.run -lsystemc
#g++ dnc/memory/dnc_usage_vector_testbench.cpp dnc/memory/dnc_usage_vector_design.cpp -o dnc/memory/dnc_usage_vector.run -lsystemc
#g++ dnc/memory/dnc_vector_content_based_addressing_testbench.cpp dnc/memory/dnc_vector_content_based_addressing_design.cpp -o dnc/memory/dnc_vector_content_based_addressing.run -lsystemc
#g++ dnc/memory/dnc_write_content_weighting_testbench.cpp dnc/memory/dnc_write_content_weighting_design.cpp -o dnc/memory/dnc_write_content_weighting.run -lsystemc
#g++ dnc/memory/dnc_write_weighting_testbench.cpp dnc/memory/dnc_write_weighting_design.cpp -o dnc/memory/dnc_write_weighting.run -lsystemc
#g++ dnc/top/dnc_interface_matrix_testbench.cpp dnc/top/dnc_interface_matrix_design.cpp -o dnc/top/dnc_interface_matrix.run -lsystemc
#g++ dnc/top/dnc_interface_top_testbench.cpp dnc/top/dnc_interface_top_design.cpp -o dnc/top/dnc_interface_top.run -lsystemc
#g++ dnc/top/dnc_interface_vector_testbench.cpp dnc/top/dnc_interface_vector_design.cpp -o dnc/top/dnc_interface_vector.run -lsystemc
#g++ dnc/top/dnc_output_vector_testbench.cpp dnc/top/dnc_output_vector_design.cpp -o dnc/top/dnc_output_vector.run -lsystemc
#g++ dnc/top/dnc_top_testbench.cpp dnc/top/dnc_top_design.cpp -o dnc/top/dnc_top.run -lsystemc
#g++ dnc/trained/dnc_trained_top_testbench.cpp dnc/trained/dnc_trained_top_design.cpp -o dnc/trained/dnc_trained_top.run -lsystemc
g++ math/algebra/matrix/ntm_matrix_convolution_testbench.cpp math/algebra/matrix/ntm_matrix_convolution_design.cpp -o math/algebra/matrix/ntm_matrix_convolution.run -lsystemc
#g++ math/algebra/matrix/ntm_matrix_inverse_testbench.cpp math/algebra/matrix/ntm_matrix_inverse_design.cpp -o math/algebra/matrix/ntm_matrix_inverse.run -lsystemc
#g++ math/algebra/matrix/ntm_matrix_multiplication_testbench.cpp math/algebra/matrix/ntm_matrix_multiplication_design.cpp -o math/algebra/matrix/ntm_matrix_multiplication.run -lsystemc
g++ math/algebra/matrix/ntm_matrix_product_testbench.cpp math/algebra/matrix/ntm_matrix_product_design.cpp -o math/algebra/matrix/ntm_matrix_product.run -lsystemc
#g++ math/algebra/matrix/ntm_matrix_summation_testbench.cpp math/algebra/matrix/ntm_matrix_summation_design.cpp -o math/algebra/matrix/ntm_matrix_summation.run -lsystemc
g++ math/algebra/matrix/ntm_matrix_transpose_testbench.cpp math/algebra/matrix/ntm_matrix_transpose_design.cpp -o math/algebra/matrix/ntm_matrix_transpose.run -lsystemc
g++ math/algebra/matrix/ntm_matrix_vector_convolution_testbench.cpp math/algebra/matrix/ntm_matrix_vector_convolution_design.cpp -o math/algebra/matrix/ntm_matrix_vector_convolution.run -lsystemc
g++ math/algebra/matrix/ntm_matrix_vector_product_testbench.cpp math/algebra/matrix/ntm_matrix_vector_product_design.cpp -o math/algebra/matrix/ntm_matrix_vector_product.run -lsystemc
g++ math/algebra/matrix/ntm_transpose_vector_product_testbench.cpp math/algebra/matrix/ntm_transpose_vector_product_design.cpp -o math/algebra/matrix/ntm_transpose_vector_product.run -lsystemc
#g++ math/algebra/scalar/ntm_scalar_multiplication_testbench.cpp math/algebra/scalar/ntm_scalar_multiplication_design.cpp -o math/algebra/scalar/ntm_scalar_multiplication.run -lsystemc
#g++ math/algebra/scalar/ntm_scalar_summation_testbench.cpp math/algebra/scalar/ntm_scalar_summation_design.cpp -o math/algebra/scalar/ntm_scalar_summation.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_convolution_testbench.cpp math/algebra/tensor/ntm_tensor_convolution_design.cpp -o math/algebra/tensor/ntm_tensor_convolution.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_inverse_testbench.cpp math/algebra/tensor/ntm_tensor_inverse_design.cpp -o math/algebra/tensor/ntm_tensor_inverse.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_matrix_convolution_testbench.cpp math/algebra/tensor/ntm_tensor_matrix_convolution_design.cpp -o math/algebra/tensor/ntm_tensor_matrix_convolution.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_matrix_product_testbench.cpp math/algebra/tensor/ntm_tensor_matrix_product_design.cpp -o math/algebra/tensor/ntm_tensor_matrix_product.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_multiplication_testbench.cpp math/algebra/tensor/ntm_tensor_multiplication_design.cpp -o math/algebra/tensor/ntm_tensor_multiplication.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_product_testbench.cpp math/algebra/tensor/ntm_tensor_product_design.cpp -o math/algebra/tensor/ntm_tensor_product.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_summation_testbench.cpp math/algebra/tensor/ntm_tensor_summation_design.cpp -o math/algebra/tensor/ntm_tensor_summation.run -lsystemc
#g++ math/algebra/tensor/ntm_tensor_transpose_testbench.cpp math/algebra/tensor/ntm_tensor_transpose_design.cpp -o math/algebra/tensor/ntm_tensor_transpose.run -lsystemc
#g++ math/algebra/vector/ntm_dot_product_testbench.cpp math/algebra/vector/ntm_dot_product_design.cpp -o math/algebra/vector/ntm_dot_product.run -lsystemc
#g++ math/algebra/vector/ntm_vector_convolution_testbench.cpp math/algebra/vector/ntm_vector_convolution_design.cpp -o math/algebra/vector/ntm_vector_convolution.run -lsystemc
#g++ math/algebra/vector/ntm_vector_cosine_similarity_testbench.cpp math/algebra/vector/ntm_vector_cosine_similarity_design.cpp -o math/algebra/vector/ntm_vector_cosine_similarity.run -lsystemc
#g++ math/algebra/vector/ntm_vector_module_testbench.cpp math/algebra/vector/ntm_vector_module_design.cpp -o math/algebra/vector/ntm_vector_module.run -lsystemc
#g++ math/algebra/vector/ntm_vector_multiplication_testbench.cpp math/algebra/vector/ntm_vector_multiplication_design.cpp -o math/algebra/vector/ntm_vector_multiplication.run -lsystemc
#g++ math/algebra/vector/ntm_vector_summation_testbench.cpp math/algebra/vector/ntm_vector_summation_design.cpp -o math/algebra/vector/ntm_vector_summation.run -lsystemc
#g++ math/calculus/matrix/ntm_matrix_differentiation_testbench.cpp math/calculus/matrix/ntm_matrix_differentiation_design.cpp -o math/calculus/matrix/ntm_matrix_differentiation.run -lsystemc
#g++ math/calculus/matrix/ntm_matrix_integration_testbench.cpp math/calculus/matrix/ntm_matrix_integration_design.cpp -o math/calculus/matrix/ntm_matrix_integration.run -lsystemc
#g++ math/calculus/matrix/ntm_matrix_softmax_testbench.cpp math/calculus/matrix/ntm_matrix_softmax_design.cpp -o math/calculus/matrix/ntm_matrix_softmax.run -lsystemc
#g++ math/calculus/tensor/ntm_tensor_differentiation_testbench.cpp math/calculus/tensor/ntm_tensor_differentiation_design.cpp -o math/calculus/tensor/ntm_tensor_differentiation.run -lsystemc
#g++ math/calculus/tensor/ntm_tensor_integration_testbench.cpp math/calculus/tensor/ntm_tensor_integration_design.cpp -o math/calculus/tensor/ntm_tensor_integration.run -lsystemc
#g++ math/calculus/tensor/ntm_tensor_softmax_testbench.cpp math/calculus/tensor/ntm_tensor_softmax_design.cpp -o math/calculus/tensor/ntm_tensor_softmax.run -lsystemc
#g++ math/calculus/vector/ntm_vector_differentiation_testbench.cpp math/calculus/vector/ntm_vector_differentiation_design.cpp -o math/calculus/vector/ntm_vector_differentiation.run -lsystemc
#g++ math/calculus/vector/ntm_vector_integration_testbench.cpp math/calculus/vector/ntm_vector_integration_design.cpp -o math/calculus/vector/ntm_vector_integration.run -lsystemc
#g++ math/calculus/vector/ntm_vector_softmax_testbench.cpp math/calculus/vector/ntm_vector_softmax_design.cpp -o math/calculus/vector/ntm_vector_softmax.run -lsystemc
#g++ math/function/matrix/ntm_matrix_logistic_function_testbench.cpp math/function/matrix/ntm_matrix_logistic_function_design.cpp -o math/function/matrix/ntm_matrix_logistic_function.run -lsystemc
#g++ math/function/matrix/ntm_matrix_oneplus_function_testbench.cpp math/function/matrix/ntm_matrix_oneplus_function_design.cpp -o math/function/matrix/ntm_matrix_oneplus_function.run -lsystemc
#g++ math/function/scalar/ntm_scalar_logistic_function_testbench.cpp math/function/scalar/ntm_scalar_logistic_function_design.cpp -o math/function/scalar/ntm_scalar_logistic_function.run -lsystemc
#g++ math/function/scalar/ntm_scalar_oneplus_function_testbench.cpp math/function/scalar/ntm_scalar_oneplus_function_design.cpp -o math/function/scalar/ntm_scalar_oneplus_function.run -lsystemc
#g++ math/function/vector/ntm_vector_logistic_function_testbench.cpp math/function/vector/ntm_vector_logistic_function_design.cpp -o math/function/vector/ntm_vector_logistic_function.run -lsystemc
#g++ math/function/vector/ntm_vector_oneplus_function_testbench.cpp math/function/vector/ntm_vector_oneplus_function_design.cpp -o math/function/vector/ntm_vector_oneplus_function.run -lsystemc
#g++ math/statitics/matrix/ntm_matrix_deviation_testbench.cpp math/statitics/matrix/ntm_matrix_deviation_design.cpp -o math/statitics/matrix/ntm_matrix_deviation.run -lsystemc
#g++ math/statitics/matrix/ntm_matrix_mean_testbench.cpp math/statitics/matrix/ntm_matrix_mean_design.cpp -o math/statitics/matrix/ntm_matrix_mean.run -lsystemc
#g++ math/statitics/scalar/ntm_scalar_deviation_testbench.cpp math/statitics/scalar/ntm_scalar_deviation_design.cpp -o math/statitics/scalar/ntm_scalar_deviation.run -lsystemc
#g++ math/statitics/scalar/ntm_scalar_mean_testbench.cpp math/statitics/scalar/ntm_scalar_mean_design.cpp -o math/statitics/scalar/ntm_scalar_mean.run -lsystemc
#g++ math/statitics/vector/ntm_vector_deviation_testbench.cpp math/statitics/vector/ntm_vector_deviation_design.cpp -o math/statitics/vector/ntm_vector_deviation.run -lsystemc
#g++ math/statitics/vector/ntm_vector_mean_testbench.cpp math/statitics/vector/ntm_vector_mean_design.cpp -o math/statitics/vector/ntm_vector_mean.run -lsystemc
#g++ ntm/memory/ntm_addressing_testbench.cpp ntm/memory/ntm_addressing_design.cpp -o ntm/memory/ntm_addressing.run -lsystemc
#g++ ntm/memory/ntm_matrix_content_based_addressing_testbench.cpp ntm/memory/ntm_matrix_content_based_addressing_design.cpp -o ntm/memory/ntm_matrix_content_based_addressing.run -lsystemc
#g++ ntm/memory/ntm_vector_content_based_addressing_testbench.cpp ntm/memory/ntm_vector_content_based_addressing_design.cpp -o ntm/memory/ntm_vector_content_based_addressing.run -lsystemc
#g++ ntm/read_heads/ntm_reading_testbench.cpp ntm/read_heads/ntm_reading_design.cpp -o ntm/read_heads/ntm_reading.run -lsystemc
#g++ ntm/top/ntm_interface_matrix_testbench.cpp ntm/top/ntm_interface_matrix_design.cpp -o ntm/top/ntm_interface_matrix.run -lsystemc
#g++ ntm/top/ntm_interface_top_testbench.cpp ntm/top/ntm_interface_top_design.cpp -o ntm/top/ntm_interface_top.run -lsystemc
#g++ ntm/top/ntm_interface_vector_testbench.cpp ntm/top/ntm_interface_vector_design.cpp -o ntm/top/ntm_interface_vector.run -lsystemc
#g++ ntm/top/ntm_output_vector_testbench.cpp ntm/top/ntm_output_vector_design.cpp -o ntm/top/ntm_output_vector.run -lsystemc
#g++ ntm/top/ntm_top_testbench.cpp ntm/top/ntm_top_design.cpp -o ntm/top/ntm_top.run -lsystemc
#g++ ntm/trained/ntm_trained_top_testbench.cpp ntm/trained/ntm_trained_top_design.cpp -o ntm/trained/ntm_trained_top.run -lsystemc
#g++ ntm/write_heads/ntm_erasing_testbench.cpp ntm/write_heads/ntm_erasing_design.cpp -o ntm/write_heads/ntm_erasing.run -lsystemc
#g++ ntm/write_heads/ntm_writing_testbench.cpp ntm/write_heads/ntm_writing_design.cpp -o ntm/write_heads/ntm_writing.run -lsystemc
#g++ state/feedback/ntm_state_matrix_feedforward_testbench.cpp state/feedback/ntm_state_matrix_feedforward_design.cpp -o state/feedback/ntm_state_matrix_feedforward.run -lsystemc
#g++ state/feedback/ntm_state_matrix_input_testbench.cpp state/feedback/ntm_state_matrix_input_design.cpp -o state/feedback/ntm_state_matrix_input.run -lsystemc
#g++ state/feedback/ntm_state_matrix_output_testbench.cpp state/feedback/ntm_state_matrix_output_design.cpp -o state/feedback/ntm_state_matrix_output.run -lsystemc
#g++ state/feedback/ntm_state_matrix_state_testbench.cpp state/feedback/ntm_state_matrix_state_design.cpp -o state/feedback/ntm_state_matrix_state.run -lsystemc
#g++ state/outputs/ntm_state_vector_output_testbench.cpp state/outputs/ntm_state_vector_output_design.cpp -o state/outputs/ntm_state_vector_output.run -lsystemc
#g++ state/outputs/ntm_state_vector_state_testbench.cpp state/outputs/ntm_state_vector_state_design.cpp -o state/outputs/ntm_state_vector_state.run -lsystemc
#g++ state/top/ntm_state_top_testbench.cpp state/top/ntm_state_top_design.cpp -o state/top/ntm_state_top.run -lsystemc
#g++ trainer/differentiation/ntm_matrix_controller_differentiation_testbench.cpp trainer/differentiation/ntm_matrix_controller_differentiation_design.cpp -o trainer/differentiation/ntm_matrix_controller_differentiation.run -lsystemc
#g++ trainer/differentiation/ntm_vector_controller_differentiation_testbench.cpp trainer/differentiation/ntm_vector_controller_differentiation_design.cpp -o trainer/differentiation/ntm_vector_controller_differentiation.run -lsystemc
#g++ trainer/FNN/ntm_fnn_b_trainer_testbench.cpp trainer/FNN/ntm_fnn_b_trainer_design.cpp -o trainer/FNN/ntm_fnn_b_trainer.run -lsystemc
#g++ trainer/FNN/ntm_fnn_d_trainer_testbench.cpp trainer/FNN/ntm_fnn_d_trainer_design.cpp -o trainer/FNN/ntm_fnn_d_trainer.run -lsystemc
#g++ trainer/FNN/ntm_fnn_k_trainer_testbench.cpp trainer/FNN/ntm_fnn_k_trainer_design.cpp -o trainer/FNN/ntm_fnn_k_trainer.run -lsystemc
#g++ trainer/FNN/ntm_fnn_trainer_testbench.cpp trainer/FNN/ntm_fnn_trainer_design.cpp -o trainer/FNN/ntm_fnn_trainer.run -lsystemc
#g++ trainer/FNN/ntm_fnn_u_trainer_testbench.cpp trainer/FNN/ntm_fnn_u_trainer_design.cpp -o trainer/FNN/ntm_fnn_u_trainer.run -lsystemc
#g++ trainer/FNN/ntm_fnn_v_trainer_testbench.cpp trainer/FNN/ntm_fnn_v_trainer_design.cpp -o trainer/FNN/ntm_fnn_v_trainer.run -lsystemc
#g++ trainer/FNN/ntm_fnn_w_trainer_testbench.cpp trainer/FNN/ntm_fnn_w_trainer_design.cpp -o trainer/FNN/ntm_fnn_w_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_b_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_b_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_b_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_d_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_d_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_d_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_k_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_k_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_k_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_u_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_u_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_u_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_v_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_v_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_v_trainer.run -lsystemc
#g++ trainer/LSTM/activation/ntm_lstm_activation_w_trainer_testbench.cpp trainer/LSTM/activation/ntm_lstm_activation_w_trainer_design.cpp -o trainer/LSTM/activation/ntm_lstm_activation_w_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_b_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_b_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_b_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_d_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_d_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_d_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_k_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_k_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_k_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_u_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_u_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_u_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_v_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_v_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_v_trainer.run -lsystemc
#g++ trainer/LSTM/forget/ntm_lstm_forget_w_trainer_testbench.cpp trainer/LSTM/forget/ntm_lstm_forget_w_trainer_design.cpp -o trainer/LSTM/forget/ntm_lstm_forget_w_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_b_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_b_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_b_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_d_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_d_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_d_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_k_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_k_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_k_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_u_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_u_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_u_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_v_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_v_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_v_trainer.run -lsystemc
#g++ trainer/LSTM/input/ntm_lstm_input_w_trainer_testbench.cpp trainer/LSTM/input/ntm_lstm_input_w_trainer_design.cpp -o trainer/LSTM/input/ntm_lstm_input_w_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_b_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_b_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_b_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_d_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_d_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_d_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_k_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_k_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_k_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_u_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_u_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_u_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_v_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_v_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_v_trainer.run -lsystemc
#g++ trainer/LSTM/output/ntm_lstm_output_w_trainer_testbench.cpp trainer/LSTM/output/ntm_lstm_output_w_trainer_design.cpp -o trainer/LSTM/output/ntm_lstm_output_w_trainer.run -lsystemc
#g++ transformer/components/ntm_masked_multi_head_attention_testbench.cpp transformer/components/ntm_masked_multi_head_attention_design.cpp -o transformer/components/ntm_masked_multi_head_attention.run -lsystemc
#g++ transformer/components/ntm_masked_scaled_dot_product_attention_testbench.cpp transformer/components/ntm_masked_scaled_dot_product_attention_design.cpp -o transformer/components/ntm_masked_scaled_dot_product_attention.run -lsystemc
#g++ transformer/components/ntm_multi_head_attention_testbench.cpp transformer/components/ntm_multi_head_attention_design.cpp -o transformer/components/ntm_multi_head_attention.run -lsystemc
#g++ transformer/components/ntm_scaled_dot_product_attention_testbench.cpp transformer/components/ntm_scaled_dot_product_attention_design.cpp -o transformer/components/ntm_scaled_dot_product_attention.run -lsystemc
#g++ transformer/fnn/ntm_fnn_testbench.cpp transformer/fnn/ntm_fnn_design.cpp -o transformer/fnn/ntm_fnn.run -lsystemc
#g++ transformer/functions/ntm_layer_norm_testbench.cpp transformer/functions/ntm_layer_norm_design.cpp -o transformer/functions/ntm_layer_norm.run -lsystemc
#g++ transformer/functions/ntm_positional_encoding_testbench.cpp transformer/functions/ntm_positional_encoding_design.cpp -o transformer/functions/ntm_positional_encoding.run -lsystemc
#g++ transformer/inputs/ntm_inputs_vector_testbench.cpp transformer/inputs/ntm_inputs_vector_design.cpp -o transformer/inputs/ntm_inputs_vector.run -lsystemc
#g++ transformer/inputs/ntm_keys_vector_testbench.cpp transformer/inputs/ntm_keys_vector_design.cpp -o transformer/inputs/ntm_keys_vector.run -lsystemc
#g++ transformer/inputs/ntm_queries_vector_testbench.cpp transformer/inputs/ntm_queries_vector_design.cpp -o transformer/inputs/ntm_queries_vector.run -lsystemc
#g++ transformer/inputs/ntm_values_vector_testbench.cpp transformer/inputs/ntm_values_vector_design.cpp -o transformer/inputs/ntm_values_vector.run -lsystemc
#g++ transformer/lstm/ntm_lstm_testbench.cpp transformer/lstm/ntm_lstm_design.cpp -o transformer/lstm/ntm_lstm.run -lsystemc
#g++ transformer/top/ntm_controller_testbench.cpp transformer/top/ntm_controller_design.cpp -o transformer/top/ntm_controller.run -lsystemc
#g++ transformer/top/ntm_decoder_testbench.cpp transformer/top/ntm_decoder_design.cpp -o transformer/top/ntm_decoder.run -lsystemc
#g++ transformer/top/ntm_encoder_testbench.cpp transformer/top/ntm_encoder_design.cpp -o transformer/top/ntm_encoder.run -lsystemc
