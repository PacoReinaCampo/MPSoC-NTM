onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_modular_pkg/MONITOR_TEST
add wave -noupdate /ntm_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/CLK
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/RST
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/START
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/MODULO_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/SIZE_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/DATA_A_IN_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/DATA_A_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/DATA_B_IN_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/DATA_B_IN
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/READY
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/DATA_OUT_ENABLE
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/DATA_OUT

add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/divider_ctrl_fsm_int
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/index_loop
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/data_a_in_divider_int
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/data_b_in_divider_int

add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/start_scalar_divider
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/modulo_in_scalar_divider
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/data_a_in_scalar_divider
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/data_b_in_scalar_divider
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/ready_scalar_divider
add wave -noupdate /ntm_modular_testbench/ntm_matrix_modular_divider_test/matrix_divider/data_out_scalar_divider

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