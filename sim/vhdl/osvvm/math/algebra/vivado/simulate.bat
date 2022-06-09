@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_algebra_testbench
xsim -R ntm_algebra_testbench
pause
