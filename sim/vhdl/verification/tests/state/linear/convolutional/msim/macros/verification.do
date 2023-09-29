#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_CONVOLUTIONAL_LINEAR_TEST 
##################################################################################################

alias accelerator_convolutional_linear_verification_compilation {
  echo "TEST: ACCELERATOR_CONVOLUTIONAL_LINEAR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/state/linear/convolutional/accelerator_convolutional_linear_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/state/linear/convolutional/accelerator_convolutional_linear_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/state/linear/convolutional/accelerator_convolutional_linear_testbench.vhd

  vsim -g /accelerator_convolutional_linear_testbench/ENABLE_ACCELERATOR_CONVOLUTIONAL_LINEAR_TEST=true -t ps +notimingchecks -L unisim work.accelerator_convolutional_linear_testbench

  #MACROS
  add log -r sim:/accelerator_convolutional_linear_testbench/*

  force -freeze sim:/accelerator_convolutional_linear_pkg/STIMULUS_ACCELERATOR_CONVOLUTIONAL_LINEAR_TEST true 0
  force -freeze sim:/accelerator_convolutional_linear_pkg/STIMULUS_ACCELERATOR_CONVOLUTIONAL_LINEAR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/accelerator_convolutional_linear_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_convolutional_linear_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-CONVOLUTIONAL-LINEAR-TEST"
echo "****************************************"
