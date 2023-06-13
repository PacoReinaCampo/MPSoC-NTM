@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_calculus_testbench
xsim -R accelerator_calculus_testbench
pause
