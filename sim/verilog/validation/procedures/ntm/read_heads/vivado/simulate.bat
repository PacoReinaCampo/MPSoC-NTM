@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_read_heads_testbench
xsim -R model_read_heads_testbench
pause
