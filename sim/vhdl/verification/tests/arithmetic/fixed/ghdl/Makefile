all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/scalar/accelerator_scalar_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/scalar/accelerator_scalar_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/scalar/accelerator_scalar_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/vector/accelerator_vector_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/vector/accelerator_vector_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/vector/accelerator_vector_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/matrix/accelerator_matrix_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/matrix/accelerator_matrix_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/matrix/accelerator_matrix_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/tensor/accelerator_tensor_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/tensor/accelerator_tensor_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/fixed/tensor/accelerator_tensor_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/fixed/accelerator_fixed_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/fixed/accelerator_fixed_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/fixed/accelerator_fixed_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_fixed_testbench
	ghdl -r --std=08 accelerator_fixed_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_fixed_testbench.tree

clean:
	rm -f *.cf *.tree
