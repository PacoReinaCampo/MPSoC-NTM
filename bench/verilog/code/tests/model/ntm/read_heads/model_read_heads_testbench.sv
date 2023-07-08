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

module model_read_heads_testbench;

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

  // READING
  // CONTROL
  wire                 start_reading;
  wire                 ready_reading;

  wire                 m_in_j_enable_reading;
  wire                 m_in_k_enable_reading;

  wire                 m_out_j_enable_reading;
  wire                 m_out_k_enable_reading;

  wire                 r_out_enable_reading;

  // DATA
  wire [DATA_SIZE-1:0] size_n_in_reading;
  wire [DATA_SIZE-1:0] size_w_in_reading;

  wire [DATA_SIZE-1:0] w_in_reading;
  wire [DATA_SIZE-1:0] m_in_reading;

  wire [DATA_SIZE-1:0] r_out_reading;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // STIMULUS
  model_read_heads_stimulus #(
    // SYSTEM-SIZE
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE),

    .X(X),
    .Y(Y),
    .N(N),
    .W(W),
    .L(L),
    .R(R)
  ) read_heads_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .NTM_READ_HEADS_START(start_reading),
    .NTM_READ_HEADS_READY(ready_reading),

    .NTM_READ_HEADS_M_IN_J_ENABLE(m_in_j_enable_reading),
    .NTM_READ_HEADS_M_IN_K_ENABLE(m_in_k_enable_reading),

    .NTM_READ_HEADS_M_OUT_J_ENABLE(m_out_j_enable_reading),
    .NTM_READ_HEADS_M_OUT_K_ENABLE(m_out_k_enable_reading),

    .NTM_READ_HEADS_R_OUT_ENABLE(r_out_enable_reading),

    // DATA
    .NTM_READ_HEADS_SIZE_N_IN(size_n_in_reading),
    .NTM_READ_HEADS_SIZE_W_IN(size_w_in_reading),

    .NTM_READ_HEADS_W_IN(w_in_reading),
    .NTM_READ_HEADS_M_IN(m_in_reading),

    .NTM_READ_HEADS_R_OUT(r_out_reading)
  );

  // READING
  model_reading #(
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

endmodule
