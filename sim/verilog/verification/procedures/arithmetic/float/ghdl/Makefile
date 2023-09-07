all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_verilog_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/tensor/accelerator_tensor_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/tensor/accelerator_tensor_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/tensor/accelerator_tensor_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/math/float/accelerator_float_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/math/float/accelerator_float_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/math/float/accelerator_float_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_float_testbench
	ghdl -r --std=08 accelerator_float_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_float_testbench.tree

clean:
	rm -f *.cf *.tree
