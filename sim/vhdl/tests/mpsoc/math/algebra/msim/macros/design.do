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
# ntm_vector_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_vector_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/vector/ntm_vector_transpose.vhd
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
# ntm_matrix_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_matrix_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/matrix/ntm_matrix_transpose.vhd
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
# ntm_tensor_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_tensor_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/tensor/ntm_tensor_transpose.vhd
}

##################################################################################################

alias d01 {
  ntm_dot_product_design_compilation
}

alias d02 {
  ntm_vector_transpose_design_compilation
}

alias d03 {
  ntm_matrix_product_design_compilation
}

alias d04 {
  ntm_matrix_transpose_design_compilation
}

alias d05 {
  ntm_tensor_product_design_compilation
}

alias d06 {
  ntm_tensor_transpose_design_compilation
}

echo "****************************************"
echo "d01 . NTM-DOT-PRODUCT-TEST"
echo "d02 . NTM-VECTOR-TRANSPOSE-TEST"
echo "d03 . NTM-MATRIX-PRODUCT-TEST"
echo "d04 . NTM-MATRIX-TRANSPOSE-TEST"
echo "d05 . NTM-TENSOR-PRODUCT-TEST"
echo "d06 . NTM-TENSOR-TRANSPOSE-TEST"
echo "****************************************"
