@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab dnc_memory_testbench
xsim -R dnc_memory_testbench
pause
