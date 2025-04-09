@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_write_heads_testbench
xsim -R accelerator_write_heads_testbench
pause
