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

module ntm_function_testbench;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE=128;
  parameter CONTROL_SIZE=64;

  parameter X=64;
  parameter Y=64;
  parameter N=64;
  parameter W=64;
  parameter L=64;
  parameter R=64;

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST=0;
  parameter STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_0=0;
  parameter STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_1=0;

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_DIFFERENTIATION_TEST=0;
  parameter STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_0=0;
  parameter STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_1=0;

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_DIFFERENTIATION_TEST=0;
  parameter STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_0=0;
  parameter STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_1=0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire CLK;
  wire RST;

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR DIFFERENTIATION
  // CONTROL
  wire start_scalar_differentiation;
  wire ready_scalar_differentiation;

  wire data_in_enable_scalar_differentiation;
  wire data_out_enable_scalar_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] period_in_scalar_differentiation;
  wire [DATA_SIZE-1:0] length_in_scalar_differentiation;
  wire [DATA_SIZE-1:0] data_in_scalar_differentiation;
  wire [DATA_SIZE-1:0] data_out_scalar_differentiation;

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR DIFFERENTIATION
  // CONTROL
  wire start_vector_differentiation;
  wire ready_vector_differentiation;

  wire data_in_vector_enable_vector_differentiation;
  wire data_in_scalar_enable_vector_differentiation;
  wire data_out_vector_enable_vector_differentiation;
  wire data_out_scalar_enable_vector_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] period_in_vector_differentiation;
  wire [DATA_SIZE-1:0] length_in_vector_differentiation;
  wire [DATA_SIZE-1:0] size_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_in_vector_differentiation;
  wire [DATA_SIZE-1:0] data_out_vector_differentiation;

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX DIFFERENTIATION
  // CONTROL
  wire start_matrix_differentiation;
  wire ready_matrix_differentiation;

  wire data_in_matrix_enable_matrix_differentiation;
  wire data_in_vector_enable_matrix_differentiation;
  wire data_in_scalar_enable_matrix_differentiation;
  wire data_out_matrix_enable_matrix_differentiation;
  wire data_out_vector_enable_matrix_differentiation;
  wire data_out_scalar_enable_matrix_differentiation;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] size_j_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] period_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] length_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] data_in_matrix_differentiation;
  wire [DATA_SIZE-1:0] data_out_matrix_differentiation;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  ntm_function_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // SCALAR-FUNCTIONALITY
    .STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST(STIMULUS_NTM_SCALAR_DIFFERENTIATION_TEST),
    .STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_0(STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_0),
    .STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_1(STIMULUS_NTM_SCALAR_DIFFERENTIATION_CASE_1),

    // VECTOR-FUNCTIONALITY
    .STIMULUS_NTM_VECTOR_DIFFERENTIATION_TEST(STIMULUS_NTM_VECTOR_DIFFERENTIATION_TEST),
    .STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_0(STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_0),
    .STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_1(STIMULUS_NTM_VECTOR_DIFFERENTIATION_CASE_1),

    // MATRIX-FUNCTIONALITY
    .STIMULUS_NTM_MATRIX_DIFFERENTIATION_TEST(STIMULUS_NTM_MATRIX_DIFFERENTIATION_TEST),
    .STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_0(STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_0),
    .STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_1(STIMULUS_NTM_MATRIX_DIFFERENTIATION_CASE_1)
  )
  function_stimulus(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR DIFFERENTIATION
    // CONTROL
    .SCALAR_DIFFERENTIATION_START(),
    .SCALAR_DIFFERENTIATION_READY(),

    .SCALAR_DIFFERENTIATION_DATA_IN_ENABLE(),

    .SCALAR_DIFFERENTIATION_DATA_OUT_ENABLE(),

    // DATA
    .SCALAR_DIFFERENTIATION_DATA_IN(),
    .SCALAR_DIFFERENTIATION_DATA_OUT(),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR DIFFERENTIATION
    // CONTROL
    .VECTOR_DIFFERENTIATION_START(),
    .VECTOR_DIFFERENTIATION_READY(),

    .VECTOR_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE(),
    .VECTOR_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE(),

    .VECTOR_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE(),
    .VECTOR_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE(),

    // DATA
    .VECTOR_DIFFERENTIATION_SIZE_IN(),
    .VECTOR_DIFFERENTIATION_DATA_IN(),
    .VECTOR_DIFFERENTIATION_DATA_OUT(),

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////

    // MATRIX DIFFERENTIATION
    // CONTROL
    .MATRIX_DIFFERENTIATION_START(start_matrix_differentiation),
    .MATRIX_DIFFERENTIATION_READY(),

    .MATRIX_DIFFERENTIATION_DATA_IN_I_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_IN_J_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_OUT_I_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_OUT_J_ENABLE(),

    .MATRIX_DIFFERENTIATION_DATA_IN_MATRIX_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_IN_SCALAR_ENABLE(),

    .MATRIX_DIFFERENTIATION_DATA_OUT_MATRIX_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE(),
    .MATRIX_DIFFERENTIATION_DATA_OUT_SCALAR_ENABLE(),

    // DATA
    .MATRIX_DIFFERENTIATION_SIZE_I_IN(),
    .MATRIX_DIFFERENTIATION_SIZE_J_IN(),
    .MATRIX_DIFFERENTIATION_DATA_IN(),
    .MATRIX_DIFFERENTIATION_DATA_OUT()
  );

  ///////////////////////////////////////////////////////////////////////
  // SCALAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR DIFFERENTIATION
  ntm_scalar_differentiation_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  scalar_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_differentiation),
    .READY(ready_scalar_differentiation),

    .DATA_IN_ENABLE(data_in_enable_scalar_differentiation),
    .DATA_OUT_ENABLE(data_out_enable_scalar_differentiation),

    // DATA
    .PERIOD_IN(period_in_scalar_differentiation),
    .LENGTH_IN(length_in_scalar_differentiation),
    .DATA_IN(data_in_scalar_differentiation),
    .DATA_OUT(data_out_scalar_differentiation)
  );

  ///////////////////////////////////////////////////////////////////////
  // VECTOR
  ///////////////////////////////////////////////////////////////////////

  // VECTOR DIFFERENTIATION
  ntm_vector_differentiation_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  vector_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_differentiation),
    .READY(ready_vector_differentiation),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_differentiation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_differentiation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_differentiation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_differentiation),

    // DATA
    .SIZE_IN(size_in_vector_differentiation),
    .PERIOD_IN(period_in_vector_differentiation),
    .LENGTH_IN(length_in_vector_differentiation),
    .DATA_IN(data_in_vector_differentiation),
    .DATA_OUT(data_out_vector_differentiation)
  );

  ///////////////////////////////////////////////////////////////////////
  // MATRIX
  ///////////////////////////////////////////////////////////////////////

  // MATRIX DIFFERENTIATION
  ntm_matrix_differentiation_function #(
    .DATA_SIZE(DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  )
  matrix_differentiation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_differentiation),
    .READY(ready_matrix_differentiation),

    .DATA_IN_MATRIX_ENABLE(data_in_matrix_enable_matrix_differentiation),
    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_matrix_differentiation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_matrix_differentiation),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_differentiation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_differentiation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_differentiation),

    // DATA
    .SIZE_I_IN(size_i_in_matrix_differentiation),
    .SIZE_J_IN(size_j_in_matrix_differentiation),
    .PERIOD_IN(period_in_matrix_differentiation),
    .LENGTH_IN(length_in_matrix_differentiation),
    .DATA_IN(data_in_matrix_differentiation),
    .DATA_OUT(data_out_matrix_differentiation)
  );

endmodule