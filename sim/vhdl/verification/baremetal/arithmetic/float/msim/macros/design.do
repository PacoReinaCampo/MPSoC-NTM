#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# accelerator_scalar_float_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_scalar_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
}

##################################################################################################
# accelerator_scalar_float_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_scalar_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
}

##################################################################################################
# accelerator_scalar_float_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_scalar_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd
}

##################################################################################################
# accelerator_vector_float_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_vector_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_adder.vhd
}

##################################################################################################
# accelerator_vector_float_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_vector_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_multiplier.vhd
}

##################################################################################################
# accelerator_vector_float_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_vector_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_divider.vhd
}

##################################################################################################
# accelerator_matrix_float_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_matrix_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_adder.vhd
}

##################################################################################################
# accelerator_matrix_float_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_matrix_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_multiplier.vhd
}

##################################################################################################
# accelerator_matrix_float_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_matrix_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_divider.vhd
}

##################################################################################################
# accelerator_tensor_float_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_tensor_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/tensor/accelerator_tensor_float_adder.vhd
}

##################################################################################################
# accelerator_tensor_float_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_tensor_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/tensor/accelerator_tensor_float_multiplier.vhd
}

##################################################################################################
# accelerator_tensor_float_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_tensor_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/tensor/accelerator_tensor_float_divider.vhd
}

##################################################################################################

alias d01 {
  accelerator_scalar_float_adder_design_compilation 
}

alias d02 {
  accelerator_scalar_float_multiplier_design_compilation 
}

alias d03 {
  accelerator_scalar_float_divider_design_compilation 
}

alias d04 {
  accelerator_vector_float_adder_design_compilation 
}

alias d05 {
  accelerator_vector_float_multiplier_design_compilation 
}

alias d06 {
  accelerator_vector_float_divider_design_compilation 
}

alias d07 {
  accelerator_matrix_float_adder_design_compilation 
}

alias d08 {
  accelerator_matrix_float_multiplier_design_compilation 
}

alias d09 {
  accelerator_matrixr_float_divider_design_compilation 
}

alias d10 {
  accelerator_tensor_float_adder_design_compilation 
}

alias d11 {
  accelerator_tensor_float_multiplier_design_compilation 
}

alias d12 {
  accelerator_tensor_float_divider_design_compilation 
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