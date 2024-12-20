@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_fixed_testbench
xsim -R model_fixed_testbench
pause
