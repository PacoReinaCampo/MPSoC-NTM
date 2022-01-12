#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_matrix_product_design_compilation ##########################################################
##################################################################################################

alias ntm_matrix_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_matrix_product.vhd
}

##################################################################################################
# ntm_matrix_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_matrix_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_matrix_transpose.vhd
}

##################################################################################################
# ntm_scalar_product_design_compilation ##########################################################
##################################################################################################

alias ntm_scalar_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_scalar_product.vhd
}

##################################################################################################
# ntm_scalar_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_scalar_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_scalar_transpose.vhd
}

##################################################################################################
# ntm_tensor_product_design_compilation ##########################################################
##################################################################################################

alias ntm_tensor_product_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_tensor_product.vhd
}

##################################################################################################
# ntm_tensor_transpose_design_compilation ########################################################
##################################################################################################

alias ntm_tensor_transpose_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/algebra/ntm_tensor_transpose.vhd
}

##################################################################################################

alias d01 {
  ntm_matrix_product_design_compilation
}

alias d02 {
  ntm_matrix_transpose_design_compilation
}

alias d03 {
  ntm_scalar_product_design_compilation
}

alias d04 {
  ntm_scalar_transpose_design_compilation
}

alias d05 {
  ntm_tensor_product_design_compilation
}

alias d06 {
  ntm_tensor_transpose_design_compilation
}

echo "****************************************"
echo "d01 . NTM-MATRIX-PRODUCT-TEST"
echo "d02 . NTM-MATRIX-TRANSPOSE-TEST"
echo "d03 . NTM-SCALAR-PRODUCT-TEST"
echo "d04 . NTM-SCALAR-TRANSPOSE-TEST"
echo "d05 . NTM-TENSOR-PRODUCT-TEST"
echo "d06 . NTM-TENSOR-TRANSPOSE-TEST"
echo "****************************************"
