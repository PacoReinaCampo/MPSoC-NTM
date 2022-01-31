#*************************
# VERIFICATION
#*************************


do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_FLOAT_ADDER_TEST 
##################################################################################################

alias ntm_scalar_float_adder_verification_compilation {
  echo "TEST: NTM_SCALAR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_SCALAR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_scalar_float_adder wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_scalar_float_adder.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_float_adder_test.wlf
}

##################################################################################################
# NTM_SCALAR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias ntm_scalar_float_multiplier_verification_compilation {
  echo "TEST: NTM_SCALAR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_SCALAR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_scalar_float_multiplier wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_scalar_float_multiplier.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_float_multiplier_test.wlf
}

##################################################################################################
# NTM_SCALAR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias ntm_scalar_float_divider_verification_compilation {
  echo "TEST: NTM_SCALAR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_SCALAR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_scalar_float_divider wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_scalar_float_divider.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_float_divider_test.wlf
}

##################################################################################################
# NTM_VECTOR_FLOAT_ADDER_TEST 
##################################################################################################

alias ntm_vector_float_adder_verification_compilation {
  echo "TEST: NTM_VECTOR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_VECTOR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_vector_float_adder wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_vector_float_adder.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_float_adder_test.wlf
}

##################################################################################################
# NTM_VECTOR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias ntm_vector_float_multiplier_verification_compilation {
  echo "TEST: NTM_VECTOR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_VECTOR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_vector_float_multiplier wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_vector_float_multiplier.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_float_multiplier_test.wlf
}

##################################################################################################
# NTM_VECTOR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias ntm_vector_float_divider_verification_compilation {
  echo "TEST: NTM_VECTOR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_VECTOR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_vector_float_divider wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_vector_float_divider.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_float_divider_test.wlf
}

##################################################################################################
# NTM_MATRIX_FLOAT_ADDER_TEST 
##################################################################################################

alias ntm_matrix_float_adder_verification_compilation {
  echo "TEST: NTM_MATRIX_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_MATRIX_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_matrix_float_adder wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_matrix_float_adder.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_ADDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_float_adder_test.wlf
}

##################################################################################################
# NTM_MATRIX_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias ntm_matrix_float_multiplier_verification_compilation {
  echo "TEST: NTM_MATRIX_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_MATRIX_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_matrix_float_multiplier wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_matrix_float_multiplier.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_float_multiplier_test.wlf
}

##################################################################################################
# NTM_MATRIX_FLOAT_DIVIDER_TEST 
##################################################################################################

alias ntm_matrix_float_divider_verification_compilation {
  echo "TEST: NTM_MATRIX_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/ntm_float_testbench.vhd

  vsim -g /ntm_float_testbench/ENABLE_NTM_MATRIX_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_float_testbench

  #MACROS
  add log -r sim:/ntm_float_testbench/*

  #WAVES
  view -title ntm_matrix_float_divider wave
  do $simulation_path/mpsoc/arithmetic/float/msim/waves/ntm_matrix_float_divider.do

  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/ntm_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_float_divider_test.wlf
}

##################################################################################################

alias v01 {
  ntm_scalar_float_adder_verification_compilation
}

alias v02 {
  ntm_scalar_float_multiplier_verification_compilation
}

alias v03 {
  ntm_scalar_float_divider_verification_compilation
}

alias v04 {
  ntm_vector_float_adder_verification_compilation
}

alias v05 {
  ntm_vector_float_multiplier_verification_compilation
}

alias v06 {
  ntm_vector_float_divider_verification_compilation
}

alias v07 {
  ntm_matrix_float_adder_verification_compilation
}

alias v08 {
  ntm_matrix_float_multiplier_verification_compilation
}

alias v09 {
  ntm_matrix_float_divider_verification_compilation
}

echo "****************************************"
echo "v01 . NTM-SCALAR-FLOAT-ADDER-TEST"
echo "v02 . NTM-SCALAR-FLOAT-MULTIPLIER-TEST"
echo "v03 . NTM-SCALAR-FLOAT-DIVIDER-TEST"
echo "v04 . NTM-VECTOR-FLOAT-ADDER-TEST"
echo "v05 . NTM-VECTOR-FLOAT-MULTIPLIER-TEST"
echo "v06 . NTM-VECTOR-FLOAT-DIVIDER-TEST"
echo "v07 . NTM-MATRIX-FLOAT-ADDER-TEST"
echo "v08 . NTM-MATRIX-FLOAT-MULTIPLIER-TEST"
echo "v09 . NTM-MATRIX-FLOAT-DIVIDER-TEST"
echo "****************************************"