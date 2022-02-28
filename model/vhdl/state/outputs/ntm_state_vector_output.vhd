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

use work.ntm_state_pkg.all;

entity ntm_state_vector_output is
  generic (
    DATA_SIZE    : integer := 32;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    DATA_A_IN_I_ENABLE : in std_logic;
    DATA_A_IN_J_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_C_IN_I_ENABLE : in std_logic;
    DATA_C_IN_J_ENABLE : in std_logic;
    DATA_D_IN_I_ENABLE : in std_logic;
    DATA_D_IN_J_ENABLE : in std_logic;

    DATA_A_I_ENABLE : out std_logic;
    DATA_A_J_ENABLE : out std_logic;
    DATA_B_I_ENABLE : out std_logic;
    DATA_B_J_ENABLE : out std_logic;
    DATA_C_I_ENABLE : out std_logic;
    DATA_C_J_ENABLE : out std_logic;
    DATA_D_I_ENABLE : out std_logic;
    DATA_D_J_ENABLE : out std_logic;

    DATA_K_IN_I_ENABLE : in std_logic;
    DATA_K_IN_J_ENABLE : in std_logic;

    DATA_K_I_ENABLE : out std_logic;
    DATA_K_J_ENABLE : out std_logic;

    DATA_U_IN_ENABLE : in std_logic;

    DATA_U_ENABLE : out std_logic;

    DATA_Y_OUT_ENABLE : out std_logic;

    -- DATA
    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_C_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_D_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_A_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_D_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    DATA_Y_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_state_vector_output_architecture of ntm_state_vector_output is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type output_ctrl_fsm is (
    STARTER_STATE,             -- STEP 0
    INPUT_FIRST_I_STATE,       -- STEP 1
    INPUT_FIRST_J_STATE,       -- STEP 2
    CLEAN_FIRST_I_STATE,       -- STEP 3
    CLEAN_FIRST_J_STATE,       -- STEP 4
    INPUT_SECOND_I_STATE,      -- STEP 5
    INPUT_SECOND_J_STATE,      -- STEP 6
    CLEAN_SECOND_I_STATE,      -- STEP 7
    CLEAN_SECOND_J_STATE,      -- STEP 8
    INPUT_THIRD_I_STATE,       -- STEP 9
    INPUT_THIRD_J_STATE,       -- STEP 10
    CLEAN_THIRD_I_STATE,       -- STEP 11
    CLEAN_THIRD_J_STATE,       -- STEP 12
    INPUT_FOURTH_I_STATE,      -- STEP 13
    INPUT_FOURTH_J_STATE,      -- STEP 14
    CLEAN_FOURTH_I_STATE,      -- STEP 15
    CLEAN_FOURTH_J_STATE       -- STEP 16
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal output_ctrl_fsm_int : output_ctrl_fsm;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_output_int : std_logic;
  signal data_a_in_j_output_int : std_logic;
  signal data_b_in_i_output_int : std_logic;
  signal data_b_in_j_output_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- x(k+1) = A·x(k) + B·u(k)
  -- y(k) = C·x(k) + D·u(k)

  -- y(k) = C·exp(A,k)·x(0) + summation(C·exp(A,k-j)·B·u(j))[j in 0 to k-1] + D·u(k)

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_Y_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case output_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Control Outputs
            DATA_A_I_ENABLE <= '1';
            DATA_A_J_ENABLE <= '1';
            DATA_B_I_ENABLE <= '1';
            DATA_B_J_ENABLE <= '1';
            DATA_C_I_ENABLE <= '1';
            DATA_C_J_ENABLE <= '1';
            DATA_D_I_ENABLE <= '1';
            DATA_D_J_ENABLE <= '1';

            DATA_K_I_ENABLE <= '1';
            DATA_K_J_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;

            -- FSM Control
            output_ctrl_fsm_int <= INPUT_FIRST_I_STATE;
          else
            -- Control Outputs
            DATA_A_I_ENABLE <= '0';
            DATA_A_J_ENABLE <= '0';
            DATA_B_I_ENABLE <= '0';
            DATA_B_J_ENABLE <= '0';
            DATA_C_I_ENABLE <= '0';
            DATA_C_J_ENABLE <= '0';
            DATA_D_I_ENABLE <= '0';
            DATA_D_J_ENABLE <= '0';

            DATA_K_I_ENABLE <= '0';
            DATA_K_J_ENABLE <= '0';
          end if;

        when INPUT_FIRST_I_STATE =>  -- STEP 1 A

        when INPUT_FIRST_J_STATE =>  -- STEP 2 A

        when CLEAN_FIRST_I_STATE =>  -- STEP 3

        when CLEAN_FIRST_J_STATE =>  -- STEP 4

        when INPUT_SECOND_I_STATE =>  -- STEP 5 C

        when INPUT_SECOND_J_STATE =>  -- STEP 6 C

        when CLEAN_SECOND_I_STATE =>  -- STEP 7

        when CLEAN_SECOND_J_STATE =>  -- STEP 8

        when INPUT_THIRD_I_STATE =>  -- STEP 9 B, u

        when INPUT_THIRD_J_STATE =>  -- STEP 10 B

        when CLEAN_THIRD_I_STATE =>  -- STEP 11

        when CLEAN_THIRD_J_STATE =>  -- STEP 12

        when INPUT_FOURTH_I_STATE =>  -- STEP 13 D

        when INPUT_FOURTH_J_STATE =>  -- STEP 14 D

        when CLEAN_FOURTH_I_STATE =>  -- STEP 15

        when CLEAN_FOURTH_J_STATE =>  -- STEP 16

        when others =>
          -- FSM Control
          output_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;