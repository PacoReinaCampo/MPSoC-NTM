@echo off
call ../../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_standard_fnn_testbench
xsim -R model_standard_fnn_testbench
pause
