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

module model_erase_vector #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input  START,
  output READY,
  input  E_IN_ENABLE,  // for k in 0 to W-1
  output E_OUT_ENABLE, // for k in 0 to W-1

  // DATA
  input      [DATA_SIZE-1:0] SIZE_W_IN,
  input      [DATA_SIZE-1:0] E_IN,
  output reg [DATA_SIZE-1:0] E_OUT
);

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

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

  // VECTOR LOGISTIC
  // CONTROL
  wire                 start_vector_logistic;
  wire                 ready_vector_logistic;
  wire                 data_in_enable_vector_logistic;
  wire                 data_out_enable_vector_logistic;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_out_vector_logistic;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // e(t;k) = sigmoid(e^(t;k))

  // ASSIGNATIONS
  // CONTROL
  assign start_vector_logistic          = START;
  assign READY                          = ready_vector_logistic;
  assign data_in_enable_vector_logistic = E_IN_ENABLE;
  assign E_OUT_ENABLE                   = data_out_enable_vector_logistic;

  // DATA
  assign size_in_vector_logistic        = SIZE_W_IN;
  assign data_in_vector_logistic        = E_IN;
  assign E_OUT                          = data_out_vector_logistic;

  // VECTOR LOGISTIC
  model_vector_logistic_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_logistic_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START          (start_vector_logistic),
    .READY          (ready_vector_logistic),
    .DATA_IN_ENABLE (data_in_enable_vector_logistic),
    .DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .SIZE_IN (size_in_vector_logistic),
    .DATA_IN (data_in_vector_logistic),
    .DATA_OUT(data_out_vector_logistic)
  );

endmodule
