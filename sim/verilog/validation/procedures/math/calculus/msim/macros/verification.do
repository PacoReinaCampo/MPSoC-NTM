#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# NTM_VECTOR_DIFFERENTIATION_TEST 
##################################################################################################

alias model_vector_differentiation_verification_compilation {
  echo "TEST: NTM_VECTOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_VECTOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_VECTOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_differentiation_test.wlf
}

##################################################################################################
# NTM_VECTOR_INTEGRATION_TEST 
##################################################################################################

alias model_vector_integration_verification_compilation {
  echo "TEST: NTM_VECTOR_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_VECTOR_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_VECTOR_INTEGRATION_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_VECTOR_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_integration_test.wlf
}

##################################################################################################
# NTM_VECTOR_SOFTMAX_TEST 
##################################################################################################

alias model_vector_softmax_verification_compilation {
  echo "TEST: NTM_VECTOR_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_VECTOR_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_VECTOR_SOFTMAX_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_VECTOR_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_softmax_test.wlf
}

##################################################################################################
# NTM_MATRIX_DIFFERENTIATION_TEST 
##################################################################################################

alias model_matrix_differentiation_verification_compilation {
  echo "TEST: NTM_MATRIX_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_MATRIX_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_MATRIX_DIFFERENTIATION_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_differentiation_test.wlf
}

##################################################################################################
# NTM_MATRIX_INTEGRATION_TEST 
##################################################################################################

alias model_matrix_integration_verification_compilation {
  echo "TEST: NTM_MATRIX_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_MATRIX_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_MATRIX_INTEGRATION_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_MATRIX_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_integration_test.wlf
}

##################################################################################################
# NTM_MATRIX_SOFTMAX_TEST 
##################################################################################################

alias model_matrix_softmax_verification_compilation {
  echo "TEST: NTM_MATRIX_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_MATRIX_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_MATRIX_SOFTMAX_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_MATRIX_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_softmax_test.wlf
}

##################################################################################################
# NTM_TENSOR_DIFFERENTIATION_TEST 
##################################################################################################

alias model_tensor_differentiation_verification_compilation {
  echo "TEST: NTM_TENSOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_TENSOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_TENSOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_TENSOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_differentiation_test.wlf
}

##################################################################################################
# NTM_TENSOR_INTEGRATION_TEST 
##################################################################################################

alias model_tensor_integration_verification_compilation {
  echo "TEST: NTM_TENSOR_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_TENSOR_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_TENSOR_INTEGRATION_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_TENSOR_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_integration_test.wlf
}

##################################################################################################
# NTM_TENSOR_SOFTMAX_TEST 
##################################################################################################

alias model_tensor_softmax_verification_compilation {
  echo "TEST: NTM_TENSOR_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $design_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/model_calculus_testbench.vhd

  vsim -g /model_calculus_testbench/ENABLE_NTM_TENSOR_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.model_calculus_testbench

  #MACROS
  add log -r sim:/model_calculus_testbench/*

  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_TENSOR_SOFTMAX_TEST true 0
  force -freeze sim:/model_calculus_pkg/STIMULUS_NTM_TENSOR_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_tensor_softmax_test.wlf
}

##################################################################################################

alias v01 {
  model_vector_differentiation_verification_compilation
}

alias v02 {
  model_vector_integration_verification_compilation
}

alias v03 {
  model_vector_softmax_verification_compilation
}

alias v04 {
  model_matrix_differentiation_verification_compilation
}

alias v05 {
  model_matrix_integration_verification_compilation
}

alias v06 {
  model_matrix_softmax_verification_compilation
}

alias v07 {
  model_tensor_differentiation_verification_compilation
}

alias v08 {
  model_tensor_integration_verification_compilation
}

alias v09 {
  model_tensor_softmax_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-VECTOR-DIFFERENTIATION-TEST"
echo "v02 . ACCELERATOR-VECTOR-INTEGRATION-TEST"
echo "v03 . ACCELERATOR-VECTOR-SOFTMAX-TEST"
echo "v04 . ACCELERATOR-MATRIX-DIFFERENTIATION-TEST"
echo "v05 . ACCELERATOR-MATRIX-INTEGRATION-TEST"
echo "v06 . ACCELERATOR-MATRIX-SOFTMAX-TEST"
echo "v07 . ACCELERATOR-TENSOR-DIFFERENTIATION-TEST"
echo "v08 . ACCELERATOR-TENSOR-INTEGRATION-TEST"
echo "v09 . ACCELERATOR-TENSOR-SOFTMAX-TEST"
echo "****************************************"
