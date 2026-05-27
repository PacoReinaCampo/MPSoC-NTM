@echo off
call ../../../../../../../../settings64_msim.bat

vsim -c -do macros/run.do

REM vsim -view wlf/TARGET.wlf -do waves/TARGET.do
pause
