#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# MODEL_TRAINER_VECTOR_DIFFERENTIATION_TEST 
##################################################################################################

alias model_trainer_vector_differentiation_verification_compilation {
  echo "TEST: MODEL_TRAINER_VECTOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_testbench.vhd

  vsim -g /model_trainer_linear_testbench/ENABLE_MODEL_TRAINER_VECTOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_trainer_linear_testbench

  #MACROS
  add log -r sim:/model_trainer_linear_testbench/*

  force -freeze sim:/model_trainer_linear_pkg/STIMULUS_MODEL_TRAINER_VECTOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/model_trainer_linear_pkg/STIMULUS_MODEL_TRAINER_VECTOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_trainer_vector_differentiation_test.wlf
}

##################################################################################################
# MODEL_TRAINER_MATRIX_DIFFERENTIATION_TEST 
##################################################################################################

alias model_trainer_matrix_differentiation_verification_compilation {
  echo "TEST: MODEL_TRAINER_MATRIX_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_testbench.vhd

  vsim -g /model_trainer_linear_testbench/ENABLE_MODEL_TRAINER_MATRIX_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_trainer_linear_testbench

  #MACROS
  add log -r sim:/model_trainer_linear_testbench/*

  force -freeze sim:/model_trainer_linear_pkg/STIMULUS_MODEL_TRAINER_MATRIX_DIFFERENTIATION_TEST true 0
  force -freeze sim:/model_trainer_linear_pkg/STIMULUS_MODEL_TRAINER_MATRIX_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_trainer_matrix_differentiation_test.wlf
}

##################################################################################################
# MODEL_TRAINER_LINEAR_TEST 
##################################################################################################

alias model_trainer_linear_verification_compilation {
  echo "TEST: MODEL_TRAINER_LINEAR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/linear/model_trainer_linear_testbench.vhd

  vsim -g /model_trainer_linear_testbench/ENABLE_MODEL_TRAINER_LINEAR_TEST=true -t ps +notimingchecks -L unisim work.model_trainer_linear_testbench

  #MACROS
  add log -r sim:/model_trainer_linear_testbench/*

  force -freeze sim:/model_trainer_linear_pkg/STIMULUS_MODEL_TRAINER_LINEAR_TEST true 0
  force -freeze sim:/model_trainer_linear_pkg/STIMULUS_MODEL_TRAINER_LINEAR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_trainer_linear_test.wlf
}

##################################################################################################

alias v01 {
  model_trainer_vector_differentiation_verification_compilation
}

alias v02 {
  model_trainer_matrix_differentiation_verification_compilation
}

alias v03 {
  model_trainer_linear_verification_compilation
}

echo "****************************************"
echo "v01 . MODEL-VECTOR-TRAINER-DIFFERENTIATION-TEST"
echo "v02 . MODEL-MATRIX-TRAINER-DIFFERENTIATION-TEST"
echo "v03 . MODEL-TRAINER-LINEAR-TEST"
echo "****************************************"
