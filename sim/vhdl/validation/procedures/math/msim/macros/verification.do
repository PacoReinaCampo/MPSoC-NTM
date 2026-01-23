#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_SCALAR_COSH_FUNCTION_TEST 
##################################################################################################

alias model_scalar_cosh_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_SCALAR_COSH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_COSH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_cosh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias model_scalar_exponentiator_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_SCALAR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_exponentiator_function_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias model_scalar_logarithm_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_SCALAR_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_logarithm_function_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_SINH_FUNCTION_TEST 
##################################################################################################

alias model_scalar_sinh_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_SCALAR_SINH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_SINH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_sinh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_SCALAR_TANH_FUNCTION_TEST 
##################################################################################################

alias model_scalar_tanh_function_verification_compilation {
  echo "TEST: ACCELERATOR_SCALAR_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_SCALAR_TANH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_TANH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_SCALAR_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_scalar_tanh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_COSH_FUNCTION_TEST 
##################################################################################################

alias model_vector_cosh_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_VECTOR_COSH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_COSH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_cosh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias model_vector_exponentiator_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_VECTOR_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_exponentiator_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias model_vector_logarithm_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_VECTOR_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_logarithm_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_SINH_FUNCTION_TEST 
##################################################################################################

alias model_vector_sinh_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_VECTOR_SINH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_SINH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_sinh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_VECTOR_TANH_FUNCTION_TEST 
##################################################################################################

alias model_vector_tanh_function_verification_compilation {
  echo "TEST: ACCELERATOR_VECTOR_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_VECTOR_TANH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_TANH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_VECTOR_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_vector_tanh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_COSH_FUNCTION_TEST 
##################################################################################################

alias model_matrix_cosh_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_COSH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_MATRIX_COSH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_COSH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_COSH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_cosh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_EXPONENTIATOR_FUNCTION_TEST 
##################################################################################################

alias model_matrix_exponentiator_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_EXPONENTIATOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_MATRIX_EXPONENTIATOR_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_EXPONENTIATOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_exponentiator_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_LOGARITHM_FUNCTION_TEST 
##################################################################################################

alias model_matrix_logarithm_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_LOGARITHM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_MATRIX_LOGARITHM_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_LOGARITHM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_logarithm_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_SINH_FUNCTION_TEST 
##################################################################################################

alias model_matrix_sinh_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_SINH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_MATRIX_SINH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_SINH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_SINH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_sinh_function_test.wlf
}

##################################################################################################
# ACCELERATOR_MATRIX_TANH_FUNCTION_TEST 
##################################################################################################

alias model_matrix_tanh_function_verification_compilation {
  echo "TEST: ACCELERATOR_MATRIX_TANH_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/math/series/model_series_testbench.vhd

  vsim -g /model_series_testbench/ENABLE_ACCELERATOR_MATRIX_TANH_TEST=true -t ps +notimingchecks -L unisim work.model_series_testbench

  #MACROS
  add log -r sim:/model_series_testbench/*

  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_TANH_TEST true 0
  force -freeze sim:/model_series_pkg/STIMULUS_ACCELERATOR_MATRIX_TANH_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/model_matrix_tanh_function_test.wlf
}

##################################################################################################

alias v01 {
  model_scalar_cosh_function_verification_compilation 
}

alias v02 {
  model_scalar_exponentiator_function_verification_compilation 
}

alias v03 {
  model_scalar_logarithm_function_verification_compilation 
}

alias v04 {
  model_scalar_sinh_function_verification_compilation 
}

alias v05 {
  model_scalar_tanh_function_verification_compilation 
}

alias v06 {
  model_vector_cosh_function_verification_compilation 
}

alias v07 {
  model_vector_exponentiator_function_verification_compilation 
}

alias v08 {
  model_vector_logarithm_function_verification_compilation 
}

alias v09 {
  model_vector_sinh_function_verification_compilation 
}

alias v10 {
  model_vector_tanh_function_verification_compilation 
}

alias v11 {
  model_matrix_cosh_function_verification_compilation 
}

alias v12 {
  model_matrix_exponentiator_function_verification_compilation 
}

alias v13 {
  model_matrix_logarithm_function_verification_compilation 
}

alias v14 {
  model_matrix_sinh_function_verification_compilation 
}

alias v15 {
  model_matrix_tanh_function_verification_compilation 
}

echo "****************************************"
echo "v01 . ACCELERATOR-SCALAR-COSH-FUNCTION-TEST"
echo "v02 . ACCELERATOR-SCALAR-EXPONENTIATOR-FUNCTION-TEST"
echo "v03 . ACCELERATOR-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "v04 . ACCELERATOR-SCALAR-SINH-FUNCTION-TEST"
echo "v05 . ACCELERATOR-SCALAR-TANH-FUNCTION-TEST"
echo "v06 . ACCELERATOR-VECTOR-COSH-FUNCTION-TEST"
echo "v07 . ACCELERATOR-VECTOR-EXPONENTIATOR-FUNCTION-TEST"
echo "v08 . ACCELERATOR-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "v09 . ACCELERATOR-VECTOR-SINH-FUNCTION-TEST"
echo "v10 . ACCELERATOR-VECTOR-TANH-FUNCTION-TEST"
echo "v11 . ACCELERATOR-MATRIX-COSH-FUNCTION-TEST"
echo "v12 . ACCELERATOR-MATRIX-EXPONENTIATOR-FUNCTION-TEST"
echo "v13 . ACCELERATOR-MATRIX-LOGARITHM-FUNCTION-TEST"
echo "v14 . ACCELERATOR-MATRIX-SINH-FUNCTION-TEST"
echo "v15 . ACCELERATOR-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"