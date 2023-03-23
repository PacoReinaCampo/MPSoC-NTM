all: build simulate

build:
    ghdl -a --std=08 ../../../../../model/vhdl/code/pkg/model_arithmetic_pkg.vhd
    ghdl -a --std=08 ../../../../../model/vhdl/code/pkg/model_math_pkg.vhd

	ghdl -a --std=08 ../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/code/pkg/ntm_math_pkg.vhd

	ghdl -a --std=08 ../../../../../model/vhdl/code/pkg/model_intro_pkg.vhd
	ghdl -a --std=08 ../../../../../model/vhdl/code/intro/model_intro_adder.vhd

	ghdl -a --std=08 ../../../../../rtl/vhdl/code/pkg/ntm_intro_pkg.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/code/intro/ntm_intro_adder.vhd

	ghdl -a --std=08 ../../../../../bench/vhdl/osvvm/intro/ntm_intro_testbench.vhd

simulate:
	ghdl -m --std=08 ntm_intro_testbench
	ghdl -r --std=08 ntm_intro_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_intro_testbench.tree

clean:
	rm -f *.cf *.tree