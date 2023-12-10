all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 accelerator_series_testbench
	ghdl -r --std=08 accelerator_series_testbench --ieee-asserts=disable-at-0 -.vcd *.wdb=accelerator_series_testbench.vcd *.wdb --wave=system.ghw --stop-time=1ms

test:
	gtkwave system.ghw

clean:
	rm -f *.cf *.vcd *.wdb *.ghw
