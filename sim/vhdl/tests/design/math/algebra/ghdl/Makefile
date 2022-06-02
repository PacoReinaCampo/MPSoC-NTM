all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_math_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/scalar/model_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/scalar/model_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/vector/model_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/vector/model_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/vector/model_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/matrix/model_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/arithmetic/float/matrix/model_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_summation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_module.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_inverse.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_summation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_transpose.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_vector_product.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_inverse.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_summation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/algebra/model_algebra_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/algebra/model_algebra_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/algebra/model_algebra_testbench.vhd

simulate:
	ghdl -m --std=08 model_algebra_testbench
	ghdl -r --std=08 model_algebra_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_algebra_testbench.tree

clean:
	rm -f *.cf *.tree
