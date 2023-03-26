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

module model_write_heads_testbench;

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

  // ALLOCATION GATE
  // CONTROL
  wire                 start_allocation_gate;
  wire                 ready_allocation_gate;

  // DATA
  wire [DATA_SIZE-1:0] ga_in_allocation_gate;
  wire                 ga_out_allocation_gate;

  // ERASE VECTOR
  // CONTROL
  wire                 start_erase_vector;
  wire                 ready_erase_vector;

  wire                 e_in_enable_erase_vector;
  wire                 e_out_enable_erase_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_erase_vector;
  wire [DATA_SIZE-1:0] e_in_erase_vector;
  wire                 e_out_erase_vector;

  // WRITE GATE
  // CONTROL
  wire                 start_write_gate;
  wire                 ready_write_gate;

  // DATA
  wire [DATA_SIZE-1:0] gw_in_write_gate;
  wire                 gw_out_write_gate;

  // WRITE KEY
  // CONTROL
  wire                 start_write_key;
  wire                 ready_write_key;

  wire                 k_in_enable_write_key;
  wire                 k_out_enable_write_key;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_write_key;
  wire [DATA_SIZE-1:0] k_in_write_key;
  wire [DATA_SIZE-1:0] k_out_write_key;

  // WRITE STRENGHT
  // CONTROL
  wire                 start_write_strength;
  wire                 ready_write_strength;

  // DATA
  wire [DATA_SIZE-1:0] beta_in_write_strength;
  wire [DATA_SIZE-1:0] beta_out_write_strength;

  // WRITE VECTOR
  // CONTROL
  wire                 start_write_vector;
  wire                 ready_write_vector;

  wire                 v_in_enable_write_vector;
  wire                 v_out_enable_write_vector;

  // DATA
  wire [DATA_SIZE-1:0] size_w_in_write_vector;
  wire [DATA_SIZE-1:0] v_in_write_vector;
  wire [DATA_SIZE-1:0] v_out_write_vector;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // STIMULUS
  model_write_heads_stimulus #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_heads_stimulus (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // ALLOCATION GATE
    // CONTROL
    .NTM_ALLOCATION_GATE_START(start_allocation_gate),
    .NTM_ALLOCATION_GATE_READY(ready_allocation_gate),

    // DATA
    .NTM_ALLOCATION_GATE_GA_IN (ga_in_allocation_gate),
    .NTM_ALLOCATION_GATE_GA_OUT(ga_out_allocation_gate),

    // ERASE VECTOR
    // CONTROL
    .NTM_ERASE_VECTOR_START(start_erase_vector),
    .NTM_ERASE_VECTOR_READY(ready_erase_vector),

    .NTM_ERASE_VECTOR_E_IN_ENABLE (e_in_enable_erase_vector),
    .NTM_ERASE_VECTOR_E_OUT_ENABLE(e_out_enable_erase_vector),

    // DATA
    .NTM_ERASE_VECTOR_SIZE_W_IN(size_w_in_erase_vector),
    .NTM_ERASE_VECTOR_E_IN     (e_in_erase_vector),
    .NTM_ERASE_VECTOR_E_OUT    (e_out_erase_vector),

    //WRITE GATE
    // CONTROL
    .NTM_WRITE_GATE_START(start_write_gate),
    .NTM_WRITE_GATE_READY(ready_write_gate),

    // DATA
    .NTM_WRITE_GATE_GW_IN (gw_in_write_gate),
    .NTM_WRITE_GATE_GW_OUT(gw_out_write_gate),

    // WRITE KEY
    // CONTROL
    .NTM_WRITE_KEY_START(start_write_key),
    .NTM_WRITE_KEY_READY(ready_write_key),

    .NTM_WRITE_KEY_K_IN_ENABLE (k_in_enable_write_key),
    .NTM_WRITE_KEY_K_OUT_ENABLE(k_out_enable_write_key),

    // DATA
    .NTM_WRITE_KEY_SIZE_W_IN(size_w_in_write_key),
    .NTM_WRITE_KEY_K_IN     (k_in_write_key),
    .NTM_WRITE_KEY_K_OUT    (k_out_write_key),

    // WRITE STRENGTH
    // CONTROL
    .NTM_WRITE_STRENGTH_START(start_write_strength),
    .NTM_WRITE_STRENGTH_READY(ready_write_strength),

    // DATA
    .NTM_WRITE_STRENGTH_BETA_IN (beta_in_write_strength),
    .NTM_WRITE_STRENGTH_BETA_OUT(beta_out_write_strength),

    // WRITE VECTOR
    // CONTROL
    .NTM_WRITE_VECTOR_START(start_write_vector),
    .NTM_WRITE_VECTOR_READY(ready_write_vector),

    .NTM_WRITE_VECTOR_V_IN_ENABLE (v_in_enable_write_vector),
    .NTM_WRITE_VECTOR_V_OUT_ENABLE(v_out_enable_write_vector),

    // DATA
    .NTM_WRITE_VECTOR_SIZE_W_IN(size_w_in_write_vector),
    .NTM_WRITE_VECTOR_V_IN     (v_in_write_vector),
    .NTM_WRITE_VECTOR_V_OUT    (v_out_write_vector)
  );

  // ALLOCATION GATE
  model_allocation_gate #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) allocation_gate (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_allocation_gate),
    .READY(ready_allocation_gate),

    // DATA
    .GA_IN (ga_in_allocation_gate),
    .GA_OUT(ga_out_allocation_gate)
  );

  // ERASE VECTOR
  model_erase_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) erase_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_erase_vector),
    .READY(ready_erase_vector),

    .E_IN_ENABLE (e_in_enable_erase_vector),
    .E_OUT_ENABLE(e_out_enable_erase_vector),

    // DATA
    .SIZE_W_IN(size_w_in_erase_vector),
    .E_IN     (e_in_erase_vector),
    .E_OUT    (e_out_erase_vector)
  );

  // WRITE GATE
  model_write_gate #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_gate (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_gate),
    .READY(ready_write_gate),

    // DATA
    .GW_IN (gw_in_write_gate),
    .GW_OUT(gw_out_write_gate)
  );

  // WRITE KEY
  model_write_key #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_key (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_key),
    .READY(ready_write_key),

    .K_IN_ENABLE (k_in_enable_write_key),
    .K_OUT_ENABLE(k_out_enable_write_key),

    // DATA
    .SIZE_W_IN(size_w_in_write_key),
    .K_IN     (k_in_write_key),
    .K_OUT    (k_out_write_key)
  );

  // WRITE STRENGTH
  model_write_strength #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_strength (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_strength),
    .READY(ready_write_strength),

    // DATA
    .BETA_IN (beta_in_write_strength),
    .BETA_OUT(beta_out_write_strength)
  );

  // WRITE VECTOR
  model_write_vector #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) write_vector (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_write_vector),
    .READY(ready_write_vector),

    .V_IN_ENABLE (v_in_enable_write_vector),
    .V_OUT_ENABLE(v_out_enable_write_vector),

    // DATA
    .SIZE_W_IN(size_w_in_write_vector),
    .V_IN     (v_in_write_vector),
    .V_OUT    (v_out_write_vector)
  );

endmodule
