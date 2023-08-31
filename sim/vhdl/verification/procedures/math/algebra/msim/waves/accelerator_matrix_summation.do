onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_algebra_pkg/MONITOR_TEST
add wave -noupdate /accelerator_algebra_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX SUMMATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/CLK
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/RST
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/START
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/SIZE_I_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/SIZE_J_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_IN_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_IN_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_IN_LENGTH_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_IN
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_LENGTH_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/READY
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/DATA_OUT

add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/summation_ctrl_fsm_int

add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/index_i_loop
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/index_j_loop

add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/start_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/operation_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/data_a_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/data_b_in_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/ready_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/data_out_scalar_float_adder
add wave -noupdate /accelerator_algebra_testbench/accelerator_matrix_summation_test/matrix_summation/overflow_out_scalar_float_adder

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
