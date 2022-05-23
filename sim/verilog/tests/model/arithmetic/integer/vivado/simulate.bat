@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_integer_testbench
xsim -R model_integer_testbench
pause
