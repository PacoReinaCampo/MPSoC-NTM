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

use work.model_math_pkg.all;
use work.model_dnc_core_pkg.all;
use work.model_memory_pkg.all;

entity model_memory_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- FUNCTIONALITY
    ENABLE_DNC_MEMORY_ALLOCATION_WEIGHTING_TEST    : boolean := false;
    ENABLE_DNC_MEMORY_BACKWARD_WEIGHTING_TEST      : boolean := false;
    ENABLE_DNC_MEMORY_FORWARD_WEIGHTING_TEST       : boolean := false;
    ENABLE_DNC_MEMORY_MATRIX_TEST                  : boolean := false;
    ENABLE_DNC_MEMORY_RETENTION_VECTOR_TEST        : boolean := false;
    ENABLE_DNC_MEMORY_PRECEDENCE_WEIGHTING_TEST    : boolean := false;
    ENABLE_DNC_MEMORY_READ_CONTENT_WEIGHTING_TEST  : boolean := false;
    ENABLE_DNC_MEMORY_READ_VECTORS_TEST            : boolean := false;
    ENABLE_DNC_MEMORY_READ_WEIGHTING_TEST          : boolean := false;
    ENABLE_DNC_MEMORY_SORT_VECTOR_TEST             : boolean := false;
    ENABLE_DNC_MEMORY_TEMPORAL_LINK_MATRIX_TEST    : boolean := false;
    ENABLE_DNC_MEMORY_USAGE_VECTOR_TEST            : boolean := false;
    ENABLE_DNC_MEMORY_WRITE_CONTENT_WEIGHTING_TEST : boolean := false;
    ENABLE_DNC_MEMORY_WRITE_WEIGHTING_TEST         : boolean := false;
    ENABLE_DNC_MEMORY_ADDRESSING_TEST              : boolean := false;

    ENABLE_DNC_MEMORY_ALLOCATION_WEIGHTING_CASE_0    : boolean := false;
    ENABLE_DNC_MEMORY_BACKWARD_WEIGHTING_CASE_0      : boolean := false;
    ENABLE_DNC_MEMORY_FORWARD_WEIGHTING_CASE_0       : boolean := false;
    ENABLE_DNC_MEMORY_MATRIX_CASE_0                  : boolean := false;
    ENABLE_DNC_MEMORY_RETENTION_VECTOR_CASE_0        : boolean := false;
    ENABLE_DNC_MEMORY_PRECEDENCE_WEIGHTING_CASE_0    : boolean := false;
    ENABLE_DNC_MEMORY_READ_CONTENT_WEIGHTING_CASE_0  : boolean := false;
    ENABLE_DNC_MEMORY_READ_VECTORS_CASE_0            : boolean := false;
    ENABLE_DNC_MEMORY_READ_WEIGHTING_CASE_0          : boolean := false;
    ENABLE_DNC_MEMORY_SORT_VECTOR_CASE_0             : boolean := false;
    ENABLE_DNC_MEMORY_TEMPORAL_LINK_MATRIX_CASE_0    : boolean := false;
    ENABLE_DNC_MEMORY_USAGE_VECTOR_CASE_0            : boolean := false;
    ENABLE_DNC_MEMORY_WRITE_CONTENT_WEIGHTING_CASE_0 : boolean := false;
    ENABLE_DNC_MEMORY_WRITE_WEIGHTING_CASE_0         : boolean := false;
    ENABLE_DNC_MEMORY_ADDRESSING_CASE_0              : boolean := false;

    ENABLE_DNC_MEMORY_ALLOCATION_WEIGHTING_CASE_1    : boolean := false;
    ENABLE_DNC_MEMORY_BACKWARD_WEIGHTING_CASE_1      : boolean := false;
    ENABLE_DNC_MEMORY_FORWARD_WEIGHTING_CASE_1       : boolean := false;
    ENABLE_DNC_MEMORY_MATRIX_CASE_1                  : boolean := false;
    ENABLE_DNC_MEMORY_RETENTION_VECTOR_CASE_1        : boolean := false;
    ENABLE_DNC_MEMORY_PRECEDENCE_WEIGHTING_CASE_1    : boolean := false;
    ENABLE_DNC_MEMORY_READ_CONTENT_WEIGHTING_CASE_1  : boolean := false;
    ENABLE_DNC_MEMORY_READ_VECTORS_CASE_1            : boolean := false;
    ENABLE_DNC_MEMORY_READ_WEIGHTING_CASE_1          : boolean := false;
    ENABLE_DNC_MEMORY_SORT_VECTOR_CASE_1             : boolean := false;
    ENABLE_DNC_MEMORY_TEMPORAL_LINK_MATRIX_CASE_1    : boolean := false;
    ENABLE_DNC_MEMORY_USAGE_VECTOR_CASE_1            : boolean := false;
    ENABLE_DNC_MEMORY_WRITE_CONTENT_WEIGHTING_CASE_1 : boolean := false;
    ENABLE_DNC_MEMORY_WRITE_WEIGHTING_CASE_1         : boolean := false;
    ENABLE_DNC_MEMORY_ADDRESSING_CASE_1              : boolean := false
    );
