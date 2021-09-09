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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;

entity dnc_memory_testbench is
end dnc_memory_testbench;

architecture dnc_memory_testbench_architecture of dnc_memory_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- ALLOCATION WEIGHTING
  -- CONTROL
  signal start_allocation_weighting : std_logic;
  signal ready_allocation_weighting : std_logic;

  signal phi_in_enable_allocation_weighting : std_logic;
  signal u_in_enable_allocation_weighting   : std_logic;

  signal a_out_enable_allocation_weighting : std_logic;

  -- DATA
  signal size_n_in_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal phi_in_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal u_in_allocation_weighting   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_out_allocation_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- BACKWARD WEIGHTING
  -- CONTROL
  signal start_backward_weighting : std_logic;
  signal ready_backward_weighting : std_logic;

  signal l_in_g_enable_backward_weighting : std_logic;
  signal l_in_j_enable_backward_weighting : std_logic;

  signal w_in_i_enable_backward_weighting : std_logic;
  signal w_in_j_enable_backward_weighting : std_logic;

  signal b_out_i_enable_backward_weighting : std_logic;
  signal b_out_j_enable_backward_weighting : std_logic;

  -- DATA
  signal size_r_in_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal l_in_backward_weighting  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_backward_weighting  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal b_out_backward_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- FORWARD WEIGHTING
  -- CONTROL
  signal start_forward_weighting : std_logic;
  signal ready_forward_weighting : std_logic;

  signal l_in_g_enable_forward_weighting : std_logic;
  signal l_in_j_enable_forward_weighting : std_logic;

  signal w_in_i_enable_forward_weighting : std_logic;
  signal w_in_j_enable_forward_weighting : std_logic;

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

  signal m_out_j_enable_memory_matrix : std_logic;
  signal m_out_k_enable_memory_matrix : std_logic;

  -- DATA
  signal size_n_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal m_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_in_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_in_memory_matrix : std_logic;

  signal m_out_memory_matrix : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MEMORY RETENTION VECTOR
  -- CONTROL
  signal start_memory_retention_vector : std_logic;
  signal ready_memory_retention_vector : std_logic;

  signal f_in_enable_memory_retention_vector : std_logic;

  signal w_in_i_enable_memory_retention_vector : std_logic;
  signal w_in_j_enable_memory_retention_vector : std_logic;

  signal psi_out_enable_memory_retention_vector : std_logic;

  -- DATA
  signal size_r_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_in_memory_retention_vector : std_logic;
  signal w_in_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal psi_out_memory_retention_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- PRECEDENCE WEIGHTING
  -- CONTROL
  signal start_precedence_weighting : std_logic;
  signal ready_precedence_weighting : std_logic;

  signal w_in_enable_precedence_weighting : std_logic;
  signal p_in_enable_precedence_weighting : std_logic;

  signal p_out_enable_precedence_weighting : std_logic;

  -- DATA
  signal size_n_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal p_in_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal p_out_precedence_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ CONTENT WEIGHTING
  -- CONTROL
  signal start_read_content_weighting : std_logic;
  signal ready_read_content_weighting : std_logic;

  signal k_in_enable_read_content_weighting : std_logic;

  signal m_in_j_enable_read_content_weighting : std_logic;
  signal m_in_k_enable_read_content_weighting : std_logic;

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

  signal w_in_i_enable_read_vectors : std_logic;
  signal w_in_j_enable_read_vectors : std_logic;

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

  signal pi_in_enable_read_weighting : std_logic;

  signal b_in_i_enable_read_weighting : std_logic;
  signal b_in_j_enable_read_weighting : std_logic;

  signal c_in_i_enable_read_weighting : std_logic;
  signal c_in_j_enable_read_weighting : std_logic;

  signal f_in_i_enable_read_weighting : std_logic;
  signal f_in_j_enable_read_weighting : std_logic;

  signal w_out_i_enable_read_weighting : std_logic;
  signal w_out_j_enable_read_weighting : std_logic;

  -- DATA
  signal size_r_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_n_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal pi_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_in_read_weighting : std_logic;

  signal w_out_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SORT VECTOR
  -- CONTROL
  signal start_sort_vector : std_logic;
  signal ready_sort_vector : std_logic;

  signal u_in_enable_sort_vector : std_logic;

  signal phi_out_enable_sort_vector : std_logic;

  -- DATA
  signal size_n_in_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal u_in_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal phi_out_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TEMPORAL LINK MATRIX
  -- CONTROL
  signal start_temporal_link_matrix : std_logic;
  signal ready_temporal_link_matrix : std_logic;

  signal l_in_g_enable_temporal_link_matrix : std_logic;
  signal l_in_j_enable_temporal_link_matrix : std_logic;

  signal w_in_enable_temporal_link_matrix : std_logic;
  signal p_in_enable_temporal_link_matrix : std_logic;

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

  signal u_out_enable_usage_vector : std_logic;

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

  signal m_in_j_enable_write_content_weighting : std_logic;
  signal m_in_k_enable_write_content_weighting : std_logic;

  signal c_out_enable_write_content_weighting : std_logic;

  -- DATA
  signal size_n_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_write_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal m_in_write_content_weighting    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_in_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal c_out_write_content_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- WRITE WEIGHTING
  -- CONTROL
  signal start_write_weighting : std_logic;
  signal ready_write_weighting : std_logic;

  signal a_in_enable_write_weighting : std_logic;
  signal c_in_enable_write_weighting : std_logic;

  signal w_out_enable_write_weighting : std_logic;

  -- DATA
  signal size_n_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal a_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal ga_in_write_weighting : std_logic;
  signal gw_in_write_weighting : std_logic;

  signal w_out_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_read_in_i_enable_addressing : std_logic;
  signal k_read_in_k_enable_addressing : std_logic;

  signal beta_read_in_enable_addressing : std_logic;

  signal f_read_in_enable_addressing : std_logic;

  signal pi_read_in_enable_addressing : std_logic;

  signal k_write_in_k_enable_addressing : std_logic;
  signal e_write_in_k_enable_addressing : std_logic;
  signal v_write_in_k_enable_addressing : std_logic;

  -- DATA
  signal size_r_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_read_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_read_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_read_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_write_in_addressing : std_logic_vector(DATA_SIZE-1 downto 0);
  signal e_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal v_write_in_addressing    : std_logic_vector(DATA_SIZE-1 downto 0);
  signal ga_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_write_in_addressing   : std_logic_vector(DATA_SIZE-1 downto 0);

  signal r_out_addressing : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

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

      PHI_IN_ENABLE => phi_in_enable_allocation_weighting,
      U_IN_ENABLE   => u_in_enable_allocation_weighting,

      A_OUT_ENABLE => a_out_enable_allocation_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_allocation_weighting,

      PHI_IN => phi_in_allocation_weighting,
      U_IN   => u_in_allocation_weighting,

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

      W_IN_I_ENABLE => w_in_i_enable_backward_weighting,
      W_IN_J_ENABLE => w_in_j_enable_backward_weighting,

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

      W_IN_I_ENABLE => w_in_i_enable_forward_weighting,
      W_IN_J_ENABLE => w_in_j_enable_forward_weighting,

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

      W_IN_I_ENABLE => w_in_i_enable_memory_retention_vector,
      W_IN_J_ENABLE => w_in_j_enable_memory_retention_vector,

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

      P_OUT_ENABLE => p_out_enable_precedence_weighting,

      -- DATA
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

      M_IN_J_ENABLE => m_in_j_enable_read_content_weighting,
      M_IN_K_ENABLE => m_in_k_enable_read_content_weighting,

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

      W_IN_I_ENABLE => w_in_i_enable_read_vectors,
      W_IN_J_ENABLE => w_in_j_enable_read_vectors,

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

      PI_IN_ENABLE => pi_in_enable_read_weighting,

      B_IN_I_ENABLE => b_in_i_enable_read_weighting,
      B_IN_J_ENABLE => b_in_j_enable_read_weighting,

      C_IN_I_ENABLE => c_in_i_enable_read_weighting,
      C_IN_J_ENABLE => c_in_j_enable_read_weighting,

      F_IN_I_ENABLE => f_in_i_enable_read_weighting,
      F_IN_J_ENABLE => f_in_j_enable_read_weighting,

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

  -- SORT VECTOR
  sort_vector : dnc_sort_vector
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_sort_vector,
      READY => ready_sort_vector,

      U_IN_ENABLE => u_in_enable_sort_vector,

      PHI_OUT_ENABLE => phi_out_enable_sort_vector,

      -- DATA
      SIZE_N_IN => size_n_in_sort_vector,

      U_IN => u_in_sort_vector,

      PHI_OUT => phi_out_sort_vector
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

      U_OUT_ENABLE => u_out_enable_usage_vector,

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

      C_OUT_ENABLE => c_out_enable_write_content_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_write_content_weighting,
      SIZE_W_IN => size_w_in_write_content_weighting,

      K_IN    => k_in_write_content_weighting,
      M_IN    => m_in_write_content_weighting,
      BETA_IN => beta_in_write_content_weighting,

      C_OUT => c_out_write_content_weighting
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

      W_OUT_ENABLE => w_out_enable_write_weighting,

      -- DATA
      SIZE_N_IN => size_n_in_write_weighting,

      A_IN => a_in_write_weighting,
      C_IN => c_in_write_weighting,

      GA_IN => ga_in_write_weighting,
      GW_IN => gw_in_write_weighting,

      W_OUT => w_out_write_weighting
      );

  -- ADDRESSING
  addressing : dnc_addressing
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_addressing,
      READY => ready_addressing,

      K_READ_IN_I_ENABLE => k_read_in_i_enable_addressing,
      K_READ_IN_K_ENABLE => k_read_in_k_enable_addressing,

      BETA_READ_IN_ENABLE => beta_read_in_enable_addressing,

      F_READ_IN_ENABLE => f_read_in_enable_addressing,

      PI_READ_IN_ENABLE => pi_read_in_enable_addressing,

      K_WRITE_IN_K_ENABLE => k_write_in_k_enable_addressing,
      E_WRITE_IN_K_ENABLE => e_write_in_k_enable_addressing,
      V_WRITE_IN_K_ENABLE => v_write_in_k_enable_addressing,

      -- DATA
      SIZE_R_IN => size_r_in_addressing,
      SIZE_W_IN => size_w_in_addressing,

      K_READ_IN    => k_read_in_addressing,
      BETA_READ_IN => beta_read_in_addressing,
      F_READ_IN    => f_read_in_addressing,
      PI_READ_IN   => pi_read_in_addressing,

      K_WRITE_IN    => k_write_in_addressing,
      BETA_WRITE_IN => beta_write_in_addressing,
      E_WRITE_IN    => e_write_in_addressing,
      V_WRITE_IN    => v_write_in_addressing,
      GA_WRITE_IN   => ga_write_in_addressing,
      GW_WRITE_IN   => gw_write_in_addressing,

      R_OUT => r_out_addressing
      );

end dnc_memory_testbench_architecture;
