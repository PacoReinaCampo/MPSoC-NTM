%{
###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Peripheral-NTM for MPSoC                                         ##
##              Neural Turing Machine for MPSoC                                  ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2020-2024 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################
%}

function Y_OUT = ntm_top(W_IN, K_IN, U_IN, V_IN, D_IN, B_IN, X_IN)
  addpath(genpath('../memory'));
  addpath(genpath('../read_heads'));
  addpath(genpath('../write_heads'));

  [SIZE_L_IN, SIZE_X_IN] = size(W_IN);

  SIZE_Y_IN = 3;
  SIZE_R_IN = 3;
  SIZE_N_IN = 3;
  SIZE_W_IN = 3;
  SIZE_M_IN = 3;
  SIZE_S_IN = 3;

  Y_OUT = zeros(SIZE_Y_IN, 1);

  M_IN = zeros(SIZE_N_IN, SIZE_W_IN);
  WA_IN = rand(SIZE_R_IN, 1);

  A_IN = rand(1, SIZE_W_IN);
  E_IN = rand(1, SIZE_W_IN);

  KA_IN = rand(1, SIZE_W_IN);
  BETA_IN = rand(1);
  G_IN = rand(1);
  S_IN = rand(1, SIZE_W_IN);
  GAMMA_IN = rand(1);

  matrix_u_int = rand(SIZE_R_IN, SIZE_M_IN, SIZE_L_IN);
  matrix_h_int = rand(SIZE_R_IN, SIZE_L_IN);

  vector_u_int = rand(SIZE_S_IN, SIZE_L_IN);
  vector_h_int = rand(SIZE_L_IN, 1);

  KO_IN = rand(SIZE_R_IN, SIZE_Y_IN, SIZE_W_IN);
  RO_IN = rand(SIZE_R_IN, SIZE_W_IN);
  UO_IN = rand(SIZE_Y_IN, SIZE_L_IN);
  HO_IN = rand(SIZE_L_IN, 1);

  % CONTROLLER

  % OUTPUT VECTOR
  Y_OUT = ntm_output_vector(KO_IN, RO_IN, UO_IN, HO_IN);

  % INTERFACE VECTOR
  XI_OUT = ntm_interface_vector(matrix_u_int, matrix_h_int);

  % INTERFACE MATRIX
  RHO_OUT = ntm_interface_matrix(vector_u_int, vector_h_int);

  % READING
  R_OUT = ntm_reading(W_IN, M_IN);

  % WRITING
  M_OUT = ntm_writing(M_IN, W_IN, A_IN);

  % ERASING
  M_OUT = ntm_erasing(M_IN, W_IN, E_IN);

  % ADDRESSING
  W_OUT = ntm_addressing(KA_IN, BETA_IN, G_IN, S_IN, GAMMA_IN, M_IN, WA_IN);
end