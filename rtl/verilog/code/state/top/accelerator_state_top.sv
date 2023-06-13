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

module accelerator_state_top #(
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
  input DATA_B_IN_I_ENABLE,
  input DATA_B_IN_J_ENABLE,
  input DATA_C_IN_I_ENABLE,
  input DATA_C_IN_J_ENABLE,
  input DATA_D_IN_I_ENABLE,
  input DATA_D_IN_J_ENABLE,

  input DATA_U_IN_ENABLE,

  output reg DATA_X_OUT_ENABLE,
  output reg DATA_Y_OUT_ENABLE,

  // DATA
  input [DATA_SIZE-1:0] SIZE_A_I_IN,
  input [DATA_SIZE-1:0] SIZE_A_J_IN,
  input [DATA_SIZE-1:0] SIZE_B_I_IN,
  input [DATA_SIZE-1:0] SIZE_B_J_IN,
  input [DATA_SIZE-1:0] SIZE_C_I_IN,
  input [DATA_SIZE-1:0] SIZE_C_J_IN,
  input [DATA_SIZE-1:0] SIZE_D_I_IN,
  input [DATA_SIZE-1:0] SIZE_D_J_IN,

  input [DATA_SIZE-1:0] DATA_A_IN,
  input [DATA_SIZE-1:0] DATA_B_IN,
  input [DATA_SIZE-1:0] DATA_C_IN,
  input [DATA_SIZE-1:0] DATA_D_IN,

  input [DATA_SIZE-1:0] DATA_U_IN,

  output reg [DATA_SIZE-1:0] DATA_X_OUT,
  output reg [DATA_SIZE-1:0] DATA_Y_OUT
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

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // u(k) = -K·y(k) + r(k)

  // x(k+1) = a·x(k) + b·r(k)
  // y(k) = c·x(k) + d·r(k)

  // x(k) = exp(a,k)·x(0) + summation(exp(a,k-j-1)·b·u(j))[j in 0 to k-1]
  // y(k) = c·exp(a,k)·x(0) + summation(c·exp(a,k-j)·b·u(j))[j in 0 to k-1] + d·u(k)

  // SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P]; K[P,P]; x[N,1]; y[Q,1]; u[P,1];

  // CONTROL

endmodule
