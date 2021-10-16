// File vhdl/dnc/memory/dnc_content_based_addressing.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
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

module dnc_content_based_addressing(
CLK,
RST,
START,
READY,
K_IN_ENABLE,
M_IN_I_ENABLE,
M_IN_J_ENABLE,
C_OUT_ENABLE,
SIZE_I_IN,
SIZE_J_IN,
K_IN,
M_IN,
BETA_IN,
C_OUT
);

parameter [31:0] DATA_SIZE=512;
// GLOBAL
input CLK;
input RST;
// CONTROL
input START;
output READY;
input K_IN_ENABLE;
// for j in 0 to J-1
input M_IN_I_ENABLE;
// for i in 0 to I-1
input M_IN_J_ENABLE;
// for j in 0 to J-1
output C_OUT_ENABLE;
// for i in 0 to I-1
// DATA
input [DATA_SIZE - 1:0] SIZE_I_IN;
input [DATA_SIZE - 1:0] SIZE_J_IN;
input [DATA_SIZE - 1:0] K_IN;
input [DATA_SIZE - 1:0] M_IN;
input [DATA_SIZE - 1:0] BETA_IN;
output [DATA_SIZE - 1:0] C_OUT;

wire CLK;
wire RST;
wire START;
wire READY;
wire K_IN_ENABLE;
wire M_IN_I_ENABLE;
wire M_IN_J_ENABLE;
wire C_OUT_ENABLE;
wire [DATA_SIZE - 1:0] SIZE_I_IN;
wire [DATA_SIZE - 1:0] SIZE_J_IN;
wire [DATA_SIZE - 1:0] K_IN;
wire [DATA_SIZE - 1:0] M_IN;
wire [DATA_SIZE - 1:0] BETA_IN;
wire [DATA_SIZE - 1:0] C_OUT;


//---------------------------------------------------------------------
// Types
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// VECTOR EXPONENTIATOR
// CONTROL
wire start_vector_exponentiator;
wire ready_vector_exponentiator;
wire data_a_in_enable_vector_exponentiator;
wire data_b_in_enable_vector_exponentiator;
wire data_out_enable_vector_exponentiator;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_exponentiator;
wire [DATA_SIZE - 1:0] size_in_vector_exponentiator;
wire [DATA_SIZE - 1:0] data_a_in_vector_exponentiator;
wire [DATA_SIZE - 1:0] data_b_in_vector_exponentiator;
wire [DATA_SIZE - 1:0] data_out_vector_exponentiator;  // VECTOR COSINE SIMILARITY
// CONTROL
wire start_vector_cosine;
wire ready_vector_cosine;
wire data_a_in_vector_enable_vector_cosine;
wire data_a_in_scalar_enable_vector_cosine;
wire data_b_in_vector_enable_vector_cosine;
wire data_b_in_scalar_enable_vector_cosine;
wire data_out_vector_enable_vector_cosine;
wire data_out_scalar_enable_vector_cosine;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_cosine;
wire [DATA_SIZE - 1:0] size_in_vector_cosine;
wire [DATA_SIZE - 1:0] length_in_vector_cosine;
wire [DATA_SIZE - 1:0] data_a_in_vector_cosine;
wire [DATA_SIZE - 1:0] data_b_in_vector_cosine;
wire [DATA_SIZE - 1:0] data_out_vector_cosine;  // VECTOR SOFTMAX
// CONTROL
wire start_vector_softmax;
wire ready_vector_softmax;
wire data_in_vector_enable_vector_softmax;
wire data_in_scalar_enable_vector_softmax;
wire data_out_vector_enable_vector_softmax;
wire data_out_scalar_enable_vector_softmax;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_softmax;
wire [DATA_SIZE - 1:0] length_in_vector_softmax;
wire [DATA_SIZE - 1:0] size_in_vector_softmax;
wire [DATA_SIZE - 1:0] data_in_vector_softmax;
wire [DATA_SIZE - 1:0] data_out_vector_softmax;

  //---------------------------------------------------------------------
  // Body
  //---------------------------------------------------------------------
  // C(M,k,beta)[i] = softmax(exponentiation(e,cosine(k,M)·beta))[i]
  // VECTOR EXPONENTIATOR
  ntm_vector_exponentiator #(
      .DATA_SIZE(DATA_SIZE))
  vector_exponentiator(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_exponentiator),
    .READY(ready_vector_exponentiator),
    .DATA_A_IN_ENABLE(data_a_in_enable_vector_exponentiator),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_exponentiator),
    .DATA_OUT_ENABLE(data_out_enable_vector_exponentiator),
    // DATA
    .MODULO_IN(modulo_in_vector_exponentiator),
    .SIZE_IN(size_in_vector_exponentiator),
    .DATA_A_IN(data_a_in_vector_exponentiator),
    .DATA_B_IN(data_b_in_vector_exponentiator),
    .DATA_OUT(data_out_vector_exponentiator));

  // VECTOR COSINE SIMILARITY
  ntm_vector_cosine_similarity_function #(
      .DATA_SIZE(DATA_SIZE))
  vector_cosine_similarity_function(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_cosine),
    .READY(ready_vector_cosine),
    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_cosine),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_cosine),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_cosine),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_cosine),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_cosine),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_cosine),
    // DATA
    .MODULO_IN(modulo_in_vector_cosine),
    .SIZE_IN(size_in_vector_cosine),
    .LENGTH_IN(length_in_vector_cosine),
    .DATA_A_IN(data_a_in_vector_cosine),
    .DATA_B_IN(data_b_in_vector_cosine),
    .DATA_OUT(data_out_vector_cosine));

  // VECTOR SOFTMAX
  ntm_vector_softmax_function #(
      .DATA_SIZE(DATA_SIZE))
  vector_softmax_function(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_softmax),
    .READY(ready_vector_softmax),
    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_softmax),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_softmax),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_softmax),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_softmax),
    // DATA
    .MODULO_IN(modulo_in_vector_softmax),
    .SIZE_IN(size_in_vector_softmax),
    .LENGTH_IN(length_in_vector_softmax),
    .DATA_IN(data_in_vector_softmax),
    .DATA_OUT(data_out_vector_softmax));


endmodule
