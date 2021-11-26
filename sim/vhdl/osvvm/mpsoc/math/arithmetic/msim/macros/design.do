#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_mod_design_compilation ##############################################################
##################################################################################################

alias ntm_scalar_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_mod.vhd
}

##################################################################################################
# ntm_scalar_adder_design_compilation ############################################################
##################################################################################################

alias ntm_scalar_adder_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_adder.vhd
}

##################################################################################################
# ntm_scalar_multiplier_design_compilation #######################################################
##################################################################################################

alias ntm_scalar_multiplier_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_multiplier.vhd
}

##################################################################################################
# ntm_scalar_inverter_design_compilation #########################################################
##################################################################################################

alias ntm_scalar_inverter_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_inverter.vhd
}

##################################################################################################
# ntm_scalar_divider_design_compilation ##########################################################
##################################################################################################

alias ntm_scalar_divider_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_divider.vhd
}

##################################################################################################
# ntm_scalar_exponentiator_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_exponentiator.vhd
}

##################################################################################################
# ntm_scalar_lcm_design_compilation ##############################################################
##################################################################################################

alias ntm_scalar_lcm_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_lcm.vhd
}

##################################################################################################
# ntm_scalar_gcd_design_compilation ##############################################################
##################################################################################################

alias ntm_scalar_gcd_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_gcd.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_mod_design_compilation 
}

alias d02 {
  ntm_scalar_adder_design_compilation 
}

alias d03 {
  ntm_scalar_multiplier_design_compilation 
}

alias d04 {
  ntm_scalar_inverter_design_compilation 
}

alias d05 {
  ntm_scalar_divider_design_compilation 
}

alias d06 {
  ntm_scalar_exponentiator_design_compilation 
}

alias d07 {
  ntm_scalar_lcm_design_compilation 
}

alias d08 {
  ntm_scalar_gcd_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-MOD-TEST"
echo "d02 . NTM-SCALAR-ADDER-TEST"
echo "d03 . NTM-SCALAR-MULTIPLIER-TEST"
echo "d04 . NTM-SCALAR-INVERTER-TEST"
echo "d05 . NTM-SCALAR-DIVIDER-TEST"
echo "d06 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "d07 . NTM-SCALAR-LCM-TEST"
echo "d08 . NTM-SCALAR-GCD-TEST"
echo "****************************************"