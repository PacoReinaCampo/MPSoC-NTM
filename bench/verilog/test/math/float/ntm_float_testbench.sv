////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              Peripheral-NTM for MPSoC                                      //
//              Neural Turing Machine for MPSoC                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////
// Author(s):
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

module ntm_float_testbench;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE=512;
  parameter INDEX_SIZE=512;

  parameter X=64;
  parameter Y=64;
  parameter N=64;
  parameter W=64;
  parameter L=64;
  parameter R=64;

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_NTM_SCALAR_ADDER_TEST         = 0;
  parameter STIMULUS_NTM_SCALAR_MULTIPLIER_TEST    = 0;
  parameter STIMULUS_NTM_SCALAR_INVERTER_TEST      = 0;
  parameter STIMULUS_NTM_SCALAR_DIVIDER_TEST       = 0;
  parameter STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST = 0;

  parameter STIMULUS_NTM_SCALAR_ADDER_CASE_0         = 0;
  parameter STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0    = 0;
  parameter STIMULUS_NTM_SCALAR_INVERTER_CASE_0      = 0;
  parameter STIMULUS_NTM_SCALAR_DIVIDER_CASE_0       = 0;
  parameter STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0 = 0;

  parameter STIMULUS_NTM_SCALAR_ADDER_CASE_1         = 0;
  parameter STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1    = 0;
  parameter STIMULUS_NTM_SCALAR_INVERTER_CASE_1      = 0;
  parameter STIMULUS_NTM_SCALAR_DIVIDER_CASE_1       = 0;
  parameter STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1 = 0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_ADDER_TEST         = 0;
  parameter STIMULUS_NTM_VECTOR_MULTIPLIER_TEST    = 0;
  parameter STIMULUS_NTM_VECTOR_INVERTER_TEST      = 0;
  parameter STIMULUS_NTM_VECTOR_DIVIDER_TEST       = 0;
  parameter STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST = 0;

  parameter STIMULUS_NTM_VECTOR_ADDER_CASE_0         = 0;
  parameter STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0    = 0;
  parameter STIMULUS_NTM_VECTOR_INVERTER_CASE_0      = 0;
  parameter STIMULUS_NTM_VECTOR_DIVIDER_CASE_0       = 0;
  parameter STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0 = 0;

  parameter STIMULUS_NTM_VECTOR_ADDER_CASE_1         = 0;
  parameter STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1    = 0;
  parameter STIMULUS_NTM_VECTOR_INVERTER_CASE_1      = 0;
  parameter STIMULUS_NTM_VECTOR_DIVIDER_CASE_1       = 0;
  parameter STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_ADDER_TEST         = 0;
  parameter STIMULUS_NTM_MATRIX_MULTIPLIER_TEST    = 0;
  parameter STIMULUS_NTM_MATRIX_INVERTER_TEST      = 0;
  parameter STIMULUS_NTM_MATRIX_DIVIDER_TEST       = 0;
  parameter STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST = 0;

  parameter STIMULUS_NTM_MATRIX_ADDER_CASE_0         = 0;
  parameter STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0    = 0;
  parameter STIMULUS_NTM_MATRIX_INVERTER_CASE_0      = 0;
  parameter STIMULUS_NTM_MATRIX_DIVIDER_CASE_0       = 0;
  parameter STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0 = 0;

  parameter STIMULUS_NTM_MATRIX_ADDER_CASE_1         = 0;
  parameter STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1    = 0;
  parameter STIMULUS_NTM_MATRIX_INVERTER_CASE_1      = 0;
  parameter STIMULUS_NTM_MATRIX_DIVIDER_CASE_1       = 0;
  parameter STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1 = 0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire CLK;
  wire RST;

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  // CONTROL
  wire start_scalar_adder;
  wire ready_scalar_adder;

  wire operation_scalar_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_a_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire start_scalar_multiplier;
  wire ready_scalar_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_scalar_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_multiplier;

  // SCALAR INVERTER
  // CONTROL
  wire start_scalar_inverter;
  wire ready_scalar_inverter;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_inverter;
  wire [DATA_SIZE-1:0] data_in_scalar_inverter;
  wire [DATA_SIZE-1:0] data_out_scalar_inverter;

  // SCALAR DIVIDER
  // CONTROL
  wire start_scalar_divider;
  wire ready_scalar_divider;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_divider;
  wire [DATA_SIZE-1:0] data_a_in_scalar_divider;
  wire [DATA_SIZE-1:0] data_b_in_scalar_divider;
  wire [DATA_SIZE-1:0] data_out_scalar_divider;

  // SCALAR EXPONENTIATOR
  // CONTROL
  wire start_scalar_exponentiator;
  wire ready_scalar_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_exponentiator;
  wire [DATA_SIZE-1:0] data_a_in_scalar_exponentiator;
  wire [DATA_SIZE-1:0] data_b_in_scalar_exponentiator;
  wire [DATA_SIZE-1:0] data_out_scalar_exponentiator;

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  // CONTROL
  wire start_vector_adder;
  wire ready_vector_adder;

  wire operation_vector_adder;

  wire data_a_in_enable_vector_adder;
  wire data_b_in_enable_vector_adder;
  wire data_out_enable_vector_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_adder;
  wire [DATA_SIZE-1:0] size_in_vector_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_adder;
  wire [DATA_SIZE-1:0] data_out_vector_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire start_vector_multiplier;
  wire ready_vector_multiplier;

  wire data_a_in_enable_vector_multiplier;
  wire data_b_in_enable_vector_multiplier;
  wire data_out_enable_vector_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_multiplier;
  wire [DATA_SIZE-1:0] size_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  // VECTOR INVERTER
  // CONTROL
  wire start_vector_inverter;
  wire ready_vector_inverter;

  wire data_in_enable_vector_inverter;
  wire data_out_enable_vector_inverter;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_inverter;
  wire [DATA_SIZE-1:0] size_in_vector_inverter;
  wire [DATA_SIZE-1:0] data_in_vector_inverter;
  wire [DATA_SIZE-1:0] data_out_vector_inverter;

  // VECTOR DIVIDER
  // CONTROL
  wire start_vector_divider;
  wire ready_vector_divider;

  wire data_a_in_enable_vector_divider;
  wire data_b_in_enable_vector_divider;
  wire data_out_enable_vector_divider;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_divider;
  wire [DATA_SIZE-1:0] size_in_vector_divider;
  wire [DATA_SIZE-1:0] data_a_in_vector_divider;
  wire [DATA_SIZE-1:0] data_b_in_vector_divider;
  wire [DATA_SIZE-1:0] data_out_vector_divider;

  // VECTOR EXPONENTIATOR
  // CONTROL
  wire start_vector_exponentiator;
  wire ready_vector_exponentiator;

  wire data_a_in_enable_vector_exponentiator;
  wire data_b_in_enable_vector_exponentiator;
  wire data_out_enable_vector_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] size_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_a_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_b_in_vector_exponentiator;
  wire [DATA_SIZE-1:0] data_out_vector_exponentiator;

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  // CONTROL
  wire start_matrix_adder;
  wire ready_matrix_adder;

  wire operation_matrix_adder;

  wire data_a_in_i_enable_matrix_adder;
  wire data_a_in_j_enable_matrix_adder;
  wire data_b_in_i_enable_matrix_adder;
  wire data_b_in_j_enable_matrix_adder;
  wire data_out_i_enable_matrix_adder;
  wire data_out_j_enable_matrix_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_adder;
  wire [DATA_SIZE-1:0] size_i_in_matrix_adder;
  wire [DATA_SIZE-1:0] size_j_in_matrix_adder;
  wire [DATA_SIZE-1:0] data_a_in_matrix_adder;
  wire [DATA_SIZE-1:0] data_b_in_matrix_adder;
  wire [DATA_SIZE-1:0] data_out_matrix_adder;

  // MATRIX MULTIPLIER
  // CONTROL
  wire start_matrix_multiplier;
  wire ready_matrix_multiplier;

  wire data_a_in_i_enable_matrix_multiplier;
  wire data_a_in_j_enable_matrix_multiplier;
  wire data_b_in_i_enable_matrix_multiplier;
  wire data_b_in_j_enable_matrix_multiplier;
  wire data_out_i_enable_matrix_multiplier;
  wire data_out_j_enable_matrix_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_multiplier;
  wire [DATA_SIZE-1:0] size_i_in_matrix_multiplier;
  wire [DATA_SIZE-1:0] size_j_in_matrix_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_matrix_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_matrix_multiplier;
  wire [DATA_SIZE-1:0] data_out_matrix_multiplier;

  // MATRIX INVERTER
  // CONTROL
  wire start_matrix_inverter;
  wire ready_matrix_inverter;

  wire data_in_i_enable_matrix_inverter;
  wire data_in_j_enable_matrix_inverter;
  wire data_out_i_enable_matrix_inverter;
  wire data_out_j_enable_matrix_inverter;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_inverter;
  wire [DATA_SIZE-1:0] size_i_in_matrix_inverter;
  wire [DATA_SIZE-1:0] size_j_in_matrix_inverter;
  wire [DATA_SIZE-1:0] data_in_matrix_inverter;
  wire [DATA_SIZE-1:0] data_out_matrix_inverter;

  // MATRIX DIVIDER
  // CONTROL
  wire start_matrix_divider;
  wire ready_matrix_divider;

  wire data_a_in_i_enable_matrix_divider;
  wire data_a_in_j_enable_matrix_divider;
  wire data_b_in_i_enable_matrix_divider;
  wire data_b_in_j_enable_matrix_divider;
  wire data_out_i_enable_matrix_divider;
  wire data_out_j_enable_matrix_divider;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_divider;
  wire [DATA_SIZE-1:0] size_i_in_matrix_divider;
  wire [DATA_SIZE-1:0] size_j_in_matrix_divider;
  wire [DATA_SIZE-1:0] data_a_in_matrix_divider;
  wire [DATA_SIZE-1:0] data_b_in_matrix_divider;
  wire [DATA_SIZE-1:0] data_out_matrix_divider;

  // MATRIX EXPONENTIATOR
  // CONTROL
  wire start_matrix_exponentiator;
  wire ready_matrix_exponentiator;

  wire data_a_in_i_enable_matrix_exponentiator;
  wire data_a_in_j_enable_matrix_exponentiator;
  wire data_b_in_i_enable_matrix_exponentiator;
  wire data_b_in_j_enable_matrix_exponentiator;
  wire data_out_i_enable_matrix_exponentiator;
  wire data_out_j_enable_matrix_exponentiator;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] size_i_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] size_j_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] data_a_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] data_b_in_matrix_exponentiator;
  wire [DATA_SIZE-1:0] data_out_matrix_exponentiator;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////
  ntm_float_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // SCALAR-FUNCTIONALITY
    .STIMULUS_NTM_SCALAR_ADDER_TEST(STIMULUS_NTM_SCALAR_ADDER_TEST),
    .STIMULUS_NTM_SCALAR_MULTIPLIER_TEST(STIMULUS_NTM_SCALAR_MULTIPLIER_TEST),
    .STIMULUS_NTM_SCALAR_INVERTER_TEST(STIMULUS_NTM_SCALAR_INVERTER_TEST),
    .STIMULUS_NTM_SCALAR_DIVIDER_TEST(STIMULUS_NTM_SCALAR_DIVIDER_TEST),
    .STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST(STIMULUS_NTM_SCALAR_EXPONENTIATOR_TEST),
    .STIMULUS_NTM_SCALAR_ADDER_CASE_0(STIMULUS_NTM_SCALAR_ADDER_CASE_0),
    .STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0(STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_0),
    .STIMULUS_NTM_SCALAR_INVERTER_CASE_0(STIMULUS_NTM_SCALAR_INVERTER_CASE_0),
    .STIMULUS_NTM_SCALAR_DIVIDER_CASE_0(STIMULUS_NTM_SCALAR_DIVIDER_CASE_0),
    .STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0(STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_0),
    .STIMULUS_NTM_SCALAR_ADDER_CASE_1(STIMULUS_NTM_SCALAR_ADDER_CASE_1),
    .STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1(STIMULUS_NTM_SCALAR_MULTIPLIER_CASE_1),
    .STIMULUS_NTM_SCALAR_INVERTER_CASE_1(STIMULUS_NTM_SCALAR_INVERTER_CASE_1),
    .STIMULUS_NTM_SCALAR_DIVIDER_CASE_1(STIMULUS_NTM_SCALAR_DIVIDER_CASE_1),
    .STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1(STIMULUS_NTM_SCALAR_EXPONENTIATOR_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_NTM_VECTOR_ADDER_TEST(STIMULUS_NTM_VECTOR_ADDER_TEST),
    .STIMULUS_NTM_VECTOR_MULTIPLIER_TEST(STIMULUS_NTM_VECTOR_MULTIPLIER_TEST),
    .STIMULUS_NTM_VECTOR_INVERTER_TEST(STIMULUS_NTM_VECTOR_INVERTER_TEST),
    .STIMULUS_NTM_VECTOR_DIVIDER_TEST(STIMULUS_NTM_VECTOR_DIVIDER_TEST),
    .STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST(STIMULUS_NTM_VECTOR_EXPONENTIATOR_TEST),
    .STIMULUS_NTM_VECTOR_ADDER_CASE_0(STIMULUS_NTM_VECTOR_ADDER_CASE_0),
    .STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0(STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_0),
    .STIMULUS_NTM_VECTOR_INVERTER_CASE_0(STIMULUS_NTM_VECTOR_INVERTER_CASE_0),
    .STIMULUS_NTM_VECTOR_DIVIDER_CASE_0(STIMULUS_NTM_VECTOR_DIVIDER_CASE_0),
    .STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0(STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_0),
    .STIMULUS_NTM_VECTOR_ADDER_CASE_1(STIMULUS_NTM_VECTOR_ADDER_CASE_1),
    .STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1(STIMULUS_NTM_VECTOR_MULTIPLIER_CASE_1),
    .STIMULUS_NTM_VECTOR_INVERTER_CASE_1(STIMULUS_NTM_VECTOR_INVERTER_CASE_1),
    .STIMULUS_NTM_VECTOR_DIVIDER_CASE_1(STIMULUS_NTM_VECTOR_DIVIDER_CASE_1),
    .STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1(STIMULUS_NTM_VECTOR_EXPONENTIATOR_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_NTM_MATRIX_ADDER_TEST(STIMULUS_NTM_MATRIX_ADDER_TEST),
    .STIMULUS_NTM_MATRIX_MULTIPLIER_TEST(STIMULUS_NTM_MATRIX_MULTIPLIER_TEST),
    .STIMULUS_NTM_MATRIX_INVERTER_TEST(STIMULUS_NTM_MATRIX_INVERTER_TEST),
    .STIMULUS_NTM_MATRIX_DIVIDER_TEST(STIMULUS_NTM_MATRIX_DIVIDER_TEST),
    .STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST(STIMULUS_NTM_MATRIX_EXPONENTIATOR_TEST),
    .STIMULUS_NTM_MATRIX_ADDER_CASE_0(STIMULUS_NTM_MATRIX_ADDER_CASE_0),
    .STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0(STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_0),
    .STIMULUS_NTM_MATRIX_INVERTER_CASE_0(STIMULUS_NTM_MATRIX_INVERTER_CASE_0),
    .STIMULUS_NTM_MATRIX_DIVIDER_CASE_0(STIMULUS_NTM_MATRIX_DIVIDER_CASE_0),
    .STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0(STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_0),
    .STIMULUS_NTM_MATRIX_ADDER_CASE_1(STIMULUS_NTM_MATRIX_ADDER_CASE_1),
    .STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1(STIMULUS_NTM_MATRIX_MULTIPLIER_CASE_1),
    .STIMULUS_NTM_MATRIX_INVERTER_CASE_1(STIMULUS_NTM_MATRIX_INVERTER_CASE_1),
    .STIMULUS_NTM_MATRIX_DIVIDER_CASE_1(STIMULUS_NTM_MATRIX_DIVIDER_CASE_1),
    .STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1(STIMULUS_NTM_MATRIX_EXPONENTIATOR_CASE_1)
  )
  float_stimulus(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR ADDER
    // CONTROL
    .SCALAR_ADDER_START(start_scalar_adder),
    .SCALAR_ADDER_READY(ready_scalar_adder),

    .SCALAR_ADDER_OPERATION(operation_scalar_adder),

    // DATA
    .SCALAR_ADDER_DATA_A_IN(data_a_in_scalar_adder),
    .SCALAR_ADDER_DATA_B_IN(data_b_in_scalar_adder),
    .SCALAR_ADDER_DATA_OUT(data_out_scalar_adder),

    // SCALAR MULTIPLIER
    // CONTROL
    .SCALAR_MULTIPLIER_START(start_scalar_multiplier),
    .SCALAR_MULTIPLIER_READY(ready_scalar_multiplier),

    // DATA
    .SCALAR_MULTIPLIER_DATA_A_IN(data_a_in_scalar_multiplier),
    .SCALAR_MULTIPLIER_DATA_B_IN(data_b_in_scalar_multiplier),
    .SCALAR_MULTIPLIER_DATA_OUT(data_out_scalar_multiplier),

    // SCALAR INVERTER
    // CONTROL
    .SCALAR_INVERTER_START(start_scalar_inverter),
    .SCALAR_INVERTER_READY(ready_scalar_inverter),

    // DATA
    .SCALAR_INVERTER_DATA_IN(data_in_scalar_inverter),
    .SCALAR_INVERTER_DATA_OUT(data_out_scalar_inverter),

    // SCALAR DIVIDER
    // CONTROL
    .SCALAR_DIVIDER_START(start_scalar_divider),
    .SCALAR_DIVIDER_READY(ready_scalar_divider),

    // DATA
    .SCALAR_DIVIDER_DATA_A_IN(data_a_in_scalar_divider),
    .SCALAR_DIVIDER_DATA_B_IN(data_b_in_scalar_divider),
    .SCALAR_DIVIDER_DATA_OUT(data_out_scalar_divider),

    // SCALAR EXPONENTIATOR
    // CONTROL
    .SCALAR_EXPONENTIATOR_START(start_scalar_exponentiator),
    .SCALAR_EXPONENTIATOR_READY(ready_scalar_exponentiator),

    // DATA
    .SCALAR_EXPONENTIATOR_DATA_A_IN(data_a_in_scalar_exponentiator),
    .SCALAR_EXPONENTIATOR_DATA_B_IN(data_b_in_scalar_exponentiator),
    .SCALAR_EXPONENTIATOR_DATA_OUT(data_out_scalar_exponentiator),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR ADDER
    // CONTROL
    .VECTOR_ADDER_START(start_vector_adder),
    .VECTOR_ADDER_READY(ready_vector_adder),

    .VECTOR_ADDER_OPERATION(operation_vector_adder),

    .VECTOR_ADDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .VECTOR_ADDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .VECTOR_ADDER_DATA_OUT_ENABLE(data_out_enable_vector_adder),

    // DATA
    .VECTOR_ADDER_SIZE_IN(size_in_vector_adder),
    .VECTOR_ADDER_DATA_A_IN(data_a_in_vector_adder),
    .VECTOR_ADDER_DATA_B_IN(data_b_in_vector_adder),
    .VECTOR_ADDER_DATA_OUT(data_out_vector_adder),

    // VECTOR MULTIPLIER
    // CONTROL
    .VECTOR_MULTIPLIER_START(start_vector_multiplier),
    .VECTOR_MULTIPLIER_READY(ready_vector_multiplier),

    .VECTOR_MULTIPLIER_DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .VECTOR_MULTIPLIER_DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .VECTOR_MULTIPLIER_DATA_OUT_ENABLE(data_out_enable_vector_multiplier),

    // DATA
    .VECTOR_MULTIPLIER_SIZE_IN(size_in_vector_multiplier),
    .VECTOR_MULTIPLIER_DATA_A_IN(data_a_in_vector_multiplier),
    .VECTOR_MULTIPLIER_DATA_B_IN(data_b_in_vector_multiplier),
    .VECTOR_MULTIPLIER_DATA_OUT(data_out_vector_multiplier),

    // VECTOR INVERTER
    // CONTROL
    .VECTOR_INVERTER_START(start_vector_inverter),
    .VECTOR_INVERTER_READY(ready_vector_inverter),

    .VECTOR_INVERTER_DATA_IN_ENABLE(data_in_enable_vector_inverter),
    .VECTOR_INVERTER_DATA_OUT_ENABLE(data_out_enable_vector_inverter),

    // DATA
    .VECTOR_INVERTER_SIZE_IN(size_in_vector_inverter),
    .VECTOR_INVERTER_DATA_IN(data_in_vector_inverter),
    .VECTOR_INVERTER_DATA_OUT(data_out_vector_inverter),

    // VECTOR DIVIDER
    // CONTROL
    .VECTOR_DIVIDER_START(start_vector_divider),
    .VECTOR_DIVIDER_READY(ready_vector_divider),

    .VECTOR_DIVIDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_divider),
    .VECTOR_DIVIDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_divider),
    .VECTOR_DIVIDER_DATA_OUT_ENABLE(data_out_enable_vector_divider),

    // DATA
    .VECTOR_DIVIDER_SIZE_IN(size_in_vector_divider),
    .VECTOR_DIVIDER_DATA_A_IN(data_a_in_vector_divider),
    .VECTOR_DIVIDER_DATA_B_IN(data_b_in_vector_divider),
    .VECTOR_DIVIDER_DATA_OUT(data_out_vector_divider),

    // VECTOR EXPONENTIATOR
    // CONTROL
    .VECTOR_EXPONENTIATOR_START(start_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_READY(ready_vector_exponentiator),

    .VECTOR_EXPONENTIATOR_DATA_A_IN_ENABLE(data_a_in_enable_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_B_IN_ENABLE(data_b_in_enable_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_OUT_ENABLE(data_out_enable_vector_exponentiator),

    // DATA
    .VECTOR_EXPONENTIATOR_SIZE_IN(size_in_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_A_IN(data_a_in_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_B_IN(data_b_in_vector_exponentiator),
    .VECTOR_EXPONENTIATOR_DATA_OUT(data_out_vector_exponentiator),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////

    // MATRIX ADDER
    // CONTROL
    .MATRIX_ADDER_START(start_matrix_adder),
    .MATRIX_ADDER_READY(ready_matrix_adder),

    .MATRIX_ADDER_OPERATION(operation_matrix_adder),

    .MATRIX_ADDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_adder),
    .MATRIX_ADDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_adder),
    .MATRIX_ADDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_adder),
    .MATRIX_ADDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_adder),
    .MATRIX_ADDER_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_adder),
    .MATRIX_ADDER_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_adder),

    // DATA
    .MATRIX_ADDER_SIZE_I_IN(size_i_in_matrix_adder),
    .MATRIX_ADDER_SIZE_J_IN(size_j_in_matrix_adder),
    .MATRIX_ADDER_DATA_A_IN(data_a_in_matrix_adder),
    .MATRIX_ADDER_DATA_B_IN(data_b_in_matrix_adder),
    .MATRIX_ADDER_DATA_OUT(data_out_matrix_adder),

    // MATRIX MULTIPLIER
    // CONTROL
    .MATRIX_MULTIPLIER_START(start_matrix_multiplier),
    .MATRIX_MULTIPLIER_READY(ready_matrix_multiplier),

    .MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_multiplier),

    // DATA
    .MATRIX_MULTIPLIER_SIZE_I_IN(size_i_in_matrix_multiplier),
    .MATRIX_MULTIPLIER_SIZE_J_IN(size_j_in_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_A_IN(data_a_in_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_B_IN(data_b_in_matrix_multiplier),
    .MATRIX_MULTIPLIER_DATA_OUT(data_out_matrix_multiplier),

    // MATRIX INVERTER
    // CONTROL
    .MATRIX_INVERTER_START(start_matrix_inverter),
    .MATRIX_INVERTER_READY(ready_matrix_inverter),

    .MATRIX_INVERTER_DATA_IN_I_ENABLE(data_in_i_enable_matrix_inverter),
    .MATRIX_INVERTER_DATA_IN_J_ENABLE(data_in_j_enable_matrix_inverter),
    .MATRIX_INVERTER_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_inverter),
    .MATRIX_INVERTER_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_inverter),

    // DATA
    .MATRIX_INVERTER_SIZE_I_IN(size_i_in_matrix_inverter),
    .MATRIX_INVERTER_SIZE_J_IN(size_j_in_matrix_inverter),
    .MATRIX_INVERTER_DATA_IN(data_in_matrix_inverter),
    .MATRIX_INVERTER_DATA_OUT(data_out_matrix_inverter),

    // MATRIX DIVIDER
    // CONTROL
    .MATRIX_DIVIDER_START(start_matrix_divider),
    .MATRIX_DIVIDER_READY(ready_matrix_divider),

    .MATRIX_DIVIDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_divider),
    .MATRIX_DIVIDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_divider),
    .MATRIX_DIVIDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_divider),
    .MATRIX_DIVIDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_divider),
    .MATRIX_DIVIDER_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_divider),
    .MATRIX_DIVIDER_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_divider),

    // DATA
    .MATRIX_DIVIDER_SIZE_I_IN(size_i_in_matrix_divider),
    .MATRIX_DIVIDER_SIZE_J_IN(size_j_in_matrix_divider),
    .MATRIX_DIVIDER_DATA_A_IN(data_a_in_matrix_divider),
    .MATRIX_DIVIDER_DATA_B_IN(data_b_in_matrix_divider),
    .MATRIX_DIVIDER_DATA_OUT(data_out_matrix_divider),

    // MATRIX EXPONENTIATOR
    // CONTROL
    .MATRIX_EXPONENTIATOR_START(start_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_READY(ready_matrix_exponentiator),

    .MATRIX_EXPONENTIATOR_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_exponentiator),

    // DATA
    .MATRIX_EXPONENTIATOR_SIZE_I_IN(size_i_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_SIZE_J_IN(size_j_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_A_IN(data_a_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_B_IN(data_b_in_matrix_exponentiator),
    .MATRIX_EXPONENTIATOR_DATA_OUT(data_out_matrix_exponentiator)
  );

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  ntm_scalar_adder #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
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
    .DATA_OUT(data_out_scalar_adder)
  );

  // SCALAR MULTIPLIER
  ntm_scalar_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  scalar_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_multiplier),
    .READY(ready_scalar_adder),

    // DATA
    .MODULO_IN(modulo_in_scalar_multiplier),
    .DATA_A_IN(data_a_in_scalar_multiplier),
    .DATA_B_IN(data_b_in_scalar_multiplier),
    .DATA_OUT(data_out_scalar_multiplier)
  );

  // SCALAR INVERTER
  ntm_scalar_inverter #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  scalar_inverter(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_inverter),
    .READY(ready_scalar_inverter),

    // DATA
    .MODULO_IN(modulo_in_scalar_inverter),
    .DATA_IN(data_in_scalar_inverter),
    .DATA_OUT(data_out_scalar_inverter)
  );

  // SCALAR DIVIDER
  ntm_scalar_divider #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  scalar_divider(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_divider),
    .READY(ready_scalar_divider),

    // DATA
    .MODULO_IN(modulo_in_scalar_divider),
    .DATA_A_IN(data_a_in_scalar_divider),
    .DATA_B_IN(data_b_in_scalar_divider),
    .DATA_OUT(data_out_scalar_divider)
  );

  // SCALAR EXPONENTIATOR
  ntm_scalar_exponentiator #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  scalar_exponentiator(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_exponentiator),
    .READY(ready_scalar_exponentiator),

    // DATA
    .MODULO_IN(modulo_in_scalar_exponentiator),
    .DATA_A_IN(data_a_in_scalar_exponentiator),
    .DATA_B_IN(data_b_in_scalar_exponentiator),
    .DATA_OUT(data_out_scalar_exponentiator)
  );

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  ntm_vector_adder #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
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
    .DATA_OUT(data_out_vector_adder)
  );

  // VECTOR MULTIPLIER
  ntm_vector_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
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
    .DATA_OUT(data_out_vector_multiplier)
  );

  // VECTOR INVERTER
  ntm_vector_inverter #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_inverter(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_inverter),
    .READY(ready_vector_inverter),

    .DATA_IN_ENABLE(data_in_enable_vector_inverter),
    .DATA_OUT_ENABLE(data_out_enable_vector_inverter),

    // DATA
    .MODULO_IN(modulo_in_vector_inverter),
    .SIZE_IN(size_in_vector_inverter),
    .DATA_IN(data_in_vector_inverter),
    .DATA_OUT(data_out_vector_inverter)
  );

  // VECTOR DIVIDER
  ntm_vector_divider #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_divider(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_divider),
    .READY(ready_vector_divider),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_divider),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_divider),
    .DATA_OUT_ENABLE(data_out_enable_vector_divider),

    // DATA
    .MODULO_IN(modulo_in_vector_divider),
    .SIZE_IN(size_in_vector_divider),
    .DATA_A_IN(data_a_in_vector_divider),
    .DATA_B_IN(data_b_in_vector_divider),
    .DATA_OUT(data_out_vector_divider)
  );

  // VECTOR EXPONENTIATOR
  ntm_vector_exponentiator #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
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
    .DATA_OUT(data_out_vector_exponentiator)
  );

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  ntm_matrix_adder #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  matrix_adder(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_adder),
    .READY(ready_matrix_adder),

    .OPERATION(operation_matrix_adder),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_adder),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_adder),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_adder),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_adder),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_adder),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_adder),

    // DATA
    .MODULO_IN(modulo_in_matrix_adder),
    .SIZE_I_IN(size_i_in_matrix_adder),
    .SIZE_J_IN(size_j_in_matrix_adder),
    .DATA_A_IN(data_a_in_matrix_adder),
    .DATA_B_IN(data_b_in_matrix_adder),
    .DATA_OUT(data_out_matrix_adder)
  );

  // MATRIX MULTIPLIER
  ntm_matrix_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  matrix_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_multiplier),
    .READY(ready_matrix_multiplier),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_multiplier),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_multiplier),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_multiplier),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_multiplier),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_multiplier),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_multiplier),

    // DATA
    .MODULO_IN(modulo_in_matrix_multiplier),
    .SIZE_I_IN(size_i_in_matrix_multiplier),
    .SIZE_J_IN(size_j_in_matrix_multiplier),
    .DATA_A_IN(data_a_in_matrix_multiplier),
    .DATA_B_IN(data_b_in_matrix_multiplier),
    .DATA_OUT(data_out_matrix_multiplier)
  );

  // MATRIX INVERTER
  ntm_matrix_inverter #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  matrix_inverter(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_inverter),
    .READY(ready_matrix_inverter),

    .DATA_IN_I_ENABLE(data_in_i_enable_matrix_inverter),
    .DATA_IN_J_ENABLE(data_in_j_enable_matrix_inverter),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_inverter),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_inverter),

    // DATA
    .MODULO_IN(modulo_in_matrix_inverter),
    .SIZE_I_IN(size_i_in_matrix_inverter),
    .SIZE_J_IN(size_j_in_matrix_inverter),
    .DATA_IN(data_in_matrix_inverter),
    .DATA_OUT(data_out_matrix_inverter)
  );

  // MATRIX DIVIDER
  ntm_matrix_divider #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  matrix_divider(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_divider),
    .READY(ready_matrix_divider),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_divider),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_divider),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_divider),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_divider),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_divider),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_divider),

    // DATA
    .MODULO_IN(modulo_in_matrix_divider),
    .SIZE_I_IN(size_i_in_matrix_divider),
    .SIZE_J_IN(size_j_in_matrix_divider),
    .DATA_A_IN(data_a_in_matrix_divider),
    .DATA_B_IN(data_b_in_matrix_divider),
    .DATA_OUT(data_out_matrix_divider)
  );

  // MATRIX EXPONENTIATOR
  ntm_matrix_exponentiator #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  matrix_exponentiator(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_exponentiator),
    .READY(ready_matrix_exponentiator),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_exponentiator),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_exponentiator),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_exponentiator),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_exponentiator),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_exponentiator),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_exponentiator),

    // DATA
    .MODULO_IN(modulo_in_matrix_exponentiator),
    .SIZE_I_IN(size_i_in_matrix_exponentiator),
    .SIZE_J_IN(size_j_in_matrix_exponentiator),
    .DATA_A_IN(data_a_in_matrix_exponentiator),
    .DATA_B_IN(data_b_in_matrix_exponentiator),
    .DATA_OUT(data_out_matrix_exponentiator)
  );

endmodule
