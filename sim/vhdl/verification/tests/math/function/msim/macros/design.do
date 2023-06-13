#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# accelerator_scalar_logistic_function_design_compilation ################################################
##################################################################################################

alias accelerator_scalar_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.vhd
}

##################################################################################################
# accelerator_scalar_oneplus_function_design_compilation #################################################
##################################################################################################

alias accelerator_scalar_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.vhd
}

##################################################################################################
# accelerator_vector_logistic_function_design_compilation ################################################
##################################################################################################

alias accelerator_vector_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_logistic_function.vhd
}

##################################################################################################
# accelerator_vector_oneplus_function_design_compilation #################################################
##################################################################################################

alias accelerator_vector_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_oneplus_function.vhd
}

##################################################################################################
# accelerator_matrix_logistic_function_design_compilation ################################################
##################################################################################################

alias accelerator_matrix_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_logistic_function.vhd
}

##################################################################################################
# accelerator_matrix_oneplus_function_design_compilation #################################################
##################################################################################################

alias accelerator_matrix_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_oneplus_function.vhd
}

##################################################################################################

alias d01 {
  accelerator_scalar_logistic_function_design_compilation 
}

alias d02 {
  accelerator_scalar_oneplus_function_design_compilation 
}

alias d03 {
  accelerator_vector_logistic_function_design_compilation 
}

alias d04 {
  accelerator_vector_oneplus_function_design_compilation 
}

alias d05 {
  accelerator_matrix_logistic_function_design_compilation 
}

alias d06 {
  accelerator_matrix_oneplus_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d03 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "d04 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "d05 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d06 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"