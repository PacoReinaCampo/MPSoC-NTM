#*******************
# DESIGN COMPILATION
#*******************

do ./variables.do

vlib work

##################################################################################################
# accelerator_scalar_logistic_function_design_compilation ########################################
##################################################################################################

alias accelerator_scalar_logistic_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/scalar/model_scalar_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.sv
}

##################################################################################################
# accelerator_scalar_oneplus_function_design_compilation #########################################
##################################################################################################

alias accelerator_scalar_oneplus_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/scalar/model_scalar_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.sv
}

##################################################################################################
# accelerator_vector_logistic_function_design_compilation ########################################
##################################################################################################

alias accelerator_vector_logistic_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/scalar/model_scalar_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/vector/model_vector_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_logistic_function.sv
}

##################################################################################################
# accelerator_vector_oneplus_function_design_compilation #########################################
##################################################################################################

alias accelerator_vector_oneplus_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/scalar/model_scalar_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/vector/model_vector_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_oneplus_function.sv
}

##################################################################################################
# accelerator_matrix_logistic_function_design_compilation ########################################
##################################################################################################

alias accelerator_matrix_logistic_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/scalar/model_scalar_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/vector/model_vector_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/matrix/model_matrix_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_logistic_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_logistic_function.sv
}

##################################################################################################
# accelerator_matrix_oneplus_function_design_compilation #########################################
##################################################################################################

alias accelerator_matrix_oneplus_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_arithmetic_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/pkg/model_math_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/accelerator_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/scalar/model_scalar_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/vector/model_vector_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $model_path/math/function/matrix/model_matrix_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_adder.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_multiplier.sv
  vlog -sv -reportprogress 300 -work work $design_path/arithmetic/float/scalar/accelerator_scalar_float_divider.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/accelerator_scalar_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/scalar/accelerator_scalar_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/vector/accelerator_vector_oneplus_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/function/matrix/accelerator_matrix_oneplus_function.sv
}

##################################################################################################

alias d01 {
  accelerator_scalar_logistic_function_design_compilation 
}

alias d02 {
  accelerator_scalar_oneplus_function_design_compilation 
}

alias d03 {
  accelerator_vector_logistic_function_design_compilation 
}

alias d04 {
  accelerator_vector_oneplus_function_design_compilation 
}

alias d05 {
  accelerator_matrix_logistic_function_design_compilation 
}

alias d06 {
  accelerator_matrix_oneplus_function_design_compilation 
}

echo "****************************************"
echo "d01 . ACCELERATOR-SCALAR-LOGISTIC-FUNCTION-TEST"
echo "d02 . ACCELERATOR-SCALAR-ONEPLUS-FUNCTION-TEST"
echo "d03 . ACCELERATOR-VECTOR-LOGISTIC-FUNCTION-TEST"
echo "d04 . ACCELERATOR-VECTOR-ONEPLUS-FUNCTION-TEST"
echo "d05 . ACCELERATOR-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d06 . ACCELERATOR-MATRIX-ONEPLUS-FUNCTION-TEST"
echo "****************************************"
