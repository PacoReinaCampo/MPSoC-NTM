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

use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;

entity dnc_allocation_weighting is
  generic (
    DATA_SIZE    : integer := 128;
    CONTROL_SIZE : integer := 64
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    U_IN_ENABLE : in std_logic;         -- for j in 0 to N-1

    U_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    A_OUT_ENABLE : out std_logic;       -- for j in 0 to N-1

    -- DATA
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

    U_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    A_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_allocation_weighting_architecture of dnc_allocation_weighting is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    INPUT_FIRST_STATE,                  -- STEP 1
    VECTOR_FIRST_SORT_STATE,            -- STEP 2
    VECTOR_ADDER_STATE,                 -- STEP 3
    INPUT_SECOND_STATE,                 -- STEP 4
    VECTOR_SECOND_SORT_STATE,           -- STEP 5
    VECTOR_MULTIPLICATION_STATE,        -- STEP 6
    VECTOR_MULTIPLIER_STATE             -- STEP 7
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO_CONTROL  : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, CONTROL_SIZE));
  constant ONE_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, CONTROL_SIZE));
  constant TWO_CONTROL   : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, CONTROL_SIZE));
  constant THREE_CONTROL : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, CONTROL_SIZE));

  constant ZERO_DATA  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant TWO_DATA   : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(2, DATA_SIZE));
  constant THREE_DATA : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(3, DATA_SIZE));

  constant FULL  : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');
  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant EULER : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Control Internal
  signal index_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  signal data_a_in_enable_vector_adder : std_logic;
  signal data_b_in_enable_vector_adder : std_logic;

  signal data_out_enable_vector_adder : std_logic;

  -- DATA
  signal size_in_vector_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_multiplier : std_logic;
  signal ready_vector_multiplier : std_logic;

  signal data_a_in_enable_vector_multiplier : std_logic;
  signal data_b_in_enable_vector_multiplier : std_logic;

  signal data_out_enable_vector_multiplier : std_logic;

  -- DATA
  signal size_in_vector_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLICATION
  -- CONTROL
  signal start_vector_multiplication : std_logic;
  signal ready_vector_multiplication : std_logic;

  signal data_in_vector_enable_vector_multiplication : std_logic;
  signal data_in_scalar_enable_vector_multiplication : std_logic;

  signal data_out_vector_enable_vector_multiplication : std_logic;
  signal data_out_scalar_enable_vector_multiplication : std_logic;

  -- DATA
  signal length_in_vector_multiplication : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_in_vector_multiplication   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SORT VECTOR
  -- CONTROL
  signal start_vector_sort : std_logic;
  signal ready_vector_sort : std_logic;

  signal u_in_enable_vector_sort : std_logic;

  signal u_out_enable_vector_sort : std_logic;

  signal phi_out_enable_vector_sort : std_logic;

  -- DATA
  signal size_n_in_vector_sort : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_vector_sort    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal phi_out_vector_sort : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      A_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_loop <= ZERO_CONTROL;

          if (START = '1') then
            -- Control Internal
            start_vector_sort <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_FIRST_STATE;
          end if;

        when INPUT_FIRST_STATE =>       -- STEP 1

        when VECTOR_FIRST_SORT_STATE =>  -- STEP 2

          -- Data Inputs
          size_n_in_vector_sort <= SIZE_N_IN;
          u_in_vector_sort      <= U_IN;

          if (phi_out_enable_vector_sort = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_adder <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_ADDER_STATE;
          else
            -- Control Internal
            start_vector_sort <= '0';
          end if;

        when VECTOR_ADDER_STATE =>      -- STEP 3

          if (data_out_enable_vector_adder = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_sort <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= INPUT_SECOND_STATE;
          else
            -- Control Internal
            start_vector_adder <= '0';
          end if;

        when INPUT_SECOND_STATE =>      -- STEP 4

        when VECTOR_SECOND_SORT_STATE =>  -- STEP 5

          -- Data Inputs
          size_n_in_vector_sort <= SIZE_N_IN;
          u_in_vector_sort      <= U_IN;

          if (phi_out_enable_vector_sort = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_multiplication <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLICATION_STATE;
          else
            -- Control Internal
            start_vector_sort <= '0';
          end if;

        when VECTOR_MULTIPLICATION_STATE =>  -- STEP 6

          if (data_out_vector_enable_vector_multiplication = '1') then
            if (unsigned(index_loop) = unsigned(ZERO_CONTROL)) then
              -- Control Internal
              start_vector_multiplier <= '1';
            end if;

            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          else
            -- Control Internal
            start_vector_multiplication <= '0';
          end if;

        when VECTOR_MULTIPLIER_STATE =>  -- STEP 7

          if (data_out_enable_vector_multiplier = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_N_IN) - unsigned(ONE_CONTROL)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE_CONTROL));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_FIRST_SORT_STATE;
            end if;

            -- Data Outputs
            A_OUT <= data_out_vector_multiplier;

            -- Control Outputs
            A_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            A_OUT_ENABLE <= '0';

            -- Control Internal
            start_vector_multiplier <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- DATA
  -- VECTOR ADDER
  size_in_vector_adder   <= SIZE_N_IN;
  data_a_in_vector_adder <= ONE_DATA;
  data_b_in_vector_adder <= phi_out_vector_sort;

  -- VECTOR MULTIPLICATION
  length_in_vector_multiplication <= SIZE_N_IN;
  size_in_vector_multiplication   <= SIZE_N_IN;
  data_in_vector_multiplication   <= phi_out_vector_sort;

  -- VECTOR MULTIPLIER
  size_in_vector_multiplier   <= SIZE_N_IN;
  data_a_in_vector_multiplier <= data_out_vector_adder;
  data_b_in_vector_multiplier <= data_out_vector_multiplication;

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_adder,

      -- DATA
      SIZE_IN   => size_in_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
      );

  -- VECTOR MULTIPLIER
  vector_multiplier : ntm_vector_multiplier
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplier,
      READY => ready_vector_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_multiplier,

      -- DATA
      SIZE_IN   => size_in_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
      );

  -- VECTOR MULTIPLICATION
  vector_multiplication_function : ntm_vector_multiplication_function
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplication,
      READY => ready_vector_multiplication,

      DATA_IN_VECTOR_ENABLE => data_in_vector_enable_vector_multiplication,
      DATA_IN_SCALAR_ENABLE => data_in_scalar_enable_vector_multiplication,

      DATA_OUT_VECTOR_ENABLE => data_out_vector_enable_vector_multiplication,
      DATA_OUT_SCALAR_ENABLE => data_out_scalar_enable_vector_multiplication,

      -- DATA
      SIZE_IN   => size_in_vector_multiplication,
      LENGTH_IN => length_in_vector_multiplication,
      DATA_IN   => data_in_vector_multiplication,
      DATA_OUT  => data_out_vector_multiplication
      );

  -- VECTOR SORT
  sort_vector : dnc_sort_vector
    generic map (
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_sort,
      READY => ready_vector_sort,

      U_IN_ENABLE => u_in_enable_vector_sort,

      U_OUT_ENABLE => u_out_enable_vector_sort,

      PHI_OUT_ENABLE => phi_out_enable_vector_sort,

      -- DATA
      SIZE_N_IN => size_n_in_vector_sort,

      U_IN => u_in_vector_sort,

      PHI_OUT => phi_out_vector_sort
      );

end architecture;
