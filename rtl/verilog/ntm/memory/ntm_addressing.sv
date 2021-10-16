// File vhdl/ntm/memory/ntm_addressing.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
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

module ntm_addressing(
CLK,
RST,
START,
READY,
K_IN_ENABLE,
S_IN_ENABLE,
M_IN_J_ENABLE,
M_IN_K_ENABLE,
W_IN_ENABLE,
W_OUT_ENABLE,
SIZE_N_IN,
SIZE_W_IN,
K_IN,
BETA_IN,
G_IN,
S_IN,
GAMMA_IN,
M_IN,
W_IN,
W_OUT
);

parameter [31:0] DATA_SIZE=512;
// GLOBAL
input CLK;
input RST;
// CONTROL
input START;
output READY;
input K_IN_ENABLE;
// for k in 0 to W-1
input S_IN_ENABLE;
// for k in 0 to W-1
input M_IN_J_ENABLE;
// for j in 0 to N-1
input M_IN_K_ENABLE;
// for k in 0 to W-1
input W_IN_ENABLE;
// for j in 0 to N-1
output W_OUT_ENABLE;
// for j in 0 to N-1
// DATA
input [DATA_SIZE - 1:0] SIZE_N_IN;
input [DATA_SIZE - 1:0] SIZE_W_IN;
input [DATA_SIZE - 1:0] K_IN;
input [DATA_SIZE - 1:0] BETA_IN;
input [DATA_SIZE - 1:0] G_IN;
input [DATA_SIZE - 1:0] S_IN;
input [DATA_SIZE - 1:0] GAMMA_IN;
input [DATA_SIZE - 1:0] M_IN;
input [DATA_SIZE - 1:0] W_IN;
output [DATA_SIZE - 1:0] W_OUT;

wire CLK;
wire RST;
wire START;
wire READY;
wire K_IN_ENABLE;
wire S_IN_ENABLE;
wire M_IN_J_ENABLE;
wire M_IN_K_ENABLE;
wire W_IN_ENABLE;
wire W_OUT_ENABLE;
wire [DATA_SIZE - 1:0] SIZE_N_IN;
wire [DATA_SIZE - 1:0] SIZE_W_IN;
wire [DATA_SIZE - 1:0] K_IN;
wire [DATA_SIZE - 1:0] BETA_IN;
wire [DATA_SIZE - 1:0] G_IN;
wire [DATA_SIZE - 1:0] S_IN;
wire [DATA_SIZE - 1:0] GAMMA_IN;
wire [DATA_SIZE - 1:0] M_IN;
wire [DATA_SIZE - 1:0] W_IN;
wire [DATA_SIZE - 1:0] W_OUT;


