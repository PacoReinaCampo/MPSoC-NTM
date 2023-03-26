@echo off
call ../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_trainer_fnn_testbench
xsim -R ntm_trainer_fnn_testbench
pause
