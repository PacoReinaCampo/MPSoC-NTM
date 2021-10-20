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

module dnc_write_strength(
  CLK,
  RST,
  START,
  READY,
  BETA_IN,
  BETA_OUT
);

  parameter DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output READY;

  // DATA
  input [DATA_SIZE-1:0] BETA_IN;
  output [DATA_SIZE-1:0] BETA_OUT;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // SCALAR ONEPLUS
  // CONTROL
  wire start_scalar_oneplus;
  wire ready_scalar_oneplus;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_scalar_oneplus;
  wire [DATA_SIZE-1:0] data_in_scalar_oneplus;
  wire [DATA_SIZE-1:0] data_out_scalar_oneplus;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // beta(t) = oneplus(beta^(t))

  // ASSIGNATIONS
  // CONTROL
  assign start_scalar_oneplus = START;
  assign READY = ready_scalar_oneplus;

  // DATA
  assign data_in_scalar_oneplus = BETA_IN;
  assign BETA_OUT = data_out_scalar_oneplus;

  // SCALAR ONEPLUS
  ntm_scalar_oneplus_function #(
    .DATA_SIZE(DATA_SIZE))
  ntm_scalar_oneplus_function_i(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_scalar_oneplus),
    .READY(ready_scalar_oneplus),

    // DATA
    .MODULO_IN(modulo_in_scalar_oneplus),
    .DATA_IN(data_in_scalar_oneplus),
    .DATA_OUT(data_out_scalar_oneplus)
  );

endmodule