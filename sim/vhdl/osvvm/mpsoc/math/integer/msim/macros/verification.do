#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_MODULAR_MOD_TEST 
##################################################################################################

alias ntm_scalar_modular_mod_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_scalar_modular_mod wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_scalar_modular_mod.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_modular_mod_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_ADDER_TEST 
##################################################################################################

alias ntm_scalar_modular_adder_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_scalar_modular_adder wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_scalar_modular_adder.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_modular_adder_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias ntm_scalar_modular_multiplier_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_scalar_modular_multiplier wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_scalar_modular_multiplier.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_INVERTER_TEST 
##################################################################################################

alias ntm_scalar_modular_inverter_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_scalar_modular_inverter wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_scalar_modular_inverter.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_modular_inverter_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_DIVIDER_TEST 
##################################################################################################

alias ntm_scalar_modular_divider_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_scalar_modular_divider wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_scalar_modular_divider.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_DIVIDER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_modular_divider_test.wlf
}

##################################################################################################
# NTM_SCALAR_MODULAR_EXPONENTIATOR_TEST 
##################################################################################################

alias ntm_scalar_modular_exponentiator_verification_compilation {
  echo "TEST: NTM_SCALAR_MODULAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_SCALAR_MODULAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_scalar_modular_exponentiator wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_scalar_modular_exponentiator.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_SCALAR_MODULAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_modular_exponentiator_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_MOD_TEST 
##################################################################################################

alias ntm_vector_modular_mod_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_vector_modular_mod wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_vector_modular_mod.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_modular_mod_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_ADDER_TEST 
##################################################################################################

alias ntm_vector_modular_adder_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_vector_modular_adder wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_vector_modular_adder.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_modular_adder_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias ntm_vector_modular_multiplier_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_vector_modular_multiplier wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_vector_modular_multiplier.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_INVERTER_TEST 
##################################################################################################

alias ntm_vector_modular_inverter_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_vector_modular_inverter wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_vector_modular_inverter.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_modular_inverter_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_DIVIDER_TEST 
##################################################################################################

alias ntm_vector_modular_divider_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_vector_modular_divider wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_vector_modular_divider.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_DIVIDER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_modular_divider_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULAR_EXPONENTIATOR_TEST 
##################################################################################################

alias ntm_vector_modular_exponentiator_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_VECTOR_MODULAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_vector_modular_exponentiator wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_vector_modular_exponentiator.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_VECTOR_MODULAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_modular_exponentiator_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_MOD_TEST 
##################################################################################################

alias ntm_matrix_modular_mod_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_matrix_modular_mod wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_matrix_modular_mod.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_modular_mod_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_ADDER_TEST 
##################################################################################################

alias ntm_matrix_modular_adder_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_ADDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_ADDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_matrix_modular_adder wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_matrix_modular_adder.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_modular_adder_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_MULTIPLIER_TEST 
##################################################################################################

alias ntm_matrix_modular_multiplier_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_MULTIPLIER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_matrix_modular_multiplier wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_matrix_modular_multiplier.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_modular_multiplier_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_INVERTER_TEST 
##################################################################################################

alias ntm_matrix_modular_inverter_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_INVERTER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_INVERTER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_matrix_modular_inverter wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_matrix_modular_inverter.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_modular_inverter_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_DIVIDER_TEST 
##################################################################################################

alias ntm_matrix_modular_divider_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_DIVIDER_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_DIVIDER_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_matrix_modular_divider wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_matrix_modular_divider.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_DIVIDER_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_DIVIDER_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_modular_divider_test.wlf
}

##################################################################################################
# NTM_MATRIX_MODULAR_EXPONENTIATOR_TEST 
##################################################################################################

alias ntm_matrix_modular_exponentiator_verification_compilation {
  echo "TEST: NTM_MATRIX_MODULAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/modular/ntm_modular_testbench.vhd

  vsim -g /ntm_modular_testbench/ENABLE_NTM_MATRIX_MODULAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.ntm_modular_testbench

  #MACROS
  add log -r sim:/ntm_modular_testbench/*

  #WAVES
  view -title ntm_matrix_modular_exponentiator wave
  do $simulation_path/mpsoc/math/modular/msim/waves/ntm_matrix_modular_exponentiator.do

  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/ntm_modular_pkg/STIMULUS_NTM_MATRIX_MODULAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_modular_exponentiator_test.wlf
}


##################################################################################################

alias v01 {
  ntm_scalar_modular_mod_verification_compilation
}

alias v02 {
  ntm_scalar_modular_adder_verification_compilation 
}

alias v03 {
  ntm_scalar_modular_multiplier_verification_compilation 
}

alias v04 {
  ntm_scalar_modular_inverter_verification_compilation 
}

alias v05 {
  ntm_scalar_modular_divider_verification_compilation 
}

alias v06 {
  ntm_scalar_modular_exponentiator_verification_compilation 
}

alias v07 {
  ntm_vector_modular_mod_verification_compilation
}

alias v08 {
  ntm_vector_modular_adder_verification_compilation 
}

alias v09 {
  ntm_vector_modular_multiplier_verification_compilation 
}

alias v10 {
  ntm_vector_modular_inverter_verification_compilation 
}

alias v11 {
  ntm_vector_modular_divider_verification_compilation 
}

alias v12 {
  ntm_vector_modular_exponentiator_verification_compilation 
}

alias v13 {
  ntm_matrix_modular_mod_verification_compilation
}

alias v14 {
  ntm_matrix_modular_adder_verification_compilation 
}

alias v15 {
  ntm_matrix_modular_multiplier_verification_compilation 
}

alias v16 {
  ntm_matrix_modular_inverter_verification_compilation 
}

alias v17 {
  ntm_matrix_modular_divider_verification_compilation 
}

alias v18 {
  ntm_matrix_modular_exponentiator_verification_compilation 
}

echo "************************************************************"
echo "v01 . NTM-SCALAR-MOD-TEST"
echo "v02 . NTM-SCALAR-ADDER-TEST"
echo "v03 . NTM-SCALAR-MULTIPLIER-TEST"
echo "v04 . NTM-SCALAR-INVERTER-TEST"
echo "v05 . NTM-SCALAR-DIVIDER-TEST"
echo "v06 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "v07 . NTM-VECTOR-MOD-TEST"
echo "v08 . NTM-VECTOR-ADDER-TEST"
echo "v09 . NTM-VECTOR-MULTIPLIER-TEST"
echo "v10 . NTM-VECTOR-INVERTER-TEST"
echo "v11 . NTM-VECTOR-DIVIDER-TEST"
echo "v12 . NTM-VECTOR-EXPONENTIATOR-TEST"
echo "v13 . NTM-MATRIX-MOD-TEST"
echo "v14 . NTM-MATRIX-ADDER-TEST"
echo "v15 . NTM-MATRIX-MULTIPLIER-TEST"
echo "v16 . NTM-MATRIX-INVERTER-TEST"
echo "v17 . NTM-MATRIX-DIVIDER-TEST"
echo "v18 . NTM-MATRIX-EXPONENTIATOR-TEST"
echo "************************************************************"