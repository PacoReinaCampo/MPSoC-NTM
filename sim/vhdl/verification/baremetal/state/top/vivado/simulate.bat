@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_state_top_testbench
xsim -R ntm_state_top_testbench
pause
