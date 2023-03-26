#*******************
# DESIGN COMPILATION
#*******************


do ./variables.do

vlib work

##################################################################################################
# model_memory_sort_vector_design_compilation ######################################################
##################################################################################################

alias model_memory_sort_vector_design_compilation {
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_arithmetic_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_math_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/pkg/model_dnc_core_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $design_path/dnc/memory/model_sort_vector.vhd
}

##################################################################################################

alias d01 {
  model_memory_sort_vector_design_compilation 
}

echo "****************************************"
echo "d01 . DNC-MEMORY-SORT-VECTOR-TEST"
echo "****************************************"