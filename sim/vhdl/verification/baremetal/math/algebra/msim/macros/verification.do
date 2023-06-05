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
  do $simulation_path/math/algebra/msim/waves/ntm_dot_product.do

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
  do $simulation_path/math/algebra/msim/waves/ntm_vector_convolution.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_convolution_test.wlf
}

##################################################################################################
# NTM_VECTOR_COSINE_SIMILARITY_TEST 
##################################################################################################

alias ntm_vector_cosine_similarity_verification_compilation {
  echo "TEST: NTM_VECTOR_COSINE_SIMILARITY_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_vector_cosine_similarity wave
  do $simulation_path/math/algebra/msim/waves/ntm_vector_cosine_similarity.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_cosine_similarity_test.wlf
}

##################################################################################################
# NTM_VECTOR_MULTIPLICATION_TEST 
##################################################################################################

alias ntm_vector_multiplication_verification_compilation {
  echo "TEST: NTM_VECTOR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_VECTOR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_vector_multiplication wave
  do $simulation_path/math/algebra/msim/waves/ntm_vector_multiplication.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_multiplication_test.wlf
}

##################################################################################################
# NTM_VECTOR_SUMMATION_TEST 
##################################################################################################

alias ntm_vector_summation_verification_compilation {
  echo "TEST: NTM_VECTOR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_VECTOR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_vector_summation wave
  do $simulation_path/math/algebra/msim/waves/ntm_vector_summation.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_SUMMATION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_summation_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULE_TEST 
##################################################################################################

alias ntm_vector_module_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_VECTOR_MODULE_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_vector_module wave
  do $simulation_path/math/algebra/msim/waves/ntm_vector_module.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_MODULE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_VECTOR_MODULE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_vector_module_test.wlf
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
  do $simulation_path/math/algebra/msim/waves/ntm_matrix_convolution.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_convolution_test.wlf
}

##################################################################################################
# NTM_MATRIX_INVERSE_TEST 
##################################################################################################

alias ntm_matrix_inverse_verification_compilation {
  echo "TEST: NTM_MATRIX_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_MATRIX_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_matrix_inverse wave
  do $simulation_path/math/algebra/msim/waves/ntm_matrix_inverse.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_INVERSE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_inverse_test.wlf
}

##################################################################################################
# NTM_MATRIX_MULTIPLICATION_TEST 
##################################################################################################

alias ntm_matrix_multiplication_verification_compilation {
  echo "TEST: NTM_MATRIX_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_MATRIX_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_matrix_multiplication wave
  do $simulation_path/math/algebra/msim/waves/ntm_matrix_multiplication.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_multiplication_test.wlf
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
  do $simulation_path/math/algebra/msim/waves/ntm_matrix_product.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_product_test.wlf
}

##################################################################################################
# NTM_MATRIX_SUMMATION_TEST 
##################################################################################################

alias ntm_matrix_summation_verification_compilation {
  echo "TEST: NTM_MATRIX_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_MATRIX_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_matrix_summation wave
  do $simulation_path/math/algebra/msim/waves/ntm_matrix_summation.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_SUMMATION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_summation_test.wlf
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
  do $simulation_path/math/algebra/msim/waves/ntm_matrix_transpose.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_matrix_transpose_test.wlf
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
  do $simulation_path/math/algebra/msim/waves/ntm_tensor_convolution.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_convolution_test.wlf
}

##################################################################################################
# NTM_TENSOR_INVERSE_TEST 
##################################################################################################

alias ntm_tensor_inverse_verification_compilation {
  echo "TEST: NTM_TENSOR_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_TENSOR_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_tensor_inverse wave
  do $simulation_path/math/algebra/msim/waves/ntm_tensor_inverse.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_INVERSE_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_inverse_test.wlf
}

##################################################################################################
# NTM_TENSOR_MULTIPLICATION_TEST 
##################################################################################################

alias ntm_tensor_multiplication_verification_compilation {
  echo "TEST: NTM_TENSOR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_TENSOR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_tensor_multiplication wave
  do $simulation_path/math/algebra/msim/waves/ntm_tensor_multiplication.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_MULTIPLICATION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_multiplication_test.wlf
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
  do $simulation_path/math/algebra/msim/waves/ntm_tensor_product.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_product_test.wlf
}

##################################################################################################
# NTM_TENSOR_SUMMATION_TEST 
##################################################################################################

alias ntm_tensor_summation_verification_compilation {
  echo "TEST: NTM_TENSOR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/ntm_algebra_testbench.vhd

  vsim -g /ntm_algebra_testbench/ENABLE_NTM_TENSOR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.ntm_algebra_testbench

  #MACROS
  add log -r sim:/ntm_algebra_testbench/*

  #WAVES
  view -title ntm_tensor_summation wave
  do $simulation_path/math/algebra/msim/waves/ntm_tensor_summation.do

  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_SUMMATION_TEST true 0
  force -freeze sim:/ntm_algebra_pkg/STIMULUS_NTM_TENSOR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim ntm_tensor_summation_test.wlf
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
  do $simulation_path/math/algebra/msim/waves/ntm_tensor_transpose.do

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
  ntm_vector_cosine_similarity_verification_compilation
}

alias v04 {
  ntm_vector_multiplication_verification_compilation
}

alias v05 {
  ntm_vector_summation_verification_compilation
}

alias v06 {
  ntm_vector_module_verification_compilation
}

alias v07 {
  ntm_matrix_convolution_verification_compilation
}

alias v08 {
  ntm_matrix_inverse_verification_compilation
}

alias v09 {
  ntm_matrix_multiplication_verification_compilation
}

alias v10 {
  ntm_matrix_product_verification_compilation
}

alias v11 {
  ntm_matrix_summation_verification_compilation
}

alias v12 {
  ntm_matrix_transpose_verification_compilation
}

alias v13 {
  ntm_tensor_convolution_verification_compilation
}

alias v14 {
  ntm_tensor_inverse_verification_compilation
}

alias v15 {
  ntm_tensor_multiplication_verification_compilation
}

alias v16 {
  ntm_tensor_product_verification_compilation
}

alias v17 {
  ntm_tensor_summation_verification_compilation
}

alias v18 {
  ntm_tensor_transpose_verification_compilation
}

echo "****************************************"
echo "v01 . NTM-DOT-PRODUCT-TEST"
echo "v02 . NTM-VECTOR-CONVOLUTION-TEST"
echo "v03 . NTM-VECTOR-COSINE-SIMILARITY-TEST"
echo "v04 . NTM-VECTOR-MULTIPLICATION-TEST"
echo "v05 . NTM-VECTOR-SUMMATION-TEST"
echo "v06 . NTM-VECTOR-MODULE-TEST"
echo "v07 . NTM-MATRIX-CONVOLUTION-TEST"
echo "v08 . NTM-MATRIX-INVERSE-TEST"
echo "v09 . NTM-MATRIX-MULTIPLICATION-TEST"
echo "v10 . NTM-MATRIX-PRODUCT-TEST"
echo "v11 . NTM-MATRIX-SUMMATION-TEST"
echo "v12 . NTM-MATRIX-TRANSPOSE-TEST"
echo "v13 . NTM-TENSOR-CONVOLUTION-TEST"
echo "v14 . NTM-TENSOR-INVERSE-TEST"
echo "v15 . NTM-TENSOR-MULTIPLICATION-TEST"
echo "v16 . NTM-TENSOR-PRODUCT-TEST"
echo "v17 . NTM-TENSOR-SUMMATION-TEST"
echo "v18 . NTM-TENSOR-TRANSPOSE-TEST"
echo "****************************************"