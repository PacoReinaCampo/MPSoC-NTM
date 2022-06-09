@echo off
call ../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_algebra_testbench
xsim -R ntm_algebra_testbench
pause
