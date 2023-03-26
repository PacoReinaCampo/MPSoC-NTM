all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_math_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_core_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/ntm_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/ntm_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/ntm_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/ntm_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/ntm_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/ntm_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_module.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_inverse.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_inverse.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/ntm/write_heads/ntm_writing.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/ntm/write_heads/ntm_erasing.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/ntm/write_heads/ntm_write_heads_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/ntm/write_heads/ntm_write_heads_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/ntm/write_heads/ntm_write_heads_testbench.vhd

simulate:
	ghdl -m --std=08 ntm_write_heads_testbench
	ghdl -r --std=08 ntm_write_heads_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_write_heads_testbench.tree

clean:
	rm -f *.cf *.tree
