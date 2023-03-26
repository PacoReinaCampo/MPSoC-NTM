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
-- out the Software without restriction, including without limitation the rights
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

use work.model_math_pkg.all;
use work.model_memory_pkg.all;

entity model_memory_stimulus is
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

    -- FORWARD WEIGHTING
    -- CONTROL
    DNC_MEMORY_FORWARD_WEIGHTING_START : out std_logic;
    DNC_MEMORY_FORWARD_WEIGHTING_READY : in  std_logic;

    DNC_MEMORY_FORWARD_WEIGHTING_L_IN_G_ENABLE : out std_logic;
    DNC_MEMORY_FORWARD_WEIGHTING_L_IN_J_ENABLE : out std_logic;

    DNC_MEMORY_FORWARD_WEIGHTING_L_OUT_G_ENABLE : in std_logic;
    DNC_MEMORY_FORWARD_WEIGHTING_L_OUT_J_ENABLE : in std_logic;

    DNC_MEMORY_FORWARD_WEIGHTING_W_IN_I_ENABLE : out std_logic;
    DNC_MEMORY_FORWARD_WEIGHTING_W_IN_J_ENABLE : out std_logic;

    DNC_MEMORY_FORWARD_WEIGHTING_W_OUT_I_ENABLE : in std_logic;
    DNC_MEMORY_FORWARD_WEIGHTING_W_OUT_J_ENABLE : in std_logic;

    DNC_MEMORY_FORWARD_WEIGHTING_F_OUT_I_ENABLE : in std_logic;
    DNC_MEMORY_FORWARD_WEIGHTING_F_OUT_J_ENABLE : in std_logic;

    -- DATA
    DNC_MEMORY_FORWARD_WEIGHTING_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    DNC_MEMORY_FORWARD_WEIGHTING_SIZE_N_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_MEMORY_FORWARD_WEIGHTING_L_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_MEMORY_FORWARD_WEIGHTING_W_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_MEMORY_FORWARD_WEIGHTING_F_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- SORT VECTOR
    -- CONTROL
    DNC_MEMORY_SORT_VECTOR_START : out std_logic;
    DNC_MEMORY_SORT_VECTOR_READY : in  std_logic;

    DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE : out std_logic;  -- for j in 0 to N-1

    DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE : in std_logic;  -- for j in 0 to N-1

    DNC_MEMORY_SORT_VECTOR_PHI_OUT_ENABLE : in std_logic;  -- for j in 0 to N-1

    -- DATA
    DNC_MEMORY_SORT_VECTOR_SIZE_N_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_MEMORY_SORT_VECTOR_U_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_MEMORY_SORT_VECTOR_PHI_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- ADDRESSING
    -- CONTROL
    DNC_MEMORY_START : out std_logic;
    DNC_MEMORY_READY : in  std_logic;

    DNC_MEMORY_K_READ_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1
    DNC_MEMORY_K_READ_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

    DNC_MEMORY_K_READ_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
    DNC_MEMORY_K_READ_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    DNC_MEMORY_BETA_READ_IN_ENABLE : out std_logic;  -- for i out 0 to R-1

    DNC_MEMORY_BETA_READ_OUT_ENABLE : in std_logic;  -- for i out 0 to R-1

    DNC_MEMORY_F_READ_IN_ENABLE : out std_logic;  -- for i out 0 to R-1

    DNC_MEMORY_F_READ_OUT_ENABLE : in std_logic;  -- for i out 0 to R-1

    DNC_MEMORY_PI_READ_IN_I_ENABLE : out std_logic;  -- for i out 0 to R-1
    DNC_MEMORY_PI_READ_IN_P_ENABLE : out std_logic;  -- for i out 0 to 2

    DNC_MEMORY_PI_READ_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
    DNC_MEMORY_PI_READ_OUT_P_ENABLE : in std_logic;  -- for i out 0 to 2

    DNC_MEMORY_K_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1
    DNC_MEMORY_E_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1
    DNC_MEMORY_V_WRITE_IN_K_ENABLE : out std_logic;  -- for k out 0 to W-1

    DNC_MEMORY_K_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1
    DNC_MEMORY_E_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1
    DNC_MEMORY_V_WRITE_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    DNC_MEMORY_R_OUT_I_ENABLE : in std_logic;  -- for i out 0 to R-1
    DNC_MEMORY_R_OUT_K_ENABLE : in std_logic;  -- for k out 0 to W-1

    -- DATA
    DNC_MEMORY_SIZE_R_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    DNC_MEMORY_SIZE_N_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
    DNC_MEMORY_SIZE_W_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);

    DNC_MEMORY_K_READ_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_BETA_READ_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_F_READ_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_PI_READ_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_MEMORY_K_WRITE_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_BETA_WRITE_IN : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_E_WRITE_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_V_WRITE_IN    : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_GA_WRITE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);
    DNC_MEMORY_GW_WRITE_IN   : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_MEMORY_R_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture model_memory_stimulus_architecture of model_memory_stimulus is

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

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

  -- FUNCTIONALITY
  DNC_MEMORY_SORT_VECTOR_START <= start_int;

  ------------------------------------------------------------------------------
  -- STIMULUS
  ------------------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_DNC_MEMORY_SORT_VECTOR_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_DNC_MEMORY_SORT_VECTOR_TEST    ";
      -------------------------------------------------------------------

      -- DATA
      DNC_MEMORY_SORT_VECTOR_SIZE_N_IN <= THREE_CONTROL;

      if (STIMULUS_DNC_MEMORY_SORT_VECTOR_CASE_0) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_MEMORY_SORT_VECTOR_CASE 0  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_MEMORY_SORT_VECTOR_U_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        SORT_VECTOR_FIRST_RUN : loop
          if (DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_MEMORY_SORT_VECTOR_SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE <= '1';

            -- DATA
            DNC_MEMORY_SORT_VECTOR_U_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE = '1' or DNC_MEMORY_SORT_VECTOR_START = '1') and (unsigned(index_i_loop) < unsigned(DNC_MEMORY_SORT_VECTOR_SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE <= '1';

            -- DATA
            DNC_MEMORY_SORT_VECTOR_U_IN <= VECTOR_SAMPLE_A(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit SORT_VECTOR_FIRST_RUN when DNC_MEMORY_SORT_VECTOR_READY = '1';
        end loop SORT_VECTOR_FIRST_RUN;
      end if;

      if (STIMULUS_DNC_MEMORY_SORT_VECTOR_CASE_1) then

        -------------------------------------------------------------------
        MONITOR_CASE <= "STIMULUS_DNC_MEMORY_SORT_VECTOR_CASE 1  ";
        -------------------------------------------------------------------

        -- INITIAL CONDITIONS
        -- DATA
        DNC_MEMORY_SORT_VECTOR_U_IN <= ZERO_DATA;

        -- LOOP
        index_i_loop <= ZERO_CONTROL;

        SORT_VECTOR_SECOND_RUN : loop
          if (DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE = '1' and (unsigned(index_i_loop) = unsigned(DNC_MEMORY_SORT_VECTOR_SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE <= '1';

            -- DATA
            DNC_MEMORY_SORT_VECTOR_U_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= ZERO_CONTROL;
          elsif ((DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE = '1' or DNC_MEMORY_SORT_VECTOR_START = '1') and (unsigned(index_i_loop) < unsigned(DNC_MEMORY_SORT_VECTOR_SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- CONTROL
            DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE <= '1';

            -- DATA
            DNC_MEMORY_SORT_VECTOR_U_IN <= VECTOR_SAMPLE_B(to_integer(unsigned(index_i_loop)));

            -- LOOP
            index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE_CONTROL));
          else
            -- CONTROL
            DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE <= '0';
          end if;

          -- GLOBAL
          wait until rising_edge(clk_int);

          -- CONTROL
          exit SORT_VECTOR_SECOND_RUN when DNC_MEMORY_SORT_VECTOR_READY = '1';
        end loop SORT_VECTOR_SECOND_RUN;
      end if;

      wait for WORKING;

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
