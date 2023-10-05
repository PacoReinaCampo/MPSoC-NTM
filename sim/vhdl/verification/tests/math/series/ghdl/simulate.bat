@echo off
call ../../../../../../../settings64_ghdl.bat
sh system.g

ghdl -e --std=08 accelerator_series_testbench
ghdl -r --std=08 accelerator_series_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_series_testbench.vcd --wave=system.ghw --stop-time=1ms
pause
