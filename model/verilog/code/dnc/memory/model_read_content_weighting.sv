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

module model_read_content_weighting #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input  START,
  output READY,

  input K_IN_ENABLE,  // for k in 0 to W-1

  output K_OUT_ENABLE,  // for k in 0 to W-1

  input M_IN_J_ENABLE,  // for j in 0 to N-1
  input M_IN_K_ENABLE,  // for k in 0 to W-1

  output M_OUT_J_ENABLE,  // for j in 0 to N-1
  output M_OUT_K_ENABLE,  // for k in 0 to W-1

  output C_OUT_ENABLE,  // for j in 0 to N-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_N_IN,
  input [DATA_SIZE-1:0] SIZE_W_IN,

  input [DATA_SIZE-1:0] K_IN,
  input [DATA_SIZE-1:0] M_IN,
  input [DATA_SIZE-1:0] BETA_IN,

  output [DATA_SIZE-1:0] C_OUT
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

  // VECTOR CONTENT BASED ADDRESSING
  // CONTROL
  wire                 start_vector_content_based_addressing;
  wire                 ready_vector_content_based_addressing;

  wire                 k_in_enable_vector_content_based_addressing;

  wire                 k_out_enable_vector_content_based_addressing;

  wire                 m_in_i_enable_vector_content_based_addressing;
  wire                 m_in_j_enable_vector_content_based_addressing;

  wire                 m_out_i_enable_vector_content_based_addressing;
  wire                 m_out_j_enable_vector_content_based_addressing;

  wire                 c_out_enable_vector_content_based_addressing;

  // DATA
  wire [DATA_SIZE-1:0] size_i_in_vector_content_based_addressing;
  wire [DATA_SIZE-1:0] size_j_in_vector_content_based_addressing;

  wire [DATA_SIZE-1:0] k_in_vector_content_based_addressing;
  wire [DATA_SIZE-1:0] m_in_vector_content_based_addressing;
  wire [DATA_SIZE-1:0] beta_in_vector_content_based_addressing;

  wire [DATA_SIZE-1:0] c_out_vector_content_based_addressing;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

  // ASSIGNATIONS
  // CONTROL
  assign start_vector_content_based_addressing         = START;

  assign READY                                         = ready_vector_content_based_addressing;

  assign k_in_enable_vector_content_based_addressing   = K_IN_ENABLE;

  assign K_OUT_ENABLE                                  = k_out_enable_vector_content_based_addressing;

  assign m_in_i_enable_vector_content_based_addressing = M_IN_J_ENABLE;
  assign m_in_j_enable_vector_content_based_addressing = M_IN_K_ENABLE;

  assign M_OUT_J_ENABLE                                = m_out_i_enable_vector_content_based_addressing;
  assign M_OUT_K_ENABLE                                = m_out_j_enable_vector_content_based_addressing;

  assign C_OUT_ENABLE                                  = c_out_enable_vector_content_based_addressing;

  // DATA
  assign size_i_in_vector_content_based_addressing     = SIZE_N_IN;
  assign size_j_in_vector_content_based_addressing     = SIZE_N_IN;

  assign k_in_vector_content_based_addressing          = K_IN;
  assign m_in_vector_content_based_addressing          = M_IN;
  assign beta_in_vector_content_based_addressing       = BETA_IN;

  assign C_OUT                                         = c_out_vector_content_based_addressing;

  // VECTOR CONTENT BASED ADDRESSING
  model_content_based_addressing #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) model_content_based_addressing_i (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_content_based_addressing),
    .READY(ready_vector_content_based_addressing),

    .K_IN_ENABLE(k_in_enable_vector_content_based_addressing),

    .K_OUT_ENABLE(k_out_enable_vector_content_based_addressing),

    .M_IN_I_ENABLE(m_in_i_enable_vector_content_based_addressing),
    .M_IN_J_ENABLE(m_in_j_enable_vector_content_based_addressing),

    .M_OUT_I_ENABLE(m_out_i_enable_vector_content_based_addressing),
    .M_OUT_J_ENABLE(m_out_j_enable_vector_content_based_addressing),

    .C_OUT_ENABLE(c_out_enable_vector_content_based_addressing),

    // DATA
    .SIZE_I_IN(size_i_in_vector_content_based_addressing),
    .SIZE_J_IN(size_j_in_vector_content_based_addressing),

    .K_IN   (k_in_vector_content_based_addressing),
    .M_IN   (m_in_vector_content_based_addressing),
    .BETA_IN(beta_in_vector_content_based_addressing),

    .C_OUT(c_out_vector_content_based_addressing)
  );

endmodule
