#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# dnc_memory_sort_vector_design_compilation ######################################################
##################################################################################################

alias dnc_memory_sort_vector_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/ntm_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/memory/dnc_sort_vector.vhd
}

##################################################################################################

alias d01 {
  dnc_memory_sort_vector_design_compilation 
}

echo "****************************************"
echo "d01 . DNC-MEMORY-SORT-VECTOR-TEST"
echo "****************************************"