@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab dnc_write_heads_testbench
xsim -R dnc_write_heads_testbench
pause
