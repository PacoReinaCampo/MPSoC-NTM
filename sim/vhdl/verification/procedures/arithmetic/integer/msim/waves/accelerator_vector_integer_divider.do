onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /accelerator_integer_pkg/MONITOR_TEST
add wave -noupdate /accelerator_integer_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR INTEGER DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/CLK
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/RST
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/START
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/SIZE_IN
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/DATA_A_IN_ENABLE
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/DATA_A_IN
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/DATA_B_IN_ENABLE
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/DATA_B_IN
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/READY
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/DATA_OUT_ENABLE
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/index_loop
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/DATA_OUT
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/REMAINDER_OUT

add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/divider_ctrl_fsm_int

add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/start_scalar_integer_divider
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/data_a_in_divider_int
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/data_a_in_scalar_integer_divider
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/data_b_in_divider_int
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/data_b_in_scalar_integer_divider
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/ready_scalar_integer_divider
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/data_out_scalar_integer_divider
add wave -noupdate /accelerator_integer_testbench/accelerator_vector_integer_divider_test/vector_integer_divider/remainder_out_scalar_integer_divider

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