@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_convolutional_transformer_testbench
xsim -R ntm_convolutional_transformer_testbench
pause
