@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab ntm_modular_testbench
xsim -R ntm_modular_testbench
pause
