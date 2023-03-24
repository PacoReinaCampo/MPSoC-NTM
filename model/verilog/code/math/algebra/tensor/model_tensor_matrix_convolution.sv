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

module model_tensor_matrix_convolution #(
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

  output reg DATA_OUT_I_ENABLE,
  output reg DATA_OUT_J_ENABLE,
  output reg DATA_OUT_K_ENABLE,

  // DATA
  input [DATA_SIZE-1:0] SIZE_A_I_IN,
  input [DATA_SIZE-1:0] SIZE_A_J_IN,
  input [DATA_SIZE-1:0] SIZE_A_K_IN,
  input [DATA_SIZE-1:0] SIZE_B_I_IN,
  input [DATA_SIZE-1:0] SIZE_B_J_IN,
  input [DATA_SIZE-1:0] DATA_A_IN,
  input [DATA_SIZE-1:0] DATA_B_IN,

  output reg [DATA_SIZE-1:0] DATA_OUT
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

  // SCALAR ADDER
  // CONTROL
  wire                 start_scalar_float_adder;
  wire                 ready_scalar_float_adder;
  wire                 operation_scalar_float_adder;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_float_adder;
  wire [DATA_SIZE-1:0] data_b_in_scalar_float_adder;
  wire [DATA_SIZE-1:0] data_out_scalar_float_adder;

  // SCALAR MULTIPLIER
  // CONTROL
  wire                 start_scalar_float_multiplier;
  wire                 ready_scalar_float_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] data_a_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_scalar_float_multiplier;
  wire [DATA_SIZE-1:0] data_out_scalar_float_multiplier;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // SCALAR ADDER
  model_scalar_float_adder #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_adder (
    // GLOBAL
    .CLK  (CLK),
    .RST  (RST),
    // CONTROL
    .START(start_scalar_float_adder),
    .READY(ready_scalar_float_adder),

    .OPERATION(operation_scalar_float_adder),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_adder),
    .DATA_B_IN(data_b_in_scalar_float_adder),
    .DATA_OUT (data_out_scalar_float_adder)
  );

  // SCALAR MULTIPLIER
  model_scalar_float_multiplier #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) scalar_float_multiplier (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_float_multiplier),
    .READY(ready_scalar_float_multiplier),

    // DATA
    .DATA_A_IN(data_a_in_scalar_float_multiplier),
    .DATA_B_IN(data_b_in_scalar_float_multiplier),
    .DATA_OUT (data_out_scalar_float_multiplier)
  );

endmodule
