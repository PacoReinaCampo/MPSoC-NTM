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

use ieee.math_real.all;
use ieee.float_pkg.all;

use work.ntm_arithmetic_pkg.all;
use work.ntm_math_pkg.all;

entity ntm_tensor_convolution is
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
    DATA_A_IN_K_ENABLE : in std_logic;
    DATA_B_IN_I_ENABLE : in std_logic;
    DATA_B_IN_J_ENABLE : in std_logic;
    DATA_B_IN_K_ENABLE : in std_logic;

    DATA_I_ENABLE : out std_logic;
    DATA_J_ENABLE : out std_logic;
    DATA_K_ENABLE : out std_logic;

    DATA_OUT_I_ENABLE : out std_logic;
    DATA_OUT_J_ENABLE : out std_logic;
    DATA_OUT_K_ENABLE : out std_logic;

    -- DATA
    SIZE_A_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_A_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_I_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_J_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_B_K_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    DATA_A_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_B_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_tensor_convolution_architecture of ntm_tensor_convolution is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type convolution_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_I_STATE,                      -- STEP 1
    INPUT_J_STATE,                      -- STEP 2
    INPUT_K_STATE,                      -- STEP 3
    ENDER_I_STATE,                      -- STEP 4
    ENDER_J_STATE,                      -- STEP 5
    ENDER_K_STATE,                      -- STEP 6
    CONVOLUTION_STATE,                  -- STEP 7
    CLEAN_I_STATE,                      -- STEP 8
    CLEAN_J_STATE,                      -- STEP 9
    CLEAN_K_STATE,                      -- STEP 10
    OPERATION_I_STATE,                  -- STEP 11
    OPERATION_J_STATE,                  -- STEP 12
    OPERATION_K_STATE                   -- STEP 13
    );

  -- Buffer
  type tensor_buffer is array (CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0, CONTROL_SIZE-1 downto 0) of std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(0.0));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(1.0));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(2.0));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_float(3.0));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal convolution_ctrl_fsm_int : convolution_ctrl_fsm;

  -- Buffer
  signal tensor_a_int : tensor_buffer;
  signal tensor_b_int : tensor_buffer;

  signal tensor_out_int : tensor_buffer;

  -- Control Internal
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_m_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_a_in_i_convolution_int : std_logic;
  signal data_a_in_j_convolution_int : std_logic;
  signal data_a_in_k_convolution_int : std_logic;
  signal data_b_in_i_convolution_int : std_logic;
  signal data_b_in_j_convolution_int : std_logic;
  signal data_b_in_k_convolution_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- DATA_OUT = DATA_A_IN · DATA_B_IN

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
    variable tensor_convolution_int : tensor_buffer;
  begin
    if (RST = '0') then
      -- Data Outputs
      DATA_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      DATA_I_ENABLE <= '0';
      DATA_J_ENABLE <= '0';
      DATA_K_ENABLE <= '0';

      DATA_OUT_I_ENABLE <= '0';
      DATA_OUT_J_ENABLE <= '0';
      DATA_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_loop <= ZERO_CONTROL;
      index_j_loop <= ZERO_CONTROL;
      index_k_loop <= ZERO_CONTROL;
      index_m_loop <= ZERO_CONTROL;

      data_a_in_i_convolution_int <= '0';
      data_a_in_j_convolution_int <= '0';
      data_a_in_k_convolution_int <= '0';
      data_b_in_i_convolution_int <= '0';
      data_b_in_j_convolution_int <= '0';
      data_b_in_k_convolution_int <= '0';

    elsif (rising_edge(CLK)) then

      case convolution_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          if (START = '1') then
            if ((unsigned(SIZE_A_I_IN) = unsigned(SIZE_B_I_IN)) and (unsigned(SIZE_A_K_IN) = unsigned(SIZE_B_J_IN))) then
              -- Control Outputs
              DATA_I_ENABLE <= '1';
              DATA_J_ENABLE <= '1';
              DATA_K_ENABLE <= '1';

              -- Control Internal
              index_i_loop <= ZERO_CONTROL;
              index_j_loop <= ZERO_CONTROL;
              index_k_loop <= ZERO_CONTROL;
              index_m_loop <= ZERO_CONTROL;

              -- FSM Control
              convolution_ctrl_fsm_int <= INPUT_I_STATE;
            else
              -- Control Outputs
              READY <= '1';
            end if;
          else
            -- Control Outputs
            READY <= '0';

            DATA_I_ENABLE <= '0';
            DATA_J_ENABLE <= '0';
            DATA_K_ENABLE <= '0';
          end if;

        when INPUT_I_STATE =>           -- STEP 1

          if ((DATA_A_IN_I_ENABLE = '1') and (DATA_A_IN_J_ENABLE = '1') and (DATA_A_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= DATA_A_IN;

            -- Control Internal
            data_a_in_i_convolution_int <= '1';
            data_a_in_j_convolution_int <= '1';
            data_a_in_k_convolution_int <= '1';
          end if;

          if ((DATA_B_IN_I_ENABLE = '1') and (DATA_B_IN_J_ENABLE = '1') and (DATA_B_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_b_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= DATA_B_IN;

            -- Control Internal
            data_b_in_i_convolution_int <= '1';
            data_b_in_j_convolution_int <= '1';
            data_b_in_k_convolution_int <= '1';
          end if;

          -- Control Outputs
          DATA_I_ENABLE <= '0';
          DATA_J_ENABLE <= '0';
          DATA_K_ENABLE <= '0';

          if (data_a_in_i_convolution_int = '1' and data_a_in_j_convolution_int = '1' and data_a_in_k_convolution_int = '1' and data_b_in_i_convolution_int = '1' and data_b_in_j_convolution_int = '1' and data_b_in_k_convolution_int = '1') then
            -- Control Internal
            data_a_in_i_convolution_int <= '0';
            data_a_in_j_convolution_int <= '0';
            data_a_in_k_convolution_int <= '0';
            data_b_in_i_convolution_int <= '0';
            data_b_in_j_convolution_int <= '0';
            data_b_in_k_convolution_int <= '0';

            -- FSM Control
            convolution_ctrl_fsm_int <= ENDER_K_STATE;
          end if;

        when INPUT_J_STATE =>           -- STEP 2

          if ((DATA_A_IN_J_ENABLE = '1') and (DATA_A_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= DATA_A_IN;

            -- Control Internal
            data_a_in_j_convolution_int <= '1';
            data_a_in_k_convolution_int <= '1';
          end if;

          if ((DATA_B_IN_J_ENABLE = '1') and (DATA_B_IN_K_ENABLE = '1')) then
            -- Data Inputs
            tensor_b_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= DATA_B_IN;

            -- Control Internal
            data_b_in_j_convolution_int <= '1';
            data_b_in_k_convolution_int <= '1';
          end if;

          -- Control Outputs
          DATA_J_ENABLE <= '0';
          DATA_K_ENABLE <= '0';

          if (data_a_in_j_convolution_int = '1' and data_a_in_k_convolution_int = '1' and data_b_in_j_convolution_int = '1' and data_b_in_k_convolution_int = '1') then
            -- Control Internal
            data_a_in_j_convolution_int <= '0';
            data_a_in_k_convolution_int <= '0';
            data_b_in_j_convolution_int <= '0';
            data_b_in_k_convolution_int <= '0';

            -- FSM Control
            if (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
              convolution_ctrl_fsm_int <= ENDER_J_STATE;
            else
              convolution_ctrl_fsm_int <= ENDER_K_STATE;
            end if;
          end if;

        when INPUT_K_STATE =>           -- STEP 3

          if (DATA_A_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= DATA_A_IN;

            -- Control Internal
            data_a_in_k_convolution_int <= '1';
          end if;

          if (DATA_B_IN_K_ENABLE = '1') then
            -- Data Inputs
            tensor_b_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop))) <= DATA_B_IN;

            -- Control Internal
            data_b_in_k_convolution_int <= '1';
          end if;

          -- Control Outputs
          DATA_K_ENABLE <= '0';

          if (data_a_in_k_convolution_int = '1' and data_b_in_k_convolution_int = '1') then
            -- Control Internal
            data_a_in_k_convolution_int <= '0';
            data_b_in_k_convolution_int <= '0';

            -- FSM Control
            if (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL) and unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
              convolution_ctrl_fsm_int <= ENDER_I_STATE;
            elsif (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
              convolution_ctrl_fsm_int <= ENDER_J_STATE;
            else
              convolution_ctrl_fsm_int <= ENDER_K_STATE;
            end if;
          end if;

        when ENDER_I_STATE =>           -- STEP 4

          if ((unsigned(index_i_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            convolution_ctrl_fsm_int <= CONVOLUTION_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_I_ENABLE <= '1';
            DATA_J_ENABLE <= '1';
            DATA_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            convolution_ctrl_fsm_int <= INPUT_I_STATE;
          end if;

        when ENDER_J_STATE =>           -- STEP 5

          if ((unsigned(index_j_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_J_ENABLE <= '1';
            DATA_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            convolution_ctrl_fsm_int <= INPUT_J_STATE;
          end if;

        when ENDER_K_STATE =>           -- STEP 6

          if (unsigned(index_k_loop) < unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_OUT <= tensor_a_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_K_ENABLE <= '1';

            -- Control Internal
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            convolution_ctrl_fsm_int <= INPUT_K_STATE;
          end if;

        when CONVOLUTION_STATE =>       -- STEP 5

          -- Data Inputs
          for i in 0 to to_integer(unsigned(SIZE_A_I_IN))-1 loop
            for j in 0 to to_integer(unsigned(SIZE_B_J_IN))-1 loop
              for k in 0 to to_integer(unsigned(SIZE_B_K_IN))-1 loop
                tensor_convolution_int(i, j, k) := ZERO_DATA;

                for m in 0 to i loop
                  for n in 0 to j loop
                    for p in 0 to k loop
                      tensor_convolution_int(i, j, k) := std_logic_vector(to_float(to_real(to_float(tensor_convolution_int(i, j, k))) + (to_real(to_float(tensor_a_int(m, n, p)))*to_real(to_float(tensor_b_int(i-m, j-n, k-p))))));
                    end loop;
                  end loop;
                end loop;

                tensor_out_int(i, j, k) <= tensor_convolution_int(i, j, k);
              end loop;
            end loop;
          end loop;

          -- FSM Control
          convolution_ctrl_fsm_int <= CLEAN_I_STATE;

        when CLEAN_I_STATE =>           -- STEP 7

          -- Control Outputs
          DATA_I_ENABLE <= '0';
          DATA_J_ENABLE <= '0';
          DATA_K_ENABLE <= '0';

          DATA_OUT_I_ENABLE <= '0';
          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          -- FSM Control
          if ((unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            convolution_ctrl_fsm_int <= OPERATION_I_STATE;
          elsif (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
            convolution_ctrl_fsm_int <= OPERATION_J_STATE;
          else
            convolution_ctrl_fsm_int <= OPERATION_K_STATE;
          end if;

        when CLEAN_J_STATE =>           -- STEP 8

          -- Control Outputs
          DATA_J_ENABLE <= '0';
          DATA_K_ENABLE <= '0';

          DATA_OUT_J_ENABLE <= '0';
          DATA_OUT_K_ENABLE <= '0';

          -- FSM Control
          if ((unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            convolution_ctrl_fsm_int <= OPERATION_I_STATE;
          elsif (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
            convolution_ctrl_fsm_int <= OPERATION_J_STATE;
          else
            convolution_ctrl_fsm_int <= OPERATION_K_STATE;
          end if;

        when CLEAN_K_STATE =>           -- STEP 9

          -- Control Outputs
          DATA_K_ENABLE <= '0';

          DATA_OUT_K_ENABLE <= '0';

          -- FSM Control
          if ((unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            convolution_ctrl_fsm_int <= OPERATION_I_STATE;
          elsif (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
            convolution_ctrl_fsm_int <= OPERATION_J_STATE;
          else
            convolution_ctrl_fsm_int <= OPERATION_K_STATE;
          end if;

        when OPERATION_I_STATE =>       -- STEP 13

          if ((unsigned(index_i_loop) = unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= tensor_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_OUT_I_ENABLE <= '1';
            DATA_OUT_J_ENABLE <= '1';
            DATA_OUT_K_ENABLE <= '1';

            READY <= '1';

            -- Control Internal
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
            index_m_loop <= ZERO_CONTROL;

            -- FSM Control
            convolution_ctrl_fsm_int <= STARTER_STATE;
          elsif ((unsigned(index_i_loop) < unsigned(SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= tensor_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_OUT_I_ENABLE <= '1';
            DATA_OUT_J_ENABLE <= '1';
            DATA_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_loop <= std_logic_vector(unsigned(index_i_loop)+unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
            index_m_loop <= ZERO_CONTROL;

            -- FSM Control
            convolution_ctrl_fsm_int <= CLEAN_I_STATE;
          end if;

        when OPERATION_J_STATE =>       -- STEP 14

          if ((unsigned(index_j_loop) < unsigned(SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            DATA_OUT <= tensor_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_OUT_J_ENABLE <= '1';
            DATA_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_loop <= std_logic_vector(unsigned(index_j_loop)+unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;

            -- FSM Control
            convolution_ctrl_fsm_int <= CLEAN_J_STATE;
          end if;

        when OPERATION_K_STATE =>       -- STEP 15

          if (unsigned(index_k_loop) < unsigned(SIZE_B_K_IN)-unsigned(ONE_CONTROL)) then
            -- Data Outputs
            DATA_OUT <= tensor_out_int(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- Control Outputs
            DATA_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_loop <= std_logic_vector(unsigned(index_k_loop)+unsigned(ONE_CONTROL));

            -- FSM Control
            convolution_ctrl_fsm_int <= CLEAN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          convolution_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
