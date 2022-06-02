@echo off
call ../../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab model_convolutional_lstm_testbench
xsim -R model_convolutional_lstm_testbench
pause
