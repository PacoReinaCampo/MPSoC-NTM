@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/ntm_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/ntm_math_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/ntm_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/ntm_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/ntm_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/ntm_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/ntm_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/ntm_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/ntm_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/ntm_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/ntm_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/scalar/ntm_scalar_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/scalar/ntm_scalar_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/vector/ntm_vector_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/vector/ntm_vector_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/matrix/ntm_matrix_logistic_function.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/function/matrix/ntm_matrix_oneplus_function.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/function/ntm_function_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/function/ntm_function_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/function/ntm_function_testbench.vhd
ghdl -m --std=08 ntm_function_testbench
ghdl -r --std=08 ntm_function_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_function_testbench.tree
pause
