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
use work.ntm_algebra_pkg.all;

entity ntm_algebra_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 128;
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

    -- DOT PRODUCT
    -- CONTROL
    DOT_PRODUCT_START : out std_logic;
    DOT_PRODUCT_READY : in  std_logic;

    DOT_PRODUCT_DATA_A_IN_ENABLE : out std_logic;
    DOT_PRODUCT_DATA_B_IN_ENABLE : out std_logic;

    DOT_PRODUCT_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    DOT_PRODUCT_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    DOT_PRODUCT_DATA_A_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DOT_PRODUCT_DATA_B_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DOT_PRODUCT_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- VECTOR TRANSPOSE
    -- CONTROL
    VECTOR_TRANSPOSE_START : out std_logic;
    VECTOR_TRANSPOSE_READY : in  std_logic;

    VECTOR_TRANSPOSE_DATA_IN_ENABLE : out std_logic;

    VECTOR_TRANSPOSE_DATA_ENABLE : in std_logic;

    VECTOR_TRANSPOSE_DATA_OUT_ENABLE : in std_logic;

    -- DATA
    VECTOR_TRANSPOSE_LENGTH_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    VECTOR_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    VECTOR_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX PRODUCT
    -- CONTROL
    MATRIX_PRODUCT_START : out std_logic;
    MATRIX_PRODUCT_READY : in  std_logic;

    MATRIX_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    MATRIX_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;

    MATRIX_PRODUCT_DATA_I_ENABLE : in std_logic;
    MATRIX_PRODUCT_DATA_J_ENABLE : in std_logic;

    MATRIX_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- MATRIX TRANSPOSE
    -- CONTROL
    MATRIX_TRANSPOSE_START : out std_logic;
    MATRIX_TRANSPOSE_READY : in  std_logic;

    MATRIX_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
    MATRIX_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;

    MATRIX_TRANSPOSE_DATA_I_ENABLE : in std_logic;
    MATRIX_TRANSPOSE_DATA_J_ENABLE : in std_logic;

    MATRIX_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
    MATRIX_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;

    -- DATA
    MATRIX_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    MATRIX_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR PRODUCT
    -- CONTROL
    TENSOR_PRODUCT_START : out std_logic;
    TENSOR_PRODUCT_READY : in  std_logic;

    TENSOR_PRODUCT_DATA_A_IN_I_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_A_IN_J_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_A_IN_K_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_I_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_J_ENABLE : out std_logic;
    TENSOR_PRODUCT_DATA_B_IN_K_ENABLE : out std_logic;

    TENSOR_PRODUCT_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_PRODUCT_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_PRODUCT_SIZE_A_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_A_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_SIZE_B_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_A_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_B_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_PRODUCT_DATA_OUT    : in  std_logic_vector(DATA_SIZE-1 downto 0);

    -- TENSOR TRANSPOSE
    -- CONTROL
    TENSOR_TRANSPOSE_START : out std_logic;
    TENSOR_TRANSPOSE_READY : in  std_logic;

    TENSOR_TRANSPOSE_DATA_IN_I_ENABLE : out std_logic;
    TENSOR_TRANSPOSE_DATA_IN_J_ENABLE : out std_logic;
    TENSOR_TRANSPOSE_DATA_IN_K_ENABLE : out std_logic;

    TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE : in std_logic;
    TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE : in std_logic;
    TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE : in std_logic;

    -- DATA
    TENSOR_TRANSPOSE_SIZE_I_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_SIZE_J_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_SIZE_K_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_DATA_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    TENSOR_TRANSPOSE_DATA_OUT  : in  std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture ntm_algebra_stimulus_architecture of ntm_algebra_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

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

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

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

  -- VECTOR-FUNCTIONALITY
  DOT_PRODUCT_START      <= start_int;
  VECTOR_TRANSPOSE_START <= start_int;

  -- MATRIX-FUNCTIONALITY
  MATRIX_PRODUCT_START   <= start_int;
  MATRIX_TRANSPOSE_START <= start_int;

  -- TENSOR-FUNCTIONALITY
  TENSOR_PRODUCT_START   <= start_int;
  TENSOR_TRANSPOSE_START <= start_int;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_NTM_DOT_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_DOT_PRODUCT_TEST           ";
      -------------------------------------------------------------------

      -- DATA
      DOT_PRODUCT_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_DOT_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_DOT_PRODUCT_CASE 0         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DOT_PRODUCT_DATA_A_IN <= ZERO_DATA;
        DOT_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        DOT_PRODUCT_FIRST_RUN : loop
          if (DOT_PRODUCT_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DOT_PRODUCT_DATA_OUT_ENABLE = '1' or DOT_PRODUCT_START = '1') and (unsigned(index_i_loop) < unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '0';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit DOT_PRODUCT_FIRST_RUN when DOT_PRODUCT_READY = '1';
        end loop DOT_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_DOT_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_DOT_PRODUCT_CASE 1         ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DOT_PRODUCT_DATA_A_IN <= ZERO_DATA;
        DOT_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        DOT_PRODUCT_SECOND_RUN : loop
          if (DOT_PRODUCT_DATA_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DOT_PRODUCT_DATA_OUT_ENABLE = '1' or DOT_PRODUCT_START = '1') and (unsigned(index_i_loop) < unsigned(DOT_PRODUCT_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '1';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '1';

            -- DATA
            DOT_PRODUCT_DATA_A_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));
            DOT_PRODUCT_DATA_B_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DOT_PRODUCT_DATA_A_IN_ENABLE <= '0';
            DOT_PRODUCT_DATA_B_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit DOT_PRODUCT_SECOND_RUN when DOT_PRODUCT_READY = '1';
        end loop DOT_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_VECTOR_TRANSPOSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_VECTOR_TRANSPOSE_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      VECTOR_TRANSPOSE_LENGTH_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_VECTOR_TRANSPOSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_TRANSPOSE_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_TRANSPOSE_FIRST_RUN : loop
          if (VECTOR_TRANSPOSE_DATA_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(VECTOR_TRANSPOSE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TRANSPOSE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TRANSPOSE_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((VECTOR_TRANSPOSE_DATA_ENABLE = '1' or VECTOR_TRANSPOSE_START = '1') and (unsigned(index_i_loop) < unsigned(VECTOR_TRANSPOSE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TRANSPOSE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TRANSPOSE_DATA_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_TRANSPOSE_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_TRANSPOSE_FIRST_RUN when VECTOR_TRANSPOSE_READY = '1';
        end loop VECTOR_TRANSPOSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_VECTOR_TRANSPOSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_VECTOR_TRANSPOSE_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        VECTOR_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        VECTOR_TRANSPOSE_SECOND_RUN : loop
          if ((VECTOR_TRANSPOSE_DATA_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(VECTOR_TRANSPOSE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TRANSPOSE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TRANSPOSE_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif (((VECTOR_TRANSPOSE_DATA_ENABLE = '1') or (VECTOR_TRANSPOSE_START = '1')) and (unsigned(index_i_loop) < unsigned(VECTOR_TRANSPOSE_LENGTH_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            VECTOR_TRANSPOSE_DATA_IN_ENABLE <= '1';

            -- DATA
            VECTOR_TRANSPOSE_DATA_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            VECTOR_TRANSPOSE_DATA_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit VECTOR_TRANSPOSE_SECOND_RUN when VECTOR_TRANSPOSE_READY = '1';
        end loop VECTOR_TRANSPOSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_PRODUCT_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_PRODUCT_SIZE_A_I_IN <= THREE_CONTROL;
      MATRIX_PRODUCT_SIZE_A_J_IN <= THREE_CONTROL;
      MATRIX_PRODUCT_SIZE_B_I_IN <= THREE_CONTROL;
      MATRIX_PRODUCT_SIZE_B_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_PRODUCT_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_PRODUCT_DATA_A_IN <= ZERO_DATA;
        MATRIX_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_PRODUCT_FIRST_RUN : loop
          if ((MATRIX_PRODUCT_DATA_I_ENABLE = '1') and (MATRIX_PRODUCT_DATA_J_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_PRODUCT_DATA_I_ENABLE = '1') and (MATRIX_PRODUCT_DATA_J_ENABLE = '1') and (unsigned(index_i_loop) < unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_PRODUCT_DATA_J_ENABLE = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_PRODUCT_FIRST_RUN when MATRIX_PRODUCT_READY = '1';
        end loop MATRIX_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_PRODUCT_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_PRODUCT_DATA_A_IN <= ZERO_DATA;
        MATRIX_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_PRODUCT_SECOND_RUN : loop
          if ((MATRIX_PRODUCT_DATA_I_ENABLE = '1') and (MATRIX_PRODUCT_DATA_J_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_PRODUCT_DATA_I_ENABLE = '1') and (MATRIX_PRODUCT_DATA_J_ENABLE = '1') and (unsigned(index_i_loop) < unsigned(MATRIX_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_PRODUCT_DATA_J_ENABLE = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_PRODUCT_SIZE_B_J_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '1';

            -- DATA
            MATRIX_PRODUCT_DATA_A_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));
            MATRIX_PRODUCT_DATA_B_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            MATRIX_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            MATRIX_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_PRODUCT_SECOND_RUN when MATRIX_PRODUCT_READY = '1';
        end loop MATRIX_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_MATRIX_TRANSPOSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_MATRIX_TRANSPOSE_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      MATRIX_TRANSPOSE_SIZE_I_IN <= THREE_CONTROL;
      MATRIX_TRANSPOSE_SIZE_J_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_TRANSPOSE_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_TRANSPOSE_FIRST_RUN : loop

          if (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_A(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' or MATRIX_TRANSPOSE_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TRANSPOSE_FIRST_RUN when MATRIX_TRANSPOSE_READY = '1';
        end loop MATRIX_TRANSPOSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_MATRIX_TRANSPOSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_MATRIX_TRANSPOSE_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        MATRIX_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;

        MATRIX_TRANSPOSE_SECOND_RUN : loop
          if (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_i_loop) = unsigned(ZERO_CONTROL) and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_I_ENABLE = '1' and MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) = unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and unsigned(index_j_loop) > unsigned(ZERO_CONTROL)) then
            -- DATA
            MATRIX_TRANSPOSE_DATA_IN <= MATRIX_SAMPLE_B(to_integer(unsigned(index_i_loop)),to_integer(unsigned(index_j_loop)));

            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
          else
            -- CONTROL
            MATRIX_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            MATRIX_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
          end if;

          -- LOOP
          if (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
          elsif (MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' and (unsigned(index_i_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
          elsif ((MATRIX_TRANSPOSE_DATA_J_ENABLE = '1' or MATRIX_TRANSPOSE_START = '1') and (unsigned(index_j_loop) < unsigned(MATRIX_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL))) then
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit MATRIX_TRANSPOSE_SECOND_RUN when MATRIX_TRANSPOSE_READY = '1';
        end loop MATRIX_TRANSPOSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_PRODUCT_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_PRODUCT_TEST        ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_PRODUCT_SIZE_A_I_IN <= THREE_CONTROL;
      TENSOR_PRODUCT_SIZE_A_J_IN <= THREE_CONTROL;
      TENSOR_PRODUCT_SIZE_A_K_IN <= THREE_CONTROL;
      TENSOR_PRODUCT_SIZE_B_I_IN <= THREE_CONTROL;
      TENSOR_PRODUCT_SIZE_B_J_IN <= THREE_CONTROL;
      TENSOR_PRODUCT_SIZE_B_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_PRODUCT_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_PRODUCT_CASE 0      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_PRODUCT_DATA_A_IN <= ZERO_DATA;
        TENSOR_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_PRODUCT_FIRST_RUN : loop
          if ((TENSOR_PRODUCT_DATA_OUT_I_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_OUT_I_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_j_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_PRODUCT_FIRST_RUN when TENSOR_PRODUCT_READY = '1';
        end loop TENSOR_PRODUCT_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_PRODUCT_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_PRODUCT_CASE 1      ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_PRODUCT_DATA_A_IN <= ZERO_DATA;
        TENSOR_PRODUCT_DATA_B_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_PRODUCT_SECOND_RUN : loop
          if ((TENSOR_PRODUCT_DATA_OUT_I_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= ONE_DATA;

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_OUT_I_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_OUT_J_ENABLE = '1') and (TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_j_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_PRODUCT_DATA_OUT_K_ENABLE = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_PRODUCT_SIZE_A_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '1';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_PRODUCT_DATA_A_IN <= TWO_DATA;
            TENSOR_PRODUCT_DATA_B_IN <= TWO_DATA;

            -- LOOP
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            TENSOR_PRODUCT_DATA_A_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_A_IN_K_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_I_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_J_ENABLE <= '0';
            TENSOR_PRODUCT_DATA_B_IN_K_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_PRODUCT_SECOND_RUN when TENSOR_PRODUCT_READY = '1';
        end loop TENSOR_PRODUCT_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    if (STIMULUS_NTM_TENSOR_TRANSPOSE_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_NTM_TENSOR_TRANSPOSE_TEST      ";
      -------------------------------------------------------------------

      -- DATA
      TENSOR_TRANSPOSE_SIZE_I_IN <= THREE_CONTROL;
      TENSOR_TRANSPOSE_SIZE_J_IN <= THREE_CONTROL;
      TENSOR_TRANSPOSE_SIZE_K_IN <= THREE_CONTROL;

      if (STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_TRANSPOSE_CASE 0    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_TRANSPOSE_FIRST_RUN : loop
          if ((TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_j_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_TRANSPOSE_FIRST_RUN when TENSOR_TRANSPOSE_READY = '1';
        end loop TENSOR_TRANSPOSE_FIRST_RUN;
      end if;

      if (STIMULUS_NTM_TENSOR_TRANSPOSE_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_NTM_TENSOR_TRANSPOSE_CASE 1    ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        TENSOR_TRANSPOSE_DATA_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;
        index_j_loop <= ZERO_CONTROL;
        index_k_loop <= ZERO_CONTROL;

        TENSOR_TRANSPOSE_SECOND_RUN : loop
          if ((TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_OUT_I_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_i_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_I_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_j_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
            index_j_loop <= ZERO_CONTROL;
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_OUT_J_ENABLE = '1') and (TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_j_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_J_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_loop) = unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '1';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE_CONTROL));
            index_k_loop <= ZERO_CONTROL;
          elsif ((TENSOR_TRANSPOSE_DATA_OUT_K_ENABLE = '1') and (unsigned(index_k_loop) < unsigned(TENSOR_TRANSPOSE_SIZE_K_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '1';

            -- DATA
            TENSOR_TRANSPOSE_DATA_IN <= TWO_DATA;

            -- LOOP
            index_k_loop <= std_logic_vector(unsigned(index_k_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            TENSOR_TRANSPOSE_DATA_IN_I_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_J_ENABLE <= '0';
            TENSOR_TRANSPOSE_DATA_IN_K_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit TENSOR_TRANSPOSE_SECOND_RUN when TENSOR_TRANSPOSE_READY = '1';
        end loop TENSOR_TRANSPOSE_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;


    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
