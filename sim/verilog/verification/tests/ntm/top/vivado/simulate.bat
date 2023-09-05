@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_top_testbench
xsim -R accelerator_top_testbench
pause
