all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_math_pkg.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/pkg/model_state_pkg.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/scalar/model_scalar_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/vector/model_vector_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_adder.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/float/matrix/model_matrix_float_divider.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_dot_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_cosine_similarity.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_summation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/vector/model_vector_module.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_inverse.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_summation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/matrix/model_matrix_transpose.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_convolution.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_inverse.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_multiplication.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_product.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_summation.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/math/algebra/tensor/model_tensor_transpose.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/state/feedback/model_state_matrix_feedforward.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/state/feedback/model_state_matrix_input.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/state/feedback/model_state_matrix_output.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/state/feedback/model_state_matrix_state.vhd

	ghdl -a --std=08 ../../../../../../../model/vhdl/state/outputs/model_state_vector_output.vhd
	ghdl -a --std=08 ../../../../../../../model/vhdl/state/outputs/model_state_vector_state.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/model/state/outputs/model_state_outputs_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/model/state/outputs/model_state_outputs_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/model/state/outputs/model_state_outputs_testbench.vhd

simulate:
	ghdl -m --std=08 model_state_outputs_testbench
	ghdl -r --std=08 model_state_outputs_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_state_outputs_testbench.tree

clean:
	rm -f *.cf *.tree
