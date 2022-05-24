@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_calculus_testbench
xsim -R ntm_calculus_testbench
pause
