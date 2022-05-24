#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# model_scalar_float_adder_design_compilation ######################################################
##################################################################################################

alias model_scalar_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
}

##################################################################################################
# model_scalar_float_multiplier_design_compilation #################################################
##################################################################################################

alias model_scalar_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
}

##################################################################################################
# model_scalar_float_divider_design_compilation ####################################################
##################################################################################################

alias model_scalar_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
}

##################################################################################################
# model_vector_float_adder_design_compilation ######################################################
##################################################################################################

alias model_vector_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_adder.vhd
}

##################################################################################################
# model_vector_float_multiplier_design_compilation #################################################
##################################################################################################

alias model_vector_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_multiplier.vhd
}

##################################################################################################
# model_vector_float_divider_design_compilation ####################################################
##################################################################################################

alias model_vector_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/model_vector_float_divider.vhd
}

##################################################################################################
# model_matrix_float_adder_design_compilation ######################################################
##################################################################################################

alias model_matrix_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_adder.vhd
}

##################################################################################################
# model_matrix_float_multiplier_design_compilation #################################################
##################################################################################################

alias model_matrix_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_multiplier.vhd
}

##################################################################################################
# model_matrix_float_divider_design_compilation ####################################################
##################################################################################################

alias model_matrix_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/model_matrix_float_divider.vhd
}

##################################################################################################
# model_tensor_float_adder_design_compilation ######################################################
##################################################################################################

alias model_tensor_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/tensor/model_tensor_float_adder.vhd
}

##################################################################################################
# model_tensor_float_multiplier_design_compilation #################################################
##################################################################################################

alias model_tensor_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/tensor/model_tensor_float_multiplier.vhd
}

##################################################################################################
# model_tensor_float_divider_design_compilation ####################################################
##################################################################################################

alias model_tensor_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/tensor/model_tensor_float_divider.vhd
}

##################################################################################################

alias d01 {
  model_scalar_float_adder_design_compilation 
}

alias d02 {
  model_scalar_float_multiplier_design_compilation 
}

alias d03 {
  model_scalar_float_divider_design_compilation 
}

alias d04 {
  model_vector_float_adder_design_compilation 
}

alias d05 {
  model_vector_float_multiplier_design_compilation 
}

alias d06 {
  model_vector_float_divider_design_compilation 
}

alias d07 {
  model_matrix_float_adder_design_compilation 
}

alias d08 {
  model_matrix_float_multiplier_design_compilation 
}

alias d09 {
  model_matrixr_float_divider_design_compilation 
}

alias d10 {
  model_tensor_float_adder_design_compilation 
}

alias d11 {
  model_tensor_float_multiplier_design_compilation 
}

alias d12 {
  model_tensor_float_divider_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-FLOAT-ADDER-TEST"
echo "d02 . NTM-SCALAR-FLOAT-MULTIPLIER-TEST"
echo "d03 . NTM-SCALAR-FLOAT-DIVIDER-TEST"
echo "d04 . NTM-VECTOR-FLOAT-ADDER-TEST"
echo "d05 . NTM-VECTOR-FLOAT-MULTIPLIER-TEST"
echo "d06 . NTM-VECTOR-FLOAT-DIVIDER-TEST"
echo "d07 . NTM-MATRIX-FLOAT-ADDER-TEST"
echo "d08 . NTM-MATRIX-FLOAT-MULTIPLIER-TEST"
echo "d09 . NTM-MATRIX-FLOAT-DIVIDER-TEST"
echo "d10 . NTM-TENSOR-FLOAT-ADDER-TEST"
echo "d11 . NTM-TENSOR-FLOAT-MULTIPLIER-TEST"
echo "d12 . NTM-TENSOR-FLOAT-DIVIDER-TEST"
echo "****************************************"