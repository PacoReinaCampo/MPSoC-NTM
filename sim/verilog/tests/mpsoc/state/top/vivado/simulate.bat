@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab dnc_top_testbench
xsim -R dnc_top_testbench
pause
