@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/ntm_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/ntm_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/ntm_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/ntm_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/ntm_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/ntm_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/ntm_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/ntm_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/ntm_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/ntm_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/tensor/ntm_tensor_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/tensor/ntm_tensor_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/tensor/ntm_tensor_float_divider.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/math/float/ntm_float_testbench.vhd
ghdl -m --std=08 ntm_float_testbench
ghdl -r --std=08 ntm_float_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_float_testbench.tree
pause
