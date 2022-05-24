@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab dnc_read_heads_testbench
xsim -R dnc_read_heads_testbench
pause
