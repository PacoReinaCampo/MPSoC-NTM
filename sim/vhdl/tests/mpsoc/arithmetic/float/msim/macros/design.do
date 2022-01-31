#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_float_adder_design_compilation ######################################################
##################################################################################################

alias ntm_scalar_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
}

##################################################################################################
# ntm_scalar_float_multiplier_design_compilation #################################################
##################################################################################################

alias ntm_scalar_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
}

##################################################################################################
# ntm_scalar_float_divider_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
}

##################################################################################################
# ntm_vector_float_adder_design_compilation ######################################################
##################################################################################################

alias ntm_vector_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_adder.vhd
}

##################################################################################################
# ntm_vector_float_multiplier_design_compilation #################################################
##################################################################################################

alias ntm_vector_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
}

##################################################################################################
# ntm_vector_float_divider_design_compilation ####################################################
##################################################################################################

alias ntm_vector_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_divider.vhd
}

##################################################################################################
# ntm_matrix_float_adder_design_compilation ######################################################
##################################################################################################

alias ntm_matrix_float_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/ntm_matrix_float_adder.vhd
}

##################################################################################################
# ntm_matrix_float_multiplier_design_compilation #################################################
##################################################################################################

alias ntm_matrix_float_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/ntm_matrix_float_multiplier.vhd
}

##################################################################################################
# ntm_matrix_float_divider_design_compilation ####################################################
##################################################################################################

alias ntm_matrix_float_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/vector/ntm_vector_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/matrix/ntm_matrix_float_divider.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_float_adder_design_compilation 
}

alias d02 {
  ntm_scalar_float_multiplier_design_compilation 
}

alias d03 {
  ntm_scalar_float_divider_design_compilation 
}

alias d04 {
  ntm_vector_float_adder_design_compilation 
}

alias d05 {
  ntm_vector_float_multiplier_design_compilation 
}

alias d06 {
  ntm_vector_float_divider_design_compilation 
}

alias d07 {
  ntm_matrix_float_adder_design_compilation 
}

alias d08 {
  ntm_matrix_float_multiplier_design_compilation 
}

alias d09 {
  ntm_matrix_float_divider_design_compilation 
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
echo "****************************************"