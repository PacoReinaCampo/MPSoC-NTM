all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/scalar/ntm_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/vector/ntm_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/arithmetic/float/matrix/ntm_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/vector/ntm_vector_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/vector/ntm_vector_integration.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/vector/ntm_vector_softmax.vhd
    
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/matrix/ntm_matrix_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/matrix/ntm_matrix_integration.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/matrix/ntm_matrix_softmax.vhd
    
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/tensor/ntm_tensor_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/tensor/ntm_tensor_integration.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/calculus/tensor/ntm_tensor_softmax.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/calculus/ntm_calculus_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/calculus/ntm_calculus_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/calculus/ntm_calculus_testbench.vhd

simulate:
	ghdl -m --std=08 model_calculus_testbench
	ghdl -r --std=08 model_calculus_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_calculus_testbench.tree

clean:
	rm -f *.cf *.tree