all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_vhdl_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_math_vhdl_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/vector/accelerator_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/arithmetic/float/matrix/accelerator_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/vector/accelerator_vector_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/vector/accelerator_vector_integration.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/vector/accelerator_vector_softmax.vhd
    
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/matrix/accelerator_matrix_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/matrix/accelerator_matrix_integration.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/matrix/accelerator_matrix_softmax.vhd
    
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/tensor/accelerator_tensor_differentiation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/tensor/accelerator_tensor_integration.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/calculus/tensor/accelerator_tensor_softmax.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/calculus/accelerator_calculus_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/calculus/accelerator_calculus_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/calculus/accelerator_calculus_testbench.vhd

simulate:
	ghdl -e --std=08 accelerator_calculus_testbench
	ghdl -r --std=08 accelerator_calculus_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_calculus_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw