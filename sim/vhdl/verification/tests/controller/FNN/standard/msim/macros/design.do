#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# accelerator_standard_fnn_design_compilation ####################################################
##################################################################################################

alias accelerator_standard_fnn_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_math_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_fnn_controller_vhdl_pkg.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_divider.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_dot_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_cosine_similarity.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_module.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_multiplication.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_summation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_transpose.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_vector_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_vector_product.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_inverse.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_matrix_convolution.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_matrix_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_product.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_transpose.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_differentiation.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_integration.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_softmax.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_oneplus_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_cosh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_sinh_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_tanh_function.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/trainer/FNN/accelerator_trainer.vhd

  vcom -2008 -reportprogress 300 -work work $design_path/controller/FNN/standard/accelerator_controller.vhd
}

##################################################################################################

alias d01 {
  accelerator_standard_fnn_design_compilation 
}

echo "****************************************"
echo "d01 . ACCELERATOR-STANDARD-FNN-TEST"
echo "****************************************"
