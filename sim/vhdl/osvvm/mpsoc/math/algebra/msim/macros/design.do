#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_dot_product_design_compilation #############################################################
##################################################################################################

alias ntm_dot_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_dot_product.vhd
}

##################################################################################################
# ntm_vector_convolution_design_compilation ######################################################
##################################################################################################

alias ntm_vector_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_vector_convolution.vhd
}

##################################################################################################
# ntm_vector_cosine_similarity_design_compilation ################################################
##################################################################################################

alias ntm_vector_cosine_similarity_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_vector_cosine_similarity.vhd
}

##################################################################################################
# ntm_vector_multiplication_design_compilation ###################################################
##################################################################################################

alias ntm_vector_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_vector_multiplication.vhd
}

##################################################################################################
# ntm_vector_summation_design_compilation ########################################################
##################################################################################################

alias ntm_vector_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_vector_summation.vhd
}

##################################################################################################
# ntm_vector_module_design_compilation ########################################################
##################################################################################################

alias ntm_vector_module_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_vector_module.vhd
}

##################################################################################################
# ntm_matrix_convolution_design_compilation ######################################################
##################################################################################################

alias ntm_matrix_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_convolution.vhd
}

##################################################################################################
# ntm_matrix_inverse_design_compilation ##########################################################
##################################################################################################

alias ntm_matrix_inverse_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_inverse.vhd
}

##################################################################################################
# ntm_matrix_multiplication_design_compilation ###################################################
##################################################################################################

alias ntm_matrix_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_multiplication.vhd
}

##################################################################################################
# ntm_matrix_product_design_compilation ##########################################################
##################################################################################################

alias ntm_matrix_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_product.vhd
}

##################################################################################################
# ntm_matrix_summation_design_compilation ########################################################
##################################################################################################

alias ntm_matrix_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_summation.vhd
}

##################################################################################################
# ntm_matrix_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_matrix_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_transpose.vhd
}

##################################################################################################
# ntm_tensor_convolution_design_compilation ######################################################
##################################################################################################

alias ntm_tensor_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_convolution.vhd
}

##################################################################################################
# ntm_tensor_inverse_design_compilation ##########################################################
##################################################################################################

alias ntm_tensor_inverse_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_inverse.vhd
}

##################################################################################################
# ntm_tensor_multiplication_design_compilation ###################################################
##################################################################################################

alias ntm_tensor_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_multiplication.vhd
}

##################################################################################################
# ntm_tensor_product_design_compilation ##########################################################
##################################################################################################

alias ntm_tensor_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_product.vhd
}

##################################################################################################
# ntm_tensor_summation_design_compilation ########################################################
##################################################################################################

alias ntm_tensor_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_summation.vhd
}

##################################################################################################
# ntm_tensor_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_tensor_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_transpose.vhd
}

##################################################################################################

alias d01 {
  ntm_dot_product_design_compilation
}

alias d02 {
  ntm_vector_convolution_design_compilation
}

alias d03 {
  ntm_vector_cosine_similarity_design_compilation
}

alias d04 {
  ntm_vector_multiplication_design_compilation
}

alias d05 {
  ntm_vector_summation_design_compilation
}

alias d06 {
  ntm_vector_module_design_compilation
}

alias d07 {
  ntm_matrix_convolution_design_compilation
}

alias d08 {
  ntm_matrix_inverse_design_compilation
}

alias d09 {
  ntm_matrix_multiplication_design_compilation
}

alias d10 {
  ntm_matrix_product_design_compilation
}

alias d11 {
  ntm_matrix_summation_design_compilation
}

alias d12 {
  ntm_matrix_transpose_design_compilation
}

alias d13 {
  ntm_tensor_convolution_design_compilation
}

alias d14 {
  ntm_tensor_inverse_design_compilation
}

alias d15 {
  ntm_tensor_multiplication_design_compilation
}

alias d16 {
  ntm_tensor_product_design_compilation
}

alias d17 {
  ntm_tensor_summation_design_compilation
}

alias d18 {
  ntm_tensor_transpose_design_compilation
}

echo "****************************************"
echo "d01 . NTM-DOT-PRODUCT-TEST"
echo "d02 . NTM-VECTOR-CONVOLUTION-TEST"
echo "d03 . NTM-VECTOR-COSINE-SIMILARITY-TEST"
echo "d04 . NTM-VECTOR-MULTIPLICATION-TEST"
echo "d05 . NTM-VECTOR-SUMMATION-TEST"
echo "d06 . NTM-VECTOR-MODULE-TEST"
echo "d07 . NTM-MATRIX-CONVOLUTION-TEST"
echo "d08 . NTM-MATRIX-INVERSE-TEST"
echo "d09 . NTM-MATRIX-MULTIPLICATION-TEST"
echo "d10 . NTM-MATRIX-PRODUCT-TEST"
echo "d11 . NTM-MATRIX-SUMMATION-TEST"
echo "d12 . NTM-MATRIX-TRANSPOSE-TEST"
echo "d13 . NTM-TENSOR-CONVOLUTION-TEST"
echo "d14 . NTM-TENSOR-INVERSE-TEST"
echo "d15 . NTM-TENSOR-MULTIPLICATION-TEST"
echo "d16 . NTM-TENSOR-PRODUCT-TEST"
echo "d17 . NTM-TENSOR-SUMMATION-TEST"
echo "d18 . NTM-TENSOR-TRANSPOSE-TEST"
echo "****************************************"