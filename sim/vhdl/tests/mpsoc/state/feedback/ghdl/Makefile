all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_state_pkg.vhd


	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/matrix/ntm_matrix_integer_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/matrix/ntm_matrix_integer_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/integer/matrix/ntm_matrix_integer_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/scalar/ntm_scalar_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/vector/ntm_vector_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/float/matrix/ntm_matrix_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/vector/ntm_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/matrix/ntm_matrix_transpose.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/algebra/tensor/ntm_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/state/feedback/ntm_state_matrix_feedforward.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/state/feedback/ntm_state_matrix_input.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/state/feedback/ntm_state_matrix_output.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/state/feedback/ntm_state_matrix_state.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/state/top/ntm_state_feedback_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/state/top/ntm_state_feedback_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/state/top/ntm_state_feedback_testbench.vhd

simulate:
	ghdl -m --std=08 ntm_state_feedback_testbench
	ghdl -r --std=08 ntm_state_feedback_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_state_feedback_testbench.tree

clean:
	rm -f *.cf *.tree
