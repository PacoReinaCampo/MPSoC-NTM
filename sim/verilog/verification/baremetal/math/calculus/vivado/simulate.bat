@echo off
call ../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_calculus_testbench
xsim -R ntm_calculus_testbench
pause
