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

module model_read_heads_memory_stimulus #(
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

  // FREE GATES
  // CONTROL
  output NTM_FREE_GATES_START,
  input  NTM_FREE_GATES_READY,

  output NTM_FREE_GATES_F_IN_ENABLE,
  input  NTM_FREE_GATES_F_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_FREE_GATES_SIZE_R_IN,
  output [DATA_SIZE-1:0] NTM_FREE_GATES_F_IN,
  output                 NTM_FREE_GATES_F_OUT,

  // READ KEYS
  // CONTROL
  output NTM_READ_KEYS_START,
  output NTM_READ_KEYS_READY,

  output NTM_READ_KEYS_K_IN_I_ENABLE,
  output NTM_READ_KEYS_K_IN_K_ENABLE,
  output NTM_READ_KEYS_K_OUT_I_ENABLE,
  output NTM_READ_KEYS_K_OUT_K_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_READ_KEYS_SIZE_R_IN,
  output [DATA_SIZE-1:0] NTM_READ_KEYS_SIZE_W_IN,
  output [DATA_SIZE-1:0] NTM_READ_KEYS_K_IN,
  output [DATA_SIZE-1:0] NTM_READ_KEYS_K_OUT,

  // READ MODES
  // CONTROL
  output NTM_READ_MODES_START,
  output NTM_READ_MODES_READY,

  output NTM_READ_MODES_PI_IN_I_ENABLE,
  output NTM_READ_MODES_PI_IN_P_ENABLE,
  output NTM_READ_MODES_PI_OUT_I_ENABLE,
  output NTM_READ_MODES_PI_OUT_P_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_READ_MODES_SIZE_R_IN,
  output [DATA_SIZE-1:0] NTM_READ_MODES_PI_IN,
  output [DATA_SIZE-1:0] NTM_READ_MODES_PI_OUT,

  // READ STRENGTHS
  // CONTROL
  output NTM_READ_STRENGTHS_START,
  output NTM_READ_STRENGTHS_READY,

  output NTM_READ_STRENGTHS_BETA_IN_ENABLE,
  output NTM_READ_STRENGTHS_BETA_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] NTM_READ_STRENGTHS_SIZE_R_IN,
  output [DATA_SIZE-1:0] NTM_READ_STRENGTHS_BETA_IN,
  output [DATA_SIZE-1:0] NTM_READ_STRENGTHS_BETA_OUT
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
