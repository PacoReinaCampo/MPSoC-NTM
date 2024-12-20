#*******************
# DESIGN COMPILATION
#*******************

do variables.do

vlib work

##################################################################################################
# model_scalar_fixed_adder_design_compilation
##################################################################################################

alias model_scalar_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_adder.vhd
}

##################################################################################################
# model_scalar_fixed_multiplier_design_compilation
##################################################################################################

alias model_scalar_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_multiplier.vhd
}

##################################################################################################
# model_scalar_fixed_divider_design_compilation
##################################################################################################

alias model_scalar_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_divider.vhd
}

##################################################################################################
# model_vector_fixed_adder_design_compilation
##################################################################################################

alias model_vector_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/vector/model_vector_fixed_adder.vhd
}

##################################################################################################
# model_vector_fixed_multiplier_design_compilation
##################################################################################################

alias model_vector_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/vector/model_vector_fixed_multiplier.vhd
}

##################################################################################################
# model_vector_fixed_divider_design_compilation
##################################################################################################

alias model_vector_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/vector/model_vector_fixed_divider.vhd
}

##################################################################################################
# model_matrix_fixed_adder_design_compilation
##################################################################################################

alias model_matrix_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/matrix/model_matrix_fixed_adder.vhd
}

##################################################################################################
# model_matrix_fixed_multiplier_design_compilation
##################################################################################################

alias model_matrix_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/matrix/model_matrix_fixed_multiplier.vhd
}

##################################################################################################
# model_matrix_fixed_divider_design_compilation
##################################################################################################

alias model_matrix_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/matrix/model_matrix_fixed_divider.vhd
}

##################################################################################################
# model_tensor_fixed_adder_design_compilation
##################################################################################################

alias model_tensor_fixed_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/tensor/model_tensor_fixed_adder.vhd
}

##################################################################################################
# model_tensor_fixed_multiplier_design_compilation
##################################################################################################

alias model_tensor_fixed_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/tensor/model_tensor_fixed_multiplier.vhd
}

##################################################################################################
# model_tensor_fixed_divider_design_compilation
##################################################################################################

alias model_tensor_fixed_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_vhdl_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/scalar/model_scalar_fixed_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/fixed/tensor/model_tensor_fixed_divider.vhd
}

##################################################################################################

alias d01 {
  model_scalar_fixed_adder_design_compilation
}

alias d02 {
  model_scalar_fixed_multiplier_design_compilation
}

alias d03 {
  model_scalar_fixed_divider_design_compilation
}

alias d04 {
  model_vector_fixed_adder_design_compilation
}

alias d05 {
  model_vector_fixed_multiplier_design_compilation
}

alias d06 {
  model_vector_fixed_divider_design_compilation
}

alias d07 {
  model_matrix_fixed_adder_design_compilation
}

alias d08 {
  model_matrix_fixed_multiplier_design_compilation
}

alias d09 {
  model_matrix_fixed_divider_design_compilation
}

alias d10 {
  model_tensor_fixed_adder_design_compilation
}

alias d11 {
  model_tensor_fixed_multiplier_design_compilation
}

alias d12 {
  model_tensor_fixed_divider_design_compilation
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