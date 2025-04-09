@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_series_testbench
xsim -R accelerator_series_testbench
pause
