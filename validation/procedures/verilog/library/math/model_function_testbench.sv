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

module model_function_testbench;

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
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_TEST = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_1 = 0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_TEST = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_TEST = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_1 = 0;
  parameter STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_1 = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire                 CLK;
  wire                 RST;

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR LOGISTIC
  // CONTROL
  wire                 start_scalar_logistic;
  wire                 ready_scalar_logistic;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_logistic;
  wire [DATA_SIZE-1:0] data_out_scalar_logistic;

  // SCALAR ONEPLUS
  // CONTROL
  wire                 start_scalar_oneplus;
  wire                 ready_scalar_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] data_in_scalar_oneplus;
  wire [DATA_SIZE-1:0] data_out_scalar_oneplus;

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR LOGISTIC
  // CONTROL
  wire                 start_vector_logistic;
  wire                 ready_vector_logistic;

  wire                 data_in_enable_vector_logistic;
  wire                 data_out_enable_vector_logistic;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_out_vector_logistic;

  // VECTOR ONEPLUS
  // CONTROL
  wire                 start_vector_oneplus;
  wire                 ready_vector_oneplus;

  wire                 data_in_enable_vector_oneplus;
  wire                 data_out_enable_vector_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_out_vector_oneplus;

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX LOGISTIC
  // CONTROL
  wire                 start_matrix_logistic;
  wire                 ready_matrix_logistic;

  wire                 data_in_i_enable_matrix_logistic;
  wire                 data_in_j_enable_matrix_logistic;
  wire                 data_out_i_enable_matrix_logistic;
  wire                 data_out_j_enable_matrix_logistic;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_logistic;
  wire [DATA_SIZE-1:0] size_j_in_matrix_logistic;
  wire [DATA_SIZE-1:0] data_in_matrix_logistic;
  wire [DATA_SIZE-1:0] data_out_matrix_logistic;

  // MATRIX ONEPLUS
  // CONTROL
  wire                 start_matrix_oneplus;
  wire                 ready_matrix_oneplus;

  wire                 data_in_i_enable_matrix_oneplus;
  wire                 data_in_j_enable_matrix_oneplus;
  wire                 data_out_i_enable_matrix_oneplus;
  wire                 data_out_j_enable_matrix_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] size_j_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] data_in_matrix_oneplus;
  wire [DATA_SIZE-1:0] data_out_matrix_oneplus;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  model_function_stimulus #(
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
    .STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_TEST  (STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_TEST   (STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_TEST),
    .STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_0(STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_0 (STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_0),
    .STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_1(STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_1),
    .STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_1 (STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_TEST  (STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_TEST   (STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_TEST),
    .STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_0(STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_0 (STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_0),
    .STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_1(STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_1),
    .STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_1 (STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_TEST  (STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_TEST   (STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_TEST),
    .STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_0(STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_0 (STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_0),
    .STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_1(STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_1),
    .STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_1 (STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_1)
  ) function_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    //////////////////////////////////////////////////////////////////////////////

    // SCALAR LOGISTIC
    // CONTROL
    .SCALAR_LOGISTIC_START(start_scalar_logistic),
    .SCALAR_LOGISTIC_READY(ready_scalar_logistic),

    // DATA
    .SCALAR_LOGISTIC_DATA_IN (data_in_scalar_logistic),
    .SCALAR_LOGISTIC_DATA_OUT(data_out_scalar_logistic),

    // SCALAR ONEPLUS
    // CONTROL
    .SCALAR_ONEPLUS_START(start_scalar_oneplus),
    .SCALAR_ONEPLUS_READY(ready_scalar_oneplus),

    // DATA
    .SCALAR_ONEPLUS_DATA_IN (data_in_scalar_oneplus),
    .SCALAR_ONEPLUS_DATA_OUT(data_out_scalar_oneplus),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    //////////////////////////////////////////////////////////////////////////////

    // VECTOR LOGISTIC
    // CONTROL
    .VECTOR_LOGISTIC_START(start_vector_logistic),
    .VECTOR_LOGISTIC_READY(ready_vector_logistic),

    .VECTOR_LOGISTIC_DATA_IN_ENABLE (data_in_enable_vector_logistic),
    .VECTOR_LOGISTIC_DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .VECTOR_LOGISTIC_SIZE_IN (size_in_vector_logistic),
    .VECTOR_LOGISTIC_DATA_IN (data_in_vector_logistic),
    .VECTOR_LOGISTIC_DATA_OUT(data_out_vector_logistic),

    // VECTOR ONEPLUS
    // CONTROL
    .VECTOR_ONEPLUS_START(start_vector_oneplus),
    .VECTOR_ONEPLUS_READY(ready_vector_oneplus),

    .VECTOR_ONEPLUS_DATA_IN_ENABLE (data_in_enable_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_OUT_ENABLE(data_out_enable_vector_oneplus),

    // DATA
    .VECTOR_ONEPLUS_SIZE_IN (size_in_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_IN (data_in_vector_oneplus),
    .VECTOR_ONEPLUS_DATA_OUT(data_out_vector_oneplus),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    //////////////////////////////////////////////////////////////////////////////

    // MATRIX LOGISTIC
    // CONTROL
    .MATRIX_LOGISTIC_START(start_matrix_logistic),
    .MATRIX_LOGISTIC_READY(ready_matrix_logistic),

    .MATRIX_LOGISTIC_DATA_IN_I_ENABLE (data_in_i_enable_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_IN_J_ENABLE (data_in_j_enable_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_logistic),

    // DATA
    .MATRIX_LOGISTIC_SIZE_I_IN(size_i_in_matrix_logistic),
    .MATRIX_LOGISTIC_SIZE_J_IN(size_j_in_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_IN  (data_in_matrix_logistic),
    .MATRIX_LOGISTIC_DATA_OUT (data_out_matrix_logistic),

    // MATRIX ONEPLUS
    // CONTROL
    .MATRIX_ONEPLUS_START(start_matrix_oneplus),
    .MATRIX_ONEPLUS_READY(ready_matrix_oneplus),

    .MATRIX_ONEPLUS_DATA_IN_I_ENABLE (data_in_i_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_IN_J_ENABLE (data_in_j_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_oneplus),

    // DATA
    .MATRIX_ONEPLUS_SIZE_I_IN(size_i_in_matrix_oneplus),
    .MATRIX_ONEPLUS_SIZE_J_IN(size_j_in_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_IN  (data_in_matrix_oneplus),
    .MATRIX_ONEPLUS_DATA_OUT (data_out_matrix_oneplus)
  );

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR LOGISTIC
  model_scalar_logistic_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_logistic_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_logistic),
    .READY(ready_scalar_logistic),

    // DATA
    .DATA_IN (data_in_scalar_logistic),
    .DATA_OUT(data_out_scalar_logistic)
  );

  // SCALAR ONEPLUS
  model_scalar_oneplus_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_oneplus_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_oneplus),
    .READY(ready_scalar_oneplus),

    // DATA
    .DATA_IN (data_in_scalar_oneplus),
    .DATA_OUT(data_out_scalar_oneplus)
  );

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR LOGISTIC
  model_vector_logistic_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_logistic_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_logistic),
    .READY(ready_vector_logistic),

    .DATA_IN_ENABLE (data_in_enable_vector_logistic),
    .DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .SIZE_IN (size_in_vector_logistic),
    .DATA_IN (data_in_vector_logistic),
    .DATA_OUT(data_out_vector_logistic)
  );

  // VECTOR ONEPLUS
  model_vector_oneplus_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_oneplus_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_oneplus),
    .READY(ready_vector_oneplus),

    .DATA_IN_ENABLE (data_in_enable_vector_oneplus),
    .DATA_OUT_ENABLE(data_out_enable_vector_oneplus),

    // DATA
    .SIZE_IN (size_in_vector_oneplus),
    .DATA_IN (data_in_vector_oneplus),
    .DATA_OUT(data_out_vector_oneplus)
  );

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX LOGISTIC
  model_matrix_logistic_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_logistic_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_logistic),
    .READY(ready_matrix_logistic),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_logistic),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_logistic),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_logistic),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_logistic),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_logistic),
    .SIZE_J_IN(size_j_in_matrix_logistic),
    .DATA_IN  (data_in_matrix_logistic),
    .DATA_OUT (data_out_matrix_logistic)
  );

  // MATRIX ONEPLUS
  model_matrix_oneplus_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_oneplus_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_oneplus),
    .READY(ready_matrix_oneplus),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_oneplus),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_oneplus),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_oneplus),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_oneplus),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_oneplus),
    .SIZE_J_IN(size_j_in_matrix_oneplus),
    .DATA_IN  (data_in_matrix_oneplus),
    .DATA_OUT (data_out_matrix_oneplus)
  );

endmodule
