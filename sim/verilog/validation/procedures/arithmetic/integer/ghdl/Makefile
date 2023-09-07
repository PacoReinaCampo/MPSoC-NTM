all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_verilog_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/scalar/model_scalar_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/scalar/model_scalar_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/scalar/model_scalar_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/vector/model_vector_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/vector/model_vector_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/vector/model_vector_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/matrix/model_matrix_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/matrix/model_matrix_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/matrix/model_matrix_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/tensor/model_tensor_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/tensor/model_tensor_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/integer/tensor/model_tensor_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/integer/model_integer_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/integer/model_integer_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/integer/model_integer_testbench.vhd

simulate:
	ghdl -m --std=08 model_integer_testbench
	ghdl -r --std=08 model_integer_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_integer_testbench.tree

clean:
	rm -f *.cf *.tree
