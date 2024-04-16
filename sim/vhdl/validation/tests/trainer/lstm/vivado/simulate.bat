@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_trainer_lstm_testbench
xsim -R model_trainer_lstm_testbench
pause
