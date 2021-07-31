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

entity ntm_point_generator is
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

    -- DATA
    PRIVATE_KEY : in std_logic_vector(DATA_SIZE-1 downto 0);

    POINT_IN_X  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    POINT_IN_Y  : in  std_logic_vector(DATA_SIZE-1 downto 0);
    POINT_OUT_X : out std_logic_vector(DATA_SIZE-1 downto 0);
    POINT_OUT_Y : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture ntm_point_generator_architecture of ntm_point_generator is

  -----------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------

  function max_word (
    DATA_INPUT : std_logic_vector(DATA_SIZE-1 downto 0)
  ) return integer is
    variable max : integer;
  begin
    for i in 0 to DATA_SIZE-1 loop
      if (DATA_INPUT(i) = '1') then
        max := i;
      end if;
    end loop;

    return max;
  end function max_word;

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type point_generator_ctrl_fsm_type is (
    STARTER_ST,    -- STEP 0
    GENERATOR_ST,  -- STEP 1
    ADDER_ST,      -- STEP 2
    DOUBLER_ST,    -- STEP 3
    ENDER_ST       -- STEP 4
  );

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant ZERO : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(0, DATA_SIZE));

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal point_generator_ctrl_fsm_st : point_generator_ctrl_fsm_type;

  -- Internal Signals
  signal point_ax_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_ay_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_bx_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_by_int : std_logic_vector(DATA_SIZE-1 downto 0);

  signal generation_cnt : integer;

  -- POINT-ADDER
  -- Control Signals
  signal start_point_adder : std_logic;
  signal ready_point_adder : std_logic;

  -- Data Signals
  signal point_in_px_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_qx_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_qy_adder_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_adder_int : std_logic_vector(DATA_SIZE-1 downto 0);

  -- POINT-DOUBLER
  -- Control Signals
  signal start_point_doubler : std_logic;
  signal ready_point_doubler : std_logic;

  -- Data Signals
  signal point_in_px_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_in_py_doubler_int  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_rx_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);
  signal point_out_ry_doubler_int : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- (x, y) = k*P Montgomery Ladder Approach

  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      POINT_OUT_X <= ZERO;
      POINT_OUT_Y <= ZERO;

      -- Control Outputs
      READY <= '0';

      -- Assignations
      point_ax_int <= ZERO;
      point_ay_int <= ZERO;
      point_bx_int <= ZERO;
      point_by_int <= ZERO;

      start_point_adder <= '0';

      point_in_px_adder_int <= ZERO;
      point_in_py_adder_int <= ZERO;
      point_in_qx_adder_int <= ZERO;
      point_in_qy_adder_int <= ZERO;
  
      start_point_doubler <= '0';
  
      point_in_px_doubler_int <= ZERO;
      point_in_py_doubler_int <= ZERO;

      generation_cnt <= 0;

    elsif (rising_edge(CLK)) then

      case point_generator_ctrl_fsm_st is
        when STARTER_ST =>  -- STEP 0

          -- Control Outputs
          READY <= '0';

          if (START = '1') then
            -- Assignations
            point_ax_int <= ZERO;
            point_ay_int <= ZERO;
            point_bx_int <= POINT_IN_X;
            point_by_int <= POINT_IN_Y;

            generation_cnt <= 0;

            -- FSM Control
            point_generator_ctrl_fsm_st <= GENERATOR_ST;
          end if;

        when GENERATOR_ST =>  -- STEP 1

          if (PRIVATE_KEY(generation_cnt) = '1') then
            -- Assignations for next state
            start_point_adder <= '1';

            point_in_px_adder_int <= point_ax_int;
            point_in_py_adder_int <= point_ay_int;
            point_in_qx_adder_int <= point_bx_int;
            point_in_qy_adder_int <= point_by_int;
          end if;

          -- FSM Control
          point_generator_ctrl_fsm_st <= ADDER_ST;

        when ADDER_ST =>  -- STEP 2

          if (PRIVATE_KEY(generation_cnt) = '1') then
            if (ready_point_adder = '1') then
              -- Assignations
              point_ax_int <= point_out_rx_adder_int;
              point_ay_int <= point_out_ry_adder_int;

              -- Assignations for next state
              start_point_doubler <= '1';

              point_in_px_doubler_int <= point_bx_int;
              point_in_py_doubler_int <= point_by_int;

              -- FSM Control
              point_generator_ctrl_fsm_st <= DOUBLER_ST;
            else
              -- Assignations for next state
              start_point_adder <= '0';
            end if;
          else
            -- Assignations for next state
            start_point_doubler <= '1';

            point_in_px_doubler_int <= point_bx_int;
            point_in_py_doubler_int <= point_by_int;

            -- FSM Control
            point_generator_ctrl_fsm_st <= DOUBLER_ST;
          end if;

        when DOUBLER_ST =>  -- STEP 3

          if (ready_point_doubler = '1') then
            -- Assignations
            point_bx_int <= point_out_rx_doubler_int;
            point_by_int <= point_out_ry_doubler_int;

            -- FSM Control
            point_generator_ctrl_fsm_st <= ENDER_ST;
          else
            -- Assignations for next state
            start_point_doubler <= '0';
          end if;

        when ENDER_ST =>  -- STEP 4

          if (generation_cnt = max_word(PRIVATE_KEY)) then
            -- Data Outputs
            POINT_OUT_X <= point_ax_int;
            POINT_OUT_Y <= point_ay_int;

            -- Control Outputs
            READY <= '1';

            -- FSM Control
            point_generator_ctrl_fsm_st <= STARTER_ST;
          else
            -- Assignations
            generation_cnt <= generation_cnt + 1;

            -- FSM Control
            point_generator_ctrl_fsm_st <= GENERATOR_ST;
          end if;

        when others =>
          -- FSM Control
          point_generator_ctrl_fsm_st <= STARTER_ST;
      end case;
    end if;
  end process;

  -----------------------------------------------------------------------
  -- Point-Adder
  -----------------------------------------------------------------------

  ntm_point_adder_i : ntm_point_adder
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_point_adder,
      READY => ready_point_adder,

      -- DATA
      POINT_IN_PX  => point_in_px_adder_int,
      POINT_IN_PY  => point_in_py_adder_int,
      POINT_IN_QX  => point_in_qx_adder_int,
      POINT_IN_QY  => point_in_qy_adder_int,
      POINT_OUT_RX => point_out_rx_adder_int,
      POINT_OUT_RY => point_out_ry_adder_int
    );

  -----------------------------------------------------------------------
  -- Point-Doubler
  -----------------------------------------------------------------------

  ntm_point_doubler_i : ntm_point_doubler
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_point_doubler,
      READY => ready_point_doubler,

      -- DATA
      POINT_IN_PX  => point_in_px_doubler_int,
      POINT_IN_PY  => point_in_py_doubler_int,
      POINT_OUT_RX => point_out_rx_doubler_int,
      POINT_OUT_RY => point_out_ry_doubler_int
    );

end architecture;
