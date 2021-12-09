#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_MOD_TEST 
##################################################################################################

alias ntm_scalar_mod_verification_compilation {
  echo "TEST: NTM_SCALAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/arithmetic/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/arithmetic/ntm_arithmetic_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/arithmetic/ntm_arithmetic_testbench.vhd

  vsim -g /ntm_arithmetic_testbench/ENABLE_NTM_SCALAR_MOD_TEST=true -t ps +notimingchecks -L unisim work.ntm_arithmetic_testbench

  #MACROS
  add log -r sim:/ntm_arithmetic_testbench/*

  #WAVES
  view -title ntm_scalar_mod wave
  do $simulation_path/mpsoc/math/arithmetic/msim/waves/ntm_scalar_mod.do

  force -freeze sim:/ntm_arithmetic_pkg/STIMULUS_NTM_SCALAR_MOD_TEST true 0
  force -freeze sim:/ntm_arithmetic_pkg/STIMULUS_NTM_SCALAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_mod_test.wlf
}

##################################################################################################

alias v1 {
  ntm_scalar_mod_verification_compilation
}

echo "************************************************************"
echo "v01 . NTM-SCALAR-MOD-TEST"
echo "************************************************************"