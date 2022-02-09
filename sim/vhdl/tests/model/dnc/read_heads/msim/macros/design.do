#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# dnc_free_gates_design_compilation ##############################################################
##################################################################################################

alias dnc_free_gates_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/dnc_free_gates.vhd
}

##################################################################################################
# dnc_read_keys_design_compilation ###############################################################
##################################################################################################

alias dnc_read_keys_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/dnc_read_keys.vhd
}

##################################################################################################
# dnc_read_modes_design_compilation ##############################################################
##################################################################################################

alias dnc_read_modes_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/ntm_matrix_softmax.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/dnc_read_modes.vhd
}

##################################################################################################
# dnc_read_strengths_design_compilation ##########################################################
##################################################################################################

alias dnc_read_strengths_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/ntm_scalar_integer_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/ntm_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/ntm_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/dnc_read_strengths.vhd
}

##################################################################################################

alias d01 {
  dnc_free_gates_design_compilation 
}

alias d02 {
  dnc_read_keys_design_compilation 
}

alias d03 {
  dnc_read_modes_design_compilation 
}

alias d04 {
  dnc_read_strengths_design_compilation 
}

echo "****************************************"
echo "d01 . DNC-FREE-GATES-TEST"
echo "d02 . DNC-READ-KEYS-TEST"
echo "d03 . DNC-READ-MODES-TEST"
echo "d04 . DNC-READ-STRENGTHS-TEST"
echo "****************************************"