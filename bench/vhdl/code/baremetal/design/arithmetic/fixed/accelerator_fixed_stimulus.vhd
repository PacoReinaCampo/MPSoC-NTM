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

use work.accelerator_arithmetic_pkg.all;
use work.accelerator_fixed_pkg.all;

entity accelerator_fixed_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))  -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS SCALAR FIXED
    ------------------------------------------------------------------------------

    -- SCALAR FIXED ADDER
    -- CONTROL
    SCALAR_FIXED_ADDER_START : out std_logic;
    SCALAR_FIXED_ADDER_READY : in  std_logic;

    SCALAR_FIXED_ADDER_OPERATION : out std_logic;

    -- DATA
    SCALAR_FIXED_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_ADDER_OVERFLOW_OUT : in  std_logic;

    -- SCALAR FIXED MULTIPLIER
    -- CONTROL
    SCALAR_FIXED_MULTIPLIER_START : out std_logic;
    SCALAR_FIXED_MULTIPLIER_READY : in  std_logic;

    -- DATA
    SCALAR_FIXED_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

    -- SCALAR FIXED DIVIDER
    -- CONTROL
    SCALAR_FIXED_DIVIDER_START : out std_logic;
    SCALAR_FIXED_DIVIDER_READY : in  std_logic;

    -- DATA
    SCALAR_FIXED_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    SCALAR_FIXED_DIVIDER_OVERFLOW_OUT : in  std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS VECTOR FIXED
    ------------------------------------------------------------------------------

    -- VECTOR FIXED ADDER
    -- CONTROL
    VECTOR_FIXED_ADDER_START : out std_logic;
    VECTOR_FIXED_ADDER_READY : in  std_logic;

    VECTOR_FIXED_ADDER_OPERATION : out std_logic;

    VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_FIXED_ADDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_FIXED_ADDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_FIXED_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_ADDER_OVERFLOW_OUT : in  std_logic;

    -- VECTOR FIXED MULTIPLIER
    -- CONTROL
    VECTOR_FIXED_MULTIPLIER_START : out std_logic;
    VECTOR_FIXED_MULTIPLIER_READY : in  std_logic;

    VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_FIXED_MULTIPLIER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_FIXED_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

    -- VECTOR FIXED DIVIDER
    -- CONTROL
    VECTOR_FIXED_DIVIDER_START : out std_logic;
    VECTOR_FIXED_DIVIDER_READY : in  std_logic;

    VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE : out std_logic;
    VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE : out std_logic;

    VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_FIXED_DIVIDER_SIZE_IN      : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_FIXED_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_FIXED_DIVIDER_OVERFLOW_OUT : in  std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS MATRIX FIXED
    ------------------------------------------------------------------------------

    -- MATRIX FIXED ADDER
    -- CONTROL
    MATRIX_FIXED_ADDER_START : out std_logic;
    MATRIX_FIXED_ADDER_READY : in  std_logic;

    MATRIX_FIXED_ADDER_OPERATION : out std_logic;

    MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_FIXED_ADDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FIXED_ADDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FIXED_ADDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_ADDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_ADDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_ADDER_OVERFLOW_OUT : in  std_logic;

    -- MATRIX FIXED MULTIPLIER
    -- CONTROL
    MATRIX_FIXED_MULTIPLIER_START : out std_logic;
    MATRIX_FIXED_MULTIPLIER_READY : in  std_logic;

    MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_FIXED_MULTIPLIER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FIXED_MULTIPLIER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FIXED_MULTIPLIER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_MULTIPLIER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_MULTIPLIER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_MULTIPLIER_OVERFLOW_OUT : in  std_logic;

    -- MATRIX FIXED DIVIDER
    -- CONTROL
    MATRIX_FIXED_DIVIDER_START : out std_logic;
    MATRIX_FIXED_DIVIDER_READY : in  std_logic;

    MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_FIXED_DIVIDER_SIZE_I_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FIXED_DIVIDER_SIZE_J_IN    : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_FIXED_DIVIDER_DATA_A_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_DIVIDER_DATA_B_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_DIVIDER_DATA_OUT     : in  std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_FIXED_DIVIDER_OVERFLOW_OUT : in  std_logic;

    ------------------------------------------------------------------------------
    -- STIMULUS TENSOR
    ------------------------------------------------------------------------------

    -- TENSOR ADDER
    -- CONTROL
    TENSOR_FIXED_ADDER_START : out std_logic;
    TENSOR_FIXED_ADDER_READY : in  std_logic;

    TENSOR_FIXED_ADDER_OPERATION : out std_logic;

    TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_FIXED_ADDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_ADDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_ADDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_ADDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FIXED_ADDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_FIXED_ADDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FIXED_ADDER_OVERFLOW_OUT : in std_logic;

    -- TENSOR MULTIPLIER
    -- CONTROL
    TENSOR_FIXED_MULTIPLIER_START : out std_logic;
    TENSOR_FIXED_MULTIPLIER_READY : in  std_logic;

    TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_FIXED_MULTIPLIER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_MULTIPLIER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_MULTIPLIER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_MULTIPLIER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FIXED_MULTIPLIER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_FIXED_MULTIPLIER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FIXED_MULTIPLIER_OVERFLOW_OUT : in std_logic;

    -- TENSOR DIVIDER
    -- CONTROL
    TENSOR_FIXED_DIVIDER_START : out std_logic;
    TENSOR_FIXED_DIVIDER_READY : in  std_logic;

    TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_FIXED_DIVIDER_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_DIVIDER_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_DIVIDER_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_FIXED_DIVIDER_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FIXED_DIVIDER_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    TENSOR_FIXED_DIVIDER_DATA_OUT     : in std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_FIXED_DIVIDER_OVERFLOW_OUT : in std_logic
    );
