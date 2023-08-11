all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_math_pkg.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_fnn_controller_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/model_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/model_tensor_transpose.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/model_matrix_transpose.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/model_scalar_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/algebra/model_tensor_product.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_convolution_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_cosine_similarity_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_differentiation_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_multiplication_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_oneplus_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_softmax_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_summation_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_convolution_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_cosine_similarity_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_differentiation_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_multiplication_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_oneplus_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_softmax_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_summation_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_convolution_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_cosine_similarity_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_differentiation_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_multiplication_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_oneplus_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_softmax_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_summation_function.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/controller/FNN/convolutional/model_controller.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/controller/FNN/convolutional/model_trainer.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/trainer/FNN/model_trainer_fnn_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/trainer/FNN/model_trainer_fnn_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/trainer/FNN/model_trainer_fnn_testbench.vhd

simulate:
	ghdl -m --std=08 model_trainer_fnn_testbench
	ghdl -r --std=08 model_trainer_fnn_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_trainer_fnn_testbench.tree

clean:
	rm -f *.cf *.tree