#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# model_free_gates_design_compilation ##############################################################
##################################################################################################

alias model_free_gates_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_logistic_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/model_free_gates.vhd
}

##################################################################################################
# model_read_keys_design_compilation ###############################################################
##################################################################################################

alias model_read_keys_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/model_read_keys.vhd
}

##################################################################################################
# model_read_modes_design_compilation ##############################################################
##################################################################################################

alias model_read_modes_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_softmax.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/model_read_modes.vhd
}

##################################################################################################
# model_read_strengths_design_compilation ##########################################################
##################################################################################################

alias model_read_strengths_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/model_scalar_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/vector/model_vector_oneplus_function.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/read_heads/model_read_strengths.vhd
}

##################################################################################################

alias d01 {
  model_free_gates_design_compilation 
}

alias d02 {
  model_read_keys_design_compilation 
}

alias d03 {
  model_read_modes_design_compilation 
}

alias d04 {
  model_read_strengths_design_compilation 
}

echo "****************************************"
echo "d01 . DNC-FREE-GATES-TEST"
echo "d02 . DNC-READ-KEYS-TEST"
echo "d03 . DNC-READ-MODES-TEST"
echo "d04 . DNC-READ-STRENGTHS-TEST"
echo "****************************************"