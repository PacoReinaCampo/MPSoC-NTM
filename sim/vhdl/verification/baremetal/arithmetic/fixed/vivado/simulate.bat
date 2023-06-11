@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_float_testbench
xsim -R ntm_float_testbench
pause
