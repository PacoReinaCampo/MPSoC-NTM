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

module ntm_function_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE=128,
  parameter CONTROL_SIZE=64,

  parameter X=64,
  parameter Y=64,
  parameter N=64,
  parameter W=64,
  parameter L=64,
  parameter R=64,

  // SCALAR-FUNCTIONALITY
  parameter STIMULUS_NTM_SCALAR_COSH_TEST=0,
  parameter STIMULUS_NTM_SCALAR_SINH_TEST=0,
  parameter STIMULUS_NTM_SCALAR_TANH_TEST=0,
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_TEST=0,
  parameter STIMULUS_NTM_SCALAR_ONEPLUS_TEST=0,
  parameter STIMULUS_NTM_SCALAR_COSH_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_SINH_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_TANH_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_ONEPLUS_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_COSH_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_SINH_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_TANH_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_LOGISTIC_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_ONEPLUS_CASE_1=0,

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_COSH_TEST=0,
  parameter STIMULUS_NTM_VECTOR_SINH_TEST=0,
  parameter STIMULUS_NTM_VECTOR_TANH_TEST=0,
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_TEST=0,
  parameter STIMULUS_NTM_VECTOR_ONEPLUS_TEST=0,
  parameter STIMULUS_NTM_VECTOR_COSH_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_SINH_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_TANH_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_ONEPLUS_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_COSH_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_SINH_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_TANH_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_LOGISTIC_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_ONEPLUS_CASE_1=0,

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_COSH_TEST=0,
  parameter STIMULUS_NTM_MATRIX_SINH_TEST=0,
  parameter STIMULUS_NTM_MATRIX_TANH_TEST=0,
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_TEST=0,
  parameter STIMULUS_NTM_MATRIX_ONEPLUS_TEST=0,
  parameter STIMULUS_NTM_MATRIX_COSH_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_SINH_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_TANH_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_ONEPLUS_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_COSH_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_SINH_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_TANH_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_LOGISTIC_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_ONEPLUS_CASE_1=0
)
  (
    // GLOBAL
    output CLK,
    output RST,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR COSH
    // CONTROL
    output SCALAR_COSH_START,
    input SCALAR_COSH_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_COSH_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_COSH_DATA_OUT,

    // SCALAR SINH
    // CONTROL
    output SCALAR_SINH_START,
    input SCALAR_SINH_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_SINH_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_SINH_DATA_OUT,

    // SCALAR TANH
    // CONTROL
    output SCALAR_TANH_START,
    input SCALAR_TANH_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_TANH_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_TANH_DATA_OUT,

    // CONTROL
    output SCALAR_LOGISTIC_START,
    input SCALAR_LOGISTIC_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_LOGISTIC_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_LOGISTIC_DATA_OUT,

    // SCALAR ONEPLUS
    // CONTROL
    output SCALAR_ONEPLUS_START,
    input SCALAR_ONEPLUS_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_ONEPLUS_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_ONEPLUS_DATA_OUT,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR COSH
    // CONTROL
    output VECTOR_COSH_START,
    input VECTOR_COSH_READY,

    output VECTOR_COSH_DATA_IN_ENABLE,
    input VECTOR_COSH_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_COSH_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_COSH_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_COSH_DATA_OUT,

    // VECTOR SINH
    // CONTROL
    output VECTOR_SINH_START,
    input VECTOR_SINH_READY,

    output VECTOR_SINH_DATA_IN_ENABLE,
    input VECTOR_SINH_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_SINH_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_SINH_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_SINH_DATA_OUT,

    // VECTOR TANH
    // CONTROL
    output VECTOR_TANH_START,
    input VECTOR_TANH_READY,

    output VECTOR_TANH_DATA_IN_ENABLE,
    input VECTOR_TANH_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_TANH_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_TANH_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_TANH_DATA_OUT,

    // VECTOR LOGISTIC
    // CONTROL
    output VECTOR_LOGISTIC_START,
    input VECTOR_LOGISTIC_READY,

    output VECTOR_LOGISTIC_DATA_IN_ENABLE,
    input VECTOR_LOGISTIC_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_LOGISTIC_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_LOGISTIC_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_LOGISTIC_DATA_OUT,

    // VECTOR ONEPLUS
    // CONTROL
    output VECTOR_ONEPLUS_START,
    input VECTOR_ONEPLUS_READY,

    output VECTOR_ONEPLUS_DATA_IN_ENABLE,
    input VECTOR_ONEPLUS_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_ONEPLUS_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_ONEPLUS_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_ONEPLUS_DATA_OUT,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////

    // MATRIX COSH
    // CONTROL
    output MATRIX_COSH_START,
    input MATRIX_COSH_READY,

    output MATRIX_COSH_DATA_IN_I_ENABLE,
    output MATRIX_COSH_DATA_IN_J_ENABLE,
    input MATRIX_COSH_DATA_OUT_I_ENABLE,
    input MATRIX_COSH_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_COSH_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_COSH_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_COSH_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_COSH_DATA_OUT,

    // MATRIX SINH
    // CONTROL
    output MATRIX_SINH_START,
    input MATRIX_SINH_READY,

    output MATRIX_SINH_DATA_IN_I_ENABLE,
    output MATRIX_SINH_DATA_IN_J_ENABLE,
    input MATRIX_SINH_DATA_OUT_I_ENABLE,
    input MATRIX_SINH_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_SINH_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_SINH_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_SINH_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_SINH_DATA_OUT,

    // MATRIX TANH
    // CONTROL
    output MATRIX_TANH_START,
    input MATRIX_TANH_READY,

    output MATRIX_TANH_DATA_IN_I_ENABLE,
    output MATRIX_TANH_DATA_IN_J_ENABLE,
    input MATRIX_TANH_DATA_OUT_I_ENABLE,
    input MATRIX_TANH_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_TANH_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_TANH_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_TANH_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_TANH_DATA_OUT,

    // MATRIX LOGISTIC
    // CONTROL
    output MATRIX_LOGISTIC_START,
    input MATRIX_LOGISTIC_READY,

    output MATRIX_LOGISTIC_DATA_IN_I_ENABLE,
    output MATRIX_LOGISTIC_DATA_IN_J_ENABLE,
    input MATRIX_LOGISTIC_DATA_OUT_I_ENABLE,
    input MATRIX_LOGISTIC_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_LOGISTIC_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_LOGISTIC_DATA_OUT,

    // MATRIX ONEPLUS
    // CONTROL
    output MATRIX_ONEPLUS_START,
    input MATRIX_ONEPLUS_READY,

    output MATRIX_ONEPLUS_DATA_IN_I_ENABLE,
    output MATRIX_ONEPLUS_DATA_IN_J_ENABLE,
    input MATRIX_ONEPLUS_DATA_OUT_I_ENABLE,
    input MATRIX_ONEPLUS_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_ONEPLUS_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_ONEPLUS_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_ONEPLUS_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_ONEPLUS_DATA_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

endmodule