//---------------------------------------------------------------------
// Types
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Constants
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// Signals
//---------------------------------------------------------------------
// VECTOR CONTENT BASED ADDRESSING
// CONTROL
wire start_vector_content_based_addressing;
wire ready_vector_content_based_addressing;
wire k_in_enable_vector_content_based_addressing;
wire m_in_i_enable_vector_content_based_addressing;
wire m_in_j_enable_vector_content_based_addressing;
wire c_out_enable_vector_content_based_addressing;  // DATA
wire [DATA_SIZE - 1:0] size_i_in_vector_content_based_addressing;
wire [DATA_SIZE - 1:0] size_j_in_vector_content_based_addressing;
wire [DATA_SIZE - 1:0] k_in_vector_content_based_addressing;
wire [DATA_SIZE - 1:0] beta_in_vector_content_based_addressing;
wire [DATA_SIZE - 1:0] m_in_vector_content_based_addressing;
wire [DATA_SIZE - 1:0] modulo_in_vector_content_based_addressing;
wire [DATA_SIZE - 1:0] c_out_vector_content_based_addressing;  // SCALAR ADDER
// CONTROL
wire start_scalar_adder;
wire ready_scalar_adder;
wire operation_scalar_adder;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_scalar_adder;
wire [DATA_SIZE - 1:0] data_a_in_scalar_adder;
wire [DATA_SIZE - 1:0] data_b_in_scalar_adder;
wire [DATA_SIZE - 1:0] data_out_scalar_adder;  // VECTOR EXPONENTIATOR
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
wire [DATA_SIZE - 1:0] data_out_vector_exponentiator;  // VECTOR MULTIPLIER
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
wire [DATA_SIZE - 1:0] data_out_vector_multiplier;  // VECTOR CONVOLUTION
// CONTROL
wire start_vector_convolution;
wire ready_vector_convolution;
wire data_a_in_vector_enable_vector_convolution;
wire data_a_in_scalar_enable_vector_convolution;
wire data_b_in_vector_enable_vector_convolution;
wire data_b_in_scalar_enable_vector_convolution;
wire data_out_vector_enable_vector_convolution;
wire data_out_scalar_enable_vector_convolution;  // DATA
wire [DATA_SIZE - 1:0] modulo_in_vector_convolution;
wire [DATA_SIZE - 1:0] size_in_vector_convolution;
wire [DATA_SIZE - 1:0] length_in_vector_convolution;
wire [DATA_SIZE - 1:0] data_a_in_vector_convolution;
wire [DATA_SIZE - 1:0] data_b_in_vector_convolution;
wire [DATA_SIZE - 1:0] data_out_vector_convolution;

  //---------------------------------------------------------------------
  // Body
  //---------------------------------------------------------------------
  // wc(t;j) = C(M(t1;j;k),k(t;k),beta(t))
  // wg(t;j) = g(t)·wc(t;j)·(1 - g(t)·w(t-1;j)
  // w(t;j) = w(t;j)*s(t;k)
  // w(t;j) = exponentiation(w(t;k),gamma(t)) / summation(exponentiation(w(t;k),gamma(t)))[j in 0 to N-1]
  // VECTOR CONTENT BASED ADDRESSING
  ntm_content_based_addressing #(
      .DATA_SIZE(DATA_SIZE))
  ntm_content_based_addressing_i(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_content_based_addressing),
    .READY(ready_vector_content_based_addressing),
    .K_IN_ENABLE(k_in_enable_vector_content_based_addressing),
    .M_IN_I_ENABLE(m_in_i_enable_vector_content_based_addressing),
    .M_IN_J_ENABLE(m_in_j_enable_vector_content_based_addressing),
    .C_OUT_ENABLE(c_out_enable_vector_content_based_addressing),
    // DATA
    .SIZE_I_IN(size_i_in_vector_content_based_addressing),
    .SIZE_J_IN(size_j_in_vector_content_based_addressing),
    .K_IN(k_in_vector_content_based_addressing),
    .BETA_IN(beta_in_vector_content_based_addressing),
    .M_IN(m_in_vector_content_based_addressing),
    .C_OUT(c_out_vector_content_based_addressing));

  // SCALAR ADDER
  ntm_scalar_adder #(
      .DATA_SIZE(DATA_SIZE))
  scalar_adder(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_scalar_adder),
    .READY(ready_scalar_adder),
    .OPERATION(operation_scalar_adder),
    // DATA
    .MODULO_IN(modulo_in_scalar_adder),
    .DATA_A_IN(data_a_in_scalar_adder),
    .DATA_B_IN(data_b_in_scalar_adder),
    .DATA_OUT(data_out_scalar_adder));

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

  // VECTOR CONVOLUTION
  ntm_vector_convolution_function #(
      .DATA_SIZE(DATA_SIZE))
  vector_convolution_function(
      // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_convolution),
    .READY(ready_vector_convolution),
    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_vector_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_vector_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_vector_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_vector_convolution),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_convolution),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_convolution),
    // DATA
    .MODULO_IN(modulo_in_vector_convolution),
    .SIZE_IN(size_in_vector_convolution),
    .LENGTH_IN(length_in_vector_convolution),
    .DATA_A_IN(data_a_in_vector_convolution),
    .DATA_B_IN(data_b_in_vector_convolution),
    .DATA_OUT(data_out_vector_convolution));


endmodule
