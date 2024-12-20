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

module model_memory_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4,

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

  // MEMORY STIMULUS
  // CONTROL
  output NTM_MEMORY_START,
  input  NTM_MEMORY_READY,

  output NTM_MEMORY_K_IN_ENABLE,
  output NTM_MEMORY_S_IN_ENABLE,

  input NTM_MEMORY_K_OUT_ENABLE,
  input NTM_MEMORY_S_OUT_ENABLE,

  output NTM_MEMORY_M_IN_J_ENABLE,
  output NTM_MEMORY_M_IN_K_ENABLE,

  input NTM_MEMORY_M_OUT_J_ENABLE,
  input NTM_MEMORY_M_OUT_K_ENABLE,

  output NTM_MEMORY_W_IN_ENABLE,
  input  NTM_MEMORY_W_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_MEMORY_SIZE_N_IN,
  output [DATA_SIZE-1:0] NTM_MEMORY_SIZE_W_IN,

  output [DATA_SIZE-1:0] NTM_MEMORY_K_IN,
  output [DATA_SIZE-1:0] NTM_MEMORY_BETA_IN,
  output [DATA_SIZE-1:0] NTM_MEMORY_G_IN,
  output [DATA_SIZE-1:0] NTM_MEMORY_S_IN,
  output [DATA_SIZE-1:0] NTM_MEMORY_GAMMA_IN,

  output [DATA_SIZE-1:0] NTM_MEMORY_M_IN,
  output [DATA_SIZE-1:0] NTM_MEMORY_W_IN,

  input [DATA_SIZE-1:0] NTM_MEMORY_W_OUT
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
