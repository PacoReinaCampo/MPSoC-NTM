#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_INTEGER_ADDER_TEST 
##################################################################################################

alias model_scalar_integer_adder_verification_compilation {
  echo "TEST: NTM_SCALAR_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_SCALAR_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_scalar_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/model_scalar_integer_adder.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_SCALAR_INTEGER_ADDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_SCALAR_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_integer_adder_test.wlf
}

##################################################################################################
# NTM_SCALAR_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias model_scalar_integer_multiplier_verification_compilation {
  echo "TEST: NTM_SCALAR_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_scalar_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/model_scalar_integer_multiplier.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_integer_multiplier_test.wlf
}

##################################################################################################
# NTM_SCALAR_INTEGER_DIVIDER_TEST 
##################################################################################################

alias model_scalar_integer_divider_verification_compilation {
  echo "TEST: NTM_SCALAR_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_SCALAR_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_scalar_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/model_scalar_integer_divider.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_SCALAR_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_integer_divider_test.wlf
}

##################################################################################################
# NTM_VECTOR_INTEGER_ADDER_TEST 
##################################################################################################

alias model_vector_integer_adder_verification_compilation {
  echo "TEST: NTM_VECTOR_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_VECTOR_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_vector_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/model_vector_integer_adder.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_VECTOR_INTEGER_ADDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_VECTOR_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_integer_adder_test.wlf
}

##################################################################################################
# NTM_VECTOR_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias model_vector_integer_multiplier_verification_compilation {
  echo "TEST: NTM_VECTOR_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_vector_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/model_vector_integer_multiplier.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_VECTOR_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_integer_multiplier_test.wlf
}

##################################################################################################
# NTM_VECTOR_INTEGER_DIVIDER_TEST 
##################################################################################################

alias model_vector_integer_divider_verification_compilation {
  echo "TEST: NTM_VECTOR_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_VECTOR_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_vector_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/model_vector_integer_divider.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_VECTOR_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_VECTOR_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_integer_divider_test.wlf
}

##################################################################################################
# NTM_MATRIX_INTEGER_ADDER_TEST 
##################################################################################################

alias model_matrix_integer_adder_verification_compilation {
  echo "TEST: NTM_MATRIX_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_MATRIX_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_matrix_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/model_matrix_integer_adder.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_MATRIX_INTEGER_ADDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_MATRIX_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_integer_adder_test.wlf
}

##################################################################################################
# NTM_MATRIX_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias model_matrix_integer_multiplier_verification_compilation {
  echo "TEST: NTM_MATRIX_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_matrix_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/model_matrix_integer_multiplier.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_MATRIX_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_integer_multiplier_test.wlf
}

##################################################################################################
# NTM_MATRIX_INTEGER_DIVIDER_TEST 
##################################################################################################

alias model_matrix_integer_divider_verification_compilation {
  echo "TEST: NTM_MATRIX_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_MATRIX_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_matrix_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/model_matrix_integer_divider.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_MATRIX_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_MATRIX_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_integer_divider_test.wlf
}

##################################################################################################
# NTM_TENSOR_INTEGER_ADDER_TEST 
##################################################################################################

alias model_tensor_integer_adder_verification_compilation {
  echo "TEST: NTM_TENSOR_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_TENSOR_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_tensor_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/model_tensor_integer_adder.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_TENSOR_INTEGER_ADDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_TENSOR_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_integer_adder_test.wlf
}

##################################################################################################
# NTM_TENSOR_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias model_tensor_integer_multiplier_verification_compilation {
  echo "TEST: NTM_TENSOR_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_tensor_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/model_tensor_integer_multiplier.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_TENSOR_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_integer_multiplier_test.wlf
}

##################################################################################################
# NTM_TENSOR_INTEGER_DIVIDER_TEST 
##################################################################################################

alias model_tensor_integer_divider_verification_compilation {
  echo "TEST: NTM_TENSOR_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/model_integer_testbench.vhd

  vsim -g /model_integer_testbench/ENABLE_NTM_TENSOR_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_integer_testbench

  #MACROS
  add log -r sim:/model_integer_testbench/*

  #WAVES
  view -title model_tensor_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/model_tensor_integer_divider.do

  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_TENSOR_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/model_integer_pkg/STIMULUS_NTM_TENSOR_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_integer_divider_test.wlf
}

##################################################################################################

alias v01 {
  model_scalar_integer_adder_verification_compilation 
}

alias v02 {
  model_scalar_integer_multiplier_verification_compilation 
}

alias v03 {
  model_scalar_integer_divider_verification_compilation 
}

alias v04 {
  model_vector_integer_adder_verification_compilation 
}

alias v05 {
  model_vector_integer_multiplier_verification_compilation 
}

alias v06 {
  model_vector_integer_divider_verification_compilation 
}

alias v07 {
  model_matrix_integer_adder_verification_compilation 
}

alias v08 {
  model_matrix_integer_multiplier_verification_compilation 
}

alias v09 {
  model_matrix_integer_divider_verification_compilation 
}

alias v10 {
  model_tensor_integer_adder_verification_compilation 
}

alias v11 {
  model_tensor_integer_multiplier_verification_compilation 
}

alias v12 {
  model_tensor_integer_divider_verification_compilation 
}

echo "************************************************************"
echo "v01 . ACCELERATOR-SCALAR-ADDER-TEST"
echo "v02 . ACCELERATOR-SCALAR-MULTIPLIER-TEST"
echo "v03 . ACCELERATOR-SCALAR-DIVIDER-TEST"
echo "v04 . ACCELERATOR-VECTOR-ADDER-TEST"
echo "v05 . ACCELERATOR-VECTOR-MULTIPLIER-TEST"
echo "v06 . ACCELERATOR-VECTOR-DIVIDER-TEST"
echo "v07 . ACCELERATOR-MATRIX-ADDER-TEST"
echo "v08 . ACCELERATOR-MATRIX-MULTIPLIER-TEST"
echo "v09 . ACCELERATOR-MATRIX-DIVIDER-TEST"
echo "v10 . ACCELERATOR-TENSOR-ADDER-TEST"
echo "v11 . ACCELERATOR-TENSOR-MULTIPLIER-TEST"
echo "v12 . ACCELERATOR-TENSOR-DIVIDER-TEST"
echo "************************************************************"
