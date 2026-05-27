#*************************
# VERIFICATION
#*************************

do variables.do

mkdir wlf

##################################################################################################
# TEST SOURCES ###################################################################################
##################################################################################################

##################################################################################################
# ACCELERATOR_CONVOLUTIONAL_LSTM_TEST 
##################################################################################################

alias accelerator_convolutional_lstm_verification_compilation {
  echo "TEST: ACCELERATOR_CONVOLUTIONAL_LSTM_TEST"

  vcom -2008 -reportprogress 300 -work work $verification_path/controller/LSTM/convolutional/accelerator_convolutional_lstm_pkg.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/controller/LSTM/convolutional/accelerator_convolutional_lstm_stimulus.vhd
  vcom -2008 -reportprogress 300 -work work $verification_path/controller/LSTM/convolutional/accelerator_convolutional_lstm_testbench.vhd

  vsim -g /accelerator_convolutional_lstm_testbench/ENABLE_ACCELERATOR_CONVOLUTIONAL_LSTM_TEST=true -t ps +notimingchecks -L unisim work.accelerator_convolutional_lstm_testbench

  #MACROS
  add log -r sim:/accelerator_convolutional_lstm_testbench/*

  force -freeze sim:/accelerator_convolutional_lstm_pkg/STIMULUS_ACCELERATOR_CONVOLUTIONAL_LSTM_TEST true 0
  force -freeze sim:/accelerator_convolutional_lstm_pkg/STIMULUS_ACCELERATOR_CONVOLUTIONAL_LSTM_CASE_0 true 0

  onbreak {resume}
  run -all

  dataset save sim wlf/accelerator_convolutional_lstm_test.wlf
}

##################################################################################################

alias v01 {
  accelerator_convolutional_lstm_verification_compilation
}

echo "****************************************"
echo "v01 . ACCELERATOR-CONVOLUTIONAL-LSTM-TEST"
echo "****************************************"
