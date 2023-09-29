#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias model_scalar_logistic_function_verification_compilation {
  echo "TEST: NTM_SCALAR_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_testbench.vhd

  vsim -g /model_function_testbench/ENABLE_NTM_SCALAR_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.model_function_testbench

  #MACROS
  add log -r sim:/model_function_testbench/*

  force -freeze sim:/model_function_pkg/STIMULUS_NTM_SCALAR_LOGISTIC_TEST true 0
  force -freeze sim:/model_function_pkg/STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_logistic_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias model_scalar_oneplus_function_verification_compilation {
  echo "TEST: NTM_SCALAR_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_testbench.vhd

  vsim -g /model_function_testbench/ENABLE_NTM_SCALAR_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.model_function_testbench

  #MACROS
  add log -r sim:/model_function_testbench/*

  force -freeze sim:/model_function_pkg/STIMULUS_NTM_SCALAR_ONEPLUS_TEST true 0
  force -freeze sim:/model_function_pkg/STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_oneplus_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias model_vector_logistic_function_verification_compilation {
  echo "TEST: NTM_VECTOR_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_testbench.vhd

  vsim -g /model_function_testbench/ENABLE_NTM_VECTOR_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.model_function_testbench

  #MACROS
  add log -r sim:/model_function_testbench/*

  force -freeze sim:/model_function_pkg/STIMULUS_NTM_VECTOR_LOGISTIC_TEST true 0
  force -freeze sim:/model_function_pkg/STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_logistic_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias model_vector_oneplus_function_verification_compilation {
  echo "TEST: NTM_VECTOR_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_testbench.vhd

  vsim -g /model_function_testbench/ENABLE_NTM_VECTOR_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.model_function_testbench

  #MACROS
  add log -r sim:/model_function_testbench/*

  force -freeze sim:/model_function_pkg/STIMULUS_NTM_VECTOR_ONEPLUS_TEST true 0
  force -freeze sim:/model_function_pkg/STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_oneplus_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias model_matrix_logistic_function_verification_compilation {
  echo "TEST: NTM_MATRIX_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_testbench.vhd

  vsim -g /model_function_testbench/ENABLE_NTM_MATRIX_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.model_function_testbench

  #MACROS
  add log -r sim:/model_function_testbench/*

  force -freeze sim:/model_function_pkg/STIMULUS_NTM_MATRIX_LOGISTIC_TEST true 0
  force -freeze sim:/model_function_pkg/STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_logistic_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias model_matrix_oneplus_function_verification_compilation {
  echo "TEST: NTM_MATRIX_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/model_function_testbench.vhd

  vsim -g /model_function_testbench/ENABLE_NTM_MATRIX_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.model_function_testbench

  #MACROS
  add log -r sim:/model_function_testbench/*

  force -freeze sim:/model_function_pkg/STIMULUS_NTM_MATRIX_ONEPLUS_TEST true 0
  force -freeze sim:/model_function_pkg/STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_oneplus_function_test.wlf
}

##################################################################################################

alias v01 {
  model_scalar_logistic_function_verification_compilation
}

alias v02 {
  model_scalar_oneplus_function_verification_compilation
}

alias v03 {
  model_vector_logistic_function_verification_compilation
}

alias v04 {
  model_vector_oneplus_function_verification_compilation
}

alias v05 {
  model_matrix_logistic_function_verification_compilation
}

alias v06 {
  model_matrix_oneplus_function_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "v02 . ACCELERATOR-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "v03 . ACCELERATOR-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "v04 . ACCELERATOR-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "v05 . ACCELERATOR-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "v06 . ACCELERATOR-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"
