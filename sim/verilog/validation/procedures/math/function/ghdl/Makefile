all: build simulate

build:
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_verilog_pkg.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_math_verilog_pkg.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_logistic_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/scalar/model_scalar_oneplus_function.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_logistic_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/vector/model_vector_oneplus_function.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_logistic_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/function/matrix/model_matrix_oneplus_function.vhd

    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/function/model_function_pkg.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/function/model_function_stimulus.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/function/model_function_testbench.vhd

simulate:
	ghdl -e --std=08 model_function_testbench
	ghdl -r --std=08 model_function_testbench --ieee-asserts=disable-at-0 --vcd=model_function_testbench.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
