all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.design.vc
	vcom -2008 -f system.verification.vc

simulate:
	vsim -c -do run.do work.accelerator_calculus_testbench

clean:
	rm -rf work transcript *.vstf *.wlf
