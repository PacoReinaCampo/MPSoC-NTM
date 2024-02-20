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

module accelerator_calculus_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4,

  parameter X = 64,
  parameter Y = 64,
  parameter N = 64,
  parameter W = 64,
  parameter L = 64,
  parameter R = 64,

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_TEST       = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_CASE_0     = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_DIFFERENTIATION_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_VECTOR_INTEGRATION_CASE_1     = 0,

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_TEST       = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_CASE_0     = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_DIFFERENTIATION_CASE_1 = 0,
  parameter STIMULUS_ACCELERATOR_MATRIX_INTEGRATION_CASE_1     = 0,

  // TENSOR-FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_TEST   = 0,
  parameter STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_TEST       = 0,
  parameter STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_0 = 0,
  parameter STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_CASE_0     = 0,
  parameter STIMULUS_ACCELERATOR_TENSOR_INTEGRATION_CASE_1     = 0,
  parameter STIMULUS_ACCELERATOR_TENSOR_DIFFERENTIATION_CASE_1 = 0
) (
  // GLOBAL
  output CLK,
  output RST,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS VECTOR
  //////////////////////////////////////////////////////////////////////////////

  // VECTOR DIFFERENTIATION
  // CONTROL
  output VECTOR_DIFFERENTIATION_START,
  input  VECTOR_DIFFERENTIATION_READY,

  output VECTOR_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE,
  output VECTOR_DIFFERENTIATION_DATA_IN_TENSOR_ENABLE,

  input VECTOR_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE,
  input VECTOR_DIFFERENTIATION_DATA_OUT_TENSOR_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_DIFFERENTIATION_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_DIFFERENTIATION_DATA_IN,
  input  [DATA_SIZE-1:0] VECTOR_DIFFERENTIATION_DATA_OUT,

  // VECTOR INTEGRATION
  // CONTROL
  output VECTOR_INTEGRATION_START,
  input  VECTOR_INTEGRATION_READY,

  output VECTOR_INTEGRATION_DATA_IN_VECTOR_ENABLE,
  output VECTOR_INTEGRATION_DATA_IN_TENSOR_ENABLE,

  input VECTOR_INTEGRATION_DATA_OUT_VECTOR_ENABLE,
  input VECTOR_INTEGRATION_DATA_OUT_TENSOR_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] VECTOR_INTEGRATION_SIZE_IN,
  output [DATA_SIZE-1:0] VECTOR_INTEGRATION_DATA_IN,
  input  [DATA_SIZE-1:0] VECTOR_INTEGRATION_DATA_OUT,

  //////////////////////////////////////////////////////////////////////////////
  // STIMULUS MATRIX
  //////////////////////////////////////////////////////////////////////////////

  // MATRIX DIFFERENTIATION
  // CONTROL
  output MATRIX_DIFFERENTIATION_START,
  input  MATRIX_DIFFERENTIATION_READY,

  output MATRIX_DIFFERENTIATION_DATA_IN_MATRIX_ENABLE,
  output MATRIX_DIFFERENTIATION_DATA_IN_VECTOR_ENABLE,
  output MATRIX_DIFFERENTIATION_DATA_IN_TENSOR_ENABLE,

  input MATRIX_DIFFERENTIATION_DATA_OUT_MATRIX_ENABLE,
  input MATRIX_DIFFERENTIATION_DATA_OUT_VECTOR_ENABLE,
  input MATRIX_DIFFERENTIATION_DATA_OUT_TENSOR_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_DIFFERENTIATION_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_DIFFERENTIATION_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_DIFFERENTIATION_DATA_IN,
  input  [DATA_SIZE-1:0] MATRIX_DIFFERENTIATION_DATA_OUT,

  // MATRIX INTEGRATION
  // CONTROL
  output MATRIX_INTEGRATION_START,
  input  MATRIX_INTEGRATION_READY,

  output MATRIX_INTEGRATION_DATA_IN_MATRIX_ENABLE,
  output MATRIX_INTEGRATION_DATA_IN_VECTOR_ENABLE,
  output MATRIX_INTEGRATION_DATA_IN_TENSOR_ENABLE,

  input MATRIX_INTEGRATION_DATA_OUT_MATRIX_ENABLE,
  input MATRIX_INTEGRATION_DATA_OUT_VECTOR_ENABLE,
  input MATRIX_INTEGRATION_DATA_OUT_TENSOR_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] MATRIX_INTEGRATION_SIZE_I_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGRATION_SIZE_J_IN,
  output [DATA_SIZE-1:0] MATRIX_INTEGRATION_DATA_IN,
  input  [DATA_SIZE-1:0] MATRIX_INTEGRATION_DATA_OUT
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
