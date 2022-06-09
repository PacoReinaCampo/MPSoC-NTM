@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_standard_fnn_testbench
xsim -R ntm_standard_fnn_testbench
pause
