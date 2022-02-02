#*************************
# VERIFICATION
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

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_SCALAR_COSH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_scalar_cosh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_scalar_cosh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_COSH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_cosh_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_exponentiator_function_verification_compilation {
  echo "TEST: NTM_SCALAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_SCALAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_scalar_exponentiator_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_scalar_exponentiator_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_exponentiator_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_logarithm_function_verification_compilation {
  echo "TEST: NTM_SCALAR_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_SCALAR_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_scalar_logarithm_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_scalar_logarithm_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_LOGARITHM_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_logarithm_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_SINH_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_sinh_function_verification_compilation {
  echo "TEST: NTM_SCALAR_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_SCALAR_SINH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_scalar_sinh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_scalar_sinh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_SINH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_sinh_function_test.wlf
}

##################################################################################################
# NTM_SCALAR_TANH_FUNCTION_TEST 
##################################################################################################

alias ntm_scalar_tanh_function_verification_compilation {
  echo "TEST: NTM_SCALAR_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_SCALAR_TANH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_scalar_tanh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_scalar_tanh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_TANH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_SCALAR_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_tanh_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_COSH_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_cosh_function_verification_compilation {
  echo "TEST: NTM_VECTOR_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_VECTOR_COSH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_vector_cosh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_vector_cosh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_COSH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_cosh_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_exponentiator_function_verification_compilation {
  echo "TEST: NTM_VECTOR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_VECTOR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_vector_exponentiator_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_vector_exponentiator_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_exponentiator_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_logarithm_function_verification_compilation {
  echo "TEST: NTM_VECTOR_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_VECTOR_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_vector_logarithm_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_vector_logarithm_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_LOGARITHM_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_logarithm_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_SINH_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_sinh_function_verification_compilation {
  echo "TEST: NTM_VECTOR_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_VECTOR_SINH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_vector_sinh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_vector_sinh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_SINH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_sinh_function_test.wlf
}

##################################################################################################
# NTM_VECTOR_TANH_FUNCTION_TEST 
##################################################################################################

alias ntm_vector_tanh_function_verification_compilation {
  echo "TEST: NTM_VECTOR_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_VECTOR_TANH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_vector_tanh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_vector_tanh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_TANH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_VECTOR_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_tanh_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_COSH_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_cosh_function_verification_compilation {
  echo "TEST: NTM_MATRIX_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_MATRIX_COSH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_matrix_cosh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_matrix_cosh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_COSH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_cosh_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_exponentiator_function_verification_compilation {
  echo "TEST: NTM_MATRIX_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_MATRIX_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_matrix_exponentiator_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_matrix_exponentiator_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_exponentiator_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_logarithm_function_verification_compilation {
  echo "TEST: NTM_MATRIX_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_MATRIX_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_matrix_logarithm_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_matrix_logarithm_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_LOGARITHM_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_logarithm_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_SINH_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_sinh_function_verification_compilation {
  echo "TEST: NTM_MATRIX_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_MATRIX_SINH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_matrix_sinh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_matrix_sinh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_SINH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_sinh_function_test.wlf
}

##################################################################################################
# NTM_MATRIX_TANH_FUNCTION_TEST 
##################################################################################################

alias ntm_matrix_tanh_function_verification_compilation {
  echo "TEST: NTM_MATRIX_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/ntm_series_testbench.vhd

  vsim -g /ntm_series_testbench/ENABLE_NTM_MATRIX_TANH_TEST=true -t ps +notimingchecks -L unisim work.ntm_series_testbench

  #MACROS
  add log -r sim:/ntm_series_testbench/*

  #WAVES
  view -title ntm_matrix_tanh_function wave
  do $simulation_path/mpsoc/math/series/msim/waves/ntm_matrix_tanh_function.do

  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_TANH_TEST true 0
  force -freeze sim:/ntm_series_pkg/STIMULUS_NTM_MATRIX_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_tanh_function_test.wlf
}

##################################################################################################

alias v01 {
  ntm_scalar_cosh_function_verification_compilation 
}

alias v02 {
  ntm_scalar_exponentiator_function_verification_compilation 
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

alias v06 {
  ntm_vector_cosh_function_verification_compilation 
}

alias v07 {
  ntm_vector_exponentiator_function_verification_compilation 
}

alias v08 {
  ntm_vector_logarithm_function_verification_compilation 
}

alias v09 {
  ntm_vector_sinh_function_verification_compilation 
}

alias v10 {
  ntm_vector_tanh_function_verification_compilation 
}

alias v11 {
  ntm_matrix_cosh_function_verification_compilation 
}

alias v12 {
  ntm_matrix_exponentiator_function_verification_compilation 
}

alias v13 {
  ntm_matrix_logarithm_function_verification_compilation 
}

alias v14 {
  ntm_matrix_sinh_function_verification_compilation 
}

alias v15 {
  ntm_matrix_tanh_function_verification_compilation 
}

echo "****************************************"
echo "v01 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "v02 . NTM-SCALAR-EXPONENTIATOR-FUNCTION-TEST"
echo "v03 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "v04 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "v05 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "v06 . NTM-VECTOR-COSH-FUNCTION-TEST"
echo "v07 . NTM-VECTOR-EXPONENTIATOR-FUNCTION-TEST"
echo "v08 . NTM-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "v09 . NTM-VECTOR-SINH-FUNCTION-TEST"
echo "v10 . NTM-VECTOR-TANH-FUNCTION-TEST"
echo "v11 . NTM-MATRIX-COSH-FUNCTION-TEST"
echo "v12 . NTM-MATRIX-EXPONENTIATOR-FUNCTION-TEST"
echo "v13 . NTM-MATRIX-LOGARITHM-FUNCTION-TEST"
echo "v14 . NTM-MATRIX-SINH-FUNCTION-TEST"
echo "v15 . NTM-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"