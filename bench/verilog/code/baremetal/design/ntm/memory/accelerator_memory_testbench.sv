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

module accelerator_memory_testbench;

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

  // ADDRESSING
  // CONTROL
  wire                 start_addressing;
  wire                 ready_addressing;

  wire                 k_in_enable_addressing;
  wire                 s_in_enable_addressing;

  wire                 k_out_enable_addressing;
  wire                 s_out_enable_addressing;

  wire                 m_in_j_enable_addressing;
  wire                 m_in_k_enable_addressing;

  wire                 m_out_j_enable_addressing;
  wire                 m_out_k_enable_addressing;

  wire                 w_in_enable_addressing;
  wire                 w_out_enable_addressing;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_addressing;
  wire [DATA_SIZE-1:0] size_w_in_addressing;

  wire [DATA_SIZE-1:0] k_in_addressing;
  wire [DATA_SIZE-1:0] beta_in_addressing;
  wire [DATA_SIZE-1:0] g_in_addressing;
  wire [DATA_SIZE-1:0] s_in_addressing;
  wire [DATA_SIZE-1:0] gamma_in_addressing;

  wire [DATA_SIZE-1:0] m_in_addressing;
  wire [DATA_SIZE-1:0] w_in_addressing;

  wire [DATA_SIZE-1:0] w_out_addressing;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // STIMULUS
  accelerator_memory_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R)
  ) memory_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .ACCELERATOR_MEMORY_START(start_addressing),
    .ACCELERATOR_MEMORY_READY(ready_addressing),

    .ACCELERATOR_MEMORY_K_IN_ENABLE(k_in_enable_addressing),
    .ACCELERATOR_MEMORY_S_IN_ENABLE(s_in_enable_addressing),

    .ACCELERATOR_MEMORY_K_OUT_ENABLE(k_out_enable_addressing),
    .ACCELERATOR_MEMORY_S_OUT_ENABLE(s_out_enable_addressing),

    .ACCELERATOR_MEMORY_M_IN_J_ENABLE(m_in_j_enable_addressing),
    .ACCELERATOR_MEMORY_M_IN_K_ENABLE(m_in_k_enable_addressing),

    .ACCELERATOR_MEMORY_M_OUT_J_ENABLE(m_out_j_enable_addressing),
    .ACCELERATOR_MEMORY_M_OUT_K_ENABLE(m_out_k_enable_addressing),

    .ACCELERATOR_MEMORY_W_IN_ENABLE (w_in_enable_addressing),
    .ACCELERATOR_MEMORY_W_OUT_ENABLE(w_out_enable_addressing),

    // DATA
    .ACCELERATOR_MEMORY_SIZE_N_IN(size_n_in_addressing),
    .ACCELERATOR_MEMORY_SIZE_W_IN(size_w_in_addressing),

    .ACCELERATOR_MEMORY_K_IN    (k_in_addressing),
    .ACCELERATOR_MEMORY_BETA_IN (beta_in_addressing),
    .ACCELERATOR_MEMORY_G_IN    (g_in_addressing),
    .ACCELERATOR_MEMORY_S_IN    (s_in_addressing),
    .ACCELERATOR_MEMORY_GAMMA_IN(gamma_in_addressing),

    .ACCELERATOR_MEMORY_M_IN(m_in_addressing),
    .ACCELERATOR_MEMORY_W_IN(w_in_addressing),

    .ACCELERATOR_MEMORY_W_OUT(w_out_addressing)
  );

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
