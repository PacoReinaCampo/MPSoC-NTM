all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/ntm_math_pkg.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_mod.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_inverter.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_divider.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_exponentiator.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_root.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/scalar/ntm_scalar_logarithm.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_mod.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_inverter.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_divider.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_exponentiator.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_root.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/vector/ntm_vector_logarithm.vhd

	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_mod.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_adder.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_multiplier.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_inverter.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_divider.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_exponentiator.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_root.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/math/arithmetic/matrix/ntm_matrix_logarithm.vhd

	ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/arithmetic/ntm_arithmetic_pkg.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/arithmetic/ntm_arithmetic_stimulus.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/osvvm/math/arithmetic/ntm_arithmetic_testbench.vhd

simulate:
	ghdl -m --std=08 ntm_arithmetic_testbench
	ghdl -r --std=08 ntm_arithmetic_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > ntm_arithmetic_testbench.tree

clean:
	rm -f *.cf *.tree
