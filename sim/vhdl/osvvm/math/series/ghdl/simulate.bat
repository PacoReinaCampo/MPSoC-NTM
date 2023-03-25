@echo off
call ../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/pkg/ntm_math_pkg.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/scalar/ntm_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/scalar/ntm_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/scalar/ntm_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/vector/ntm_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/vector/ntm_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/vector/ntm_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/matrix/ntm_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/matrix/ntm_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/float/matrix/ntm_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_cosh_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_sinh_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/scalar/ntm_scalar_tanh_function.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_cosh_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_sinh_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/vector/ntm_vector_tanh_function.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_cosh_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_exponentiator_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_logarithm_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_sinh_function.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/series/matrix/ntm_matrix_tanh_function.vhd

ghdl -a --std=08 ../../../../../../bench/vhdl/code/osvvm/math/series/ntm_series_pkg.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/code/osvvm/math/series/ntm_series_stimulus.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/code/osvvm/math/series/ntm_series_testbench.vhd
ghdl -m --std=08 ntm_series_testbench
ghdl -r --std=08 ntm_series_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_series_testbench.tree
pause
