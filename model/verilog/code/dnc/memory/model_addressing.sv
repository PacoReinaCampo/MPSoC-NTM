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

module model_addressing #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input K_READ_IN_I_ENABLE,  // for i in 0 to R-1
  input K_READ_IN_K_ENABLE,  // for k in 0 to W-1

  output reg K_READ_OUT_I_ENABLE,  // for i in 0 to R-1
  output reg K_READ_OUT_K_ENABLE,  // for k in 0 to W-1

  input BETA_READ_IN_ENABLE,  // for i in 0 to R-1

  output reg BETA_READ_OUT_ENABLE,  // for i in 0 to R-1

  input F_READ_IN_ENABLE,  // for i in 0 to R-1

  output reg F_READ_OUT_ENABLE,  // for i in 0 to R-1

  input PI_READ_IN_ENABLE,  // for i in 0 to R-1

  output reg PI_READ_OUT_ENABLE,  // for i in 0 to R-1

  input K_WRITE_IN_K_ENABLE,  // for k in 0 to W-1

  output reg K_WRITE_OUT_K_ENABLE,  // for k in 0 to W-1

  input E_WRITE_IN_K_ENABLE,  // for k in 0 to W-1

  output reg E_WRITE_OUT_K_ENABLE,  // for k in 0 to W-1

  input V_WRITE_IN_K_ENABLE,  // for k in 0 to W-1

  output reg V_WRITE_OUT_K_ENABLE,  // for k in 0 to W-1

  output reg R_OUT_I_ENABLE,  // for i in 0 to R-1
  output reg R_OUT_K_ENABLE,  // for k in 0 to W-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_R_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,

  input [DATA_SIZE-1:0] K_READ_IN,
  input [DATA_SIZE-1:0] BETA_READ_IN,
  input [DATA_SIZE-1:0] F_READ_IN,
  input [DATA_SIZE-1:0] PI_READ_IN,

  input [DATA_SIZE-1:0] K_WRITE_IN,
  input [DATA_SIZE-1:0] BETA_WRITE_IN,
  input [DATA_SIZE-1:0] E_WRITE_IN,
  input [DATA_SIZE-1:0] V_WRITE_IN,
  input [DATA_SIZE-1:0] GA_WRITE_IN,
  input [DATA_SIZE-1:0] GW_WRITE_IN,

  output reg [DATA_SIZE-1:0] R_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [3:0] STARTER_STATE = 0;
  parameter [3:0] PRECEDENCE_WEIGHTING_STATE = 1;
  parameter [3:0] TEMPORAL_LINK_MATRIX_STATE = 2;
  parameter [3:0] BACKWARD_FORWARD_WEIGHTING_STATE = 3;
  parameter [3:0] MEMORY_RETENTION_VECTOR_STATE = 4;
  parameter [3:0] USAGE_VECTOR_STATE = 5;
  parameter [3:0] ALLOCATION_WEIGHTING_STATE = 6;
  parameter [3:0] READ_WRITE_CONTENT_WEIGHTING_STATE = 7;
  parameter [3:0] READ_WRITE_WEIGHTING_STATE = 8;
  parameter [3:0] MEMORY_MATRIX_STATE = 9;
  parameter [3:0] READ_VECTORS_STATE = 10;

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
  reg  [          3:0] controller_ctrl_fsm_int;

  // ALLOCATION WEIGHTING
  // CONTROL
  wire                 start_allocation_weighting;
  wire                 ready_allocation_weighting;

  wire                 u_in_enable_allocation_weighting;

  wire                 u_out_enable_allocation_weighting;

  wire                 a_out_enable_allocation_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_allocation_weighting;

  wire [DATA_SIZE-1:0] u_in_allocation_weighting;

  wire [DATA_SIZE-1:0] a_out_allocation_weighting;

  // BACKWARD WEIGHTING
  // CONTROL
  wire                 start_backward_weighting;
  wire                 ready_backward_weighting;

  wire                 l_in_g_enable_backward_weighting;
  wire                 l_in_j_enable_backward_weighting;

  wire                 w_in_i_enable_backward_weighting;
  wire                 w_in_j_enable_backward_weighting;

  wire                 b_i_enable_backward_weighting;
  wire                 b_j_enable_backward_weighting;

  wire                 b_out_i_enable_backward_weighting;
  wire                 b_out_j_enable_backward_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_backward_weighting;
  wire [DATA_SIZE-1:0] size_n_in_backward_weighting;

  wire [DATA_SIZE-1:0] l_in_backward_weighting;
  wire [DATA_SIZE-1:0] w_in_backward_weighting;

  wire [DATA_SIZE-1:0] b_out_backward_weighting;

  // FORWARD WEIGHTING
  // CONTROL
  wire                 start_forward_weighting;
  wire                 ready_forward_weighting;

  wire                 l_in_g_enable_forward_weighting;
  wire                 l_in_j_enable_forward_weighting;

  wire                 w_in_i_enable_forward_weighting;
  wire                 w_in_j_enable_forward_weighting;

  wire                 f_i_enable_forward_weighting;
  wire                 f_j_enable_forward_weighting;

  wire                 f_out_i_enable_forward_weighting;
  wire                 f_out_j_enable_forward_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_forward_weighting;
  wire [DATA_SIZE-1:0] size_n_in_forward_weighting;

  wire [DATA_SIZE-1:0] l_in_forward_weighting;

  wire [DATA_SIZE-1:0] w_in_forward_weighting;

  wire [DATA_SIZE-1:0] f_out_forward_weighting;

  // MEMORY MATRIX
  // CONTROL
  wire                 start_memory_matrix;
  wire                 ready_memory_matrix;

  wire                 m_in_j_enable_memory_matrix;
  wire                 m_in_k_enable_memory_matrix;

  wire                 w_in_j_enable_memory_matrix;
  wire                 v_in_k_enable_memory_matrix;
  wire                 e_in_k_enable_memory_matrix;

  wire                 w_out_j_enable_memory_matrix;
  wire                 v_out_k_enable_memory_matrix;
  wire                 e_out_k_enable_memory_matrix;

  wire                 m_out_j_enable_memory_matrix;
  wire                 m_out_k_enable_memory_matrix;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_memory_matrix;
  wire [DATA_SIZE-1:0] size_w_in_memory_matrix;

  wire [DATA_SIZE-1:0] m_in_memory_matrix;

  wire [DATA_SIZE-1:0] w_in_memory_matrix;
  wire [DATA_SIZE-1:0] v_in_memory_matrix;
  wire [DATA_SIZE-1:0] e_in_memory_matrix;

  wire [DATA_SIZE-1:0] m_out_memory_matrix;

  // MEMORY RETENTION VECTOR
  // CONTROL
  wire                 start_memory_retention_vector;
  wire                 ready_memory_retention_vector;

  wire                 f_in_enable_memory_retention_vector;

  wire                 f_out_enable_memory_retention_vector;

  wire                 w_in_i_enable_memory_retention_vector;
  wire                 w_in_j_enable_memory_retention_vector;

  wire                 w_out_i_enable_memory_retention_vector;
  wire                 w_out_j_enable_memory_retention_vector;

  wire                 psi_out_enable_memory_retention_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_memory_retention_vector;
  wire [DATA_SIZE-1:0] size_n_in_memory_retention_vector;

  wire [DATA_SIZE-1:0] f_in_memory_retention_vector;
  wire [DATA_SIZE-1:0] w_in_memory_retention_vector;

  wire [DATA_SIZE-1:0] psi_out_memory_retention_vector;

  // PRECEDENCE WEIGHTING
  // CONTROL
  reg                  start_precedence_weighting;
  wire                 ready_precedence_weighting;

  wire                 w_in_enable_precedence_weighting;
  wire                 p_in_enable_precedence_weighting;

  wire                 w_out_enable_precedence_weighting;
  wire                 p_out_enable_precedence_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_precedence_weighting;
  wire [DATA_SIZE-1:0] size_n_in_precedence_weighting;

  wire [DATA_SIZE-1:0] w_in_precedence_weighting;
  wire [DATA_SIZE-1:0] p_in_precedence_weighting;

  wire [DATA_SIZE-1:0] p_out_precedence_weighting;

  // READ CONTENT WEIGHTING
  // CONTROL
  wire                 start_read_content_weighting;
  wire                 ready_read_content_weighting;

  wire                 k_in_enable_read_content_weighting;

  wire                 k_out_enable_read_content_weighting;

  wire                 m_in_j_enable_read_content_weighting;
  wire                 m_in_k_enable_read_content_weighting;

  wire                 m_out_j_enable_read_content_weighting;
  wire                 m_out_k_enable_read_content_weighting;

  wire                 c_out_enable_read_content_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_read_content_weighting;
  wire [DATA_SIZE-1:0] size_w_in_read_content_weighting;

  wire [DATA_SIZE-1:0] k_in_read_content_weighting;
  wire [DATA_SIZE-1:0] m_in_read_content_weighting;
  wire [DATA_SIZE-1:0] beta_in_read_content_weighting;

  wire [DATA_SIZE-1:0] c_out_read_content_weighting;

  // READ VECTORS
  // CONTROL
  wire                 start_read_vectors;
  wire                 ready_read_vectors;

  wire                 m_in_j_enable_read_vectors;
  wire                 m_in_k_enable_read_vectors;

  wire                 m_out_j_enable_read_vectors;
  wire                 m_out_k_enable_read_vectors;

  wire                 w_in_i_enable_read_vectors;
  wire                 w_in_j_enable_read_vectors;

  wire                 w_out_i_enable_read_vectors;
  wire                 w_out_j_enable_read_vectors;

  wire                 r_out_i_enable_read_vectors;
  wire                 r_out_k_enable_read_vectors;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_vectors;
  wire [DATA_SIZE-1:0] size_n_in_read_vectors;
  wire [DATA_SIZE-1:0] size_w_in_read_vectors;

  wire [DATA_SIZE-1:0] m_in_read_vectors;
  wire [DATA_SIZE-1:0] w_in_read_vectors;

  wire [DATA_SIZE-1:0] r_out_read_vectors;

  // READ WEIGHTING
  // CONTROL
  wire                 start_read_weighting;
  wire                 ready_read_weighting;

  wire                 pi_in_i_enable_read_weighting;
  wire                 pi_in_p_enable_read_weighting;

  wire                 pi_out_i_enable_read_weighting;
  wire                 pi_out_p_enable_read_weighting;

  wire                 b_in_i_enable_read_weighting;
  wire                 b_in_j_enable_read_weighting;

  wire                 b_out_i_enable_read_weighting;
  wire                 b_out_j_enable_read_weighting;

  wire                 c_in_i_enable_read_weighting;
  wire                 c_in_j_enable_read_weighting;

  wire                 c_out_i_enable_read_weighting;
  wire                 c_out_j_enable_read_weighting;

  wire                 f_in_i_enable_read_weighting;
  wire                 f_in_j_enable_read_weighting;

  wire                 f_out_i_enable_read_weighting;
  wire                 f_out_j_enable_read_weighting;

  wire                 w_out_i_enable_read_weighting;
  wire                 w_out_j_enable_read_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_weighting;
  wire [DATA_SIZE-1:0] size_n_in_read_weighting;

  wire [DATA_SIZE-1:0] pi_in_read_weighting;

  wire [DATA_SIZE-1:0] b_in_read_weighting;
  wire [DATA_SIZE-1:0] c_in_read_weighting;
  wire [DATA_SIZE-1:0] f_in_read_weighting;

  wire [DATA_SIZE-1:0] w_out_read_weighting;

  // TEMPORAL LINK MATRIX
  // CONTROL
  wire                 start_temporal_link_matrix;
  wire                 ready_temporal_link_matrix;

  wire                 l_in_g_enable_temporal_link_matrix;
  wire                 l_in_j_enable_temporal_link_matrix;

  wire                 w_in_enable_temporal_link_matrix;
  wire                 p_in_enable_temporal_link_matrix;

  wire                 w_out_enable_temporal_link_matrix;
  wire                 p_out_enable_temporal_link_matrix;

  wire                 l_out_g_enable_temporal_link_matrix;
  wire                 l_out_j_enable_temporal_link_matrix;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_temporal_link_matrix;

  wire [DATA_SIZE-1:0] l_in_temporal_link_matrix;
  wire [DATA_SIZE-1:0] w_in_temporal_link_matrix;
  wire [DATA_SIZE-1:0] p_in_temporal_link_matrix;

  wire [DATA_SIZE-1:0] l_out_temporal_link_matrix;

  // USAGE VECTOR
  // CONTROL
  wire                 start_usage_vector;
  wire                 ready_usage_vector;

  wire                 u_in_enable_usage_vector;
  wire                 w_in_enable_usage_vector;
  wire                 psi_in_enable_usage_vector;

  wire                 u_out_enable_usage_vector;
  wire                 w_out_enable_usage_vector;
  wire                 psi_out_enable_usage_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_usage_vector;

  wire [DATA_SIZE-1:0] u_in_usage_vector;
  wire [DATA_SIZE-1:0] w_in_usage_vector;
  wire [DATA_SIZE-1:0] psi_in_usage_vector;

  wire [DATA_SIZE-1:0] u_out_usage_vector;

  // WRITE CONTENT WEIGHTING
  // CONTROL
  wire                 start_write_content_weighting;
  wire                 ready_write_content_weighting;

  wire                 k_in_enable_write_content_weighting;

  wire                 k_out_enable_write_content_weighting;

  wire                 m_in_j_enable_write_content_weighting;
  wire                 m_in_k_enable_write_content_weighting;

  wire                 m_out_j_enable_write_content_weighting;
  wire                 m_out_k_enable_write_content_weighting;

  wire                 c_out_enable_write_content_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_write_content_weighting;
  wire [DATA_SIZE-1:0] size_w_in_write_content_weighting;

  wire [DATA_SIZE-1:0] k_in_write_content_weighting;
  wire [DATA_SIZE-1:0] m_in_write_content_weighting;
  wire [DATA_SIZE-1:0] beta_in_write_content_weighting;

  wire [DATA_SIZE-1:0] c_out_content_weighting;

  // WRITE WEIGHTING
  // CONTROL
  wire                 start_write_weighting;
  wire                 ready_write_weighting;

  wire                 a_in_enable_write_weighting;
  wire                 c_in_enable_write_weighting;

  wire                 a_out_enable_write_weighting;
  wire                 c_out_enable_write_weighting;

  wire                 w_out_enable_write_weighting;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_write_weighting;

  wire [DATA_SIZE-1:0] a_in_write_weighting;
  wire [DATA_SIZE-1:0] c_in_write_weighting;

  wire [DATA_SIZE-1:0] ga_in_write_weighting;
  wire [DATA_SIZE-1:0] gw_in_write_weighting;

  wire [DATA_SIZE-1:0] w_out_write_weighting;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if (RST == 1'b0) begin
      // Data Outputs
      R_OUT <= ZERO_DATA;

      // Control Outputs
      READY <= 1'b0;
    end else begin
      case (controller_ctrl_fsm_int)
        STARTER_STATE: begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if (START == 1'b1) begin
            // Control Internal
            start_precedence_weighting <= 1'b1;

            // FSM Control
            controller_ctrl_fsm_int    <= PRECEDENCE_WEIGHTING_STATE;
          end else begin
            // Control Internal
            start_precedence_weighting <= 1'b0;
          end
        end

        PRECEDENCE_WEIGHTING_STATE: begin  // STEP 1

          // p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
          // p(t=0) = 0
        end

        TEMPORAL_LINK_MATRIX_STATE: begin  // STEP 2

          // L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
          // L(t=0)[g,j] = 0
        end

        BACKWARD_FORWARD_WEIGHTING_STATE: begin  // STEP 3

          // b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

          // f(t;i;j) = L(t;g;j)·w(t-1;i;j)
        end

        MEMORY_RETENTION_VECTOR_STATE: begin  // STEP 4

          // psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]
        end

        USAGE_VECTOR_STATE: begin  // STEP 5

          // u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)
        end

        ALLOCATION_WEIGHTING_STATE: begin  // STEP 6

          // a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]
        end

        READ_WRITE_CONTENT_WEIGHTING_STATE: begin  // STEP 7

          // c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

          // c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))
        end

        READ_WRITE_WEIGHTING_STATE: begin  // STEP 8

          // w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

          // w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))
        end

        MEMORY_MATRIX_STATE: begin  // STEP 9

          // M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))
        end

        READ_VECTORS_STATE: begin  // STEP 10

          // r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)
        end
        default: begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // ALLOCATION WEIGHTING
  model_allocation_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) allocation_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_allocation_weighting),
    .READY(ready_allocation_weighting),

    .U_IN_ENABLE(u_in_enable_allocation_weighting),

    .U_OUT_ENABLE(u_out_enable_allocation_weighting),

    .A_OUT_ENABLE(a_out_enable_allocation_weighting),

    // DATA
    .SIZE_N_IN(size_n_in_allocation_weighting),

    .U_IN(u_in_allocation_weighting),

    .A_OUT(a_out_allocation_weighting)
  );

  // BACKWARD WEIGHTING
  model_backward_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) backward_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_backward_weighting),
    .READY(ready_backward_weighting),

    .L_IN_G_ENABLE(l_in_g_enable_backward_weighting),
    .L_IN_J_ENABLE(l_in_j_enable_backward_weighting),

    .W_IN_I_ENABLE(w_in_i_enable_backward_weighting),
    .W_IN_J_ENABLE(w_in_j_enable_backward_weighting),

    .W_OUT_I_ENABLE(b_i_enable_backward_weighting),
    .W_OUT_J_ENABLE(b_j_enable_backward_weighting),

    .B_OUT_I_ENABLE(b_out_i_enable_backward_weighting),
    .B_OUT_J_ENABLE(b_out_j_enable_backward_weighting),

    // DATA
    .SIZE_R_IN(size_r_in_backward_weighting),
    .SIZE_N_IN(size_n_in_backward_weighting),

    .L_IN(l_in_backward_weighting),

    .W_IN(w_in_backward_weighting),

    .B_OUT(b_out_backward_weighting)
  );

  // FORWARD WEIGHTING
  model_forward_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) forward_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_forward_weighting),
    .READY(ready_forward_weighting),

    .L_IN_G_ENABLE(l_in_g_enable_forward_weighting),
    .L_IN_J_ENABLE(l_in_j_enable_forward_weighting),

    .W_IN_I_ENABLE(w_in_i_enable_forward_weighting),
    .W_IN_J_ENABLE(w_in_j_enable_forward_weighting),

    .F_I_ENABLE(f_i_enable_forward_weighting),
    .F_J_ENABLE(f_j_enable_forward_weighting),

    .F_OUT_I_ENABLE(f_out_i_enable_forward_weighting),
    .F_OUT_J_ENABLE(f_out_j_enable_forward_weighting),

    // DATA
    .SIZE_R_IN(size_r_in_forward_weighting),
    .SIZE_N_IN(size_n_in_forward_weighting),
    .L_IN     (l_in_forward_weighting),
    .W_IN     (w_in_forward_weighting),
    .F_OUT    (f_out_forward_weighting)
  );

  // MEMORY MATRIX
  model_memory_matrix #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) memory_matrix (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_memory_matrix),
    .READY(ready_memory_matrix),

    .M_IN_J_ENABLE(m_in_j_enable_memory_matrix),
    .M_IN_K_ENABLE(m_in_k_enable_memory_matrix),

    .W_IN_J_ENABLE(w_in_j_enable_memory_matrix),
    .V_IN_K_ENABLE(v_in_k_enable_memory_matrix),
    .E_IN_K_ENABLE(e_in_k_enable_memory_matrix),

    .W_OUT_J_ENABLE(w_out_j_enable_memory_matrix),
    .V_OUT_K_ENABLE(v_out_k_enable_memory_matrix),
    .E_OUT_K_ENABLE(e_out_k_enable_memory_matrix),

    .M_OUT_J_ENABLE(m_out_j_enable_memory_matrix),
    .M_OUT_K_ENABLE(m_out_k_enable_memory_matrix),

    // DATA
    .SIZE_N_IN(size_n_in_memory_matrix),
    .SIZE_W_IN(size_w_in_memory_matrix),

    .M_IN(m_in_memory_matrix),

    .W_IN(w_in_memory_matrix),
    .V_IN(v_in_memory_matrix),
    .E_IN(e_in_memory_matrix),

    .M_OUT(m_out_memory_matrix)
  );

  // MEMORY RETENTION VECTOR
  model_memory_retention_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) memory_retention_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_memory_retention_vector),
    .READY(ready_memory_retention_vector),

    .F_IN_ENABLE(f_in_enable_memory_retention_vector),

    .F_OUT_ENABLE(f_out_enable_memory_retention_vector),

    .W_IN_I_ENABLE(w_in_i_enable_memory_retention_vector),
    .W_IN_J_ENABLE(w_in_j_enable_memory_retention_vector),

    .W_OUT_I_ENABLE(w_out_i_enable_memory_retention_vector),
    .W_OUT_J_ENABLE(w_out_j_enable_memory_retention_vector),

    .PSI_OUT_ENABLE(psi_out_enable_memory_retention_vector),

    // DATA
    .SIZE_R_IN(size_r_in_memory_retention_vector),
    .SIZE_N_IN(size_n_in_memory_retention_vector),

    .F_IN(f_in_memory_retention_vector),
    .W_IN(w_in_memory_retention_vector),

    .PSI_OUT(psi_out_memory_retention_vector)
  );

  // PRECEDENCE WEIGHTING
  model_precedence_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) precedence_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_precedence_weighting),
    .READY(ready_precedence_weighting),

    .W_IN_ENABLE(w_in_enable_precedence_weighting),
    .P_IN_ENABLE(p_in_enable_precedence_weighting),

    .W_OUT_ENABLE(w_out_enable_precedence_weighting),
    .P_OUT_ENABLE(p_out_enable_precedence_weighting),

    // DATA
    .SIZE_R_IN(size_r_in_precedence_weighting),
    .SIZE_N_IN(size_n_in_precedence_weighting),

    .W_IN(w_in_precedence_weighting),
    .P_IN(p_in_precedence_weighting),

    .P_OUT(p_out_precedence_weighting)
  );

  // READ CONTENT WEIGHTING
  model_read_content_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) read_content_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_content_weighting),
    .READY(ready_read_content_weighting),

    .K_IN_ENABLE(k_in_enable_read_content_weighting),

    .K_OUT_ENABLE(k_out_enable_read_content_weighting),

    .M_IN_J_ENABLE(m_in_j_enable_read_content_weighting),
    .M_IN_K_ENABLE(m_in_k_enable_read_content_weighting),

    .M_OUT_J_ENABLE(m_out_j_enable_read_content_weighting),
    .M_OUT_K_ENABLE(m_out_k_enable_read_content_weighting),

    .C_OUT_ENABLE(c_out_enable_read_content_weighting),

    // DATA
    .SIZE_N_IN(size_n_in_read_content_weighting),
    .SIZE_W_IN(size_w_in_read_content_weighting),

    .K_IN   (k_in_read_content_weighting),
    .M_IN   (m_in_read_content_weighting),
    .BETA_IN(beta_in_read_content_weighting),

    .C_OUT(c_out_read_content_weighting)
  );

  // READ VECTORS
  model_read_vectors #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) read_vectors (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_vectors),
    .READY(ready_read_vectors),

    .M_IN_J_ENABLE(m_in_j_enable_read_vectors),
    .M_IN_K_ENABLE(m_in_k_enable_read_vectors),

    .M_OUT_J_ENABLE(m_out_j_enable_read_vectors),
    .M_OUT_K_ENABLE(m_out_k_enable_read_vectors),

    .W_IN_I_ENABLE(w_in_i_enable_read_vectors),
    .W_IN_J_ENABLE(w_in_j_enable_read_vectors),

    .W_OUT_I_ENABLE(w_out_i_enable_read_vectors),
    .W_OUT_J_ENABLE(w_out_j_enable_read_vectors),

    .R_OUT_I_ENABLE(r_out_i_enable_read_vectors),
    .R_OUT_K_ENABLE(r_out_k_enable_read_vectors),

    // DATA
    .SIZE_R_IN(size_r_in_read_vectors),
    .SIZE_N_IN(size_n_in_read_vectors),
    .SIZE_W_IN(size_w_in_read_vectors),

    .M_IN(m_in_read_vectors),
    .W_IN(w_in_read_vectors),

    .R_OUT(r_out_read_vectors)
  );

  // READ WEIGHTING
  model_read_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) read_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_weighting),
    .READY(ready_read_weighting),

    .PI_IN_I_ENABLE(pi_in_i_enable_read_weighting),
    .PI_IN_P_ENABLE(pi_in_p_enable_read_weighting),

    .PI_OUT_I_ENABLE(pi_out_i_enable_read_weighting),
    .PI_OUT_P_ENABLE(pi_out_p_enable_read_weighting),

    .B_IN_I_ENABLE(b_in_i_enable_read_weighting),
    .B_IN_J_ENABLE(b_in_j_enable_read_weighting),

    .B_OUT_I_ENABLE(b_out_i_enable_read_weighting),
    .B_OUT_J_ENABLE(b_out_j_enable_read_weighting),

    .C_IN_I_ENABLE(c_in_i_enable_read_weighting),
    .C_IN_J_ENABLE(c_in_j_enable_read_weighting),

    .C_OUT_I_ENABLE(c_out_i_enable_read_weighting),
    .C_OUT_J_ENABLE(c_out_j_enable_read_weighting),

    .F_IN_I_ENABLE(f_in_i_enable_read_weighting),
    .F_IN_J_ENABLE(f_in_j_enable_read_weighting),

    .F_OUT_I_ENABLE(f_out_i_enable_read_weighting),
    .F_OUT_J_ENABLE(f_out_j_enable_read_weighting),

    .W_OUT_I_ENABLE(w_out_i_enable_read_weighting),
    .W_OUT_J_ENABLE(w_out_j_enable_read_weighting),

    // DATA
    .SIZE_R_IN(size_r_in_read_weighting),
    .SIZE_N_IN(size_n_in_read_weighting),

    .PI_IN(pi_in_read_weighting),

    .B_IN(b_in_read_weighting),
    .C_IN(c_in_read_weighting),
    .F_IN(f_in_read_weighting),

    .W_OUT(w_out_read_weighting)
  );

  // TEMPORAL LINK MATRIX
  model_temporal_link_matrix #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) temporal_link_matrix (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_temporal_link_matrix),
    .READY(ready_temporal_link_matrix),

    .L_IN_G_ENABLE(l_in_g_enable_temporal_link_matrix),
    .L_IN_J_ENABLE(l_in_j_enable_temporal_link_matrix),

    .W_IN_ENABLE(w_in_enable_temporal_link_matrix),
    .P_IN_ENABLE(p_in_enable_temporal_link_matrix),

    .W_OUT_ENABLE(w_out_enable_temporal_link_matrix),
    .P_OUT_ENABLE(p_out_enable_temporal_link_matrix),

    .L_OUT_G_ENABLE(l_out_g_enable_temporal_link_matrix),
    .L_OUT_J_ENABLE(l_out_j_enable_temporal_link_matrix),

    // DATA
    .SIZE_N_IN(size_n_in_temporal_link_matrix),

    .L_IN(l_in_temporal_link_matrix),
    .W_IN(w_in_temporal_link_matrix),
    .P_IN(p_in_temporal_link_matrix),

    .L_OUT(l_out_temporal_link_matrix)
  );

  // USAGE VECTOR
  model_usage_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) usage_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_usage_vector),
    .READY(ready_usage_vector),

    .U_IN_ENABLE  (u_in_enable_usage_vector),
    .W_IN_ENABLE  (w_in_enable_usage_vector),
    .PSI_IN_ENABLE(psi_in_enable_usage_vector),

    .U_OUT_ENABLE  (u_out_enable_usage_vector),
    .W_OUT_ENABLE  (w_out_enable_usage_vector),
    .PSI_OUT_ENABLE(psi_out_enable_usage_vector),

    // DATA
    .SIZE_N_IN(size_n_in_usage_vector),

    .U_IN  (u_in_usage_vector),
    .W_IN  (w_in_usage_vector),
    .PSI_IN(psi_in_usage_vector),

    .U_OUT(u_out_usage_vector)
  );

  // WRITE CONTENT WEIGHTING
  model_write_content_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_content_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_content_weighting),
    .READY(ready_write_content_weighting),

    .K_IN_ENABLE(k_in_enable_write_content_weighting),

    .K_OUT_ENABLE(k_out_enable_write_content_weighting),

    .M_IN_J_ENABLE(m_in_j_enable_write_content_weighting),
    .M_IN_K_ENABLE(m_in_k_enable_write_content_weighting),

    .M_OUT_J_ENABLE(m_out_j_enable_write_content_weighting),
    .M_OUT_K_ENABLE(m_out_k_enable_write_content_weighting),

    .C_OUT_ENABLE(c_out_enable_write_content_weighting),

    // DATA
    .SIZE_N_IN(size_n_in_write_content_weighting),
    .SIZE_W_IN(size_w_in_write_content_weighting),

    .K_IN   (k_in_write_content_weighting),
    .M_IN   (m_in_write_content_weighting),
    .BETA_IN(beta_in_write_content_weighting),

    .C_OUT(c_out_content_weighting)
  );

  // WRITE WEIGHTING
  model_write_weighting #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_weighting (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_weighting),
    .READY(ready_write_weighting),

    .A_IN_ENABLE(a_in_enable_write_weighting),
    .C_IN_ENABLE(c_in_enable_write_weighting),

    .A_OUT_ENABLE(a_out_enable_write_weighting),
    .C_OUT_ENABLE(c_out_enable_write_weighting),

    .W_OUT_ENABLE(w_out_enable_write_weighting),

    // DATA
    .SIZE_N_IN(size_n_in_write_weighting),

    .A_IN(a_in_write_weighting),
    .C_IN(c_in_write_weighting),

    .GA_IN(ga_in_write_weighting),
    .GW_IN(gw_in_write_weighting),

    .W_OUT(w_out_write_weighting)
  );

endmodule
