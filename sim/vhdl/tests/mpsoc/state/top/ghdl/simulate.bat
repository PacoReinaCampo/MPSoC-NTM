@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/dnc_core_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_lstm_controller_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/scalar/ntm_scalar_integer_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/scalar/ntm_scalar_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/scalar/ntm_scalar_integer_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/vector/ntm_vector_integer_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/vector/ntm_vector_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/vector/ntm_vector_integer_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/matrix/ntm_matrix_integer_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/matrix/ntm_matrix_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/matrix/ntm_matrix_integer_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_tensor_transpose.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_transpose.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_scalar_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_tensor_product.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_differentiation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_summation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/scalar/ntm_scalar_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_differentiation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_summation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/vector/ntm_vector_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_convolution_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_cosine_similarity_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_differentiation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_multiplication_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_oneplus_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_softmax_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_summation_function.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/function/matrix/ntm_matrix_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_controller.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_activation_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_activation_trainer.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_forget_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_forget_trainer.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_hidden_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_input_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_input_trainer.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_output_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_output_trainer.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/controller/LSTM/convolutional/ntm_state_gate_vector.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/read_heads/dnc_free_gates.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/read_heads/dnc_read_keys.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/read_heads/dnc_read_modes.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/read_heads/dnc_read_strengths.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/write_heads/dnc_allocation_gate.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/write_heads/dnc_erase_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/write_heads/dnc_write_gate.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/write_heads/dnc_write_key.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/write_heads/dnc_write_strength.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/write_heads/dnc_write_vector.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_content_based_addressing.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_allocation_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_backward_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_forward_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_memory_matrix.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_memory_retention_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_precedence_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_read_content_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_read_vectors.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_read_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_sort_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_temporal_link_matrix.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_usage_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_write_content_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_write_weighting.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/memory/dnc_addressing.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/top/dnc_top.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/top/dnc_output_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/top/dnc_read_interface_vector.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/dnc/top/dnc_write_interface_vector.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/dnc/top/dnc_top_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/dnc/top/dnc_top_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/dnc/top/dnc_top_testbench.vhd
ghdl -m --std=08 dnc_top_testbench
ghdl -r --std=08 dnc_top_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > dnc_top_testbench.tree
pause