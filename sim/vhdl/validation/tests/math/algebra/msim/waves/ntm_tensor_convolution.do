onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_algebra_pkg/MONITOR_TEST
add wave -noupdate /model_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR CONVOLUTION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/CLK
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/RST
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/START
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/SIZE_A_I_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/SIZE_A_J_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/SIZE_A_K_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/SIZE_B_I_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/SIZE_B_J_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/SIZE_B_K_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_A_IN_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_A_IN_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_A_IN_K_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_A_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_B_IN_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_B_IN_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_B_IN_K_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_B_IN
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_K_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/READY
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_OUT_I_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_OUT_J_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_OUT_K_ENABLE
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/DATA_OUT

add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/convolution_ctrl_fsm_int

add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/index_i_loop
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/index_j_loop
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/index_k_loop

add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/data_a_in_i_convolution_int
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/data_a_in_j_convolution_int
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/data_a_in_k_convolution_int
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/data_b_in_i_convolution_int
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/data_b_in_j_convolution_int
add wave -noupdate /model_algebra_testbench/model_tensor_convolution_test/tensor_convolution/data_b_in_k_convolution_int

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1042309203 ps} 0} {{Cursor 2} {7446987402 ps} 0}
configure wave -namecolwidth 305
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1134027470 ps} {1150214364 ps}