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

module model_tensor_fixed_divider #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input      START,
  output reg READY,

  input DATA_A_IN_I_ENABLE,
  input DATA_A_IN_J_ENABLE,
  input DATA_A_IN_K_ENABLE,
  input DATA_B_IN_I_ENABLE,
  input DATA_B_IN_J_ENABLE,
  input DATA_B_IN_K_ENABLE,

  output reg DATA_OUT_I_ENABLE,
  output reg DATA_OUT_J_ENABLE,
  output reg DATA_OUT_K_ENABLE,

  // DATA
  input [DATA_SIZE-1:0] SIZE_A_I_IN,
  input [DATA_SIZE-1:0] SIZE_A_J_IN,
  input [DATA_SIZE-1:0] SIZE_A_K_IN,
  input [DATA_SIZE-1:0] SIZE_B_I_IN,
  input [DATA_SIZE-1:0] SIZE_B_J_IN,
  input [DATA_SIZE-1:0] SIZE_B_K_IN,
  input [DATA_SIZE-1:0] DATA_A_IN,
  input [DATA_SIZE-1:0] DATA_B_IN,

  output reg [DATA_SIZE-1:0] DATA_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] INPUT_I_STATE = 1;
  parameter [1:0] INPUT_J_STATE = 2;
  parameter [1:0] ENDER_STATE = 3;

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
  reg  [             1:0] divider_ctrl_fsm_int;

  // Data Internal
  reg  [CONTROL_SIZE-1:0] index_i_loop;
  reg  [CONTROL_SIZE-1:0] index_j_loop;

  reg                     data_a_in_i_divider_int;
  reg                     data_a_in_j_divider_int;
  reg                     data_b_in_i_divider_int;
  reg                     data_b_in_j_divider_int;

  // DIVIDER
  // CONTROL
  reg                     start_vector_fixed_divider;
  wire                    ready_vector_fixed_divider;
  reg                     data_a_in_enable_vector_fixed_divider;
  reg                     data_b_in_enable_vector_fixed_divider;
  wire                    data_out_enable_vector_fixed_divider;

  // DATA
  reg  [   DATA_SIZE-1:0] size_in_vector_fixed_divider;
  reg  [   DATA_SIZE-1:0] data_a_in_vector_fixed_divider;
  reg  [   DATA_SIZE-1:0] data_b_in_vector_fixed_divider;
  wire [   DATA_SIZE-1:0] data_out_vector_fixed_divider;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // DATA_OUT = DATA_A_IN / DATA_B_IN = M_A_IN / M_B_IN · 2^(E_A_IN - E_B_IN)

  // CONTROL

  // DIVIDER
  model_vector_fixed_divider #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_fixed_divider (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START           (start_vector_fixed_divider),
    .READY           (ready_vector_fixed_divider),
    .DATA_A_IN_ENABLE(data_a_in_enable_vector_fixed_divider),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_fixed_divider),
    .DATA_OUT_ENABLE (data_out_enable_vector_fixed_divider),

    // DATA
    .SIZE_IN  (size_in_vector_fixed_divider),
    .DATA_A_IN(data_a_in_vector_fixed_divider),
    .DATA_B_IN(data_b_in_vector_fixed_divider),
    .DATA_OUT (data_out_vector_fixed_divider)
  );

endmodule
