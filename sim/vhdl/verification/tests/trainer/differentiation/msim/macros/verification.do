#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_TEST 
##################################################################################################

alias model_vector_trainer_differentiation_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/differentiation/accelerator_trainer_differentiation_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/differentiation/accelerator_trainer_differentiation_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/differentiation/accelerator_trainer_differentiation_testbench.vhd

  vsim -g /accelerator_trainer_differentiation_testbench/ENABLE_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_trainer_differentiation_testbench

  #MACROS
  add log -r sim:/accelerator_trainer_differentiation_testbench/*

  #WAVES
  view -title model_vector_trainer_differentiation wave
  do $simulation_path/trainer/differentiation/msim/waves/accelerator_vector_trainer_differentiation.do

  force -freeze sim:/accelerator_trainer_differentiation_pkg/STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_TEST true 0
  force -freeze sim:/accelerator_trainer_differentiation_pkg/STIMULUS_ACCELERATOR_VECTOR_TRAINER_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_trainer_differentiation_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_TEST 
##################################################################################################

alias model_matrix_trainer_differentiation_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/differentiation/accelerator_trainer_differentiation_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/differentiation/accelerator_trainer_differentiation_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/trainer/differentiation/accelerator_trainer_differentiation_testbench.vhd

  vsim -g /accelerator_trainer_differentiation_testbench/ENABLE_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_trainer_differentiation_testbench

  #MACROS
  add log -r sim:/accelerator_trainer_differentiation_testbench/*

  #WAVES
  view -title model_matrix_trainer_differentiation wave
  do $simulation_path/trainer/differentiation/msim/waves/accelerator_matrix_trainer_differentiation.do

  force -freeze sim:/accelerator_trainer_differentiation_pkg/STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_TEST true 0
  force -freeze sim:/accelerator_trainer_differentiation_pkg/STIMULUS_ACCELERATOR_MATRIX_TRAINER_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_trainer_differentiation_test.wlf
}

##################################################################################################

alias v01 {
  model_vector_trainer_differentiation_verification_compilation
}

alias v02 {
  model_matrix_trainer_differentiation_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-VECTOR-TRAINER-DIFFERENTIATION-TEST"
echo "v02 . ACCELERATOR-MATRIX-TRAINER-DIFFERENTIATION-TEST"
echo "****************************************"
