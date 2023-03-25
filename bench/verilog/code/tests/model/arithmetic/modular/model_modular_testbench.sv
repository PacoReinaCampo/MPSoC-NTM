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

module model_modular_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE = 64;
  parameter CONTROL_SIZE = 64;

  parameter X = 64;
  parameter Y = 64;
  parameter N = 64;
  parameter W = 64;
  parameter L = 64;
  parameter R = 64;

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST = 0;

  parameter STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0 = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0 = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0 = 0;

  parameter STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_1 = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_1 = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_1 = 0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST = 0;

  parameter STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0 = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0 = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0 = 0;

  parameter STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_1 = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_1 = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_1 = 0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST = 0;

  parameter STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0 = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0 = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0 = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0 = 0;

  parameter STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_1 = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_1 = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1 = 0;
  parameter STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_1 = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire                 CLK;
  wire                 RST;

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR MOD
  // CONTROL
  wire                 start_scalar_modular_mod;
  wire                 ready_scalar_modular_mod;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_modular_mod;
  wire [DATA_SIZE-1:0] data_in_scalar_modular_mod;
  wire [DATA_SIZE-1:0] data_out_scalar_modular_mod;

  // SCALAR ADDER
  // CONTROL
  wire                 start_scalar_modular_adder;
  wire                 ready_scalar_modular_adder;

  wire                 operation_scalar_modular_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_modular_adder;
  wire [DATA_SIZE-1:0] data_a_in_scalar_modular_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_modular_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_modular_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire                 start_scalar_modular_multiplier;
  wire                 ready_scalar_modular_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_modular_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_scalar_modular_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_modular_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_modular_multiplier;

  // SCALAR INVERTER
  // CONTROL
  wire                 start_scalar_modular_inverter;
  wire                 ready_scalar_modular_inverter;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_modular_inverter;
  wire [DATA_SIZE-1:0] data_in_scalar_modular_inverter;
  wire [DATA_SIZE-1:0] data_out_scalar_modular_inverter;

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR MOD
  // CONTROL
  wire                 start_vector_modular_mod;
  wire                 ready_vector_modular_mod;

  wire                 data_in_enable_vector_modular_mod;
  wire                 data_out_enable_vector_modular_mod;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_modular_mod;
  wire [DATA_SIZE-1:0] size_in_vector_modular_mod;
  wire [DATA_SIZE-1:0] data_in_vector_modular_mod;
  wire [DATA_SIZE-1:0] data_out_vector_modular_mod;

  // VECTOR ADDER
  // CONTROL
  wire                 start_vector_modular_adder;
  wire                 ready_vector_modular_adder;

  wire                 operation_vector_modular_adder;

  wire                 data_a_in_enable_vector_modular_adder;
  wire                 data_b_in_enable_vector_modular_adder;
  wire                 data_out_enable_vector_modular_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_modular_adder;
  wire [DATA_SIZE-1:0] size_in_vector_modular_adder;
  wire [DATA_SIZE-1:0] data_a_in_vector_modular_adder;
  wire [DATA_SIZE-1:0] data_b_in_vector_modular_adder;
  wire [DATA_SIZE-1:0] data_out_vector_modular_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire                 start_vector_modular_multiplier;
  wire                 ready_vector_modular_multiplier;

  wire                 data_a_in_enable_vector_modular_multiplier;
  wire                 data_b_in_enable_vector_modular_multiplier;
  wire                 data_out_enable_vector_modular_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_modular_multiplier;
  wire [DATA_SIZE-1:0] size_in_vector_modular_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_modular_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_modular_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_modular_multiplier;

  // VECTOR INVERTER
  // CONTROL
  wire                 start_vector_modular_inverter;
  wire                 ready_vector_modular_inverter;

  wire                 data_in_enable_vector_modular_inverter;
  wire                 data_out_enable_vector_modular_inverter;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_modular_inverter;
  wire [DATA_SIZE-1:0] size_in_vector_modular_inverter;
  wire [DATA_SIZE-1:0] data_in_vector_modular_inverter;
  wire [DATA_SIZE-1:0] data_out_vector_modular_inverter;

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX MOD
  // CONTROL
  wire                 start_matrix_modular_mod;
  wire                 ready_matrix_modular_mod;

  wire                 data_in_i_enable_matrix_modular_mod;
  wire                 data_in_j_enable_matrix_modular_mod;
  wire                 data_out_i_enable_matrix_modular_mod;
  wire                 data_out_j_enable_matrix_modular_mod;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_modular_mod;
  wire [DATA_SIZE-1:0] size_i_in_matrix_modular_mod;
  wire [DATA_SIZE-1:0] size_j_in_matrix_modular_mod;
  wire [DATA_SIZE-1:0] data_in_matrix_modular_mod;
  wire [DATA_SIZE-1:0] data_out_matrix_modular_mod;

  // MATRIX ADDER
  // CONTROL
  wire                 start_matrix_modular_adder;
  wire                 ready_matrix_modular_adder;

  wire                 operation_matrix_modular_adder;

  wire                 data_a_in_i_enable_matrix_modular_adder;
  wire                 data_a_in_j_enable_matrix_modular_adder;
  wire                 data_b_in_i_enable_matrix_modular_adder;
  wire                 data_b_in_j_enable_matrix_modular_adder;
  wire                 data_out_i_enable_matrix_modular_adder;
  wire                 data_out_j_enable_matrix_modular_adder;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_modular_adder;
  wire [DATA_SIZE-1:0] size_i_in_matrix_modular_adder;
  wire [DATA_SIZE-1:0] size_j_in_matrix_modular_adder;
  wire [DATA_SIZE-1:0] data_a_in_matrix_modular_adder;
  wire [DATA_SIZE-1:0] data_b_in_matrix_modular_adder;
  wire [DATA_SIZE-1:0] data_out_matrix_modular_adder;

  // MATRIX MULTIPLIER
  // CONTROL
  wire                 start_matrix_modular_multiplier;
  wire                 ready_matrix_modular_multiplier;

  wire                 data_a_in_i_enable_matrix_modular_multiplier;
  wire                 data_a_in_j_enable_matrix_modular_multiplier;
  wire                 data_b_in_i_enable_matrix_modular_multiplier;
  wire                 data_b_in_j_enable_matrix_modular_multiplier;
  wire                 data_out_i_enable_matrix_modular_multiplier;
  wire                 data_out_j_enable_matrix_modular_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_modular_multiplier;
  wire [DATA_SIZE-1:0] size_i_in_matrix_modular_multiplier;
  wire [DATA_SIZE-1:0] size_j_in_matrix_modular_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_matrix_modular_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_matrix_modular_multiplier;
  wire [DATA_SIZE-1:0] data_out_matrix_modular_multiplier;

  // MATRIX INVERTER
  // CONTROL
  wire                 start_matrix_modular_inverter;
  wire                 ready_matrix_modular_inverter;

  wire                 data_in_i_enable_matrix_modular_inverter;
  wire                 data_in_j_enable_matrix_modular_inverter;
  wire                 data_out_i_enable_matrix_modular_inverter;
  wire                 data_out_j_enable_matrix_modular_inverter;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_modular_inverter;
  wire [DATA_SIZE-1:0] size_i_in_matrix_modular_inverter;
  wire [DATA_SIZE-1:0] size_j_in_matrix_modular_inverter;
  wire [DATA_SIZE-1:0] data_in_matrix_modular_inverter;
  wire [DATA_SIZE-1:0] data_out_matrix_modular_inverter;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////
  model_modular_stimulus #(
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
    .STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST         (STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST),
    .STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST       (STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST),
    .STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST  (STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST),
    .STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST    (STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST),
    .STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0       (STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0),
    .STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0     (STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0),
    .STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0(STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0),
    .STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0  (STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0),
    .STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_1       (STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_1),
    .STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_1     (STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_1),
    .STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1(STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1),
    .STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_1  (STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST         (STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST),
    .STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST       (STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST),
    .STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST  (STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST),
    .STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST    (STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST),
    .STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0       (STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0),
    .STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0     (STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0),
    .STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0(STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0),
    .STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0  (STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0),
    .STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_1       (STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_1),
    .STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_1     (STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_1),
    .STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1(STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1),
    .STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_1  (STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST         (STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST),
    .STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST       (STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST),
    .STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST  (STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST),
    .STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST    (STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST),
    .STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0       (STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0),
    .STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0     (STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0),
    .STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0(STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0),
    .STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0  (STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0),
    .STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_1       (STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_1),
    .STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_1     (STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_1),
    .STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1(STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1),
    .STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_1  (STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_1)
  ) modular_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    //////////////////////////////////////////////////////////////////////////////

    // SCALAR MOD
    // CONTROL
    .SCALAR_MODULAR_MOD_START(start_scalar_modular_mod),
    .SCALAR_MODULAR_MOD_READY(ready_scalar_modular_mod),

    // DATA
    .SCALAR_MODULAR_MOD_MODULO_IN(modulo_in_scalar_modular_mod),
    .SCALAR_MODULAR_MOD_DATA_IN  (data_in_scalar_modular_mod),
    .SCALAR_MODULAR_MOD_DATA_OUT (data_out_scalar_modular_mod),

    // SCALAR ADDER
    // CONTROL
    .SCALAR_MODULAR_ADDER_START(start_scalar_modular_adder),
    .SCALAR_MODULAR_ADDER_READY(ready_scalar_modular_adder),

    .SCALAR_MODULAR_ADDER_OPERATION(operation_scalar_modular_adder),

    // DATA
    .SCALAR_MODULAR_ADDER_MODULO_IN(modulo_in_scalar_modular_adder),
    .SCALAR_MODULAR_ADDER_DATA_A_IN(data_a_in_scalar_modular_adder),
    .SCALAR_MODULAR_ADDER_DATA_B_IN(data_b_in_scalar_modular_adder),
    .SCALAR_MODULAR_ADDER_DATA_OUT (data_out_scalar_modular_adder),

    // SCALAR MULTIPLIER
    // CONTROL
    .SCALAR_MODULAR_MULTIPLIER_START(start_scalar_modular_multiplier),
    .SCALAR_MODULAR_MULTIPLIER_READY(ready_scalar_modular_multiplier),

    // DATA
    .SCALAR_MODULAR_MULTIPLIER_MODULO_IN(modulo_in_scalar_modular_multiplier),
    .SCALAR_MODULAR_MULTIPLIER_DATA_A_IN(data_a_in_scalar_modular_multiplier),
    .SCALAR_MODULAR_MULTIPLIER_DATA_B_IN(data_b_in_scalar_modular_multiplier),
    .SCALAR_MODULAR_MULTIPLIER_DATA_OUT (data_out_scalar_modular_multiplier),

    // SCALAR INVERTER
    // CONTROL
    .SCALAR_MODULAR_INVERTER_START(start_scalar_modular_inverter),
    .SCALAR_MODULAR_INVERTER_READY(ready_scalar_modular_inverter),

    // DATA
    .SCALAR_MODULAR_INVERTER_MODULO_IN(modulo_in_scalar_modular_inverter),
    .SCALAR_MODULAR_INVERTER_DATA_IN  (data_in_scalar_modular_inverter),
    .SCALAR_MODULAR_INVERTER_DATA_OUT (data_out_scalar_modular_inverter),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    //////////////////////////////////////////////////////////////////////////////

    // VECTOR MOD
    // CONTROL
    .VECTOR_MODULAR_MOD_START(start_vector_modular_mod),
    .VECTOR_MODULAR_MOD_READY(ready_vector_modular_mod),

    .VECTOR_MODULAR_MOD_DATA_IN_ENABLE (data_in_enable_vector_modular_mod),
    .VECTOR_MODULAR_MOD_DATA_OUT_ENABLE(data_out_enable_vector_modular_mod),

    // DATA
    .VECTOR_MODULAR_MOD_MODULO_IN(modulo_in_vector_modular_mod),
    .VECTOR_MODULAR_MOD_SIZE_IN  (size_in_vector_modular_mod),
    .VECTOR_MODULAR_MOD_DATA_IN  (data_in_vector_modular_mod),
    .VECTOR_MODULAR_MOD_DATA_OUT (data_out_vector_modular_mod),

    // VECTOR ADDER
    // CONTROL
    .VECTOR_MODULAR_ADDER_START(start_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_READY(ready_vector_modular_adder),

    .VECTOR_MODULAR_ADDER_OPERATION(operation_vector_modular_adder),

    .VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE(data_a_in_enable_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE(data_b_in_enable_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE (data_out_enable_vector_modular_adder),

    // DATA
    .VECTOR_MODULAR_ADDER_MODULO_IN(modulo_in_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_SIZE_IN  (size_in_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_DATA_A_IN(data_a_in_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_DATA_B_IN(data_b_in_vector_modular_adder),
    .VECTOR_MODULAR_ADDER_DATA_OUT (data_out_vector_modular_adder),

    // VECTOR MULTIPLIER
    // CONTROL
    .VECTOR_MODULAR_MULTIPLIER_START(start_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_READY(ready_vector_modular_multiplier),

    .VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE(data_a_in_enable_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE(data_b_in_enable_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE (data_out_enable_vector_modular_multiplier),

    // DATA
    .VECTOR_MODULAR_MULTIPLIER_MODULO_IN(modulo_in_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_SIZE_IN  (size_in_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_DATA_A_IN(data_a_in_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_DATA_B_IN(data_b_in_vector_modular_multiplier),
    .VECTOR_MODULAR_MULTIPLIER_DATA_OUT (data_out_vector_modular_multiplier),

    // VECTOR INVERTER
    // CONTROL
    .VECTOR_MODULAR_INVERTER_START(start_vector_modular_inverter),
    .VECTOR_MODULAR_INVERTER_READY(ready_vector_modular_inverter),

    .VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE (data_in_enable_vector_modular_inverter),
    .VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE(data_out_enable_vector_modular_inverter),

    // DATA
    .VECTOR_MODULAR_INVERTER_MODULO_IN(modulo_in_vector_modular_inverter),
    .VECTOR_MODULAR_INVERTER_SIZE_IN  (size_in_vector_modular_inverter),
    .VECTOR_MODULAR_INVERTER_DATA_IN  (data_in_vector_modular_inverter),
    .VECTOR_MODULAR_INVERTER_DATA_OUT (data_out_vector_modular_inverter),

    //////////////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    //////////////////////////////////////////////////////////////////////////////

    // MATRIX MOD
    // CONTROL
    .MATRIX_MODULAR_MOD_START(start_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_READY(ready_matrix_modular_mod),

    .MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE (data_in_i_enable_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE (data_in_j_enable_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_modular_mod),

    // DATA
    .MATRIX_MODULAR_MOD_MODULO_IN(modulo_in_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_SIZE_I_IN(size_i_in_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_SIZE_J_IN(size_j_in_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_DATA_IN  (data_in_matrix_modular_mod),
    .MATRIX_MODULAR_MOD_DATA_OUT (data_out_matrix_modular_mod),

    // MATRIX ADDER
    // CONTROL
    .MATRIX_MODULAR_ADDER_START(start_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_READY(ready_matrix_modular_adder),

    .MATRIX_MODULAR_ADDER_OPERATION(operation_matrix_modular_adder),

    .MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_modular_adder),

    // DATA
    .MATRIX_MODULAR_ADDER_MODULO_IN(modulo_in_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_SIZE_I_IN(size_i_in_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_SIZE_J_IN(size_j_in_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_A_IN(data_a_in_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_B_IN(data_b_in_matrix_modular_adder),
    .MATRIX_MODULAR_ADDER_DATA_OUT (data_out_matrix_modular_adder),

    // MATRIX MULTIPLIER
    // CONTROL
    .MATRIX_MODULAR_MULTIPLIER_START(start_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_READY(ready_matrix_modular_multiplier),

    .MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE (data_out_i_enable_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE (data_out_j_enable_matrix_modular_multiplier),

    // DATA
    .MATRIX_MODULAR_MULTIPLIER_MODULO_IN(modulo_in_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN(size_i_in_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN(size_j_in_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_A_IN(data_a_in_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_B_IN(data_b_in_matrix_modular_multiplier),
    .MATRIX_MODULAR_MULTIPLIER_DATA_OUT (data_out_matrix_modular_multiplier),

    // MATRIX INVERTER
    // CONTROL
    .MATRIX_MODULAR_INVERTER_START(start_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_READY(ready_matrix_modular_inverter),

    .MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE (data_in_i_enable_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE (data_in_j_enable_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE(data_out_i_enable_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE(data_out_j_enable_matrix_modular_inverter),

    // DATA
    .MATRIX_MODULAR_INVERTER_MODULO_IN(modulo_in_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_SIZE_I_IN(size_i_in_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_SIZE_J_IN(size_j_in_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_DATA_IN  (data_in_matrix_modular_inverter),
    .MATRIX_MODULAR_INVERTER_DATA_OUT (data_out_matrix_modular_inverter)
  );

  //////////////////////////////////////////////////////////////////////////////
  // SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR MOD
  model_scalar_modular_mod #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_modular_mod (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_modular_mod),
    .READY(ready_scalar_modular_mod),

    // DATA
    .MODULO_IN(modulo_in_scalar_modular_mod),
    .DATA_IN  (data_in_scalar_modular_mod),
    .DATA_OUT (data_out_scalar_modular_mod)
  );

  // SCALAR ADDER
  model_scalar_modular_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_modular_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_modular_adder),
    .READY(ready_scalar_modular_adder),

    .OPERATION(operation_scalar_modular_adder),

    // DATA
    .MODULO_IN(modulo_in_scalar_modular_adder),
    .DATA_A_IN(data_a_in_scalar_modular_adder),
    .DATA_B_IN(data_b_in_scalar_modular_adder),
    .DATA_OUT (data_out_scalar_modular_adder)
  );

  // SCALAR MULTIPLIER
  model_scalar_modular_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_modular_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_modular_multiplier),
    .READY(ready_scalar_modular_adder),

    // DATA
    .MODULO_IN(modulo_in_scalar_modular_multiplier),
    .DATA_A_IN(data_a_in_scalar_modular_multiplier),
    .DATA_B_IN(data_b_in_scalar_modular_multiplier),
    .DATA_OUT (data_out_scalar_modular_multiplier)
  );

  // SCALAR INVERTER
  model_scalar_modular_inverter #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_modular_inverter (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_modular_inverter),
    .READY(ready_scalar_modular_inverter),

    // DATA
    .MODULO_IN(modulo_in_scalar_modular_inverter),
    .DATA_IN  (data_in_scalar_modular_inverter),
    .DATA_OUT (data_out_scalar_modular_inverter)
  );

  //////////////////////////////////////////////////////////////////////////////
  // VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR MOD
  model_vector_modular_mod #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_modular_mod (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_modular_mod),
    .READY(ready_vector_modular_mod),

    .DATA_IN_ENABLE (data_in_enable_vector_modular_mod),
    .DATA_OUT_ENABLE(data_out_enable_vector_modular_mod),

    // DATA
    .MODULO_IN(modulo_in_vector_modular_mod),
    .SIZE_IN  (size_in_vector_modular_mod),
    .DATA_IN  (data_in_vector_modular_mod),
    .DATA_OUT (data_out_vector_modular_mod)
  );

  // VECTOR ADDER
  model_vector_modular_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_modular_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_modular_adder),
    .READY(ready_vector_modular_adder),

    .OPERATION(operation_vector_modular_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_modular_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_modular_adder),
    .DATA_OUT_ENABLE (data_out_enable_vector_modular_adder),

    // DATA
    .MODULO_IN(modulo_in_vector_modular_adder),
    .SIZE_IN  (size_in_vector_modular_adder),
    .DATA_A_IN(data_a_in_vector_modular_adder),
    .DATA_B_IN(data_b_in_vector_modular_adder),
    .DATA_OUT (data_out_vector_modular_adder)
  );

  // VECTOR MULTIPLIER
  model_vector_modular_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_modular_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_modular_multiplier),
    .READY(ready_vector_modular_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_modular_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_modular_multiplier),
    .DATA_OUT_ENABLE (data_out_enable_vector_modular_multiplier),

    // DATA
    .MODULO_IN(modulo_in_vector_modular_multiplier),
    .SIZE_IN  (size_in_vector_modular_multiplier),
    .DATA_A_IN(data_a_in_vector_modular_multiplier),
    .DATA_B_IN(data_b_in_vector_modular_multiplier),
    .DATA_OUT (data_out_vector_modular_multiplier)
  );

  // VECTOR INVERTER
  model_vector_modular_inverter #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_modular_inverter (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_modular_inverter),
    .READY(ready_vector_modular_inverter),

    .DATA_IN_ENABLE (data_in_enable_vector_modular_inverter),
    .DATA_OUT_ENABLE(data_out_enable_vector_modular_inverter),

    // DATA
    .MODULO_IN(modulo_in_vector_modular_inverter),
    .SIZE_IN  (size_in_vector_modular_inverter),
    .DATA_IN  (data_in_vector_modular_inverter),
    .DATA_OUT (data_out_vector_modular_inverter)
  );

  //////////////////////////////////////////////////////////////////////////////
  // MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX MOD
  model_matrix_modular_mod #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_modular_mod (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_modular_mod),
    .READY(ready_matrix_modular_mod),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_modular_mod),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_modular_mod),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_modular_mod),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_modular_mod),

    // DATA
    .MODULO_IN(modulo_in_matrix_modular_mod),
    .SIZE_I_IN(size_i_in_matrix_modular_mod),
    .SIZE_J_IN(size_j_in_matrix_modular_mod),
    .DATA_IN  (data_in_matrix_modular_mod),
    .DATA_OUT (data_out_matrix_modular_mod)
  );

  // MATRIX ADDER
  model_matrix_modular_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_modular_adder (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_modular_adder),
    .READY(ready_matrix_modular_adder),

    .OPERATION(operation_matrix_modular_adder),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_modular_adder),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_modular_adder),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_modular_adder),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_modular_adder),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_modular_adder),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_modular_adder),

    // DATA
    .MODULO_IN(modulo_in_matrix_modular_adder),
    .SIZE_I_IN(size_i_in_matrix_modular_adder),
    .SIZE_J_IN(size_j_in_matrix_modular_adder),
    .DATA_A_IN(data_a_in_matrix_modular_adder),
    .DATA_B_IN(data_b_in_matrix_modular_adder),
    .DATA_OUT (data_out_matrix_modular_adder)
  );

  // MATRIX MULTIPLIER
  model_matrix_modular_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_modular_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_modular_multiplier),
    .READY(ready_matrix_modular_multiplier),

    .DATA_A_IN_I_ENABLE(data_a_in_i_enable_matrix_modular_multiplier),
    .DATA_A_IN_J_ENABLE(data_a_in_j_enable_matrix_modular_multiplier),
    .DATA_B_IN_I_ENABLE(data_b_in_i_enable_matrix_modular_multiplier),
    .DATA_B_IN_J_ENABLE(data_b_in_j_enable_matrix_modular_multiplier),
    .DATA_OUT_I_ENABLE (data_out_i_enable_matrix_modular_multiplier),
    .DATA_OUT_J_ENABLE (data_out_j_enable_matrix_modular_multiplier),

    // DATA
    .MODULO_IN(modulo_in_matrix_modular_multiplier),
    .SIZE_I_IN(size_i_in_matrix_modular_multiplier),
    .SIZE_J_IN(size_j_in_matrix_modular_multiplier),
    .DATA_A_IN(data_a_in_matrix_modular_multiplier),
    .DATA_B_IN(data_b_in_matrix_modular_multiplier),
    .DATA_OUT (data_out_matrix_modular_multiplier)
  );

  // MATRIX INVERTER
  model_matrix_modular_inverter #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) matrix_modular_inverter (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_modular_inverter),
    .READY(ready_matrix_modular_inverter),

    .DATA_IN_I_ENABLE (data_in_i_enable_matrix_modular_inverter),
    .DATA_IN_J_ENABLE (data_in_j_enable_matrix_modular_inverter),
    .DATA_OUT_I_ENABLE(data_out_i_enable_matrix_modular_inverter),
    .DATA_OUT_J_ENABLE(data_out_j_enable_matrix_modular_inverter),

    // DATA
    .MODULO_IN(modulo_in_matrix_modular_inverter),
    .SIZE_I_IN(size_i_in_matrix_modular_inverter),
    .SIZE_J_IN(size_j_in_matrix_modular_inverter),
    .DATA_IN  (data_in_matrix_modular_inverter),
    .DATA_OUT (data_out_matrix_modular_inverter)
  );

endmodule
