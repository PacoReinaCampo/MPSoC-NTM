#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# model_trainer_vector_differentiation_design_compilation ########################################
##################################################################################################

alias model_trainer_vector_differentiation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_linear_controller_pkg.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_dot_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_cosine_similarity.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_module.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_transpose.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_product.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_transpose.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/trainer/differentiation/model_trainer_vector_differentiation.vhd
}

##################################################################################################
# model_trainer_matrix_differentiation_design_compilation ########################################
##################################################################################################

alias model_trainer_matrix_differentiation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_linear_controller_pkg.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_dot_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_cosine_similarity.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_module.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_transpose.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_product.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_transpose.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/trainer/differentiation/model_trainer_matrix_differentiation.vhd
}

##################################################################################################
# model_trainer_linear_design_compilation ########################################################
##################################################################################################

alias model_trainer_linear_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_linear_controller_pkg.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_dot_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_cosine_similarity.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_module.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_transpose.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_product.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_transpose.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/model_matrix_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/model_vector_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/trainer/linear/model_trainer.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/state/linear/standard/model_controller.vhd
}

##################################################################################################

alias d01 {
  model_trainer_vector_differentiation_design_compilation 
}

alias d02 {
  model_trainer_matrix_differentiation_design_compilation 
}

alias d03 {
  model_trainer_linear_design_compilation 
}

echo "****************************************"
echo "d01 . MODEL-TRAINER-VECTOR-DIFFERENTIATION-TEST"
echo "d02 . MODEL-TRAINER-MATRIX-DIFFERENTIATION-TEST"
echo "d03 . MODEL-TRAINER-LINEAR-TEST"
echo "****************************************"
