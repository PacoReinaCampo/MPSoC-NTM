onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {ACCELERATOR SCALAR INTEGER MULTIPLIER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/CLK
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/RST
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/START
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/DATA_A_IN
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/DATA_B_IN
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/READY
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/DATA_OUT
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/OVERFLOW_OUT

add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/multiplier_ctrl_fsm_int
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/multiplier_int
add wave -noupdate /accelerator_integer_testbench/accelerator_scalar_integer_multiplier_test/scalar_integer_multiplier/index_loop

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