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

module accelerator_top #(
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

  input W_OUT_L_ENABLE,  // for l in 0 to L-1
  input W_OUT_X_ENABLE,  // for x in 0 to X-1

  input K_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input K_IN_L_ENABLE,  // for l in 0 to L-1
  input K_IN_K_ENABLE,  // for k in 0 to W-1

  input K_OUT_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
  input K_OUT_L_ENABLE,  // for l in 0 to L-1
  input K_OUT_K_ENABLE,  // for k in 0 to W-1

  input U_IN_L_ENABLE,  // for l in 0 to L-1
  input U_IN_P_ENABLE,  // for p in 0 to L-1

  input U_OUT_L_ENABLE,  // for l in 0 to L-1
  input U_OUT_P_ENABLE,  // for p in 0 to L-1

  input B_IN_ENABLE,  // for l in 0 to L-1

  input B_OUT_ENABLE,  // for l in 0 to L-1

  input X_IN_ENABLE,  // for x in 0 to X-1

  input X_OUT_ENABLE,  // for x in 0 to X-1

  output reg Y_OUT_ENABLE,  // for y in 0 to Y-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_X_IN,
  input [DATA_SIZE-1:0] SIZE_Y_IN,
  input [DATA_SIZE-1:0] SIZE_N_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,
  input [DATA_SIZE-1:0] SIZE_L_IN,
  input [DATA_SIZE-1:0] SIZE_R_IN,

  input [DATA_SIZE-1:0] W_IN,
  input [DATA_SIZE-1:0] K_IN,
  input [DATA_SIZE-1:0] U_IN,
  input [DATA_SIZE-1:0] B_IN,

  input      [DATA_SIZE-1:0] X_IN,
  output reg [DATA_SIZE-1:0] Y_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] CONTROLLER_STATE = 1;
  parameter [2:0] READ_HEADS_STATE = 2;
  parameter [2:0] WRITE_HEADS_STATE = 3;
  parameter [2:0] MEMORY_STATE = 4;

  parameter [2:0] STARTER_CONTROLLER_STATE = 0;
  parameter [2:0] CONTROLLER_BODY_STATE = 1;
  parameter [2:0] OUTPUT_VECTOR_STATE = 2;
  parameter [2:0] INTERFACE_VECTOR_STATE = 3;

  parameter [1:0] STARTER_WRITE_HEADS_STATE = 0;
  parameter [1:0] WRITING_STATE = 1;
  parameter [1:0] ERASING_STATE = 2;

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
  reg  [             2:0] top_ctrl_fsm_int;

  reg  [             2:0] controller_ctrl_fsm_int;
  reg  [             1:0] write_heads_ctrl_fsm_int;

  // Data Internal
  reg  [CONTROL_SIZE-1:0] index_loop;

  //////////////////////////////////////////////////////////////////////////////
  // CONTROLLER
  //////////////////////////////////////////////////////////////////////////////

  // CONTROLLER
  // CONTROL
  wire                    start_controller;
  wire                    ready_controller;

  wire                    w_in_l_enable_controller;
  wire                    w_in_x_enable_controller;

  wire                    k_in_i_enable_controller;
  wire                    k_in_l_enable_controller;
  wire                    k_in_k_enable_controller;

  wire                    u_in_l_enable_controller;
  wire                    u_in_p_enable_controller;

  wire                    b_in_enable_controller;

  wire                    x_in_enable_controller;

  wire                    x_out_enable_controller;

  wire                    r_in_i_enable_controller;
  wire                    r_in_k_enable_controller;

  wire                    r_out_i_enable_controller;
  wire                    r_out_k_enable_controller;

  wire                    h_in_enable_controller;

  wire                    w_out_l_enable_controller;
  wire                    w_out_x_enable_controller;

  wire                    k_out_i_enable_controller;
  wire                    k_out_l_enable_controller;
  wire                    k_out_k_enable_controller;

  wire                    u_out_l_enable_controller;
  wire                    u_out_p_enable_controller;

  wire                    b_out_enable_controller;

  wire                    h_out_enable_controller;

  // DATA
  wire [   DATA_SIZE-1:0] size_x_in_controller;
  wire [   DATA_SIZE-1:0] size_w_in_controller;
  wire [   DATA_SIZE-1:0] size_l_in_controller;
  wire [   DATA_SIZE-1:0] size_r_in_controller;

  wire [   DATA_SIZE-1:0] w_in_controller;
  wire [   DATA_SIZE-1:0] k_in_controller;
  wire [   DATA_SIZE-1:0] u_in_controller;
  wire [   DATA_SIZE-1:0] b_in_controller;

  wire [   DATA_SIZE-1:0] x_in_controller;
  wire [   DATA_SIZE-1:0] r_in_controller;
  wire [   DATA_SIZE-1:0] h_in_controller;

  wire [   DATA_SIZE-1:0] w_out_controller;
  wire [   DATA_SIZE-1:0] k_out_controller;
  wire [   DATA_SIZE-1:0] u_out_controller;
  wire [   DATA_SIZE-1:0] b_out_controller;

  wire [   DATA_SIZE-1:0] h_out_controller;

  // OUTPUT VECTOR
  // CONTROL
  wire                    start_output_vector;
  wire                    ready_output_vector;

  wire                    k_in_i_enable_output_vector;
  wire                    k_in_y_enable_output_vector;
  wire                    k_in_k_enable_output_vector;

  wire                    k_out_i_enable_output_vector;
  wire                    k_out_y_enable_output_vector;
  wire                    k_out_k_enable_output_vector;

  wire                    r_in_i_enable_output_vector;
  wire                    r_in_k_enable_output_vector;

  wire                    r_out_i_enable_output_vector;
  wire                    r_out_k_enable_output_vector;

  wire                    u_in_y_enable_output_vector;
  wire                    u_in_l_enable_output_vector;

  wire                    u_out_y_enable_output_vector;
  wire                    u_out_l_enable_output_vector;

  wire                    h_in_enable_output_vector;

  wire                    h_out_enable_output_vector;

  wire                    y_out_enable_output_vector;

  // DATA
  wire [   DATA_SIZE-1:0] size_y_in_output_vector;
  wire [   DATA_SIZE-1:0] size_l_in_output_vector;
  wire [   DATA_SIZE-1:0] size_w_in_output_vector;
  wire [   DATA_SIZE-1:0] size_r_in_output_vector;

  wire [   DATA_SIZE-1:0] k_in_output_vector;
  wire [   DATA_SIZE-1:0] r_in_output_vector;

  wire [   DATA_SIZE-1:0] u_in_output_vector;
  wire [   DATA_SIZE-1:0] h_in_output_vector;

  wire [   DATA_SIZE-1:0] y_out_output_vector;

  // INTERFACE VECTOR
  // CONTROL
  wire                    start_interface_vector;
  wire                    ready_interface_vector;

  // Key Vector
  wire                    u_in_s_enable_interface_vector;
  wire                    u_in_l_enable_interface_vector;

  wire                    u_out_s_enable_interface_vector;
  wire                    u_out_l_enable_interface_vector;

  // Hidden State
  wire                    h_in_enable_interface_vector;

  wire                    h_out_enable_interface_vector;

  // Interface
  wire                    xi_out_enable_interface_vector;

  // DATA
  wire [   DATA_SIZE-1:0] size_s_in_interface_vector;
  wire [   DATA_SIZE-1:0] size_l_in_interface_vector;

  wire [   DATA_SIZE-1:0] u_in_interface_vector;

  wire [   DATA_SIZE-1:0] h_in_interface_vector;

  wire [   DATA_SIZE-1:0] xi_out_interface_vector;

  //////////////////////////////////////////////////////////////////////////////
  // READ HEADS
  //////////////////////////////////////////////////////////////////////////////

  // READING
  // CONTROL
  wire                    start_reading;
  wire                    ready_reading;

  wire                    m_in_j_enable_reading;
  wire                    m_in_k_enable_reading;

  wire                    m_out_j_enable_reading;
  wire                    m_out_k_enable_reading;

  wire                    r_out_enable_reading;

  // DATA
  wire [   DATA_SIZE-1:0] size_n_in_reading;
  wire [   DATA_SIZE-1:0] size_w_in_reading;

  wire [   DATA_SIZE-1:0] w_in_reading;
  wire [   DATA_SIZE-1:0] m_in_reading;

  wire [   DATA_SIZE-1:0] r_out_reading;

  //////////////////////////////////////////////////////////////////////////////
  // WRITE HEADS
  //////////////////////////////////////////////////////////////////////////////

  // WRITING
  // CONTROL
  wire                    start_writing;
  wire                    ready_writing;

  wire                    m_in_j_enable_writing;
  wire                    m_in_k_enable_writing;

  wire                    w_in_enable_writing;

  wire                    a_in_enable_writing;

  wire                    w_out_enable_writing;

  wire                    a_out_enable_writing;

  wire                    m_out_j_enable_writing;
  wire                    m_out_k_enable_writing;

  // DATA
  wire [   DATA_SIZE-1:0] size_n_in_writing;
  wire [   DATA_SIZE-1:0] size_w_in_writing;

  wire [   DATA_SIZE-1:0] m_in_writing;
  wire [   DATA_SIZE-1:0] a_in_writing;
  wire [   DATA_SIZE-1:0] w_in_writing;

  wire [   DATA_SIZE-1:0] m_out_writing;

  // ERASING
  // CONTROL
  wire                    start_erasing;
  wire                    ready_erasing;

  wire                    m_in_j_enable_erasing;
  wire                    m_in_k_enable_erasing;

  wire                    e_in_enable_erasing;

  wire                    e_out_enable_erasing;

  wire                    m_out_j_enable_erasing;
  wire                    m_out_k_enable_erasing;

  // DATA
  wire [   DATA_SIZE-1:0] size_n_in_erasing;
  wire [   DATA_SIZE-1:0] size_w_in_erasing;

  wire [   DATA_SIZE-1:0] m_in_erasing;
  wire [   DATA_SIZE-1:0] e_in_erasing;
  wire [   DATA_SIZE-1:0] w_in_erasing;

  wire [   DATA_SIZE-1:0] m_out_erasing;

  //////////////////////////////////////////////////////////////////////////////
  // MEMORY
  //////////////////////////////////////////////////////////////////////////////

  // ADDRESSING
  // CONTROL
  wire                    start_addressing;
  wire                    ready_addressing;

  wire                    k_in_enable_addressing;
  wire                    s_in_enable_addressing;

  wire                    k_out_enable_addressing;
  wire                    s_out_enable_addressing;

  wire                    m_in_j_enable_addressing;
  wire                    m_in_k_enable_addressing;

  wire                    m_out_j_enable_addressing;
  wire                    m_out_k_enable_addressing;

  wire                    w_in_enable_addressing;
  wire                    w_out_enable_addressing;

  // DATA
  wire [   DATA_SIZE-1:0] size_n_in_addressing;
  wire [   DATA_SIZE-1:0] size_w_in_addressing;

  wire [   DATA_SIZE-1:0] k_in_addressing;
  wire [   DATA_SIZE-1:0] beta_in_addressing;
  wire [   DATA_SIZE-1:0] g_in_addressing;
  wire [   DATA_SIZE-1:0] s_in_addressing;
  wire [   DATA_SIZE-1:0] gamma_in_addressing;

  wire [   DATA_SIZE-1:0] m_in_addressing;
  wire [   DATA_SIZE-1:0] w_in_addressing;

  wire [   DATA_SIZE-1:0] w_out_addressing;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      Y_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (top_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // FSM Control
            top_ctrl_fsm_int <= CONTROLLER_STATE;
          end
        end

        CONTROLLER_STATE: begin  // STEP 1
          case (controller_ctrl_fsm_int)
            STARTER_CONTROLLER_STATE: begin  // STEP 0
            end

            CONTROLLER_BODY_STATE: begin  // STEP 1
              // FNN Convolutional mode: h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + b(l))
              // FNN Standard mode:      h(t;l) = sigmoid(W(l;x)·x(t;x) + K(i;l;k)·r(t;i;k) + U(l;l)·h(t-1;l) + b(l))
            end

            OUTPUT_VECTOR_STATE: begin  // STEP 2
              // y(t;y) = K(i;y;k)·r(t;i;k) + U(y;l)·h(t;l)
            end

            INTERFACE_VECTOR_STATE: begin  // STEP 3
              // xi(t;?) = U(t;?;l)·h(t;l)

              // k(t;i;k) = Wk(t;l;k)·h(t;l)
              // beta(t;i) = Wbeta(t;l)·h(t;l)
              // g(t;i) = Wg(t;l)·h(t;l)
              // s(t;j) = Wk(t;l;j)·h(t;l)
              // gamma(t;i) = Wgamma(t;l)·h(t;l)
            end
            default: begin
              // FSM Control
              controller_ctrl_fsm_int <= STARTER_CONTROLLER_STATE;
            end
          endcase
        end

        READ_HEADS_STATE: begin  // STEP 2
          // r(t;k) = summation(w(t;i;j)·M(t;j;k))[j in 1 to N]
        end

        WRITE_HEADS_STATE: begin  // STEP 3
          case (write_heads_ctrl_fsm_int)
            STARTER_WRITE_HEADS_STATE: begin  // STEP 0
            end

            WRITING_STATE: begin  // STEP 1
              // M(t;j;k) = M(t;j;k) + w(t;i;j)·a(t;k)
            end

            ERASING_STATE: begin  // STEP 2
              // M(t;j;k) = M(t;j;k)·(1 - w(t;i;j)·e(t;k))
            end
            default: begin
              // FSM Control
              write_heads_ctrl_fsm_int <= STARTER_WRITE_HEADS_STATE;
            end
          endcase
        end

        MEMORY_STATE: begin  // STEP 4

          // wc(t;i;j) = C(M(t;j;k),k(t;i;k),beta(t;i))

          // wg(t;i;j) = g(t;i)·wc(t;i;j) + (1 - g(t;i))·w(t-1;i;j)

          // w(t;i;j) = wg(t;i;j)*s(t;i;k)

          // w(t;i;j) = exponentiation(w(t;i;j),gamma(t;i)) / summation(exponentiation(w(t;i;j),gamma(t;i)))[j in 0 to N-1]

          if (index_loop == SIZE_R_IN - ONE_CONTROL) begin
            // FSM Control
            top_ctrl_fsm_int <= STARTER_STATE;
          end
        end
        default: begin
          // FSM Control
          top_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  //////////////////////////////////////////////////////////////////////////////
  // CONTROLLER
  //////////////////////////////////////////////////////////////////////////////

  // CONTROLLER
  accelerator_controller #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) accelerator_controller_i (
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

  // OUTPUT VECTOR
  accelerator_output_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) output_vector_i (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_output_vector),
    .READY(ready_output_vector),

    .K_IN_I_ENABLE(k_in_i_enable_output_vector),
    .K_IN_Y_ENABLE(k_in_y_enable_output_vector),
    .K_IN_K_ENABLE(k_in_k_enable_output_vector),

    .K_OUT_I_ENABLE(k_out_i_enable_output_vector),
    .K_OUT_Y_ENABLE(k_out_y_enable_output_vector),
    .K_OUT_K_ENABLE(k_out_k_enable_output_vector),

    .R_IN_I_ENABLE(r_in_i_enable_output_vector),
    .R_IN_K_ENABLE(r_in_k_enable_output_vector),

    .R_OUT_I_ENABLE(r_out_i_enable_output_vector),
    .R_OUT_K_ENABLE(r_out_k_enable_output_vector),

    .U_IN_Y_ENABLE(u_in_y_enable_output_vector),
    .U_IN_L_ENABLE(u_in_l_enable_output_vector),

    .U_OUT_Y_ENABLE(u_out_y_enable_output_vector),
    .U_OUT_L_ENABLE(u_out_l_enable_output_vector),

    .H_IN_ENABLE(h_in_enable_output_vector),

    .H_OUT_ENABLE(h_out_enable_output_vector),

    .Y_OUT_ENABLE(y_out_enable_output_vector),

    // DATA
    .SIZE_Y_IN(size_y_in_output_vector),
    .SIZE_L_IN(size_l_in_output_vector),
    .SIZE_W_IN(size_w_in_output_vector),
    .SIZE_R_IN(size_r_in_output_vector),

    .K_IN(k_in_output_vector),
    .R_IN(r_in_output_vector),

    .U_IN(u_in_output_vector),
    .H_IN(h_in_output_vector),

    .Y_OUT(y_out_output_vector)
  );

  // INTERFACE VECTOR
  accelerator_interface_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) interface_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_interface_vector),
    .READY(ready_interface_vector),

    // Weight
    .U_IN_S_ENABLE(u_in_s_enable_interface_vector),
    .U_IN_L_ENABLE(u_in_l_enable_interface_vector),

    .U_OUT_S_ENABLE(u_out_s_enable_interface_vector),
    .U_OUT_L_ENABLE(u_out_l_enable_interface_vector),

    // Hidden State
    .H_IN_ENABLE(h_in_enable_interface_vector),

    .H_OUT_ENABLE(h_out_enable_interface_vector),

    // Interface
    .XI_OUT_ENABLE(xi_out_enable_interface_vector),

    // DATA
    .SIZE_S_IN(size_s_in_interface_vector),
    .SIZE_L_IN(size_l_in_interface_vector),

    .U_IN(u_in_interface_vector),

    .H_IN(h_in_interface_vector),

    .XI_OUT(xi_out_interface_vector)
  );

  //////////////////////////////////////////////////////////////////////////////
  // READ HEADS
  //////////////////////////////////////////////////////////////////////////////

  // READING
  accelerator_reading #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) reading (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_reading),
    .READY(ready_reading),

    .M_IN_J_ENABLE(m_in_j_enable_reading),
    .M_IN_K_ENABLE(m_in_k_enable_reading),

    .M_OUT_J_ENABLE(m_out_j_enable_reading),
    .M_OUT_K_ENABLE(m_out_k_enable_reading),

    .R_OUT_ENABLE(r_out_enable_reading),

    // DATA
    .SIZE_N_IN(size_n_in_reading),
    .SIZE_W_IN(size_w_in_reading),

    .W_IN(w_in_reading),
    .M_IN(m_in_reading),

    .R_OUT(r_out_reading)
  );

  //////////////////////////////////////////////////////////////////////////////
  // WRITE HEADS
  //////////////////////////////////////////////////////////////////////////////

  // WRITING
  accelerator_writing #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) writing (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_writing),
    .READY(ready_writing),

    .M_IN_J_ENABLE(m_in_j_enable_writing),
    .M_IN_K_ENABLE(m_in_k_enable_writing),

    .W_IN_ENABLE(w_in_enable_writing),

    .A_IN_ENABLE(a_in_enable_writing),

    .W_OUT_ENABLE(w_out_enable_writing),

    .A_OUT_ENABLE(a_out_enable_writing),

    .M_OUT_J_ENABLE(m_out_j_enable_writing),
    .M_OUT_K_ENABLE(m_out_k_enable_writing),

    // DATA
    .SIZE_N_IN(size_n_in_writing),
    .SIZE_W_IN(size_w_in_writing),

    .M_IN(m_in_writing),
    .A_IN(a_in_writing),
    .W_IN(w_in_writing),

    .M_OUT(m_out_writing)
  );

  // ERASING
  accelerator_erasing #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) erasing (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_erasing),
    .READY(ready_erasing),

    .M_IN_J_ENABLE(m_in_j_enable_erasing),
    .M_IN_K_ENABLE(m_in_k_enable_erasing),

    .E_IN_ENABLE(e_in_enable_erasing),

    .E_OUT_ENABLE(e_out_enable_erasing),

    .M_OUT_J_ENABLE(m_out_j_enable_erasing),
    .M_OUT_K_ENABLE(m_out_k_enable_erasing),

    // DATA
    .SIZE_N_IN(size_n_in_erasing),
    .SIZE_W_IN(size_w_in_erasing),

    .M_IN(m_in_erasing),
    .E_IN(e_in_erasing),
    .W_IN(w_in_erasing),

    .M_OUT(m_out_erasing)
  );

  //////////////////////////////////////////////////////////////////////////////
  // MEMORY
  //////////////////////////////////////////////////////////////////////////////

  // ADDRESSING
  accelerator_addressing #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) addressing (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_addressing),
    .READY(ready_addressing),

    .K_IN_ENABLE(k_in_enable_addressing),
    .S_IN_ENABLE(s_in_enable_addressing),

    .K_OUT_ENABLE(k_out_enable_addressing),
    .S_OUT_ENABLE(s_out_enable_addressing),

    .M_IN_J_ENABLE(m_in_j_enable_addressing),
    .M_IN_K_ENABLE(m_in_k_enable_addressing),

    .M_OUT_J_ENABLE(m_out_j_enable_addressing),
    .M_OUT_K_ENABLE(m_out_k_enable_addressing),

    .W_IN_ENABLE (w_in_enable_addressing),
    .W_OUT_ENABLE(w_out_enable_addressing),

    // DATA
    .SIZE_N_IN(size_n_in_addressing),
    .SIZE_W_IN(size_w_in_addressing),

    .K_IN    (k_in_addressing),
    .BETA_IN (beta_in_addressing),
    .G_IN    (g_in_addressing),
    .S_IN    (s_in_addressing),
    .GAMMA_IN(gamma_in_addressing),

    .M_IN(m_in_addressing),
    .W_IN(w_in_addressing),

    .W_OUT(w_out_addressing)
  );

endmodule
