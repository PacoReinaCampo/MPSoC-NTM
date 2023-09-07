all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_verilog_pkg.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_math_verilog_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/vector/model_vector_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/vector/model_vector_integration.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/vector/model_vector_softmax.vhd
    
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/matrix/model_matrix_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/matrix/model_matrix_integration.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/matrix/model_matrix_softmax.vhd
    
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/tensor/model_tensor_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/tensor/model_tensor_integration.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/calculus/tensor/model_tensor_softmax.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/calculus/model_calculus_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/calculus/model_calculus_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/calculus/model_calculus_testbench.vhd

simulate:
	ghdl -m --std=08 model_calculus_testbench
	ghdl -r --std=08 model_calculus_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_calculus_testbench.tree

clean:
	rm -f *.cf *.tree