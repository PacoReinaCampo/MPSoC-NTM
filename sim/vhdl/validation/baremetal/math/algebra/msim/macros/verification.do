#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_DOT_PRODUCT_TEST 
##################################################################################################

alias model_dot_product_verification_compilation {
  echo "TEST: NTM_DOT_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_DOT_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_dot_product wave
  do $simulation_path/math/algebra/msim/waves/model_dot_product.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_DOT_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_DOT_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_dot_product_test.wlf
}

##################################################################################################
# NTM_VECTOR_CONVOLUTION_TEST 
##################################################################################################

alias model_vector_convolution_verification_compilation {
  echo "TEST: NTM_VECTOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_vector_convolution wave
  do $simulation_path/math/algebra/msim/waves/model_vector_convolution.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_convolution_test.wlf
}

##################################################################################################
# NTM_VECTOR_COSINE_SIMILARITY_TEST 
##################################################################################################

alias model_vector_cosine_similarity_verification_compilation {
  echo "TEST: NTM_VECTOR_COSINE_SIMILARITY_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_vector_cosine_similarity wave
  do $simulation_path/math/algebra/msim/waves/model_vector_cosine_similarity.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_cosine_similarity_test.wlf
}

##################################################################################################
# NTM_VECTOR_MULTIPLICATION_TEST 
##################################################################################################

alias model_vector_multiplication_verification_compilation {
  echo "TEST: NTM_VECTOR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_vector_multiplication wave
  do $simulation_path/math/algebra/msim/waves/model_vector_multiplication.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_multiplication_test.wlf
}

##################################################################################################
# NTM_VECTOR_SUMMATION_TEST 
##################################################################################################

alias model_vector_summation_verification_compilation {
  echo "TEST: NTM_VECTOR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_vector_summation wave
  do $simulation_path/math/algebra/msim/waves/model_vector_summation.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_SUMMATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_summation_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULE_TEST 
##################################################################################################

alias model_vector_module_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_MODULE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_vector_module wave
  do $simulation_path/math/algebra/msim/waves/model_vector_module.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MODULE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MODULE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_vector_module_test.wlf
}

##################################################################################################
# NTM_MATRIX_CONVOLUTION_TEST 
##################################################################################################

alias model_matrix_convolution_verification_compilation {
  echo "TEST: NTM_MATRIX_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_matrix_convolution wave
  do $simulation_path/math/algebra/msim/waves/model_matrix_convolution.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_convolution_test.wlf
}

##################################################################################################
# NTM_MATRIX_INVERSE_TEST 
##################################################################################################

alias model_matrix_inverse_verification_compilation {
  echo "TEST: NTM_MATRIX_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_matrix_inverse wave
  do $simulation_path/math/algebra/msim/waves/model_matrix_inverse.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_INVERSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_inverse_test.wlf
}

##################################################################################################
# NTM_MATRIX_MULTIPLICATION_TEST 
##################################################################################################

alias model_matrix_multiplication_verification_compilation {
  echo "TEST: NTM_MATRIX_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_matrix_multiplication wave
  do $simulation_path/math/algebra/msim/waves/model_matrix_multiplication.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_multiplication_test.wlf
}

##################################################################################################
# NTM_MATRIX_PRODUCT_TEST 
##################################################################################################

alias model_matrix_product_verification_compilation {
  echo "TEST: NTM_MATRIX_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_matrix_product wave
  do $simulation_path/math/algebra/msim/waves/model_matrix_product.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_product_test.wlf
}

##################################################################################################
# NTM_MATRIX_SUMMATION_TEST 
##################################################################################################

alias model_matrix_summation_verification_compilation {
  echo "TEST: NTM_MATRIX_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_matrix_summation wave
  do $simulation_path/math/algebra/msim/waves/model_matrix_summation.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_SUMMATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_summation_test.wlf
}

##################################################################################################
# NTM_MATRIX_TRANSPOSE_TEST 
##################################################################################################

