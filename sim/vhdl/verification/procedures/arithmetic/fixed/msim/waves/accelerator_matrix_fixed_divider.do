onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_fixed_pkg/MONITOR_TEST
add wave -noupdate /accelerator_fixed_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX FIXED DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/CLK
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/RST
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/START
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/SIZE_I_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/SIZE_J_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_A_IN_I_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_A_IN_J_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_A_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_B_IN_I_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_B_IN_J_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_B_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/READY
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/index_i_loop
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/index_j_loop
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/DATA_OUT
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/OVERFLOW_OUT

add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/divider_ctrl_fsm_int

add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/start_scalar_fixed_divider
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_a_in_i_divider_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_a_in_j_divider_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_a_in_scalar_fixed_divider
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_b_in_i_divider_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_b_in_j_divider_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_b_in_scalar_fixed_divider
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/ready_scalar_fixed_divider
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/data_out_scalar_fixed_divider
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_divider_test/matrix_fixed_divider/overflow_out_scalar_fixed_divider

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