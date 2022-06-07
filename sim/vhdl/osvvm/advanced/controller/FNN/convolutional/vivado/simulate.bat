@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_convolutional_fnn_testbench
xsim -R ntm_convolutional_fnn_testbench
pause
