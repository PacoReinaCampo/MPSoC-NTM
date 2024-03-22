@echo off
call ../../../../../../../../settings64_ghdl.bat
sh system.g

ghdl -e --std=08 model_standard_lstm_testbench
ghdl -r --std=08 model_standard_lstm_testbench --ieee-asserts=disable-at-0 --vcd=model_standard_lstm_testbench.vcd --wave=system.ghw --stop-time=1ms
pause