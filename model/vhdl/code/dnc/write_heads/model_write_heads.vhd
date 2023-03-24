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

entity model_write_heads is
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

    XI_IN_ENABLE : in std_logic;        -- for s in 0 to S-1

    XI_OUT_ENABLE : out std_logic;      -- for s in 0 to S-1

    K_OUT_ENABLE : out std_logic;       -- for i in 0 to W-1
    E_OUT_ENABLE : out std_logic;       -- for i in 0 to W-1
    V_OUT_ENABLE : out std_logic;       -- for i in 0 to W-1

    -- DATA
    SIZE_S_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    XI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    E_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    V_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    GA_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0);
    GW_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_write_heads_urchitecture of model_write_heads is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- XI_IN [S]

  -- Outputs:
  -- K_OUT [W]
  -- BETA_OUT [1]
  -- E_OUT [W]
  -- V_OUT [W]
  -- GA_OUT [1]
  -- GW_OUT [1]

  -- States:
  -- INPUT_S_STATE, CLEAN_IN_S_STATE

  -- OUTPUT_S_STATE, CLEAN_OUT_S_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_xi_in_fsm is (
    STARTER_XI_IN_STATE,                -- STEP 0
    INPUT_XI_IN_S_STATE,                -- STEP 1
    CLEAN_XI_IN_S_STATE                 -- STEP 2
    );

  type controller_k_out_fsm is (
    STARTER_K_OUT_STATE,                -- STEP 0
    CLEAN_K_OUT_K_STATE,                -- STEP 1
    OUTPUT_K_OUT_K_STATE                -- STEP 2
    );

  type controller_e_out_fsm is (
    STARTER_E_OUT_STATE,                -- STEP 0
    CLEAN_E_OUT_K_STATE,                -- STEP 1
    OUTPUT_E_OUT_K_STATE                -- STEP 2
    );

  type controller_v_out_fsm is (
    STARTER_V_OUT_STATE,                -- STEP 0
    CLEAN_V_OUT_K_STATE,                -- STEP 1
    OUTPUT_V_OUT_K_STATE                -- STEP 2
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_xi_in_fsm_int : controller_xi_in_fsm;

  signal controller_k_out_fsm_int : controller_k_out_fsm;
  signal controller_e_out_fsm_int : controller_e_out_fsm;
  signal controller_v_out_fsm_int : controller_v_out_fsm;

  -- Buffer
  signal vector_xi_in_int : vector_buffer;

  signal write_out_int : write_heads_output;

  -- Control Internal
  signal index_s_xi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_k_k_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_e_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_v_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_xi_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- CONTROL
  xi_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      XI_OUT_ENABLE <= '0';

      -- Control Internal
      index_s_xi_in_loop <= ZERO_CONTROL;

      data_xi_in_enable_int <= '0';
    elsif (rising_edge(CLK)) then

      case controller_xi_in_fsm_int is
        when STARTER_XI_IN_STATE =>     -- STEP 0
          -- Control Outputs
          XI_OUT_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '0';

            -- FSM Control
            controller_xi_in_fsm_int <= INPUT_XI_IN_S_STATE;
          end if;

        when INPUT_XI_IN_S_STATE =>     -- STEP 1

          if (XI_IN_ENABLE = '1') then
            -- Data Inputs
            vector_xi_in_int(to_integer(unsigned(index_s_xi_in_loop))) <= XI_IN;

            data_xi_in_enable_int <= '0';

            -- FSM Control
            controller_xi_in_fsm_int <= CLEAN_XI_IN_S_STATE;
          end if;

          -- Control Outputs
          XI_OUT_ENABLE <= '0';

        when CLEAN_XI_IN_S_STATE =>     -- STEP 2

          if (unsigned(index_s_xi_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Internal
            write_out_int <= function_model_write_heads (
              SIZE_S_IN => SIZE_S_IN,
              SIZE_W_IN => SIZE_W_IN,

              vector_xi_input => vector_xi_in_int
              );

            -- Control Internal
            index_s_xi_in_loop <= ZERO_CONTROL;

            data_xi_in_enable_int <= '1';

            -- FSM Control
            controller_xi_in_fsm_int <= STARTER_XI_IN_STATE;
          elsif (unsigned(index_s_xi_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Internal
            index_s_xi_in_loop <= std_logic_vector(unsigned(index_s_xi_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_xi_in_fsm_int <= INPUT_XI_IN_S_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_xi_in_fsm_int <= STARTER_XI_IN_STATE;
      end case;
    end if;
  end process;

  -- k(t;k) = k^(t;k)
  k_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      K_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      K_OUT_ENABLE <= '0';

      -- Control Internal
      index_k_k_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_k_out_fsm_int is
        when STARTER_K_OUT_STATE =>     -- STEP 0
          if (data_xi_in_enable_int = '1') then
            -- Control Internal
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_K_STATE;
          end if;

        when CLEAN_K_OUT_K_STATE =>     -- STEP 1
          -- Control Outputs
          K_OUT_ENABLE <= '0';

          -- FSM Control
          controller_k_out_fsm_int <= OUTPUT_K_OUT_K_STATE;

        when OUTPUT_K_OUT_K_STATE =>    -- STEP 2

          if (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            K_OUT <= write_out_int.vector_k_output(to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            READY <= '1';

            K_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= STARTER_K_OUT_STATE;
          elsif (unsigned(index_k_k_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            K_OUT <= write_out_int.vector_k_output(to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            K_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_k_out_loop <= std_logic_vector(unsigned(index_k_k_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_out_fsm_int <= STARTER_K_OUT_STATE;
      end case;
    end if;
  end process;

  -- e(t;k) = sigmoid(e^(t;k))
  e_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      E_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      E_OUT_ENABLE <= '0';

      -- Control Internal
      index_k_e_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_e_out_fsm_int is
        when STARTER_E_OUT_STATE =>     -- STEP 0
          if (data_xi_in_enable_int = '1') then
            -- Control Internal
            index_k_e_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_e_out_fsm_int <= CLEAN_E_OUT_K_STATE;
          end if;

        when CLEAN_E_OUT_K_STATE =>     -- STEP 1
          -- Control Outputs
          E_OUT_ENABLE <= '0';

          -- FSM Control
          controller_e_out_fsm_int <= OUTPUT_E_OUT_K_STATE;

        when OUTPUT_E_OUT_K_STATE =>    -- STEP 2

          if (unsigned(index_k_e_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            E_OUT <= write_out_int.vector_e_output(to_integer(unsigned(index_k_e_out_loop)));

            -- Control Outputs
            READY <= '1';

            E_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_e_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_e_out_fsm_int <= STARTER_E_OUT_STATE;
          elsif (unsigned(index_k_e_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            E_OUT <= write_out_int.vector_e_output(to_integer(unsigned(index_k_e_out_loop)));

            -- Control Outputs
            E_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_e_out_loop <= std_logic_vector(unsigned(index_k_e_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_e_out_fsm_int <= CLEAN_E_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_e_out_fsm_int <= STARTER_E_OUT_STATE;
      end case;
    end if;
  end process;

  -- v(t;k) = v^(t;k)
  v_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      V_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      V_OUT_ENABLE <= '0';

      -- Control Internal
      index_k_v_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_v_out_fsm_int is
        when STARTER_V_OUT_STATE =>     -- STEP 0
          if (data_xi_in_enable_int = '1') then
            -- Control Internal
            index_k_v_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_out_fsm_int <= CLEAN_V_OUT_K_STATE;
          end if;

        when CLEAN_V_OUT_K_STATE =>     -- STEP 1
          -- Control Outputs
          V_OUT_ENABLE <= '0';

          -- FSM Control
          controller_v_out_fsm_int <= OUTPUT_V_OUT_K_STATE;

        when OUTPUT_V_OUT_K_STATE =>    -- STEP 2

          if (unsigned(index_k_v_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            V_OUT <= write_out_int.vector_v_output(to_integer(unsigned(index_k_v_out_loop)));

            -- Control Outputs
            READY <= '1';

            V_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_v_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_v_out_fsm_int <= STARTER_V_OUT_STATE;
          elsif (unsigned(index_k_v_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            V_OUT <= write_out_int.vector_v_output(to_integer(unsigned(index_k_v_out_loop)));

            -- Control Outputs
            V_OUT_ENABLE <= '1';

            -- Control Internal
            index_k_v_out_loop <= std_logic_vector(unsigned(index_k_v_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_v_out_fsm_int <= CLEAN_V_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_v_out_fsm_int <= STARTER_V_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
