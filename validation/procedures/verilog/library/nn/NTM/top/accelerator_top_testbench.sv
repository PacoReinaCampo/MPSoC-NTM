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

module accelerator_top_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE = 64;
  parameter CONTROL_SIZE = 4;

  parameter X = 64;
  parameter Y = 64;
  parameter N = 64;
  parameter W = 64;
  parameter L = 64;
  parameter R = 64;

  // FUNCTIONALITY
  parameter STIMULUS_ACCELERATOR_TOP_TEST = 0;
  parameter STIMULUS_ACCELERATOR_TOP_CASE_0 = 0;
  parameter STIMULUS_ACCELERATOR_TOP_CASE_1 = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire                 CLK;
  wire                 RST;

  // TOP
  // CONTROL
  wire                 start_top;
  wire                 ready_top;

  wire                 w_in_l_enable_top;
  wire                 w_in_x_enable_top;

  wire                 w_out_l_enable_top;
  wire                 w_out_x_enable_top;

  wire                 k_in_i_enable_top;
  wire                 k_in_l_enable_top;
  wire                 k_in_k_enable_top;

  wire                 k_out_i_enable_top;
  wire                 k_out_l_enable_top;
  wire                 k_out_k_enable_top;

  wire                 u_in_l_enable_top;
  wire                 u_in_p_enable_top;

  wire                 u_out_l_enable_top;
  wire                 u_out_p_enable_top;

  wire                 b_in_enable_top;

  wire                 b_out_enable_top;

  wire                 x_in_enable_top;

  wire                 x_out_enable_top;

  wire                 y_out_enable_top;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_top;
  wire [DATA_SIZE-1:0] size_y_in_top;
  wire [DATA_SIZE-1:0] size_n_in_top;
  wire [DATA_SIZE-1:0] size_w_in_top;
  wire [DATA_SIZE-1:0] size_l_in_top;
  wire [DATA_SIZE-1:0] size_r_in_top;

  wire [DATA_SIZE-1:0] w_in_top;
  wire [DATA_SIZE-1:0] k_in_top;
  wire [DATA_SIZE-1:0] u_in_top;
  wire [DATA_SIZE-1:0] b_in_top;

  wire [DATA_SIZE-1:0] x_in_top;
  wire [DATA_SIZE-1:0] y_out_top;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  accelerator_top_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R),

    // FUNCTIONALITY
    .STIMULUS_ACCELERATOR_TOP_TEST  (STIMULUS_ACCELERATOR_TOP_TEST),
    .STIMULUS_ACCELERATOR_TOP_CASE_0(STIMULUS_ACCELERATOR_TOP_CASE_0),
    .STIMULUS_ACCELERATOR_TOP_CASE_1(STIMULUS_ACCELERATOR_TOP_CASE_1)
  ) top_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .ACCELERATOR_TOP_START(start_top),
    .ACCELERATOR_TOP_READY(ready_top),

    .ACCELERATOR_TOP_W_IN_L_ENABLE(w_in_l_enable_top),
    .ACCELERATOR_TOP_W_IN_X_ENABLE(w_in_x_enable_top),

    .ACCELERATOR_TOP_W_OUT_L_ENABLE(w_out_l_enable_top),
    .ACCELERATOR_TOP_W_OUT_X_ENABLE(w_out_x_enable_top),

    .ACCELERATOR_TOP_K_IN_I_ENABLE(k_in_i_enable_top),
    .ACCELERATOR_TOP_K_IN_L_ENABLE(k_in_l_enable_top),
    .ACCELERATOR_TOP_K_IN_K_ENABLE(k_in_k_enable_top),

    .ACCELERATOR_TOP_K_OUT_I_ENABLE(k_out_i_enable_top),
    .ACCELERATOR_TOP_K_OUT_L_ENABLE(k_out_l_enable_top),
    .ACCELERATOR_TOP_K_OUT_K_ENABLE(k_out_k_enable_top),

    .ACCELERATOR_TOP_U_IN_L_ENABLE(u_in_l_enable_top),
    .ACCELERATOR_TOP_U_IN_P_ENABLE(u_in_p_enable_top),

    .ACCELERATOR_TOP_U_OUT_L_ENABLE(u_out_l_enable_top),
    .ACCELERATOR_TOP_U_OUT_P_ENABLE(u_out_p_enable_top),

    .ACCELERATOR_TOP_B_IN_ENABLE(b_in_enable_top),

    .ACCELERATOR_TOP_B_OUT_ENABLE(b_out_enable_top),

    .ACCELERATOR_TOP_X_IN_ENABLE(x_in_enable_top),

    .ACCELERATOR_TOP_X_OUT_ENABLE(x_out_enable_top),

    .ACCELERATOR_TOP_Y_OUT_ENABLE(y_out_enable_top),

    // DATA
    .ACCELERATOR_TOP_SIZE_X_IN(size_x_in_top),
    .ACCELERATOR_TOP_SIZE_Y_IN(size_y_in_top),
    .ACCELERATOR_TOP_SIZE_N_IN(size_n_in_top),
    .ACCELERATOR_TOP_SIZE_W_IN(size_w_in_top),
    .ACCELERATOR_TOP_SIZE_L_IN(size_l_in_top),
    .ACCELERATOR_TOP_SIZE_R_IN(size_r_in_top),

    .ACCELERATOR_TOP_W_IN(w_in_top),
    .ACCELERATOR_TOP_K_IN(k_in_top),
    .ACCELERATOR_TOP_U_IN(u_in_top),
    .ACCELERATOR_TOP_B_IN(b_in_top),

    .ACCELERATOR_TOP_X_IN (x_in_top),
    .ACCELERATOR_TOP_Y_OUT(y_out_top)
  );

  // TOP
  accelerator_top #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) top (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_top),
    .READY(ready_top),

    .W_IN_L_ENABLE(w_in_l_enable_top),
    .W_IN_X_ENABLE(w_in_x_enable_top),

    .W_OUT_L_ENABLE(w_out_l_enable_top),
    .W_OUT_X_ENABLE(w_out_x_enable_top),

    .K_IN_I_ENABLE(k_in_i_enable_top),
    .K_IN_L_ENABLE(k_in_l_enable_top),
    .K_IN_K_ENABLE(k_in_k_enable_top),

    .K_OUT_I_ENABLE(k_out_i_enable_top),
    .K_OUT_L_ENABLE(k_out_l_enable_top),
    .K_OUT_K_ENABLE(k_out_k_enable_top),

    .U_IN_L_ENABLE(u_in_l_enable_top),
    .U_IN_P_ENABLE(u_in_p_enable_top),

    .U_OUT_L_ENABLE(u_out_l_enable_top),
    .U_OUT_P_ENABLE(u_out_p_enable_top),

    .B_IN_ENABLE(b_in_enable_top),

    .B_OUT_ENABLE(b_out_enable_top),

    .X_IN_ENABLE(x_in_enable_top),

    .X_OUT_ENABLE(x_out_enable_top),

    .Y_OUT_ENABLE(y_out_enable_top),

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
    .Y_OUT(y_out_top)
  );

endmodule
