all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_verilog_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/scalar/model_scalar_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/scalar/model_scalar_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/scalar/model_scalar_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/vector/model_vector_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/vector/model_vector_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/vector/model_vector_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/matrix/model_matrix_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/matrix/model_matrix_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/matrix/model_matrix_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/tensor/model_tensor_fixed_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/tensor/model_tensor_fixed_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/fixed/tensor/model_tensor_fixed_divider.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/fixed/model_fixed_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/fixed/model_fixed_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/fixed/model_fixed_testbench.vhd

simulate:
	ghdl -m --std=08 model_fixed_testbench
	ghdl -r --std=08 model_fixed_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_fixed_testbench.tree

clean:
	rm -f *.cf *.tree
