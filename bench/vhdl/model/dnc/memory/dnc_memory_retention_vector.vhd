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

entity dnc_memory_retention_vector is
  generic (
    DATA_SIZE : integer := 512
    );
  port (
    -- GLOBAL
    CLK : in std_logic;
    RST : in std_logic;

    -- CONTROL
    START : in  std_logic;
    READY : out std_logic;

    F_IN_ENABLE : in std_logic;         -- for i in 0 to R-1

    W_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    W_IN_J_ENABLE : in std_logic;       -- for j in 0 to N-1

    PSI_OUT_ENABLE : out std_logic;     -- for j in 0 to N-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    F_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    PSI_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_memory_retention_vector_architecture of dnc_memory_retention_vector is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    VECTOR_MULTIPLIER_STATE,            -- STEP 1
    VECTOR_ADDER_STATE,                 -- STEP 2
    VECTOR_MULTIPLICATION_STATE         -- STEP 3
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));
  constant FULL : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '1');

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_ctrl_fsm_int : controller_ctrl_fsm;

  -- Internal Signals
  signal index_loop : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLICATION
  -- CONTROL
  signal start_vector_multiplication : std_logic;
  signal ready_vector_multiplication : std_logic;

  signal data_in_vector_enable_vector_multiplication : std_logic;
  signal data_in_scalar_enable_vector_multiplication : std_logic;

  signal data_out_vector_enable_vector_multiplication : std_logic;
  signal data_out_scalar_enable_vector_multiplication : std_logic;

  -- DATA
  signal modulo_in_vector_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal length_in_vector_multiplication : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_multiplication   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplication  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  signal data_a_in_enable_vector_adder : std_logic;
  signal data_b_in_enable_vector_adder : std_logic;

  signal data_out_enable_vector_adder : std_logic;

  -- DATA
  signal modulo_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_adder   : std_logic_vector(DATA_SIZE-1 downto 0);
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
  signal modulo_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_multiplier   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      PSI_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Control Internal
      index_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Control Internal
          index_loop <= ZERO;

          if (START = '1') then
            -- FSM Control
            controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
          end if;

        when VECTOR_MULTIPLIER_STATE =>  -- STEP 1

        when VECTOR_ADDER_STATE =>  -- STEP 2

        when VECTOR_MULTIPLICATION_STATE =>  -- STEP 3

          if (data_out_enable_vector_multiplier = '1') then
            if (unsigned(index_loop) = unsigned(SIZE_N_IN) - unsigned(ONE)) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              controller_ctrl_fsm_int <= STARTER_STATE;
            else
              -- Control Internal
              index_loop <= std_logic_vector(unsigned(index_loop) + unsigned(ONE));

              -- FSM Control
              controller_ctrl_fsm_int <= VECTOR_MULTIPLIER_STATE;
            end if;

            -- Data Outputs
            PSI_OUT <= data_out_vector_multiplication;

            -- Control Outputs
            PSI_OUT_ENABLE <= '1';
          else
            -- Control Outputs
            PSI_OUT_ENABLE <= '0';
          end if;

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- DATA
  -- VECTOR MULTIPLIER
  modulo_in_vector_multiplier <= FULL;
  size_in_vector_multiplier   <= SIZE_N_IN;
  data_a_in_vector_multiplier <= F_IN;
  data_b_in_vector_multiplier <= W_IN;

  -- VECTOR ADDER
  modulo_in_vector_adder <= FULL;
  size_in_vector_adder   <= SIZE_N_IN;
  data_a_in_vector_adder <= ONE;
  data_b_in_vector_adder <= data_out_vector_multiplication;

  -- VECTOR MULTIPLICATION
  modulo_in_vector_multiplication <= FULL;
  length_in_vector_multiplication <= SIZE_N_IN;
  size_in_vector_multiplication   <= SIZE_R_IN;
  data_in_vector_multiplication   <= data_out_vector_multiplier;

  -- VECTOR MULTIPLICATION
  vector_multiplication_function : ntm_vector_multiplication_function
    generic map (
      DATA_SIZE => DATA_SIZE
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
      MODULO_IN => modulo_in_vector_multiplication,
      SIZE_IN   => size_in_vector_multiplication,
      LENGTH_IN => length_in_vector_multiplication,
      DATA_IN   => data_in_vector_multiplication,
      DATA_OUT  => data_out_vector_multiplication
      );

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE => DATA_SIZE
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
      MODULO_IN => modulo_in_vector_adder,
      SIZE_IN   => size_in_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
      );

  -- VECTOR MULTIPLIER
  vector_multiplier : ntm_vector_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
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
      MODULO_IN => modulo_in_vector_multiplier,
      SIZE_IN   => size_in_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
      );

end architecture;
