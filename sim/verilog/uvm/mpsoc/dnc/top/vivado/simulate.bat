@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab dnc_top_testbench
xsim -R dnc_top_testbench
pause
