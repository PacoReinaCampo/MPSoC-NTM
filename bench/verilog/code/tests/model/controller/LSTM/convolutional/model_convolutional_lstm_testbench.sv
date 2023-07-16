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

module model_convolutional_lstm_testbench;

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

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire                 CLK;
  wire                 RST;

  // CONTROLLER
  // CONTROL
  wire                 start_controller;
  wire                 ready_controller;

  wire                 w_in_l_enable_controller;
  wire                 w_in_x_enable_controller;

  wire                 k_in_i_enable_controller;
  wire                 k_in_l_enable_controller;
  wire                 k_in_k_enable_controller;

  wire                 u_in_l_enable_controller;
  wire                 u_in_p_enable_controller;

  wire                 b_in_enable_controller;

  wire                 x_in_enable_controller;

  wire                 x_out_enable_controller;

  wire                 r_in_i_enable_controller;
  wire                 r_in_k_enable_controller;

  wire                 r_out_i_enable_controller;
  wire                 r_out_k_enable_controller;

  wire                 h_in_enable_controller;

  wire                 w_out_l_enable_controller;
  wire                 w_out_x_enable_controller;

  wire                 k_out_i_enable_controller;
  wire                 k_out_l_enable_controller;
  wire                 k_out_k_enable_controller;

  wire                 u_out_l_enable_controller;
  wire                 u_out_p_enable_controller;

  wire                 b_out_enable_controller;

  wire                 h_out_enable_controller;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_controller;
  wire [DATA_SIZE-1:0] size_w_in_controller;
  wire [DATA_SIZE-1:0] size_l_in_controller;
  wire [DATA_SIZE-1:0] size_r_in_controller;

  wire [DATA_SIZE-1:0] w_in_controller;
  wire [DATA_SIZE-1:0] k_in_controller;
  wire [DATA_SIZE-1:0] u_in_controller;
  wire [DATA_SIZE-1:0] b_in_controller;

  wire [DATA_SIZE-1:0] x_in_controller;
  wire [DATA_SIZE-1:0] r_in_controller;
  wire [DATA_SIZE-1:0] h_in_controller;

  wire [DATA_SIZE-1:0] w_out_controller;
  wire [DATA_SIZE-1:0] k_out_controller;
  wire [DATA_SIZE-1:0] u_out_controller;
  wire [DATA_SIZE-1:0] b_out_controller;

  wire [DATA_SIZE-1:0] h_out_controller;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // STIMULUS
  model_convolutional_lstm_stimulus #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) convolutional_lstm_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .CONVOLUTIONAL_LSTM_START(start_controller),
    .CONVOLUTIONAL_LSTM_READY(ready_controller),

    .CONVOLUTIONAL_LSTM_W_IN_L_ENABLE(w_in_l_enable_controller),
    .CONVOLUTIONAL_LSTM_W_IN_X_ENABLE(w_in_x_enable_controller),

    .CONVOLUTIONAL_LSTM_K_IN_I_ENABLE(k_in_i_enable_controller),
    .CONVOLUTIONAL_LSTM_K_IN_L_ENABLE(k_in_l_enable_controller),
    .CONVOLUTIONAL_LSTM_K_IN_K_ENABLE(k_in_k_enable_controller),

    .CONVOLUTIONAL_LSTM_U_IN_L_ENABLE(u_in_l_enable_controller),
    .CONVOLUTIONAL_LSTM_U_IN_P_ENABLE(u_in_p_enable_controller),

    .CONVOLUTIONAL_LSTM_B_IN_ENABLE(b_in_enable_controller),

    .CONVOLUTIONAL_LSTM_X_IN_ENABLE(x_in_enable_controller),

    .CONVOLUTIONAL_LSTM_X_OUT_ENABLE(x_out_enable_controller),

    .CONVOLUTIONAL_LSTM_R_IN_I_ENABLE(r_in_i_enable_controller),
    .CONVOLUTIONAL_LSTM_R_IN_K_ENABLE(r_in_k_enable_controller),

    .CONVOLUTIONAL_LSTM_R_OUT_I_ENABLE(r_out_i_enable_controller),
    .CONVOLUTIONAL_LSTM_R_OUT_K_ENABLE(r_out_k_enable_controller),

    .CONVOLUTIONAL_LSTM_H_IN_ENABLE(h_in_enable_controller),

    .CONVOLUTIONAL_LSTM_W_OUT_L_ENABLE(w_out_l_enable_controller),
    .CONVOLUTIONAL_LSTM_W_OUT_X_ENABLE(w_out_x_enable_controller),

    .CONVOLUTIONAL_LSTM_K_OUT_I_ENABLE(k_out_i_enable_controller),
    .CONVOLUTIONAL_LSTM_K_OUT_L_ENABLE(k_out_l_enable_controller),
    .CONVOLUTIONAL_LSTM_K_OUT_K_ENABLE(k_out_k_enable_controller),

    .CONVOLUTIONAL_LSTM_U_OUT_L_ENABLE(u_out_l_enable_controller),
    .CONVOLUTIONAL_LSTM_U_OUT_P_ENABLE(u_out_p_enable_controller),

    .CONVOLUTIONAL_LSTM_B_OUT_ENABLE(b_out_enable_controller),

    .CONVOLUTIONAL_LSTM_H_OUT_ENABLE(h_out_enable_controller),

    // DATA
    .CONVOLUTIONAL_LSTM_SIZE_X_IN(size_x_in_controller),
    .CONVOLUTIONAL_LSTM_SIZE_W_IN(size_w_in_controller),
    .CONVOLUTIONAL_LSTM_SIZE_L_IN(size_l_in_controller),
    .CONVOLUTIONAL_LSTM_SIZE_R_IN(size_r_in_controller),

    .CONVOLUTIONAL_LSTM_W_IN(w_in_controller),
    .CONVOLUTIONAL_LSTM_K_IN(k_in_controller),
    .CONVOLUTIONAL_LSTM_U_IN(u_in_controller),
    .CONVOLUTIONAL_LSTM_B_IN(b_in_controller),

    .CONVOLUTIONAL_LSTM_X_IN(x_in_controller),
    .CONVOLUTIONAL_LSTM_R_IN(r_in_controller),
    .CONVOLUTIONAL_LSTM_H_IN(h_in_controller),

    .CONVOLUTIONAL_LSTM_W_OUT(w_out_controller),
    .CONVOLUTIONAL_LSTM_K_OUT(k_out_controller),
    .CONVOLUTIONAL_LSTM_U_OUT(u_out_controller),
    .CONVOLUTIONAL_LSTM_B_OUT(b_out_controller),

    .CONVOLUTIONAL_LSTM_H_OUT(h_out_controller)
  );

  // CONTROLLER
  model_controller #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) model_controller_i (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_controller),
    .READY(ready_controller),

    .W_IN_L_ENABLE(w_in_l_enable_controller),
    .W_IN_X_ENABLE(w_in_x_enable_controller),

    .K_IN_I_ENABLE(k_in_i_enable_controller),
    .K_IN_L_ENABLE(k_in_l_enable_controller),
    .K_IN_K_ENABLE(k_in_k_enable_controller),

    .U_IN_L_ENABLE(u_in_l_enable_controller),
    .U_IN_P_ENABLE(u_in_p_enable_controller),

    .B_IN_ENABLE(b_in_enable_controller),

    .X_IN_ENABLE(x_in_enable_controller),

    .X_OUT_ENABLE(x_out_enable_controller),

    .R_IN_I_ENABLE(r_in_i_enable_controller),
    .R_IN_K_ENABLE(r_in_k_enable_controller),

    .R_OUT_I_ENABLE(r_out_i_enable_controller),
    .R_OUT_K_ENABLE(r_out_k_enable_controller),

    .H_IN_ENABLE(h_in_enable_controller),

    .W_OUT_L_ENABLE(w_out_l_enable_controller),
    .W_OUT_X_ENABLE(w_out_x_enable_controller),

    .K_OUT_I_ENABLE(k_out_i_enable_controller),
    .K_OUT_L_ENABLE(k_out_l_enable_controller),
    .K_OUT_K_ENABLE(k_out_k_enable_controller),

    .U_OUT_L_ENABLE(u_out_l_enable_controller),
    .U_OUT_P_ENABLE(u_out_p_enable_controller),

    .B_OUT_ENABLE(b_out_enable_controller),

    .H_OUT_ENABLE(h_out_enable_controller),

    // DATA
    .SIZE_X_IN(size_x_in_controller),
    .SIZE_W_IN(size_w_in_controller),
    .SIZE_L_IN(size_l_in_controller),
    .SIZE_R_IN(size_r_in_controller),

    .W_IN(w_in_controller),
    .K_IN(k_in_controller),
    .U_IN(u_in_controller),
    .B_IN(b_in_controller),

    .X_IN(x_in_controller),
    .R_IN(r_in_controller),
    .H_IN(h_in_controller),

    .W_OUT(w_out_controller),
    .K_OUT(k_out_controller),
    .U_OUT(u_out_controller),
    .B_OUT(b_out_controller),

    .H_OUT(h_out_controller)
  );

endmodule
