@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_integer_testbench
xsim -R accelerator_integer_testbench
pause
