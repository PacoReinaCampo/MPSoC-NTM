onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_trainer_linear_pkg/MONITOR_TEST
add wave -noupdate /model_trainer_linear_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM TRAINER LINEAR TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/CLK
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/RST

add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/START

add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/SIZE_T_IN
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/SIZE_X_IN
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/SIZE_L_IN

add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/X_IN_T_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_t_x_in_loop
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/X_IN_X_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_x_x_in_loop
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/X_IN
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/data_x_in_enable_int
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/X_OUT_T_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/X_OUT_X_ENABLE

add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/H_IN_T_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_t_h_in_loop
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/H_IN_L_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_l_h_in_loop
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/H_IN
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/data_h_in_enable_int
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/H_OUT_T_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/H_OUT_L_ENABLE

add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/READY
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/data_w_out_enable_int
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/W_OUT_L_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_l_w_out_loop
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/W_OUT_X_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_x_w_out_loop
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/data_b_out_enable_int
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/B_OUT_L_ENABLE
add wave -noupdate /model_trainer_linear_testbench/model_trainer_linear_test/trainer/index_l_b_out_loop

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
