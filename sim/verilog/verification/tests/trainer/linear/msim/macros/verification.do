#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_TRAINER_LINEAR_TEST 
##################################################################################################

alias accelerator_trainer_linear_verification_compilation {
  echo "TEST: ACCELERATOR_TRAINER_LINEAR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/accelerator_trainer_linear_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/accelerator_trainer_linear_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/accelerator_trainer_linear_testbench.vhd

  vsim -g /accelerator_trainer_linear_testbench/ENABLE_ACCELERATOR_TRAINER_LINEAR_TEST=true -t ps +notimingchecks -L unisim work.accelerator_trainer_linear_testbench

  #MACROS
  add log -r sim:/accelerator_trainer_linear_testbench/*

  #WAVES
  view -title accelerator_trainer_linear wave
  do $simulation_path/trainer/linear/msim/waves/accelerator_trainer_linear.do

  force -freeze sim:/accelerator_trainer_linear_pkg/STIMULUS_ACCELERATOR_TRAINER_LINEAR_TEST true 0
  force -freeze sim:/accelerator_trainer_linear_pkg/STIMULUS_ACCELERATOR_TRAINER_LINEAR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_trainer_linear_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_trainer_linear_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-TRAINER-LINEAR-TEST"
echo "****************************************"
