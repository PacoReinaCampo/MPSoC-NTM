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

package ntm_arithmetic_pkg;

  ///////////////////////////////////////////////////////////////////////
  // Types
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // Constants
  ///////////////////////////////////////////////////////////////////////

  parameter DATA_SIZE=64;
  parameter CONTROL_SIZE=64;

  parameter ZERO_CONTROL=0;
  parameter ONE_CONTROL=1;
  parameter TWO_CONTROL=2;
  parameter THREE_CONTROL=3;

  parameter ZERO_DATA=0.0;
  parameter ONE_DATA=1.0;
  parameter TWO_DATA=2.0;
  parameter THREE_DATA=3.0;

  parameter LENGTH_IN=0.001;

  ///////////////////////////////////////////////////////////////////////
  // Functions
  ///////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////
  // ARITHMETIC - MODULAR
  ///////////////////////////////////////////////////////////////////////

  // SCALAR
  function [DATA_SIZE-1:0] function_scalar_modular_mod;
    input [DATA_SIZE-1:0] scalar_modulo_input;

    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_modular_mod = scalar_input % scalar_modulo_input;
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_modular_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] scalar_modulo_input;

    input [DATA_SIZE-1:0] scalar_a_input;
    input [DATA_SIZE-1:0] scalar_b_input;

    begin
      if (OPERATION == 1'b1) begin
        function_scalar_modular_adder = (scalar_a_input + scalar_b_input) % scalar_modulo_input;
      end
      else begin
        function_scalar_modular_adder = (scalar_a_input - scalar_b_input) % scalar_modulo_input;
      end
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_modular_multiplier;
    input [DATA_SIZE-1:0] scalar_modulo_input;

    input [DATA_SIZE-1:0] scalar_a_input;
    input [DATA_SIZE-1:0] scalar_b_input;

    begin
      function_scalar_modular_multiplier = (scalar_a_input * scalar_b_input) % scalar_modulo_input;
    end
  endfunction

  function [DATA_SIZE-1:0] function_scalar_modular_inverter;
    input [DATA_SIZE-1:0] scalar_modulo_input;

    input [DATA_SIZE-1:0] scalar_input;

    begin
      function_scalar_modular_inverter = scalar_input % scalar_modulo_input;
    end
  endfunction

  // VECTOR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_modular_mod;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_modulo_input;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_modular_mod[i] = vector_input[i] % vector_modulo_input[i];
      end
    end
  endfunction

  function [DATA_SIZE-1:0] function_vector_modular_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_modulo_input;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        if (OPERATION == 1'b1) begin
          function_vector_modular_adder[i] = (vector_a_input[i] + vector_b_input[i]) % vector_modulo_input[i];
        end
        else begin
          function_vector_modular_adder[i] = (vector_a_input[i] - vector_b_input[i]) % vector_modulo_input[i];
        end
      end
    end
  endfunction

  function [DATA_SIZE-1:0] function_vector_modular_multiplier;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_modulo_input;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_modular_multiplier[i] = (vector_a_input[i] * vector_b_input[i]) % vector_modulo_input[i];
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_modular_inverter;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_modulo_input;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_modular_inverter[i] = vector_input[i] % vector_modulo_input[i];
      end
    end
  endfunction

  // MATRIX
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_modular_mod;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_modular_mod[i][j] = matrix_input[i][j] % matrix_modulo_input[i][j];
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_modular_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          if (OPERATION == 1'b1) begin
            function_matrix_modular_adder[i][j] = (matrix_a_input[i][j] + matrix_b_input[i][j]) % matrix_modulo_input[i][j];
          end
          else begin
            function_matrix_modular_adder[i][j] = (matrix_a_input[i][j] - matrix_b_input[i][j]) % matrix_modulo_input[i][j];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_modular_multiplier;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_modular_multiplier[i][j] = (matrix_a_input[i][j] * matrix_b_input[i][j]) % matrix_modulo_input[i][j];
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_modular_inverter;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_modular_inverter[i][j] = matrix_input[i][j] % matrix_modulo_input[i][j];
        end
      end
    end
  endfunction

  // TENSOR
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_modular_mod;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_modular_mod[i][j][k] = tensor_input[i][j][k] % tensor_modulo_input[i][j][k];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_modular_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            if (OPERATION == 1'b1) begin
              function_tensor_modular_adder[i][j][k] = (tensor_a_input[i][j][k] + tensor_b_input[i][j][k]) % tensor_modulo_input[i][j][k];
            end
            else begin
              function_tensor_modular_adder[i][j][k] = (tensor_a_input[i][j][k] - tensor_b_input[i][j][k]) % tensor_modulo_input[i][j][k];
            end
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_modular_multiplier;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_modular_multiplier[i][j][k] = (tensor_a_input[i][j][k] * tensor_b_input[i][j][k]) % tensor_modulo_input[i][j][k];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_modular_inverter;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_modulo_input;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_modular_inverter[i][j][k] = tensor_input[i][j][k] % tensor_modulo_input[i][j][k];
          end
        end
      end
    end
  endfunction

  ///////////////////////////////////////////////////////////////////////
  // ARITHMETIC - INTEGER
  ///////////////////////////////////////////////////////////////////////

  // SCALAR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_scalar_integer_adder;
    input OPERATION;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_b_input;

    begin
      if (OPERATION == 1'b1) begin
        function_scalar_integer_adder = scalar_a_input + scalar_b_input;
      end
      else begin
        function_scalar_integer_adder = scalar_a_input - scalar_b_input;
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_scalar_integer_multiplier;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_b_input;

    begin
      function_scalar_integer_multiplier = scalar_a_input * scalar_b_input;
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_scalar_integer_divider;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_b_input;

    begin
      function_scalar_integer_divider = scalar_a_input / scalar_b_input;
    end
  endfunction

  // VECTOR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_integer_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        if (OPERATION == 1'b1) begin
          function_vector_integer_adder[i] = vector_a_input[i] + vector_b_input[i];
        end
        else begin
          function_vector_integer_adder[i] = vector_a_input[i] - vector_b_input[i];
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_integer_multiplier;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_integer_multiplier[i] = vector_a_input[i] * vector_b_input[i];
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_integer_divider;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_integer_divider[i] = vector_a_input[i] / vector_b_input[i];
      end
    end
  endfunction

  // MATRIX
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_integer_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          if (OPERATION == 1'b1) begin
            function_matrix_integer_adder[i][j] = matrix_a_input[i][j] + matrix_b_input[i][j];
          end
          else begin
            function_matrix_integer_adder[i][j] = matrix_a_input[i][j] - matrix_b_input[i][j];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_integer_multiplier;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_integer_multiplier[i][j] = matrix_a_input[i][j] * matrix_b_input[i][j];
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_integer_divider;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_integer_divider[i][j] = matrix_a_input[i][j] / matrix_b_input[i][j];
        end
      end
    end
  endfunction

  // TENSOR
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_integer_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            if (OPERATION == 1'b1) begin
              function_tensor_integer_adder[i][j][k] = tensor_a_input[i][j][k] + tensor_b_input[i][j][k];
            end
            else begin
              function_tensor_integer_adder[i][j][k] = tensor_a_input[i][j][k] - tensor_b_input[i][j][k];
            end
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_integer_multiplier;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_integer_multiplier[i][j][k] = tensor_a_input[i][j][k] * tensor_b_input[i][j][k];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_integer_divider;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_integer_divider[i][j][k] = tensor_a_input[i][j][k] / tensor_b_input[i][j][k];
          end
        end
      end
    end
  endfunction

  ///////////////////////////////////////////////////////////////////////
  // ARITHMETIC - FLOAT
  ///////////////////////////////////////////////////////////////////////

  // SCALAR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_scalar_float_adder;
    input OPERATION;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_b_input;

    begin
      if (OPERATION == 1'b1) begin
        function_scalar_float_adder = scalar_a_input + scalar_b_input;
      end
      else begin
        function_scalar_float_adder = scalar_a_input - scalar_b_input;
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_scalar_float_multiplier;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_b_input;

    begin
      function_scalar_float_multiplier = scalar_a_input * scalar_b_input;
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_scalar_float_divider;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] scalar_b_input;

    begin
      function_scalar_float_divider = scalar_a_input / scalar_b_input;
    end
  endfunction

  // VECTOR
  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_float_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        if (OPERATION == 1'b1) begin
          function_vector_float_adder[i] = vector_a_input[i] + vector_b_input[i];
        end
        else begin
          function_vector_float_adder[i] = vector_a_input[i] - vector_b_input[i];
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_float_multiplier;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_float_multiplier[i] = vector_a_input[i] * vector_b_input[i];
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_vector_float_divider;
    input [DATA_SIZE-1:0] SIZE_IN;

    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_a_input;
    input [CONTROL_SIZE-1:0][DATA_SIZE-1:0] vector_b_input;

    reg [CONTROL_SIZE-1:0] i;

    begin
      for(i = 0; i < SIZE_IN; i = i + 1) begin
        function_vector_float_divider[i] = vector_a_input[i] / vector_b_input[i];
      end
    end
  endfunction

  // MATRIX
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_float_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          if (OPERATION == 1'b1) begin
            function_matrix_float_adder[i][j] = matrix_a_input[i][j] + matrix_b_input[i][j];
          end
          else begin
            function_matrix_float_adder[i][j] = matrix_a_input[i][j] - matrix_b_input[i][j];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_float_multiplier;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_float_multiplier[i][j] = matrix_a_input[i][j] * matrix_b_input[i][j];
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_matrix_float_divider;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] matrix_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          function_matrix_float_divider[i][j] = matrix_a_input[i][j] / matrix_b_input[i][j];
        end
      end
    end
  endfunction

  // TENSOR
  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_float_adder;
    input OPERATION;

    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            if (OPERATION == 1'b1) begin
              function_tensor_float_adder[i][j][k] = tensor_a_input[i][j][k] + tensor_b_input[i][j][k];
            end
            else begin
              function_tensor_float_adder[i][j][k] = tensor_a_input[i][j][k] - tensor_b_input[i][j][k];
            end
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_float_multiplier;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_float_multiplier[i][j][k] = tensor_a_input[i][j][k] * tensor_b_input[i][j][k];
          end
        end
      end
    end
  endfunction

  function [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] function_tensor_float_divider;
    input [DATA_SIZE-1:0] SIZE_I_IN;
    input [DATA_SIZE-1:0] SIZE_J_IN;
    input [DATA_SIZE-1:0] SIZE_K_IN;

    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_a_input;
    input [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][DATA_SIZE-1:0] tensor_b_input;

    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] i;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] j;
    reg [CONTROL_SIZE-1:0][CONTROL_SIZE-1:0][CONTROL_SIZE-1:0] k;

    begin
      for(i = 0; i < SIZE_I_IN; i = i + 1) begin
        for(j = 0; j < SIZE_J_IN; j = j + 1) begin
          for(k = 0; k < SIZE_K_IN; k = k + 1) begin
            function_tensor_float_divider[i][j][k] = tensor_a_input[i][j][k] / tensor_b_input[i][j][k];
          end
        end
      end
    end
  endfunction

endpackage