#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# dnc_allocation_gate_design_compilation #########################################################
##################################################################################################

alias dnc_allocation_gate_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_allocation_gate.vhd
}

##################################################################################################
# dnc_erase_vector_design_compilation ############################################################
##################################################################################################

alias dnc_erase_vector_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_erase_vector.vhd
}

##################################################################################################
# dnc_write_gate_design_compilation ##############################################################
##################################################################################################

alias dnc_write_gate_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_write_gate.vhd
}

##################################################################################################
# dnc_write_key_design_compilation ###############################################################
##################################################################################################

alias dnc_write_key_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_write_key.vhd
}

##################################################################################################
# dnc_write_strength_design_compilation ##########################################################
##################################################################################################

alias dnc_write_strength_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_write_strength.vhd
}

##################################################################################################
# dnc_write_vector_design_compilation ############################################################
##################################################################################################

alias dnc_write_vector_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_write_vector.vhd
}

##################################################################################################

alias d01 {
  dnc_allocation_gate_design_compilation 
}

alias d02 {
  dnc_erase_vector_design_compilation 
}

alias d03 {
  dnc_write_gate_design_compilation 
}

alias d04 {
  dnc_write_key_design_compilation 
}

alias d05 {
  dnc_write_strength_design_compilation 
}

alias d06 {
  dnc_write_vector_design_compilation 
}

echo "****************************************"
echo "d01 . DNC-ALLOCATION-GATE-TEST"
echo "d02 . DNC-ERASE-VECTOR-TEST"
echo "d03 . DNC-WRITE-GATE-TEST"
echo "d04 . DNC-WRITE-KEY-TEST"
echo "d05 . DNC-WRITE-STRENGTH-TEST"
echo "d06 . DNC-WRITE-VECTOR-TEST"
echo "****************************************"