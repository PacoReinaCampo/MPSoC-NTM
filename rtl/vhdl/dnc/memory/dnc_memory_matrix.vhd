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

use work.ntm_arithmetic_pkg.all;
use work.ntm_math_pkg.all;

entity dnc_memory_matrix is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    V_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1
    E_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    V_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1
    E_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_memory_matrix_architecture of dnc_memory_matrix is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- M_IN [N,W]
  -- W_IN [N]
  -- E_IN [W]
  -- V_IN [W]

  -- Outputs:
  -- M_OUT [N,W]

  -- States:
  -- INPUT_N_STATE, CLEAN_IN_N_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE
  -- OUTPUT_W_STATE, CLEAN_OUT_W_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_m_in_fsm is (
    STARTER_M_IN_STATE,                 -- STEP 0
    INPUT_M_IN_J_STATE,                 -- STEP 1
    INPUT_M_IN_K_STATE,                 -- STEP 2
    CLEAN_M_IN_J_STATE,                 -- STEP 3
    CLEAN_M_IN_K_STATE                  -- STEP 4
    );

  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_J_STATE,                 -- STEP 2
    CLEAN_W_IN_J_STATE                  -- STEP 1
    );

  type controller_in_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_STATE,                        -- STEP 1
    CLEAN_STATE                         -- STEP 2
    );

  -- Ops
  type controller_transpose_vector_product_fsm is (
    STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 0
    INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 1
    INPUT_J_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 2
    CLEAN_I_TRANSPOSE_VECTOR_PRODUCT_STATE,  -- STEP 3
    CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE   -- STEP 4
    );

  type controller_first_matrix_float_adder_fsm is (
    STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 1
    INPUT_J_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 2
    CLEAN_I_FIRST_MATRIX_FLOAT_ADDER_STATE,  -- STEP 3
    CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE   -- STEP 4
    );

  type controller_matrix_float_multiplier_fsm is (
    STARTER_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 1
    INPUT_J_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 2
    CLEAN_I_MATRIX_FLOAT_MULTIPLIER_STATE,  -- STEP 3
    CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE   -- STEP 4
    );

  type controller_second_matrix_float_adder_fsm is (
    STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 0
    INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 1
    INPUT_J_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 2
    CLEAN_I_SECOND_MATRIX_FLOAT_ADDER_STATE,  -- STEP 3
    CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE   -- STEP 4
    );

  -- Output
  type controller_m_out_fsm is (
    STARTER_M_OUT_STATE,                -- STEP 0
    CLEAN_M_OUT_J_STATE,                -- STEP 1
    CLEAN_M_OUT_K_STATE,                -- STEP 2
    OUTPUT_M_OUT_J_STATE,               -- STEP 3
    OUTPUT_M_OUT_K_STATE                -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_m_in_fsm_int : controller_m_in_fsm;

  signal controller_w_in_fsm_int : controller_w_in_fsm;

  signal controller_in_fsm_int : controller_in_fsm;

  -- Ops
  signal controller_transpose_vector_product_fsm_int  : controller_transpose_vector_product_fsm;
  signal controller_first_matrix_float_adder_fsm_int  : controller_first_matrix_float_adder_fsm;
  signal controller_matrix_float_multiplier_fsm_int   : controller_matrix_float_multiplier_fsm;
  signal controller_second_matrix_float_adder_fsm_int : controller_second_matrix_float_adder_fsm;

  -- Output
  signal controller_m_out_fsm_int : controller_m_out_fsm;

  -- Buffer
  -- Input
  signal matrix_m_in_int : matrix_buffer;

  signal vector_w_in_int : vector_buffer;
  signal vector_v_in_int : vector_buffer;
  signal vector_e_in_int : vector_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal matrix_m_out_int : matrix_buffer;

  -- Control Internal - Index
  -- Input
  signal index_j_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_i_transpose_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_transpose_vector_product_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_matrix_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_float_adder_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_matrix_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_matrix_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_j_m_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Control Internal - Enable
  -- Input
  signal data_m_in_enable_int : std_logic;

  signal data_w_in_enable_int : std_logic;

  signal data_v_in_enable_int : std_logic;
  signal data_e_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

  -- Ops
  signal data_transpose_vector_product_enable_int  : std_logic;
  signal data_first_matrix_float_adder_enable_int  : std_logic;
  signal data_matrix_float_multiplier_enable_int   : std_logic;
  signal data_second_matrix_float_adder_enable_int : std_logic;

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_float_adder : std_logic;
  signal ready_matrix_float_adder : std_logic;

  signal operation_matrix_float_adder : std_logic;

  signal data_a_in_i_enable_matrix_float_adder : std_logic;
  signal data_a_in_j_enable_matrix_float_adder : std_logic;
  signal data_b_in_i_enable_matrix_float_adder : std_logic;
  signal data_b_in_j_enable_matrix_float_adder : std_logic;

  signal data_out_i_enable_matrix_float_adder : std_logic;
  signal data_out_j_enable_matrix_float_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_float_multiplier : std_logic;
  signal ready_matrix_float_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_float_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_float_multiplier : std_logic;

  signal data_out_i_enable_matrix_float_multiplier : std_logic;
  signal data_out_j_enable_matrix_float_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_float_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TRANSPOSE VECTOR PRODUCT
  -- CONTROL
  signal start_transpose_vector_product : std_logic;
  signal ready_transpose_vector_product : std_logic;

  signal data_a_in_enable_transpose_vector_product : std_logic;
  signal data_b_in_enable_transpose_vector_product : std_logic;

  signal data_enable_transpose_vector_product : std_logic;

  signal data_out_i_enable_transpose_vector_product : std_logic;
  signal data_out_j_enable_transpose_vector_product : std_logic;

  -- DATA
  signal size_a_in_transpose_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_in_transpose_vector_product : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_transpose_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_transpose_vector_product : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_transpose_vector_product  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX PRODUCT
  -- CONTROL
  signal start_matrix_product : std_logic;
  signal ready_matrix_product : std_logic;

  signal data_a_in_i_enable_matrix_product : std_logic;
  signal data_a_in_j_enable_matrix_product : std_logic;
  signal data_b_in_i_enable_matrix_product : std_logic;
  signal data_b_in_j_enable_matrix_product : std_logic;

  signal data_out_i_enable_matrix_product : std_logic;
  signal data_out_j_enable_matrix_product : std_logic;

  -- DATA
  signal size_a_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_a_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_i_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_b_j_in_matrix_product : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_product   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_product    : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

  -- INPUT CONTROL
  m_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      M_OUT_J_ENABLE <= '0';
      M_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_j_m_in_loop <= ZERO_CONTROL;
      index_k_m_in_loop <= ZERO_CONTROL;

      data_m_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_m_in_fsm_int is
        when STARTER_M_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_in_loop <= ZERO_CONTROL;
            index_k_m_in_loop <= ZERO_CONTROL;

            data_m_in_enable_int <= '0';

            -- FSM Control
            controller_m_in_fsm_int <= INPUT_M_IN_J_STATE;
          else
            -- Control Outputs
            M_OUT_J_ENABLE <= '0';
            M_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_M_IN_J_STATE =>      -- STEP 1

          if ((M_IN_J_ENABLE = '1') and (M_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_m_in_int(to_integer(unsigned(index_j_m_in_loop)), to_integer(unsigned(index_k_m_in_loop))) <= M_IN;

            -- FSM Control
            controller_m_in_fsm_int <= CLEAN_M_IN_K_STATE;
          end if;

          -- Control Outputs
          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

        when INPUT_M_IN_K_STATE =>      -- STEP 2

          if (M_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_m_in_int(to_integer(unsigned(index_j_m_in_loop)), to_integer(unsigned(index_k_m_in_loop))) <= M_IN;

            -- FSM Control
            if (unsigned(index_k_m_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_m_in_fsm_int <= CLEAN_M_IN_J_STATE;
            else
              controller_m_in_fsm_int <= CLEAN_M_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          M_OUT_K_ENABLE <= '0';

        when CLEAN_M_IN_J_STATE =>      -- STEP 3

          if ((unsigned(index_j_m_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_m_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_in_loop <= ZERO_CONTROL;
            index_k_m_in_loop <= ZERO_CONTROL;

            data_m_in_enable_int <= '1';

            -- FSM Control
            controller_m_in_fsm_int <= STARTER_M_IN_STATE;
          elsif ((unsigned(index_j_m_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_m_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_in_loop <= std_logic_vector(unsigned(index_j_m_in_loop) + unsigned(ONE_CONTROL));
            index_k_m_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_m_in_fsm_int <= INPUT_M_IN_J_STATE;
          end if;

        when CLEAN_M_IN_K_STATE =>      -- STEP 4

          if (unsigned(index_k_m_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_m_in_loop <= std_logic_vector(unsigned(index_k_m_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_m_in_fsm_int <= INPUT_M_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_m_in_fsm_int <= STARTER_M_IN_STATE;
      end case;
    end if;
  end process;

  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_j_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';
    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_J_STATE;
          end if;

        when INPUT_W_IN_J_STATE =>      -- STEP 1

          if (W_IN_J_ENABLE = '1') then
            -- Data Inputs
            vector_w_in_int(to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
          end if;

          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

        when CLEAN_W_IN_J_STATE =>      -- STEP 2

          if (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif (unsigned(index_j_w_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_j_w_in_loop <= std_logic_vector(unsigned(index_j_w_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_in_fsm_int <= STARTER_W_IN_STATE;
      end case;
    end if;
  end process;

  in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      V_OUT_K_ENABLE <= '0';
      E_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_j_in_loop <= ZERO_CONTROL;

      data_v_in_enable_int <= '0';
      data_e_in_enable_int <= '0';

      data_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_in_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          if (START = '1') then
            -- Control Outputs
            V_OUT_K_ENABLE <= '1';
            E_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= ZERO_CONTROL;

            data_v_in_enable_int <= '0';
            data_e_in_enable_int <= '0';

            data_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          else
            -- Control Outputs
            V_OUT_K_ENABLE <= '0';
            E_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_STATE =>             -- STEP 1

          if (V_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_v_in_int(to_integer(unsigned(index_j_in_loop))) <= V_IN;

            -- Control Internal
            data_v_in_enable_int <= '1';
          end if;

          if (E_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_e_in_int(to_integer(unsigned(index_j_in_loop))) <= E_IN;

            -- Control Internal
            data_e_in_enable_int <= '1';
          end if;

          -- Control Outputs
          V_OUT_K_ENABLE <= '0';
          E_OUT_K_ENABLE <= '0';

          if (data_v_in_enable_int = '1' and data_e_in_enable_int = '1') then
            -- Control Internal
            data_v_in_enable_int <= '0';
            data_e_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= CLEAN_STATE;
          end if;

        when CLEAN_STATE =>             -- STEP 2

          if (unsigned(index_j_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_K_ENABLE <= '1';
            E_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= ZERO_CONTROL;

            data_in_enable_int <= '1';

            -- FSM Control
            controller_in_fsm_int <= STARTER_STATE;
          elsif (unsigned(index_j_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            V_OUT_K_ENABLE <= '1';
            E_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= std_logic_vector(unsigned(index_j_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_in_fsm_int <= INPUT_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_in_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  transpose_vector_product_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_transpose_vector_product <= '0';
      data_b_in_enable_transpose_vector_product <= '0';

      data_transpose_vector_product_enable_int <= '0';

      index_i_transpose_vector_product_loop <= ZERO_CONTROL;
      index_j_transpose_vector_product_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_transpose_vector_product_fsm_int is
        when STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_transpose_vector_product <= '0';
          data_b_in_enable_transpose_vector_product <= '0';

          data_transpose_vector_product_enable_int <= '0';

          if (data_m_in_enable_int = '1' and data_w_in_enable_int = '1') then
            -- Data Inputs
            size_a_in_transpose_vector_product <= SIZE_N_IN;
            size_b_in_transpose_vector_product <= SIZE_N_IN;

            -- Control Internal
            index_i_transpose_vector_product_loop <= ZERO_CONTROL;
            index_j_transpose_vector_product_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_transpose_vector_product_fsm_int <= INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
          end if;

        when INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 1

          -- Data Inputs
          data_a_in_transpose_vector_product <= vector_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)));

          -- Control Internal
          if (unsigned(index_i_transpose_vector_product_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_transpose_vector_product_loop) = unsigned(ZERO_CONTROL)) then
            start_transpose_vector_product <= '1';
          end if;

          data_a_in_enable_transpose_vector_product <= '1';
          data_b_in_enable_transpose_vector_product <= '1';

          -- FSM Control
          controller_transpose_vector_product_fsm_int <= CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE;

        when INPUT_J_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 2

          -- Data Inputs
          data_a_in_transpose_vector_product <= vector_operation_int(to_integer(unsigned(index_j_transpose_vector_product_loop)));

          -- Control Internal
          data_b_in_enable_transpose_vector_product <= '1';

          -- FSM Control
          if (unsigned(index_j_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_transpose_vector_product_fsm_int <= CLEAN_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
          else
            controller_transpose_vector_product_fsm_int <= CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE;
          end if;

        when CLEAN_I_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 3

          if (data_out_i_enable_transpose_vector_product = '1' and data_out_j_enable_transpose_vector_product = '1') then
            if ((unsigned(index_i_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)), to_integer(unsigned(index_j_transpose_vector_product_loop))) <= data_out_transpose_vector_product;

              -- Control Internal
              data_transpose_vector_product_enable_int <= '1';

              index_i_transpose_vector_product_loop <= ZERO_CONTROL;
              index_j_transpose_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_transpose_vector_product_fsm_int <= STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE;
            elsif ((unsigned(index_i_transpose_vector_product_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_transpose_vector_product_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)), to_integer(unsigned(index_j_transpose_vector_product_loop))) <= data_out_transpose_vector_product;

              -- Control Internal
              index_i_transpose_vector_product_loop <= std_logic_vector(unsigned(index_i_transpose_vector_product_loop) + unsigned(ONE_CONTROL));
              index_j_transpose_vector_product_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_transpose_vector_product_fsm_int <= INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_transpose_vector_product <= '0';

            data_a_in_enable_transpose_vector_product <= '0';
            data_b_in_enable_transpose_vector_product <= '0';
          end if;

        when CLEAN_J_TRANSPOSE_VECTOR_PRODUCT_STATE =>  -- STEP 4

          if (data_out_i_enable_transpose_vector_product = '1') then
            if (unsigned(index_j_transpose_vector_product_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_transpose_vector_product_loop)), to_integer(unsigned(index_j_transpose_vector_product_loop))) <= data_out_transpose_vector_product;

              -- Control Internal
              index_j_transpose_vector_product_loop <= std_logic_vector(unsigned(index_j_transpose_vector_product_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_transpose_vector_product_fsm_int <= INPUT_I_TRANSPOSE_VECTOR_PRODUCT_STATE;
            end if;
          else
            -- Control Internal
            start_transpose_vector_product <= '0';

            data_a_in_enable_transpose_vector_product <= '0';
            data_b_in_enable_transpose_vector_product <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_transpose_vector_product_fsm_int <= STARTER_TRANSPOSE_VECTOR_PRODUCT_STATE;
      end case;
    end if;
  end process;

  first_matrix_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_adder <= '0';
      data_a_in_j_enable_matrix_float_adder <= '0';
      data_b_in_i_enable_matrix_float_adder <= '0';
      data_b_in_j_enable_matrix_float_adder <= '0';

      data_first_matrix_float_adder_enable_int <= '0';

      index_i_matrix_float_adder_loop <= ZERO_CONTROL;
      index_j_matrix_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_first_matrix_float_adder_fsm_int is
        when STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_adder <= '0';
          data_a_in_j_enable_matrix_float_adder <= '0';
          data_b_in_i_enable_matrix_float_adder <= '0';
          data_b_in_j_enable_matrix_float_adder <= '0';

          data_first_matrix_float_adder_enable_int <= '0';

          if (data_m_in_enable_int = '1' and data_m_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_adder <= SIZE_N_IN;
            size_j_in_matrix_float_adder <= SIZE_W_IN;

            -- Control Internal
            index_i_matrix_float_adder_loop <= ZERO_CONTROL;
            index_j_matrix_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_first_matrix_float_adder_fsm_int <= INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_adder <= '1';
          end if;

          data_a_in_i_enable_matrix_float_adder <= '1';
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_i_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          controller_first_matrix_float_adder_fsm_int <= CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE;

        when INPUT_J_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_first_matrix_float_adder_fsm_int <= CLEAN_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
          else
            controller_first_matrix_float_adder_fsm_int <= CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when CLEAN_I_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              data_first_matrix_float_adder_enable_int <= '1';

              index_i_matrix_float_adder_loop <= ZERO_CONTROL;
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_float_adder_fsm_int <= STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE;
            elsif ((unsigned(index_i_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_i_matrix_float_adder_loop <= std_logic_vector(unsigned(index_i_matrix_float_adder_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_first_matrix_float_adder_fsm_int <= INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when CLEAN_J_FIRST_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_adder = '1') then
            if (unsigned(index_j_matrix_float_adder_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_j_matrix_float_adder_loop <= std_logic_vector(unsigned(index_j_matrix_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_first_matrix_float_adder_fsm_int <= INPUT_I_FIRST_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_first_matrix_float_adder_fsm_int <= STARTER_FIRST_MATRIX_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  matrix_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_multiplier <= '0';
      data_a_in_j_enable_matrix_float_multiplier <= '0';
      data_b_in_i_enable_matrix_float_multiplier <= '0';
      data_b_in_j_enable_matrix_float_multiplier <= '0';

      data_matrix_float_multiplier_enable_int <= '0';

      index_i_matrix_float_multiplier_loop <= ZERO_CONTROL;
      index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_matrix_float_multiplier_fsm_int is
        when STARTER_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_multiplier <= '0';
          data_a_in_j_enable_matrix_float_multiplier <= '0';
          data_b_in_i_enable_matrix_float_multiplier <= '0';
          data_b_in_j_enable_matrix_float_multiplier <= '0';

          data_matrix_float_multiplier_enable_int <= '0';

          if (data_m_in_enable_int = '1' and data_m_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_multiplier <= SIZE_N_IN;
            size_j_in_matrix_float_multiplier <= SIZE_W_IN;

            -- Control Internal
            index_i_matrix_float_multiplier_loop <= ZERO_CONTROL;
            index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_matrix_float_multiplier_fsm_int <= INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE;
          end if;

        when INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));
          data_b_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_multiplier_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_multiplier_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_multiplier <= '1';
          end if;

          data_a_in_i_enable_matrix_float_multiplier <= '1';
          data_a_in_j_enable_matrix_float_multiplier <= '1';
          data_b_in_i_enable_matrix_float_multiplier <= '1';
          data_b_in_j_enable_matrix_float_multiplier <= '1';

          -- FSM Control
          controller_matrix_float_multiplier_fsm_int <= CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE;

        when INPUT_J_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));
          data_b_in_matrix_float_multiplier <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_multiplier <= '1';
          data_b_in_j_enable_matrix_float_multiplier <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_matrix_float_multiplier_fsm_int <= CLEAN_I_MATRIX_FLOAT_MULTIPLIER_STATE;
          else
            controller_matrix_float_multiplier_fsm_int <= CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE;
          end if;

        when CLEAN_I_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_multiplier = '1' and data_out_i_enable_matrix_float_multiplier = '1') then
            if ((unsigned(index_i_matrix_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              data_matrix_float_multiplier_enable_int <= '1';

              index_i_matrix_float_multiplier_loop <= ZERO_CONTROL;
              index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= STARTER_MATRIX_FLOAT_MULTIPLIER_STATE;
            elsif ((unsigned(index_i_matrix_float_multiplier_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_multiplier_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              index_i_matrix_float_multiplier_loop <= std_logic_vector(unsigned(index_i_matrix_float_multiplier_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_multiplier <= '0';

            data_a_in_i_enable_matrix_float_multiplier <= '0';
            data_a_in_j_enable_matrix_float_multiplier <= '0';
            data_b_in_i_enable_matrix_float_multiplier <= '0';
            data_b_in_j_enable_matrix_float_multiplier <= '0';
          end if;

        when CLEAN_J_MATRIX_FLOAT_MULTIPLIER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_multiplier = '1') then
            if (unsigned(index_j_matrix_float_multiplier_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_multiplier_loop)), to_integer(unsigned(index_j_matrix_float_multiplier_loop))) <= data_out_matrix_float_multiplier;

              -- Control Internal
              index_j_matrix_float_multiplier_loop <= std_logic_vector(unsigned(index_j_matrix_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_matrix_float_multiplier_fsm_int <= INPUT_I_MATRIX_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_multiplier <= '0';

            data_a_in_i_enable_matrix_float_multiplier <= '0';
            data_a_in_j_enable_matrix_float_multiplier <= '0';
            data_b_in_i_enable_matrix_float_multiplier <= '0';
            data_b_in_j_enable_matrix_float_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_matrix_float_multiplier_fsm_int <= STARTER_MATRIX_FLOAT_MULTIPLIER_STATE;
      end case;
    end if;
  end process;

  second_matrix_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_i_enable_matrix_float_adder <= '0';
      data_a_in_j_enable_matrix_float_adder <= '0';
      data_b_in_i_enable_matrix_float_adder <= '0';
      data_b_in_j_enable_matrix_float_adder <= '0';

      data_second_matrix_float_adder_enable_int <= '0';

      index_i_matrix_float_adder_loop <= ZERO_CONTROL;
      index_j_matrix_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_second_matrix_float_adder_fsm_int is
        when STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_i_enable_matrix_float_adder <= '0';
          data_a_in_j_enable_matrix_float_adder <= '0';
          data_b_in_i_enable_matrix_float_adder <= '0';
          data_b_in_j_enable_matrix_float_adder <= '0';

          data_second_matrix_float_adder_enable_int <= '0';

          if (data_m_in_enable_int = '1' and data_m_in_enable_int = '1') then
            -- Data Inputs
            size_i_in_matrix_float_adder <= SIZE_N_IN;
            size_j_in_matrix_float_adder <= SIZE_W_IN;

            -- Control Internal
            index_i_matrix_float_adder_loop <= ZERO_CONTROL;
            index_j_matrix_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_second_matrix_float_adder_fsm_int <= INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_i_matrix_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_matrix_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_matrix_float_adder <= '1';
          end if;

          data_a_in_i_enable_matrix_float_adder <= '1';
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_i_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          controller_second_matrix_float_adder_fsm_int <= CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE;

        when INPUT_J_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 6

          -- Data Inputs
          data_a_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));
          data_b_in_matrix_float_adder <= matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop)));

          -- Control Internal
          data_a_in_j_enable_matrix_float_adder <= '1';
          data_b_in_j_enable_matrix_float_adder <= '1';

          -- FSM Control
          if (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_second_matrix_float_adder_fsm_int <= CLEAN_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
          else
            controller_second_matrix_float_adder_fsm_int <= CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE;
          end if;

        when CLEAN_I_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_i_enable_matrix_float_adder = '1' and data_out_i_enable_matrix_float_adder = '1') then
            if ((unsigned(index_i_matrix_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              data_second_matrix_float_adder_enable_int <= '1';

              index_i_matrix_float_adder_loop <= ZERO_CONTROL;
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_float_adder_fsm_int <= STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE;
            elsif ((unsigned(index_i_matrix_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_matrix_float_adder_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_i_matrix_float_adder_loop <= std_logic_vector(unsigned(index_i_matrix_float_adder_loop) + unsigned(ONE_CONTROL));
              index_j_matrix_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_second_matrix_float_adder_fsm_int <= INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when CLEAN_J_SECOND_MATRIX_FLOAT_ADDER_STATE =>  -- STEP 8

          if (data_out_i_enable_matrix_float_adder = '1') then
            if (unsigned(index_j_matrix_float_adder_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              matrix_operation_int(to_integer(unsigned(index_i_matrix_float_adder_loop)), to_integer(unsigned(index_j_matrix_float_adder_loop))) <= data_out_matrix_float_adder;

              -- Control Internal
              index_j_matrix_float_adder_loop <= std_logic_vector(unsigned(index_j_matrix_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_second_matrix_float_adder_fsm_int <= INPUT_I_SECOND_MATRIX_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_matrix_float_adder <= '0';

            data_a_in_i_enable_matrix_float_adder <= '0';
            data_a_in_j_enable_matrix_float_adder <= '0';
            data_b_in_i_enable_matrix_float_adder <= '0';
            data_b_in_j_enable_matrix_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_second_matrix_float_adder_fsm_int <= STARTER_SECOND_MATRIX_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  m_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      M_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      M_OUT_J_ENABLE <= '0';
      M_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_j_m_out_loop <= ZERO_CONTROL;
      index_k_m_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_m_out_fsm_int is
        when STARTER_M_OUT_STATE =>     -- STEP 0
          if (data_m_in_enable_int = '1' and data_w_in_enable_int = '1' and data_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_j_m_out_loop <= ZERO_CONTROL;
            index_k_m_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_m_out_fsm_int <= CLEAN_M_OUT_J_STATE;
          end if;

        when CLEAN_M_OUT_J_STATE =>     -- STEP 1
          -- Control Outputs
          M_OUT_J_ENABLE <= '0';
          M_OUT_K_ENABLE <= '0';

          -- FSM Control
          controller_m_out_fsm_int <= OUTPUT_M_OUT_K_STATE;

        when CLEAN_M_OUT_K_STATE =>     -- STEP 2

          -- Control Outputs
          M_OUT_K_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_k_m_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_m_out_fsm_int <= OUTPUT_M_OUT_J_STATE;
          else
            controller_m_out_fsm_int <= OUTPUT_M_OUT_K_STATE;
          end if;

        when OUTPUT_M_OUT_J_STATE =>    -- STEP 3

          if ((unsigned(index_j_m_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_m_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            M_OUT <= matrix_m_out_int(to_integer(unsigned(index_j_m_out_loop)), to_integer(unsigned(index_k_m_out_loop)));

            -- Control Outputs
            READY <= '1';

            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_out_loop <= ZERO_CONTROL;
            index_k_m_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_m_out_fsm_int <= STARTER_M_OUT_STATE;
          elsif ((unsigned(index_j_m_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_m_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            M_OUT <= matrix_m_out_int(to_integer(unsigned(index_j_m_out_loop)), to_integer(unsigned(index_k_m_out_loop)));

            -- Control Outputs
            M_OUT_J_ENABLE <= '1';
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_m_out_loop <= std_logic_vector(unsigned(index_j_m_out_loop) + unsigned(ONE_CONTROL));
            index_k_m_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_m_out_fsm_int <= CLEAN_M_OUT_J_STATE;
          end if;

        when OUTPUT_M_OUT_K_STATE =>    -- STEP 4

          if (unsigned(index_k_m_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            M_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_m_out_loop <= std_logic_vector(unsigned(index_k_m_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_m_out_fsm_int <= CLEAN_M_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_m_out_fsm_int <= STARTER_M_OUT_STATE;
      end case;
    end if;
  end process;

  -- MATRIX ADDER
  matrix_float_adder : ntm_matrix_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_float_adder,
      READY => ready_matrix_float_adder,

      OPERATION => operation_matrix_float_adder,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_adder,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_adder,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_adder,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_adder,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_adder,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_adder,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_float_adder,
      SIZE_J_IN => size_j_in_matrix_float_adder,
      DATA_A_IN => data_a_in_matrix_float_adder,
      DATA_B_IN => data_b_in_matrix_float_adder,
      DATA_OUT  => data_out_matrix_float_adder
      );

  -- MATRIX MULTIPLIER
  matrix_float_multiplier : ntm_matrix_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_float_multiplier,
      READY => ready_matrix_float_multiplier,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_float_multiplier,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_float_multiplier,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_float_multiplier,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_float_multiplier,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_float_multiplier,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_float_multiplier,

      -- DATA
      SIZE_I_IN => size_i_in_matrix_float_multiplier,
      SIZE_J_IN => size_j_in_matrix_float_multiplier,
      DATA_A_IN => data_a_in_matrix_float_multiplier,
      DATA_B_IN => data_b_in_matrix_float_multiplier,
      DATA_OUT  => data_out_matrix_float_multiplier
      );

  -- TRANSPOSE VECTOR PRODUCT
  transpose_vector_product : ntm_transpose_vector_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_transpose_vector_product,
      READY => ready_transpose_vector_product,

      DATA_A_IN_ENABLE => data_a_in_enable_transpose_vector_product,
      DATA_B_IN_ENABLE => data_b_in_enable_transpose_vector_product,

      DATA_ENABLE => data_enable_transpose_vector_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_transpose_vector_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_transpose_vector_product,

      -- DATA
      SIZE_A_IN => size_a_in_transpose_vector_product,
      SIZE_B_IN => size_b_in_transpose_vector_product,

      DATA_A_IN => data_a_in_transpose_vector_product,
      DATA_B_IN => data_b_in_transpose_vector_product,
      DATA_OUT  => data_out_transpose_vector_product
      );

  -- MATRIX PRODUCT
  matrix_product : ntm_matrix_product
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_product,
      READY => ready_matrix_product,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_product,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_product,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_product,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_product,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_product,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_product,

      -- DATA
      SIZE_A_I_IN => size_a_i_in_matrix_product,
      SIZE_A_J_IN => size_a_j_in_matrix_product,
      SIZE_B_I_IN => size_b_i_in_matrix_product,
      SIZE_B_J_IN => size_b_j_in_matrix_product,
      DATA_A_IN   => data_a_in_matrix_product,
      DATA_B_IN   => data_b_in_matrix_product,
      DATA_OUT    => data_out_matrix_product
      );

end architecture;