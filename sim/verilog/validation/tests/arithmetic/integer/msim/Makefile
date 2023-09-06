all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.design.vc
	vcom -2008 -f system.validation.vc

simulate:
	vsim -c -do run.do work.model_integer_testbench

clean:
	rm -rf work transcript *.vstf *.wlf
