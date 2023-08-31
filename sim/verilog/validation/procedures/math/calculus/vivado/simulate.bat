@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_calculus_testbench
xsim -R model_calculus_testbench
pause
