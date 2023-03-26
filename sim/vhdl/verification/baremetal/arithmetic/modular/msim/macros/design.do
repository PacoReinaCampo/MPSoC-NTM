#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# model_scalar_modular_mod_design_compilation ######################################################
##################################################################################################

alias model_scalar_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_mod.vhd
}

##################################################################################################
# model_scalar_modular_adder_design_compilation ####################################################
##################################################################################################

alias model_scalar_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_adder.vhd
}

##################################################################################################
# model_scalar_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias model_scalar_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_multiplier.vhd
}

##################################################################################################
# model_scalar_modular_inverter_design_compilation #################################################
##################################################################################################

alias model_scalar_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_inverter.vhd
}

##################################################################################################
# model_vector_modular_mod_design_compilation ######################################################
##################################################################################################

alias model_vector_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/vector/model_vector_modular_mod.vhd
}

##################################################################################################
# model_vector_modular_adder_design_compilation ####################################################
##################################################################################################

alias model_vector_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/vector/model_vector_modular_adder.vhd
}

##################################################################################################
# model_vector_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias model_vector_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/vector/model_vector_modular_multiplier.vhd
}

##################################################################################################
# model_vector_modular_inverter_design_compilation #################################################
##################################################################################################

alias model_vector_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/vector/model_vector_modular_inverter.vhd
}

##################################################################################################
# model_matrix_modular_mod_design_compilation ######################################################
##################################################################################################

alias model_matrix_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/matrix/model_matrix_modular_mod.vhd
}

##################################################################################################
# model_matrix_modular_adder_design_compilation ####################################################
##################################################################################################

alias model_matrix_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/matrix/model_matrix_modular_adder.vhd
}

##################################################################################################
# model_matrix_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias model_matrix_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/matrix/model_matrix_modular_multiplier.vhd
}

##################################################################################################
# model_matrix_modular_inverter_design_compilation #################################################
##################################################################################################

alias model_matrix_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/matrix/model_matrix_modular_inverter.vhd
}

##################################################################################################
# model_tensor_modular_mod_design_compilation ######################################################
##################################################################################################

alias model_tensor_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/tensor/model_tensor_modular_mod.vhd
}

##################################################################################################
# model_tensor_modular_adder_design_compilation ####################################################
##################################################################################################

alias model_tensor_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/tensor/model_tensor_modular_adder.vhd
}

##################################################################################################
# model_tensor_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias model_tensor_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/tensor/model_tensor_modular_multiplier.vhd
}

##################################################################################################
# model_tensor_modular_inverter_design_compilation #################################################
##################################################################################################

alias model_tensor_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/scalar/model_scalar_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/modular/tensor/model_tensor_modular_inverter.vhd
}

##################################################################################################

alias d01 {
  model_scalar_modular_mod_design_compilation 
}

alias d02 {
  model_scalar_modular_adder_design_compilation 
}

alias d03 {
  model_scalar_modular_multiplier_design_compilation 
}

alias d04 {
  model_scalar_modular_inverter_design_compilation 
}

alias d05 {
  model_vector_modular_mod_design_compilation 
}

alias d06 {
  model_vector_modular_adder_design_compilation 
}

alias d07 {
  model_vector_modular_multiplier_design_compilation 
}

alias d08 {
  model_vector_modular_inverter_design_compilation 
}

alias d09 {
  model_matrix_modular_mod_design_compilation 
}

alias d10 {
  model_matrix_modular_adder_design_compilation 
}

alias d11 {
  model_matrix_modular_multiplier_design_compilation 
}

alias d12 {
  model_matrix_modular_inverter_design_compilation 
}

alias d13 {
  model_tensor_modular_mod_design_compilation 
}

alias d14 {
  model_tensor_modular_adder_design_compilation 
}

alias d15 {
  model_tensor_modular_multiplier_design_compilation 
}

alias d16 {
  model_tensor_modular_inverter_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-MOD-TEST"
echo "d02 . NTM-SCALAR-ADDER-TEST"
echo "d03 . NTM-SCALAR-MULTIPLIER-TEST"
echo "d04 . NTM-SCALAR-INVERTER-TEST"
echo "d05 . NTM-VECTOR-MOD-TEST"
echo "d06 . NTM-VECTOR-ADDER-TEST"
echo "d07 . NTM-VECTOR-MULTIPLIER-TEST"
echo "d08 . NTM-VECTOR-INVERTER-TEST"
echo "d09 . NTM-MATRIX-MOD-TEST"
echo "d10 . NTM-MATRIX-ADDER-TEST"
echo "d11 . NTM-MATRIX-MULTIPLIER-TEST"
echo "d12 . NTM-MATRIX-INVERTER-TEST"
echo "d13 . NTM-TENSOR-MOD-TEST"
echo "d14 . NTM-TENSOR-ADDER-TEST"
echo "d15 . NTM-TENSOR-MULTIPLIER-TEST"
echo "d16 . NTM-TENSOR-INVERTER-TEST"
echo "****************************************"