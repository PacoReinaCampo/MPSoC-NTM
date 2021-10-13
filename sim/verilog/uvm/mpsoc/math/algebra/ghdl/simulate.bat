@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_determinant.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_inversion.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_rank.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_matrix_transpose.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_scalar_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/ntm_vector_product.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/algebra/ntm_algebra_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/algebra/ntm_algebra_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/algebra/ntm_algebra_testbench.vhd
ghdl -m --std=08 ntm_algebra_testbench
ghdl -r --std=08 ntm_algebra_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_algebra_testbench.tree
pause
