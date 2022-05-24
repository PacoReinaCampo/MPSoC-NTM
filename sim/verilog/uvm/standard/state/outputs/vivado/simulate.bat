@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_state_outputs_testbench
xsim -R ntm_state_outputs_testbench
pause
