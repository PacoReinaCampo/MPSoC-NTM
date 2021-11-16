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

module ntm_controller #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input W_IN_L_ENABLE,  // for l in 0 to L-1
    input W_IN_X_ENABLE,  // for x in 0 to X-1
    input K_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
    input K_IN_L_ENABLE,  // for l in 0 to L-1
    input K_IN_K_ENABLE,  // for k in 0 to W-1
    input B_IN_ENABLE,  // for l in 0 to L-1
    input X_IN_ENABLE,  // for x in 0 to X-1
    input R_IN_I_ENABLE,  // for i in 0 to R-1 (read heads flow)
    input R_IN_K_ENABLE,  // for k in 0 to W-1
    output reg H_OUT_ENABLE,  // for l in 0 to L-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_X_IN,
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] SIZE_L_IN,
    input [DATA_SIZE-1:0] SIZE_R_IN,
    input [DATA_SIZE-1:0] W_IN,
    input [DATA_SIZE-1:0] K_IN,
    input [DATA_SIZE-1:0] B_IN,
    input [DATA_SIZE-1:0] X_IN,
    input [DATA_SIZE-1:0] R_IN,
    output reg H_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] MATRIX_FIRST_CONVOLUTION_STATE = 1;
  parameter [2:0] VECTOR_FIRST_ADDER_STATE = 2;
  parameter [2:0] MATRIX_SECOND_CONVOLUTION_STATE = 3;
  parameter [2:0] VECTOR_SECOND_ADDER_STATE = 4;
  parameter [2:0] VECTOR_LOGISTIC_STATE = 5;
  parameter [2:0] ENDER_STATE = 6;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO = 0;
  parameter ONE = 1;
  parameter FULL = 1;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] controller_ctrl_fsm_int;

  reg data_in_vector_summation_int;
  reg data_a_in_i_matrix_convolution_int;
  reg data_a_in_j_matrix_convolution_int;
  reg data_b_in_i_matrix_convolution_int;
  reg data_b_in_j_matrix_convolution_int;
  reg data_in_vector_logistic_int;

  // VECTOR ADDER
  // CONTROL
  reg start_vector_adder;
  wire ready_vector_adder;

  reg operation_vector_adder;

  reg data_a_in_enable_vector_adder;
  reg data_b_in_enable_vector_adder;
  wire data_out_enable_vector_adder;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_adder;
  reg [DATA_SIZE-1:0] size_in_vector_adder;
  reg [DATA_SIZE-1:0] data_a_in_vector_adder;
  reg [DATA_SIZE-1:0] data_b_in_vector_adder;
  wire [DATA_SIZE-1:0] data_out_vector_adder;

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
  reg [DATA_SIZE-1:0] modulo_in_matrix_convolution;
  reg [DATA_SIZE-1:0] size_i_in_matrix_convolution;
  reg [DATA_SIZE-1:0] size_j_in_matrix_convolution;
  reg [DATA_SIZE-1:0] length_in_matrix_convolution;
  reg [DATA_SIZE-1:0] data_a_in_matrix_convolution;
  reg [DATA_SIZE-1:0] data_b_in_matrix_convolution;
  wire [DATA_SIZE-1:0] data_out_matrix_convolution;

  // VECTOR LOGISTIC
  // CONTROL
  wire start_vector_logistic;
  wire ready_vector_logistic;
  wire data_in_enable_vector_logistic;
  wire data_out_enable_vector_logistic;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_logistic;
  reg [DATA_SIZE-1:0] size_in_vector_logistic;
  reg [DATA_SIZE-1:0] data_in_vector_logistic;
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

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      H_OUT <= 1'b0;

      // Control Outputs
      READY <= 1'b0;
    end
    else begin
      case(controller_ctrl_fsm_int)
        STARTER_STATE : begin  // STEP 0
          // Control Outputs
          READY <= 1'b0;

          if(START == 1'b1) begin
            // FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_CONVOLUTION_STATE;
          end
        end

        MATRIX_FIRST_CONVOLUTION_STATE : begin  // STEP 1

          // Data Inputs
          modulo_in_matrix_convolution <= FULL;
          size_i_in_matrix_convolution <= FULL;
          size_j_in_matrix_convolution <= FULL;
          length_in_matrix_convolution <= FULL;
          data_a_in_matrix_convolution <= W_IN;
          data_b_in_matrix_convolution <= X_IN;
        end

        VECTOR_FIRST_ADDER_STATE : begin  // STEP 2

          // Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= FULL;
          data_a_in_vector_adder <= data_out_matrix_convolution;
          data_b_in_vector_adder <= B_IN;
        end

        MATRIX_SECOND_CONVOLUTION_STATE : begin  // STEP 3

          // Data Inputs
          modulo_in_matrix_convolution <= FULL;
          size_i_in_matrix_convolution <= FULL;
          size_j_in_matrix_convolution <= FULL;
          length_in_matrix_convolution <= FULL;
          data_a_in_matrix_convolution <= K_IN;
          data_b_in_matrix_convolution <= R_IN;
        end

        VECTOR_SECOND_ADDER_STATE : begin  // STEP 4

          // Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= FULL;
          data_a_in_vector_adder <= data_out_matrix_convolution;
          data_b_in_vector_adder <= data_out_vector_adder;
        end

        VECTOR_LOGISTIC_STATE : begin  // STEP 5

          // Data Inputs
          modulo_in_vector_logistic <= FULL;
          size_in_vector_logistic   <= FULL;
          data_in_vector_logistic   <= FULL;
        end

        ENDER_STATE : begin  // STEP 6

          // Data Outputs
          H_OUT <= data_out_vector_logistic;
        end

        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // VECTOR ADDER
  ntm_vector_adder #(
    .DATA_SIZE(DATA_SIZE)
  )
  vector_adder(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),
    // CONTROL
    .START(start_vector_adder),
    .READY(ready_vector_adder),

    .OPERATION(operation_vector_adder),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_adder),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_adder),
    .DATA_OUT_ENABLE(data_out_enable_vector_adder),

    // DATA
    .MODULO_IN(modulo_in_vector_adder),
    .SIZE_IN(size_in_vector_adder),
    .DATA_A_IN(data_a_in_vector_adder),
    .DATA_B_IN(data_b_in_vector_adder),
    .DATA_OUT(data_out_vector_adder)
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
