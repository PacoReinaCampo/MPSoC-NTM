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

module model_controller #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 4
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input W_IN_L_ENABLE,  // for l in 0 to L-1
  input W_IN_X_ENABLE,  // for x in 0 to X-1

  input K_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input K_IN_L_ENABLE,  // for l in 0 to L-1
  input K_IN_K_ENABLE,  // for k in 0 to W-1

  input U_IN_L_ENABLE,  // for l in 0 to L-1
  input U_IN_P_ENABLE,  // for p in 0 to L-1

  input B_IN_ENABLE,  // for l in 0 to L-1

  input X_IN_ENABLE,  // for x in 0 to X-1

  output reg X_OUT_ENABLE,  // for x in 0 to X-1

  input R_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input R_IN_K_ENABLE,  // for k in 0 to W-1

  output reg R_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg R_OUT_K_ENABLE,  // for k in 0 to W-1

  input H_IN_ENABLE,  // for l in 0 to L-1

  output reg W_OUT_L_ENABLE,  // for l in 0 to L-1
  output reg W_OUT_X_ENABLE,  // for x in 0 to X-1

  output reg K_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  output reg K_OUT_L_ENABLE,  // for l in 0 to L-1
  output reg K_OUT_K_ENABLE,  // for k in 0 to W-1

  output reg U_OUT_L_ENABLE,  // for l in 0 to L-1
  output reg U_OUT_P_ENABLE,  // for p in 0 to L-1

  output reg B_OUT_ENABLE,  // for l in 0 to L-1

  output reg H_OUT_ENABLE,  // for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_X_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,
  input [DATA_SIZE-1:0] SIZE_L_IN,
  input [DATA_SIZE-1:0] SIZE_R_IN,

  input [DATA_SIZE-1:0] W_IN,
  input [DATA_SIZE-1:0] K_IN,
  input [DATA_SIZE-1:0] U_IN,
  input [DATA_SIZE-1:0] B_IN,

  input [DATA_SIZE-1:0] X_IN,
  input [DATA_SIZE-1:0] R_IN,
  input [DATA_SIZE-1:0] H_IN,

  output reg [DATA_SIZE-1:0] W_OUT,
  output reg [DATA_SIZE-1:0] K_OUT,
  output reg [DATA_SIZE-1:0] U_OUT,
  output reg [DATA_SIZE-1:0] B_OUT,

  output reg [DATA_SIZE-1:0] H_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_ACTIVATION_STATE = 1;
  parameter [2:0] VECTOR_FORGET_STATE = 2;
  parameter [2:0] VECTOR_INPUT_STATE = 3;
  parameter [2:0] VECTOR_STATE_STATE = 4;
  parameter [2:0] VECTOR_OUTPUT_GATE = 5;
  parameter [2:0] VECTOR_HIDDEN_GATE = 6;

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  parameter ZERO_CONTROL = 0;
  parameter ONE_CONTROL = 1;
  parameter TWO_CONTROL = 2;
  parameter THREE_CONTROL = 3;

  parameter ZERO_DATA = 0;
  parameter ONE_DATA = 1;
  parameter TWO_DATA = 2;
  parameter THREE_DATA = 3;

  parameter FULL = 1;
  parameter EMPTY = 0;

  parameter EULER = 0;

  //////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg  [          2:0] controller_ctrl_fsm_int;

  // ACTIVATION GATE VECTOR
  // CONTROL
  wire                 start_activation_gate_vector;
  wire                 ready_activation_gate_vector;

  wire                 w_in_l_enable_activation_gate_vector;
  wire                 w_in_x_enable_activation_gate_vector;

  wire                 w_out_l_enable_activation_gate_vector;
  wire                 w_out_x_enable_activation_gate_vector;

  wire                 x_in_enable_activation_gate_vector;

  wire                 x_out_enable_activation_gate_vector;

  wire                 k_in_i_enable_activation_gate_vector;
  wire                 k_in_l_enable_activation_gate_vector;
  wire                 k_in_k_enable_activation_gate_vector;

  wire                 k_out_i_enable_activation_gate_vector;
  wire                 k_out_l_enable_activation_gate_vector;
  wire                 k_out_k_enable_activation_gate_vector;

  wire                 r_in_i_enable_activation_gate_vector;
  wire                 r_in_k_enable_activation_gate_vector;

  wire                 r_out_i_enable_activation_gate_vector;
  wire                 r_out_k_enable_activation_gate_vector;

  wire                 u_in_l_enable_activation_gate_vector;
  wire                 u_in_p_enable_activation_gate_vector;

  wire                 u_out_l_enable_activation_gate_vector;
  wire                 u_out_p_enable_activation_gate_vector;

  wire                 h_in_enable_activation_gate_vector;

  wire                 h_out_enable_activation_gate_vector;

  wire                 b_in_enable_activation_gate_vector;

  wire                 b_out_enable_activation_gate_vector;

  wire                 a_out_enable_activation_gate_vector;

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
  wire                 start_activation_trainer;
  wire                 ready_activation_trainer;

  wire                 x_in_enable_activation_trainer;

  wire                 x_out_enable_activation_trainer;

  wire                 r_in_i_enable_activation_trainer;
  wire                 r_in_k_enable_activation_trainer;

  wire                 r_out_i_enable_activation_trainer;
  wire                 r_out_k_enable_activation_trainer;

  wire                 h_in_enable_activation_trainer;

  wire                 h_out_enable_activation_trainer;

  wire                 a_in_enable_activation_trainer;
  wire                 i_in_enable_activation_trainer;
  wire                 s_in_enable_activation_trainer;

  wire                 a_out_enable_activation_trainer;
  wire                 i_out_enable_activation_trainer;
  wire                 s_out_enable_activation_trainer;

  wire                 w_out_l_enable_activation_trainer;
  wire                 w_out_x_enable_activation_trainer;

  wire                 k_out_i_enable_activation_trainer;
  wire                 k_out_l_enable_activation_trainer;
  wire                 k_out_k_enable_activation_trainer;

  wire                 u_out_l_enable_activation_trainer;
  wire                 u_out_p_enable_activation_trainer;

  wire                 b_out_enable_activation_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_activation_trainer;
  wire [DATA_SIZE-1:0] size_w_in_activation_trainer;
  wire [DATA_SIZE-1:0] size_l_in_activation_trainer;
  wire [DATA_SIZE-1:0] size_r_in_activation_trainer;

  wire [DATA_SIZE-1:0] x_in_activation_trainer;
  wire [DATA_SIZE-1:0] r_in_activation_trainer;
  wire [DATA_SIZE-1:0] h_in_activation_trainer;

  wire [DATA_SIZE-1:0] a_in_activation_trainer;
  wire [DATA_SIZE-1:0] i_in_activation_trainer;
  wire [DATA_SIZE-1:0] s_in_activation_trainer;

  wire [DATA_SIZE-1:0] w_out_activation_trainer;
  wire [DATA_SIZE-1:0] k_out_activation_trainer;
  wire [DATA_SIZE-1:0] u_out_activation_trainer;
  wire [DATA_SIZE-1:0] b_out_activation_trainer;

  // INTPUT GATE VECTOR
  // CONTROL
  wire                 start_input_gate_vector;
  wire                 ready_input_gate_vector;

  wire                 w_in_l_enable_input_gate_vector;
  wire                 w_in_x_enable_input_gate_vector;

  wire                 w_out_l_enable_input_gate_vector;
  wire                 w_out_x_enable_input_gate_vector;

  wire                 x_in_enable_input_gate_vector;

  wire                 x_out_enable_input_gate_vector;

  wire                 k_in_i_enable_input_gate_vector;
  wire                 k_in_l_enable_input_gate_vector;
  wire                 k_in_k_enable_input_gate_vector;

  wire                 k_out_i_enable_input_gate_vector;
  wire                 k_out_l_enable_input_gate_vector;
  wire                 k_out_k_enable_input_gate_vector;

  wire                 r_in_i_enable_input_gate_vector;
  wire                 r_in_k_enable_input_gate_vector;

  wire                 r_out_i_enable_input_gate_vector;
  wire                 r_out_k_enable_input_gate_vector;

  wire                 u_in_l_enable_input_gate_vector;
  wire                 u_in_p_enable_input_gate_vector;

  wire                 u_out_l_enable_input_gate_vector;
  wire                 u_out_p_enable_input_gate_vector;

  wire                 h_in_enable_input_gate_vector;

  wire                 h_out_enable_input_gate_vector;

  wire                 b_in_enable_input_gate_vector;

  wire                 b_out_enable_input_gate_vector;

  wire                 i_out_enable_input_gate_vector;

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

  wire [DATA_SIZE-1:0] i_out_input_gate_vector;

  // INPUT TRAINER
  // CONTROL
  wire                 start_input_trainer;
  wire                 ready_input_trainer;

  wire                 x_in_enable_input_trainer;

  wire                 x_out_enable_input_trainer;

  wire                 r_in_i_enable_input_trainer;
  wire                 r_in_k_enable_input_trainer;

  wire                 r_out_i_enable_input_trainer;
  wire                 r_out_k_enable_input_trainer;

  wire                 h_in_enable_input_trainer;

  wire                 h_out_enable_input_trainer;

  wire                 a_in_enable_input_trainer;
  wire                 i_in_enable_input_trainer;
  wire                 s_in_enable_input_trainer;

  wire                 a_out_enable_input_trainer;
  wire                 i_out_enable_input_trainer;
  wire                 s_out_enable_input_trainer;

  wire                 w_out_l_enable_input_trainer;
  wire                 w_out_x_enable_input_trainer;

  wire                 k_out_i_enable_input_trainer;
  wire                 k_out_l_enable_input_trainer;
  wire                 k_out_k_enable_input_trainer;

  wire                 u_out_l_enable_input_trainer;
  wire                 u_out_p_enable_input_trainer;

  wire                 b_out_enable_input_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_input_trainer;
  wire [DATA_SIZE-1:0] size_w_in_input_trainer;
  wire [DATA_SIZE-1:0] size_l_in_input_trainer;
  wire [DATA_SIZE-1:0] size_r_in_input_trainer;

  wire [DATA_SIZE-1:0] x_in_input_trainer;
  wire [DATA_SIZE-1:0] r_in_input_trainer;
  wire [DATA_SIZE-1:0] h_in_input_trainer;

  wire [DATA_SIZE-1:0] a_in_input_trainer;
  wire [DATA_SIZE-1:0] i_in_input_trainer;
  wire [DATA_SIZE-1:0] s_in_input_trainer;

  wire [DATA_SIZE-1:0] w_out_input_trainer;
  wire [DATA_SIZE-1:0] k_out_input_trainer;
  wire [DATA_SIZE-1:0] u_out_input_trainer;
  wire [DATA_SIZE-1:0] b_out_input_trainer;

  // OUTPUT GATE VECTOR
  // CONTROL
  wire                 start_output_gate_vector;
  wire                 ready_output_gate_vector;

  wire                 w_in_l_enable_output_gate_vector;
  wire                 w_in_x_enable_output_gate_vector;

  wire                 w_out_l_enable_output_gate_vector;
  wire                 w_out_x_enable_output_gate_vector;

  wire                 x_in_enable_output_gate_vector;

  wire                 x_out_enable_output_gate_vector;

  wire                 k_in_i_enable_output_gate_vector;
  wire                 k_in_l_enable_output_gate_vector;
  wire                 k_in_k_enable_output_gate_vector;

  wire                 k_out_i_enable_output_gate_vector;
  wire                 k_out_l_enable_output_gate_vector;
  wire                 k_out_k_enable_output_gate_vector;

  wire                 r_in_i_enable_output_gate_vector;
  wire                 r_in_k_enable_output_gate_vector;

  wire                 r_out_i_enable_output_gate_vector;
  wire                 r_out_k_enable_output_gate_vector;

  wire                 u_in_enable_output_gate_vector;

  wire                 u_out_enable_output_gate_vector;

  wire                 h_in_enable_output_gate_vector;

  wire                 h_out_enable_output_gate_vector;

  wire                 b_in_enable_output_gate_vector;

  wire                 b_out_enable_output_gate_vector;

  wire                 o_out_enable_output_gate_vector;

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

  wire [DATA_SIZE-1:0] o_out_output_gate_vector;

  // OUTPUT TRAINER
  // CONTROL
  wire                 start_output_trainer;
  wire                 ready_output_trainer;

  wire                 x_in_enable_output_trainer;

  wire                 x_out_enable_output_trainer;

  wire                 r_in_i_enable_output_trainer;
  wire                 r_in_k_enable_output_trainer;

  wire                 r_out_i_enable_output_trainer;
  wire                 r_out_k_enable_output_trainer;

  wire                 h_in_enable_output_trainer;

  wire                 h_out_enable_output_trainer;

  wire                 a_in_enable_output_trainer;
  wire                 o_in_enable_output_trainer;

  wire                 a_out_enable_output_trainer;
  wire                 o_out_enable_output_trainer;

  wire                 w_out_l_enable_output_trainer;
  wire                 w_out_x_enable_output_trainer;

  wire                 k_out_i_enable_output_trainer;
  wire                 k_out_l_enable_output_trainer;
  wire                 k_out_k_enable_output_trainer;

  wire                 u_out_l_enable_output_trainer;
  wire                 u_out_p_enable_output_trainer;

  wire                 b_out_enable_output_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_output_trainer;
  wire [DATA_SIZE-1:0] size_w_in_output_trainer;
  wire [DATA_SIZE-1:0] size_l_in_output_trainer;
  wire [DATA_SIZE-1:0] size_r_in_output_trainer;

  wire [DATA_SIZE-1:0] x_in_output_trainer;
  wire [DATA_SIZE-1:0] r_in_output_trainer;
  wire [DATA_SIZE-1:0] h_in_output_trainer;

  wire [DATA_SIZE-1:0] a_in_output_trainer;
  wire [DATA_SIZE-1:0] o_in_output_trainer;

  wire [DATA_SIZE-1:0] w_out_output_trainer;
  wire [DATA_SIZE-1:0] k_out_output_trainer;
  wire [DATA_SIZE-1:0] u_out_output_trainer;
  wire [DATA_SIZE-1:0] b_out_output_trainer;

  // FORGET GATE VECTOR
  // CONTROL
  wire                 start_forget_gate_vector;
  wire                 ready_forget_gate_vector;

  wire                 w_in_l_enable_forget_gate_vector;
  wire                 w_in_x_enable_forget_gate_vector;

  wire                 w_out_l_enable_forget_gate_vector;
  wire                 w_out_x_enable_forget_gate_vector;

  wire                 x_in_enable_forget_gate_vector;

  wire                 x_out_enable_forget_gate_vector;

  wire                 k_in_i_enable_forget_gate_vector;
  wire                 k_in_l_enable_forget_gate_vector;
  wire                 k_in_k_enable_forget_gate_vector;

  wire                 k_out_i_enable_forget_gate_vector;
  wire                 k_out_l_enable_forget_gate_vector;
  wire                 k_out_k_enable_forget_gate_vector;

  wire                 r_in_i_enable_forget_gate_vector;
  wire                 r_in_k_enable_forget_gate_vector;

  wire                 r_out_i_enable_forget_gate_vector;
  wire                 r_out_k_enable_forget_gate_vector;

  wire                 u_in_enable_forget_gate_vector;
  wire                 h_in_enable_forget_gate_vector;
  wire                 b_in_enable_forget_gate_vector;

  wire                 u_out_enable_forget_gate_vector;
  wire                 h_out_enable_forget_gate_vector;
  wire                 b_out_enable_forget_gate_vector;

  wire                 f_out_enable_forget_gate_vector;

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

  wire [DATA_SIZE-1:0] f_out_forget_gate_vector;

  // FORGET TRAINER
  // CONTROL
  wire                 start_forget_trainer;
  wire                 ready_forget_trainer;

  wire                 x_in_enable_forget_trainer;

  wire                 x_out_enable_forget_trainer;

  wire                 r_in_i_enable_forget_trainer;
  wire                 r_in_k_enable_forget_trainer;

  wire                 r_out_i_enable_forget_trainer;
  wire                 r_out_k_enable_forget_trainer;

  wire                 h_in_enable_forget_trainer;

  wire                 h_out_enable_forget_trainer;

  wire                 f_in_enable_forget_trainer;
  wire                 s_in_enable_forget_trainer;

  wire                 f_out_enable_forget_trainer;
  wire                 s_out_enable_forget_trainer;

  wire                 w_out_l_enable_forget_trainer;
  wire                 w_out_x_enable_forget_trainer;

  wire                 k_out_i_enable_forget_trainer;
  wire                 k_out_l_enable_forget_trainer;
  wire                 k_out_k_enable_forget_trainer;

  wire                 u_out_l_enable_forget_trainer;
  wire                 u_out_p_enable_forget_trainer;

  wire                 b_out_enable_forget_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_forget_trainer;
  wire [DATA_SIZE-1:0] size_w_in_forget_trainer;
  wire [DATA_SIZE-1:0] size_l_in_forget_trainer;
  wire [DATA_SIZE-1:0] size_r_in_forget_trainer;

  wire [DATA_SIZE-1:0] x_in_forget_trainer;
  wire [DATA_SIZE-1:0] r_in_forget_trainer;
  wire [DATA_SIZE-1:0] h_in_forget_trainer;

  wire [DATA_SIZE-1:0] f_in_forget_trainer;
  wire [DATA_SIZE-1:0] s_in_forget_trainer;

  wire [DATA_SIZE-1:0] w_out_forget_trainer;
  wire [DATA_SIZE-1:0] k_out_forget_trainer;
  wire [DATA_SIZE-1:0] u_out_forget_trainer;
  wire [DATA_SIZE-1:0] b_out_forget_trainer;

  // STATE GATE VECTOR
  // CONTROL
  wire                 start_state_gate_vector;
  wire                 ready_state_gate_vector;

  wire                 i_in_enable_state_gate_vector;
  wire                 f_in_enable_state_gate_vector;
  wire                 a_in_enable_state_gate_vector;

  wire                 i_out_enable_state_gate_vector;
  wire                 f_out_enable_state_gate_vector;
  wire                 a_out_enable_state_gate_vector;

  wire                 s_in_enable_state_gate_vector;

  wire                 s_out_enable_state_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_l_in_state_gate_vector;

  wire [DATA_SIZE-1:0] s_in_state_gate_vector;
  wire [DATA_SIZE-1:0] i_in_state_gate_vector;
  wire [DATA_SIZE-1:0] f_in_state_gate_vector;
  wire [DATA_SIZE-1:0] a_in_state_gate_vector;

  wire [DATA_SIZE-1:0] s_out_state_gate_vector;

  // HIDDEN GATE VECTOR
  // CONTROL
  wire                 start_hidden_gate_vector;
  wire                 ready_hidden_gate_vector;

  wire                 s_in_enable_hidden_gate_vector;
  wire                 o_in_enable_hidden_gate_vector;

  wire                 s_out_enable_hidden_gate_vector;
  wire                 o_out_enable_hidden_gate_vector;

  wire                 h_out_enable_hidden_gate_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_l_in_hidden_gate_vector;

  wire [DATA_SIZE-1:0] s_in_hidden_gate_vector;
  wire [DATA_SIZE-1:0] o_in_hidden_gate_vector;

  wire [DATA_SIZE-1:0] h_out_hidden_gate_vector;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if ((RST == 1'b0)) begin
      // Data Outputs
      H_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_ACTIVATION_STATE;
          end
        end

        VECTOR_ACTIVATION_STATE: begin  // STEP 1
        end

        VECTOR_FORGET_STATE: begin  // STEP 2
        end

        VECTOR_INPUT_STATE: begin  // STEP 3
        end

        VECTOR_STATE_STATE: begin  // STEP 4
        end

        VECTOR_OUTPUT_GATE: begin  // STEP 5
        end

        VECTOR_HIDDEN_GATE: begin  // STEP 6
        end
        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // ACTIVATION GATE VECTOR
  model_activation_gate_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) activation_gate_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_activation_gate_vector),
    .READY(ready_activation_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_activation_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_activation_gate_vector),

    .W_OUT_L_ENABLE(w_out_l_enable_activation_gate_vector),
    .W_OUT_X_ENABLE(w_out_x_enable_activation_gate_vector),

    .X_IN_ENABLE(x_in_enable_activation_gate_vector),

    .X_OUT_ENABLE(x_out_enable_activation_gate_vector),

    .K_IN_I_ENABLE(k_in_i_enable_activation_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_activation_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_activation_gate_vector),

    .K_OUT_I_ENABLE(k_out_i_enable_activation_gate_vector),
    .K_OUT_L_ENABLE(k_out_l_enable_activation_gate_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_activation_gate_vector),

    .R_IN_I_ENABLE(r_in_i_enable_activation_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_activation_gate_vector),

    .R_OUT_I_ENABLE(r_out_i_enable_activation_gate_vector),
    .R_OUT_K_ENABLE(r_out_k_enable_activation_gate_vector),

    .U_IN_L_ENABLE(u_in_l_enable_activation_gate_vector),
    .U_IN_P_ENABLE(u_in_p_enable_activation_gate_vector),

    .U_OUT_L_ENABLE(u_out_l_enable_activation_gate_vector),
    .U_OUT_P_ENABLE(u_out_p_enable_activation_gate_vector),

    .H_IN_ENABLE(h_in_enable_activation_gate_vector),

    .H_OUT_ENABLE(h_out_enable_activation_gate_vector),

    .B_IN_ENABLE(b_in_enable_activation_gate_vector),

    .B_OUT_ENABLE(b_out_enable_activation_gate_vector),

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
  model_activation_trainer #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) activation_trainer (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_activation_trainer),
    .READY(ready_activation_trainer),

    .X_IN_ENABLE(x_in_enable_activation_trainer),

    .X_OUT_ENABLE(x_out_enable_activation_trainer),

    .R_IN_I_ENABLE(r_in_i_enable_activation_trainer),
    .R_IN_K_ENABLE(r_in_k_enable_activation_trainer),

    .R_OUT_I_ENABLE(r_out_i_enable_activation_trainer),
    .R_OUT_K_ENABLE(r_out_k_enable_activation_trainer),

    .H_IN_ENABLE(h_in_enable_activation_trainer),

    .H_OUT_ENABLE(h_out_enable_activation_trainer),

    .A_IN_ENABLE(a_in_enable_activation_trainer),
    .I_IN_ENABLE(i_in_enable_activation_trainer),
    .S_IN_ENABLE(s_in_enable_activation_trainer),

    .A_OUT_ENABLE(a_out_enable_activation_trainer),
    .I_OUT_ENABLE(i_out_enable_activation_trainer),
    .S_OUT_ENABLE(s_out_enable_activation_trainer),

    .W_OUT_L_ENABLE(w_out_l_enable_activation_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_activation_trainer),

    .K_OUT_I_ENABLE(k_out_i_enable_activation_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_activation_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_activation_trainer),

    .U_OUT_L_ENABLE(u_out_l_enable_activation_trainer),
    .U_OUT_P_ENABLE(u_out_p_enable_activation_trainer),

    .B_OUT_ENABLE(b_out_enable_activation_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_activation_trainer),
    .SIZE_W_IN(size_w_in_activation_trainer),
    .SIZE_L_IN(size_l_in_activation_trainer),
    .SIZE_R_IN(size_r_in_activation_trainer),

    .X_IN(x_in_activation_trainer),
    .R_IN(r_in_activation_trainer),
    .H_IN(h_in_activation_trainer),

    .A_IN(a_in_activation_trainer),
    .I_IN(i_in_activation_trainer),
    .S_IN(s_in_activation_trainer),

    .W_OUT(w_out_activation_trainer),
    .K_OUT(k_out_activation_trainer),
    .U_OUT(u_out_activation_trainer),
    .B_OUT(b_out_activation_trainer)
  );

  // INTPUT GATE VECTOR
  model_input_gate_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) input_gate_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_input_gate_vector),
    .READY(ready_input_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_input_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_input_gate_vector),

    .W_OUT_L_ENABLE(w_out_l_enable_input_gate_vector),
    .W_OUT_X_ENABLE(w_out_x_enable_input_gate_vector),

    .X_IN_ENABLE(x_in_enable_input_gate_vector),

    .X_OUT_ENABLE(x_out_enable_input_gate_vector),

    .K_IN_I_ENABLE(k_in_i_enable_input_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_input_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_input_gate_vector),

    .K_OUT_I_ENABLE(k_out_i_enable_input_gate_vector),
    .K_OUT_L_ENABLE(k_out_l_enable_input_gate_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_input_gate_vector),

    .R_IN_I_ENABLE(r_in_i_enable_input_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_input_gate_vector),

    .R_OUT_I_ENABLE(r_out_i_enable_input_gate_vector),
    .R_OUT_K_ENABLE(r_out_k_enable_input_gate_vector),

    .U_IN_L_ENABLE(u_in_l_enable_input_gate_vector),
    .U_IN_P_ENABLE(u_in_p_enable_input_gate_vector),

    .U_OUT_L_ENABLE(u_out_l_enable_input_gate_vector),
    .U_OUT_P_ENABLE(u_out_p_enable_input_gate_vector),

    .H_IN_ENABLE(h_in_enable_input_gate_vector),

    .H_OUT_ENABLE(h_out_enable_input_gate_vector),

    .B_IN_ENABLE(b_in_enable_input_gate_vector),

    .B_OUT_ENABLE(b_out_enable_input_gate_vector),

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
  model_input_trainer #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) input_trainer (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_input_trainer),
    .READY(ready_input_trainer),

    .X_IN_ENABLE(x_in_enable_input_trainer),

    .X_OUT_ENABLE(x_out_enable_input_trainer),

    .R_IN_I_ENABLE(r_in_i_enable_input_trainer),
    .R_IN_K_ENABLE(r_in_k_enable_input_trainer),

    .R_OUT_I_ENABLE(r_out_i_enable_input_trainer),
    .R_OUT_K_ENABLE(r_out_k_enable_input_trainer),

    .H_IN_ENABLE(h_in_enable_input_trainer),

    .H_OUT_ENABLE(h_out_enable_input_trainer),

    .A_IN_ENABLE(a_in_enable_input_trainer),
    .I_IN_ENABLE(i_in_enable_input_trainer),
    .S_IN_ENABLE(s_in_enable_input_trainer),

    .A_OUT_ENABLE(a_out_enable_input_trainer),
    .I_OUT_ENABLE(i_out_enable_input_trainer),
    .S_OUT_ENABLE(s_out_enable_input_trainer),

    .W_OUT_L_ENABLE(w_out_l_enable_input_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_input_trainer),

    .K_OUT_I_ENABLE(k_out_i_enable_input_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_input_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_input_trainer),

    .U_OUT_L_ENABLE(u_out_l_enable_input_trainer),
    .U_OUT_P_ENABLE(u_out_p_enable_input_trainer),

    .B_OUT_ENABLE(b_out_enable_input_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_input_trainer),
    .SIZE_W_IN(size_w_in_input_trainer),
    .SIZE_L_IN(size_l_in_input_trainer),
    .SIZE_R_IN(size_r_in_input_trainer),

    .X_IN(x_in_input_trainer),
    .R_IN(r_in_input_trainer),
    .H_IN(h_in_input_trainer),

    .A_IN(a_in_input_trainer),
    .I_IN(i_in_input_trainer),
    .S_IN(s_in_input_trainer),

    .W_OUT(w_out_input_trainer),
    .K_OUT(k_out_input_trainer),
    .U_OUT(u_out_input_trainer),
    .B_OUT(b_out_input_trainer)
  );

  // OUTPUT GATE VECTOR
  model_output_gate_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) output_gate_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_output_gate_vector),
    .READY(ready_output_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_output_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_output_gate_vector),

    .W_OUT_L_ENABLE(w_out_l_enable_output_gate_vector),
    .W_OUT_X_ENABLE(w_out_x_enable_output_gate_vector),

    .X_IN_ENABLE(x_in_enable_output_gate_vector),

    .X_OUT_ENABLE(x_out_enable_output_gate_vector),

    .K_IN_I_ENABLE(k_in_i_enable_output_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_output_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_output_gate_vector),

    .K_OUT_I_ENABLE(k_out_i_enable_output_gate_vector),
    .K_OUT_L_ENABLE(k_out_l_enable_output_gate_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_output_gate_vector),

    .R_IN_I_ENABLE(r_in_i_enable_output_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_output_gate_vector),

    .R_OUT_I_ENABLE(r_out_i_enable_output_gate_vector),
    .R_OUT_K_ENABLE(r_out_k_enable_output_gate_vector),

    .U_IN_L_ENABLE(u_in_l_enable_output_gate_vector),
    .U_IN_P_ENABLE(u_in_p_enable_output_gate_vector),

    .H_IN_ENABLE(h_in_enable_output_gate_vector),

    .H_OUT_ENABLE(h_out_enable_output_gate_vector),

    .B_IN_ENABLE(b_in_enable_output_gate_vector),

    .B_OUT_ENABLE(b_out_enable_output_gate_vector),

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
  model_output_trainer #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) output_trainer (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_output_trainer),
    .READY(ready_output_trainer),

    .X_IN_ENABLE(x_in_enable_output_trainer),

    .X_OUT_ENABLE(x_out_enable_output_trainer),

    .R_IN_I_ENABLE(r_in_i_enable_output_trainer),
    .R_IN_K_ENABLE(u_in_p_enable_output_trainer),

    .R_OUT_I_ENABLE(r_out_i_enable_output_trainer),
    .R_OUT_K_ENABLE(u_out_p_enable_output_trainer),

    .H_IN_ENABLE(h_in_enable_output_trainer),

    .H_OUT_ENABLE(h_out_enable_output_trainer),

    .A_IN_ENABLE(a_in_enable_output_trainer),
    .O_IN_ENABLE(o_in_enable_output_trainer),

    .A_OUT_ENABLE(a_out_enable_output_trainer),
    .O_OUT_ENABLE(o_out_enable_output_trainer),

    .W_OUT_L_ENABLE(w_out_l_enable_output_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_output_trainer),

    .K_OUT_I_ENABLE(k_out_i_enable_output_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_output_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_output_trainer),

    .U_OUT_L_ENABLE(u_out_l_enable_output_trainer),
    .U_OUT_P_ENABLE(u_out_p_enable_output_trainer),

    .B_OUT_ENABLE(b_out_enable_output_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_output_trainer),
    .SIZE_W_IN(size_w_in_output_trainer),
    .SIZE_L_IN(size_l_in_output_trainer),
    .SIZE_R_IN(size_r_in_output_trainer),

    .X_IN(x_in_output_trainer),
    .R_IN(r_in_output_trainer),
    .H_IN(h_in_output_trainer),

    .A_IN(a_in_output_trainer),
    .O_IN(o_in_output_trainer),

    .W_OUT(w_out_output_trainer),
    .K_OUT(k_out_output_trainer),
    .U_OUT(u_out_output_trainer),
    .B_OUT(b_out_output_trainer)
  );

  // FORGET GATE VECTOR
  model_forget_gate_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) forget_gate_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_forget_gate_vector),
    .READY(ready_forget_gate_vector),

    .W_IN_L_ENABLE(w_in_l_enable_forget_gate_vector),
    .W_IN_X_ENABLE(w_in_x_enable_forget_gate_vector),

    .W_OUT_L_ENABLE(w_out_l_enable_forget_gate_vector),
    .W_OUT_X_ENABLE(w_out_x_enable_forget_gate_vector),

    .X_IN_ENABLE(x_in_enable_forget_gate_vector),

    .X_OUT_ENABLE(x_out_enable_forget_gate_vector),

    .K_IN_I_ENABLE(k_in_i_enable_forget_gate_vector),
    .K_IN_L_ENABLE(k_in_l_enable_forget_gate_vector),
    .K_IN_K_ENABLE(k_in_k_enable_forget_gate_vector),

    .K_OUT_I_ENABLE(k_out_i_enable_forget_gate_vector),
    .K_OUT_L_ENABLE(k_out_l_enable_forget_gate_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_forget_gate_vector),

    .R_IN_I_ENABLE(r_in_i_enable_forget_gate_vector),
    .R_IN_K_ENABLE(r_in_k_enable_forget_gate_vector),

    .R_OUT_I_ENABLE(r_out_i_enable_forget_gate_vector),
    .R_OUT_K_ENABLE(r_out_k_enable_forget_gate_vector),

    .U_IN_L_ENABLE(u_in_l_enable_forget_gate_vector),
    .U_IN_P_ENABLE(u_in_p_enable_forget_gate_vector),

    .U_OUT_L_ENABLE(u_out_l_enable_forget_gate_vector),
    .U_OUT_P_ENABLE(u_out_p_enable_forget_gate_vector),

    .H_IN_ENABLE(h_in_enable_forget_gate_vector),

    .H_OUT_ENABLE(h_out_enable_forget_gate_vector),

    .B_IN_ENABLE(b_in_enable_forget_gate_vector),

    .B_OUT_ENABLE(b_out_enable_forget_gate_vector),

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
  model_forget_trainer #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) forget_trainer (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_forget_trainer),
    .READY(ready_forget_trainer),

    .X_IN_ENABLE(x_in_enable_forget_trainer),

    .X_OUT_ENABLE(x_out_enable_forget_trainer),

    .R_IN_I_ENABLE(r_in_i_enable_forget_trainer),
    .R_IN_K_ENABLE(r_in_k_enable_forget_trainer),

    .R_OUT_I_ENABLE(r_out_i_enable_forget_trainer),
    .R_OUT_K_ENABLE(r_out_k_enable_forget_trainer),

    .H_IN_ENABLE(h_in_enable_forget_trainer),

    .H_OUT_ENABLE(h_out_enable_forget_trainer),

    .F_IN_ENABLE(f_in_enable_forget_trainer),
    .S_IN_ENABLE(s_in_enable_forget_trainer),

    .F_OUT_ENABLE(f_out_enable_forget_trainer),
    .S_OUT_ENABLE(s_out_enable_forget_trainer),

    .W_OUT_L_ENABLE(w_out_l_enable_forget_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_forget_trainer),

    .K_OUT_I_ENABLE(k_out_i_enable_forget_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_forget_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_forget_trainer),

    .U_OUT_L_ENABLE(u_out_l_enable_forget_trainer),
    .U_OUT_P_ENABLE(u_out_p_enable_forget_trainer),

    .B_OUT_ENABLE(b_out_enable_forget_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_forget_trainer),
    .SIZE_W_IN(size_w_in_forget_trainer),
    .SIZE_L_IN(size_l_in_forget_trainer),
    .SIZE_R_IN(size_r_in_forget_trainer),

    .X_IN(x_in_forget_trainer),
    .R_IN(r_in_forget_trainer),
    .H_IN(h_in_forget_trainer),

    .F_IN(f_in_forget_trainer),
    .S_IN(s_in_forget_trainer),

    .W_OUT(w_out_forget_trainer),
    .K_OUT(k_out_forget_trainer),
    .U_OUT(u_out_forget_trainer),
    .B_OUT(b_out_forget_trainer)
  );

  // STATE GATE VECTOR
  model_state_gate_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) state_gate_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_state_gate_vector),
    .READY(ready_state_gate_vector),

    .I_IN_ENABLE(i_in_enable_state_gate_vector),
    .F_IN_ENABLE(f_in_enable_state_gate_vector),
    .A_IN_ENABLE(a_in_enable_state_gate_vector),

    .I_OUT_ENABLE(i_out_enable_state_gate_vector),
    .F_OUT_ENABLE(f_out_enable_state_gate_vector),
    .A_OUT_ENABLE(a_out_enable_state_gate_vector),

    .S_IN_ENABLE(s_in_enable_state_gate_vector),

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
  model_hidden_gate_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) hidden_gate_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_hidden_gate_vector),
    .READY(ready_hidden_gate_vector),

    .S_IN_ENABLE(s_in_enable_hidden_gate_vector),
    .O_IN_ENABLE(o_in_enable_hidden_gate_vector),

    .S_OUT_ENABLE(s_out_enable_hidden_gate_vector),
    .O_OUT_ENABLE(o_out_enable_hidden_gate_vector),

    .H_OUT_ENABLE(h_out_enable_hidden_gate_vector),

    // DATA
    .SIZE_L_IN(size_l_in_hidden_gate_vector),

    .S_IN(s_in_hidden_gate_vector),
    .O_IN(o_in_hidden_gate_vector),

    .H_OUT(h_out_hidden_gate_vector)
  );

endmodule
