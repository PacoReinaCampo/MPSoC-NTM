onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_float_pkg/MONITOR_TEST
add wave -noupdate /ntm_float_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR INVERTER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/CLK
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/RST
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/START
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/MODULO_IN
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/SIZE_IN
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/DATA_IN_ENABLE
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/DATA_IN
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/READY
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/DATA_OUT_ENABLE
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/DATA_OUT

add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/inverter_ctrl_fsm_int
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/index_loop

add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/start_scalar_inverter
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/modulo_in_scalar_inverter
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/data_in_scalar_inverter
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/ready_scalar_inverter
add wave -noupdate /ntm_float_testbench/ntm_vector_inverter_test/vector_inverter/data_out_scalar_inverter

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