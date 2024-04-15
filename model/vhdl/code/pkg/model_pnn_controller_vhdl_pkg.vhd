--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;

package model_pnn_controller_vhdl_pkg is
  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  type trainer_output is record
    matrix_w_output : matrix_buffer;
    vector_b_output : vector_buffer;
  end record trainer_output;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component model_controller is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      W_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1
      W_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      B_IN_ENABLE : in std_logic;       -- for l in 0 to L-1

      B_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      X_IN_ENABLE : in std_logic;       -- for x in 0 to X-1

      X_OUT_ENABLE : out std_logic;     -- for x in 0 to X-1

      H_OUT_ENABLE : out std_logic;     -- for l in 0 to L-1

      -- DATA
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      H_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_trainer is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for x in 0 to X-1
      X_IN_X_ENABLE : in std_logic;     -- for x in 0 to X-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      X_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      H_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      H_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      H_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      H_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      W_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1
      W_OUT_X_ENABLE : out std_logic;   -- for x in 0 to X-1

      B_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
      H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
      B_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_trainer_vector_differentiation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      X_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      Y_OUT_T_ENABLE : out std_logic;   -- for l in 0 to T-1
      Y_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      LENGTH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  component model_trainer_matrix_differentiation is
    generic (
      DATA_SIZE    : integer := 64;
      CONTROL_SIZE : integer := 4
      );
    port (
      -- GLOBAL
      CLK : in std_logic;
      RST : in std_logic;

      -- CONTROL
      START : in  std_logic;
      READY : out std_logic;

      X_IN_T_ENABLE : in std_logic;     -- for t in 0 to T-1
      X_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
      X_IN_L_ENABLE : in std_logic;     -- for l in 0 to L-1

      X_OUT_T_ENABLE : out std_logic;   -- for t in 0 to T-1
      X_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      X_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      Y_OUT_T_ENABLE : out std_logic;   -- for l in 0 to T-1
      Y_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
      Y_OUT_L_ENABLE : out std_logic;   -- for l in 0 to L-1

      -- DATA
      SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
      SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

      LENGTH_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

      Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  function function_trainer_vector_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return matrix_buffer;

  function function_trainer_matrix_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return tensor_buffer;

  ------------------------------------------------------------------------------
  -- Controller
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_pnn_convolutional_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_pnn_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer;

  ------------------------------------------------------------------------------
  -- Trainer
  ------------------------------------------------------------------------------

  function function_model_pnn_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    vector_h_input : matrix_buffer
    ) return matrix_buffer;

  function function_model_pnn_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer
    ) return vector_buffer;

  function function_model_pnn_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_w_x_input : matrix_buffer;
    vector_w_h_input : matrix_buffer;

    vector_b_h_input : matrix_buffer
    ) return trainer_output;

end model_pnn_controller_vhdl_pkg;

