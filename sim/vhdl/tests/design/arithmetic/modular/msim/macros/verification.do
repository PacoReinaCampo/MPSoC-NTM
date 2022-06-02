#*************************
# VERIFICATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_MODULAR_MOD_TEST 
##################################################################################################

alias model_scalar_modular_mod_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_scalar_modular_mod wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_scalar_modular_mod.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_modular_mod_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_ADDER_TEST 
##################################################################################################

alias model_scalar_modular_adder_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_scalar_modular_adder wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_scalar_modular_adder.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_modular_adder_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias model_scalar_modular_multiplier_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_scalar_modular_multiplier wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_scalar_modular_multiplier.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_INVERTER_TEST 
##################################################################################################

alias model_scalar_modular_inverter_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_scalar_modular_inverter wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_scalar_modular_inverter.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_scalar_modular_inverter_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_MOD_TEST 
##################################################################################################

alias model_vector_modular_mod_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_vector_modular_mod wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_vector_modular_mod.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_modular_mod_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_ADDER_TEST 
##################################################################################################

alias model_vector_modular_adder_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_vector_modular_adder wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_vector_modular_adder.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_modular_adder_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias model_vector_modular_multiplier_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_vector_modular_multiplier wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_vector_modular_multiplier.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_INVERTER_TEST 
##################################################################################################

alias model_vector_modular_inverter_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_vector_modular_inverter wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_vector_modular_inverter.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_modular_inverter_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_MOD_TEST 
##################################################################################################

alias model_matrix_modular_mod_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_matrix_modular_mod wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_matrix_modular_mod.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_modular_mod_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_ADDER_TEST 
##################################################################################################

alias model_matrix_modular_adder_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_matrix_modular_adder wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_matrix_modular_adder.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_modular_adder_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias model_matrix_modular_multiplier_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_matrix_modular_multiplier wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_matrix_modular_multiplier.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_INVERTER_TEST 
##################################################################################################

alias model_matrix_modular_inverter_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_matrix_modular_inverter wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_matrix_modular_inverter.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_modular_inverter_test.wlf
}

##################################################################################################
# NTM_TENSOR_MODULAR_MOD_TEST 
##################################################################################################

alias model_tensor_modular_mod_verification_compilation {
  echo "TEST: NTM_TENSOR_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_TENSOR_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_tensor_modular_mod wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_tensor_modular_mod.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_MOD_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_modular_mod_test.wlf
}

##################################################################################################
# NTM_TENSOR_MODULAR_ADDER_TEST 
##################################################################################################

alias model_tensor_modular_adder_verification_compilation {
  echo "TEST: NTM_TENSOR_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_TENSOR_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_tensor_modular_adder wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_tensor_modular_adder.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_ADDER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_modular_adder_test.wlf
}

##################################################################################################
# NTM_TENSOR_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias model_tensor_modular_multiplier_verification_compilation {
  echo "TEST: NTM_TENSOR_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_TENSOR_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_tensor_modular_multiplier wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_tensor_modular_multiplier.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_TENSOR_MODULAR_INVERTER_TEST 
##################################################################################################

alias model_tensor_modular_inverter_verification_compilation {
  echo "TEST: NTM_TENSOR_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/arithmetic/modular/model_modular_testbench.vhd

  vsim -g /model_modular_testbench/ENABLE_NTM_TENSOR_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.model_modular_testbench

  #MACROS
  add log -r sim:/model_modular_testbench/*

  #WAVES
  view -title model_tensor_modular_inverter wave
  do $simulation_path/model/arithmetic/modular/msim/waves/model_tensor_modular_inverter.do

  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/model_modular_pkg/STIMULUS_NTM_TENSOR_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_modular_inverter_test.wlf
}

##################################################################################################

alias v01 {
  model_scalar_modular_mod_verification_compilation
}

alias v02 {
  model_scalar_modular_adder_verification_compilation 
}

alias v03 {
  model_scalar_modular_multiplier_verification_compilation 
}

alias v04 {
  model_scalar_modular_inverter_verification_compilation 
}

alias v05 {
  model_vector_modular_mod_verification_compilation
}

alias v06 {
  model_vector_modular_adder_verification_compilation 
}

alias v07 {
  model_vector_modular_multiplier_verification_compilation 
}

alias v08 {
  model_vector_modular_inverter_verification_compilation 
}

alias v09 {
  model_matrix_modular_mod_verification_compilation
}

alias v10 {
  model_matrix_modular_adder_verification_compilation 
}

alias v11 {
  model_matrix_modular_multiplier_verification_compilation 
}

alias v12 {
  model_matrix_modular_inverter_verification_compilation 
}

alias v13 {
  model_tensor_modular_mod_verification_compilation
}

alias v14 {
  model_tensor_modular_adder_verification_compilation 
}

alias v15 {
  model_tensor_modular_multiplier_verification_compilation 
}

alias v16 {
  model_tensor_modular_inverter_verification_compilation 
}

echo "************************************************************"
echo "v01 . NTM-SCALAR-MOD-TEST"
echo "v02 . NTM-SCALAR-ADDER-TEST"
echo "v03 . NTM-SCALAR-MULTIPLIER-TEST"
echo "v04 . NTM-SCALAR-INVERTER-TEST"
echo "v05 . NTM-VECTOR-MOD-TEST"
echo "v06 . NTM-VECTOR-ADDER-TEST"
echo "v07 . NTM-VECTOR-MULTIPLIER-TEST"
echo "v08 . NTM-VECTOR-INVERTER-TEST"
echo "v09 . NTM-MATRIX-MOD-TEST"
echo "v10 . NTM-MATRIX-ADDER-TEST"
echo "v11 . NTM-MATRIX-MULTIPLIER-TEST"
echo "v12 . NTM-MATRIX-INVERTER-TEST"
echo "v13 . NTM-TENSOR-MOD-TEST"
echo "v14 . NTM-TENSOR-ADDER-TEST"
echo "v15 . NTM-TENSOR-MULTIPLIER-TEST"
echo "v16 . NTM-TENSOR-INVERTER-TEST"
echo "************************************************************"