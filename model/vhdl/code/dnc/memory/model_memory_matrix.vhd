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

use work.model_arithmetic_pkg.all;
use work.model_math_pkg.all;
use work.model_dnc_core_pkg.all;

entity model_memory_matrix is
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

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    V_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1
    E_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    V_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1
    E_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

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

architecture model_memory_matrix_architecture of model_memory_matrix is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- M_IN [R,N]
  -- M_IN [N,N]

  -- Outputs:
  -- M_OUT [R,N]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
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
  type controller_m_out_fsm is (
    STARTER_M_OUT_STATE,                -- STEP 0
    CLEAN_M_OUT_J_STATE,                -- STEP 1
    CLEAN_M_OUT_K_STATE,                -- STEP 2
    OUTPUT_M_OUT_J_STATE,               -- STEP 3
    OUTPUT_M_OUT_K_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_m_in_fsm_int : controller_m_in_fsm;

  signal controller_w_in_fsm_int : controller_w_in_fsm;

  signal controller_in_fsm_int : controller_in_fsm;

  signal controller_m_out_fsm_int : controller_m_out_fsm;

  -- Buffer
  signal matrix_m_in_int : matrix_buffer;

  signal vector_w_in_int : vector_buffer;
  signal vector_v_in_int : vector_buffer;
  signal vector_e_in_int : vector_buffer;

  signal matrix_m_out_int : matrix_buffer;

  -- Control Internal
  signal index_j_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_m_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_m_in_enable_int : std_logic;

  signal data_w_in_enable_int : std_logic;

  signal data_v_in_enable_int : std_logic;
  signal data_e_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

  -- CONTROL
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
            matrix_m_out_int <= function_model_memory_matrix (
              SIZE_N_IN => SIZE_N_IN,
              SIZE_W_IN => SIZE_W_IN,

              matrix_m_input => matrix_m_in_int,

              vector_w_input => vector_w_in_int,
              vector_v_input => vector_v_in_int,
              vector_e_input => vector_e_in_int
              );

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

end architecture;
