onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_algebra_pkg/MONITOR_TEST
add wave -noupdate /ntm_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR SUMMATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/CLK
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/RST
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/START
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/SIZE_I_IN
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/SIZE_J_IN
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/SIZE_K_IN
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_IN_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_IN_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_IN_K_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_IN
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_K_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/READY
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/DATA_OUT

add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/summation_ctrl_fsm_int

add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/index_i_loop
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/index_j_loop
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/index_k_loop

add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/start_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/operation_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/data_a_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/data_b_in_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/ready_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/data_out_scalar_adder
add wave -noupdate /ntm_algebra_testbench/ntm_tensor_summation_test/tensor_summation/overflow_out_scalar_adder

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