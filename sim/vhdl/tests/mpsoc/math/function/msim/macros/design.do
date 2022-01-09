#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_convolution_function_design_compilation #############################################
##################################################################################################

alias ntm_scalar_convolution_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_convolution_function.vhd
}

##################################################################################################
# ntm_scalar_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
}

##################################################################################################
# ntm_scalar_cosine_similarity_function_design_compilation #######################################
##################################################################################################

alias ntm_scalar_cosine_similarity_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_scalar_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosine_similarity_function.vhd
}

##################################################################################################
# ntm_scalar_differentiation_function_design_compilation #########################################
##################################################################################################

alias ntm_scalar_differentiation_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_differentiation_function.vhd
}

##################################################################################################
# ntm_scalar_exponentiator_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
}

##################################################################################################
# ntm_scalar_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
}

##################################################################################################
# ntm_scalar_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_scalar_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
}

##################################################################################################
# ntm_scalar_multiplication_function_design_compilation ##########################################
##################################################################################################

alias ntm_scalar_multiplication_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_multiplication_function.vhd
}

##################################################################################################
# ntm_scalar_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_scalar_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
}

##################################################################################################
# ntm_scalar_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
}

##################################################################################################
# ntm_scalar_softmax_function_design_compilation #################################################
##################################################################################################

alias ntm_scalar_softmax_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_softmax_function.vhd
}

##################################################################################################
# ntm_scalar_summation_function_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_summation_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_summation_function.vhd
}

##################################################################################################
# ntm_scalar_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_convolution_function_design_compilation 
}

alias d02 {
  ntm_scalar_cosh_function_design_compilation 
}

alias d03 {
  ntm_scalar_cosine_similarity_function_design_compilation 
}

alias d04 {
  ntm_scalar_differentiation_function_design_compilation 
}

alias d05 {
  ntm_scalar_exponentiator_design_compilation 
}

alias d06 {
  ntm_scalar_logarithm_function_design_compilation 
}

alias d07 {
  ntm_scalar_logistic_function_design_compilation 
}

alias d08 {
  ntm_scalar_multiplication_function_design_compilation 
}

alias d09 {
  ntm_scalar_oneplus_function_design_compilation 
}

alias d10 {
  ntm_scalar_sinh_function_design_compilation 
}

alias d11 {
  ntm_scalar_softmax_function_design_compilation 
}

alias d12 {
  ntm_scalar_summation_function_design_compilation 
}

alias d13 {
  ntm_scalar_tanh_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-CONVOLUTION-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "d03 . NTM-SCALAR-COSINE_SIMILARITY-FUNCTION-TEST"
echo "d04 . NTM-SCALAR-DIFFERENTIATION-FUNCTION-TEST"
echo "d05 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "d06 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "d07 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d08 . NTM-SCALAR-MULTIPLICATION-FUNCTION-TEST"
echo "d09 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d10 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "d11 . NTM-SCALAR-SOFTMAX-FUNCTION-TEST"
echo "d12 . NTM-SCALAR-SUMMATION-FUNCTION-TEST"
echo "d13 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "****************************************"