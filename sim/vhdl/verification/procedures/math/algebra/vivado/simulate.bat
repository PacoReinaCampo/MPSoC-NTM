@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_algebra_testbench
xsim -R accelerator_algebra_testbench
pause
