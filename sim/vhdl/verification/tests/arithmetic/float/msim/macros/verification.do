#*************************
# VERIFICATION
#*************************


do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_SCALAR_FLOAT_ADDER_TEST 
##################################################################################################

alias accelerator_scalar_float_adder_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_SCALAR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_scalar_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_scalar_float_adder.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_SCALAR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_float_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_scalar_float_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_scalar_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_scalar_float_multiplier.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_SCALAR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_float_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias accelerator_scalar_float_divider_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_scalar_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_scalar_float_divider.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_SCALAR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_float_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_FLOAT_ADDER_TEST 
##################################################################################################

alias accelerator_vector_float_adder_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_VECTOR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_vector_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_vector_float_adder.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_VECTOR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_VECTOR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_float_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_vector_float_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_vector_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_vector_float_multiplier.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_VECTOR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_float_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias accelerator_vector_float_divider_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_vector_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_vector_float_divider.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_VECTOR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_VECTOR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_float_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_FLOAT_ADDER_TEST 
##################################################################################################

alias accelerator_matrix_float_adder_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_MATRIX_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_matrix_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_matrix_float_adder.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_MATRIX_FLOAT_ADDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_MATRIX_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_float_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_matrix_float_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_matrix_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_matrix_float_multiplier.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_MATRIX_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_float_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST 
##################################################################################################

alias accelerator_matrix_float_divider_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_matrix_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_matrix_float_divider.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_MATRIX_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_MATRIX_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_float_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_FLOAT_ADDER_TEST 
##################################################################################################

alias accelerator_tensor_float_adder_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_TENSOR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_tensor_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_tensor_float_adder.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_TENSOR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_TENSOR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_float_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_tensor_float_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_tensor_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_tensor_float_multiplier.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_TENSOR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_float_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias accelerator_tensor_float_divider_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/accelerator_float_testbench.vhd

  vsim -g /accelerator_float_testbench/ENABLE_ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_float_testbench

  #MACROS
  add log -r sim:/accelerator_float_testbench/*

  #WAVES
  view -title accelerator_tensor_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/accelerator_tensor_float_divider.do

  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_TENSOR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_float_pkg/STIMULUS_ACCELERATOR_TENSOR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_float_divider_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_scalar_float_adder_verification_compilation
}

alias v02 {
  accelerator_scalar_float_multiplier_verification_compilation
}

alias v03 {
  accelerator_scalar_float_divider_verification_compilation
}

alias v04 {
  accelerator_vector_float_adder_verification_compilation
}

alias v05 {
  accelerator_vector_float_multiplier_verification_compilation
}

alias v06 {
  accelerator_vector_float_divider_verification_compilation
}

alias v07 {
  accelerator_matrix_float_adder_verification_compilation
}

alias v08 {
  accelerator_matrix_float_multiplier_verification_compilation
}

alias v09 {
  accelerator_matrix_float_divider_verification_compilation
}

alias v10 {
  accelerator_tensor_float_adder_verification_compilation
}

alias v11 {
  accelerator_tensor_float_multiplier_verification_compilation
}

alias v12 {
  accelerator_tensor_float_divider_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-SCALAR-FLOAT-ADDER-TEST"
echo "v02 . ACCELERATOR-SCALAR-FLOAT-MULTIPLIER-TEST"
echo "v03 . ACCELERATOR-SCALAR-FLOAT-DIVIDER-TEST"
echo "v04 . ACCELERATOR-VECTOR-FLOAT-ADDER-TEST"
echo "v05 . ACCELERATOR-VECTOR-FLOAT-MULTIPLIER-TEST"
echo "v06 . ACCELERATOR-VECTOR-FLOAT-DIVIDER-TEST"
echo "v07 . ACCELERATOR-MATRIX-FLOAT-ADDER-TEST"
echo "v08 . ACCELERATOR-MATRIX-FLOAT-MULTIPLIER-TEST"
echo "v09 . ACCELERATOR-MATRIX-FLOAT-DIVIDER-TEST"
echo "v10 . ACCELERATOR-TENSOR-FLOAT-ADDER-TEST"
echo "v11 . ACCELERATOR-TENSOR-FLOAT-MULTIPLIER-TEST"
echo "v12 . ACCELERATOR-TENSOR-FLOAT-DIVIDER-TEST"
echo "****************************************"