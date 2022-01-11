#*************************
# VERIFICATION COMPILATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_MATRIX_PRODUCT_TEST 
##################################################################################################

alias ntm_matrix_product_verification_compilation {
  echo "TEST: NTM_MATRIX_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_MATRIX_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_matrix_product wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_matrix_product.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_product_test.wlf
}

##################################################################################################
# NTM_MATRIX_TRANSPOSE_TEST 
##################################################################################################

alias ntm_matrix_transpose_verification_compilation {
  echo "TEST: NTM_MATRIX_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_MATRIX_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_matrix_transpose wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_matrix_transpose.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_transpose_test.wlf
}

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
# NTM_TENSOR_TRANSPOSE_TEST 
##################################################################################################

alias ntm_tensor_transpose_verification_compilation {
  echo "TEST: NTM_TENSOR_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_TENSOR_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_tensor_transpose wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_tensor_transpose.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_TRANSPOSE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_transpose_test.wlf
}

##################################################################################################
# NTM_TENSOR_PRODUCT_TEST 
##################################################################################################

alias ntm_tensor_product_verification_compilation {
  echo "TEST: NTM_TENSOR_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_TENSOR_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_tensor_product wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_tensor_product.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_product_test.wlf
}

##################################################################################################

alias v01 {
  ntm_matrix_product_verification_compilation
}

alias v02 {
  ntm_matrix_transpose_verification_compilation
}

alias v03 {
  ntm_scalar_product_verification_compilation
}

alias v04 {
  ntm_tensor_product_verification_compilation
}

alias v05 {
  ntm_tensor_transpose_verification_compilation
}

echo "****************************************"
echo "v01 . NTM-MATRIX-PRODUCT-TEST"
echo "v02 . NTM-MATRIX-TRANSPOSE-TEST"
echo "v03 . NTM-SCALAR-PRODUCT-TEST"
echo "v04 . NTM-TENSOR-PRODUCT-TEST"
echo "v05 . NTM-TENSOR-TRANSPOSE-TEST"
echo "****************************************"