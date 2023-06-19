all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_math_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_state_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/scalar/accelerator_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/vector/accelerator_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/float/matrix/accelerator_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/vector/accelerator_vector_module.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_inverse.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_summation.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/matrix/accelerator_matrix_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_convolution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_inverse.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/algebra/tensor/accelerator_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/accelerator_state_matrix_feedforward.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/accelerator_state_matrix_input.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/accelerator_state_matrix_output.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/feedback/accelerator_state_matrix_state.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/outputs/accelerator_state_vector_output.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/state/outputs/accelerator_state_vector_state.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/state/outputs/accelerator_state_outputs_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/state/outputs/accelerator_state_outputs_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/state/outputs/accelerator_state_outputs_testbench.vhd

simulate:
	ghdl -m --std=08 accelerator_state_outputs_testbench
	ghdl -r --std=08 accelerator_state_outputs_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_state_outputs_testbench.tree

clean:
	rm -f *.cf *.tree
