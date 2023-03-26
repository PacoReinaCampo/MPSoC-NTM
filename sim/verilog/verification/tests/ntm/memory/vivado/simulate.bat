@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_memory_testbench
xsim -R model_memory_testbench
pause
