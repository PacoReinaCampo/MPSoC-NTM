@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_memory_testbench
xsim -R ntm_memory_testbench
pause
