#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# model_scalar_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_scalar_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_adder.sv
}

##################################################################################################
# model_scalar_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_scalar_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_multiplier.sv
}

##################################################################################################
# model_scalar_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_scalar_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_divider.sv
}

##################################################################################################
# model_vector_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_vector_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/vector/model_vector_integer_adder.sv
}

##################################################################################################
# model_vector_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_vector_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/vector/model_vector_integer_multiplier.sv
}

##################################################################################################
# model_vector_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_vector_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/vector/model_vector_integer_divider.sv
}

##################################################################################################
# model_matrix_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_matrix_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/model_matrix_integer_adder.sv
}

##################################################################################################
# model_matrix_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_matrix_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/model_matrix_integer_multiplier.sv
}

##################################################################################################
# model_matrix_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_matrix_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/matrix/model_matrix_integer_divider.sv
}

##################################################################################################
# model_tensor_integer_adder_design_compilation ####################################################
##################################################################################################

alias model_tensor_integer_adder_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/model_tensor_integer_adder.sv
}

##################################################################################################
# model_tensor_integer_multiplier_design_compilation ###############################################
##################################################################################################

alias model_tensor_integer_multiplier_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/model_tensor_integer_multiplier.sv
}

##################################################################################################
# model_tensor_integer_divider_design_compilation ##################################################
##################################################################################################

alias model_tensor_integer_divider_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/scalar/model_scalar_integer_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/integer/tensor/model_tensor_integer_divider.sv
}

##################################################################################################

alias d01 {
  model_scalar_integer_adder_design_compilation 
}

alias d02 {
  model_scalar_integer_multiplier_design_compilation 
}

alias d03 {
  model_scalar_integer_divider_design_compilation 
}

alias d04 {
  model_vector_integer_adder_design_compilation 
}

alias d05 {
  model_vector_integer_multiplier_design_compilation 
}

alias d06 {
  model_vector_integer_divider_design_compilation 
}

alias d07 {
  model_matrix_integer_adder_design_compilation 
}

alias d08 {
  model_matrix_integer_multiplier_design_compilation 
}

alias d09 {
  model_matrix_integer_divider_design_compilation 
}

alias d10 {
  model_tensor_integer_adder_design_compilation 
}

alias d11 {
  model_tensor_integer_multiplier_design_compilation 
}

alias d12 {
  model_tensor_integer_divider_design_compilation 
}

echo "****************************************"
echo "d01 . ACCELERATOR-SCALAR-ADDER-TEST"
echo "d02 . ACCELERATOR-SCALAR-MULTIPLIER-TEST"
echo "d03 . ACCELERATOR-SCALAR-DIVIDER-TEST"
echo "d04 . ACCELERATOR-VECTOR-ADDER-TEST"
echo "d05 . ACCELERATOR-VECTOR-MULTIPLIER-TEST"
echo "d06 . ACCELERATOR-VECTOR-DIVIDER-TEST"
echo "d07 . ACCELERATOR-MATRIX-ADDER-TEST"
echo "d08 . ACCELERATOR-MATRIX-MULTIPLIER-TEST"
echo "d09 . ACCELERATOR-MATRIX-DIVIDER-TEST"
echo "d10 . ACCELERATOR-TENSOR-ADDER-TEST"
echo "d11 . ACCELERATOR-TENSOR-MULTIPLIER-TEST"
echo "d12 . ACCELERATOR-TENSOR-DIVIDER-TEST"
echo "****************************************"