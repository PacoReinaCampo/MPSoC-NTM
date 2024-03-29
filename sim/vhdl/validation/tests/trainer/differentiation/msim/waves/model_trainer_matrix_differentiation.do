onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM MATRIX TRAINER DIFFERENTIATION TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/CLK
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/RST

add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/START

add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/SIZE_T_IN
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/SIZE_R_IN
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/SIZE_L_IN

add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_IN_T_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/index_t_x_in_loop
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_IN_I_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/index_i_x_in_loop
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_IN_L_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/index_l_x_in_loop
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_IN
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/data_x_in_enable_int
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_OUT_T_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_OUT_I_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/X_OUT_L_ENABLE

add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/READY
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/Y_OUT_T_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/index_t_y_out_loop
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/Y_OUT_I_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/index_i_y_out_loop
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/Y_OUT_L_ENABLE
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/index_l_y_out_loop
add wave -noupdate /model_trainer_differentiation_testbench/model_trainer_matrix_differentiation_test/trainer_matrix_differentiation/Y_OUT

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
