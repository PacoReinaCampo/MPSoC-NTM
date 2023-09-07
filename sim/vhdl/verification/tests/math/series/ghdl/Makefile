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

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_cosh_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_exponentiator_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_logarithm_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_sinh_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/scalar/accelerator_scalar_tanh_function.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_cosh_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_exponentiator_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_logarithm_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_sinh_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/vector/accelerator_vector_tanh_function.vhd

    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_cosh_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_exponentiator_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_logarithm_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_sinh_function.vhd
    ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/series/matrix/accelerator_matrix_tanh_function.vhd

    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/series/accelerator_series_pkg.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/series/accelerator_series_stimulus.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/tests/design/math/series/accelerator_series_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_series_testbench
	ghdl -r --std=08 accelerator_series_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_series_testbench.tree

clean:
	rm -f *.cf *.tree
