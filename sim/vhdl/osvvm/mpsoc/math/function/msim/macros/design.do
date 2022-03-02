#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_scalar_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
}

##################################################################################################
# ntm_scalar_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_scalar_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
}

##################################################################################################
# ntm_vector_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_vector_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
}

##################################################################################################
# ntm_vector_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_vector_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
}

##################################################################################################
# ntm_matrix_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_matrix_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_logistic_function.vhd
}

##################################################################################################
# ntm_matrix_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_matrix_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_oneplus_function.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_logistic_function_design_compilation 
}

alias d02 {
  ntm_scalar_oneplus_function_design_compilation 
}

alias d03 {
  ntm_vector_logistic_function_design_compilation 
}

alias d04 {
  ntm_vector_oneplus_function_design_compilation 
}

alias d05 {
  ntm_matrix_logistic_function_design_compilation 
}

alias d06 {
  ntm_matrix_oneplus_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d03 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "d04 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "d05 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d06 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"