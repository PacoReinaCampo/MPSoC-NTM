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
## Copyright (c) 2022-2023 by the author(s)                                      ##
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

import numpy as np

def accelerator_activation_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in):
  # Body
  # a(t;l) = tanh(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
  
  # W(l;x)*x(t;x)
  vector_operation_int = accelerator_matrix_vector_convolution(w_in, x_in)

  # K(i;l;k)*r(t;i;k)
  matrix_operation_int = accelerator_tensor_matrix_convolution(k_in, r_in)

  for i in range(len(k_in)):
    for l in range(len(k_in[i])):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # D(i;l;m)*rho(t;i;m)
  matrix_operation_int = accelerator_tensor_matrix_convolution(d_in, rho_in)

  for i in range(len(k_in)):
    for l in range(len(k_in[i])):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # b[l]
  a_out = vector_operation_int + b_in

  # V(l;s)*xi(t;s)
  vector_operation_int = accelerator_matrix_vector_convolution(v_in, xi_in)

  a_out = a_out + vector_operation_int

  # U(l;l)*h(t-1;l)
  vector_operation_int = accelerator_matrix_vector_convolution(u_in, h_in)

  a_out = a_out + vector_operation_int

  # tanh(.)
  a_out = np.tanh(a_out)

  return a_out

def accelerator_forget_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in):
  # Body
  # f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
  
  # W(l;x)*x(t;x)
  vector_operation_int = accelerator_matrix_vector_convolution(w_in, x_in)

  # K(i;l;k)*r(t;i;k)
  matrix_operation_int = accelerator_tensor_matrix_convolution(k_in, r_in)

  for i in range(len(k_in)):
    for l in range(len(k_in[i])):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # D(i;l;m)*rho(t;i;m)
  matrix_operation_int = accelerator_tensor_matrix_convolution(d_in, rho_in)

  for i in range(len(k_in)):
    for l in range(len(k_in[i])):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # b[l]
  f_out = vector_operation_int + b_in

  # V(l;s)*xi(t;s)
  vector_operation_int = accelerator_matrix_vector_convolution(v_in, xi_in)

  f_out = f_out + vector_operation_int

  # U(l;l)*h(t-1;l)
  vector_operation_int = accelerator_matrix_vector_convolution(u_in, h_in)

  f_out = f_out + vector_operation_int

  # sigmoid(.)
  f_out = accelerator_vector_logistic_function(f_out)

  return f_out

def accelerator_input_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in):
  # Body
  # i(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
  
  # W(l;x)*x(t;x)
  vector_operation_int = accelerator_matrix_vector_convolution(w_in, x_in)

  # K(i;l;k)*r(t;i;k)
  matrix_operation_int = accelerator_tensor_matrix_convolution(k_in, r_in)

  for l in range(len(k_in[i])):
    for i in range(len(k_in)):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # D(i;l;m)*rho(t;i;m)
  matrix_operation_int = accelerator_tensor_matrix_convolution(d_in, rho_in)

  for l in range(len(k_in[i])):
    for i in range(len(k_in)):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # b[l]
  i_out = vector_operation_int + b_in

  # V(l;s)*xi(t;s)
  vector_operation_int = accelerator_matrix_vector_convolution(v_in, xi_in)

  i_out = i_out + vector_operation_int

  # U(l;l)*h(t-1;l)
  vector_operation_int = accelerator_matrix_vector_convolution(u_in, h_in)

  i_out = i_out + vector_operation_int

  # sigmoid(.)
  i_out = accelerator_vector_logistic_function(i_out)

  return i_out

def accelerator_output_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in):
  # Body
  # o(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1;l) + b(l))
  
  # W(l;x)*x(t;x)
  vector_operation_int = accelerator_matrix_vector_convolution(w_in, x_in)

  # K(i;l;k)*r(t;i;k)
  matrix_operation_int = accelerator_tensor_matrix_convolution(k_in, r_in)

  for i in range(len(k_in)):
    for l in range(len(k_in[i])):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # D(i;l;m)*rho(t;i;m)
  matrix_operation_int = accelerator_tensor_matrix_convolution(d_in, rho_in)

  for i in range(len(k_in)):
    for l in range(len(k_in[i])):
      vector_operation_int[l] = vector_operation_int[l] + matrix_operation_int[i][l]

  # b[l]
  o_out = vector_operation_int + b_in

  # V(l;s)*xi(t;s)
  vector_operation_int = accelerator_matrix_vector_convolution(v_in, xi_in)

  o_out = o_out + vector_operation_int

  # U(l;l)*h(t-1;l)
  vector_operation_int = accelerator_matrix_vector_convolution(u_in, h_in)

  o_out = o_out + vector_operation_int

  # sigmoid(.)
  o_out = accelerator_vector_logistic_function(o_out)

  return o_out

def accelerator_hidden_gate_vector(S_IN, O_IN):
  # Body
  # h(t;l) = o(t;l) o tanh(s(t;l))
  # h(t=0;l) = 0; h(t;l=0) = 0
  vector_operation_int = np.tanh(S_IN)

  h_out = accelerator_vector_multiplier(O_IN, vector_operation_int)

  return h_out

def accelerator_state_gate_vector(S_IN, I_IN, F_IN, A_IN):
  # Body
  # s(t;l) = f(t;l) o s(t-1;l) + i(t;l) o a(t;l)
  # s(t=0;l) = 0
  vector_first_operation_int = accelerator_vector_multiplier(F_IN, S_IN)

  vector_second_operation_int = accelerator_vector_multiplier(I_IN, A_IN)

  s_out = vector_first_operation_int + vector_second_operation_int

  return s_out

def accelerator_controller(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, S_IN, h_in, x_in):
  # Body
  # a(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
  vector_a_int = accelerator_activation_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in)

  # f(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
  vector_f_int = accelerator_forget_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in)

  # i(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
  vector_i_int = accelerator_input_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in)

  # s(t;l) = f(t;l) o s(t-1,l) + i(t;l) o a(t;l)
  vector_s_int = accelerator_state_gate_vector(S_IN, vector_i_int, vector_f_int, vector_a_int)

  # o(t;l) = sigmoid(W(l;x)*x(t;x) + K(i;l;k)*r(t;i;k) + D(i;l;m)*rho(t;i;m) + V(l;s)*xi(t;s) + U(l;l)*h(t-1,l) + b(l))
  vector_o_int = accelerator_output_gate_vector(w_in, k_in, v_in, d_in, u_in, b_in, r_in, xi_in, rho_in, h_in, x_in)

  # h(t;l) = o(t;l) o tanh(s(t;l))
  h_out = accelerator_hidden_gate_vector(vector_s_int, vector_o_int)

  return h_out
