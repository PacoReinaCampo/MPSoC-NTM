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

module ntm_standard_lstm_testbench;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE=512;

  parameter X=64;
  parameter Y=64;
  parameter N=64;
  parameter W=64;
  parameter L=64;
  parameter R=64;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // GLOBAL
  wire CLK;
  wire RST;

  // ACTIVATION GATE VECTOR
  // CONTROL
  wire start_activation_gate_vector;
  wire ready_activation_gate_vector;

  wire w_in_l_enable_activation_gate_vector;
  wire w_in_x_enable_activation_gate_vector;
  wire x_in_enable_activation_gate_vector;
  wire k_in_i_enable_activation_gate_vector;
  wire k_in_l_enable_activation_gate_vector;
  wire k_in_k_enable_activation_gate_vector;
  wire r_in_i_enable_activation_gate_vector;
  wire r_in_k_enable_activation_gate_vector;
  wire u_in_enable_activation_gate_vector;
  wire h_in_enable_activation_gate_vector;
  wire b_in_enable_activation_gate_vector;
  wire a_out_enable_activation_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] size_w_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] size_l_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] size_r_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] w_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] x_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] k_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] r_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] u_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] h_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] b_in_activation_gate_vector;
  wire [DATA_SIZE-1:0] a_out_activation_gate_vector;

  // ACTIVATION TRAINER
  // CONTROL
  wire start_activation_trainer;
  wire ready_activation_trainer;

  wire h_in_enable_activation_trainer;
  wire x_in_enable_activation_trainer;
  wire a_in_enable_activation_trainer;
  wire i_in_enable_activation_trainer;
  wire s_in_enable_activation_trainer;
  wire w_out_l_enable_activation_trainer;
  wire w_out_x_enable_activation_trainer;
  wire k_out_i_enable_activation_trainer;
  wire k_out_l_enable_activation_trainer;
  wire k_out_k_enable_activation_trainer;
  wire b_out_enable_activation_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_activation_trainer;
  wire [DATA_SIZE-1:0] size_w_in_activation_trainer;
  wire [DATA_SIZE-1:0] size_l_in_activation_trainer;
  wire [DATA_SIZE-1:0] size_r_in_activation_trainer;
  wire [DATA_SIZE-1:0] h_in_activation_trainer;
  wire [DATA_SIZE-1:0] x_in_activation_trainer;
  wire [DATA_SIZE-1:0] a_in_activation_trainer;
  wire [DATA_SIZE-1:0] i_in_activation_trainer;
  wire [DATA_SIZE-1:0] s_in_activation_trainer;
  wire [DATA_SIZE-1:0] w_out_activation_trainer;
  wire [DATA_SIZE-1:0] k_out_activation_trainer;
  wire [DATA_SIZE-1:0] b_out_activation_trainer;

  // INTPUT GATE VECTOR
  // CONTROL
  wire start_input_gate_vector;
  wire ready_input_gate_vector;

  wire w_in_l_enable_input_gate_vector;
  wire w_in_x_enable_input_gate_vector;
  wire x_in_enable_input_gate_vector;
  wire k_in_i_enable_input_gate_vector;
  wire k_in_l_enable_input_gate_vector;
  wire k_in_k_enable_input_gate_vector;
  wire r_in_i_enable_input_gate_vector;
  wire r_in_k_enable_input_gate_vector;
  wire u_in_enable_input_gate_vector;
  wire h_in_enable_input_gate_vector;
  wire b_in_enable_input_gate_vector;
  wire i_out_enable_input_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_input_gate_vector;
  wire [DATA_SIZE-1:0] size_w_in_input_gate_vector;
  wire [DATA_SIZE-1:0] size_l_in_input_gate_vector;
  wire [DATA_SIZE-1:0] size_r_in_input_gate_vector;
  wire [DATA_SIZE-1:0] w_in_input_gate_vector;
  wire [DATA_SIZE-1:0] x_in_input_gate_vector;
  wire [DATA_SIZE-1:0] k_in_input_gate_vector;
  wire [DATA_SIZE-1:0] r_in_input_gate_vector;
  wire [DATA_SIZE-1:0] u_in_input_gate_vector;
  wire [DATA_SIZE-1:0] h_in_input_gate_vector;
  wire [DATA_SIZE-1:0] b_in_input_gate_vector;
  wire i_out_input_gate_vector;

  // INPUT TRAINER
  // CONTROL
  wire start_input_trainer;
  wire ready_input_trainer;

  wire h_in_enable_input_trainer;
  wire x_in_enable_input_trainer;
  wire a_in_enable_input_trainer;
  wire i_in_enable_input_trainer;
  wire s_in_enable_input_trainer;
  wire w_out_l_enable_input_trainer;
  wire w_out_x_enable_input_trainer;
  wire k_out_i_enable_input_trainer;
  wire k_out_l_enable_input_trainer;
  wire k_out_k_enable_input_trainer;
  wire b_out_enable_input_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_input_trainer;
  wire [DATA_SIZE-1:0] size_w_in_input_trainer;
  wire [DATA_SIZE-1:0] size_l_in_input_trainer;
  wire [DATA_SIZE-1:0] size_r_in_input_trainer;
  wire [DATA_SIZE-1:0] h_in_input_trainer;
  wire [DATA_SIZE-1:0] x_in_input_trainer;
  wire [DATA_SIZE-1:0] a_in_input_trainer;
  wire [DATA_SIZE-1:0] i_in_input_trainer;
  wire [DATA_SIZE-1:0] s_in_input_trainer;
  wire [DATA_SIZE-1:0] w_out_input_trainer;
  wire [DATA_SIZE-1:0] k_out_input_trainer;
  wire [DATA_SIZE-1:0] b_out_input_trainer;

  // OUTPUT GATE VECTOR
  // CONTROL
  wire start_output_gate_vector;
  wire ready_output_gate_vector;

  wire w_in_l_enable_output_gate_vector;
  wire w_in_x_enable_output_gate_vector;
  wire x_in_enable_output_gate_vector;
  wire k_in_i_enable_output_gate_vector;
  wire k_in_l_enable_output_gate_vector;
  wire k_in_k_enable_output_gate_vector;
  wire r_in_i_enable_output_gate_vector;
  wire r_in_k_enable_output_gate_vector;
  wire u_in_enable_output_gate_vector;
  wire h_in_enable_output_gate_vector;
  wire b_in_enable_output_gate_vector;
  wire o_out_enable_output_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_output_gate_vector;
  wire [DATA_SIZE-1:0] size_w_in_output_gate_vector;
  wire [DATA_SIZE-1:0] size_l_in_output_gate_vector;
  wire [DATA_SIZE-1:0] size_r_in_output_gate_vector;
  wire [DATA_SIZE-1:0] w_in_output_gate_vector;
  wire [DATA_SIZE-1:0] x_in_output_gate_vector;
  wire [DATA_SIZE-1:0] k_in_output_gate_vector;
  wire [DATA_SIZE-1:0] r_in_output_gate_vector;
  wire [DATA_SIZE-1:0] u_in_output_gate_vector;
  wire [DATA_SIZE-1:0] h_in_output_gate_vector;
  wire [DATA_SIZE-1:0] b_in_output_gate_vector;
  wire o_out_output_gate_vector;

  // OUTPUT TRAINER
  // CONTROL
  wire start_output_trainer;
  wire ready_output_trainer;

  wire h_in_enable_output_trainer;
  wire x_in_enable_output_trainer;
  wire a_in_enable_output_trainer;
  wire o_in_enable_output_trainer;
  wire w_out_l_enable_output_trainer;
  wire w_out_x_enable_output_trainer;
  wire k_out_i_enable_output_trainer;
  wire k_out_l_enable_output_trainer;
  wire k_out_k_enable_output_trainer;
  wire b_out_enable_output_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_output_trainer;
  wire [DATA_SIZE-1:0] size_w_in_output_trainer;
  wire [DATA_SIZE-1:0] size_l_in_output_trainer;
  wire [DATA_SIZE-1:0] size_r_in_output_trainer;
  wire [DATA_SIZE-1:0] h_in_output_trainer;
  wire [DATA_SIZE-1:0] x_in_output_trainer;
  wire [DATA_SIZE-1:0] a_in_output_trainer;
  wire [DATA_SIZE-1:0] o_in_output_trainer;
  wire [DATA_SIZE-1:0] w_out_output_trainer;
  wire [DATA_SIZE-1:0] k_out_output_trainer;
  wire [DATA_SIZE-1:0] b_out_output_trainer;

  // FORGET GATE VECTOR
  // CONTROL
  wire start_forget_gate_vector;
  wire ready_forget_gate_vector;

  wire w_in_l_enable_forget_gate_vector;
  wire w_in_x_enable_forget_gate_vector;
  wire x_in_enable_forget_gate_vector;
  wire k_in_i_enable_forget_gate_vector;
  wire k_in_l_enable_forget_gate_vector;
  wire k_in_k_enable_forget_gate_vector;
  wire r_in_i_enable_forget_gate_vector;
  wire r_in_k_enable_forget_gate_vector;
  wire u_in_enable_forget_gate_vector;
  wire h_in_enable_forget_gate_vector;
  wire b_in_enable_forget_gate_vector;
  wire f_out_enable_forget_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] size_w_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] size_l_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] size_r_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] w_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] x_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] k_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] r_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] u_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] h_in_forget_gate_vector;
  wire [DATA_SIZE-1:0] b_in_forget_gate_vector;
  wire f_out_forget_gate_vector;

  // FORGET TRAINER
  // CONTROL
  wire start_forget_trainer;
  wire ready_forget_trainer;

  wire h_in_enable_forget_trainer;
  wire x_in_enable_forget_trainer;
  wire f_in_enable_forget_trainer;
  wire s_in_enable_forget_trainer;
  wire w_out_l_enable_forget_trainer;
  wire w_out_x_enable_forget_trainer;
  wire k_out_i_enable_forget_trainer;
  wire k_out_l_enable_forget_trainer;
  wire k_out_k_enable_forget_trainer;
  wire b_out_enable_forget_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_forget_trainer;
  wire [DATA_SIZE-1:0] size_w_in_forget_trainer;
  wire [DATA_SIZE-1:0] size_l_in_forget_trainer;
  wire [DATA_SIZE-1:0] size_r_in_forget_trainer;
  wire [DATA_SIZE-1:0] h_in_forget_trainer;
  wire [DATA_SIZE-1:0] x_in_forget_trainer;
  wire [DATA_SIZE-1:0] f_in_forget_trainer;
  wire [DATA_SIZE-1:0] s_in_forget_trainer;
  wire [DATA_SIZE-1:0] w_out_forget_trainer;
  wire [DATA_SIZE-1:0] k_out_forget_trainer;
  wire [DATA_SIZE-1:0] b_out_forget_trainer;

  // STATE GATE VECTOR
  // CONTROL
  wire start_state_gate_vector;
  wire ready_state_gate_vector;

  wire s_in_enable_state_gate_vector;
  wire i_in_enable_state_gate_vector;
  wire f_in_enable_state_gate_vector;
  wire a_in_enable_state_gate_vector;
  wire s_out_enable_state_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_l_in_state_gate_vector;
  wire [DATA_SIZE-1:0] s_in_state_gate_vector;
  wire [DATA_SIZE-1:0] i_in_state_gate_vector;
  wire [DATA_SIZE-1:0] f_in_state_gate_vector;
  wire [DATA_SIZE-1:0] a_in_state_gate_vector;
  wire [DATA_SIZE-1:0] s_out_state_gate_vector;

  // HIDDEN GATE VECTOR
  // CONTROL
  wire start_hidden_gate_vector;
  wire ready_hidden_gate_vector;

  wire s_in_enable_hidden_gate_vector;
  wire o_in_enable_hidden_gate_vector;
  wire h_out_enable_hidden_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_l_in_hidden_gate_vector;
  wire [DATA_SIZE-1:0] s_in_hidden_gate_vector;
  wire [DATA_SIZE-1:0] o_in_hidden_gate_vector;
  wire [DATA_SIZE-1:0] h_out_hidden_gate_vector;

  // CONTROLLER
  // CONTROL
  wire start_controller;
  wire ready_controller;

  wire w_in_l_enable_controller;
  wire w_in_x_enable_controller;
  wire k_in_i_enable_controller;
  wire k_in_l_enable_controller;
  wire k_in_k_enable_controller;
  wire b_in_enable_controller;
  wire x_in_enable_controller;
  wire r_in_i_enable_controller;
  wire r_in_k_enable_controller;
  wire h_out_enable_controller;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_controller;
  wire [DATA_SIZE-1:0] size_w_in_controller;
  wire [DATA_SIZE-1:0] size_l_in_controller;
  wire [DATA_SIZE-1:0] size_r_in_controller;
  wire [DATA_SIZE-1:0] w_in_controller;
  wire [DATA_SIZE-1:0] k_in_controller;
  wire [DATA_SIZE-1:0] b_in_controller;
  wire [DATA_SIZE-1:0] x_in_controller;
  wire [DATA_SIZE-1:0] r_in_controller;
  wire [DATA_SIZE-1:0] h_out_controller;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // STIMULUS
  ntm_standard_lstm_stimulus #(
    .DATA_SIZE(DATA_SIZE)
  )
  standard_lstm_stimulus(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .NTM_STANDARD_LSTM_START(start_controller),
    .NTM_STANDARD_LSTM_READY(ready_controller),

    .NTM_STANDARD_LSTM_W_IN_L_ENABLE(w_in_l_enable_controller),
    .NTM_STANDARD_LSTM_W_IN_X_ENABLE(w_in_x_enable_controller),
    .NTM_STANDARD_LSTM_K_IN_I_ENABLE(k_in_i_enable_controller),
    .NTM_STANDARD_LSTM_K_IN_L_ENABLE(k_in_l_enable_controller),
    .NTM_STANDARD_LSTM_K_IN_K_ENABLE(k_in_k_enable_controller),
    .NTM_STANDARD_LSTM_B_IN_ENABLE(b_in_enable_controller),
    .NTM_STANDARD_LSTM_X_IN_ENABLE(x_in_enable_controller),
    .NTM_STANDARD_LSTM_R_IN_I_ENABLE(r_in_i_enable_controller),
    .NTM_STANDARD_LSTM_R_IN_K_ENABLE(r_in_k_enable_controller),
    .NTM_STANDARD_LSTM_H_OUT_ENABLE(h_out_enable_controller),

    // DATA
    .NTM_STANDARD_LSTM_SIZE_X_IN(size_x_in_controller),
    .NTM_STANDARD_LSTM_SIZE_W_IN(size_w_in_controller),
    .NTM_STANDARD_LSTM_SIZE_L_IN(size_l_in_controller),
    .NTM_STANDARD_LSTM_SIZE_R_IN(size_r_in_controller),
    .NTM_STANDARD_LSTM_W_IN(w_in_controller),
    .NTM_STANDARD_LSTM_K_IN(k_in_controller),
    .NTM_STANDARD_LSTM_B_IN(b_in_controller),
    .NTM_STANDARD_LSTM_X_IN(x_in_controller),
    .NTM_STANDARD_LSTM_R_IN(r_in_controller),
    .NTM_STANDARD_LSTM_H_OUT(h_out_controller)
  );

  // ACTIVATION GATE VECTOR
  ntm_activation_gate_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  activation_gate_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_activation_gate_vector),
    .READY(ready_activation_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_activation_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_activation_gate_vector),
    .X_IN_ENABLE(x_in_enable_activation_gate_vector),
    .K_IN_I_ENABLE(k_in_i_enable_activation_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_activation_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_activation_gate_vector),
    .R_IN_I_ENABLE(r_in_i_enable_activation_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_activation_gate_vector),
    .U_IN_ENABLE(u_in_enable_activation_gate_vector),
    .H_IN_ENABLE(h_in_enable_activation_gate_vector),
    .B_IN_ENABLE(b_in_enable_activation_gate_vector),
    .A_OUT_ENABLE(a_out_enable_activation_gate_vector),

    // DATA
    .SIZE_X_IN(size_x_in_activation_gate_vector),
    .SIZE_W_IN(size_w_in_activation_gate_vector),
    .SIZE_L_IN(size_l_in_activation_gate_vector),
    .SIZE_R_IN(size_r_in_activation_gate_vector),
    .W_IN(w_in_activation_gate_vector),
    .X_IN(x_in_activation_gate_vector),
    .K_IN(k_in_activation_gate_vector),
    .R_IN(r_in_activation_gate_vector),
    .U_IN(u_in_activation_gate_vector),
    .H_IN(h_in_activation_gate_vector),
    .B_IN(b_in_activation_gate_vector),
    .A_OUT(a_out_activation_gate_vector)
  );

  // ACTIVATION TRAINER
  ntm_activation_trainer #(
    .DATA_SIZE(DATA_SIZE)
  )
  activation_trainer(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_activation_trainer),
    .READY(ready_activation_trainer),

    .H_IN_ENABLE(h_in_enable_activation_trainer),
    .X_IN_ENABLE(x_in_enable_activation_trainer),
    .A_IN_ENABLE(a_in_enable_activation_trainer),
    .I_IN_ENABLE(i_in_enable_activation_trainer),
    .S_IN_ENABLE(s_in_enable_activation_trainer),
    .W_OUT_L_ENABLE(w_out_l_enable_activation_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_activation_trainer),
    .K_OUT_I_ENABLE(k_out_i_enable_activation_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_activation_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_activation_trainer),
    .B_OUT_ENABLE(b_out_enable_activation_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_activation_trainer),
    .SIZE_W_IN(size_w_in_activation_trainer),
    .SIZE_L_IN(size_l_in_activation_trainer),
    .SIZE_R_IN(size_r_in_activation_trainer),
    .H_IN(h_in_activation_trainer),
    .X_IN(x_in_activation_trainer),
    .A_IN(a_in_activation_trainer),
    .I_IN(i_in_activation_trainer),
    .S_IN(s_in_activation_trainer),
    .W_OUT(w_out_activation_trainer),
    .K_OUT(k_out_activation_trainer),
    .B_OUT(b_out_activation_trainer)
  );

  // INTPUT GATE VECTOR
  ntm_input_gate_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  input_gate_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_input_gate_vector),
    .READY(ready_input_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_input_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_input_gate_vector),
    .X_IN_ENABLE(x_in_enable_input_gate_vector),
    .K_IN_I_ENABLE(k_in_i_enable_input_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_input_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_input_gate_vector),
    .R_IN_I_ENABLE(r_in_i_enable_input_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_input_gate_vector),
    .U_IN_ENABLE(u_in_enable_input_gate_vector),
    .H_IN_ENABLE(h_in_enable_input_gate_vector),
    .B_IN_ENABLE(b_in_enable_input_gate_vector),
    .I_OUT_ENABLE(i_out_enable_input_gate_vector),

    // DATA
    .SIZE_X_IN(size_x_in_input_gate_vector),
    .SIZE_W_IN(size_w_in_input_gate_vector),
    .SIZE_L_IN(size_l_in_input_gate_vector),
    .SIZE_R_IN(size_r_in_input_gate_vector),
    .W_IN(w_in_input_gate_vector),
    .X_IN(x_in_input_gate_vector),
    .K_IN(k_in_input_gate_vector),
    .R_IN(r_in_input_gate_vector),
    .U_IN(u_in_input_gate_vector),
    .H_IN(h_in_input_gate_vector),
    .B_IN(b_in_input_gate_vector),
    .I_OUT(i_out_input_gate_vector)
  );

  // INPUT TRAINER
  ntm_input_trainer #(
    .DATA_SIZE(DATA_SIZE)
  )
  input_trainer(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_input_trainer),
    .READY(ready_input_trainer),

    .H_IN_ENABLE(h_in_enable_input_trainer),
    .X_IN_ENABLE(x_in_enable_input_trainer),
    .A_IN_ENABLE(a_in_enable_input_trainer),
    .I_IN_ENABLE(i_in_enable_input_trainer),
    .S_IN_ENABLE(s_in_enable_input_trainer),
    .W_OUT_L_ENABLE(w_out_l_enable_input_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_input_trainer),
    .K_OUT_I_ENABLE(k_out_i_enable_input_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_input_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_input_trainer),
    .B_OUT_ENABLE(b_out_enable_input_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_input_trainer),
    .SIZE_W_IN(size_w_in_input_trainer),
    .SIZE_L_IN(size_l_in_input_trainer),
    .SIZE_R_IN(size_r_in_input_trainer),
    .H_IN(h_in_input_trainer),
    .X_IN(x_in_input_trainer),
    .A_IN(a_in_input_trainer),
    .I_IN(i_in_input_trainer),
    .S_IN(s_in_input_trainer),
    .W_OUT(w_out_input_trainer),
    .K_OUT(k_out_input_trainer),
    .B_OUT(b_out_input_trainer)
  );

  // OUTPUT GATE VECTOR
  ntm_output_gate_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  output_gate_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_output_gate_vector),
    .READY(ready_output_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_output_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_output_gate_vector),
    .X_IN_ENABLE(x_in_enable_output_gate_vector),
    .K_IN_I_ENABLE(k_in_i_enable_output_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_output_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_output_gate_vector),
    .R_IN_I_ENABLE(r_in_i_enable_output_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_output_gate_vector),
    .U_IN_ENABLE(u_in_enable_output_gate_vector),
    .H_IN_ENABLE(h_in_enable_output_gate_vector),
    .B_IN_ENABLE(b_in_enable_output_gate_vector),
    .O_OUT_ENABLE(o_out_enable_output_gate_vector),

    // DATA
    .SIZE_X_IN(size_x_in_output_gate_vector),
    .SIZE_W_IN(size_w_in_output_gate_vector),
    .SIZE_L_IN(size_l_in_output_gate_vector),
    .SIZE_R_IN(size_r_in_output_gate_vector),
    .W_IN(w_in_output_gate_vector),
    .X_IN(x_in_output_gate_vector),
    .K_IN(k_in_output_gate_vector),
    .R_IN(r_in_output_gate_vector),
    .U_IN(u_in_output_gate_vector),
    .H_IN(h_in_output_gate_vector),
    .B_IN(b_in_output_gate_vector),
    .O_OUT(o_out_output_gate_vector)
  );

  // OUTPUT TRAINER
  ntm_output_trainer #(
    .DATA_SIZE(DATA_SIZE)
  )
  output_trainer(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_output_trainer),
    .READY(ready_output_trainer),

    .H_IN_ENABLE(h_in_enable_output_trainer),
    .X_IN_ENABLE(x_in_enable_output_trainer),
    .A_IN_ENABLE(a_in_enable_output_trainer),
    .O_IN_ENABLE(o_in_enable_output_trainer),
    .W_OUT_L_ENABLE(w_out_l_enable_output_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_output_trainer),
    .K_OUT_I_ENABLE(k_out_i_enable_output_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_output_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_output_trainer),
    .B_OUT_ENABLE(b_out_enable_output_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_output_trainer),
    .SIZE_W_IN(size_w_in_output_trainer),
    .SIZE_L_IN(size_l_in_output_trainer),
    .SIZE_R_IN(size_r_in_output_trainer),
    .H_IN(h_in_output_trainer),
    .X_IN(x_in_output_trainer),
    .A_IN(a_in_output_trainer),
    .O_IN(o_in_output_trainer),
    .W_OUT(w_out_output_trainer),
    .K_OUT(k_out_output_trainer),
    .B_OUT(b_out_output_trainer)
  );

  // FORGET GATE VECTOR
  ntm_forget_gate_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  forget_gate_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_forget_gate_vector),
    .READY(ready_forget_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_forget_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_forget_gate_vector),
    .X_IN_ENABLE(x_in_enable_forget_gate_vector),
    .K_IN_I_ENABLE(k_in_i_enable_forget_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_forget_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_forget_gate_vector),
    .R_IN_I_ENABLE(r_in_i_enable_forget_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_forget_gate_vector),
    .U_IN_ENABLE(u_in_enable_forget_gate_vector),
    .H_IN_ENABLE(h_in_enable_forget_gate_vector),
    .B_IN_ENABLE(b_in_enable_forget_gate_vector),
    .F_OUT_ENABLE(f_out_enable_forget_gate_vector),

    // DATA
    .SIZE_X_IN(size_x_in_forget_gate_vector),
    .SIZE_W_IN(size_w_in_forget_gate_vector),
    .SIZE_L_IN(size_l_in_forget_gate_vector),
    .SIZE_R_IN(size_r_in_forget_gate_vector),
    .W_IN(w_in_forget_gate_vector),
    .X_IN(x_in_forget_gate_vector),
    .K_IN(k_in_forget_gate_vector),
    .R_IN(r_in_forget_gate_vector),
    .U_IN(u_in_forget_gate_vector),
    .H_IN(h_in_forget_gate_vector),
    .B_IN(b_in_forget_gate_vector),
    .F_OUT(f_out_forget_gate_vector)
  );

  // FORGET TRAINER
  ntm_forget_trainer #(
    .DATA_SIZE(DATA_SIZE)
  )
  forget_trainer(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_forget_trainer),
    .READY(ready_forget_trainer),

    .H_IN_ENABLE(h_in_enable_forget_trainer),
    .X_IN_ENABLE(x_in_enable_forget_trainer),
    .F_IN_ENABLE(f_in_enable_forget_trainer),
    .S_IN_ENABLE(s_in_enable_forget_trainer),
    .W_OUT_L_ENABLE(w_out_l_enable_forget_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_forget_trainer),
    .K_OUT_I_ENABLE(k_out_i_enable_forget_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_forget_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_forget_trainer),
    .B_OUT_ENABLE(b_out_enable_forget_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_forget_trainer),
    .SIZE_W_IN(size_w_in_forget_trainer),
    .SIZE_L_IN(size_l_in_forget_trainer),
    .SIZE_R_IN(size_r_in_forget_trainer),
    .H_IN(h_in_forget_trainer),
    .X_IN(x_in_forget_trainer),
    .F_IN(f_in_forget_trainer),
    .S_IN(s_in_forget_trainer),
    .W_OUT(w_out_forget_trainer),
    .K_OUT(k_out_forget_trainer),
    .B_OUT(b_out_forget_trainer)
  );

  // STATE GATE VECTOR
  ntm_state_gate_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  state_gate_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_state_gate_vector),
    .READY(ready_state_gate_vector),

    .S_IN_ENABLE(s_in_enable_state_gate_vector),
    .I_IN_ENABLE(i_in_enable_state_gate_vector),
    .F_IN_ENABLE(f_in_enable_state_gate_vector),
    .A_IN_ENABLE(a_in_enable_state_gate_vector),
    .S_OUT_ENABLE(s_out_enable_state_gate_vector),

    // DATA
    .SIZE_L_IN(size_l_in_state_gate_vector),
    .S_IN(s_in_state_gate_vector),
    .I_IN(i_in_state_gate_vector),
    .F_IN(f_in_state_gate_vector),
    .A_IN(a_in_state_gate_vector),
    .S_OUT(s_out_state_gate_vector)
  );

  // HIDDEN GATE VECTOR
  ntm_hidden_gate_vector #(
    .DATA_SIZE(DATA_SIZE)
  )
  hidden_gate_vector(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_hidden_gate_vector),
    .READY(ready_hidden_gate_vector),

    .S_IN_ENABLE(s_in_enable_hidden_gate_vector),
    .O_IN_ENABLE(o_in_enable_hidden_gate_vector),
    .H_OUT_ENABLE(h_out_enable_hidden_gate_vector),

    // DATA
    .SIZE_L_IN(size_l_in_hidden_gate_vector),
    .S_IN(s_in_hidden_gate_vector),
    .O_IN(o_in_hidden_gate_vector),
    .H_OUT(h_out_hidden_gate_vector)
  );

  // CONTROLLER
  ntm_controller #(
    .DATA_SIZE(DATA_SIZE)
  )
  ntm_controller_i(
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
    .B_IN_ENABLE(b_in_enable_controller),
    .X_IN_ENABLE(x_in_enable_controller),
    .R_IN_I_ENABLE(r_in_i_enable_controller),
    .R_IN_K_ENABLE(r_in_k_enable_controller),
    .H_OUT_ENABLE(h_out_enable_controller),

    // DATA
    .SIZE_X_IN(size_x_in_controller),
    .SIZE_W_IN(size_w_in_controller),
    .SIZE_L_IN(size_l_in_controller),
    .SIZE_R_IN(size_r_in_controller),
    .W_IN(w_in_controller),
    .K_IN(k_in_controller),
    .B_IN(b_in_controller),
    .X_IN(x_in_controller),
    .R_IN(r_in_controller),
    .H_OUT(h_out_controller)
  );

endmodule
