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

module dnc_read_weighting #(
  parameter DATA_SIZE=512,
  parameter INDEX_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input PI_IN_I_ENABLE,  // for i in 0 to R-1
    input PI_IN_P_ENABLE,  // for p in 0 to 2

    output reg PI_OUT_I_ENABLE,  // for i in 0 to R-1
    output reg PI_OUT_P_ENABLE,  // for p in 0 to 2

    input B_IN_I_ENABLE,  // for i in 0 to R-1
    input B_IN_J_ENABLE,  // for j in 0 to N-1

    output reg B_OUT_I_ENABLE,  // for i in 0 to R-1
    output reg B_OUT_J_ENABLE,  // for j in 0 to N-1

    input C_IN_I_ENABLE,  // for i in 0 to R-1
    input C_IN_J_ENABLE,  // for j in 0 to N-1

    output reg C_OUT_I_ENABLE,  // for i in 0 to R-1
    output reg C_OUT_J_ENABLE,  // for j in 0 to N-1

    input F_IN_I_ENABLE,  // for i in 0 to R-1
    input F_IN_J_ENABLE,  // for j in 0 to N-1

    output reg F_OUT_I_ENABLE,  // for i in 0 to R-1
    output reg F_OUT_J_ENABLE,  // for j in 0 to N-1

    output reg W_OUT_I_ENABLE,  // for i in 0 to R-1
    output reg W_OUT_J_ENABLE,  // for j in 0 to N-1

    // DATA
    input [DATA_SIZE-1:0] SIZE_R_IN,
    input [DATA_SIZE-1:0] SIZE_N_IN,

    input [DATA_SIZE-1:0] PI_IN,

    input [DATA_SIZE-1:0] B_IN,
    input [DATA_SIZE-1:0] C_IN,
    input [DATA_SIZE-1:0] F_IN,

    output reg [DATA_SIZE-1:0] W_OUT
    );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [2:0] STARTER_STATE = 0;
  parameter [2:0] VECTOR_FIRST_MULTIPLIER_STATE = 1;
  parameter [2:0] VECTOR_FIRST_ADDER_STATE = 2;
  parameter [2:0] VECTOR_SECOND_MULTIPLIER_STATE = 3;
  parameter [2:0] VECTOR_SECOND_ADDER_STATE = 4;
  parameter [2:0] VECTOR_THIRD_MULTIPLIER_STATE = 5;
  parameter [2:0] VECTOR_THIRD_ADDER_STATE = 6;

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter ZERO  = 0;
  parameter ONE   = 1;
  parameter TWO   = 2;
  parameter THREE = 3;

  parameter FULL  = 1;
  parameter EMPTY = 0;

  parameter EULER = 0;

  ///////////////////////////////////////////////////////////////////////
  // Signals
  ///////////////////////////////////////////////////////////////////////

  // Finite State Machine
  reg [2:0] controller_ctrl_fsm_int;

  // Internal Signals
  reg [INDEX_SIZE-1:0] index_loop;

  // VECTOR ADDER
  // CONTROL
  wire start_vector_adder;
  wire ready_vector_adder;

  wire operation_vector_adder;

  wire data_a_in_enable_vector_adder;
  wire data_b_in_enable_vector_adder;
  wire data_out_enable_vector_adder;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_adder;
  reg [DATA_SIZE-1:0] size_in_vector_adder;
  reg [DATA_SIZE-1:0] data_a_in_vector_adder;
  reg [DATA_SIZE-1:0] data_b_in_vector_adder;
  wire [DATA_SIZE-1:0] data_out_vector_adder;

  // VECTOR MULTIPLIER
  // CONTROL
  wire start_vector_multiplier;
  wire ready_vector_multiplier;

  wire data_a_in_enable_vector_multiplier;
  wire data_b_in_enable_vector_multiplier;
  wire data_out_enable_vector_multiplier;

  // DATA
  reg [DATA_SIZE-1:0] modulo_in_vector_multiplier;
  reg [DATA_SIZE-1:0] size_in_vector_multiplier;
  reg [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  reg [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      W_OUT <= ZERO;

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
            controller_ctrl_fsm_int <= VECTOR_FIRST_MULTIPLIER_STATE;
          end
        end

        VECTOR_FIRST_MULTIPLIER_STATE : begin  // STEP 1

          // Data Inputs
          modulo_in_vector_multiplier <= FULL;
          size_in_vector_multiplier   <= SIZE_N_IN;
          data_a_in_vector_multiplier <= PI_IN;
          data_b_in_vector_multiplier <= B_IN;
        end

        VECTOR_FIRST_ADDER_STATE : begin  // STEP 2

          // Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= SIZE_N_IN;
          data_a_in_vector_adder <= ZERO;
          data_b_in_vector_adder <= data_out_vector_multiplier;
        end

        VECTOR_SECOND_MULTIPLIER_STATE : begin  // STEP 3

          // Data Inputs
          modulo_in_vector_multiplier <= FULL;
          size_in_vector_multiplier   <= SIZE_N_IN;
          data_a_in_vector_multiplier <= PI_IN;
          data_b_in_vector_multiplier <= C_IN;
        end

        VECTOR_SECOND_ADDER_STATE : begin  // STEP 4

          // Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= SIZE_N_IN;
          data_a_in_vector_adder <= data_out_vector_adder;
          data_b_in_vector_adder <= data_out_vector_multiplier;
        end

        VECTOR_THIRD_MULTIPLIER_STATE : begin  // STEP 5

          // Data Inputs
          modulo_in_vector_multiplier <= FULL;
          size_in_vector_multiplier   <= SIZE_N_IN;
          data_a_in_vector_multiplier <= PI_IN;
          data_b_in_vector_multiplier <= F_IN;
        end

        VECTOR_THIRD_ADDER_STATE : begin  // STEP 6

          // Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= SIZE_N_IN;
          data_a_in_vector_adder <= data_out_vector_adder;
          data_b_in_vector_adder <= data_out_vector_multiplier;
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
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
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

  // VECTOR MULTIPLIER
  ntm_vector_multiplier #(
    .DATA_SIZE(DATA_SIZE),
    .INDEX_SIZE(INDEX_SIZE)
  )
  vector_multiplier(
    // GLOBAL
    .CLK(CLK),
    .RST(RST),

    // CONTROL
    .START(start_vector_multiplier),
    .READY(ready_vector_multiplier),

    .DATA_A_IN_ENABLE(data_a_in_enable_vector_multiplier),
    .DATA_B_IN_ENABLE(data_b_in_enable_vector_multiplier),
    .DATA_OUT_ENABLE(data_out_enable_vector_multiplier),

    // DATA
    .MODULO_IN(modulo_in_vector_multiplier),
    .SIZE_IN(size_in_vector_multiplier),
    .DATA_A_IN(data_a_in_vector_multiplier),
    .DATA_B_IN(data_b_in_vector_multiplier),
    .DATA_OUT(data_out_vector_multiplier)
  );

endmodule
