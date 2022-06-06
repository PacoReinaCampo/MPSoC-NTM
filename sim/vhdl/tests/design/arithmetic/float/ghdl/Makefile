all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_arithmetic_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/tensor/ntm_tensor_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/tensor/ntm_tensor_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/tensor/ntm_tensor_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_testbench.vhd

simulate:
	ghdl -m --std=08 model_float_testbench
	ghdl -r --std=08 model_float_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_float_testbench.tree

clean:
	rm -f *.cf *.tree
