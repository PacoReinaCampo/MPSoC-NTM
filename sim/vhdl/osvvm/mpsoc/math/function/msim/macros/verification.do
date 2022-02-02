#*************************
# VERIFICATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_logistic_function_verification_compilation {
  echo "TEST: NTM_SCALAR_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_logistic_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_logistic_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_LOGISTIC_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_logistic_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_oneplus_function_verification_compilation {
  echo "TEST: NTM_SCALAR_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_oneplus_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_oneplus_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_ONEPLUS_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_oneplus_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_logistic_function_verification_compilation {
  echo "TEST: NTM_VECTOR_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_logistic_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_logistic_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_LOGISTIC_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_logistic_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_oneplus_function_verification_compilation {
  echo "TEST: NTM_VECTOR_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_oneplus_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_oneplus_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_ONEPLUS_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_oneplus_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_logistic_function_verification_compilation {
  echo "TEST: NTM_MATRIX_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_logistic_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_logistic_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_LOGISTIC_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_logistic_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_oneplus_function_verification_compilation {
  echo "TEST: NTM_MATRIX_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_oneplus_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_oneplus_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_ONEPLUS_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_oneplus_function_test.wlf
}

##################################################################################################

alias v01 {
  ntm_scalar_logistic_function_verification_compilation
}

alias v02 {
  ntm_scalar_oneplus_function_verification_compilation
}

alias v03 {
  ntm_vector_logistic_function_verification_compilation
}

alias v04 {
  ntm_vector_oneplus_function_verification_compilation
}

alias v05 {
  ntm_matrix_logistic_function_verification_compilation
}

alias 06 {
  ntm_matrix_oneplus_function_verification_compilation
}

echo "****************************************"
echo "v01 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "v02 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "v03 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "v04 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "v05 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "v06 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"