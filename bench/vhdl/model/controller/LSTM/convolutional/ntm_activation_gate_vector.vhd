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
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;

entity ntm_activation_gate_vector is
  generic (
    DATA_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    W_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    W_IN_X_ENABLE : in std_logic;       -- for x in 0 to X-1
    X_IN_ENABLE   : in std_logic;       -- for x in 0 to X-1

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    K_IN_L_ENABLE : in std_logic;       -- for l in 0 to L-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1
    R_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1 (read heads flow)
    R_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    U_IN_ENABLE : in std_logic;         -- for l in 0 to L-1 (square matrix)
    H_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    B_IN_ENABLE : in std_logic;         -- for l in 0 to L-1

    A_OUT_ENABLE : out std_logic;       -- for l in 0 to L-1

    -- DATA
    SIZE_X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_L_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    X_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    H_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_activation_gate_vector_architecture of ntm_activation_gate_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,  -- STEP 0
    MATRIX_FIRST_CONVOLUTION_STATE,  -- STEP 1
    VECTOR_FIRST_ADDER_STATE,  -- STEP 2
    MATRIX_SECOND_CONVOLUTION_STATE,  -- STEP 3
    VECTOR_SECOND_ADDER_STATE,  -- STEP 4
    MATRIX_THIRD_CONVOLUTION_STATE,  -- STEP 5
    VECTOR_THIRD_ADDER_STATE,  -- STEP 6
    MATRIX_FOURTH_CONVOLUTION_STATE,  -- STEP 7
    VECTOR_FOURTH_ADDER_STATE,  -- STEP 8
    VECTOR_TANH_STATE  -- STEP 9
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  signal data_a_in_enable_vector_adder : std_logic;
  signal data_b_in_enable_vector_adder : std_logic;

  signal data_out_enable_vector_adder : std_logic;

  -- DATA
  signal modulo_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_adder   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX CONVOLUTION
  -- CONTROL
  signal start_matrix_convolution : std_logic;
  signal ready_matrix_convolution : std_logic;

  signal data_a_in_matrix_enable_matrix_convolution : std_logic;
  signal data_a_in_vector_enable_matrix_convolution : std_logic;
  signal data_a_in_scalar_enable_matrix_convolution : std_logic;
  signal data_b_in_matrix_enable_matrix_convolution : std_logic;
  signal data_b_in_vector_enable_matrix_convolution : std_logic;
  signal data_b_in_scalar_enable_matrix_convolution : std_logic;

  signal data_out_matrix_enable_matrix_convolution : std_logic;
  signal data_out_vector_enable_matrix_convolution : std_logic;
  signal data_out_scalar_enable_matrix_convolution : std_logic;

  -- DATA
  signal modulo_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_convolution : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_convolution  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR TANH
  -- CONTROL
  signal start_vector_tanh : std_logic;
  signal ready_vector_tanh : std_logic;

  signal data_in_enable_vector_tanh : std_logic;

  signal data_out_enable_vector_tanh : std_logic;

  -- DATA
  signal modulo_in_vector_tanh : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_tanh   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_tanh  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- a(t;l) = tanh(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + U(l;l)*h(t-1;l) + U(l-1;l-1)*h(t;l-1) + b(t;l))

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      A_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_loop <= ZERO;

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= MATRIX_FIRST_CONVOLUTION_STATE;
          end if;

        when MATRIX_FIRST_CONVOLUTION_STATE =>  -- STEP 1

          -- Data Inputs
          modulo_in_matrix_convolution <= FULL;
          size_i_in_matrix_convolution <= FULL;
          size_j_in_matrix_convolution <= FULL;
          length_in_matrix_convolution <= FULL;
          data_a_in_matrix_convolution <= W_IN;
          data_b_in_matrix_convolution <= X_IN;

        when VECTOR_FIRST_ADDER_STATE =>  -- STEP 2

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= FULL;
          data_a_in_vector_adder <= data_out_matrix_convolution;
          data_b_in_vector_adder <= B_IN;

        when MATRIX_SECOND_CONVOLUTION_STATE =>  -- STEP 3

          -- Data Inputs
          modulo_in_matrix_convolution <= FULL;
          size_i_in_matrix_convolution <= FULL;
          size_j_in_matrix_convolution <= FULL;
          length_in_matrix_convolution <= FULL;
          data_a_in_matrix_convolution <= K_IN;
          data_b_in_matrix_convolution <= R_IN;

        when VECTOR_SECOND_ADDER_STATE =>  -- STEP 4

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= FULL;
          data_a_in_vector_adder <= data_out_matrix_convolution;
          data_b_in_vector_adder <= data_out_vector_adder;

        when MATRIX_THIRD_CONVOLUTION_STATE =>  -- STEP 5

          -- Data Inputs
          modulo_in_matrix_convolution <= FULL;
          size_i_in_matrix_convolution <= FULL;
          size_j_in_matrix_convolution <= FULL;
          length_in_matrix_convolution <= FULL;
          data_a_in_matrix_convolution <= U_IN;
          data_b_in_matrix_convolution <= H_IN;

        when VECTOR_THIRD_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= FULL;
          data_a_in_vector_adder <= data_out_matrix_convolution;
          data_b_in_vector_adder <= data_out_vector_adder;

        when MATRIX_FOURTH_CONVOLUTION_STATE =>  -- STEP 7

          -- Data Inputs
          modulo_in_matrix_convolution <= FULL;
          size_i_in_matrix_convolution <= FULL;
          size_j_in_matrix_convolution <= FULL;
          length_in_matrix_convolution <= FULL;
          data_a_in_matrix_convolution <= U_IN;
          data_b_in_matrix_convolution <= H_IN;

        when VECTOR_FOURTH_ADDER_STATE =>  -- STEP 8

          -- Data Inputs
          modulo_in_vector_adder <= FULL;
          size_in_vector_adder   <= FULL;
          data_a_in_vector_adder <= data_out_matrix_convolution;
          data_b_in_vector_adder <= data_out_vector_adder;

        when VECTOR_TANH_STATE =>  -- STEP 9

          -- Data Inputs
          modulo_in_vector_tanh <= FULL;
          size_in_vector_tanh   <= FULL;
          data_in_vector_tanh   <= FULL;

          if (data_out_enable_vector_tanh = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_L_IN) - unsigned(ONE)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= MATRIX_FIRST_CONVOLUTION_STATE;
            end if;

            -- Data Outputs
            A_OUT <= data_out_vector_tanh;

            -- Control Outputs
            A_OUT_ENABLE <= '1';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_adder,

      -- DATA
      MODULO_IN => modulo_in_vector_adder,
      SIZE_IN   => size_in_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
      );

  -- MATRIX CONVOLUTION
  matrix_convolution_function : ntm_matrix_convolution_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_convolution,
      READY => ready_matrix_convolution,

      DATA_A_IN_MATRIX_ENABLE => data_a_in_matrix_enable_matrix_convolution,
      DATA_A_IN_VECTOR_ENABLE => data_a_in_vector_enable_matrix_convolution,
      DATA_A_IN_SCALAR_ENABLE => data_a_in_scalar_enable_matrix_convolution,
      DATA_B_IN_MATRIX_ENABLE => data_b_in_matrix_enable_matrix_convolution,
      DATA_B_IN_VECTOR_ENABLE => data_b_in_vector_enable_matrix_convolution,
      DATA_B_IN_SCALAR_ENABLE => data_b_in_scalar_enable_matrix_convolution,

      DATA_OUT_MATRIX_ENABLE => data_out_matrix_enable_matrix_convolution,
      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_matrix_convolution,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_matrix_convolution,

      -- DATA
      MODULO_IN => modulo_in_matrix_convolution,
      SIZE_I_IN => size_i_in_matrix_convolution,
      SIZE_J_IN => size_j_in_matrix_convolution,
      LENGTH_IN => length_in_matrix_convolution,
      DATA_A_IN => data_a_in_matrix_convolution,
      DATA_B_IN => data_b_in_matrix_convolution,
      DATA_OUT  => data_out_matrix_convolution
      );

  -- VECTOR TANH
  vector_tanh_function : ntm_vector_tanh_function
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_tanh,
      READY => ready_vector_tanh,

      DATA_IN_ENABLE => data_in_enable_vector_tanh,

      DATA_OUT_ENABLE => data_out_enable_vector_tanh,

      -- DATA
      MODULO_IN => modulo_in_vector_tanh,
      SIZE_IN   => size_in_vector_tanh,
      DATA_IN   => data_in_vector_tanh,
      DATA_OUT  => data_out_vector_tanh
      );

end architecture;
