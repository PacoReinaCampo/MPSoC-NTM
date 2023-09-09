#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_VECTOR_DIFFERENTIATION_TEST 
##################################################################################################

alias accelerator_vector_differentiation_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_VECTOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_vector_differentiation wave
  do $simulation_path/math/calculus/msim/waves/accelerator_vector_differentiation.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_differentiation_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_INTEGRATION_TEST 
##################################################################################################

alias accelerator_vector_integration_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_VECTOR_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_vector_integration wave
  do $simulation_path/math/calculus/msim/waves/accelerator_vector_integration.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_integration_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_SOFTMAX_TEST 
##################################################################################################

alias accelerator_vector_softmax_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_VECTOR_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_vector_softmax wave
  do $simulation_path/math/calculus/msim/waves/accelerator_vector_softmax.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_VECTOR_SOFTMAX_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_VECTOR_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_vector_softmax_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_DIFFERENTIATION_TEST 
##################################################################################################

alias accelerator_matrix_differentiation_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_MATRIX_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_matrix_differentiation wave
  do $simulation_path/math/calculus/msim/waves/accelerator_matrix_differentiation.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_differentiation_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_INTEGRATION_TEST 
##################################################################################################

alias accelerator_matrix_integration_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_MATRIX_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_matrix_integration wave
  do $simulation_path/math/calculus/msim/waves/accelerator_matrix_integration.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_integration_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_SOFTMAX_TEST 
##################################################################################################

alias accelerator_matrix_softmax_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_MATRIX_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_matrix_softmax wave
  do $simulation_path/math/calculus/msim/waves/accelerator_matrix_softmax.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_MATRIX_SOFTMAX_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_MATRIX_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_matrix_softmax_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_DIFFERENTIATION_TEST 
##################################################################################################

alias accelerator_tensor_differentiation_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_DIFFERENTIATION_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_TENSOR_DIFFERENTIATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_tensor_differentiation wave
  do $simulation_path/math/calculus/msim/waves/accelerator_tensor_differentiation.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_differentiation_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_INTEGRATION_TEST 
##################################################################################################

alias accelerator_tensor_integration_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_INTEGRATION_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_TENSOR_INTEGRATION_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_tensor_integration wave
  do $simulation_path/math/calculus/msim/waves/accelerator_tensor_integration.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_integration_test.wlf
}

##################################################################################################
# ACCELERATOR_TENSOR_SOFTMAX_TEST 
##################################################################################################

alias accelerator_tensor_softmax_verification_compilation {
  echo "TEST: ACCELERATOR_TENSOR_SOFTMAX_TEST"

  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $model_pkg_path/model_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_pkg_path/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/calculus/accelerator_calculus_testbench.vhd

  vsim -g /accelerator_calculus_testbench/ENABLE_ACCELERATOR_TENSOR_SOFTMAX_TEST=true -t ps +notimingchecks -L unisim work.accelerator_calculus_testbench

  #MACROS
  add log -r sim:/accelerator_calculus_testbench/*

  #WAVES
  view -title accelerator_tensor_softmax wave
  do $simulation_path/math/calculus/msim/waves/accelerator_tensor_softmax.do

  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_TENSOR_SOFTMAX_TEST true 0
  force -freeze sim:/accelerator_calculus_pkg/STIMULUS_ACCELERATOR_TENSOR_SOFTMAX_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_tensor_softmax_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_vector_differentiation_verification_compilation
}

alias v02 {
  accelerator_vector_integration_verification_compilation
}

alias v03 {
  accelerator_vector_softmax_verification_compilation
}

alias v04 {
  accelerator_matrix_differentiation_verification_compilation
}

alias v05 {
  accelerator_matrix_integration_verification_compilation
}

alias v06 {
  accelerator_matrix_softmax_verification_compilation
}

alias v07 {
  accelerator_tensor_differentiation_verification_compilation
}

alias v08 {
  accelerator_tensor_integration_verification_compilation
}

alias v09 {
  accelerator_tensor_softmax_verification_compilation
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
