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
# NTM_SCALAR_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_exponentiator_function_verification_compilation {
  echo "TEST: NTM_SCALAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_scalar_exponentiator_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_scalar_exponentiator_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_exponentiator_function_test.wlf
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
# NTM_VECTOR_CONVOLUTION_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_convolution_function_verification_compilation {
  echo "TEST: NTM_VECTOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_convolution_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_convolution_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_convolution_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_COSH_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_cosh_function_verification_compilation {
  echo "TEST: NTM_VECTOR_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_COSH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_cosh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_cosh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_COSH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_cosh_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_COSINE_SIMILARITY_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_cosine_similarity_function_verification_compilation {
  echo "TEST: NTM_VECTOR_COSINE_SIMILARITY_FUNCTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_COSINE_SIMILARITY_FUNCTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_cosine_similarity_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_cosine_similarity_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_FUNCTION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_FUNCTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_cosine_similarity_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_DIFFERENTIATION_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_differentiation_function_verification_compilation {
  echo "TEST: NTM_VECTOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_differentiation_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_differentiation_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_differentiation_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_exponentiator_function_verification_compilation {
  echo "TEST: NTM_VECTOR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_exponentiator_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_exponentiator_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_exponentiator_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_logarithm_function_verification_compilation {
  echo "TEST: NTM_VECTOR_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_logarithm_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_logarithm_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_LOGARITHM_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_logarithm_function_test.wlf
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
# NTM_VECTOR_MULTIPLICATION_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_multiplication_function_verification_compilation {
  echo "TEST: NTM_VECTOR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_multiplication_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_multiplication_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_multiplication_function_test.wlf
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
# NTM_VECTOR_SINH_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_sinh_function_verification_compilation {
  echo "TEST: NTM_VECTOR_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_SINH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_sinh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_sinh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_SINH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_sinh_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_SOFTMAX_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_softmax_function_verification_compilation {
  echo "TEST: NTM_VECTOR_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_softmax_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_softmax_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_SOFTMAX_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_softmax_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_SUMMATION_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_summation_function_verification_compilation {
  echo "TEST: NTM_VECTOR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_summation_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_summation_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_SUMMATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_summation_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_TANH_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_tanh_function_verification_compilation {
  echo "TEST: NTM_VECTOR_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_VECTOR_TANH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_vector_tanh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_vector_tanh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_TANH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_VECTOR_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_tanh_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_CONVOLUTION_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_convolution_function_verification_compilation {
  echo "TEST: NTM_MATRIX_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_convolution_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_convolution_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_convolution_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_COSH_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_cosh_function_verification_compilation {
  echo "TEST: NTM_MATRIX_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_COSH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_cosh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_cosh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_COSH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_cosh_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_COSINE_SIMILARITY_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_cosine_similarity_function_verification_compilation {
  echo "TEST: NTM_MATRIX_COSINE_SIMILARITY_FUNCTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_COSINE_SIMILARITY_FUNCTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_cosine_similarity_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_cosine_similarity_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_FUNCTION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_COSINE_SIMILARITY_FUNCTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_cosine_similarity_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_DIFFERENTIATION_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_differentiation_function_verification_compilation {
  echo "TEST: NTM_MATRIX_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_differentiation_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_differentiation_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_DIFFERENTIATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_differentiation_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_exponentiator_function_verification_compilation {
  echo "TEST: NTM_MATRIX_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_exponentiator_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_exponentiator_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_exponentiator_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_logarithm_function_verification_compilation {
  echo "TEST: NTM_MATRIX_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_logarithm_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_logarithm_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_LOGARITHM_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_logarithm_function_test.wlf
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
# NTM_MATRIX_MULTIPLICATION_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_multiplication_function_verification_compilation {
  echo "TEST: NTM_MATRIX_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_multiplication_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_multiplication_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_multiplication_function_test.wlf
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
# NTM_MATRIX_SINH_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_sinh_function_verification_compilation {
  echo "TEST: NTM_MATRIX_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_SINH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_sinh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_sinh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_SINH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_sinh_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_SOFTMAX_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_softmax_function_verification_compilation {
  echo "TEST: NTM_MATRIX_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_softmax_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_softmax_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_SOFTMAX_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_softmax_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_SUMMATION_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_summation_function_verification_compilation {
  echo "TEST: NTM_MATRIX_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_summation_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_summation_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_SUMMATION_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_summation_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_TANH_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_tanh_function_verification_compilation {
  echo "TEST: NTM_MATRIX_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/function/ntm_function_testbench.vhd

  vsim -g /ntm_function_testbench/ENABLE_NTM_MATRIX_TANH_TEST=true -t ps +notimingchecks -L unisim work.ntm_function_testbench

  #MACROS
  add log -r sim:/ntm_function_testbench/*

  #WAVES
  view -title ntm_matrix_tanh_function wave
  do $simulation_path/mpsoc/math/function/msim/waves/ntm_matrix_tanh_function.do

  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_TANH_TEST true 0
  force -freeze sim:/ntm_function_pkg/STIMULUS_NTM_MATRIX_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_tanh_function_test.wlf
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
  ntm_scalar_exponentiator_function_verification_compilation 
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

alias v14 {
  ntm_vector_convolution_function_verification_compilation 
}

alias v15 {
  ntm_vector_cosh_function_verification_compilation 
}

alias v16 {
  ntm_vector_cosine_similarity_function_verification_compilation 
}

alias v17 {
  ntm_vector_differentiation_function_verification_compilation 
}

alias v18 {
  ntm_vector_exponentiator_function_verification_compilation 
}

alias v19 {
  ntm_vector_logarithm_function_verification_compilation 
}

alias v20 {
  ntm_vector_logistic_function_verification_compilation 
}

alias v21 {
  ntm_vector_multiplication_function_verification_compilation 
}

alias v22 {
  ntm_vector_oneplus_function_verification_compilation 
}

alias v23 {
  ntm_vector_sinh_function_verification_compilation 
}

alias v24 {
  ntm_vector_softmax_function_verification_compilation 
}

alias v25 {
  ntm_vector_summation_function_verification_compilation 
}

alias v26 {
  ntm_vector_tanh_function_verification_compilation 
}

alias v27 {
  ntm_matrix_convolution_function_verification_compilation 
}

alias v28 {
  ntm_matrix_cosh_function_verification_compilation 
}

alias v29 {
  ntm_matrix_cosine_similarity_function_verification_compilation 
}

alias v30 {
  ntm_matrix_differentiation_function_verification_compilation 
}

alias v31 {
  ntm_matrix_exponentiator_function_verification_compilation 
}

alias v32 {
  ntm_matrix_logarithm_function_verification_compilation 
}

alias v33 {
  ntm_matrix_logistic_function_verification_compilation 
}

alias v34 {
  ntm_matrix_multiplication_function_verification_compilation 
}

alias v35 {
  ntm_matrix_oneplus_function_verification_compilation 
}

alias v36 {
  ntm_matrix_sinh_function_verification_compilation 
}

alias v37 {
  ntm_matrix_softmax_function_verification_compilation 
}

alias v38 {
  ntm_matrix_summation_function_verification_compilation 
}

alias v39 {
  ntm_matrix_tanh_function_verification_compilation 
}

echo "****************************************"
echo "v01 . NTM-SCALAR-CONVOLUTION-FUNCTION-TEST"
echo "v02 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "v03 . NTM-SCALAR-COSINE_SIMILARITY-FUNCTION-TEST"
echo "v04 . NTM-SCALAR-DIFFERENTIATION-FUNCTION-TEST"
echo "v05 . NTM-SCALAR-EXPONENTIATOR-FUNCTION-FUNCTION-TEST"
echo "v06 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "v07 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "v08 . NTM-SCALAR-MULTIPLICATION-FUNCTION-TEST"
echo "v09 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "v10 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "v11 . NTM-SCALAR-SOFTMAX-FUNCTION-TEST"
echo "v12 . NTM-SCALAR-SUMMATION-FUNCTION-TEST"
echo "v13 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "v14 . NTM-VECTOR-CONVOLUTION-FUNCTION-TEST"
echo "v15 . NTM-VECTOR-COSH-FUNCTION-TEST"
echo "v16 . NTM-VECTOR-COSINE_SIMILARITY-FUNCTION-TEST"
echo "v17 . NTM-VECTOR-DIFFERENTIATION-FUNCTION-TEST"
echo "v18 . NTM-VECTOR-EXPONENTIATOR-FUNCTION-FUNCTION-TEST"
echo "v19 . NTM-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "v20 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "v21 . NTM-VECTOR-MULTIPLICATION-FUNCTION-TEST"
echo "v22 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "v23 . NTM-VECTOR-SINH-FUNCTION-TEST"
echo "v24 . NTM-VECTOR-SOFTMAX-FUNCTION-TEST"
echo "v25 . NTM-VECTOR-SUMMATION-FUNCTION-TEST"
echo "v26 . NTM-VECTOR-TANH-FUNCTION-TEST"
echo "v27 . NTM-MATRIX-CONVOLUTION-FUNCTION-TEST"
echo "v28 . NTM-MATRIX-COSH-FUNCTION-TEST"
echo "v29 . NTM-MATRIX-COSINE_SIMILARITY-FUNCTION-TEST"
echo "v30 . NTM-MATRIX-DIFFERENTIATION-FUNCTION-TEST"
echo "v31 . NTM-MATRIX-EXPONENTIATOR-FUNCTION-FUNCTION-TEST"
echo "v32 . NTM-MATRIX-LOGARITHM-FUNCTION-TEST"
echo "v33 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "v34 . NTM-MATRIX-MULTIPLICATION-FUNCTION-TEST"
echo "v35 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "v36 . NTM-MATRIX-SINH-FUNCTION-TEST"
echo "v37 . NTM-MATRIX-SOFTMAX-FUNCTION-TEST"
echo "v38 . NTM-MATRIX-SUMMATION-FUNCTION-TEST"
echo "v39 . NTM-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"