all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/scalar/ntm_scalar_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/scalar/ntm_scalar_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/scalar/ntm_scalar_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/vector/ntm_vector_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/vector/ntm_vector_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/vector/ntm_vector_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/matrix/ntm_matrix_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/matrix/ntm_matrix_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/integer/matrix/ntm_matrix_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_vector_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_vector_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_vector_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_vector_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/algebra/ntm_algebra_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/algebra/ntm_algebra_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/algebra/ntm_algebra_testbench.vhd

simulate:
	ghdl -m --std=08 ntm_algebra_testbench
	ghdl -r --std=08 ntm_algebra_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_algebra_testbench.tree

clean:
	rm -f *.cf *.tree
