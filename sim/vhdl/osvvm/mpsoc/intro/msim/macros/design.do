#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_integer_adder_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
}

##################################################################################################
# ntm_scalar_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
}

##################################################################################################
# ntm_scalar_integer_divider_design_compilation ##################################################
##################################################################################################

alias ntm_scalar_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
}

##################################################################################################
# ntm_vector_integer_adder_design_compilation ####################################################
##################################################################################################

alias ntm_vector_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_adder.vhd
}

##################################################################################################
# ntm_vector_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_vector_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
}

##################################################################################################
# ntm_vector_integer_divider_design_compilation ##################################################
##################################################################################################

alias ntm_vector_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_divider.vhd
}

##################################################################################################
# ntm_matrix_integer_adder_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/ntm_matrix_integer_adder.vhd
}

##################################################################################################
# ntm_matrix_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_matrix_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/ntm_matrix_integer_multiplier.vhd
}

##################################################################################################
# ntm_matrix_integer_divider_design_compilation ##################################################
##################################################################################################

alias ntm_matrix_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/ntm_matrix_integer_divider.vhd
}

##################################################################################################
# ntm_tensor_integer_adder_design_compilation ####################################################
##################################################################################################

alias ntm_tensor_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/ntm_tensor_integer_adder.vhd
}

##################################################################################################
# ntm_tensor_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_tensor_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/ntm_tensor_integer_multiplier.vhd
}

##################################################################################################
# ntm_tensor_integer_divider_design_compilation ##################################################
##################################################################################################

alias ntm_tensor_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/ntm_tensor_integer_divider.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_integer_adder_design_compilation 
}

alias d02 {
  ntm_scalar_integer_multiplier_design_compilation 
}

alias d03 {
  ntm_scalar_integer_divider_design_compilation 
}

alias d04 {
  ntm_vector_integer_adder_design_compilation 
}

alias d05 {
  ntm_vector_integer_multiplier_design_compilation 
}

alias d06 {
  ntm_vector_integer_divider_design_compilation 
}

alias d07 {
  ntm_matrix_integer_adder_design_compilation 
}

alias d08 {
  ntm_matrix_integer_multiplier_design_compilation 
}

alias d09 {
  ntm_matrix_integer_divider_design_compilation 
}

alias d10 {
  ntm_tensor_integer_adder_design_compilation 
}

alias d11 {
  ntm_tensor_integer_multiplier_design_compilation 
}

alias d12 {
  ntm_tensor_integer_divider_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-ADDER-TEST"
echo "d02 . NTM-SCALAR-MULTIPLIER-TEST"
echo "d03 . NTM-SCALAR-DIVIDER-TEST"
echo "d04 . NTM-VECTOR-ADDER-TEST"
echo "d05 . NTM-VECTOR-MULTIPLIER-TEST"
echo "d06 . NTM-VECTOR-DIVIDER-TEST"
echo "d07 . NTM-MATRIX-ADDER-TEST"
echo "d08 . NTM-MATRIX-MULTIPLIER-TEST"
echo "d09 . NTM-MATRIX-DIVIDER-TEST"
echo "d10 . NTM-TENSOR-ADDER-TEST"
echo "d11 . NTM-TENSOR-MULTIPLIER-TEST"
echo "d12 . NTM-TENSOR-DIVIDER-TEST"
echo "****************************************"