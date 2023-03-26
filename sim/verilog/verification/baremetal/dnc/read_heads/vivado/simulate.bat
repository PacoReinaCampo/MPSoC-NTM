@echo off
call ../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab dnc_read_heads_testbench
xsim -R dnc_read_heads_testbench
pause
