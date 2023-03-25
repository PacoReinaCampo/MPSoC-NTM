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

module model_memory_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // SYSTEM-SIZE
  parameter DATA_SIZE = 64;
  parameter CONTROL_SIZE = 64;

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
  wire                 start_precedence_weighting;
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

  // ADDRESSING
  // CONTROL
  wire                 start_addressing;
  wire                 ready_addressing;

  wire                 k_read_in_i_enable_addressing;
  wire                 k_read_in_k_enable_addressing;

  wire                 k_read_out_i_enable_addressing;
  wire                 k_read_out_k_enable_addressing;

  wire                 beta_read_in_enable_addressing;

  wire                 beta_read_out_enable_addressing;

  wire                 f_read_in_enable_addressing;

  wire                 f_read_out_enable_addressing;

  wire                 pi_read_in_enable_addressing;

  wire                 pi_read_out_enable_addressing;

  wire                 k_write_in_k_enable_addressing;

  wire                 k_write_out_k_enable_addressing;

  wire                 e_write_in_k_enable_addressing;

  wire                 e_write_out_k_enable_addressing;

  wire                 v_write_in_k_enable_addressing;

  wire                 v_write_out_k_enable_addressing;

  wire                 r_out_i_enable_addressing;
  wire                 r_out_k_enable_addressing;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_addressing;
  wire [DATA_SIZE-1:0] size_w_in_addressing;

  wire [DATA_SIZE-1:0] k_read_in_addressing;
  wire [DATA_SIZE-1:0] beta_read_in_addressing;
  wire [DATA_SIZE-1:0] f_read_in_addressing;
  wire [DATA_SIZE-1:0] pi_read_in_addressing;

  wire [DATA_SIZE-1:0] k_write_in_addressing;
  wire [DATA_SIZE-1:0] beta_write_in_addressing;
  wire [DATA_SIZE-1:0] e_write_in_addressing;
  wire [DATA_SIZE-1:0] v_write_in_addressing;
  wire [DATA_SIZE-1:0] ga_write_in_addressing;
  wire [DATA_SIZE-1:0] gw_write_in_addressing;

  wire [DATA_SIZE-1:0] r_out_addressing;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // STIMULUS
  model_memory_stimulus #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) memory_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .DNC_MEMORY_START(start_addressing),
    .DNC_MEMORY_READY(ready_addressing),

    .DNC_MEMORY_K_READ_IN_I_ENABLE(k_read_in_i_enable_addressing),
    .DNC_MEMORY_K_READ_IN_K_ENABLE(k_read_in_k_enable_addressing),

    .DNC_MEMORY_K_READ_OUT_I_ENABLE(k_read_out_i_enable_addressing),
    .DNC_MEMORY_K_READ_OUT_K_ENABLE(k_read_out_k_enable_addressing),

    .DNC_MEMORY_BETA_READ_IN_ENABLE(beta_read_in_enable_addressing),

    .DNC_MEMORY_BETA_READ_OUT_ENABLE(beta_read_out_enable_addressing),

    .DNC_MEMORY_F_READ_IN_ENABLE(f_read_in_enable_addressing),

    .DNC_MEMORY_F_READ_OUT_ENABLE(f_read_out_enable_addressing),

    .DNC_MEMORY_PI_READ_IN_ENABLE(pi_read_in_enable_addressing),

    .DNC_MEMORY_PI_READ_OUT_ENABLE(pi_read_out_enable_addressing),

    .DNC_MEMORY_K_WRITE_IN_K_ENABLE(k_write_in_k_enable_addressing),

    .DNC_MEMORY_K_WRITE_OUT_K_ENABLE(k_write_out_k_enable_addressing),

    .DNC_MEMORY_E_WRITE_IN_K_ENABLE(e_write_in_k_enable_addressing),

    .DNC_MEMORY_E_WRITE_OUT_K_ENABLE(e_write_out_k_enable_addressing),

    .DNC_MEMORY_V_WRITE_IN_K_ENABLE(v_write_in_k_enable_addressing),

    .DNC_MEMORY_V_WRITE_OUT_K_ENABLE(v_write_out_k_enable_addressing),

    .DNC_MEMORY_R_OUT_I_ENABLE(r_out_i_enable_addressing),
    .DNC_MEMORY_R_OUT_K_ENABLE(r_out_k_enable_addressing),

    // DATA
    .DNC_MEMORY_SIZE_R_IN(size_r_in_addressing),
    .DNC_MEMORY_SIZE_W_IN(size_w_in_addressing),

    .DNC_MEMORY_K_READ_IN   (k_read_in_addressing),
    .DNC_MEMORY_BETA_READ_IN(beta_read_in_addressing),
    .DNC_MEMORY_F_READ_IN   (f_read_in_addressing),
    .DNC_MEMORY_PI_READ_IN  (pi_read_in_addressing),

    .DNC_MEMORY_K_WRITE_IN   (k_write_in_addressing),
    .DNC_MEMORY_BETA_WRITE_IN(beta_write_in_addressing),
    .DNC_MEMORY_E_WRITE_IN   (e_write_in_addressing),
    .DNC_MEMORY_V_WRITE_IN   (v_write_in_addressing),
    .DNC_MEMORY_GA_WRITE_IN  (ga_write_in_addressing),
    .DNC_MEMORY_GW_WRITE_IN  (gw_write_in_addressing),

    .DNC_MEMORY_R_OUT(r_out_addressing)
  );

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

  // ADDRESSING
  model_addressing #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) addressing (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_addressing),
    .READY(ready_addressing),

    .K_READ_IN_I_ENABLE(k_read_in_i_enable_addressing),
    .K_READ_IN_K_ENABLE(k_read_in_k_enable_addressing),

    .K_READ_OUT_I_ENABLE(k_read_out_i_enable_addressing),
    .K_READ_OUT_K_ENABLE(k_read_out_k_enable_addressing),

    .BETA_READ_IN_ENABLE(beta_read_in_enable_addressing),

    .BETA_READ_OUT_ENABLE(beta_read_out_enable_addressing),

    .F_READ_IN_ENABLE(f_read_in_enable_addressing),

    .F_READ_OUT_ENABLE(f_read_out_enable_addressing),

    .PI_READ_IN_ENABLE(pi_read_in_enable_addressing),

    .PI_READ_OUT_ENABLE(pi_read_out_enable_addressing),

    .K_WRITE_IN_K_ENABLE(k_write_in_k_enable_addressing),

    .K_WRITE_OUT_K_ENABLE(k_write_out_k_enable_addressing),

    .E_WRITE_IN_K_ENABLE(e_write_in_k_enable_addressing),

    .E_WRITE_OUT_K_ENABLE(e_write_out_k_enable_addressing),

    .V_WRITE_IN_K_ENABLE(v_write_in_k_enable_addressing),

    .V_WRITE_OUT_K_ENABLE(v_write_out_k_enable_addressing),

    .R_OUT_I_ENABLE(r_out_i_enable_addressing),
    .R_OUT_K_ENABLE(r_out_k_enable_addressing),

    // DATA
    .SIZE_R_IN(size_r_in_addressing),
    .SIZE_W_IN(size_w_in_addressing),

    .K_READ_IN   (k_read_in_addressing),
    .BETA_READ_IN(beta_read_in_addressing),
    .F_READ_IN   (f_read_in_addressing),
    .PI_READ_IN  (pi_read_in_addressing),

    .K_WRITE_IN   (k_write_in_addressing),
    .BETA_WRITE_IN(beta_write_in_addressing),
    .E_WRITE_IN   (e_write_in_addressing),
    .V_WRITE_IN   (v_write_in_addressing),
    .GA_WRITE_IN  (ga_write_in_addressing),
    .GW_WRITE_IN  (gw_write_in_addressing),

    .R_OUT(r_out_addressing)
  );

endmodule
