#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_SCALAR_PRODUCT_TEST 
##################################################################################################

alias ntm_scalar_product_verification_compilation {
  echo "TEST: NTM_SCALAR_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_SCALAR_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_scalar_product wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_scalar_product.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_SCALAR_PRODUCT_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_SCALAR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_scalar_product_test.wlf
}

##################################################################################################

alias v01 {
  ntm_scalar_product_verification_compilation
}

echo "************************************************************"
echo "v01 . NTM-SCALAR-PRODUCT-TEST"
echo "************************************************************"