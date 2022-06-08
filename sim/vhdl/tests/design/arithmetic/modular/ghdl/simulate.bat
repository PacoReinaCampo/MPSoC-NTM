@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/scalar/ntm_scalar_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/vector/ntm_vector_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/matrix/ntm_matrix_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/tensor/ntm_tensor_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/tensor/ntm_tensor_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/tensor/ntm_tensor_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/modular/tensor/ntm_tensor_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/design/math/modular/ntm_modular_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/design/math/modular/ntm_modular_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/design/math/modular/ntm_modular_testbench.vhd
ghdl -m --std=08 model_modular_testbench
ghdl -r --std=08 model_modular_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_modular_testbench.tree
pause
