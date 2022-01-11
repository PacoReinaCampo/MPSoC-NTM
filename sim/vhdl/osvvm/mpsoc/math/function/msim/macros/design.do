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
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
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
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
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
# ntm_scalar_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_scalar_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
}

##################################################################################################
# ntm_scalar_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
}

##################################################################################################
# ntm_scalar_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_scalar_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
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
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
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
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
}

##################################################################################################
# ntm_scalar_softmax_function_design_compilation #################################################
##################################################################################################

alias ntm_scalar_softmax_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
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
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
}

##################################################################################################
# ntm_vector_convolution_function_design_compilation #############################################
##################################################################################################

alias ntm_vector_convolution_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_convolution_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_convolution_function.vhd
}

##################################################################################################
# ntm_vector_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_cosh_function.vhd
}

##################################################################################################
# ntm_vector_cosine_similarity_function_design_compilation #######################################
##################################################################################################

alias ntm_vector_cosine_similarity_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_vector_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosine_similarity_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_cosine_similarity_function.vhd
}

##################################################################################################
# ntm_vector_differentiation_function_design_compilation #########################################
##################################################################################################

alias ntm_vector_differentiation_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_differentiation_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_differentiation_function.vhd
}

##################################################################################################
# ntm_vector_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_vector_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_exponentiator_function.vhd
}

##################################################################################################
# ntm_vector_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_vector_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logarithm_function.vhd
}

##################################################################################################
# ntm_vector_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_vector_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
}

##################################################################################################
# ntm_vector_multiplication_function_design_compilation ##########################################
##################################################################################################

alias ntm_vector_multiplication_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_multiplication_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_multiplication_function.vhd
}

##################################################################################################
# ntm_vector_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_vector_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
}

##################################################################################################
# ntm_vector_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_sinh_function.vhd
}

##################################################################################################
# ntm_vector_softmax_function_design_compilation #################################################
##################################################################################################

alias ntm_vector_softmax_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_softmax_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_softmax_function.vhd
}

##################################################################################################
# ntm_vector_summation_function_design_compilation ###############################################
##################################################################################################

alias ntm_vector_summation_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_summation_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_summation_function.vhd
}

##################################################################################################
# ntm_vector_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_vector_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_tanh_function.vhd
}

##################################################################################################
# ntm_matrix_convolution_function_design_compilation #############################################
##################################################################################################

alias ntm_matrix_convolution_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_convolution_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_convolution_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_convolution_function.vhd
}

##################################################################################################
# ntm_matrix_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_cosh_function.vhd
}

##################################################################################################
# ntm_matrix_cosine_similarity_function_design_compilation #######################################
##################################################################################################

alias ntm_matrix_cosine_similarity_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_vector_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosine_similarity_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_cosine_similarity_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_cosine_similarity_function.vhd
}

##################################################################################################
# ntm_matrix_differentiation_function_design_compilation #########################################
##################################################################################################

alias ntm_matrix_differentiation_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_differentiation_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_differentiation_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_differentiation_function.vhd
}

##################################################################################################
# ntm_matrix_exponentiator_function_design_compilation ###########################################
##################################################################################################

alias ntm_matrix_exponentiator_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_exponentiator_function.vhd
}

##################################################################################################
# ntm_matrix_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_matrix_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_logarithm_function.vhd
}

##################################################################################################
# ntm_matrix_logistic_function_design_compilation ################################################
##################################################################################################

alias ntm_matrix_logistic_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_logistic_function.vhd
}

##################################################################################################
# ntm_matrix_multiplication_function_design_compilation ##########################################
##################################################################################################

alias ntm_matrix_multiplication_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_multiplication_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_multiplication_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_multiplication_function.vhd
}

##################################################################################################
# ntm_matrix_oneplus_function_design_compilation #################################################
##################################################################################################

alias ntm_matrix_oneplus_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_oneplus_function.vhd
}

##################################################################################################
# ntm_matrix_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_sinh_function.vhd
}

##################################################################################################
# ntm_matrix_softmax_function_design_compilation #################################################
##################################################################################################

alias ntm_matrix_softmax_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_softmax_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_softmax_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_softmax_function.vhd
}

##################################################################################################
# ntm_matrix_summation_function_design_compilation ###############################################
##################################################################################################

alias ntm_matrix_summation_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_summation_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_summation_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_summation_function.vhd
}

##################################################################################################
# ntm_matrix_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_tanh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/ntm_matrix_tanh_function.vhd
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
  ntm_scalar_exponentiator_function_design_compilation 
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

alias d14 {
  ntm_vector_convolution_function_design_compilation 
}

alias d15 {
  ntm_vector_cosh_function_design_compilation 
}

