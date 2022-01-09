#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_COSH_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_cosh_function_verification_compilation {
  echo "TEST: NTM_SCALAR_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_COSH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_cosh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_cosh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_COSH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_cosh_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_EXPONENTIATOR_TEST 
##################################################################################################

alias ntm_scalar_exponentiator_verification_compilation {
  echo "TEST: NTM_SCALAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_exponentiator wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_exponentiator.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_exponentiator_test.wlf
}

##################################################################################################
# NTM_SCALAR_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_logarithm_function_verification_compilation {
  echo "TEST: NTM_SCALAR_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_logarithm_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_logarithm_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_LOGARITHM_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_logarithm_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_SINH_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_sinh_function_verification_compilation {
  echo "TEST: NTM_SCALAR_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_SINH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_sinh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_sinh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_SINH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_sinh_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_TANH_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_tanh_function_verification_compilation {
  echo "TEST: NTM_SCALAR_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_TANH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_tanh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_tanh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_TANH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_tanh_function_test.wlf
}

##################################################################################################

alias v01 {
  ntm_scalar_cosh_function_verification_compilation
}

alias v02 {
  ntm_scalar_exponentiator_verification_compilation
}

alias v03 {
  ntm_scalar_logarithm_function_verification_compilation
}

alias v04 {
  ntm_scalar_sinh_function_verification_compilation
}

alias v05 {
  ntm_scalar_tanh_function_verification_compilation
}

echo "************************************************************"
echo "v01 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "v02 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "v03 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "v04 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "v05 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "************************************************************"