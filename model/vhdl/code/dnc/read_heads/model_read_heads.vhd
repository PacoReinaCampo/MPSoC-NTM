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

entity model_read_heads is
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

    RHO_IN_I_ENABLE : in std_logic;     -- for i in 0 to R-1
    RHO_IN_M_ENABLE : in std_logic;     -- for m in 0 to M-1

    RHO_OUT_I_ENABLE : out std_logic;   -- for i in 0 to R-1
    RHO_OUT_M_ENABLE : out std_logic;   -- for m in 0 to M-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    BETA_OUT_ENABLE : out std_logic;    -- for i in 0 to R-1

    F_OUT_ENABLE : out std_logic;       -- for i in 0 to R-1

    PI_OUT_I_ENABLE : out std_logic;    -- for i in 0 to R-1
    PI_OUT_P_ENABLE : out std_logic;    -- for p in 0 to 2

    -- DATA
    SIZE_M_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    RHO_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
    F_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0);
    PI_OUT   : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_read_heads_architecture of model_read_heads is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- RHO_IN [R,M]

  -- Outputs:
  -- K_OUT [R,W]
  -- BETA_OUT [R]
  -- F_OUT [R]
  -- PI_OUT [R,3]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_M_STATE, CLEAN_IN_M_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_M_STATE, CLEAN_OUT_M_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_rho_in_fsm is (
    STARTER_RHO_IN_STATE,               -- STEP 0
    INPUT_RHO_IN_I_STATE,               -- STEP 1
    INPUT_RHO_IN_J_STATE,               -- STEP 2
    CLEAN_RHO_IN_I_STATE,               -- STEP 3
    CLEAN_RHO_IN_J_STATE                -- STEP 4
    );

  type controller_k_out_fsm is (
    STARTER_K_OUT_STATE,                -- STEP 0
    CLEAN_K_OUT_I_STATE,                -- STEP 1
    CLEAN_K_OUT_K_STATE,                -- STEP 2
    OUTPUT_K_OUT_I_STATE,               -- STEP 3
    OUTPUT_K_OUT_K_STATE                -- STEP 4
    );

  type controller_beta_out_fsm is (
    STARTER_BETA_OUT_STATE,             -- STEP 0
    CLEAN_BETA_OUT_I_STATE,             -- STEP 1
    OUTPUT_BETA_OUT_I_STATE             -- STEP 2
    );

  type controller_f_out_fsm is (
    STARTER_F_OUT_STATE,                -- STEP 0
    CLEAN_F_OUT_I_STATE,                -- STEP 1
    OUTPUT_F_OUT_I_STATE                -- STEP 2
    );

  type controller_pi_out_fsm is (
    STARTER_PI_OUT_STATE,               -- STEP 0
    CLEAN_PI_OUT_I_STATE,               -- STEP 1
    CLEAN_PI_OUT_P_STATE,               -- STEP 2
    OUTPUT_PI_OUT_I_STATE,              -- STEP 3
    OUTPUT_PI_OUT_P_STATE               -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_rho_in_fsm_int : controller_rho_in_fsm;

  signal controller_k_out_fsm_int    : controller_k_out_fsm;
  signal controller_beta_out_fsm_int : controller_beta_out_fsm;
  signal controller_f_out_fsm_int    : controller_f_out_fsm;
  signal controller_pi_out_fsm_int   : controller_pi_out_fsm;

  -- Buffer
  signal matrix_rho_in_int : matrix_buffer;

  signal read_out_int : read_heads_output;

  -- Control Internal
  signal index_i_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_rho_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_k_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_beta_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_f_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_pi_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_pi_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_rho_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- CONTROL
  rho_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      RHO_OUT_I_ENABLE <= '0';
      RHO_OUT_M_ENABLE <= '0';

      -- Control Internal
      index_i_rho_in_loop <= ZERO_CONTROL;
      index_m_rho_in_loop <= ZERO_CONTROL;

      data_rho_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_rho_in_fsm_int is
        when STARTER_RHO_IN_STATE =>    -- STEP 0
          if (START = '1') then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '0';

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          else
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '0';
            RHO_OUT_M_ENABLE <= '0';
          end if;

        when INPUT_RHO_IN_I_STATE =>    -- STEP 1 k

          if ((RHO_IN_I_ENABLE = '1') and (RHO_IN_M_ENABLE = '1')) then
            -- Data Inputs
            matrix_rho_in_int(to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            controller_rho_in_fsm_int <= CLEAN_RHO_IN_J_STATE;
          end if;

          -- Control Outputs
          RHO_OUT_I_ENABLE <= '0';
          RHO_OUT_M_ENABLE <= '0';

        when INPUT_RHO_IN_J_STATE =>    -- STEP 2 k

          if (RHO_IN_M_ENABLE = '1') then
            -- Data Inputs
            matrix_rho_in_int(to_integer(unsigned(index_i_rho_in_loop)), to_integer(unsigned(index_m_rho_in_loop))) <= RHO_IN;

            -- FSM Control
            if (unsigned(index_m_rho_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_I_STATE;
            else
              controller_rho_in_fsm_int <= CLEAN_RHO_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          RHO_OUT_M_ENABLE <= '0';

        when CLEAN_RHO_IN_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_rho_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Data Internal
            read_out_int <= function_model_read_heads (
              SIZE_M_IN => SIZE_M_IN,
              SIZE_R_IN => SIZE_R_IN,
              SIZE_W_IN => SIZE_W_IN,

              matrix_rho_input => matrix_rho_in_int
              );

            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= ZERO_CONTROL;
            index_m_rho_in_loop <= ZERO_CONTROL;

            data_rho_in_enable_int <= '1';

            -- FSM Control
            controller_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
          elsif ((unsigned(index_i_rho_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_m_rho_in_loop) = unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            RHO_OUT_I_ENABLE <= '1';
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_i_rho_in_loop <= std_logic_vector(unsigned(index_i_rho_in_loop) + unsigned(ONE_CONTROL));
            index_m_rho_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_I_STATE;
          end if;

        when CLEAN_RHO_IN_J_STATE =>    -- STEP 4

          if (unsigned(index_m_rho_in_loop) < unsigned(SIZE_M_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            RHO_OUT_M_ENABLE <= '1';

            -- Control Internal
            index_m_rho_in_loop <= std_logic_vector(unsigned(index_m_rho_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_rho_in_fsm_int <= INPUT_RHO_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_rho_in_fsm_int <= STARTER_RHO_IN_STATE;
      end case;
    end if;
  end process;

  -- k(t;i;k) = k^(t;i;k)
  k_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      K_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      K_OUT_I_ENABLE <= '0';
      K_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_k_out_loop <= ZERO_CONTROL;
      index_k_k_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_k_out_fsm_int is
        when STARTER_K_OUT_STATE =>     -- STEP 0
          if (data_rho_in_enable_int = '1') then
            -- Control Internal
            index_i_k_out_loop <= ZERO_CONTROL;
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_I_STATE;
          end if;

        when CLEAN_K_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          K_OUT_I_ENABLE <= '0';
          K_OUT_K_ENABLE <= '0';

          -- FSM Control
          controller_k_out_fsm_int <= OUTPUT_K_OUT_K_STATE;

        when CLEAN_K_OUT_K_STATE =>     -- STEP 2

          -- Control Outputs
          K_OUT_K_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_k_out_fsm_int <= OUTPUT_K_OUT_I_STATE;
          else
            controller_k_out_fsm_int <= OUTPUT_K_OUT_K_STATE;
          end if;

        when OUTPUT_K_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_k_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            K_OUT <= read_out_int.matrix_k_output(to_integer(unsigned(index_i_k_out_loop)), to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            READY <= '1';

            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_out_loop <= ZERO_CONTROL;
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= STARTER_K_OUT_STATE;
          elsif ((unsigned(index_i_k_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            K_OUT <= read_out_int.matrix_k_output(to_integer(unsigned(index_i_k_out_loop)), to_integer(unsigned(index_k_k_out_loop)));

            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_k_out_loop <= std_logic_vector(unsigned(index_i_k_out_loop) + unsigned(ONE_CONTROL));
            index_k_k_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_out_fsm_int <= CLEAN_K_OUT_I_STATE;
          end if;

        when OUTPUT_K_OUT_K_STATE =>    -- STEP 4

          if (unsigned(index_k_k_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_OUT_K_ENABLE <= '1';

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

  -- beta(t;i) = oneplus(beta^(t;i))
  beta_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      BETA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      BETA_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_beta_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_beta_out_fsm_int is
        when STARTER_BETA_OUT_STATE =>  -- STEP 0
          if (data_rho_in_enable_int = '1') then
            -- Control Internal
            index_i_beta_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_beta_out_fsm_int <= CLEAN_BETA_OUT_I_STATE;
          end if;

        when CLEAN_BETA_OUT_I_STATE =>  -- STEP 1
          -- Control Outputs
          BETA_OUT_ENABLE <= '0';

          -- FSM Control
          controller_beta_out_fsm_int <= OUTPUT_BETA_OUT_I_STATE;

        when OUTPUT_BETA_OUT_I_STATE =>  -- STEP 2

          if (unsigned(index_i_beta_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            BETA_OUT <= read_out_int.vector_beta_output(to_integer(unsigned(index_i_beta_out_loop)));

            -- Control Outputs
            READY <= '1';

            BETA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_beta_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_beta_out_fsm_int <= STARTER_BETA_OUT_STATE;
          elsif (unsigned(index_i_beta_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            BETA_OUT <= read_out_int.vector_beta_output(to_integer(unsigned(index_i_beta_out_loop)));

            -- Control Outputs
            BETA_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_beta_out_loop <= std_logic_vector(unsigned(index_i_beta_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_beta_out_fsm_int <= CLEAN_BETA_OUT_I_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_beta_out_fsm_int <= STARTER_BETA_OUT_STATE;
      end case;
    end if;
  end process;

  -- f(t;i) = sigmoid(f^(t;i))
  f_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      F_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      F_OUT_ENABLE <= '0';

      -- Control Internal
      index_i_f_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_f_out_fsm_int is
        when STARTER_F_OUT_STATE =>     -- STEP 0
          if (data_rho_in_enable_int = '1') then
            -- Control Internal
            index_i_f_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_f_out_fsm_int <= CLEAN_F_OUT_I_STATE;
          end if;

        when CLEAN_F_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          F_OUT_ENABLE <= '0';

          -- FSM Control
          controller_f_out_fsm_int <= OUTPUT_F_OUT_I_STATE;

        when OUTPUT_F_OUT_I_STATE =>    -- STEP 2

          if (unsigned(index_i_f_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            F_OUT <= read_out_int.vector_f_output(to_integer(unsigned(index_i_f_out_loop)));

            -- Control Outputs
            READY <= '1';

            F_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_f_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_f_out_fsm_int <= STARTER_F_OUT_STATE;
          elsif (unsigned(index_i_f_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            F_OUT <= read_out_int.vector_f_output(to_integer(unsigned(index_i_f_out_loop)));

            -- Control Outputs
            F_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_f_out_loop <= std_logic_vector(unsigned(index_i_f_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_f_out_fsm_int <= CLEAN_F_OUT_I_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_f_out_fsm_int <= STARTER_F_OUT_STATE;
      end case;
    end if;
  end process;

  -- pi(t;i;p) = softmax(pi^(t;i;p))
  pi_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      PI_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      PI_OUT_I_ENABLE <= '0';
      PI_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_i_pi_out_loop <= ZERO_CONTROL;
      index_p_pi_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_pi_out_fsm_int is
        when STARTER_PI_OUT_STATE =>    -- STEP 0
          if (data_rho_in_enable_int = '1') then
            -- Control Internal
            index_i_pi_out_loop <= ZERO_CONTROL;
            index_p_pi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_pi_out_fsm_int <= CLEAN_PI_OUT_I_STATE;
          end if;

        when CLEAN_PI_OUT_I_STATE =>    -- STEP 1
          -- Control Outputs
          PI_OUT_I_ENABLE <= '0';
          PI_OUT_P_ENABLE <= '0';

          -- FSM Control
          controller_pi_out_fsm_int <= OUTPUT_PI_OUT_P_STATE;

        when CLEAN_PI_OUT_P_STATE =>    -- STEP 2

          -- Control Outputs
          PI_OUT_P_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_p_pi_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
            controller_pi_out_fsm_int <= OUTPUT_PI_OUT_I_STATE;
          else
            controller_pi_out_fsm_int <= OUTPUT_PI_OUT_P_STATE;
          end if;

        when OUTPUT_PI_OUT_I_STATE =>   -- STEP 3

          if ((unsigned(index_i_pi_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            PI_OUT <= read_out_int.matrix_pi_output(to_integer(unsigned(index_i_pi_out_loop)), to_integer(unsigned(index_p_pi_out_loop)));

            -- Control Outputs
            READY <= '1';

            PI_OUT_I_ENABLE <= '1';
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_out_loop <= ZERO_CONTROL;
            index_p_pi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_pi_out_fsm_int <= STARTER_PI_OUT_STATE;
          elsif ((unsigned(index_i_pi_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_out_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            PI_OUT <= read_out_int.matrix_pi_output(to_integer(unsigned(index_i_pi_out_loop)), to_integer(unsigned(index_p_pi_out_loop)));

            -- Control Outputs
            PI_OUT_I_ENABLE <= '1';
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_out_loop <= std_logic_vector(unsigned(index_i_pi_out_loop) + unsigned(ONE_CONTROL));
            index_p_pi_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_pi_out_fsm_int <= CLEAN_PI_OUT_I_STATE;
          end if;

        when OUTPUT_PI_OUT_P_STATE =>   -- STEP 4

          if (unsigned(index_p_pi_out_loop) < unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_pi_out_loop <= std_logic_vector(unsigned(index_p_pi_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_pi_out_fsm_int <= CLEAN_PI_OUT_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_pi_out_fsm_int <= STARTER_PI_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
