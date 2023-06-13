#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# accelerator_scalar_fixed_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_scalar_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_adder.vhd
}

##################################################################################################
# accelerator_scalar_fixed_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_scalar_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_multiplier.vhd
}

##################################################################################################
# accelerator_scalar_fixed_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_scalar_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_divider.vhd
}

##################################################################################################
# accelerator_vector_fixed_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_vector_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/vector/accelerator_vector_fixed_adder.vhd
}

##################################################################################################
# accelerator_vector_fixed_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_vector_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/vector/accelerator_vector_fixed_multiplier.vhd
}

##################################################################################################
# accelerator_vector_fixed_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_vector_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/vector/accelerator_vector_fixed_divider.vhd
}

##################################################################################################
# accelerator_matrix_fixed_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_matrix_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/matrix/accelerator_matrix_fixed_adder.vhd
}

##################################################################################################
# accelerator_matrix_fixed_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_matrix_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/matrix/accelerator_matrix_fixed_multiplier.vhd
}

##################################################################################################
# accelerator_matrix_fixed_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_matrix_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/matrix/accelerator_matrix_fixed_divider.vhd
}

##################################################################################################
# accelerator_tensor_fixed_adder_design_compilation ######################################################
##################################################################################################

alias accelerator_tensor_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/tensor/accelerator_tensor_fixed_adder.vhd
}

##################################################################################################
# accelerator_tensor_fixed_multiplier_design_compilation #################################################
##################################################################################################

alias accelerator_tensor_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/tensor/accelerator_tensor_fixed_multiplier.vhd
}

##################################################################################################
# accelerator_tensor_fixed_divider_design_compilation ####################################################
##################################################################################################

alias accelerator_tensor_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/accelerator_scalar_fixed_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/tensor/accelerator_tensor_fixed_divider.vhd
}

##################################################################################################

alias d01 {
  accelerator_scalar_fixed_adder_design_compilation 
}

alias d02 {
  accelerator_scalar_fixed_multiplier_design_compilation 
}

alias d03 {
  accelerator_scalar_fixed_divider_design_compilation 
}

alias d04 {
  accelerator_vector_fixed_adder_design_compilation 
}

alias d05 {
  accelerator_vector_fixed_multiplier_design_compilation 
}

alias d06 {
  accelerator_vector_fixed_divider_design_compilation 
}

alias d07 {
  accelerator_matrix_fixed_adder_design_compilation 
}

alias d08 {
  accelerator_matrix_fixed_multiplier_design_compilation 
}

alias d09 {
  accelerator_matrixr_fixed_divider_design_compilation 
}

alias d10 {
  accelerator_tensor_fixed_adder_design_compilation 
}

alias d11 {
  accelerator_tensor_fixed_multiplier_design_compilation 
}

alias d12 {
  accelerator_tensor_fixed_divider_design_compilation 
}

echo "****************************************"
echo "d01 . ACCELERATOR-SCALAR-FIXED-ADDER-TEST"
echo "d02 . ACCELERATOR-SCALAR-FIXED-MULTIPLIER-TEST"
echo "d03 . ACCELERATOR-SCALAR-FIXED-DIVIDER-TEST"
echo "d04 . ACCELERATOR-VECTOR-FIXED-ADDER-TEST"
echo "d05 . ACCELERATOR-VECTOR-FIXED-MULTIPLIER-TEST"
echo "d06 . ACCELERATOR-VECTOR-FIXED-DIVIDER-TEST"
echo "d07 . ACCELERATOR-MATRIX-FIXED-ADDER-TEST"
echo "d08 . ACCELERATOR-MATRIX-FIXED-MULTIPLIER-TEST"
echo "d09 . ACCELERATOR-MATRIX-FIXED-DIVIDER-TEST"
echo "d10 . ACCELERATOR-TENSOR-FIXED-ADDER-TEST"
echo "d11 . ACCELERATOR-TENSOR-FIXED-MULTIPLIER-TEST"
echo "d12 . ACCELERATOR-TENSOR-FIXED-DIVIDER-TEST"
echo "****************************************"