@echo off
call ../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/scalar/ntm_scalar_integer_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/scalar/ntm_scalar_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/scalar/ntm_scalar_integer_divider.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/vector/ntm_vector_integer_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/vector/ntm_vector_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/vector/ntm_vector_integer_divider.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/matrix/ntm_matrix_integer_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/matrix/ntm_matrix_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/matrix/ntm_matrix_integer_divider.vhd

ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/tensor/ntm_tensor_integer_adder.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/tensor/ntm_tensor_integer_multiplier.vhd
ghdl -a --std=08 ../../../../../../rtl/vhdl/code/math/integer/tensor/ntm_tensor_integer_divider.vhd

ghdl -a --std=08 ../../../../../../bench/vhdl/code/osvvm/math/integer/ntm_integer_pkg.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/code/osvvm/math/integer/ntm_integer_stimulus.vhd
ghdl -a --std=08 ../../../../../../bench/vhdl/code/osvvm/math/integer/ntm_integer_testbench.vhd
ghdl -m --std=08 ntm_integer_testbench
ghdl -r --std=08 ntm_integer_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_integer_testbench.tree
pause
