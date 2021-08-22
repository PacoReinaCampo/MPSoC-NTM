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

use work.ntm_math_pkg.all;
use work.ntm_lstm_controller_pkg.all;

entity ntm_standard_lstm_testbench is
end ntm_standard_lstm_testbench;

architecture ntm_standard_lstm_testbench_architecture of ntm_standard_lstm_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- INTPUT GATE VECTOR
  -- CONTROL
  signal start_input_gate_vector : std_logic;
  signal ready_input_gate_vector : std_logic;

  -- DATA
  signal w_in_input_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_input_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_input_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal x_in_input_gate_vector   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_input_gate_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_in_input_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_input_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_input_gate_vector : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal i_out_input_gate_vector  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- OUTPUT GATE VECTOR
  -- CONTROL
  signal start_output_gate_vector : std_logic;
  signal ready_output_gate_vector : std_logic;

  -- DATA
  signal w_in_output_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_output_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_output_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal x_in_output_gate_vector   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_output_gate_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_in_output_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_output_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_output_gate_vector : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal o_out_output_gate_vector  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- FORGET GATE VECTOR
  -- CONTROL
  signal start_forget_gate_vector : std_logic;
  signal ready_forget_gate_vector : std_logic;

  -- DATA
  signal w_in_forget_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_forget_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_forget_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal x_in_forget_gate_vector   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_forget_gate_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_in_forget_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_forget_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_forget_gate_vector : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal f_out_forget_gate_vector  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- STATE GATE VECTOR
  -- CONTROL
  signal start_state_gate_vector : std_logic;
  signal ready_state_gate_vector : std_logic;

  -- DATA
  signal w_in_state_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_in_state_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal u_in_state_gate_vector   : std_logic_arithmetic_vector_matrix(H-1 downto 0)(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal x_in_state_gate_vector   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_state_gate_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal i_in_state_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal f_in_state_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal s_in_state_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_in_state_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal b_in_state_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_state_gate_vector : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal s_out_state_gate_vector  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- HIDDEN GATE VECTOR
  -- CONTROL
  signal start_hidden_gate_vector : std_logic;
  signal ready_hidden_gate_vector : std_logic;

  -- DATA
  signal s_in_hidden_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal o_in_hidden_gate_vector   : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_hidden_gate_vector : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);
  signal h_out_hidden_gate_vector  : std_logic_arithmetic_vector_vector(H-1 downto 0)(DATA_SIZE-1 downto 0);

  -- CONTROLLER OUTPUT VECTOR
  -- CONTROL
  signal start_controller_output_vector : std_logic;
  signal ready_controller_output_vector : std_logic;

  -- DATA
  signal r_in_controller_output_vector   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal nu_in_controller_output_vector  : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal w_in_controller_output_vector   : std_logic_arithmetic_vector_matrix(Y-1 downto 0)(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_controller_output_vector : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);
  signal y_out_controller_output_vector  : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);

  -- CONTROLLER
  -- CONTROL
  signal start_controller : std_logic;
  signal ready_controller : std_logic;

  -- DATA
  signal x_in_controller   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal r_in_controller   : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_controller : std_logic_arithmetic_vector_vector(W-1 downto 0)(DATA_SIZE-1 downto 0);
  signal y_out_controller  : std_logic_arithmetic_vector_vector(Y-1 downto 0)(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- INTPUT GATE VECTOR
  input_gate_vector : ntm_input_gate_vector
    generic map (
      X => X,
      W => W,
      H => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_input_gate_vector,
      READY => ready_input_gate_vector,

      -- DATA
      W_IN => w_in_input_gate_vector,
      K_IN => k_in_input_gate_vector,
      U_IN => u_in_input_gate_vector,

      X_IN => x_in_input_gate_vector,
      R_IN => r_in_input_gate_vector,
      H_IN => h_in_input_gate_vector,

      B_IN => b_in_input_gate_vector,

      MODULO => modulo_input_gate_vector,
      I_OUT  => i_out_input_gate_vector
    );

  -- OUTPUT GATE VECTOR
  output_gate_vector : ntm_output_gate_vector
    generic map (
      X => X,
      W => W,
      H => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_output_gate_vector,
      READY => ready_output_gate_vector,

      -- DATA
      W_IN => w_in_output_gate_vector,
      K_IN => k_in_output_gate_vector,
      U_IN => u_in_output_gate_vector,

      X_IN => x_in_output_gate_vector,
      R_IN => r_in_output_gate_vector,
      H_IN => h_in_output_gate_vector,

      B_IN => b_in_output_gate_vector,

      MODULO => modulo_output_gate_vector,
      O_OUT  => o_out_output_gate_vector
    );

  -- FORGET GATE VECTOR
  forget_gate_vector : ntm_forget_gate_vector
    generic map (
      X => X,
      W => W,
      H => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_forget_gate_vector,
      READY => ready_forget_gate_vector,

      -- DATA
      W_IN => w_in_forget_gate_vector,
      K_IN => k_in_forget_gate_vector,
      U_IN => u_in_forget_gate_vector,

      X_IN => x_in_forget_gate_vector,
      R_IN => r_in_forget_gate_vector,
      H_IN => h_in_forget_gate_vector,

      B_IN => b_in_forget_gate_vector,

      MODULO => modulo_forget_gate_vector,
      F_OUT  => f_out_forget_gate_vector
    );

  -- STATE GATE VECTOR
  state_gate_vector : ntm_state_gate_vector
    generic map (
      X => X,
      W => W,
      H => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_state_gate_vector,
      READY => ready_state_gate_vector,

      -- DATA
      W_IN => w_in_state_gate_vector,
      K_IN => k_in_state_gate_vector,
      U_IN => u_in_state_gate_vector,

      X_IN => x_in_state_gate_vector,
      R_IN => r_in_state_gate_vector,
      I_IN => i_in_state_gate_vector,
      F_IN => f_in_state_gate_vector,
      S_IN => s_in_state_gate_vector,
      H_IN => h_in_state_gate_vector,

      B_IN => b_in_state_gate_vector,

      MODULO => modulo_state_gate_vector,
      S_OUT  => s_out_state_gate_vector
    );

  -- HIDDEN GATE VECTOR
  hidden_gate_vector : ntm_hidden_gate_vector
    generic map (
      H => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_hidden_gate_vector,
      READY => ready_hidden_gate_vector,

      -- DATA
      S_IN => s_in_hidden_gate_vector,
      O_IN => o_in_hidden_gate_vector,

      MODULO => modulo_hidden_gate_vector,
      H_OUT  => h_out_hidden_gate_vector
    );

  -- CONTROLLER OUTPUT VECTOR
  controller_output_vector : ntm_controller_output_vector
    generic map (
      Y => Y,
      W => W,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller_output_vector,
      READY => ready_controller_output_vector,

      -- DATA
      R_IN  => r_in_controller_output_vector,
      NU_IN => nu_in_controller_output_vector,

      W_IN => w_in_controller_output_vector,

      MODULO => modulo_controller_output_vector,
      Y_OUT  => y_out_controller_output_vector
    );

  -- CONTROLLER
  controller_input_matrix : ntm_controller
    generic map (
      X => X,
      Y => Y,
      W => W,
      H => H,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_controller,
      READY => ready_controller,

      -- DATA
      X_IN => x_in_controller,
      R_IN => r_in_controller,

      MODULO => modulo_controller,
      Y_OUT  => y_out_controller
    );

end ntm_standard_lstm_testbench_architecture;
