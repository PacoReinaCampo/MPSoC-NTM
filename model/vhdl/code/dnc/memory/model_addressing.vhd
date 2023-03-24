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

entity model_addressing is
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

    K_READ_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)
    K_READ_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

    K_READ_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
    K_READ_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

    BETA_READ_IN_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)

    BETA_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

    F_READ_IN_ENABLE : in std_logic;    -- for i in 0 to R-1 (read heads flow)

    F_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

    PI_READ_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)
    PI_READ_IN_P_ENABLE : in std_logic;  -- for p in 0 to 2

    PI_READ_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
    PI_READ_OUT_P_ENABLE : out std_logic;  -- for p in 0 to 2

    K_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
    E_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
    V_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

    K_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
    E_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
    V_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    K_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_READ_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    F_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    PI_READ_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_WRITE_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    E_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    GA_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    GW_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_addressing_architecture of model_addressing is

  ------------------------------------------------------------------------------
  -- Functionality
  ------------------------------------------------------------------------------

  -- Inputs:
  -- K_READ_IN    [R,W]
  -- BETA_READ_IN [R]
  -- F_READ_IN    [R,P]
  -- PI_READ_IN   [R]

  -- K_WRITE_IN    [W]
  -- BETA_WRITE_IN [1]
  -- E_WRITE_IN    [W]
  -- V_WRITE_IN    [W]
  -- GA_WRITE_IN   [1]
  -- GW_WRITE_IN   [1]

  -- Outputs:
  -- R_OUT [R,W]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_W_STATE, CLEAN_OUT_W_STATE

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  -- Finite State Machine
  type controller_k_read_in_fsm is (
    STARTER_K_READ_IN_STATE,            -- STEP 0
    INPUT_K_READ_IN_I_STATE,            -- STEP 1
    INPUT_K_READ_IN_K_STATE,            -- STEP 2
    CLEAN_K_READ_IN_I_STATE,            -- STEP 3
    CLEAN_K_READ_IN_K_STATE             -- STEP 4
    );

  type controller_pi_read_in_fsm is (
    STARTER_PI_READ_IN_STATE,           -- STEP 0
    INPUT_PI_READ_IN_I_STATE,           -- STEP 1
    INPUT_PI_READ_IN_P_STATE,           -- STEP 2
    CLEAN_PI_READ_IN_I_STATE,           -- STEP 3
    CLEAN_PI_READ_IN_P_STATE            -- STEP 4
    );

  type controller_read_in_fsm is (
    STARTER_READ_IN_STATE,              -- STEP 0
    INPUT_READ_STATE,                   -- STEP 1
    CLEAN_READ_STATE                    -- STEP 2
    );

  type controller_write_in_fsm is (
    STARTER_WRITE_IN_STATE,             -- STEP 0
    INPUT_WRITE_STATE,                  -- STEP 1
    CLEAN_WRITE_STATE                   -- STEP 2
    );

  type controller_r_out_fsm is (
    STARTER_R_OUT_STATE,                -- STEP 0
    CLEAN_R_OUT_I_STATE,                -- STEP 1
    CLEAN_R_OUT_K_STATE,                -- STEP 2
    OUTPUT_R_OUT_I_STATE,               -- STEP 3
    OUTPUT_R_OUT_K_STATE                -- STEP 4
    );

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- Finite State Machine
  signal controller_k_read_in_fsm_read_int  : controller_k_read_in_fsm;
  signal controller_pi_read_in_fsm_read_int : controller_pi_read_in_fsm;

  signal controller_read_in_fsm_int : controller_read_in_fsm;

  signal controller_write_in_fsm_int : controller_write_in_fsm;

  signal controller_r_out_fsm_read_int : controller_r_out_fsm;

  -- Buffer
  signal matrix_k_read_in_int    : matrix_buffer;
  signal vector_beta_read_in_int : vector_buffer;
  signal vector_f_read_in_int    : vector_buffer;
  signal matrix_pi_read_in_int   : matrix_buffer;

  signal vector_k_write_in_int : vector_buffer;
  signal vector_e_write_in_int : vector_buffer;
  signal vector_v_write_in_int : vector_buffer;


  signal matrix_r_out_int : matrix_buffer;

  -- Control Internal
  signal index_j_k_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_pi_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_pi_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_in_read_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_k_in_write_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_r_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_k_read_in_enable_int : std_logic;

  signal data_pi_read_in_enable_int : std_logic;

  signal data_beta_read_in_enable_int : std_logic;
  signal data_f_read_in_enable_int    : std_logic;

  signal data_read_in_enable_int : std_logic;

  signal data_k_write_in_enable_int : std_logic;
  signal data_e_write_in_enable_int : std_logic;
  signal data_v_write_in_enable_int : std_logic;

  signal data_write_in_enable_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- CONTROL
  k_read_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      K_READ_OUT_I_ENABLE <= '0';
      K_READ_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_j_k_read_in_loop <= ZERO_CONTROL;
      index_k_k_read_in_loop <= ZERO_CONTROL;

      data_k_read_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_read_in_fsm_read_int is
        when STARTER_K_READ_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_k_read_in_loop <= ZERO_CONTROL;
            index_k_k_read_in_loop <= ZERO_CONTROL;

            data_k_read_in_enable_int <= '0';

            -- FSM Control
            controller_k_read_in_fsm_read_int <= INPUT_K_READ_IN_I_STATE;
          else
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '0';
            K_READ_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_K_READ_IN_I_STATE =>  -- STEP 1

          if ((K_READ_IN_I_ENABLE = '1') and (K_READ_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_read_in_int(to_integer(unsigned(index_j_k_read_in_loop)), to_integer(unsigned(index_k_k_read_in_loop))) <= K_READ_IN;

            -- FSM Control
            controller_k_read_in_fsm_read_int <= CLEAN_K_READ_IN_K_STATE;
          end if;

          -- Control Outputs
          K_READ_OUT_I_ENABLE <= '0';
          K_READ_OUT_K_ENABLE <= '0';

        when INPUT_K_READ_IN_K_STATE =>  -- STEP 2

          if (K_READ_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_k_read_in_int(to_integer(unsigned(index_j_k_read_in_loop)), to_integer(unsigned(index_k_k_read_in_loop))) <= K_READ_IN;

            -- FSM Control
            if (unsigned(index_k_k_read_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_k_read_in_fsm_read_int <= CLEAN_K_READ_IN_I_STATE;
            else
              controller_k_read_in_fsm_read_int <= CLEAN_K_READ_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          K_READ_OUT_K_ENABLE <= '0';

        when CLEAN_K_READ_IN_I_STATE =>  -- STEP 3

          if ((unsigned(index_j_k_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_read_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_k_read_in_loop <= ZERO_CONTROL;
            index_k_k_read_in_loop <= ZERO_CONTROL;

            data_k_read_in_enable_int <= '1';

            -- FSM Control
            controller_k_read_in_fsm_read_int <= STARTER_K_READ_IN_STATE;
          elsif ((unsigned(index_j_k_read_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_read_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_k_read_in_loop <= std_logic_vector(unsigned(index_j_k_read_in_loop) + unsigned(ONE_CONTROL));
            index_k_k_read_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_read_in_fsm_read_int <= INPUT_K_READ_IN_I_STATE;
          end if;

        when CLEAN_K_READ_IN_K_STATE =>  -- STEP 4

          if (unsigned(index_k_k_read_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_read_in_loop <= std_logic_vector(unsigned(index_k_k_read_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_read_in_fsm_read_int <= INPUT_K_READ_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_read_in_fsm_read_int <= STARTER_K_READ_IN_STATE;
      end case;
    end if;
  end process;

  pi_read_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      PI_READ_OUT_I_ENABLE <= '0';
      PI_READ_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_i_pi_read_in_loop <= ZERO_CONTROL;
      index_p_pi_read_in_loop <= ZERO_CONTROL;

      data_pi_read_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_pi_read_in_fsm_read_int is
        when STARTER_PI_READ_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_read_in_loop <= ZERO_CONTROL;
            index_p_pi_read_in_loop <= ZERO_CONTROL;

            data_pi_read_in_enable_int <= '0';

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= INPUT_PI_READ_IN_I_STATE;
          else
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '0';
            PI_READ_OUT_P_ENABLE <= '0';
          end if;

        when INPUT_PI_READ_IN_I_STATE =>  -- STEP 1

          if ((PI_READ_IN_I_ENABLE = '1') and (PI_READ_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_pi_read_in_int(to_integer(unsigned(index_i_pi_read_in_loop)), to_integer(unsigned(index_p_pi_read_in_loop))) <= PI_READ_IN;

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= CLEAN_PI_READ_IN_P_STATE;
          end if;

          -- Control Outputs
          PI_READ_OUT_I_ENABLE <= '0';
          PI_READ_OUT_P_ENABLE <= '0';

        when INPUT_PI_READ_IN_P_STATE =>  -- STEP 2

          if (PI_READ_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_pi_read_in_int(to_integer(unsigned(index_i_pi_read_in_loop)), to_integer(unsigned(index_p_pi_read_in_loop))) <= PI_READ_IN;

            -- FSM Control
            if (unsigned(index_p_pi_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_pi_read_in_fsm_read_int <= CLEAN_PI_READ_IN_I_STATE;
            else
              controller_pi_read_in_fsm_read_int <= CLEAN_PI_READ_IN_P_STATE;
            end if;
          end if;

          -- Control Outputs
          PI_READ_OUT_P_ENABLE <= '0';

        when CLEAN_PI_READ_IN_I_STATE =>  -- STEP 3

          if ((unsigned(index_i_pi_read_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_read_in_loop <= ZERO_CONTROL;
            index_p_pi_read_in_loop <= ZERO_CONTROL;

            data_pi_read_in_enable_int <= '1';

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= STARTER_PI_READ_IN_STATE;
          elsif ((unsigned(index_i_pi_read_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_read_in_loop <= std_logic_vector(unsigned(index_i_pi_read_in_loop) + unsigned(ONE_CONTROL));
            index_p_pi_read_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= INPUT_PI_READ_IN_I_STATE;
          end if;

        when CLEAN_PI_READ_IN_P_STATE =>  -- STEP 4

          if (unsigned(index_p_pi_read_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_pi_read_in_loop <= std_logic_vector(unsigned(index_p_pi_read_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= INPUT_PI_READ_IN_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_pi_read_in_fsm_read_int <= STARTER_PI_READ_IN_STATE;
      end case;
    end if;
  end process;

  read_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      BETA_READ_OUT_ENABLE <= '0';
      F_READ_OUT_ENABLE    <= '0';

      -- Control Internal
      index_i_in_read_loop <= ZERO_CONTROL;

      data_beta_read_in_enable_int <= '0';
      data_f_read_in_enable_int    <= '0';

      data_read_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_read_in_fsm_int is
        when STARTER_READ_IN_STATE =>   -- STEP 0
          if (START = '1') then
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '1';
            F_READ_OUT_ENABLE    <= '1';

            -- Control Internal
            index_i_in_read_loop <= ZERO_CONTROL;

            data_beta_read_in_enable_int <= '0';
            data_f_read_in_enable_int    <= '0';

            data_read_in_enable_int <= '0';

            -- FSM Control
            controller_read_in_fsm_int <= INPUT_READ_STATE;
          else
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '0';
            F_READ_OUT_ENABLE    <= '0';
          end if;

        when INPUT_READ_STATE =>        -- STEP 1

          if (BETA_READ_IN_ENABLE = '1') then
            -- Data Inputs
            vector_beta_read_in_int(to_integer(unsigned(index_i_in_read_loop))) <= BETA_READ_IN;

            -- Control Internal
            data_beta_read_in_enable_int <= '1';
          end if;

          if (F_READ_IN_ENABLE = '1') then
            -- Data Inputs
            vector_f_read_in_int(to_integer(unsigned(index_i_in_read_loop))) <= F_READ_IN;

            -- Control Internal
            data_f_read_in_enable_int <= '1';
          end if;

          -- Control Outputs
          BETA_READ_OUT_ENABLE <= '0';
          F_READ_OUT_ENABLE    <= '0';

          if (data_beta_read_in_enable_int = '1' and data_f_read_in_enable_int = '1') then
            -- Control Internal
            data_beta_read_in_enable_int <= '0';
            data_f_read_in_enable_int    <= '0';

            -- FSM Control
            controller_read_in_fsm_int <= CLEAN_READ_STATE;
          end if;

        when CLEAN_READ_STATE =>        -- STEP 2

          if (unsigned(index_i_in_read_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '1';
            F_READ_OUT_ENABLE    <= '1';

            -- Control Internal
            index_i_in_read_loop <= ZERO_CONTROL;

            data_read_in_enable_int <= '1';

            -- FSM Control
            controller_read_in_fsm_int <= STARTER_READ_IN_STATE;
          elsif (unsigned(index_i_in_read_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '1';
            F_READ_OUT_ENABLE    <= '1';

            -- Control Internal
            index_i_in_read_loop <= std_logic_vector(unsigned(index_i_in_read_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_read_in_fsm_int <= INPUT_READ_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_read_in_fsm_int <= STARTER_READ_IN_STATE;
      end case;
    end if;
  end process;

  write_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      K_WRITE_OUT_K_ENABLE <= '0';
      E_WRITE_OUT_K_ENABLE <= '0';
      V_WRITE_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_k_in_write_loop <= ZERO_CONTROL;

      data_k_write_in_enable_int <= '0';
      data_e_write_in_enable_int <= '0';
      data_v_write_in_enable_int <= '0';

      data_write_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_write_in_fsm_int is
        when STARTER_WRITE_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_in_write_loop <= ZERO_CONTROL;

            data_k_write_in_enable_int <= '0';
            data_e_write_in_enable_int <= '0';
            data_v_write_in_enable_int <= '0';

            data_write_in_enable_int <= '0';

            -- FSM Control
            controller_write_in_fsm_int <= INPUT_WRITE_STATE;
          else
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '0';
            E_WRITE_OUT_K_ENABLE <= '0';
            V_WRITE_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_WRITE_STATE =>       -- STEP 1

          if (K_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_k_write_in_int(to_integer(unsigned(index_k_in_write_loop))) <= K_WRITE_IN;

            -- Control Internal
            data_k_write_in_enable_int <= '1';
          end if;

          if (E_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_e_write_in_int(to_integer(unsigned(index_k_in_write_loop))) <= E_WRITE_IN;

            -- Control Internal
            data_e_write_in_enable_int <= '1';
          end if;

          if (V_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_v_write_in_int(to_integer(unsigned(index_k_in_write_loop))) <= V_WRITE_IN;

            -- Control Internal
            data_v_write_in_enable_int <= '1';
          end if;

          -- Control Outputs
          K_WRITE_OUT_K_ENABLE <= '0';
          E_WRITE_OUT_K_ENABLE <= '0';
          V_WRITE_OUT_K_ENABLE <= '0';

          if (data_k_write_in_enable_int = '1' and data_e_write_in_enable_int = '1' and data_v_write_in_enable_int = '1') then
            -- Control Internal
            data_k_write_in_enable_int <= '0';
            data_e_write_in_enable_int <= '0';
            data_v_write_in_enable_int <= '0';

            -- FSM Control
            controller_write_in_fsm_int <= CLEAN_WRITE_STATE;
          end if;

        when CLEAN_WRITE_STATE =>       -- STEP 2

          if (unsigned(index_k_in_write_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_in_write_loop <= ZERO_CONTROL;

            data_write_in_enable_int <= '1';

            -- FSM Control
            controller_write_in_fsm_int <= STARTER_WRITE_IN_STATE;
          elsif (unsigned(index_k_in_write_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_in_write_loop <= std_logic_vector(unsigned(index_k_in_write_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_write_in_fsm_int <= INPUT_WRITE_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_write_in_fsm_int <= STARTER_WRITE_IN_STATE;
      end case;
    end if;
  end process;

  r_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      R_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_r_out_loop <= ZERO_CONTROL;
      index_k_r_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_r_out_fsm_read_int is
        when STARTER_R_OUT_STATE =>     -- STEP 0
          if (data_pi_read_in_enable_int = '1' and data_k_read_in_enable_int = '1' and data_read_in_enable_int = '1' and data_write_in_enable_int = '1') then
            -- Data Internal
            matrix_r_out_int <= function_model_addressing (
              SIZE_R_IN => SIZE_R_IN,
              SIZE_N_IN => SIZE_N_IN,
              SIZE_W_IN => SIZE_W_IN,

              matrix_k_read_input    => matrix_k_read_in_int,
              vector_beta_read_input => vector_beta_read_in_int,
              vector_f_read_input    => vector_f_read_in_int,
              matrix_pi_read_input   => matrix_pi_read_in_int,

              vector_k_write_input    => vector_k_write_in_int,
              scalar_beta_write_input => BETA_WRITE_IN,
              vector_e_write_input    => vector_e_write_in_int,
              vector_v_write_input    => vector_v_write_in_int,
              scalar_ga_write_input   => GA_WRITE_IN,
              scalar_gw_write_input   => GW_WRITE_IN
              );

            -- Control Internal
            index_i_r_out_loop <= ZERO_CONTROL;
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_read_int <= CLEAN_R_OUT_I_STATE;
          end if;

        when CLEAN_R_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

          -- FSM Control
          controller_r_out_fsm_read_int <= OUTPUT_R_OUT_K_STATE;

        when CLEAN_R_OUT_K_STATE =>     -- STEP 2

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_r_out_fsm_read_int <= OUTPUT_R_OUT_I_STATE;
          else
            controller_r_out_fsm_read_int <= OUTPUT_R_OUT_K_STATE;
          end if;

        when OUTPUT_R_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_r_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= matrix_r_out_int(to_integer(unsigned(index_i_r_out_loop)), to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            READY <= '1';

            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_out_loop <= ZERO_CONTROL;
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_read_int <= STARTER_R_OUT_STATE;
          elsif ((unsigned(index_i_r_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= matrix_r_out_int(to_integer(unsigned(index_i_r_out_loop)), to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_out_loop <= std_logic_vector(unsigned(index_i_r_out_loop) + unsigned(ONE_CONTROL));
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_read_int <= CLEAN_R_OUT_I_STATE;
          end if;

        when OUTPUT_R_OUT_K_STATE =>    -- STEP 4

          if (unsigned(index_k_r_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_out_loop <= std_logic_vector(unsigned(index_k_r_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_r_out_fsm_read_int <= CLEAN_R_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_r_out_fsm_read_int <= STARTER_R_OUT_STATE;
      end case;
    end if;
  end process;

end architecture;
