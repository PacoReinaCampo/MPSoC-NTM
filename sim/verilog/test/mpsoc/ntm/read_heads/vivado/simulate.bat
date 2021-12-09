@echo off
call ../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab ntm_read_heads_testbench
xsim -R ntm_read_heads_testbench
pause
