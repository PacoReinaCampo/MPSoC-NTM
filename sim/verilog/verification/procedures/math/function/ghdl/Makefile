all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 accelerator_function_testbench
	ghdl -r --std=08 accelerator_function_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_function_testbench.vcd --wave=system.ghw --stop-time=1ms

test:
	gtkwave system.ghw

clean:
	rm -f *.cf *.vcd *.wdb *.ghw
