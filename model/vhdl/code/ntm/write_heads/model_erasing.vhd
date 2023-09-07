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

use work.model_arithmetic_vhdl_pkg.all;
use work.model_math_vhdl_pkg.all;
use work.model_ntm_core_vhdl_pkg.all;

entity model_erasing is
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

    M_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1
    M_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    E_IN_ENABLE : in std_logic;         -- for k in 0 to W-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    E_OUT_ENABLE : out std_logic;       -- for k in 0 to W-1

    M_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1
    M_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    M_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    E_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    M_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_erasing_architecture of model_erasing is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- M_IN [N,W]
  -- W_IN [N]
  -- E_IN [W]

  -- Outputs:
  -- M_OUT [N,W]

  -- States:
  -- INPUT_N_STATE, CLEAN_IN_N_STATE
  -- INPUT_W_STATE, CLEAN_IN_W_STATE

  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE
  -- OUTPUT_W_STATE, CLEAN_OUT_W_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_w_in_fsm is (
    STARTER_W_IN_STATE,                 -- STEP 0
    INPUT_W_IN_I_STATE,                 -- STEP 1
    INPUT_W_IN_J_STATE,                 -- STEP 2
    CLEAN_W_IN_I_STATE,                 -- STEP 3
    CLEAN_W_IN_J_STATE                  -- STEP 4
    );

  type controller_m_in_fsm is (
    STARTER_M_IN_STATE,                 -- STEP 0
    INPUT_M_IN_J_STATE,                 -- STEP 1
    INPUT_M_IN_K_STATE,                 -- STEP 2
    CLEAN_M_IN_J_STATE,                 -- STEP 3
    CLEAN_M_IN_K_STATE                  -- STEP 4
    );

  type controller_e_in_fsm is (
    STARTER_E_IN_STATE,                 -- STEP 0
    INPUT_E_IN_STATE,                   -- STEP 1
    CLEAN_E_IN_STATE                    -- STEP 2
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
  signal controller_w_in_fsm_int : controller_w_in_fsm;
  signal controller_m_in_fsm_int : controller_m_in_fsm;
  signal controller_e_in_fsm_int : controller_e_in_fsm;

  signal controller_m_out_fsm_int : controller_m_out_fsm;

  -- Buffer
  signal matrix_w_in_int : matrix_buffer;
  signal matrix_m_in_int : matrix_buffer;
  signal vector_e_in_int : vector_buffer;

  signal matrix_m_out_int : matrix_buffer;

  -- Control Internal
  signal index_i_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_w_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_k_e_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_j_m_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_m_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_w_in_enable_int : std_logic;
  signal data_m_in_enable_int : std_logic;
  signal data_e_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- M(t;j;k) = M(t;j;k)·(1 - w(t;i;j)·e(t;k))

  -- CONTROL
  w_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      W_OUT_I_ENABLE <= '0';
      W_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_w_in_loop <= ZERO_CONTROL;
      index_j_w_in_loop <= ZERO_CONTROL;

      data_w_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_w_in_fsm_int is
        when STARTER_W_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= ZERO_CONTROL;
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '0';

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_I_STATE;
          else
            -- Control Outputs
            W_OUT_I_ENABLE <= '0';
            W_OUT_J_ENABLE <= '0';
          end if;

        when INPUT_W_IN_I_STATE =>      -- STEP 1

          if ((W_IN_I_ENABLE = '1') and (W_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_i_w_in_loop)), to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
          end if;

          -- Control Outputs
          W_OUT_I_ENABLE <= '0';
          W_OUT_J_ENABLE <= '0';

        when INPUT_W_IN_J_STATE =>      -- STEP 2

          if (W_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_w_in_int(to_integer(unsigned(index_i_w_in_loop)), to_integer(unsigned(index_j_w_in_loop))) <= W_IN;

            -- FSM Control
            if (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_w_in_fsm_int <= CLEAN_W_IN_I_STATE;
            else
              controller_w_in_fsm_int <= CLEAN_W_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

        when CLEAN_W_IN_I_STATE =>      -- STEP 3

          if ((unsigned(index_i_w_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= ZERO_CONTROL;
            index_j_w_in_loop <= ZERO_CONTROL;

            data_w_in_enable_int <= '1';

            -- FSM Control
            controller_w_in_fsm_int <= STARTER_W_IN_STATE;
          elsif ((unsigned(index_i_w_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_in_loop <= std_logic_vector(unsigned(index_i_w_in_loop) + unsigned(ONE_CONTROL));
            index_j_w_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_in_fsm_int <= INPUT_W_IN_I_STATE;
          end if;

        when CLEAN_W_IN_J_STATE =>      -- STEP 4

          if (unsigned(index_j_w_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_J_ENABLE <= '1';

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

  m_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
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

  e_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      E_OUT_ENABLE <= '0';

      -- Control Internal
      index_k_e_in_loop <= ZERO_CONTROL;

      data_e_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_e_in_fsm_int is
        when STARTER_E_IN_STATE =>      -- STEP 0
          if (START = '1') then
            -- Control Outputs
            E_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_e_in_loop <= ZERO_CONTROL;

            data_e_in_enable_int <= '0';

            -- FSM Control
            controller_e_in_fsm_int <= INPUT_E_IN_STATE;
          else
            -- Control Outputs
            E_OUT_ENABLE <= '0';
          end if;

        when INPUT_E_IN_STATE =>        -- STEP 1

          if (E_IN_ENABLE = '1') then
            -- Data Inputs
            vector_e_in_int(to_integer(unsigned(index_k_e_in_loop))) <= E_IN;

            -- FSM Control
            controller_e_in_fsm_int <= CLEAN_E_IN_STATE;
          end if;

          -- Control Outputs
          E_OUT_ENABLE <= '0';

        when CLEAN_E_IN_STATE =>        -- STEP 2

          if (unsigned(index_k_e_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            E_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_e_in_loop <= std_logic_vector(unsigned(index_k_e_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_e_in_fsm_int <= INPUT_E_IN_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_e_in_fsm_int <= STARTER_E_IN_STATE;
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
          if (data_w_in_enable_int = '1' and data_m_in_enable_int = '1' and data_e_in_enable_int = '1') then
            -- Control Internal
            matrix_m_out_int <= function_model_erasing (
              SIZE_R_IN => SIZE_R_IN,
              SIZE_N_IN => SIZE_N_IN,
              SIZE_W_IN => SIZE_W_IN,

              matrix_w_input => matrix_w_in_int,
              matrix_m_input => matrix_m_in_int,
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
            -- Data Outputs
            M_OUT <= matrix_m_out_int(to_integer(unsigned(index_j_m_out_loop)), to_integer(unsigned(index_k_m_out_loop)));

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
