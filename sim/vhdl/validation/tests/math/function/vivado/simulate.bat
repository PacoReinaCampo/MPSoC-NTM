@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_function_testbench
xsim -R model_function_testbench
pause
