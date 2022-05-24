#*************************
# VERIFICATION
#*************************


do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# DNC_FREE_GATES_TEST 
##################################################################################################

alias dnc_free_gates_verification_compilation {
  echo "TEST: DNC_FREE_GATES_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_testbench.vhd

  vsim -g /dnc_read_heads_testbench/ENABLE_DNC_FREE_GATES_TEST=true -t ps +notimingchecks -L unisim work.dnc_read_heads_testbench

  #MACROS
  add log -r sim:/dnc_read_heads_testbench/*

  #WAVES
  view -title dnc_free_gates wave
  do $simulation_path/mpsoc/dnc/read_heads/msim/waves/dnc_free_gates.do

  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_FREE_GATES_TEST true 0
  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_FREE_GATES_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim dnc_free_gates_test.wlf
}

##################################################################################################
# DNC_READ_KEYS_TEST 
##################################################################################################

alias dnc_read_keys_verification_compilation {
  echo "TEST: DNC_READ_KEYS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_testbench.vhd

  vsim -g /dnc_read_heads_testbench/ENABLE_DNC_READ_KEYS_TEST=true -t ps +notimingchecks -L unisim work.dnc_read_heads_testbench

  #MACROS
  add log -r sim:/dnc_read_heads_testbench/*

  #WAVES
  view -title dnc_read_keys wave
  do $simulation_path/mpsoc/dnc/read_heads/msim/waves/dnc_read_keys.do

  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_READ_KEYS_TEST true 0
  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_READ_KEYS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim dnc_read_keys_test.wlf
}

##################################################################################################
# DNC_READ_MODES_TEST 
##################################################################################################

alias dnc_read_modes_verification_compilation {
  echo "TEST: DNC_READ_MODES_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_testbench.vhd

  vsim -g /dnc_read_heads_testbench/ENABLE_DNC_READ_MODES_TEST=true -t ps +notimingchecks -L unisim work.dnc_read_heads_testbench

  #MACROS
  add log -r sim:/dnc_read_heads_testbench/*

  #WAVES
  view -title dnc_read_modes wave
  do $simulation_path/mpsoc/dnc/read_heads/msim/waves/dnc_read_modes.do

  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_READ_MODES_TEST true 0
  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_READ_MODES_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim dnc_read_modes_test.wlf
}

##################################################################################################
# DNC_READ_STRENGTHS_TEST 
##################################################################################################

alias dnc_read_strengths_verification_compilation {
  echo "TEST: DNC_READ_STRENGTHS_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/dnc/read_heads/dnc_read_heads_testbench.vhd

  vsim -g /dnc_read_heads_testbench/ENABLE_DNC_READ_STRENGTHS_TEST=true -t ps +notimingchecks -L unisim work.dnc_read_heads_testbench

  #MACROS
  add log -r sim:/dnc_read_heads_testbench/*

  #WAVES
  view -title dnc_read_strengths wave
  do $simulation_path/mpsoc/dnc/read_heads/msim/waves/dnc_read_strengths.do

  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_READ_STRENGTHS_TEST true 0
  force -freeze sim:/dnc_read_heads_pkg/STIMULUS_DNC_READ_STRENGTHS_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim dnc_read_strengths_test.wlf
}

##################################################################################################

alias v01 {
  dnc_free_gates_verification_compilation 
}

alias v02 {
  dnc_read_keys_verification_compilation 
}

alias v03 {
  dnc_read_modes_verification_compilation 
}

alias v04 {
  dnc_read_strengths_verification_compilation 
}

echo "****************************************"
echo "v01 . DNC-FREE-GATES-TEST"
echo "v02 . DNC-READ-KEYS-TEST"
echo "v03 . DNC-READ-MODES-TEST"
echo "v04 . DNC-READ-STRENGTHS-TEST"
echo "****************************************"