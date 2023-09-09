#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_SCALAR_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias accelerator_scalar_logistic_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_testbench.vhd

  vsim -g /accelerator_function_testbench/ENABLE_ACCELERATOR_SCALAR_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.accelerator_function_testbench

  #MACROS
  add log -r sim:/accelerator_function_testbench/*

  #WAVES
  view -title accelerator_scalar_logistic_function wave
  do $simulation_path/math/function/msim/waves/accelerator_scalar_logistic_function.do

  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_TEST true 0
  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_logistic_function_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias accelerator_scalar_oneplus_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_testbench.vhd

  vsim -g /accelerator_function_testbench/ENABLE_ACCELERATOR_SCALAR_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.accelerator_function_testbench

  #MACROS
  add log -r sim:/accelerator_function_testbench/*

  #WAVES
  view -title accelerator_scalar_oneplus_function wave
  do $simulation_path/math/function/msim/waves/accelerator_scalar_oneplus_function.do

  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_TEST true 0
  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_oneplus_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias accelerator_vector_logistic_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_testbench.vhd

  vsim -g /accelerator_function_testbench/ENABLE_ACCELERATOR_VECTOR_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.accelerator_function_testbench

  #MACROS
  add log -r sim:/accelerator_function_testbench/*

  #WAVES
  view -title accelerator_vector_logistic_function wave
  do $simulation_path/math/function/msim/waves/accelerator_vector_logistic_function.do

  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_TEST true 0
  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_logistic_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias accelerator_vector_oneplus_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_testbench.vhd

  vsim -g /accelerator_function_testbench/ENABLE_ACCELERATOR_VECTOR_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.accelerator_function_testbench

  #MACROS
  add log -r sim:/accelerator_function_testbench/*

  #WAVES
  view -title accelerator_vector_oneplus_function wave
  do $simulation_path/math/function/msim/waves/accelerator_vector_oneplus_function.do

  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_TEST true 0
  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_oneplus_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_LOGISTIC_FUNCTION_TEST 
##################################################################################################

alias accelerator_matrix_logistic_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_LOGISTIC_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_testbench.vhd

  vsim -g /accelerator_function_testbench/ENABLE_ACCELERATOR_MATRIX_LOGISTIC_TEST=true -t ps +notimingchecks -L unisim work.accelerator_function_testbench

  #MACROS
  add log -r sim:/accelerator_function_testbench/*

  #WAVES
  view -title accelerator_matrix_logistic_function wave
  do $simulation_path/math/function/msim/waves/accelerator_matrix_logistic_function.do

  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_TEST true 0
  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_logistic_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_ONEPLUS_FUNCTION_TEST 
##################################################################################################

alias accelerator_matrix_oneplus_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_ONEPLUS_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/accelerator_function_testbench.vhd

  vsim -g /accelerator_function_testbench/ENABLE_ACCELERATOR_MATRIX_ONEPLUS_TEST=true -t ps +notimingchecks -L unisim work.accelerator_function_testbench

  #MACROS
  add log -r sim:/accelerator_function_testbench/*

  #WAVES
  view -title accelerator_matrix_oneplus_function wave
  do $simulation_path/math/function/msim/waves/accelerator_matrix_oneplus_function.do

  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_TEST true 0
  force -freeze sim:/accelerator_function_pkg/STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_oneplus_function_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_scalar_logistic_function_verification_compilation
}

alias v02 {
  accelerator_scalar_oneplus_function_verification_compilation
}

alias v03 {
  accelerator_vector_logistic_function_verification_compilation
}

alias v04 {
  accelerator_vector_oneplus_function_verification_compilation
}

alias v05 {
  accelerator_matrix_logistic_function_verification_compilation
}

alias v06 {
  accelerator_matrix_oneplus_function_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "v02 . ACCELERATOR-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "v03 . ACCELERATOR-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "v04 . ACCELERATOR-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "v05 . ACCELERATOR-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "v06 . ACCELERATOR-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"
