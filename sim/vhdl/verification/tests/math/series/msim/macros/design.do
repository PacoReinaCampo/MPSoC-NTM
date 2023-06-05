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
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_cosh_function.vhd
}

##################################################################################################
# ntm_scalar_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_scalar_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
}

##################################################################################################
# ntm_scalar_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
}

##################################################################################################
# ntm_scalar_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_sinh_function.vhd
}

##################################################################################################
# ntm_scalar_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_tanh_function.vhd
}

##################################################################################################
# ntm_vector_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_cosh_function.vhd
}

##################################################################################################
# ntm_vector_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_vector_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_exponentiator_function.vhd
}

##################################################################################################
# ntm_vector_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_vector_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_logarithm_function.vhd
}

##################################################################################################
# ntm_vector_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_sinh_function.vhd
}

##################################################################################################
# ntm_vector_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_tanh_function.vhd
}

##################################################################################################
# ntm_matrix_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/ntm_matrix_cosh_function.vhd
}

##################################################################################################
# ntm_matrix_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_matrix_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/ntm_matrix_exponentiator_function.vhd
}

##################################################################################################
# ntm_matrix_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_matrix_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/ntm_matrix_logarithm_function.vhd
}

##################################################################################################
# ntm_matrix_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/ntm_matrix_sinh_function.vhd
}

##################################################################################################
# ntm_matrix_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/ntm_vector_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/ntm_matrix_tanh_function.vhd
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
  ntm_scalar_sinh_function_design_compilation 
}

alias d05 {
  ntm_scalar_tanh_function_design_compilation 
}

alias d06 {
  ntm_vector_cosh_function_design_compilation 
}

alias d07 {
  ntm_vector_exponentiator_function_design_compilation 
}

alias d08 {
  ntm_vector_logarithm_function_design_compilation 
}

alias d09 {
  ntm_vector_sinh_function_design_compilation 
}

alias d10 {
  ntm_vector_tanh_function_design_compilation 
}

alias d11 {
  ntm_matrix_cosh_function_design_compilation 
}

alias d12 {
  ntm_matrix_exponentiator_function_design_compilation 
}

alias d13 {
  ntm_matrix_logarithm_function_design_compilation 
}

alias d14 {
  ntm_matrix_sinh_function_design_compilation 
}

alias d15 {
  ntm_matrix_tanh_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-EXPONENTIATOR-FUNCTION-TEST"
echo "d03 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "d04 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "d05 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "d06 . NTM-VECTOR-COSH-FUNCTION-TEST"
echo "d07 . NTM-VECTOR-EXPONENTIATOR-FUNCTION-TEST"
echo "d08 . NTM-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "d09 . NTM-VECTOR-SINH-FUNCTION-TEST"
echo "d10 . NTM-VECTOR-TANH-FUNCTION-TEST"
echo "d11 . NTM-MATRIX-COSH-FUNCTION-TEST"
echo "d12 . NTM-MATRIX-EXPONENTIATOR-FUNCTION-TEST"
echo "d13 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d14 . NTM-MATRIX-SINH-FUNCTION-TEST"
echo "d15 . NTM-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"