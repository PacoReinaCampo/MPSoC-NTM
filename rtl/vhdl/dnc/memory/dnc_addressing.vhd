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
use work.dnc_core_pkg.all;

entity dnc_addressing is
  generic (
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 64
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

    F_READ_OUT_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)

    PI_READ_IN_I_ENABLE : in std_logic;  -- for i in 0 to R-1 (read heads flow)
    PI_READ_IN_P_ENABLE : in std_logic;  -- for p in 0 to 2

    PI_READ_OUT_I_ENABLE : out std_logic;  -- for i in 0 to R-1 (read heads flow)
    PI_READ_OUT_P_ENABLE : out std_logic;  -- for p in 0 to 2

    K_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
    E_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1
    V_WRITE_IN_K_ENABLE : in std_logic;  -- for k in 0 to W-1

    K_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
    E_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1
    V_WRITE_OUT_K_ENABLE : out std_logic;  -- for k in 0 to W-1

    R_OUT_I_ENABLE : out std_logic;     -- for i in 0 to R-1 (read heads flow)
    R_OUT_K_ENABLE : out std_logic;     -- for k in 0 to W-1

    -- DATA
    SIZE_R_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_N_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);
    SIZE_W_IN : in std_logic_vector(CONTROL_SIZE-1 downto 0);

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
  -- Functionality
  -----------------------------------------------------------------------

  -- Inputs:
  -- K_READ_IN    [R,W]
  -- BETA_READ_IN [R]
  -- F_READ_IN    [R,P]
  -- PI_READ_IN   [R]

  -- K_WRITE_IN    [W]
  -- BETA_WRITE_IN [1]
  -- E_WRITE_IN    [W]
  -- V_WRITE_IN    [W]
  -- GA_WRITE_IN   [1]
  -- GW_WRITE_IN   [1]

  -- Outputs:
  -- R_OUT [R,W]

  -- States:
  -- INPUT_R_STATE, CLEAN_IN_R_STATE
  -- INPUT_P_STATE, CLEAN_IN_P_STATE
  -- INPUT_N_STATE, CLEAN_IN_N_STATE

  -- OUTPUT_R_STATE, CLEAN_OUT_R_STATE
  -- OUTPUT_W_STATE, CLEAN_OUT_W_STATE

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -- Finite State Machine
  type controller_k_read_in_fsm is (
    STARTER_K_READ_IN_STATE,            -- STEP 0
    INPUT_K_READ_IN_I_STATE,            -- STEP 1
    INPUT_K_READ_IN_K_STATE,            -- STEP 2
    CLEAN_K_READ_IN_I_STATE,            -- STEP 3
    CLEAN_K_READ_IN_K_STATE             -- STEP 4
    );

  type controller_pi_read_in_fsm is (
    STARTER_PI_READ_IN_STATE,           -- STEP 0
    INPUT_PI_READ_IN_I_STATE,           -- STEP 1
    INPUT_PI_READ_IN_P_STATE,           -- STEP 2
    CLEAN_PI_READ_IN_I_STATE,           -- STEP 3
    CLEAN_PI_READ_IN_P_STATE            -- STEP 4
    );

  type controller_read_in_fsm is (
    STARTER_READ_IN_STATE,              -- STEP 0
    INPUT_READ_STATE,                   -- STEP 1
    CLEAN_READ_STATE                    -- STEP 2
    );

  type controller_write_in_fsm is (
    STARTER_WRITE_IN_STATE,             -- STEP 0
    INPUT_WRITE_STATE,                  -- STEP 1
    CLEAN_WRITE_STATE                   -- STEP 2
    );

  type controller_r_out_fsm is (
    STARTER_R_OUT_STATE,                -- STEP 0
    CLEAN_R_OUT_I_STATE,                -- STEP 1
    CLEAN_R_OUT_K_STATE,                -- STEP 2
    OUTPUT_R_OUT_I_STATE,               -- STEP 3
    OUTPUT_R_OUT_K_STATE                -- STEP 4
    );

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- Finite State Machine
  signal controller_k_read_in_fsm_read_int  : controller_k_read_in_fsm;
  signal controller_pi_read_in_fsm_read_int : controller_pi_read_in_fsm;

  signal controller_read_in_fsm_int : controller_read_in_fsm;

  signal controller_write_in_fsm_int : controller_write_in_fsm;

  signal controller_r_out_fsm_read_int : controller_r_out_fsm;

  -- Buffer
  signal matrix_k_read_in_int    : matrix_buffer;
  signal vector_beta_read_in_int : vector_buffer;
  signal vector_f_read_in_int    : vector_buffer;
  signal matrix_pi_read_in_int   : matrix_buffer;

  signal vector_k_write_in_int : vector_buffer;
  signal vector_e_write_in_int : vector_buffer;
  signal vector_v_write_in_int : vector_buffer;


  signal matrix_r_out_int : matrix_buffer;

  -- Control Internal
  signal index_j_k_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_k_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_pi_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_p_pi_read_in_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_in_read_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_k_in_write_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal index_i_r_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal index_k_r_out_loop : std_logic_vector(CONTROL_SIZE-1 downto 0);

  signal data_k_read_in_enable_int : std_logic;

  signal data_pi_read_in_enable_int : std_logic;

  signal data_beta_read_in_enable_int : std_logic;
  signal data_f_read_in_enable_int    : std_logic;

  signal data_read_in_enable_int : std_logic;

  signal data_k_write_in_enable_int : std_logic;
  signal data_e_write_in_enable_int : std_logic;
  signal data_v_write_in_enable_int : std_logic;

  signal data_write_in_enable_int : std_logic;

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

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- CONTROL
  k_read_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      K_READ_OUT_I_ENABLE <= '0';
      K_READ_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_j_k_read_in_loop <= ZERO_CONTROL;
      index_k_k_read_in_loop <= ZERO_CONTROL;

      data_k_read_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_k_read_in_fsm_read_int is
        when STARTER_K_READ_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_k_read_in_loop <= ZERO_CONTROL;
            index_k_k_read_in_loop <= ZERO_CONTROL;

            data_k_read_in_enable_int <= '0';

            -- FSM Control
            controller_k_read_in_fsm_read_int <= INPUT_K_READ_IN_I_STATE;
          else
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '0';
            K_READ_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_K_READ_IN_I_STATE =>  -- STEP 1

          if ((K_READ_IN_I_ENABLE = '1') and (K_READ_IN_K_ENABLE = '1')) then
            -- Data Inputs
            matrix_k_read_in_int(to_integer(unsigned(index_j_k_read_in_loop)), to_integer(unsigned(index_k_k_read_in_loop))) <= K_READ_IN;

            -- FSM Control
            controller_k_read_in_fsm_read_int <= CLEAN_K_READ_IN_K_STATE;
          end if;

          -- Control Outputs
          K_READ_OUT_I_ENABLE <= '0';
          K_READ_OUT_K_ENABLE <= '0';

        when INPUT_K_READ_IN_K_STATE =>  -- STEP 2

          if (K_READ_IN_K_ENABLE = '1') then
            -- Data Inputs
            matrix_k_read_in_int(to_integer(unsigned(index_j_k_read_in_loop)), to_integer(unsigned(index_k_k_read_in_loop))) <= K_READ_IN;

            -- FSM Control
            if (unsigned(index_k_k_read_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
              controller_k_read_in_fsm_read_int <= CLEAN_K_READ_IN_I_STATE;
            else
              controller_k_read_in_fsm_read_int <= CLEAN_K_READ_IN_K_STATE;
            end if;
          end if;

          -- Control Outputs
          K_READ_OUT_K_ENABLE <= '0';

        when CLEAN_K_READ_IN_I_STATE =>  -- STEP 3

          if ((unsigned(index_j_k_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_read_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_k_read_in_loop <= ZERO_CONTROL;
            index_k_k_read_in_loop <= ZERO_CONTROL;

            data_k_read_in_enable_int <= '1';

            -- FSM Control
            controller_k_read_in_fsm_read_int <= STARTER_K_READ_IN_STATE;
          elsif ((unsigned(index_j_k_read_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_k_read_in_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            K_READ_OUT_I_ENABLE <= '1';
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_j_k_read_in_loop <= std_logic_vector(unsigned(index_j_k_read_in_loop) + unsigned(ONE_CONTROL));
            index_k_k_read_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_k_read_in_fsm_read_int <= INPUT_K_READ_IN_I_STATE;
          end if;

        when CLEAN_K_READ_IN_K_STATE =>  -- STEP 4

          if (unsigned(index_k_k_read_in_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_READ_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_k_read_in_loop <= std_logic_vector(unsigned(index_k_k_read_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_k_read_in_fsm_read_int <= INPUT_K_READ_IN_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_k_read_in_fsm_read_int <= STARTER_K_READ_IN_STATE;
      end case;
    end if;
  end process;

  pi_read_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      PI_READ_OUT_I_ENABLE <= '0';
      PI_READ_OUT_P_ENABLE <= '0';

      -- Control Internal
      index_i_pi_read_in_loop <= ZERO_CONTROL;
      index_p_pi_read_in_loop <= ZERO_CONTROL;

      data_pi_read_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_pi_read_in_fsm_read_int is
        when STARTER_PI_READ_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_read_in_loop <= ZERO_CONTROL;
            index_p_pi_read_in_loop <= ZERO_CONTROL;

            data_pi_read_in_enable_int <= '0';

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= INPUT_PI_READ_IN_I_STATE;
          else
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '0';
            PI_READ_OUT_P_ENABLE <= '0';
          end if;

        when INPUT_PI_READ_IN_I_STATE =>  -- STEP 1

          if ((PI_READ_IN_I_ENABLE = '1') and (PI_READ_IN_P_ENABLE = '1')) then
            -- Data Inputs
            matrix_pi_read_in_int(to_integer(unsigned(index_i_pi_read_in_loop)), to_integer(unsigned(index_p_pi_read_in_loop))) <= PI_READ_IN;

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= CLEAN_PI_READ_IN_P_STATE;
          end if;

          -- Control Outputs
          PI_READ_OUT_I_ENABLE <= '0';
          PI_READ_OUT_P_ENABLE <= '0';

        when INPUT_PI_READ_IN_P_STATE =>  -- STEP 2

          if (PI_READ_IN_P_ENABLE = '1') then
            -- Data Inputs
            matrix_pi_read_in_int(to_integer(unsigned(index_i_pi_read_in_loop)), to_integer(unsigned(index_p_pi_read_in_loop))) <= PI_READ_IN;

            -- FSM Control
            if (unsigned(index_p_pi_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
              controller_pi_read_in_fsm_read_int <= CLEAN_PI_READ_IN_I_STATE;
            else
              controller_pi_read_in_fsm_read_int <= CLEAN_PI_READ_IN_P_STATE;
            end if;
          end if;

          -- Control Outputs
          PI_READ_OUT_P_ENABLE <= '0';

        when CLEAN_PI_READ_IN_I_STATE =>  -- STEP 3

          if ((unsigned(index_i_pi_read_in_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_read_in_loop <= ZERO_CONTROL;
            index_p_pi_read_in_loop <= ZERO_CONTROL;

            data_pi_read_in_enable_int <= '1';

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= STARTER_PI_READ_IN_STATE;
          elsif ((unsigned(index_i_pi_read_in_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_p_pi_read_in_loop) = unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL))) then
            -- Control Outputs
            PI_READ_OUT_I_ENABLE <= '1';
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_i_pi_read_in_loop <= std_logic_vector(unsigned(index_i_pi_read_in_loop) + unsigned(ONE_CONTROL));
            index_p_pi_read_in_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= INPUT_PI_READ_IN_I_STATE;
          end if;

        when CLEAN_PI_READ_IN_P_STATE =>  -- STEP 4

          if (unsigned(index_p_pi_read_in_loop) < unsigned(SIZE_N_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            PI_READ_OUT_P_ENABLE <= '1';

            -- Control Internal
            index_p_pi_read_in_loop <= std_logic_vector(unsigned(index_p_pi_read_in_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_pi_read_in_fsm_read_int <= INPUT_PI_READ_IN_P_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_pi_read_in_fsm_read_int <= STARTER_PI_READ_IN_STATE;
      end case;
    end if;
  end process;

  read_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      BETA_READ_OUT_ENABLE <= '0';
      F_READ_OUT_ENABLE    <= '0';

      -- Control Internal
      index_i_in_read_loop <= ZERO_CONTROL;

      data_beta_read_in_enable_int <= '0';
      data_f_read_in_enable_int    <= '0';

      data_read_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_read_in_fsm_int is
        when STARTER_READ_IN_STATE =>   -- STEP 0
          if (START = '1') then
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '1';
            F_READ_OUT_ENABLE    <= '1';

            -- Control Internal
            index_i_in_read_loop <= ZERO_CONTROL;

            data_beta_read_in_enable_int <= '0';
            data_f_read_in_enable_int    <= '0';

            data_read_in_enable_int <= '0';

            -- FSM Control
            controller_read_in_fsm_int <= INPUT_READ_STATE;
          else
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '0';
            F_READ_OUT_ENABLE    <= '0';
          end if;

        when INPUT_READ_STATE =>        -- STEP 1

          if (BETA_READ_IN_ENABLE = '1') then
            -- Data Inputs
            vector_beta_read_in_int(to_integer(unsigned(index_i_in_read_loop))) <= BETA_READ_IN;

            -- Control Internal
            data_beta_read_in_enable_int <= '1';
          end if;

          if (F_READ_IN_ENABLE = '1') then
            -- Data Inputs
            vector_f_read_in_int(to_integer(unsigned(index_i_in_read_loop))) <= F_READ_IN;

            -- Control Internal
            data_f_read_in_enable_int <= '1';
          end if;

          -- Control Outputs
          BETA_READ_OUT_ENABLE <= '0';
          F_READ_OUT_ENABLE    <= '0';

          if (data_beta_read_in_enable_int = '1' and data_f_read_in_enable_int = '1') then
            -- Control Internal
            data_beta_read_in_enable_int <= '0';
            data_f_read_in_enable_int    <= '0';

            -- FSM Control
            controller_read_in_fsm_int <= CLEAN_READ_STATE;
          end if;

        when CLEAN_READ_STATE =>        -- STEP 2

          if (unsigned(index_i_in_read_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '1';
            F_READ_OUT_ENABLE    <= '1';

            -- Control Internal
            index_i_in_read_loop <= ZERO_CONTROL;

            data_read_in_enable_int <= '1';

            -- FSM Control
            controller_read_in_fsm_int <= STARTER_READ_IN_STATE;
          elsif (unsigned(index_i_in_read_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            BETA_READ_OUT_ENABLE <= '1';
            F_READ_OUT_ENABLE    <= '1';

            -- Control Internal
            index_i_in_read_loop <= std_logic_vector(unsigned(index_i_in_read_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_read_in_fsm_int <= INPUT_READ_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_read_in_fsm_int <= STARTER_READ_IN_STATE;
      end case;
    end if;
  end process;

  write_in_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Control Outputs
      K_WRITE_OUT_K_ENABLE <= '0';
      E_WRITE_OUT_K_ENABLE <= '0';
      V_WRITE_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_k_in_write_loop <= ZERO_CONTROL;

      data_k_write_in_enable_int <= '0';
      data_e_write_in_enable_int <= '0';
      data_v_write_in_enable_int <= '0';

      data_write_in_enable_int <= '0';

    elsif (rising_edge(CLK)) then

      case controller_write_in_fsm_int is
        when STARTER_WRITE_IN_STATE =>  -- STEP 0
          if (START = '1') then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_in_write_loop <= ZERO_CONTROL;

            data_k_write_in_enable_int <= '0';
            data_e_write_in_enable_int <= '0';
            data_v_write_in_enable_int <= '0';

            data_write_in_enable_int <= '0';

            -- FSM Control
            controller_write_in_fsm_int <= INPUT_WRITE_STATE;
          else
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '0';
            E_WRITE_OUT_K_ENABLE <= '0';
            V_WRITE_OUT_K_ENABLE <= '0';
          end if;

        when INPUT_WRITE_STATE =>       -- STEP 1

          if (K_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_k_write_in_int(to_integer(unsigned(index_k_in_write_loop))) <= K_WRITE_IN;

            -- Control Internal
            data_k_write_in_enable_int <= '1';
          end if;

          if (E_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_e_write_in_int(to_integer(unsigned(index_k_in_write_loop))) <= E_WRITE_IN;

            -- Control Internal
            data_e_write_in_enable_int <= '1';
          end if;

          if (V_WRITE_IN_K_ENABLE = '1') then
            -- Data Inputs
            vector_v_write_in_int(to_integer(unsigned(index_k_in_write_loop))) <= V_WRITE_IN;

            -- Control Internal
            data_v_write_in_enable_int <= '1';
          end if;

          -- Control Outputs
          K_WRITE_OUT_K_ENABLE <= '0';
          E_WRITE_OUT_K_ENABLE <= '0';
          V_WRITE_OUT_K_ENABLE <= '0';

          if (data_k_write_in_enable_int = '1' and data_e_write_in_enable_int = '1' and data_v_write_in_enable_int = '1') then
            -- Control Internal
            data_k_write_in_enable_int <= '0';
            data_e_write_in_enable_int <= '0';
            data_v_write_in_enable_int <= '0';

            -- FSM Control
            controller_write_in_fsm_int <= CLEAN_WRITE_STATE;
          end if;

        when CLEAN_WRITE_STATE =>       -- STEP 2

          if (unsigned(index_k_in_write_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_in_write_loop <= ZERO_CONTROL;

            data_write_in_enable_int <= '1';

            -- FSM Control
            controller_write_in_fsm_int <= STARTER_WRITE_IN_STATE;
          elsif (unsigned(index_k_in_write_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            K_WRITE_OUT_K_ENABLE <= '1';
            E_WRITE_OUT_K_ENABLE <= '1';
            V_WRITE_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_in_write_loop <= std_logic_vector(unsigned(index_k_in_write_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_write_in_fsm_int <= INPUT_WRITE_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_write_in_fsm_int <= STARTER_WRITE_IN_STATE;
      end case;
    end if;
  end process;

  -- p(t;j) = (1 - summation(w(t;j))[i in 1 to N])·p(t-1;j) + w(t;j)
  -- p(t=0) = 0


  -- L(t)[g;j] = (1 - w(t;j)[i] - w(t;j)[j])·L(t-1)[g;j] + w(t;j)[i]·p(t-1;j)[j]
  -- L(t=0)[g,j] = 0


  -- b(t;i;j) = transpose(L(t;g;j))·w(t-1;i;j)

  -- f(t;i;j) = L(t;g;j)·w(t-1;i;j)


  -- psi(t;j) = multiplication(1 - f(t;i)·w(t-1;i;j))[i in 1 to R]


  -- u(t;j) = (u(t-1;j) + w(t-1;j) - u(t-1;j) o w(t-1;j)) o psi(t;j)


  -- a(t)[phi(t)[j]] = (1 - u(t)[phi(t)[j]])·multiplication(u(t)[phi(t)[j]])[i in 1 to j-1]


  -- c(t;i;j) = C(M(t-1;j;k),k(t;i;k),beta(t;i))

  -- c(t;j) = C(M(t-1;j;k),k(t;k),beta(t))


  -- w(t;i,j) = pi(t;i)[1]·b(t;i;j) + pi(t;i)[2]·c(t;i,j) + pi(t;i)[3]·f(t;i;j)

  -- w(t;j) = gw(t)·(ga(t)·a(t;j) + (1 - ga(t))·c(t;j))


  -- M(t;j;k) = M(t-1;j;k) o (E - w(t;j)·transpose(e(t;k))) + w(t;j)·transpose(v(t;k))


  -- r(t;i;k) = transpose(M(t;j;k))·w(t;i;j)
  r_out_fsm : process(CLK, RST)
  begin
    if (RST = '0') then
      -- Data Outputs
      R_OUT <= ZERO_DATA;

      -- Control Outputs
      READY <= '0';

      R_OUT_I_ENABLE <= '0';
      R_OUT_K_ENABLE <= '0';

      -- Control Internal
      index_i_r_out_loop <= ZERO_CONTROL;
      index_k_r_out_loop <= ZERO_CONTROL;

    elsif (rising_edge(CLK)) then

      case controller_r_out_fsm_read_int is
        when STARTER_R_OUT_STATE =>     -- STEP 0
          if (data_pi_read_in_enable_int = '1' and data_k_read_in_enable_int = '1' and data_read_in_enable_int = '1' and data_write_in_enable_int = '1') then
            -- Data Internal

            -- Control Internal
            index_i_r_out_loop <= ZERO_CONTROL;
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_read_int <= CLEAN_R_OUT_I_STATE;
          end if;

        when CLEAN_R_OUT_I_STATE =>     -- STEP 1
          -- Control Outputs
          R_OUT_I_ENABLE <= '0';
          R_OUT_K_ENABLE <= '0';

          -- FSM Control
          controller_r_out_fsm_read_int <= OUTPUT_R_OUT_K_STATE;

        when CLEAN_R_OUT_K_STATE =>     -- STEP 2

          -- Control Outputs
          R_OUT_K_ENABLE <= '0';

          -- FSM Control
          if (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            controller_r_out_fsm_read_int <= OUTPUT_R_OUT_I_STATE;
          else
            controller_r_out_fsm_read_int <= OUTPUT_R_OUT_K_STATE;
          end if;

        when OUTPUT_R_OUT_I_STATE =>    -- STEP 3

          if ((unsigned(index_i_r_out_loop) = unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= matrix_r_out_int(to_integer(unsigned(index_i_r_out_loop)), to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            READY <= '1';

            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_out_loop <= ZERO_CONTROL;
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_read_int <= STARTER_R_OUT_STATE;
          elsif ((unsigned(index_i_r_out_loop) < unsigned(SIZE_R_IN)-unsigned(ONE_CONTROL)) and (unsigned(index_k_r_out_loop) = unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL))) then
            -- Data Outputs
            R_OUT <= matrix_r_out_int(to_integer(unsigned(index_i_r_out_loop)), to_integer(unsigned(index_k_r_out_loop)));

            -- Control Outputs
            R_OUT_I_ENABLE <= '1';
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_i_r_out_loop <= std_logic_vector(unsigned(index_i_r_out_loop) + unsigned(ONE_CONTROL));
            index_k_r_out_loop <= ZERO_CONTROL;

            -- FSM Control
            controller_r_out_fsm_read_int <= CLEAN_R_OUT_I_STATE;
          end if;

        when OUTPUT_R_OUT_K_STATE =>    -- STEP 4

          if (unsigned(index_k_r_out_loop) < unsigned(SIZE_W_IN)-unsigned(ONE_CONTROL)) then
            -- Control Outputs
            R_OUT_K_ENABLE <= '1';

            -- Control Internal
            index_k_r_out_loop <= std_logic_vector(unsigned(index_k_r_out_loop) + unsigned(ONE_CONTROL));

            -- FSM Control
            controller_r_out_fsm_read_int <= CLEAN_R_OUT_K_STATE;
          end if;

        when others =>
          -- FSM Control
          controller_r_out_fsm_read_int <= STARTER_R_OUT_STATE;
      end case;
    end if;
  end process;

  -- ALLOCATION WEIGHTING
  allocation_weighting : dnc_allocation_weighting
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

  -- BACKWARD WEIGHTING
  backward_weighting : dnc_backward_weighting
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

  -- FORWARD WEIGHTING
  forward_weighting : dnc_forward_weighting
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

  -- MEMORY MATRIX
  memory_matrix : dnc_memory_matrix
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

  -- MEMORY RETENTION VECTOR
  memory_retention_vector : dnc_memory_retention_vector
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

  -- PRECEDENCE WEIGHTING
  precedence_weighting : dnc_precedence_weighting
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

  -- READ CONTENT WEIGHTING
  read_content_weighting : dnc_read_content_weighting
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

  -- READ VECTORS
  read_vectors : dnc_read_vectors
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

  -- READ WEIGHTING
  read_weighting : dnc_read_weighting
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

  -- TEMPORAL LINK MATRIX
  temporal_link_matrix : dnc_temporal_link_matrix
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

  -- WRITE CONTENT WEIGHTING
  write_content_weighting : dnc_write_content_weighting
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

  -- WRITE WEIGHTING
  write_weighting : dnc_write_weighting
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

end dnc_addressing_architecture;
