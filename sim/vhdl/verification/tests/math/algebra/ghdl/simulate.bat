@echo off
call ../../../../../../../settings64_ghdl.bat
sh system.g

ghdl -e --std=08 accelerator_algebra_testbench
ghdl -r --std=08 accelerator_algebra_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_algebra_testbench.vcd --wave=system.ghw --stop-time=1ms
pause
