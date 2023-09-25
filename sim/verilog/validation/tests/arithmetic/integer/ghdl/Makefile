all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_verilog_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/scalar/model_scalar_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/scalar/model_scalar_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/scalar/model_scalar_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/vector/model_vector_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/vector/model_vector_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/vector/model_vector_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/matrix/model_matrix_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/matrix/model_matrix_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/matrix/model_matrix_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/tensor/model_tensor_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/tensor/model_tensor_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/integer/tensor/model_tensor_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/arithmetic/integer/model_integer_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/arithmetic/integer/model_integer_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/arithmetic/integer/model_integer_testbench.vhd

simulate:
	ghdl -e --std=08 model_integer_testbench
	ghdl -r --std=08 model_integer_testbench --ieee-asserts=disable-at-0 --vcd=model_integer_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
