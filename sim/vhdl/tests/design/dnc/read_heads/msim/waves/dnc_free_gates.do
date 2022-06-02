onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_read_heads_pkg/MONITOR_TEST
add wave -noupdate /model_read_heads_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM FREE GATES TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/CLK
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/RST
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/START
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/SIZE_R_IN
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/F_IN_ENABLE
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/F_IN
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/READY
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/F_OUT_ENABLE
add wave -noupdate /model_read_heads_testbench/model_free_gates_test/free_gates/F_OUT

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