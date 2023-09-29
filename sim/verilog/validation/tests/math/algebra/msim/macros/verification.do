#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_DOT_PRODUCT_TEST 
##################################################################################################

alias model_dot_product_verification_compilation {
  echo "TEST: NTM_DOT_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_DOT_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_DOT_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_DOT_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_dot_product_test.wlf
}

##################################################################################################
# NTM_VECTOR_CONVOLUTION_TEST 
##################################################################################################

alias model_vector_convolution_verification_compilation {
  echo "TEST: NTM_VECTOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_convolution_test.wlf
}

##################################################################################################
# NTM_VECTOR_COSINE_SIMILARITY_TEST 
##################################################################################################

alias model_vector_cosine_similarity_verification_compilation {
  echo "TEST: NTM_VECTOR_COSINE_SIMILARITY_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_COSINE_SIMILARITY_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_COSINE_SIMILARITY_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_cosine_similarity_test.wlf
}

##################################################################################################
# NTM_VECTOR_MULTIPLICATION_TEST 
##################################################################################################

alias model_vector_multiplication_verification_compilation {
  echo "TEST: NTM_VECTOR_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_multiplication_test.wlf
}

##################################################################################################
# NTM_VECTOR_SUMMATION_TEST 
##################################################################################################

alias model_vector_summation_verification_compilation {
  echo "TEST: NTM_VECTOR_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_SUMMATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_summation_test.wlf
}

##################################################################################################
# NTM_VECTOR_MODULE_TEST 
##################################################################################################

alias model_vector_module_verification_compilation {
  echo "TEST: NTM_VECTOR_MODULE_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_VECTOR_MODULE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MODULE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_VECTOR_MODULE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_module_test.wlf
}

##################################################################################################
# NTM_MATRIX_CONVOLUTION_TEST 
##################################################################################################

alias model_matrix_convolution_verification_compilation {
  echo "TEST: NTM_MATRIX_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_convolution_test.wlf
}

##################################################################################################
# NTM_MATRIX_VECTOR_CONVOLUTION_TEST 
##################################################################################################

alias model_matrix_vector_convolution_verification_compilation {
  echo "TEST: NTM_MATRIX_VECTOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_VECTOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_VECTOR_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_VECTOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_vector_convolution_test.wlf
}

##################################################################################################
# NTM_MATRIX_INVERSE_TEST 
##################################################################################################

alias model_matrix_inverse_verification_compilation {
  echo "TEST: NTM_MATRIX_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_INVERSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_inverse_test.wlf
}

##################################################################################################
# NTM_MATRIX_MULTIPLICATION_TEST 
##################################################################################################

alias model_matrix_multiplication_verification_compilation {
  echo "TEST: NTM_MATRIX_MULTIPLICATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_MULTIPLICATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_MULTIPLICATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_multiplication_test.wlf
}

##################################################################################################
# NTM_MATRIX_PRODUCT_TEST 
##################################################################################################

alias model_matrix_product_verification_compilation {
  echo "TEST: NTM_MATRIX_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_product_test.wlf
}

##################################################################################################
# NTM_MATRIX_VECTOR_PRODUCT_TEST 
##################################################################################################

alias model_matrix_vector_product_verification_compilation {
  echo "TEST: NTM_MATRIX_VECTOR_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_VECTOR_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_VECTOR_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_VECTOR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_vector_product_test.wlf
}

##################################################################################################
# NTM_MATRIX_SUMMATION_TEST 
##################################################################################################

alias model_matrix_summation_verification_compilation {
  echo "TEST: NTM_MATRIX_SUMMATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_SUMMATION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_SUMMATION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_SUMMATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_summation_test.wlf
}

##################################################################################################
# NTM_MATRIX_TRANSPOSE_TEST 
##################################################################################################

alias model_matrix_transpose_verification_compilation {
  echo "TEST: NTM_MATRIX_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_MATRIX_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_transpose_test.wlf
}

##################################################################################################
# NTM_TENSOR_CONVOLUTION_TEST 
##################################################################################################

alias model_tensor_convolution_verification_compilation {
  echo "TEST: NTM_TENSOR_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_convolution_test.wlf
}

