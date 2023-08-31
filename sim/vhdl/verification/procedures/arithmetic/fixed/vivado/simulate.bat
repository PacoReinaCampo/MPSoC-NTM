@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_fixed_testbench
xsim -R accelerator_fixed_testbench
pause
