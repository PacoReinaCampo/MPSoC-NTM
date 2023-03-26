@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_modular_testbench
xsim -R model_modular_testbench
pause
