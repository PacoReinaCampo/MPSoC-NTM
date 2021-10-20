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

module ntm_controller(
  CLK,
  RST,
  START,
  READY,
  W_IN_L_ENABLE,
  W_IN_X_ENABLE,
  K_IN_I_ENABLE,
  K_IN_L_ENABLE,
  K_IN_K_ENABLE,
  B_IN_ENABLE,
  X_IN_ENABLE,
  R_IN_I_ENABLE,
  R_IN_K_ENABLE,
  H_OUT_ENABLE,
  SIZE_X_IN,
  SIZE_W_IN,
  SIZE_L_IN,
  SIZE_R_IN,
  W_IN,
  K_IN,
  B_IN,
  X_IN,
  R_IN,
  H_OUT
);

  parameter DATA_SIZE=512;

  // GLOBAL
  input CLK;
  input RST;

  // CONTROL
  input START;
  output READY;

  input W_IN_L_ENABLE;  // for l in 0 to L-1
  input W_IN_X_ENABLE;  // for x in 0 to X-1
  input K_IN_I_ENABLE;  // for i in 0 to R-1 (read heads flow)
  input K_IN_L_ENABLE;  // for l in 0 to L-1
  input K_IN_K_ENABLE;  // for k in 0 to W-1
  input B_IN_ENABLE;  // for l in 0 to L-1
  input X_IN_ENABLE;  // for x in 0 to X-1
  input R_IN_I_ENABLE;  // for i in 0 to R-1 (read heads flow)
  input R_IN_K_ENABLE;  // for k in 0 to W-1
  output H_OUT_ENABLE;  // for l in 0 to L-1

  // DATA
  input [DATA_SIZE-1:0] SIZE_X_IN;
  input [DATA_SIZE-1:0] SIZE_W_IN;
  input [DATA_SIZE-1:0] SIZE_L_IN;
  input [DATA_SIZE-1:0] SIZE_R_IN;
  input [DATA_SIZE-1:0] W_IN;
  input [DATA_SIZE-1:0] K_IN;
  input [DATA_SIZE-1:0] B_IN;
  input [DATA_SIZE-1:0] X_IN;
  input [DATA_SIZE-1:0] R_IN;
  output [DATA_SIZE-1:0] H_OUT;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] VECTOR_SUMMATION_STATE = 1;
  parameter [1:0] MATRIX_PRODUCT_STATE = 2;
  parameter [1:0] ENDER_STATE = 3;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [1:0] controller_ctrl_fsm_int;

  // Internal Signals
  reg [31:0] index_loop;

  reg data_in_vector_summation_int;
  reg data_a_in_i_matrix_convolution_int;
  reg data_a_in_j_matrix_convolution_int;
  reg data_b_in_i_matrix_convolution_int;
  reg data_b_in_j_matrix_convolution_int;
  reg data_in_vector_logistic_int;

  // VECTOR SUMMATION
  // CONTROL
  wire start_vector_summation;
  wire ready_vector_summation;
  wire data_in_vector_enable_vector_summation;
  wire data_in_scalar_enable_vector_summation;
  wire data_out_vector_enable_vector_summation;
  wire data_out_scalar_enable_vector_summation;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_summation;
  wire [DATA_SIZE-1:0] size_in_vector_summation;
  wire [DATA_SIZE-1:0] length_in_vector_summation;
  wire [DATA_SIZE-1:0] data_in_vector_summation;
  wire [DATA_SIZE-1:0] data_out_vector_summation;

  // MATRIX CONVOLUTION
  // CONTROL
  wire start_matrix_convolution;
  wire ready_matrix_convolution;
  wire data_a_in_matrix_enable_matrix_convolution;
  wire data_a_in_vector_enable_matrix_convolution;
  wire data_a_in_scalar_enable_matrix_convolution;
  wire data_b_in_matrix_enable_matrix_convolution;
  wire data_b_in_vector_enable_matrix_convolution;
  wire data_b_in_scalar_enable_matrix_convolution;
  wire data_out_matrix_enable_matrix_convolution;
  wire data_out_vector_enable_matrix_convolution;
  wire data_out_scalar_enable_matrix_convolution;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_matrix_convolution;
  wire [DATA_SIZE-1:0] size_i_in_matrix_convolution;
  wire [DATA_SIZE-1:0] size_j_in_matrix_convolution;
  wire [DATA_SIZE-1:0] length_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_a_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_b_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_out_matrix_convolution;

  // VECTOR LOGISTIC
  // CONTROL
  wire start_vector_logistic;
  wire ready_vector_logistic;
  wire data_in_enable_vector_logistic;
  wire data_out_enable_vector_logistic;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_logistic;
  wire [DATA_SIZE-1:0] size_in_vector_logistic;
  wire [DATA_SIZE-1:0] data_in_vector_logistic;
  wire data_out_vector_logistic;

  // TRAINER
  // CONTROL
  wire start_trainer;
  wire ready_trainer;
  wire h_in_enable_trainer;
  wire x_in_enable_trainer;
  wire w_out_l_enable_trainer;
  wire w_out_x_enable_trainer;
  wire k_out_i_enable_trainer;
  wire k_out_l_enable_trainer;
  wire k_out_k_enable_trainer;
  wire b_out_enable_trainer;

  // DATA
  wire [DATA_SIZE-1:0] size_x_in_trainer;
  wire [DATA_SIZE-1:0] size_w_in_trainer;
  wire [DATA_SIZE-1:0] size_l_in_trainer;
  wire [DATA_SIZE-1:0] size_r_in_trainer;
  wire [DATA_SIZE-1:0] h_in_trainer;
  wire [DATA_SIZE-1:0] x_in_trainer;
  wire [DATA_SIZE-1:0] w_out_trainer;
  wire [DATA_SIZE-1:0] k_out_trainer;
  wire [DATA_SIZE-1:0] b_out_trainer;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // h(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + b(t;l))
  always @(posedge CLK or posedge RST) begin
    if((RST == 1'b0)) begin
      // Data Outputs
      H_OUT <= ZERO;
      // Control Outputs
      READY <= 1'b0;
      // Assignations
      index_loop <= 0;
      data_in_vector_summation_int <= 1'b0;
      data_a_in_i_matrix_convolution_int <= 1'b0;
      data_a_in_j_matrix_convolution_int <= 1'b0;
      data_b_in_i_matrix_convolution_int <= 1'b0;
      data_b_in_j_matrix_convolution_int <= 1'b0;
      data_in_vector_logistic_int <= 1'b0;
    end else begin
      case(controller_ctrl_fsm_int)
        STARTER_STATE : begin
          // STEP 0
          // Control Outputs
          READY <= 1'b0;
          if((START == 1'b1)) begin
            // FSM Control
            controller_ctrl_fsm_int <= VECTOR_SUMMATION_STATE;
          end
        end
        VECTOR_SUMMATION_STATE : begin
          // STEP 1
        end
        MATRIX_PRODUCT_STATE : begin
          // STEP 2
        end
        ENDER_STATE : begin
          // STEP 3
        end
        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR SUMMATION
  ntm_vector_summation_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_summation_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_summation),
    .READY(ready_vector_summation),

    .DATA_IN_VECTOR_ENABLE(data_in_vector_enable_vector_summation),
    .DATA_IN_SCALAR_ENABLE(data_in_scalar_enable_vector_summation),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_vector_summation),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_vector_summation),

    // DATA
    .MODULO_IN(modulo_in_vector_summation),
    .SIZE_IN(size_in_vector_summation),
    .LENGTH_IN(length_in_vector_summation),
    .DATA_IN(data_in_vector_summation),
    .DATA_OUT(data_out_vector_summation)
  );

  // MATRIX CONVOLUTION
  ntm_matrix_convolution_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  matrix_convolution_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_matrix_convolution),
    .READY(ready_matrix_convolution),

    .DATA_A_IN_MATRIX_ENABLE(data_a_in_matrix_enable_matrix_convolution),
    .DATA_A_IN_VECTOR_ENABLE(data_a_in_vector_enable_matrix_convolution),
    .DATA_A_IN_SCALAR_ENABLE(data_a_in_scalar_enable_matrix_convolution),
    .DATA_B_IN_MATRIX_ENABLE(data_b_in_matrix_enable_matrix_convolution),
    .DATA_B_IN_VECTOR_ENABLE(data_b_in_vector_enable_matrix_convolution),
    .DATA_B_IN_SCALAR_ENABLE(data_b_in_scalar_enable_matrix_convolution),
    .DATA_OUT_MATRIX_ENABLE(data_out_matrix_enable_matrix_convolution),
    .DATA_OUT_VECTOR_ENABLE(data_out_vector_enable_matrix_convolution),
    .DATA_OUT_SCALAR_ENABLE(data_out_scalar_enable_matrix_convolution),

    // DATA
    .MODULO_IN(modulo_in_matrix_convolution),
    .SIZE_I_IN(size_i_in_matrix_convolution),
    .SIZE_J_IN(size_j_in_matrix_convolution),
    .LENGTH_IN(length_in_matrix_convolution),
    .DATA_A_IN(data_a_in_matrix_convolution),
    .DATA_B_IN(data_b_in_matrix_convolution),
    .DATA_OUT(data_out_matrix_convolution)
  );

  // VECTOR LOGISTIC
  ntm_vector_logistic_function #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_logistic_function(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_logistic),
    .READY(ready_vector_logistic),

    .DATA_IN_ENABLE(data_in_enable_vector_logistic),
    .DATA_OUT_ENABLE(data_out_enable_vector_logistic),

    // DATA
    .MODULO_IN(modulo_in_vector_logistic),
    .SIZE_IN(size_in_vector_logistic),
    .DATA_IN(data_in_vector_logistic),
    .DATA_OUT(data_out_vector_logistic)
  );

  // TRAINER
  ntm_trainer #(
    .DATA_SIZE(DATA_SIZE)
  )
  ntm(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_trainer),
    .READY(ready_trainer),

    .H_IN_ENABLE(h_in_enable_trainer),
    .X_IN_ENABLE(x_in_enable_trainer),
    .W_OUT_L_ENABLE(w_out_l_enable_trainer),
    .W_OUT_X_ENABLE(w_out_x_enable_trainer),
    .K_OUT_I_ENABLE(k_out_i_enable_trainer),
    .K_OUT_L_ENABLE(k_out_l_enable_trainer),
    .K_OUT_K_ENABLE(k_out_k_enable_trainer),
    .B_OUT_ENABLE(b_out_enable_trainer),

    // DATA
    .SIZE_X_IN(size_x_in_trainer),
    .SIZE_W_IN(size_w_in_trainer),
    .SIZE_L_IN(size_l_in_trainer),
    .SIZE_R_IN(size_r_in_trainer),
    .H_IN(h_in_trainer),
    .X_IN(x_in_trainer),
    .W_OUT(w_out_trainer),
    .K_OUT(k_out_trainer),
    .B_OUT(b_out_trainer)
  );

endmodule
