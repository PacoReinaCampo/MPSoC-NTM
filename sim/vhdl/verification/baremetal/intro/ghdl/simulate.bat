@echo off
call ../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../model/vhdl/code/pkg/model_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../model/vhdl/code/pkg/model_math_pkg.vhd

ghdl -a --std=08 ../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../rtl/vhdl/code/pkg/ntm_math_pkg.vhd

ghdl -a --std=08 ../../../../../model/vhdl/code/pkg/model_intro_pkg.vhd
ghdl -a --std=08 ../../../../../model/vhdl/code/intro/model_intro_adder.vhd

ghdl -a --std=08 ../../../../../rtl/vhdl/code/pkg/ntm_intro_pkg.vhd
ghdl -a --std=08 ../../../../../rtl/vhdl/code/intro/ntm_intro_adder.vhd

ghdl -a --std=08 ../../../../../bench/vhdl/code/osvvm/intro/ntm_intro_testbench.vhd

ghdl -m --std=08 ntm_intro_testbench
ghdl -r --std=08 ntm_intro_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_intro_testbench.tree
pause