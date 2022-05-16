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

entity dnc_read_weighting is
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

    PI_IN_I_ENABLE : in std_logic;      -- for i in 0 to R-1
    PI_IN_P_ENABLE : in std_logic;      -- for p in 0 to 2

    PI_OUT_I_ENABLE : out std_logic;    -- for i in 0 to R-1
    PI_OUT_P_ENABLE : out std_logic;    -- for p in 0 to 2

    B_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    B_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    B_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    B_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    C_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    C_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    C_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    C_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    F_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    F_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    F_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    F_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    W_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    W_OUT_J_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    PI_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    B_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    C_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    W_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_read_weighting_architecture of dnc_read_weighting is

  -----------------------------------------------------------------------
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- PI_IN [R,P]
  -- B_IN  [R,N]
  -- C_IN  [R,N]
  -- F_IN  [R,N]

  -- Outputs:
  -- W_OUT [R,N]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_N_STATE, CLEAN_OUT_N_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  type controller_pi_in_fsm is (
    STARTER_PI_IN_STATE,                -- STEP 0
    INPUT_PI_IN_I_STATE,                -- STEP 1
    INPUT_PI_IN_P_STATE,                -- STEP 2
    CLEAN_PI_IN_I_STATE,                -- STEP 3
    CLEAN_PI_IN_P_STATE                 -- STEP 4
    );

  type controller_in_fsm is (
    STARTER_IN_STATE,                   -- STEP 0
    INPUT_IN_I_STATE,                   -- STEP 1
    INPUT_IN_J_STATE,                   -- STEP 2
    CLEAN_IN_I_STATE,                   -- STEP 3
    CLEAN_IN_J_STATE                    -- STEP 4
    );


  -- Ops
  type controller_vector_float_adder_fsm is (
    STARTER_VECTOR_FLOAT_ADDER_STATE,   -- STEP 0
    INPUT_VECTOR_FLOAT_ADDER_STATE,     -- STEP 2
    CLEAN_VECTOR_FLOAT_ADDER_STATE      -- STEP 4
    );

  type controller_vector_float_multiplier_fsm is (
    STARTER_VECTOR_FLOAT_MULTIPLIER_STATE,  -- STEP 0
    INPUT_VECTOR_FLOAT_MULTIPLIER_STATE,    -- STEP 2
    CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE     -- STEP 4
    );

  -- Output
  type controller_w_out_fsm is (
    STARTER_W_OUT_STATE,                -- STEP 0
    CLEAN_W_OUT_I_STATE,                -- STEP 1
    CLEAN_W_OUT_J_STATE,                -- STEP 2
    OUTPUT_W_OUT_I_STATE,               -- STEP 3
    OUTPUT_W_OUT_J_STATE                -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  -- Input
  signal controller_pi_in_fsm_int : controller_pi_in_fsm;

  signal controller_in_fsm_int : controller_in_fsm;

  -- Ops
  signal controller_vector_float_adder_fsm_int      : controller_vector_float_adder_fsm;
  signal controller_vector_float_multiplier_fsm_int : controller_vector_float_multiplier_fsm;

  -- Output
  signal controller_w_out_fsm_int : controller_w_out_fsm;

  -- Buffer
  -- Input
  signal matrix_pi_in_int : matrix_buffer;

  signal matrix_b_in_int : matrix_buffer;
  signal matrix_c_in_int : matrix_buffer;
  signal matrix_f_in_int : matrix_buffer;

  -- Ops
  signal matrix_operation_int : matrix_buffer;
  signal vector_operation_int : vector_buffer;

  -- Output
  signal matrix_w_out_int : matrix_buffer;

  -- Control Internal - Index
  -- Input
  signal index_i_pi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_pi_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Ops
  signal index_vector_float_multiplier_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_vector_float_adder_loop      : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Output
  signal index_i_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_w_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- Enable
  -- Input
  signal data_pi_in_enable_int : std_logic;

  signal data_b_in_enable_int : std_logic;
  signal data_c_in_enable_int : std_logic;
  signal data_f_in_enable_int : std_logic;

  signal data_in_enable_int : std_logic;

  -- Ops
  signal data_vector_float_adder_enable_int      : std_logic;
  signal data_vector_float_multiplier_enable_int : std_logic;

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_float_adder : std_logic;
  signal ready_vector_float_adder : std_logic;

  signal operation_vector_float_adder : std_logic;

  signal data_a_in_enable_vector_float_adder : std_logic;
  signal data_b_in_enable_vector_float_adder : std_logic;

  signal data_out_enable_vector_float_adder : std_logic;

  -- DATA
  signal size_in_vector_float_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_float_multiplier : std_logic;
  signal ready_vector_float_multiplier : std_logic;

  signal data_a_in_enable_vector_float_multiplier : std_logic;
  signal data_b_in_enable_vector_float_multiplier : std_logic;

  signal data_out_enable_vector_float_multiplier : std_logic;

  -- DATA
  signal size_in_vector_float_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_float_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_float_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

  -- INPUT CONTROL
  pi_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      PI_OUT_I_ENABLE <= '0';
      PI_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_i_pi_in_loop <= ZERO_CONTROL;
      index_p_pi_in_loop <= ZERO_CONTROL;

      data_pi_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_pi_in_fsm_int is
        when STARTER_PI_IN_STATE =>     -- STEP 0
          if (START = '1') then
            -- Control Outputs
            PI_OUT_I_ENABLE <= '1';
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_in_loop <= ZERO_CONTROL;
            index_p_pi_in_loop <= ZERO_CONTROL;

            data_pi_in_enable_int <= '0';

            -- FSM Control
            controller_pi_in_fsm_int <= INPUT_PI_IN_I_STATE;
          else
            -- Control Outputs
            PI_OUT_I_ENABLE <= '0';
            PI_OUT_P_ENABLE <= '0';
          end if;

        when INPUT_PI_IN_I_STATE =>     -- STEP 1

          if ((PI_IN_I_ENABLE = '1') and (PI_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_pi_in_int(to_integer(unsigned(index_i_pi_in_loop)), to_integer(unsigned(index_p_pi_in_loop))) <= PI_IN;

            -- FSM Control
            controller_pi_in_fsm_int <= CLEAN_PI_IN_P_STATE;
          end if;

          -- Control Outputs
          PI_OUT_I_ENABLE <= '0';
          PI_OUT_P_ENABLE <= '0';

        when INPUT_PI_IN_P_STATE =>     -- STEP 2

          if (PI_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_pi_in_int(to_integer(unsigned(index_i_pi_in_loop)), to_integer(unsigned(index_p_pi_in_loop))) <= PI_IN;

            -- FSM Control
            if (unsigned(index_p_pi_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_pi_in_fsm_int <= CLEAN_PI_IN_I_STATE;
            else
              controller_pi_in_fsm_int <= CLEAN_PI_IN_P_STATE;
            end if;
          end if;

          -- Control Outputs
          PI_OUT_P_ENABLE <= '0';

        when CLEAN_PI_IN_I_STATE =>     -- STEP 3

          if ((unsigned(index_i_pi_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_OUT_I_ENABLE <= '1';
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_in_loop <= ZERO_CONTROL;
            index_p_pi_in_loop <= ZERO_CONTROL;

            data_pi_in_enable_int <= '1';

            -- FSM Control
            controller_pi_in_fsm_int <= STARTER_PI_IN_STATE;
          elsif ((unsigned(index_i_pi_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_OUT_I_ENABLE <= '1';
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_in_loop <= std_logic_vector(unsigned(index_i_pi_in_loop) + unsigned(ONE_CONTROL));
            index_p_pi_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_pi_in_fsm_int <= INPUT_PI_IN_I_STATE;
          end if;

        when CLEAN_PI_IN_P_STATE =>     -- STEP 4

          if (unsigned(index_p_pi_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            PI_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_pi_in_loop <= std_logic_vector(unsigned(index_p_pi_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_pi_in_fsm_int <= INPUT_PI_IN_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_pi_in_fsm_int <= STARTER_PI_IN_STATE;
      end case;
    end if;
  end process;

  in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      B_OUT_I_ENABLE <= '0';
      B_OUT_J_ENABLE <= '0';

      C_OUT_I_ENABLE <= '0';
      C_OUT_J_ENABLE <= '0';

      F_OUT_I_ENABLE <= '0';
      F_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_in_loop <= ZERO_CONTROL;
      index_j_in_loop <= ZERO_CONTROL;

      data_b_in_enable_int <= '0';
      data_c_in_enable_int <= '0';
      data_f_in_enable_int <= '0';

      data_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_in_fsm_int is
        when STARTER_IN_STATE =>        -- STEP 0
          if (START = '1') then
            -- Control Outputs
            B_OUT_I_ENABLE <= '1';
            B_OUT_J_ENABLE <= '1';

            C_OUT_I_ENABLE <= '1';
            C_OUT_J_ENABLE <= '1';

            F_OUT_I_ENABLE <= '1';
            F_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_in_loop <= ZERO_CONTROL;
            index_j_in_loop <= ZERO_CONTROL;

            data_b_in_enable_int <= '0';
            data_c_in_enable_int <= '0';
            data_f_in_enable_int <= '0';

            data_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= INPUT_IN_I_STATE;
          else
            -- Control Outputs
            B_OUT_I_ENABLE <= '0';
            B_OUT_J_ENABLE <= '0';

            C_OUT_I_ENABLE <= '0';
            C_OUT_J_ENABLE <= '0';

            F_OUT_I_ENABLE <= '0';
            F_OUT_J_ENABLE <= '0';
          end if;

        when INPUT_IN_I_STATE =>        -- STEP 1

          if ((B_IN_I_ENABLE = '1') and (B_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_in_loop)), to_integer(unsigned(index_j_in_loop))) <= B_IN;

            -- Control Internal
            data_b_in_enable_int <= '1';
          end if;

          if ((C_IN_I_ENABLE = '1') and (C_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_c_in_int(to_integer(unsigned(index_i_in_loop)), to_integer(unsigned(index_j_in_loop))) <= C_IN;

            -- Control Internal
            data_c_in_enable_int <= '1';
          end if;

          if ((F_IN_I_ENABLE = '1') and (F_IN_J_ENABLE = '1')) then
            -- Data Inputs
            matrix_f_in_int(to_integer(unsigned(index_i_in_loop)), to_integer(unsigned(index_j_in_loop))) <= F_IN;

            -- Control Internal
            data_f_in_enable_int <= '1';
          end if;

          -- Control Outputs
          B_OUT_I_ENABLE <= '0';
          B_OUT_J_ENABLE <= '0';

          C_OUT_I_ENABLE <= '0';
          C_OUT_J_ENABLE <= '0';

          F_OUT_I_ENABLE <= '0';
          F_OUT_J_ENABLE <= '0';

          if (data_b_in_enable_int = '1' and data_c_in_enable_int = '1' and data_f_in_enable_int = '1') then
            -- Control Internal
            data_b_in_enable_int <= '0';
            data_c_in_enable_int <= '0';
            data_f_in_enable_int <= '0';

            -- FSM Control
            controller_in_fsm_int <= CLEAN_IN_J_STATE;
          end if;

        when INPUT_IN_J_STATE =>        -- STEP 2

          if (B_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_in_loop)), to_integer(unsigned(index_j_in_loop))) <= B_IN;

            -- Control Internal
            data_b_in_enable_int <= '1';
          end if;

          if (C_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_c_in_int(to_integer(unsigned(index_i_in_loop)), to_integer(unsigned(index_j_in_loop))) <= C_IN;

            -- Control Internal
            data_c_in_enable_int <= '1';
          end if;

          if (F_IN_J_ENABLE = '1') then
            -- Data Inputs
            matrix_b_in_int(to_integer(unsigned(index_i_in_loop)), to_integer(unsigned(index_j_in_loop))) <= F_IN;

            -- Control Internal
            data_f_in_enable_int <= '1';
          end if;

          if (data_b_in_enable_int = '1' and data_c_in_enable_int = '1' and data_f_in_enable_int = '1') then
            -- FSM Control
            if (unsigned(index_j_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_in_fsm_int <= CLEAN_IN_I_STATE;
            else
              controller_in_fsm_int <= CLEAN_IN_J_STATE;
            end if;
          end if;

          -- Control Outputs
          B_OUT_J_ENABLE <= '0';
          C_OUT_J_ENABLE <= '0';
          F_OUT_J_ENABLE <= '0';

        when CLEAN_IN_I_STATE =>        -- STEP 3

          if ((unsigned(index_i_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            B_OUT_I_ENABLE <= '1';
            B_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_in_loop <= ZERO_CONTROL;
            index_j_in_loop <= ZERO_CONTROL;

            data_in_enable_int <= '1';

            -- FSM Control
            controller_in_fsm_int <= STARTER_IN_STATE;
          elsif ((unsigned(index_i_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            B_OUT_I_ENABLE <= '1';
            B_OUT_J_ENABLE <= '1';

            C_OUT_I_ENABLE <= '1';
            C_OUT_J_ENABLE <= '1';

            F_OUT_I_ENABLE <= '1';
            F_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_in_loop <= std_logic_vector(unsigned(index_i_in_loop) + unsigned(ONE_CONTROL));
            index_j_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_in_fsm_int <= INPUT_IN_I_STATE;
          end if;

        when CLEAN_IN_J_STATE =>        -- STEP 4

          if (unsigned(index_j_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            B_OUT_J_ENABLE <= '1';
            C_OUT_J_ENABLE <= '1';
            F_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_in_loop <= std_logic_vector(unsigned(index_j_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_in_fsm_int <= INPUT_IN_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_in_fsm_int <= STARTER_IN_STATE;
      end case;
    end if;
  end process;

  -- OPS CONTROL
  vector_float_adder_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_adder <= '0';
      data_b_in_enable_vector_float_adder <= '0';

      data_vector_float_adder_enable_int <= '0';

      index_vector_float_adder_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_adder_fsm_int is
        when STARTER_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_adder <= '0';
          data_b_in_enable_vector_float_adder <= '0';

          data_vector_float_adder_enable_int <= '0';

          if (data_f_in_enable_int = '1' and data_f_in_enable_int = '1') then
            -- Data Inputs
            operation_vector_float_adder <= '0';

            size_in_vector_float_adder <= SIZE_N_IN;

            -- Control Internal
            index_vector_float_adder_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
          end if;

        when INPUT_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));
          data_b_in_vector_float_adder <= vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_adder_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_adder <= '1';
          end if;

          data_a_in_enable_vector_float_adder <= '1';
          data_b_in_enable_vector_float_adder <= '1';

          -- FSM Control
          controller_vector_float_adder_fsm_int <= CLEAN_VECTOR_FLOAT_ADDER_STATE;

        when CLEAN_VECTOR_FLOAT_ADDER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_adder = '1' and data_out_enable_vector_float_adder = '1') then
            if (unsigned(index_vector_float_adder_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              data_vector_float_adder_enable_int <= '1';

              index_vector_float_adder_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
            elsif (unsigned(index_vector_float_adder_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_adder_loop))) <= data_out_vector_float_adder;

              -- Control Internal
              index_vector_float_adder_loop <= std_logic_vector(unsigned(index_vector_float_adder_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_float_adder_fsm_int <= INPUT_VECTOR_FLOAT_ADDER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_adder <= '0';

            data_a_in_enable_vector_float_adder <= '0';
            data_b_in_enable_vector_float_adder <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_float_adder_fsm_int <= STARTER_VECTOR_FLOAT_ADDER_STATE;
      end case;
    end if;
  end process;

  vector_float_multiplier_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Internal
      data_a_in_enable_vector_float_multiplier <= '0';
      data_b_in_enable_vector_float_multiplier <= '0';

      data_vector_float_multiplier_enable_int <= '0';

      index_vector_float_multiplier_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_vector_float_multiplier_fsm_int is
        when STARTER_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 0
          -- Control Internal
          data_a_in_enable_vector_float_multiplier <= '0';
          data_b_in_enable_vector_float_multiplier <= '0';

          data_vector_float_multiplier_enable_int <= '0';

          if (data_f_in_enable_int = '1' and data_f_in_enable_int = '1') then
            -- Data Inputs
            size_in_vector_float_multiplier <= SIZE_N_IN;

            -- Control Internal
            index_vector_float_multiplier_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_vector_float_multiplier_fsm_int <= INPUT_VECTOR_FLOAT_MULTIPLIER_STATE;
          end if;

        when INPUT_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 5

          -- Data Inputs
          data_a_in_vector_float_multiplier <= vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop)));
          data_b_in_vector_float_multiplier <= vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop)));

          -- Control Internal
          if (unsigned(index_vector_float_multiplier_loop) = unsigned(ZERO_CONTROL) and unsigned(index_vector_float_multiplier_loop) = unsigned(ZERO_CONTROL)) then
            start_vector_float_multiplier <= '1';
          end if;

          data_a_in_enable_vector_float_multiplier <= '1';
          data_b_in_enable_vector_float_multiplier <= '1';

          -- FSM Control
          controller_vector_float_multiplier_fsm_int <= CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE;

        when CLEAN_VECTOR_FLOAT_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_enable_vector_float_multiplier = '1' and data_out_enable_vector_float_multiplier = '1') then
            if (unsigned(index_vector_float_multiplier_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              data_vector_float_multiplier_enable_int <= '1';

              index_vector_float_multiplier_loop <= ZERO_CONTROL;

              -- FSM Control
              controller_vector_float_multiplier_fsm_int <= STARTER_VECTOR_FLOAT_MULTIPLIER_STATE;
            elsif (unsigned(index_vector_float_multiplier_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              -- Data Internal
              vector_operation_int(to_integer(unsigned(index_vector_float_multiplier_loop))) <= data_out_vector_float_multiplier;

              -- Control Internal
              index_vector_float_multiplier_loop <= std_logic_vector(unsigned(index_vector_float_multiplier_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_vector_float_multiplier_fsm_int <= INPUT_VECTOR_FLOAT_MULTIPLIER_STATE;
            end if;
          else
            -- Control Internal
            start_vector_float_multiplier <= '0';

            data_a_in_enable_vector_float_multiplier <= '0';
            data_b_in_enable_vector_float_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_vector_float_multiplier_fsm_int <= STARTER_VECTOR_FLOAT_MULTIPLIER_STATE;
      end case;
    end if;
  end process;

  -- OUTPUT CONTROL
  w_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      W_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      W_OUT_I_ENABLE <= '0';
      W_OUT_J_ENABLE <= '0';

      -- Control Internal
      index_i_w_out_loop <= ZERO_CONTROL;
      index_j_w_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_w_out_fsm_int is
        when STARTER_W_OUT_STATE =>     -- STEP 0
          if (data_in_enable_int = '1' and data_pi_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_i_w_out_loop <= ZERO_CONTROL;
            index_j_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_I_STATE;
          end if;

        when CLEAN_W_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          W_OUT_I_ENABLE <= '0';
          W_OUT_J_ENABLE <= '0';

          -- FSM Control
          controller_w_out_fsm_int <= OUTPUT_W_OUT_J_STATE;

        when CLEAN_W_OUT_J_STATE =>     -- STEP 2

          -- Control Outputs
          W_OUT_J_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_j_w_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            controller_w_out_fsm_int <= OUTPUT_W_OUT_I_STATE;
          else
            controller_w_out_fsm_int <= OUTPUT_W_OUT_J_STATE;
          end if;

        when OUTPUT_W_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_w_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_i_w_out_loop)), to_integer(unsigned(index_j_w_out_loop)));

            -- Control Outputs
            READY <= '1';

            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_out_loop <= ZERO_CONTROL;
            index_j_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
          elsif ((unsigned(index_i_w_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_w_out_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            W_OUT <= matrix_w_out_int(to_integer(unsigned(index_i_w_out_loop)), to_integer(unsigned(index_j_w_out_loop)));

            -- Control Outputs
            W_OUT_I_ENABLE <= '1';
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_i_w_out_loop <= std_logic_vector(unsigned(index_i_w_out_loop) + unsigned(ONE_CONTROL));
            index_j_w_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_I_STATE;
          end if;

        when OUTPUT_W_OUT_J_STATE =>    -- STEP 4

          if (unsigned(index_j_w_out_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            W_OUT_J_ENABLE <= '1';

            -- Control Internal
            index_j_w_out_loop <= std_logic_vector(unsigned(index_j_w_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_w_out_fsm_int <= CLEAN_W_OUT_J_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_w_out_fsm_int <= STARTER_W_OUT_STATE;
      end case;
    end if;
  end process;

  -- VECTOR ADDER
  vector_float_adder : ntm_vector_float_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_adder,
      READY => ready_vector_float_adder,

      OPERATION => operation_vector_float_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_float_adder,

      -- DATA
      SIZE_IN   => size_in_vector_float_adder,
      DATA_A_IN => data_a_in_vector_float_adder,
      DATA_B_IN => data_b_in_vector_float_adder,
      DATA_OUT  => data_out_vector_float_adder
      );

  -- VECTOR MULTIPLIER
  vector_float_multiplier : ntm_vector_float_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_float_multiplier,
      READY => ready_vector_float_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_float_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_float_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_float_multiplier,

      -- DATA
      SIZE_IN   => size_in_vector_float_multiplier,
      DATA_A_IN => data_a_in_vector_float_multiplier,
      DATA_B_IN => data_b_in_vector_float_multiplier,
      DATA_OUT  => data_out_vector_float_multiplier
      );

end architecture;