@echo off
call ../../../../../../../../settings64_iverilog.bat

iverilog -g2012 -o system.vvp -c system.vc -s model_convolutional_lstm_testbench
vvp system.vvp
pause