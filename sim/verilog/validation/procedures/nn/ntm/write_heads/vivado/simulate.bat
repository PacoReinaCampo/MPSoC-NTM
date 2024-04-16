@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab model_write_heads_testbench
xsim -R model_write_heads_testbench
pause
