#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# accelerator_scalar_float_adder_design_compilation ####################################################
##################################################################################################

alias accelerator_scalar_float_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
}

##################################################################################################
# accelerator_scalar_float_multiplier_design_compilation ###############################################
##################################################################################################

alias accelerator_scalar_float_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
}

##################################################################################################
# accelerator_scalar_float_divider_design_compilation ##################################################
##################################################################################################

alias accelerator_scalar_float_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
}

##################################################################################################
# accelerator_vector_float_adder_design_compilation ####################################################
##################################################################################################

alias accelerator_vector_float_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/vector/model_vector_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_adder.sv
}

##################################################################################################
# accelerator_vector_float_multiplier_design_compilation ###############################################
##################################################################################################

alias accelerator_vector_float_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/vector/model_vector_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_multiplier.sv
}

##################################################################################################
# accelerator_vector_float_divider_design_compilation ##################################################
##################################################################################################

alias accelerator_vector_float_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/vector/model_vector_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/vector/accelerator_vector_float_divider.sv
}

##################################################################################################
# accelerator_matrix_float_adder_design_compilation ####################################################
##################################################################################################

alias accelerator_matrix_float_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/matrix/model_matrix_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_adder.sv
}

##################################################################################################
# accelerator_matrix_float_multiplier_design_compilation ###############################################
##################################################################################################

alias accelerator_matrix_float_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/matrix/model_matrix_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_multiplier.sv
}

##################################################################################################
# accelerator_matrix_float_divider_design_compilation ##################################################
##################################################################################################

alias accelerator_matrix_float_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/matrix/model_matrix_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/matrix/accelerator_matrix_float_divider.sv
}

##################################################################################################
# accelerator_tensor_float_adder_design_compilation ####################################################
##################################################################################################

alias accelerator_tensor_float_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/tensor/model_tensor_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/tensor/accelerator_tensor_float_adder.sv
}

##################################################################################################
# accelerator_tensor_float_multiplier_design_compilation ###############################################
##################################################################################################

alias accelerator_tensor_float_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/tensor/model_tensor_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/tensor/accelerator_tensor_float_multiplier.sv
}

##################################################################################################
# accelerator_tensor_float_divider_design_compilation ##################################################
##################################################################################################

alias accelerator_tensor_float_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/scalar/model_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $model_path/arithmetic/float/tensor/model_tensor_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/tensor/accelerator_tensor_float_divider.sv
}

##################################################################################################

alias d01 {
  accelerator_scalar_float_adder_design_compilation 
}

alias d02 {
  accelerator_scalar_float_multiplier_design_compilation 
}

alias d03 {
  accelerator_scalar_float_divider_design_compilation 
}

alias d04 {
  accelerator_vector_float_adder_design_compilation 
}

alias d05 {
  accelerator_vector_float_multiplier_design_compilation 
}

alias d06 {
  accelerator_vector_float_divider_design_compilation 
}

alias d07 {
  accelerator_matrix_float_adder_design_compilation 
}

alias d08 {
  accelerator_matrix_float_multiplier_design_compilation 
}

alias d09 {
  accelerator_matrix_float_divider_design_compilation 
}

alias d10 {
  accelerator_tensor_float_adder_design_compilation 
}

alias d11 {
  accelerator_tensor_float_multiplier_design_compilation 
}

alias d12 {
  accelerator_tensor_float_divider_design_compilation 
}

echo "****************************************"
echo "d01 . ACCELERATOR-SCALAR-FLOAT-ADDER-TEST"
echo "d02 . ACCELERATOR-SCALAR-FLOAT-MULTIPLIER-TEST"
echo "d03 . ACCELERATOR-SCALAR-FLOAT-DIVIDER-TEST"
echo "d04 . ACCELERATOR-VECTOR-FLOAT-ADDER-TEST"
echo "d05 . ACCELERATOR-VECTOR-FLOAT-MULTIPLIER-TEST"
echo "d06 . ACCELERATOR-VECTOR-FLOAT-DIVIDER-TEST"
echo "d07 . ACCELERATOR-MATRIX-FLOAT-ADDER-TEST"
echo "d08 . ACCELERATOR-MATRIX-FLOAT-MULTIPLIER-TEST"
echo "d09 . ACCELERATOR-MATRIX-FLOAT-DIVIDER-TEST"
echo "d10 . ACCELERATOR-TENSOR-FLOAT-ADDER-TEST"
echo "d11 . ACCELERATOR-TENSOR-FLOAT-MULTIPLIER-TEST"
echo "d12 . ACCELERATOR-TENSOR-FLOAT-DIVIDER-TEST"
echo "****************************************"