end entity;

architecture accelerator_fixed_stimulus_architecture of accelerator_fixed_stimulus is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  constant EXPONENT_SIZE : integer := 8;
  constant MANTISSA_SIZE : integer := 23;

  constant MAX_POSITIVE : std_logic_vector(DATA_SIZE-1 downto 0) := "0111111111111111111111111111111111111111111111111111111111111111";
  constant MIN_NEGATIVE : std_logic_vector(DATA_SIZE-1 downto 0) := "1000000000000000000000000000000000000000000000000000000000000000";

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- LOOP
  signal index_i_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  CLK <= clk_int;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  RST <= rst_int;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -- SCALAR-FUNCTIONALITY
  SCALAR_FIXED_ADDER_START      <= start_int;
  SCALAR_FIXED_MULTIPLIER_START <= start_int;
  SCALAR_FIXED_DIVIDER_START    <= start_int;

  -- VECTOR-FUNCTIONALITY
  VECTOR_FIXED_ADDER_START      <= start_int;
  VECTOR_FIXED_MULTIPLIER_START <= start_int;
  VECTOR_FIXED_DIVIDER_START    <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_FIXED_ADDER_START      <= start_int;
  MATRIX_FIXED_MULTIPLIER_START <= start_int;
  MATRIX_FIXED_DIVIDER_START    <= start_int;

  -- TENSOR-FUNCTIONALITY
  TENSOR_FIXED_ADDER_START      <= start_int;
  TENSOR_FIXED_MULTIPLIER_START <= start_int;
  TENSOR_FIXED_DIVIDER_START    <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    -------------------------------------------------------------------
    -- SCALAR- FIXED
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_FIXED_ADDER_TEST    ";
      -------------------------------------------------------------------

      -- CONTROL
      SCALAR_FIXED_ADDER_OPERATION <= '0';

      if (STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FIXED_ADDER_CASE 0  ";
        -------------------------------------------------------------------

        SCALAR_FIXED_ADDER_DATA_A_IN <= SCALAR_SAMPLE_A;
        SCALAR_FIXED_ADDER_DATA_B_IN <= SCALAR_SAMPLE_B;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_FIXED_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FIXED_ADDER_CASE 1  ";
        -------------------------------------------------------------------

        SCALAR_FIXED_ADDER_DATA_A_IN <= SCALAR_SAMPLE_B;
        SCALAR_FIXED_ADDER_DATA_B_IN <= SCALAR_SAMPLE_A;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_FIXED_MULTIPLIE_TEST";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FIXED_MULTIPL_CASE 0";
        -------------------------------------------------------------------

        SCALAR_FIXED_MULTIPLIER_DATA_A_IN <= SCALAR_SAMPLE_A;
        SCALAR_FIXED_MULTIPLIER_DATA_B_IN <= SCALAR_SAMPLE_B;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_FIXED_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FIXED_MULTIPL_CASE 1";
        -------------------------------------------------------------------

        SCALAR_FIXED_MULTIPLIER_DATA_A_IN <= SCALAR_SAMPLE_B;
        SCALAR_FIXED_MULTIPLIER_DATA_B_IN <= SCALAR_SAMPLE_A;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_SCALAR_FIXED_DIVIDER_TEST  ";
      -------------------------------------------------------------------

      if (STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FIXED_DIVIDER_CASE 0";
        -------------------------------------------------------------------

        SCALAR_FIXED_DIVIDER_DATA_A_IN <= SCALAR_SAMPLE_A;
        SCALAR_FIXED_DIVIDER_DATA_B_IN <= SCALAR_SAMPLE_B;
      end if;

      if (STIMULUS_ACCELERATOR_SCALAR_FIXED_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_SCALAR_FIXED_DIVIDER_CASE 1";
        -------------------------------------------------------------------

        SCALAR_FIXED_DIVIDER_DATA_A_IN <= SCALAR_SAMPLE_B;
        SCALAR_FIXED_DIVIDER_DATA_B_IN <= SCALAR_SAMPLE_A;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- VECTOR- FIXED
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- OPERATION
      VECTOR_FIXED_ADDER_OPERATION <= '0';

      -- DATA
      VECTOR_FIXED_ADDER_SIZE_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FIXED_ADDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FIXED_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FIXED_ADDER_FIRST_RUN : loop
          if (VECTOR_FIXED_ADDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FIXED_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_ADDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_ADDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FIXED_ADDER_DATA_OUT_ENABLE = '1' or VECTOR_FIXED_ADDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FIXED_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_ADDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_ADDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FIXED_ADDER_FIRST_RUN when VECTOR_FIXED_ADDER_READY = '1';
        end loop VECTOR_FIXED_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_FIXED_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FIXED_ADDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FIXED_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FIXED_ADDER_SECOND_RUN : loop
          if (VECTOR_FIXED_ADDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FIXED_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_ADDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_ADDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FIXED_ADDER_DATA_OUT_ENABLE = '1' or VECTOR_FIXED_ADDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FIXED_ADDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_ADDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_ADDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FIXED_ADDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FIXED_ADDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FIXED_ADDER_SECOND_RUN when VECTOR_FIXED_ADDER_READY = '1';
        end loop VECTOR_FIXED_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_FIXED_MULTIPLIER_SIZE_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FIXED_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FIXED_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FIXED_MULTIPLIER_FIRST_RUN : loop
          if (VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FIXED_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE = '1' or VECTOR_FIXED_MULTIPLIER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FIXED_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FIXED_MULTIPLIER_FIRST_RUN when VECTOR_FIXED_MULTIPLIER_READY = '1';
        end loop VECTOR_FIXED_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_FIXED_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FIXED_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FIXED_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FIXED_MULTIPLIER_SECOND_RUN : loop
          if (VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FIXED_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FIXED_MULTIPLIER_DATA_OUT_ENABLE = '1' or VECTOR_FIXED_MULTIPLIER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FIXED_MULTIPLIER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FIXED_MULTIPLIER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FIXED_MULTIPLIER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FIXED_MULTIPLIER_SECOND_RUN when VECTOR_FIXED_MULTIPLIER_READY = '1';
        end loop VECTOR_FIXED_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_FIXED_DIVIDER_SIZE_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FIXED_DIVIDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FIXED_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FIXED_DIVIDER_FIRST_RUN : loop
          if (VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FIXED_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE = '1' or VECTOR_FIXED_DIVIDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FIXED_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FIXED_DIVIDER_FIRST_RUN when VECTOR_FIXED_DIVIDER_READY = '1';
        end loop VECTOR_FIXED_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_VECTOR_FIXED_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_FIXED_DIVIDER_DATA_A_IN <= ZERO_DATA;
        VECTOR_FIXED_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_FIXED_DIVIDER_SECOND_RUN : loop
          if (VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_FIXED_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_FIXED_DIVIDER_DATA_OUT_ENABLE = '1' or VECTOR_FIXED_DIVIDER_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_FIXED_DIVIDER_SIZE_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE <= '1';
            VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE <= '1';

            -- DATA
            VECTOR_FIXED_DIVIDER_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            VECTOR_FIXED_DIVIDER_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_FIXED_DIVIDER_DATA_A_IN_ENABLE <= '0';
            VECTOR_FIXED_DIVIDER_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_FIXED_DIVIDER_SECOND_RUN when VECTOR_FIXED_DIVIDER_READY = '1';
        end loop VECTOR_FIXED_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- MATRIX- FIXED
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      MATRIX_FIXED_ADDER_OPERATION <= '0';

      -- DATA
      MATRIX_FIXED_ADDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_FIXED_ADDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FIXED_ADDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FIXED_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FIXED_ADDER_FIRST_RUN : loop
          if (MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_ADDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_ADDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FIXED_ADDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FIXED_ADDER_FIRST_RUN when MATRIX_FIXED_ADDER_READY = '1';
        end loop MATRIX_FIXED_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_FIXED_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FIXED_ADDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FIXED_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FIXED_ADDER_SECOND_RUN : loop
          if (MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_ADDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_ADDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FIXED_ADDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FIXED_ADDER_SECOND_RUN when MATRIX_FIXED_ADDER_READY = '1';
        end loop MATRIX_FIXED_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_FIXED_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_FIXED_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FIXED_MULTIPLIER_FIRST_RUN : loop
          if (MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' or MATRIX_FIXED_MULTIPLIER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FIXED_MULTIPLIER_FIRST_RUN when MATRIX_FIXED_MULTIPLIER_READY = '1';
        end loop MATRIX_FIXED_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_FIXED_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FIXED_MULTIPLIER_SECOND_RUN : loop
          if (MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' or MATRIX_FIXED_MULTIPLIER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FIXED_MULTIPLIER_SECOND_RUN when MATRIX_FIXED_MULTIPLIER_READY = '1';
        end loop MATRIX_FIXED_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_FIXED_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_FIXED_DIVIDER_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FIXED_DIVIDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FIXED_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FIXED_DIVIDER_FIRST_RUN : loop
          if (MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FIXED_DIVIDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FIXED_DIVIDER_FIRST_RUN when MATRIX_FIXED_DIVIDER_READY = '1';
        end loop MATRIX_FIXED_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_MATRIX_FIXED_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_FIXED_DIVIDER_DATA_A_IN <= ZERO_DATA;
        MATRIX_FIXED_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_FIXED_DIVIDER_SECOND_RUN : loop
          if (MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          elsif (MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_FIXED_DIVIDER_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));
            MATRIX_FIXED_DIVIDER_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' or MATRIX_FIXED_DIVIDER_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_FIXED_DIVIDER_SECOND_RUN when MATRIX_FIXED_DIVIDER_READY = '1';
        end loop MATRIX_FIXED_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    -------------------------------------------------------------------
    -- TENSOR- FIXED
    -------------------------------------------------------------------

    if (STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_ADDER_TEST          ";
      -------------------------------------------------------------------

      -- CONTROL
      TENSOR_FIXED_ADDER_OPERATION <= '0';

      -- DATA
      TENSOR_FIXED_ADDER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_FIXED_ADDER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_FIXED_ADDER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_ADDER_CASE 0        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FIXED_ADDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FIXED_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FIXED_ADDER_FIRST_RUN : loop
          if (TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FIXED_ADDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FIXED_ADDER_FIRST_RUN when TENSOR_FIXED_ADDER_READY = '1';
        end loop TENSOR_FIXED_ADDER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_TENSOR_FIXED_ADDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_ADDER_CASE 1        ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FIXED_ADDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FIXED_ADDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FIXED_ADDER_SECOND_RUN : loop
          if (TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_ADDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_ADDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FIXED_ADDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FIXED_ADDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FIXED_ADDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FIXED_ADDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FIXED_ADDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FIXED_ADDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FIXED_ADDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FIXED_ADDER_SECOND_RUN when TENSOR_FIXED_ADDER_READY = '1';
        end loop TENSOR_FIXED_ADDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_MULTIPLIER_TEST     ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_FIXED_MULTIPLIER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_FIXED_MULTIPLIER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_FIXED_MULTIPLIER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_MULTIPLIER_CASE 0   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FIXED_MULTIPLIER_FIRST_RUN : loop
          if (TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' or TENSOR_FIXED_MULTIPLIER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FIXED_MULTIPLIER_FIRST_RUN when TENSOR_FIXED_MULTIPLIER_READY = '1';
        end loop TENSOR_FIXED_MULTIPLIER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_TENSOR_FIXED_MULTIPLIER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_MULTIPLIER_CASE 1   ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FIXED_MULTIPLIER_SECOND_RUN : loop
          if (TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FIXED_MULTIPLIER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FIXED_MULTIPLIER_DATA_OUT_K_ENABLE = '1' or TENSOR_FIXED_MULTIPLIER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FIXED_MULTIPLIER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FIXED_MULTIPLIER_SECOND_RUN when TENSOR_FIXED_MULTIPLIER_READY = '1';
        end loop TENSOR_FIXED_MULTIPLIER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_DIVIDER_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_FIXED_DIVIDER_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_FIXED_DIVIDER_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_FIXED_DIVIDER_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_DIVIDER_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FIXED_DIVIDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FIXED_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FIXED_DIVIDER_FIRST_RUN : loop
          if (TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FIXED_DIVIDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FIXED_DIVIDER_FIRST_RUN when TENSOR_FIXED_DIVIDER_READY = '1';
        end loop TENSOR_FIXED_DIVIDER_FIRST_RUN;
      end if;

      if (STIMULUS_ACCELERATOR_TENSOR_FIXED_DIVIDER_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_DIVIDER_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_FIXED_DIVIDER_DATA_A_IN <= ZERO_DATA;
        TENSOR_FIXED_DIVIDER_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_FIXED_DIVIDER_SECOND_RUN : loop
          if (TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_I_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL) and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_J_ENABLE = '1' and TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and unsigned(index_k_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            TENSOR_FIXED_DIVIDER_DATA_A_IN <= TENSOR_SAMPLE_B(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));
            TENSOR_FIXED_DIVIDER_DATA_B_IN <= TENSOR_SAMPLE_A(to_integer(unsigned(index_i_loop)), to_integer(unsigned(index_j_loop)), to_integer(unsigned(index_k_loop)));

            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '1';
          else
            -- CONTROL
            TENSOR_FIXED_DIVIDER_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_FIXED_DIVIDER_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- LOOP
          if (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(TENSOR_FIXED_DIVIDER_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif (TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' and (unsigned(index_j_loop) < unsigned(TENSOR_FIXED_DIVIDER_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_FIXED_DIVIDER_DATA_OUT_K_ENABLE = '1' or TENSOR_FIXED_DIVIDER_START = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_FIXED_DIVIDER_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_FIXED_DIVIDER_SECOND_RUN when TENSOR_FIXED_DIVIDER_READY = '1';
        end loop TENSOR_FIXED_DIVIDER_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
