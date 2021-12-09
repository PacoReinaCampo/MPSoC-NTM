@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_inverter.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_divider.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_exponentiator.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/modular/ntm_modular_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/modular/ntm_modular_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/modular/ntm_modular_testbench.vhd
ghdl -m --std=08 ntm_modular_testbench
ghdl -r --std=08 ntm_modular_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_modular_testbench.tree
pause
