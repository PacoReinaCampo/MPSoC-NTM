onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_modular_pkg/MONITOR_TEST
add wave -noupdate /model_modular_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM VECTOR MOD TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/CLK
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/RST
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/START
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/MODULO_IN
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/SIZE_IN
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/DATA_IN_ENABLE
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/DATA_IN
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/READY
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/DATA_OUT_ENABLE
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/index_loop
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/DATA_OUT

add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/mod_ctrl_fsm_int

add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/start_scalar_mod
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/modulo_in_scalar_mod
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/data_in_scalar_mod
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/ready_scalar_mod
add wave -noupdate /model_modular_testbench/model_vector_modular_mod_test/vector_modular_mod/data_out_scalar_mod

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