package body model_pnn_controller_vhdl_pkg is

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  function function_trainer_vector_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    vector_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_output : matrix_buffer;
  begin
    -- Data Inputs
    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        if (t = 0) then
          vector_output(t, l) := ZERO_DATA;
        else
          scalar_operation_int := function_scalar_float_adder (
            OPERATION => '1',

            scalar_a_input => vector_input(t, l),
            scalar_b_input => vector_input(t-1, l)
            );

          vector_output(t, l) := function_scalar_float_multiplier (
            scalar_a_input => scalar_operation_int,
            scalar_b_input => LENGTH_IN
            );
        end if;
      end loop;
    end loop;

    return vector_output;
  end function function_trainer_vector_differentiation;

  function function_trainer_matrix_differentiation (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    LENGTH_IN : std_logic_vector(DATA_SIZE-1 downto 0);

    matrix_input : tensor_buffer
    ) return tensor_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable matrix_output : tensor_buffer;
  begin
    -- Data Inputs
    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for i in 0 to to_integer(unsigned(SIZE_R_IN))-1 loop
        for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
          if (t = 0) then
            matrix_output(t, i, l) := ZERO_DATA;
          else
            scalar_operation_int := function_scalar_float_adder (
              OPERATION => '1',

              scalar_a_input => matrix_input(t, i, l),
              scalar_b_input => matrix_input(t-1, i, l)
              );

            matrix_output(t, i, l) := function_scalar_float_multiplier (
              scalar_a_input => scalar_operation_int,
              scalar_b_input => LENGTH_IN
              );
          end if;
        end loop;
      end loop;
    end loop;

    return matrix_output;
  end function function_trainer_matrix_differentiation;

  ------------------------------------------------------------------------------
  -- Controller
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- CONVOLUTIONAL
  ------------------------------------------------------------------------------

  function function_model_pnn_convolutional_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    variable matrix_operation_int : matrix_buffer;

    variable vector_one_operation_int : vector_buffer;
    variable vector_two_operation_int : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = sigmoid(W(l;x)*x(t;x) + b(l))

    -- W(l;x)*x(t;x)
    vector_one_operation_int := function_matrix_vector_convolution (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    -- b(l)
    vector_two_operation_int := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_one_operation_int,
      vector_b_input => vector_b_input
      );

    -- logistic(h(t;l))
    vector_h_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_two_operation_int
      );

    return vector_h_output;
  end function function_model_pnn_convolutional_controller;

  ------------------------------------------------------------------------------
  -- STANDARD
  ------------------------------------------------------------------------------

  function function_model_pnn_standard_controller (
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    matrix_w_input : matrix_buffer;
    vector_b_input : vector_buffer;

    vector_x_input : vector_buffer
    ) return vector_buffer is

    variable vector_one_operation_int : vector_buffer;
    variable vector_two_operation_int : vector_buffer;

    variable vector_h_output : vector_buffer;

  begin

    -- h(t;l) = sigmoid(W(l;x)·x(t;x) + b(l))

    -- W(l;x)·x(t;x)
    vector_one_operation_int := function_matrix_vector_product (
      SIZE_A_I_IN => SIZE_L_IN,
      SIZE_A_J_IN => SIZE_X_IN,
      SIZE_B_IN   => SIZE_X_IN,

      matrix_a_input => matrix_w_input,
      vector_b_input => vector_x_input
      );

    -- b(l)
    vector_two_operation_int := function_vector_float_adder (
      OPERATION => '0',

      SIZE_IN => SIZE_L_IN,

      vector_a_input => vector_one_operation_int,
      vector_b_input => vector_b_input
      );

    -- logistic(h(t;l))
    vector_h_output := function_vector_logistic (
      SIZE_IN => SIZE_L_IN,

      vector_input => vector_two_operation_int
      );

    return vector_h_output;
  end function function_model_pnn_standard_controller;

  ------------------------------------------------------------------------------
  -- Trainer
  ------------------------------------------------------------------------------

  function function_model_pnn_w_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_x_input : matrix_buffer;
    vector_h_input : matrix_buffer
    ) return matrix_buffer is

    variable scalar_operation_int : std_logic_vector(DATA_SIZE-1 downto 0);

    variable vector_dh_int : matrix_buffer;

    variable matrix_w_output : matrix_buffer;

  begin

    -- dW(l;x) = summation(d*(t;l) · x(t;x))[t in 0 to T]

    matrix_w_output := (others => (others => ZERO_DATA));

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        for x in 0 to to_integer(unsigned(SIZE_X_IN))-1 loop
          scalar_operation_int := function_scalar_float_multiplier (
            scalar_a_input => vector_dh_int(t, l),
            scalar_b_input => vector_x_input(t, x)
            );

          matrix_w_output(l, x) := function_scalar_float_adder (
            OPERATION => '0',

            scalar_a_input => scalar_operation_int,
            scalar_b_input => matrix_w_output(l, x)
            );
        end loop;
      end loop;
    end loop;

    return matrix_w_output;
  end function function_model_pnn_w_trainer;

  function function_model_pnn_b_trainer (
    SIZE_T_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_h_input : matrix_buffer
    ) return vector_buffer is

    variable vector_dh_int : matrix_buffer;

    variable vector_b_output : vector_buffer;

  begin

    -- db(l) = summation(d*(t+1;l))[t in 0 to T]

    vector_b_output := (others => ZERO_DATA);

    vector_dh_int := function_trainer_vector_differentiation (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      LENGTH_IN => ONE_DATA,

      vector_input => vector_h_input
      );

    for t in 0 to to_integer(unsigned(SIZE_T_IN))-1 loop
      for l in 0 to to_integer(unsigned(SIZE_L_IN))-1 loop
        vector_b_output(l) := function_scalar_float_adder (
          OPERATION => '0',

          scalar_a_input => vector_dh_int(t, l),
          scalar_b_input => vector_b_output(l)
          );
      end loop;
    end loop;

    return vector_b_output;
  end function function_model_pnn_b_trainer;

  function function_model_pnn_trainer (
    SIZE_T_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_X_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    vector_w_x_input : matrix_buffer;
    vector_w_h_input : matrix_buffer;

    vector_b_h_input : matrix_buffer
    ) return trainer_output is

    -- Trainer Variable
    variable matrix_w_output : matrix_buffer;
    variable vector_b_output : vector_buffer;

    variable trainer_pnn_output : trainer_output;

  begin

    -- TRAINER_STATE

    matrix_w_output := function_model_pnn_w_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_X_IN => SIZE_X_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_x_input => vector_w_x_input,
      vector_h_input => vector_w_h_input
      );

    vector_b_output := function_model_pnn_b_trainer (
      SIZE_T_IN => SIZE_T_IN,
      SIZE_L_IN => SIZE_L_IN,

      vector_h_input => vector_b_h_input
      );

    trainer_pnn_output.matrix_w_output := matrix_w_output;
    trainer_pnn_output.vector_b_output := vector_b_output;

    return trainer_pnn_output;

  end function function_model_pnn_trainer;

end model_pnn_controller_vhdl_pkg;
