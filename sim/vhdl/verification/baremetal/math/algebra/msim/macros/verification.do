#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_DOT_PRODUCT_TEST 
##################################################################################################

alias accelerator_dot_product_verification_compilation {
  echo "TEST: ACCELERATOR_DOT_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_DOT_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_dot_product wave
  do $simulation_path/math/algebra/msim/waves/accelerator_dot_product.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_DOT_PRODUCT_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_DOT_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_dot_product_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_CONVOLUTION_TEST 
##################################################################################################

alias accelerator_vector_convolution_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_VECTOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_vector_convolution wave
  do $simulation_path/math/algebra/msim/waves/accelerator_vector_convolution.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_convolution_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_COSINE_SIMILARITY_TEST 
##################################################################################################

alias accelerator_vector_cosine_similarity_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_COSINE_SIMILARITY_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_VECTOR_COSINE_SIMILARITY_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_vector_cosine_similarity wave
  do $simulation_path/math/algebra/msim/waves/accelerator_vector_cosine_similarity.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_COSINE_SIMILARITY_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_COSINE_SIMILARITY_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_cosine_similarity_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_MULTIPLICATION_TEST 
##################################################################################################

alias accelerator_vector_multiplication_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_VECTOR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_vector_multiplication wave
  do $simulation_path/math/algebra/msim/waves/accelerator_vector_multiplication.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_MULTIPLICATION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_multiplication_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_SUMMATION_TEST 
##################################################################################################

alias accelerator_vector_summation_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_VECTOR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_vector_summation wave
  do $simulation_path/math/algebra/msim/waves/accelerator_vector_summation.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_SUMMATION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_summation_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_MODULE_TEST 
##################################################################################################

alias accelerator_vector_module_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_MODULE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_VECTOR_MODULE_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_vector_module wave
  do $simulation_path/math/algebra/msim/waves/accelerator_vector_module.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_MODULE_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_VECTOR_MODULE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_module_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_CONVOLUTION_TEST 
##################################################################################################

alias accelerator_matrix_convolution_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_MATRIX_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_matrix_convolution wave
  do $simulation_path/math/algebra/msim/waves/accelerator_matrix_convolution.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_convolution_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_INVERSE_TEST 
##################################################################################################

alias accelerator_matrix_inverse_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_MATRIX_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_matrix_inverse wave
  do $simulation_path/math/algebra/msim/waves/accelerator_matrix_inverse.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_INVERSE_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_inverse_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_MULTIPLICATION_TEST 
##################################################################################################

alias accelerator_matrix_multiplication_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_MATRIX_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_matrix_multiplication wave
  do $simulation_path/math/algebra/msim/waves/accelerator_matrix_multiplication.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_MULTIPLICATION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_multiplication_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_PRODUCT_TEST 
##################################################################################################

alias accelerator_matrix_product_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_MATRIX_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_matrix_product wave
  do $simulation_path/math/algebra/msim/waves/accelerator_matrix_product.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_PRODUCT_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_product_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_SUMMATION_TEST 
##################################################################################################

alias accelerator_matrix_summation_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_MATRIX_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_matrix_summation wave
  do $simulation_path/math/algebra/msim/waves/accelerator_matrix_summation.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_SUMMATION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_summation_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_TRANSPOSE_TEST 
##################################################################################################

alias accelerator_matrix_transpose_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_MATRIX_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_matrix_transpose wave
  do $simulation_path/math/algebra/msim/waves/accelerator_matrix_transpose.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_MATRIX_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_transpose_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_CONVOLUTION_TEST 
##################################################################################################

alias accelerator_tensor_convolution_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_TENSOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_tensor_convolution wave
  do $simulation_path/math/algebra/msim/waves/accelerator_tensor_convolution.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_CONVOLUTION_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_convolution_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_INVERSE_TEST 
##################################################################################################

alias accelerator_tensor_inverse_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_TENSOR_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_tensor_inverse wave
  do $simulation_path/math/algebra/msim/waves/accelerator_tensor_inverse.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_INVERSE_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_inverse_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_PRODUCT_TEST 
##################################################################################################

alias accelerator_tensor_product_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_TENSOR_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_tensor_product wave
  do $simulation_path/math/algebra/msim/waves/accelerator_tensor_product.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_PRODUCT_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_product_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_TRANSPOSE_TEST 
##################################################################################################

alias accelerator_tensor_transpose_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/accelerator_algebra_testbench.vhd

  vsim -g /accelerator_algebra_testbench/ENABLE_ACCELERATOR_TENSOR_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.accelerator_algebra_testbench

  #MACROS
  add log -r sim:/accelerator_algebra_testbench/*

  #WAVES
  view -title accelerator_tensor_transpose wave
  do $simulation_path/math/algebra/msim/waves/accelerator_tensor_transpose.do

  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_TEST true 0
  force -freeze sim:/accelerator_algebra_pkg/STIMULUS_ACCELERATOR_TENSOR_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_transpose_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_dot_product_verification_compilation
}

alias v02 {
  accelerator_vector_convolution_verification_compilation
}

alias v03 {
  accelerator_vector_cosine_similarity_verification_compilation
}

alias v04 {
  accelerator_vector_multiplication_verification_compilation
}

alias v05 {
  accelerator_vector_summation_verification_compilation
}

alias v06 {
  accelerator_vector_module_verification_compilation
}

alias v07 {
  accelerator_matrix_convolution_verification_compilation
}

alias v08 {
  accelerator_matrix_inverse_verification_compilation
}

alias v09 {
  accelerator_matrix_multiplication_verification_compilation
}

alias v10 {
  accelerator_matrix_product_verification_compilation
}

alias v11 {
  accelerator_matrix_summation_verification_compilation
}

alias v12 {
  accelerator_matrix_transpose_verification_compilation
}

alias v13 {
  accelerator_tensor_convolution_verification_compilation
}

alias v14 {
  accelerator_tensor_inverse_verification_compilation
}

alias v15 {
  accelerator_tensor_product_verification_compilation
}

alias v16 {
  accelerator_tensor_transpose_verification_compilation
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
