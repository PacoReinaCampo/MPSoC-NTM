###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              QueenField                                                       ##
##              Multi-Processor System on Chip                                   ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2022-2025 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

emacs -batch code/classes/philosophers/ntm_philosophers.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/classes/soldiers/ntm_soldiers.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/classes/workers/ntm_workers.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_multi_processor_system_on_chip/traditional_multi_processor_system_on_chip.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_processing_unit/traditional_mimd.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_processing_unit/traditional_misd.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_processing_unit/traditional_simd.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_processing_unit/traditional_sisd.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_system_on_chip/traditional_bus_on_chip.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_advanced_computer_architecture/traditional_system_on_chip/traditional_network_on_chip.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_computer_architecture/traditional_harvard_architecture/traditional_pu_riscv.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_computer_architecture/traditional_harvard_architecture/traditional_pu_or1k.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_computer_architecture/traditional_von_neumann_architecture/traditional_pu_riscv.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_computer_architecture/traditional_von_neumann_architecture/traditional_pu_msp430.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_bit/traditional_bit.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_combinational_logic/traditional_arithmetic_circuits.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_combinational_logic/traditional_logic_circuits.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_finite_state_machine/traditional_finite_state_machine.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_and_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_nand_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_nor_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_not_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_or_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_xnor_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_xor_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_logic_gate/traditional_yes_gate.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_information/traditional_pushdown_automaton/traditional_pushdown_automaton.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_neural_network/traditional_feedforward_neural_network/traditional_feedforward_neural_network.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_neural_network/traditional_long_short_term_memory_neural_network/traditional_long_short_term_memory_neural_network.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_neural_network/traditional_transformer_neural_network/traditional_transformer_neural_network.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_turing_machine/traditional_differentiable_neural_computer/traditional_feedforward_differentiable_neural_computer.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_turing_machine/traditional_differentiable_neural_computer/traditional_lstm_differentiable_neural_computer.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_turing_machine/traditional_differentiable_neural_computer/traditional_transformer_differentiable_neural_computer.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_turing_machine/traditional_neural_turing_machine/traditional_feedforward_neural_turing_machine.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_turing_machine/traditional_neural_turing_machine/traditional_lstm_neural_turing_machine.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/computing/traditional_turing_machine/traditional_neural_turing_machine/traditional_transformer_neural_turing_machine.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/classes/ntm_philosophers_pkg.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/classes/ntm_soldiers_pkg.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/classes/ntm_workers_pkg.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/computing/traditional_state_pkg.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/ieee/math_complex-body.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/ieee/math_complex.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/ieee/math_real-body.vhd -f vhdl-beautify-buffer -f save-buffer
emacs -batch code/pkg/ieee/math_real.vhd -f vhdl-beautify-buffer -f save-buffer
