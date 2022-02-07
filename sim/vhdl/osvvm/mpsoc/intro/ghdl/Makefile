all: build simulate

build:
	ghdl -a --std=08 ghdl -a --std=08 ../../../../../../../bench/vhdl/model/intro/ntm_intro_adder_model.vhd
	ghdl -a --std=08 ghdl -a --std=08 ../../../../../../../bench/vhdl/model/intro/ntm_intro_adder_rtl.vhd

	ghdl -a --std=08 ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/intro/ntm_intro_testbench.vhd

simulate:
	ghdl -m --std=08 ntm_intro_testbench
	ghdl -r --std=08 ntm_intro_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_intro_testbench.tree

clean:
	rm -f *.cf *.tree
