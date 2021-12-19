#*******************
# DESIGN COMPILATION
#*******************

# MODELSIM 10.4d

do ./variables.do

vlib work

##################################################################################################
# ntm_scalar_mod_design_compilation ##############################################################
##################################################################################################

alias ntm_scalar_mod_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/math/arithmetic/scalar/ntm_scalar_mod.vhd
}

##################################################################################################

alias d1 {
  ntm_scalar_mod_design_compilation 
}

echo "****************************************"
echo "d01 . NTM-SCALAR-MOD-TEST"
echo "****************************************"