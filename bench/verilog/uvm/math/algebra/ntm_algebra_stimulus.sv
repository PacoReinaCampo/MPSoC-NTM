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

module ntm_algebra_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE=512,

  parameter X=64,
  parameter Y=64,
  parameter N=64,
  parameter W=64,
  parameter L=64,
  parameter R=64,

  // FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_DETERMINANT_TEST=0,
  parameter STIMULUS_NTM_MATRIX_INVERSION_TEST=0,
  parameter STIMULUS_NTM_MATRIX_PRODUCT_TEST=0,
  parameter STIMULUS_NTM_MATRIX_RANK_TEST=0,
  parameter STIMULUS_NTM_MATRIX_TRANSPOSE_TEST=0,
  parameter STIMULUS_NTM_SCALAR_PRODUCT_TEST=0,
  parameter STIMULUS_NTM_TENSOR_PRODUCT_TEST=0,
  parameter STIMULUS_NTM_MATRIX_DETERMINANT_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_INVERSION_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_PRODUCT_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_RANK_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_PRODUCT_CASE_0=0,
  parameter STIMULUS_NTM_TENSOR_PRODUCT_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_DETERMINANT_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_INVERSION_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_PRODUCT_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_RANK_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_PRODUCT_CASE_1=0,
  parameter STIMULUS_NTM_TENSOR_PRODUCT_CASE_1=0
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // MATRIX DETERMINANT
    // CONTROL
    input MATRIX_DETERMINANT_START,
    input MATRIX_DETERMINANT_READY,

    input MATRIX_DETERMINANT_DATA_IN_I_ENABLE,
    input MATRIX_DETERMINANT_DATA_IN_J_ENABLE,
    output MATRIX_DETERMINANT_DATA_OUT_I_ENABLE,
    output MATRIX_DETERMINANT_DATA_OUT_J_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MATRIX_DETERMINANT_MODULO_IN,
    input [DATA_SIZE-1:0] MATRIX_DETERMINANT_DATA_IN,
    output [DATA_SIZE-1:0] MATRIX_DETERMINANT_DATA_OUT,

    // MATRIX INVERSION
    // CONTROL
    input MATRIX_INVERSION_START,
    output MATRIX_INVERSION_READY,

    input MATRIX_INVERSION_DATA_IN_I_ENABLE,
    input MATRIX_INVERSION_DATA_IN_J_ENABLE,
    output MATRIX_INVERSION_DATA_OUT_I_ENABLE,
    output MATRIX_INVERSION_DATA_OUT_J_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MATRIX_INVERSION_MODULO_IN,
    input [DATA_SIZE-1:0] MATRIX_INVERSION_DATA_IN,
    output [DATA_SIZE-1:0] MATRIX_INVERSION_DATA_OUT,

    // MATRIX PRODUCT
    // CONTROL
    input MATRIX_PRODUCT_START,
    output MATRIX_PRODUCT_READY,

    input MATRIX_PRODUCT_DATA_A_IN_I_ENABLE,
    input MATRIX_PRODUCT_DATA_A_IN_J_ENABLE,
    input MATRIX_PRODUCT_DATA_B_IN_I_ENABLE,
    input MATRIX_PRODUCT_DATA_B_IN_J_ENABLE,
    output MATRIX_PRODUCT_DATA_OUT_I_ENABLE,
    output MATRIX_PRODUCT_DATA_OUT_J_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_MODULO_IN,
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_SIZE_A_I_IN,
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_SIZE_A_J_IN,
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_SIZE_B_I_IN,
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_SIZE_B_J_IN,
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_DATA_A_IN,
    input [DATA_SIZE-1:0] MATRIX_PRODUCT_DATA_B_IN,
    output [DATA_SIZE-1:0] MATRIX_PRODUCT_DATA_OUT,

    // MATRIX RANK
    // CONTROL
    input MATRIX_RANK_START,
    output MATRIX_RANK_READY,

    input MATRIX_RANK_DATA_IN_I_ENABLE,
    input MATRIX_RANK_DATA_IN_J_ENABLE,
    output MATRIX_RANK_DATA_OUT_I_ENABLE,
    output MATRIX_RANK_DATA_OUT_J_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MATRIX_RANK_MODULO_IN,
    input [DATA_SIZE-1:0] MATRIX_RANK_DATA_IN,
    output [DATA_SIZE-1:0] MATRIX_RANK_DATA_OUT,

    // MATRIX TRANSPOSE
    // CONTROL
    input MATRIX_TRANSPOSE_START,
    output MATRIX_TRANSPOSE_READY,

    input MATRIX_TRANSPOSE_DATA_IN_I_ENABLE,
    input MATRIX_TRANSPOSE_DATA_IN_J_ENABLE,
    output MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE,
    output MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] MATRIX_TRANSPOSE_MODULO_IN,
    input [DATA_SIZE-1:0] MATRIX_TRANSPOSE_DATA_IN,
    output [DATA_SIZE-1:0] MATRIX_TRANSPOSE_DATA_OUT,

    // SCALAR PRODUCT
    // CONTROL
    input SCALAR_PRODUCT_START,
    output SCALAR_PRODUCT_READY,

    input SCALAR_PRODUCT_DATA_A_IN_ENABLE,
    input SCALAR_PRODUCT_DATA_B_IN_ENABLE,
    output SCALAR_PRODUCT_DATA_OUT_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] SCALAR_PRODUCT_MODULO_IN,
    input [DATA_SIZE-1:0] SCALAR_PRODUCT_LENGTH_IN,
    input [DATA_SIZE-1:0] SCALAR_PRODUCT_DATA_A_IN,
    input [DATA_SIZE-1:0] SCALAR_PRODUCT_DATA_B_IN,
    output [DATA_SIZE-1:0] SCALAR_PRODUCT_DATA_OUT,

    // TENSOR PRODUCT
    // CONTROL
    input TENSOR_PRODUCT_START,
    output TENSOR_PRODUCT_READY,

    input TENSOR_PRODUCT_DATA_A_IN_I_ENABLE,
    input TENSOR_PRODUCT_DATA_A_IN_J_ENABLE,
    input TENSOR_PRODUCT_DATA_A_IN_K_ENABLE,
    input TENSOR_PRODUCT_DATA_B_IN_I_ENABLE,
    input TENSOR_PRODUCT_DATA_B_IN_J_ENABLE,
    input TENSOR_PRODUCT_DATA_B_IN_K_ENABLE,
    output TENSOR_PRODUCT_DATA_OUT_I_ENABLE,
    output TENSOR_PRODUCT_DATA_OUT_J_ENABLE,
    output TENSOR_PRODUCT_DATA_OUT_K_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] TENSOR_PRODUCT_MODULO_IN,
    input [DATA_SIZE-1:0] TENSOR_PRODUCT_DATA_A_IN,
    input [DATA_SIZE-1:0] TENSOR_PRODUCT_DATA_B_IN,
    output [DATA_SIZE-1:0] TENSOR_PRODUCT_DATA_OUT
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
