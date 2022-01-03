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

module ntm_modular_stimulus #(
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
  parameter STIMULUS_NTM_SCALAR_MODULAR_MOD_TEST=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_ADDER_TEST=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_TEST=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_INVERTER_TEST=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_0=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_MOD_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_ADDER_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_MULTIPLIER_CASE_1=0,
  parameter STIMULUS_NTM_SCALAR_MODULAR_INVERTER_CASE_1=0,

  // VECTOR-FUNCTIONALITY
  parameter STIMULUS_NTM_VECTOR_MODULAR_MOD_TEST=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_ADDER_TEST=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_TEST=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_INVERTER_TEST=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_0=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_MOD_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_ADDER_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_MULTIPLIER_CASE_1=0,
  parameter STIMULUS_NTM_VECTOR_MODULAR_INVERTER_CASE_1=0,

  // MATRIX-FUNCTIONALITY
  parameter STIMULUS_NTM_MATRIX_MODULAR_MOD_TEST=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_ADDER_TEST=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_TEST=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_INVERTER_TEST=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_0=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_MOD_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_ADDER_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_MULTIPLIER_CASE_1=0,
  parameter STIMULUS_NTM_MATRIX_MODULAR_INVERTER_CASE_1=0
)
  (
    // GLOBAL
    output CLK,
    output RST,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS SCALAR
    ///////////////////////////////////////////////////////////////////////

    // SCALAR MOD
    // CONTROL
    output SCALAR_MODULAR_MOD_START,
    input SCALAR_MODULAR_MOD_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_MODULAR_MOD_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_MODULAR_MOD_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_MODULAR_MOD_DATA_OUT,

    // SCALAR ADDER
    // CONTROL
    output SCALAR_MODULAR_ADDER_START,
    input SCALAR_MODULAR_ADDER_READY,
    output SCALAR_MODULAR_ADDER_OPERATION,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_MODULAR_ADDER_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_MODULAR_ADDER_DATA_A_IN,
    output [DATA_SIZE-1:0] SCALAR_MODULAR_ADDER_DATA_B_IN,
    input [DATA_SIZE-1:0] SCALAR_MODULAR_ADDER_DATA_OUT,

    // SCALAR MULTIPLIER
    // CONTROL
    output SCALAR_MODULAR_MULTIPLIER_START,
    input SCALAR_MODULAR_MULTIPLIER_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_MODULAR_MULTIPLIER_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_MODULAR_MULTIPLIER_DATA_A_IN,
    output [DATA_SIZE-1:0] SCALAR_MODULAR_MULTIPLIER_DATA_B_IN,
    input [DATA_SIZE-1:0] SCALAR_MODULAR_MULTIPLIER_DATA_OUT,

    // SCALAR INVERTER
    // CONTROL
    output SCALAR_MODULAR_INVERTER_START,
    input SCALAR_MODULAR_INVERTER_READY,

    // DATA
    output [DATA_SIZE-1:0] SCALAR_MODULAR_INVERTER_MODULO_IN,
    output [DATA_SIZE-1:0] SCALAR_MODULAR_INVERTER_DATA_IN,
    input [DATA_SIZE-1:0] SCALAR_MODULAR_INVERTER_DATA_OUT,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS VECTOR
    ///////////////////////////////////////////////////////////////////////

    // VECTOR MOD
    // CONTROL
    output VECTOR_MODULAR_MOD_START,
    input VECTOR_MODULAR_MOD_READY,
    output VECTOR_MODULAR_MOD_DATA_IN_ENABLE,
    input VECTOR_MODULAR_MOD_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MOD_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MOD_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MOD_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_MODULAR_MOD_DATA_OUT,

    // VECTOR ADDER
    // CONTROL
    output VECTOR_MODULAR_ADDER_START,
    input VECTOR_MODULAR_ADDER_READY,

    output VECTOR_MODULAR_ADDER_OPERATION,

    output VECTOR_MODULAR_ADDER_DATA_A_IN_ENABLE,
    output VECTOR_MODULAR_ADDER_DATA_B_IN_ENABLE,
    input VECTOR_MODULAR_ADDER_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_MODULAR_ADDER_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_ADDER_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_ADDER_DATA_A_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_ADDER_DATA_B_IN,
    input [DATA_SIZE-1:0] VECTOR_MODULAR_ADDER_DATA_OUT,

    // VECTOR MULTIPLIER
    // CONTROL
    output VECTOR_MODULAR_MULTIPLIER_START,
    input VECTOR_MODULAR_MULTIPLIER_READY,

    output VECTOR_MODULAR_MULTIPLIER_DATA_A_IN_ENABLE,
    output VECTOR_MODULAR_MULTIPLIER_DATA_B_IN_ENABLE,
    input VECTOR_MODULAR_MULTIPLIER_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MULTIPLIER_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MULTIPLIER_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MULTIPLIER_DATA_A_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_MULTIPLIER_DATA_B_IN,
    input [DATA_SIZE-1:0] VECTOR_MODULAR_MULTIPLIER_DATA_OUT,

    // VECTOR INVERTER
    // CONTROL
    output VECTOR_MODULAR_INVERTER_START,
    input VECTOR_MODULAR_INVERTER_READY,
    output VECTOR_MODULAR_INVERTER_DATA_IN_ENABLE,
    input VECTOR_MODULAR_INVERTER_DATA_OUT_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] VECTOR_MODULAR_INVERTER_MODULO_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_INVERTER_SIZE_IN,
    output [DATA_SIZE-1:0] VECTOR_MODULAR_INVERTER_DATA_IN,
    input [DATA_SIZE-1:0] VECTOR_MODULAR_INVERTER_DATA_OUT,

    ///////////////////////////////////////////////////////////////////////
    // STIMULUS MATRIX
    ///////////////////////////////////////////////////////////////////////
    // MATRIX MOD
    // CONTROL
    output MATRIX_MODULAR_MOD_START,
    input MATRIX_MODULAR_MOD_READY,

    output MATRIX_MODULAR_MOD_DATA_IN_I_ENABLE,
    output MATRIX_MODULAR_MOD_DATA_IN_J_ENABLE,
    input MATRIX_MODULAR_MOD_DATA_OUT_I_ENABLE,
    input MATRIX_MODULAR_MOD_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MOD_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MOD_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MOD_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MOD_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_MODULAR_MOD_DATA_OUT,

    // MATRIX ADDER
    // CONTROL
    output MATRIX_MODULAR_ADDER_START,
    input MATRIX_MODULAR_ADDER_READY,

    output MATRIX_MODULAR_ADDER_OPERATION,

    output MATRIX_MODULAR_ADDER_DATA_A_IN_I_ENABLE,
    output MATRIX_MODULAR_ADDER_DATA_A_IN_J_ENABLE,
    output MATRIX_MODULAR_ADDER_DATA_B_IN_I_ENABLE,
    output MATRIX_MODULAR_ADDER_DATA_B_IN_J_ENABLE,
    input MATRIX_MODULAR_ADDER_DATA_OUT_I_ENABLE,
    input MATRIX_MODULAR_ADDER_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_MODULAR_ADDER_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_ADDER_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_ADDER_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_ADDER_DATA_A_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_ADDER_DATA_B_IN,
    input [DATA_SIZE-1:0] MATRIX_MODULAR_ADDER_DATA_OUT,

    // MATRIX MULTIPLIER
    // CONTROL
    output MATRIX_MODULAR_MULTIPLIER_START,
    input MATRIX_MODULAR_MULTIPLIER_READY,
    output MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_I_ENABLE,
    output MATRIX_MODULAR_MULTIPLIER_DATA_A_IN_J_ENABLE,
    output MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_I_ENABLE,
    output MATRIX_MODULAR_MULTIPLIER_DATA_B_IN_J_ENABLE,
    input MATRIX_MODULAR_MULTIPLIER_DATA_OUT_I_ENABLE,
    input MATRIX_MODULAR_MULTIPLIER_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MULTIPLIER_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MULTIPLIER_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MULTIPLIER_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MULTIPLIER_DATA_A_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_MULTIPLIER_DATA_B_IN,
    input [DATA_SIZE-1:0] MATRIX_MODULAR_MULTIPLIER_DATA_OUT,

    // MATRIX INVERTER
    // CONTROL
    output MATRIX_MODULAR_INVERTER_START,
    input MATRIX_MODULAR_INVERTER_READY,

    output MATRIX_MODULAR_INVERTER_DATA_IN_I_ENABLE,
    output MATRIX_MODULAR_INVERTER_DATA_IN_J_ENABLE,
    input MATRIX_MODULAR_INVERTER_DATA_OUT_I_ENABLE,
    input MATRIX_MODULAR_INVERTER_DATA_OUT_J_ENABLE,

    // DATA
    output [DATA_SIZE-1:0] MATRIX_MODULAR_INVERTER_MODULO_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_INVERTER_SIZE_I_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_INVERTER_SIZE_J_IN,
    output [DATA_SIZE-1:0] MATRIX_MODULAR_INVERTER_DATA_IN,
    input [DATA_SIZE-1:0] MATRIX_MODULAR_INVERTER_DATA_OUT
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
