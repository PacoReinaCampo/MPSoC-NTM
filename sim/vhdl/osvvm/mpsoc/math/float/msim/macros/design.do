#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_adder_design_compilation ############################################################
##################################################################################################

alias ntm_scalar_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
}

##################################################################################################
# ntm_scalar_multiplier_design_compilation #######################################################
##################################################################################################

alias ntm_scalar_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
}

##################################################################################################
# ntm_scalar_inverter_design_compilation #########################################################
##################################################################################################

alias ntm_scalar_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_inverter.vhd
}

##################################################################################################
# ntm_scalar_divider_design_compilation ##########################################################
##################################################################################################

alias ntm_scalar_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
}

##################################################################################################
# ntm_scalar_exponentiator_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_exponentiator.vhd
}

##################################################################################################
# ntm_vector_adder_design_compilation ############################################################
##################################################################################################

alias ntm_vector_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/vector/ntm_vector_adder.vhd
}

##################################################################################################
# ntm_vector_multiplier_design_compilation #######################################################
##################################################################################################

alias ntm_vector_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/vector/ntm_vector_multiplier.vhd
}

##################################################################################################
# ntm_vector_inverter_design_compilation #########################################################
##################################################################################################

alias ntm_vector_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_inverter.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/vector/ntm_vector_inverter.vhd
}

##################################################################################################
# ntm_vector_divider_design_compilation ##########################################################
##################################################################################################

alias ntm_vector_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/vector/ntm_vector_divider.vhd
}

##################################################################################################
# ntm_vector_exponentiator_design_compilation ####################################################
##################################################################################################

alias ntm_vector_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/vector/ntm_vector_exponentiator.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_adder_design_compilation 
}

alias d02 {
  ntm_scalar_multiplier_design_compilation 
}

alias d03 {
  ntm_scalar_inverter_design_compilation 
}

alias d04 {
  ntm_scalar_divider_design_compilation 
}

alias d05 {
  ntm_scalar_exponentiator_design_compilation 
}

alias d06 {
  ntm_vector_adder_design_compilation 
}

alias d07 {
  ntm_vector_multiplier_design_compilation 
}

alias d08 {
  ntm_vector_inverter_design_compilation 
}

alias d09 {
  ntm_vector_divider_design_compilation 
}

alias d10 {
  ntm_vector_exponentiator_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-ADDER-TEST"
echo "d02 . NTM-SCALAR-MULTIPLIER-TEST"
echo "d03 . NTM-SCALAR-INVERTER-TEST"
echo "d04 . NTM-SCALAR-DIVIDER-TEST"
echo "d05 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "d06 . NTM-VECTOR-ADDER-TEST"
echo "d07 . NTM-VECTOR-MULTIPLIER-TEST"
echo "d08 . NTM-VECTOR-INVERTER-TEST"
echo "d09 . NTM-VECTOR-DIVIDER-TEST"
echo "d10 . NTM-VECTOR-EXPONENTIATOR-TEST"
echo "****************************************"