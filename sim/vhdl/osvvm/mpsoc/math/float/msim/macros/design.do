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
##################################################################################################

  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
}

##################################################################################################
# ntm_scalar_divider_design_compilation ##########################################################
##################################################################################################

alias ntm_scalar_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
}

##################################################################################################
##################################################################################################

  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
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
##################################################################################################

  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
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
##################################################################################################

  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_adder_design_compilation 
}

alias d02 {
  ntm_scalar_multiplier_design_compilation 
}

alias d03 {
}

alias d04 {
  ntm_scalar_divider_design_compilation 
}

alias d05 {
}

alias d06 {
  ntm_vector_adder_design_compilation 
}

alias d07 {
  ntm_vector_multiplier_design_compilation 
}

alias d08 {
}

alias d09 {
  ntm_vector_divider_design_compilation 
}

alias d10 {
}

echo "****************************************"
echo "d01 . NTM-SCALAR-ADDER-TEST"
echo "d02 . NTM-SCALAR-MULTIPLIER-TEST"
echo "d04 . NTM-SCALAR-DIVIDER-TEST"
echo "d06 . NTM-VECTOR-ADDER-TEST"
echo "d07 . NTM-VECTOR-MULTIPLIER-TEST"
echo "d09 . NTM-VECTOR-DIVIDER-TEST"
echo "****************************************"