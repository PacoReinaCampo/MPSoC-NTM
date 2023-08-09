#*************************
# VERIFICATION
#*************************

do ./variables.do

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_STANDARD_LSTM_TEST 
##################################################################################################

alias accelerator_standard_lstm_verification_compilation {
  echo "TEST: ACCELERATOR_STANDARD_LSTM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/controller/LSTM/standard/accelerator_standard_lstm_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/controller/LSTM/standard/accelerator_standard_lstm_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/controller/LSTM/standard/accelerator_standard_lstm_testbench.vhd

  vsim -g /accelerator_standard_lstm_testbench/ENABLE_ACCELERATOR_STANDARD_LSTM_TEST=true -t ps +notimingchecks -L unisim work.accelerator_standard_lstm_testbench

  #MACROS
  add log -r sim:/accelerator_standard_lstm_testbench/*

  #WAVES
  view -title accelerator_standard_lstm wave
  do $simulation_path/controller/LSTM/standard/msim/waves/accelerator_standard_lstm.do

  force -freeze sim:/accelerator_standard_lstm_pkg/STIMULUS_ACCELERATOR_STANDARD_LSTM_TEST true 0
  force -freeze sim:/accelerator_standard_lstm_pkg/STIMULUS_ACCELERATOR_STANDARD_LSTM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim accelerator_standard_lstm_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_standard_lstm_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-STANDARD-LSTM-TEST"
echo "****************************************"
