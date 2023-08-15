onerror {resume}

quietly WaveActivateNextPane {} 0

add wave -noupdate /model_convolutional_linear_pkg/MONITOR_TEST
add wave -noupdate /model_convolutional_linear_pkg/MONITOR_CASE

add wave -noupdate -divider {=========================================}
add wave -noupdate -divider {NTM CONVOLUTIONAL LINEAR TEST}
add wave -noupdate -divider {=========================================}

add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/CLK
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/RST

add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/START

add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/SIZE_X_IN
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/SIZE_L_IN

add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/W_IN_L_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/W_IN_X_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/W_IN
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/data_w_in_enable_int
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/W_OUT_L_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/index_l_w_in_loop
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/W_OUT_X_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/index_x_w_in_loop
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/B_IN_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/B_IN
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/data_b_in_enable_int
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/B_OUT_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/index_l_b_in_loop

add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/X_IN_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/data_x_in_enable_int
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/index_x_x_in_loop
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/X_IN
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/X_OUT_ENABLE

add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/READY
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/H_OUT_ENABLE
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/index_l_h_out_loop
add wave -noupdate /model_convolutional_linear_testbench/model_convolutional_linear_test/controller/H_OUT

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
