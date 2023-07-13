@echo off
call ../../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_standard_transformer_testbench
xsim -R model_standard_transformer_testbench
pause
