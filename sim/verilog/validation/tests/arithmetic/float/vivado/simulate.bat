@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_float_testbench
xsim -R model_float_testbench
pause
