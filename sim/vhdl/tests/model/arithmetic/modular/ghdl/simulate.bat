@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/scalar/model_scalar_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/scalar/model_scalar_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/scalar/model_scalar_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/scalar/model_scalar_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/vector/model_vector_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/vector/model_vector_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/vector/model_vector_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/vector/model_vector_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/matrix/model_matrix_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/matrix/model_matrix_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/matrix/model_matrix_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/matrix/model_matrix_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/tensor/model_tensor_modular_mod.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/tensor/model_tensor_modular_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/tensor/model_tensor_modular_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/modular/tensor/model_tensor_modular_inverter.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/model/math/modular/model_modular_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/model/math/modular/model_modular_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/model/math/modular/model_modular_testbench.vhd
ghdl -m --std=08 model_modular_testbench
ghdl -r --std=08 model_modular_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_modular_testbench.tree
pause
