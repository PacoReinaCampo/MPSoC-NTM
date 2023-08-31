@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_trainer_lstm_testbench
xsim -R accelerator_trainer_lstm_testbench
pause