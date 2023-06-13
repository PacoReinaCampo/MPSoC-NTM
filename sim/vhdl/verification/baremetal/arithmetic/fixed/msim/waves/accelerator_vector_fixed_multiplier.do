onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_fixed_pkg/MONITOR_TEST
add wave -noupdate /accelerator_fixed_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR FIXED MULTIPLIER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/CLK
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/RST
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/START
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/SIZE_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/DATA_A_IN_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/DATA_A_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/DATA_B_IN_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/DATA_B_IN
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/READY
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/DATA_OUT_ENABLE
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/index_loop
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/DATA_OUT
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/OVERFLOW_OUT

add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/multiplier_ctrl_fsm_int

add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/start_scalar_fixed_multiplier
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/data_a_in_multiplier_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/data_a_in_scalar_fixed_multiplier
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/data_b_in_multiplier_int
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/data_b_in_scalar_fixed_multiplier
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/ready_scalar_fixed_multiplier
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/data_out_scalar_fixed_multiplier
add wave -noupdate /accelerator_fixed_testbench/accelerator_vector_fixed_multiplier_test/vector_fixed_multiplier/overflow_out_scalar_fixed_multiplier

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