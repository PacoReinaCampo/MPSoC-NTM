all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_vhdl_pkg.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/pkg/accelerator_math_vhdl_pkg.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/pkg/accelerator_lstm_controller_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_summation.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_module.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_inverse.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_summation.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_transpose.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_convolution.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_inverse.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/vector/accelerator_vector_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/vector/accelerator_vector_integration.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/vector/accelerator_vector_softmax.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/matrix/accelerator_matrix_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/matrix/accelerator_matrix_integration.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/matrix/accelerator_matrix_softmax.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/tensor/accelerator_tensor_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/tensor/accelerator_tensor_integration.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/calculus/tensor/accelerator_tensor_softmax.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_oneplus_function.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_oneplus_function.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_oneplus_function.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_logarithm_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_logarithm_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_logarithm_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../../bench/vhdl/code/tests/design/controller/LSTM/standard/accelerator_standard_lstm_pkg.vhd
	ghdl -a --std=08 ../../../../../../../../bench/vhdl/code/tests/design/controller/LSTM/standard/accelerator_standard_lstm_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../../bench/vhdl/code/tests/design/controller/LSTM/standard/accelerator_standard_lstm_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_standard_lstm_testbench
	ghdl -r --std=08 accelerator_standard_lstm_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_standard_lstm_testbench.tree

clean:
	rm -f *.cf *.tree