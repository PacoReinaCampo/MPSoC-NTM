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

module model_integer_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE = 64;
  parameter CONTROL_SIZE = 4;

  parameter X = 64;
  parameter Y = 64;
  parameter N = 64;
  parameter W = 64;
  parameter L = 64;
  parameter R = 64;

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST = 0;

  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_1 = 0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST = 0;

  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST = 0;

  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_1 = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////
  // GLOBAL
  wire                 CLK;
  wire                 RST;

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  // CONTROL
  wire                 start_scalar_integer_adder;
  wire                 ready_scalar_integer_adder;

  wire                 operation_scalar_integer_adder;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_integer_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_integer_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_integer_adder;
  wire                 overflow_out_scalar_integer_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire                 start_scalar_integer_multiplier;
  wire                 ready_scalar_integer_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_integer_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_integer_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_integer_multiplier;
  wire [DATA_SIZE-1:0] overflow_out_scalar_integer_multiplier;

  // SCALAR DIVIDER
  // CONTROL
  wire                 start_scalar_integer_divider;
  wire                 ready_scalar_integer_divider;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_integer_divider;
  wire [DATA_SIZE-1:0] data_b_in_scalar_integer_divider;
  wire [DATA_SIZE-1:0] data_out_scalar_integer_divider;
  wire [DATA_SIZE-1:0] rest_out_scalar_integer_divider;

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  // CONTROL
  wire                 start_vector_integer_adder;
  wire                 ready_vector_integer_adder;

  wire                 operation_vector_integer_adder;

  wire                 data_a_in_enable_vector_integer_adder;
  wire                 data_b_in_enable_vector_integer_adder;
  wire                 data_out_enable_vector_integer_adder;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_integer_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_integer_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_integer_adder;
  wire [DATA_SIZE-1:0] data_out_vector_integer_adder;
  wire                 overflow_out_vector_integer_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire                 start_vector_integer_multiplier;
  wire                 ready_vector_integer_multiplier;

  wire                 data_a_in_enable_vector_integer_multiplier;
  wire                 data_b_in_enable_vector_integer_multiplier;
  wire                 data_out_enable_vector_integer_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_integer_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_integer_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_integer_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_integer_multiplier;
  wire [DATA_SIZE-1:0] overflow_out_vector_integer_multiplier;

  // VECTOR DIVIDER
  // CONTROL
  wire                 start_vector_integer_divider;
  wire                 ready_vector_integer_divider;

  wire                 data_a_in_enable_vector_integer_divider;
  wire                 data_b_in_enable_vector_integer_divider;
  wire                 data_out_enable_vector_integer_divider;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_integer_divider;
  wire [DATA_SIZE-1:0] data_a_in_vector_integer_divider;
  wire [DATA_SIZE-1:0] data_b_in_vector_integer_divider;
  wire [DATA_SIZE-1:0] data_out_vector_integer_divider;
  wire [DATA_SIZE-1:0] rest_out_vector_integer_divider;

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  // CONTROL
  wire                 start_matrix_integer_adder;
  wire                 ready_matrix_integer_adder;

  wire                 operation_matrix_integer_adder;

  wire                 data_a_in_i_enable_matrix_integer_adder;
  wire                 data_a_in_j_enable_matrix_integer_adder;
  wire                 data_b_in_i_enable_matrix_integer_adder;
  wire                 data_b_in_j_enable_matrix_integer_adder;
  wire                 data_out_i_enable_matrix_integer_adder;
  wire                 data_out_j_enable_matrix_integer_adder;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_integer_adder;
  wire [DATA_SIZE-1:0] size_j_in_matrix_integer_adder;
  wire [DATA_SIZE-1:0] data_a_in_matrix_integer_adder;
  wire [DATA_SIZE-1:0] data_b_in_matrix_integer_adder;
  wire [DATA_SIZE-1:0] data_out_matrix_integer_adder;
  wire                 overflow_out_matrix_integer_adder;

  // MATRIX MULTIPLIER
  // CONTROL
  wire                 start_matrix_integer_multiplier;
  wire                 ready_matrix_integer_multiplier;

  wire                 data_a_in_i_enable_matrix_integer_multiplier;
  wire                 data_a_in_j_enable_matrix_integer_multiplier;
  wire                 data_b_in_i_enable_matrix_integer_multiplier;
  wire                 data_b_in_j_enable_matrix_integer_multiplier;
  wire                 data_out_i_enable_matrix_integer_multiplier;
  wire                 data_out_j_enable_matrix_integer_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_integer_multiplier;
  wire [DATA_SIZE-1:0] size_j_in_matrix_integer_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_matrix_integer_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_matrix_integer_multiplier;
  wire [DATA_SIZE-1:0] data_out_matrix_integer_multiplier;
  wire [DATA_SIZE-1:0] overflow_out_matrix_integer_multiplier;

  // MATRIX DIVIDER
  // CONTROL
  wire                 start_matrix_integer_divider;
  wire                 ready_matrix_integer_divider;

  wire                 data_a_in_i_enable_matrix_integer_divider;
  wire                 data_a_in_j_enable_matrix_integer_divider;
  wire                 data_b_in_i_enable_matrix_integer_divider;
  wire                 data_b_in_j_enable_matrix_integer_divider;
  wire                 data_out_i_enable_matrix_integer_divider;
  wire                 data_out_j_enable_matrix_integer_divider;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_integer_divider;
  wire [DATA_SIZE-1:0] size_j_in_matrix_integer_divider;
  wire [DATA_SIZE-1:0] data_a_in_matrix_integer_divider;
  wire [DATA_SIZE-1:0] data_b_in_matrix_integer_divider;
  wire [DATA_SIZE-1:0] data_out_matrix_integer_divider;
  wire [DATA_SIZE-1:0] rest_out_matrix_integer_divider;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  model_integer_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // SCALAR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST       (STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST  (STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST     (STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_0     (STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_0(STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_0   (STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_1     (STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_1(STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_1   (STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST       (STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST  (STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST     (STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_0     (STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_0(STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_0   (STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_1     (STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_1(STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_1   (STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST       (STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST  (STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST     (STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_0     (STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_0(STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_0   (STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_1     (STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_1(STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_1   (STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_1)
  ) integer_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    //////////////////////////////////////////////////////////////////////////////

    // SCALAR ADDER
    // CONTROL
    .SCALAR_INTEGER_ADDER_START(start_scalar_integer_adder),
    .SCALAR_INTEGER_ADDER_READY(ready_scalar_integer_adder),

    .SCALAR_INTEGER_ADDER_OPERATION(operation_scalar_integer_adder),

    // DATA
    .SCALAR_INTEGER_ADDER_DATA_A_IN(data_a_in_scalar_integer_adder),
    .SCALAR_INTEGER_ADDER_DATA_B_IN(data_b_in_scalar_integer_adder),

    .SCALAR_INTEGER_ADDER_DATA_OUT    (data_out_scalar_integer_adder),
    .SCALAR_INTEGER_ADDER_OVERFLOW_OUT(overflow_out_scalar_integer_adder),

    // SCALAR MULTIPLIER
    // CONTROL
    .SCALAR_INTEGER_MULTIPLIER_START(start_scalar_integer_multiplier),
    .SCALAR_INTEGER_MULTIPLIER_READY(ready_scalar_integer_multiplier),

    // DATA
    .SCALAR_INTEGER_MULTIPLIER_DATA_A_IN(data_a_in_scalar_integer_multiplier),
    .SCALAR_INTEGER_MULTIPLIER_DATA_B_IN(data_b_in_scalar_integer_multiplier),

    .SCALAR_INTEGER_MULTIPLIER_DATA_OUT    (data_out_scalar_integer_multiplier),
    .SCALAR_INTEGER_MULTIPLIER_OVERFLOW_OUT(overflow_out_scalar_integer_multiplier),

    // SCALAR DIVIDER
    // CONTROL
    .SCALAR_INTEGER_DIVIDER_START(start_scalar_integer_divider),
    .SCALAR_INTEGER_DIVIDER_READY(ready_scalar_integer_divider),

    // DATA
    .SCALAR_INTEGER_DIVIDER_DATA_A_IN(data_a_in_scalar_integer_divider),
    .SCALAR_INTEGER_DIVIDER_DATA_B_IN(data_b_in_scalar_integer_divider),

    .SCALAR_INTEGER_DIVIDER_DATA_OUT(data_out_scalar_integer_divider),
    .SCALAR_INTEGER_DIVIDER_REST_OUT(rest_out_scalar_integer_divider),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    //////////////////////////////////////////////////////////////////////////////

    // VECTOR ADDER
    // CONTROL
    .VECTOR_INTEGER_ADDER_START(start_vector_integer_adder),
    .VECTOR_INTEGER_ADDER_READY(ready_vector_integer_adder),

    .VECTOR_INTEGER_ADDER_OPERATION(operation_vector_integer_adder),

    .VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_integer_adder),
    .VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_integer_adder),
    .VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE (data_out_enable_vector_integer_adder),

    // DATA
    .VECTOR_INTEGER_ADDER_SIZE_IN  (size_in_vector_integer_adder),
    .VECTOR_INTEGER_ADDER_DATA_A_IN(data_a_in_vector_integer_adder),
    .VECTOR_INTEGER_ADDER_DATA_B_IN(data_b_in_vector_integer_adder),

    .VECTOR_INTEGER_ADDER_DATA_OUT    (data_out_vector_integer_adder),
    .VECTOR_INTEGER_ADDER_OVERFLOW_OUT(overflow_out_vector_integer_adder),

    // VECTOR MULTIPLIER
    // CONTROL
    .VECTOR_INTEGER_MULTIPLIER_START(start_vector_integer_multiplier),
    .VECTOR_INTEGER_MULTIPLIER_READY(ready_vector_integer_multiplier),

    .VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE(data_a_in_enable_vector_integer_multiplier),
    .VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE(data_b_in_enable_vector_integer_multiplier),
    .VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE (data_out_enable_vector_integer_multiplier),

    // DATA
    .VECTOR_INTEGER_MULTIPLIER_SIZE_IN  (size_in_vector_integer_multiplier),
    .VECTOR_INTEGER_MULTIPLIER_DATA_A_IN(data_a_in_vector_integer_multiplier),
    .VECTOR_INTEGER_MULTIPLIER_DATA_B_IN(data_b_in_vector_integer_multiplier),

    .VECTOR_INTEGER_MULTIPLIER_DATA_OUT    (data_out_vector_integer_multiplier),
    .VECTOR_INTEGER_MULTIPLIER_OVERFLOW_OUT(overflow_out_vector_integer_multiplier),

    // VECTOR DIVIDER
    // CONTROL
    .VECTOR_INTEGER_DIVIDER_START(start_vector_integer_divider),
    .VECTOR_INTEGER_DIVIDER_READY(ready_vector_integer_divider),

    .VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_integer_divider),
    .VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_integer_divider),
    .VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE (data_out_enable_vector_integer_divider),

    // DATA
    .VECTOR_INTEGER_DIVIDER_SIZE_IN  (size_in_vector_integer_divider),
    .VECTOR_INTEGER_DIVIDER_DATA_A_IN(data_a_in_vector_integer_divider),
    .VECTOR_INTEGER_DIVIDER_DATA_B_IN(data_b_in_vector_integer_divider),

    .VECTOR_INTEGER_DIVIDER_DATA_OUT(data_out_vector_integer_divider),
    .VECTOR_INTEGER_DIVIDER_REST_OUT(rest_out_vector_integer_divider),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    //////////////////////////////////////////////////////////////////////////////

    // MATRIX ADDER
    // CONTROL
    .MATRIX_INTEGER_ADDER_START(start_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_READY(ready_matrix_integer_adder),

    .MATRIX_INTEGER_ADDER_OPERATION(operation_matrix_integer_adder),

    .MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_integer_adder),

    // DATA
    .MATRIX_INTEGER_ADDER_SIZE_I_IN(size_i_in_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_SIZE_J_IN(size_j_in_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_A_IN(data_a_in_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_DATA_B_IN(data_b_in_matrix_integer_adder),

    .MATRIX_INTEGER_ADDER_DATA_OUT    (data_out_matrix_integer_adder),
    .MATRIX_INTEGER_ADDER_OVERFLOW_OUT(overflow_out_matrix_integer_adder),

    // MATRIX MULTIPLIER
    // CONTROL
    .MATRIX_INTEGER_MULTIPLIER_START(start_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_READY(ready_matrix_integer_multiplier),

    .MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_integer_multiplier),

    // DATA
    .MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN(size_i_in_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN(size_j_in_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_A_IN(data_a_in_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_DATA_B_IN(data_b_in_matrix_integer_multiplier),

    .MATRIX_INTEGER_MULTIPLIER_DATA_OUT    (data_out_matrix_integer_multiplier),
    .MATRIX_INTEGER_MULTIPLIER_OVERFLOW_OUT(overflow_out_matrix_integer_multiplier),

    // MATRIX DIVIDER
    // CONTROL
    .MATRIX_INTEGER_DIVIDER_START(start_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_READY(ready_matrix_integer_divider),

    .MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_integer_divider),

    // DATA
    .MATRIX_INTEGER_DIVIDER_SIZE_I_IN(size_i_in_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_SIZE_J_IN(size_j_in_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_A_IN(data_a_in_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_DATA_B_IN(data_b_in_matrix_integer_divider),

    .MATRIX_INTEGER_DIVIDER_DATA_OUT(data_out_matrix_integer_divider),
    .MATRIX_INTEGER_DIVIDER_REST_OUT(rest_out_matrix_integer_divider)
  );

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  model_scalar_integer_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_integer_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_integer_adder),
    .READY(ready_scalar_integer_adder),

    .OPERATION(operation_scalar_integer_adder),

    // DATA
    .OVERFLOW_OUT(overflow_out_scalar_integer_adder),
    .DATA_A_IN   (data_a_in_scalar_integer_adder),
    .DATA_B_IN   (data_b_in_scalar_integer_adder),
    .DATA_OUT    (data_out_scalar_integer_adder)
  );

  // SCALAR MULTIPLIER
  model_scalar_integer_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_integer_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_integer_multiplier),
    .READY(ready_scalar_integer_adder),

    // DATA
    .OVERFLOW_OUT(overflow_out_scalar_integer_multiplier),
    .DATA_A_IN   (data_a_in_scalar_integer_multiplier),
    .DATA_B_IN   (data_b_in_scalar_integer_multiplier),
    .DATA_OUT    (data_out_scalar_integer_multiplier)
  );

  // SCALAR DIVIDER
  model_scalar_integer_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_integer_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_integer_divider),
    .READY(ready_scalar_integer_divider),

    // DATA
    .REST_OUT (rest_out_scalar_integer_divider),
    .DATA_A_IN(data_a_in_scalar_integer_divider),
    .DATA_B_IN(data_b_in_scalar_integer_divider),
    .DATA_OUT (data_out_scalar_integer_divider)
  );

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  model_vector_integer_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_integer_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_integer_adder),
    .READY(ready_vector_integer_adder),

    .OPERATION(operation_vector_integer_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_integer_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_integer_adder),
    .DATA_OUT_ENABLE (data_out_enable_vector_integer_adder),

    // DATA
    .OVERFLOW_OUT(overflow_out_vector_integer_adder),
    .SIZE_IN     (size_in_vector_integer_adder),
    .DATA_A_IN   (data_a_in_vector_integer_adder),
    .DATA_B_IN   (data_b_in_vector_integer_adder),
    .DATA_OUT    (data_out_vector_integer_adder)
  );

  // VECTOR MULTIPLIER
  model_vector_integer_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_integer_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_integer_multiplier),
    .READY(ready_vector_integer_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_integer_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_integer_multiplier),
    .DATA_OUT_ENABLE (data_out_enable_vector_integer_multiplier),

    // DATA
    .OVERFLOW_OUT(overflow_out_vector_integer_multiplier),
    .SIZE_IN     (size_in_vector_integer_multiplier),
    .DATA_A_IN   (data_a_in_vector_integer_multiplier),
    .DATA_B_IN   (data_b_in_vector_integer_multiplier),
    .DATA_OUT    (data_out_vector_integer_multiplier)
  );

  // VECTOR DIVIDER
  model_vector_integer_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_integer_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_integer_divider),
    .READY(ready_vector_integer_divider),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_integer_divider),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_integer_divider),
    .DATA_OUT_ENABLE (data_out_enable_vector_integer_divider),

    // DATA
    .REST_OUT (rest_out_vector_integer_divider),
    .SIZE_IN  (size_in_vector_integer_divider),
    .DATA_A_IN(data_a_in_vector_integer_divider),
    .DATA_B_IN(data_b_in_vector_integer_divider),
    .DATA_OUT (data_out_vector_integer_divider)
  );

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  model_matrix_integer_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_integer_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_integer_adder),
    .READY(ready_matrix_integer_adder),

    .OPERATION(operation_matrix_integer_adder),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_integer_adder),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_integer_adder),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_integer_adder),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_integer_adder),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_integer_adder),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_integer_adder),

    // DATA
    .OVERFLOW_OUT(overflow_out_matrix_integer_adder),
    .SIZE_I_IN   (size_i_in_matrix_integer_adder),
    .SIZE_J_IN   (size_j_in_matrix_integer_adder),
    .DATA_A_IN   (data_a_in_matrix_integer_adder),
    .DATA_B_IN   (data_b_in_matrix_integer_adder),
    .DATA_OUT    (data_out_matrix_integer_adder)
  );

  // MATRIX MULTIPLIER
  model_matrix_integer_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_integer_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_integer_multiplier),
    .READY(ready_matrix_integer_multiplier),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_integer_multiplier),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_integer_multiplier),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_integer_multiplier),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_integer_multiplier),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_integer_multiplier),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_integer_multiplier),

    // DATA
    .OVERFLOW_OUT(overflow_out_matrix_integer_multiplier),
    .SIZE_I_IN   (size_i_in_matrix_integer_multiplier),
    .SIZE_J_IN   (size_j_in_matrix_integer_multiplier),
    .DATA_A_IN   (data_a_in_matrix_integer_multiplier),
    .DATA_B_IN   (data_b_in_matrix_integer_multiplier),
    .DATA_OUT    (data_out_matrix_integer_multiplier)
  );

  // MATRIX DIVIDER
  model_matrix_integer_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_integer_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_integer_divider),
    .READY(ready_matrix_integer_divider),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_integer_divider),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_integer_divider),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_integer_divider),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_integer_divider),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_integer_divider),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_integer_divider),

    // DATA
    .REST_OUT (rest_out_matrix_integer_divider),
    .SIZE_I_IN(size_i_in_matrix_integer_divider),
    .SIZE_J_IN(size_j_in_matrix_integer_divider),
    .DATA_A_IN(data_a_in_matrix_integer_divider),
    .DATA_B_IN(data_b_in_matrix_integer_divider),
    .DATA_OUT (data_out_matrix_integer_divider)
  );

endmodule
