#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_STANDARD_FNN_TEST 
##################################################################################################

alias accelerator_standard_fnn_verification_compilation {
  echo "TEST: ACCELERATOR_STANDARD_FNN_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/controller/FNN/standard/accelerator_standard_fnn_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/controller/FNN/standard/accelerator_standard_fnn_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/controller/FNN/standard/accelerator_standard_fnn_testbench.vhd

  vsim -g /accelerator_standard_fnn_testbench/ENABLE_ACCELERATOR_STANDARD_FNN_TEST=true -t ps +notimingchecks -L unisim work.accelerator_standard_fnn_testbench

  #MACROS
  add log -r sim:/accelerator_standard_fnn_testbench/*

  #WAVES
  view -title accelerator_standard_fnn wave
  do $simulation_path/controller/FNN/standard/msim/waves/accelerator_standard_fnn.do

  force -freeze sim:/accelerator_standard_fnn_pkg/STIMULUS_ACCELERATOR_STANDARD_FNN_TEST true 0
  force -freeze sim:/accelerator_standard_fnn_pkg/STIMULUS_ACCELERATOR_STANDARD_FNN_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_standard_fnn_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_standard_fnn_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-STANDARD-FNN-TEST"
echo "****************************************"
