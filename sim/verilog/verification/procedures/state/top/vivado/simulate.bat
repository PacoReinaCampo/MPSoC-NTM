@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_state_top_testbench
xsim -R accelerator_state_top_testbench
pause
