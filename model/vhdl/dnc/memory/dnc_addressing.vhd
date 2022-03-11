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
use work.dnc_core_pkg.all;

entity dnc_addressing is
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

architecture dnc_addressing_architecture of dnc_addressing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_STATE,                  -- STEP 1
    CLEAN_FIRST_STATE,                  -- STEP 2
    INPUT_SECOND_I_STATE,               -- STEP 3
    INPUT_SECOND_J_STATE,               -- STEP 4
    CLEAN_SECOND_I_STATE,               -- STEP 5
    CLEAN_SECOND_J_STATE,               -- STEP 6
    INPUT_THIRD_I_STATE,                -- STEP 7
    INPUT_THIRD_J_STATE,                -- STEP 8
    CLEAN_THIRD_I_STATE,                -- STEP 9
    CLEAN_THIRD_J_STATE                 -- STEP 10
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Buffer
  signal matrix_k_read_int    : matrix_buffer;
  signal vector_beta_read_int : vector_buffer;
  signal vector_f_read_int    : vector_buffer;
  signal matrix_pi_read_int   : matrix_buffer;

  signal vector_k_write_int : vector_buffer;
  signal vector_e_write_int : vector_buffer;
  signal vector_v_write_int : vector_buffer;

  signal matrix_out_int : matrix_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_k_in_i_int : std_logic;
  signal data_k_in_j_int : std_logic;

  signal data_pi_in_i_int : std_logic;
  signal data_pi_in_j_int : std_logic;

  signal data_e_in_int : std_logic;
  signal data_f_in_int : std_logic;
  signal data_k_in_int : std_logic;
  signal data_v_in_int : std_logic;

  signal data_beta_in_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      R_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      K_READ_OUT_I_ENABLE <= '0';
      K_READ_OUT_K_ENABLE <= '0';

      BETA_READ_OUT_ENABLE <= '0';

      F_READ_OUT_ENABLE <= '0';

      PI_READ_OUT_I_ENABLE <= '0';
      PI_READ_OUT_P_ENABLE <= '0';

      K_WRITE_OUT_K_ENABLE <= '0';
      E_WRITE_OUT_K_ENABLE <= '0';
      V_WRITE_OUT_K_ENABLE <= '0';

      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Data Outputs
          R_OUT <= ZERO_DATA;

          -- Control Outputs
          READY <= '0';

          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

          if (START = '1') then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '0';
            K_READ_OUT_K_ENABLE <= '0';

            BETA_READ_OUT_ENABLE <= '0';

            F_READ_OUT_ENABLE <= '0';

            PI_READ_OUT_I_ENABLE <= '0';
            PI_READ_OUT_P_ENABLE <= '0';

            K_WRITE_OUT_K_ENABLE <= '0';
            E_WRITE_OUT_K_ENABLE <= '0';
            V_WRITE_OUT_K_ENABLE <= '0';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_STATE;
          else
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '0';
            K_READ_OUT_K_ENABLE <= '0';

            BETA_READ_OUT_ENABLE <= '0';

            F_READ_OUT_ENABLE <= '0';

            PI_READ_OUT_I_ENABLE <= '0';
            PI_READ_OUT_P_ENABLE <= '0';

            K_WRITE_OUT_K_ENABLE <= '0';
            E_WRITE_OUT_K_ENABLE <= '0';
            V_WRITE_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_FIRST_STATE =>       -- STEP 1 k,e,v

          if (K_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_k_write_int(to_integer(unsigned(index_i_loop))) <= K_WRITE_IN;

            -- Control Internal
            data_k_in_int <= '1';
          end if;

          if (E_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_e_write_int(to_integer(unsigned(index_i_loop))) <= E_WRITE_IN;

            -- Control Internal
            data_e_in_int <= '1';
          end if;

          if (E_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_v_write_int(to_integer(unsigned(index_i_loop))) <= V_WRITE_IN;

            -- Control Internal
            data_v_in_int <= '1';
          end if;

          -- Control Outputs
          K_WRITE_OUT_K_ENABLE <= '0';
          E_WRITE_OUT_K_ENABLE <= '0';
          V_WRITE_OUT_K_ENABLE <= '0';

          if (data_k_in_int = '1' and data_e_in_int = '1' and data_v_in_int = '1') then
            -- Control Internal
            data_k_in_int <= '0';
            data_e_in_int <= '0';
            data_v_in_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_FIRST_STATE;
          end if;

        when CLEAN_FIRST_STATE =>       -- STEP 3

          if (unsigned(index_i_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          elsif (unsigned(index_i_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_STATE;
          end if;

        when INPUT_SECOND_I_STATE =>    -- STEP 5 pi,f

          if ((PI_READ_IN_I_ENABLE = '1') and (PI_READ_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_pi_read_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= PI_READ_IN;

            -- Control Internal
            data_pi_in_i_int <= '1';
            data_pi_in_j_int <= '1';
          end if;

          if (F_READ_IN_ENABLE = '1') then
            -- Data Inputs
            vector_f_read_int(to_integer(unsigned(index_i_loop))) <= F_READ_IN;

            -- Control Internal
            data_f_in_int <= '1';
          end if;

          -- Control Outputs
          PI_READ_OUT_I_ENABLE <= '0';
          PI_READ_OUT_P_ENABLE <= '0';

          F_READ_OUT_ENABLE <= '0';

          if (data_pi_in_i_int = '1' and data_pi_in_j_int = '1' and data_f_in_int = '1') then
            -- Control Internal
            data_pi_in_i_int <= '0';
            data_pi_in_j_int <= '0';

            data_f_in_int <= '0';

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_SECOND_J_STATE;
          end if;

        when INPUT_SECOND_J_STATE =>    -- STEP 6 pi

          if (PI_READ_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_pi_read_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= PI_READ_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
            else
              controller_ctrl_fsm_int <= INPUT_THIRD_J_STATE;
            end if;
          end if;

          -- Control Outputs
          PI_READ_OUT_P_ENABLE <= '0';

        when CLEAN_SECOND_I_STATE =>    -- STEP 7

          if ((unsigned(index_i_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            F_READ_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL))) then
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            F_READ_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_I_STATE;
          end if;

        when CLEAN_SECOND_J_STATE =>    -- STEP 8

          if (unsigned(index_j_loop) < unsigned(THREE_CONTROL)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_J_STATE;
          end if;

        when INPUT_THIRD_I_STATE =>     -- STEP 9 k,beta

          if ((K_READ_OUT_I_ENABLE = '1') and (K_READ_OUT_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_read_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= K_READ_IN;

            -- Control Internal
            data_k_in_i_int <= '1';
            data_k_in_j_int <= '1';
          end if;

          if (BETA_READ_IN_ENABLE = '1') then
            -- Data Inputs
            vector_e_write_int(to_integer(unsigned(index_i_loop))) <= BETA_READ_IN;

            -- Control Internal
            data_beta_in_int <= '1';
          end if;

          if (data_k_in_i_int = '1' and data_k_in_j_int = '1' and data_beta_in_int = '1') then
            -- Control Internal
            data_k_in_i_int <= '0';
            data_k_in_j_int <= '0';

            data_beta_in_int <= '0';

            -- Data Internal
            matrix_out_int <= function_dnc_addressing (
              SIZE_R_IN => SIZE_R_IN,
              SIZE_N_IN => SIZE_N_IN,
              SIZE_W_IN => SIZE_W_IN,

              matrix_k_read_input    => matrix_k_read_int,
              vector_beta_read_input => vector_beta_read_int,
              vector_f_read_input    => vector_f_read_int,
              matrix_pi_read_input   => matrix_pi_read_int,

              vector_k_write_input    => vector_k_write_int,
              scalar_beta_write_input => BETA_WRITE_IN,
              vector_e_write_input    => vector_e_write_int,
              vector_v_write_input    => vector_v_write_int,
              scalar_ga_write_input   => GA_WRITE_IN,
              scalar_gw_write_input   => GW_WRITE_IN
              );

            -- FSM Control
            controller_ctrl_fsm_int <= CLEAN_THIRD_J_STATE;
          end if;

          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

          K_READ_OUT_I_ENABLE <= '0';
          K_READ_OUT_K_ENABLE <= '0';

          BETA_READ_OUT_ENABLE <= '0';

        when INPUT_THIRD_J_STATE =>     -- STEP 10 k

          if (K_READ_OUT_K_ENABLE = '1') then
            -- Data Inputs
            matrix_k_read_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop))) <= K_READ_IN;

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_ctrl_fsm_int <= CLEAN_THIRD_I_STATE;
            else
              controller_ctrl_fsm_int <= CLEAN_THIRD_J_STATE;
            end if;
          end if;

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

        when CLEAN_THIRD_I_STATE =>     -- STEP 11

          if ((unsigned(index_i_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            READY <= '1';

            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            BETA_READ_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= STARTER_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            BETA_READ_OUT_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_I_STATE;
          end if;

        when CLEAN_THIRD_J_STATE =>     -- STEP 12

          if (unsigned(index_j_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            R_OUT <= matrix_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_THIRD_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
