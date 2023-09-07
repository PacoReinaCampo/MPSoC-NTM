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

alias model_scalar_float_adder_verification_compilation {
  echo "TEST: NTM_SCALAR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_SCALAR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_scalar_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/model_scalar_float_adder.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_float_adder_test.wlf
}

##################################################################################################
# NTM_SCALAR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias model_scalar_float_multiplier_verification_compilation {
  echo "TEST: NTM_SCALAR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_SCALAR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_scalar_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/model_scalar_float_multiplier.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_float_multiplier_test.wlf
}

##################################################################################################
# NTM_SCALAR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias model_scalar_float_divider_verification_compilation {
  echo "TEST: NTM_SCALAR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_SCALAR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_scalar_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/model_scalar_float_divider.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_SCALAR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_float_divider_test.wlf
}

##################################################################################################
# NTM_VECTOR_FLOAT_ADDER_TEST 
##################################################################################################

alias model_vector_float_adder_verification_compilation {
  echo "TEST: NTM_VECTOR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_VECTOR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_vector_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/model_vector_float_adder.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_float_adder_test.wlf
}

##################################################################################################
# NTM_VECTOR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias model_vector_float_multiplier_verification_compilation {
  echo "TEST: NTM_VECTOR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_VECTOR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_vector_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/model_vector_float_multiplier.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_float_multiplier_test.wlf
}

##################################################################################################
# NTM_VECTOR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias model_vector_float_divider_verification_compilation {
  echo "TEST: NTM_VECTOR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_VECTOR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_vector_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/model_vector_float_divider.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_VECTOR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_float_divider_test.wlf
}

##################################################################################################
# NTM_MATRIX_FLOAT_ADDER_TEST 
##################################################################################################

alias model_matrix_float_adder_verification_compilation {
  echo "TEST: NTM_MATRIX_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_MATRIX_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_matrix_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/model_matrix_float_adder.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_ADDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_float_adder_test.wlf
}

##################################################################################################
# NTM_MATRIX_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias model_matrix_float_multiplier_verification_compilation {
  echo "TEST: NTM_MATRIX_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_MATRIX_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_matrix_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/model_matrix_float_multiplier.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_float_multiplier_test.wlf
}

##################################################################################################
# NTM_MATRIX_FLOAT_DIVIDER_TEST 
##################################################################################################

alias model_matrix_float_divider_verification_compilation {
  echo "TEST: NTM_MATRIX_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_MATRIX_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_matrix_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/model_matrix_float_divider.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_MATRIX_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_float_divider_test.wlf
}

##################################################################################################
# NTM_TENSOR_FLOAT_ADDER_TEST 
##################################################################################################

alias model_tensor_float_adder_verification_compilation {
  echo "TEST: NTM_TENSOR_FLOAT_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_TENSOR_FLOAT_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_tensor_float_adder wave
  do $simulation_path/arithmetic/float/msim/waves/model_tensor_float_adder.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_TENSOR_FLOAT_ADDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_TENSOR_FLOAT_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_float_adder_test.wlf
}

##################################################################################################
# NTM_TENSOR_FLOAT_MULTIPLIER_TEST 
##################################################################################################

alias model_tensor_float_multiplier_verification_compilation {
  echo "TEST: NTM_TENSOR_FLOAT_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_TENSOR_FLOAT_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_tensor_float_multiplier wave
  do $simulation_path/arithmetic/float/msim/waves/model_tensor_float_multiplier.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_TENSOR_FLOAT_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_float_multiplier_test.wlf
}

##################################################################################################
# NTM_TENSOR_FLOAT_DIVIDER_TEST 
##################################################################################################

alias model_tensor_float_divider_verification_compilation {
  echo "TEST: NTM_TENSOR_FLOAT_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/float/model_float_testbench.vhd

  vsim -g /model_float_testbench/ENABLE_NTM_TENSOR_FLOAT_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.model_float_testbench

  #MACROS
  add log -r sim:/model_float_testbench/*

  #WAVES
  view -title model_tensor_float_divider wave
  do $simulation_path/arithmetic/float/msim/waves/model_tensor_float_divider.do

  force -freeze sim:/model_float_pkg/STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_TEST true 0
  force -freeze sim:/model_float_pkg/STIMULUS_NTM_TENSOR_FLOAT_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_float_divider_test.wlf
}

##################################################################################################

alias v01 {
  model_scalar_float_adder_verification_compilation
}

alias v02 {
  model_scalar_float_multiplier_verification_compilation
}

alias v03 {
  model_scalar_float_divider_verification_compilation
}

alias v04 {
  model_vector_float_adder_verification_compilation
}

alias v05 {
  model_vector_float_multiplier_verification_compilation
}

alias v06 {
  model_vector_float_divider_verification_compilation
}

alias v07 {
  model_matrix_float_adder_verification_compilation
}

alias v08 {
  model_matrix_float_multiplier_verification_compilation
}

alias v09 {
  model_matrix_float_divider_verification_compilation
}

alias v10 {
  model_tensor_float_adder_verification_compilation
}

alias v11 {
  model_tensor_float_multiplier_verification_compilation
}

alias v12 {
  model_tensor_float_divider_verification_compilation
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
