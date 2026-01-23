onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR MATRIX FIXED ADDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/CLK
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/RST
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/START
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/OPERATION
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/SIZE_I_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/SIZE_J_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_A_IN_I_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_A_IN_J_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_A_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_B_IN_I_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_B_IN_J_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_B_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/READY
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_OUT_I_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/index_i_loop
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_OUT_J_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/index_j_loop
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/DATA_OUT
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/OVERFLOW_OUT

add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/adder_ctrl_fsm_int

add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/start_scalar_fixed_adder
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/operation_scalar_fixed_adder
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_a_in_i_adder_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_a_in_j_adder_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_a_in_scalar_fixed_adder
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_b_in_i_adder_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_b_in_j_adder_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_b_in_scalar_fixed_adder
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/ready_scalar_fixed_adder
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/data_out_scalar_fixed_adder
add wave -noupdate /accelerator_fixed_testbench/accelerator_matrix_fixed_adder_test/matrix_fixed_adder/overflow_out_scalar_fixed_adder

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