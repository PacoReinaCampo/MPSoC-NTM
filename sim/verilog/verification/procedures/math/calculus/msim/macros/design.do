#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# accelerator_vector_differentiation_design_compilation ##################################################
##################################################################################################

alias accelerator_vector_differentiation_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/vector/model_vector_differentiation.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_differentiation.sv
}

##################################################################################################
# accelerator_vector_integration_design_compilation ######################################################
##################################################################################################

alias accelerator_vector_integration_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/vector/model_vector_integration.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_integration.sv
}

##################################################################################################
# accelerator_vector_softmax_design_compilation ##########################################################
##################################################################################################

alias accelerator_vector_softmax_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/vector/model_vector_softmax.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/vector/accelerator_vector_softmax.sv
}

##################################################################################################
# accelerator_matrix_differentiation_design_compilation ##################################################
##################################################################################################

alias accelerator_matrix_differentiation_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/matrix/model_matrix_differentiation.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_differentiation.sv
}

##################################################################################################
# accelerator_matrix_integration_design_compilation ######################################################
##################################################################################################

alias accelerator_matrix_integration_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/matrix/model_matrix_integration.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_integration.sv
}

##################################################################################################
# accelerator_matrix_softmax_design_compilation ##########################################################
##################################################################################################

alias accelerator_matrix_softmax_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/matrix/model_matrix_softmax.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/matrix/accelerator_matrix_softmax.sv
}

##################################################################################################
# accelerator_tensor_differentiation_design_compilation ##################################################
##################################################################################################

alias accelerator_tensor_differentiation_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/tensor/model_tensor_differentiation.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_differentiation.sv
}

##################################################################################################
# accelerator_tensor_integration_design_compilation ######################################################
##################################################################################################

alias accelerator_tensor_integration_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/tensor/model_tensor_integration.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_integration.sv
}

##################################################################################################
# accelerator_tensor_softmax_design_compilation ##########################################################
##################################################################################################

alias accelerator_tensor_softmax_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/calculus/tensor/model_tensor_softmax.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/calculus/tensor/accelerator_tensor_softmax.sv
}

##################################################################################################

alias d01 {
  accelerator_vector_differentiation_design_compilation
}

alias d02 {
  accelerator_vector_integration_design_compilation
}

alias d03 {
  accelerator_vector_softmax_design_compilation
}

alias d04 {
  accelerator_matrix_differentiation_design_compilation
}

alias d05 {
  accelerator_matrix_integration_design_compilation
}

alias d06 {
  accelerator_matrix_softmax_design_compilation
}

alias d07 {
  accelerator_tensor_differentiation_design_compilation
}

alias d08 {
  accelerator_tensor_integration_design_compilation
}

alias d09 {
  accelerator_tensor_softmax_design_compilation
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
