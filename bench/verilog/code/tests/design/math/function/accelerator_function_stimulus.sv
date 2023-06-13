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

module accelerator_function_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64,

  parameter X = 64,
  parameter Y = 64,
  parameter N = 64,
  parameter W = 64,
  parameter L = 64,
  parameter R = 64,

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_TEST    = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_0  = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_LOGISTIC_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_SCALAR_ONEPLUS_CASE_1  = 0,

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_TEST    = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_0  = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_LOGISTIC_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_ONEPLUS_CASE_1  = 0,

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_TEST    = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_0  = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_LOGISTIC_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_ONEPLUS_CASE_1  = 0
) (
  // GLOBAL
  output CLK,
  output RST,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS SCALAR
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR LOGISTIC
  // CONTROL
  output SCALAR_LOGISTIC_START,
  input  SCALAR_LOGISTIC_READY,

  // DATA
  output [DATA_SIZE-1:0] SCALAR_LOGISTIC_DATA_IN,
  input  [DATA_SIZE-1:0] SCALAR_LOGISTIC_DATA_OUT,

  // SCALAR ONEPLUS
  // CONTROL
  output SCALAR_ONEPLUS_START,
  input  SCALAR_ONEPLUS_READY,

  // DATA
  output [DATA_SIZE-1:0] SCALAR_ONEPLUS_DATA_IN,
  input  [DATA_SIZE-1:0] SCALAR_ONEPLUS_DATA_OUT,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR LOGISTIC
  // CONTROL
  output VECTOR_LOGISTIC_START,
  input  VECTOR_LOGISTIC_READY,

  output VECTOR_LOGISTIC_DATA_IN_ENABLE,
  input  VECTOR_LOGISTIC_DATA_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_LOGISTIC_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_LOGISTIC_DATA_IN,
  input  [DATA_SIZE-1:0] VECTOR_LOGISTIC_DATA_OUT,

  // VECTOR ONEPLUS
  // CONTROL
  output VECTOR_ONEPLUS_START,
  input  VECTOR_ONEPLUS_READY,

  output VECTOR_ONEPLUS_DATA_IN_ENABLE,
  input  VECTOR_ONEPLUS_DATA_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_ONEPLUS_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_ONEPLUS_DATA_IN,
  input  [DATA_SIZE-1:0] VECTOR_ONEPLUS_DATA_OUT,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX LOGISTIC
  // CONTROL
  output MATRIX_LOGISTIC_START,
  input  MATRIX_LOGISTIC_READY,

  output MATRIX_LOGISTIC_DATA_IN_I_ENABLE,
  output MATRIX_LOGISTIC_DATA_IN_J_ENABLE,
  input  MATRIX_LOGISTIC_DATA_OUT_I_ENABLE,
  input  MATRIX_LOGISTIC_DATA_OUT_J_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_LOGISTIC_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_LOGISTIC_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_LOGISTIC_DATA_IN,
  input  [DATA_SIZE-1:0] MATRIX_LOGISTIC_DATA_OUT,

  // MATRIX ONEPLUS
  // CONTROL
  output MATRIX_ONEPLUS_START,
  input  MATRIX_ONEPLUS_READY,

  output MATRIX_ONEPLUS_DATA_IN_I_ENABLE,
  output MATRIX_ONEPLUS_DATA_IN_J_ENABLE,
  input  MATRIX_ONEPLUS_DATA_OUT_I_ENABLE,
  input  MATRIX_ONEPLUS_DATA_OUT_J_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_ONEPLUS_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_ONEPLUS_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_ONEPLUS_DATA_IN,
  input  [DATA_SIZE-1:0] MATRIX_ONEPLUS_DATA_OUT
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
