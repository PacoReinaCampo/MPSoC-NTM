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

module ntm_reading #(
  parameter DATA_SIZE=512
)
  (
    // GLOBAL
    input CLK,
    input RST,

    // CONTROL
    input START,
    output reg READY,

    input M_IN_ENABLE,
    output reg R_OUT_ENABLE,

    // DATA
    input [DATA_SIZE-1:0] SIZE_N_IN,
    input [DATA_SIZE-1:0] SIZE_W_IN,
    input [DATA_SIZE-1:0] W_IN,
    input [DATA_SIZE-1:0] M_IN,
    output reg [DATA_SIZE-1:0] R_OUT
  );

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  parameter [1:0] STARTER_STATE = 0;
  parameter [1:0] VECTOR_MULTIPLIER_STATE = 1;
  parameter [1:0] VECTOR_SUMMATION_STATE = 2;
  parameter [1:0] ENDER_STATE = 3;

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
  reg [1:0] controller_ctrl_fsm_int;

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

  // VECTOR MULTIPLIER
  // CONTROL
  wire start_vector_multiplier;
  wire ready_vector_multiplier;
  wire data_a_in_enable_vector_multiplier;
  wire data_b_in_enable_vector_multiplier;
  wire data_out_enable_vector_multiplier;

  // DATA
  wire [DATA_SIZE-1:0] modulo_in_vector_multiplier;
  wire [DATA_SIZE-1:0] size_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_a_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_b_in_vector_multiplier;
  wire [DATA_SIZE-1:0] data_out_vector_multiplier;

  ///////////////////////////////////////////////////////////////////////
  // Body
  ///////////////////////////////////////////////////////////////////////

  // r(t;k) = summation(w(t;j)·M(t;j;k))[j in 1 to N]

  // CONTROL
  always @(posedge CLK or posedge RST) begin
    if(RST == 1'b0) begin
      // Data Outputs
      R_OUT <= ZERO;

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
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          end
        end

        VECTOR_MULTIPLIER_STATE : begin  // STEP 1
        end

        VECTOR_SUMMATION_STATE : begin  // STEP 2
        end

        ENDER_STATE : begin  // STEP 3

          // Data Outputs
          R_OUT <= data_out_vector_summation;
        end
        default : begin
          // FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
        end
      endcase
    end
  end

  // DATA
  // VECTOR MULTIPLIER
  assign modulo_in_vector_multiplier = FULL;
  assign size_in_vector_multiplier   = SIZE_W_IN;
  assign data_a_in_vector_multiplier = W_IN;
  assign data_b_in_vector_multiplier = M_IN;

  // VECTOR SUMMATION
  assign modulo_in_vector_summation = FULL;
  assign size_in_vector_summation   = SIZE_W_IN;
  assign length_in_vector_summation = SIZE_N_IN;
  assign data_in_vector_summation   = data_out_vector_multiplier;

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

  // VECTOR MULTIPLIER
  ntm_vector_multiplier #(
    .DATA_SIZE(DATA_SIZE)
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