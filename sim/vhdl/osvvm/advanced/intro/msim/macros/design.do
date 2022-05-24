#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# model_scalar_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_scalar_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
}

##################################################################################################
# model_scalar_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_scalar_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
}

##################################################################################################
# model_scalar_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_scalar_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
}

##################################################################################################
# model_vector_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_vector_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_adder.vhd
}

##################################################################################################
# model_vector_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_vector_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_multiplier.vhd
}

##################################################################################################
# model_vector_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_vector_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_divider.vhd
}

##################################################################################################
# model_matrix_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_matrix_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/model_matrix_integer_adder.vhd
}

##################################################################################################
# model_matrix_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_matrix_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/model_matrix_integer_multiplier.vhd
}

##################################################################################################
# model_matrix_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_matrix_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/model_matrix_integer_divider.vhd
}

##################################################################################################
# model_tensor_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_tensor_integer_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/model_tensor_integer_adder.vhd
}

##################################################################################################
# model_tensor_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_tensor_integer_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/model_tensor_integer_multiplier.vhd
}

##################################################################################################
# model_tensor_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_tensor_integer_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/model_tensor_integer_divider.vhd
}

##################################################################################################

alias d01 {
  model_scalar_integer_adder_design_compilation 
}

alias d02 {
  model_scalar_integer_multiplier_design_compilation 
}

alias d03 {
  model_scalar_integer_divider_design_compilation 
}

alias d04 {
  model_vector_integer_adder_design_compilation 
}

alias d05 {
  model_vector_integer_multiplier_design_compilation 
}

alias d06 {
  model_vector_integer_divider_design_compilation 
}

alias d07 {
  model_matrix_integer_adder_design_compilation 
}

alias d08 {
  model_matrix_integer_multiplier_design_compilation 
}

alias d09 {
  model_matrix_integer_divider_design_compilation 
}

alias d10 {
  model_tensor_integer_adder_design_compilation 
}

alias d11 {
  model_tensor_integer_multiplier_design_compilation 
}

alias d12 {
  model_tensor_integer_divider_design_compilation 
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