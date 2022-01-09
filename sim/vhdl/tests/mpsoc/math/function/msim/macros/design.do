#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_cosh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_cosh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_cosh_function.vhd
}

##################################################################################################
# ntm_scalar_exponentiator_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_exponentiator_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
}

##################################################################################################
# ntm_scalar_logarithm_function_design_compilation ###############################################
##################################################################################################

alias ntm_scalar_logarithm_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logarithm_function.vhd
}

##################################################################################################
# ntm_scalar_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
}

##################################################################################################
# ntm_scalar_tanh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_tanh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/float/scalar/ntm_scalar_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_exponentiator.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_tanh_function.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_cosh_function_design_compilation 
}

alias d02 {
  ntm_scalar_exponentiator_design_compilation 
}

alias d03 {
  ntm_scalar_logarithm_function_design_compilation 
}

alias d04 {
  ntm_scalar_sinh_function_design_compilation 
}

alias d05 {
  ntm_scalar_tanh_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-COSH-FUNCTION-TEST"
echo "d02 . NTM-SCALAR-EXPONENTIATOR-TEST"
echo "d03 . NTM-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "d04 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "d05 . NTM-SCALAR-TANH-FUNCTION-TEST"
echo "****************************************"