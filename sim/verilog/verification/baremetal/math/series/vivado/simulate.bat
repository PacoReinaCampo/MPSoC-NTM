@echo off
call ../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_function_testbench
xsim -R ntm_function_testbench
pause
