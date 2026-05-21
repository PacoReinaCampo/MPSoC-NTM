@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_read_heads_testbench
xsim -R accelerator_read_heads_testbench
pause
