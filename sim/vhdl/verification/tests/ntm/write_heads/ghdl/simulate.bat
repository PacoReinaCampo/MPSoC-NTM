@echo off
call ../../../../../../../settings64_ghdl.bat
sh system.s

ghdl -e --std=08 accelerator_write_heads_testbench
ghdl -r --std=08 accelerator_write_heads_testbench --ieee-asserts=disable-at-0 --vcd=accelerator_write_heads_testbench.vcd --wave=system.ghw --stop-time=1ms
pause