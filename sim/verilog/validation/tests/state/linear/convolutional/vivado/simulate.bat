@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_convolutional_linear_testbench
xsim -R accelerator_convolutional_linear_testbench
pause
