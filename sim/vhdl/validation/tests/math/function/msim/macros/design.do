#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# model_scalar_logistic_function_design_compilation ################################################
##################################################################################################

alias model_scalar_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
}

##################################################################################################
# model_scalar_oneplus_function_design_compilation #################################################
##################################################################################################

alias model_scalar_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd
}

##################################################################################################
# model_vector_logistic_function_design_compilation ################################################
##################################################################################################

alias model_vector_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_logistic_function.vhd
}

##################################################################################################
# model_vector_oneplus_function_design_compilation #################################################
##################################################################################################

alias model_vector_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_oneplus_function.vhd
}

##################################################################################################
# model_matrix_logistic_function_design_compilation ################################################
##################################################################################################

alias model_matrix_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_logistic_function.vhd
}

##################################################################################################
# model_matrix_oneplus_function_design_compilation #################################################
##################################################################################################

alias model_matrix_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_oneplus_function.vhd
}

##################################################################################################

alias d01 {
  model_scalar_logistic_function_design_compilation 
}

alias d02 {
  model_scalar_oneplus_function_design_compilation 
}

alias d03 {
  model_vector_logistic_function_design_compilation 
}

alias d04 {
  model_vector_oneplus_function_design_compilation 
}

alias d05 {
  model_matrix_logistic_function_design_compilation 
}

alias d06 {
  model_matrix_oneplus_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d03 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "d04 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "d05 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d06 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"