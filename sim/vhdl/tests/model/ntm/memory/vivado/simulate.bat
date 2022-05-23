@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_memory_testbench
xsim -R model_memory_testbench
pause