##################################################################################################
# NTM_TENSOR_MATRIX_CONVOLUTION_TEST 
##################################################################################################

alias model_tensor_matrix_convolution_verification_compilation {
  echo "TEST: NTM_TENSOR_MATRIX_CONVOLUTION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_MATRIX_CONVOLUTION_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_MATRIX_CONVOLUTION_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_MATRIX_CONVOLUTION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_matrix_convolution_test.wlf
}

##################################################################################################
# NTM_TENSOR_INVERSE_TEST 
##################################################################################################

alias model_tensor_inverse_verification_compilation {
  echo "TEST: NTM_TENSOR_INVERSE_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_INVERSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_INVERSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_INVERSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_inverse_test.wlf
}

##################################################################################################
# NTM_TENSOR_PRODUCT_TEST 
##################################################################################################

alias model_tensor_product_verification_compilation {
  echo "TEST: NTM_TENSOR_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_product_test.wlf
}

##################################################################################################
# NTM_TENSOR_MATRIX_PRODUCT_TEST 
##################################################################################################

alias model_tensor_matrix_product_verification_compilation {
  echo "TEST: NTM_TENSOR_MATRIX_PRODUCT_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_MATRIX_PRODUCT_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_MATRIX_PRODUCT_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_MATRIX_PRODUCT_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_matrix_product_test.wlf
}

##################################################################################################
# NTM_TENSOR_TRANSPOSE_TEST 
##################################################################################################

alias model_tensor_transpose_verification_compilation {
  echo "TEST: NTM_TENSOR_TRANSPOSE_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/algebra/model_algebra_testbench.vhd

  vsim -g /model_algebra_testbench/ENABLE_NTM_TENSOR_TRANSPOSE_TEST=true -t ps +notimingchecks -L unisim work.model_algebra_testbench

  #MACROS
  add log -r sim:/model_algebra_testbench/*

  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_TRANSPOSE_TEST true 0
  force -freeze sim:/model_algebra_pkg/STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_transpose_test.wlf
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
  model_matrix_vector_convolution_verification_compilation
}

alias v09 {
  model_matrix_inverse_verification_compilation
}

alias v10 {
  model_matrix_multiplication_verification_compilation
}

alias v11 {
  model_matrix_product_verification_compilation
}

alias v12 {
  model_matrix_vector_product_verification_compilation
}

alias v13 {
  model_matrix_summation_verification_compilation
}

alias v14 {
  model_matrix_transpose_verification_compilation
}

alias v15 {
  model_tensor_convolution_verification_compilation
}

alias v16 {
  model_tensor_matrix_convolution_verification_compilation
}

alias v17 {
  model_tensor_inverse_verification_compilation
}

alias v18 {
  model_tensor_product_verification_compilation
}

alias v19 {
  model_tensor_matrix_product_verification_compilation
}

alias v20 {
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
echo "v08 . ACCELERATOR-MATRIX-VECTOR-CONVOLUTION-TEST"
echo "v09 . ACCELERATOR-MATRIX-INVERSE-TEST"
echo "v10 . ACCELERATOR-MATRIX-MULTIPLICATION-TEST"
echo "v11 . ACCELERATOR-MATRIX-PRODUCT-TEST"
echo "v12 . ACCELERATOR-MATRIX-VECTOR-PRODUCT-TEST"
echo "v13 . ACCELERATOR-MATRIX-SUMMATION-TEST"
echo "v14 . ACCELERATOR-MATRIX-TRANSPOSE-TEST"
echo "v15 . ACCELERATOR-TENSOR-CONVOLUTION-TEST"
echo "v16 . ACCELERATOR-TENSOR-MATRIX-CONVOLUTION-TEST"
echo "v17 . ACCELERATOR-TENSOR-INVERSE-TEST"
echo "v18 . ACCELERATOR-TENSOR-PRODUCT-TEST"
echo "v19 . ACCELERATOR-TENSOR-MATRIX-PRODUCT-TEST"
echo "v20 . ACCELERATOR-TENSOR-TRANSPOSE-TEST"
echo "****************************************"
