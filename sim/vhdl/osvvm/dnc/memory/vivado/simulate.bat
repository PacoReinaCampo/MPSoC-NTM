@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab dnc_memory_testbench
xsim -R dnc_memory_testbench
pause
