@echo off
call ../../../../../settings64_vivado.bat

xvlog -i ../../../../../uvm/src -prj system.prj
xelab ntm_intro_testbench
xsim -R ntm_intro_testbench
pause
