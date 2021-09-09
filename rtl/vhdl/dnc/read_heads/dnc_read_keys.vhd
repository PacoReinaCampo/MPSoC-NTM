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

entity dnc_read_keys is
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

    K_IN_I_ENABLE : in std_logic;       -- for i in 0 to R-1
    K_IN_K_ENABLE : in std_logic;       -- for k in 0 to W-1

    K_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1
    K_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_read_keys_architecture of dnc_read_keys is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type read_keys_ctrl_fsm is (
    STARTER_STATE,                      -- STEP 0
    ENDER_STATE                         -- STEP 1
    );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));
  constant ONE  : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(1, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal read_keys_ctrl_fsm_int : read_keys_ctrl_fsm;

  -- Internal Signals
  signal index_i_loop : std_logic_vector(DATA_SIZE-1 downto 0);
  signal index_j_loop : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- k(t;i;k) = k^(t;i;k)

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      K_OUT <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      index_i_loop <= ZERO;
      index_j_loop <= ZERO;

    elsif (rising_edge(CLK)) then

      case read_keys_ctrl_fsm_int is
        when STARTER_STATE =>           -- STEP 0
          -- Control Outputs
          READY <= '0';

          -- Assignations
          index_i_loop <= ZERO;
          index_j_loop <= ZERO;

          if (START = '1') then
            -- FSM Control
            read_keys_ctrl_fsm_int <= ENDER_STATE;
          end if;

        when ENDER_STATE =>             -- STEP 1

          if (K_IN_I_ENABLE = '1') then
            -- Control Internal
            if (index_i_loop < SIZE_R_IN and index_j_loop = SIZE_W_IN) then
              index_i_loop <= std_logic_vector(unsigned(index_i_loop) + unsigned(ONE));
              index_j_loop <= ZERO;
            end if;

            -- Control Outputs
            K_OUT_I_ENABLE <= '1';
            K_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            K_OUT_I_ENABLE <= '0';
            K_OUT_K_ENABLE <= '0';
          end if;

          if (K_IN_K_ENABLE = '1') then
            if (index_i_loop = SIZE_R_IN and index_j_loop = SIZE_W_IN) then
              -- Control Outputs
              READY <= '1';

              -- FSM Control
              read_keys_ctrl_fsm_int <= STARTER_STATE;
            elsif (index_i_loop < SIZE_R_IN and index_j_loop < SIZE_W_IN) then
              -- Control Internal
              index_j_loop <= std_logic_vector(unsigned(index_j_loop) + unsigned(ONE));
            end if;

            -- Control Outputs
            K_OUT_K_ENABLE <= '1';
          else
            -- Control Outputs
            K_OUT_K_ENABLE <= '0';
          end if;

          -- Data Outputs
          K_OUT <= K_IN;

        when others =>
          -- FSM Control
          read_keys_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

end architecture;
