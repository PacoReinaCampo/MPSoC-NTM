@echo off
call ../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_intro_testbench
xsim -R ntm_intro_testbench
pause
