all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 model_float_testbench
	ghdl -r --std=08 model_float_testbench --ieee-asserts=disable-at-0 -.vcd *.wdb=model_float_testbench.vcd *.wdb --wave=system.ghw --stop-time=1ms

test:
	gtkwave system.ghw

clean:
	rm -f *.cf *.vcd *.wdb *.ghw
