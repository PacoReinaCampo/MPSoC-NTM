all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_verilog_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/scalar/accelerator_scalar_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/scalar/accelerator_scalar_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/scalar/accelerator_scalar_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/vector/accelerator_vector_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/vector/accelerator_vector_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/vector/accelerator_vector_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/matrix/accelerator_matrix_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/matrix/accelerator_matrix_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/matrix/accelerator_matrix_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/tensor/accelerator_tensor_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/tensor/accelerator_tensor_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/integer/tensor/accelerator_tensor_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/arithmetic/integer/accelerator_integer_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/arithmetic/integer/accelerator_integer_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/arithmetic/integer/accelerator_integer_testbench.vhd

simulate:
	ghdl -e --std=08 accelerator_integer_testbench
	ghdl -r --std=08 accelerator_integer_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_integer_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
