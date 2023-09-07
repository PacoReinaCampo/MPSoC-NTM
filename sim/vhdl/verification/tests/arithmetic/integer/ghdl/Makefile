all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/scalar/accelerator_scalar_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/scalar/accelerator_scalar_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/scalar/accelerator_scalar_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/vector/accelerator_vector_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/vector/accelerator_vector_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/vector/accelerator_vector_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/matrix/accelerator_matrix_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/matrix/accelerator_matrix_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/matrix/accelerator_matrix_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/tensor/accelerator_tensor_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/tensor/accelerator_tensor_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/integer/tensor/accelerator_tensor_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/integer/accelerator_integer_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/integer/accelerator_integer_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/integer/accelerator_integer_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_integer_testbench
	ghdl -r --std=08 accelerator_integer_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_integer_testbench.tree

clean:
	rm -f *.cf *.tree
