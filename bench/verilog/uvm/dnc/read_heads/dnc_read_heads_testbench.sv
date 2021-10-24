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

module dnc_read_heads_testbench;

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

  // FREE GATES
  // CONTROL
  wire f_in_enable_free_gates;
  wire f_out_enable_free_gates;
  wire start_free_gates;
  wire ready_free_gates;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_free_gates;
  wire [DATA_SIZE-1:0] f_in_free_gates;
  wire f_out_free_gates;

  // READ KEYS
  // CONTROL
  wire k_in_i_enable_read_keys;
  wire k_in_k_enable_read_keys;
  wire k_out_i_enable_read_keys;
  wire k_out_k_enable_read_keys;
  wire start_read_keys;
  wire ready_read_keys;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_keys;
  wire [DATA_SIZE-1:0] size_w_in_read_keys;
  wire [DATA_SIZE-1:0] k_in_read_keys;
  wire [DATA_SIZE-1:0] k_out_read_keys;

  // READ MODES
  // CONTROL
  wire pi_in_i_enable_read_modes;
  wire pi_in_p_enable_read_modes;
  wire pi_out_i_enable_read_modes;
  wire pi_out_p_enable_read_modes;
  wire start_read_modes;
  wire ready_read_modes;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_modes;
  wire [DATA_SIZE-1:0] pi_in_read_modes;
  wire [DATA_SIZE-1:0] pi_out_read_modes;

  // READ STRENGTHS
  // CONTROL
  wire beta_in_enable_read_strengths;
  wire beta_out_enable_read_strengths;
  wire start_read_strengths;
  wire ready_read_strengths;

  // DATA
  wire [DATA_SIZE-1:0] size_r_in_read_strengths;
  wire [DATA_SIZE-1:0] beta_in_read_strengths;
  wire [DATA_SIZE-1:0] beta_out_read_strengths;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // FREE GATES
  dnc_free_gates #(
    .DATA_SIZE(DATA_SIZE)
  )
  free_gates(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_free_gates),
    .READY(ready_free_gates),

    .F_IN_ENABLE(f_in_enable_free_gates),
    .F_OUT_ENABLE(f_out_enable_free_gates),

    // DATA
    .SIZE_R_IN(size_r_in_free_gates),
    .F_IN(f_in_free_gates),
    .F_OUT(f_out_free_gates)
  );

  // READ KEYS
  dnc_read_keys #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_keys(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_keys),
    .READY(ready_read_keys),

    .K_IN_I_ENABLE(k_in_i_enable_read_keys),
    .K_IN_K_ENABLE(k_in_k_enable_read_keys),
    .K_OUT_I_ENABLE(k_out_i_enable_read_keys),
    .K_OUT_K_ENABLE(k_out_k_enable_read_keys),

    // DATA
    .SIZE_R_IN(size_r_in_read_keys),
    .SIZE_W_IN(size_w_in_read_keys),
    .K_IN(k_in_read_keys),
    .K_OUT(k_out_read_keys)
  );

  // READ MODES
  dnc_read_modes #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_modes(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_modes),
    .READY(ready_read_modes),

    .PI_IN_I_ENABLE(pi_in_i_enable_read_modes),
    .PI_IN_P_ENABLE(pi_in_p_enable_read_modes),
    .PI_OUT_I_ENABLE(pi_out_i_enable_read_modes),
    .PI_OUT_P_ENABLE(pi_out_p_enable_read_modes),

    // DATA
    .SIZE_R_IN(size_r_in_free_gates),
    .PI_IN(pi_in_read_modes),
    .PI_OUT(pi_out_read_modes)
  );

  // READ STRENGTHS
  dnc_read_strengths #(
    .DATA_SIZE(DATA_SIZE)
  )
  read_strengths(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_read_strengths),
    .READY(ready_read_strengths),

    .BETA_IN_ENABLE(beta_in_enable_read_strengths),
    .BETA_OUT_ENABLE(beta_out_enable_read_strengths),

    // DATA
    .SIZE_R_IN(size_r_in_free_gates),
    .BETA_IN(beta_in_read_strengths),
    .BETA_OUT(beta_out_read_strengths)
  );

endmodule
