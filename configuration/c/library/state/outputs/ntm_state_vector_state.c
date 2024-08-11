///////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _                  //
//                                           / _(_)    | |   | |                 //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 //
//                  | |                                                          //
//                  |_|                                                          //
//                                                                               //
//                                                                               //
//              Peripheral-NTM for MPSoC                                         //
//              Neural Turing Machine for MPSoC                                  //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// Copyright (c) 2020-2024 by the author(s)                                      //
//                                                                               //
// Permission is hereby granted, free of charge, to any person obtaining a copy  //
// of this software and associated documentation files (the "Software"), to deal //
// in the Software without restriction, including without limitation the rights  //
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     //
// copies of the Software, and to permit persons to whom the Software is         //
// furnished to do so, subject to the following conditions:                      //
//                                                                               //
// The above copyright notice and this permission notice shall be included in    //
// all copies or substantial portions of the Software.                           //
//                                                                               //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    //
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      //
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   //
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        //
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, //
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     //
// THE SOFTWARE.                                                                 //
//                                                                               //
// ============================================================================= //
// Author(s):                                                                    //
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>

// Package

double **ntm_state_vector_state(double **data_k_in, double **data_a_in, double **data_b_in, double **data_c_in, double **data_d_in, double **data_u_in, double *initial_x, int k) {
  // Variables
  double **data_a_out;
  double **data_b_out;
  double **data_c_out;

  double **data_x_out;

  int i;

  data_a_out = (double **)malloc(SIZE_I_IN * sizeof(int *));
  data_b_out = (double **)malloc(SIZE_I_IN * sizeof(int *));
  data_c_out = (double **)malloc(SIZE_I_IN * sizeof(int *));

  data_x_out = (double **)malloc(SIZE_I_IN * sizeof(int *));

  for (i = 0; i < SIZE_I_IN; i++) {
    data_a_out[i] = (double *)malloc(SIZE_J_IN * sizeof(int));
    data_b_out[i] = (double *)malloc(SIZE_J_IN * sizeof(int));
    data_c_out[i] = (double *)malloc(SIZE_J_IN * sizeof(int));

    data_x_out[i] = (double *)malloc(SIZE_J_IN * sizeof(int));
  }

  // Body
  // x(k) = exp(A,k)·x(0) + summation(exp(A,k-j-1)·B·u(j))[j in 0 to k-1]
  data_a_out = ntm_state_matrix_state(data_k_in, data_a_in, data_b_in, data_c_in, data_d_in);
  data_b_out = ntm_state_matrix_input(data_k_in, data_b_in, data_d_in);
  data_c_out = ntm_state_matrix_output(data_k_in, data_c_in, data_d_in);

  data_x_out = (data_a_out ^ k) * initial_x;

  for (j = 0; j < k; j++) {
    data_x_out = data_x_out + data_c_out * (data_a_out ^ (k - j - 1)) * data_b_out * data_u_in(k);
  }

return data_x_out;
}
