#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_SCALAR_FIXED_ADDER_TEST 
##################################################################################################

alias accelerator_scalar_fixed_adder_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_FIXED_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_SCALAR_FIXED_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_scalar_fixed_adder wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_scalar_fixed_adder.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_fixed_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_FIXED_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_scalar_fixed_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_FIXED_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_scalar_fixed_multiplier wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_scalar_fixed_multiplier.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_fixed_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_FIXED_DIVIDER_TEST 
##################################################################################################

alias accelerator_scalar_fixed_divider_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_FIXED_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_SCALAR_FIXED_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_scalar_fixed_divider wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_scalar_fixed_divider.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_scalar_fixed_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_FIXED_ADDER_TEST 
##################################################################################################

alias accelerator_vector_fixed_adder_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_FIXED_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_VECTOR_FIXED_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_vector_fixed_adder wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_vector_fixed_adder.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_fixed_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_FIXED_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_vector_fixed_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_FIXED_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_vector_fixed_multiplier wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_vector_fixed_multiplier.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_fixed_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_FIXED_DIVIDER_TEST 
##################################################################################################

alias accelerator_vector_fixed_divider_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_FIXED_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_VECTOR_FIXED_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_vector_fixed_divider wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_vector_fixed_divider.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_fixed_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_FIXED_ADDER_TEST 
##################################################################################################

alias accelerator_matrix_fixed_adder_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_FIXED_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_MATRIX_FIXED_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_matrix_fixed_adder wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_matrix_fixed_adder.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_fixed_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_FIXED_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_matrix_fixed_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_FIXED_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_matrix_fixed_multiplier wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_matrix_fixed_multiplier.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_fixed_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_FIXED_DIVIDER_TEST 
##################################################################################################

alias accelerator_matrix_fixed_divider_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_FIXED_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_MATRIX_FIXED_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_matrix_fixed_divider wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_matrix_fixed_divider.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_fixed_divider_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_FIXED_ADDER_TEST 
##################################################################################################

alias accelerator_tensor_fixed_adder_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_FIXED_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_TENSOR_FIXED_ADDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_tensor_fixed_adder wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_tensor_fixed_adder.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_fixed_adder_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_FIXED_MULTIPLIER_TEST 
##################################################################################################

alias accelerator_tensor_fixed_multiplier_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_FIXED_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_tensor_fixed_multiplier wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_tensor_fixed_multiplier.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_fixed_multiplier_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_FIXED_DIVIDER_TEST 
##################################################################################################

alias accelerator_tensor_fixed_divider_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_FIXED_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/fixed/accelerator_fixed_testbench.vhd

  vsim -g /accelerator_fixed_testbench/ENABLE_ACCELERATOR_TENSOR_FIXED_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.accelerator_fixed_testbench

  #MACROS
  add log -r sim:/accelerator_fixed_testbench/*

  #WAVES
  view -title accelerator_tensor_fixed_divider wave
  do $simulation_path/arithmetic/fixed/msim/waves/accelerator_tensor_fixed_divider.do

  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_TEST true 0
  force -freeze sim:/accelerator_fixed_pkg/STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_fixed_divider_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_scalar_fixed_adder_verification_compilation
}

alias v02 {
  accelerator_scalar_fixed_multiplier_verification_compilation
}

alias v03 {
  accelerator_scalar_fixed_divider_verification_compilation
}

alias v04 {
  accelerator_vector_fixed_adder_verification_compilation
}

alias v05 {
  accelerator_vector_fixed_multiplier_verification_compilation
}

alias v06 {
  accelerator_vector_fixed_divider_verification_compilation
}

alias v07 {
  accelerator_matrix_fixed_adder_verification_compilation
}

alias v08 {
  accelerator_matrix_fixed_multiplier_verification_compilation
}

alias v09 {
  accelerator_matrix_fixed_divider_verification_compilation
}

alias v10 {
  accelerator_tensor_fixed_adder_verification_compilation
}

alias v11 {
  accelerator_tensor_fixed_multiplier_verification_compilation
}

alias v12 {
  accelerator_tensor_fixed_divider_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-SCALAR-FIXED-ADDER-TEST"
echo "v02 . ACCELERATOR-SCALAR-FIXED-MULTIPLIER-TEST"
echo "v03 . ACCELERATOR-SCALAR-FIXED-DIVIDER-TEST"
echo "v04 . ACCELERATOR-VECTOR-FIXED-ADDER-TEST"
echo "v05 . ACCELERATOR-VECTOR-FIXED-MULTIPLIER-TEST"
echo "v06 . ACCELERATOR-VECTOR-FIXED-DIVIDER-TEST"
echo "v07 . ACCELERATOR-MATRIX-FIXED-ADDER-TEST"
echo "v08 . ACCELERATOR-MATRIX-FIXED-MULTIPLIER-TEST"
echo "v09 . ACCELERATOR-MATRIX-FIXED-DIVIDER-TEST"
echo "v10 . ACCELERATOR-TENSOR-FIXED-ADDER-TEST"
echo "v11 . ACCELERATOR-TENSOR-FIXED-MULTIPLIER-TEST"
echo "v12 . ACCELERATOR-TENSOR-FIXED-DIVIDER-TEST"
echo "****************************************"
