#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_CONVOLUTION_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_convolution_function_verification_compilation {
  echo "TEST: NTM_SCALAR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_convolution_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_convolution_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_convolution_function_test.wlf
}

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
# NTM_SCALAR_COSINE_SIMILARITY_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_cosine_similarity_function_verification_compilation {
  echo "TEST: NTM_SCALAR_COSINE_SIMILARITY_FUNCTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_COSINE_SIMILARITY_FUNCTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_cosine_similarity_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_cosine_similarity_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_FUNCTION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_COSINE_SIMILARITY_FUNCTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_cosine_similarity_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_DIFFERENTIATION_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_differentiation_function_verification_compilation {
  echo "TEST: NTM_SCALAR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_differentiation_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_differentiation_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_differentiation_function_test.wlf
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
# NTM_SCALAR_MULTIPLICATION_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_multiplication_function_verification_compilation {
  echo "TEST: NTM_SCALAR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_multiplication_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_multiplication_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_MULTIPLICATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_multiplication_function_test.wlf
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
# NTM_SCALAR_SOFTMAX_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_softmax_function_verification_compilation {
  echo "TEST: NTM_SCALAR_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_softmax_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_softmax_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_SOFTMAX_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_softmax_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_SUMMATION_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_summation_function_verification_compilation {
  echo "TEST: NTM_SCALAR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_summation_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_summation_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_SUMMATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_summation_function_test.wlf
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
  ntm_scalar_convolution_function_verification_compilation 
}

alias v02 {
  ntm_scalar_cosh_function_verification_compilation 
}

alias v03 {
  ntm_scalar_cosine_similarity_function_verification_compilation 
}

alias v04 {
  ntm_scalar_differentiation_function_verification_compilation 
}

alias v05 {
  ntm_scalar_exponentiator_verification_compilation 
}

alias v06 {
  ntm_scalar_logarithm_function_verification_compilation 
}

alias v07 {
  ntm_scalar_logistic_function_verification_compilation 
}

alias v08 {
  ntm_scalar_multiplication_function_verification_compilation 
}

alias v09 {
  ntm_scalar_oneplus_function_verification_compilation 
}

alias v10 {
  ntm_scalar_sinh_function_verification_compilation 
}

alias v11 {
  ntm_scalar_softmax_function_verification_compilation 
}

alias v12 {
  ntm_scalar_summation_function_verification_compilation 
}

alias v13 {
  ntm_scalar_tanh_function_verification_compilation 
}

echo "****************************************"
echo "v01 . NTM-SCALAR-CONVOLUTION-FUNCTION-TEST"
echo "v02 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "v03 . NTM-SCALAR-COSINE_SIMILARITY-FUNCTION-TEST"
echo "v04 . NTM-SCALAR-DIFFERENTIATION-FUNCTION-TEST"
echo "v05 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "v06 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "v07 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "v08 . NTM-SCALAR-MULTIPLICATION-FUNCTION-TEST"
echo "v09 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "v10 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "v11 . NTM-SCALAR-SOFTMAX-FUNCTION-TEST"
echo "v12 . NTM-SCALAR-SUMMATION-FUNCTION-TEST"
echo "v13 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "****************************************"