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

module model_write_heads_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64,

  parameter X = 64,
  parameter Y = 64,
  parameter N = 64,
  parameter W = 64,
  parameter L = 64,
  parameter R = 64
) (
  // GLOBAL
  output CLK,
  output RST,

  // ALLOCATION GATE
  // CONTROL
  output NTM_ALLOCATION_GATE_START,
  input  NTM_ALLOCATION_GATE_READY,

  // DATA
  output [DATA_SIZE-1:0] NTM_ALLOCATION_GATE_GA_IN,
  input                  NTM_ALLOCATION_GATE_GA_OUT,

  // ERASE VECTOR
  // CONTROL
  output NTM_ERASE_VECTOR_START,
  input  NTM_ERASE_VECTOR_READY,

  output NTM_ERASE_VECTOR_E_IN_ENABLE,
  input  NTM_ERASE_VECTOR_E_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_ERASE_VECTOR_SIZE_W_IN,
  output [DATA_SIZE-1:0] NTM_ERASE_VECTOR_E_IN,
  input                  NTM_ERASE_VECTOR_E_OUT,

  //WRITE GATE
  // CONTROL
  output NTM_WRITE_GATE_START,
  input  NTM_WRITE_GATE_READY,

  // DATA
  output [DATA_SIZE-1:0] NTM_WRITE_GATE_GW_IN,
  input                  NTM_WRITE_GATE_GW_OUT,

  // WRITE KEY
  // CONTROL
  output NTM_WRITE_KEY_START,
  input  NTM_WRITE_KEY_READY,

  output NTM_WRITE_KEY_K_IN_ENABLE,
  input  NTM_WRITE_KEY_K_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_WRITE_KEY_SIZE_W_IN,
  output [DATA_SIZE-1:0] NTM_WRITE_KEY_K_IN,
  input  [DATA_SIZE-1:0] NTM_WRITE_KEY_K_OUT,

  // WRITE STRENGTH
  // CONTROL
  output NTM_WRITE_STRENGTH_START,
  input  NTM_WRITE_STRENGTH_READY,

  // DATA
  output [DATA_SIZE-1:0] NTM_WRITE_STRENGTH_BETA_IN,
  input  [DATA_SIZE-1:0] NTM_WRITE_STRENGTH_BETA_OUT,

  // WRITE VECTOR
  // CONTROL
  output NTM_WRITE_VECTOR_START,
  input  NTM_WRITE_VECTOR_READY,

  output NTM_WRITE_VECTOR_V_IN_ENABLE,
  input  NTM_WRITE_VECTOR_V_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_WRITE_VECTOR_SIZE_W_IN,
  output [DATA_SIZE-1:0] NTM_WRITE_VECTOR_V_IN,
  input  [DATA_SIZE-1:0] NTM_WRITE_VECTOR_V_OUT
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
