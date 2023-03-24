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

module dnc_top_synthesis #(
  // SYSTEM-SIZE
  parameter DATA_SIZE    = 128,
  parameter CONTROL_SIZE = 64,

  parameter X = 64,
  parameter Y = 64,
  parameter N = 64,
  parameter W = 64,
  parameter L = 64,
  parameter R = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input  START,
  output READY,

  input W_IN_L_ENABLE,  // for l in 0 to L-1
  input W_IN_X_ENABLE,  // for x in 0 to X-1

  output W_OUT_L_ENABLE,  // for l in 0 to L-1
  output W_OUT_X_ENABLE,  // for x in 0 to X-1

  input K_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input K_IN_L_ENABLE,  // for l in 0 to L-1
  input K_IN_K_ENABLE,  // for k in 0 to W-1

  output K_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output K_OUT_L_ENABLE,  // for l in 0 to L-1
  output K_OUT_K_ENABLE,  // for k in 0 to W-1

  input B_IN_ENABLE,  // for l in 0 to L-1

  input B_OUT_ENABLE,  // for l in 0 to L-1

  input  X_IN_ENABLE,  // for x in 0 to X-1
  output Y_OUT_ENABLE  // for y in 0 to Y-1
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // DATA
  parameter size_x_in_top = 0;
  parameter size_y_in_top = 0;
  parameter size_n_in_top = 0;
  parameter size_w_in_top = 0;
  parameter size_l_in_top = 0;
  parameter size_r_in_top = 0;

  parameter w_in_top = 0;
  parameter k_in_top = 0;
  parameter u_in_top = 0;
  parameter b_in_top = 0;
  parameter x_in_top = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // TOP
  dnc_top #(
    .DATA_SIZE   (DATA_SIZE),
    .DATA_CONTROL(DATA_CONTROL)
  ) top (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(START),
    .READY(READY),

    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_top),
    .READY(ready_top),

    .W_IN_L_ENABLE(W_IN_L_ENABLE),
    .W_IN_X_ENABLE(W_IN_X_ENABLE),

    .W_OUT_L_ENABLE(W_OUT_L_ENABLE),
    .W_OUT_X_ENABLE(W_OUT_X_ENABLE),

    .K_IN_I_ENABLE(K_IN_I_ENABLE),
    .K_IN_L_ENABLE(K_IN_L_ENABLE),
    .K_IN_K_ENABLE(K_IN_K_ENABLE),

    .K_OUT_I_ENABLE(K_OUT_I_ENABLE),
    .K_OUT_L_ENABLE(K_OUT_L_ENABLE),
    .K_OUT_K_ENABLE(K_OUT_K_ENABLE),

    .U_IN_L_ENABLE(U_IN_L_ENABLE),
    .U_IN_P_ENABLE(U_IN_P_ENABLE),

    .U_OUT_L_ENABLE(U_OUT_L_ENABLE),
    .U_OUT_P_ENABLE(U_OUT_P_ENABLE),

    .B_IN_ENABLE(B_IN_ENABLE),

    .B_OUT_ENABLE(B_OUT_ENABLE),

    .X_IN_ENABLE (X_IN_ENABLE),
    .Y_OUT_ENABLE(Y_OUT_ENABLE),

    // DATA
    .SIZE_X_IN(size_x_in_top),
    .SIZE_Y_IN(size_y_in_top),
    .SIZE_N_IN(size_n_in_top),
    .SIZE_W_IN(size_w_in_top),
    .SIZE_L_IN(size_l_in_top),
    .SIZE_R_IN(size_r_in_top),

    .W_IN(w_in_top),
    .K_IN(k_in_top),
    .U_IN(u_in_top),
    .B_IN(b_in_top),

    .X_IN (x_in_top),
    .Y_OUT()
  );

endmodule
