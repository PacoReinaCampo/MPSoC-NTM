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

module model_read_modes #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input  START,
  output READY,

  input  PI_IN_I_ENABLE,   // for i in 0 to R-1
  input  PI_IN_P_ENABLE,   // for i in 0 to 2
  output PI_OUT_I_ENABLE,  // for i in 0 to R-1
  output PI_OUT_P_ENABLE,  // for i in 0 to 2

  // DATA
  input  [DATA_SIZE-1:0] SIZE_R_IN,
  input  [DATA_SIZE-1:0] PI_IN,
  output [DATA_SIZE-1:0] PI_OUT
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

  // VECTOR SOFTMAX
  // CONTROL
  wire                 start_vector_softmax;
  wire                 ready_vector_softmax;

  wire                 data_in_vector_enable_vector_softmax;
  wire                 data_in_scalar_enable_vector_softmax;
  wire                 data_out_vector_enable_vector_softmax;
  wire                 data_out_scalar_enable_vector_softmax;

  // DATA
  wire [DATA_SIZE-1:0] length_in_vector_softmax;
  wire [DATA_SIZE-1:0] size_in_vector_softmax;
  wire [DATA_SIZE-1:0] data_in_vector_softmax;
  wire [DATA_SIZE-1:0] data_out_vector_softmax;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // pi(t;i;p) = softmax(pi^(t;i;p))

  // ASSIGNATIONS
  // CONTROL
  assign start_vector_softmax                 = START;
  assign READY                                = ready_vector_softmax;
  assign data_in_vector_enable_vector_softmax = PI_IN_I_ENABLE;
  assign data_in_scalar_enable_vector_softmax = PI_IN_P_ENABLE;
  assign PI_OUT_I_ENABLE                      = data_out_vector_enable_vector_softmax;
  assign PI_OUT_P_ENABLE                      = data_out_scalar_enable_vector_softmax;

  // DATA
  assign length_in_vector_softmax             = THREE_DATA;
  assign size_in_vector_softmax               = SIZE_R_IN;
  assign data_in_vector_softmax               = PI_IN;
  assign PI_OUT                               = data_out_vector_softmax;

  // VECTOR SOFTMAX
  model_vector_softmax #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_softmax (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_softmax),
    .READY(ready_vector_softmax),

    .DATA_IN_VECTOR_ENABLE (data_in_vector_enable_vector_softmax),
    .DATA_IN_SCALAR_ENABLE (data_in_scalar_enable_vector_softmax),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_softmax),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_softmax),

    // DATA
    .SIZE_IN  (size_in_vector_softmax),
    .LENGTH_IN(length_in_vector_softmax),
    .DATA_IN  (data_in_vector_softmax),
    .DATA_OUT (data_out_vector_softmax)
  );

endmodule
