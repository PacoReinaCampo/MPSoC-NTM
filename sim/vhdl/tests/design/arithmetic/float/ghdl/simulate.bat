@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/tensor/model_tensor_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/tensor/model_tensor_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/tensor/model_tensor_float_divider.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/model_float_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/model_float_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/model_float_testbench.vhd
ghdl -m --std=08 model_float_testbench
ghdl -r --std=08 model_float_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_float_testbench.tree
pause
