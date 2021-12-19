@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_modular_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_modular_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_modular_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_testbench.vhd
ghdl -m --std=08 ntm_float_testbench
ghdl -r --std=08 ntm_float_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_float_testbench.tree
pause
