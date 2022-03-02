onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_calculus_pkg/MONITOR_TEST
add wave -noupdate /ntm_calculus_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TENSOR DIFFERENTIATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/CLK
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/RST
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/START
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/CONTROL
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/SIZE_I_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/SIZE_J_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/SIZE_K_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/LENGTH_I_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/LENGTH_J_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/LENGTH_K_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_IN_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_IN_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_IN_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_IN
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/READY
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_OUT_I_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_OUT_J_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_OUT_K_ENABLE
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/DATA_OUT

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/differentiation_ctrl_fsm_int

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/index_i_loop
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/index_j_loop
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/index_k_loop

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/start_scalar_float_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/operation_scalar_float_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/data_a_in_scalar_float_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/data_b_in_scalar_float_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/ready_scalar_float_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/data_out_scalar_float_adder
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/overflow_out_scalar_float_adder

add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/start_scalar_float_divider
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/data_a_in_scalar_float_divider
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/data_b_in_scalar_float_divider
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/ready_scalar_float_divider
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/data_out_scalar_float_divider
add wave -noupdate /ntm_calculus_testbench/ntm_tensor_differentiation_test/tensor_differentiation/rest_out_scalar_float_divider

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