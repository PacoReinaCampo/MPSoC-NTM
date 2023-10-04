all: build simulate

build:
	sh system.s

simulate:
	ghdl -e --std=08 accelerator_state_outputs_testbench
	ghdl -r --std=08 accelerator_state_outputs_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_state_outputs_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
