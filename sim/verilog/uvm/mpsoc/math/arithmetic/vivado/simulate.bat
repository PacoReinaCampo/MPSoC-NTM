@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_arithmetic_testbench
xsim -R ntm_arithmetic_testbench
pause
