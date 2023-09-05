@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_algebra_testbench
xsim -R model_algebra_testbench
pause
