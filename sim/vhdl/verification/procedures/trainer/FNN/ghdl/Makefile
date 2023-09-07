all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_math_vhdl_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_fnn_controller_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/accelerator_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/accelerator_tensor_transpose.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/accelerator_matrix_transpose.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/accelerator_scalar_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/accelerator_tensor_product.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_convolution_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_cosine_similarity_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_differentiation_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_multiplication_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_oneplus_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_softmax_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_summation_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_convolution_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_cosine_similarity_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_differentiation_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_multiplication_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_oneplus_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_softmax_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_summation_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_exponentiator_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_convolution_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_cosh_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_cosine_similarity_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_differentiation_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_logistic_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_multiplication_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_oneplus_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_sinh_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_softmax_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_summation_function.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_tanh_function.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/controller/FNN/convolutional/accelerator_controller.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/controller/FNN/convolutional/accelerator_trainer.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/trainer/FNN/accelerator_trainer_fnn_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/trainer/FNN/accelerator_trainer_fnn_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/trainer/FNN/accelerator_trainer_fnn_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_trainer_fnn_testbench
	ghdl -r --std=08 accelerator_trainer_fnn_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_trainer_fnn_testbench.tree

clean:
	rm -f *.cf *.tree