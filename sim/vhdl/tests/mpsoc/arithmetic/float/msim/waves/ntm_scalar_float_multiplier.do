onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /ntm_float_pkg/MONITOR_TEST
add wave -noupdate /ntm_float_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM SCALAR FLOAT MULTIPLIER TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/CLK
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/RST
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/START
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/DATA_A_IN
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/DATA_B_IN
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/READY
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/DATA_OUT

add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/state

add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/A_mantissa
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/B_mantissa
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/A_exp
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/B_exp
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/A_sgn
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/B_sgn

add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/sum_exp
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/sum_mantissa
add wave -noupdate /ntm_float_testbench/ntm_scalar_float_multiplier_test/scalar_float_multiplier/sum_sgn

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