#*************************
# VERIFICATION
#*************************

# MODELSIM 10.4d

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_DOT_PRODUCT_TEST 
##################################################################################################

alias ntm_dot_product_verification_compilation {
  echo "TEST: NTM_DOT_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_DOT_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_dot_product wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_dot_product.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_DOT_PRODUCT_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_DOT_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_dot_product_test.wlf
}

##################################################################################################
# NTM_VECTOR_CONVOLUTION_TEST 
##################################################################################################

alias ntm_vector_convolution_verification_compilation {
  echo "TEST: NTM_VECTOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_VECTOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_vector_convolution wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_vector_convolution.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_convolution_test.wlf
}

##################################################################################################
# NTM_VECTOR_TRANSPOSE_TEST 
##################################################################################################

alias ntm_vector_transpose_verification_compilation {
  echo "TEST: NTM_VECTOR_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_VECTOR_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_vector_transpose wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_vector_transpose.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_TRANSPOSE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_transpose_test.wlf
}

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
# NTM_MATRIX_CONVOLUTION_TEST 
##################################################################################################

alias ntm_matrix_convolution_verification_compilation {
  echo "TEST: NTM_MATRIX_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_MATRIX_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_matrix_convolution wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_matrix_convolution.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_convolution_test.wlf
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
# NTM_TENSOR_CONVOLUTION_TEST 
##################################################################################################

alias ntm_tensor_convolution_verification_compilation {
  echo "TEST: NTM_TENSOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_TENSOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_tensor_convolution wave
  do $simulation_path/mpsoc/math/algebra/msim/waves/ntm_tensor_convolution.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_convolution_test.wlf
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

alias v01 {
  ntm_dot_product_verification_compilation
}

alias v02 {
  ntm_vector_convolution_verification_compilation
}

alias v03 {
  ntm_vector_transpose_verification_compilation
}

alias v04 {
  ntm_matrix_product_verification_compilation
}

alias v05 {
  ntm_matrix_convolution_verification_compilation
}

alias v06 {
  ntm_matrix_transpose_verification_compilation
}

alias v07 {
  ntm_tensor_product_verification_compilation
}

alias v08 {
  ntm_tensor_convolution_verification_compilation
}

alias v09 {
  ntm_tensor_transpose_verification_compilation
}

echo "****************************************"
echo "v01 . NTM-DOT-PRODUCT-TEST"
echo "v02 . NTM-VECTOR-CONVOLUTION-TEST"
echo "v03 . NTM-VECTOR-TRANSPOSE-TEST"
echo "v04 . NTM-MATRIX-PRODUCT-TEST"
echo "v05 . NTM-MATRIX-CONVOLUTION-TEST"
echo "v06 . NTM-MATRIX-TRANSPOSE-TEST"
echo "v07 . NTM-TENSOR-PRODUCT-TEST"
echo "v08 . NTM-TENSOR-CONVOLUTION-TEST"
echo "v09 . NTM-TENSOR-TRANSPOSE-TEST"
echo "****************************************"
