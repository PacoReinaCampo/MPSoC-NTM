#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_vector_differentiation_design_compilation ##################################################
##################################################################################################

alias ntm_vector_differentiation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/ntm_vector_differentiation.vhd
}

##################################################################################################
# ntm_vector_integration_design_compilation ######################################################
##################################################################################################

alias ntm_vector_integration_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/ntm_vector_integration.vhd
}

##################################################################################################
# ntm_vector_softmax_design_compilation ##########################################################
##################################################################################################

alias ntm_vector_softmax_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/vector/ntm_vector_softmax.vhd
}

##################################################################################################
# ntm_matrix_differentiation_design_compilation ##################################################
##################################################################################################

alias ntm_matrix_differentiation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/ntm_matrix_differentiation.vhd
}

##################################################################################################
# ntm_matrix_integration_design_compilation ######################################################
##################################################################################################

alias ntm_matrix_integration_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/ntm_matrix_integration.vhd
}

##################################################################################################
# ntm_matrix_softmax_design_compilation ##########################################################
##################################################################################################

alias ntm_matrix_softmax_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/matrix/ntm_matrix_softmax.vhd
}

##################################################################################################
# ntm_tensor_differentiation_design_compilation ##################################################
##################################################################################################

alias ntm_tensor_differentiation_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_divider.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/ntm_tensor_differentiation.vhd
}

##################################################################################################
# ntm_tensor_integration_design_compilation ######################################################
##################################################################################################

alias ntm_tensor_integration_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/ntm_tensor_integration.vhd
}

##################################################################################################
# ntm_tensor_softmax_design_compilation ##########################################################
##################################################################################################

alias ntm_tensor_softmax_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_adder.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/arithmetic/float/scalar/ntm_scalar_float_multiplier.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/calculus/tensor/ntm_tensor_softmax.vhd
}

##################################################################################################

alias d01 {
  ntm_vector_differentiation_design_compilation
}

alias d02 {
  ntm_vector_integration_design_compilation
}

alias d03 {
  ntm_vector_softmax_design_compilation
}

alias d04 {
  ntm_matrix_differentiation_design_compilation
}

alias d05 {
  ntm_matrix_integration_design_compilation
}

alias d06 {
  ntm_matrix_softmax_design_compilation
}

alias d07 {
  ntm_tensor_differentiation_design_compilation
}

alias d08 {
  ntm_tensor_integration_design_compilation
}

alias d09 {
  ntm_tensor_softmax_design_compilation
}

echo "****************************************"
echo "d01 . NTM-VECTOR-DIFFERENTIATION-TEST"
echo "d02 . NTM-VECTOR-INTEGRATION-TEST"
echo "d03 . NTM-VECTOR-SOFTMAX-TEST"
echo "d04 . NTM-MATRIX-DIFFERENTIATION-TEST"
echo "d05 . NTM-MATRIX-INTEGRATION-TEST"
echo "d06 . NTM-MATRIX-SOFTMAX-TEST"
echo "d07 . NTM-TENSOR-DIFFERENTIATION-TEST"
echo "d08 . NTM-TENSOR-INTEGRATION-TEST"
echo "d09 . NTM-TENSOR-SOFTMAX-TEST"
echo "****************************************"