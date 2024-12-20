#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# MODEL_STANDARD_LINEAR_TEST 
##################################################################################################

alias model_standard_linear_verification_compilation {
  echo "TEST: MODEL_STANDARD_LINEAR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/state/linear/standard/model_standard_linear_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/state/linear/standard/model_standard_linear_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/state/linear/standard/model_standard_linear_testbench.vhd

  vsim -g /model_standard_linear_testbench/ENABLE_MODEL_STANDARD_LINEAR_TEST=true -t ps +notimingchecks -L unisim work.model_standard_linear_testbench

  #MACROS
  add log -r sim:/model_standard_linear_testbench/*

  force -freeze sim:/model_standard_linear_pkg/STIMULUS_MODEL_STANDARD_LINEAR_TEST true 0
  force -freeze sim:/model_standard_linear_pkg/STIMULUS_MODEL_STANDARD_LINEAR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_standard_linear_test.wlf
}

##################################################################################################

alias v01 {
  model_standard_linear_verification_compilation
}

echo "****************************************"
echo "v01 . MODEL-STANDARD-LINEAR-TEST"
echo "****************************************"
