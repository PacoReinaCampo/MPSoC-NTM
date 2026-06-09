-----------------------------------------------------------------------------------
--                                            __ _      _     _                  --
--                                           / _(_)    | |   | |                 --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 --
--                  | |                                                          --
--                  |_|                                                          --
--                                                                               --
--                                                                               --
--              Peripheral-NTM for MPSoC                                         --
--              Neural Turing Machine for MPSoC                                  --
--                                                                               --
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--                                                                               --
-- Copyright (c) 2020-2024 by the author(s)                                      --
--                                                                               --
-- Permission is hereby granted, free of charge, to any person obtaining a copy  --
-- of this software and associated documentation files (the "Software"), to deal --
-- in the Software without restriction, including without limitation the rights  --
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     --
-- copies of the Software, and to permit persons to whom the Software is         --
-- furnished to do so, subject to the following conditions:                      --
--                                                                               --
-- The above copyright notice and this permission notice shall be included in    --
-- all copies or substantial portions of the Software.                           --
--                                                                               --
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    --
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      --
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   --
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        --
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, --
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     --
-- THE SOFTWARE.                                                                 --
--                                                                               --
-- ============================================================================= --
-- Author(s):                                                                    --
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           --
--                                                                               --
-----------------------------------------------------------------------------------

with Ada.Text_IO;
use Ada.Text_IO;

with System.Assertions;

with accelerator_size;
use accelerator_size;

with accelerator_state_outputs;
use accelerator_state_outputs;

procedure test_state_outputs is

  -- Inputs
  data_a_in : matrix := ((2.0, 0.0, 4.0), (2.0, 0.0, 4.0), (2.0, 0.0, 4.0));
  data_b_in : matrix := ((1.0, 1.0, 2.0), (1.0, 1.0, 2.0), (1.0, 1.0, 2.0));
  data_c_in : matrix := ((2.0, 0.0, 4.0), (2.0, 0.0, 4.0), (2.0, 0.0, 4.0));
  data_d_in : matrix := ((1.0, 1.0, 2.0), (1.0, 1.0, 2.0), (1.0, 1.0, 2.0));

  data_k_in : matrix := ((2.0, 0.0, 4.0), (2.0, 0.0, 4.0), (2.0, 0.0, 4.0));
  data_u_in : matrix := ((1.0, 1.0, 2.0), (1.0, 1.0, 2.0), (1.0, 1.0, 2.0));

  initial_x : vector := (0.0, 0.0, 0.0);

  k : float := 0.0;

  -- Variables
  matrix_generation_int : matrix := ((2.0, 0.0, 4.0), (2.0, 0.0, 4.0), (2.0, 0.0, 4.0));

  matrix_operation_int : matrix := ((2.0, 0.0, 4.0), (2.0, 0.0, 4.0), (2.0, 0.0, 4.0));
  matrix_eye_int       : matrix := ((1.0, 1.0, 2.0), (1.0, 1.0, 2.0), (1.0, 1.0, 2.0));

  -- Outputs
  data_x_out : vector := (0.0, 0.0, 0.0);
  data_y_out : vector := (0.0, 0.0, 0.0);

begin

  accelerator_state_outputs.accelerator_state_vector_output (
    -- Inputs
    data_a_in => data_a_in,
    data_b_in => data_b_in,
    data_c_in => data_c_in,
    data_d_in => data_d_in,

    data_k_in => data_k_in,
    data_u_in => data_u_in,

    initial_x => initial_x,

    k => k,

    -- Variables
    matrix_generation_int => matrix_generation_int,

    matrix_operation_int => matrix_operation_int,
    matrix_eye_int       => matrix_eye_int,

    -- Outputs
    data_y_out => data_y_out
  );

  pragma Assert (data_y_out = data_y_out, "Vector Output");

  for i in data_y_out'Range(1) loop
    Put(float'Image(data_y_out(i)));
  end loop;

  accelerator_state_outputs.accelerator_state_vector_state (
    -- Inputs
    data_a_in => data_a_in,
    data_b_in => data_b_in,
    data_c_in => data_c_in,
    data_d_in => data_d_in,

    data_k_in => data_k_in,
    data_u_in => data_u_in,

    initial_x => initial_x,

    k => k,

    -- Variables
    matrix_generation_int => matrix_generation_int,

    matrix_operation_int => matrix_operation_int,
    matrix_eye_int       => matrix_eye_int,

    -- Outputs
    data_x_out  => data_x_out
  );

  pragma Assert (data_x_out = data_x_out, "Vector State");

  for i in data_x_out'Range(1) loop
    Put(float'Image(data_x_out(i)));
  end loop;

end test_state_outputs;
