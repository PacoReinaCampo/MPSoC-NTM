@echo off
call ../../../../../../../settings64_iverilog.bat

iverilog -g2012 -o system.vvp -c system.vc -s dnc_write_heads_testbench
vvp system.vvp
pause
