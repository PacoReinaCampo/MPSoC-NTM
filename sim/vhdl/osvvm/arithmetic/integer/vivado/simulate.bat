@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_integer_testbench
xsim -R ntm_integer_testbench
pause
