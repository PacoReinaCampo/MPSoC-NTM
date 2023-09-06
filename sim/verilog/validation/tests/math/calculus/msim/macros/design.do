#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# model_vector_differentiation_design_compilation ##################################################
##################################################################################################

alias model_vector_differentiation_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_differentiation.sv
}

##################################################################################################
# model_vector_integration_design_compilation ######################################################
##################################################################################################

alias model_vector_integration_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_integration.sv
}

##################################################################################################
# model_vector_softmax_design_compilation ##########################################################
##################################################################################################

alias model_vector_softmax_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/model_vector_softmax.sv
}

##################################################################################################
# model_matrix_differentiation_design_compilation ##################################################
##################################################################################################

alias model_matrix_differentiation_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_differentiation.sv
}

##################################################################################################
# model_matrix_integration_design_compilation ######################################################
##################################################################################################

alias model_matrix_integration_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_integration.sv
}

##################################################################################################
# model_matrix_softmax_design_compilation ##########################################################
##################################################################################################

alias model_matrix_softmax_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/model_matrix_softmax.sv
}

##################################################################################################
# model_tensor_differentiation_design_compilation ##################################################
##################################################################################################

alias model_tensor_differentiation_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_differentiation.sv
}

##################################################################################################
# model_tensor_integration_design_compilation ######################################################
##################################################################################################

alias model_tensor_integration_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_integration.sv
}

##################################################################################################
# model_tensor_softmax_design_compilation ##########################################################
##################################################################################################

alias model_tensor_softmax_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/model_tensor_softmax.sv
}

##################################################################################################

alias d01 {
  model_vector_differentiation_design_compilation
}

alias d02 {
  model_vector_integration_design_compilation
}

alias d03 {
  model_vector_softmax_design_compilation
}

alias d04 {
  model_matrix_differentiation_design_compilation
}

alias d05 {
  model_matrix_integration_design_compilation
}

alias d06 {
  model_matrix_softmax_design_compilation
}

alias d07 {
  model_tensor_differentiation_design_compilation
}

alias d08 {
  model_tensor_integration_design_compilation
}

alias d09 {
  model_tensor_softmax_design_compilation
}

echo "****************************************"
echo "d01 . ACCELERATOR-VECTOR-DIFFERENTIATION-TEST"
echo "d02 . ACCELERATOR-VECTOR-INTEGRATION-TEST"
echo "d03 . ACCELERATOR-VECTOR-SOFTMAX-TEST"
echo "d04 . ACCELERATOR-MATRIX-DIFFERENTIATION-TEST"
echo "d05 . ACCELERATOR-MATRIX-INTEGRATION-TEST"
echo "d06 . ACCELERATOR-MATRIX-SOFTMAX-TEST"
echo "d07 . ACCELERATOR-TENSOR-DIFFERENTIATION-TEST"
echo "d08 . ACCELERATOR-TENSOR-INTEGRATION-TEST"
echo "d09 . ACCELERATOR-TENSOR-SOFTMAX-TEST"
echo "****************************************"