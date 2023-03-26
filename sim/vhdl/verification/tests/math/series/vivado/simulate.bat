@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_series_testbench
xsim -R ntm_series_testbench
pause