alias model_matrix_transpose_verification_compilation {
  echo "TEST: NTM_MATRIX_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_matrix_transpose wave
  do $simulation_path/math/algebra/msim/waves/model_matrix_transpose.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_matrix_transpose_test.wlf
}

##################################################################################################
# NTM_TENSOR_CONVOLUTION_TEST 
##################################################################################################

alias model_tensor_convolution_verification_compilation {
  echo "TEST: NTM_TENSOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_tensor_convolution wave
  do $simulation_path/math/algebra/msim/waves/model_tensor_convolution.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_convolution_test.wlf
}

##################################################################################################
# NTM_TENSOR_INVERSE_TEST 
##################################################################################################

alias model_tensor_inverse_verification_compilation {
  echo "TEST: NTM_TENSOR_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_tensor_inverse wave
  do $simulation_path/math/algebra/msim/waves/model_tensor_inverse.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_INVERSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_inverse_test.wlf
}

##################################################################################################
# NTM_TENSOR_PRODUCT_TEST 
##################################################################################################

alias model_tensor_product_verification_compilation {
  echo "TEST: NTM_TENSOR_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_tensor_product wave
  do $simulation_path/math/algebra/msim/waves/model_tensor_product.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_product_test.wlf
}

##################################################################################################
# NTM_TENSOR_TRANSPOSE_TEST 
##################################################################################################

alias model_tensor_transpose_verification_compilation {
  echo "TEST: NTM_TENSOR_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  #WAVES
  view -title model_tensor_transpose wave
  do $simulation_path/math/algebra/msim/waves/model_tensor_transpose.do

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_TRANSPOSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim model_tensor_transpose_test.wlf
}

##################################################################################################

alias v01 {
  model_dot_product_verification_compilation
}

alias v02 {
  model_vector_convolution_verification_compilation
}

alias v03 {
  model_vector_cosine_similarity_verification_compilation
}

alias v04 {
  model_vector_multiplication_verification_compilation
}

alias v05 {
  model_vector_summation_verification_compilation
}

alias v06 {
  model_vector_module_verification_compilation
}

alias v07 {
  model_matrix_convolution_verification_compilation
}

alias v08 {
  model_matrix_inverse_verification_compilation
}

alias v09 {
  model_matrix_multiplication_verification_compilation
}

alias v10 {
  model_matrix_product_verification_compilation
}

alias v11 {
  model_matrix_summation_verification_compilation
}

alias v12 {
  model_matrix_transpose_verification_compilation
}

alias v13 {
  model_tensor_convolution_verification_compilation
}

alias v14 {
  model_tensor_inverse_verification_compilation
}

alias v15 {
  model_tensor_product_verification_compilation
}

alias v16 {
  model_tensor_transpose_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-DOT-PRODUCT-TEST"
echo "v02 . ACCELERATOR-VECTOR-CONVOLUTION-TEST"
echo "v03 . ACCELERATOR-VECTOR-COSINE-SIMILARITY-TEST"
echo "v04 . ACCELERATOR-VECTOR-MULTIPLICATION-TEST"
echo "v05 . ACCELERATOR-VECTOR-SUMMATION-TEST"
echo "v06 . ACCELERATOR-VECTOR-MODULE-TEST"
echo "v07 . ACCELERATOR-MATRIX-CONVOLUTION-TEST"
echo "v08 . ACCELERATOR-MATRIX-INVERSE-TEST"
echo "v09 . ACCELERATOR-MATRIX-MULTIPLICATION-TEST"
echo "v10 . ACCELERATOR-MATRIX-PRODUCT-TEST"
echo "v11 . ACCELERATOR-MATRIX-SUMMATION-TEST"
echo "v12 . ACCELERATOR-MATRIX-TRANSPOSE-TEST"
echo "v13 . ACCELERATOR-TENSOR-CONVOLUTION-TEST"
echo "v14 . ACCELERATOR-TENSOR-INVERSE-TEST"
echo "v15 . ACCELERATOR-TENSOR-PRODUCT-TEST"
echo "v16 . ACCELERATOR-TENSOR-TRANSPOSE-TEST"
echo "****************************************"
