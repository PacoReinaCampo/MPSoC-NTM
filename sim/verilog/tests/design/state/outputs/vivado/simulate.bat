@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_state_outputs_testbench
xsim -R model_state_outputs_testbench
pause
