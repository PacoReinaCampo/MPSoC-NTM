onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_memory_pkg/MONITOR_TEST
add wave -noupdate /model_memory_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR MODULE TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/CLK
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/RST
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/START
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/SIZE_N_IN
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/U_IN_ENABLE
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/U_IN
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/U_OUT_ENABLE
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/READY
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/PHI_OUT_ENABLE
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/PHI_OUT

add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/sort_ctrl_fsm_int

add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/index_i_loop
add wave -noupdate /model_memory_testbench/model_sort_vector_test/sort_vector/index_m_loop

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