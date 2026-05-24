@echo off
call ../../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_memory_testbench
xsim -R accelerator_memory_testbench
pause
