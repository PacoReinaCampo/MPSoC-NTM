onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR FLOAT DIVIDER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/CLK
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/RST
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/START
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/DATA_A_IN
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/DATA_B_IN
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/READY
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/DATA_OUT
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/OVERFLOW_OUT

add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/divider_ctrl_fsm_int

add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/data_a_int
add wave -noupdate /model_float_testbench/model_scalar_float_divider_test/scalar_float_divider/data_b_int

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
