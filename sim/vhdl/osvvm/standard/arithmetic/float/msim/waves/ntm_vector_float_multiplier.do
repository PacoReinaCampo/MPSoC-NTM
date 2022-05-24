onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_float_pkg/MONITOR_TEST
add wave -noupdate /model_float_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR FLOAT MULTIPLIER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/CLK
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/RST
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/START
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/SIZE_IN
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/DATA_A_IN_ENABLE
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/DATA_A_IN
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/DATA_B_IN_ENABLE
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/DATA_B_IN
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/READY
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/DATA_OUT_ENABLE
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/index_loop
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/DATA_OUT
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/OVERFLOW_OUT

add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/multiplier_ctrl_fsm_int

add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/start_scalar_float_multiplier
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/data_a_in_multiplier_int
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/data_a_in_scalar_float_multiplier
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/data_b_in_multiplier_int
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/data_b_in_scalar_float_multiplier
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/ready_scalar_float_multiplier
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/data_out_scalar_float_multiplier
add wave -noupdate /model_float_testbench/model_vector_float_multiplier_test/vector_float_multiplier/overflow_out_scalar_float_multiplier

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