#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_SCALAR_INTEGER_ADDER_TEST 
##################################################################################################

alias accelerator_scalar_integer_adder_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_scalar_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_scalar_integer_adder.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_integer_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_scalar_integer_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_scalar_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_scalar_integer_multiplier.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_integer_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST 
##################################################################################################

alias accelerator_scalar_integer_divider_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_scalar_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_scalar_integer_divider.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_integer_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_INTEGER_ADDER_TEST 
##################################################################################################

alias accelerator_vector_integer_adder_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_vector_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_vector_integer_adder.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_integer_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_vector_integer_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_vector_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_vector_integer_multiplier.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_integer_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST 
##################################################################################################

alias accelerator_vector_integer_divider_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_vector_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_vector_integer_divider.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_integer_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_INTEGER_ADDER_TEST 
##################################################################################################

alias accelerator_matrix_integer_adder_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_matrix_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_matrix_integer_adder.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_integer_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_matrix_integer_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_matrix_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_matrix_integer_multiplier.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_integer_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST 
##################################################################################################

alias accelerator_matrix_integer_divider_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_matrix_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_matrix_integer_divider.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_integer_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_INTEGER_ADDER_TEST 
##################################################################################################

alias accelerator_tensor_integer_adder_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_INTEGER_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_TENSOR_INTEGER_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_tensor_integer_adder wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_tensor_integer_adder.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGER_ADDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGER_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_integer_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_tensor_integer_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_tensor_integer_multiplier wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_tensor_integer_multiplier.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGER_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_integer_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_INTEGER_DIVIDER_TEST 
##################################################################################################

alias accelerator_tensor_integer_divider_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_INTEGER_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/integer/accelerator_integer_testbench.vhd

  vsim -g /accelerator_integer_testbench/ENABLE_ACCELERATOR_TENSOR_INTEGER_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_integer_testbench

  #MACROS
  add log -r sim:/accelerator_integer_testbench/*

  #WAVES
  view -title accelerator_tensor_integer_divider wave
  do $simulation_path/arithmetic/integer/msim/waves/accelerator_tensor_integer_divider.do

  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGER_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_integer_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGER_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_integer_divider_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_scalar_integer_adder_verification_compilation 
}

alias v02 {
  accelerator_scalar_integer_multiplier_verification_compilation 
}

alias v03 {
  accelerator_scalar_integer_divider_verification_compilation 
}

alias v04 {
  accelerator_vector_integer_adder_verification_compilation 
}

alias v05 {
  accelerator_vector_integer_multiplier_verification_compilation 
}

alias v06 {
  accelerator_vector_integer_divider_verification_compilation 
}

alias v07 {
  accelerator_matrix_integer_adder_verification_compilation 
}

alias v08 {
  accelerator_matrix_integer_multiplier_verification_compilation 
}

alias v09 {
  accelerator_matrix_integer_divider_verification_compilation 
}

alias v10 {
  accelerator_tensor_integer_adder_verification_compilation 
}

alias v11 {
  accelerator_tensor_integer_multiplier_verification_compilation 
}

alias v12 {
  accelerator_tensor_integer_divider_verification_compilation 
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