end model_memory_testbench;

architecture model_memory_testbench_architecture of model_memory_testbench is

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- ALLOCATION WEIGHTING
  -- CONTROL
  signal start_allocation_weighting : std_logic;
  signal ready_allocation_weighting : std_logic;

  signal u_in_enable_allocation_weighting : std_logic;

  signal u_out_enable_allocation_weighting : std_logic;

  signal a_out_enable_allocation_weighting : std_logic;

  -- DATA
  signal size_n_in_allocation_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_r_in_backward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_backward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal l_in_backward_weighting  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal w_in_backward_weighting  : std_logic_vector(DATA_SIZE-1 downto 0);
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
  signal size_r_in_forward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_forward_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_n_in_memory_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_memory_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_r_in_memory_retention_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_memory_retention_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_n_in_precedence_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_n_in_read_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_read_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_r_in_read_vectors : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_read_vectors : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_read_vectors : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_r_in_read_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_read_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal pi_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal b_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_in_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_read_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SORT VECTOR
  -- CONTROL
  signal start_sort_vector : std_logic;
  signal ready_sort_vector : std_logic;

  signal u_in_enable_sort_vector : std_logic;

  signal u_out_enable_sort_vector : std_logic;

  signal phi_out_enable_sort_vector : std_logic;

  -- DATA
  signal size_n_in_sort_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal u_in_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  signal phi_out_sort_vector : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TEMPORAL LINK MATRIX
  -- CONTROL
  signal start_temporal_link_matrix : std_logic;
  signal ready_temporal_link_matrix : std_logic;

  signal l_in_g_enable_temporal_link_matrix : std_logic;
  signal l_in_j_enable_temporal_link_matrix : std_logic;

  signal l_out_g_enable_temporal_link_matrix : std_logic;
  signal l_out_j_enable_temporal_link_matrix : std_logic;

  signal w_in_enable_temporal_link_matrix : std_logic;
  signal p_in_enable_temporal_link_matrix : std_logic;

  signal w_out_enable_temporal_link_matrix : std_logic;
  signal p_out_enable_temporal_link_matrix : std_logic;

  -- DATA
  signal size_n_in_temporal_link_matrix : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_n_in_usage_vector : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_n_in_write_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_write_content_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  signal size_n_in_write_weighting : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal a_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal c_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal ga_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);
  signal gw_in_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  signal w_out_write_weighting : std_logic_vector(DATA_SIZE-1 downto 0);

  -- ADDRESSING
  -- CONTROL
  signal start_addressing : std_logic;
  signal ready_addressing : std_logic;

  signal k_read_in_i_enable_addressing : std_logic;
  signal k_read_in_k_enable_addressing : std_logic;

  signal k_read_out_i_enable_addressing : std_logic;
  signal k_read_out_k_enable_addressing : std_logic;

  signal beta_read_in_enable_addressing : std_logic;

  signal beta_read_out_enable_addressing : std_logic;

  signal f_read_in_enable_addressing : std_logic;

  signal f_read_out_enable_addressing : std_logic;

  signal pi_read_in_i_enable_addressing : std_logic;
  signal pi_read_in_p_enable_addressing : std_logic;

  signal pi_read_out_i_enable_addressing : std_logic;
  signal pi_read_out_p_enable_addressing : std_logic;

  signal k_write_in_k_enable_addressing : std_logic;
  signal e_write_in_k_enable_addressing : std_logic;
  signal v_write_in_k_enable_addressing : std_logic;

  signal k_write_out_k_enable_addressing : std_logic;
  signal e_write_out_k_enable_addressing : std_logic;
  signal v_write_out_k_enable_addressing : std_logic;

  signal r_out_i_enable_addressing : std_logic;
  signal r_out_k_enable_addressing : std_logic;

  -- DATA
  signal size_r_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_n_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_w_in_addressing : std_logic_vector(CONTROL_SIZE-1 downto 0);

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

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  -- STIMULUS
  memory_stimulus : model_memory_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- FORWARD WEIGHTING
      -- CONTROL
      DNC_MEMORY_FORWARD_WEIGHTING_START => start_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_READY => ready_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_L_IN_G_ENABLE => l_in_g_enable_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_L_IN_J_ENABLE => l_in_j_enable_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_L_OUT_G_ENABLE => l_out_g_enable_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_L_OUT_J_ENABLE => l_out_j_enable_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_W_IN_I_ENABLE => w_in_i_enable_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_W_IN_J_ENABLE => w_in_j_enable_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_W_OUT_I_ENABLE => w_out_i_enable_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_W_OUT_J_ENABLE => w_out_j_enable_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_F_OUT_I_ENABLE => f_out_i_enable_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_F_OUT_J_ENABLE => f_out_j_enable_forward_weighting,

      -- DATA
      DNC_MEMORY_FORWARD_WEIGHTING_SIZE_R_IN => size_r_in_forward_weighting,
      DNC_MEMORY_FORWARD_WEIGHTING_SIZE_N_IN => size_n_in_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_L_IN => l_in_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_W_IN => w_in_forward_weighting,

      DNC_MEMORY_FORWARD_WEIGHTING_F_OUT => f_out_forward_weighting,

      -- SORT VECTOR
      -- CONTROL
      DNC_MEMORY_SORT_VECTOR_START => start_sort_vector,
      DNC_MEMORY_SORT_VECTOR_READY => ready_sort_vector,

      DNC_MEMORY_SORT_VECTOR_U_IN_ENABLE => u_in_enable_sort_vector,

      DNC_MEMORY_SORT_VECTOR_U_OUT_ENABLE => u_out_enable_sort_vector,

      DNC_MEMORY_SORT_VECTOR_PHI_OUT_ENABLE => phi_out_enable_sort_vector,

      -- DATA
      DNC_MEMORY_SORT_VECTOR_SIZE_N_IN => size_n_in_sort_vector,

      DNC_MEMORY_SORT_VECTOR_U_IN => u_in_sort_vector,

      DNC_MEMORY_SORT_VECTOR_PHI_OUT => phi_out_sort_vector,

      -- ADDRESSING
      -- CONTROL
      DNC_MEMORY_START => start_addressing,
      DNC_MEMORY_READY => ready_addressing,

      DNC_MEMORY_K_READ_IN_I_ENABLE => k_read_in_i_enable_addressing,
      DNC_MEMORY_K_READ_IN_K_ENABLE => k_read_in_k_enable_addressing,

      DNC_MEMORY_K_READ_OUT_I_ENABLE => k_read_out_i_enable_addressing,
      DNC_MEMORY_K_READ_OUT_K_ENABLE => k_read_out_k_enable_addressing,

      DNC_MEMORY_BETA_READ_IN_ENABLE => beta_read_in_enable_addressing,

      DNC_MEMORY_BETA_READ_OUT_ENABLE => beta_read_out_enable_addressing,

      DNC_MEMORY_F_READ_IN_ENABLE => f_read_in_enable_addressing,

      DNC_MEMORY_F_READ_OUT_ENABLE => f_read_out_enable_addressing,

      DNC_MEMORY_PI_READ_IN_I_ENABLE => pi_read_in_i_enable_addressing,
      DNC_MEMORY_PI_READ_IN_P_ENABLE => pi_read_in_p_enable_addressing,

      DNC_MEMORY_PI_READ_OUT_I_ENABLE => pi_read_out_i_enable_addressing,
      DNC_MEMORY_PI_READ_OUT_P_ENABLE => pi_read_out_p_enable_addressing,

      DNC_MEMORY_K_WRITE_IN_K_ENABLE => k_write_in_k_enable_addressing,
      DNC_MEMORY_E_WRITE_IN_K_ENABLE => e_write_in_k_enable_addressing,
      DNC_MEMORY_V_WRITE_IN_K_ENABLE => v_write_in_k_enable_addressing,

      DNC_MEMORY_K_WRITE_OUT_K_ENABLE => k_write_out_k_enable_addressing,
      DNC_MEMORY_E_WRITE_OUT_K_ENABLE => e_write_out_k_enable_addressing,
      DNC_MEMORY_V_WRITE_OUT_K_ENABLE => v_write_out_k_enable_addressing,

      DNC_MEMORY_R_OUT_I_ENABLE => r_out_i_enable_addressing,
      DNC_MEMORY_R_OUT_K_ENABLE => r_out_k_enable_addressing,

      -- DATA
      DNC_MEMORY_SIZE_R_IN => size_r_in_addressing,
      DNC_MEMORY_SIZE_N_IN => size_n_in_addressing,
      DNC_MEMORY_SIZE_W_IN => size_w_in_addressing,

      DNC_MEMORY_K_READ_IN    => k_read_in_addressing,
      DNC_MEMORY_BETA_READ_IN => beta_read_in_addressing,
      DNC_MEMORY_F_READ_IN    => f_read_in_addressing,
      DNC_MEMORY_PI_READ_IN   => pi_read_in_addressing,

      DNC_MEMORY_K_WRITE_IN    => k_write_in_addressing,
      DNC_MEMORY_BETA_WRITE_IN => beta_write_in_addressing,
      DNC_MEMORY_E_WRITE_IN    => e_write_in_addressing,
      DNC_MEMORY_V_WRITE_IN    => v_write_in_addressing,
      DNC_MEMORY_GA_WRITE_IN   => ga_write_in_addressing,
      DNC_MEMORY_GW_WRITE_IN   => gw_write_in_addressing,

      DNC_MEMORY_R_OUT => r_out_addressing
      );

  -- ALLOCATION WEIGHTING
  model_allocation_weighting_test : if (ENABLE_DNC_MEMORY_ALLOCATION_WEIGHTING_TEST) generate
    allocation_weighting : model_allocation_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_allocation_weighting_test;

  -- BACKWARD WEIGHTING
  model_backward_weighting_test : if (ENABLE_DNC_MEMORY_BACKWARD_WEIGHTING_TEST) generate
    backward_weighting : model_backward_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_backward_weighting_test;

  -- FORWARD WEIGHTING
  model_forward_weighting_test : if (ENABLE_DNC_MEMORY_FORWARD_WEIGHTING_TEST) generate
    forward_weighting : model_forward_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_forward_weighting_test;

  -- MEMORY MATRIX
  model_memory_matrix_test : if (ENABLE_DNC_MEMORY_MATRIX_TEST) generate
    memory_matrix : model_memory_matrix
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_memory_matrix_test;

  -- MEMORY RETENTION VECTOR
  model_memory_retention_vector_test : if (ENABLE_DNC_MEMORY_RETENTION_VECTOR_TEST) generate
    memory_retention_vector : model_memory_retention_vector
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_memory_retention_vector_test;

  -- PRECEDENCE WEIGHTING
  model_precedence_weighting_test : if (ENABLE_DNC_MEMORY_PRECEDENCE_WEIGHTING_TEST) generate
    precedence_weighting : model_precedence_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
        SIZE_N_IN => size_n_in_precedence_weighting,

        W_IN => w_in_precedence_weighting,
        P_IN => p_in_precedence_weighting,

        P_OUT => p_out_precedence_weighting
        );
  end generate model_precedence_weighting_test;

  -- READ CONTENT WEIGHTING
  model_read_content_weighting_test : if (ENABLE_DNC_MEMORY_READ_CONTENT_WEIGHTING_TEST) generate
    read_content_weighting : model_read_content_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_read_content_weighting_test;

  -- READ VECTORS
  model_read_vectors_test : if (ENABLE_DNC_MEMORY_READ_VECTORS_TEST) generate
    read_vectors : model_read_vectors
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_read_vectors_test;

  -- READ WEIGHTING
  model_read_weighting_test : if (ENABLE_DNC_MEMORY_READ_WEIGHTING_TEST) generate
    read_weighting : model_read_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_read_weighting_test;

  -- SORT VECTOR
  model_sort_vector_test : if (ENABLE_DNC_MEMORY_SORT_VECTOR_TEST) generate
    sort_vector : model_sort_vector
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_sort_vector,
        READY => ready_sort_vector,

        U_IN_ENABLE => u_in_enable_sort_vector,

        U_OUT_ENABLE => u_out_enable_sort_vector,

        PHI_OUT_ENABLE => phi_out_enable_sort_vector,

        -- DATA
        SIZE_N_IN => size_n_in_sort_vector,

        U_IN => u_in_sort_vector,

        PHI_OUT => phi_out_sort_vector
        );
  end generate model_sort_vector_test;

  -- TEMPORAL LINK MATRIX
  model_temporal_link_matrix_test : if (ENABLE_DNC_MEMORY_TEMPORAL_LINK_MATRIX_TEST) generate
    temporal_link_matrix : model_temporal_link_matrix
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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

        L_OUT_G_ENABLE => l_out_g_enable_temporal_link_matrix,
        L_OUT_J_ENABLE => l_out_j_enable_temporal_link_matrix,

        W_IN_ENABLE => w_in_enable_temporal_link_matrix,
        P_IN_ENABLE => p_in_enable_temporal_link_matrix,

        W_OUT_ENABLE => w_out_enable_temporal_link_matrix,
        P_OUT_ENABLE => p_out_enable_temporal_link_matrix,

        -- DATA
        SIZE_N_IN => size_n_in_temporal_link_matrix,

        L_IN => l_in_temporal_link_matrix,
        W_IN => w_in_temporal_link_matrix,
        P_IN => p_in_temporal_link_matrix,

        L_OUT => l_out_temporal_link_matrix
        );
  end generate model_temporal_link_matrix_test;

  -- USAGE VECTOR
  model_usage_vector_test : if (ENABLE_DNC_MEMORY_USAGE_VECTOR_TEST) generate
    usage_vector : model_usage_vector
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_usage_vector_test;

  -- WRITE CONTENT WEIGHTING
  model_write_content_weighting_test : if (ENABLE_DNC_MEMORY_WRITE_CONTENT_WEIGHTING_TEST) generate
    write_content_weighting : model_write_content_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_write_content_weighting_test;

  -- WRITE WEIGHTING
  model_write_weighting_test : if (ENABLE_DNC_MEMORY_WRITE_WEIGHTING_TEST) generate
    write_weighting : model_write_weighting
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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
  end generate model_write_weighting_test;

  -- ADDRESSING
  model_addressing_test : if (ENABLE_DNC_MEMORY_ADDRESSING_TEST) generate
    addressing : model_addressing
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
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

        K_READ_OUT_I_ENABLE => k_read_out_i_enable_addressing,
        K_READ_OUT_K_ENABLE => k_read_out_k_enable_addressing,

        BETA_READ_IN_ENABLE => beta_read_in_enable_addressing,

        BETA_READ_OUT_ENABLE => beta_read_out_enable_addressing,

        F_READ_IN_ENABLE => f_read_in_enable_addressing,

        F_READ_OUT_ENABLE => f_read_out_enable_addressing,

        PI_READ_IN_I_ENABLE => pi_read_in_i_enable_addressing,
        PI_READ_IN_P_ENABLE => pi_read_in_p_enable_addressing,

        PI_READ_OUT_I_ENABLE => pi_read_out_i_enable_addressing,
        PI_READ_OUT_P_ENABLE => pi_read_out_p_enable_addressing,

        K_WRITE_IN_K_ENABLE => k_write_in_k_enable_addressing,
        E_WRITE_IN_K_ENABLE => e_write_in_k_enable_addressing,
        V_WRITE_IN_K_ENABLE => v_write_in_k_enable_addressing,

        K_WRITE_OUT_K_ENABLE => k_write_out_k_enable_addressing,
        E_WRITE_OUT_K_ENABLE => e_write_out_k_enable_addressing,
        V_WRITE_OUT_K_ENABLE => v_write_out_k_enable_addressing,

        R_OUT_I_ENABLE => r_out_i_enable_addressing,
        R_OUT_K_ENABLE => r_out_k_enable_addressing,

        -- DATA
        SIZE_R_IN => size_r_in_addressing,
        SIZE_N_IN => size_n_in_addressing,
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
  end generate model_addressing_test;

end model_memory_testbench_architecture;
