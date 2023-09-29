#*******************
# DESIGN COMPILATION
#*******************

do variables.do

vlib work

##################################################################################################
# model_scalar_cosh_function_design_compilation
##################################################################################################

alias model_scalar_cosh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_cosh_function.sv
}

##################################################################################################
# model_scalar_exponentiator_function_design_compilation
##################################################################################################

alias model_scalar_exponentiator_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.sv
}

##################################################################################################
# model_scalar_logarithm_function_design_compilation
##################################################################################################

alias model_scalar_logarithm_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.sv
}

##################################################################################################
# model_scalar_sinh_function_design_compilation
##################################################################################################

alias model_scalar_sinh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_sinh_function.sv
}

##################################################################################################
# model_scalar_tanh_function_design_compilation
##################################################################################################

alias model_scalar_tanh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_tanh_function.sv
}

##################################################################################################
# model_vector_cosh_function_design_compilation
##################################################################################################

alias model_vector_cosh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_cosh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_cosh_function.sv
}

##################################################################################################
# model_vector_exponentiator_function_design_compilation
##################################################################################################

alias model_vector_exponentiator_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_exponentiator_function.sv
}

##################################################################################################
# model_vector_logarithm_function_design_compilation
##################################################################################################

alias model_vector_logarithm_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_logarithm_function.sv
}

##################################################################################################
# model_vector_sinh_function_design_compilation
##################################################################################################

alias model_vector_sinh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_sinh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_sinh_function.sv
}

##################################################################################################
# model_vector_tanh_function_design_compilation
##################################################################################################

alias model_vector_tanh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_tanh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_tanh_function.sv
}

##################################################################################################
# model_matrix_cosh_function_design_compilation
##################################################################################################

alias model_matrix_cosh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_cosh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_cosh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_cosh_function.sv
}

##################################################################################################
# model_matrix_exponentiator_function_design_compilation
##################################################################################################

alias model_matrix_exponentiator_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_exponentiator_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_exponentiator_function.sv
}

##################################################################################################
# model_matrix_logarithm_function_design_compilation
##################################################################################################

alias model_matrix_logarithm_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_logarithm_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_logarithm_function.sv
}

##################################################################################################
# model_matrix_sinh_function_design_compilation
##################################################################################################

alias model_matrix_sinh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_sinh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_sinh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_sinh_function.sv
}

##################################################################################################
# model_matrix_tanh_function_design_compilation
##################################################################################################

alias model_matrix_tanh_function_design_compilation {
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_arithmetic_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/pkg/model_math_verilog_pkg.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/scalar/model_scalar_tanh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/vector/model_vector_tanh_function.sv
  vlog -sv -reportprogress 300 -work work $design_path/math/series/matrix/model_matrix_tanh_function.sv
}

##################################################################################################

alias d01 {
  model_scalar_cosh_function_design_compilation
}

alias d02 {
  model_scalar_exponentiator_function_design_compilation
}

alias d03 {
  model_scalar_logarithm_function_design_compilation
}

alias d04 {
  model_scalar_sinh_function_design_compilation
}

alias d05 {
  model_scalar_tanh_function_design_compilation
}

alias d06 {
  model_vector_cosh_function_design_compilation
}

alias d07 {
  model_vector_exponentiator_function_design_compilation
}

alias d08 {
  model_vector_logarithm_function_design_compilation
}

alias d09 {
  model_vector_sinh_function_design_compilation
}

alias d10 {
  model_vector_tanh_function_design_compilation
}

alias d11 {
  model_matrix_cosh_function_design_compilation
}

alias d12 {
  model_matrix_exponentiator_function_design_compilation
}

alias d13 {
  model_matrix_logarithm_function_design_compilation
}

alias d14 {
  model_matrix_sinh_function_design_compilation
}

alias d15 {
  model_matrix_tanh_function_design_compilation
}

echo "****************************************"
echo "d01 . ACCELERATOR-SCALAR-COSH-FUNCTION-TEST"
echo "d02 . ACCELERATOR-SCALAR-EXPONENTIATOR-FUNCTION-TEST"
echo "d03 . ACCELERATOR-SCALAR-LOGARITHM-FUNCTION-TEST"
echo "d04 . ACCELERATOR-SCALAR-SINH-FUNCTION-TEST"
echo "d05 . ACCELERATOR-SCALAR-TANH-FUNCTION-TEST"
echo "d06 . ACCELERATOR-VECTOR-COSH-FUNCTION-TEST"
echo "d07 . ACCELERATOR-VECTOR-EXPONENTIATOR-FUNCTION-TEST"
echo "d08 . ACCELERATOR-VECTOR-LOGARITHM-FUNCTION-TEST"
echo "d09 . ACCELERATOR-VECTOR-SINH-FUNCTION-TEST"
echo "d10 . ACCELERATOR-VECTOR-TANH-FUNCTION-TEST"
echo "d11 . ACCELERATOR-MATRIX-COSH-FUNCTION-TEST"
echo "d12 . ACCELERATOR-MATRIX-EXPONENTIATOR-FUNCTION-TEST"
echo "d13 . ACCELERATOR-MATRIX-LOGISTIC-FUNCTION-TEST"
echo "d14 . ACCELERATOR-MATRIX-SINH-FUNCTION-TEST"
echo "d15 . ACCELERATOR-MATRIX-TANH-FUNCTION-TEST"
echo "****************************************"
