@echo off
call ../../../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab accelerator_trainer_transformer_testbench
xsim -R accelerator_trainer_transformer_testbench
pause