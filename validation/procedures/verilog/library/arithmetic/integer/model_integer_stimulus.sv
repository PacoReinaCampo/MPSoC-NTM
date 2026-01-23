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

module model_integer_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4,

  parameter X = 64,
  parameter Y = 64,
  parameter N = 64,
  parameter W = 64,
  parameter L = 64,
  parameter R = 64,

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_TEST        = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_TEST      = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_0      = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_0    = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_ADDER_CASE_1      = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_MULTIPLIER_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_INTEGER_DIVIDER_CASE_1    = 0,

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_TEST        = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_TEST      = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_0      = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_0    = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_ADDER_CASE_1      = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_MULTIPLIER_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGER_DIVIDER_CASE_1    = 0,

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_TEST        = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_TEST      = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_0      = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_0    = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_ADDER_CASE_1      = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_MULTIPLIER_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGER_DIVIDER_CASE_1    = 0
) (
  // GLOBAL
  output CLK,
  output RST,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  // CONTROL
  output SCALAR_INTEGER_ADDER_START,
  input  SCALAR_INTEGER_ADDER_READY,
  output SCALAR_INTEGER_ADDER_OPERATION,

  // DATA
  output [DATA_SIZE-1:0] SCALAR_INTEGER_ADDER_DATA_A_IN,
  output [DATA_SIZE-1:0] SCALAR_INTEGER_ADDER_DATA_B_IN,

  input [DATA_SIZE-1:0] SCALAR_INTEGER_ADDER_DATA_OUT,
  input                 SCALAR_INTEGER_ADDER_OVERFLOW_OUT,

  // SCALAR MULTIPLIER
  // CONTROL
  output SCALAR_INTEGER_MULTIPLIER_START,
  input  SCALAR_INTEGER_MULTIPLIER_READY,

  // DATA
  output [DATA_SIZE-1:0] SCALAR_INTEGER_MULTIPLIER_DATA_A_IN,
  output [DATA_SIZE-1:0] SCALAR_INTEGER_MULTIPLIER_DATA_B_IN,

  input [DATA_SIZE-1:0] SCALAR_INTEGER_MULTIPLIER_DATA_OUT,
  input [DATA_SIZE-1:0] SCALAR_INTEGER_MULTIPLIER_OVERFLOW_OUT,

  // SCALAR DIVIDER
  // CONTROL
  output SCALAR_INTEGER_DIVIDER_START,
  input  SCALAR_INTEGER_DIVIDER_READY,

  // DATA
  output [DATA_SIZE-1:0] SCALAR_INTEGER_DIVIDER_DATA_A_IN,
  output [DATA_SIZE-1:0] SCALAR_INTEGER_DIVIDER_DATA_B_IN,

  input [DATA_SIZE-1:0] SCALAR_INTEGER_DIVIDER_DATA_OUT,
  input [DATA_SIZE-1:0] SCALAR_INTEGER_DIVIDER_REST_OUT,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR ADDER
  // CONTROL
  output VECTOR_INTEGER_ADDER_START,
  input  VECTOR_INTEGER_ADDER_READY,

  output VECTOR_INTEGER_ADDER_OPERATION,

  output VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE,
  output VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE,
  input  VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_INTEGER_ADDER_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGER_ADDER_DATA_A_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGER_ADDER_DATA_B_IN,

  input [DATA_SIZE-1:0] VECTOR_INTEGER_ADDER_DATA_OUT,
  input                 VECTOR_INTEGER_ADDER_OVERFLOW_OUT,

  // VECTOR MULTIPLIER
  // CONTROL
  output VECTOR_INTEGER_MULTIPLIER_START,
  input  VECTOR_INTEGER_MULTIPLIER_READY,

  output VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE,
  output VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE,
  input  VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_INTEGER_MULTIPLIER_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGER_MULTIPLIER_DATA_A_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGER_MULTIPLIER_DATA_B_IN,

  input [DATA_SIZE-1:0] VECTOR_INTEGER_MULTIPLIER_DATA_OUT,
  input [DATA_SIZE-1:0] VECTOR_INTEGER_MULTIPLIER_OVERFLOW_OUT,

  // VECTOR DIVIDER
  // CONTROL
  output VECTOR_INTEGER_DIVIDER_START,
  input  VECTOR_INTEGER_DIVIDER_READY,

  output VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE,
  output VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE,
  input  VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_INTEGER_DIVIDER_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGER_DIVIDER_DATA_A_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGER_DIVIDER_DATA_B_IN,

  input [DATA_SIZE-1:0] VECTOR_INTEGER_DIVIDER_DATA_OUT,
  input [DATA_SIZE-1:0] VECTOR_INTEGER_DIVIDER_REST_OUT,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX ADDER
  // CONTROL
  output MATRIX_INTEGER_ADDER_START,
  input  MATRIX_INTEGER_ADDER_READY,

  output MATRIX_INTEGER_ADDER_OPERATION,

  output MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE,
  output MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE,
  output MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE,
  output MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE,
  input  MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE,
  input  MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_INTEGER_ADDER_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_ADDER_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_ADDER_DATA_A_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_ADDER_DATA_B_IN,

  input [DATA_SIZE-1:0] MATRIX_INTEGER_ADDER_DATA_OUT,
  input                 MATRIX_INTEGER_ADDER_OVERFLOW_OUT,

  // MATRIX MULTIPLIER
  // CONTROL
  output MATRIX_INTEGER_MULTIPLIER_START,
  input  MATRIX_INTEGER_MULTIPLIER_READY,
  output MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE,
  output MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE,
  output MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE,
  output MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE,
  input  MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE,
  input  MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_MULTIPLIER_DATA_A_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_MULTIPLIER_DATA_B_IN,

  input [DATA_SIZE-1:0] MATRIX_INTEGER_MULTIPLIER_DATA_OUT,
  input [DATA_SIZE-1:0] MATRIX_INTEGER_MULTIPLIER_OVERFLOW_OUT,

  // MATRIX DIVIDER
  // CONTROL
  output MATRIX_INTEGER_DIVIDER_START,
  input  MATRIX_INTEGER_DIVIDER_READY,

  output MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE,
  output MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE,
  output MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE,
  output MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE,
  input  MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE,
  input  MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_INTEGER_DIVIDER_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_DIVIDER_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_DIVIDER_DATA_A_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGER_DIVIDER_DATA_B_IN,

  input [DATA_SIZE-1:0] MATRIX_INTEGER_DIVIDER_DATA_OUT,
  input [DATA_SIZE-1:0] MATRIX_INTEGER_DIVIDER_REST_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

endmodule
