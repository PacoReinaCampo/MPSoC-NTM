@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_standard_lstm_testbench
xsim -R ntm_standard_lstm_testbench
pause
