#*************************
# VERIFICATION
#*************************


do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# DNC_WRITE_VECTOR_TEST 
##################################################################################################

alias dnc_write_vector_verification_compilation {
  echo "TEST: DNC_WRITE_VECTOR_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/write_heads/dnc_write_heads_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/write_heads/dnc_write_heads_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/write_heads/dnc_write_heads_testbench.vhd

  vsim -g /dnc_write_heads_testbench/ENABLE_DNC_WRITE_VECTOR_TEST=true -t ps +notimingchecks -L unisim work.dnc_write_heads_testbench

  #MACROS
  add log -r sim:/dnc_write_heads_testbench/*

  #WAVES
  view -title dnc_write_vector wave
  do $simulation_path/mpsoc/dnc/write_heads/msim/waves/dnc_write_vector.do

  force -freeze sim:/dnc_write_heads_pkg/STIMULUS_DNC_WRITE_VECTOR_TEST true 0
  force -freeze sim:/dnc_write_heads_pkg/STIMULUS_DNC_WRITE_VECTOR_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim dnc_write_vector_test.wlf
}

##################################################################################################

alias v01 {
  dnc_write_vector_verification_compilation 
}

echo "************************************************************"
echo "v01 . DNC-WRITE-VECTOR-TEST"
echo "************************************************************"