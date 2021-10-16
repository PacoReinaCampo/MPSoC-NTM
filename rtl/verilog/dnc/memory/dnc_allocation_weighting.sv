// File vhdl/dnc/memory/dnc_allocation_weighting.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
// vhd2vl settings:
//  * Verilog Module Declaration Style: 1995

// vhd2vl is Free (libre) Software:
//   Copyright (C) 2001 Vincenzo Liguori - Ocean Logic Pty Ltd
//     http://www.ocean-logic.com
//   Modifications Copyright (C) 2006 Mark Gonzales - PMC Sierra Inc
//   Modifications (C) 2010 Shankar Giri
//   Modifications Copyright (C) 2002, 2005, 2008-2010, 2015 Larry Doolittle - LBNL
//     http://doolittle.icarus.com/~larry/vhd2vl/
//
//   vhd2vl comes with ABSOLUTELY NO WARRANTY.  Always check the resulting
//   Verilog for correctness, ideally with a formal verification tool.
//
//   You are welcome to redistribute vhd2vl under certain conditions.
//   See the license (GPLv2) file included with the source for details.

// The result of translation follows.  Its copyright status should be
// considered unchanged from the original VHDL.

//------------------------------------------------------------------------------
//                                            __ _      _     _               --
//                                           / _(_)    | |   | |              --
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
//                  | |                                                       --
//                  |_|                                                       --
//                                                                            --
//                                                                            --
//              Peripheral-NTM for MPSoC                                      --
//              Neural Turing Machine for MPSoC                               --
//                                                                            --
//------------------------------------------------------------------------------
// Copyright (c) 2020-2021 by the author(s)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>
// no timescale needed

module dnc_allocation_weighting(
CLK,
RST,
START,
READY,
PHI_IN_ENABLE,
U_IN_ENABLE,
A_OUT_ENABLE,
SIZE_N_IN,
PHI_IN,
U_IN,
A_OUT
);

parameter [31:0] DATA_SIZE=512;
// GLOBAL
input CLK;
input RST;
// CONTROL
input START;
output READY;
input PHI_IN_ENABLE;
// for j in 0 to N-1
input U_IN_ENABLE;
// for j in 0 to N-1
output A_OUT_ENABLE;
// for j in 0 to N-1
// DATA
input [DATA_SIZE - 1:0] SIZE_N_IN;
input [DATA_SIZE - 1:0] PHI_IN;
input [DATA_SIZE - 1:0] U_IN;
output [DATA_SIZE - 1:0] A_OUT;

wire CLK;
wire RST;
wire START;
wire READY;
wire PHI_IN_ENABLE;
wire U_IN_ENABLE;
wire A_OUT_ENABLE;
wire [DATA_SIZE - 1:0] SIZE_N_IN;
wire [DATA_SIZE - 1:0] PHI_IN;
wire [DATA_SIZE - 1:0] U_IN;
wire [DATA_SIZE - 1:0] A_OUT;


//---------------------------------------------------------------------
// Types
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// VECTOR MULTIPLICATION
// CONTROL
wire start_vector_multiplication;
wire ready_vector_multiplication;
wire data_in_vector_enable_vector_multiplication;
wire data_in_scalar_enable_vector_multiplication;
wire data_out_vector_enable_vector_multiplication;
wire data_out_scalar_enable_vector_multiplication;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_multiplication;
wire [DATA_SIZE - 1:0] length_in_vector_multiplication;
wire [DATA_SIZE - 1:0] size_in_vector_multiplication;
wire [DATA_SIZE - 1:0] data_in_vector_multiplication;
wire [DATA_SIZE - 1:0] data_out_vector_multiplication;  // VECTOR ADDER
// CONTROL
wire start_vector_adder;
wire ready_vector_adder;
wire operation_vector_adder;
wire data_a_in_enable_vector_adder;
wire data_b_in_enable_vector_adder;
wire data_out_enable_vector_adder;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_adder;
wire [DATA_SIZE - 1:0] size_in_vector_adder;
wire [DATA_SIZE - 1:0] data_a_in_vector_adder;
wire [DATA_SIZE - 1:0] data_b_in_vector_adder;
wire [DATA_SIZE - 1:0] data_out_vector_adder;  // VECTOR MULTIPLIER
// CONTROL
wire start_vector_multiplier;
wire ready_vector_multiplier;
wire data_a_in_enable_vector_multiplier;
wire data_b_in_enable_vector_multiplier;
wire data_out_enable_vector_multiplier;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_multiplier;
wire [DATA_SIZE - 1:0] size_in_vector_multiplier;
wire [DATA_SIZE - 1:0] data_a_in_vector_multiplier;
wire [DATA_SIZE - 1:0] data_b_in_vector_multiplier;
wire [DATA_SIZE - 1:0] data_out_vector_multiplier;

  //---------------------------------------------------------------------
  // Body
  //---------------------------------------------------------------------
  // a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]
  // VECTOR MULTIPLICATION
  ntm_vector_multiplication_function #(
      .DATA_SIZE(DATA_SIZE))
  vector_multiplication_function(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_multiplication),
    .READY(ready_vector_multiplication),
    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_multiplication),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_multiplication),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_multiplication),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_multiplication),
    // DATA
    .MODULO_IN(modulo_in_vector_multiplication),
    .SIZE_IN(size_in_vector_multiplication),
    .LENGTH_IN(length_in_vector_multiplication),
    .DATA_IN(data_in_vector_multiplication),
    .DATA_OUT(data_out_vector_multiplication));

  // VECTOR ADDER
  ntm_vector_adder #(
      .DATA_SIZE(DATA_SIZE))
  vector_adder(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_adder),
    .READY(ready_vector_adder),
    .OPERATION(operation_vector_adder),
    .DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .DATA_OUT_ENABLE(data_out_enable_vector_adder),
    // DATA
    .MODULO_IN(modulo_in_vector_adder),
    .SIZE_IN(size_in_vector_adder),
    .DATA_A_IN(data_a_in_vector_adder),
    .DATA_B_IN(data_b_in_vector_adder),
    .DATA_OUT(data_out_vector_adder));

  // VECTOR MULTIPLIER
  ntm_vector_multiplier #(
      .DATA_SIZE(DATA_SIZE))
  vector_multiplier(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_multiplier),
    .READY(ready_vector_multiplier),
    .DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .DATA_OUT_ENABLE(data_out_enable_vector_multiplier),
    // DATA
    .MODULO_IN(modulo_in_vector_multiplier),
    .SIZE_IN(size_in_vector_multiplier),
    .DATA_A_IN(data_a_in_vector_multiplier),
    .DATA_B_IN(data_b_in_vector_multiplier),
    .DATA_OUT(data_out_vector_multiplier));


endmodule
