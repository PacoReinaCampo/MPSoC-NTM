#*******************
# DESIGN COMPILATION
#*******************

do variables.do

vlib work

##################################################################################################
# model_dot_product_design_compilation
##################################################################################################

alias model_dot_product_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/model_dot_product.sv
}

##################################################################################################
# model_vector_convolution_design_compilation
##################################################################################################

alias model_vector_convolution_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_convolution.sv
}

##################################################################################################
# model_vector_cosine_similarity_design_compilation
##################################################################################################

alias model_vector_cosine_similarity_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_cosine_similarity.sv
}

##################################################################################################
# model_vector_multiplication_design_compilation
##################################################################################################

alias model_vector_multiplication_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_multiplication.sv
}

##################################################################################################
# model_vector_summation_design_compilation
##################################################################################################

alias model_vector_summation_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_summation.sv
}

##################################################################################################
# model_vector_module_design_compilation
##################################################################################################

alias model_vector_module_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/vector/model_vector_module.sv
}

##################################################################################################
# model_matrix_convolution_design_compilation
##################################################################################################

alias model_matrix_convolution_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_convolution.sv
}

##################################################################################################
# model_matrix_vector_convolution_design_compilation
##################################################################################################

alias model_matrix_vector_convolution_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_convolution.sv
}

##################################################################################################
# model_matrix_inverse_design_compilation
##################################################################################################

alias model_matrix_inverse_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_inverse.sv
}

##################################################################################################
# model_matrix_multiplication_design_compilation
##################################################################################################

alias model_matrix_multiplication_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_multiplication.sv
}

##################################################################################################
# model_matrix_product_design_compilation
##################################################################################################

alias model_matrix_product_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_product.sv
}

##################################################################################################
# model_matrix_vector_product_design_compilation
##################################################################################################

alias model_matrix_vector_product_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_vector_product.sv
}

##################################################################################################
# model_matrix_summation_design_compilation
##################################################################################################

alias model_matrix_summation_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_summation.sv
}

##################################################################################################
# model_matrix_transpose_design_compilation
##################################################################################################

alias model_matrix_transpose_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/matrix/model_matrix_transpose.sv
}

##################################################################################################
# model_tensor_convolution_design_compilation
##################################################################################################

alias model_tensor_convolution_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_convolution.sv
}

##################################################################################################
# model_tensor_matrix_convolution_design_compilation
##################################################################################################

alias model_tensor_matrix_convolution_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_convolution.sv
}

##################################################################################################
# model_tensor_inverse_design_compilation
##################################################################################################

alias model_tensor_inverse_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_inverse.sv
}

##################################################################################################
# model_tensor_product_design_compilation
##################################################################################################

alias model_tensor_product_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_product.sv
}

##################################################################################################
# model_tensor_matrix_product_design_compilation
##################################################################################################

alias model_tensor_matrix_product_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_matrix_product.sv
}

##################################################################################################
# model_tensor_transpose_design_compilation
##################################################################################################

alias model_tensor_transpose_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/algebra/tensor/model_tensor_transpose.sv
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
  model_matrix_vector_convolution_design_compilation
}

alias d09 {
  model_matrix_inverse_design_compilation
}

alias d10 {
  model_matrix_multiplication_design_compilation
}

alias d11 {
  model_matrix_product_design_compilation
}

alias d12 {
  model_matrix_vector_product_design_compilation
}

alias d13 {
  model_matrix_summation_design_compilation
}

alias d14 {
  model_matrix_transpose_design_compilation
}

alias d15 {
  model_tensor_convolution_design_compilation
}

alias d16 {
  model_tensor_matrix_convolution_design_compilation
}

alias d17 {
  model_tensor_inverse_design_compilation
}

alias d18 {
  model_tensor_product_design_compilation
}

alias d19 {
  model_tensor_matrix_product_design_compilation
}

alias d20 {
  model_tensor_transpose_design_compilation
}

echo "****************************************"
echo "d01 . ACCELERATOR-DOT-PRODUCT-TEST"
echo "d02 . ACCELERATOR-VECTOR-CONVOLUTION-TEST"
echo "d03 . ACCELERATOR-VECTOR-COSINE-SIMILARITY-TEST"
echo "d04 . ACCELERATOR-VECTOR-MULTIPLICATION-TEST"
echo "d05 . ACCELERATOR-VECTOR-SUMMATION-TEST"
echo "d06 . ACCELERATOR-VECTOR-MODULE-TEST"
echo "d07 . ACCELERATOR-MATRIX-CONVOLUTION-TEST"
echo "d08 . ACCELERATOR-MATRIX-VECTOR-CONVOLUTION-TEST"
echo "d09 . ACCELERATOR-MATRIX-INVERSE-TEST"
echo "d10 . ACCELERATOR-MATRIX-MULTIPLICATION-TEST"
echo "d11 . ACCELERATOR-MATRIX-PRODUCT-TEST"
echo "d12 . ACCELERATOR-MATRIX-VECTOR-PRODUCT-TEST"
echo "d13 . ACCELERATOR-MATRIX-SUMMATION-TEST"
echo "d14 . ACCELERATOR-MATRIX-TRANSPOSE-TEST"
echo "d15 . ACCELERATOR-TENSOR-CONVOLUTION-TEST"
echo "d16 . ACCELERATOR-TENSOR-MATRIX-CONVOLUTION-TEST"
echo "d17 . ACCELERATOR-TENSOR-INVERSE-TEST"
echo "d18 . ACCELERATOR-TENSOR-PRODUCT-TEST"
echo "d19 . ACCELERATOR-TENSOR-MATRIX-PRODUCT-TEST"
echo "d20 . ACCELERATOR-TENSOR-TRANSPOSE-TEST"
echo "****************************************"
