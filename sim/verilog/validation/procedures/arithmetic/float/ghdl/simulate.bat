@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/scalar/model_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/vector/model_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/matrix/model_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/tensor/model_tensor_float_adder.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/tensor/model_tensor_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../model/vhdl/code/arithmetic/float/tensor/model_tensor_float_divider.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/model/arithmetic/float/model_float_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/model/arithmetic/float/model_float_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/model/arithmetic/float/model_float_testbench.vhd
ghdl -e --std=08 model_float_testbench
ghdl -r --std=08 model_float_testbench --ieee-asserts=disable-at-0 --vcd=model_float_testbench.vcd --wave=system.ghw --stop-time=1ms
pause
