#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# model_dot_product_design_compilation #############################################################
##################################################################################################

alias model_dot_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_dot_product.vhd
}

##################################################################################################
# model_vector_convolution_design_compilation ######################################################
##################################################################################################

alias model_vector_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_convolution.vhd
}

##################################################################################################
# model_vector_cosine_similarity_design_compilation ################################################
##################################################################################################

alias model_vector_cosine_similarity_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_cosine_similarity.vhd
}

##################################################################################################
# model_vector_multiplication_design_compilation ###################################################
##################################################################################################

alias model_vector_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_multiplication.vhd
}

##################################################################################################
# model_vector_summation_design_compilation ########################################################
##################################################################################################

alias model_vector_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_summation.vhd
}

##################################################################################################
# model_vector_module_design_compilation ########################################################
##################################################################################################

alias model_vector_module_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_module.vhd
}

##################################################################################################
# model_matrix_convolution_design_compilation ######################################################
##################################################################################################

alias model_matrix_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_convolution.vhd
}

##################################################################################################
# model_matrix_inverse_design_compilation ##########################################################
##################################################################################################

alias model_matrix_inverse_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_inverse.vhd
}

##################################################################################################
# model_matrix_multiplication_design_compilation ###################################################
##################################################################################################

alias model_matrix_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_multiplication.vhd
}

##################################################################################################
# model_matrix_product_design_compilation ##########################################################
##################################################################################################

alias model_matrix_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_product.vhd
}

##################################################################################################
# model_matrix_summation_design_compilation ########################################################
##################################################################################################

alias model_matrix_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_summation.vhd
}

##################################################################################################
# model_matrix_transpose_design_compilation ########################################################
##################################################################################################

alias model_matrix_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_transpose.vhd
}

##################################################################################################
# model_tensor_convolution_design_compilation ######################################################
##################################################################################################

alias model_tensor_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_convolution.vhd
}

##################################################################################################
# model_tensor_inverse_design_compilation ##########################################################
##################################################################################################

alias model_tensor_inverse_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_inverse.vhd
}

##################################################################################################
# model_tensor_multiplication_design_compilation ###################################################
##################################################################################################

alias model_tensor_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_multiplication.vhd
}

##################################################################################################
# model_tensor_product_design_compilation ##########################################################
##################################################################################################

alias model_tensor_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_product.vhd
}

##################################################################################################
# model_tensor_summation_design_compilation ########################################################
##################################################################################################

alias model_tensor_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_summation.vhd
}

##################################################################################################
# model_tensor_transpose_design_compilation ########################################################
##################################################################################################

alias model_tensor_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_transpose.vhd
}

##################################################################################################

alias d01 {
  model_dot_product_design_compilation
}

alias d02 {
  model_vector_convolution_design_compilation
}

alias d03 {
  model_vector_cosine_similarity_design_compilation
}

alias d04 {
  model_vector_multiplication_design_compilation
}

alias d05 {
  model_vector_summation_design_compilation
}

alias d06 {
  model_vector_module_design_compilation
}

alias d07 {
  model_matrix_convolution_design_compilation
}

alias d08 {
  model_matrix_inverse_design_compilation
}

alias d09 {
  model_matrix_multiplication_design_compilation
}

alias d10 {
  model_matrix_product_design_compilation
}

alias d11 {
  model_matrix_summation_design_compilation
}

alias d12 {
  model_matrix_transpose_design_compilation
}

alias d13 {
  model_tensor_convolution_design_compilation
}

alias d14 {
  model_tensor_inverse_design_compilation
}

alias d15 {
  model_tensor_multiplication_design_compilation
}

alias d16 {
  model_tensor_product_design_compilation
}

alias d17 {
  model_tensor_summation_design_compilation
}

alias d18 {
  model_tensor_transpose_design_compilation
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