@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_function_testbench
xsim -R accelerator_function_testbench
pause
