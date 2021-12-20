#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_modular_mod_design_compilation ######################################################
##################################################################################################

alias ntm_scalar_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_mod.vhd
}

##################################################################################################
# ntm_scalar_modular_adder_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_adder.vhd
}

##################################################################################################
# ntm_scalar_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_multiplier.vhd
}

##################################################################################################
# ntm_scalar_modular_inverter_design_compilation #########################################################
##################################################################################################

alias ntm_scalar_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_inverter.vhd
}

##################################################################################################
# ntm_scalar_modular_divider_design_compilation ##################################################
##################################################################################################

alias ntm_scalar_modular_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_divider.vhd
}

##################################################################################################
# ntm_scalar_modular_exponentiator_design_compilation ############################################
##################################################################################################

alias ntm_scalar_modular_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_exponentiator.vhd
}

##################################################################################################
# ntm_vector_modular_mod_design_compilation ######################################################
##################################################################################################

alias ntm_vector_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_mod.vhd
}

##################################################################################################
# ntm_vector_modular_adder_design_compilation ####################################################
##################################################################################################

alias ntm_vector_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_adder.vhd
}

##################################################################################################
# ntm_vector_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_vector_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_multiplier.vhd
}

##################################################################################################
# ntm_vector_modular_inverter_design_compilation #################################################
##################################################################################################

alias ntm_vector_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_inverter.vhd
}

##################################################################################################
# ntm_vector_modular_divider_design_compilation ##################################################
##################################################################################################

alias ntm_vector_modular_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_divider.vhd
}

##################################################################################################
# ntm_vector_modular_exponentiator_design_compilation ############################################
##################################################################################################

alias ntm_vector_modular_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_exponentiator.vhd
}

##################################################################################################
# ntm_matrix_modular_mod_design_compilation ######################################################
##################################################################################################

alias ntm_matrix_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_mod.vhd
}

##################################################################################################
# ntm_matrix_modular_adder_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_adder.vhd
}

##################################################################################################
# ntm_matrix_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_matrix_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_multiplier.vhd
}

##################################################################################################
# ntm_matrix_modular_inverter_design_compilation #################################################
##################################################################################################

alias ntm_matrix_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_inverter.vhd
}

##################################################################################################
# ntm_matrix_modular_divider_design_compilation ##################################################
##################################################################################################

alias ntm_matrix_modular_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_divider.vhd
}

##################################################################################################
# ntm_matrix_modular_exponentiator_design_compilation ############################################
##################################################################################################

alias ntm_matrix_modular_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_exponentiator.vhd
}

##################################################################################################
# ntm_tensor_modular_mod_design_compilation ######################################################
##################################################################################################

alias ntm_tensor_modular_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_mod.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/tensor/ntm_tensor_modular_mod.vhd
}

##################################################################################################
# ntm_tensor_modular_adder_design_compilation ####################################################
##################################################################################################

alias ntm_tensor_modular_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/tensor/ntm_tensor_modular_adder.vhd
}

##################################################################################################
# ntm_tensor_modular_multiplier_design_compilation ###############################################
##################################################################################################

alias ntm_tensor_modular_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/tensor/ntm_tensor_modular_multiplier.vhd
}

##################################################################################################
# ntm_tensor_modular_inverter_design_compilation #################################################
##################################################################################################

alias ntm_tensor_modular_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/tensor/ntm_tensor_modular_inverter.vhd
}

##################################################################################################
# ntm_tensor_modular_divider_design_compilation ##################################################
##################################################################################################

alias ntm_tensor_modular_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/tensor/ntm_tensor_modular_divider.vhd
}

##################################################################################################
# ntm_tensor_modular_exponentiator_design_compilation ############################################
##################################################################################################

alias ntm_tensor_modular_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/scalar/ntm_scalar_modular_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/vector/ntm_vector_modular_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/matrix/ntm_matrix_modular_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/modular/tensor/ntm_tensor_modular_exponentiator.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_modular_mod_design_compilation 
}

alias d02 {
  ntm_scalar_modular_adder_design_compilation 
}

alias d03 {
  ntm_scalar_modular_multiplier_design_compilation 
}

alias d04 {
  ntm_scalar_modular_inverter_design_compilation 
}

alias d05 {
  ntm_scalar_modular_divider_design_compilation 
}

alias d06 {
  ntm_scalar_modular_exponentiator_design_compilation 
}

alias d07 {
  ntm_vector_modular_mod_design_compilation 
}

alias d08 {
  ntm_vector_modular_adder_design_compilation 
}

alias d09 {
  ntm_vector_modular_multiplier_design_compilation 
}

alias d10 {
  ntm_vector_modular_inverter_design_compilation 
}

alias d11 {
  ntm_vector_modular_divider_design_compilation 
}

alias d12 {
  ntm_vector_modular_exponentiator_design_compilation 
}

alias d13 {
  ntm_matrix_modular_mod_design_compilation 
}

alias d14 {
  ntm_matrix_modular_adder_design_compilation 
}

alias d15 {
  ntm_matrix_modular_multiplier_design_compilation 
}

alias d16 {
  ntm_matrix_modular_inverter_design_compilation 
}

alias d17 {
  ntm_matrix_modular_divider_design_compilation 
}

alias d18 {
  ntm_matrix_modular_exponentiator_design_compilation 
}

alias d19 {
  ntm_tensor_modular_mod_design_compilation 
}

alias d20 {
  ntm_tensor_modular_adder_design_compilation 
}

alias d21 {
  ntm_tensor_modular_multiplier_design_compilation 
}

alias d22 {
  ntm_tensor_modular_inverter_design_compilation 
}

alias d23 {
  ntm_tensor_modular_divider_design_compilation 
}

alias d24 {
  ntm_tensor_modular_exponentiator_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-MOD-TEST"
echo "d02 . NTM-SCALAR-ADDER-TEST"
echo "d03 . NTM-SCALAR-MULTIPLIER-TEST"
echo "d04 . NTM-SCALAR-INVERTER-TEST"
echo "d05 . NTM-SCALAR-DIVIDER-TEST"
echo "d06 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "d07 . NTM-VECTOR-MOD-TEST"
echo "d08 . NTM-VECTOR-ADDER-TEST"
echo "d09 . NTM-VECTOR-MULTIPLIER-TEST"
echo "d10 . NTM-VECTOR-INVERTER-TEST"
echo "d11 . NTM-VECTOR-DIVIDER-TEST"
echo "d12 . NTM-VECTOR-EXPONENTIATOR-TEST"
echo "d13 . NTM-MATRIX-MOD-TEST"
echo "d14 . NTM-MATRIX-ADDER-TEST"
echo "d15 . NTM-MATRIX-MULTIPLIER-TEST"
echo "d16 . NTM-MATRIX-INVERTER-TEST"
echo "d17 . NTM-MATRIX-DIVIDER-TEST"
echo "d18 . NTM-MATRIX-EXPONENTIATOR-TEST"
echo "d19 . NTM-TENSOR-MOD-TEST"
echo "d20 . NTM-TENSOR-ADDER-TEST"
echo "d21 . NTM-TENSOR-MULTIPLIER-TEST"
echo "d22 . NTM-TENSOR-INVERTER-TEST"
echo "d23 . NTM-TENSOR-DIVIDER-TEST"
echo "d24 . NTM-TENSOR-EXPONENTIATOR-TEST"
echo "****************************************"