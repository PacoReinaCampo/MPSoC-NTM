#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

###################################################################################################
# TEST SOURCES ####################################################################################
###################################################################################################

vlib work
vmap work work

#################################################################################
# NTM_SCALAR_MOD_TEST 
#################################################################################

alias ntm_scalar_mod_verification_compilation {
  echo "TEST: NTM_SCALAR_MOD_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/vectors/vhdl/math/arithmetic/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/vectors/vhdl/math/arithmetic/ntm_arithmetic_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/vectors/vhdl/math/arithmetic/ntm_arithmetic_testbench.vhd

  vsim -g /ntm_arithmetic_testbench/C_GCM_MULTIPLIER_TEST=true -t ps +notimingchecks -L unisim work.ntm_arithmetic_testbench

  #MACROS
  add log -r sim:/ntm_arithmetic_testbench/*

  #WAVES
  view -title ntm_scalar_mod wave
  do $verification_path/waves/ntm_scalar_mod.do

  force -freeze sim:/ntm_arithmetic_pkg/STIMULUS_NTM_SCALAR_MOD_TEST true 0
  force -freeze sim:/ntm_arithmetic_pkg/STIMULUS_NTM_SCALAR_MOD_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_mod_test.wlf
}

#################################################################################

alias v1 {
  ntm_scalar_mod_verification_compilation
}

echo "************************************************************"
echo "v1  . NTM-SCALAR-MOD-TEST"
echo "************************************************************"