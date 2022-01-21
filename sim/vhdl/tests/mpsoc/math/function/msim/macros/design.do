#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
}

##################################################################################################
# ntm_scalar_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_scalar_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
}

##################################################################################################
# ntm_scalar_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
}

##################################################################################################
# ntm_scalar_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_scalar_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
}

##################################################################################################
# ntm_scalar_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_scalar_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
}

##################################################################################################
# ntm_scalar_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
}

##################################################################################################
# ntm_scalar_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
}

##################################################################################################
# ntm_vector_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_cosh_function.vhd
}

##################################################################################################
# ntm_vector_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_vector_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_exponentiator_function.vhd
}

##################################################################################################
# ntm_vector_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_vector_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logarithm_function.vhd
}

##################################################################################################
# ntm_vector_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_vector_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
}

##################################################################################################
# ntm_vector_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_vector_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
}

##################################################################################################
# ntm_vector_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_sinh_function.vhd
}

##################################################################################################
# ntm_vector_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_tanh_function.vhd
}

##################################################################################################
# ntm_matrix_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_cosh_function.vhd
}

##################################################################################################
# ntm_matrix_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_matrix_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_exponentiator_function.vhd
}

##################################################################################################
# ntm_matrix_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_matrix_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_logarithm_function.vhd
}

##################################################################################################
# ntm_matrix_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_matrix_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
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
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_oneplus_function.vhd
}

##################################################################################################
# ntm_matrix_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_sinh_function.vhd
}

##################################################################################################
# ntm_matrix_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_tanh_function.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_cosh_function_design_compilation 
}

alias d02 {
  ntm_scalar_exponentiator_function_design_compilation 
}

alias d03 {
  ntm_scalar_logarithm_function_design_compilation 
}

alias d04 {
  ntm_scalar_logistic_function_design_compilation 
}

alias d05 {
  ntm_scalar_oneplus_function_design_compilation 
}

alias d06 {
  ntm_scalar_sinh_function_design_compilation 
}

alias d07 {
  ntm_scalar_tanh_function_design_compilation 
}

alias d08 {
  ntm_vector_cosh_function_design_compilation 
}

alias d09 {
  ntm_vector_exponentiator_function_design_compilation 
}

alias d10 {
  ntm_vector_logarithm_function_design_compilation 
}

alias d11 {
  ntm_vector_logistic_function_design_compilation 
}

alias d12 {
  ntm_vector_oneplus_function_design_compilation 
}

alias d13 {
  ntm_vector_sinh_function_design_compilation 
}

alias d14 {
  ntm_vector_tanh_function_design_compilation 
}

alias d15 {
  ntm_matrix_cosh_function_design_compilation 
}

alias d16 {
  ntm_matrix_exponentiator_function_design_compilation 
}

alias d17 {
  ntm_matrix_logarithm_function_design_compilation 
}

alias d18 {
  ntm_matrix_logistic_function_design_compilation 
}

alias d19 {
  ntm_matrix_oneplus_function_design_compilation 
}

alias d20 {
  ntm_matrix_sinh_function_design_compilation 
}

alias d21 {
  ntm_matrix_tanh_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-EXPONENTIATOR-FUNCTION-TEST"
echo "d03 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "d04 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d05 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d06 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "d07 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "d08 . NTM-VECTOR-COSH-FUNCTION-TEST"
echo "d09 . NTM-VECTOR-EXPONENTIATOR-FUNCTION-TEST"
echo "d10 . NTM-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "d11 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "d12 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "d13 . NTM-VECTOR-SINH-FUNCTION-TEST"
echo "d14 . NTM-VECTOR-TANH-FUNCTION-TEST"
echo "d15 . NTM-MATRIX-COSH-FUNCTION-TEST"
echo "d16 . NTM-MATRIX-EXPONENTIATOR-FUNCTION-TEST"
echo "d17 . NTM-MATRIX-LOGARITHM-FUNCTION-TEST"
echo "d18 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d19 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "d20 . NTM-MATRIX-SINH-FUNCTION-TEST"
echo "d21 . NTM-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"