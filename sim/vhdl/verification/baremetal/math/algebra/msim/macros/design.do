#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# accelerator_dot_product_design_compilation #############################################################
##################################################################################################

alias accelerator_dot_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_dot_product.vhd
}

##################################################################################################
# accelerator_vector_convolution_design_compilation ######################################################
##################################################################################################

alias accelerator_vector_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_convolution.vhd
}

##################################################################################################
# accelerator_vector_cosine_similarity_design_compilation ################################################
##################################################################################################

alias accelerator_vector_cosine_similarity_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_cosine_similarity.vhd
}

##################################################################################################
# accelerator_vector_multiplication_design_compilation ###################################################
##################################################################################################

alias accelerator_vector_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_multiplication.vhd
}

##################################################################################################
# accelerator_vector_summation_design_compilation ########################################################
##################################################################################################

alias accelerator_vector_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_summation.vhd
}

##################################################################################################
# accelerator_vector_module_design_compilation ########################################################
##################################################################################################

alias accelerator_vector_module_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_module.vhd
}

##################################################################################################
# accelerator_matrix_convolution_design_compilation ######################################################
##################################################################################################

alias accelerator_matrix_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_convolution.vhd
}

##################################################################################################
# accelerator_matrix_inverse_design_compilation ##########################################################
##################################################################################################

alias accelerator_matrix_inverse_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_inverse.vhd
}

##################################################################################################
# accelerator_matrix_multiplication_design_compilation ###################################################
##################################################################################################

alias accelerator_matrix_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_multiplication.vhd
}

##################################################################################################
# accelerator_matrix_product_design_compilation ##########################################################
##################################################################################################

alias accelerator_matrix_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_product.vhd
}

##################################################################################################
# accelerator_matrix_summation_design_compilation ########################################################
##################################################################################################

alias accelerator_matrix_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_summation.vhd
}

##################################################################################################
# accelerator_matrix_transpose_design_compilation ########################################################
##################################################################################################

alias accelerator_matrix_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_transpose.vhd
}

##################################################################################################
# accelerator_tensor_convolution_design_compilation ######################################################
##################################################################################################

alias accelerator_tensor_convolution_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_convolution.vhd
}

##################################################################################################
# accelerator_tensor_inverse_design_compilation ##########################################################
##################################################################################################

alias accelerator_tensor_inverse_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_inverse.vhd
}

##################################################################################################
# accelerator_tensor_multiplication_design_compilation ###################################################
##################################################################################################

alias accelerator_tensor_multiplication_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_multiplication.vhd
}

##################################################################################################
# accelerator_tensor_product_design_compilation ##########################################################
##################################################################################################

alias accelerator_tensor_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_product.vhd
}

##################################################################################################
# accelerator_tensor_summation_design_compilation ########################################################
##################################################################################################

alias accelerator_tensor_summation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_summation.vhd
}

##################################################################################################
# accelerator_tensor_transpose_design_compilation ########################################################
##################################################################################################

alias accelerator_tensor_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_transpose.vhd
}

##################################################################################################

alias d01 {
  accelerator_dot_product_design_compilation
}

alias d02 {
  accelerator_vector_convolution_design_compilation
}

alias d03 {
  accelerator_vector_cosine_similarity_design_compilation
}

alias d04 {
  accelerator_vector_multiplication_design_compilation
}

alias d05 {
  accelerator_vector_summation_design_compilation
}

alias d06 {
  accelerator_vector_module_design_compilation
}

alias d07 {
  accelerator_matrix_convolution_design_compilation
}

alias d08 {
  accelerator_matrix_inverse_design_compilation
}

alias d09 {
  accelerator_matrix_multiplication_design_compilation
}

alias d10 {
  accelerator_matrix_product_design_compilation
}

alias d11 {
  accelerator_matrix_summation_design_compilation
}

alias d12 {
  accelerator_matrix_transpose_design_compilation
}

alias d13 {
  accelerator_tensor_convolution_design_compilation
}

alias d14 {
  accelerator_tensor_inverse_design_compilation
}

alias d15 {
  accelerator_tensor_multiplication_design_compilation
}

alias d16 {
  accelerator_tensor_product_design_compilation
}

alias d17 {
  accelerator_tensor_summation_design_compilation
}

alias d18 {
  accelerator_tensor_transpose_design_compilation
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