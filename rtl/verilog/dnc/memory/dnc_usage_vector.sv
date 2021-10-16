// File vhdl/dnc/memory/dnc_usage_vector.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
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

module dnc_usage_vector(
CLK,
RST,
START,
READY,
U_IN_ENABLE,
W_IN_ENABLE,
PSI_IN_ENABLE,
U_OUT_ENABLE,
SIZE_N_IN,
U_IN,
W_IN,
PSI_IN,
U_OUT
);

parameter [31:0] DATA_SIZE=512;
// GLOBAL
input CLK;
input RST;
// CONTROL
input START;
output READY;
input U_IN_ENABLE;
// for j in 0 to N-1
input W_IN_ENABLE;
// for j in 0 to N-1
input PSI_IN_ENABLE;
// for j in 0 to N-1
output U_OUT_ENABLE;
// for j in 0 to N-1
// DATA
input [DATA_SIZE - 1:0] SIZE_N_IN;
input [DATA_SIZE - 1:0] U_IN;
input [DATA_SIZE - 1:0] W_IN;
input [DATA_SIZE - 1:0] PSI_IN;
output [DATA_SIZE - 1:0] U_OUT;

wire CLK;
wire RST;
wire START;
wire READY;
wire U_IN_ENABLE;
wire W_IN_ENABLE;
wire PSI_IN_ENABLE;
wire U_OUT_ENABLE;
wire [DATA_SIZE - 1:0] SIZE_N_IN;
wire [DATA_SIZE - 1:0] U_IN;
wire [DATA_SIZE - 1:0] W_IN;
wire [DATA_SIZE - 1:0] PSI_IN;
wire [DATA_SIZE - 1:0] U_OUT;


//---------------------------------------------------------------------
// Types
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// VECTOR ADDER
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
  // u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)
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
