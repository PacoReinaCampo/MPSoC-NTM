all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/scalar/accelerator_scalar_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/scalar/accelerator_scalar_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/scalar/accelerator_scalar_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/vector/accelerator_vector_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/vector/accelerator_vector_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/vector/accelerator_vector_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/matrix/accelerator_matrix_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/matrix/accelerator_matrix_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/matrix/accelerator_matrix_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/tensor/accelerator_tensor_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/tensor/accelerator_tensor_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/fixed/tensor/accelerator_tensor_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/arithmetic/fixed/accelerator_fixed_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/arithmetic/fixed/accelerator_fixed_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/design/arithmetic/fixed/accelerator_fixed_testbench.vhd

simulate:
	ghdl -e --std=08 accelerator_fixed_testbench
	ghdl -r --std=08 accelerator_fixed_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_fixed_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