alias d16 {
  ntm_vector_cosine_similarity_function_design_compilation 
}

alias d17 {
  ntm_vector_differentiation_function_design_compilation 
}

alias d18 {
  ntm_vector_exponentiator_function_design_compilation 
}

alias d19 {
  ntm_vector_logarithm_function_design_compilation 
}

alias d20 {
  ntm_vector_logistic_function_design_compilation 
}

alias d21 {
  ntm_vector_multiplication_function_design_compilation 
}

alias d22 {
  ntm_vector_oneplus_function_design_compilation 
}

alias d23 {
  ntm_vector_sinh_function_design_compilation 
}

alias d24 {
  ntm_vector_softmax_function_design_compilation 
}

alias d25 {
  ntm_vector_summation_function_design_compilation 
}

alias d26 {
  ntm_vector_tanh_function_design_compilation 
}

alias d27 {
  ntm_matrix_convolution_function_design_compilation 
}

alias d28 {
  ntm_matrix_cosh_function_design_compilation 
}

alias d29 {
  ntm_matrix_cosine_similarity_function_design_compilation 
}

alias d30 {
  ntm_matrix_differentiation_function_design_compilation 
}

alias d31 {
  ntm_matrix_exponentiator_function_design_compilation 
}

alias d32 {
  ntm_matrix_logarithm_function_design_compilation 
}

alias d33 {
  ntm_matrix_logistic_function_design_compilation 
}

alias d34 {
  ntm_matrix_multiplication_function_design_compilation 
}

alias d35 {
  ntm_matrix_oneplus_function_design_compilation 
}

alias d36 {
  ntm_matrix_sinh_function_design_compilation 
}

alias d37 {
  ntm_matrix_softmax_function_design_compilation 
}

alias d38 {
  ntm_matrix_summation_function_design_compilation 
}

alias d39 {
  ntm_matrix_tanh_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-CONVOLUTION-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "d03 . NTM-SCALAR-COSINE_SIMILARITY-FUNCTION-TEST"
echo "d04 . NTM-SCALAR-DIFFERENTIATION-FUNCTION-TEST"
echo "d05 . NTM-SCALAR-EXPONENTIATOR-FUNCTION-FUNCTION-TEST"
echo "d06 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "d07 . NTM-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d08 . NTM-SCALAR-MULTIPLICATION-FUNCTION-TEST"
echo "d09 . NTM-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d10 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "d11 . NTM-SCALAR-SOFTMAX-FUNCTION-TEST"
echo "d12 . NTM-SCALAR-SUMMATION-FUNCTION-TEST"
echo "d13 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "d14 . NTM-VECTOR-CONVOLUTION-FUNCTION-TEST"
echo "d15 . NTM-VECTOR-COSH-FUNCTION-TEST"
echo "d16 . NTM-VECTOR-COSINE_SIMILARITY-FUNCTION-TEST"
echo "d17 . NTM-VECTOR-DIFFERENTIATION-FUNCTION-TEST"
echo "d18 . NTM-VECTOR-EXPONENTIATOR-FUNCTION-FUNCTION-TEST"
echo "d19 . NTM-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "d20 . NTM-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "d21 . NTM-VECTOR-MULTIPLICATION-FUNCTION-TEST"
echo "d22 . NTM-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "d23 . NTM-VECTOR-SINH-FUNCTION-TEST"
echo "d24 . NTM-VECTOR-SOFTMAX-FUNCTION-TEST"
echo "d25 . NTM-VECTOR-SUMMATION-FUNCTION-TEST"
echo "d26 . NTM-VECTOR-TANH-FUNCTION-TEST"
echo "d27 . NTM-MATRIX-CONVOLUTION-FUNCTION-TEST"
echo "d28 . NTM-MATRIX-COSH-FUNCTION-TEST"
echo "d29 . NTM-MATRIX-COSINE_SIMILARITY-FUNCTION-TEST"
echo "d30 . NTM-MATRIX-DIFFERENTIATION-FUNCTION-TEST"
echo "d31 . NTM-MATRIX-EXPONENTIATOR-FUNCTION-FUNCTION-TEST"
echo "d32 . NTM-MATRIX-LOGARITHM-FUNCTION-TEST"
echo "d33 . NTM-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d34 . NTM-MATRIX-MULTIPLICATION-FUNCTION-TEST"
echo "d35 . NTM-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "d36 . NTM-MATRIX-SINH-FUNCTION-TEST"
echo "d37 . NTM-MATRIX-SOFTMAX-FUNCTION-TEST"
echo "d38 . NTM-MATRIX-SUMMATION-FUNCTION-TEST"
echo "d39 . NTM-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"