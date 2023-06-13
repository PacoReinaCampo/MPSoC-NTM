@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_standard_fnn_testbench
xsim -R accelerator_standard_fnn_testbench
pause
