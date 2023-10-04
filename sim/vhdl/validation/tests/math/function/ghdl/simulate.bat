@echo off
call ../../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 model_function_testbench
ghdl -r --std=08 model_function_testbench --ieee-asserts=disable-at-0 --vcd=model_function_testbench.vcd --wave=system.ghw --stop-time=1ms
pause
