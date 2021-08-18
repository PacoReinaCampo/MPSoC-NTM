all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.vc

simulate:
	vsim -c -do run.do work.ntm_function_testbench

clean:
	rm -rf work transcript
