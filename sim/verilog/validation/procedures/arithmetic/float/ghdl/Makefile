all: build simulate

build:
	sh system.s

simulate:
	ghdl -e --std=08 model_float_testbench
	ghdl -r --std=08 model_float_testbench --ieee-asserts=disable-at-0 --vcd=model_float_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
