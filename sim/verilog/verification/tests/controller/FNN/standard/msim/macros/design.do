#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# accelerator_standard_fnn_design_compilation ####################################################
##################################################################################################

alias accelerator_standard_fnn_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_fnn_controller_verilog_pkg.sv

  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv

  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_divider.sv

  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_divider.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_dot_product.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_convolution.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_cosine_similarity.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_multiplication.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_summation.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/accelerator_vector_module.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_convolution.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_inverse.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_multiplication.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_product.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_summation.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_transpose.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_vector_convolution.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/accelerator_matrix_vector_product.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_convolution.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_inverse.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_matrix_convolution.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_matrix_product.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_product.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/accelerator_tensor_transpose.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_differentiation.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_integration.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_softmax.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_differentiation.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_integration.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_softmax.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_differentiation.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_integration.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_softmax.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_oneplus_function.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_oneplus_function.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_cosh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_sinh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_tanh_function.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_cosh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_sinh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/accelerator_vector_tanh_function.sv

  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_cosh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_sinh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/accelerator_matrix_tanh_function.sv

  vlog -sv -reportprogress 300 -work work $design_path/trainer/FNN/accelerator_trainer.sv

  vlog -sv -reportprogress 300 -work work $design_path/controller/FNN/standard/accelerator_controller.sv
}

##################################################################################################

alias d01 {
  accelerator_standard_fnn_design_compilation 
}

echo "****************************************"
echo "d01 . ACCELERATOR-STANDARD-FNN-TEST"
echo "****************************************"
