all: build simulate

build:
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_vhdl_pkg.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_math_vhdl_pkg.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_logistic_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/scalar/accelerator_scalar_oneplus_function.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_logistic_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/vector/accelerator_vector_oneplus_function.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_logistic_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/function/matrix/accelerator_matrix_oneplus_function.vhd

    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/function/accelerator_function_pkg.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/function/accelerator_function_stimulus.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/function/accelerator_function_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_function_testbench
	ghdl -r --std=08 accelerator_function_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_function_testbench.tree

clean:
	rm -f *.cf *.tree
