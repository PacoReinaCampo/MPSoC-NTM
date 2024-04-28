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

module accelerator_fixed_testbench;

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
  parameter STIMULUS_ACCELERATOR_SCALAR_ADDER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_DIVIDER_TEST = 0;

  parameter STIMULUS_ACCELERATOR_SCALAR_ADDER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_DIVIDER_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_SCALAR_ADDER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_DIVIDER_CASE_1 = 0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_ADDER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_DIVIDER_TEST = 0;

  parameter STIMULUS_ACCELERATOR_VECTOR_ADDER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_DIVIDER_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_VECTOR_ADDER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_DIVIDER_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_ADDER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_DIVIDER_TEST = 0;

  parameter STIMULUS_ACCELERATOR_MATRIX_ADDER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_DIVIDER_CASE_0 = 0;

  parameter STIMULUS_ACCELERATOR_MATRIX_ADDER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_DIVIDER_CASE_1 = 0;

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
  wire                 start_scalar_fixed_adder;
  wire                 ready_scalar_fixed_adder;

  wire                 operation_scalar_fixed_adder;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_fixed_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_fixed_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_fixed_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire                 start_scalar_fixed_multiplier;
  wire                 ready_scalar_fixed_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_fixed_multiplier;

  // SCALAR DIVIDER
  // CONTROL
  wire                 start_scalar_fixed_divider;
  wire                 ready_scalar_fixed_divider;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_fixed_divider;
  wire [DATA_SIZE-1:0] data_b_in_scalar_fixed_divider;
  wire [DATA_SIZE-1:0] data_out_scalar_fixed_divider;

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  // CONTROL
  wire                 start_vector_fixed_adder;
  wire                 ready_vector_fixed_adder;

  wire                 operation_vector_fixed_adder;

  wire                 data_a_in_enable_vector_fixed_adder;
  wire                 data_b_in_enable_vector_fixed_adder;
  wire                 data_out_enable_vector_fixed_adder;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_fixed_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_fixed_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_fixed_adder;
  wire [DATA_SIZE-1:0] data_out_vector_fixed_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire                 start_vector_fixed_multiplier;
  wire                 ready_vector_fixed_multiplier;

  wire                 data_a_in_enable_vector_fixed_multiplier;
  wire                 data_b_in_enable_vector_fixed_multiplier;
  wire                 data_out_enable_vector_fixed_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_fixed_multiplier;

  // VECTOR DIVIDER
  // CONTROL
  wire                 start_vector_fixed_divider;
  wire                 ready_vector_fixed_divider;

  wire                 data_a_in_enable_vector_fixed_divider;
  wire                 data_b_in_enable_vector_fixed_divider;
  wire                 data_out_enable_vector_fixed_divider;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_fixed_divider;
  wire [DATA_SIZE-1:0] data_a_in_vector_fixed_divider;
  wire [DATA_SIZE-1:0] data_b_in_vector_fixed_divider;
  wire [DATA_SIZE-1:0] data_out_vector_fixed_divider;

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  // CONTROL
  wire                 start_matrix_fixed_adder;
  wire                 ready_matrix_fixed_adder;

  wire                 operation_matrix_fixed_adder;

  wire                 data_a_in_i_enable_matrix_fixed_adder;
  wire                 data_a_in_j_enable_matrix_fixed_adder;
  wire                 data_b_in_i_enable_matrix_fixed_adder;
  wire                 data_b_in_j_enable_matrix_fixed_adder;
  wire                 data_out_i_enable_matrix_fixed_adder;
  wire                 data_out_j_enable_matrix_fixed_adder;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_fixed_adder;
  wire [DATA_SIZE-1:0] size_j_in_matrix_fixed_adder;
  wire [DATA_SIZE-1:0] data_a_in_matrix_fixed_adder;
  wire [DATA_SIZE-1:0] data_b_in_matrix_fixed_adder;
  wire [DATA_SIZE-1:0] data_out_matrix_fixed_adder;

  // MATRIX MULTIPLIER
  // CONTROL
  wire                 start_matrix_fixed_multiplier;
  wire                 ready_matrix_fixed_multiplier;

  wire                 data_a_in_i_enable_matrix_fixed_multiplier;
  wire                 data_a_in_j_enable_matrix_fixed_multiplier;
  wire                 data_b_in_i_enable_matrix_fixed_multiplier;
  wire                 data_b_in_j_enable_matrix_fixed_multiplier;
  wire                 data_out_i_enable_matrix_fixed_multiplier;
  wire                 data_out_j_enable_matrix_fixed_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_fixed_multiplier;
  wire [DATA_SIZE-1:0] size_j_in_matrix_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_matrix_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_matrix_fixed_multiplier;
  wire [DATA_SIZE-1:0] data_out_matrix_fixed_multiplier;

  // MATRIX DIVIDER
  // CONTROL
  wire                 start_matrix_fixed_divider;
  wire                 ready_matrix_fixed_divider;

  wire                 data_a_in_i_enable_matrix_fixed_divider;
  wire                 data_a_in_j_enable_matrix_fixed_divider;
  wire                 data_b_in_i_enable_matrix_fixed_divider;
  wire                 data_b_in_j_enable_matrix_fixed_divider;
  wire                 data_out_i_enable_matrix_fixed_divider;
  wire                 data_out_j_enable_matrix_fixed_divider;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_fixed_divider;
  wire [DATA_SIZE-1:0] size_j_in_matrix_fixed_divider;
  wire [DATA_SIZE-1:0] data_a_in_matrix_fixed_divider;
  wire [DATA_SIZE-1:0] data_b_in_matrix_fixed_divider;
  wire [DATA_SIZE-1:0] data_out_matrix_fixed_divider;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  accelerator_fixed_stimulus #(
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
    .STIMULUS_ACCELERATOR_SCALAR_ADDER_TEST       (STIMULUS_ACCELERATOR_SCALAR_ADDER_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_TEST  (STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_DIVIDER_TEST     (STIMULUS_ACCELERATOR_SCALAR_DIVIDER_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_ADDER_CASE_0     (STIMULUS_ACCELERATOR_SCALAR_ADDER_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_CASE_0(STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_DIVIDER_CASE_0   (STIMULUS_ACCELERATOR_SCALAR_DIVIDER_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_ADDER_CASE_1     (STIMULUS_ACCELERATOR_SCALAR_ADDER_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_CASE_1(STIMULUS_ACCELERATOR_SCALAR_MULTIPLIER_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_DIVIDER_CASE_1   (STIMULUS_ACCELERATOR_SCALAR_DIVIDER_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_VECTOR_ADDER_TEST       (STIMULUS_ACCELERATOR_VECTOR_ADDER_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_TEST  (STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_DIVIDER_TEST     (STIMULUS_ACCELERATOR_VECTOR_DIVIDER_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_ADDER_CASE_0     (STIMULUS_ACCELERATOR_VECTOR_ADDER_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_CASE_0(STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_DIVIDER_CASE_0   (STIMULUS_ACCELERATOR_VECTOR_DIVIDER_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_ADDER_CASE_1     (STIMULUS_ACCELERATOR_VECTOR_ADDER_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_CASE_1(STIMULUS_ACCELERATOR_VECTOR_MULTIPLIER_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_DIVIDER_CASE_1   (STIMULUS_ACCELERATOR_VECTOR_DIVIDER_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_MATRIX_ADDER_TEST       (STIMULUS_ACCELERATOR_MATRIX_ADDER_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_TEST  (STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_DIVIDER_TEST     (STIMULUS_ACCELERATOR_MATRIX_DIVIDER_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_ADDER_CASE_0     (STIMULUS_ACCELERATOR_MATRIX_ADDER_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_CASE_0(STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_DIVIDER_CASE_0   (STIMULUS_ACCELERATOR_MATRIX_DIVIDER_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_ADDER_CASE_1     (STIMULUS_ACCELERATOR_MATRIX_ADDER_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_CASE_1(STIMULUS_ACCELERATOR_MATRIX_MULTIPLIER_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_DIVIDER_CASE_1   (STIMULUS_ACCELERATOR_MATRIX_DIVIDER_CASE_1)
  )fixed_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    //////////////////////////////////////////////////////////////////////////////

    // SCALAR ADDER
    // CONTROL
    .SCALAR_ADDER_START(start_scalar_fixed_adder),
    .SCALAR_ADDER_READY(ready_scalar_fixed_adder),

    .SCALAR_ADDER_OPERATION(operation_scalar_fixed_adder),

    // DATA
    .SCALAR_ADDER_DATA_A_IN(data_a_in_scalar_fixed_adder),
    .SCALAR_ADDER_DATA_B_IN(data_b_in_scalar_fixed_adder),
    .SCALAR_ADDER_DATA_OUT (data_out_scalar_fixed_adder),

    // SCALAR MULTIPLIER
    // CONTROL
    .SCALAR_MULTIPLIER_START(start_scalar_fixed_multiplier),
    .SCALAR_MULTIPLIER_READY(ready_scalar_fixed_multiplier),

    // DATA
    .SCALAR_MULTIPLIER_DATA_A_IN(data_a_in_scalar_fixed_multiplier),
    .SCALAR_MULTIPLIER_DATA_B_IN(data_b_in_scalar_fixed_multiplier),
    .SCALAR_MULTIPLIER_DATA_OUT (data_out_scalar_fixed_multiplier),

    // SCALAR DIVIDER
    // CONTROL
    .SCALAR_DIVIDER_START(start_scalar_fixed_divider),
    .SCALAR_DIVIDER_READY(ready_scalar_fixed_divider),

    // DATA
    .SCALAR_DIVIDER_DATA_A_IN(data_a_in_scalar_fixed_divider),
    .SCALAR_DIVIDER_DATA_B_IN(data_b_in_scalar_fixed_divider),
    .SCALAR_DIVIDER_DATA_OUT (data_out_scalar_fixed_divider),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    //////////////////////////////////////////////////////////////////////////////

    // VECTOR ADDER
    // CONTROL
    .VECTOR_ADDER_START(start_vector_fixed_adder),
    .VECTOR_ADDER_READY(ready_vector_fixed_adder),

    .VECTOR_ADDER_OPERATION(operation_vector_fixed_adder),

    .VECTOR_ADDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_adder),
    .VECTOR_ADDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_adder),
    .VECTOR_ADDER_DATA_OUT_ENABLE (data_out_enable_vector_fixed_adder),

    // DATA
    .VECTOR_ADDER_SIZE_IN  (size_in_vector_fixed_adder),
    .VECTOR_ADDER_DATA_A_IN(data_a_in_vector_fixed_adder),
    .VECTOR_ADDER_DATA_B_IN(data_b_in_vector_fixed_adder),
    .VECTOR_ADDER_DATA_OUT (data_out_vector_fixed_adder),

    // VECTOR MULTIPLIER
    // CONTROL
    .VECTOR_MULTIPLIER_START(start_vector_fixed_multiplier),
    .VECTOR_MULTIPLIER_READY(ready_vector_fixed_multiplier),

    .VECTOR_MULTIPLIER_DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_multiplier),
    .VECTOR_MULTIPLIER_DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_multiplier),
    .VECTOR_MULTIPLIER_DATA_OUT_ENABLE (data_out_enable_vector_fixed_multiplier),

    // DATA
    .VECTOR_MULTIPLIER_SIZE_IN  (size_in_vector_fixed_multiplier),
    .VECTOR_MULTIPLIER_DATA_A_IN(data_a_in_vector_fixed_multiplier),
    .VECTOR_MULTIPLIER_DATA_B_IN(data_b_in_vector_fixed_multiplier),
    .VECTOR_MULTIPLIER_DATA_OUT (data_out_vector_fixed_multiplier),

    // VECTOR DIVIDER
    // CONTROL
    .VECTOR_DIVIDER_START(start_vector_fixed_divider),
    .VECTOR_DIVIDER_READY(ready_vector_fixed_divider),

    .VECTOR_DIVIDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_divider),
    .VECTOR_DIVIDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_divider),
    .VECTOR_DIVIDER_DATA_OUT_ENABLE (data_out_enable_vector_fixed_divider),

    // DATA
    .VECTOR_DIVIDER_SIZE_IN  (size_in_vector_fixed_divider),
    .VECTOR_DIVIDER_DATA_A_IN(data_a_in_vector_fixed_divider),
    .VECTOR_DIVIDER_DATA_B_IN(data_b_in_vector_fixed_divider),
    .VECTOR_DIVIDER_DATA_OUT (data_out_vector_fixed_divider),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    //////////////////////////////////////////////////////////////////////////////

    // MATRIX ADDER
    // CONTROL
    .MATRIX_ADDER_START(start_matrix_fixed_adder),
    .MATRIX_ADDER_READY(ready_matrix_fixed_adder),

    .MATRIX_ADDER_OPERATION(operation_matrix_fixed_adder),

    .MATRIX_ADDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_fixed_adder),

    // DATA
    .MATRIX_ADDER_SIZE_I_IN(size_i_in_matrix_fixed_adder),
    .MATRIX_ADDER_SIZE_J_IN(size_j_in_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_A_IN(data_a_in_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_B_IN(data_b_in_matrix_fixed_adder),
    .MATRIX_ADDER_DATA_OUT (data_out_matrix_fixed_adder),

    // MATRIX MULTIPLIER
    // CONTROL
    .MATRIX_MULTIPLIER_START(start_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_READY(ready_matrix_fixed_multiplier),

    .MATRIX_MULTIPLIER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_fixed_multiplier),

    // DATA
    .MATRIX_MULTIPLIER_SIZE_I_IN(size_i_in_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_SIZE_J_IN(size_j_in_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_A_IN(data_a_in_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_B_IN(data_b_in_matrix_fixed_multiplier),
    .MATRIX_MULTIPLIER_DATA_OUT (data_out_matrix_fixed_multiplier),

    // MATRIX DIVIDER
    // CONTROL
    .MATRIX_DIVIDER_START(start_matrix_fixed_divider),
    .MATRIX_DIVIDER_READY(ready_matrix_fixed_divider),

    .MATRIX_DIVIDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_fixed_divider),

    // DATA
    .MATRIX_DIVIDER_SIZE_I_IN(size_i_in_matrix_fixed_divider),
    .MATRIX_DIVIDER_SIZE_J_IN(size_j_in_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_A_IN(data_a_in_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_B_IN(data_b_in_matrix_fixed_divider),
    .MATRIX_DIVIDER_DATA_OUT (data_out_matrix_fixed_divider)
  );

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  accelerator_scalar_fixed_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_fixed_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_fixed_adder),
    .READY(ready_scalar_fixed_adder),

    .OPERATION(operation_scalar_fixed_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_fixed_adder),
    .DATA_B_IN(data_b_in_scalar_fixed_adder),
    .DATA_OUT (data_out_scalar_fixed_adder)
  );

  // SCALAR MULTIPLIER
  accelerator_scalar_fixed_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_fixed_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_fixed_multiplier),
    .READY(ready_scalar_fixed_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_fixed_multiplier),
    .DATA_B_IN(data_b_in_scalar_fixed_multiplier),
    .DATA_OUT (data_out_scalar_fixed_multiplier)
  );

  // SCALAR DIVIDER
  accelerator_scalar_fixed_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_fixed_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_fixed_divider),
    .READY(ready_scalar_fixed_divider),

    // DATA
    .DATA_A_IN(data_a_in_scalar_fixed_divider),
    .DATA_B_IN(data_b_in_scalar_fixed_divider),
    .DATA_OUT (data_out_scalar_fixed_divider)
  );

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  accelerator_vector_fixed_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_fixed_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_fixed_adder),
    .READY(ready_vector_fixed_adder),

    .OPERATION(operation_vector_fixed_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_adder),
    .DATA_OUT_ENABLE (data_out_enable_vector_fixed_adder),

    // DATA
    .SIZE_IN  (size_in_vector_fixed_adder),
    .DATA_A_IN(data_a_in_vector_fixed_adder),
    .DATA_B_IN(data_b_in_vector_fixed_adder),
    .DATA_OUT (data_out_vector_fixed_adder)
  );

  // VECTOR MULTIPLIER
  accelerator_vector_fixed_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_fixed_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_fixed_multiplier),
    .READY(ready_vector_fixed_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_multiplier),
    .DATA_OUT_ENABLE (data_out_enable_vector_fixed_multiplier),

    // DATA
    .SIZE_IN  (size_in_vector_fixed_multiplier),
    .DATA_A_IN(data_a_in_vector_fixed_multiplier),
    .DATA_B_IN(data_b_in_vector_fixed_multiplier),
    .DATA_OUT (data_out_vector_fixed_multiplier)
  );

  // VECTOR DIVIDER
  accelerator_vector_fixed_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_fixed_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_fixed_divider),
    .READY(ready_vector_fixed_divider),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_divider),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_divider),
    .DATA_OUT_ENABLE (data_out_enable_vector_fixed_divider),

    // DATA
    .SIZE_IN  (size_in_vector_fixed_divider),
    .DATA_A_IN(data_a_in_vector_fixed_divider),
    .DATA_B_IN(data_b_in_vector_fixed_divider),
    .DATA_OUT (data_out_vector_fixed_divider)
  );

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  accelerator_matrix_fixed_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_fixed_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_fixed_adder),
    .READY(ready_matrix_fixed_adder),

    .OPERATION(operation_matrix_fixed_adder),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_fixed_adder),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_fixed_adder),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_fixed_adder),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_fixed_adder),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_fixed_adder),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_fixed_adder),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_fixed_adder),
    .SIZE_J_IN(size_j_in_matrix_fixed_adder),
    .DATA_A_IN(data_a_in_matrix_fixed_adder),
    .DATA_B_IN(data_b_in_matrix_fixed_adder),
    .DATA_OUT (data_out_matrix_fixed_adder)
  );

  // MATRIX MULTIPLIER
  accelerator_matrix_fixed_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_fixed_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_fixed_multiplier),
    .READY(ready_matrix_fixed_multiplier),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_fixed_multiplier),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_fixed_multiplier),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_fixed_multiplier),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_fixed_multiplier),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_fixed_multiplier),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_fixed_multiplier),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_fixed_multiplier),
    .SIZE_J_IN(size_j_in_matrix_fixed_multiplier),
    .DATA_A_IN(data_a_in_matrix_fixed_multiplier),
    .DATA_B_IN(data_b_in_matrix_fixed_multiplier),
    .DATA_OUT (data_out_matrix_fixed_multiplier)
  );

  // MATRIX DIVIDER
  accelerator_matrix_fixed_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_fixed_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_fixed_divider),
    .READY(ready_matrix_fixed_divider),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_fixed_divider),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_fixed_divider),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_fixed_divider),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_fixed_divider),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_fixed_divider),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_fixed_divider),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_fixed_divider),
    .SIZE_J_IN(size_j_in_matrix_fixed_divider),
    .DATA_A_IN(data_a_in_matrix_fixed_divider),
    .DATA_B_IN(data_b_in_matrix_fixed_divider),
    .DATA_OUT (data_out_matrix_fixed_divider)
  );

endmodule
