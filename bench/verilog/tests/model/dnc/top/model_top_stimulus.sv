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
//              Peripheral-DNC for MPSoC                                      //
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

module model_top_stimulus #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64,

  parameter X = 64,
  parameter Y = 64,
  parameter N = 64,
  parameter W = 64,
  parameter L = 64,
  parameter R = 64,

  parameter STIMULUS_DNC_TOP_TEST   = 0,
  parameter STIMULUS_DNC_TOP_CASE_0 = 0,
  parameter STIMULUS_DNC_TOP_CASE_1 = 0
) (
  // GLOBAL
  output CLK,
  output RST,

  // CONTROL
  output DNC_TOP_START,
  input  DNC_TOP_READY,

  output DNC_TOP_W_IN_L_ENABLE,
  output DNC_TOP_W_IN_X_ENABLE,

  input DNC_TOP_W_OUT_L_ENABLE,
  input DNC_TOP_W_OUT_X_ENABLE,

  output DNC_TOP_K_IN_I_ENABLE,
  output DNC_TOP_K_IN_L_ENABLE,
  output DNC_TOP_K_IN_K_ENABLE,

  input DNC_TOP_K_OUT_I_ENABLE,
  input DNC_TOP_K_OUT_L_ENABLE,
  input DNC_TOP_K_OUT_K_ENABLE,

  output DNC_TOP_U_IN_L_ENABLE,
  output DNC_TOP_U_IN_P_ENABLE,

  input DNC_TOP_U_OUT_L_ENABLE,
  input DNC_TOP_U_OUT_P_ENABLE,

  output DNC_TOP_B_IN_ENABLE,

  input DNC_TOP_B_OUT_ENABLE,

  output DNC_TOP_X_IN_ENABLE,
  input  DNC_TOP_Y_OUT_ENABLE,

  // DATA
  output [DATA_SIZE-1:0] DNC_TOP_SIZE_X_IN,
  output [DATA_SIZE-1:0] DNC_TOP_SIZE_Y_IN,
  output [DATA_SIZE-1:0] DNC_TOP_SIZE_N_IN,
  output [DATA_SIZE-1:0] DNC_TOP_SIZE_W_IN,
  output [DATA_SIZE-1:0] DNC_TOP_SIZE_L_IN,
  output [DATA_SIZE-1:0] DNC_TOP_SIZE_R_IN,

  output [DATA_SIZE-1:0] DNC_TOP_W_IN,
  output [DATA_SIZE-1:0] DNC_TOP_K_IN,
  output [DATA_SIZE-1:0] DNC_TOP_U_IN,
  output [DATA_SIZE-1:0] DNC_TOP_B_IN,

  output [DATA_SIZE-1:0] DNC_TOP_X_IN,
  input  [DATA_SIZE-1:0] DNC_TOP_Y_OUT
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
