#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# dnc_write_vector_design_compilation ############################################################
##################################################################################################

alias dnc_write_vector_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/write_heads/dnc_write_vector.vhd
}

##################################################################################################

alias d01 {
  dnc_write_vector_design_compilation 
}

echo "****************************************"
echo "d01 . DNC-WRITE-VECTOR-TEST"
echo "****************************************"