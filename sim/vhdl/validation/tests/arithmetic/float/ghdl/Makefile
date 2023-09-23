all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/tensor/model_tensor_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/tensor/model_tensor_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/tensor/model_tensor_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/math/float/model_float_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/math/float/model_float_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/model/math/float/model_float_testbench.vhd

simulate:
	ghdl -e --std=08 model_float_testbench
	ghdl -r --std=08 model_float_testbench --ieee-asserts=disable-at-0 --vcd=model_float_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
