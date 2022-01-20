#*************************
# VERIFICATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_VECTOR_INTEGRATION_TEST 
##################################################################################################

alias ntm_vector_integration_verification_compilation {
  echo "TEST: NTM_VECTOR_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_VECTOR_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_vector_integration wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_vector_integration.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_VECTOR_INTEGRATION_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_VECTOR_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_integration_test.wlf
}

##################################################################################################
# NTM_VECTOR_AVERAGE_TEST 
##################################################################################################

alias ntm_vector_average_verification_compilation {
  echo "TEST: NTM_VECTOR_AVERAGE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_VECTOR_AVERAGE_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_vector_average wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_vector_average.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_VECTOR_AVERAGE_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_VECTOR_AVERAGE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_average_test.wlf
}

##################################################################################################
# NTM_VECTOR_DIFFERENTIATION_TEST 
##################################################################################################

alias ntm_vector_differentiation_verification_compilation {
  echo "TEST: NTM_VECTOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_vector_differentiation wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_vector_differentiation.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_VECTOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_differentiation_test.wlf
}

##################################################################################################
# NTM_MATRIX_INTEGRATION_TEST 
##################################################################################################

alias ntm_matrix_integration_verification_compilation {
  echo "TEST: NTM_MATRIX_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_MATRIX_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_matrix_integration wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_matrix_integration.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_MATRIX_INTEGRATION_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_MATRIX_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_integration_test.wlf
}

##################################################################################################
# NTM_MATRIX_AVERAGE_TEST 
##################################################################################################

alias ntm_matrix_average_verification_compilation {
  echo "TEST: NTM_MATRIX_AVERAGE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_MATRIX_AVERAGE_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_matrix_average wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_matrix_average.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_MATRIX_AVERAGE_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_MATRIX_AVERAGE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_average_test.wlf
}

##################################################################################################
# NTM_MATRIX_DIFFERENTIATION_TEST 
##################################################################################################

alias ntm_matrix_differentiation_verification_compilation {
  echo "TEST: NTM_MATRIX_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_matrix_differentiation wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_matrix_differentiation.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_MATRIX_DIFFERENTIATION_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_differentiation_test.wlf
}

##################################################################################################
# NTM_TENSOR_INTEGRATION_TEST 
##################################################################################################

alias ntm_tensor_integration_verification_compilation {
  echo "TEST: NTM_TENSOR_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_TENSOR_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_tensor_integration wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_tensor_integration.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_TENSOR_INTEGRATION_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_TENSOR_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_integration_test.wlf
}

##################################################################################################
# NTM_TENSOR_AVERAGE_TEST 
##################################################################################################

alias ntm_tensor_average_verification_compilation {
  echo "TEST: NTM_TENSOR_AVERAGE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_TENSOR_AVERAGE_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_tensor_average wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_tensor_average.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_TENSOR_AVERAGE_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_TENSOR_AVERAGE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_average_test.wlf
}

##################################################################################################
# NTM_TENSOR_DIFFERENTIATION_TEST 
##################################################################################################

alias ntm_tensor_differentiation_verification_compilation {
  echo "TEST: NTM_TENSOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/ntm_calculus_testbench.vhd

  vsim -g /ntm_calculus_testbench/ENABLE_NTM_TENSOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_calculus_testbench

  #MACROS
  add log -r sim:/ntm_calculus_testbench/*

  #WAVES
  view -title ntm_tensor_differentiation wave
  do $simulation_path/mpsoc/math/calculus/msim/waves/ntm_tensor_differentiation.do

  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_TENSOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/ntm_calculus_pkg/STIMULUS_NTM_TENSOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_differentiation_test.wlf
}

##################################################################################################

alias v01 {
  ntm_vector_integration_verification_compilation
}

alias v02 {
  ntm_vector_average_verification_compilation
}

alias v03 {
  ntm_vector_differentiation_verification_compilation
}

alias v04 {
  ntm_matrix_integration_verification_compilation
}

alias v05 {
  ntm_matrix_average_verification_compilation
}

alias v06 {
  ntm_matrix_differentiation_verification_compilation
}

alias v07 {
  ntm_tensor_integration_verification_compilation
}

alias v08 {
  ntm_tensor_average_verification_compilation
}

alias v09 {
  ntm_tensor_differentiation_verification_compilation
}

echo "****************************************"
echo "v01 . NTM-VECTOR-INTEGRATION-TEST"
echo "v02 . NTM-VECTOR-AVERAGE-TEST"
echo "v03 . NTM-VECTOR-DIFFERENTIATION-TEST"
echo "v04 . NTM-MATRIX-INTEGRATION-TEST"
echo "v05 . NTM-MATRIX-AVERAGE-TEST"
echo "v06 . NTM-MATRIX-DIFFERENTIATION-TEST"
echo "v07 . NTM-TENSOR-INTEGRATION-TEST"
echo "v08 . NTM-TENSOR-AVERAGE-TEST"
echo "v09 . NTM-TENSOR-DIFFERENTIATION-TEST"
echo "****************************************"
