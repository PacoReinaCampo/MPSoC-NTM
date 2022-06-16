@echo off
call ../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab Demo_Rand
xsim -R Demo_Rand
pause
