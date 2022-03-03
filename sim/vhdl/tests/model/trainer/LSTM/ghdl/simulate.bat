@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/ntm_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/ntm_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/ntm_lstm_controller_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/scalar/ntm_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/vector/ntm_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/vector/ntm_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/matrix/ntm_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/matrix/ntm_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/matrix/ntm_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/ntm_dot_product.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/ntm_vector_convolution.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/ntm_vector_cosine_similarity.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/ntm_vector_multiplication.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/ntm_vector_summation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/ntm_vector_module.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/ntm_matrix_convolution.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/ntm_matrix_inverse.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/ntm_matrix_multiplication.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/ntm_matrix_summation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/ntm_matrix_transpose.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/ntm_tensor_convolution.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/ntm_tensor_inverse.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/ntm_tensor_multiplication.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/ntm_tensor_product.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/ntm_tensor_summation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/ntm_tensor_transpose.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/vector/ntm_vector_differentiation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/vector/ntm_vector_integration.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/vector/ntm_vector_softmax.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/matrix/ntm_matrix_differentiation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/matrix/ntm_matrix_integration.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/matrix/ntm_matrix_softmax.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/tensor/ntm_tensor_differentiation.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/tensor/ntm_tensor_integration.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/calculus/tensor/ntm_tensor_softmax.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/scalar/ntm_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/scalar/ntm_scalar_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/vector/ntm_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/vector/ntm_vector_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/matrix/ntm_matrix_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/matrix/ntm_matrix_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/ntm_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/ntm_scalar_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/ntm_scalar_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/ntm_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/scalar/ntm_scalar_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/ntm_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/ntm_vector_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/ntm_vector_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/ntm_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/vector/ntm_vector_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/ntm_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/ntm_matrix_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/ntm_matrix_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/ntm_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/series/matrix/ntm_matrix_tanh_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/trainer/LSTM/ntm_activation_trainer.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/trainer/LSTM/ntm_forget_trainer.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/trainer/LSTM/ntm_input_trainer.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/trainer/LSTM/ntm_output_trainer.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_controller.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_activation_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_forget_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_hidden_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_input_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_output_gate_vector.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/controller/LSTM/standard/ntm_state_gate_vector.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/trainer/LSTM/standard/ntm_standard_lstm_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/trainer/LSTM/standard/ntm_standard_lstm_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/trainer/LSTM/standard/ntm_standard_lstm_testbench.vhd
pause