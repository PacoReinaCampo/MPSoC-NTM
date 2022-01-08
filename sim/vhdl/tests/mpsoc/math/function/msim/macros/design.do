#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_sinh_function_design_compilation ####################################################
##################################################################################################

alias ntm_scalar_sinh_function_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/function/scalar/ntm_scalar_sinh_function.vhd
}

##################################################################################################

alias d01 {
  ntm_scalar_sinh_function_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-SINH-FUNCTION-TEST"
echo "****************************************"