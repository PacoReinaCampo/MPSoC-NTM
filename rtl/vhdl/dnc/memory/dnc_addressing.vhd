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

entity dnc_addressing is
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

    K_READ_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)
    K_READ_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

    K_READ_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
    K_READ_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

    BETA_READ_IN_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)

    BETA_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

    F_READ_IN_ENABLE : in std_logic;    -- for i in 0 to R-1 (read heads flow)

    F_READ_OUT_ENABLE : out std_logic;    -- for i in 0 to R-1 (read heads flow)

    PI_READ_IN_ENABLE : in std_logic;   -- for i in 0 to R-1 (read heads flow)

    PI_READ_OUT_ENABLE : out std_logic;   -- for i in 0 to R-1 (read heads flow)

    K_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
    E_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
    V_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

    K_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
    E_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
    V_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_READ_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    F_READ_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    PI_READ_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    K_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    BETA_WRITE_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
    E_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    V_WRITE_IN    : in std_logic_vector(DATA_SIZE-1 downto 0);
    GA_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);
    GW_WRITE_IN   : in std_logic_vector(DATA_SIZE-1 downto 0);

    R_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
    );
end dnc_addressing;

architecture dnc_addressing_architecture of dnc_addressing is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  type controller_ctrl_fsm is (
    STARTER_STATE,                       -- STEP 0
    PRECEDENCE_WEIGHTING_STATE,          -- STEP 1
    TEMPORAL_LINK_MATRIX_STATE,          -- STEP 2
    BACKWARD_FORWARD_WEIGHTING_STATE,    -- STEP 3
    MEMORY_RETENTION_VECTOR_STATE,       -- STEP 4
    USAGE_VECTOR_STATE,                  -- STEP 5
    ALLOCATION_WEIGHTING_STATE,          -- STEP 6
    READ_WRITE_CONTENT_WEIGHTING_STATE,  -- STEP 7
    READ_WRITE_WEIGHTING_STATE,          -- STEP 8
    MEMORY_MATRIX_STATE,                 -- STEP 9
    READ_VECTORS_STATE                   -- STEP 10
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

  -- ALLOCATION WEIGHTING
  -- CONTROL
  signal start_allocation_weighting : std_logic;
  signal ready_allocation_weighting : std_logic;

  signal u_in_enable_allocation_weighting : std_logic;

  signal u_out_enable_allocation_weighting : std_logic;

  signal a_out_enable_allocation_weighting : std_logic;

  -- DATA
  signal size_n_in_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_out_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- BACKWARD WEIGHTING
  -- CONTROL
  signal start_backward_weighting : std_logic;
  signal ready_backward_weighting : std_logic;

  signal l_in_g_enable_backward_weighting : std_logic;
  signal l_in_j_enable_backward_weighting : std_logic;

  signal l_out_g_enable_backward_weighting : std_logic;
  signal l_out_j_enable_backward_weighting : std_logic;

  signal w_in_i_enable_backward_weighting : std_logic;
  signal w_in_j_enable_backward_weighting : std_logic;

  signal w_out_i_enable_backward_weighting : std_logic;
  signal w_out_j_enable_backward_weighting : std_logic;

  signal b_out_i_enable_backward_weighting : std_logic;
  signal b_out_j_enable_backward_weighting : std_logic;

  -- DATA
  signal size_r_in_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal l_in_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_out_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FORWARD WEIGHTING
  -- CONTROL
  signal start_forward_weighting : std_logic;
  signal ready_forward_weighting : std_logic;

  signal l_in_g_enable_forward_weighting : std_logic;
  signal l_in_j_enable_forward_weighting : std_logic;

  signal l_out_g_enable_forward_weighting : std_logic;
  signal l_out_j_enable_forward_weighting : std_logic;

  signal w_in_i_enable_forward_weighting : std_logic;
  signal w_in_j_enable_forward_weighting : std_logic;

  signal w_out_i_enable_forward_weighting : std_logic;
  signal w_out_j_enable_forward_weighting : std_logic;

  signal f_out_i_enable_forward_weighting : std_logic;
  signal f_out_j_enable_forward_weighting : std_logic;

  -- DATA
  signal size_r_in_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal l_in_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_out_forward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MEMORY MATRIX
  -- CONTROL
  signal start_memory_matrix : std_logic;
  signal ready_memory_matrix : std_logic;

  signal m_in_j_enable_memory_matrix : std_logic;
  signal m_in_k_enable_memory_matrix : std_logic;

  signal w_in_j_enable_memory_matrix : std_logic;
  signal v_in_k_enable_memory_matrix : std_logic;
  signal e_in_k_enable_memory_matrix : std_logic;

  signal w_out_j_enable_memory_matrix : std_logic;
  signal v_out_k_enable_memory_matrix : std_logic;
  signal e_out_k_enable_memory_matrix : std_logic;

  signal m_out_j_enable_memory_matrix : std_logic;
  signal m_out_k_enable_memory_matrix : std_logic;

  -- DATA
  signal size_n_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_out_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MEMORY RETENTION VECTOR
  -- CONTROL
  signal start_memory_retention_vector : std_logic;
  signal ready_memory_retention_vector : std_logic;

  signal f_in_enable_memory_retention_vector : std_logic;

  signal f_out_enable_memory_retention_vector : std_logic;

  signal w_in_i_enable_memory_retention_vector : std_logic;
  signal w_in_j_enable_memory_retention_vector : std_logic;

  signal w_out_i_enable_memory_retention_vector : std_logic;
  signal w_out_j_enable_memory_retention_vector : std_logic;

  signal psi_out_enable_memory_retention_vector : std_logic;

  -- DATA
  signal size_r_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal psi_out_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- PRECEDENCE WEIGHTING
  -- CONTROL
  signal start_precedence_weighting : std_logic;
  signal ready_precedence_weighting : std_logic;

  signal w_in_enable_precedence_weighting : std_logic;
  signal p_in_enable_precedence_weighting : std_logic;

  signal w_out_enable_precedence_weighting : std_logic;
  signal p_out_enable_precedence_weighting : std_logic;

  -- DATA
  signal size_r_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal p_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal p_out_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ CONTENT WEIGHTING
  -- CONTROL
  signal start_read_content_weighting : std_logic;
  signal ready_read_content_weighting : std_logic;

  signal k_in_enable_read_content_weighting : std_logic;

  signal k_out_enable_read_content_weighting : std_logic;

  signal m_in_j_enable_read_content_weighting : std_logic;
  signal m_in_k_enable_read_content_weighting : std_logic;

  signal m_out_j_enable_read_content_weighting : std_logic;
  signal m_out_k_enable_read_content_weighting : std_logic;

  signal c_out_enable_read_content_weighting : std_logic;

  -- DATA
  signal size_n_in_read_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_read_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_read_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_read_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_read_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_read_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ VECTORS
  -- CONTROL
  signal start_read_vectors : std_logic;
  signal ready_read_vectors : std_logic;

  signal m_in_j_enable_read_vectors : std_logic;
  signal m_in_k_enable_read_vectors : std_logic;

  signal m_out_j_enable_read_vectors : std_logic;
  signal m_out_k_enable_read_vectors : std_logic;

  signal w_in_i_enable_read_vectors : std_logic;
  signal w_in_j_enable_read_vectors : std_logic;

  signal w_out_i_enable_read_vectors : std_logic;
  signal w_out_j_enable_read_vectors : std_logic;

  signal r_out_i_enable_read_vectors : std_logic;
  signal r_out_k_enable_read_vectors : std_logic;

  -- DATA
  signal size_r_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_out_read_vectors : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ WEIGHTING
  -- CONTROL
  signal start_read_weighting : std_logic;
  signal ready_read_weighting : std_logic;

  signal pi_in_i_enable_read_weighting : std_logic;
  signal pi_in_p_enable_read_weighting : std_logic;

  signal pi_out_i_enable_read_weighting : std_logic;
  signal pi_out_p_enable_read_weighting : std_logic;

  signal b_in_i_enable_read_weighting : std_logic;
  signal b_in_j_enable_read_weighting : std_logic;

  signal b_out_i_enable_read_weighting : std_logic;
  signal b_out_j_enable_read_weighting : std_logic;

  signal c_in_i_enable_read_weighting : std_logic;
  signal c_in_j_enable_read_weighting : std_logic;

  signal c_out_i_enable_read_weighting : std_logic;
  signal c_out_j_enable_read_weighting : std_logic;

  signal f_in_i_enable_read_weighting : std_logic;
  signal f_in_j_enable_read_weighting : std_logic;

  signal f_out_i_enable_read_weighting : std_logic;
  signal f_out_j_enable_read_weighting : std_logic;

  signal w_out_i_enable_read_weighting : std_logic;
  signal w_out_j_enable_read_weighting : std_logic;

  -- DATA
  signal size_r_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal pi_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TEMPORAL LINK MATRIX
  -- CONTROL
  signal start_temporal_link_matrix : std_logic;
  signal ready_temporal_link_matrix : std_logic;

  signal l_in_g_enable_temporal_link_matrix : std_logic;
  signal l_in_j_enable_temporal_link_matrix : std_logic;

  signal w_in_enable_temporal_link_matrix : std_logic;
  signal p_in_enable_temporal_link_matrix : std_logic;

  signal w_out_enable_temporal_link_matrix : std_logic;
  signal p_out_enable_temporal_link_matrix : std_logic;

  signal l_out_g_enable_temporal_link_matrix : std_logic;
  signal l_out_j_enable_temporal_link_matrix : std_logic;

  -- DATA
  signal size_n_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal l_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal p_in_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal l_out_temporal_link_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -- USAGE VECTOR
  -- CONTROL
  signal start_usage_vector : std_logic;
  signal ready_usage_vector : std_logic;

  signal u_in_enable_usage_vector   : std_logic;
  signal w_in_enable_usage_vector   : std_logic;
  signal psi_in_enable_usage_vector : std_logic;

  signal u_out_enable_usage_vector   : std_logic;
  signal w_out_enable_usage_vector   : std_logic;
  signal psi_out_enable_usage_vector : std_logic;

  -- DATA
  signal size_n_in_usage_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_usage_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_usage_vector   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal psi_in_usage_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_out_usage_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE CONTENT WEIGHTING
  -- CONTROL
  signal start_write_content_weighting : std_logic;
  signal ready_write_content_weighting : std_logic;

  signal k_in_enable_write_content_weighting : std_logic;

  signal k_out_enable_write_content_weighting : std_logic;

  signal m_in_j_enable_write_content_weighting : std_logic;
  signal m_in_k_enable_write_content_weighting : std_logic;

  signal m_out_j_enable_write_content_weighting : std_logic;
  signal m_out_k_enable_write_content_weighting : std_logic;

  signal c_out_enable_write_content_weighting : std_logic;

  -- DATA
  signal size_n_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_write_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_write_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE WEIGHTING
  -- CONTROL
  signal start_write_weighting : std_logic;
  signal ready_write_weighting : std_logic;

  signal a_in_enable_write_weighting : std_logic;
  signal c_in_enable_write_weighting : std_logic;

  signal a_out_enable_write_weighting : std_logic;
  signal c_out_enable_write_weighting : std_logic;

  signal w_out_enable_write_weighting : std_logic;

  -- DATA
  signal size_n_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal ga_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  ctrl_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      R_OUT <= ZERO;

      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Outputs
      READY <= '0';

    elsif (rising_edge(CLK)) then

      case controller_ctrl_fsm_int is
        when STARTER_STATE =>  -- STEP 0
          -- Control Outputs
          READY <= '0';

          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

          if (START = '1') then
            -- Control Internal
            start_precedence_weighting <= '1';

            -- FSM Control
            controller_ctrl_fsm_int <= PRECEDENCE_WEIGHTING_STATE;
          else
            -- Control Internal
            start_precedence_weighting <= '0';
          end if;

        when PRECEDENCE_WEIGHTING_STATE =>  -- STEP 1

          -- p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
          -- p(t=0) = 0

        when TEMPORAL_LINK_MATRIX_STATE =>  -- STEP 2

          -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
          -- L(t=0)[g,j] = 0

        when BACKWARD_FORWARD_WEIGHTING_STATE =>  -- STEP 3

          -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

          -- f(t;i;j) = L(t;g;j)·w(t-1;i;j)

        when MEMORY_RETENTION_VECTOR_STATE =>  -- STEP 4

          -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]

        when USAGE_VECTOR_STATE =>  -- STEP 5

          -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)

        when ALLOCATION_WEIGHTING_STATE =>  -- STEP 6

          -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]

        when READ_WRITE_CONTENT_WEIGHTING_STATE =>  -- STEP 7

          -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

          -- c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))

        when READ_WRITE_WEIGHTING_STATE =>  -- STEP 8

          -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

          -- w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))

        when MEMORY_MATRIX_STATE =>  -- STEP 9

          -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))

        when READ_VECTORS_STATE =>  -- STEP 10

          -- r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)

        when others =>
          -- FSM Control
          controller_ctrl_fsm_int <= STARTER_STATE;
      end case;
    end if;
  end process;

  -- ALLOCATION WEIGHTING
  u_in_enable_allocation_weighting <= '0';

  -- BACKWARD WEIGHTING
  l_in_g_enable_backward_weighting <= '0';
  l_in_j_enable_backward_weighting <= '0';

  w_in_i_enable_backward_weighting <= '0';
  w_in_j_enable_backward_weighting <= '0';

  -- FORWARD WEIGHTING
  l_in_g_enable_forward_weighting <= '0';
  l_in_j_enable_forward_weighting <= '0';

  w_in_i_enable_forward_weighting <= '0';
  w_in_j_enable_forward_weighting <= '0';

  -- MEMORY MATRIX
  m_in_j_enable_memory_matrix <= '0';
  m_in_k_enable_memory_matrix <= '0';

  w_in_j_enable_memory_matrix <= '0';
  v_in_k_enable_memory_matrix <= '0';
  e_in_k_enable_memory_matrix <= '0';

  -- MEMORY RETENTION VECTOR
  f_in_enable_memory_retention_vector <= '0';

  w_in_i_enable_memory_retention_vector <= '0';
  w_in_j_enable_memory_retention_vector <= '0';

  -- PRECEDENCE WEIGHTING
  w_in_enable_precedence_weighting <= '0';
  p_in_enable_precedence_weighting <= '0';

  -- READ CONTENT WEIGHTING
  k_in_enable_read_content_weighting <= '0';

  m_in_j_enable_read_content_weighting <= '0';
  m_in_k_enable_read_content_weighting <= '0';

  -- READ VECTORS
  m_in_j_enable_read_vectors <= '0';
  m_in_k_enable_read_vectors <= '0';

  w_in_i_enable_read_vectors <= '0';
  w_in_j_enable_read_vectors <= '0';

  -- READ WEIGHTING
  pi_in_i_enable_read_weighting <= '0';
  pi_in_p_enable_read_weighting <= '0';

  b_in_i_enable_read_weighting <= '0';
  b_in_j_enable_read_weighting <= '0';

  c_in_i_enable_read_weighting <= '0';
  c_in_j_enable_read_weighting <= '0';

  f_in_i_enable_read_weighting <= '0';
  f_in_j_enable_read_weighting <= '0';

  -- TEMPORAL LINK MATRIX
  l_in_g_enable_temporal_link_matrix <= '0';
  l_in_j_enable_temporal_link_matrix <= '0';

  w_in_enable_temporal_link_matrix <= '0';
  p_in_enable_temporal_link_matrix <= '0';

  -- USAGE VECTOR
  u_in_enable_usage_vector   <= '0';
  w_in_enable_usage_vector   <= '0';
  psi_in_enable_usage_vector <= '0';

  -- WRITE CONTENT WEIGHTING
  k_in_enable_write_content_weighting <= '0';

  m_in_j_enable_write_content_weighting <= '0';
  m_in_k_enable_write_content_weighting <= '0';

  -- WRITE WEIGHTING
  a_in_enable_write_weighting <= '0';
  c_in_enable_write_weighting <= '0';

  -- DATA
  -- ALLOCATION WEIGHTING
  size_n_in_allocation_weighting <= FULL;
  u_in_allocation_weighting      <= FULL;

  a_out_allocation_weighting <= FULL;

  -- BACKWARD WEIGHTING
  size_r_in_backward_weighting <= FULL;
  size_n_in_backward_weighting <= FULL;

  l_in_backward_weighting  <= FULL;
  w_in_backward_weighting  <= FULL;
  b_out_backward_weighting <= FULL;

  -- FORWARD WEIGHTING
  l_in_forward_weighting <= FULL;

  w_in_forward_weighting <= FULL;

  f_out_forward_weighting <= FULL;

  -- MEMORY MATRIX
  size_n_in_memory_matrix <= FULL;
  size_w_in_memory_matrix <= FULL;

  m_in_memory_matrix <= FULL;

  w_in_memory_matrix <= FULL;
  v_in_memory_matrix <= FULL;
  e_in_memory_matrix <= FULL;

  m_out_memory_matrix <= FULL;

  -- MEMORY RETENTION VECTOR
  size_r_in_memory_retention_vector <= FULL;
  size_n_in_memory_retention_vector <= FULL;

  f_in_memory_retention_vector <= FULL;
  w_in_memory_retention_vector <= FULL;

  psi_out_memory_retention_vector <= FULL;

  -- PRECEDENCE WEIGHTING
  size_r_in_precedence_weighting <= FULL;
  size_n_in_precedence_weighting <= FULL;

  w_in_precedence_weighting <= FULL;
  p_in_precedence_weighting <= FULL;

  p_out_precedence_weighting <= FULL;

  -- READ CONTENT WEIGHTING
  size_n_in_read_content_weighting <= FULL;
  size_w_in_read_content_weighting <= FULL;

  k_in_read_content_weighting    <= FULL;
  m_in_read_content_weighting    <= FULL;
  beta_in_read_content_weighting <= FULL;

  c_out_read_content_weighting <= FULL;

  -- READ VECTORS
  size_r_in_read_vectors <= FULL;
  size_n_in_read_vectors <= FULL;
  size_w_in_read_vectors <= FULL;

  m_in_read_vectors <= FULL;
  w_in_read_vectors <= FULL;

  r_out_read_vectors <= FULL;

  -- READ WEIGHTING
  size_r_in_read_weighting <= FULL;
  size_n_in_read_weighting <= FULL;

  pi_in_read_weighting <= FULL;

  b_in_read_weighting <= FULL;
  c_in_read_weighting <= FULL;
  f_in_read_weighting <= FULL;

  w_out_read_weighting <= FULL;

  -- TEMPORAL LINK MATRIX
  size_n_in_temporal_link_matrix <= FULL;

  l_in_temporal_link_matrix <= FULL;
  w_in_temporal_link_matrix <= FULL;
  p_in_temporal_link_matrix <= FULL;

  l_out_temporal_link_matrix <= FULL;

  -- USAGE VECTOR
  size_n_in_usage_vector <= FULL;

  u_in_usage_vector   <= FULL;
  w_in_usage_vector   <= FULL;
  psi_in_usage_vector <= FULL;

  u_out_usage_vector <= FULL;

  -- WRITE CONTENT WEIGHTING
  size_n_in_write_content_weighting <= FULL;
  size_w_in_write_content_weighting <= FULL;

  k_in_write_content_weighting    <= FULL;
  m_in_write_content_weighting    <= FULL;
  beta_in_write_content_weighting <= FULL;

  c_out_content_weighting <= FULL;

  -- WRITE WEIGHTING
  size_n_in_write_weighting <= FULL;

  a_in_write_weighting <= FULL;
  c_in_write_weighting <= FULL;

  ga_in_write_weighting <= FULL;
  gw_in_write_weighting <= FULL;

  w_out_write_weighting <= FULL;

  -- ALLOCATION WEIGHTING
  allocation_weighting : dnc_allocation_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_allocation_weighting,
      READY => ready_allocation_weighting,

      U_IN_ENABLE => u_in_enable_allocation_weighting,

      U_OUT_ENABLE => u_out_enable_allocation_weighting,

      A_OUT_ENABLE => a_out_enable_allocation_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_allocation_weighting,

      U_IN => u_in_allocation_weighting,

      A_OUT => a_out_allocation_weighting
      );

  -- BACKWARD WEIGHTING
  backward_weighting : dnc_backward_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_backward_weighting,
      READY => ready_backward_weighting,

      L_IN_G_ENABLE => l_in_g_enable_backward_weighting,
      L_IN_J_ENABLE => l_in_j_enable_backward_weighting,

      L_OUT_G_ENABLE => l_out_g_enable_backward_weighting,
      L_OUT_J_ENABLE => l_out_j_enable_backward_weighting,

      W_IN_I_ENABLE => w_in_i_enable_backward_weighting,
      W_IN_J_ENABLE => w_in_j_enable_backward_weighting,

      W_OUT_I_ENABLE => w_out_i_enable_backward_weighting,
      W_OUT_J_ENABLE => w_out_j_enable_backward_weighting,

      B_OUT_I_ENABLE => b_out_i_enable_backward_weighting,
      B_OUT_J_ENABLE => b_out_j_enable_backward_weighting,

      -- DATA
      SIZE_R_IN => size_r_in_backward_weighting,
      SIZE_N_IN => size_n_in_backward_weighting,

      L_IN => l_in_backward_weighting,

      W_IN => w_in_backward_weighting,

      B_OUT => b_out_backward_weighting
      );

  -- FORWARD WEIGHTING
  forward_weighting : dnc_forward_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_forward_weighting,
      READY => ready_forward_weighting,

      L_IN_G_ENABLE => l_in_g_enable_forward_weighting,
      L_IN_J_ENABLE => l_in_j_enable_forward_weighting,

      L_OUT_G_ENABLE => l_out_g_enable_forward_weighting,
      L_OUT_J_ENABLE => l_out_j_enable_forward_weighting,

      W_IN_I_ENABLE => w_in_i_enable_forward_weighting,
      W_IN_J_ENABLE => w_in_j_enable_forward_weighting,

      W_OUT_I_ENABLE => w_out_i_enable_forward_weighting,
      W_OUT_J_ENABLE => w_out_j_enable_forward_weighting,

      F_OUT_I_ENABLE => f_out_i_enable_forward_weighting,
      F_OUT_J_ENABLE => f_out_j_enable_forward_weighting,

      -- DATA
      SIZE_R_IN => size_r_in_forward_weighting,
      SIZE_N_IN => size_n_in_forward_weighting,

      L_IN => l_in_forward_weighting,

      W_IN => w_in_forward_weighting,

      F_OUT => f_out_forward_weighting
      );

  -- MEMORY MATRIX
  memory_matrix : dnc_memory_matrix
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_memory_matrix,
      READY => ready_memory_matrix,

      M_IN_J_ENABLE => m_in_j_enable_memory_matrix,
      M_IN_K_ENABLE => m_in_k_enable_memory_matrix,

      W_IN_J_ENABLE => w_in_j_enable_memory_matrix,
      V_IN_K_ENABLE => v_in_k_enable_memory_matrix,
      E_IN_K_ENABLE => e_in_k_enable_memory_matrix,

      W_OUT_J_ENABLE => w_out_j_enable_memory_matrix,
      V_OUT_K_ENABLE => v_out_k_enable_memory_matrix,
      E_OUT_K_ENABLE => e_out_k_enable_memory_matrix,

      M_OUT_J_ENABLE => m_out_j_enable_memory_matrix,
      M_OUT_K_ENABLE => m_out_k_enable_memory_matrix,

      -- DATA
      SIZE_N_IN => size_n_in_memory_matrix,
      SIZE_W_IN => size_w_in_memory_matrix,

      M_IN => m_in_memory_matrix,

      W_IN => w_in_memory_matrix,
      V_IN => v_in_memory_matrix,
      E_IN => e_in_memory_matrix,

      M_OUT => m_out_memory_matrix
      );

  -- MEMORY RETENTION VECTOR
  memory_retention_vector : dnc_memory_retention_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_memory_retention_vector,
      READY => ready_memory_retention_vector,

      F_IN_ENABLE => f_in_enable_memory_retention_vector,

      F_OUT_ENABLE => f_out_enable_memory_retention_vector,

      W_IN_I_ENABLE => w_in_i_enable_memory_retention_vector,
      W_IN_J_ENABLE => w_in_j_enable_memory_retention_vector,

      W_OUT_I_ENABLE => w_out_i_enable_memory_retention_vector,
      W_OUT_J_ENABLE => w_out_j_enable_memory_retention_vector,

      PSI_OUT_ENABLE => psi_out_enable_memory_retention_vector,

      -- DATA
      SIZE_R_IN => size_r_in_memory_retention_vector,
      SIZE_N_IN => size_n_in_memory_retention_vector,

      F_IN => f_in_memory_retention_vector,
      W_IN => w_in_memory_retention_vector,

      PSI_OUT => psi_out_memory_retention_vector
      );

  -- PRECEDENCE WEIGHTING
  precedence_weighting : dnc_precedence_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_precedence_weighting,
      READY => ready_precedence_weighting,

      W_IN_ENABLE => w_in_enable_precedence_weighting,
      P_IN_ENABLE => p_in_enable_precedence_weighting,

      W_OUT_ENABLE => w_out_enable_precedence_weighting,
      P_OUT_ENABLE => p_out_enable_precedence_weighting,

      -- DATA
      SIZE_R_IN => size_n_in_precedence_weighting,
      SIZE_N_IN => size_n_in_precedence_weighting,

      W_IN => w_in_precedence_weighting,
      P_IN => p_in_precedence_weighting,

      P_OUT => p_out_precedence_weighting
      );

  -- READ CONTENT WEIGHTING
  read_content_weighting : dnc_read_content_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_content_weighting,
      READY => ready_read_content_weighting,

      K_IN_ENABLE => k_in_enable_read_content_weighting,

      K_OUT_ENABLE => k_out_enable_read_content_weighting,

      M_IN_J_ENABLE => m_in_j_enable_read_content_weighting,
      M_IN_K_ENABLE => m_in_k_enable_read_content_weighting,

      M_OUT_J_ENABLE => m_out_j_enable_read_content_weighting,
      M_OUT_K_ENABLE => m_out_k_enable_read_content_weighting,

      C_OUT_ENABLE => c_out_enable_read_content_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_read_content_weighting,
      SIZE_W_IN => size_w_in_read_content_weighting,

      K_IN    => k_in_read_content_weighting,
      M_IN    => m_in_read_content_weighting,
      BETA_IN => beta_in_read_content_weighting,

      C_OUT => c_out_read_content_weighting
      );

  -- READ VECTORS
  read_vectors : dnc_read_vectors
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_vectors,
      READY => ready_read_vectors,

      M_IN_J_ENABLE => m_in_j_enable_read_vectors,
      M_IN_K_ENABLE => m_in_k_enable_read_vectors,

      M_OUT_J_ENABLE => m_out_j_enable_read_vectors,
      M_OUT_K_ENABLE => m_out_k_enable_read_vectors,

      W_IN_I_ENABLE => w_in_i_enable_read_vectors,
      W_IN_J_ENABLE => w_in_j_enable_read_vectors,

      W_OUT_I_ENABLE => w_out_i_enable_read_vectors,
      W_OUT_J_ENABLE => w_out_j_enable_read_vectors,

      R_OUT_I_ENABLE => r_out_i_enable_read_vectors,
      R_OUT_K_ENABLE => r_out_k_enable_read_vectors,

      -- DATA
      SIZE_R_IN => size_r_in_read_vectors,
      SIZE_N_IN => size_n_in_read_vectors,
      SIZE_W_IN => size_w_in_read_vectors,

      M_IN => m_in_read_vectors,
      W_IN => w_in_read_vectors,

      R_OUT => r_out_read_vectors
      );

  -- READ WEIGHTING
  read_weighting : dnc_read_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_weighting,
      READY => ready_read_weighting,

      PI_IN_I_ENABLE => pi_in_i_enable_read_weighting,
      PI_IN_P_ENABLE => pi_in_p_enable_read_weighting,

      PI_OUT_I_ENABLE => pi_out_i_enable_read_weighting,
      PI_OUT_P_ENABLE => pi_out_p_enable_read_weighting,

      B_IN_I_ENABLE => b_in_i_enable_read_weighting,
      B_IN_J_ENABLE => b_in_j_enable_read_weighting,

      B_OUT_I_ENABLE => b_out_i_enable_read_weighting,
      B_OUT_J_ENABLE => b_out_j_enable_read_weighting,

      C_IN_I_ENABLE => c_in_i_enable_read_weighting,
      C_IN_J_ENABLE => c_in_j_enable_read_weighting,

      C_OUT_I_ENABLE => c_out_i_enable_read_weighting,
      C_OUT_J_ENABLE => c_out_j_enable_read_weighting,

      F_IN_I_ENABLE => f_in_i_enable_read_weighting,
      F_IN_J_ENABLE => f_in_j_enable_read_weighting,

      F_OUT_I_ENABLE => f_out_i_enable_read_weighting,
      F_OUT_J_ENABLE => f_out_j_enable_read_weighting,

      W_OUT_I_ENABLE => w_out_i_enable_read_weighting,
      W_OUT_J_ENABLE => w_out_j_enable_read_weighting,

      -- DATA
      SIZE_R_IN => size_r_in_read_weighting,
      SIZE_N_IN => size_n_in_read_weighting,

      PI_IN => pi_in_read_weighting,

      B_IN => b_in_read_weighting,
      C_IN => c_in_read_weighting,
      F_IN => f_in_read_weighting,

      W_OUT => w_out_read_weighting
      );

  -- TEMPORAL LINK MATRIX
  temporal_link_matrix : dnc_temporal_link_matrix
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_temporal_link_matrix,
      READY => ready_temporal_link_matrix,

      L_IN_G_ENABLE => l_in_g_enable_temporal_link_matrix,
      L_IN_J_ENABLE => l_in_j_enable_temporal_link_matrix,

      W_IN_ENABLE => w_in_enable_temporal_link_matrix,
      P_IN_ENABLE => p_in_enable_temporal_link_matrix,

      W_OUT_ENABLE => w_out_enable_temporal_link_matrix,
      P_OUT_ENABLE => p_out_enable_temporal_link_matrix,

      L_OUT_G_ENABLE => l_out_g_enable_temporal_link_matrix,
      L_OUT_J_ENABLE => l_out_j_enable_temporal_link_matrix,

      -- DATA
      SIZE_N_IN => size_n_in_temporal_link_matrix,

      L_IN => l_in_temporal_link_matrix,
      W_IN => w_in_temporal_link_matrix,
      P_IN => p_in_temporal_link_matrix,

      L_OUT => l_out_temporal_link_matrix
      );

  -- USAGE VECTOR
  usage_vector : dnc_usage_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_usage_vector,
      READY => ready_usage_vector,

      U_IN_ENABLE   => u_in_enable_usage_vector,
      W_IN_ENABLE   => w_in_enable_usage_vector,
      PSI_IN_ENABLE => psi_in_enable_usage_vector,

      U_OUT_ENABLE   => u_out_enable_usage_vector,
      W_OUT_ENABLE   => w_out_enable_usage_vector,
      PSI_OUT_ENABLE => psi_out_enable_usage_vector,

      -- DATA
      SIZE_N_IN => size_n_in_usage_vector,

      U_IN   => u_in_usage_vector,
      W_IN   => w_in_usage_vector,
      PSI_IN => psi_in_usage_vector,

      U_OUT => u_out_usage_vector
      );

  -- WRITE CONTENT WEIGHTING
  write_content_weighting : dnc_write_content_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_content_weighting,
      READY => ready_write_content_weighting,

      K_IN_ENABLE => k_in_enable_write_content_weighting,

      M_IN_J_ENABLE => m_in_j_enable_write_content_weighting,
      M_IN_K_ENABLE => m_in_k_enable_write_content_weighting,

      M_OUT_J_ENABLE => m_out_j_enable_write_content_weighting,
      M_OUT_K_ENABLE => m_out_k_enable_write_content_weighting,

      C_OUT_ENABLE => c_out_enable_write_content_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_write_content_weighting,
      SIZE_W_IN => size_w_in_write_content_weighting,

      K_IN    => k_in_write_content_weighting,
      M_IN    => m_in_write_content_weighting,
      BETA_IN => beta_in_write_content_weighting,

      C_OUT => c_out_content_weighting
      );

  -- WRITE WEIGHTING
  write_weighting : dnc_write_weighting
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_write_weighting,
      READY => ready_write_weighting,

      A_IN_ENABLE => a_in_enable_write_weighting,
      C_IN_ENABLE => c_in_enable_write_weighting,

      A_OUT_ENABLE => a_out_enable_write_weighting,
      C_OUT_ENABLE => c_out_enable_write_weighting,

      W_OUT_ENABLE => w_out_enable_write_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_write_weighting,

      A_IN => a_in_write_weighting,
      C_IN => c_in_write_weighting,

      GA_IN => ga_in_write_weighting,
      GW_IN => gw_in_write_weighting,

      W_OUT => w_out_write_weighting
      );

end dnc_addressing_architecture;
