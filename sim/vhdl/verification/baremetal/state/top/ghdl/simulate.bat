@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_arithmetic_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_math_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/ntm_state_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/ntm_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/ntm_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/ntm_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/ntm_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/ntm_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/ntm_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/ntm_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/ntm_matrix_float_multiplier.vhd
ghdl -a --std=08 ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/ntm_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_dot_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_cosine_similarity.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/ntm_vector_module.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_inverse.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/ntm_matrix_transpose.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_convolution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_inverse.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_multiplication.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_product.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_summation.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/ntm_tensor_transpose.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/ntm_state_matrix_feedforward.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/ntm_state_matrix_input.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/ntm_state_matrix_output.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/ntm_state_matrix_state.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/outputs/ntm_state_vector_output.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/outputs/ntm_state_vector_state.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/top/ntm_state_top.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/state/top/ntm_state_top_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/state/top/ntm_state_top_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/state/top/ntm_state_top_testbench.vhd

ghdl -m --std=08 ntm_state_top_testbench
ghdl -r --std=08 ntm_state_top_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_state_top_testbench.tree
pause
