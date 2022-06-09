onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_read_heads_pkg/MONITOR_TEST
add wave -noupdate /model_read_heads_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM READ MODES TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/CLK
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/RST
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/START
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/SIZE_R_IN
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/PI_IN_I_ENABLE
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/PI_IN_P_ENABLE
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/PI_IN
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/READY
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/PI_OUT_I_ENABLE
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/PI_OUT_P_ENABLE
add wave -noupdate /model_read_heads_testbench/model_read_modes_test/read_modes/PI_OUT

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