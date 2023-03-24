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

module model_read_strengths #(
  parameter DATA_SIZE    = 64,
  parameter CONTROL_SIZE = 64
) (
  // GLOBAL
  input CLK,
  input RST,

  // CONTROL
  input  START,
  output READY,

  input  BETA_IN_ENABLE,  // for i in 0 to R-1
  output BETA_OUT_ENABLE, // for i in 0 to R-1

  // DATA
  input  [DATA_SIZE-1:0] SIZE_R_IN,
  input  [DATA_SIZE-1:0] BETA_IN,
  output [DATA_SIZE-1:0] BETA_OUT
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

  // VECTOR ONE_CONTROLPLUS
  // CONTROL
  wire                 start_vector_oneplus;
  wire                 ready_vector_oneplus;
  wire                 data_in_enable_vector_oneplus;
  wire                 data_out_enable_vector_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] size_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_in_vector_oneplus;
  wire [DATA_SIZE-1:0] data_out_vector_oneplus;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // beta(t;i) = oneplus(beta^(t;i))

  // ASSIGNATIONS
  // CONTROL
  assign start_vector_oneplus          = START;
  assign READY                         = ready_vector_oneplus;
  assign data_in_enable_vector_oneplus = BETA_IN_ENABLE;
  assign BETA_OUT_ENABLE               = data_out_enable_vector_oneplus;

  // DATA
  assign size_in_vector_oneplus        = SIZE_R_IN;
  assign data_in_vector_oneplus        = BETA_IN;
  assign BETA_OUT                      = data_out_vector_oneplus;

  // VECTOR ONE_CONTROLPLUS
  model_vector_oneplus_function #(
    .DATA_SIZE   (DATA_SIZE),
    .CONTROL_SIZE(CONTROL_SIZE)
  ) vector_oneplus_function (
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_oneplus),
    .READY(ready_vector_oneplus),

    .DATA_IN_ENABLE (data_in_enable_vector_oneplus),
    .DATA_OUT_ENABLE(data_out_enable_vector_oneplus),

    // DATA
    .SIZE_IN (size_in_vector_oneplus),
    .DATA_IN (data_in_vector_oneplus),
    .DATA_OUT(data_out_vector_oneplus)
  );

endmodule
