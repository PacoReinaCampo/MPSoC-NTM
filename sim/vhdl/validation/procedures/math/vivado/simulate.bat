@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_series_testbench
xsim -R model_series_testbench
pause
